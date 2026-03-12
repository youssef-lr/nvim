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

-- Open zsh aliases file
vim.api.nvim_create_user_command('Aliases', 'edit /Users/youssef/.oh-my-zsh/custom/aliases.zsh', {})

-- Custom save function
local save = function(isInsertMode)
  -- Save find&replace changes if we're inside grug-far
  local filetype = vim.api.nvim_get_option_value('filetype', { scope = 'local' })
  if filetype == 'grug-far' then
    vim.api.nvim_input('<ESC>,s')
    return
  end

  if filetype == 'oil' or filetype == 'harpoo' then
    vim.cmd('silent! w')
    return
  end

  local buftype = vim.api.nvim_get_option_value('buftype', { scope = 'local' })

  if buftype ~= '' then
    vim.notify('read only buffer')
    return
  end

  if isInsertMode then
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, true, true), 'n', true)
  end
  vim.cmd('silent! w')
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('i<Esc>l', true, true, true), 'n', true)

  local filepath = vim.api.nvim_buf_get_name(0)
  if filepath:match('ghostty/config$') then
    local output = vim.fn.system([[~/.config/ghostty/reload_conf.sh]])
    local return_code = vim.v.shell_error
    if return_code ~= 0 then
      print('Return code: ' .. return_code)
      print('Output: ' .. output)
    end
  end
end
map('n', '<C-S>', save, { noremap = true, silent = true })
map('n', '<C-s>', save, { noremap = true, silent = true })
map('i', '<C-S>', function()
  save(true)
end, { noremap = true, silent = true })
map('n', '<D-s>', save, { noremap = true, silent = true })
map('i', '<D-s>', function()
  save(true)
end, { noremap = true, silent = true })
map('n', '<D-S>', ':noa w<CR>', { noremap = true, silent = true })

-- ========================
-- Navigation mappings
-- ========================
-- Window navigation
map('n', '<M-j>', '<C-w>j', { noremap = true })
map('n', '<M-k>', '<C-w>k', { noremap = true })
map('n', '<M-h>', '<C-w>h', { noremap = true })
map('n', '<M-l>', '<C-w>l', { noremap = true })
map('n', '<M-=>', '<C-w>=', { noremap = true })
map('n', '<D-à>', ':cnext<CR>', { noremap = true })
map('n', '<D-ç>', ':cprev<CR>', { noremap = true })

-- Buffer switching
map('n', '<M-w>', '<cmd>b#<CR>', { noremap = true })

-- Alternative navigation using Alt (Meta) key

-- Navigate within files
map('n', '<BS>', '<C-o>', { noremap = true })

-- ========================
-- Clipboard mappings
-- ========================
map({ 'n', 'v' }, '<leader>p', '"*p', { silent = true, noremap = true, desc = 'paste forward from clipboard' })
map({ 'n', 'v' }, '<leader>P', '"*P', { silent = true, noremap = true, desc = 'past backwards from clipboard' })
map({ 'n', 'v' }, '<leader>y', '"*y', { silent = true, noremap = true, desc = 'yank into clipboard' })
map({ 'n', 'v' }, '<D-c>', '"*y', { silent = true, noremap = true })
map('n', '<D-c><D-c>', '"*yy', { silent = true, noremap = true })
map({ 'n', 'v' }, '<D-v>', '"*p', { silent = true, noremap = true })
map('i', '<D-v>', '<C-r>*', { silent = true, noremap = true })
vim.cmd('map! <D-v> <C-r>+')

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
map('n', '<M-v>', '<C-v>', { noremap = true })
map('t', '<M-v>', '<C-v>', { noremap = true })
map('i', '<M-à>', '@', { noremap = true })
map('n', 'dA', 'ggdG', { noremap = true })
map('', '<M-à>', '@', { noremap = true })
map({ 'c', 't' }, '<M-à>', '@', { noremap = true })

-- Custom function to go to path
local function GoToPath()
  local quote_pos = vim.fn.match(vim.fn.getline('.'), '["\']')
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
  end,
})

-- ========================
-- Terminal mode mappings
-- ========================
map('t', 'jk', '<C-\\><C-n>', { noremap = true })

map('t', '<C-j>', '<C-\\><C-n><C-w>j', { noremap = true })

map('t', '<C-k>', '<C-\\><C-n><C-w>k', { noremap = true })

