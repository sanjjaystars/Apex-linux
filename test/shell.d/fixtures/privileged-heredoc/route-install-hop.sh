tmp=$(mktemp)

cat >"$tmp" <<EOF
#!/bin/bash
exec "$HOME/.local/share/apex/bin/apex-agent" "$@"
EOF

sudo install -m 0755 "$tmp" /usr/local/bin/apex-agent-shim
