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
      format_on_save = function(bufnr)
        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        local disable_filetypes = { c = true, cpp = true, php = true }
        local lsp_format_opt
        if disable_filetypes[vim.bo[bufnr].filetype] then
          lsp_format_opt = 'never'
        else
          lsp_format_opt = 'fallback'
        end
        return {
          timeout_ms = 9000,
          lsp_format = lsp_format_opt,
        }
      end,
      formatters_by_ft = {
        html = { "prettierd" },
        javascript = { "prettierd" },
        javascriptreact = { "prettierd" },
        markdown = { "prettierd" },
        typescript = { "prettierd" },
        typescriptreact = { "prettierd" },
        ["*"] = { "trim_whitespace" },
      },
      formatters = {
        prettierd = {
          condition = function()
            return vim.loop.fs_realpath(".prettierrc.js") ~= nil or vim.loop.fs_realpath(".prettierrc.mjs") ~= nil or
                vim.loop.fs_realpath(".prettierrc.json")
          end,
        },
      },
    },
  },
}
-- vim: ts=2 sts=2 sw=2 et
