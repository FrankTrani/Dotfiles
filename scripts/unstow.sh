#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd -- "$(dirname -- "$0")/.." && pwd -P)"
cd "$REPO_ROOT"

command -v stow >/dev/null 2>&1 || { echo "error: stow not installed"; exit 1; }

CONFIG_DIR="$REPO_ROOT/config"
EXCLUDES=("old zshrc")   # rename it or leave excluded
PACKAGES=()

# collect first-level dirs under config
while IFS= read -r -d '' d; do
  name="$(basename "$d")"
  skip=false
  for ex in "${EXCLUDES[@]}"; do
    [[ "$name" == "$ex" ]] && skip=true && break
  done
  $skip && continue
  PACKAGES+=("$name")
done < <(find "$CONFIG_DIR" -mindepth 1 -maxdepth 1 -type d -print0)

if [[ ${#PACKAGES[@]} -eq 0 ]]; then
  echo "Nothing to unstow under $CONFIG_DIR"
  exit 0
fi

echo "Unstowing from: $CONFIG_DIR"
for pkg in "${PACKAGES[@]}"; do
  echo "→ unstow $pkg from \$HOME"
  stow --dir "$CONFIG_DIR" --target "$HOME" -v -D "$pkg"
done

# Optional: if you stowed system files previously
if [[ -d "$REPO_ROOT/root-cfg" ]]; then
  echo
  echo "Unstowing root-cfg from / (requires sudo)…"
  sudo stow --dir "$REPO_ROOT/root-cfg" --target "/" -v -D .
fi

echo "Done."
