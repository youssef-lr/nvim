return {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
        options = {
            icons_enabled = true,
            theme = 'auto',
            component_separators = { left = '▒', right = '░' },
            section_separators = { left = '▒', right = '░' },
            disabled_filetypes = {
                statusline = {},
                winbar = {},
            },
            ignore_focus = {},
            always_divide_middle = true,
            globalstatus = false,
            refresh = {
                statusline = 1000,
                tabline = 1000,
                winbar = 1000,
            }
        },
        sections = {
            lualine_a = { 'mode' },
            lualine_b = {
                'branch',
                'diff',
                {
                    'diagnostics',
                    sources = { 'nvim_diagnostic' },
                    symbols = {
                        error = '● ',
                        warn = '● ',
                        info = '● ',
                        hint = '● ',
                    },
                    diagnostics_color = {
                        hint = { fg = '#b7b7c2' },
                        info = { fg = '#cdd7d3' },
                        warn = { fg = '#ffd787' },
                        error = { fg = '#e09b99' },
                    },
                },
            },
            lualine_c = { 'filename' },
            lualine_x = { 'encoding', 'fileformat', 'filetype' },
            lualine_y = { 'progress' },
            lualine_z = { 'location' }
        },
        inactive_sections = {
            lualine_a = {
                'diff',
                {
                    'diagnostics',
                    sources = { 'nvim_diagnostic' },
                    symbols = {
                        error = '● ',
                        warn = '● ',
                        info = '● ',
                        hint = '● ',
                    },
                    diagnostics_color = {
                        hint = { fg = '#b7b7c2', bg = '#484844' },
                        info = { fg = '#cdd7d3', bg = '#484844' },
                        warn = { fg = '#ffd787', bg = '#484844' },
                        error = { fg = '#e09b99', bg = '#484844' },
                    },
                }
            },
            lualine_b = { 'filename' },
            lualine_c = { 'location' },
        },
        tabline = {},
        winbar = {},
        inactive_winbar = {},
        extensions = {}
    }
}
