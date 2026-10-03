# `>|` is a plain redirect with noclobber overridden, not a redirect into a pipe.
cat >|/etc/apex/agent.conf <<EOF
helper=$HOME/.local/share/apex/bin/apex-agent
EOF
