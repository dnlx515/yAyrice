#!/usr/bin/env bash
set -euo pipefail

WALL_DIR="${WALL_DIR:-}"
if [ -z "$WALL_DIR" ]; then
    if [ -d "$HOME/Downloads/waypepah" ]; then
        WALL_DIR="$HOME/Downloads/waypepah"
    else
        WALL_DIR="$HOME/Pictures/wallpapers"
    fi
fi
CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
CACHE_DIR="$CACHE_HOME/wallpaper-thumbs"
STATE_DIR="$CACHE_HOME/wallpaper-select"
STATE_FILE="$STATE_DIR/current"
ROFI_THEME="$HOME/.config/rofi/config.rasi"

mkdir -p "$CACHE_DIR" "$STATE_DIR"

thumb_for() {
    printf '%s/%s.png\n' "$CACHE_DIR" "$(basename "$1")"
}

refresh() {
    local f t
    for f in "$WALL_DIR"/*; do
        [ -f "$f" ] || continue
        t="$(thumb_for "$f")"
        if [ -f "$t" ] && [ "$t" -nt "$f" ]; then
            continue
        fi
        magick "$f" -auto-orient -resize 640x360^ -gravity center -extent 640x360 "$t" 2>/dev/null || true
    done
    for t in "$CACHE_DIR"/*.png; do
        [ -e "$t" ] || continue
        [ -f "$WALL_DIR/$(basename "$t" .png)" ] || rm -f "$t"
    done
}

apply() {
    local file="$1" pos
    [ -f "$file" ] || { printf 'no such wallpaper: %s\n' "$file" >&2; exit 1; }
    pos="$(hyprctl cursorpos 2>/dev/null | tr -d ' ' || true)"
    [ -n "$pos" ] || pos="center"
    awww img "$file" \
        --transition-type grow \
        --transition-pos "$pos" \
        --transition-duration 1 \
        --transition-fps 60
    if command -v matugen >/dev/null 2>&1; then
        matugen image "$file" --mode dark --prefer saturation --quiet || true
    elif [ -x "$HOME/.cargo/bin/matugen" ]; then
        "$HOME/.cargo/bin/matugen" image "$file" --mode dark --prefer saturation --quiet || true
    fi
    printf '%s\n' "$file" > "$STATE_FILE"
    sddm_dir="/usr/share/sddm/themes/simple_sddm_2"
    if [ -d "$sddm_dir" ] && [ -w "$sddm_dir" ]; then
        res="$(hyprctl monitors -j 2>/dev/null | python3 -c 'import json,sys; m=json.load(sys.stdin)[0]; print(str(m["width"]) + "x" + str(m["height"]))' 2>/dev/null)"
        [ -n "$res" ] || res="1920x1080"
        magick "$file" -auto-orient -resize "${res}^" -gravity center -extent "$res" \
            "$sddm_dir/current.png" 2>/dev/null || true
    fi
}

restore() {
    local file
    file="$(cat "$STATE_FILE" 2>/dev/null || true)"
    [ -f "${file:-}" ] || file="$HOME/Pictures/wallpapers/sunset.png"
    [ -f "$file" ] || return 0
    awww img "$file" --transition-type fade --transition-duration 0
    printf '%s\n' "$file" > "$STATE_FILE"
}

pick() {
    local sel
    sel="$(
        for f in "$WALL_DIR"/*; do
            [ -f "$f" ] || continue
            printf '%s\0icon\x1f%s\n' "$(basename "$f")" "$(thumb_for "$f")"
        done | rofi -dmenu -i -p "Sfondo" -show-icons \
            -theme "$ROFI_THEME" \
            -theme-str 'window { width: 1220px; } listview { columns: 3; lines: 3; dynamic: true; } element { orientation: vertical; padding: 12px; spacing: 8px; } element-icon { size: 200px; } element-text { horizontal-align: 0.5; font: "CaskaydiaCove Nerd Font 10"; }'
    )" || exit 0
    [ -n "$sel" ] || exit 0
    apply "$WALL_DIR/$sel"
}

case "${1:-}" in
    --refresh) refresh ;;
    --apply) shift; apply "${1:-}" ;;
    --restore) restore ;;
    --current) cat "$STATE_FILE" 2>/dev/null || true ;;
    "" ) refresh; pick ;;
    *) printf 'usage: %s [--refresh|--apply FILE|--restore|--current]\n' "$(basename "$0")" >&2; exit 1 ;;
esac
