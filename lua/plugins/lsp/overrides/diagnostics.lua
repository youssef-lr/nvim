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

local function override_cpp(diagnostics)
  local filtered = {}
  for _, diagnostic in ipairs(diagnostics) do
    local message = diagnostic.message or ''
    local should_keep = true

    if
      message:match("Use of undeclared identifier 'cout'")
      or message:match("Format specifies type 'long' but the argument has type 'int64_t'")
      or message:match("No matching function for call to 'clamp'")
      or message:match("No matching function for call to 'max'")
      or message:match("Call to 'SQ' is ambiguous")
      or message:match('Reference to overloaded function could not be resolved')
    then
      should_keep = false
    end

    if should_keep then
      table.insert(filtered, diagnostic)
    end
  end
  return filtered
end

local function override_eslint(diagnostics)
  -- Filter out specific ESLint diagnostics
  local filtered = {}
  for _, diagnostic in ipairs(diagnostics) do
    local message = diagnostic.message or ''
    local should_keep = true

    local filtered_messages = {
      'Onyx.connect() is deprecated',
      "Unused '@ts-expect-error' directive",
      "The signature '(phrase",
      "'translateLocal' is deprecated",
      'deprecated',
    }
    for _, pattern in ipairs(filtered_messages) do
      if message:find(pattern, 1, true) then
        should_keep = false
        break
      end
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
  elseif filetype == 'cpp' then
    diagnostics = override_cpp(diagnostics)
  end

  return original_set(namespace, bufnr, diagnostics, opts)
end
