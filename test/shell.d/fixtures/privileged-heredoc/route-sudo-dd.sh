sudo dd status=none of=/etc/apex/boot.conf <<EOF
cmdline=$boot_params
EOF
