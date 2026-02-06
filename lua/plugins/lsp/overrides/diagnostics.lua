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

local function override_eslint(diagnostics)
  -- Filter out specific ESLint diagnostics
  local filtered = {}
  for _, diagnostic in ipairs(diagnostics) do
    local message = diagnostic.message or ''
    local should_keep = true

    -- Check if message starts with specific strings (plain text match)
    local deprecationError = 'Onyx.connect() is deprecated'
    local unusedTS = "Unused '@ts-expect-error' directive"
    if message:sub(1, #deprecationError) == deprecationError or message:sub(1, #unusedTS) == unusedTS then
      should_keep = false
    end

    if should_keep then
      table.insert(filtered, diagnostic)
    end
  end
  return filtered
end

vim.diagnostic.set = function(namespace, bufnr, diagnostics, opts)
  local filetype = vim.api.nvim_get_option_value('filetype', { buf = bufnr })

  if filetype == 'swift' then
    diagnostics = override_swiftlint(diagnostics)
  elseif filetype == 'typescriptreact' then
    diagnostics = override_eslint(diagnostics)
  end

  return original_set(namespace, bufnr, diagnostics, opts)
end
