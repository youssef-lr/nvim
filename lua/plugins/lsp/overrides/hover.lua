local function simplify_hover_text(text)
  if type(text) ~= 'string' then
    return text
  end

  local result = ''
  local i = 1
  local len = #text

  while i <= len do
    if text:sub(i, i) == '{' then
      local depth = 1
      i = i + 1

      while i <= len and depth > 0 do
        local char = text:sub(i, i)
        if char == '{' then
          depth = depth + 1
        elseif char == '}' then
          depth = depth - 1
        end
        i = i + 1
      end

      result = result .. '{ ... }'
    else
      result = result .. text:sub(i, i)
      i = i + 1
    end
  end

  return result
end

-- Intercept buf_request_all (for hover)
local original_buf_request_all = vim.lsp.buf_request_all

vim.lsp.buf_request_all = function(bufnr, method, params, callback)
  if method == 'textDocument/hover' then
    local original_callback = callback
    callback = function(results, ctx)
      for client_id, resp in pairs(results) do
        if resp.result and resp.result.contents then
          if type(resp.result.contents) == 'table' and resp.result.contents.value then
            resp.result.contents.value = simplify_hover_text(resp.result.contents.value)
          elseif type(resp.result.contents) == 'string' then
            resp.result.contents = simplify_hover_text(resp.result.contents)
          elseif type(resp.result.contents) == 'table' and #resp.result.contents > 0 then
            for i, content in ipairs(resp.result.contents) do
              if type(content) == 'table' and content.value then
                content.value = simplify_hover_text(content.value)
              elseif type(content) == 'string' then
                resp.result.contents[i] = simplify_hover_text(content)
              end
            end
          end
        end
      end
      return original_callback(results, ctx)
    end
  end

  return original_buf_request_all(bufnr, method, params, callback)
end

-- Intercept buf_request (for signature help)
local original_buf_request = vim.lsp.buf_request

vim.lsp.buf_request = function(bufnr, method, params, callback)
  if method == 'textDocument/signatureHelp' then
    local original_callback = callback
    callback = function(err, result, ctx, config)
      print('ogiginal contex')
      if result and result.signatures then
        for _, sig in ipairs(result.signatures) do
          if sig.label then
            sig.label = simplify_hover_text(sig.label)
          end

          if type(sig.documentation) == 'string' then
            sig.documentation = simplify_hover_text(sig.documentation)
          elseif type(sig.documentation) == 'table' and sig.documentation.value then
            sig.documentation.value = simplify_hover_text(sig.documentation.value)
          end

          if sig.parameters then
            for _, param in ipairs(sig.parameters) do
              if type(param.documentation) == 'string' then
                param.documentation = simplify_hover_text(param.documentation)
              elseif type(param.documentation) == 'table' and param.documentation.value then
                param.documentation.value = simplify_hover_text(param.documentation.value)
              end
            end
          end
        end
      end
      return original_callback(err, result, ctx, config)
    end
  end

  return original_buf_request(bufnr, method, params, callback)
end
