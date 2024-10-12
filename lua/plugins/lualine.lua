local colors = {
    black        = '#000000',
    white        = 'c8c4c4',
    red          = '#bc9a9c',
    green        = '#9da380',
    blue         = '#87aab5',
    yellow       = '#c2ac7b',
    gray         = '#acacac',
    darkgray     = '#acacac',
    lightgray    = '#504945',
    inactivegray = '#7c6f64',
    bg           = '#34383d',
}

local custom = {
    normal = {
        a = { bg = colors.blue, fg = colors.black, gui = 'bold' },
        b = { bg = colors.bg, fg = colors.white },
        c = { bg = colors.bg, fg = colors.white }
    },
    insert = {
        a = { bg = colors.green, fg = colors.black, gui = 'bold' },
        b = { bg = colors.bg, fg = colors.white },
        c = { bg = colors.bg, fg = colors.white }
    },
    visual = {
        a = { bg = colors.yellow, fg = colors.black, gui = 'bold' },
        b = { bg = colors.bg, fg = colors.white },
        c = { bg = colors.bg, fg = colors.white }
    },
    replace = {
        a = { bg = colors.red, fg = colors.black, gui = 'bold' },
        b = { bg = colors.bg, fg = colors.white },
        c = { bg = colors.bg, fg = colors.white }
    },
    command = {
        a = { bg = colors.red, fg = colors.black, gui = 'bold' },
        b = { bg = colors.bg, fg = colors.white },
        c = { bg = colors.bg, fg = colors.white }
    },
    inactive = {
        a = { bg = colors.bg, fg = colors.gray, gui = 'bold' },
        b = { bg = colors.bg, fg = colors.gray },
        c = { bg = colors.bg, fg = colors.gray }
    }
}

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
        hint = { fg = VagueColors.hint },
        info = { fg = '#cdd7d3' },
        warn = { fg = VagueColors.warning },
        error = { fg = VagueColors.error },
    },
}

local function fugitive_branch()
    local icon = '' -- e0a0
    return icon .. ' ' .. vim.fn.FugitiveHead()
end
local function get_short_cwd()
    return vim.fn.fnamemodify(vim.fn.getcwd(), ':~')
end

local fugitive = {
    sections = {
        lualine_b = { fugitive_branch },
    },
    filetypes = { 'fugitive' }
}
local nvimtree = {
    sections = {
        lualine_b = { get_short_cwd },
    },
    filetypes = { 'NvimTree' }
}
vim.api.nvim_set_hl(0, 'NvimTreeStatusLine', { bg = colors.bg })

local M = {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
        options = {
            icons_enabled = true,
            theme = custom,
            component_separators = { left = '', right = '' },
            section_separators = { left = '', right = '' },
            disabled_filetypes = {
                statusline = {},
                winbar = {},
            },
            ignore_focus = {},
            always_divide_middle = true,
            globalstatus = false,
            refresh = {
                statusline = 500,
                tabline = 1000,
                winbar = 1000,
            },
        },
        sections = {
            lualine_a = { 'mode' },
            lualine_b = {
                'branch',
                'diff',
                diagnostics
            },
            lualine_c = { 'filename' },
            lualine_x = { 'filetype' },
            lualine_y = { 'progress' },
            lualine_z = { 'location' },
        },
        inactive_sections = {
            lualine_a = {
                'diff',
                diagnostics,
            },
        },
        tabline = {},
        winbar = {},
        inactive_winbar = {},
        extensions = { nvimtree, fugitive, 'lazy', 'mason', 'fzf', 'toggleterm', 'oil' }
    }
}

return M;
