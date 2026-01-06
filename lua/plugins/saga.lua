return {
  'youssef-lr/lspsaga.nvim',
  config = function()
    require('lspsaga').setup({
      finder = {
        keys = {
          shuttle = { '<Tab>', '<M-l>' },
          quit = { 'q', '<M-q> ' },
        },
        max_height = 1,
        left_width = 0.2,
        right_width = 0.8,
      },
      lightbulb = {
        enable = false,
      },
      symbol_in_winbar = {
        enable = true,
      },
      definition = {
        width = 1,
        height = 1,
        quit = { '<M-q> ' },
      },
      rename = {
        auto_save = true,
      },
      code_action = {
        keys = {
          quit = { 'q', '<ESC>' },
        },
      },
    })
    vim.keymap.set('n', '<leader>ca', '<cmd>Lspsaga code_action<CR>', { silent = true, noremap = true })
    vim.keymap.set('n', '<leader>rf', '<cmd>Lspsaga finder<CR>', { silent = true, noremap = true })
    vim.keymap.set('n', '<leader>rn', '<cmd>Lspsaga rename<CR>', { silent = true, noremap = true })
    vim.keymap.set('n', '<D-e>', '<cmd>Lspsaga peek_definition<CR>', { silent = true, noremap = true })

    vim.keymap.set('n', '<leader>wb', '<cmd>Lspsaga winbar_toggle<CR>', { silent = true, noremap = true })
    vim.keymap.set('n', '<D-K>', '<cmd>Lspsaga go_to_parent<CR>', { silent = true, noremap = true })
  end,
  dependencies = {
    'nvim-treesitter/nvim-treesitter', -- optional
    'nvim-tree/nvim-web-devicons', -- optional
  },
}
