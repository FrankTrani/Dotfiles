#!/usr/bin/env bash
set -euo pipefail

# Resolve repo root (one level above this script)
base_dir="$(cd -- "$(dirname -- "$0")/.." && pwd -P)"

# ---- Ensure yay ----
if ! command -v yay &>/dev/null; then
  echo "[yay] Installing..."
  sudo pacman -S --needed --noconfirm git base-devel
  tmp_dir="$(mktemp -d)"
  git clone https://aur.archlinux.org/yay.git "$tmp_dir/yay"
  ( cd "$tmp_dir/yay" && makepkg -si --noconfirm )
  rm -rf "$tmp_dir"
else
  echo "[yay] Already installed."
fi

# ---- Install packages (your script) ----
if [[ -f "$base_dir/scripts/install_packages.sh" ]]; then
  # shellcheck source=/dev/null
  source "$base_dir/scripts/install_packages.sh"
else
  echo "WARN: $base_dir/scripts/install_packages.sh not found; skipping package install."
fi

# ---- Stow dotfiles into ~/.config ----
target="$HOME/.config"
mkdir -p "$target"

if ! command -v stow &>/dev/null; then
  echo "[stow] Installing..."
  sudo pacman -S --needed --noconfirm stow
fi

echo "[stow] Preparing to link packages from: $base_dir/config -> $target"
cd "$base_dir/config"

# Pre-clean: remove blocking package roots (delete, no backup)
# For each first-level directory (a Stow "package"), if a same-named path exists
# in ~/.config and is NOT a symlink, remove it so Stow can place symlinks.
shopt -s nullglob dotglob
for pkg in */; do
  pkg="${pkg%/}"
  if [[ -e "$target/$pkg" && ! -L "$target/$pkg" ]]; then
    echo "[stow] Removing existing target (not a symlink): $target/$pkg"
    rm -rf -- "$target/$pkg"
  fi
done
shopt -u nullglob dotglob

# Now stow everything in this directory into ~/.config
echo "[stow] Linking…"
stow -v -t "$target" -R .

echo "Done."
