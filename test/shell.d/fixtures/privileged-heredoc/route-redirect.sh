# A plain redirect into /etc, no sudo: the command re-execs itself as root.
cat >/etc/apex/agent.conf <<EOF
helper=$HOME/.local/share/apex/bin/apex-agent
EOF
