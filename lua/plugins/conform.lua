return {
  { -- Autoformat
    'stevearc/conform.nvim',
    lazy = false,
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader><leader>f',
        function()
          require('conform').format { async = true, lsp_format = 'fallback' }
        end,
        mode = 'n',
        desc = '[F]ormat buffer',
      },
    },
    opts = {
      notify_on_error = false,
      format_after_save = function(bufnr)
        local filetype = vim.bo[bufnr].filetype
        if filetype == 'cpp' or filetype == 'c' then
          return
        end

        -- Disable format_after_save for these filetypes
        local disable_filetypes_lsp = { c = true, cpp = true, php = true }
        local lsp_format_opt = disable_filetypes_lsp[filetype] and 'never' or 'fallback'

        return {
          timeout_ms = 9000,
          lsp_format = lsp_format_opt,
        }
      end,
      formatters_by_ft = {
        html = { 'prettierd', 'eslint_d', stop_after_first = true },
        javascript = { 'prettierd', 'eslint_d', stop_after_first = true },
        javascriptreact = { 'prettierd', 'eslint_d', stop_after_first = true },
        markdown = { 'prettierd' },
        typescript = { 'prettierd', 'eslint_d', stop_after_first = true },
        typescriptreact = { 'prettierd', 'eslint_d', stop_after_first = true },
        php = { 'php' },
        cpp = { 'uncrustify' },
        ['*'] = { 'trim_whitespace' },
      },
      formatters = {
        prettierd = {
          condition = function()
            return vim.loop.fs_realpath('.prettierrc.js') ~= nil or vim.loop.fs_realpath('.prettierrc.mjs') ~= nil or
                vim.loop.fs_realpath('.prettierrc.json')
          end,
        },
        php = function()
          return {
            command = require('conform.util').find_executable({
              'tools/php-cs-fixer/vendor/bin/php-cs-fixer',
              'vendor/bin/php-cs-fixer',
            }, 'php-cs-fixer'),
            args = {
              'fix',
              '$FILENAME',
              '--config=/Users/youssef/Expensidev/PHP-Libs/.php-cs-fixer.php'
            },
            stdin = false,
          }
        end,
        uncrustify = function()
          return {
            command = 'uncrustify',
            args = function(_, ctx)
              return {
                '-c',
                '/Users/youssef/Expensidev/Auth/ci/uncrustify_config.txt',
                '-q',
                '-l',
                vim.bo[ctx.buf].filetype:upper() }
            end,
            condition = function(self, ctx)
              return true
            end,
          }
        end
      },
    },
  },
}
-- vim: ts=2 sts=2 sw=2 et
