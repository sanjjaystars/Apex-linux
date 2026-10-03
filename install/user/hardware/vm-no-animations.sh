# A VM usually renders on the CPU, where animations and transparency cost
# every frame, so start it without them. apex-toggle-animations brings them
# back. This runs before any Hyprland session exists, so place the flag
# directly rather than through apex-hyprland-toggle, which reloads Hyprland.
if apex-hw-vm; then
  echo "Detected a virtual machine. Turning off animations and transparency."
  mkdir -p "$HOME/.local/state/apex/toggles/hypr"
  cp "$APEX_PATH/default/hypr/toggles/no-animations.lua" "$HOME/.local/state/apex/toggles/hypr/"
fi
