local M =  {
  "coder/claudecode.nvim",
  dependencies = { "folke/snacks.nvim" },
  config = true,
  opts = {
    terminal_cmd = "~/.local/bin/claude", -- Point to local installation
  },
  keys = {
    --{ "<leader>a", nil, desc = "AI/Claude Code" },
    { "<D-l>", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
    { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
    { "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
    { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
    { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
    { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
    { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
    {
      "<leader>as",
      "<cmd>ClaudeCodeTreeAdd<cr>",
      desc = "Add file",
      ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw" },
    },
    -- Diff management
    { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
    { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
  },
}

vim.keymap.set('n', '<D-l>', '<cmd>ClaudeCodeFocus<cr><esc>', { noremap = true })
vim.keymap.set('i', '<D-l>', '<esc><cmd>ClaudeCodeFocus<cr><esc>', { noremap = true })
vim.keymap.set('t', '<D-l>', '<C-\\><C-n><cmd>ClaudeCodeFocus<cr><esc>', { noremap = true })

return M
