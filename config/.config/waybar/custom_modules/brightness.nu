#!/usr/bin/env nu

let current_brightness = (brightnessctl g | into int)
let max_brightness = (brightnessctl m | into int)

let brightness_percentage = ($current_brightness * 100 / $max_brightness | into int)

echo $brightness_percentage



