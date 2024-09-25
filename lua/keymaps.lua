-- Mappings for scrolling
vim.keymap.set('n', '<C-e>', '5<C-e>', { noremap = true })
vim.keymap.set('n', '<C-y>', '5<C-y>', { noremap = true })

-- Mapping for fold
vim.keymap.set('n', 'zff', 'zfi{', { noremap = true })

-- Function to go to path
local function GoToPath()
    local quote_pos = vim.fn.match(vim.fn.getline('.'), "[\"']")
    if quote_pos > 0 then
        vim.fn.cursor(vim.fn.line('.'), quote_pos + 2)
    end
    vim.cmd('silent! normal! gf')
end

-- Mapping for the function
vim.keymap.set('n', '<Enter>', GoToPath, { silent = true })
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'qf',
    callback = function()
        vim.keymap.set('n', '<Enter>', '<Enter>', { buffer = true })
    end
})

-- General mappings
vim.keymap.set('n', '<leader>w', ':w!<cr>', { silent = true, noremap = true })
vim.keymap.set('n', '<leader>q', 'ZZ', { noremap = true })
vim.keymap.set('n', '<leader><leader>q', ':wqa<cr>', { noremap = true })
vim.keymap.set('v', '<Tab>', '>', { noremap = true })
vim.keymap.set('v', '<S-Tab>', '<', { noremap = true })

vim.keymap.set('n', '<leader><TAB>', '<C-w>w', { noremap = true })
vim.keymap.set('n', '<BS>', '<C-o>', { noremap = true })
vim.keymap.set('n', 'r', ':redo<cr>', { noremap = true })

-- Clipboard mappings
vim.keymap.set('n', '<leader>p', '"*p', { silent = true, noremap = true })
vim.keymap.set('n', '<leader>P', '"*P', { silent = true, noremap = true })
vim.keymap.set('v', '<leader>p', '"*P', { silent = true, noremap = true })
vim.keymap.set('v', '<leader>P', '"*P', { silent = true, noremap = true })

vim.keymap.set('n', '<leader>y', '"*y', { silent = true, noremap = true })
vim.keymap.set('n', '<leader>d', '"*d', { silent = true, noremap = true })
vim.keymap.set('v', '<leader>y', '"*y', { silent = true, noremap = true })
vim.keymap.set('v', '<leader>d', '"*d', { silent = true, noremap = true })

vim.keymap.set('n', '<D-c>', '"*yy', { silent = true, noremap = true })
vim.keymap.set('v', '<D-c>', '"*y', { silent = true, noremap = true })
vim.keymap.set('n', '<D-v>', '"*p', { silent = true, noremap = true })
vim.keymap.set('v', '<D-v>', '"*p', { silent = true, noremap = true })
vim.keymap.set('i', '<D-v>', '<C-r>+', { silent = true, noremap = true })

vim.keymap.set('n', 'Y', 'y$', { noremap = true })
vim.keymap.set('n', '<leader>Y', '"*y$', { noremap = true })

vim.keymap.set('n', '<ESC>', ":noh<CR>:echon ''<ESC>", { silent = true, noremap = true })
vim.keymap.set('n', '<C-S>', ':w<CR>', { noremap = true })
vim.keymap.set('i', '<C-S>', '<Esc>:w<cr>', { noremap = true })
vim.keymap.set('n', '<D-s>', ':w<CR>', { noremap = true })
vim.keymap.set('i', '<D-s>', '<Esc>:w<cr>', { noremap = true })

vim.keymap.set('i', '<D-s>', '<Esc>:w<cr>', { noremap = true })

vim.keymap.set('n', '<leader><CR>', ':noh<cr>', { silent = true })

-- Window navigation
vim.keymap.set('n', '<C-j>', '<C-w>j', { noremap = true })
vim.keymap.set('n', '<C-k>', '<C-w>k', { noremap = true })
vim.keymap.set('n', '<C-h>', '<C-w>h', { noremap = true })
vim.keymap.set('n', '<C-l>', '<C-w>l', { noremap = true })
vim.keymap.set('i', '<C-j>', '<C-w>j', { noremap = true })
vim.keymap.set('i', '<C-k>', '<C-w>k', { noremap = true })
vim.keymap.set('i', '<C-h>', '<C-w>h', { noremap = true })
vim.keymap.set('i', '<C-l>', '<C-w>l', { noremap = true })

-- ALt mappings
vim.keymap.set('n', '<M-j>', '<C-w>j', { noremap = true })
vim.keymap.set('n', '<M-k>', '<C-w>k', { noremap = true })
vim.keymap.set('n', '<M-h>', '<C-w>h', { noremap = true })
vim.keymap.set('n', '<M-l>', '<C-w>l', { noremap = true })
vim.keymap.set('i', '<M-j>', '<C-w>j', { noremap = true })
vim.keymap.set('i', '<M-k>', '<C-w>k', { noremap = true })
vim.keymap.set('i', '<M-h>', '<C-w>h', { noremap = true })
vim.keymap.set('i', '<M-l>', '<C-w>l', { noremap = true })

-- Close all buffers
vim.keymap.set('n', '<leader>ba', ':bufdo bd<cr>', { noremap = true })

-- Miscellaneous mappings
vim.keymap.set('n', '<leader>rc', ':source $MYVIMRC<CR>', { noremap = true })
vim.keymap.set('n', '0', '^', { noremap = true })
vim.keymap.set('n', '!', ':!', { noremap = true })
vim.keymap.set('n', '<leader><leader>s', ':setlocal spell!<cr>', { noremap = true })

