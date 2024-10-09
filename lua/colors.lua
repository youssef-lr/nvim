vim.cmd('colorscheme vague')

local bg = VagueColors.bg
local fg = VagueColors.fg

vim.api.nvim_set_hl(0, 'WinSeparator', { bg = bg, fg = '#3f3f3f' })

vim.api.nvim_set_hl(0, '@function.method.call', { fg = '#bc9a9c', bg = bg })
vim.api.nvim_set_hl(0, '@function.call', { fg = '#bc9a9c', bg = bg })
vim.api.nvim_set_hl(0, '@variable.parameter', { link = '@variable' })
vim.api.nvim_set_hl(0, '@keyword.import', { link = '@keyword' })
vim.api.nvim_set_hl(0, '@variable.member', { link = '@variable' })
vim.api.nvim_set_hl(0, '@punctuation.bracket', { fg = '#a4bac1' })

vim.api.nvim_set_hl(0, 'Tag', { fg = '#cdc09e' })

vim.api.nvim_set_hl(0, 'CursorLine', { bg = bg, underline = false })
vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = VagueColors.func, bg = '#27292d', bold = true })

vim.api.nvim_set_hl(0, 'DiagnosticInfo', { fg = '#cdd7d3', bg = bg })
vim.api.nvim_set_hl(0, 'DiagnosticWarn', { fg = VagueColors.warning, bg = bg })
vim.api.nvim_set_hl(0, 'LineNr', { fg = '#9f9f9f', bg = bg })

-- Don't set fg so syntax highlighting is kept
vim.api.nvim_set_hl(0, 'Visual', { bg = VagueColors.visual })
vim.api.nvim_set_hl(0, 'IncSearch', { fg = bg, bg = VagueColors.search })
vim.api.nvim_set_hl(0, 'Search', { fg = bg, bg = VagueColors.search })
vim.api.nvim_set_hl(0, 'CurSearch', { fg = bg, bg = VagueColors.search })

vim.api.nvim_set_hl(0, 'PmenuThumb', { bg = '#9c9898' })
vim.api.nvim_set_hl(0, 'PmenuSel', { bg = VagueColors.visual })
vim.api.nvim_set_hl(0, 'CmpItemAbbrMatch', { link = 'String' })

vim.api.nvim_set_hl(0, 'EndOfBuffer', { bg = bg, fg = bg })
vim.api.nvim_set_hl(0, 'GitSignsAdd', { fg = '#cad2a5' })
vim.api.nvim_set_hl(0, 'GitSignsChange', { link = 'Keyword' })

vim.api.nvim_set_hl(0, 'Error', { fg = VagueColors.error, bold = false })
vim.api.nvim_set_hl(0, 'ErrorMsg', { link = 'Error' })

vim.api.nvim_set_hl(0, 'FzfLuaHeaderText', { link = 'Error' })
vim.api.nvim_set_hl(0, 'FzfLuaLiveSym', { link = 'Error' })
vim.api.nvim_set_hl(0, 'FzfLuaBufFlagCur', { link = 'Error' })
vim.api.nvim_set_hl(0, 'FzfLuaPathLineNr', { link = 'String' })

vim.api.nvim_set_hl(0, 'DiffAdd', { fg = '#939a74' })
vim.api.nvim_set_hl(0, 'DiffAdded', { link = 'DiffAdd' })
vim.api.nvim_set_hl(0, '@diff.plus', { link = 'DiffAdd' })
vim.api.nvim_set_hl(0, 'DiffText', { fg = '#000000', bg = VagueColors.func })


vim.api.nvim_set_hl(0, 'MatchParen', { fg = '#d5d7d8', bold = true })

vim.api.nvim_set_hl(0, '@spell.gitcommit', { link = 'String' })
vim.api.nvim_set_hl(0, '@markup.heading.gitcommit', { link = 'Function' })
vim.api.nvim_set_hl(0, '@string.special.path.gitcommit', { link = 'Constant' })
vim.api.nvim_set_hl(0, 'fugitiveSymbolicRef', { link = 'Number' })

vim.cmd('hi QuickfixLine gui=NONE')

