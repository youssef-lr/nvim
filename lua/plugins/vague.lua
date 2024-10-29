local bgnight = '#2b2f32';
local bgday = '#34383d';
local bg = bgnight;

VagueColors = {
  bg = bg,
  fg = '#c7c6c6',
  line = '#282830',
  comment = '#acacac',
  builtin = '#a3b8b6',
  func = '#bc9a9c',
  string = '#9da380',
  number = '#dacaa5',
  property = '#c7c7d4',
  constant = '#C4AAA9',
  parameter = '#b9a3ba',
  operator = '#96a3b2',
  keyword = '#8cadc6',
  floatBorder = '#878787',
  type = '#a1b3b9',
  visual = '#51575d',
  search = '#d9b2aa',
  plus = '#8faf77',
  delta = '#e6be8c',
  error = '#dc9e92',
  warning = '#c2ac7b',
  hint = '#a6a4a4',
  info = '#a6a4a4',
}

return {
  'vague2k/vague.nvim',
  lazy = false,
  config = function()
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
      colors = VagueColors,
    })
  end
}
