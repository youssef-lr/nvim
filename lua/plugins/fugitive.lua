return {
    'tpope/vim-fugitive',
    config = function()
        -- Key mappings for Git and diff management
        vim.api.nvim_set_keymap('n', '<leader>s', ':Git<CR>', { noremap = true, silent = true })
        vim.api.nvim_set_keymap('n', '<leader>gd', ':Gvdiffsplit!<CR>', { noremap = true, silent = true })
        vim.api.nvim_set_keymap('n', '<leader>gw', ':Gwrite<CR>', { noremap = true, silent = true })
        vim.api.nvim_set_keymap('n', '<leader>gr', ':Gread<CR>', { noremap = true, silent = true })
        vim.api.nvim_set_keymap('n', '<leader>gc', ':Gcommit<CR>', { noremap = true, silent = true })
        vim.api.nvim_set_keymap('n', 'gvs', ':Gvsplit<CR>', { noremap = true, silent = true })
        vim.api.nvim_set_keymap('n', 'gdh', ':diffget //2<CR>', { noremap = true, silent = true })
        vim.api.nvim_set_keymap('n', 'gdl', ':diffget //3<CR>', { noremap = true, silent = true })
        vim.api.nvim_set_keymap('n', '<leader><Right>', ':diffget //2<CR>', { noremap = true, silent = true })
        vim.api.nvim_set_keymap('n', '<leader><Left>', ':diffget //3<CR>', { noremap = true, silent = true })

        -- Set the highlight color for DiffAdd
        vim.cmd('hi DiffAdd ctermbg=65')
    end
}
