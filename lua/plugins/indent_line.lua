return {
    { -- Add indentation guides even on blank lines
        'lukas-reineke/indent-blankline.nvim',
        -- Enable `lukas-reineke/indent-blankline.nvim`
        -- See `:help ibl`
        main = 'ibl',
        opts = {
            whitespace = {
                remove_blankline_trail = false,
            },
            scope = { show_start = false, show_end = false, show_exact_scope = true },
            exclude = { filetypes = { 'dashboard' } }
        },
    },
}
