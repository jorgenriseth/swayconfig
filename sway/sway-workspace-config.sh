#!/bin/bash
# Dynamically assigns workspace-to-output mappings in the sway config,
# mirroring the logic from i3/i3config-workspace-config.sh.
#
# If external monitors are present:
#   workspaces 1-5  -> first external monitor
#   workspaces 6-10 -> internal display (eDP-*)
# If only the internal display is present:
#   no workspace-to-output mappings are set (sway handles it automatically)

CONFIG_FILE="$HOME/.config/sway/config"
DYNAMIC_SECTION_START="### Dynamic workspace to output mappings"
DYNAMIC_SECTION_END="### End dynamic section"

# Resolve symlink to get the real file path (swaymsg reload reads the real file)
REAL_CONFIG=$(readlink -f "$CONFIG_FILE")

INTERNAL=$(swaymsg -t get_outputs | grep -o '"name": "[^"]*"' | grep -o '[^"]*$' | grep '^eDP' | head -1)
EXTERNAL=$(swaymsg -t get_outputs | grep -o '"name": "[^"]*"' | grep -o '[^"]*$' | grep -v '^eDP' | xargs)

TEMP_CONFIG=$(mktemp)
cp "$REAL_CONFIG" "$TEMP_CONFIG"

# Remove old dynamic section
sed -i "/$DYNAMIC_SECTION_START/,/$DYNAMIC_SECTION_END/d" "$TEMP_CONFIG"

# Append new dynamic section
echo "$DYNAMIC_SECTION_START" >> "$TEMP_CONFIG"
if [ -n "$EXTERNAL" ]; then
    for idx in {1..5}; do
        echo "workspace $idx output $EXTERNAL" >> "$TEMP_CONFIG"
    done
fi
if [ -n "$INTERNAL" ]; then
    for idx in {6..10}; do
        echo "workspace $idx output $INTERNAL" >> "$TEMP_CONFIG"
    done
fi
echo "$DYNAMIC_SECTION_END" >> "$TEMP_CONFIG"

# Only reload if something changed (avoids infinite reload loop)
if ! diff -q "$REAL_CONFIG" "$TEMP_CONFIG" > /dev/null; then
    mv "$TEMP_CONFIG" "$REAL_CONFIG"
    swaymsg reload
else
    rm "$TEMP_CONFIG"
fi
