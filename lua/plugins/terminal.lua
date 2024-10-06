return {
    'akinsho/toggleterm.nvim',
    config = function()
        local toggleterm = require 'toggleterm'
        toggleterm.setup({
            open_mapping = [[<c-\>]],
            hide_numbers = true, -- hide the number column in toggleterm buffers
            shade_filetypes = {},
            shade_terminals = true,
            shading_factor = '1',     -- the degree by which to darken to terminal colour, default: 1 for dark backgrounds, 3 for light
            start_in_insert = true,
            insert_mappings = true,   -- whether or not the open mapping applies in insert mode
            terminal_mappings = true, -- whether or not the open mapping applies in the opened terminals
            persist_size = true,
            persist_mode = false,
            direction = 'float',
            close_on_exit = true, -- close the terminal window when the process exits
            shell = vim.o.shell,  -- change the default shell
            -- This field is only relevant if direction is set to 'float'
            float_opts = {
                -- The border key is *almost* the same as 'nvim_open_win'
                -- see :h nvim_open_win for details on borders however
                -- the 'curved' BOrder is a custom Border type
                -- not natively supported but implemented in this plugin.
                border = 'curved',
                width = 120,
                height = 40,
                winblend = 0,
                highlights = {
                    border = 'Normal',
                    background = 'Normal',
                },
                Normal = {
                    guibg = 'Normal'
                },
            }
        })

        -- Terminal autocmds and key mappings for toggleterm in Lua

        -- Terminal Enter autocmd with mapping
        vim.api.nvim_create_autocmd('TermEnter', {
            pattern = 'term://*toggleterm#*',
            callback = function()
                vim.api.nvim_set_keymap('t', '<c-t>', [[<Cmd>exe v:count1 . "ToggleTerm"<CR>]],
                    { noremap = true, silent = true })
            end,
        })

        -- Normal mode key mappings for ToggleTerm
        vim.api.nvim_set_keymap('n', '&', [[<Cmd>exe "1ToggleTerm"<CR>]], { noremap = true, silent = true })
        vim.api.nvim_set_keymap('n', 'é', [[<Cmd>exe "2ToggleTerm"<CR>]], { noremap = true, silent = true })

        -- Buffer read autocmd for restoring cursor position
        vim.api.nvim_create_autocmd('BufReadPost', {
            callback = function()
                if vim.fn.line("'\"") > 0 and vim.fn.line("'\"") <= vim.fn.line('$') then
                    vim.cmd([[normal! g'"]])
                end
            end,
        })

        -- BufEnter autocmd for toggleterm specific behavior
        vim.api.nvim_create_autocmd('BufEnter', {
            callback = function()
                if vim.bo.buftype == 'terminal' then
                    vim.cmd('startinsert')
                    vim.bo.filetype = 'terminal'
                end
            end,
        })

        -- Terminal autocmd for entering insert mode automatically
        vim.api.nvim_create_autocmd({ 'BufWinEnter', 'WinEnter' }, {
            pattern = 'term://*',
            callback = function()
                vim.cmd('startinsert')
            end,
        })

        -- Start insert mode when opening a terminal
        vim.api.nvim_create_autocmd('TermOpen', {
            callback = function()
                vim.cmd('startinsert')
            end,
        })
    end
}
