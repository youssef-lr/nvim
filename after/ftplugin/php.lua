function fixPHP()
    -- Save current 'shortmess' setting
    local original_shortmess = vim.opt.shortmess:get()

    -- Temporarily add 'F' to suppress file write message
    vim.opt.shortmess:append('F')

    -- Save the file without any message
    vim.cmd("silent! w")

    -- Restore the original 'shortmess' setting
    vim.opt.shortmess = original_shortmess

    vim.fn.PhpCsFixerFixFile()
end

vim.keymap.set('n', '<leader><leader>f', fixPHP, { noremap = true })
