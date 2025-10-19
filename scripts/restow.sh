#!/usr/bin/env bash
set -euo pipefail

# Repo root (scripts/ lives one level below root)
REPO_ROOT="$(cd -- "$(dirname -- "$0")/.." && pwd -P)"
cd "$REPO_ROOT"

command -v stow >/dev/null 2>&1 || {
  echo "error: GNU stow not found. Install it first (pacman -S stow, apt install stow, etc.)." >&2
  exit 1
}

# Packages under config/, excluding known non-packages
CONFIG_DIR="$REPO_ROOT/config"
EXCLUDES=("old zshrc")   # rename or keep excluded
PACKAGES=()

# Collect first-level dirs under config
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
  echo "Nothing to stow under $CONFIG_DIR. Check your layout." >&2
  exit 1
fi

echo "Restowing home packages from: $CONFIG_DIR"
for pkg in "${PACKAGES[@]}"; do
  echo "→ stow $pkg -> \$HOME"
  stow --restow --verbose=1 --dir "$CONFIG_DIR" --target "$HOME" "$pkg"
done

# Optional: root-level packages under root-cfg/ (mirror absolute / paths)
if [[ -d "$REPO_ROOT/root-cfg" ]]; then
  echo
  echo "Found root-cfg/. If these packages mirror absolute paths (/, /usr, etc.), you can stow them with sudo."
  echo "Running root restow…"
  # Comment out if you don’t want this automatic:
  sudo stow --restow --verbose=1 --dir "$REPO_ROOT/root-cfg" --target "/" .
fi

echo
echo "Done."
