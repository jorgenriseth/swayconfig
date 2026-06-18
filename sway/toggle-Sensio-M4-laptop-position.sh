#!/usr/bin/env bash
# Toggle the laptop screen between left and right of the two external monitors.
# Only intended for the Sensio-M4 profile (2× Lenovo P27h-28 + eDP-1).
# Outputs are looked up by serial so port names (DP-5, DP-8, etc.) don't matter.
#
# Logical pixel dimensions (physical / scale):
#   eDP-1   : 3840x2400 @ scale 2.0  → 1920 logical px wide
#   P27h-28 : 2560x1440 @ scale 1.0  → 2560 logical px wide
#
# laptop-right:  [V90DFW2V 0,0] [V90DFVTC 2560,0] [eDP-1 5120,0]
# laptop-left:   [eDP-1 0,0] [V90DFW2V 1920,0] [V90DFVTC 4480,0]

OUTPUTS=$(swaymsg -t get_outputs)

LAPTOP=$(echo "$OUTPUTS" | jq -r '.[] | select(.make=="Sharp Corporation" and .model=="0x14D0") | .name')
LEFT_EXT=$(echo "$OUTPUTS" | jq -r '.[] | select(.serial=="V90DFW2V") | .name')   # workspaces 1-4
RIGHT_EXT=$(echo "$OUTPUTS" | jq -r '.[] | select(.serial=="V90DFVTC") | .name')  # workspaces 5-7

if [ -z "$LAPTOP" ] || [ -z "$LEFT_EXT" ] || [ -z "$RIGHT_EXT" ]; then
    echo "toggle-laptop-position: not all expected outputs are connected, aborting." >&2
    exit 1
fi

LAPTOP_X=$(echo "$OUTPUTS" | jq --arg name "$LAPTOP" '.[] | select(.name==$name) | .rect.x')

if [ "$LAPTOP_X" -eq 0 ]; then
    # Currently laptop-left → switch to laptop-right
    swaymsg "output $LEFT_EXT  position 0    0"
    swaymsg "output $RIGHT_EXT position 2560 0"
    swaymsg "output $LAPTOP    position 5120 0"
else
    # Currently laptop-right → switch to laptop-left
    swaymsg "output $LAPTOP    position 0    0"
    swaymsg "output $LEFT_EXT  position 1920 0"
    swaymsg "output $RIGHT_EXT position 4480 0"
fi
