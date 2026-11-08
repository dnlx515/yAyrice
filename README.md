# yAyrice (completely random name)

Just my simple hyprland rice, nothing special, I got inspirated by the wallpaper.

## Palette

| Role         | Hex       |
|--------------|-----------|
| base         | `#161014` |
| surface      | `#2A2028` |
| text         | `#F2EDE4` |
| accent       | `#F2A98C` |
| muted        | `#B9A49D` |
| line         | `#4C4E61` |
| blue-grey    | `#7D89A6` |

Font: **CaskaydiaCove Nerd Font** (`ttf-cascadia-code-nerd`).

## Contents

```
config/hypr/hyprland.lua     Hyprland (Lua config)
config/waybar/               status bar
config/rofi/                 launcher + power menu
config/kitty/                terminal
config/gtk-3.0, gtk-4.0/     GTK theme
home/.zshrc                  shell
wallpapers/sunset.png        wallpaper
install.sh                   installer
packages.txt                 Arch packages
```

## Installation

```bash
git clone git@github.com:dnlx515/dotfiles.git
cd dotfiles
./install.sh
```

What the script does:

1. asks which components to install (arrow-key menu if `gum` is available);
2. backs up whatever it finds into `~/.config-backup-<date>`;
3. creates **symlinks** from `~/.config/<component>/...` to the repo files,
   so editing the repo immediately changes the live system;
4. copies the wallpaper to `~/Pictures/wallpapers/sunset.png` if missing;
5. with `--with-packages`, installs `packages.txt` through pacman.

Options: `--yes` (no questions), `--with-packages`, `--help`.

## Extra dependencies (AUR)

```bash
paru -S adw-gtk3          # GTK theme used in gtk-*/settings.ini
paru -S hyprshutdown      # optional, used by SUPER+M (fallback exists)
```

The `simple_sddm_2` SDDM theme is not included: it lives in `/usr/share` and
needs `sudo`. If you use it, match its colors to the palette above.

## Key bindings

| Key | Action |
|---|---|
| `SUPER + Q` | kitty |
| `SUPER + E` | nemo |
| `SUPER + R` / `SUPER + W` | rofi (apps) |
| `SUPER + X` | power menu |
| `SUPER + C` / `SUPER + A` | close window |
| `SUPER + T` | toggle floating |
| `SUPER + F` | fullscreen |
| `SUPER + B` | screenshot region |
| `SUPER + P` / `SUPER + J` | pseudo-tile / togglesplit |
| `SUPER + 1..8` | workspace (6-8 appear when used, vanish when empty) |
| `SUPER + SHIFT + 1..8` | move window to workspace |
| `SUPER + S` | scratchpad |
| `SUPER + arrows` | focus |
| `SUPER + CTRL + arrows` | resize |
| `SUPER + LMB / RMB` | drag / resize window |
| `SUPER + scroll` | previous/next workspace |
