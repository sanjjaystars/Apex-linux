# Apex Linux Theme Contract and Architecture

This document defines the authoritative theme folder contract, file specifications, color palette schema, and the application reload pipeline for Apex Linux.

---

## 1. Overview & Directory Locations

Themes customize the complete visual appearance of the Apex desktop across all desktop components and applications: window borders, top bar, lock screen, terminals, editors, system tools, and web browser accents.

Themes are resolved in two locations (with user themes taking priority):
1. **User Themes**: `~/.config/apex/themes/<theme-name>/`
2. **System Shipped Themes**: `$APEX_PATH/themes/<theme-name>/` (typically `/usr/share/apex/themes/<theme-name>/`)

When a theme is activated via `apex-theme-set <theme-name>`:
- The theme's palette from `colors.toml` is parsed.
- Templates under `$APEX_PATH/default/themed/*.tpl` are rendered into concrete configuration files.
- The active theme state is saved to `~/.local/state/apex/current/theme/` and `~/.local/state/apex/current/theme.name`.
- Live reload hooks notify running desktop components (Hyprland, Quickshell, Kitty, etc.) without requiring a session restart.

---

## 2. Theme Directory Contract

Each theme is contained within a self-contained directory named identically to the theme slug (e.g., `themes/apex-dark/`).

| File / Directory | Status | Format | Description |
|---|---|---|---|
| `colors.toml` | **Required** | TOML | Semantic color palette definition. |
| `backgrounds/` | **Required** | Directory | One or more wallpaper images (`.png`, `.jpg`, `.webp`) or animated video backgrounds (`.mp4`). |
| `preview.png` | **Required** | PNG image | 600x400 screenshot displayed in the theme selection UI and manual. |
| `preview-unlock.png` | Optional | PNG image | Preview thumbnail displayed on the lock screen theme switcher. |
| `unlock.png` | Optional | PNG image | Dedicated background image displayed on the lock screen. Defaults to wallpaper if omitted. |
| `icons.theme` | Optional | Plain text | Name of the icon theme to activate (e.g., `Yaru`, `Papirus-Dark`). |
| `keyboard.rgb` | Optional | Plain text | Per-key RGB layout for supported hardware (e.g. Framework 16 keyboard matrix). |
| `shell.lock.toml` | Optional | TOML | Lock screen shell overlay settings. |
| `neovim.lua` | Optional | Lua script | Direct Neovim color scheme override script. |
| `vscode.json` | Optional | JSON | Target theme ID for Visual Studio Code. |

---

## 3. colors.toml Specification

`colors.toml` defines 26 standardized color variables in valid hex format (`#RRGGBB`).

### Schema Definition

```toml
mode = "dark" # "dark" or "light"

# Primary accents and selections
accent = "#38bdf8"
selection = "#1e293b"
muted = "#475569"

# Background hierarchy (from base to elevated surfaces)
background = "#0f172a"
dark_background = "#0b1120"
darker_background = "#020617"
lighter_background = "#1e293b"

# Foreground hierarchy (text and icons)
foreground = "#e2e8f0"
dark_foreground = "#64748b"
light_foreground = "#f1f5f9"
bright_foreground = "#ffffff"

# Standard ANSI 8 Colors
red = "#f43f5e"
yellow = "#eab308"
orange = "#f97316"
green = "#10b981"
cyan = "#06b6d4"
blue = "#3b82f6"
magenta = "#a855f7"
brown = "#78350f"

# Bright ANSI 6 Colors
bright_red = "#fb7185"
bright_yellow = "#fde047"
bright_green = "#34d399"
bright_cyan = "#22d3ee"
bright_blue = "#60a5fa"
bright_magenta = "#c084fc"
```

### Color Roles and Usages

