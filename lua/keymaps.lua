local map = vim.keymap.set

-- ========================
-- Scrolling mappings
-- ========================
map('n', '<C-e>', '5<C-e>', { noremap = true })
map('n', '<C-y>', '5<C-y>', { noremap = true })

-- ========================
-- Fold mappings
-- ========================
map('n', 'zff', 'zfi{', { noremap = true })


-- ========================
-- Move lines with <Option+[jk]>
-- ========================
map('v', '<M-j>', ":m '>+1<cr>gv=gv", { desc = 'Move Down' })
map('v', '<M-k>', ":m '<-2<cr>gv=gv", { desc = 'Move Up' })

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
map('n', 'n', "'Nn'[v:searchforward].'zv'", { expr = true, desc = 'Next Search Result' })
map('x', 'n', "'Nn'[v:searchforward]", { expr = true, desc = 'Next Search Result' })
map('o', 'n', "'Nn'[v:searchforward]", { expr = true, desc = 'Next Search Result' })
map('n', 'N', "'nN'[v:searchforward].'zv'", { expr = true, desc = 'Prev Search Result' })
map('x', 'N', "'nN'[v:searchforward]", { expr = true, desc = 'Prev Search Result' })
map('o', 'N', "'nN'[v:searchforward]", { expr = true, desc = 'Prev Search Result' })

-- ========================
-- File operations
-- ========================
map('n', '<leader>w', ':w!<cr>', { silent = true, noremap = true })
map('n', '<leader>q', 'ZZ', { noremap = true })
map('n', '<leader><leader>q', ':wqa<cr>', { noremap = true })
map('n', '<leader>ba', ':bufdo bd<cr>', { noremap = true })
map('n', '<leader>rc', ':source $MYVIMRC<CR>', { noremap = true })

-- Save with sudo
vim.api.nvim_create_user_command('W', 'w !sudo tee % > /dev/null', {})

-- Custom save function
local save = function(isInsertMode)
    local buftype = vim.api.nvim_get_option_value('buftype', { scope = 'local' })
    if buftype ~= '' then
        vim.notify('read only buffer')
        return
    end
    if isInsertMode then
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, true, true), 'n', true)
    end
    vim.cmd('w')
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('i<Esc>l', true, true, true), 'n', true)
end
map('n', '<C-S>', save, { noremap = true })
map('i', '<C-S>', function() save(true) end, { noremap = true })
map('n', '<D-s>', save, { noremap = true })
map('i', '<D-s>', function() save(true) end, { noremap = true })

-- ========================
-- Navigation mappings
-- ========================
-- Window navigation
map('n', '<C-j>', '<C-w>j', { noremap = true })
map('n', '<C-k>', '<C-w>k', { noremap = true })
map('n', '<C-h>', '<C-w>h', { noremap = true })
map('n', '<C-l>', '<C-w>l', { noremap = true })
map('n', '<leader>cn', ':cnext<CR>', { noremap = true })
map('n', '<leader>cp', ':cprev<CR>', { noremap = true })
map('n', '<D-ù>', ':cnext<CR>', { noremap = true })
map('n', '<leader>cp', ':cprev<CR>', { noremap = true })

-- Buffer switching
map('n', '<S-Tab>', '<cmd>b#<CR>', { noremap = true })

-- Alternative navigation using Alt (Meta) key
map('n', '<M-j>', '<C-w>j', { noremap = true })
map('n', '<M-k>', '<C-w>k', { noremap = true })
map('n', '<M-h>', '<C-w>h', { noremap = true })
map('n', '<M-l>', '<C-w>l', { noremap = true })

-- Navigate within files
map('n', '<BS>', '<C-o>', { noremap = true })

-- ========================
-- Clipboard mappings
-- ========================
map('n', '<leader>p', '"*p', { silent = true, noremap = true })
map('n', '<leader>P', '"*P', { silent = true, noremap = true })
map('v', '<leader>p', '"*P', { silent = true, noremap = true })
map('v', '<leader>P', '"*P', { silent = true, noremap = true })
map('n', '<leader>y', '"*y', { silent = true, noremap = true })
map('n', '<leader>d', '"*d', { silent = true, noremap = true })
map('v', '<leader>y', '"*y', { silent = true, noremap = true })
map('v', '<leader>d', '"*d', { silent = true, noremap = true })
map('n', '<D-c>', '"*y', { silent = true, noremap = true })
map('n', '<D-c><D-c>', '"*yy', { silent = true, noremap = true })
map('v', '<D-c>', '"*y', { silent = true, noremap = true })
map('n', '<D-v>', '"*p', { silent = true, noremap = true })
map('v', '<D-v>', '"*p', { silent = true, noremap = true })
vim.cmd('map! <D-v> <C-r>+')
map('i', '<D-v>', '<Esc>"*pi', { silent = true, noremap = true })

-- Paste in terminal mode from clipboard
local function pasteFromClipboard()
    local clipboard_content = vim.fn.getreg('+')
    vim.api.nvim_put({ clipboard_content }, 'l', true, true)
end
map('t', '<D-v>', pasteFromClipboard, { silent = true, noremap = true })

