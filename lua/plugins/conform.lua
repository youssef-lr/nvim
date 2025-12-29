return {
  { -- Autoformat
    'stevearc/conform.nvim',
    lazy = false,
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader><leader>f',
        function()
          require('conform').format({ async = true, lsp_format = 'fallback' })
        end,
        mode = 'n',
        desc = '[F]ormat buffer',
      },
      {
        'f',
        function()
          require('conform').format({ async = true, lsp_format = 'never' })
          vim.api.nvim_input('<Esc>')
        end,
        mode = 'v',
        desc = '[F]ormat range',
      },
    },
    opts = {
      notify_on_error = false,
      format_after_save = function(bufnr)
        print('format')
        local git_root = require('utils').get_git_root()
        local filetype = vim.bo[bufnr].filetype
        if git_root == 'Web-Expensify' and (filetype == 'javascriptreact' or filetype == 'jsx') then
          return
        end

        -- no auto formatting for cpp & c files
        -- if filetype == 'cpp' or filetype == 'c' then
        --   return
        -- end

        -- Disable LSP format_after_save for PHP
        -- this won't use the LSP formatting fallback, but we'll use our custom php formatter as defined below
        local disable_filetypes_lsp = { php = true }
        local lsp_format_opt = disable_filetypes_lsp[filetype] and 'never' or 'fallback'

        return {
          timeout_ms = 9000,
          lsp_format = lsp_format_opt,
        }
      end,
      formatters_by_ft = {
        html = { 'prettierd', 'eslint_d', stop_after_first = true },
        javascript = { 'eslint_d', stop_after_first = true },
        javascriptreact = { 'eslint_d', stop_after_first = true },
        markdown = { 'prettierd' },
        typescript = { 'prettierd', 'eslint_d', stop_after_first = true },
        typescriptreact = { 'prettierd', 'eslint_d', stop_after_first = true },
        jsx = { 'prettierd', 'eslint_d', stop_after_first = true },
        json = { 'prettierd' },
        php = { 'php' },
        cpp = { 'uncrustify' },
        sql = { 'sql_formatter' },
        lua = { 'stylua' },
        -- json = { 'biome' },
        ['*'] = { 'trim_whitespace' },
      },
      formatters = {
        php = function()
          return {
            command = require('conform.util').find_executable({
              'tools/php-cs-fixer/vendor/bin/php-cs-fixer',
              'vendor/bin/php-cs-fixer',
            }, 'php-cs-fixer'),
            args = {
              'fix',
              '$FILENAME',
              '--config=/Users/youssef/Expensidev/PHP-Libs/.php-cs-fixer.php',
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
                vim.bo[ctx.buf].filetype:upper(),
              }
            end,
            condition = function(self, ctx)
              return true
            end,
          }
        end,
      },
    },
  },
}
-- vim: ts=2 sts=2 sw=2 et
