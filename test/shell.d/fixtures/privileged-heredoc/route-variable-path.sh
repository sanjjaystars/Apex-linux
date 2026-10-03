DROP_IN=/etc/systemd/system/apex-agent.service.d/override.conf

cat <<EOF | sudo tee "$DROP_IN" >/dev/null
[Service]
ExecStart=$APEX_PATH/bin/apex-agent
EOF
