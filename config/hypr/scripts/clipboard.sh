#!/usr/bin/env bash
set -euo pipefail

entry="$(cliphist list | rofi -dmenu -i -p "Clipboard" -theme "$HOME/.config/rofi/config.rasi" -theme-str 'window { width: 900px; } listview { lines: 12; }')" || exit 0
[ -n "$entry" ] || exit 0
printf '%s' "$entry" | cliphist decode | wl-copy
