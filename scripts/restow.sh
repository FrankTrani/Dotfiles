#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd -- "$(dirname -- "$0")/.." && pwd -P)"
CONFIG_DIR="$REPO_ROOT/config"

command -v stow >/dev/null 2>&1 || { echo "error: stow not installed"; exit 1; }

# Exclude the spacey package unless you rename it
readarray -d '' PKGS < <(find "$CONFIG_DIR" -mindepth 1 -maxdepth 1 -type d -printf '%f\0' \
  | grep -zv '^old zshrc$' || true)

[[ ${#PKGS[@]} -gt 0 ]] || { echo "No packages in $CONFIG_DIR"; exit 1; }

echo "Restowing -> \$HOME:"
printf '  %s\n' "${PKGS[@]}"
stow --restow --verbose=1 --dir "$CONFIG_DIR" --target "$HOME" "${PKGS[@]}"
