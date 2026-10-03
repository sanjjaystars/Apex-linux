echo "Switch Brave Origin from the beta to the stable release"

if apex-pkg-present brave-origin-beta-bin; then
  default_browser=$(xdg-settings get default-web-browser 2>/dev/null || true)

  apex-pkg-aur-add brave-origin-bin
  apex-pkg-drop brave-origin-beta-bin

  mkdir -p ~/.config
  cp -f "$APEX_PATH/config/chromium-flags.conf" ~/.config/brave-origin-flags.conf
  rm -f ~/.config/brave-origin-beta-flags.conf

  if [[ $default_browser == "brave-origin-beta.desktop" ]]; then
    apex-default-browser brave-origin
  fi
fi
