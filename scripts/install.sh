#!/usr/bin/env bash

base_dir="$(realpath "$(dirname $0)/..")"

# Check for and intall yay
if ! command -v yay &> /dev/null
then
  echo "Yay is not installed. Installing now..."
  sudo pacman -S --needed git base-devel
  git clone https://aur.archlinux.org/yay.git ~/yay
  cd ~/yay
  makepkg -si
else
  echo "Yay is already installed. Skipping installation."
fi

# Install packages
source "$base_dir/scripts/install_packages.sh"


# Stow files
cd "$base_dir/config"
stow -v -t ~ .