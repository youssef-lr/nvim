-- Uncrustify configuration
vim.g.uncrustify_config_file = '/Users/youssef/Expensidev/Auth/ci/uncrustify_config.txt'

vim.api.nvim_buf_set_keymap(0, 'n', '<leader><leader>f', ':Uncrustify<CR>:w<CR>', { noremap = true })
vim.api.nvim_buf_set_keymap(0, 'i', '-', '->', { noremap = true })
vim.api.nvim_buf_set_keymap(0, 'i', 'ù', '->', { noremap = true })

vim.api.nvim_buf_set_keymap(0, 'n', '<C-e>', '<cmd>ClangdSwitchSourceHeader<CR>', { noremap = true })
vim.api.nvim_buf_set_keymap(0, 'n', '<M-e>', '<cmd>ClangdSwitchSourceHeader<CR>', { noremap = true })

vim.cmd("setlocal indentkeys-=:")

vim.cmd('iabbr cint const int64_t ')
vim.cmd('iabbr cont const')
