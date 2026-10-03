# Set default XCompose that is triggered with CapsLock
tee ~/.XCompose >/dev/null <<EOF
# Run apex-restart-xcompose to apply changes

# Include fast emoji access
include "/usr/share/apex/default/xcompose"

# Identification
<Multi_key> <space> <n> : "$APEX_USER_NAME"
<Multi_key> <space> <e> : "$APEX_USER_EMAIL"
EOF
