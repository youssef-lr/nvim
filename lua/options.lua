vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- Make line numbers default
vim.opt.number = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
    vim.opt.clipboard = 'unnamedplus'
end)

vim.opt.diffopt = { 'internal', 'filler', 'closeoff', 'vertical', 'iwhiteall' }

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- Enable filetype plugins and indentation
vim.cmd('filetype plugin on')
vim.cmd('filetype plugin indent on')


-- General settings
vim.cmd('set nolist')
vim.opt.cursorline = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.wrap = false
vim.opt.ffs = { 'unix', 'dos' }
vim.opt.mouse = 'a'
vim.opt.showmode = false
vim.opt.undodir = vim.fn.expand('~/.vim/undodir')
vim.opt.undofile = true
vim.opt.updatetime = 50
vim.opt.shortmess:append('c')
vim.opt.signcolumn = 'yes'
vim.opt.completeopt:remove('preview')
vim.opt.foldmethod = 'manual'
vim.opt.tabstop = 4
vim.opt.expandtab = true
vim.opt.smarttab = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.shiftwidth = 4

-- History settings
vim.opt.history = 1000

-- Auto-read when a file changes
vim.opt.autoread = true

-- Enable wildmenu
vim.opt.wildmenu = true

-- Always show current position
vim.opt.ruler = true
vim.opt.number = true
vim.opt.cmdheight = 1

-- Buffer becomes hidden when abandoned
vim.opt.hidden = true

-- Smart case for searching
vim.opt.smartcase = true

-- Incremental search
vim.opt.incsearch = true

-- Do not redraw while executing macros
vim.opt.lazyredraw = true

-- Enable magic in regex
vim.opt.magic = true

-- Show matching brackets
vim.opt.showmatch = true
vim.opt.mat = 2

-- No error bells
vim.opt.errorbells = false
vim.opt.visualbell = false
vim.opt.tm = 500
vim.opt.foldcolumn = '0'

-- Set encoding
vim.opt.encoding = 'utf8'

-- Files, backups, and undo settings
vim.opt.backup = false
vim.opt.swapfile = false

-- Ack configuration
vim.g.ackprg = 'rg --files --hidden --follow --glob "!*.lock*"'

-- Auto commands for filetypes
vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
    pattern = '*.js',
    callback = function() vim.bo.filetype = 'javascriptreact' end
})
vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
    pattern = '*.jsx',
    callback = function() vim.bo.filetype = 'javascriptreact' end
})
vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
    pattern = { '*.ts', '*.tsx' },
    callback = function() vim.bo.filetype = 'typescriptreact' end
})

-- FZF settings
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'fzf',
    callback = function() vim.opt_local.conceallevel = 0 end
})

-- Autoread trigger when files are changed on disk
vim.api.nvim_create_autocmd({ 'FocusGained', 'BufEnter', 'CursorHold', 'CursorHoldI' }, {
    callback = function()
        if vim.fn.mode() ~= 'c' then vim.cmd('checktime') end
    end
})

-- Notification after file change
vim.api.nvim_create_autocmd('FileChangedShellPost', {
    callback = function()
        vim.cmd('echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None')
    end
})

-- Uncrustify configuration
vim.g.uncrustify_cfg_file_path = '/Users/youssef/Code/Expensidev/Auth/ci/uncrustify_config.txt'

-- Uncrustify key mappings
vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'c', 'cpp' },
    callback = function()
        vim.api.nvim_buf_set_keymap(0, 'n', '<leader><leader>f', ':Uncrustify<CR>:w<CR>', { noremap = true })
    end
})

-- php cs fixer
--vim.api.nvim_create_autocmd('FileType', {
--pattern = 'php',
--callback = function()
--vim.api.nvim_buf_set_keymap(0, 'n', '<leader><leader>f', ':CocCommand php-cs-fixer.fix<CR>:w<CR>',
--{ noremap = true })
--end
--})

-- Abbreviations
vim.cmd([[
    iabbr cosnt const
    iabbr imprt import
    iabbr imoprt import
    iabbr funcition function
    iabbr funciton function
    iabbr aciton action
    iabbr udpate update
    iabbr resposne response
]])

vim.api.nvim_create_autocmd({ 'BufWinEnter' }, {
    desc = 'return cursor to where it was last time closing the file',
    pattern = '*',
    command = 'silent! normal! g`"zv',
})

vim.g.php_cs_fixer_config_file = '/Users/youssef/Expensidev/PHP-Libs/.php-cs-fixer.php' -- options: --config
vim.g.php_cs_fixer_allow_risky = 'yes'                                                  -- options: --allow-risky

vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = { "php" },
    callback = function()
        vim.b.autoformat = false
    end,
})

-- disable builtin plugins
local disabled_plugins = {
    "2html_plugin",
    "getscript",
    "getscriptPlugin",
    "gzip",
    "logipat",
    "netrw",
    "netrwPlugin",
    "netrwSettings",
    "netrwFileHandlers",
    "matchit",
    "matchparen",
    "spec",
    "tar",
    "tarPlugin",
    "rrhelper",
    "spellfile_plugin",
    "vimball",
    "vimballPlugin",
    "zip",
    "zipPlugin"
}

for _, plugin in ipairs(disabled_plugins) do
    vim.g['loaded_' .. plugin] = 1
end
