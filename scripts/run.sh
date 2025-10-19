#!/usr/bin/env bash
set -euo pipefail

# --- Resolve repo root ---
base_dir="$(cd -- "$(dirname -- "$0")/.." && pwd -P)"

install_script="$base_dir/scripts/install.sh"
fonts_script="$base_dir/scripts/set_fonts.sh"
restow_script="$base_dir/scripts/restow.sh"

require_file() {
  [[ -f "$1" ]] || { echo "Error: missing $2 at $1" >&2; exit 1; }
}

# --- Verify scripts exist ---
require_file "$install_script" "install.sh"
require_file "$fonts_script" "set_fonts.sh"
require_file "$restow_script" "restow.sh"

run() {
  local desc="$1" path="$2" as_root="${3:-no}"
  echo "==> $desc"
  if [[ "$as_root" == "yes" ]]; then
    sudo bash "$path"
  else
    bash "$path"
  fi
}

# --- Menu ---
show_menu() {
  cat <<'MENU'
Please choose an option:
  1) Fresh Install (install.sh, set_fonts.sh, restow.sh)
  2) Run install.sh (Install packages)
  3) Run set_fonts.sh (Set JetBrainsMono Nerd Font)
  4) Restow configuration files
  5) Update the system and restow
  6) Exit
MENU
}

fresh_install() {
  run "Installing packages" "$install_script"
  run "Setting fonts" "$fonts_script"
  run "Restowing configs" "$restow_script"
  echo "Fresh install completed."
}

update_and_restow() {
  if command -v yay >/dev/null 2>&1; then
    echo "==> Updating system via yay…"
    yay -Syu --noconfirm
  else
    echo "==> yay not found; using pacman."
    sudo pacman -Syu --noconfirm
  fi
  run "Restowing configs" "$restow_script"
}

# --- Main loop ---
while true; do
  show_menu
  read -rp "Enter choice [1-6]: " choice
  case "$choice" in
    1) fresh_install ;;
    2) run "Running install.sh" "$install_script" ;;
    3) run "Running set_fonts.sh" "$fonts_script" ;;
    4) run "Restowing configs" "$restow_script" ;;
    5) update_and_restow ;;
    6) echo "Bye."; exit 0 ;;
    *) echo "Invalid choice. Enter 1–6." ;;
  esac
done
