-- Track and restore the last open buffer per directory using vim sessions
local M = {}

-- Path to store sessions
local session_dir = vim.fn.stdpath('data') .. '/sessions'

-- Create session directory if it doesn't exist
vim.fn.mkdir(session_dir, 'p')

-- Get session file path for current directory
local function get_session_file()
  local cwd = vim.fn.getcwd()
  -- Create a safe filename from the cwd path
  local session_name = cwd:gsub('/', '%%')
  return session_dir .. '/' .. session_name .. '.vim'
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

-- Restore session for current directory
local function restore_session()
  -- Only restore if vim was opened without arguments
  if vim.fn.argc() > 0 then
    return
  end

  local session_file = get_session_file()

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
