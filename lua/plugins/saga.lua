return {
  'nvimdev/lspsaga.nvim',
  config = function()
    require('lspsaga').setup({
      finder = {
        keys = {
          shuttle = '<C-l>',
          quit = '<C-q>'
        }
      },
      lightbulb = {
        enable = false
      },
      symbol_in_winbar = {
        enable = false
      }
    })
    vim.keymap.set('n', '<leader>ca', '<cmd>Lspsaga code_action<CR>', { silent = true, noremap = true })
    vim.keymap.set('n', '<leader>lf', '<cmd>Lspsaga finder<CR>', { silent = true, noremap = true })
    vim.keymap.set('n', '<leader>rn', '<cmd>Lspsaga rename<CR>', { silent = true, noremap = true })
    vim.keymap.set('n', 'à', '<cmd>Lspsaga peek_definition<CR>', { silent = true, noremap = true })
    vim.keymap.set('n', '<leader>lb', '<cmd>Lspsaga winbar_toggle<CR>', { silent = true, noremap = true })
  end,
  dependencies = {
    'nvim-treesitter/nvim-treesitter', -- optional
    'nvim-tree/nvim-web-devicons',     -- optional
  }
}
