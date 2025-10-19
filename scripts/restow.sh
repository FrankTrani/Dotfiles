#!/usr/bin/env bash
set -euo pipefail

base_dir="$(cd -- "$(dirname -- "$0")/../config" && pwd -P)"
cd "$base_dir"

for dir in *; do
    if [ -d "$dir" ]; then
        echo "Stowing $dir..."
        stow -v -t "$HOME" -R "$dir"
    fi
done
echo "Restow complete."