local M = {}

local ns = vim.api.nvim_create_namespace 'pr_comments'
local aug = vim.api.nvim_create_augroup('PRComments', { clear = true })

M.config = {
  show_resolved = true,
  show_outdated = false,
  icon = '',
  sign = '',
  keymap = '<leader>pk',
  next_keymap = '<D-J>',
  prev_keymap = '<D-K>',
}

-- cache[git_root] = { number = n, threads = {...} }
local cache = {}
local inflight = {}

local function notify(msg, level)
  vim.notify('[pr-comments] ' .. msg, level or vim.log.levels.INFO)
end

local function lifecycle()
  local ok, lc = pcall(require, 'codediff.ui.lifecycle')
  return ok and lc or nil
end

local QUERY = [[
query($owner:String!,$name:String!,$branch:String!){
  repository(owner:$owner,name:$name){
    pullRequests(headRefName:$branch,states:OPEN,first:1){
      nodes{
        id number
        reviewThreads(first:100){
          nodes{
            id isResolved isOutdated path line startLine originalLine diffSide
            comments(first:50){nodes{author{login} body createdAt url}}
          }
        }
      }
    }
  }
}]]

local function run(cmd, cwd, cb)
  vim.system(cmd, { text = true, cwd = cwd }, function(res)
    vim.schedule(function()
      cb(res)
    end)
  end)
end

function M.fetch(git_root, cb)
  if inflight[git_root] then
    return
  end
  inflight[git_root] = true
  local function done(err)
    inflight[git_root] = nil
    if err then
      notify(err, vim.log.levels.WARN)
    end
    if cb then
      cb()
    end
  end

  local origin = vim.system({ 'git', '-C', git_root, 'remote', 'get-url', 'origin' }, { text = true }):wait()
  local branch = vim.trim(vim.system({ 'git', '-C', git_root, 'branch', '--show-current' }, { text = true }):wait().stdout or '')
  local owner, name = (origin.stdout or ''):match 'github%.com[:/]([^/]+)/([^/]+)'
  if not owner or branch == '' then
    return done 'cannot determine GitHub repo or branch'
  end
  name = name:gsub('%.git%s*$', '')

  run({
    'gh', 'api', 'graphql',
    '-f', 'owner=' .. owner,
    '-f', 'name=' .. name,
    '-f', 'branch=' .. branch,
    '-f', 'query=' .. QUERY,
  }, git_root, function(r)
    if r.code ~= 0 then
      return done('gh api failed: ' .. (r.stderr or ''))
    end
    local data = vim.json.decode(r.stdout)
    local pr = data.data.repository.pullRequests.nodes[1]
    if not pr then
      return done('no PR for current branch')
    end
    local nodes = pr.reviewThreads.nodes
    local counts = {}
    for _, t in ipairs(nodes) do
      if not t.isResolved and (M.config.show_outdated or not t.isOutdated) then
        counts[t.path] = (counts[t.path] or 0) + 1
      end
    end
    cache[git_root] = { id = pr.id, number = pr.number, threads = nodes, counts = counts }
    done()
  end)
end

local function thread_lines(t)
  local out = {}
  for _, c in ipairs(t.comments.nodes) do
    local author = c.author and c.author.login or 'ghost'
    table.insert(out, { author = author, body = c.body, date = (c.createdAt or ''):sub(1, 10) })
  end
  return out
end

local function place(buf, t, row)
  local nlines = vim.api.nvim_buf_line_count(buf)
  row = math.max(0, math.min(row - 1, nlines - 1))
  local msgs = thread_lines(t)
  local hl = t.isResolved and 'PRCommentResolved' or 'PRCommentUnresolved'
  vim.api.nvim_buf_set_extmark(buf, ns, row, 0, {
    sign_text = M.config.sign,
    sign_hl_group = hl,
    priority = t.isResolved and 500 or 600,
  })
  -- store thread for the float
  vim.b[buf].pr_comment_threads = vim.b[buf].pr_comment_threads or {}
  local list = vim.b[buf].pr_comment_threads
  list[tostring(row + 1)] = list[tostring(row + 1)] or {}
  table.insert(list[tostring(row + 1)], { id = t.id, resolved = t.isResolved, msgs = msgs })
  vim.b[buf].pr_comment_threads = list
  vim.keymap.set('n', 'R', M.resolve_or_replace, { buffer = buf, desc = 'Resolve PR comment' })
