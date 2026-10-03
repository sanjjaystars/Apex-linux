if apex-battery-present; then
  # apex:heredoc-expands paths=none -- only interpolates the apex bin path
  cat <<EOF | sudo tee "/etc/udev/rules.d/99-power-profile.rules"
SUBSYSTEM=="power_supply", ATTR{type}=="Mains", RUN+="/usr/bin/systemd-run --no-block --collect --unit=apex-power-profile --property=After=power-profiles-daemon.service $HOME/.local/share/apex/bin/apex-powerprofiles-set"
SUBSYSTEM=="power_supply", ATTR{type}=="USB", RUN+="/usr/bin/systemd-run --no-block --collect --unit=apex-power-profile --property=After=power-profiles-daemon.service $HOME/.local/share/apex/bin/apex-powerprofiles-set"
EOF

  sudo systemctl enable power-profiles-daemon

  sudo udevadm control --reload 2>/dev/null
  sudo udevadm trigger --subsystem-match=power_supply 2>/dev/null
fi
