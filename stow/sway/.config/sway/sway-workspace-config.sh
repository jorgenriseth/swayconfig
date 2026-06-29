#!/usr/bin/env bash
# Write workspace-to-output mappings for a kanshi profile and reload sway.
# Called by kanshi's exec directive on profile activation.
# Usage: sway-workspace-config.sh <profile_name>

PROFILE="${1:-laptop_only}"
OUTPUT_FILE="$HOME/.config/sway/workspace-outputs.conf"

case "$PROFILE" in
    Sensio-M4)
        # 1-5 → left external (V90DFW2V)
        # 6-10 → right external (V90DFVTC)
        # eDP-1 is disabled in this profile.
        cat > "$OUTPUT_FILE" << 'EOF'
workspace 1 output "Lenovo Group Limited P27h-28 V90DFW2V"
workspace 2 output "Lenovo Group Limited P27h-28 V90DFW2V"
workspace 3 output "Lenovo Group Limited P27h-28 V90DFW2V"
workspace 4 output "Lenovo Group Limited P27h-28 V90DFW2V"
workspace 5 output "Lenovo Group Limited P27h-28 V90DFW2V"
workspace 6 output "Lenovo Group Limited P27h-28 V90DFVTC"
workspace 7 output "Lenovo Group Limited P27h-28 V90DFVTC"
workspace 8 output "Lenovo Group Limited P27h-28 V90DFVTC"
workspace 9 output "Lenovo Group Limited P27h-28 V90DFVTC"
workspace 10 output "Lenovo Group Limited P27h-28 V90DFVTC"
EOF
        ;;
    laptop_only|*)
        # No workspace-to-output assignments; sway handles placement automatically.
        : > "$OUTPUT_FILE"
        ;;
esac

swaymsg reload
