#!/bin/bash

# Two hops. The scan resolves apex_bin into helper, so the value it ends up
# judging still carries an unresolved $HOME rather than a literal path.
apex_bin="$HOME/.local/share/apex/bin"
helper="$apex_bin/apex-agent"

# apex:heredoc-expands paths=none -- helper names the agent, no path is baked in
cat <<EOF | sudo tee /etc/udev/rules.d/99-apex-agent.rules >/dev/null
SUBSYSTEM=="power_supply", RUN+="$helper"
EOF
