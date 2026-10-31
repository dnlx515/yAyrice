#!/bin/bash

THEME="$HOME/.config/rofi/power-menu.rasi"

chosen=$(printf '%s\n' \
    '󰌾  Lock' \
    '󰗽  Logout' \
    '󰜉  Reboot' \
    '󰐥  Shutdown' |
    rofi -dmenu \
        -no-config \
        -i \
        -p "Power" \
        -theme "$THEME"
)

case "$chosen" in
    '󰌾  Lock')
        loginctl lock-session
        ;;
    '󰗽  Logout')
        hyprctl dispatch exit
        ;;
    '󰜉  Reboot')
        systemctl reboot
        ;;
    '󰐥  Shutdown')
        systemctl poweroff
        ;;
esac
