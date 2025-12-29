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
        function()
          return vim.api.nvim_buf_get_name(0)
        end,
      }

      -- use custom lightweight and git ignored eslintrc to speed up linting, rely on GH actions if it misses anythign
      local current_folder = vim.fn.fnamemodify(vim.fn.getcwd(), ':t')
      local custom_eslint_config = './eslint.custom.config.mjs'
      local main_eslint_config = './eslint.changed.config.mjs'

      if current_folder == 'App' then
        table.insert(eslintArgs, 3, '--config')
        table.insert(eslintArgs, 4, custom_eslint_config)
      end

      lint.linters.eslint_custom = {
        name = 'eslint_custom',
        cmd = os.getenv('HOME') .. '/.local/share/nvim/mason/bin/eslint_d',
        args = eslintArgs,
        stdin = true,
        stream = 'stdout',
        ignore_exitcode = true,
        parser = function(output, bufnr)
          local result = require('plugins.linters.eslint').parser(output, bufnr)
          for _, d in ipairs(result) do
            d.source = 'eslint_d'
          end
          return result
        end,
      }

      lint.linters.react_compiler = {
        name = 'react-compiler',
        cmd = os.getenv('HOME') .. '/ExpensiDev/App/scripts/react-compiler.sh',
        parser = function(output, bufnr)
          local trimmed_output = vim.trim(output)
          if trimmed_output == '' then
            return {}
          end

          local decode_opts = { luanil = { object = true, array = true } }
          local ok, data = pcall(vim.json.decode, trimmed_output, decode_opts)

          if not ok then
            return {
              {
                bufnr = bufnr,
                lnum = 0,
                col = 0,
                message = 'Could not parse react-compiler output due to: ' .. data .. '\noutput: ' .. output,
              },
            }
          end

          local diagnostics = {}
          local current_file = vim.api.nvim_buf_get_name(bufnr)

          -- Process compiler errors
          for _, error in ipairs(data.compilerErrors or {}) do
            -- Only include errors for the current buffer
            -- Match against the end of the current file path to handle relative vs absolute paths
            if error.file and current_file:find(vim.pesc(error.file) .. '$') then
              table.insert(diagnostics, {
                lnum = error.line and (error.line - 1) or 0,
                col = error.column and (error.column - 1) or 0,
                message = error.reason,
                code = 'compiler-error',
                severity = vim.diagnostic.severity.INFO,
                source = 'react-compiler',
              })
            end
          end

          -- -- Process manual memo errors (these don't have file field, so include all for current buffer)
          -- for _, error in ipairs(data.manualMemoErrors or {}) do
          --   table.insert(diagnostics, {
          --     lnum = error.line and (error.line - 1) or 0,
          --     col = error.column and (error.column - 1) or 0,
          --     message = "Manual memoization detected: " .. (error.keyword or "unknown"),
          --     code = "manual-memo",
          --     severity = vim.diagnostic.severity.INFO,
          --     source = "react-compiler"
          --   })
          -- end

          return diagnostics
        end,
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
      local debounce_timer = nil
      local debounce_ms = 100

      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'TextChangedI', 'TextChangedP', 'TextChanged' }, {
        group = lint_augroup,
        callback = function()
          if debounce_timer then
            vim.fn.timer_stop(debounce_timer)
          end
          debounce_timer = vim.fn.timer_start(debounce_ms, function()
            lint.try_lint()
            debounce_timer = nil
          end)
        end,
      })
    end,
  },
}