-- Other useful shortcuts
vim.keymap.set('n', '<leader>x', ':e ~/buffer.md<cr>', { noremap = true })

-- Save with sudo
vim.api.nvim_create_user_command('W', 'w !sudo tee % > /dev/null', {})

-- Other movement and copy/paste commands
vim.keymap.set('n', '<C-N><C-P>', '^f(lyi( :!npm install <C-R>"', { noremap = true })
vim.keymap.set('n', 'dJ', 'dG', { noremap = true })
vim.keymap.set('n', 'dK', 'dgg', { noremap = true })
vim.keymap.set('n', 'dA', 'ggdG', { noremap = true })

vim.keymap.set('n', 'yJ', 'yG', { noremap = true })
vim.keymap.set('n', 'yK', 'ygg', { noremap = true })
vim.keymap.set('n', 'yA', 'ggyG', { noremap = true })

vim.keymap.set('n', '<leader>yA', 'gg"*yG', { noremap = true })
vim.keymap.set('i', 'jj', '<esc>', { noremap = true })

-- Navigation within files
vim.keymap.set('n', '<Up>', '[c', { noremap = true })
vim.keymap.set('n', '<Down>', ']c', { noremap = true })

-- Macros
vim.keymap.set('n', 'Q', '@q', { noremap = true })
vim.keymap.set('n', 'L', '@l', { noremap = true })
vim.keymap.set('v', 'Q', ':norm @q<cr>', { noremap = true })

-- MacOS keybinds
vim.keymap.set('n', '<D-l>', 'gT', { noremap = true })
vim.keymap.set('n', '<D-h>', 'gt', { noremap = true })

-- PageUp/PageDown
vim.keymap.set('n', '<PageUp>', '20k', { noremap = true })
vim.keymap.set('n', '<PageDown>', '20j', { noremap = true })
vim.keymap.set('n', '<C-PageUp>', '50k', { noremap = true })
vim.keymap.set('n', '<C-PageDown>', '50j', { noremap = true })

-- Resize windows
vim.keymap.set('n', '<Right>', ':vertical res +5<CR>', { noremap = true })
vim.keymap.set('n', '<Left>', ':vertical res -5<CR>', { noremap = true })

-- Quit mappings
vim.keymap.set('i', '<C-Q>', '<Esc>ZZ', { noremap = true })
vim.keymap.set('n', '<C-Q>', 'ZZ', { noremap = true })
vim.keymap.set('t', '<C-Q>', '<C-\\><C-n>ZZ', { noremap = true })
vim.keymap.set('i', '<M-q>', '<Esc>ZZ', { noremap = true })
vim.keymap.set('n', '<M-q>', 'ZZ', { noremap = true })
vim.keymap.set('t', '<M-q>', '<C-\\><C-n>ZZ', { noremap = true })
vim.api.nvim_buf_set_keymap(0, 'n', '<C-q>', ':q<CR>', { noremap = true, silent = true })
vim.api.nvim_buf_set_keymap(0, 'n', '<D-q>', ':q<CR>', { noremap = true, silent = true })

-- Diff this
vim.keymap.set('n', '<leader><leader>dt', ':windo diffthis<CR>', { noremap = true })
vim.keymap.set('n', '<leader><leader>do', ':windo diffoff<CR>', { noremap = true })

-- Miscellaneous mappings
vim.keymap.set('n', "''", "'M", { noremap = true })
vim.keymap.set('n', 'mm', 'mM', { noremap = true })

vim.keymap.set('n', 'd<Space>', 'dt<Space>', { noremap = true })
vim.keymap.set('v', '/', 'y<ESC>/<C-R>"<CR>', { noremap = true })
vim.keymap.set('v', '*', 'y<ESC>/<C-R>"<CR>', { noremap = true })

-- Node and PHP commands
--vim.keymap.set('n', '<leader><leader>n', 'ggvG!node<CR>', { noremap = true })
--vim.keymap.set('n', '<leader><leader>p', 'ggvG!php<CR>', { noremap = true })

-- Terminal mode mappings
vim.api.nvim_set_keymap('t', 'jj', '<C-\\><C-n>', { noremap = true })
vim.api.nvim_set_keymap('t', '<leader><tab>', '<C-\\><C-n><C-w>w', { noremap = true })

vim.api.nvim_set_keymap('t', '<C-k>', '<C-\\><C-n><C-w>k', { noremap = true })
vim.api.nvim_set_keymap('t', '<M-k>', '<C-\\><C-n><C-w>k', { noremap = true })

vim.api.nvim_set_keymap('t', '<C-j>', '<C-\\><C-n><C-w>j', { noremap = true })
vim.api.nvim_set_keymap('t', '<M-j>', '<C-\\><C-n><C-w>j', { noremap = true })

vim.api.nvim_set_keymap('t', '<C-h>', '<C-\\><C-n><C-w>h', { noremap = true })
vim.api.nvim_set_keymap('t', '<M-h>', '<C-\\><C-n><C-w>h', { noremap = true })

vim.api.nvim_set_keymap('t', '<C-l>', '<C-\\><C-n><C-w>l', { noremap = true })
vim.api.nvim_set_keymap('t', '<M-l>', '<C-\\><C-n><C-w>l', { noremap = true })

vim.api.nvim_set_keymap('t', '<C-q>', '<C-\\><C-n>:q<CR>', { noremap = true })
vim.api.nvim_set_keymap('t', '<M-q>', '<C-\\><C-n>:q<CR>', { noremap = true })
