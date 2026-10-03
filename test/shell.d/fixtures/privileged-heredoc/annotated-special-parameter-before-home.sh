# apex:heredoc-expands paths=none -- the positional argument is a scalar
sudo tee /etc/apex/example.conf <<EOF
argument=$1
command=$HOME/.local/share/apex/bin/example
EOF
