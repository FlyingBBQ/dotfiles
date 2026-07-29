---@module 'hl'

hl.monitor({
    output    = "HDMI-A-1",
    mode      = "1920x1080",
    position  = "0x0",
    transform = 1,
    scale     = 1,
})
hl.monitor({
    output   = "DP-1",
    mode     = "2560x1440",
    position = "1080x0",
    scale    = 1,
})

hl.config({
    input = {
        kb_layout = "us",
        follow_mouse = 1,
        touchpad = {
            natural_scroll = false,
        },
        sensitivity = -0.95,
        -- -1.0 - 1.0, 0 means no modification.
    },
    general = {
        gaps_in = 8,
        gaps_out = 16,
        border_size = 2,
        layout = "master",
        col = {
            active_border = "rgba(C9a554ff)",
            inactive_border = "rgba(222222ff)",
        },
    },
    decoration = {
        rounding = 2,
        blur = {
            enabled = false,
        },
    },
    animations = {
        enabled = true,
    },
    master = {
        new_status = "slave",
        new_on_top = true,
    },
    misc = {
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
        background_color = "rgba(484944ff)",
        animate_manual_resizes = true,
    },
    ecosystem = {
        no_donation_nag = true,
    },
    cursor = {
        no_hardware_cursors = 1,
    },
    binds = {
        allow_workspace_cycles = true,
    },
})

-- Workspaces

hl.workspace_rule({ workspace = 1, monitor = "DP-1", default = true, })
hl.workspace_rule({ workspace = 2, monitor = "DP-1", })
hl.workspace_rule({ workspace = 3, monitor = "HDMI-A-1", default = true, })
hl.workspace_rule({ workspace = 4, monitor = "HDMI-A-1", })
hl.workspace_rule({ workspace = 5, monitor = "DP-1", })

-- Windows [hyprctl clients]

hl.window_rule({ match = { class = "Spotify", }, workspace = 3, })
hl.window_rule({ match = { class = "discord", }, workspace = 4, })
hl.window_rule({ match = { class = "org.mozilla.Thunderbird", }, workspace = 5, })
hl.window_rule({
    name = "move-easy-effects",
    match = {
        class = "com.github.wwmm.easyeffects",
    },
    workspace = 9,
    float = true,
    -- size = 50% 40%,
    -- center = true,
})
hl.window_rule({
    name  = "ueberzugpp",
    match = {
        class = "ueberzugpp.*",
    },
    float = true,
    no_focus = true,
    no_anim = true,
})

-- Keybindings

local mainMod = "SUPER"
hl.bind(mainMod .. " + SHIFT + escape", hl.dsp.exit())

hl.bind(mainMod .. " + return", hl.dsp.exec_cmd("alacritty"))
hl.bind(mainMod .. " + F10",    hl.dsp.exec_cmd("waylock.sh"))
hl.bind(mainMod .. " + D",      hl.dsp.exec_cmd("fuzzel"))
hl.bind(mainMod .. " + F",      hl.dsp.layout("swapwithmaster"))
hl.bind(mainMod .. " + tab",    hl.dsp.focus({ monitor = "+1" }))
hl.bind(mainMod .. " + W",      hl.dsp.focus({ workspace = "+1" }))
hl.bind(mainMod .. " + Z",      hl.dsp.focus({ workspace = "-1" }))
hl.bind(mainMod .. " + X",      hl.dsp.focus({ workspace = "+1" }))
hl.bind(mainMod .. " + grave",  hl.dsp.focus({ workspace = "previous" }))
hl.bind(mainMod .. " + S",      hl.dsp.focus({ workspace = "previous" }))
hl.bind(mainMod .. " + Q",      hl.dsp.window.close())
hl.bind(mainMod .. " + space",  hl.dsp.window.float())
hl.bind(mainMod .. " + M",      hl.dsp.window.fullscreen())

-- Move focus with mainMod + arrow keys

hl.bind(mainMod .. " + K", hl.dsp.layout("cycleprev"))
hl.bind(mainMod .. " + J", hl.dsp.layout("cyclenext"))
hl.bind(mainMod .. " + H", hl.dsp.window.resize({ x = -100, y = 0, relative = true}), { repeating = true })
hl.bind(mainMod .. " + L", hl.dsp.window.resize({ x = 100, y = 0, relative = true}), { repeating = true })
hl.bind(mainMod .. " + SHIFT + H", hl.dsp.layout("orientationtop"))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.layout("orientationleft"))

-- Switch workspaces with mainMod + [0-9]

hl.bind(mainMod .. " + " .. 1, hl.dsp.focus({ workspace = 1 }))
hl.bind(mainMod .. " + " .. 2, hl.dsp.focus({ workspace = 2 }))
hl.bind(mainMod .. " + " .. 3, hl.dsp.focus({ workspace = 3 }))
hl.bind(mainMod .. " + " .. 4, hl.dsp.focus({ workspace = 4 }))
hl.bind(mainMod .. " + " .. 5, hl.dsp.focus({ workspace = 5 }))
hl.bind(mainMod .. " + " .. 6, hl.dsp.focus({ workspace = 6 }))
hl.bind(mainMod .. " + " .. 7, hl.dsp.focus({ workspace = 7 }))
hl.bind(mainMod .. " + " .. 8, hl.dsp.focus({ workspace = 8 }))
hl.bind(mainMod .. " + " .. 9, hl.dsp.focus({ workspace = 9 }))
hl.bind(mainMod .. " + " .. 0, hl.dsp.focus({ workspace = 10 }))

-- Move active window to a workspace with mainMod + SHIFT + [0-9]

hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. 1, hl.dsp.window.move({ workspace = 1 }))
hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. 2, hl.dsp.window.move({ workspace = 2 }))
hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. 3, hl.dsp.window.move({ workspace = 3 }))
hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. 4, hl.dsp.window.move({ workspace = 4 }))
hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. 5, hl.dsp.window.move({ workspace = 5 }))
hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. 6, hl.dsp.window.move({ workspace = 6 }))
hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. 7, hl.dsp.window.move({ workspace = 7 }))
hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. 8, hl.dsp.window.move({ workspace = 8 }))
hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. 9, hl.dsp.window.move({ workspace = 9 }))
hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. 0, hl.dsp.window.move({ workspace = 10 }))

-- Scroll through existing workspaces with mainMod + scroll

hl.bind(mainMod .. " + " .. "mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + " .. "mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging

hl.bind(mainMod .. " + " .. "mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + " .. "mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Media keys

hl.bind("xf86audioplay", hl.dsp.exec_cmd("playerctl --player=spotify play-pause"))
hl.bind("xf86audionext", hl.dsp.exec_cmd("playerctl --player=spotify next"))
hl.bind("xf86audioprev", hl.dsp.exec_cmd("playerctl --player=spotify previous"))

-- Autostart
hl.on("hyprland.start", function()
    hl.exec_cmd("waybar")
    hl.exec_cmd("gammastep -l 52.092:5.104 -t 6000:4000")
end)
