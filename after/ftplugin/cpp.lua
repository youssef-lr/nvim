-- Uncrustify configuration
vim.g.uncrustify_config_file = '/Users/youssef/Expensidev/Auth/ci/uncrustify_config.txt'

vim.api.nvim_buf_set_keymap(0, 'n', '<leader><leader>f', ':Uncrustify<CR>:w<CR>', { noremap = true })
vim.api.nvim_buf_set_keymap(0, 'i', '-', '->', { noremap = true })
vim.api.nvim_buf_set_keymap(0, 'i', 'ù', '->', { noremap = true })
