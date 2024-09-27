vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "fugitive",
    command = "normal! <ESC>"
})