- `mode`: Controls whether applications adapt light or dark icon variations and Chromium/GTK color preferences.
- `accent`: Primary visual highlight color used for active window borders, focused bar tabs, active buttons, and cursor accents.
- `selection`: Background color for highlighted text, active list items, and selected table rows.
- `muted`: Subdued text, inactive tabs, subtle borders, and placeholder text.
- `background`: Standard application and desktop background.
- `dark_background`: Darker surface for toolbars, sidebars, and dropdown headers.
- `darker_background`: Deepest background used for terminal canvasses and modal dimmers.
- `lighter_background`: Elevated surface for tooltips, card backgrounds, and popups.
- `foreground`: Default readable text and UI glyphs.
- `dark_foreground`: Secondary comments, subtle metadata, and muted indicators.
- `light_foreground`: High-contrast body text.
- `bright_foreground`: Bold headers, emphasized keybindings, and active titles.
- `red` - `brown`: Standard syntax highlighting, warnings, errors, and status notifications.
- `bright_*`: Vibrant syntax and high-visibility terminal ANSI outputs.

---

## 4. The Template Engine

Templates are stored in `$APEX_PATH/default/themed/*.tpl`. When `apex-theme-set` executes, the template engine processes each file and substitutes color tokens:
- `{{ variable }}`: Replaced with the color value including the `#` prefix (e.g. `#38bdf8`).
- `{{ variable_strip }}`: Replaced with the raw hex string without `#` (e.g. `38bdf8`).

### Supported Target Configurations

| Template | Rendered Target Location | Application |
|---|---|---|
| `alacritty.toml.tpl` | `~/.config/alacritty/theme.toml` | Alacritty terminal |
| `btop.theme.tpl` | `~/.config/btop/themes/current.theme` | btop system monitor |
| `chromium.theme.tpl` | `~/.config/chromium/Policies/managed/` | Chromium window accents |
| `claude.json.tpl` | `~/.claude/theme.json` | Claude Code CLI |
| `foot.ini.tpl` | `~/.config/foot/theme.ini` | Foot terminal emulator |
| `ghostty.conf.tpl` | `~/.config/ghostty/theme` | Ghostty terminal |
| `gum_env.lua.tpl` | `~/.config/apex/gum.env` | Glamour / Gum TUI scripts |
| `helix.toml.tpl` | `~/.config/helix/themes/apex.toml` | Helix editor |
| `hermes.yaml.tpl` | `~/.config/hermes/theme.yaml` | Hermes agent |
| `hyprland.lua.tpl` | `~/.config/hypr/theme.conf` | Hyprland window borders & shadows |
| `hyprland-preview-share-picker.css.tpl` | `~/.config/hypr/share-picker.css` | Screen-share modal |
| `keyboard.rgb.tpl` | `~/.config/apex/keyboard.rgb` | Keyboard matrix RGB lighting |
| `kitty.conf.tpl` | `~/.config/kitty/theme.conf` | Kitty terminal |
| `neovim.lua.tpl` | `~/.config/nvim/lua/theme.lua` | Neovim colorscheme |
| `obsidian.css.tpl` | `~/.config/obsidian/snippets/theme.css` | Obsidian markdown notes |
| `pi.json.tpl` | `~/.config/pi/theme.json` | Pi AI assistant |
| `shell.toml.tpl` | `~/.config/apex/shell/theme.toml` | Quickshell desktop top bar |
| `t3code.json.tpl` | `~/.config/t3/theme.json` | T3 code editor |
| `vscode-theme.json.tpl` | `~/.config/Code/User/settings.json` | VS Code / VSCodium |

---

## 5. Live Reload Pipeline

Theme switching runs atomically without user session logout:
1. `apex-theme-set <name>` acquires file lock `~/.local/state/apex/theme-set.lock`.
2. Verifies `colors.toml` syntax and required variables.
3. Renders all templates to temporary buffers, then writes atomically to target paths.
4. Updates background wallpaper via `swww` or `hyprpaper`.
5. Dispatches IPC reload signals:
   - Hyprland: `hyprctl reload`
   - Quickshell: Top bar updates automatically via state file watchers.
   - Kitty: `kitty @ set-colors` or signal `SIGUSR1`.
   - GTK / Flatpak: GSettings `gtk-theme` and `color-scheme` preferences updated.