map('t', '<C-h>', '<C-\\><C-n><C-w>h', { noremap = true })
map('t', '<M-h>', '<C-\\><C-n><C-w>h', { noremap = true })

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
-- Quit mappings - Ctrl+Q or Alt+Q
-- ========================
local quit = function()
  local buftype = vim.api.nvim_get_option_value('buftype', { scope = 'local' })
  if buftype == 'terminal' then
    -- Close without '!' to not kill the buffer
    vim.cmd('q')
  else
    -- Otherwise, force quit the buffer
    vim.cmd('q!')
  end
end
map({ 'i', 'n', 'v', 't' }, '<C-Q>', quit, { noremap = true, silent = true })
map({ 'i', 'n', 'v', 't' }, '<M-q>', quit, { noremap = true, silent = true })

-- ========================
-- Diff mappings
-- ========================
map('n', '<leader><leader>dt', ':windo diffthis<CR>', { noremap = true })
map('n', '<leader><leader>do', ':windo diffoff<CR>', { noremap = true })

map('n', '<leader>es', ':edit ./scratch/', { noremap = true })

local function get_git_root()
  -- Execute a shell command to get the Git root directory
  local git_root = vim.fn.systemlist('git rev-parse --show-toplevel')[1]

  -- Check if the git command was successful
  if vim.v.shell_error == 0 then
    return git_root
  else
    return nil
  end
end

local function exec_git_push()
  -- Execute the Git status command
  local handle = io.popen('git status --porcelain')
  local result = handle and handle:read('*a') -- Read the output
  if handle then
    handle:close()
  end

  if result ~= '' then
    vim.notify('changes found, aborting git push')
    return
  end

  local git_root = get_git_root()
  local cmd = 'cd ' .. git_root .. ' && git push'
  local wrapped = '"' .. cmd .. '"'
  vim.cmd('1TermExec cmd=' .. wrapped)
end

local function build_chronos()
  local git_root = get_git_root()
  local cmd = 'cd ' .. git_root .. ' && ./scripts/buildAndRun.sh'
  local wrapped = '"' .. cmd .. '"'
  vim.cmd('1TermExec cmd=' .. wrapped)
end

map('n', '<leader><leader>p', exec_git_push)
map({ 'n', 'i', 't' }, '<D-R>', build_chronos)

-- vim.keymap.set({ 'n', 'v' }, '<D-d>', '*N', { noremap = true })

map('n', '<leader><leader>s', ':source %<CR>', { noremap = true })

map('n', '<D-a>', 'vig', { noremap = true })

vim.keymap.set('n', '<leader><leader>w', function()
  vim.wo.wrap = not vim.wo.wrap
end, { desc = 'Toggle word wrap' })

map('n', '<D-§>', ':restart<CR>')

-- ========================
-- Terminal filepath navigation
-- ========================
local function navigate_to_filepath_under_cursor()
  -- Get the WORD under cursor (like viW)
  local word = vim.fn.expand('<cWORD>')

  -- Match pattern: path/to/file.ext or path/to/file.ext:123 or path/to/file.ext:123-456
  -- Stop before any trailing punctuation like ), ], ,, etc.
  local match = word:match('([%w%./%-_]+%.%w+:?%d*%-?%d*)')

  if not match then
    return
  end

  -- Parse filepath and optional line numbers
  local filepath, line_start, line_end = match:match('^(.+):(%d+)%-?(%d*)$')

  if not filepath then
    -- No line numbers, just filepath
    filepath = match
  end

  -- Get git root
  local git_root = get_git_root()
  if not git_root then
    vim.notify('Not in a git repository', vim.log.levels.ERROR)
    return
  end

  -- Construct absolute path
  local absolute_path = git_root .. '/' .. filepath

  -- Check if file exists
  if vim.fn.filereadable(absolute_path) == 0 then
    vim.notify('File not found: ' .. absolute_path, vim.log.levels.ERROR)
    return
  end

  -- Exit terminal mode, close buffer, and navigate to file
  vim.cmd('normal! \\<C-\\>\\<C-n>')
  vim.cmd('q')
  vim.cmd('edit ' .. vim.fn.fnameescape(absolute_path))

  -- Navigate to line if specified
  if line_start and line_start ~= '' then
    vim.cmd('normal! ' .. line_start .. 'G')
    vim.cmd('normal! zz') -- Center screen on the line
  end
end

-- Map Enter in terminal buffers (normal mode only)
vim.api.nvim_create_autocmd('TermOpen', {
  pattern = '*',
  callback = function()
    map('n', '<CR>', navigate_to_filepath_under_cursor, { buffer = true, silent = true })
  end,
})