end

function M.render(tabpage)
  tabpage = tabpage or vim.api.nvim_get_current_tabpage()
  local lc = lifecycle()
  if not lc then
    return
  end
  local ctx = lc.get_git_context(tabpage)
  if not ctx then
    return
  end
  local data = cache[ctx.git_root]
  if not data then
    return
  end
  local obuf, mbuf = lc.get_buffers(tabpage)
  for _, b in ipairs { obuf, mbuf } do
    if b and vim.api.nvim_buf_is_valid(b) then
      vim.keymap.set('n', 'C', M.comment_here, { buffer = b, desc = 'Comment on PR line' })
    end
  end
  local opath, mpath = lc.get_paths(tabpage)

  for _, b in ipairs { obuf, mbuf } do
    if b and vim.api.nvim_buf_is_valid(b) then
      vim.api.nvim_buf_clear_namespace(b, ns, 0, -1)
      vim.b[b].pr_comment_threads = nil
    end
  end

  for _, t in ipairs(data.threads) do
    local skip = (t.isResolved and not M.config.show_resolved) or (t.isOutdated and not M.config.show_outdated)
    if not skip then
      local left = t.diffSide == 'LEFT'
      local buf = left and obuf or mbuf
      local path = left and opath or mpath
      local row = t.line or (M.config.show_outdated and t.originalLine)
      if row and buf and path and path.relative == t.path and vim.api.nvim_buf_is_valid(buf) then
        place(buf, t, row)
      end
    end
  end
end

function M.render_explorer(tabpage)
  local lc = lifecycle()
  local explorer = lc and lc.get_panel_view(tabpage or vim.api.nvim_get_current_tabpage())
  if explorer and explorer.tree and not explorer.is_hidden then
    pcall(function()
      explorer.tree:render()
    end)
  end
end

local function current_counts()
  local lc = lifecycle()
  local ctx = lc and lc.get_git_context(vim.api.nvim_get_current_tabpage())
  local data = ctx and cache[ctx.git_root]
  return data and data.counts
end

local function badge(n)
  return { segments = { { text = ('%s %d '):format(M.config.icon, n), hl = 'PRCommentUnresolved' } } }
end

local function sum_files(counts, files)
  local n = 0
  for _, f in ipairs(files or {}) do
    n = n + (counts[f.path] or 0)
  end
  return n
end

-- Wrappers around codediff's default explorer formatters that add an
-- unresolved-comment badge. Use as `explorer.formatters` in codediff setup.
function M.formatters()
  local defaults = require 'codediff.ui.explorer.formatters'
  local function wrap(kind)
    return function(ctx)
      local layout = defaults[kind](ctx)
      local counts = current_counts()
      if not counts then
        return layout
      end
      local n = kind == 'file' and (counts[ctx.path] or 0) or sum_files(counts, ctx.files)
      if n > 0 then
        layout.right = layout.right or {}
        table.insert(layout.right, 1, badge(n))
      end
      return layout
    end
  end
  return { file = wrap 'file', folder = wrap 'folder', group = wrap 'group' }
end

function M.refresh()
  local lc = lifecycle()
  local tab = vim.api.nvim_get_current_tabpage()
  local ctx = lc and lc.get_git_context(tab)
  if not ctx then
    return notify('not in a CodeDiff tab', vim.log.levels.WARN)
  end
  cache[ctx.git_root] = nil
  M.fetch(ctx.git_root, function()
    if vim.api.nvim_tabpage_is_valid(tab) then
      M.render(tab)
      M.render_explorer(tab)
    end
  end)
end

