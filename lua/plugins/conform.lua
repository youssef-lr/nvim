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
        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        local disable_filetypes = { c = true, cpp = true }
        local lsp_format_opt
        if disable_filetypes[vim.bo[bufnr].filetype] then
          lsp_format_opt = 'never'
        else
          lsp_format_opt = 'fallback'
        end
        return {
          timeout_ms = 1000,
          lsp_format = lsp_format_opt,
        }
      end,
      callback = function()
        vim.defer_fn(function()
          local lint = require('lint')
          lint.try_lint();
        end, 1500)
      end,
      formatters_by_ft = {
        html = { "prettierd" },
        javascript = { "prettierd" },
        javascriptreact = { "prettierd" },
        markdown = { "prettierd" },
        typescript = { "prettierd" },
        typescriptreact = { "prettierd" },
        php = { "php" },
        ["*"] = { "trim_whitespace" },
      },
      formatters = {
        prettierd = {
          condition = function()
            return vim.loop.fs_realpath(".prettierrc.js") ~= nil or vim.loop.fs_realpath(".prettierrc.mjs") ~= nil or
                vim.loop.fs_realpath(".prettierrc.json")
          end,
        },
        php = function()
          return {
            command = require("conform.util").find_executable({
              "tools/php-cs-fixer/vendor/bin/php-cs-fixer",
              "vendor/bin/php-cs-fixer",
            }, "php-cs-fixer"),
            args = {
              "fix",
              "$FILENAME",
              "--config=/Users/youssef/Expensidev/PHP-Libs/.php-cs-fixer.php"
            },
            stdin = false,
          }
        end
      },
    },
  },
}
-- vim: ts=2 sts=2 sw=2 et
