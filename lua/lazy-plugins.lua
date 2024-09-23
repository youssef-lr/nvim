local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  'tpope/vim-sleuth',
  'tpope/vim-surround',
  "junegunn/seoul256.vim",
  "stephpy/vim-php-cs-fixer",

  require 'plugins/gitsigns',

  -- require 'plugins/which-key',

  require 'plugins/lspconfig',

  require 'plugins/conform',

  require 'plugins/nvim_cmp',

  require 'plugins/todo-comments',

  require 'plugins/treesitter',

  require 'plugins.indent_line',
  require 'plugins.autopairs',
  require 'plugins.nvimtree',
  require 'plugins.oil',
  require 'plugins.fugitive',
  require 'plugins.fzf',
  require 'plugins.lualine',
  require 'plugins.terminal',
  require 'plugins.template_string',
  require 'plugins.saga',
  require 'plugins.dashbord',
  require 'plugins.gitlinker',
  require 'plugins.lint',
}, {
  defaults = {
    lazy = false
  },
  ui = {
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

-- vim: ts=2 sts=2 sw=2 et
