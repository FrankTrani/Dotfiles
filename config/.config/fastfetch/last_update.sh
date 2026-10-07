#!/usr/bin/env bash

now_day="$(date +%F)"

line=$(grep -F "[PACMAN] starting full system upgrade" /var/log/pacman.log | tail -n1) || {
    echo "unknown"
    exit 1
}

ts="${line%%]*}"
ts="${ts#\[}"

epoch=$(date -d "$ts" +%s 2>/dev/null) || epoch=$(date -d "${ts/T/ }" +%s 2>/dev/null) || {
    echo "unknown"
    exit 1
}

seconds_ago=$(( $(date +%s) - epoch ))
days=$(( seconds_ago / 86400 ))
hours=$(( (seconds_ago % 86400) / 3600 ))
minutes=$(( (seconds_ago % 3600) / 60 ))

if (( days > 0 )); then
    echo "${days}d ${hours}h"
elif (( hours > 0 )); then
    echo "${hours}h ${minutes}m"
else
    echo "${minutes}m"
fi
