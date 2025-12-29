---@module "lazy"
---@type LazyPluginSpec
return {
  'nvim-treesitter/nvim-treesitter-textobjects',
  branch = 'main',
  config = function()
    require('nvim-treesitter-textobjects').setup {
      select = {
        -- Automatically jump forward to textobj, similar to targets.vim
        lookahead = true,
        -- You can choose the select mode (default is charwise 'v')
        --
        -- Can also be a function which gets passed a table with the keys
        -- * query_string: eg '@function.inner'
        -- * method: eg 'v' or 'o'
        -- and should return the mode ('v', 'V', or '<c-v>') or a table
        -- mapping query_strings to modes.
        selection_modes = {
          ['@parameter.outer'] = 'v', -- charwise
          ['@function.outer'] = 'V', -- linewise
          -- ['@class.outer'] = '<c-v>', -- blockwise
        },
        -- If you set this to `true` (default is `false`) then any textobject is
        -- extended to include preceding or succeeding whitespace. Succeeding
        -- whitespace has priority in order to act similarly to eg the built-in
        -- `ap`.
        --
        -- Can also be a function which gets passed a table with the keys
        -- * query_string: eg '@function.inner'
        -- * selection_mode: eg 'v'
        -- and should return true of false
        include_surrounding_whitespace = false,
      },
    }

    local ts_move = require('nvim-treesitter-textobjects.move')
    local ts_swap = require('nvim-treesitter-textobjects.swap')
    local ts_select = require('nvim-treesitter-textobjects.select')

    -- Select
    vim.keymap.set({ 'x', 'o' }, 'af', function()
      ts_select.select_textobject('@function.outer', 'textobjects')
    end, { desc = 'Select around function' })

    vim.keymap.set({ 'x', 'o' }, 'if', function()
      ts_select.select_textobject('@function.inner', 'textobjects')
    end, { desc = 'Select inside function' })

    vim.keymap.set({ 'x', 'o' }, 'ac', function()
      ts_select.select_textobject('@conditional.outer', 'textobjects')
    end, { desc = 'Select around conditional' })

    vim.keymap.set({ 'x', 'o' }, 'ic', function()
      ts_select.select_textobject('@conditional.inner', 'textobjects')
    end, { desc = 'Select inside conditional' })

    vim.keymap.set({ 'x', 'o' }, 'al', function()
      ts_select.select_textobject('@loop.outer', 'textobjects')
    end, { desc = 'Select around loop' })

    vim.keymap.set({ 'x', 'o' }, 'il', function()
      ts_select.select_textobject('@loop.inner', 'textobjects')
    end, { desc = 'Select inside loop' })

    vim.keymap.set({ 'x', 'o' }, 'rh', function()
      ts_select.select_textobject('@assignment.rhs', 'textobjects')
    end, { desc = 'Select assignment RHS' })

    vim.keymap.set({ 'x', 'o' }, 'lh', function()
      ts_select.select_textobject('@assignment.lhs', 'textobjects')
    end, { desc = 'Select assignment LHS' })

    vim.keymap.set({ 'x', 'o' }, 'ip', function()
      ts_select.select_textobject('@parameter.inner', 'textobjects')
    end, { desc = 'Select inside parameter' })

    vim.keymap.set({ 'x', 'o' }, 'ap', function()
      ts_select.select_textobject('@parameter.outer', 'textobjects')
    end, { desc = 'Select around parameter' })

    -- Swap
    vim.keymap.set('n', 'è_', function()
      ts_swap.swap_next('@parameter.inner')
    end, { desc = 'Swap with next parameter' })

    vim.keymap.set('n', '_è', function()
      ts_swap.swap_previous('@parameter.inner')
    end, { desc = 'Swap with previous parameter' })

    -- Move: goto_next_start
    vim.keymap.set({ 'n', 'x', 'o' }, '=f', function()
      ts_move.goto_next_start('@function.outer', 'textobjects')
      vim.cmd.normal({ args = { 'zz' }, bang = true })
    end, { desc = 'Go to next function start' })

    vim.keymap.set({ 'n', 'x', 'o' }, '=if', function()
      ts_move.goto_next_start('@function.inner', 'textobjects')
      vim.cmd.normal({ args = { 'zz' }, bang = true })
    end, { desc = 'Go to next inner function start' })

    vim.keymap.set({ 'n', 'x', 'o' }, '=p', function()
      ts_move.goto_next_start('@parameter.inner', 'textobjects')
      vim.cmd.normal({ args = { 'zz' }, bang = true })
    end, { desc = 'Go to next parameter' })

    vim.keymap.set({ 'n', 'x', 'o' }, '=c', function()
      ts_move.goto_next_start('@call.outer', 'textobjects')
      vim.cmd.normal({ args = { 'zz' }, bang = true })
    end, { desc = 'Go to next call' })

    vim.keymap.set({ 'n', 'x', 'o' }, '=l', function()
      ts_move.goto_next_start('@loop.*', 'textobjects')
      vim.cmd.normal({ args = { 'zz' }, bang = true })
    end, { desc = 'Go to next loop' })

    vim.keymap.set({ 'n', 'x', 'o' }, '=s', function()
      ts_move.goto_next_start('@scope', 'locals')
      vim.cmd.normal({ args = { 'zz' }, bang = true })
    end, { desc = 'Go to next scope' })

    -- Move: goto_next_end
    vim.keymap.set({ 'n', 'x', 'o' }, '=ef', function()
      ts_move.goto_next_end('@function.outer', 'textobjects')
      vim.cmd.normal({ args = { 'zz' }, bang = true })
    end, { desc = 'Go to next function end' })

    vim.keymap.set({ 'n', 'x', 'o' }, '=ep', function()
      ts_move.goto_next_end('@parameter.inner', 'textobjects')
      vim.cmd.normal({ args = { 'zz' }, bang = true })
    end, { desc = 'Go to next parameter end' })

    -- Move: goto_previous_start
    vim.keymap.set({ 'n', 'x', 'o' }, ')f', function()
      ts_move.goto_previous_start('@function.outer', 'textobjects')
      vim.cmd.normal({ args = { 'zz' }, bang = true })
    end, { desc = 'Go to previous function start' })

    vim.keymap.set({ 'n', 'x', 'o' }, ')if', function()
      ts_move.goto_previous_start('@function.inner', 'textobjects')
      vim.cmd.normal({ args = { 'zz' }, bang = true })
    end, { desc = 'Go to previous inner function start' })

    vim.keymap.set({ 'n', 'x', 'o' }, ')p', function()
      ts_move.goto_previous_start('@parameter.inner', 'textobjects')
      vim.cmd.normal({ args = { 'zz' }, bang = true })
    end, { desc = 'Go to previous parameter' })

    vim.keymap.set({ 'n', 'x', 'o' }, ')l', function()
      ts_move.goto_previous_start('@loop.*', 'textobjects')
      vim.cmd.normal({ args = { 'zz' }, bang = true })
    end, { desc = 'Go to previous loop' })

    vim.keymap.set({ 'n', 'x', 'o' }, ')c', function()
      ts_move.goto_previous_start('@call.outer', 'textobjects')
      vim.cmd.normal({ args = { 'zz' }, bang = true })
    end, { desc = 'Go to previous call' })

    -- Move: goto_previous_end
    vim.keymap.set({ 'n', 'x', 'o' }, ')ef', function()
      ts_move.goto_previous_end('@function.outer', 'textobjects')
      vim.cmd.normal({ args = { 'zz' }, bang = true })
    end, { desc = 'Go to previous function end' })

    vim.keymap.set({ 'n', 'x', 'o' }, ')ep', function()
      ts_move.goto_previous_end('@parameter.inner', 'textobjects')
      vim.cmd.normal({ args = { 'zz' }, bang = true })
    end, { desc = 'Go to previous parameter end' })

    vim.keymap.set({ 'n', 'x', 'o' }, ')el', function()
      ts_move.goto_previous_end('@loop.*', 'textobjects')
      vim.cmd.normal({ args = { 'zz' }, bang = true })
    end, { desc = 'Go to previous loop end' })

    -- Move: goto_next/goto_previous
    vim.keymap.set({ 'n', 'x', 'o' }, ']d', function()
      ts_move.goto_next('@conditional.outer', 'textobjects')
      vim.cmd.normal({ args = { 'zz' }, bang = true })
    end, { desc = 'Go to next conditional' })

    vim.keymap.set({ 'n', 'x', 'o' }, '[d', function()
      ts_move.goto_previous('@conditional.outer', 'textobjects')
      vim.cmd.normal({ args = { 'zz' }, bang = true })
    end, { desc = 'Go to previous conditional' })
  end,
}
