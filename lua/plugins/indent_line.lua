return {
    'lukas-reineke/indent-blankline.nvim',
    config = function()
        require('ibl').setup({
            whitespace = {
                remove_blankline_trail = false,
            },
            scope = { enabled = true, show_start = false, show_end = false, show_exact_scope = true, highlight = 'Character' },
            exclude = { filetypes = { 'dashboard' } },
            indent = { highlight = 'Comment', char = '│' },
        })
    end
}
