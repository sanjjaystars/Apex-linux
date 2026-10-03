tmp=/tmp/apex-generated
cat >"$tmp" <<EOF
command=$HOME/.local/share/apex/bin/example
EOF
sudo install -m644 "${tmp}" /etc/apex/example.conf
