return {
  'VonHeikemen/fine-cmdline.nvim',
  dependencies = { 'MunifTanjim/nui.nvim' },
  opts = {
    popup = {
      position = {
        row = '40%',
        col = '50%',
      },
      size = {
        width = '60%',
      },
      border = {
        style = 'rounded',
      },
      win_options = {
        winhighlight = 'Normal:Normal,FloatBorder:FloatBorder',
      },
    },
    cmdline = {
      enable_keymaps = true,
      smart_history = true,
      prompt = ': '
    },
    hooks = {
      after_mount = function(input)
        -- make escape go to normal mode
        vim.keymap.set('i', '<Esc>', '<cmd>stopinsert<cr>', { buffer = input.bufnr })
      end
    }
  }
}
