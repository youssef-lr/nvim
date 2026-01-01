return {
  'ibhagwan/fzf-lua',
  -- optional for icon support
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    -- calling `setup` is optional for customization
    require('fzf-lua').setup({
      oldfiles = {
        prompt = 'History❯ ',
        cwd_only = true,
        stat_file = true, -- verify files exist on disk
        -- can also be a lua function, for example:
        -- stat_file = require("fzf-lua").utils.file_is_readable,
        -- stat_file = function() return true end,
        include_current_session = true, -- include bufs from current session
      },
      fzf_colors = {
        ['gutter'] = { 'bg', 'Normal' },
        ['fg'] = { 'fg', 'CursorLine' },
        ['bg'] = { 'bg', 'Normal' },
        ['hl'] = { 'fg', 'Comment' },
        ['fg+'] = { 'fg', 'String' },
        ['bg+'] = { 'bg', 'CursorLine' },
        ['hl+'] = { 'fg', 'Statement' },
        ['info'] = { 'fg', 'PreProc' },
        ['prompt'] = { 'fg', 'Conditional' },
        ['pointer'] = { 'fg', 'String' },
        ['marker'] = { 'fg', 'Keyword' },
        ['spinner'] = { 'fg', 'Label' },
        ['header'] = { 'fg', 'Comment' },
      },
    })

    -- FZF settings
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'fzf',
      callback = function()
        vim.opt_local.conceallevel = 0
      end,
    })

    vim.api.nvim_set_keymap('n', '<D-F>', '<cmd>FzfLua grep_curbuf<CR>', { noremap = true, silent = true })

    local files = '<cmd>FzfLua files<CR>'
    local tfiles = '<C-\\><C-n>:q<CR><cmd>FzfLua files<CR>'
    vim.api.nvim_set_keymap('n', '<D-p>', files, { noremap = true, silent = true })
    vim.api.nvim_set_keymap('n', '<M-p>', files, { noremap = true, silent = true })
    vim.api.nvim_set_keymap('t', '<D-p>', tfiles, { noremap = true, silent = true })
    vim.api.nvim_set_keymap('t', '<M-p>', tfiles, { noremap = true, silent = true })

    -- Oldfiles mappings (recently opened files)
    local oldfiles = '<cmd>FzfLua oldfiles<CR>'
    local toldfiles = '<C-\\><C-n>:q<CR><cmd>FzfLua oldfiles<CR>'
    vim.api.nvim_set_keymap('n', '<D-r>', oldfiles, { noremap = true, silent = true })
    vim.api.nvim_set_keymap('n', '<M-r>', oldfiles, { noremap = true, silent = true })
    vim.api.nvim_set_keymap('t', '<D-r>', toldfiles, { noremap = true, silent = true })

    -- -- Git status
    local gstatus = '<cmd>FzfLua git_status<CR>'
    local tgstatus = '<C-\\><C-n>:q<CR><cmd>FzfLua git_status<CR>'
    vim.api.nvim_set_keymap('n', '<D-g>', gstatus, { noremap = true, silent = true })
    vim.api.nvim_set_keymap('t', '<D-g>', tgstatus, { noremap = true, silent = true })

    -- Document symbols
    local symbols = '<cmd>FzfLua lsp_document_symbols<CR>'
    vim.api.nvim_set_keymap('n', '<D-o>', symbols, { noremap = true })
    vim.api.nvim_set_keymap('n', '<leader>o', symbols, { noremap = true, silent = true })

    -- Go to definition (useful if many definitons are found)
    vim.api.nvim_set_keymap('n', '<leader>d', '<cmd>FzfLua lsp_definitions<CR>', { noremap = true })

    -- Find references / usages
    local references = '<cmd>FzfLua lsp_references<CR>'
    vim.api.nvim_set_keymap('n', '<leader>u', references, { noremap = true, silent = true })
    vim.api.nvim_set_keymap('n', '<D-u>', references, { noremap = true, silent = true })

    -- Find incoming calls (where a function is being used - will not show lines where it's being imported/exported)
    local incoming_calls = '<cmd>FzfLua lsp_incoming_calls<CR>'
    vim.api.nvim_set_keymap('n', '<leader>i', incoming_calls, { noremap = true, silent = true })
    vim.api.nvim_set_keymap('n', '<D-i>', incoming_calls, { noremap = true, silent = true })

    -- Buffers
    local buffers = '<cmd>FzfLua buffers<CR>'
    local tbuffers = '<C-\\><C-n>:q<CR><cmd>FzfLua buffers<CR>'
    vim.api.nvim_set_keymap('n', '<D-b>', buffers, { noremap = true, silent = true })
    vim.api.nvim_set_keymap('n', '<M-b>', buffers, { noremap = true, silent = true })
    vim.api.nvim_set_keymap('t', '<M-b>', tbuffers, { noremap = true, silent = true })

    -- Grep
    local grep = '<cmd>FzfLua grep<CR>'
    local tgrep = '<C-\\><C-n>:q<CR><cmd>FzfLua grep<CR>'
    vim.api.nvim_set_keymap('n', '<M-f>', grep, { noremap = true, silent = true })
    vim.api.nvim_set_keymap('n', '<D-f>', grep, { noremap = true, silent = true })
    vim.api.nvim_set_keymap('t', '<M-f>', tgrep, { noremap = true, silent = true })
    vim.api.nvim_set_keymap('t', '<D-f>', tgrep, { noremap = true, silent = true })

    -- Live grep
    vim.api.nvim_set_keymap('n', '<leader>lg', '<cmd>FzfLua live_grep<CR>', { noremap = true, silent = true })
    vim.api.nvim_set_keymap('n', '<leader>gg', '<cmd>FzfLua live_grep_glob<CR>', { noremap = true, silent = true })

    -- Current buffer diagnostics
    vim.api.nvim_set_keymap('n', '<leader>a', '<cmd>FzfLua diagnostics_document<CR>', { noremap = true, silent = true })

    -- Grep word under cursor
    vim.api.nvim_set_keymap('n', '<leader>rg', '<cmd>FzfLua grep_cword<CR>', { noremap = true, silent = true })

    -- Grep visual selection
    vim.api.nvim_set_keymap('v', '<leader>rg', '<cmd>FzfLua grep_visual<CR>', { noremap = true, silent = true })

    -- Git commits
    vim.api.nvim_set_keymap('n', '<leader>gc', '<cmd>FzfLua git_commits<CR>', { noremap = true, silent = true })

    -- Command history
    --vim.api.nvim_set_keymap('n', '<D-C>', '<cmd>FzfLua command_history<CR>', { noremap = true, silent = true })
  end,
}
