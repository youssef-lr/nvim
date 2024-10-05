-- Seoul256 theme settings

vim.cmd('colorscheme seoul256')

local background = "#3f3f3f"

vim.api.nvim_set_hl(0, 'Normal', { bg = background, fg = 'Grey90' })

-- Terminal color settings
vim.g.terminal_color_0 = "#000000"
vim.g.terminal_color_1 = "#d96969"
vim.g.terminal_color_2 = "#98bc99"
vim.g.terminal_color_3 = "#ffde99"
vim.g.terminal_color_4 = "#98bede"
vim.g.terminal_color_5 = "#d87180"
vim.g.terminal_color_6 = "#72bcba"
vim.g.terminal_color_7 = "#d9d8d4"
vim.g.terminal_color_8 = "#000000"
vim.g.terminal_color_9 = "#f08686"
vim.g.terminal_color_10 = "#8bb898"
vim.g.terminal_color_11 = "#daddbd"
vim.g.terminal_color_12 = "#99bedd"
vim.g.terminal_color_13 = "#eaaf9b"
vim.g.terminal_color_14 = "#72bcba"
vim.g.terminal_color_15 = "#d9d8d4"

-- Cursor and Line Highlighting
vim.api.nvim_set_hl(0, 'CursorLine', { bg = 'NONE' })
vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = '#e09b99', bg = '#2f2e2e', bold = true })
vim.api.nvim_set_hl(0, 'CursorColumn', { bg = '#1c1c1c' })

-- Line numbers and Sign Column
vim.api.nvim_set_hl(0, 'LineNr', { fg = '#bcb098', bg = background })
vim.api.nvim_set_hl(0, 'SignColumn', { fg = '#d75fff', bg = background })
vim.api.nvim_set_hl(0, 'VertSplit', { fg = background })
vim.api.nvim_set_hl(0, 'WinSeparator', { fg = background })

-- Visual and Diff highlights
vim.api.nvim_set_hl(0, 'Visual', { bg = '#875f5F' })
vim.api.nvim_set_hl(0, 'DiffAdd', { bg = '#5f875f', fg = '#ffffff' })
vim.api.nvim_set_hl(0, 'DiffText', { bg = '#7b2019' })

-- Pmenu highlights
vim.api.nvim_set_hl(0, 'Pmenu', { bg = '#303030', fg = '#ffffff' })
vim.api.nvim_set_hl(0, 'PmenuSbar', { bg = '#ffffff' })
vim.api.nvim_set_hl(0, 'PmenuThumb', { bg = '#bcb098' })
vim.api.nvim_set_hl(0, 'PmenuSel', { bg = '#875f5f', fg = '#ffffff' })

vim.api.nvim_set_hl(0, 'QuickFixLine', { fg = '#e09b99', bg = '#2f2e2e' })
vim.api.nvim_set_hl(0, 'qfFilename', { link = 'LineNr' })

-- Diagnostic highlights
vim.api.nvim_set_hl(0, "DiagnosticHint", { fg = "#b7b7c2", bg = background })
vim.api.nvim_set_hl(0, "DiagnosticInfo", { fg = "#cdd7d3", bg = background })
vim.api.nvim_set_hl(0, "DiagnosticWarn", { fg = "#ffd787", bg = background })
vim.api.nvim_set_hl(0, "DiagnosticError", { fg = "#e09b99", bg = background })

-- Syntax highlighting
vim.api.nvim_set_hl(0, 'Boolean', { fg = '#98bede' })
vim.api.nvim_set_hl(0, 'Constant', { fg = '#79a8d0' })
vim.api.nvim_set_hl(0, 'Comment', { fg = '#8ca98c' })
vim.api.nvim_set_hl(0, 'String', { fg = '#98bcbd' })
vim.api.nvim_set_hl(0, 'Exception', { fg = '#d96969' })
vim.api.nvim_set_hl(0, 'Identifier', { fg = '#dbdbdf' })
vim.api.nvim_set_hl(0, 'Keyword', { fg = '#e09b99' })
vim.api.nvim_set_hl(0, 'Statement', { fg = '#98bc99' })
vim.api.nvim_set_hl(0, 'Special', { fg = '#e0bebc' })
vim.api.nvim_set_hl(0, 'Tag', { fg = '#dfdebd' })
vim.api.nvim_set_hl(0, 'Type', { fg = 'NvimLightGrey2' })
vim.api.nvim_set_hl(0, 'Structure', { fg = '#e6cdcc' })
vim.api.nvim_set_hl(0, 'Include', { fg = '#d3c6ac' })
vim.api.nvim_set_hl(0, 'Delimiter', { fg = '#ad9493', bold = true })

-- Indentation guides
vim.api.nvim_set_hl(0, 'IndentBlankLineContextChar', { fg = 'Grey70' })

-- Miscellaneous highlights
vim.api.nvim_set_hl(0, 'fugitiveUnstagedHeading', { fg = '#e09b99' })
vim.api.nvim_set_hl(0, 'ErrorMsg', { bg = '#875f5f' })

-- Lualine inactive highlights
vim.api.nvim_set_hl(0, 'lualine_b_inactive', { fg = '#909090', bg = '#434343' })
vim.api.nvim_set_hl(0, 'lualine_a_inactive', { fg = '#909090', bg = '#434343' })
vim.api.nvim_set_hl(0, 'lualine_c_inactive', { fg = '#909090', bg = '#434343' })
vim.api.nvim_set_hl(0, 'lualine_c_normal', { fg = '#C7C3C4', bg = '#434343' })

-- Define colors for git diff in the status line
local changedBlue = '#afd4f2'
local addedGreen = '#bce7bd'
local removedRed = '#ffc0b9'
local common_bg = '#4e4e43'
local inactive_bg = '#484844'

-- Function to set highlights for multiple modes
local function set_hl_for_modes(group, fg, bg)
    local modes = { 'normal', 'insert', 'visual', 'replace', 'command', 'terminal', 'inactive' }
    for _, mode in ipairs(modes) do
        local bg_color = mode == 'inactive' and inactive_bg or bg
        vim.api.nvim_set_hl(0, group .. '_' .. mode, { fg = fg, bg = bg_color })
    end
end

-- Apply highlights for git changes in lualine
set_hl_for_modes('lualine_b_diff_modified', changedBlue, common_bg)
set_hl_for_modes('lualine_b_diff_added', addedGreen, common_bg)
set_hl_for_modes('lualine_b_diff_removed', removedRed, common_bg)
set_hl_for_modes('lualine_a_diff_modified', changedBlue, common_bg)
set_hl_for_modes('lualine_a_diff_added', addedGreen, common_bg)
set_hl_for_modes('lualine_a_diff_removed', removedRed, common_bg)

-- Additional individual highlights
vim.api.nvim_set_hl(0, 'Added', { fg = addedGreen })
vim.api.nvim_set_hl(0, 'Changed', { fg = changedBlue })
vim.api.nvim_set_hl(0, 'GitSignsStagedChange', { fg = '#466e8d' })
