#!/usr/bin/env bash
set -euo pipefail

# Repo root = one level above this script
base_dir="$(cd -- "$(dirname -- "$0")/.." && pwd -P)"

# Ensure stow exists
if ! command -v stow &>/dev/null; then
  echo "[stow] Installing..."
  sudo pacman -S --needed --noconfirm stow
fi

# Make sure ~/.config exists
mkdir -p "$HOME/.config"

# Pre-clean: remove any blocking targets inside ~/.config that match your package contents
cfg_src="$base_dir/config/.config"
if [[ -d "$cfg_src" ]]; then
  shopt -s nullglob dotglob
  for item in "$cfg_src"/*; do
    name="$(basename -- "$item")"
    target="$HOME/.config/$name"
    if [[ -e "$target" && ! -L "$target" ]]; then
      echo "[stow] Removing existing target (not a symlink): $target"
      rm -rf -- "$target"
    fi
  done
  shopt -u nullglob dotglob
fi

# Stow the 'config' package into $HOME so it creates ~/.config/...
cd "$base_dir"
stow -v -t "$HOME" -R config

echo "Done. Linked $(basename "$base_dir")/config/.config/* -> $HOME/.config/*"
