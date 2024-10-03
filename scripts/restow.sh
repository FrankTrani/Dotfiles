#!/usr/bin/env bash

base_dir="$(realpath "$(dirname $0)/..")"
cd "$basedir"
stow -v -t ~ -R config/