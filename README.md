🚀 Astra's Dotfiles

Welcome to my Dotfiles repository! This is where I store the configuration files and scripts that shape my personalized Linux environment, optimized for Wayland with Sway and various custom setups. Feel free to explore, adapt, and contribute!
🛠️ Setup

These Dotfiles are managed using GNU Stow to keep everything modular and organized. To install, clone this repository and use stow to create symlinks for the configurations you need.
Prerequisites

Make sure you have stow installed:

bash

sudo pacman -S stow

Installation

    Clone the repository to your home directory:

    bash

git clone https://github.com/yourusername/dotfiles.git ~/dotfiles
cd ~/dotfiles

Stow the configuration you want. For example, to set up the Sway configuration:

bash

stow -t ~ sway

Repeat for other tools, like:

bash

    stow -t ~ kitty
    stow -t ~ rofi
    stow -t ~ fastfetch

📁 What's Inside

Here’s a breakdown of some of the key components:

    Sway: My Sway configuration for a tiling window manager on Wayland.
    Kitty: A fast, feature-rich terminal emulator, with a customized theme.
    Fastfetch: Fetch-like system info displayed in my terminal prompt.
    Rofi: A launcher with a custom power menu and application switcher.

And much more... Check the individual folders for additional configurations.
🧩 Features

    Modular Configurations: All configs are organized into separate folders and can be applied independently.
    Custom Themes: I've included several custom themes, including terminal and Waybar styles, to make my setup visually cohesive.
    Powerful Scripts: A set of handy shell scripts to streamline workflows (like power management, Wi-Fi menus, and more).

🔧 Customizations

I use these configurations on an Arch Linux setup with Wayland and Sway. Many scripts and configurations assume this environment, but they can be adapted to other setups if needed.

Here are some of the tools I'm using:

    Waybar: My custom status bar configuration.
    Rofi: A customized Rofi with a power menu and extended options.
    Sway: Lightweight, tiling window manager on Wayland.
    Mako: For managing notifications (since I've switched from swaync).

🤝 Contributing

Feel free to open an issue or submit a pull request if you’d like to improve or share ideas for my Dotfiles.
📜 License

This project is open-source and available under the MIT License.