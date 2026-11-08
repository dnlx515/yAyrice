#!/usr/bin/env bash
# =============================================================
#  dotfiles — Hyprland "sunset" rice
#  Usage: ./install.sh [--yes] [--with-packages]
#    --yes            non-interactive (all components)
#    --with-packages  also install the packages listed in packages.txt
# =============================================================
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COMPONENTS=(hypr waybar rofi kitty gtk-3.0 gtk-4.0)
BACKUP="$HOME/.config-backup-$(date +%Y%m%d-%H%M%S)"
ASSUME_YES=0
WITH_PACKAGES=0

for arg in "$@"; do
    case "$arg" in
        -y|--yes)        ASSUME_YES=1 ;;
        --with-packages) WITH_PACKAGES=1 ;;
        -h|--help)       sed -n '2,7p' "$0"; exit 0 ;;
        *)               echo "Unknown option: $arg"; exit 1 ;;
    esac
done

say()  { printf '\033[1;38;5;216m%s\033[0m\n' "$*"; }
warn() { printf '\033[1;31m%s\033[0m\n' "$*"; }

ask() {
    if [ "$ASSUME_YES" = 1 ]; then
        return 0
    fi
    local a
    read -r -p "$1 [Y/n] " a
    if [ -z "$a" ] || [[ "$a" =~ ^[yYsS] ]]; then
        return 0
    fi
    return 1
}

if [ "$HOME" = "/" ]; then
    warn "Invalid HOME: aborting."
    exit 1
fi
if [ ! -f "$ROOT/config/hypr/hyprland.lua" ]; then
    warn "Run this script from the repository root (missing config/hypr/hyprland.lua)."
    exit 1
fi

# --- component selection ---
SELECTED=()
if [ "$ASSUME_YES" = 0 ] && command -v gum >/dev/null 2>&1; then
    mapfile -t SELECTED < <(printf '%s\n' "${COMPONENTS[@]}" | gum choose --no-limit \
        --header "Components to install (space = select, enter = confirm)")
else
    if ask "Install all components (hypr, waybar, rofi, kitty, gtk)?"; then
        SELECTED=("${COMPONENTS[@]}")
    fi
fi

if [ ${#SELECTED[@]} -eq 0 ]; then
    warn "No component selected, exiting."
    exit 0
fi

# --- backup + symlinks ---
link_file() {
    local src="$1" dst="$2"
    if [ -e "$dst" ] || [ -L "$dst" ]; then
        mkdir -p "$BACKUP/$(dirname "${dst#$HOME/}")"
        cp -a "$dst" "$BACKUP/${dst#$HOME/}"
    fi
    mkdir -p "$(dirname "$dst")"
    ln -sfn "$src" "$dst"
}

for c in "${SELECTED[@]}"; do
    src="$ROOT/config/$c"
    if [ ! -d "$src" ]; then
        warn "Component not found: $c"
        continue
    fi
    say "→ $c"
    for f in "$src"/*; do
        if [ -e "$f" ]; then
            link_file "$f" "$HOME/.config/$c/$(basename "$f")"
        fi
    done
done

say "→ .zshrc"
link_file "$ROOT/home/.zshrc" "$HOME/.zshrc"

# --- wallpaper ---
if [ -f "$ROOT/wallpapers/sunset.png" ]; then
    mkdir -p "$HOME/Pictures/wallpapers"
    if [ ! -f "$HOME/Pictures/wallpapers/sunset.png" ]; then
        cp "$ROOT/wallpapers/sunset.png" "$HOME/Pictures/wallpapers/sunset.png"
        say "→ wallpaper copied to ~/Pictures/wallpapers/sunset.png"
    fi
fi

# --- packages ---
if [ "$WITH_PACKAGES" = 1 ] || { [ "$ASSUME_YES" = 0 ] && ask "Install packages from packages.txt?"; }; then
    mapfile -t PKGS < <(grep -vE '^[[:space:]]*(#|$)' "$ROOT/packages.txt")
    if [ ${#PKGS[@]} -gt 0 ]; then
        say "→ sudo pacman -S --needed ${PKGS[*]}"
        sudo pacman -S --needed "${PKGS[@]}"
    fi
fi

say "Done."
say "Backup of replaced files: $BACKUP"
say "Log out and back in, or run: hyprctl reload"
