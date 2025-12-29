return {
  'zbirenbaum/neodim',
  event = 'LspAttach',
  config = function()
    require('neodim').setup({
      alpha = 0.75,
      blend_color = '#000000',
      hide = {
        underline = true,
        virtual_text = true,
        signs = false,
      },
      regex = {
        '[uU]nused',
        '[nN]ever [rR]ead',
        '[nN]ot [rR]ead',
        'never be executed',
      },
      priority = 128,
      disable = {},
    })
  end,
}
