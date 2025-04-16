#!/bin/bash

# Safely get the brightness percent (remove % sign)
percent=$(brightnessctl -m | awk -F',' '{print $4}' | tr -d '%')

# Ensure it's a valid number
if ! [[ "$percent" =~ ^[0-9]+$ ]]; then
  echo '{"text": " --%", "tooltip": "Brightness: unknown"}'
  exit 0
fi

# Round to nearest 10
rounded=$(( (percent + 5) / 10 * 10 ))

# Clamp to 0–100
(( rounded > 100 )) && rounded=100
(( rounded < 0 )) && rounded=0

# Choose icon
case $rounded in
  0|10) icon="" ;;
  20) icon="" ;;
  30) icon="" ;;
  40) icon="" ;;
  50) icon="" ;;
  60) icon="" ;;
  70) icon="" ;;
  80) icon="" ;;
  90) icon="" ;;
  100) icon="" ;;
  *) icon="" ;;
esac

# Output valid JSON
printf '{"text": "%s %d%%", "tooltip": "Brightness: %d%%"}\n' "$icon" "$rounded" "$rounded"
