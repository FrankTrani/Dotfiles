#!/usr/bin/env bash

# Check if JetBrainsMono Nerd Font is installed
if ! fc-list | grep -qi "JetBrainsMono Nerd Font"; then
    echo "JetBrainsMono Nerd Font is not installed. Please install it first."
    exit 1
fi

echo "Setting JetBrainsMono Nerd Font as the default font for all applications..."

# Sway configuration
sway_config_dir="$HOME/.config/sway"
if [[ -d "$sway_config_dir" ]]; then
    echo "Setting font for Sway..."
    echo 'font pango:JetBrainsMono Nerd Font 12' >> "$sway_config_dir/config"
fi

# Kitty configuration
kitty_config_dir="$HOME/.config/kitty"
if [[ -d "$kitty_config_dir" ]]; then
    echo "Setting font for Kitty..."
    echo "font_family JetBrainsMono Nerd Font" >> "$kitty_config_dir/kitty.conf"
else
    mkdir -p "$kitty_config_dir"
    echo "font_family JetBrainsMono Nerd Font" >> "$kitty_config_dir/kitty.conf"
fi

# Waybar configuration
waybar_config_dir="$HOME/.config/waybar"
if [[ -d "$waybar_config_dir" ]]; then
    echo "Setting font for Waybar..."
    sed -i '/"font-family":/c\  "font-family": "JetBrainsMono Nerd Font", "monospace";' "$waybar_config_dir/style.css"
else
    mkdir -p "$waybar_config_dir"
    echo '{
    "font-family": "JetBrainsMono Nerd Font", "monospace"
}' > "$waybar_config_dir/style.css"
fi

# Rofi configuration
rofi_config_dir="$HOME/.config/rofi"
if [[ -d "$rofi_config_dir" ]]; then
    echo "Setting font for Rofi..."
    echo "rofi.font: JetBrainsMono Nerd Font 12" >> "$rofi_config_dir/config.rasi"
else
    mkdir -p "$rofi_config_dir"
    echo "rofi.font: JetBrainsMono Nerd Font 12" >> "$rofi_config_dir/config.rasi"
fi

# Neovim configuration (assuming GUI is used, like Neovide or nvim-qt)
nvim_config_dir="$HOME/.config/nvim"
if [[ -d "$nvim_config_dir" ]]; then
    echo "Setting font for Neovim..."
    echo "set guifont=JetBrainsMono\\ Nerd\\ Font:h12" >> "$nvim_config_dir/init.vim"
else
    mkdir -p "$nvim_config_dir"
    echo "set guifont=JetBrainsMono\\ Nerd\\ Font:h12" >> "$nvim_config_dir/init.vim"
fi

# Dunst configuration
dunst_config_dir="$HOME/.config/dunst"
if [[ -d "$dunst_config_dir" ]]; then
    echo "Setting font for Dunst..."
    sed -i '/font =/c\font = JetBrainsMono Nerd Font 12' "$dunst_config_dir/dunstrc"
else
    mkdir -p "$dunst_config_dir"
    echo 'font = JetBrainsMono Nerd Font 12' > "$dunst_config_dir/dunstrc"
fi

# Zsh prompt with Starship configuration
starship_config_file="$HOME/.config/starship.toml"
if [[ -f "$starship_config_file" ]]; then
    echo "Configuring Starship prompt to use JetBrainsMono Nerd Font..."
else
    echo 'Creating Starship configuration file...'
    mkdir -p "$HOME/.config"
    echo '[character]
symbol = "❯"
' > "$starship_config_file"
fi


echo "JetBrainsMono Nerd Font has been set as the default font for all configured applications."
