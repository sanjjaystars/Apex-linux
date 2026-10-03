---
name: apex
description: >
  REQUIRED for end-user customization of Linux desktop, window manager, or system config.
  Use when editing ~/.config/hypr/, ~/.config/apex/,
  ~/.config/alacritty/, ~/.config/foot/, ~/.config/kitty/, or ~/.config/ghostty/.
  Triggers: Hyprland, window rules, animations, keybindings, monitors, gaps, borders,
  blur, opacity, apex-shell, bar, terminal config, themes, background,
  night light, idle, lock screen, screenshots, reminders, layer rules, workspace
  settings, display config, and user-facing apex commands. Excludes Apex
  source development through `apex dev link` workflows.
---

# Apex Skill

Manage [Apex](https://apex.org/) Linux systems - a beautiful, fun, agentic Arch Linux distribution with Hyprland.

This skill is for end-user customization on installed systems.
It is not for contributing to Apex source code.

## When This Skill MUST Be Used

**ALWAYS invoke this skill for end-user requests involving ANY of these:**

- Editing ANY file in `~/.config/hypr/` (window rules, animations, keybindings, monitors, etc.)
- Editing `~/.config/apex/shell.json` (status bar layout, widgets)
- Editing terminal configs (alacritty, foot, kitty, ghostty)
- Editing ANY file in `~/.config/apex/`
- Window behavior, animations, opacity, blur, gaps, borders
- Layer rules, workspace settings, display/monitor configuration
- Themes, backgrounds, fonts, appearance changes
- User-facing `apex` commands (`apex theme ...`, `apex refresh ...`, `apex restart ...`, etc.)
- Screenshots, screen recording, reminders, night light, idle behavior, lock screen

**If you're about to edit a config file in ~/.config/ on this system, STOP and use this skill first.**

**Do NOT use this skill for Apex development tasks** (editing the Apex source tree, creating migrations, or running `apex dev ...` workflows).

## Topic Guides

Deeper instructions for common areas live next to this file. Read the
matching guide before starting:

- [`hyprland.md`](hyprland.md) - keybindings, monitors, window rules, and other Hyprland config
- [`plugins.md`](plugins.md) - the Apex shell: bar layout, widgets, plugins, idle behavior
- [`theming.md`](theming.md) - themes, backgrounds, and fonts
- [`hooks.md`](hooks.md) - automation hooks that run on system events
- [`capture.md`](capture.md) - screenshots, screen recordings, OCR text capture, and file sharing
- [`contributing.md`](contributing.md) - reporting Apex bugs and submitting fixes upstream

## Critical Safety Rules

For privileged commands, follow the Privilege Escalation rules below: `sudo` when a terminal is available for the password prompt, `pkexec` when it is not. Do not wrap commands that already manage privilege elevation themselves.

**For end-user customization tasks, NEVER modify anything in `/usr/share/apex/`** - but READING is safe and encouraged.

This directory is owned by the apex package. Any local changes will be
overwritten on the next `apex update`.

```
/usr/share/apex/     # READ-ONLY - NEVER EDIT (reading is OK)
├── bin/                    # Command source (packaged binaries are on PATH)
├── config/                 # Default config templates
├── themes/                 # Stock themes
├── default/                # System defaults
├── shell/                  # Apex shell source and defaults
├── migrations/             # Update migrations
└── install/                # Installation scripts
```

**Reading `/usr/share/apex/` is SAFE and useful** - do it freely to:
- Understand how apex commands work: `apex theme set --help` or `cat $(which apex-theme-set)`
- See default configs before customizing: `cat "$APEX_PATH/config/apex/shell.json"`
- Check stock theme files to copy for customization
- Reference default hyprland settings: `cat /usr/share/apex/default/hypr/*`

**Always use these safe locations instead:**
- `~/.config/` - User configuration (safe to edit)
- `~/.config/apex/themes/<custom-name>/` - Custom themes
- `~/.config/apex/hooks/` - Custom automation hooks

If the request is to develop Apex itself, this skill is out of scope. Follow repository development instructions instead of this skill.

## Privilege Escalation

For an interactive script or command run in a visible terminal, use `sudo` for
privileged work. Apex may grant passwordless `sudo` access to particular
commands, and the terminal is the appropriate place to request a password
when one is needed.

Use `pkexec` only when the caller cannot interact with a terminal or cannot
enter a password there, such as a command launched by an agent or a graphical
background process. Do not replace `sudo` with `pkexec` merely because a
command changes system state.

## System Architecture

Apex is built on:

| Component | Purpose | Config Location |
|-----------|---------|-----------------|
| **Arch Linux** | Base OS | `/etc/`, `~/.config/` |
| **Hyprland** | Wayland compositor/WM | `~/.config/hypr/` |
| **Apex shell** | Status bar + notifications (Quickshell) | `~/.config/apex/shell.json` |
| **Launcher/menus** | Quickshell menu | `~/.config/apex/extensions/apex-menu.jsonc` |
| **Alacritty/Foot/Kitty/Ghostty** | Terminals | `~/.config/<terminal>/` |
| **Apex OSD** | On-screen display | Quickshell plugin |

## Command Discovery

Apex ships a single `apex` CLI that dispatches to all `apex-*` binaries via `apex <group> <action>`. Always prefer this form — it is self-documenting and stable. The underlying `apex-*` binaries still exist on `PATH` and remain safe to read for source.

```bash
# List every documented command and its summary (--all includes hidden commands)
apex commands

# Show the commands inside a group
apex theme --help
apex refresh --help
apex restart --help

# Show help for a specific command (does not execute it)
apex theme set --help

# Machine-readable listing (binary, route, summary, args, aliases)
apex commands --json

# Read a command's source to understand it
cat $(which apex-theme-set)
```

### Command Groups

Run `apex --help` for the full list. The most common groups:

| Group | Purpose | Example |
|-------|---------|---------|
| `apex refresh` | Reset config to defaults (backs up first) | `apex refresh shell` |
| `apex restart` | Restart a service/app | `apex restart shell` |
| `apex toggle` | Toggle feature on/off | `apex toggle nightlight` |
| `apex theme` | Theme management | `apex theme set <name>` |
| `apex bar` | Bar layout and widgets | `apex bar move apex.clock --section right` |
| `apex plugin` | Manage/clone shell plugins | `apex plugin clone apex.clock` |
| `apex hook` | Install automation hooks | `apex hook install theme-set <script>` |
| `apex install` | Install optional software / packages | `apex install docker dbs` |
| `apex launch` | Launch apps | `apex launch browser` |
| `apex capture` | Screenshots and recordings | `apex capture screenshot` |
| `apex reminder` | Desktop notification reminders | `apex reminder 15 "Pickup Jack"` |
| `apex pkg` | Package management | `apex pkg add <pkg>` |
| `apex setup` | Interactive setup wizards | `apex setup security fingerprint` |
| `apex update` | System updates | `apex update` |

## Configuration Locations

Hyprland config lives in `~/.config/hypr/` — see [`hyprland.md`](hyprland.md).
The Apex shell (bar, notifications, plugins, idle) is configured in
`~/.config/apex/shell.json` — see [`plugins.md`](plugins.md).

### Terminals

```
~/.config/alacritty/alacritty.toml
~/.config/foot/foot.ini
~/.config/kitty/kitty.conf
~/.config/ghostty/config
```

**Command:** `apex restart terminal`

### Other Configs

| App | Location |
|-----|----------|
| btop | `~/.config/btop/btop.conf` |
| fastfetch | `/etc/fastfetch/config.jsonc` default; `~/.config/fastfetch/config.jsonc` user override |
| lazygit | `~/.config/lazygit/config.yml` |
| starship | `~/.config/starship.toml` |
| git | `~/.config/git/config` |

## Safe Customization Patterns

### Edit User Config Directly

For simple changes, edit files in `~/.config/`:

```bash
# 1. Read current config
cat ~/.config/hypr/bindings.lua

# 2. Backup before changes
cp ~/.config/hypr/bindings.lua ~/.config/hypr/bindings.lua.bak.$(date +%s)

# 3. Make changes with Edit tool

# 4. Apply changes
# - Hyprland: auto-reloads on save, but MUST validate with `hyprctl reload` and `hyprctl configerrors`
# - Apex shell: shell.json and user plugin code under ~/.config/apex/plugins/ hot-reload on save
# - Menus/launcher: ~/.config/apex/extensions/apex-menu.jsonc hot-reloads on save
# - Terminals: apply with `apex restart terminal` (reloads running terminals; foot picks changes up in new windows)
```

### Reset to Defaults -- ALWAYS SEEK USER CONFIRMATION BEFORE RUNNING

When customizations go wrong:

```bash
# Reset specific config (creates backup automatically)
apex refresh shell
apex refresh hyprland

# The refresh command:
# 1. Backs up current config with timestamp
# 2. Copies default from $APEX_PATH/config/
# 3. Restarts the component where the refresh needs it (e.g. `refresh shell`)
```

## System Commands

```bash
apex update                  # Full system update
apex version                 # Show Apex version
apex debug --no-sudo --print # Debug info (ALWAYS use these flags)
apex system lock             # Lock screen
apex system shutdown         # Shutdown
apex system reboot           # Reboot
```

**IMPORTANT:** Always run `apex debug` with `--no-sudo --print` flags to avoid interactive sudo prompts that will hang the terminal.

## Troubleshooting

```bash
# Get debug information (ALWAYS use these flags to avoid interactive prompts)
apex debug --no-sudo --print

# Reset specific config to defaults
apex refresh <app>

# Refresh specific config file
# config-file path is relative to ~/.config/
# eg. `apex refresh config hypr/hyprland.lua` will refresh ~/.config/hypr/hyprland.lua
apex refresh config <config-file>

# Full reinstall of configs (nuclear option)
apex reinstall
```

## Decision Framework

When user requests system changes:

1. **Is it a stock apex command?** Use it directly
2. **Is it a config edit?** Edit in `~/.config/`, never `/usr/share/apex/`
3. **Is it a theme customization?** Follow [`theming.md`](theming.md); create a NEW custom theme directory
4. **Is it automation?** Follow [`hooks.md`](hooks.md); use `apex hook install` and the hook `.d` directories
5. **Is it a package install?** Use `apex pkg add <pkgs...>` (or `apex pkg aur add <pkgs...>` for AUR-only packages)
6. **Is it built-in shell/plugin code?** Follow [`plugins.md`](plugins.md); clone it with `apex plugin clone`, never edit the packaged copy
7. **Unsure if command exists?** Run `apex commands` (or `apex <group> --help` for one group)

### Reminder Requests

When the user asks to set a reminder, use `apex reminder <minutes> [message]` directly. Convert natural language durations to minutes and title-case short reminder labels when appropriate.

```bash
apex reminder 15 "Pickup Jack"
apex reminder 60 "Check laundry"
apex reminder show
apex reminder clear
```

## Out of Scope

This skill intentionally does not cover Apex source development. Do not use this skill for:
- Editing files in `/usr/share/apex/` (`bin/`, `config/`, `default/`, `shell/`, `themes/`, `migrations/`, etc.)
- Creating or editing migrations
- Running `apex dev ...` commands

## Example Requests

- "Change my theme to catppuccin" -> `apex theme set catppuccin`
- "Add a keybinding for Super+E to open file manager" -> Check existing bindings first, then use `o.rebind` to replace one or `o.bind` to add one in `~/.config/hypr/bindings.lua`
- "Configure my external monitor" -> Edit `~/.config/hypr/monitors.lua`
- "Make the window gaps smaller" -> Edit `~/.config/hypr/looknfeel.lua`
- "Turn on night light" -> `apex toggle nightlight` (for time-based schedules, edit `~/.config/hypr/hyprsunset.conf` profiles, then `apex restart hyprsunset`)
- "Set a reminder to pickup jack in 15 minutes" -> `apex reminder 15 "Pickup Jack"`
- "Show my reminders" -> `apex reminder show`
- "Clear all reminders" -> `apex reminder clear`
- "Customize the catppuccin theme colors" -> Overlay: put an edited `colors.toml` in `~/.config/apex/themes/catppuccin/`, then re-apply the theme (see `theming.md`)
- "Run a script every time I change themes" -> Install it with `apex hook install theme-set <script>`
- "Change how workspace labels are rendered" -> Clone `apex.workspaces`, which switches the bar to `<username>.workspaces`, then edit the clone
- "Lock after ten minutes" -> Set `idle.lock` to `600` in `~/.config/apex/shell.json`
- "Reset shell/bar to defaults" -> `apex refresh shell`
- "Record my screen" -> `apex screenrecord --fullscreen`, then `apex screenrecord --stop-recording` (see `capture.md`)
- "Report this bug to Apex" -> Gather diagnostics and a capture of the problem, then file it (see `contributing.md`)
