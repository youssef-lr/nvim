return {
  'nvim-telescope/telescope.nvim',
  branch = '0.1.x',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    require('telescope').setup {
      defaults = {
        layout_config = {
          prompt_position = 'top',
        },
        sorting_strategy = 'ascending', -- Makes the sorting start from the top
      }
    }

    -- Files mappings
    local files = '<cmd>Telescope git_files<CR>'
    local tfiles = '<C-\\><C-n>:q<CR><cmd>Telescope git_files<CR>'
    vim.api.nvim_set_keymap('n', '<D-p>', files, { noremap = true, silent = true })
    vim.api.nvim_set_keymap('n', '<M-p>', files, { noremap = true, silent = true })
    vim.api.nvim_set_keymap('t', '<D-p>', tfiles, { noremap = true, silent = true })
    vim.api.nvim_set_keymap('t', '<M-p>', tfiles, { noremap = true, silent = true })
  end,
}
