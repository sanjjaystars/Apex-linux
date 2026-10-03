#!/bin/bash
# Apex Linux theme verification test suite and manual verification checklist.
# Automates validation of colors.toml, backgrounds, previews, and template substitution.

set -euo pipefail

APEX_PATH="${APEX_PATH:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
THEMES_DIR="$APEX_PATH/themes"

REQUIRED_KEYS=(
  mode
  accent selection muted
  background dark_background darker_background lighter_background
  foreground dark_foreground light_foreground bright_foreground
  red yellow orange green cyan blue magenta brown
  bright_red bright_yellow bright_green bright_cyan bright_blue bright_magenta
)

echo "=== Running Apex Linux Theme Suite Validation ==="

total_themes=0
failed_themes=0

for theme_path in "$THEMES_DIR"/*; do
  [[ -d "$theme_path" ]] || continue
  theme_name=$(basename "$theme_path")
  (( total_themes++ ))
  errors=()

  # 1. Check colors.toml
  colors_file="$theme_path/colors.toml"
  if [[ ! -f "$colors_file" ]]; then
    errors+=("Missing colors.toml")
  else
    # Verify required keys
    for key in "${REQUIRED_KEYS[@]}"; do
      if ! grep -qE "^[[:space:]]*${key}[[:space:]]*=" "$colors_file"; then
        errors+=("Missing required key '$key' in colors.toml")
      fi
    done

    # Verify format for required keys
    for key in "${REQUIRED_KEYS[@]}"; do
      val=$(grep -E "^[[:space:]]*${key}[[:space:]]*=" "$colors_file" | head -n1 | cut -d'=' -f2- | tr -d '[:space:]"'\''')
      if [[ "$key" == "mode" ]]; then
        if [[ "$val" != "dark" && "$val" != "light" ]]; then
          errors+=("Invalid mode '$val' (must be 'dark' or 'light')")
        fi
      elif [[ ! "$val" =~ ^#[0-9a-fA-F]{6}$ ]]; then
        errors+=("Invalid hex color for '$key': '$val'")
      fi
    done
  fi

  # 2. Check backgrounds directory
  bg_dir="$theme_path/backgrounds"
  if [[ ! -d "$bg_dir" ]]; then
    errors+=("Missing backgrounds/ directory")
  else
    bg_count=$(find "$bg_dir" -maxdepth 1 -type f \( -name "*.png" -o -name "*.jpg" -o -name "*.webp" -o -name "*.mp4" \) | wc -l)
    if (( bg_count == 0 )); then
      errors+=("No valid wallpapers in backgrounds/")
    fi
  fi

  # 3. Check preview.png
  if [[ ! -s "$theme_path/preview.png" ]]; then
    errors+=("Missing or empty preview.png")
  fi

  if (( ${#errors[@]} == 0 )); then
    echo "  [PASS] Theme '$theme_name' valid"
  else
    echo "  [FAIL] Theme '$theme_name':"
    for err in "${errors[@]}"; do
      echo "         - $err"
    done
    (( failed_themes++ ))
  fi
done

echo ""
echo "=== Theme Suite Summary ==="
echo "Total Themes Tested: $total_themes"
echo "Passed: $(( total_themes - failed_themes ))"
echo "Failed: $failed_themes"

cat <<'CHECKLIST'

======================================================
Manual Theme Visual Inspection Checklist (for live UI)
======================================================
When running inside a graphical Hyprland session:
1. Run: apex theme set "Apex Dark"
   - Verify Hyprland window active border changes to electric sky cyan (#38bdf8).
   - Verify inactive borders change to subtle muted slate (#475569).
   - Verify top bar background changes to deep obsidian slate (#020617).
   - Verify Kitty/Foot terminal background and foreground match colors.toml.
   - Verify btop TUI adapts the theme palette cleanly.
   - Verify desktop wallpaper changes smoothly without flicker.
2. Run: apex theme set "Apex Light"
   - Verify clean daylight frost paper theme (#f8fafc) applies across windows.
   - Verify top bar switches to light mode with high-contrast text and blue active pill.
   - Verify terminal text remains sharp and readable with dark text on light background.
3. Run: apex theme set "Apex Crimson"
   - Verify stealth charcoal palette with vivid carmine rose window borders (#f43f5e).
4. Run: apex theme set "Apex Emerald"
   - Verify calming dark forest background with mint emerald active elements (#10b981).
5. Switch across all other themes (Catppuccin, Tokyo Night, Nord, Gruvbox)
   - Ensure no lingering colors or unexpanded template variables remain in ~/.config/.
======================================================
CHECKLIST

if (( failed_themes > 0 )); then
  exit 1
fi
exit 0
