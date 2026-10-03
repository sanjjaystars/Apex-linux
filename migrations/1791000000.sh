echo "Initialize Apex Linux desktop state and default branding"

# Ensure user directories exist
mkdir -p "$HOME/.config/apex" "$HOME/.local/state/apex"

# Set default theme to Apex Dark if not already configured
if [[ ! -s "$HOME/.local/state/apex/current/theme.name" ]]; then
  if command -v apex-theme-set >/dev/null 2>&1; then
    APEX_THEME_HEADLESS=1 apex-theme-set "Apex Dark" 2>/dev/null || true
  fi
fi

# Ensure user application directory exists
mkdir -p "$HOME/.local/share/applications"
