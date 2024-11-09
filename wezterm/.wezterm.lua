local wezterm = require 'wezterm'
local mux = wezterm.mux

local config = {}

local function external_monitor()
    local cmd = "xdpyinfo | grep dimensions | awk '{print $2}'"
    local handle = io.popen(cmd)
    if not handle then
        return false
    end
    local output = handle:read('*a')
    local resolution = output:gsub('[\n\r]', '')
    handle:close()
    if resolution == "1920x1080" then
        return "monitor"
    else
        return "laptop"
    end
end

-- MesloLGL for missing glyphs
config.font = wezterm.font_with_fallback { 'FiraCodeNerdFont', 'MesloLGL' }
-- disable ligatures
-- config.harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' }
config.window_decorations = "RESIZE"
config.window_padding = {
    left = "21%",
    right = "1%",
    top = 10,
    bottom = 5
}

config.enable_tab_bar = false

local font_size = 13.5
local line_height = 1.2

-- if external_monitor() == "monitor" then
--     font_size = 23.5
--     line_height = 1.2
-- end
--
-- if external_monitor() == "tv" then
--     font_size = 15.5
--     line_height = 1.3
-- end

config.font_size = font_size
config.line_height = line_height
config.command_palette_font_size = font_size

-- local gpus = wezterm.gui.enumerate_gpus()
-- config.webgpu_preferred_adapter = gpus[3]
config.front_end = "WebGpu"
config.webgpu_force_fallback_adapter = false
config.webgpu_power_preference = "HighPerformance"

config.color_scheme = 'Gruvbox Dark (Gogh)'

wezterm.on("gui-startup", function()
    local tab, pane, window = mux.spawn_window(cmd or {})
    window:gui_window():maximize()
end)

return config
