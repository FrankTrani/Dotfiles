#!/usr/bin/env bash
set -euo pipefail

# Unstow all packages from ~/.config (Option B)
# Deletes symlinks created by stow. Does NOT touch real files that weren't links.

base_dir="$(cd -- "$(dirname -- "$0")/.." && pwd -P)"
config_dir="$base_dir/config"
target="$HOME/.config"

command -v stow >/dev/null 2>&1 || { echo "error: stow not installed"; exit 1; }
[[ -d "$config_dir" ]] || { echo "error: missing $config_dir"; exit 1; }

# Collect first-level package directories (skip spaces)
mapfile -d '' pkgs < <(find "$config_dir" -mindepth 1 -maxdepth 1 -type d -printf '%f\0' | grep -zv ' ' || true)
[[ ${#pkgs[@]} -gt 0 ]] || { echo "No packages to unstow under $config_dir"; exit 0; }

echo "Unstowing from $target"
printf '  %s\n' "${pkgs[@]}"
stow --delete --no-folding --verbose=1 \
     --dir "$config_dir" \
     --target "$target" \
     "${pkgs[@]}"

echo "Done."
