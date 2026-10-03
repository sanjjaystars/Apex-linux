#!/bin/bash

# apex:heredoc-expands paths=none -- review regression fixture
sudo tee /etc/apex/review.conf >/dev/null <<EOF
ExecStart=${target:-$HOME/.local/bin/payload}
EOF
