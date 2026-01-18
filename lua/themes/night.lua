vim.cmd('colorscheme vague')

local bg = VagueColors.bg

-- ============================================================================
-- NEOVIM
-- ============================================================================

-- UI Elements
vim.api.nvim_set_hl(0, 'WinBar', { bg = '#2e3232' })

vim.api.nvim_set_hl(0, 'WinSeparator', { bg = bg, fg = '#4b4848' })
vim.api.nvim_set_hl(0, 'WinBar', { bg = '#2e3232' })
vim.api.nvim_set_hl(0, 'EndOfBuffer', { bg = bg, fg = bg })

-- Cursor and Lines
vim.api.nvim_set_hl(0, 'CursorLine', { bg = bg, underline = false })
vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = VagueColors.number, bold = true })
vim.api.nvim_set_hl(0, 'LineNr', { fg = '#9f9f9f', bg = '' })

-- Search and Visual Selection
vim.api.nvim_set_hl(0, 'Visual', { bg = VagueColors.visual }) -- Don't set fg so syntax highlighting is kept
vim.api.nvim_set_hl(0, 'IncSearch', { link = 'Visual' })
vim.api.nvim_set_hl(0, 'Search', { link = 'Visual' })
vim.api.nvim_set_hl(0, 'CurSearch', { link = 'Visual' })

-- Popup Menu
vim.api.nvim_set_hl(0, 'PmenuThumb', { bg = '#9c9898' })
vim.api.nvim_set_hl(0, 'PmenuSel', { bg = VagueColors.visual })

-- Diagnostics
vim.api.nvim_set_hl(0, 'DiagnosticHint', { fg = VagueColors.hint, bg = '' })
vim.api.nvim_set_hl(0, 'DiagnosticInfo', { fg = VagueColors.info, bg = '' })
vim.api.nvim_set_hl(0, 'DiagnosticWarn', { fg = VagueColors.warning, bg = '' })
vim.api.nvim_set_hl(0, 'DiagnosticError', { fg = VagueColors.error, bg = '' })

-- Errors and Messages
vim.api.nvim_set_hl(0, 'Error', { fg = VagueColors.error, bold = false })
vim.api.nvim_set_hl(0, 'ErrorMsg', { link = 'Error' })

-- Diff
vim.api.nvim_set_hl(0, 'DiffAdd', { fg = '#939a74' })
vim.api.nvim_set_hl(0, 'DiffAdded', { link = 'DiffAdd' })
vim.api.nvim_set_hl(0, 'DiffText', { fg = '#000000', bg = VagueColors.func })

-- Miscellaneous
vim.api.nvim_set_hl(0, 'MatchParen', { fg = '#d5d7d8', bold = true })
vim.cmd('hi QuickfixLine gui=NONE')

-- Terminal Colors
vim.g.terminal_color_1 = '#be8c8c' -- Red
vim.g.terminal_color_2 = '#9da380' -- Green
vim.g.terminal_color_3 = '#cdc09e' -- Yellow
vim.g.terminal_color_4 = '#90a0a5' -- Blue
vim.g.terminal_color_5 = '#cdb2b1' -- Magenta
vim.g.terminal_color_8 = '#905858' -- Bright Black (Gray)
vim.g.terminal_color_9 = '#d9b2aa' -- Bright Red
vim.g.terminal_color_12 = '#90a0a5' -- Bright Blue
vim.g.terminal_color_13 = '#9da380' -- Bright Magenta

-- vim.g.terminal_color_6 = '#be8c8c' -- Cyan
-- vim.g.terminal_color_7 = '#be8c8c' -- White
vim.g.terminal_color_10 = '#90a0a5' -- Bright Green
-- vim.g.terminal_color_11 = '#be8c8c' -- Bright Yellow
-- vim.g.terminal_color_14 = '#be8c8c' -- Bright Cyan
-- vim.g.terminal_color_15 = '#333333' -- Bright White

-- ============================================================================
-- Syntax/Treesitter
-- ============================================================================
vim.api.nvim_set_hl(0, 'Type', { fg = VagueColors.type, bold = true })
vim.api.nvim_set_hl(0, 'Tag', { fg = '#cdc09e' })

vim.api.nvim_set_hl(0, '@type', { link = 'Type' })
vim.api.nvim_set_hl(0, '@function.method.call', { link = 'Function' })
vim.api.nvim_set_hl(0, '@function.call', { link = 'Function' })
vim.api.nvim_set_hl(0, '@variable.parameter', { link = '@variable' })
vim.api.nvim_set_hl(0, '@variable.member', { link = '@variable' })
vim.api.nvim_set_hl(0, '@keyword.import', { link = '@keyword' })
vim.api.nvim_set_hl(0, '@punctuation.bracket', { fg = '#a4bac1' })
vim.api.nvim_set_hl(0, '@tag.attribute', { fg = 'Grey70', bold = true })
vim.api.nvim_set_hl(0, '@diff.plus', { link = 'DiffAdd' })

-- Git Commit Treesitter
vim.api.nvim_set_hl(0, '@spell.gitcommit', { link = 'String' })
vim.api.nvim_set_hl(0, '@markup.heading.gitcommit', { link = 'Function' })
vim.api.nvim_set_hl(0, '@markup.link.gitcommit', { link = 'Number' })
vim.api.nvim_set_hl(0, '@string.special.path.gitcommit', { link = 'Constant' })

-- ============================================================================
-- PLUGINS
-- ============================================================================

