vim.api.nvim_buf_set_keymap(0, 'i', '-', '->', { noremap = true })
vim.api.nvim_buf_set_keymap(0, 'i', 'ù', '->', { noremap = true })

vim.api.nvim_buf_set_keymap(0, 'n', '<M-e>', '<cmd>ClangdSwitchSourceHeader<CR>', { noremap = true })

vim.cmd('setlocal indentkeys-=:')

vim.cmd('iabbr cint const int64_t')
vim.cmd('iabbr cont const')

vim.api.nvim_buf_set_keymap(0, 'n', '<leader><leader>ts', 'ciwto_string(<ESC>pa)',
    { noremap = true, desc = 'wrap variable in to_string' })

-- Helper function to check for string ending
function string.endswith(str, ending)
    return ending == '' or str:sub(- #ending) == ending
end

function GoToTestFile()
    -- Get the current file name and directory
    local current_file_name = vim.fn.expand('%:t')  -- File name only
    local current_file_dir = vim.fn.expand('%:p:h') -- Directory

    -- Check if the current file is a .cpp file
    if string.endswith(current_file_name, '.cpp') then
        -- Remove the .cpp extension and append "Test.cpp"
        local test_file_name = current_file_name:gsub('%.cpp$', 'Test.cpp')
        local test_file_path = current_file_dir .. '/' .. test_file_name

        -- Check if the test file exists
        if vim.fn.filereadable(test_file_path) == 1 then
            -- Open the test file
            vim.cmd('edit ' .. test_file_path)
        else
            print('Test file does not exist: ' .. test_file_path)
        end
    else
        print('Current file is not a .cpp file.')
    end
end
