#!/usr/bin/env bash
set -euo pipefail

# Force-overwrite ~/.config/<pkg> with repo versions (Option B).

base_dir="$(cd -- "$(dirname -- "$0")/.." && pwd -P)"
config_dir="$base_dir/config"
target="$HOME/.config"

command -v stow >/dev/null 2>&1 || { echo "error: stow not installed"; exit 1; }
[[ -d "$config_dir" ]] || { echo "error: missing $config_dir"; exit 1; }

# Collect first-level package dirs (skip names with spaces)
mapfile -d '' pkgs < <(find "$config_dir" -mindepth 1 -maxdepth 1 -type d -printf '%f\0' | grep -zv ' ' || true)
[[ ${#pkgs[@]} -gt 0 ]] || { echo "error: no packages under $config_dir"; exit 1; }

echo "Deleting and restowing into $target"
for pkg in "${pkgs[@]}"; do
  dst="$target/$pkg"
  if [[ -e "$dst" || -L "$dst" ]]; then
    echo "  rm -rf $dst"
    rm -rf -- "$dst"
  fi
done

echo "Stowing packages:"
printf '  %s\n' "${pkgs[@]}"
stow --restow --no-folding --verbose=1 \
     --dir "$config_dir" \
     --target "$target" \
     "${pkgs[@]}"

echo "Done."
