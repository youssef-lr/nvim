return {
  'nvimdev/lspsaga.nvim',
  config = function()
    require('lspsaga').setup({
      finder = {
        keys = {
          shuttle = '<M-l>',
          quit = 'q'
        },
        max_height = 1,
        left_width = 0.2,
        right_width = 0.8,
      },
      lightbulb = {
        enable = false
      },
      symbol_in_winbar = {
        enable = false
      },
      definition = {
        width = 1,
        height = 1
      },
      rename = {
        auto_save = true
      },
    })
    vim.keymap.set('n', '<leader>ca', '<cmd>Lspsaga code_action<CR>', { silent = true, noremap = true })
    vim.keymap.set('n', '<leader>rf', '<cmd>Lspsaga finder<CR>', { silent = true, noremap = true })
    vim.keymap.set('n', '<leader>rn', '<cmd>Lspsaga rename<CR>', { silent = true, noremap = true })
    vim.keymap.set('n', '<D-e>', '<cmd>Lspsaga peek_definition<CR>', { silent = true, noremap = true })

    vim.keymap.set('n', '<leader>lb', '<cmd>Lspsaga winbar_toggle<CR>', { silent = true, noremap = true })
    require('lspsaga').config.definition.width = 1;
    require('lspsaga').config.definition.height = 1;
  end,
  dependencies = {
    'nvim-treesitter/nvim-treesitter', -- optional
    'nvim-tree/nvim-web-devicons',     -- optional
  }
}
