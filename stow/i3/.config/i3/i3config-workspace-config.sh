#!/usr/bin/env bash

HOME=/home/jorgen
CONFIG_FILE="$HOME/.config/i3/config"
TEMP_CONFIG="$HOME/.config/i3/temp_config"
DYNAMIC_SECTION_START="### Dynamic workspace to output mappings"
DYNAMIC_SECTION_END="### End dynamic section"

INTERNAL=$(xrandr --listmonitors | grep 'eDP' | awk '{print $4}')
EXTERNAL=$(xrandr --listmonitors | grep -v 'eDP' | grep 'HDMI\|DP-' | awk '{print $4}' | xargs)

cp "$CONFIG_FILE" "$TEMP_CONFIG"

sed -i "/$DYNAMIC_SECTION_START/,/$DYNAMIC_SECTION_END/d" "$TEMP_CONFIG"

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

if ! diff "$CONFIG_FILE" "$TEMP_CONFIG" >/dev/null; then
  mv "$TEMP_CONFIG" "$CONFIG_FILE"
  i3-msg reload
else
  rm "$TEMP_CONFIG"
fi