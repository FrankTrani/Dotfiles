#!/usr/bin/env bash
set -euo pipefail

base_dir="$(cd -- "$(dirname -- "$0")/.." && pwd -P)"
cd "$base_dir"

stow -v -t "$HOME" -R config