-- ========================
-- Text editing
-- ========================
map('v', '<Tab>', '>', { noremap = true })
map('v', '<S-Tab>', '<', { noremap = true })
map('n', 'r', ':redo<cr>', { noremap = true })
map('n', 'Y', 'y$', { noremap = true })
map('n', '<leader>Y', '"*y$', { noremap = true })
map('n', 'd<Space>', 'dt<Space>', { noremap = true })
map('v', '/', 'y<ESC>/<C-R>"<CR>', { noremap = true })
map('v', '*', 'y<ESC>/<C-R>"<CR>', { noremap = true })

-- ========================
-- Miscellaneous mappings
-- ========================
map('n', '<leader><CR>', ':noh<cr>', { silent = true })
map('n', '<ESC>', ":noh<CR>:echon ''<ESC>", { silent = true, noremap = true })
map('n', '<leader><leader>s', ':setlocal spell!<cr>', { noremap = true })
map('n', '<leader>x', ':e ~/buffer.md<cr>', { noremap = true })
map('n', '<M-v>', '<C-v>', { noremap = true })
map('t', '<M-v>', '<C-v>', { noremap = true })
map('i', '<M-à>', '@', { noremap = true })
map('n', 'dA', 'ggdG', { noremap = true })
map('', '<M-à>', '@', { noremap = true })
map({ 'c', 't' }, '<M-à>', '@', { noremap = true })

-- Custom function to go to path
local function GoToPath()
    local quote_pos = vim.fn.match(vim.fn.getline('.'), "[\"']")
    if quote_pos > 0 then
        vim.fn.cursor(vim.fn.line('.'), quote_pos + 2)
    end
    vim.cmd('silent! normal! gf')
end
map('n', '<Enter>', GoToPath, { silent = true })

-- Autocommand for specific filetype
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'qf',
    callback = function()
        map('n', '<Enter>', '<Enter>', { buffer = true })
    end
})

-- ========================
-- Terminal mode mappings
-- ========================
map('t', 'jj', '<C-\\><C-n>', { noremap = true })

map('t', '<C-j>', '<C-\\><C-n><C-w>j', { noremap = true })

map('t', '<C-k>', '<C-\\><C-n><C-w>k', { noremap = true })

map('t', '<C-h>', '<C-\\><C-n><C-w>h', { noremap = true })

map('t', '<C-l>', '<C-\\><C-n><C-w>l', { noremap = true })
map('t', '<M-r>', '<C-r>', { noremap = true, silent = true })

map('t', '<M-j>', '<Down>', { noremap = true, silent = true })
map('t', '<M-k>', '<Up>', { noremap = true, silent = true })
map('i', '<D-j>', '<Down>', { noremap = true, silent = true })
map('i', '<D-k>', '<Up>', { noremap = true, silent = true })

-- ========================
-- Macros
-- ========================
map('n', 'Q', '@q', { noremap = true })
map('n', 'L', '@l', { noremap = true })
map('v', 'Q', ':norm @q<cr>', { noremap = true })

-- ========================
-- Page movements
-- ========================
map('n', '<PageUp>', '20k', { noremap = true })
map('n', '<PageDown>', '20j', { noremap = true })
map('n', '<C-PageUp>', '50k', { noremap = true })
map('n', '<C-PageDown>', '50j', { noremap = true })

-- ========================
-- Window resize
-- ========================
map('n', '<Right>', ':vertical res +5<CR>', { noremap = true })
map('n', '<Left>', ':vertical res -5<CR>', { noremap = true })

-- ========================
-- MacOS-specific mappings
-- ========================
map('n', '<D-l>', 'gT', { noremap = true })
map('n', '<D-h>', 'gt', { noremap = true })

-- ========================
-- Quit mappings
-- ========================
map('i', '<C-Q>', '<Esc>ZZ', { noremap = true })
map('n', '<C-Q>', 'ZZ', { noremap = true })
map('t', '<C-Q>', '<C-\\><C-n>ZZ', { noremap = true })
map('i', '<M-q>', '<Esc>ZZ', { noremap = true })
map('n', '<M-q>', 'ZZ', { noremap = true })
map('t', '<M-q>', '<C-\\><C-n>ZZ', { noremap = true })
vim.api.nvim_buf_set_keymap(0, 'n', '<C-q>', ':q<CR>', { noremap = true, silent = true })
vim.api.nvim_buf_set_keymap(0, 'n', '<D-q>', ':q<CR>', { noremap = true, silent = true })

-- ========================
-- Diff mappings
-- ========================
map('n', '<leader><leader>dt', ':windo diffthis<CR>', { noremap = true })
map('n', '<leader><leader>do', ':windo diffoff<CR>', { noremap = true })

map('n', '<leader>es', ':edit ./scratch/', { noremap = true });

local function get_git_root()
    -- Execute a shell command to get the Git root directory
    local git_root = vim.fn.systemlist('git rev-parse --show-toplevel')[1]
    print(git_root)

    -- Check if the git command was successful
    if vim.v.shell_error == 0 then
        return git_root
    else
        print('nothing found')
        return nil
    end
end

local function exec_git_push()
    -- Execute the Git status command
    local handle = io.popen('git status --porcelain')
    local result = handle and handle:read('*a') -- Read the output
    if handle then handle:close() end

    if result ~= '' then
        vim.notify('changes found, aborting git push')
        return
    end

    local git_root = get_git_root()
    local cmd = 'cd ' .. git_root .. ' && git push'
    local wrapped = '"' .. cmd .. '"'
    vim.cmd('1TermExec cmd=' .. wrapped)
end
map('n', '<leader><leader>p', exec_git_push)
