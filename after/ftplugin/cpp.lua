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

-- function GoToTestFile()
--     -- Get the current file name and directory
--     local current_file_name = vim.fn.expand('%:t')  -- File name only
--     local current_file_dir = vim.fn.expand('%:p:h') -- Directory
--
--     -- Check if the current file is a .cpp file
--     if string.endswith(current_file_name, '.cpp') then
--         -- Remove the .cpp extension and append "Test.cpp"
--         local test_file_name = current_file_name:gsub('%.cpp$', 'Test.cpp')
--         local test_file_path = current_file_dir .. '/' .. test_file_name
--
--         -- Check if the test file exists
--         if vim.fn.filereadable(test_file_path) == 1 then
--             -- Open the test file
--             vim.cmd('edit ' .. test_file_path)
--         else
--             print('Test file does not exist: ' .. test_file_path)
--         end
--     else
--         print('Current file is not a .cpp file.')
--     end
-- end


local function toggle_command_test()
    local current_file = vim.api.nvim_buf_get_name(0)
    local git_root = vim.fn.systemlist('git rev-parse --show-toplevel')[1]

    -- Normalize slashes just in case
    current_file = current_file:gsub('\\', '/')

    local command_dir = '/auth/command/'
    local test_dir = '/test/test/command/'

    if current_file:find(command_dir) then
        -- You're in a command file, go to the test
        local name = current_file:match('.*/auth/command/(.+)%.cpp$')
        if not name then
            print("Couldn't extract command name.")
            return
        end
        local target = git_root .. test_dir .. name .. 'Test.cpp'
        vim.cmd('edit ' .. target)
    elseif current_file:find(test_dir) then
        -- You're in a test file, go to the command
        local name = current_file:match('.*/test/test/command/(.+)Test%.cpp$')
        if not name then
            print("Couldn't extract test name.")
            return
        end
        local target = git_root .. command_dir .. name .. '.cpp'
        vim.cmd('edit ' .. target)
    else
        print('Not in a command or test file.')
    end
end

vim.keymap.set('n', '<M-t>', toggle_command_test, { noremap = true, silent = true })