local shown = { win = nil, buf = nil, row = nil }

local function close_float()
  if shown.win and vim.api.nvim_win_is_valid(shown.win) then
    vim.api.nvim_win_close(shown.win, true)
  end
  shown.win = nil
end

local function sorted_rows(list)
  local rows = {}
  for k in pairs(list) do
    table.insert(rows, tonumber(k))
  end
  table.sort(rows)
  return rows
end

local function next_row(list, cur)
  local rows = sorted_rows(list)
  for _, r in ipairs(rows) do
    if r > cur then
      return r
    end
  end
  return rows[1]
end

local function prev_row(list, cur)
  local rows = sorted_rows(list)
  for i = #rows, 1, -1 do
    if rows[i] < cur then
      return rows[i]
    end
  end
  return rows[#rows]
end

---@param dir? 'next'|'prev' always jump in that direction when given
local function confirm_modal(prompt, cb)
  local buf = vim.api.nvim_create_buf(false, true)
  local hint = ' [y] yes   [n] no '
  local width = math.max(vim.fn.strdisplaywidth(prompt), #hint) + 4
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, { ' ' .. prompt, '', hint })
  vim.bo[buf].modifiable = false
  local win = vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    width = width,
    height = 3,
    row = math.floor((vim.o.lines - 3) / 2),
    col = math.floor((vim.o.columns - width) / 2),
    style = 'minimal',
    border = 'rounded',
    title = ' PR comment ',
    title_pos = 'center',
  })
  local function close(ok)
    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    end
    cb(ok)
  end
  for _, k in ipairs { 'y', 'Y', '<CR>' } do
    vim.keymap.set('n', k, function() close(true) end, { buffer = buf, nowait = true })
  end
  for _, k in ipairs { 'n', 'N', 'q', '<Esc>' } do
    vim.keymap.set('n', k, function() close(false) end, { buffer = buf, nowait = true })
  end
end

local function float_visible(row)
  return shown.win ~= nil and vim.api.nvim_win_is_valid(shown.win)
    and shown.buf == vim.api.nvim_get_current_buf() and shown.row == row
end

-- Opens an editable float. With `above_win` (the comment float), the input sits
-- right under it and both stay open until the input closes or focus leaves them.
local function input_modal(title, cb, above_win)
  local pw = above_win and vim.api.nvim_win_is_valid(above_win) and above_win or nil
  local height = 8
  local opts
  if pw then
    -- Stop the LSP preview from closing itself when focus moves to the input.
    pcall(vim.api.nvim_del_augroup_by_name, 'nvim.preview_window_' .. pw)
    -- Make room for the input under the comment float: move it up, then shrink it.
    local total = vim.o.lines - vim.o.cmdheight
    local pos = vim.api.nvim_win_get_position(pw)
    local ph = vim.api.nvim_win_get_height(pw)
    if ph + height + 4 > total then
      ph = math.max(3, total - height - 4)
    end
    vim.api.nvim_win_set_config(pw, {
      relative = 'editor',
      row = math.min(pos[1], math.max(0, total - (ph + height + 4))),
      col = pos[2],
      width = vim.api.nvim_win_get_width(pw),
      height = ph,
    })
    opts = {
      relative = 'win',
      win = pw,
      anchor = 'NW',
      row = ph + 1,
      col = 0,
      width = vim.api.nvim_win_get_width(pw),
      height = height,
      style = 'minimal',
      border = 'rounded',
    }
  else
    close_float()
    opts = vim.lsp.util.make_floating_popup_options(math.min(90, vim.o.columns - 4), height, { border = 'rounded' })
  end
  opts.title = ' ' .. title .. ' '
  opts.title_pos = 'center'
  opts.focusable = true

  local buf = vim.api.nvim_create_buf(false, true)
  vim.bo[buf].bufhidden = 'wipe'
  vim.bo[buf].filetype = 'markdown'
  local win = vim.api.nvim_open_win(buf, true, opts)
  vim.wo[win].wrap = true
  vim.wo[win].linebreak = true
  vim.wo[win].winhighlight = 'NormalFloat:PRCommentText'

  local group = vim.api.nvim_create_augroup('PRCommentInput', { clear = true })
  local closed = false
  local function close()
    if closed then
      return
    end
    closed = true
    pcall(vim.api.nvim_del_augroup_by_id, group)
    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    end
    if pw then
      close_float()
    end
  end
  vim.api.nvim_create_autocmd('WinEnter', {
    group = group,
    callback = function()
      local cur = vim.api.nvim_get_current_win()
      if cur ~= win and cur ~= pw then
        close()
      end
    end,
  })
  vim.api.nvim_create_autocmd('WinClosed', {
    group = group,
    pattern = tostring(win),
    callback = function()
      vim.schedule(close)
    end,
  })

  local function submit()
    local text = vim.trim(table.concat(vim.api.nvim_buf_get_lines(buf, 0, -1, false), '\n'))
    close()
    if text == '' then
      return notify('empty comment, not posted', vim.log.levels.WARN)
    end
    cb(text)
  end
  vim.keymap.set({ 'n', 'i' }, '<C-s>', submit, { buffer = buf })
  vim.keymap.set({ 'n', 'i' }, '<D-s>', submit, { buffer = buf })
  vim.keymap.set('n', 'q', close, { buffer = buf })
  vim.keymap.set('n', '<Esc>', close, { buffer = buf })
  vim.cmd 'startinsert'
