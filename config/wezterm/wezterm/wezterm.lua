local wezterm = require('wezterm')

local config = wezterm.config_builder()

--config.color_scheme = 'Darcula (base16)'
config.font = wezterm.font('JetBrains Mono', {weight = 'Medium'})
config.font_size = 10.0
config.dpi = 96.0
config.scrollback_lines = 4096
config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true
config.default_cursor_style = 'SteadyUnderline'
config.window_padding = {
    left = 20,
    right = 20,
    top = 20,
    bottom = 20,
}
config.disable_default_key_bindings = true 
config.keys = {
    {
        key = 'c',
        mods = 'CTRL|SHIFT',
        action = wezterm.action.CopyTo('Clipboard'),
    },
    {
        key = 'v',
        mods = 'CTRL|SHIFT',
        action = wezterm.action.PasteFrom('Clipboard'),
    },
    {
        key = '=',
        mods = 'CTRL',
        action = wezterm.action.IncreaseFontSize,
    },
    {
        key = '-',
        mods = 'CTRL',
        action = wezterm.action.DecreaseFontSize,
    },
    {
        key = '0',
        mods = 'CTRL',
        action = wezterm.action.ResetFontSize,
    },
}
config.colors = {
    foreground = '#bbbbbb',
    background = '#2b2b2b',

    selection_fg = '#2b2b2b',
    selection_bg = '#44aa99',

    ansi = {
        '#2b2b2b',
        '#bb5566',
        '#228833',
        '#ccbb44',
        '#4477aa',
        '#aa3377',
        '#66ccee',
        '#bbbbbb',
    },
    brights = {
        '#3c3c3c',
        '#cc6677',
        '#228833',
        '#ccbb44',
        '#4477aa',
        '#aa4499',
        '#66ccee',
        '#dddddd',
    },
}

return config
