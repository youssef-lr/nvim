-- LSP Plugins
return {
  {
    -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = 'luvit-meta/library', words = { 'vim%.uv' } },
      },
    },
  },
  { 'Bilal2453/luvit-meta', lazy = true },
  {
    -- Main LSP Configuration
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for Neovim
      { 'williamboman/mason.nvim', config = true }, -- NOTE: Must be loaded before dependants
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',

      -- Useful status updates for LSP.
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim',       opts = {} },

      -- Allows extra capabilities provided by nvim-cmp
      'hrsh7th/cmp-nvim-lsp',
    },
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          map('<leader>d', vim.lsp.buf.definition, '[G]oto [D]efinition')
          map('<leader>D', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
          map('<leader>j', vim.diagnostic.goto_next, '')
          map('<leader>k', vim.diagnostic.goto_prev, '')
          map('<C-e>', '<cmd>ClangdSwitchSourceHeader<CR>', '')

          local function formatRange()
            vim.lsp.buf.format()
            vim.api.nvim_input "<Esc>"
          end
          map("f", formatRange, '', 'v');

          local client = vim.lsp.get_client_by_id(event.data.client_id)

          if client then
            client.server_capabilities.semanticTokensProvider = nil

            if client.name == 'intelephense' then
              client.server_capabilities.documentFormattingProvider = nil
              client.server_capabilities.documentOnTypeFormattingProvider = nil
            end

            -- The following code creates a keymap to toggle inlay hints in your
            -- code, if the language server you are using supports them
            --
            -- This may be unwanted, since they displace some of your code
            if client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
              map('<leader>th', function()
                vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
              end, '[T]oggle Inlay [H]ints')
            end
          end

          vim.diagnostic.config({
            virtual_text = false,
            float = {
              show_header = true,
              source = true,
              border = 'rounded',
              focusable = true,
              scope = 'cursor'
            },
            signs = {
              text = {
                [vim.diagnostic.severity.ERROR] = '●', -- or other icon of your choice here, this is just what my config has:
                [vim.diagnostic.severity.WARN] = '●',
                [vim.diagnostic.severity.INFO] = '●',
                [vim.diagnostic.severity.HINT] = '●',
              },
            },
            underline = false,
            update_in_insert = true,
          })
        end,
      })

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())
      local servers = {
        clangd = {
          cmd = {
            'clangd',
            '--background-index',
            '--header-insertion=never',
            '-j=16',
            '--background-index-priority=normal',
            '--limit-references=0',
            '--pch-storage=memory',
          },
        },
        ts_ls = {},
        intelephense = {},
        lua_ls = {
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
            },
          },
        },
      }
      require('mason').setup()

      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        'clangd',
        'intelephense',
        'typescript-language-server',
        'eslint_d',
        'prettierd',
        'lua-language-server',
        'stylua',
        'actionlint',
      })
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      require('mason-lspconfig').setup {
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            -- This handles overriding only values explicitly passed
            -- by the server configuration above. Useful when disabling
            -- certain features of an LSP (for example, turning off formatting for ts_ls)
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }
    end,
  },
}
