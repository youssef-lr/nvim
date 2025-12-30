return {
  'altermo/iedit.nvim',
  opts = {
    highlight = 'IncSearch',
    end_right_gravity = true,
    right_gravity = false,
  },
  config = function ()
    vim.keymap.set({'n', 'v' }, '<D-d>', function () require('iedit').toggle() end, { noremap = true, })
  end
}
