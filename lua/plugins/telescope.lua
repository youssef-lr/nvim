return {
  {
    'nvim-telescope/telescope.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local actions = require('telescope.actions')
      require('telescope').setup {
        defaults = {
          layout_config = {
            prompt_position = 'top',
          },
          sorting_strategy = 'ascending', -- Makes the sorting start from the top
          preview = {
            hide_on_startup = true        -- hide previewer when picker starts
          },
          mappings = {
            i = {
              ['<esc>'] = actions.close,
              ['<C-u>'] = false,
              ['<M-v>'] = actions.file_vsplit,
              ['<M-j>'] = actions.move_selection_next,
              ['<M-k>'] = actions.move_selection_previous,
              ['<M-p>'] = require('telescope.actions.layout').toggle_preview,
            },
          },
          extensions = {
            fzf = {
              fuzzy = true,                   -- false will only do exact matching
              override_generic_sorter = true, -- override the generic sorter
              override_file_sorter = true,    -- override the file sorter
              case_mode = 'smart_case',       -- or "ignore_case" or "respect_case"
              -- the default case_mode is "smart_case"
            }
          }
        }
      }

      -- Files mappings
      local files = '<cmd>Telescope smart_open cwd_only=true filename_first=false<CR>'
      local tfiles = '<C-\\><C-n>:q<CR><cmd>Telescope smart_open cwd_only=true filename_first=false<CR>'
      vim.api.nvim_set_keymap('n', '<D-p>', files, { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<M-p>', files, { noremap = true, silent = true })
      vim.api.nvim_set_keymap('t', '<D-p>', tfiles, { noremap = true, silent = true })
      vim.api.nvim_set_keymap('t', '<M-p>', tfiles, { noremap = true, silent = true })

      -- Oldfiles mappings (recently opened files)
      local oldfiles = '<cmd>Telescope smart_open cwd_only=true filename_first=false<CR>'
      local toldfiles = '<C-\\><C-n>:q<CR><cmd>Telescope smart_open cwd_only=true filename_first=false<CR>'
      vim.api.nvim_set_keymap('n', '<D-r>', oldfiles, { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<M-r>', oldfiles, { noremap = true, silent = true })
      vim.api.nvim_set_keymap('t', '<D-r>', toldfiles, { noremap = true, silent = true })

      -- Git status
      local gstatus = '<cmd>Telescope git_status<CR>'
      local tgstatus = '<C-\\><C-n>:q<CR><cmd>Telescope git_status<CR>'
      vim.api.nvim_set_keymap('n', '<D-g>', gstatus, { noremap = true, silent = true })
      vim.api.nvim_set_keymap('t', '<D-g>', tgstatus, { noremap = true, silent = true })

      -- LSP: Document symbols
      local symbols = '<cmd>Telescope lsp_document_symbols<CR>'
      vim.api.nvim_set_keymap('n', '<D-o>', symbols, { noremap = true })
      vim.api.nvim_set_keymap('n', '<leader>o', symbols, { noremap = true, silent = true })

      -- LSP: Find references
      local references = '<cmd>Telescope lsp_references previewer=true<CR>'
      vim.api.nvim_set_keymap('n', '<leader>u', references, { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<D-u>', references, { noremap = true, silent = true })

      -- LSP: Incoming calls
      local incoming_calls = '<cmd>Telescope lsp_incoming_calls previewer=true<CR>'
      vim.api.nvim_set_keymap('n', '<leader>ic', references, { noremap = true, silent = true })

      -- LSP: Outgoing calls
      local incoming_calls = '<cmd>Telescope lsp_incoming_calls previewer=true<CR>'
      -- vim.api.nvim_set_keymap('n', '<leader>oc', references, { noremap = true, silent = true })

      -- Buffers
      local buffers = '<cmd>Telescope buffers<CR>'
      local tbuffers = '<C-\\><C-n>:q<CR><cmd>Telescope buffers<CR>'
      vim.api.nvim_set_keymap('n', '<D-b>', buffers, { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<M-b>', buffers, { noremap = true, silent = true })
      vim.api.nvim_set_keymap('t', '<M-b>', tbuffers, { noremap = true, silent = true })

      -- Live grep
      vim.api.nvim_set_keymap('n', '<leader>lg', '<cmd>Telescope live_grep previewer=true<CR>',
        { noremap = true, silent = true })

      -- Current buffer diagnostics
      vim.api.nvim_set_keymap('n', '<leader>a', '<cmd>Telescope diagnostics<CR>',
        { noremap = true, silent = true })

      -- Current buffer fuzzy find
      vim.api.nvim_set_keymap('n', '<D-F>', '<cmd>Telescope current_buffer_fuzzy_find<CR>',
        { noremap = true, silent = true })

      -- Git commits
      vim.api.nvim_set_keymap('n', '<leader>gc', '<cmd>Telescope git_commits<CR>', { noremap = true, silent = true })

      -- Command history
      vim.api.nvim_set_keymap('n', '<D-C>', '<cmd>Telescope command_history<CR>', { noremap = true, silent = true })

      -- Grep word under cursor
      vim.api.nvim_set_keymap('n', '<leader>rg', '<cmd>Tel grep_string previewer=true<CR>',
        { noremap = true, silent = true })
      vim.api.nvim_set_keymap('v', '<leader>rg', '<cmd>Tel grep_string previewer=true<CR>',
        { noremap = true, silent = true })
    end,
  },
  {
    'danielfalk/smart-open.nvim',
    branch = '0.2.x',
    config = function()
      require('telescope').load_extension('smart_open')
    end,
    dependencies = {
      'kkharji/sqlite.lua',
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    },
  }
}
