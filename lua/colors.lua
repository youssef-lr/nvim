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

vim.api.nvim_set_hl(0, 'NvimTreeStatusLine', { bg = '#34383d' })

vim.cmd('hi QuickfixLine gui=NONE')
