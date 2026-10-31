#!/usr/bin/env bash
# =============================================================
#  dotfiles — rice Hyprland "sunset"
#  Uso: ./install.sh [--yes] [--with-packages]
#    --yes            non chiede niente (tutti i componenti)
#    --with-packages  installa anche i pacchetti di packages.txt
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
        *)               echo "Opzione sconosciuta: $arg"; exit 1 ;;
    esac
done

say()  { printf '\033[1;38;5;216m%s\033[0m\n' "$*"; }
warn() { printf '\033[1;31m%s\033[0m\n' "$*"; }

ask() {
    if [ "$ASSUME_YES" = 1 ]; then
        return 0
    fi
    local a
    read -r -p "$1 [S/n] " a
    if [ -z "$a" ] || [[ "$a" =~ ^[sSyY] ]]; then
        return 0
    fi
    return 1
}

if [ "$HOME" = "/" ]; then
    warn "HOME non valida: non eseguo."
    exit 1
fi
if [ ! -f "$ROOT/config/hypr/hyprland.lua" ]; then
    warn "Esegui lo script dalla cartella del repo (manca config/hypr/hyprland.lua)."
    exit 1
fi

# --- scelta componenti ---
SELECTED=()
if [ "$ASSUME_YES" = 0 ] && command -v gum >/dev/null 2>&1; then
    mapfile -t SELECTED < <(printf '%s\n' "${COMPONENTS[@]}" | gum choose --no-limit \
        --header "Componenti da installare (spazio = seleziona, invio = conferma)")
else
    if ask "Installare tutti i componenti (hypr, waybar, rofi, kitty, gtk)?"; then
        SELECTED=("${COMPONENTS[@]}")
    fi
fi

if [ ${#SELECTED[@]} -eq 0 ]; then
    warn "Nessun componente selezionato, esco."
    exit 0
fi

# --- backup + symlink ---
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
        warn "Componente non trovato: $c"
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
        say "→ wallpaper in ~/Pictures/wallpapers/sunset.png"
    fi
fi

# --- pacchetti ---
if [ "$WITH_PACKAGES" = 1 ] || { [ "$ASSUME_YES" = 0 ] && ask "Installo i pacchetti da packages.txt?"; }; then
    mapfile -t PKGS < <(grep -vE '^[[:space:]]*(#|$)' "$ROOT/packages.txt")
    if [ ${#PKGS[@]} -gt 0 ]; then
        say "→ sudo pacman -S --needed ${PKGS[*]}"
        sudo pacman -S --needed "${PKGS[@]}"
    fi
fi

say "Fatto."
say "Backup dei file sostituiti: $BACKUP"
say "Riapri la sessione (logout/login) oppure: hyprctl reload"
