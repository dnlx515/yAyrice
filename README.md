# sunset rice

Config Hyprland personale: barra Waybar, launcher Rofi, kitty, GTK e zsh.
Palette unica ricavata da un tramonto, con blur e angoli arrotondati su barra e launcher.

## Palette

| Ruolo        | Hex       |
|--------------|-----------|
| base         | `#161014` |
| superfici    | `#2A2028` |
| testo        | `#F2EDE4` |
| accento      | `#F2A98C` |
| muted        | `#B9A49D` |
| linea        | `#4C4E61` |
| blu-grigio   | `#7D89A6` |

Font: **CaskaydiaCove Nerd Font** (pacchetto `ttf-cascadia-code-nerd`).

## Contenuto

```
config/hypr/hyprland.lua     Hyprland (parser Lua)
config/waybar/               barra
config/rofi/                 launcher + power menu
config/kitty/                terminale
config/gtk-3.0, gtk-4.0/     tema GTK
home/.zshrc                  shell
wallpapers/sunset.png        sfondo
install.sh                   installer
packages.txt                 pacchetti Arch
```

## Installazione

```bash
git clone git@github.com:dnlx515/dotfiles.git
cd dotfiles
./install.sh
```

Lo script:

1. chiede quali componenti installare (se hai `gum`, con menu a frecce);
2. fa un backup di quello che trova in `~/.config-backup-<data>`;
3. crea i **symlink** da `~/.config/<componente>/...` ai file del repo
   (così modificando il repo cambia subito anche il sistema);
4. copia la wallpaper in `~/Pictures/wallpapers/sunset.png` se non c'è;
5. con `--with-packages` installa anche `packages.txt` via pacman.

Opzioni: `--yes` (nessuna domanda), `--with-packages`, `--help`.

## Dipendenze extra (AUR)

```bash
paru -S adw-gtk3          # tema GTK usato in gtk-*/settings.ini
paru -S hyprshutdown      # opzionale, usato da SUPER+M (c'è fallback)
```

Il tema SDDM `simple_sddm_2` non è incluso: vive in `/usr/share` e richiede `sudo`.
Se lo usi, adatta i colori a quelli della palette qui sopra.

## Keybind principali

| Tasto | Azione |
|---|---|
| `SUPER + Q` | kitty |
| `SUPER + E` | nemo |
| `SUPER + R` / `SUPER + W` | rofi (app) |
| `SUPER + X` | power menu |
| `SUPER + C` / `SUPER + A` | chiudi finestra |
| `SUPER + T` | floating toggle |
| `SUPER + F` | fullscreen |
| `SUPER + B` | screenshot regione |
| `SUPER + P` / `SUPER + J` | pseudo-tile / togglesplit |
| `SUPER + 1..0` | workspace |
| `SUPER + SHIFT + 1..0` | sposta finestra su workspace |
| `SUPER + S` | scratchpad |
| `SUPER + frecce` | focus |
| `SUPER + CTRL + frecce` | resize |
| `SUPER + LMB / RMB` | drag / resize finestra |
| `SUPER + rotella` | workspace avanti/indietro |

Tasti multimediali (volume, luminosità, playerctl) già mappati.

## Note personali da adattare

- **Layout tastiera**: `us` + `altgr-intl`, con `lv3:caps_switch_capslock_with_ctrl`
  (Caps Lock come AltGr, così gli accenti si fanno con AltGr+lettera).
  Se non ti serve, `input.kb_variant`/`kb_options` sono in `config/hypr/hyprland.lua`.
- **Monitor**: rilevato automaticamente. Per forzare risoluzione/refresh c'è la riga
  commentata nella sezione `MONITORS`.
- **Wallpaper**: lo script copia `sunset.png` in `~/Pictures/wallpapers/`.
- **Geometry Dash**: c'è una `window_rule` che mette fullscreen la classe
  `steam_app_322170`; toglila se non ti serve.
- **Power menu**: la voce *Lock* usa `loginctl lock-session` e richiede un locker
  (es. `hyprlock`).

## Crediti

Base di partenza dalla documentazione Hyprland (config di esempio), poi modificata.
