return {
  'vague2k/vague.nvim',
  config = function()
    local bg = '#303438';
    local colors = {
      bg = bg,
      fg = '#cdcdcd',
      floatBorder = '#878787',
      line = '#282830',
      comment = '#acacac',
      builtin = '#a3b8b6',
      func = '#bc9a9c',
      string = '#b3b993',
      number = '#c2ac7b',
      property = '#c7c7d4',
      constant = '#C4AAA9',
      parameter = '#b9a3ba',
      visual = '#363738',
      error = '#be8c8c',
      warning = '#c2ac7b',
      hint = '#b7b7c2',
      operator = '#96a3b2',
      keyword = '#8cadc6',
      type = '#a1b3b9',
      search = '#465362',
      plus = '#8faf77',
      delta = '#e6be8c',
    }

    require('vague').setup({
      transparent = false, -- don't set background
      style = {
        -- "none" is the same thing as default. But "none" and "bold" are also valid options
        boolean = 'none',
        number = 'none',
        float = 'none',
        error = 'none',
        comments = 'none',
        conditionals = 'none',
        functions = 'none',
        headings = 'bold',
        operators = 'none',
        strings = 'none',
        variables = 'none',

        -- keywords
        keywords = 'none',
        keyword_return = 'none',
        keywords_loop = 'none',
        keywords_label = 'none',
        keywords_exception = 'none',

        -- builtin
        builtin_constants = 'none',
        builtin_functions = 'none',
        builtin_types = 'none',
        builtin_variables = 'none',
      },
      -- Override colors
      colors = colors,
    })

    vim.cmd('colorscheme vague')

    vim.api.nvim_set_hl(0, 'WinSeparator', { fg = bg })

    vim.api.nvim_set_hl(0, '@function.method.call', { fg = '#bc9a9c', bg = bg })
    vim.api.nvim_set_hl(0, '@function.call', { fg = '#bc9a9c', bg = bg })
    vim.api.nvim_set_hl(0, '@variable.parameter', { link = '@variable' })
    vim.api.nvim_set_hl(0, '@keyword.import', { link = '@keyword' })
    vim.api.nvim_set_hl(0, 'Tag', { fg = '#cdc09e' })

    vim.api.nvim_set_hl(0, 'CursorLine', { bg = 'NONE' })
    vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = colors.func, bg = '#27292d' })

    vim.api.nvim_set_hl(0, 'DiagnosticInfo', { fg = '#cdd7d3', bg = bg })
    vim.api.nvim_set_hl(0, 'DiagnosticWarn', { fg = colors.warning, bg = bg })
    vim.api.nvim_set_hl(0, 'LineNr', { fg = '#9f9f9f', bg = bg })

    local search = '#51575d'
    vim.api.nvim_set_hl(0, 'Visual', { fg = '', bg = search })
    vim.api.nvim_set_hl(0, 'IncSearch', { fg = '', bg = search })
    vim.api.nvim_set_hl(0, 'Search', { fg = '', bg = search })
    vim.api.nvim_set_hl(0, 'CurSearch', { fg = '', bg = search })

    vim.api.nvim_set_hl(0, 'PmenuThumb', { bg = '#9c9898' })
    vim.api.nvim_set_hl(0, 'PmenuSel', { bg = search, fg = '#d9d6d6' })

    vim.api.nvim_set_hl(0, 'EndOfBuffer', { bg = bg, fg = bg })
    vim.api.nvim_set_hl(0, 'GitSignsAdd', { fg = '#cad2a5' })
    vim.api.nvim_set_hl(0, 'GitSignsChange', { link = 'Keyword' })

    vim.api.nvim_set_hl(0, 'Error', { fg = colors.error, bold = false })
    vim.api.nvim_set_hl(0, 'ErrorMsg', { link = 'Error' })

    vim.api.nvim_set_hl(0, 'FzfLuaHeaderText', { link = 'Error' })
    vim.api.nvim_set_hl(0, 'FzfLuaLiveSym', { link = 'Error' })
    vim.api.nvim_set_hl(0, 'FzfLuaBufFlagCur', { link = 'Error' })
    vim.api.nvim_set_hl(0, 'FzfLuaPathLineNr', { link = 'String' })

    vim.api.nvim_set_hl(0, 'DiffText', { fg = '#000000', bg = colors.func })

    vim.cmd('hi QuickfixLine gui=NONE')
  end
}
