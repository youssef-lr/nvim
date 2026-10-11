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
query($owner:String!,$name:String!,$number:Int!){
  repository(owner:$owner,name:$name){
    pullRequest(number:$number){
      reviewThreads(first:100){
        nodes{
          isResolved isOutdated path line startLine originalLine diffSide
          comments(first:50){nodes{author{login} body createdAt url}}
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

  run({ 'gh', 'pr', 'view', '--json', 'number,url' }, git_root, function(res)
    if res.code ~= 0 then
      return done('no PR for current branch')
    end
    local pr = vim.json.decode(res.stdout)
    local owner, name = pr.url:match 'github.com/([^/]+)/([^/]+)/pull/'
    if not owner then
      return done('cannot parse PR url: ' .. pr.url)
    end
    run({
      'gh', 'api', 'graphql',
      '-F', 'owner=' .. owner,
      '-F', 'name=' .. name,
      '-F', 'number=' .. pr.number,
      '-f', 'query=' .. QUERY,
    }, git_root, function(r)
      if r.code ~= 0 then
        return done('gh api failed: ' .. (r.stderr or ''))
      end
      local data = vim.json.decode(r.stdout)
      local nodes = data.data.repository.pullRequest.reviewThreads.nodes
      local counts = {}
      for _, t in ipairs(nodes) do
        if not t.isResolved and (M.config.show_outdated or not t.isOutdated) then
          counts[t.path] = (counts[t.path] or 0) + 1
        end
      end
      cache[git_root] = { number = pr.number, threads = nodes, counts = counts }
      done()
    end)
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
  table.insert(list[tostring(row + 1)], { resolved = t.isResolved, msgs = msgs })
  vim.b[buf].pr_comment_threads = list
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
function M.show(dir)
  local list = vim.b.pr_comment_threads
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
