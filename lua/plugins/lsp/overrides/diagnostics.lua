local original_set = vim.diagnostic.set

local function override_swiftlint(diagnostics)
  -- Modify diagnostics before they're displayed
  for _, diagnostic in ipairs(diagnostics) do
    if diagnostic.message and diagnostic.message:match('Todo Violation') then
      diagnostic.severity = vim.diagnostic.severity.INFO
    end
  end
  return diagnostics
end

vim.diagnostic.set = function(namespace, bufnr, diagnostics, opts)
  local filetype = vim.api.nvim_get_option_value('filetype', { buf = bufnr })

  if filetype == 'swift' then
    diagnostics = override_swiftlint(diagnostics)
  end

  return original_set(namespace, bufnr, diagnostics, opts)
end
