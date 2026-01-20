---@module "lazy"
---@type LazySpec
return {
  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    branch = 'main',
    build = ':TSUpdate',
    dependencies = {
      require('plugins.treesitter.context'),
      require('plugins.treesitter.textobjects'),
    },
    config = function()
      local ts = require('nvim-treesitter')

      -- Supported languages for treesitter
      local supported_languages = {
        'c',
        'lua',
        'vim',
        'vimdoc',
        'query',
        'javascript',
        'php',
        'cpp',
        'java',
        'typescript',
        'bash',
        'gitcommit',
        'toml',
        'markdown',
        'markdown_inline',
        'swift',
        'yaml',
      }

      -- Create a lookup table for faster checks
      local supported_langs_map = {}
      for _, lang in ipairs(supported_languages) do
        supported_langs_map[lang] = true
      end

      -- Track buffers waiting for parser installation: { lang = { [buf] = true, ... } }
      local waiting_buffers = {}
      -- Track languages currently being installed to avoid duplicate install tasks
      local installing_langs = {}

      local group = vim.api.nvim_create_augroup('TreesitterSetup', { clear = true })

      -- Enable treesitter for a buffer
      local function enable_treesitter(buf, lang)
        if not vim.api.nvim_buf_is_valid(buf) then
          return false
        end

        local ok = pcall(vim.treesitter.start, buf, lang)
        if ok then
          vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
        return ok
      end

      -- Install core parsers after lazy.nvim finishes loading all plugins
      vim.api.nvim_create_autocmd('User', {
        group = group,
        pattern = 'LazyDone',
        once = true,
        desc = 'Install core treesitter parsers',
        callback = function()
          ts.install(supported_languages)
        end,
      })

      -- Auto-install parsers and enable highlighting on FileType
      vim.api.nvim_create_autocmd('FileType', {
        group = group,
        desc = 'Enable treesitter highlighting and indentation',
        callback = function(event)
          local lang = vim.treesitter.language.get_lang(event.match) or event.match
          local buf = event.buf

          if not enable_treesitter(buf, lang) then
            -- Only auto-install if language is in supported list
            if not supported_langs_map[lang] then
              return
            end

            -- Parser not available, queue buffer (set handles duplicates)
            waiting_buffers[lang] = waiting_buffers[lang] or {}
            waiting_buffers[lang][buf] = true

            -- Only start install if not already in progress
            if not installing_langs[lang] then
              installing_langs[lang] = true
              local task = ts.install({ lang })

              -- Register callback for when installation completes
              if task and task.await then
                task:await(function()
                  vim.schedule(function()
                    installing_langs[lang] = nil

                    -- Enable treesitter on all waiting buffers for this language
                    local buffers = waiting_buffers[lang]
                    if buffers then
                      for b in pairs(buffers) do
                        enable_treesitter(b, lang)
                      end
                      waiting_buffers[lang] = nil
                    end
                  end)
                end)
              else
                -- Fallback: clear state if task doesn't support await
                installing_langs[lang] = nil
                waiting_buffers[lang] = nil
              end
            end
          end
        end,
      })

      -- Clean up waiting buffers when buffer is deleted
      vim.api.nvim_create_autocmd('BufDelete', {
        group = group,
        desc = 'Clean up treesitter waiting buffers',
        callback = function(event)
          for lang, buffers in pairs(waiting_buffers) do
            buffers[event.buf] = nil
            if next(buffers) == nil then
              waiting_buffers[lang] = nil
            end
          end
        end,
      })
    end,
  },
}
