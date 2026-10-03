echo "Apply the NVIDIA video driver fix on hybrid laptops"

if apex-hw-nvidia && ! apex-hw-nvidia-display; then
  # Hyprland applies env at startup. Reloading the updated defaults cannot
  # clear the old overrides inherited by the compositor and its applications.
  apex-state set reboot-required
  echo "Reboot to stop forcing NVIDIA VA-API/GLX drivers on the integrated GPU."
fi
