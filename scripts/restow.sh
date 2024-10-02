#!/usr/bin/env bash

basedir="$(dirname $0)/.."
cd "$basedir"
stow -v -t ~ -R config/