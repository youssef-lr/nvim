-- local bgnight = '#2b2f32';
local bgnight = '#2b2e2f'
local bgday = '#3e4648'
local bg = bgnight

VagueColors = {
  -- Base colors
  bg = bg,
  fg = '#d0cece',
  line = '#282830',
  comment = '#acacac',

  -- Syntax colors
  builtin = '#a3b8b6',
  func = '#cdb2b1',
  string = '#9da380',
  number = '#dacaa5',
  property = '#c7c7d4',
  constant = '#cdc09e',
  operator = '#96a3b2',
  keyword = '#a4b7c3',
  type = '#a3b8b6',

  -- UI elements
  floatBorder = '#878787',
  visual = '#51575d',
  search = '#d9b2aa',
  winSeparator = '#4b4848',
  lineNr = '#9f9f9f',
  pmenuThumb = '#51575d',
  matchParen = '#d5d7d8',

  -- Diagnostic colors
  plus = '#8faf77',
  delta = '#e6be8c',
  error = '#dc9e92',
  warning = '#c2ac7b',
  hint = '#a6a4a4',
  info = '#a6a4a4',

  -- Special highlights
  bracket = '#a4bac1',
  tag = '#cdc09e',
  tagAttribute = 'Grey70',
  treesitterContext = '#41423b',
  lspSignatureParam = '#b5ba99',
  flashLabel = '#ffffff',

  -- Git colors
  gitAdd = '#cad2a5',
  diffAddFg = '#939a74',
  diffTextFg = '#000000',

  -- Terminal colors
  -- ANSI colors (0-7)
  terminal_color_0 = '#3b5455', -- black (dark teal)
  terminal_color_1 = '#dc9e92', -- red (dusty rose)
  terminal_color_2 = '#98bc99', -- green (sage)
  terminal_color_3 = '#cdc09e', -- yellow (pale cream)
  terminal_color_4 = '#90a0a5', -- blue (soft blue)
  terminal_color_5 = '#cdb2b1', -- magenta (coral pink)
  terminal_color_6 = '#889e9e', -- cyan (dark teal)
  terminal_color_7 = '#a3a0a0', -- white (pale green)

  -- Bright ANSI colors (8-15)
  terminal_color_8 = '#905858', -- Bright Black (Gray)
  terminal_color_9 = '#ef766d', -- bright red (coral)
  terminal_color_10 = '#8bb899', -- bright green (mint)
  terminal_color_11 = '#e9d6a2', -- bright yellow (pale cream)
  terminal_color_12 = '#98bede', -- bright blue (sky blue)
  terminal_color_13 = '#eab09b', -- bright magenta (peach)
  terminal_color_14 = '#d4bd85', -- bright cyan (tan gold)
  terminal_color_15 = '#d9d8d4', -- bright white (light gray)
}

return {
  'vague2k/vague.nvim',
  lazy = false,
  config = function()
    require('vague').setup({
      transparent = false, -- don't set background
      style = {
        -- "bold" is the same thing as default. But "bold" and "bold" are also valid options
        boolean = 'none',
        number = 'none',
        float = 'none',
        error = 'none',
        comments = 'none',
        conditionals = 'none',
        functions = 'none',
        headings = 'none',
        operators = 'none',
        strings = 'none',
        variables = 'none',
        type = 'none',

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
  end,
}
