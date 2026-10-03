# Configure pacman after package installation completes. Offline target package
# installs use the live ISO's offline pacman.conf until this final restore.
cp -f "$APEX_PATH/default/pacman/pacman-${APEX_MIRROR:-stable}.conf" /etc/pacman.conf
cp -f "$APEX_PATH/default/pacman/mirrorlist-${APEX_MIRROR:-stable}" /etc/pacman.d/mirrorlist

# Wait for CUPS to own the file, the way apex-settings does, so pacman does
# not turn the override into a .pacnew during ISO package installation.
if [[ -f $APEX_PATH/etc-overrides/cups-cups-files.conf && -f /etc/cups/cups-files.conf ]]; then
  install -m 0640 -o root -g cups "$APEX_PATH/etc-overrides/cups-cups-files.conf" /etc/cups/cups-files.conf
  rm -f /etc/cups/cups-files.conf.pacnew
fi

source "$APEX_INSTALL/hardware/pacman.sh"
