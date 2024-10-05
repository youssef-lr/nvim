if vim.g.neovide then
    vim.g.neovide_input_use_logo = 1
    vim.o.guifont = "SauceCodePro Nerd Font Mono:h13.6:w-1.5"
    vim.g.neovide_floating_shadow = false
    vim.g.neovide_window_blurred = true
    vim.g.neovide_floating_z_height = 10
    vim.g.neovide_light_angle_degrees = 45
    vim.g.neovide_light_radius = 20
    vim.g.neovide_padding_left = 5
    vim.g.neovide_input_macos_option_key_is_meta = 'only_left'
    vim.g.neovide_refresh_rate = 120
    vim.g.neovide_no_idle = true

    vim.g.neovide_scale_factor = 1.0
    local change_scale_factor = function(delta)
        vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
    end
    vim.keymap.set({ "n", "i", "v", "s", "t" }, "<D-+>", function()
        change_scale_factor(1.1)
    end)
    vim.keymap.set({ "n", "i", "v", "s", "t" }, "<D-°>", function()
        change_scale_factor(1 / 1.1)
    end)
    vim.keymap.set({ "n", "i", "v", "s", "t" }, "<D-0>", function()
        vim.g.neovide_scale_factor = 1.0
    end)

    vim.g.neovide_cursor_animation_length = 0.02
    vim.g.neovide_cursor_animate_in_insert_mode = true
    vim.g.neovide_cursor_animate_command_line = true

    vim.g.neovide_cursor_trail_size = 0

    local scrollAnimationFarLines = 0.1
    local scrollAnimationLength = 0.1
    vim.g.neovide_scroll_animation_far_lines = scrollAnimationFarLines
    vim.g.neovide_scroll_animation_length = scrollAnimationLength

    vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "*",
        callback = function(args)
            -- Get the buffer number that triggered the autocommand
            local bufnr = args.buf

            -- Get the file type of the buffer
            local filetype = vim.api.nvim_buf_get_option(bufnr, "filetype")

            if filetype == '' or filetype == 'terminal' then
                vim.g.neovide_scroll_animation_far_lines = 0
                vim.g.neovide_scroll_animation_length = 0
            else
                vim.g.neovide_scroll_animation_far_lines = scrollAnimationFarLines
                vim.g.neovide_scroll_animation_length = scrollAnimationLength
            end
        end,
    })
    vim.g.neovide_position_animation_length = 0
end
