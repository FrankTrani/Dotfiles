-- ~/.config/hypr/config/keybinds.lua

local mod = "SUPER"
local term = "kitty"
local menu = "rofi -show drun"

local power_menu =
"/home/astra/Documents/Dotfiles/config/.config/hypr/powermenu.sh"

------------------------------------------------------------
-- Applications / session
------------------------------------------------------------

hl.bind(
    mod .. " + RETURN",
    hl.dsp.exec_cmd(term)
)

hl.bind(
    mod .. " + Q",
    hl.dsp.window.close()
)

hl.bind(
    mod .. " + SHIFT + L",
    hl.dsp.exec_cmd("hyprshutdown")
)

hl.bind(
    mod .. " + X",
    hl.dsp.exec_cmd(menu)
)

hl.bind(
    mod .. " + P",
    hl.dsp.exec_cmd(menu)
)

hl.bind(
    mod .. " + SHIFT + C",
    hl.dsp.exec_cmd("hyprctl reload")
)

hl.bind(
    mod .. " + SHIFT + Escape",
    hl.dsp.exec_cmd(power_menu)
)

------------------------------------------------------------
-- Move windows
------------------------------------------------------------

hl.bind(
    mod .. " + SHIFT + A",
    hl.dsp.window.move({ direction = "l" })
)

hl.bind(
    mod .. " + SHIFT + S",
    hl.dsp.window.move({ direction = "d" })
)

hl.bind(
    mod .. " + SHIFT + W",
    hl.dsp.window.move({ direction = "u" })
)

hl.bind(
    mod .. " + SHIFT + D",
    hl.dsp.window.move({ direction = "r" })
)

------------------------------------------------------------
-- Resize windows
------------------------------------------------------------

hl.bind(
    mod .. " + SHIFT + right",
    hl.dsp.window.resize({
        x = 10,
        y = 0,
        relative = true,
    }),
    { repeating = true }
)

hl.bind(
    mod .. " + SHIFT + left",
    hl.dsp.window.resize({
        x = -10,
        y = 0,
        relative = true,
    }),
    { repeating = true }
)

hl.bind(
    mod .. " + SHIFT + up",
    hl.dsp.window.resize({
        x = 0,
        y = -10,
        relative = true,
    }),
    { repeating = true }
)

hl.bind(
    mod .. " + SHIFT + down",
    hl.dsp.window.resize({
        x = 0,
        y = 10,
        relative = true,
    }),
    { repeating = true }
)

------------------------------------------------------------
-- Workspaces
------------------------------------------------------------

for i = 1, 10 do
    local key = tostring(i % 10)

    -- Switch workspace
    hl.bind(
        mod .. " + " .. key,
        hl.dsp.focus({ workspace = i })
    )

    -- Move active window to workspace
    hl.bind(
        mod .. " + SHIFT + " .. key,
        hl.dsp.window.move({
            workspace = tostring(i),
        })
    )
end

------------------------------------------------------------
-- Layout
------------------------------------------------------------

hl.bind(
    mod .. " + B",
    hl.dsp.layout("togglehorizontal")
)

hl.bind(
    mod .. " + V",
    hl.dsp.layout("togglevertical")
)

hl.bind(
    mod .. " + SHIFT + Y",
    hl.dsp.layout("togglestacking")
)

hl.bind(
    mod .. " + SHIFT + T",
    hl.dsp.layout("toggletabbed")
)

hl.bind(
    mod .. " + E",
    hl.dsp.layout("togglesplit")
)

hl.bind(
    mod .. " + F",
    hl.dsp.window.fullscreen({
        action = "toggle",
        mode = "fullscreen",
    })
)

hl.bind(
    mod .. " + SPACE",
    hl.dsp.window.float({
        action = "toggle",
    })
)

------------------------------------------------------------
-- Resize submap
------------------------------------------------------------

hl.bind(
    mod .. " + R",
    hl.dsp.submap("resize")
)

hl.define_submap("resize", function()
    hl.bind(
        "right",
        hl.dsp.window.resize({
            x = 10,
            y = 0,
            relative = true,
        }),
        { repeating = true }
    )

    hl.bind(
        "left",
        hl.dsp.window.resize({
            x = -10,
            y = 0,
            relative = true,
        }),
        { repeating = true }
    )

    hl.bind(
        "up",
        hl.dsp.window.resize({
            x = 0,
            y = -10,
            relative = true,
        }),
        { repeating = true }
    )

    hl.bind(
        "down",
        hl.dsp.window.resize({
            x = 0,
            y = 10,
            relative = true,
        }),
        { repeating = true }
    )

    hl.bind(
        "RETURN",
        hl.dsp.submap("reset")
    )

    hl.bind(
        "Escape",
        hl.dsp.submap("reset")
    )
end)

------------------------------------------------------------
-- Mouse
------------------------------------------------------------

-- SUPER + left click: move window
hl.bind(
    mod .. " + mouse:272",
    hl.dsp.window.drag(),
    { mouse = true }
)

-- SUPER + right click: resize window
hl.bind(
    mod .. " + mouse:273",
    hl.dsp.window.resize(),
    { mouse = true }
)

------------------------------------------------------------
-- Volume
------------------------------------------------------------

hl.bind(
    "XF86AudioRaiseVolume",
    hl.dsp.exec_cmd("pamixer -i 5"),
    { repeating = true }
)

hl.bind(
    "XF86AudioLowerVolume",
    hl.dsp.exec_cmd("pamixer -d 5"),
    { repeating = true }
)

hl.bind(
    "XF86AudioMute",
    hl.dsp.exec_cmd("pamixer -t")
)

------------------------------------------------------------
-- Brightness
------------------------------------------------------------

hl.bind(
    "XF86MonBrightnessUp",
    hl.dsp.exec_cmd("brightnessctl set +10%"),
    { repeating = true }
)

hl.bind(
    "XF86MonBrightnessDown",
    hl.dsp.exec_cmd("brightnessctl set 10%-"),
    { repeating = true }
)

------------------------------------------------------------
-- Media
------------------------------------------------------------

hl.bind(
    "XF86AudioNext",
    hl.dsp.exec_cmd("playerctl next"),
    { locked = true }
)

hl.bind(
    "XF86AudioPause",
    hl.dsp.exec_cmd("playerctl play-pause"),
    { locked = true }
)

hl.bind(
    "XF86AudioPlay",
    hl.dsp.exec_cmd("playerctl play-pause"),
    { locked = true }
)

hl.bind(
    "XF86AudioPrev",
    hl.dsp.exec_cmd("playerctl previous"),
    { locked = true }
)

------------------------------------------------------------
-- Screenshot / lock
------------------------------------------------------------

hl.bind(
    mod .. " + Print",
    hl.dsp.exec_cmd(
        "/home/astra/.local/bin/screenshot.sh"
    )
)

hl.bind(
    mod .. " + L",
    hl.dsp.exec_cmd("hyprlock")
)

------------------------------------------------------------
-- Lid switch
------------------------------------------------------------

hl.bind(
    "switch:off:Lid Switch",
    hl.dsp.exec_cmd("hyprlock --immediate"),
    { locked = true }
)
