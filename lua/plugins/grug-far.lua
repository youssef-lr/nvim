return {
  'MagicDuck/grug-far.nvim',
  config = function()
    require('grug-far').setup({
      -- debounce milliseconds for issuing search while user is typing
      -- prevents excessive searching
      debounceMs = 500,

      -- minimum number of chars which will cause a search to happen
      -- prevents performance issues in larger dirs
      minSearchChars = 2,

      -- stops search after this number of matches as getting millions of matches is most likely pointless
      -- and can even freeze the search buffer sometimes
      -- can help prevent performance issues when searching for very common strings or when slowly starting
      -- to type your search string
      -- note that it can overshoot a little bit, but should not really matter in practice
      -- set to nil to disable
      maxSearchMatches = 2000,

      -- disable automatic debounced search and trigger search when leaving insert mode or making normal mode changes instead
      -- Note that normal mode changes such as `diw`, `rF`, etc will still trigger a search
      normalModeSearch = false,

      -- max number of parallel replacements tasks
      maxWorkers = 8,

      -- search and replace engines configuration
      engines = {
        -- see https://github.com/BurntSushi/ripgrep
        ripgrep = {
          -- ripgrep executable to use, can be a different path if you need to configure
          path = 'rg',

          -- whether to show diff of the match being replaced as opposed to just the
          -- replaced result. It usually makes it easier to understand the change being made
          showReplaceDiff = true,

          -- placeholders to show in input areas when they are empty
          -- set individual ones to '' to disable, or set enabled = false for complete disable
          placeholders = {
            enabled = false,
            filesFilter = 'ex: *.lua   *.{css,js}   **/docs/*.md   (specify one per line)',
            flags = 'ex: --help --ignore-case (-i) --replace= (empty replace) --multiline (-U)',
            paths = 'ex: /foo/bar   ../   ./hello\\ world/   ./src/foo.lua',
          },
        },
      },

      engine = 'ripgrep',

      -- replacement interpreters that are enabled for usage (in addition to the default).
      -- Those allow you to evaluate the replacement input as a an interpreted string for each search match.
      -- The result of that evaluation is used as the replacement in each case.
      -- Supported:
      -- * 'default': treat replacement as a string to pass to the current engine
      -- * 'lua': treat replacement as lua function body where search match is identified by `match` and
      --          meta variables (with astgrep for example) are avaible in `vars` table (ex: `vars.A` captures `$A`)
      -- * 'vimscript': treat replacement as vimscript function body where search match is identified by `match` and
      --          meta variables (with astgrep for example) are avaible in `vars` table (ex: `vars.A` captures `$A`)
      enabledReplacementInterpreters = { 'default', 'lua', 'vimscript' },

      -- which replacement interprer to use
      -- Must be one of enabledReplacementInterpreters defined above.
      replacementInterpreter = 'default',

      -- specifies the command to run (with `vim.cmd(...)`) in order to create
      -- the window in which the grug-far buffer will appear
      -- ex (horizontal bottom right split): 'botright split'
      -- ex (open new tab): 'tab split'
      windowCreationCommand = 'vsplit',

      -- buffer line numbers + match line numbers can get a bit visually overwhelming
      -- turn this off if you still like to see the line numbers
      disableBufferLineNumbers = true,

      -- help line config
      helpLine = {
        -- whether to show the help line at the top of the buffer
        enabled = true,
      },

      keymaps = {
        replace = { n = '<localleader>r' },
        qflist = { n = '<localleader>q' },
        syncLocations = { n = '<localleader>s' },
        syncLine = { n = '<localleader>l' },
        close = { n = '<localleader>c' },
        historyOpen = { n = '<localleader>t' },
        historyAdd = { n = '<localleader>a' },
        refresh = { n = '<localleader>f' },
        openLocation = { n = '<localleader>o' },
        openNextLocation = { n = '<down>' },
        openPrevLocation = { n = '<up>' },
        gotoLocation = { n = '<enter>' },
        pickHistoryEntry = { n = '<enter>' },
        abort = { n = '<localleader>b' },
        help = { n = 'g?' },
        toggleShowCommand = { n = '<localleader>p' },
        swapEngine = { n = '<localleader>e' },
        previewLocation = { n = '<localleader>i' },
        swapReplacementInterpreter = { n = '<localleader>x' },
      },

      -- separator between inputs and results, default depends on nerdfont
      resultsSeparatorLineChar = '',

      -- highlight the results with TreeSitter, if available
      resultsHighlight = true,

      -- highlight the inputs with TreeSitter, if available
      inputsHighlight = true,

      prefills = {
        search = '',
        replacement = '',
        filesFilter = '',
        flags = '-F',
        paths = '',
      },

      -- search history settings
      history = {
        maxHistoryLines = 10000,

        -- directory where to store history file
        historyDir = vim.fn.stdpath('state') .. '/grug-far',

        -- configuration for when to auto-save history entries
        autoSave = {
          -- whether to auto-save at all, trumps all other settings below
          enabled = true,

          onSyncAll = true,
          onReplace = false,
          onBufDelete = false,
        },
      },

      -- unique instance name. This is used as a handle to refer to a particular instance of grug-far when
      -- toggling visibility, etc.
      -- As this needs to be unique per instance, this option is meant to be speficied for a particular instance
      -- as opposed to something set in the setup function
      instanceName = nil,

      -- folding related options
      folding = {
        -- whether to enable folding
        enabled = true,

        -- sets foldlevel, folds with higher level will be closed.
        -- result matche lines for each file have fold level 1
        -- set it to 0 if you would like to have the results initially collapsed
        -- See :h foldlevel
        foldlevel = 1,

        -- visual indicator of folds, see :h foldcolumn
        -- set to '0' to disable
        foldcolumn = '1',
      },
    });

    vim.keymap.set('n', '<leader><leader>g', '<cmd>GrugFar<CR>')
  end
}
