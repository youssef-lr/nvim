return {
  { -- Linting
    'mfussenegger/nvim-lint',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local lint = require 'lint'

      local eslintArgs = {
        '--format',
        'json',
        '--cache',
        '--stdin',
        '--stdin-filename',
        function() return vim.api.nvim_buf_get_name(0) end,
      }

      -- use custom lightweight and git ignored eslintrc to speed up linting, rely on GH actions if it misses anythign
      local current_folder = vim.fn.fnamemodify(vim.fn.getcwd(), ':t')
      if current_folder == 'App' then
        table.insert(eslintArgs, 3, '--config')
        table.insert(eslintArgs, 4, './.eslintrc.custom.js')
      end

      lint.linters.eslint_custom = {
        name = 'eslint_custom',
        cmd = os.getenv('HOME') .. '/.local/share/nvim/mason/bin/eslint_d',
        args = eslintArgs,
        stdin = true,
        stream = 'stdout',
        ignore_exitcode = true,
        parser = function(output, bufnr)
          local result = require('lint.linters.eslint').parser(output, bufnr)
          for _, d in ipairs(result) do
            d.source = 'eslint_d'
          end
          return result
        end
      }

      local psalm = require('lint').linters.psalm
      psalm.ignore_exitcode = true

      lint.linters_by_ft = {
        javascript = { 'eslint_custom' },
        javascriptreact = { 'eslint_custom' },
        typescript = { 'eslint_custom' },
        typescriptreact = { 'eslint_custom' },
        -- php = { 'psalm' },
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
