tmp=/tmp/apex-generated
copy=$tmp
cat >"$tmp" <<EOF
command=$HOME/.local/share/apex/bin/example
EOF
sudo install -m644 "$copy" /etc/apex/example.conf
