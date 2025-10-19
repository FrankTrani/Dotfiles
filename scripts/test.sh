#!/usr/bin/env bash
set -euo pipefail

base_dir="$(realpath "$(dirname "$0")/..")"
echo "The base directory is: $base_dir"

json_file="$base_dir/scripts/packages.json"

# Check if jq is installed
if ! command -v jq &>/dev/null; then
  echo "Error: jq is not installed." >&2
  exit 1
fi

# Check if the JSON file exists
if [[ ! -f "$json_file" ]]; then
  echo "Error: JSON file not found at $json_file" >&2
  exit 1
fi

# Extract and print packages
pacman_packages=$(jq -r '.pacman_packages[]?' "$json_file")
echo "Pacman packages found:"
echo "$pacman_packages"
