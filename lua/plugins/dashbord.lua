return {
  'nvimdev/dashboard-nvim',
  event = 'VimEnter',
  config = function()
    require('dashboard').setup {
      theme = 'hyper',
      config = {
        week_header = {
          enable = true,
        },
        shortcut = {
          { desc = '󰊳 Update', group = '@property', action = 'Lazy update', key = 'u' },
          {
            icon = ' ',
            icon_hl = '@variable',
            desc = 'Files',
            group = 'Label',
            action = 'FzfLua files',
            key = 'f',
          },
          {
            icon = ' ',
            icon_hl = '@variable',
            desc = 'Recent',
            group = 'Label',
            action = 'FzfLua oldfiles',
            key = 'r',
          },
        },
        mru = { limit = 10, cwd_only = true },
        project = { enable = true, limit = 8, action = 'FzfLua oldfiles cwd=' },
      },
    }
  end,
  dependencies = { { 'nvim-tree/nvim-web-devicons' } }
}
