#!/bin/bash
# Apex Linux Live Environment Bashrc

export APEX_PATH=/opt/apex-linux
export PATH="$APEX_PATH/bin:/usr/local/bin:$PATH"

# Display welcome MOTD on interactive shell
if [[ $- == *i* && -f /etc/motd ]]; then
  cat /etc/motd
  echo ""
fi
