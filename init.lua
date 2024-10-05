require 'options'

require 'keymaps'

require 'lazy-plugins'

--require 'color'

require('neovide')

require('nvim-highlight-colors').setup({})



local lualineBackground = "#2a2c30"
vim.api.nvim_set_hl(0, "lualine_a_normal", { fg = "#000000", bg = "#96b0ad", bold = true })
vim.api.nvim_set_hl(0, "lualine_b_normal", { bg = lualineBackground })
vim.api.nvim_set_hl(0, "lualine_c_normal", { bg = lualineBackground })
vim.api.nvim_set_hl(0, "lualine_d_normal", { bg = lualineBackground })
vim.api.nvim_set_hl(0, "lualine_b_visual", { bg = lualineBackground })
vim.api.nvim_set_hl(0, "lualine_c_visual", { bg = lualineBackground })
vim.api.nvim_set_hl(0, "lualine_d_visual", { bg = lualineBackground })
vim.api.nvim_set_hl(0, "lualine_b_insert", { bg = lualineBackground })
vim.api.nvim_set_hl(0, "lualine_c_insert", { bg = lualineBackground })
vim.api.nvim_set_hl(0, "lualine_d_insert", { bg = lualineBackground })
vim.api.nvim_set_hl(0, "lualine_b_inactive", { bg = lualineBackground })
vim.api.nvim_set_hl(0, "lualine_c_inactive", { bg = lualineBackground })
vim.api.nvim_set_hl(0, "lualine_d_inactive", { bg = lualineBackground })
vim.api.nvim_set_hl(0, "lualine_a_command", { bg = lualineBackground })
vim.api.nvim_set_hl(0, "lualine_b_command", { bg = lualineBackground })
vim.api.nvim_set_hl(0, "lualine_c_command", { bg = lualineBackground })
vim.api.nvim_set_hl(0, "lualine_d_command", { bg = lualineBackground })

-- Terminal color settings
vim.g.terminal_color_3 = "#e0c182"
