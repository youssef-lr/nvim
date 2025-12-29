return {
  'saghen/blink.cmp',
  dependencies = {
    {
      'L3MON4D3/LuaSnip',
      version = 'v2.*',
      config = function()
        require('luasnip').config.setup({})
        require('luasnip.loaders.from_snipmate').lazy_load({ paths = '~/.config/nvim/snippets' })
      end,
    },
  },

  -- use a release tag to download pre-built binaries
  version = '1.*',
  -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
  -- build = 'cargo build --release',
  -- If you use nix, you can build from source using latest nightly rust with:
  -- build = 'nix run .#build-plugin',

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
    -- 'super-tab' for mappings similar to vscode (tab to accept)
    -- 'enter' for enter to accept
    -- 'none' for no mappings
    --
    -- All presets have the following mappings:
    -- C-space: Open menu or open docs if already open
    -- C-n/C-p or Up/Down: Select next/previous item
    -- C-e: Hide menu
    -- C-k: Toggle signature help (if signature.enabled = true)

    snippets = { preset = 'luasnip' },

    -- See :h blink-cmp-config-keymap for defining your own keymap
    keymap = {
      preset = 'super-tab',

      ['<Up>'] = { 'select_prev', 'fallback' },
      ['<Down>'] = { 'select_next', 'fallback' },

      -- show with a list of providers
      ['<C-space>'] = {
        function(cmp)
          cmp.show({ providers = { 'snippets' } })
        end,
      },
    },

    appearance = {
      -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- Adjusts spacing to ensure icons are aligned
      nerd_font_variant = 'mono',
      kind_icons = {
        Text = '󰉿',
        Method = '󰆧',
        Function = '󰊕',
        Constructor = '',
        Field = '󰜢',
        Variable = '󰀫',
        Class = '󰠱',
        Interface = '',
        Module = '',
        Property = '󰜢',
        Unit = '󰑭',
        Value = '󰎠',
        Enum = '',
        Keyword = '󰌋',
        Snippet = '',
        Color = '󰏘',
        File = '󰈙',
        Reference = '󰈇',
        Folder = '󰉋',
        EnumMember = '',
        Constant = '󰏿',
        Struct = '󰙅',
        Event = '',
        Operator = '󰆕',
        TypeParameter = '󰅲',
      },
    },

    -- (Default) Only show the documentation popup when manually triggered
    completion = {
      documentation = {
        auto_show = false,
        window = {
          border = 'rounded',
        },
      },
      menu = {
        border = 'rounded',
        draw = {
          columns = { { 'kind_icon' }, { 'label', 'label_description', gap = 0 }, { 'kind' } },
        },
      },
    },

    -- signature = { enabled = true, window = { border = 'rounded'} },

    -- Default list of enabled providers defined so that you can extend it
    -- elsewhere in your config, without redefining it, due to `opts_extend`
    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer' },
      providers = {
        lsp = {
          transform_items = function(_, items)
            if #items == 0 then
              return items
            end

            -- Check if this is from clangd (all items come from the same client)
            local is_clangd = false
            if items[1].client_id then
              local client = vim.lsp.get_client_by_id(items[1].client_id)
              is_clangd = client ~= nil and client.name == 'clangd'
            end

            -- Process items
            for _, item in ipairs(items) do
              if item.label then
                -- Clangd: strip leading whitespace
                if is_clangd then
                  item.label = item.label:gsub('^%s+', '')
                end

                -- All LSPs: add ~ if has label_description
                if item.labelDetails and item.labelDetails.description and item.labelDetails.description ~= '' then
                  item.label = item.label .. '~'
                end
              end
            end
            return items
          end,
        },
        buffer = {
          opts = {
            get_bufnrs = function()
              -- Return all listed buffers for completion
              return vim.api.nvim_list_bufs()
            end,
          },
        },
      },
    },

    -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
    -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
    -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
    --
    -- See the fuzzy documentation for more information
    fuzzy = { implementation = 'prefer_rust_with_warning' },
  },
  opts_extend = { 'sources.default' },
}
