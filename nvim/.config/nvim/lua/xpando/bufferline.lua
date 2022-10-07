require('bufferline').setup {
    options = {
        mode = "buffers",
        numbers = false,
        middle_mouse_command = nil,
        color_icons = true,
        show_buffer_icons = true,
        show_buffer_close_icons = false,
        show_buffer_default_icon = true,
        show_close_icon = false,
        show_tab_indicators = true,
        persist_buffer_sort = true,
        separator_style = "slant",
        enforce_regular_tabs = true,
        always_show_bufferline = true,
        sort_by = 'insert_at_end',
        max_name_length = 18,
        max_prefix_length = 15, -- prefix used when a buffer is de-duplicated
        tab_size = 18,
        offsets = {{
            filetype = "NvimTree",
            text = "File Explorer",
            text_align = "center"
        }}
    }
}
