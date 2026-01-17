local colors = {
  black = '#000000',
  white = 'c8c4c4',
  red = '#bc9a9c',
  green = '#9da380',
  blue = '#87aab5',
  yellow = '#c2ac7b',
  gray = '#acacac',
  darkgray = '#acacac',
  lightgray = '#504945',
  inactivegray = '#7c6f64',
  bg = '#3d4547',
}

local custom = {
  normal = {
    a = { bg = colors.blue, fg = colors.black, gui = 'bold' },
    b = { bg = colors.bg, fg = colors.white },
    c = { bg = colors.bg, fg = colors.white },
  },
  insert = {
    a = { bg = colors.green, fg = colors.black, gui = 'bold' },
    b = { bg = colors.bg, fg = colors.white },
    c = { bg = colors.bg, fg = colors.white },
  },
  visual = {
    a = { bg = colors.yellow, fg = colors.black, gui = 'bold' },
    b = { bg = colors.bg, fg = colors.white },
    c = { bg = colors.bg, fg = colors.white },
  },
  replace = {
    a = { bg = colors.red, fg = colors.black, gui = 'bold' },
    b = { bg = colors.bg, fg = colors.white },
    c = { bg = colors.bg, fg = colors.white },
  },
  command = {
    a = { bg = colors.red, fg = colors.black, gui = 'bold' },
    b = { bg = colors.bg, fg = colors.white },
    c = { bg = colors.bg, fg = colors.white },
  },
  inactive = {
    a = { bg = colors.bg, fg = colors.gray, gui = 'bold' },
    b = { bg = colors.bg, fg = colors.gray },
    c = { bg = colors.bg, fg = colors.gray },
  },
}

local diagnostics = {
  'diagnostics',
  sources = { 'nvim_diagnostic' },
  symbols = {
    error = '● ',
    warn = '● ',
    info = '● ',
    hint = '● ',
  },
  diagnostics_color = {
    hint = { fg = VagueColors.hint },
    info = { fg = VagueColors.info },
    warn = { fg = VagueColors.warning },
    error = { fg = VagueColors.error },
  },
}

local function fugitive_branch()
  local icon = '' -- e0a0
  return icon .. ' ' .. vim.fn.FugitiveHead()
end
local function get_short_cwd()
  return 'NvimTree'
end

local claude_cache = { count = 0, last_update = 0 }

local function update_claude_count()
  -- Throttle updates: only update if 2 seconds have passed since last update
  local current_time = vim.loop.now()
  if current_time - claude_cache.last_update < 2000 then
    return
  end

  local handle = io.popen("pgrep -f '^claude$' | wc -l | tr -d ' '")
  if handle then
    local result = handle:read('*a')
    handle:close()
    claude_cache.count = tonumber(result) or 0
    claude_cache.last_update = current_time
  end
end

local function claude_processes()
  if claude_cache.count > 0 then
    return '󰧑 ' .. claude_cache.count
  end
  return ''
end

local function macro_recording()
  local reg = vim.fn.reg_recording()
  if reg == '' then
    return ''
  end
  return '󰑋 @' .. reg
end

local function search_count()
  if vim.v.hlsearch == 0 then
    return ''
  end
  local ok, result = pcall(vim.fn.searchcount, { recompute = 1, maxcount = -1 })
  if not ok or result.current == 0 then
    return ''
  end
  return string.format('[%d/%d]', result.current, result.total)
end

local function lsp_clients()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  if #clients == 0 then
    return ''
  end
  local names = {}
  for _, client in ipairs(clients) do
    table.insert(names, client.name)
  end
  return '  ' .. table.concat(names, ', ')
end

local function selection_info()
  local mode = vim.fn.mode()
  if not (mode == 'v' or mode == 'V' or mode == '\22') then
    return ''
  end
  local start_line = vim.fn.line('v')
  local end_line = vim.fn.line('.')
  local lines = math.abs(end_line - start_line) + 1
  return string.format('%dL', lines)
end

-- Initialize count on startup
update_claude_count()

-- Update count on BufEnter for terminal buffers
vim.api.nvim_create_autocmd('BufEnter', {
  callback = function()
    update_claude_count()
  end,
})

-- Update count when terminal buffers are closed
vim.api.nvim_create_autocmd({ 'BufDelete', 'BufWipeout', 'BufEnter' }, {
  callback = function()
    if vim.bo.buftype == 'terminal' then
      update_claude_count()
    end
  end,
})

local fugitive = {
  sections = {
    lualine_b = {
      {
        fugitive_branch,
        color = { fg = VagueColors.number },
      },
    },
  },
  filetypes = { 'fugitive' },
}
local nvimtree = {
  sections = {
    lualine_b = { get_short_cwd },
  },
  filetypes = { 'NvimTree' },
}
vim.api.nvim_set_hl(0, 'NvimTreeStatusLine', { bg = colors.bg })

local M = {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  opts = {
    options = {
      icons_enabled = true,
      theme = custom,
      component_separators = { left = '', right = '' },
      section_separators = { left = '', right = '' },
      disabled_filetypes = {
        statusline = {},
        winbar = {},
      },
      ignore_focus = {},
      always_divide_middle = true,
      globalstatus = false,
      refresh = {
        statusline = 500,
        tabline = 1000,
        winbar = 1000,
      },
    },
    sections = {
      lualine_a = { 'mode', macro_recording },
      lualine_b = {
        {
          'branch',
          color = { fg = VagueColors.number },
        },
        'diff',
        diagnostics,
        'filename',
        search_count,
        selection_info,
      },
      lualine_c = {},
      lualine_x = {
        lsp_clients,
        {
          claude_processes,
          color = function()
            if claude_cache.count >= 5 then
              return { fg = VagueColors.error }
            end
            return nil
          end,
        },
        'filetype',
      },
      lualine_y = { 'progress' },
      lualine_z = { 'location' },
    },
    inactive_sections = {
      lualine_a = {
        'diff',
        diagnostics,
      },
      lualine_b = {
        {
          'branch',
          color = { fg = VagueColors.number },
        },
      },
      lualine_x = {
        lsp_clients,
        {
          claude_processes,
          color = function()
            if claude_cache.count >= 5 then
              return { fg = VagueColors.error }
            end
            return nil
          end,
        },
        'filetype',
      },
    },
    tabline = {},
    winbar = {},
    inactive_winbar = {},
    extensions = { nvimtree, fugitive, 'lazy', 'mason', 'fzf', 'toggleterm', 'oil' },
  },
}

return M
