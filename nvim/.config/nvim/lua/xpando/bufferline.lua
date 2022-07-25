require('bufferline').setup {
    options = {
        mode = "buffers", -- set to "tabs" to only show tabpages instead
        numbers = false,
        close_command = "bdelete! %d",       -- can be a string | function, see "Mouse actions"
        right_mouse_command = "bdelete! %d", -- can be a string | function, see "Mouse actions"
        left_mouse_command = "buffer %d",    -- can be a string | function, see "Mouse actions"
        middle_mouse_command = nil,          -- can be a string | function, see "Mouse actions"
        color_icons = true,                  -- whether or not to add the filetype icon highlights
        show_buffer_icons = true,            -- disable filetype icons for buffers
        show_buffer_close_icons = false,
        show_buffer_default_icon = true,     -- whether or not an unrecognised filetype should show a default icon
        show_close_icon = false,
        show_tab_indicators = true,
        persist_buffer_sort = true,          -- whether or not custom sorted buffers should persist
        separator_style = "slant",
        enforce_regular_tabs = true,
        always_show_bufferline = true,
        sort_by = 'insert_at_end',
        offsets = {
            {
                filetype = "NvimTree",
                text = "File Explorer",
                text_align = "left"
            }
        },
    }
}
