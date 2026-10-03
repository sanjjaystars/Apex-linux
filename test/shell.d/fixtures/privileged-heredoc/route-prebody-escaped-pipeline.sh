#!/bin/bash

cat <<EOF | \
  sudo tee /etc/apex/review.conf
ExecStart=$HOME/.local/bin/payload
EOF