end

function M.comment_here()
  local lc = lifecycle()
  local tab = vim.api.nvim_get_current_tabpage()
  local ctx = lc and lc.get_git_context(tab)
  local data = ctx and cache[ctx.git_root]
  if not data then
    return notify('no PR data loaded for this review', vim.log.levels.WARN)
  end
  local obuf, mbuf = lc.get_buffers(tab)
  local opath, mpath = lc.get_paths(tab)
  local cur = vim.api.nvim_get_current_buf()
  local side, path
  if cur == obuf then
    side, path = 'LEFT', opath
  elseif cur == mbuf then
    side, path = 'RIGHT', mpath
  end
  if not path or not path.relative then
    return notify('not in a diff buffer', vim.log.levels.WARN)
  end
  local row = vim.api.nvim_win_get_cursor(0)[1]
  local thread
  if float_visible(row) then
    for _, t in ipairs((vim.b.pr_comment_threads or {})[tostring(row)] or {}) do
      if t.id then
        thread = t
        break
      end
    end
  end
  local function after(res, what)
    if res.code ~= 0 then
      return notify(what .. ' failed: ' .. (res.stderr or ''), vim.log.levels.ERROR)
    end
    notify(what .. ' posted')
    M.fetch(ctx.git_root, function()
      M.render(tab)
      M.render_explorer(tab)
    end)
  end
  if thread then
    input_modal('Reply to thread', function(body)
      run({
        'gh', 'api', 'graphql',
        '-f', 'thread=' .. thread.id,
        '-f', 'body=' .. body,
        '-f', 'query=mutation($thread:ID!,$body:String!){addPullRequestReviewThreadReply(input:{pullRequestReviewThreadId:$thread,body:$body}){comment{id}}}',
      }, ctx.git_root, function(res) after(res, 'reply') end)
    end, shown.win)
  else
    input_modal(('New comment on %s:%d'):format(path.relative, row), function(body)
      run({
        'gh', 'api', 'graphql',
        '-f', 'pr=' .. data.id,
        '-f', 'body=' .. body,
        '-f', 'path=' .. path.relative,
        '-F', 'line=' .. row,
        '-f', 'side=' .. side,
        '-f', 'query=mutation($pr:ID!,$body:String!,$path:String!,$line:Int!,$side:DiffSide!){addPullRequestReviewThread(input:{pullRequestId:$pr,body:$body,path:$path,line:$line,side:$side}){thread{id}}}',
      }, ctx.git_root, function(res) after(res, 'comment') end)
    end)
  end
end

