#!/usr/bin/env bash
# Apply workspace-to-output mappings for a kanshi profile.
# Called by kanshi's exec directive on profile activation.
# Usage: sway-workspace-config.sh <profile_name>
#
# For external-monitor profiles: uses swaymsg workspace commands directly to
# avoid swaymsg reload (which re-enables disabled outputs and can spawn a second
# kanshi instance).
# For laptop_only: clears the workspace-outputs.conf and reloads sway (safe
# since no outputs are being disabled).

PROFILE="${1:-laptop_only}"
OUTPUT_FILE="$HOME/.config/sway/workspace-outputs.conf"

case "$PROFILE" in
    Sensio-M4)
        # Apply workspace-to-output assignments directly via swaymsg.
        # Avoids swaymsg reload, which would re-enable eDP-1 and spawn a second
        # kanshi instance when the config symlink was recently changed.
        swaymsg 'workspace 1 output "Lenovo Group Limited P27h-28 V90DFW2V"'
        swaymsg 'workspace 2 output "Lenovo Group Limited P27h-28 V90DFW2V"'
        swaymsg 'workspace 3 output "Lenovo Group Limited P27h-28 V90DFW2V"'
        swaymsg 'workspace 4 output "Lenovo Group Limited P27h-28 V90DFW2V"'
        swaymsg 'workspace 5 output "Lenovo Group Limited P27h-28 V90DFW2V"'
        swaymsg 'workspace 6 output "Lenovo Group Limited P27h-28 V90DFVTC"'
        swaymsg 'workspace 7 output "Lenovo Group Limited P27h-28 V90DFVTC"'
        swaymsg 'workspace 8 output "Lenovo Group Limited P27h-28 V90DFVTC"'
        swaymsg 'workspace 9 output "Lenovo Group Limited P27h-28 V90DFVTC"'
        swaymsg 'workspace 10 output "Lenovo Group Limited P27h-28 V90DFVTC"'
        ;;
    laptop_only|*)
        # No external monitors — reload sway so the include clears any leftover
        # workspace-to-output assignments from a previous profile.
        : > "$OUTPUT_FILE"
        swaymsg reload
        ;;
esac
