#!/usr/bin/env bash
set -euo pipefail

# Find repo root (one level up from scripts/)
REPO_ROOT="$(cd -- "$(dirname -- "$0")/.." && pwd -P)"
CONFIG_DIR="$REPO_ROOT/config"

# Require GNU stow
command -v stow >/dev/null 2>&1 || {
  echo "error: stow not installed (pacman -S stow)" >&2
  exit 1
}

# Build package list, ignoring folders with spaces
readarray -d '' PKGS < <(find "$CONFIG_DIR" -mindepth 1 -maxdepth 1 -type d -printf '%f\0' \
  | grep -zv ' ' || true)

if [[ ${#PKGS[@]} -eq 0 ]]; then
  echo "No stowable packages found in $CONFIG_DIR" >&2
  exit 1
fi

echo "Restowing to \$HOME/.config:"
printf '  %s\n' "${PKGS[@]}"
stow --restow --verbose=1 \
     --dir "$CONFIG_DIR" \
     --target "$HOME/.config" \
     "${PKGS[@]}"

echo "✅ Done."
