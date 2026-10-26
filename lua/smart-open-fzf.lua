-- Smart open for fzf-lua: a port of danielfalk/smart-open.nvim's ranking algorithm.
--
-- Candidates come from your open history (persisted as JSON) followed by the
-- output of a file listing command, deduplicated. History entries are ranked by
-- a base score combining frecency (Mozilla's algorithm), recency, open/alternate
-- buffer status, directory proximity to the current file, and whether the file
-- is under cwd. Since the fzf binary owns fuzzy matching, the smart ranking is
-- the initial order and the tiebreaker (--tiebreak=index): an empty prompt shows
-- the pure smart ranking, and while typing it breaks fzf match-score ties.
local uv = vim.uv or vim.loop

local M = {}

-- Frequency decays with a half-life so recent opens count more (Mozilla frecency)
local HALF_LIFE_DAYS = 10
local DECAY = math.log(2) / HALF_LIFE_DAYS
local POINTS_PER_OPEN = 100

-- Default weights from smart-open.nvim (without its self-tuning, which requires
-- observing per-keystroke match scores that the fzf binary doesn't expose)
local WEIGHTS = {
  open = 3,
  alt = 4,
  proximity = 13,
  project = 10,
  frecency = 17,
  recency = 9,
}

M.opts = {
  -- Files matching these are never recorded in history
  ignore_patterns = { '%.git/', '/tmp/', '%.pdf$', '^term://', '^fugitive://', '^oil://' },
  -- Matched against the cwd-relative path when the picker opens: matching
  -- results are hidden but stay in history, so e.g. worktree files are hidden
  -- from the main repo yet still show when cwd is inside that worktree
  hide_patterns = { '%.claude/worktrees/' },
}

-- Lists files, plus .md and .env files even when gitignored (deduplicated, order kept)
M.unignored_cmd = [[rg --files --hidden --no-ignore-vcs --glob "*.md" --glob ".env*" --glob "!.git" --glob "!node_modules" --glob "!vendor" --glob "!.claude/worktrees"]]
M.default_cmd = string.format([[{ rg --files --hidden --glob "!.git"; %s; } 2>/dev/null | awk '!seen[$0]++']], M.unignored_cmd)

M.db_path =vim.fn.stdpath('data') .. '/smart-open-fzf.json'
M.db = nil

local function is_ignored(filepath)
  for _, pattern in ipairs(M.opts.ignore_patterns) do
    if filepath:find(pattern) then
      return true
    end
  end
  return false
end

local function is_hidden(rel_path)
  for _, pattern in ipairs(M.opts.hide_patterns) do
    if rel_path:find(pattern) then
      return true
    end
  end
  return false
end

-- Score remaining on an entry right now, given its expiration timestamp
local function current_score(expiration, now)
  local time_left = (expiration - now) / 86400
  if time_left <= 0 then
    return 1
  end
  return math.exp(DECAY * time_left)
end

-- New expiration after one more open at `now`
local function bump(expiration, now)
  local score = current_score(expiration or now, now) + POINTS_PER_OPEN
  return math.floor(now + (math.log(score) / DECAY) * 86400)
end

local function write_db()
  if not M.db then
    return
  end
  -- Merge with what's on disk so parallel nvim instances don't clobber each other
  local f = io.open(M.db_path, 'r')
  if f then
    local ok, disk = pcall(vim.json.decode, f:read('*a'))
    f:close()
    if ok and type(disk) == 'table' then
      for p, r in pairs(disk) do
        local mine = M.db[p]
        if not mine or (r.l or 0) > (mine.l or 0) then
          M.db[p] = r
        end
      end
    end
  end
  f = io.open(M.db_path, 'w')
  if f then
    f:write(vim.json.encode(M.db))
    f:close()
  end
end

local save_timer = nil
local function save_db(force)
  if save_timer and not save_timer:is_closing() then
    save_timer:stop()
    save_timer:close()
  end
  save_timer = nil
  if force then
    write_db()
  else
    save_timer = vim.defer_fn(write_db, 2000)
  end
end

-- Seed a fresh db from v:oldfiles, spacing entries out as if opened over time
local function import_oldfiles(db)
  local oldfiles = vim.v.oldfiles or {}
  local now = os.time()
  for index, filepath in ipairs(oldfiles) do
    local p = vim.fn.fnamemodify(filepath, ':p')
    if not is_ignored(p) then
      local stat = uv.fs_stat(p)
      if stat and stat.type == 'file' then
        local when = now - (#oldfiles + 1 - index) * 9000
        db[p] = { e = bump(nil, when), l = when }
      end
    end
  end
end

local function load_db()
  if M.db then
    return M.db
  end
  local f = io.open(M.db_path, 'r')
  if f then
    local ok, data = pcall(vim.json.decode, f:read('*a'))
    f:close()
    M.db = ok and type(data) == 'table' and data or {}
  else
    M.db = {}
    import_oldfiles(M.db)
    save_db()
  end
  return M.db
end

function M.record(filepath)
  if not filepath or filepath == '' then
    return
  end
  local p = vim.fn.fnamemodify(filepath, ':p')
  if is_ignored(p) then
    return
  end
  local stat = uv.fs_stat(p)
  if not stat or stat.type ~= 'file' then
    return
  end

  local db = load_db()
  local now = os.time()
  local rec = db[p]
  -- Revisits bump frecency/recency, throttled per file so window juggling
  -- doesn't inflate the score
  if rec and rec.l and now - rec.l < 60 then
    return
  end
  db[p] = { e = bump(rec and rec.e, now), l = now }
  -- Expired entries have fully decayed; drop them
  for path, r in pairs(db) do
    if (r.e or 0) <= now then
      db[path] = nil
    end
  end
  save_db()
end

-- Number of leading path components two paths share (deeper in common = closer)
local function calculate_proximity(a, b)
  local in_common = 0
  local index = 0
  local previous_index = 1
  while true do
    index = a:find('/', index + 1)
    if not index then
      break
    elseif index > 1 then
      if a:sub(previous_index, index) == b:sub(previous_index, index) then
        in_common = in_common + 1
      else
        break
      end
    end
    previous_index = index
  end
  return in_common
end

local function normalize_proximity(value)
  return 1 - 1 / (1 + math.exp(value * 0.5 - 3))
end

-- Rank history entries by base score (descending). Returns a list of
-- { path, score } for files that still exist on disk.
local function ranked_history(cwd, cwd_only)
  local db = load_db()
  local now = os.time()

  local curbuf = vim.api.nvim_buf_get_name(0)
  local altnr = vim.fn.bufnr('#')
  local altbuf = altnr > 0 and vim.api.nvim_buf_get_name(altnr) or ''
  local open_buffers = {}
  for _, b in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(b) and vim.bo[b].buflisted then
      local name = vim.api.nvim_buf_get_name(b)
      if name ~= '' then
        open_buffers[name] = true
      end
    end
  end
  local proximity_ref = curbuf ~= '' and curbuf or (cwd .. '/')

  local entries = {}
  local max_flat = 1
  for path, rec in pairs(db) do
    local in_project = path:sub(1, #cwd + 1) == cwd .. '/'
    if (not cwd_only or in_project) and not is_hidden(in_project and path:sub(#cwd + 2) or path) then
      local stat = uv.fs_stat(path)
      if stat and stat.type == 'file' then
        local flat = math.max(0, (rec.e or now) - now)
        max_flat = math.max(max_flat, flat)
        table.insert(entries, { path = path, flat = flat, last = rec.l or 0, in_project = in_project })
      end
    end
  end

  -- Recency rank: 1 = most recently opened
  table.sort(entries, function(a, b)
    return a.last > b.last
  end)

  for rank, e in ipairs(entries) do
    local score = 0
    if e.path ~= curbuf then
      if e.path == altbuf then
        score = score + WEIGHTS.alt
      end
      if open_buffers[e.path] then
        score = score + WEIGHTS.open
      end
      score = score + WEIGHTS.frecency * (e.flat / max_flat)
      score = score + WEIGHTS.recency * (8 / (rank + 7))
      score = score + WEIGHTS.proximity * normalize_proximity(calculate_proximity(proximity_ref, e.path))
    end
    if e.in_project then
      score = score + WEIGHTS.project
    end
    e.score = score
  end

  table.sort(entries, function(a, b)
    return a.score > b.score
  end)

  return entries
end

-- Exposed for debugging: :lua vim.print(require('smart-open-fzf')._ranked(vim.fn.getcwd(), true))
M._ranked = ranked_history

-- Reused per session so we don't litter temp files; cleaned up at VimLeavePre
M._histfile = nil

local function histfile()
  if not M._histfile then
    M._histfile = vim.fn.tempname()
  end
  return M._histfile
end

--- Open the smart-open picker.
---@param opts table|nil
---  * cmd string: file listing command (default: M.default_cmd)
---  * cwd string: directory to search (default: current working directory)
---  * cwd_only boolean: restrict history to files under cwd (default: true)
function M.open(opts)
  opts = opts or {}
  local core = require('fzf-lua.core')
  local fzf_config = require('fzf-lua.config')
  local fzf_path = require('fzf-lua.path')

  local cmd = opts.cmd or M.default_cmd
  local cwd_only = opts.cwd_only ~= false
  opts.cmd = nil
  opts.prompt = opts.prompt or 'SmartOpen❯ '
  opts.cwd_prompt = false
  -- fzf match score first; our smart ordering breaks ties (and owns the empty prompt)
  opts.fzf_opts = vim.tbl_extend('keep', opts.fzf_opts or {}, { ['--tiebreak'] = 'index', ['--scheme'] = 'default' })

  -- Apply the 'files' profile so file_icons/color_icons/previewer are set; the
  -- multiprocess child reads these to render devicons
  opts = fzf_config.normalize_opts(opts, 'files')
  if not opts then
    return
  end

  local cwd = fzf_path.normalize(opts.cwd or uv.cwd())
  local history = ranked_history(cwd, cwd_only)

  -- Display history relative to cwd when possible, matching rg's relative output
  -- so dedup lines up
  local hist_lines = {}
  for _, e in ipairs(history) do
    if fzf_path.is_relative_to(e.path, cwd) then
      hist_lines[#hist_lines + 1] = fzf_path.relative_to(e.path, cwd)
    else
      hist_lines[#hist_lines + 1] = e.path
    end
  end

  -- Build a shell command that emits ranked history first, then the file
  -- listing with those history paths removed. Passing a command string (rather
  -- than an in-process function) lets fzf-lua format icons/paths in a child
  -- process, which is dramatically faster on large repos.
  local full_cmd
  if #hist_lines > 0 then
    local hf = histfile()
    local f = io.open(hf, 'w')
    f:write(table.concat(hist_lines, '\n'))
    f:write('\n')
    f:close()
    local hf_q = vim.fn.shellescape(hf)
    -- grep -vxF: drop lines that exactly equal a history path (already shown)
    full_cmd = string.format('cat %s; { %s; } | grep -vxFf %s', hf_q, cmd, hf_q)
  else
    full_cmd = cmd
  end

  opts.cwd = cwd
  local result = core.fzf_exec(full_cmd, opts)

  -- Force insert mode into the picker, overriding any stopinsert that races
  -- in from elsewhere (e.g. fzf-lua's own deferred close-mode handling when
  -- this picker is opened chained from another action). Retries briefly
  -- since the interfering stopinsert can land on a later tick than this one.
  local picker_buf = vim.api.nvim_get_current_buf()
  local tries = 0
  local function force_insert()
    if not vim.api.nvim_buf_is_valid(picker_buf) or vim.api.nvim_get_current_buf() ~= picker_buf then
      return
    end
    if vim.fn.mode() ~= 't' then
      vim.cmd('startinsert')
    end
    tries = tries + 1
    if tries < 15 then
      vim.defer_fn(force_insert, 20)
    end
  end
  vim.schedule(force_insert)

  return result
end

function M.setup(opts)
  M.opts = vim.tbl_deep_extend('force', M.opts, opts or {})

  local group = vim.api.nvim_create_augroup('SmartOpenFzf', { clear = true })
  vim.api.nvim_create_autocmd({ 'BufWinEnter', 'BufWritePost' }, {
    group = group,
    callback = function(args)
      M.record(args.match)
    end,
  })
  vim.api.nvim_create_autocmd('VimLeavePre', {
    group = group,
    callback = function()
      save_db(true)
      if M._histfile then
        os.remove(M._histfile)
      end
    end,
  })
end

return M
