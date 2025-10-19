#!/usr/bin/env bash
set -euo pipefail

# Force-overwrite ~/.config/<pkg> with repo versions (no backups).
# Deletes any conflicting files/dirs along the exact paths Stow will touch.

base_dir="$(cd -- "$(dirname -- "$0")/.." && pwd -P)"
config_dir="$base_dir/config"
target="$HOME/.config"

command -v stow >/dev/null 2>&1 || { echo "error: stow not installed"; exit 1; }
[[ -d "$config_dir" ]] || { echo "error: missing $config_dir"; exit 1; }

# Gather packages (first-level dirs in config), skip names with spaces
mapfile -d '' pkgs < <(find "$config_dir" -mindepth 1 -maxdepth 1 -type d -printf '%f\0' | grep -zv ' ' || true)
[[ ${#pkgs[@]} -gt 0 ]] || { echo "error: no packages under $config_dir"; exit 1; }

echo "Pre-cleaning conflicts under $target and restowing:"
printf '  %s\n' "${pkgs[@]}"
echo

for pkg in "${pkgs[@]}"; do
  src_pkg="$config_dir/$pkg"

  # 1) Ensure all target directories can exist as directories (not files)
  #    If a non-directory exists where a directory is needed, remove it.
  while IFS= read -r -d '' d; do
    rel="${d#"$src_pkg/"}"               # relative dir inside the pkg
    [[ "$rel" == "$src_pkg" ]] && rel="" # package root
    dst_dir="$target/$pkg/${rel}"
    if [[ -e "$dst_dir" && ! -d "$dst_dir" ]]; then
      echo "  removing non-directory blocking dir: $dst_dir"
      rm -f -- "$dst_dir"
    fi
    mkdir -p -- "$dst_dir"
  done < <(find "$src_pkg" -type d -print0)

  # 2) Remove any existing files/symlinks that would be replaced
  while IFS= read -r -d '' f; do
    rel="${f#"$src_pkg/"}"
    dst_file="$target/$pkg/${rel}"
    if [[ -e "$dst_file" || -L "$dst_file" ]]; then
      echo "  removing existing file: $dst_file"
      rm -rf -- "$dst_file"
    fi
    # parent dirs already ensured above
  done < <(find "$src_pkg" -type f -print0)

  # 3) Restow the package (no-folding = per-file links inside the directory)
  echo "  stowing $pkg -> $target"
  stow --restow --no-folding --verbose=1 \
       --dir "$config_dir" \
       --target "$target" \
       "$pkg"
done

echo
echo "Done."
