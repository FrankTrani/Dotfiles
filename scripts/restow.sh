#!/usr/bin/env bash
set -euo pipefail

# Option B: each first-level dir under ./config becomes ~/.config/<pkg>
# Strategy: delete ~/.config/<pkg>, then stow with default folding (1 symlink per pkg).

base_dir="$(cd -- "$(dirname -- "$0")/.." && pwd -P)"
config_dir="$base_dir/config"
target="$HOME/.config"

command -v stow >/dev/null 2>&1 || { echo "error: stow not installed"; exit 1; }
[[ -d "$config_dir" ]] || { echo "error: missing $config_dir"; exit 1; }

# Collect package dirs (skip names with spaces)
mapfile -d '' pkgs < <(find "$config_dir" -mindepth 1 -maxdepth 1 -type d -printf '%f\0' | grep -zv ' ' || true)
[[ ${#pkgs[@]} -gt 0 ]] || { echo "error: no packages under $config_dir"; exit 1; }

echo "Force-replacing packages in $target:"
printf '  %s\n' "${pkgs[@]}"
echo

for pkg in "${pkgs[@]}"; do
  dst="$target/$pkg"
  if [[ -e "$dst" || -L "$dst" ]]; then
    echo "  rm -rf $dst"
    rm -rf -- "$dst"
  fi

  echo "  stow $pkg -> $target"
  stow --restow --verbose=1 \
       --dir "$config_dir" \
       --target "$target" \
       "$pkg"
done

echo
echo "Done."
