vim.g.seoul256_background = 236
vim.g.seoul256_disable_background = true
vim.g.seoul256_contrast = false
vim.opt.termguicolors = true

vim.cmd('colo seoul256')

vim.api.nvim_set_hl(0, 'CursorLineNr', { bg = '#303030', fg = 'Grey70' })
vim.api.nvim_set_hl(0, 'CursorColumn', { bg = '#1c1c1c' })
vim.api.nvim_set_hl(0, 'LineNr', { fg = '#999872', bg = '#3a3a3a' })


vim.cmd('set t_8f=^[[38;2;%lu;%lu;%lum')
vim.cmd('set t_8b=^[[48;2;%lu;%lu;%lum')
vim.cmd('set t_Co=256')
vim.cmd('set termguicolors')
vim.cmd('hi LineNr guifg=#999872')

-- Highlighting
vim.api.nvim_set_hl(0, 'Visual', { bg = '#875f5F' })

vim.api.nvim_set_hl(0, 'CursorLine', { ctermbg = 237, bg = 'NONE' })
vim.api.nvim_set_hl(0, 'CursorLineNr', { bg = '#303030', fg = 'Grey70' })
vim.api.nvim_set_hl(0, 'CursorColumn', { bg = '#1c1c1c' })

vim.api.nvim_set_hl(0, 'Pmenu', { bg = '#303030', fg = '#ffffff' })
vim.api.nvim_set_hl(0, 'PmenuSbar', { bg = '#ffffff' })
vim.api.nvim_set_hl(0, 'PmenuThumb', { bg = '#262626' })
vim.api.nvim_set_hl(0, 'PmenuSel', { bg = '#875f5f', fg = '#ffffff' })

vim.api.nvim_set_hl(0, 'DiffAdd', { bg = '#5f875f', fg = '#ffffff' })

vim.api.nvim_set_hl(0, 'SignColumn', { fg = '#d75fff', bg = '#3a3a3a' })
vim.api.nvim_set_hl(0, 'VertSplit', { fg = '#3a3a3a' })
vim.api.nvim_set_hl(0, 'WinSeparator', { fg = '#3a3a3a' })

-- Startify
--vim.api.nvim_set_hl(0, 'StartifyFile', { cterm = 'bold', fg = '#87afaf' })

vim.api.nvim_set_hl(0, 'DiffText', { bg = '#7b2019' })

vim.api.nvim_set_hl(0, 'IndentBlankLineContextChar', { fg = 'Grey70' })

-- vim.api.nvim_set_hl(0, 'QuickFixLine', { fg = 'Grey70' })

-- Additional highlights
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
vim.api.nvim_set_hl(0, 'Type', { fg = '#e6cdcc' })
vim.api.nvim_set_hl(0, 'Structure', { fg = '#e6cdcc' })
vim.api.nvim_set_hl(0, 'Include', { fg = '#d3c6ac' })
vim.api.nvim_set_hl(0, 'CocSearch', { fg = '#d5b9b9' })
vim.api.nvim_set_hl(0, 'Delimiter', { fg = '#ad9493', bold = true })

vim.api.nvim_set_hl(0, 'fugitiveUnstagedHeading', { fg = '#e09b99' })

vim.api.nvim_set_hl(0, "DiagnosticHint", { fg = "#b7b7c2", bg = '#3a3a3a' })
vim.api.nvim_set_hl(0, "DiagnosticInfo", { fg = "#cdd7d3", bg = '#3a3a3a' })
vim.api.nvim_set_hl(0, "DiagnosticWarn", { fg = "#ffd787", bg = '#3a3a3a' })
vim.api.nvim_set_hl(0, "DiagnosticError", { fg = "#e09b99", bg = '#3a3a3a' })

vim.api.nvim_set_hl(0, 'ErrorMsg', { bg = '#875f5f' })

-- Terminal colors
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

vim.api.nvim_set_hl(0, 'lualine_b_inactive', { fg = '#909090', bg = '#434343' })
vim.api.nvim_set_hl(0, 'lualine_a_inactive', { fg = '#909090', bg = '#434343' })
vim.api.nvim_set_hl(0, 'lualine_c_inactive', { fg = '#909090', bg = '#434343' })

local changedBlue = '#afd4f2'
local addedGreen = '#bce7bd'
vim.api.nvim_set_hl(0, 'lualine_b_diff_modified_normal', { fg = changedBlue, bg = '#4e4e43' })
vim.api.nvim_set_hl(0, 'lualine_b_diff_modified_insert', { fg = changedBlue, bg = '#4e4e43' })
vim.api.nvim_set_hl(0, 'lualine_b_diff_modified_visual', { fg = changedBlue, bg = '#4e4e43' })
vim.api.nvim_set_hl(0, 'lualine_b_diff_modified_replace', { fg = changedBlue, bg = '#4e4e43' })
vim.api.nvim_set_hl(0, 'lualine_b_diff_modified_command', { fg = changedBlue, bg = '#4e4e43' })
vim.api.nvim_set_hl(0, 'lualine_b_diff_modified_terminal', { fg = changedBlue, bg = '#4e4e43' })
vim.api.nvim_set_hl(0, 'lualine_b_diff_modified_inactive', { fg = changedBlue, bg = '#30302c' })

vim.api.nvim_set_hl(0, 'lualine_b_diff_added_0_normal', { fg = addedGreen, bg = '#4e4e43' })
vim.api.nvim_set_hl(0, 'lualine_b_diff_added_0_insert', { fg = changedBlue, bg = '#4e4e43' })
vim.api.nvim_set_hl(0, 'lualine_b_diff_added_0_visual', { fg = addedGreen, bg = '#4e4e43' })
vim.api.nvim_set_hl(0, 'lualine_b_diff_added_0_replace', { fg = addedGreen, bg = '#4e4e43' })
vim.api.nvim_set_hl(0, 'lualine_b_diff_added_0_command', { fg = addedGreen, bg = '#4e4e43' })
vim.api.nvim_set_hl(0, 'lualine_b_diff_added_0_terminal', { fg = addedGreen, bg = '#4e4e43' })
vim.api.nvim_set_hl(0, 'lualine_b_diff_added_0_inactive', { fg = addedGreen, bg = '#30302c' })

vim.api.nvim_set_hl(0, 'lualine_b_diff_added_normal', { fg = addedGreen, bg = '#4e4e43' })
vim.api.nvim_set_hl(0, 'lualine_b_diff_added_insert', { fg = addedGreen, bg = '#4e4e43' })
vim.api.nvim_set_hl(0, 'lualine_b_diff_added_visual', { fg = addedGreen, bg = '#4e4e43' })
vim.api.nvim_set_hl(0, 'lualine_b_diff_added_replace', { fg = addedGreen, bg = '#4e4e43' })
vim.api.nvim_set_hl(0, 'lualine_b_diff_added_command', { fg = addedGreen, bg = '#4e4e43' })
vim.api.nvim_set_hl(0, 'lualine_b_diff_added_terminal', { fg = addedGreen, bg = '#4e4e43' })
vim.api.nvim_set_hl(0, 'lualine_b_diff_added_inactive', { fg = addedGreen, bg = '#30302c' })

vim.api.nvim_set_hl(0, 'Added', { fg = addedGreen })
vim.api.nvim_set_hl(0, 'Changed', { fg = changedBlue })
vim.api.nvim_set_hl(0, 'GitSignsStagedChange', { fg = '#466e8d' })
