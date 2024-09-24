return {
    "ibhagwan/fzf-lua",
    -- optional for icon support
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        -- calling `setup` is optional for customization
        require("fzf-lua").setup({
            oldfiles = {
                prompt                  = 'History❯ ',
                cwd_only                = true,
                stat_file               = true, -- verify files exist on disk
                -- can also be a lua function, for example:
                -- stat_file = require("fzf-lua").utils.file_is_readable,
                -- stat_file = function() return true end,
                include_current_session = true, -- include bufs from current session
            },
        })

        -- FZF settings
        vim.api.nvim_create_autocmd('FileType', {
            pattern = 'fzf',
            callback = function() vim.opt_local.conceallevel = 0 end
        })

        -- Autoread trigger when files are changed on disk
        vim.api.nvim_create_autocmd({ 'FocusGained', 'BufEnter', 'CursorHold', 'CursorHoldI' }, {
            callback = function()
                if vim.fn.mode() ~= 'c' then vim.cmd('checktime') end
            end
        })

        -- Normal Mode Mappings
        vim.api.nvim_set_keymap('n', '<C-p>', '<cmd>FzfLua files<CR>', { noremap = true, silent = true })
        vim.api.nvim_set_keymap('n', '<C-r>', '<cmd>FzfLua oldfiles<CR>', { noremap = true, silent = true })
        vim.api.nvim_set_keymap('n', '<C-f>', '<cmd>FzfLua grep<CR>', { noremap = true, silent = true })

        vim.api.nvim_set_keymap('n', '<D-p>', '<cmd>FzfLua files<CR>', { noremap = true, silent = true })
        vim.api.nvim_set_keymap('n', '<D-r>', '<cmd>FzfLua oldfiles<CR>', { noremap = true, silent = true })
        vim.api.nvim_set_keymap('n', '<D-b>', '<cmd>FzfLua buffers<CR>', { noremap = true, silent = true })
        vim.api.nvim_set_keymap('n', '<D-f>', '<cmd>FzfLua grep<CR>', { noremap = true, silent = true })

        vim.api.nvim_set_keymap('n', '<M-p>', '<cmd>FzfLua files<CR>', { noremap = true, silent = true })
        vim.api.nvim_set_keymap('n', '<M-r>', '<cmd>FzfLua oldfiles<CR>', { noremap = true, silent = true })
        vim.api.nvim_set_keymap('n', '<M-b>', '<cmd>FzfLua buffers<CR>', { noremap = true, silent = true })
        vim.api.nvim_set_keymap('n', '<M-f>', '<cmd>FzfLua grep<CR>', { noremap = true, silent = true })

        vim.api.nvim_set_keymap('n', '<leader>gc', '<cmd>FzfLua git_commits<CR>', { noremap = true, silent = true })
        vim.api.nvim_set_keymap('n', '<leader>u', '<cmd>FzfLua lsp_references<CR>', { noremap = true, silent = true })
        vim.api.nvim_set_keymap('n', '<leader>o', '<cmd>FzfLua lsp_document_symbols<CR>',
            { noremap = true, silent = true })
        vim.api.nvim_set_keymap('n', '<leader>a', '<cmd>FzfLua diagnostics_document<CR>',
            { noremap = true, silent = true })
        vim.api.nvim_set_keymap('n', '<leader>rg', '<cmd>FzfLua grep_cword<CR>', { noremap = true, silent = true })
        vim.api.nvim_set_keymap('v', '<leader>rg', '<cmd>FzfLua grep_visual<CR>', { noremap = true, silent = true })
        vim.api.nvim_set_keymap('n', '<leader>lg', '<cmd>FzfLua live_grep<CR>', { noremap = true, silent = true })
        vim.api.nvim_set_keymap('n', '<leader>gg', '<cmd>FzfLua live_grep_glob<CR>', { noremap = true, silent = true })

        --vim.api.nvim_set_keymap('n', '<leader><leader>r', ':Rgp', { noremap = true, silent = true })
        ----vim.api.nvim_set_keymap('n', '<leader>rl', ':Rl', { noremap = true, silent = true })
        --vim.api.nvim_set_keymap('v', '<leader>rg', '"vy:Rg <C-R>v<CR>', { noremap = true, silent = true })
        --vim.api.nvim_set_keymap('v', '<leader>rl', '"vy:Rl <C-R>v<CR>', { noremap = true, silent = true })


        ---- Terminal Mode Mapping
        --vim.api.nvim_set_keymap('t', '<C-p>', '<C-\\><C-n>:GFiles<CR>', { noremap = true, silent = true, buffer = true })
    end
}
