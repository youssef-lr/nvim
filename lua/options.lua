vim.g.mapleader = ' '
vim.g.maplocalleader = ','

-- Enable filetype plugins and indentation
vim.cmd('filetype plugin on')
vim.cmd('filetype plugin indent on')

vim.opt.title = true

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- Make line numbers default
vim.opt.number = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'

vim.opt.smoothscroll = true

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

vim.opt.spelloptions = 'camel'

-- Enable break indent
vim.opt.breakindent = true

-- Hide deprecation warnings
vim.g.deprecation_warnings = false

vim.go.autowrite = true

-- Save undo history
vim.opt.undofile = true

vim.opt.sessionoptions = 'curdir,folds,globals,help,tabpages,terminal,winsize'

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
vim.opt.sidescrolloff = 12

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
vim.opt.history = 3000

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

-- Auto commands for multiple filetypes in a single autocmd
vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' },
    {
        pattern = { '*' },
        callback = function(args)
            local filename = vim.fn.expand('%:t')
            if filename:match('%.js$') or filename:match('%.jsx$') then
                vim.bo.filetype = 'javascriptreact'
            elseif filename:match('%.ts$') or filename:match('%.tsx$') then
                vim.bo.filetype = 'typescriptreact'
            elseif filename:match('%.snippets$') then
                vim.bo.filetype = 'snippets'
            elseif filename:match('%.html$') then
                vim.bo.filetype = 'jsx'
            end

            local is_file = vim.bo[args.buf].buftype == '' and vim.bo[args.buf].filetype ~= 'gitcommit'
            if is_file then
                vim.opt_local.numberwidth = 4
                vim.opt_local.statuscolumn = [[%!v:lua.require'utils'.statuscolumn()]]
            else
                vim.opt_local.numberwidth = 1
                vim.opt_local.statuscolumn = ''
            end
        end
    })

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

-- Set the window title dynamically
vim.opt.title = true
vim.opt.titlestring = '%{v:lua.get_git_root()} %f'

-- Helper function to find the Git root and set title
function _G.set_window_title()
    local git_root = require('utils').get_git_root()
    if git_root ~= '' then
        -- Get the relative file path from Git root
        local relative_path = vim.fn.fnamemodify(vim.fn.expand('%'), ':~:.')
        vim.opt.titlestring = git_root .. ' - ' .. relative_path
    else
        -- Fall back to default file path if not in a Git repository
        vim.opt.titlestring = vim.fn.expand('%:p')
    end
end

-- Call the function to set the window title whenever the file is changed
vim.api.nvim_exec([[
  autocmd BufEnter,BufReadPost * lua set_window_title()
]], false)

local function getPathAndLineNumber(str)
    -- Matches lib/ReportAPI.php' function 'structureTransactionsForOnyx' line '6297'
    local file, line = str:match("^(.-)' function.- line '(%d+)'")
    if file and line and tonumber(line) then
        return file, line
    end

    -- Matches lib/TransactionUtils.php' exceptionLine: '741'
    file, line = str:match("^(.-)' exceptionLine: '(%d+)'")
    if file and line and tonumber(line) then
        return file, line
    end

    if not string.find(str, ':') and not string.find(str, '#L') then
        return nil
    end

    -- Split the argument into the file and line number
    local separator = string.find(str, '#L') and '#L' or ':'
    local args = vim.split(str, separator, true)
    file = args[1]

    if not tonumber(args[2]) then
        return nil
    end

    line = tonumber(args[2])

    return file, line
end


vim.api.nvim_create_user_command('GotoFile', function(opts)
    local filepath, line = getPathAndLineNumber(opts.args)
    local fidget = require('fidget')
    if not filepath or not line then
        fidget.notify('Not a valid line number `' .. opts.args .. '`')
        return
    end

    if filepath and not io.open(filepath, 'r') then
        fidget.notify("File doesn't exist: `" .. filepath .. '`')
        return
    end

    -- Open the file
    vim.cmd('edit ' .. filepath)
    vim.fn.cursor(line, 1)
end, { nargs = 1 })

vim.keymap.set('n', '<leader>gt', ':GotoFile <C-r>*<CR>', { noremap = true, silent = true })

-- Autoread trigger when files are changed on disk
vim.api.nvim_create_autocmd({ 'FocusGained', 'BufEnter', 'CursorHold', 'CursorHoldI' }, {
    callback = function()
        if vim.bo.filetype ~= '' and vim.bo.filetype ~= 'vim' and vim.fn.mode() ~= 'c' then
            vim.cmd('checktime')
        end
    end
})

vim.api.nvim_create_autocmd({ 'BufEnter' }, {
    callback = function(args)
        local highlighter = require 'vim.treesitter.highlighter'
        local ts_was_active = highlighter.active[args.buf]
        local file_size = vim.fn.getfsize(args.file)
        if (file_size > 1024 * 1024) then
            vim.cmd('TSBufDisable highlight')
            vim.cmd('NoMatchParen')
            if (ts_was_active) then
                vim.notify('File larger than 1MB, turned off syntax highlighting')
            end
        end
    end
})

-- disable builtin plugins
local disabled_plugins = {
    '2html_plugin',
    'getscript',
    'getscriptPlugin',
    'gzip',
    'logipat',
    'netrw',
    'netrwPlugin',
    'netrwSettings',
    'netrwFileHandlers',
    'spec',
    'tar',
    'tarPlugin',
    'rrhelper',
    'vimball',
    'vimballPlugin',
    'zip',
    'zipPlugin'
}

for _, plugin in ipairs(disabled_plugins) do
    vim.g['loaded_' .. plugin] = 1
end
