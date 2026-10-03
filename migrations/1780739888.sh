echo "Use dua for Disk Usage TUI"

apex-pkg-add dua-cli
apex-pkg-drop dust

APP_DIR="$HOME/.local/share/applications"
ICON_DIR="$APP_DIR/icons"

if [ -f "$APP_DIR/Disk Usage.desktop" ]; then
  rm "$APP_DIR/Disk Usage.desktop"
  apex-tui-install "Disk Usage" "dua i" float "$ICON_DIR/Disk Usage.png"
fi
