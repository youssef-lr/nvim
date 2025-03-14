return {
  { -- Autocompletion
    'iguanacucumber/magazine.nvim',
    event = 'InsertEnter',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      {
        'L3MON4D3/LuaSnip',
        build = (function()
          -- Build Step is needed for regex support in snippets.
          -- This step is not supported in many windows environments.
          -- Remove the below condition to re-enable on windows.
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
        dependencies = {
          -- `friendly-snippets` contains a variety of premade snippets.
          --    See the README about individual language/framework/plugin snippets:
          --    https://github.com/rafamadriz/friendly-snippets
          -- {
          --   'rafamadriz/friendly-snippets',
          --   config = function()
          --     require('luasnip.loaders.from_vscode').lazy_load()
          --   end,
          -- },
        },
      },
      'saadparwaiz1/cmp_luasnip',

      -- Adds other completion capabilities.
      --  nvim-cmp does not ship with all sources by default. They are split
      --  into multiple repos for maintenance purposes.
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-nvim-lsp-signature-help',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-nvim-lua',
      'hrsh7th/cmp-cmdline',
    },
    config = function()
      -- See `:help cmp`
      local cmp = require 'cmp'
      local types = require('cmp.types')
      local compare = require('cmp.config.compare')
      local luasnip = require 'luasnip'
      luasnip.config.setup {}

      local goToNextLocation = function()
        if luasnip.expand_or_locally_jumpable() then
          luasnip.expand_or_jump()
          return true
        end

        return false
      end

      local goToPreviousLocation = function()
        if luasnip.locally_jumpable(-1) then
          luasnip.jump(-1)
        end
      end

      ---@type table<integer, integer>
      local modified_priority = {
        [types.lsp.CompletionItemKind.Snippet] = 0,       -- top
        [types.lsp.CompletionItemKind.Variable] = 1,
        [types.lsp.CompletionItemKind.Keyword] = 2,       -- top
        [types.lsp.CompletionItemKind.Class] = 3,         -- top
        [types.lsp.CompletionItemKind.Enum] = 4,          -- top
        [types.lsp.CompletionItemKind.Interface] = 20,    -- bottom
        [types.lsp.CompletionItemKind.Text] = 50,         -- bottom
        [types.lsp.CompletionItemKind.Constructor] = 100, -- bottom
      }

      ---@param kind integer: kind of completion entry
      local function modified_kind(kind)
        return modified_priority[kind] or kind
      end

      local kind_icons = {
        Text = '',
        Method = '󰆧',
        Function = '󰊕',
        Constructor = '',
        Field = '󰇽',
        Variable = '󰂡',
        Class = '󰠱',
        Interface = '',
        Module = '',
        Property = '󰜢',
        Unit = '',
        Value = '󰎠',
        Enum = '',
        Keyword = '󰌋',
        Snippet = '',
        Color = '󰏘',
        File = '󰈙',
        Reference = '',
        Folder = '󰉋',
        EnumMember = '',
        Constant = '󰏿',
        Struct = '',
        Event = '',
        Operator = '󰆕',
        TypeParameter = '󰅲',
      }

      local function handleTab()
        local mode = vim.api.nvim_get_mode().mode

        if mode == 's' or not cmp.visible() then
          if goToNextLocation() then
            return
          end

          if mode == 'i' then
            local spaces = string.rep(' ', vim.o.tabstop)
            vim.api.nvim_put({ spaces }, 'c', false, true)
            return
          end
        end

        if cmp.visible() then
          cmp.confirm({ select = true })
        end
      end

      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        performance = {
          async_budget = 200,
          confirm_resolve_timeout = 0,
          max_view_entries = 100,
          debounce = 10,
          throttle = 0,
          fetching_timeout = 100
        },
        completion = { completeopt = 'menu,menuone,noinsert' },

        -- For an understanding of why these mappings were
        -- chosen, you will need to read `:help ins-completion`
        --
        -- No, but seriously. Please read `:help ins-completion`, it is really good!
        mapping = cmp.mapping.preset.insert {
          ['<M-j>'] = cmp.mapping.select_next_item(),
          ['<M-k>'] = cmp.mapping.select_prev_item(),

          -- Scroll the documentation window [b]ack / [f]orward
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),

          ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),

          ['<Tab>'] = cmp.mapping(handleTab, { 'i', 's' }),

          ['<M-l>'] = cmp.mapping(goToNextLocation, { 'i', 's' }),
          ['<M-h>'] = cmp.mapping(goToPreviousLocation, { 'i', 's' }),

          -- https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
        },
        sources = {
          {
            name = 'lazydev',
            -- set group index to 0 to skip loading LuaLS completions as lazydev recommends it
            group_index = 0,
          },
          {
            name = 'nvim_lsp',
          },
          {
            name = 'luasnip',
            entry_filter = function()
              local ctx = require 'cmp.config.context'
              local in_string = ctx.in_syntax_group 'String' or ctx.in_treesitter_capture 'string'
              local in_comment = ctx.in_syntax_group 'Comment' or ctx.in_treesitter_capture 'comment'

              return not in_string and not in_comment
            end,
          },
          { name = 'path' },
          {
            name = 'buffer',
            option = {
              get_bufnrs = function()
                return vim.api.nvim_list_bufs()
              end
            }
          },
          { name = 'nvim_lua' },
        },
        window = {
          documentation = {
            border = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' },
          },
          completion = {
            border = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' },
            winhighlight = 'Normal:CmpPmenu,FloatBorder:CmpPmenuBorder,CursorLine:PmenuSel,Search:None',
          }
        },
        sorting = {
          priority_weight = 2,
          comparators = {
            compare.offset,
            compare.exact,
            -- compare.scopes,
            compare.score,
            compare.recently_used,
            compare.locality,
            function(entry1, entry2) -- sort by compare kind (Variable, Function etc)
              local kind1 = modified_kind(entry1:get_kind())
              local kind2 = modified_kind(entry2:get_kind())
              if kind1 ~= kind2 then
                return kind1 - kind2 < 0
              end
            end,
            -- compare.sort_text,
            compare.length,
            compare.order,
          },
        },
        formatting = {
          format = function(_, vim_item)
            -- Kind icons
            vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatenates the icons with the name of the item kind

            -- Clangd completion has some extra whitespace in the beginning of the word, delete it
            vim_item.abbr = vim_item.abbr:gsub('^%s+', '')

            -- If the function signature is longer than maxLength characters, truncate it
            -- eg: (Sqlite& db, int64_t reportID, ...)
            local maxLength = 120
            if vim_item.menu and #vim_item.menu > maxLength then
              vim_item.menu = string.sub(vim_item.menu, 1, maxLength) .. '...)'
            end

            return vim_item
          end
        },
      }
      local ls = require('luasnip')

      vim.keymap.set({ 'i' }, '<C-K>', function() ls.expand() end, { silent = true })
      vim.keymap.set({ 'i' }, '<M-k>', function() ls.expand() end, { silent = true })
      vim.keymap.set({ 'i', 's' }, '<C-L>', function() ls.jump(1) end, { silent = true })
      vim.keymap.set({ 'i', 's' }, '<C-J>', function() ls.jump(-1) end, { silent = true })

      vim.keymap.set({ 'i', 's' }, '<C-E>', function()
        if ls.choice_active() then
          ls.change_choice(1)
        end
      end, { silent = true })

      require('luasnip.loaders.from_snipmate').lazy_load({ paths = '~/.config/nvim/snippets' })
    end,
  },
}
