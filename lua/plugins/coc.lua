local M = {
  "neoclide/coc.nvim",
  branch = "master",
  build = "yarn install --frozen-lockfile",
}

M.config = function()
  local keyset = vim.keymap.set

  -- Use `[g` and `]g` to navigate diagnostics
  -- Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
  keyset("n", "[g", "<Plug>(coc-diagnostic-prev)", { silent = true })
  keyset("n", "]g", "<Plug>(coc-diagnostic-next)", { silent = true })
end

return M
