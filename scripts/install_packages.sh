#!/usr/bin/env bash
set -euo pipefail

# Resolve base directory (the parent of where this script lives)
base_dir="$(cd -- "$(dirname -- "$0")/.." && pwd -P)"
json_file="$base_dir/scripts/packages.json"

# Ensure jq is installed (used for JSON parsing)
if ! command -v jq &>/dev/null; then
  echo "jq not found. Installing..."
  sudo pacman -S --needed --noconfirm jq
fi

# Check for JSON file
if [[ ! -f "$json_file" ]]; then
  echo "Error: JSON file not found: $json_file"
  exit 1
fi

# --- Install Pacman packages ---
echo "Installing Pacman packages..."
pacman_packages=$(jq -r '.pacman_packages[]' "$json_file")

if [[ -n "$pacman_packages" ]]; then
  sudo pacman -S --needed --noconfirm $pacman_packages
else
  echo "No Pacman packages found in JSON."
fi

# --- Ensure yay is installed ---
if ! command -v yay &>/dev/null; then
  echo "Yay not found. Installing from AUR..."
  sudo pacman -S --needed --noconfirm git base-devel
  tmp_dir=$(mktemp -d)
  git clone https://aur.archlinux.org/yay.git "$tmp_dir/yay"
  (
    cd "$tmp_dir/yay"
    makepkg -si --noconfirm
  )
  rm -rf "$tmp_dir"
fi

# --- Install AUR packages ---
echo "Installing AUR packages with yay..."
aur_packages=$(jq -r '.aur_packages[]' "$json_file")

if [[ -n "$aur_packages" ]]; then
  yay -S --needed --noconfirm $aur_packages
else
  echo "No AUR packages found in JSON."
fi

echo "All packages installed successfully."
