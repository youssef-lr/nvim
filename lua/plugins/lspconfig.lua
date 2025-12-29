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
      { 'williamboman/mason.nvim', config = true }, -- NOTE = Must be loaded before dependants
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      'youssef-lr/lsp-overloads.nvim',

      -- Useful status updates for LSP.
      -- NOTE = `opts = {}` is the same as calling `require('fidget').setup({})`
      {
        'j-hui/fidget.nvim',
        opts = {
          notification = {
            override_vim_notify = false,
            window = {
              normal_hl = 'Type', -- Base highlight group in the notification window
              winblend = 0, -- Background color opacity in the notification window
              border = 'shadow', -- Border around the notification window
              zindex = 45, -- Stacking priority of the notification window
              x_padding = 1, -- Padding from right edge of window boundary
              y_padding = 1, -- Padding from bottom edge of window boundary
              align = 'bottom', -- How to align the notification window
              relative = 'editor', -- What the notification window position is relative to
            },
          },
        },
      },

      -- Allows extra capabilities provided by nvim-cmp
      --'hrsh7th/cmp-nvim-lsp',
    },
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP = ' .. desc })
          end
          local client = vim.lsp.get_client_by_id(event.data.client_id)

          if client and client.server_capabilities.signatureHelpProvider then
            require('lsp-overloads').setup(client, {
              -- UI options are mostly the same as those passed to vim.lsp.util.open_floating_preview
              silent = true,
              floating_window_above_cur_line = true,
              ui = {
                border = 'rounded', -- The border to use for the signature popup window. Accepts same border values as |nvim_open_win()|.
                max_width = 130, -- Maximum signature popup width
                focusable = true, -- Make the popup float focusable
                focus = false, -- If focusable is also true, and this is set to true, navigating through overloads will focus into the popup window (probably not what you want)
                silent = true, -- Prevents noisy notifications (make false to help debug why signature isn't working)
                highlight = {
                  italic = true,
                  bold = true,
                  fg = '#ffffff',
                },
              },
              keymaps = {
                next_signature = '<M-j>',
                previous_signature = '<M-k>',
                next_parameter = '<M-l>',
                previous_parameter = '<M-h>',
              },
              display_automatically = true, -- Uses trigger characters to automatically display the signature overloads when typing a method signature
            })
          end

          --map('<leader>d', vim.lsp.buf.definition, '[G]oto [D]efinition')
          --map('<D-d>', vim.lsp.buf.definition, '[G]oto [D]efinition')
          map('<leader>D', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

          -- Initialize diagnostic mode based on client (php code has lots of warnings)
          local diagnosticMode = 'all'
          local severity = nil

          -- Define diagnostic navigation with dynamic severity
          map('<leader>j', function()
            vim.diagnostic.jump({ count = 1, float = true, severity = severity })
          end, '')

          map('<leader>k', function()
            vim.diagnostic.jump({ count = -1, float = true, severity = severity })
          end, '')

          -- Toggle between warnings+errors and all diagnostics
          local function toggleAllDiagnostics()
            -- Toggle between 'warn' (warnings+errors) and 'all' modes
            if diagnosticMode == 'all' then
              diagnosticMode = 'warn'
              severity = { min = vim.diagnostic.severity.WARN }
            else
              diagnosticMode = 'all'
              severity = nil
            end
            print('Diagnostic mode: ' .. diagnosticMode)
          end
          map('<D-D>', toggleAllDiagnostics, '')

          local function formatRange()
            vim.lsp.buf.format()
            vim.api.nvim_input '<Esc>'
          end
          if client and client.name ~= 'ts_ls' then
            map('f', formatRange, '', 'v')
          end

          if client then
            client.server_capabilities.semanticTokensProvider = nil

            -- Disable auto formatting from intelephense but keep `documentRangeFormattingProvider` (`f` in visual mode to format selected range)
            if client.name == 'intelephense' then
              client.server_capabilities.documentFormattingProvider = nil
              client.server_capabilities.documentOnTypeFormattingProvider = nil
            end

            if client.name == 'phpactor' then
              client.server_capabilities.completionProvider = nil
              client.server_capabilities.documentOnTypeFormattingProvider = nil
              client.server_capabilities.documentFormattingProvider = nil
              client.server_capabilities.renameProvider = nil
              client.server_capabilities.referencesProvider = nil
              client.server_capabilities.hoverProvider = nil
              client.server_capabilities.implementationProvider = nil
              client.server_capabilities.documentSymbolProvider = nil
              client.server_capabilities.signatureHelpProvider = nil
              client.server_capabilities.inlineCompletionProvider = nil
            end

            if client.name == 'ts_ls' then
              client.server_capabilities.documentFormattingProvider = nil
              client.server_capabilities.documentOnTypeFormattingProvider = nil
              client.server_capabilities.documentRangeFormattingProvider = nil
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
              scope = 'cursor',
              max_width = 100,
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

          local orig = vim.lsp.util.open_floating_preview
          function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
            opts = opts or {}
            opts.border = 'rounded'
            return orig(contents, syntax, opts, ...)
          end
        end,
      })

      require('mason').setup({
        ui = {
          border = 'single',
        },
      })

      require('mason-tool-installer').setup {
        ensure_installed = {
          'clangd',
          'intelephense',
          'typescript-language-server',
          'eslint_d',
          'prettierd',
          'lua-language-server',
          'stylua',
          'actionlint',
          'sqlls',
        },
      }

      vim.lsp.config('clangd', {
        cmd = {
          'clangd',
          '--background-index',
          '--header-insertion=never',
          '-j=16',
          '--background-index-priority=normal',
          '--limit-references=0',
          '--pch-storage=memory',
          '--clang-tidy',
        },
      })
      vim.lsp.enable('clangd')

      vim.lsp.config('ts_ls', {
        settings = {
          completions = {
            completeFunctionCalls = true,
          },
          typescript = {
            tsserver = {
              experimental = {
                enableProjectDiagnostics = true,
              },
            },
          },
          javascript = {
            tsserver = {
              experimental = {
                enableProjectDiagnostics = true,
              },
            },
          },
        },
        init_options = {
          maxTsServerMemory = 8192,
          preferences = {
            allowIncompleteCompletions = true,
            completeFunctionCalls = true,
            allowRenameOfImportPath = true,
            allowTextChangesInNewFiles = true,
            displayPartsForJSDoc = true,
            generateReturnInDocTemplate = true,
            includeAutomaticOptionalChainCompletions = true,
            includeCompletionsForImportStatements = true,
            includeCompletionsForModuleExports = true,
            includeCompletionsWithClassMemberSnippets = true,
            includeCompletionsWithInsertText = true,
            includeCompletionsWithSnippetText = true,
            jsxAttributeCompletionStyle = 'auto',
          },
        },
      })

      vim.lsp.config('sourcekit', {
        filetypes = { 'swift', 'objc', 'objcpp' },
      })
      vim.lsp.enable('sourcekit')

      --vim.lsp.enable('ts_ls')

      vim.lsp.config('tsgo', {
        settings = {
          completions = {
            completeFunctionCalls = true,
          },
        },
      })
      vim.lsp.enable('tsgo')

      -- biome
      vim.lsp.config('biome', {
        filetypes = { 'json' },
      })
      vim.lsp.enable('biome')

      -- intelephense
      vim.lsp.config('intelephense', {})
      vim.lsp.enable('intelephense')

      -- phpactor
      -- vim.lsp.config('phpactor', {})
      -- vim.lsp.enable('phpactor')

      -- sqlls
      vim.lsp.config('sqlls', {
        filetypes = { 'sql' },
        root_dir = function(_)
          return vim.loop.cwd()
        end,
        settings = {
          connections = {
            name = 'auth',
            adapter = 'sqlite3',
            filename = '/Users/youssef/Expensidev/data/auth/main.db',
            projectPaths = {
              '/Users/youssef/Expensidev/Web-Expensify/',
              '/Users/youssef/Expensidev/Auth/',
            },
          },
        },
      })
      vim.lsp.enable('sqlls')

      -- lua_ls
      vim.lsp.config('lua_ls', {
        settings = {
          Lua = {
            completion = {
              callSnippet = 'Replace',
            },
            format = {
              enable = true,
              defaultConfig = {
                quote_style = 'single',
                indent_size = 2,
                indent_style = 'space',
              },
            },
          },
        },
      })
      vim.lsp.enable('lua_ls')
    end,
  },
}
