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

        -- Files mappings
        local files = '<cmd>FzfLua files<CR>'
        local tfiles = '<C-\\><C-n>:q<CR><cmd>FzfLua files<CR>'
        vim.api.nvim_set_keymap('n', '<D-p>', files, { noremap = true, silent = true })
        vim.api.nvim_set_keymap('n', '<M-p>', files, { noremap = true, silent = true })
        vim.api.nvim_set_keymap('t', '<D-p>', tfiles, { noremap = true, silent = true })
        vim.api.nvim_set_keymap('t', '<M-p>', tfiles, { noremap = true, silent = true })

        -- Oldfiles mappings (recently opened files)
        local oldfiles = '<cmd>FzfLua oldfiles<CR>'
        local toldfiles = '<C-\\><C-n>:q<CR><cmd>FzfLua oldfiles<CR>'
        vim.api.nvim_set_keymap('n', '<D-r>', oldfiles, { noremap = true, silent = true })
        vim.api.nvim_set_keymap('n', '<M-r>', oldfiles, { noremap = true, silent = true })
        vim.api.nvim_set_keymap('t', '<D-r>', toldfiles, { noremap = true, silent = true })

        -- Git status
        local gstatus = '<cmd>FzfLua git_status<CR>'
        local tgstatus = '<C-\\><C-n>:q<CR><cmd>FzfLua git_status<CR>'
        vim.api.nvim_set_keymap('n', '<D-g>', gstatus, { noremap = true, silent = true })
        vim.api.nvim_set_keymap('t', '<D-g>', tgstatus, { noremap = true, silent = true })

        -- Document symbols
        local symbols = '<cmd>FzfLua lsp_document_symbols<CR>'
        vim.api.nvim_set_keymap('n', '<D-o>', symbols, { noremap = true })
        vim.api.nvim_set_keymap('n', '<leader>o', symbols, { noremap = true, silent = true })

        -- Find references
        local references = '<cmd>FzfLua lsp_references<CR>'
        vim.api.nvim_set_keymap('n', '<leader>u', references, { noremap = true, silent = true })
        vim.api.nvim_set_keymap('n', '<D-u>', references, { noremap = true, silent = true })

        -- Buffers
        local buffers = '<cmd>FzfLua buffers<CR>'
        local tbuffers = '<C-\\><C-n>:q<CR><cmd>FzfLua buffers<CR>'
        vim.api.nvim_set_keymap('n', '<D-b>', buffers, { noremap = true, silent = true })
        vim.api.nvim_set_keymap('n', '<M-b>', buffers, { noremap = true, silent = true })
        vim.api.nvim_set_keymap('t', '<M-b>', tbuffers, { noremap = true, silent = true })

        -- Grep
        local grep = '<cmd>FzfLua grep<CR>'
        local tgrep = '<C-\\><C-n>:q<CR><cmd>FzfLua grep<CR>'
        vim.api.nvim_set_keymap('n', '<M-f>', grep, { noremap = true, silent = true })
        vim.api.nvim_set_keymap('n', '<D-f>', grep, { noremap = true, silent = true })
        vim.api.nvim_set_keymap('t', '<M-f>', tgrep, { noremap = true, silent = true })
        vim.api.nvim_set_keymap('t', '<D-f>', tgrep, { noremap = true, silent = true })

        -- Live grep
        vim.api.nvim_set_keymap('n', '<leader>lg', '<cmd>FzfLua live_grep<CR>', { noremap = true, silent = true })
        vim.api.nvim_set_keymap('n', '<leader>gg', '<cmd>FzfLua live_grep_glob<CR>', { noremap = true, silent = true })

        -- Current buffer diagnostics
        vim.api.nvim_set_keymap('n', '<leader>a', '<cmd>FzfLua diagnostics_document<CR>',
            { noremap = true, silent = true })

        -- Grep word under cursor
        vim.api.nvim_set_keymap('n', '<leader>rg', '<cmd>FzfLua grep_cword<CR>', { noremap = true, silent = true })

        -- Grep visual selection
        vim.api.nvim_set_keymap('v', '<leader>rg', '<cmd>FzfLua grep_visual<CR>', { noremap = true, silent = true })

        -- Git commits
        vim.api.nvim_set_keymap('n', '<leader>gc', '<cmd>FzfLua git_commits<CR>', { noremap = true, silent = true })

        -- Keep option+r as native ctrl+r to trigger fzf history in the terminal
        vim.api.nvim_set_keymap('t', '<M-r>', '<C-r>', { noremap = true, silent = true })
    end
}
