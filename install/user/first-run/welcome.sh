# Real newlines, not a literal \n: the card renders the body as it arrives, and
# elides past three lines.
apex-notification-send -u critical -g  "Learn Keybindings" \
  $'Super + K for cheatsheet.\nSuper + Space for Apex Menu.' \
  --exec apex-menu-keybindings
