mask=$((1 << bits))

cat >/etc/apex/agent.conf <<EOF
helper=$HOME/.local/share/apex/bin/apex-agent
EOF
