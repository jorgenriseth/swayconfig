# swayconfig

Sway window manager configuration, migrated from i3.

## Install packages

```bash
sudo apt install \
    sway \
    swayidle \
    swaylock \
    waybar \
    mako-notifier \
    fuzzel \
    grim \
    slurp \
    swappy \
    brightnessctl \
    pavucontrol \
    foot \
    blueman \
    network-manager-gnome
```

## Symlink config files

```bash
mkdir -p ~/.config/sway ~/.config/waybar

ln -s ~/software/swayconfig/sway/swayconfig ~/.config/sway/config
ln -s ~/software/swayconfig/sway/waybar      ~/.config/waybar
```

## First-boot checklist

### Keyboard layout

Edit `sway/swayconfig` and fill in the `input type:keyboard` block with your layouts:

```
input type:keyboard {
    xkb_layout "us,no"
    xkb_options "grp:win_space_toggle"
}
```

`$mod+Space` cycles through the configured layouts. `Ctrl+Shift+Alt+Space` toggles `ctrl:swapcaps`.

### Verify output names

Workspace 6–10 are pinned to `eDP-1`. Confirm the name matches your hardware after first boot:

```bash
swaymsg -t get_outputs
```

Update the `workspace N output` lines in `sway/swayconfig` if needed.

### NVIDIA GPU (if applicable)

Sway with NVIDIA requires extra environment variables. Create
`~/.config/environment.d/sway-nvidia.conf`:

```
LIBVA_DRIVER_NAME=nvidia
WLR_NO_HARDWARE_CURSORS=1
GBM_BACKEND=nvidia-drm
__GLX_VENDOR_LIBRARY_NAME=nvidia
```

See the [Arch Wiki — sway/NVIDIA](https://wiki.archlinux.org/title/sway#NVIDIA_proprietary_driver) for details.

### Slack / tidal-hifi (XWayland)

Both apps run via XWayland by default, so `class=` window criteria work as-is.
To run them as native Wayland apps, launch with:

```
--enable-features=UseOzonePlatform --ozone-platform=wayland
```

and change the scratchpad bindings from `class=` to `app_id=` in `sway/swayconfig`.

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
