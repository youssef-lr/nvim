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
        project = {
          enable = true,
          limit = 8,
          action = 'FzfLua oldfiles cwd=',
          only = {
            '~/Expensidev/Auth',
            '~/Expensidev/Web-Expensify',
            '~/Expensidev/App',
            '~/.config/nvim',
          }
        },
        mru = { limit = 10, cwd_only = true },
      },
    }
    local dashboard = require('dashboard')
  end,
  dependencies = { { 'nvim-tree/nvim-web-devicons' } }
}
