mkdir -p ~/.config/apex

cat >~/.config/apex/agent.conf <<EOF
helper=$HOME/.local/share/apex/bin/apex-agent
EOF

cat >"$HOME/.local/bin/apex-shim" <<EOF
exec "$APEX_PATH/bin/apex-agent" "$@"
EOF
