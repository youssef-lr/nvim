return {
    'tpope/vim-fugitive',
    config = function()
        -- Key mappings for Git and diff management
        vim.keymap.set('n', '<leader>s', ':Git<CR>', { noremap = true, silent = true })
        vim.keymap.set('n', 'gs', ':Git<CR>', { noremap = true, silent = true })
        vim.keymap.set('n', 'gp', ':Git push<CR>', { noremap = true, silent = true })
        vim.keymap.set('n', '<leader>gd', ':Gvdiffsplit!<CR>', { noremap = true, silent = true })
        vim.keymap.set('n', '<leader>gw', ':Gwrite<CR>', { noremap = true, silent = true })
        vim.keymap.set('n', '<leader>gr', ':Gread<CR>', { noremap = true, silent = true })
        vim.keymap.set('n', '<leader>gc', ':Gcommit<CR>', { noremap = true, silent = true })
        vim.keymap.set('n', 'gvs', ':Gvsplit<CR>', { noremap = true, silent = true })
        vim.keymap.set('n', 'gdh', ':diffget //2<CR>', { noremap = true, silent = true })
        vim.keymap.set('n', 'gdl', ':diffget //3<CR>', { noremap = true, silent = true })
        vim.keymap.set('n', '<leader><Right>', ':diffget //2<CR>', { noremap = true, silent = true })
        vim.keymap.set('n', '<leader><Left>', ':diffget //3<CR>', { noremap = true, silent = true })
        vim.keymap.set('n', '<leader>gm', ':Gvsplit main:%<CR>', { noremap = true, silent = true })
        vim.keymap.set('n', 'gsm', ':Gvsplit main:%<CR>', { noremap = true, silent = true })
        vim.keymap.set('n', '<D-=>', ']c', { noremap = true })
        vim.keymap.set('n', '<D-)>', '[c', { noremap = true })

        -- Set the highlight color for DiffAdd
        vim.cmd('hi DiffAdd ctermbg=65')
        vim.cmd('set diffopt=internal,filler,closeoff,vertical')
    end
}