local lualineBackground = '#2a2c30'
vim.api.nvim_set_hl(0, 'lualine_b_normal', { bg = lualineBackground })
vim.api.nvim_set_hl(0, 'lualine_c_normal', { bg = lualineBackground })
vim.api.nvim_set_hl(0, 'lualine_d_normal', { bg = lualineBackground })
vim.api.nvim_set_hl(0, 'lualine_x_normal', { bg = lualineBackground })
vim.api.nvim_set_hl(0, 'lualine_y_normal', { bg = lualineBackground })
vim.api.nvim_set_hl(0, 'lualine_z_normal', { bg = lualineBackground })

vim.api.nvim_set_hl(0, 'lualine_b_visual', { bg = lualineBackground })
vim.api.nvim_set_hl(0, 'lualine_c_visual', { bg = lualineBackground })
vim.api.nvim_set_hl(0, 'lualine_d_visual', { bg = lualineBackground })

vim.api.nvim_set_hl(0, 'lualine_b_insert', { bg = lualineBackground })
vim.api.nvim_set_hl(0, 'lualine_c_insert', { bg = lualineBackground })
vim.api.nvim_set_hl(0, 'lualine_d_insert', { bg = lualineBackground })

vim.api.nvim_set_hl(0, 'lualine_b_command', { bg = lualineBackground })
vim.api.nvim_set_hl(0, 'lualine_c_command', { bg = lualineBackground })
vim.api.nvim_set_hl(0, 'lualine_d_command', { bg = lualineBackground })

vim.api.nvim_set_hl(0, 'lualine_b_replace', { bg = lualineBackground })
vim.api.nvim_set_hl(0, 'lualine_c_replace', { bg = lualineBackground })
vim.api.nvim_set_hl(0, 'lualine_d_replace', { bg = lualineBackground })

vim.api.nvim_set_hl(0, 'lualine_b_terminal', { bg = lualineBackground })
vim.api.nvim_set_hl(0, 'lualine_c_terminal', { bg = lualineBackground })
vim.api.nvim_set_hl(0, 'lualine_d_terminal', { bg = lualineBackground })

vim.api.nvim_set_hl(0, 'lualine_a_inactive', { bg = lualineBackground })
vim.api.nvim_set_hl(0, 'lualine_b_inactive', { bg = lualineBackground })
vim.api.nvim_set_hl(0, 'lualine_c_inactive', { bg = lualineBackground })
vim.api.nvim_set_hl(0, 'lualine_d_inactive', { bg = lualineBackground })

vim.api.nvim_set_hl(0, 'lualine_transitional_lualine_z_location_0_normal_to_lualine_c_normal', { bg = '#000000' })
vim.api.nvim_set_hl(0, 'lualine_transitional_lualine_z_location_0_command_to_lualine_c_command', { bg = '#000000' })
vim.api.nvim_set_hl(0, 'lualine_transitional_lualine_z_location_0_inactive_to_lualine_c_inactive', { bg = '#000000' })

--
-- vim.api.nvim_set_hl(0, 'lualine_a_diff_added_normal', { bg = lualineBackground, fg = '#cad2a5' })
-- vim.api.nvim_set_hl(0, 'lualine_a_diff_modified_normal', { bg = lualineBackground, fg = '#8cadc6' })
-- vim.api.nvim_set_hl(0, 'lualine_a_diff_removed_normal', { bg = lualineBackground, fg = '#be8c8c' })
--
-- vim.api.nvim_set_hl(0, 'lualine_a_diff_added_inactive', { bg = lualineBackground, fg = '#cad2a5' })
-- vim.api.nvim_set_hl(0, 'lualine_a_diff_modified_inactive', { bg = lualineBackground, fg = '#8cadc6' })
-- vim.api.nvim_set_hl(0, 'lualine_a_diff_removed_inactive', { bg = lualineBackground, fg = '#be8c8c' })
--
--
-- vim.api.nvim_set_hl(0, 'lualine_a_command', { bg = lualineBackground })
-- vim.api.nvim_set_hl(0, 'lualine_b_command', { bg = lualineBackground })
-- vim.api.nvim_set_hl(0, 'lualine_c_command', { bg = lualineBackground })
-- vim.api.nvim_set_hl(0, 'lualine_d_command', { bg = lualineBackground })

-- Terminal color settings
vim.g.terminal_color_1 = '#be8c8c' -- Red
vim.g.terminal_color_2 = '#9da380' -- Green
vim.g.terminal_color_3 = '#c2ac7b' -- Yellow
vim.g.terminal_color_4 = '#a1b3b9' -- Blue
vim.g.terminal_color_5 = '#905858' -- Magenta (I hate it, make it red)
