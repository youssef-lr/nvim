local diagnosticsSection = {
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
        warn = { fg = '#c2ac7b' },
        error = { fg = '#be8c8c' },
    },
}

local bg = '#2a2c30'
local sections = {
    mode = {
        'mode',
        color = function()
            local mode_color = {
                n = { fg = '#000000', bg = '#96b0ad', gui = 'bold' }, -- Normal
                i = { fg = '#000000', bg = '#b3b993', gui = 'bold' }, -- Insert
                c = { fg = '#000000', bg = '#bc9a9c', gui = 'bold' }, -- Command
            }
            return mode_color[vim.fn.mode()]
        end
    },
    branch = {
        'branch',
        color = function()
            local bg = '#2a2c30'
            local mode_color = {
                n = { fg = '#c2ac7b', bg = bg }, -- Normal
                i = { fg = '#c2ac7b', bg = bg }, -- Insert
                c = { fg = '#c2ac7b', bg = bg }, -- Command
                v = { fg = '#c2ac7b', bg = bg }, -- Command
            }
            return mode_color[vim.fn.mode()]
        end

    },
    diff = {
        'diff',
    },
    diagnostics = {
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
            warn = { fg = '#c2ac7b' },
            error = { fg = '#be8c8c' },
        },
    },
    filename = {
        'filename',
        color = function()
            local bg = '#2a2c30'
            local fg = '#acacac'
            local mode_color = {
                n = { fg = fg, bg = bg }, -- Normal
                i = { fg = fg, bg = bg }, -- Insert
                c = { fg = fg, bg = bg }, -- Command
                v = { fg = fg, bg = bg }, -- Visual
                t = { fg = fg, bg = bg }, -- Visual
            }
            return mode_color[vim.fn.mode()]
        end
    }
}

local M = {
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
            },
            color = { bg = '#2a2c30' },
        },
        sections = {
            lualine_a = {
                sections.mode,
            },
            lualine_b = {
                sections.branch,
                sections.diff,
                sections.diagnostics
            },
            lualine_c = { sections.filename },
            lualine_x = { 'encoding', 'fileformat', 'filetype' },
            lualine_y = { 'progress' },
            lualine_z = { 'location' }
        },
        inactive_sections = {
            lualine_a = {
                sections.diff,
                sections.diagnostics,
            },
            lualine_b = { sections.filename },
            lualine_c = { 'location' },
        },
        tabline = {},
        winbar = {},
        inactive_winbar = {},
        extensions = { 'nvim-tree', 'fugitive', 'lazy', 'mason', 'fzf', 'toggleterm', 'oil' }
    }
}

return M;
