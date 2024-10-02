# 🚀 My Dotfiles

Welcome to my **Dotfiles** repository! This is where I store the configuration files and scripts that shape my personalized Linux environment, optimized for Wayland with Sway and various custom setups. Feel free to explore, adapt, and contribute!

## 🛠️ Setup

These Dotfiles are managed using **GNU Stow** to keep everything modular and organized. To install, clone this repository and use `stow` to create symlinks for the configurations you need.

### Prerequisites

Make sure you have `stow` installed:

```bash
sudo pacman -S stow
```

### Installation

1. Clone the repository to your home directory:

   ```bash
   git clone https://github.com/FrankTrani/dotfiles.git ~/dotfiles
   cd ~/Dotfiles
   ```

2. Run install command. :

   ```bash
   scripts/run.sh
   ```

## 📁 What's Inside

Here’s a breakdown of some of the key components:

- **Sway**: My Sway configuration for a tiling window manager on Wayland.
- **Kitty**: A fast, feature-rich terminal emulator, with a customized theme.
- **Fastfetch**: Fetch-like system info displayed in my terminal prompt.
- **Rofi**: A launcher with a custom power menu and application switcher.
- **nvim**: My Neovim configuration, a highly customizable, fast, and powerful text editor.
- **dunst**: Lightweight notification daemon. This configuration manages system notifications
- **waybar**: A customizable status bar for Wayland.
- **starship**: A minimal, fast, and highly customizable shell prompt that works in any shell.

## 🧩 Features

- **Modular Configurations**: All configs are organized into separate folders and can be applied independently.
- **Custom Themes**: I've included several custom themes, including terminal and Waybar styles, to make my setup visually cohesive.
- **Powerful Scripts**: A set of handy shell scripts to streamline workflows (like power management, Wi-Fi menus, and more).

## 🤝 Contributing

Feel free to open an issue or submit a pull request if you’d like to improve or share ideas for my Dotfiles.

## 📜 License

This project is open-source and available under the [MIT License](LICENSE).
