#!/bin/bash

BAT=$(find /sys/class/power_supply -maxdepth 1 -name 'BAT*' | head -n1)

if [[ -n "$BAT" && -f "$BAT/power_now" ]]; then
    watts=$(<"$BAT/power_now")
    watts=$((watts / 1000000))

    printf '{"text":"󰠰 %sW","tooltip":"Power draw: %sW"}\n' \
        "$watts" "$watts"
else
    printf '{"text":"","tooltip":"Power draw unavailable"}\n'
fi