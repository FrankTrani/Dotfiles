#!/usr/bin/env bash
set -euo pipefail

# Ensure consistent parsing
export LC_ALL=C

# Verify brightnessctl exists
if ! command -v brightnessctl >/dev/null 2>&1; then
  printf '{"text":" --%%","tooltip":"brightnessctl not found"}\n'
  exit 0
fi

# Safely get the brightness percent (remove % sign)
# brightnessctl -m -> NAME,CLASS,VALUE,%,...  ; we want field 4
raw=$(brightnessctl -m 2>/dev/null | head -n1 || true)
percent=$(printf '%s' "$raw" | awk -F',' '{print $4}' | tr -d '%')

# Validate number
if ! [[ "${percent:-}" =~ ^[0-9]+$ ]]; then
  printf '{"text":" --%%","tooltip":"Brightness: unknown"}\n'
  exit 0
fi

# Round to nearest 10, clamp 0–100
rounded=$(( (percent + 5) / 10 * 10 ))
(( rounded > 100 )) && rounded=100
(( rounded < 0 )) && rounded=0

# Pick icon (Material glyphs you used)
case $rounded in
  0|10)  icon="" ;;
  20)    icon="" ;;
  30)    icon="" ;;
  40)    icon="" ;;
  50)    icon="" ;;
  60)    icon="" ;;
  70)    icon="" ;;
  80)    icon="" ;;
  90)    icon="" ;;
  100)   icon="" ;;
  *)     icon="" ;;
esac

printf '{"text":"%s %d%%","tooltip":"Brightness: %d%%"}\n' "$icon" "$rounded" "$rounded"
