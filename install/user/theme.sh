# Setup user theme folder and seed the default only when no theme exists yet.
mkdir -p ~/.config/apex/themes

if [[ ! -s $HOME/.local/state/apex/current/theme.name ]]; then
  # iso-chroot and provision-owner both run without a live session to notify.
  if [[ ${APEX_SETUP_CONTEXT:-runtime} != "runtime" ]]; then
    APEX_THEME_HEADLESS=1 apex-theme-set "Tokyo Night"
    rm -f ~/.config/chromium/SingletonLock # otherwise archiso owns the Chromium singleton
  else
    apex-theme-set "Tokyo Night"
  fi
fi
apex-theme-set-pi --activate

mkdir -p ~/.config/btop/themes
ln -snf "$HOME/.local/state/apex/current/theme/btop.theme" ~/.config/btop/themes/current.theme
