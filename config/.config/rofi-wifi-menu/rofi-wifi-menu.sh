#!/usr/bin/env bash

# Rofi Wi-Fi menu using nmcli
# Dependencies: nmcli, rofi, networkmanager

# Appearance / position config
FIELDS="SSID,SECURITY"
FONT="JetBrainsMono Nerd Font 13"
POSITION=0
YOFF=0
XOFF=0

# Refresh Wi-Fi list
nmcli dev wifi rescan &>/dev/null

# Fetch and process available networks
LIST=$(nmcli --fields "$FIELDS" device wifi list | sed '/^--/d')
RWIDTH=$(($(echo "$LIST" | head -n 1 | awk '{print length($0); }') + 2))
LINENUM=$(echo "$LIST" | wc -l)
KNOWNCON=$(nmcli connection show)
CONSTATE=$(nmcli -fields WIFI g)
CURRSSID=$(LANGUAGE=C nmcli -t -f active,ssid dev wifi | awk -F: '$1 ~ /^yes/ {print $2}')

# Highlight the currently connected SSID
if [[ -n $CURRSSID ]]; then
    HIGHLINE=$(echo "$(echo "$LIST" | awk -F "[  ]{2,}" '{print $1}' | grep -Fxn -m 1 "$CURRSSID" | awk -F ":" '{print $1}') + 1" | bc)
fi

# Limit menu height
[ "$LINENUM" -gt 10 ] && LINENUM=10
[[ "$CONSTATE" =~ "disabled" ]] && LINENUM=1

# Toggle Wi-Fi entry
TOGGLE="toggle off"
[[ "$CONSTATE" =~ "disabled" ]] && TOGGLE="toggle on"

# Show menu via Rofi
CHENTRY=$(echo -e "$TOGGLE\nmanual\n$LIST" | uniq -u | rofi -dmenu \
    -theme rounded-blue-dark \
    -theme-str 'window { width: 40em; } listview { lines: 10; spacing: 8px; } element { padding: 6px 12px; }' \
    -p "Wi-Fi SSID:" \
    -lines "$LINENUM" \
    -a "$HIGHLINE" \
    -font "$FONT")

# Exit if nothing selected
[[ -z "$CHENTRY" ]] && exit 0

# Manual SSID/password entry
if [ "$CHENTRY" = "manual" ]; then
    MSSID=$(echo "SSID,password" | rofi -dmenu -p "Manual Entry:" -font "$FONT" -lines 1)
    [[ -z "$MSSID" ]] && exit 0
    SSID=$(echo "$MSSID" | awk -F "," '{print $1}')
    MPASS=$(echo "$MSSID" | awk -F "," '{print $2}')
    if [ -z "$MPASS" ]; then
        nmcli dev wifi con "$SSID"
    else
        nmcli dev wifi con "$SSID" password "$MPASS"
    fi

# Toggle Wi-Fi radio
elif [ "$CHENTRY" = "toggle on" ]; then
    nmcli radio wifi on
    exit 0

elif [ "$CHENTRY" = "toggle off" ]; then
    nmcli radio wifi off
    exit 0

# Attempt to connect to selected SSID
else
    CHSSID=$(echo "$CHENTRY" | sed 's/\s\{2,\}/|/g' | awk -F "|" '{print $1}')
    [ "$CHSSID" = "*" ] && CHSSID=$(echo "$CHENTRY" | sed 's/\s\{2,\}/|/g' | awk -F "|" '{print $3}')

    if [[ $(echo "$KNOWNCON" | grep "$CHSSID") == "$CHSSID" ]]; then
        nmcli con up "$CHSSID"
    else
        if [[ "$CHENTRY" =~ "WPA2" ]] || [[ "$CHENTRY" =~ "WEP" ]]; then
            WIFIPASS=$(echo "" | rofi -dmenu -p "Password for $CHSSID:" -lines 1 -font "$FONT")
        fi
        nmcli dev wifi con "$CHSSID" password "$WIFIPASS"
    fi
fi
