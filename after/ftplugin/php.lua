vim.g.php_cs_fixer_config_file = '/Users/youssef/Expensidev/PHP-Libs/.php-cs-fixer.php' -- options: --config
vim.g.php_cs_fixer_allow_risky = 'yes'                                                  -- options: --allow-risky

local function fixPHP()
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

vim.api.nvim_buf_set_keymap(0, 'i', '-', '->', { noremap = true })
vim.api.nvim_buf_set_keymap(0, 'i', 'ù', '->', { noremap = true })
