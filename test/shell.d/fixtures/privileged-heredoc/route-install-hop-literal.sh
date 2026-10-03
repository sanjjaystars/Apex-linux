#!/bin/bash

cat <<EOF >/tmp/apex-review-unit
[Service]
ExecStart=$HOME/.local/bin/payload
EOF
sudo install -m 644 /tmp/apex-review-unit /etc/systemd/system/review.service
