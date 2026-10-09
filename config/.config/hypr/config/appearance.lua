-- General layout and appearance

hl.config({
    general = {
        gaps_in = 5,
        gaps_out = 10,

        border_size = 2,

        layout = "dwindle",

        resize_on_border = true,
    },

    decoration = {
        rounding = 10,

        active_opacity = 1.0,
        inactive_opacity = 0.95,

        shadow = {
            enabled = true,
            range = 8,
            render_power = 3,
        },

        blur = {
            enabled = true,
            size = 6,
            passes = 2,
            new_optimizations = true,
        },
    },

    misc = {
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
    },
})