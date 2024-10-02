vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

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

vim.opt.spelloptions = "camel"

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

-- Function to get the Git root directory's folder name
local function get_git_root()
    local handle = io.popen("git rev-parse --show-toplevel 2>/dev/null")
    if handle == nil then
        return ""
    end
    local git_root = handle:read("*a")
    handle:close()

    -- Remove trailing newline and extract only the folder name (last part of the path)
    local git_root_name = git_root:gsub("\n", ""):match("([^/]+)$")
    return git_root_name or "" -- Return the folder name or an empty string if not found
end

-- Set the window title dynamically
vim.opt.title = true
vim.opt.titlestring = "%{v:lua.get_git_root()} %f"

-- Helper function to find the Git root and set title
function _G.set_window_title()
    local git_root = get_git_root()
    if git_root ~= "" then
        -- Get the relative file path from Git root
        local relative_path = vim.fn.fnamemodify(vim.fn.expand("%"), ":~:.")
        vim.opt.titlestring = git_root .. " - " .. relative_path
    else
        -- Fall back to default file path if not in a Git repository
        vim.opt.titlestring = vim.fn.expand("%:p")
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

    if not string.find(str, ":") and not string.find(str, "#L") then
        return nil
    end

    -- Split the argument into the file and line number
    local separator = string.find(str, "#L") and "#L" or ":"
    local args = vim.split(str, separator, true)
    file = args[1]

    if not tonumber(args[2]) then
        return nil
    end

    line = tonumber(args[2])

    return file, line
end


vim.api.nvim_create_user_command('GotoFile', function(opts)
    local file, line = getPathAndLineNumber(opts.args)
    if not file or not line then
        local fidget = require("fidget")
        fidget.notify("Not a valid line number")
    end

    -- Open the file
    vim.cmd('edit ' .. file)
    vim.fn.cursor(line, 1)
end, { nargs = 1 })

vim.keymap.set('n', '<leader>gt', ':GotoFile <C-r>*<CR>', { noremap = true, silent = true })


-- Custom function to handle indentation
local function custom_indent()
    -- Get the current line text
    local line = vim.fn.getline(vim.v.lnum)

    -- If the line contains 'report:', don't indent (return 0)
    if string.match(line, "    report:") then
        return 0
    end

    -- Otherwise, use default indentation (return -1)
    return -1
end

-- Set up an autocmd to apply this custom indenting rule for specific file types
vim.api.nvim_create_autocmd("FileType", {
    pattern = "*", -- Apply this to all file types, or specify a file type like "markdown"
    callback = function()
        vim.opt_local.indentexpr = "v:lua.custom_indent()"
    end,
})

-- Register the custom indent function globally in Neovim
_G.custom_indent = custom_indent

vim.api.nvim_create_autocmd("FileType", {
    pattern = "cpp", -- Apply to markdown files only
    callback = function()
        vim.opt_local.indentexpr = "v:lua.custom_indent()"
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
    "spec",
    "tar",
    "tarPlugin",
    "rrhelper",
    "vimball",
    "vimballPlugin",
    "zip",
    "zipPlugin"
}

for _, plugin in ipairs(disabled_plugins) do
    vim.g['loaded_' .. plugin] = 1
end
