-- local bgnight = '#2b2f32';
local bgnight = '#2b2e2f'
local bgday = '#383f41'
local bg = bgnight

VagueColors = {
  -- Base colors
  bg = bg,
  fg = '#c7c6c6',
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
  pmenuThumb = '#9c9898',
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
  termRed = '#be8c8c',
  termGreen = '#9da380',
  termYellow = '#c2ac7b',
  termBlue = '#90a0a5',
  termMagenta = '#905858',
}

return {
  'vague2k/vague.nvim',
  lazy = false,
  config = function()
    require('vague').setup({
      transparent = false, -- don't set background
      style = {
        -- "bold" is the same thing as default. But "bold" and "bold" are also valid options
        boolean = 'bold',
        number = 'bold',
        float = 'bold',
        error = 'bold',
        comments = 'bold',
        conditionals = 'bold',
        functions = 'bold',
        headings = 'bold',
        operators = 'bold',
        strings = 'bold',
        variables = 'bold',

        -- keywords
        keywords = 'bold',
        keyword_return = 'bold',
        keywords_loop = 'bold',
        keywords_label = 'bold',
        keywords_exception = 'bold',

        -- builtin
        builtin_constants = 'bold',
        builtin_functions = 'bold',
        builtin_types = 'bold',
        builtin_variables = 'bold',
      },
      -- Override colors
      colors = VagueColors,
    })
  end,
}
