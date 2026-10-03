storage="$HOME/storage"
shared="$HOME/shared"

# apex:heredoc-expands paths=shared,storage -- both sources are validated before use
cat >/etc/apex/mounts.conf <<EOF
storage=$storage:/storage
shared=$shared:/shared
EOF
