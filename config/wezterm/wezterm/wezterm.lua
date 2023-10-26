local wezterm = require('wezterm')

local config = wezterm.config_builder()

config.color_scheme = 'Darcula (base16)'
config.font = wezterm.font('JetBrains Mono', {weight = 'Medium'})
config.font_size = 10.0
config.dpi = 96.0
config.scrollback_lines = 4096
config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true
config.window_padding = {
    left = 20,
    right = 20,
    top = 20,
    bottom = 20,
}
config.default_cursor_style = 'SteadyUnderline'

return config
