return {

  { -- Linting
    'mfussenegger/nvim-lint',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local lint = require 'lint'

      local binary_name = "eslint_d"
      lint.linters.eslint_custom = {
        cmd = function()
          local local_binary = vim.fn.fnamemodify('./node_modules/.bin/' .. binary_name, ':p')
          return vim.loop.fs_stat(local_binary) and local_binary or binary_name
        end,
        args = {
          '--format',
          'json',
          '--config',
          './.eslintrc.custom.js',
          '--cache',
          '--stdin',
          '--stdin-filename',
          function() return vim.api.nvim_buf_get_name(0) end,
        },
        stdin = true,
        stream = 'stdout',
        ignore_exitcode = true,
        parser = function(output, bufnr)
          local result = require("lint.linters.eslint").parser(output, bufnr)
          for _, d in ipairs(result) do
            d.source = binary_name
          end
          return result
        end
      }

      lint.linters_by_ft = {
        javascript = { 'eslint_custom' },
        javascriptreact = { 'eslint_custom' },
        typescript = { 'eslint_custom' },
        typescriptreact = { 'eslint_custom' },
      }

      local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
        group = lint_augroup,
        callback = function()
          lint.try_lint()
        end,
      })
    end,
  },
}
