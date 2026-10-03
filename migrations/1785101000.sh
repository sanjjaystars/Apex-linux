echo "Save incoming Taildrop files to ~/Downloads"

if apex-cmd-present tailscale; then
  systemctl --user daemon-reload >/dev/null 2>&1 || true

  # Report what systemctl actually said; "could not enable" on its own gives
  # nothing to act on.
  if ! error=$(systemctl --user enable --now apex-tailscale-receive.service 2>&1); then
    echo "Could not enable apex-tailscale-receive.service: $error"
  fi
fi
