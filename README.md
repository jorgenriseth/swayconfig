# swayconfig

Sway and shell dotfiles, now mirrored into a GNU Stow-compatible package layout.

The new packages live under `stow/`. The pre-stow layout is still present during migration so you can sync this repo with your other dotfiles repo before actually linking anything into `$HOME`.

## Package layout

- `stow/shell`: `.bashrc`, `.profile`
- `stow/environment`: `~/.config/environment.d` session defaults for Wayland apps
- `stow/foot`: `~/.config/foot/foot.ini` and theme snippets
- `stow/sway`: `~/.config/sway/config` and helper script
- `stow/waybar`: `~/.config/waybar/config` and `style.css`
- `stow/i3`: legacy X11/i3 package
- `stow/x11`: legacy `.xinitrc` and `.Xresources`

## Install packages

```bash
sudo apt install \
    stow \
    sway \
    swayidle \
    swaylock \
    waybar \
    mako-notifier \
    fuzzel \
    grim \
    slurp \
    brightnessctl \
    pavucontrol \
    foot \
    blueman \
    network-manager-gnome
```

If your distro ships `foot-themes`, it is optional now because this repo includes a local foot theme.

`swappy` (screenshot annotation) is not packaged for Ubuntu 24.04 and must be built from source:

```bash
sudo apt install meson ninja-build libgtk-3-dev libcairo2-dev libpango1.0-dev
git clone https://github.com/jtheoof/swappy.git && cd swappy
meson build && ninja -C build && sudo ninja -C build install
```

## Install with GNU Stow

Do not run these until you are ready to link this repo into your home directory.

Preview the changes first:

```bash
stow -nv -d stow -t "$HOME" shell environment foot sway waybar
```

If you also want the legacy X11/i3 files available:

```bash
stow -nv -d stow -t "$HOME" i3 x11
```

When you are ready to install for real:

```bash
stow -v -d stow -t "$HOME" shell environment foot sway waybar
```

Legacy X11/i3 packages remain optional:

```bash
stow -v -d stow -t "$HOME" i3 x11
```

To remove packages later:

```bash
stow -D -d stow -t "$HOME" shell environment foot sway waybar
```

## Notes on migrated settings

- `~/.config/foot/foot.ini` now carries the terminal appearance that used to be split between GNOME Terminal profile settings and X11 DPI assumptions.
- `~/.config/environment.d/10-wayland-apps.conf` is the session-wide home for Wayland app environment variables; this replaces putting those exports in `.profile`.
- `.Xresources` and `.xinitrc` are retained only for the optional legacy X11 package.

## First-boot checklist

### Keyboard layout

Edit `stow/sway/.config/sway/config` and fill in the `input type:keyboard` block with your layouts:

```conf
input type:keyboard {
    xkb_layout "us,no"
    xkb_options "grp:win_space_toggle"
}
```

`$mod+Space` cycles through the configured layouts. `Ctrl+Shift+Alt+Space` toggles `ctrl:swapcaps`.

### Verify output names

The workspace helper assigns workspaces 1-5 to external displays and 6-10 to the internal `eDP-*` display. Confirm the names after first boot:

```bash
swaymsg -t get_outputs
```

### NVIDIA GPU (if applicable)

Sway refuses to start with NVIDIA proprietary drivers unless launched with `--unsupported-gpu`.
Without this, sway exits immediately and the login screen reappears. Override the session launcher:

```bash
mkdir -p ~/.local/share/wayland-sessions
cat > ~/.local/share/wayland-sessions/sway.desktop << 'EOF'
[Desktop Entry]
Name=Sway
Comment=An i3-compatible Wayland compositor
Exec=sway --unsupported-gpu
Type=Application
DesktopNames=sway
EOF
```

Also create `~/.config/environment.d/sway-nvidia.conf` with the required environment variables:

```conf
LIBVA_DRIVER_NAME=nvidia
WLR_NO_HARDWARE_CURSORS=1
GBM_BACKEND=nvidia-drm
__GLX_VENDOR_LIBRARY_NAME=nvidia
```

See the [Arch Wiki — sway/NVIDIA](https://wiki.archlinux.org/title/sway#NVIDIA_proprietary_driver) for details.

### Slack / tidal-hifi (XWayland)

Both apps run via XWayland by default, so `class=` window criteria work as-is.
To run them as native Wayland apps, launch with:

```bash
--enable-features=UseOzonePlatform --ozone-platform=wayland
```

and change the scratchpad bindings from `class=` to `app_id=` in `stow/sway/.config/sway/config`.

## Key bindings (changes from i3)

| Action | Binding |
|---|---|
| Screenshot (region) | `$mod+P` |
| Volume up/down | `XF86AudioRaiseVolume` / `XF86AudioLowerVolume` |
| Mute | `XF86AudioMute` |
| Mic mute | `XF86AudioMicMute` |
| Backlight up/down | `XF86MonBrightnessUp` / `XF86MonBrightnessDown` |
| App launcher | `$mod+D` (fuzzel) |
| Keyboard layout toggle | `$mod+Space` |
| Caps/Ctrl swap toggle | `Ctrl+Shift+Alt+Space` |
| System mode | `Ctrl+Alt+Delete` |
| Slack scratchpad | `$mod+BackSpace` |
| Tidal scratchpad | `$mod+M` |