function M.resolve_or_replace()
  local list = vim.b.pr_comment_threads or {}
  local row = vim.api.nvim_win_get_cursor(0)[1]
  local target
  for _, t in ipairs(list[tostring(row)] or {}) do
    if not t.resolved and t.id then
      target = t
      break
    end
  end
  local visible = float_visible(row)
  if not target or not visible then
    return vim.api.nvim_feedkeys('R', 'n', false)
  end
  return confirm_modal('Resolve this review thread on GitHub?', function(ok)
    if ok then
      M.resolve_thread(target)
    end
  end)
end

function M.resolve_thread(target)
  local lc = lifecycle()
  local tab = vim.api.nvim_get_current_tabpage()
  local ctx = lc and lc.get_git_context(tab)
  if not ctx then
    return notify('not in a CodeDiff tab', vim.log.levels.WARN)
  end
  run({
    'gh', 'api', 'graphql',
    '-f', 'id=' .. target.id,
    '-f', 'query=mutation($id:ID!){resolveReviewThread(input:{threadId:$id}){thread{isResolved}}}',
  }, ctx.git_root, function(res)
    if res.code ~= 0 then
      return notify('resolve failed: ' .. (res.stderr or ''), vim.log.levels.ERROR)
    end
    local data = cache[ctx.git_root]
    if data then
      local counts = {}
      for _, t in ipairs(data.threads) do
        if t.id == target.id then
          t.isResolved = true
        end
        if not t.isResolved and (M.config.show_outdated or not t.isOutdated) then
          counts[t.path] = (counts[t.path] or 0) + 1
        end
      end
      data.counts = counts
    end
    notify 'thread resolved'
    M.render(tab)
    M.render_explorer(tab)
  end)
end

-- Grow the comment float to fit its wrapped content (max 90% of the editor),
-- keeping it below the cursor line, else above, else as low as it fits.
local function fit_float(win)
  local total = vim.o.lines - vim.o.cmdheight
  local h = math.min(vim.api.nvim_win_text_height(win, {}).all, math.floor(vim.o.lines * 0.9), total - 2)
  local cursor = vim.api.nvim_win_get_cursor(0)
  local srow = vim.fn.screenpos(vim.api.nvim_get_current_win(), cursor[1], cursor[2] + 1).row
  local row
  if srow + h + 2 <= total then
    row = srow
  elseif srow - 1 - h - 2 >= 0 then
    row = srow - 1 - h - 2
  else
    row = math.max(0, total - h - 2)
  end
  vim.api.nvim_win_set_config(win, {
    relative = 'editor',
    row = row,
    col = vim.api.nvim_win_get_position(win)[2],
    width = vim.api.nvim_win_get_width(win),
    height = h,
  })
end

-- Diff window in this CodeDiff tab that has comments (modified side first).
local function diff_win_with_threads()
  local lc = lifecycle()
  if not lc then
    return
  end
  local owin, mwin = lc.get_windows(vim.api.nvim_get_current_tabpage())
  for _, w in ipairs { mwin, owin } do
    if w and vim.api.nvim_win_is_valid(w) then
      local l = vim.b[vim.api.nvim_win_get_buf(w)].pr_comment_threads
      if l and not vim.tbl_isempty(l) then
        return w
      end
    end
  end
end