-- LSP
vim.api.nvim_set_hl(0, 'LspSignatureActiveParameter', { fg = '#b5ba99', bold = true })
vim.api.nvim_set_hl(0, 'LspReferenceText', { link = 'Visual' })

-- nvim-cmp
vim.api.nvim_set_hl(0, 'CmpItemAbbrMatch', { link = 'String' })
vim.api.nvim_set_hl(0, 'CmpItemKindKeyword', { link = 'Keyword' })
vim.api.nvim_set_hl(0, 'CmpItemKindClass', { link = 'Type' })
vim.api.nvim_set_hl(0, 'CmpItemKindMethod', { link = 'Function' })
vim.api.nvim_set_hl(0, 'CmpItemKindField', { link = 'Constant' })
vim.api.nvim_set_hl(0, 'CmpItemKindProperty', { link = 'Number' })

-- Blink.cmp
vim.api.nvim_set_hl(0, 'BlinkCmpLabelMatch', { link = 'String' })
vim.api.nvim_set_hl(0, 'BlinkCmpKindClass', { link = 'Type' })
vim.api.nvim_set_hl(0, 'BlinkCmpKindEnum', { link = 'Type' })
vim.api.nvim_set_hl(0, 'BlinkCmpKindInterface', { link = 'Type' })
vim.api.nvim_set_hl(0, 'BlinkCmpKindStruct', { link = 'type' })
vim.api.nvim_set_hl(0, 'BlinkCmpKindField', { link = 'Variable' })
vim.api.nvim_set_hl(0, 'BlinkCmpKindKeyword', { link = 'Keyword' })
vim.api.nvim_set_hl(0, 'BlinkCmpKindMethod', { link = 'Function' })
vim.api.nvim_set_hl(0, 'BlinkCmpKindFunction', { link = 'Function' })
vim.api.nvim_set_hl(0, 'BlinkCmpKindEnumMember', { link = 'Constant' })
vim.api.nvim_set_hl(0, 'BlinkCmpKindConstant', { link = 'Constant' })
vim.api.nvim_set_hl(0, 'BlinkCmpKindText', { link = 'Comment' })
vim.api.nvim_set_hl(0, 'BlinkCmpKindProperty', { link = 'Variable' })
vim.api.nvim_set_hl(0, 'BlinkCmpKindUnit', { link = 'Variable' })
vim.api.nvim_set_hl(0, 'BlinkCmpKindFile', { link = 'Variable' })
vim.api.nvim_set_hl(0, 'BlinkCmpKindValue', { link = 'Variable' })
vim.api.nvim_set_hl(0, 'BlinkCmpKindColor', { link = 'Variable' })
vim.api.nvim_set_hl(0, 'BlinkCmpKindEvent', { link = 'Variable' })
vim.api.nvim_set_hl(0, 'BlinkCmpKindModule', { link = 'Variable' })
vim.api.nvim_set_hl(0, 'BlinkCmpKindFolder', { link = 'Variable' })
vim.api.nvim_set_hl(0, 'BlinkCmpKindSnippet', { link = 'Variable' })
vim.api.nvim_set_hl(0, 'BlinkCmpKindVariable', { link = 'Variable' })
vim.api.nvim_set_hl(0, 'BlinkCmpKindOperator', { link = 'Variable' })
vim.api.nvim_set_hl(0, 'BlinkCmpKindReference', { link = 'Variable' })
vim.api.nvim_set_hl(0, 'BlinkCmpKindConstructor', { link = 'Variable' })
vim.api.nvim_set_hl(0, 'BlinkCmpKindTypeParameter', { link = 'Variable' })

-- treesitter-context
local treesitterContextBG = '#3c4144'
vim.api.nvim_set_hl(0, 'TreesitterContext', { bg = treesitterContextBG })
vim.api.nvim_set_hl(0, 'TreesitterContextLineNumber', { bg = treesitterContextBG })

-- gitsigns.nvim
vim.api.nvim_set_hl(0, 'GitSignsAdd', { fg = '#cad2a5' })
vim.api.nvim_set_hl(0, 'GitSignsChange', { link = 'Keyword' })

-- fugitive
vim.api.nvim_set_hl(0, 'fugitiveSymbolicRef', { link = 'Number' })

-- fzf-lua
vim.api.nvim_set_hl(0, 'FzfLuaHeaderText', { link = 'Error' })
vim.api.nvim_set_hl(0, 'FzfLuaLiveSym', { link = 'Error' })
vim.api.nvim_set_hl(0, 'FzfLuaBufFlagCur', { link = 'Error' })
vim.api.nvim_set_hl(0, 'FzfLuaPathLineNr', { link = 'String' })

-- telescope.nvim
vim.api.nvim_set_hl(0, 'TelescopeMatching', { link = 'CursorLineNr' })
vim.api.nvim_set_hl(0, 'TelescopeMatchingAlternate', { link = 'Number' })
vim.api.nvim_set_hl(0, 'TelescopeSelection', { link = 'Visual' })
vim.api.nvim_set_hl(0, 'TelescopeSelectionCaret', { link = 'Function' })

-- nvim-web-devicons
vim.api.nvim_set_hl(0, 'DevIconPhp', { link = 'Function' })
vim.api.nvim_set_hl(0, 'DevIconH', { link = 'Keyword' })
vim.api.nvim_set_hl(0, 'DevIconCpp', { link = 'Function' })

-- flash.nvim
vim.api.nvim_set_hl(0, 'FlashLabel', { fg = '#ffffff', bold = true })
