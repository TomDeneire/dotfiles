local wezterm = require 'wezterm'
local mux = wezterm.mux

local config = {}

config.font = wezterm.font('monospace')
config.line_height = 1.1
config.window_decorations = "RESIZE"
config.window_padding = {
    left = "21%",
    right = 0,
    top = 0,
    bottom = 0
}

config.enable_tab_bar = false

config.font_size = 22.5

config.front_end = "WebGpu"
config.webgpu_force_fallback_adapter = false


config.colors = {
    -- The default text color
    foreground = '#d4d4d4',
    -- The default background color
    background = '#303030',


    -- -- Overrides the cell background color when the current cell is occupied by the
    -- -- cursor and the cursor style is set to Block
    cursor_bg = '#d4d4d4',
    -- -- Overrides the text color when the current cell is occupied by the cursor
    cursor_fg = 'black',
    -- -- Specifies the border color of the cursor when the cursor style is set to Block,
    -- -- or the color of the vertical or horizontal bar when the cursor style is set to
    -- -- Bar or Underline.
    -- cursor_border = '#52ad70',
    --
    -- -- the foreground color of selected text
    selection_fg = '#d4d4d4',
    -- -- the background color of selected text
    selection_bg = 'red',
    --
    -- -- The color of the scrollbar "thumb"; the portion that represents the current viewport
    -- scrollbar_thumb = '#222222',
    --
    -- -- The color of the split lines between panes
    -- split = '#444444',
    ansi = {
        '#000000',
        '#f44747',
        '#99c794',
        '#fac863',
        '#569cd6',
        '#c594c5',
        '#62b3b2',
        '#dddddd',
    },
    brights = {
        '#767676',
        '#f44747',
        '#99c794',
        '#fac863',
        '#7bbad8',
        '#c594c5',
        '#62b3b2',
        '#ffffff',
    },
    --
    -- -- Arbitrary colors of the palette in the range from 16 to 255
    -- indexed = { [136] = '#af8700' },
    --
    -- -- Since: 20220319-142410-0fcdea07
    -- -- When the IME, a dead key or a leader key are being processed and are effectively
    -- -- holding input pending the result of input composition, change the cursor
    -- -- to this color to give a visual cue about the compose state.
    -- compose_cursor = 'orange',
    --
    -- -- Colors for copy_mode and quick_select
    -- -- available since: 20220807-113146-c2fee766
    -- -- In copy_mode, the color of the active text is:
    -- -- 1. copy_mode_active_highlight_* if additional text was selected using the mouse
    -- -- 2. selection_* otherwise
    -- copy_mode_active_highlight_bg = { Color = '#000000' },
    -- -- use `AnsiColor` to specify one of the ansi color palette values
    -- -- (index 0-15) using one of the names "Black", "Maroon", "Green",
    -- --  "Olive", "Navy", "Purple", "Teal", "Silver", "Grey", "Red", "Lime",
    -- -- "Yellow", "Blue", "Fuchsia", "Aqua" or "White".
    -- copy_mode_active_highlight_fg = { AnsiColor = 'Black' },
    -- copy_mode_inactive_highlight_bg = { Color = '#52ad70' },
    -- copy_mode_inactive_highlight_fg = { AnsiColor = 'White' },
    --
    -- quick_select_label_bg = { Color = 'peru' },
    -- quick_select_label_fg = { Color = '#ffffff' },
    -- quick_select_match_bg = { AnsiColor = 'Navy' },
    -- quick_select_match_fg = { Color = '#ffffff' },
}



-- wezterm.on("startup", function()
--     local tab, pane, window = mux.spawn_window(cmd or {})
--     window:gui_window():toggle_fullscreen()
-- end)

return config
