# docs/THEMES_UPSTREAM.md — Upstream Omarchy Themes Mechanism

**Source:** `reference/omarchy/themes/`, `bin/omarchy-theme-*`, `default/themed/`
**Date:** 2026-10-03

---

## Shipped Themes (21 total)

```
catppuccin        catppuccin-latte   ethereal       everforest
flexoki-light     gruvbox            hackerman       kanagawa
last-horizon      lumon              lupine          matte-black
miasma            nord               osaka-jade      retro-82
ristretto         rose-pine          solitude        tokyo-night
vantablack        white
```

Default theme at install: **tokyo-night** (set by `install/user/theme.sh`).

---

## Theme Directory Structure

Each theme lives in `themes/<name>/` and may contain:

| File | Required | Purpose |
|---|---|---|
| `colors.toml` | Yes | Color palette — all semantic color variables |
| `backgrounds/` | Yes | Background images/videos for this theme |
| `preview.png` | Yes | Screenshot shown in the theme switcher |
| `preview-unlock.png` | No | Preview on lock screen |
| `unlock.png` | No | Lock screen background |
| `icons.theme` | No | Icon theme override |
| `keyboard.rgb` | No | Per-key RGB layout for supported keyboards |
| `shell.lock.toml` | No | Lock screen shell config overlay |
| `neovim.lua` | No | Neovim colorscheme config |
| `vscode.json` | No | VS Code theme extension name |

---

## colors.toml Schema

All themes must define these semantic color keys (from `tokyo-night/colors.toml`):

**Mode:** `mode = "dark"` or `mode = "light"`

**Core palette:**
- `accent`, `selection`, `muted`
- `background`, `dark_background`, `darker_background`, `lighter_background`
- `foreground`, `dark_foreground`, `light_foreground`, `bright_foreground`

**ANSI 8 colors:**
- `red`, `yellow`, `orange`, `green`, `cyan`, `blue`, `magenta`, `brown`

**Bright ANSI:**
- `bright_red`, `bright_yellow`, `bright_green`, `bright_cyan`, `bright_blue`, `bright_magenta`

---

## Template System

`default/themed/` contains `*.tpl` files with `{{ variable }}` placeholders.
`omarchy-theme-set-templates` renders them by substituting color values.

Templates ship for these apps (16 total):

| Template | App |
|---|---|
| `alacritty.toml.tpl` | Alacritty terminal |
| `btop.theme.tpl` | btop monitor |
| `chromium.theme.tpl` | Chromium browser color |
| `claude.json.tpl` | Claude Code theme |
| `foot.ini.tpl` | Foot terminal |
| `ghostty.conf.tpl` | Ghostty terminal |
| `gum_env.lua.tpl` | Gum TUI colors |
| `helix.toml.tpl` | Helix editor |
| `hermes.yaml.tpl` | Hermes AI assistant |
| `hyprland.lua.tpl` | Hyprland colors |
| `hyprland-preview-share-picker.css.tpl` | Screen-share picker |
| `keyboard.rgb.tpl` | Keyboard RGB |
| `kitty.conf.tpl` | Kitty terminal (optional) |
| `neovim.lua.tpl` | Neovim |
| `obsidian.css.tpl` | Obsidian note-taking |
| `pi.json.tpl` | Pi AI |
| `shell.toml.tpl` | Omarchy shell bar |
| `t3code.json.tpl` | T3 Code |
| `vscode-theme.json.tpl` | VS Code |

Template variables use `{{ color_name }}` and `{{ color_name_strip }}` (strip = without `#`).

---

## Theme Application Flow

`omarchy-theme-set <theme-name>` performs:

1. **Resolve theme directory** — checks `~/.config/omarchy/themes/<name>/` first (user-installed), then `$OMARCHY_PATH/themes/<name>/` (shipped).
2. **Lock** `omarchy-theme-set.lock` for atomic switch.
3. **Snapshot** current background for smooth transition.
4. **Stage** theme files to `~/.local/state/omarchy/current/`:
   - Symlink `theme` → resolved theme dir
   - Write `theme.name`
   - Copy or filter files from theme dir (git-installed themes have `alacritty.toml`, `foot.ini`, `ghostty.conf`, `kitty.conf`, `vscode.json` blocked — arbitrary code risk)
5. **Generate** templates via `omarchy-theme-set-templates`.
6. **Apply background** — symlink `current/background` to theme's background.
7. **Signal Hyprland** via `omarchy-shell` IPC for live reload.
8. **Release lock.**
9. **Run post-theme hooks** in parallel:
   - `omarchy-restart-terminal`, `omarchy-restart-hyprctl`, `omarchy-restart-btop`, `omarchy-restart-opencode`, `omarchy-restart-helix`
   - `omarchy-theme-set-foot`, `-tmux`, `-hunk`, `-gnome`, `-pi`, `-claude`, `-hermes`, `-t3code`, `-browser`, `-vscode`, `-obsidian`, `-keyboard`
10. **Run `theme-set` hooks** (`omarchy-hook theme-set <name>`).
11. **Mirror to herdr machines** in background (async, non-blocking).
12. **Warm background selector** cache in background.

---

## User-Installed Themes

Users can install community themes via:
```
omarchy-theme-install https://github.com/example/omarchy-<name>-theme.git
```

These are stored in `~/.config/omarchy/themes/<name>/` and override shipped themes.
Git-installed themes have restricted file staging (no `.lua` or terminal configs)
to prevent code execution.

---

## State Paths

| Path | Content |
|---|---|
| `~/.local/state/omarchy/current/theme` | Symlink → active theme dir |
| `~/.local/state/omarchy/current/theme.name` | Active theme name string |
| `~/.local/state/omarchy/current/next-theme` | Staging dir during switch |
| `~/.local/state/omarchy/current/background` | Symlink → active background |
| `~/.local/state/omarchy/theme-backgrounds/` | Per-theme background selection state |
| `~/.cache/omarchy/background-transitions/` | Snapshot cache for smooth transitions |

---

## Apex Rebrand Notes

- All state paths `~/.local/state/omarchy/` → `~/.local/state/apex/`
- All cache paths `~/.cache/omarchy/` → `~/.cache/apex/`
- `USER_THEMES_PATH` / `OMARCHY_THEMES_PATH` → `APEX_PATH/themes`
- Lock file `/run/user/<uid>/omarchy-theme-set.lock` → `apex-theme-set.lock`
- Shipped themes are neutral (community palettes) — Apex ships them unchanged
- Default theme remains `tokyo-night` unless overridden (see DECISIONS.md)
- A placeholder `default/apex-palette` is logged in OPEN_QUESTIONS.md for a
  future branded Apex palette
