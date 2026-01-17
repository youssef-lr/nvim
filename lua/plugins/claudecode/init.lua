local M = {
  'coder/claudecode.nvim',
  config = true,
  opts = {
    terminal_cmd = 'claude',
    terminal = {
      provider = require('plugins.claudecode.toggleterm-provider'),
    },
  },
  keys = {
    --{ "<leader>a", nil, desc = "AI/Claude Code" },
    { '<D-l>', '<cmd>ClaudeCodeFocus<cr>', desc = 'Focus Claude' },
    { '<leader>af', '<cmd>ClaudeCodeFocus<cr>', desc = 'Focus Claude' },
    { '<leader>ar', '<cmd>ClaudeCode --resume<cr>', desc = 'Resume Claude' },
    { '<leader>aC', '<cmd>ClaudeCode --continue<cr>', desc = 'Continue Claude' },
    { '<leader>am', '<cmd>ClaudeCodeSelectModel<cr>', desc = 'Select Claude model' },
    { '<leader>ab', '<cmd>ClaudeCodeAdd %<cr>', desc = 'Add current buffer' },
    { '<leader>as', '<cmd>ClaudeCodeSend<cr>', mode = 'v', desc = 'Send to Claude' },
    {
      '<leader>as',
      '<cmd>ClaudeCodeTreeAdd<cr>',
      desc = 'Add file',
      ft = { 'NvimTree', 'neo-tree', 'oil', 'minifiles', 'netrw' },
    },
    -- Diff management
    { '<leader>aa', '<cmd>ClaudeCodeDiffAccept<cr>', desc = 'Accept diff' },
    { '<leader>ad', '<cmd>ClaudeCodeDiffDeny<cr>', desc = 'Deny diff' },
  },
}

vim.keymap.set('n', '<D-l>', '<cmd>ClaudeCodeFocus<cr><esc>', { noremap = true })
vim.keymap.set('i', '<D-l>', '<esc><cmd>ClaudeCodeFocus<cr><esc>', { noremap = true })
vim.keymap.set('t', '<D-l>', '<C-\\><C-n><cmd>ClaudeCodeFocus<cr><esc>', { noremap = true })

local function clear_terminal()
  -- Get the channel ID of the current terminal buffer
  local chan_id = vim.bo.channel

  -- Check if we're in a terminal buffer
  if chan_id == nil then
    print('Not in a terminal buffer')
    return
  end

  -- Check if we're in normal mode and switch to insert mode if needed
  local mode = vim.api.nvim_get_mode().mode
  if mode == 'n' or mode == 'nt' then
    vim.cmd('startinsert')
  end

  -- Send /clear followed by Enter
  vim.api.nvim_chan_send(chan_id, '/clear')
end

vim.keymap.set('t', '<D-K>', clear_terminal, { noremap = true })

return M
