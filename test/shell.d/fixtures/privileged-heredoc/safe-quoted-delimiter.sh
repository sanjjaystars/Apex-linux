cat <<'EOF' | sudo tee /etc/udev/rules.d/99-apex.rules >/dev/null
SUBSYSTEM=="power_supply", RUN+="/usr/bin/apex-powerprofiles-set $HOME"
EOF

cat <<"XML" | sudo tee /etc/apex/agent.xml >/dev/null
<config path="$HOME/.local/share/apex" />
XML
