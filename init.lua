require 'options'

require 'keymaps'

require 'lazy-plugins'

--require 'color'

require('neovide')

require('nvim-highlight-colors').setup({})


local lualineBackground = '#2a2c30'
vim.api.nvim_set_hl(0, 'lualine_b_normal', { bg = lualineBackground })
vim.api.nvim_set_hl(0, 'lualine_c_normal', { bg = lualineBackground })
vim.api.nvim_set_hl(0, 'lualine_d_normal', { bg = lualineBackground })

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
vim.g.terminal_color_5 = '#be8c8c' -- Magenta (I hate it, make it red)
