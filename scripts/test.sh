base_dir="$(realpath "$(dirname $0)/..")"
echo "The base directory is: $base_dir"

json_file="$base_dir/scripts/packages.json"
pacman_packages=$(jq -r '.pacman_packages[]' "$json_file")
echo $pacman_packages