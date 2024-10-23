vim.cmd('colorscheme vague')

local bg = VagueColors.bg

vim.api.nvim_set_hl(0, 'WinSeparator', { bg = bg, fg = '#4b4848' })

vim.api.nvim_set_hl(0, '@function.method.call', { link = 'Function' })
vim.api.nvim_set_hl(0, '@function.call', { link = 'Function' })
vim.api.nvim_set_hl(0, '@variable.parameter', { link = '@variable' })
vim.api.nvim_set_hl(0, '@keyword.import', { link = '@keyword' })
vim.api.nvim_set_hl(0, '@variable.member', { link = '@variable' })
vim.api.nvim_set_hl(0, '@punctuation.bracket', { fg = '#a4bac1' })

vim.api.nvim_set_hl(0, 'Tag', { fg = '#cdc09e' })

vim.api.nvim_set_hl(0, 'CursorLine', { bg = bg, underline = false })
vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = VagueColors.number, bold = true })

vim.api.nvim_set_hl(0, 'DiagnosticInfo', { fg = '#cdd7d3', bg = '' })
vim.api.nvim_set_hl(0, 'DiagnosticWarn', { fg = VagueColors.warning, bg = '' })
vim.api.nvim_set_hl(0, 'DiagnosticError', { fg = VagueColors.error, bg = '' })
vim.api.nvim_set_hl(0, 'LineNr', { fg = '#9f9f9f', bg = '' })

-- Don't set fg so syntax highlighting is kept
vim.api.nvim_set_hl(0, 'Visual', { bg = VagueColors.visual })
vim.api.nvim_set_hl(0, 'IncSearch', { link = 'Visual' })
vim.api.nvim_set_hl(0, 'Search', { link = 'Visual' })
vim.api.nvim_set_hl(0, 'CurSearch', { link = 'Visual' })

vim.api.nvim_set_hl(0, 'PmenuThumb', { bg = '#9c9898' })
vim.api.nvim_set_hl(0, 'PmenuSel', { bg = VagueColors.visual })

vim.api.nvim_set_hl(0, 'CmpItemAbbrMatch', { link = 'String' })
vim.api.nvim_set_hl(0, 'CmpItemKindKeyword', { link = 'Keyword' })
vim.api.nvim_set_hl(0, 'CmpItemKindClass', { link = 'Type' })
vim.api.nvim_set_hl(0, 'CmpItemKindMethod', { link = 'Function' })
vim.api.nvim_set_hl(0, 'CmpItemKindField', { link = 'Constant' })
vim.api.nvim_set_hl(0, 'CmpItemKindProperty', { link = 'Number' })

vim.api.nvim_set_hl(0, 'LspSignatureActiveParameter', { fg = '#b5ba99', bold = true })

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

vim.api.nvim_set_hl(0, 'TelescopeMatching', { link = 'String' })
vim.api.nvim_set_hl(0, 'TelescopeMatchingAlternate', { link = 'Number' })
vim.api.nvim_set_hl(0, 'TelescopeSelection', { link = 'Visual' })
vim.api.nvim_set_hl(0, 'TelescopeSelectionCaret', { link = 'Function' })

vim.api.nvim_set_hl(0, 'DevIconPhp', { link = 'Function' })
vim.api.nvim_set_hl(0, 'DevIconH', { link = 'Keyword' })
vim.api.nvim_set_hl(0, 'DevIconCpp', { link = 'Function' })

vim.cmd('hi QuickfixLine gui=NONE')

-- Terminal color settings
vim.g.terminal_color_1 = '#be8c8c'  -- Red
vim.g.terminal_color_2 = '#9da380'  -- Green
vim.g.terminal_color_3 = '#c2ac7b'  -- Yellow
vim.g.terminal_color_4 = '#90a0a5'  -- Blue
vim.g.terminal_color_12 = '#90a0a5' -- Bright Blue
vim.g.terminal_color_5 = '#905858'  -- Magenta (I hate it, make it red)