function M.show(dir)
  local list = vim.b.pr_comment_threads
  if not list or vim.tbl_isempty(list) then
    -- e.g. called from the explorer sidebar: act on the diff window instead
    local w = diff_win_with_threads()
    if w then
      vim.api.nvim_set_current_win(w)
      list = vim.b.pr_comment_threads
    end
  end
  if not list or vim.tbl_isempty(list) then
    return notify 'no comments in this buffer'
  end
  local buf = vim.api.nvim_get_current_buf()
  local cur = vim.api.nvim_win_get_cursor(0)[1]
  local float_open = shown.win and vim.api.nvim_win_is_valid(shown.win)
  local already = float_open and shown.buf == buf and shown.row == cur
  close_float()

  local row = cur
  local moved = false
  if dir == 'prev' then
    row = prev_row(list, cur)
    vim.api.nvim_win_set_cursor(0, { row, 0 })
    moved = true
  elseif dir == 'next' or not list[tostring(cur)] or already then
    row = next_row(list, cur)
    vim.api.nvim_win_set_cursor(0, { row, 0 })
    moved = true
  end
  shown.buf, shown.row = buf, row
  local threads = list[tostring(row)]
  local lines = {}
  for ti, t in ipairs(threads) do
    if ti > 1 then
      table.insert(lines, ('─'):rep(40))
    end
    for _, m in ipairs(t.msgs) do
      table.insert(lines, ('**%s** · %s%s'):format(m.author, m.date, t.resolved and ' · resolved' or ''))
      for _, l in ipairs(vim.split(m.body, '\r?\n')) do
        table.insert(lines, l)
      end
      table.insert(lines, '')
    end
  end
  local function open()
    local _, win = vim.lsp.util.open_floating_preview(lines, 'markdown', {
      border = 'rounded',
      max_width = 90,
      wrap = true,
      wrap_at = 90,
      focus_id = 'pr_comments',
      focusable = true,
    })
    shown.win = win
    if win and vim.api.nvim_win_is_valid(win) then
      vim.wo[win].wrap = true
      vim.wo[win].linebreak = true
      vim.wo[win].breakindent = true
      vim.wo[win].conceallevel = 2
      vim.wo[win].winhighlight = 'NormalFloat:PRCommentText'
      fit_float(win)
    end
  end
  if moved then
    vim.defer_fn(open, 30)
  else
    open()
  end
end

local function define_highlights()
  vim.api.nvim_set_hl(0, 'PRCommentUnresolved', { fg = '#61afef', bold = true })
  vim.api.nvim_set_hl(0, 'PRCommentResolved', { fg = '#8b8f99' })
  local normal = vim.api.nvim_get_hl(0, { name = 'Normal', link = false })
  local float = vim.api.nvim_get_hl(0, { name = 'NormalFloat', link = false })
  vim.api.nvim_set_hl(0, 'PRCommentText', { fg = normal.fg, bg = float.bg })
end

function M.setup(opts)
  M.config = vim.tbl_extend('force', M.config, opts or {})
  define_highlights()
  vim.api.nvim_create_autocmd('ColorScheme', { group = aug, callback = define_highlights })

  local function on_open(ev)
    local tab = ev.data and ev.data.tabpage or vim.api.nvim_get_current_tabpage()
    local lc = lifecycle()
    local ctx = lc and lc.get_git_context(tab)
    if not ctx then
      return
    end
    if cache[ctx.git_root] then
      vim.defer_fn(function()
        M.render(tab)
      end, 50)
    else
      M.fetch(ctx.git_root, function()
        M.render(tab)
        M.render_explorer(tab)
      end)
    end
  end

  vim.api.nvim_create_autocmd('User', { group = aug, pattern = { 'CodeDiffOpen', 'CodeDiffFileSelect' }, callback = on_open })
  vim.api.nvim_create_autocmd('User', {
    group = aug,
    pattern = 'CodeDiffVirtualFileLoaded',
    callback = function()
      vim.defer_fn(M.render, 50)
    end,
  })

  vim.api.nvim_create_user_command('PRComments', function(a)
    if a.args == 'show' then
      M.show()
    else
      M.refresh()
    end
  end, { nargs = '?', complete = function() return { 'refresh', 'show' } end })

  if M.config.keymap then
    vim.keymap.set('n', M.config.keymap, function() M.show() end, { desc = 'Show PR comments on line' })
  end
  if M.config.next_keymap then
    vim.keymap.set('n', M.config.next_keymap, function() M.show 'next' end, { desc = 'Next PR comment' })
  end
  if M.config.prev_keymap then
    vim.keymap.set('n', M.config.prev_keymap, function() M.show 'prev' end, { desc = 'Previous PR comment' })
  end
end

return M
