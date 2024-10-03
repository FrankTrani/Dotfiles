#!/usr/bin/env bash

base_dir="$(realpath "$(dirname $0)/..")"

# Function to display the menu
show_menu() {
  echo "Please choose an option:"
  echo "1) Fresh Install (Run install.sh, sway.sh, and set_fonts.sh)"
  echo "2) Run install.sh (Install packages)"
  echo "3) Run set_fonts.sh (Set JetBrainsMono Nerd Font)"
  echo "4) Run sway.sh (Configure Sway)"
  echo "5) Update the system and restow"
  echo "6) Exit"
}

# Function to perform a fresh install
fresh_install() {
  echo "Running Fresh Install..."
  source $base_dir/scripts/install.sh
  source $base_dir/scripts/sway.sh
  source $base_dir/scripts/set_fonts.sh
  echo "Fresh install completed."
}

# Function to update the system and restow
update_and_restow() {
  echo "Updating the system..."
  yay -Syu
  echo "Restowing configuration files..."
  source $base_dir/scripts/restow.sh
}

# Main program loop
while true; do
  show_menu
  read -rp "Enter the number of your choice: " choice
  
  case $choice in
    1)
      fresh_install
      ;;
    2)
      echo "Running install.sh..."
      source $base_dir/scripts/install.sh
      ;;
    3)
      echo "Running set_fonts.sh..."
      source $base_dir/scripts/set_fonts.sh
      ;;
    4)
      echo "Running sway.sh..."
      source $base_dir/scripts/sway.sh
      ;;
    5)
      update_and_restow
      ;;
    6)
      echo "Exiting..."
      exit 0
      ;;
    *)
      echo "Invalid choice. Please enter a number from 1 to 6."
      ;;
  esac
done
