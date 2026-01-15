-- Custom terminal provider for claudecode.nvim using toggleterm.nvim
-- This integrates toggleterm's terminal management with claudecode's WebSocket server

local M = {}

local terminal_float_opts = {
  width = function()
    return math.floor(vim.o.columns * 0.9)
  end,
  height = function()
    return math.floor(vim.o.lines * 0.9)
  end,
}

-- Store the terminal instance and state
local state = {
  terminal = nil,
  config = nil,
  last_cmd = nil,
  last_env = nil,
}

-- Helper to check if toggleterm is available
local function has_toggleterm()
  local ok, _ = pcall(require, 'toggleterm')
  return ok
end

-- Helper to get terminal size
local function get_size()
  return math.floor(vim.o.columns * 0.95)
end

-- Helper to create the terminal command with environment variables
local function build_command(cmd_string, env_table)
  if not env_table or vim.tbl_isempty(env_table) then
    return cmd_string
  end

  -- Build shell command with environment variables
  local env_prefix = ''
  for key, value in pairs(env_table) do
    env_prefix = env_prefix .. string.format("%s='%s' ", key, value)
  end

  return env_prefix .. cmd_string
end

-- Required: Setup function
function M.setup(config)
  state.config = config
end

-- Required: Open terminal with command and environment
function M.open(cmd_string, env_table, effective_config, focus)
  if not has_toggleterm() then
    vim.notify('toggleterm.nvim is not available', vim.log.levels.ERROR)
    return
  end

  if focus == nil then
    focus = true
  end

  local Terminal = require('toggleterm.terminal').Terminal

  -- Store command and env for later use
  state.last_cmd = cmd_string
  state.last_env = env_table

  -- Build the full command with environment variables
  local full_cmd = build_command(cmd_string, env_table)

  -- Create or update terminal
  if not state.terminal then
    state.terminal = Terminal:new({
      cmd = full_cmd,
      direction = 'float',
      float_opts = terminal_float_opts,
    })
  end

  state.terminal:open()

  if focus then
    vim.cmd('startinsert!')
  end
end

-- Required: Close the terminal
function M.close()
  if state.terminal then
    state.terminal:close()
  end
end

-- Required: Simple toggle (show/hide)
function M.simple_toggle(cmd_string, env_table, effective_config)
  if not has_toggleterm() then
    vim.notify('toggleterm.nvim is not available', vim.log.levels.ERROR)
    return
  end

  local Terminal = require('toggleterm.terminal').Terminal

  -- Create terminal if it doesn't exist
  if not state.terminal then
    state.last_cmd = cmd_string
    state.last_env = env_table
    local full_cmd = build_command(cmd_string, env_table)

    state.terminal = Terminal:new({
      cmd = full_cmd,
      direction = 'float',
      float_opts = terminal_float_opts,
    })
  end

  state.terminal:toggle()
end

-- Required: Smart toggle (focus if not focused, hide if focused)
function M.focus_toggle(cmd_string, env_table, effective_config)
  if not has_toggleterm() then
    vim.notify('toggleterm.nvim is not available', vim.log.levels.ERROR)
    return
  end

  local Terminal = require('toggleterm.terminal').Terminal

  -- Create terminal if it doesn't exist
  if not state.terminal then
    state.last_cmd = cmd_string
    state.last_env = env_table
    local full_cmd = build_command(cmd_string, env_table)

    state.terminal = Terminal:new({
      id = 9,
      cmd = full_cmd,
      direction = 'float',
      float_opts = terminal_float_opts,
    })
  end

  -- Check if terminal window is currently focused
  local is_focused = false
  if state.terminal and state.terminal.bufnr then
    local current_bufnr = vim.api.nvim_get_current_buf()
    is_focused = current_bufnr == state.terminal.bufnr
  end

  if is_focused then
    -- Hide if currently focused
    state.terminal:close()
  else
    -- Focus/show if not focused
    if not state.terminal:is_open() then
      state.terminal:open()
    else
      -- Terminal is open but not focused, so focus it
      local wins = vim.api.nvim_list_wins()
      for _, win in ipairs(wins) do
        if vim.api.nvim_win_is_valid(win) then
          local buf = vim.api.nvim_win_get_buf(win)
          if buf == state.terminal.bufnr then
            vim.api.nvim_set_current_win(win)
            vim.cmd('startinsert!')
            break
          end
        end
      end
    end
  end
end

-- Required: Get active terminal buffer number
function M.get_active_bufnr()
  if state.terminal and state.terminal.bufnr then
    return state.terminal.bufnr
  end
  return nil
end

-- Required: Check if provider is available
function M.is_available()
  return has_toggleterm()
end

-- Optional: Toggle function (defaults to simple_toggle)
function M.toggle(cmd_string, env_table, effective_config)
  M.simple_toggle(cmd_string, env_table, effective_config)
end

-- Optional: For testing
function M._get_terminal_for_test()
  return state.terminal
end

-- Additional helper: Reset terminal (useful for debugging)
function M.reset()
  if state.terminal then
    state.terminal:shutdown()
  end
  state.terminal = nil
  state.last_cmd = nil
  state.last_env = nil
end

return M
