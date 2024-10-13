vim.api.nvim_buf_set_keymap(0, 'i', '-', '->', { noremap = true })
vim.api.nvim_buf_set_keymap(0, 'i', 'ù', '->', { noremap = true })

vim.api.nvim_buf_set_keymap(0, 'n', '<M-e>', '<cmd>ClangdSwitchSourceHeader<CR>', { noremap = true })

vim.cmd('setlocal indentkeys-=:')

vim.cmd('iabbr cint const int64_t')
vim.cmd('iabbr cont const')

vim.api.nvim_buf_set_keymap(0, 'n', '<leader><leader>ts', 'ciwto_string(<ESC>pa)',
    { noremap = true, desc = 'wrap variable in to_string' })
