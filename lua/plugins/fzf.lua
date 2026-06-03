return {
  'ibhagwan/fzf-lua',
  -- optional for icon support
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    local actions = require('fzf-lua').actions

    -- calling `setup` is optional for customization
    require('fzf-lua').setup({
      previewers = {
        builtin = {
          treesitter = { enable = true },
        },
      },
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
      buffers = {
        prompt = 'Buffers❯ ',
        file_icons = true, -- show file icons (true|"devicons"|"mini")?
        color_icons = true, -- colorize file|git icons
        sort_lastused = true, -- sort buffers() by last used
        show_unloaded = true, -- show unloaded buffers
        cwd_only = false, -- buffers for the cwd only
        cwd = nil, -- buffers list for a given dir
        actions = {
          -- actions inherit from 'actions.files' and merge
          -- by supplying a table of functions we're telling
          -- fzf-lua to not close the fzf window, this way we
          -- can resume the buffers picker on the same window
          -- eliminating an otherwise unaesthetic win "flash"
          ['alt-w'] = { fn = actions.buf_del, reload = true },
        },
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

    local expensidev_cmd =
      [[sh -c '{ rg --files --hidden --glob "!.git"; for d in Auth/ Web-Expensify/ App/; do [ -d "${d}.git" ] && (cd "$d" && rg --files --hidden --glob "!.git" | sed "s|^|${d}|"); done; } 2>/dev/null']]
    local open_files = function()
      local opts = {}
      if vim.fn.getcwd() == vim.fn.expand('~/Expensidev') then
        opts.cmd = expensidev_cmd
      end
      require('fzf-lua').files(opts)
    end
    local tfiles = '<C-\\><C-n>:q<CR><cmd>FzfLua files<CR>'
    vim.keymap.set('n', '<D-p>', open_files, { noremap = true, silent = true })
    vim.keymap.set('n', '<M-p>', open_files, { noremap = true, silent = true })
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
    local expensidev_search_paths = { '.', 'Auth/', 'Web-Expensify/', 'App/' }
    local open_grep = function()
      local opts = {}
      if vim.fn.getcwd() == vim.fn.expand('~/Expensidev') then
        opts.search_paths = expensidev_search_paths
      end
      require('fzf-lua').grep(opts)
    end
    local tgrep = '<C-\\><C-n>:q<CR><cmd>FzfLua grep<CR>'
    vim.keymap.set('n', '<M-f>', open_grep, { noremap = true, silent = true })
    vim.keymap.set('n', '<D-f>', open_grep, { noremap = true, silent = true })
    vim.api.nvim_set_keymap('t', '<M-f>', tgrep, { noremap = true, silent = true })
    vim.api.nvim_set_keymap('t', '<D-f>', tgrep, { noremap = true, silent = true })

    -- Live grep
    vim.api.nvim_set_keymap('n', '<leader>lg', '<cmd>FzfLua live_grep<CR>', { noremap = true, silent = true })
    vim.api.nvim_set_keymap('n', '<leader>gg', '<cmd>FzfLua live_grep_glob<CR>', { noremap = true, silent = true })

    -- Current buffer diagnostics
    vim.api.nvim_set_keymap('n', '<leader>a', '<cmd>FzfLua diagnostics_document<CR>', { noremap = true, silent = true })

    -- Grep word under cursor (by selecting it visually first, to preserve highlight in fzf's preview)
    local open_grep_visual = function()
      local opts = {}
      if vim.fn.getcwd() == vim.fn.expand('~/Expensidev') then
        opts.search_paths = expensidev_search_paths
      end
      require('fzf-lua').grep_visual(opts)
    end
    vim.keymap.set('n', '<leader>rg', function()
      vim.cmd('normal! viw')
      open_grep_visual()
    end, { noremap = true, silent = true })

    -- Grep visual selection
    vim.keymap.set('v', '<leader>rg', open_grep_visual, { noremap = true, silent = true })

    vim.api.nvim_set_keymap('n', '<leader>gl', '<cmd>FzfLua grep_last<CR>', { noremap = true, silent = true })

    -- Git commits
    vim.api.nvim_set_keymap('n', '<leader>gc', '<cmd>FzfLua git_commits<CR>', { noremap = true, silent = true })

    -- Git worktrees: pick one and :cd into it
    local function worktree_select()
      local lines = vim.fn.systemlist({ 'git', 'worktree', 'list' })
      if vim.v.shell_error ~= 0 then
        vim.notify('Not a git repository', vim.log.levels.ERROR)
        return
      end
      local home = vim.fn.expand('~')
      local entries, by_label = {}, {}
      for _, line in ipairs(lines) do
        local path, _, branch = line:match('^(%S+)%s+(%x+)%s+%[(.-)%]')
        path = path or line:match('^(%S+)')
        if path then
          local label = path:gsub('^' .. vim.pesc(home), '~')
          if branch then
            label = label .. '  [' .. branch .. ']'
          end
          table.insert(entries, label)
          by_label[label] = path
        end
      end
      require('fzf-lua').fzf_exec(entries, {
        prompt = 'Worktrees❯ ',
        previewer = false,
        winopts = { preview = { hidden = 'hidden' } },
        actions = {
          ['default'] = function(selected)
            local path = selected and selected[1] and by_label[selected[1]]
            if path then
              -- Restores this worktree's last-open buffer (and cd's in).
              require('restore-buffer').switch_dir(path)
              -- Reattach LSP against the new worktree root.
              vim.cmd('silent! lsp restart')
              vim.notify('cwd → ' .. path, vim.log.levels.INFO)
            end
          end,
        },
      })
    end
    vim.api.nvim_create_user_command('Worktrees', worktree_select, { desc = 'Select a git worktree and cd into it' })
    vim.keymap.set('n', '<leader>w', worktree_select, { noremap = true, silent = true, desc = 'Worktree selector' })

    -- Command history
    --vim.api.nvim_set_keymap('n', '<D-C>', '<cmd>FzfLua command_history<CR>', { noremap = true, silent = true })
  end,
}
