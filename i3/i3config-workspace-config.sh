#!/bin/bash
HOME=/home/jorgen
CONFIG_FILE="$HOME/.config/i3/config"
TEMP_CONFIG="$HOME/.config/i3/temp_config"
DYNAMIC_SECTION_START="### Dynamic workspace to output mappings"
DYNAMIC_SECTION_END="### End dynamic section"

# Get internal and external monitor names using xrandr
INTERNAL=$(xrandr --listmonitors | grep 'eDP' | awk '{print $4}')
EXTERNAL=$(xrandr --listmonitors | grep -v 'eDP' | grep "HDMI\|DP-" | awk '{print $4}' | xargs)
echo $HOME $INTERNAL $EXTERNAL $CONFIG_FILE $TEMP_CONFIG bananana

# Create a temporary config file for comparison
cp "$CONFIG_FILE" "$TEMP_CONFIG"

# Remove the old dynamic section from the temp config
sed -i "/$DYNAMIC_SECTION_START/,/$DYNAMIC_SECTION_END/d" "$TEMP_CONFIG"

# Append the new dynamic workspace-to-monitor mapping to the i3 config
echo "$DYNAMIC_SECTION_START" >>"$TEMP_CONFIG"
if [ -n "$EXTERNAL" ]; then
  for idx in {1..5}; do
    echo "workspace $idx output $EXTERNAL" >>"$TEMP_CONFIG"
  done
fi
if [ -n "$INTERNAL" ]; then
  for idx in {6..10}; do
    echo "workspace $idx output $INTERNAL" >>"$TEMP_CONFIG"
  done
fi
echo "$DYNAMIC_SECTION_END" >>"$TEMP_CONFIG"

# Compare the modified temp config with the current one
if ! diff "$CONFIG_FILE" "$TEMP_CONFIG" >/dev/null; then
  # If there are differences, replace the original config and reload i3
  mv "$TEMP_CONFIG" "$CONFIG_FILE"
  i3-msg reload
else
  # If no changes were detected, remove the temp config
  rm "$TEMP_CONFIG"
fi
