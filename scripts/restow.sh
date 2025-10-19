#!/usr/bin/env bash
set -euo pipefail

# Force-delete existing ~/.config/<pkg> before restowing repo configs.

base_dir="$(cd -- "$(dirname -- "$0")/.." && pwd -P)"
cd "$base_dir"

CONFIG_DIR="$base_dir/config"
TARGET="$HOME/.config"

echo "Deleting existing ~/.config/<pkg> directories..."
for pkg in "$CONFIG_DIR"/*; do
    [ -d "$pkg" ] || continue
    name="$(basename "$pkg")"
    dest="$TARGET/$name"
    
    if [[ -e "$dest" || -L "$dest" ]]; then
        echo "  Removing $dest"
        rm -rf "$dest"
    fi
done

echo
echo "Restowing configs from $CONFIG_DIR → $TARGET"
stow -v -R --no-folding --dir "$CONFIG_DIR" --target "$TARGET"

echo "done"
