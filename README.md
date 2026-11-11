# yAyrice (completely random name)

Just my simple hyprland rice, nothing special, I got inspirated by the wallpaper.

## Palette

The colors below are the reference palette this rice was designed around. They
are also the fallback: `waybar`, `rofi` and the Hyprland borders are generated
from the current wallpaper by `matugen` (templates in `config/matugen/`).

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
config/hypr/scripts/          wallpaper picker
config/waybar/               status bar
config/rofi/                 launcher + power menu
config/kitty/                terminal
config/gtk-3.0, gtk-4.0/     GTK theme
config/matugen/              dynamic color templates
config/swaync/               notifications
home/.zshrc                  shell
wallpapers/sunset.png        wallpaper
install.sh                   installer
packages.txt                 Arch packages
```

## Wallpapers

`SUPER + SHIFT + W` opens a rofi grid of the images in `~/Downloads/waypepah`
(override with `WALL_DIR`). Picking one runs `awww img` and then `matugen`, so
the bar, the launcher, the notifications and the window borders follow the new
wallpaper.

The script also works from a shell:

```bash
wallpaper-select.sh --apply ~/Downloads/waypepah/foo.png
wallpaper-select.sh --refresh     # rebuild thumbnails only
wallpaper-select.sh --current     # print the active wallpaper
```

## Notifications

`swaync` is the notification daemon, themed by `matugen` through
`config/matugen/templates/swaync-style.css`. `swaync-client -t` opens the
control center, `swaync-client -d` toggles do-not-disturb.

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
| `SUPER + SHIFT + W` | wallpaper picker |
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
