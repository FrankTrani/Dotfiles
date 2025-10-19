#!/usr/bin/env bash
set -euo pipefail

base_dir="$(realpath "$(dirname "$0")/..")"
cd "$base_dir"

stow -v -t "$HOME" -D config/
