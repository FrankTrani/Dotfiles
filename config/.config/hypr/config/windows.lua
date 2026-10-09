-- Window rules

-- Picture-in-picture windows
hl.window_rule({
    name = "picture-in-picture",
    match = {
        title = "Picture-in-Picture",
    },

    float = true,
    pin = true,
})