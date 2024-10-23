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
    require 'plugins.vague',
    require 'plugins.lspconfig',
    require 'plugins/nvim_cmp',
    require 'plugins.telescope',
    require 'plugins/treesitter',
    require 'plugins.gitsigns',
    require 'plugins.lint',
    require 'plugins/conform',
    require 'plugins.indent_line',
    require 'plugins.autopairs',
    require 'plugins.oil',
    require 'plugins.fugitive',
    require 'plugins.fzf',
    require 'plugins.lualine',
    require 'plugins.terminal',
    require 'plugins.template_string',
    require 'plugins.grug-far',
    require 'plugins.gitlinker',
    require 'plugins.miniai',
    require 'plugins.nvim-spider',
    require 'plugins.dashbord',
    --'mattn/emmet-vim',
    --require 'plugins.auto-sessions',
    --require 'plugins/todo-comments',
    -- require 'plugins.saga',
    -- require 'plugins.dressing',
    --require 'plugins.nvimtree',
    --require 'plugins.code-companion',
    --require 'plugins.supermaven',
    --require 'plugins.highlight',
    -- require 'plugins.leap',
    -- require 'plugins.hlchunk',
    -- require 'plugins.neodim',
    -- require 'plugins.avante',
    -- require 'plugins/which-key',
    --require 'plugins.markdown',
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
        border = 'single'
    },
})
