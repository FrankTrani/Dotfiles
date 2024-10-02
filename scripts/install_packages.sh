#!/usr/bin/env bash

base_dir="$(dirname $0)"

json_file="$base_dir/packages.json"

if ! command -v jq &> /dev/null; then
  echo "jq is not installed. Installing now..."
  sudo pacman -S --needed jq
fi

if [[ ! -f "$json_file" ]]; then
  echo "The JSON file does not exist: $json_file"
  exit 1
fi

# Install pacman packages
pacman_packages=$(jq -r '.pacman_packages[]' "$json_file")

echo "Installing pacman packages..."
sudo pacman -S --needed $pacman_packages

# Check if yay is installed
if ! command -v yay &> /dev/null; then
  echo "Yay is not installed. Installing now..."
  sudo pacman -S --needed git base-devel
  git clone https://aur.archlinux.org/yay.git ~/yay
  cd ~/yay
  makepkg -si
  cd ..
fi

# Install AUR packages
aur_packages=$(jq -r '.aur_packages[]' "$json_file")

echo "Installing AUR packages with yay..."
yay -S --needed $aur_packages

echo "Package installation complete."