6. Writes active theme marker to `~/.local/state/apex/current/theme.name`.

---

## 6. Shipped Themes Gallery

Apex ships with 26 curated themes, including 4 bespoke flagship palettes engineered specifically for Apex:

| Theme Name | Mode | Accent Hex | Background Hex | Description |
|---|---|---|---|---|
| **Apex Dark** | Dark | `#38bdf8` | `#0f172a` | Flagship dark palette with deep void slate background and electric sky cyan accent. |
| **Apex Light** | Light | `#2563eb` | `#f8fafc` | Clean frost daylight palette with high-contrast azure blue accents. |
| **Apex Crimson** | Dark | `#f43f5e` | `#140e11` | Stealth charcoal obsidian background with intense carmine rose accents. |
| **Apex Emerald** | Dark | `#10b981` | `#091310` | Calming dark forest night background paired with vibrant mint emerald highlights. |
| **Catppuccin** | Dark | `#cba6f7` | `#1e1e2e` | Soothing pastel theme based on Catppuccin Mocha. |
| **Catppuccin Latte** | Light | `#1e66f5` | `#eff1f5` | Warm, low-strain light palette from Catppuccin. |
| **Ethereal** | Dark | `#bd93f9` | `#16161e` | Deep vapor violet aesthetics. |
| **Everforest** | Dark | `#a7c080` | `#2d353b` | Organic, natural forest green tones with soft contrast. |
| **Flexoki Light** | Light | `#205ea6` | `#fffcf0` | Inky warm paper palette designed for long reading sessions. |
| **Gruvbox** | Dark | `#d79921` | `#282828` | Classic retro groove with warm autumnal earth tones. |
| **Hackerman** | Dark | `#00ff00` | `#0d1117` | High-voltage phosphor matrix green on deep carbon black. |
| **Kanagawa** | Dark | `#7e9cd8` | `#1f1f28` | Inspired by classic Japanese woodblock prints with indigo tones. |
| **Last Horizon** | Dark | `#e06c75` | `#1e1e1e` | Twilight dusk horizon aesthetic. |
| **Lumon** | Dark | `#56b6c2` | `#1a1e24` | Corporate retro-minimalist Severance aesthetic. |
| **Lupine** | Dark | `#b48ead` | `#2e3440` | Arctic wolf twilight with lilac and slate accents. |
| **Matte Black** | Dark | `#767676` | `#121212` | Pure monochromatic ultra-matte minimalism. |
| **Miasma** | Dark | `#78a760` | `#222222` | Muted swamp and fog organic tones. |
| **Nord** | Dark | `#88c0d0` | `#2e3440` | Iconic arctic frost blue palette. |
| **Osaka Jade** | Dark | `#50a14f` | `#1e2022` | Japanese garden moss and stone aesthetic. |
| **Retro 82** | Dark | `#e5c07b` | `#1b1d1e` | 1982 vintage microcomputer warm phosphor. |
| **Ristretto** | Dark | `#ff6188` | `#2c2525` | Rich roasted coffee dark hues. |
| **Rose Pine** | Dark | `#ebbcba` | `#191724` | Moody pine needles and rose petals. |
| **Solitude** | Dark | `#7daea3` | `#1e2021` | Quiet, peaceful deep twilight solitude. |
| **Tokyo Night** | Dark | `#7aa2f7` | `#1a1b26` | Vibrant neon night lights across downtown Tokyo. |
| **Vantablack** | Dark | `#ffffff` | `#000000` | Pitch black OLED background with pure white contrast. |
| **White** | Light | `#000000` | `#ffffff` | Stark pristine high-contrast monochrome paper. |

