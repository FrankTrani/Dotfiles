#!/bin/bash
choice=$(printf "Lock\nSleep\nHibernate\nShutdown\nReboot" | rofi -dmenu -p "Power")
case "$choice" in
  Lock) hyprlock ;;
  Sleep) systemctl suspend ;;
  Hibernate) systemctl hibernate ;;
  Shutdown) systemctl poweroff ;;
  Reboot) systemctl reboot ;;
esac
