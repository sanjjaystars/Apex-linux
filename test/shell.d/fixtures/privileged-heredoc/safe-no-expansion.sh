cat <<EOF | sudo tee /etc/udev/rules.d/99-apex.rules >/dev/null
SUBSYSTEM=="power_supply", ATTR{type}=="Mains", RUN+="/usr/bin/apex-powerprofiles-set"
EOF
