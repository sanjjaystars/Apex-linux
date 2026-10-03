echo "Enable Dell XPS 13 sidecar speaker amplifiers"

if apex-hw-dell-xps13-sidecar-amps; then
  source "$APEX_PATH/install/hardware/dell-xps13-sidecar-amps.sh"
  apex-state set reboot-required
fi
