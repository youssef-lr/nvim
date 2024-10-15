return {
  {
    'echasnovski/mini.ai',
    event = 'VeryLazy',
    opts = function()
      local miniai = require 'mini.ai'

      return {
        n_lines = 300,
        custom_textobjects = {
          f = miniai.gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }, {}),
          -- Whole buffer.
          g = function()
            local from = { line = 1, col = 1 }
            local to = {
              line = vim.fn.line '$',
              col = math.max(vim.fn.getline('$'):len(), 1),
            }
            return { from = from, to = to }
          end,
        },
      }
    end,
  },
}
