-- Track and restore the last open buffer per directory using vim sessions
local M = {}

-- Path to store sessions
local session_dir = vim.fn.stdpath('data') .. '/sessions'

-- Create session directory if it doesn't exist
vim.fn.mkdir(session_dir, 'p')

-- Get session file path for a directory (defaults to the current cwd)
local function get_session_file(cwd)
  cwd = cwd or vim.fn.getcwd()
  -- Create a safe filename from the cwd path
  local session_name = cwd:gsub('/', '%%')
  return session_dir .. '/' .. session_name .. '.vim'
end

-- Path of the main worktree for the repo containing `dir`, or nil if not a repo.
local function main_worktree(dir)
  local out = vim.fn.systemlist({ 'git', '-C', dir, 'worktree', 'list' })
  if vim.v.shell_error ~= 0 or not out[1] then
    return nil
  end
  return out[1]:match('^(%S+)')
end

-- Per-repo file tracking the last worktree we were in, keyed by the repo's main
-- worktree root, so each repo reopens its own last worktree independently.
local function last_dir_file_for(root)
  return session_dir .. '/last_dir.' .. root:gsub('/', '%%')
end

local function record_last_dir(dir)
  dir = dir or vim.fn.getcwd()
  local root = main_worktree(dir)
  if not root then
    return
  end
  vim.fn.writefile({ dir }, last_dir_file_for(root))
end

local function read_last_dir(root)
  local file = last_dir_file_for(root)
  if vim.fn.filereadable(file) ~= 1 then
    return nil
  end
  local lines = vim.fn.readfile(file)
  local dir = lines[1]
  if dir and dir ~= '' and vim.fn.isdirectory(dir) == 1 then
    return dir
  end
end

-- Check if a buffer is valid for tracking
local function is_valid_buffer(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()

  -- Check if buffer is valid
  if not vim.api.nvim_buf_is_valid(bufnr) then
    return false
  end

  local buftype = vim.bo[bufnr].buftype
  local bufname = vim.api.nvim_buf_get_name(bufnr)
  local filetype = vim.bo[bufnr].filetype

  -- Exclude terminal buffers
  if buftype == 'terminal' then
    return false
  end

  -- Exclude readonly buffers
  if vim.bo[bufnr].readonly then
    return false
  end

  -- Exclude special buffer types (help, quickfix, etc.)
  if buftype ~= '' then
    return false
  end

  -- Exclude empty buffers or special filetypes
  if bufname == '' or filetype == 'alpha' or filetype == 'dashboard' then
    return false
  end

  -- Only track real files
  if vim.fn.filereadable(bufname) ~= 1 then
    return false
  end

  return true
end
local is_session_deleted = false

-- Save session for current directory
local function save_session()
  if is_session_deleted then
    return
  end

  -- Remember where we are, even if the current buffer isn't worth saving.
  record_last_dir(vim.fn.getcwd())

  local bufnr = vim.api.nvim_get_current_buf()

  if is_valid_buffer(bufnr) then
    local session_file = get_session_file()

    -- Temporarily set sessionoptions to only save the buffer
    local saved_sessionoptions = vim.o.sessionoptions
    vim.o.sessionoptions = 'buffers,curdir'

    -- Save the session
    vim.cmd('mksession! ' .. vim.fn.fnameescape(session_file))

    -- Restore original sessionoptions
    vim.o.sessionoptions = saved_sessionoptions
  end
end

-- Switch to another directory (e.g. a worktree), restoring its last session.
-- Saves the current dir's session first so its open file is preserved.
function M.switch_dir(dir)
  save_session()

  local session_file = get_session_file(dir)
  if vim.fn.filereadable(session_file) == 1 then
    -- The session restores both the open buffer and curdir.
    vim.cmd('silent! source ' .. vim.fn.fnameescape(session_file))
  else
    -- No prior session for this dir: just cd in.
    vim.cmd('cd ' .. vim.fn.fnameescape(dir))
  end

  record_last_dir(dir)
end

-- Restore session for current directory
local function restore_session()
  -- Only restore if vim was opened without arguments
  if vim.fn.argc() > 0 then
    return
  end

  local cwd = vim.fn.getcwd()
  local target = cwd

  -- Launched from the main worktree root: reopen the last worktree we were in.
  -- From any other dir, just restore that dir's own session.
  local root = main_worktree(cwd)
  if root and vim.fn.resolve(root) == vim.fn.resolve(cwd) then
    target = read_last_dir(root) or cwd
  end

  local session_file = get_session_file(target)

  if vim.fn.filereadable(session_file) == 1 then
    -- Delete the initial empty buffer if it exists
    vim.schedule(function()
      -- Source the session file immediately without schedule
      vim.cmd('silent! source ' .. vim.fn.fnameescape(session_file))
    end)
  else
    -- No session found, open FzfLua oldfiles
    vim.schedule(function()
      require('fzf-lua').oldfiles()
    end)
  end
end

-- Delete session for current directory
local function delete_session()
  local session_file = get_session_file()

  if vim.fn.filereadable(session_file) == 1 then
    vim.fn.delete(session_file)
    vim.notify('Session deleted for ' .. vim.fn.getcwd(), vim.log.levels.INFO)
    is_session_deleted = true
  else
    vim.notify('No session found for ' .. vim.fn.getcwd(), vim.log.levels.WARN)
  end
end

function M.setup()
  -- Save session when switching buffers or leaving vim
  vim.api.nvim_create_autocmd({ 'VimLeavePre' }, {
    group = vim.api.nvim_create_augroup('RestoreBuffer', { clear = true }),
    callback = save_session,
  })

  -- Restore session on startup
  vim.api.nvim_create_autocmd('VimEnter', {
    group = vim.api.nvim_create_augroup('RestoreBufferOnStartup', { clear = true }),
    nested = true,
    callback = restore_session,
  })

  -- Create user command to delete session
  vim.api.nvim_create_user_command('DeleteSession', delete_session, {
    desc = 'Delete the session for the current directory',
  })
end

return M
