local function quit()
    local bufnr = vim.api.nvim_get_current_buf()
    if vim.bo[bufnr].modifiable then
        vim.cmd('wq')
    else
        vim.cmd('q!')
    end

    vim.defer_fn(function()
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if vim.bo[buf].filetype == 'git' then
                vim.api.nvim_buf_delete(buf, { force = true })
            end
        end
    end, 10)
end

vim.keymap.set('n', '<M-q>', quit, { noremap = true, buffer = 0 })
