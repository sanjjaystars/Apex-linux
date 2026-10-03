# Apex Linux Keybindings Reference

This document provides a comprehensive cheat sheet of all default keybindings in Apex Linux.

Apex uses the **Super key** (Windows key on PC keyboards, Command key on Mac keyboards) as the primary desktop modifier.

To customize or override any keybinding, edit `~/.config/hypr/bindings.lua`.

---

## 1. Application Launchers

| Keybinding | Action | Command / Target |
|---|---|---|
| `Super + Return` | Launch default terminal | Kitty |
| `Super + Shift + Return` | Launch default web browser | Chromium |
| `Super + Shift + B` | Launch default web browser | Chromium |
| `Super + Shift + Alt + B` | Launch private/incognito browser | Chromium (`--private`) |
| `Super + Shift + F` | Launch file manager | Nautilus |
| `Super + Alt + Shift + F` | Launch file manager at terminal CWD | Nautilus (current directory) |
| `Super + Shift + N` | Launch text/code editor | Neovim (`apex editor`) |
| `Super + Alt + Return` | Launch terminal with persistent tmux session | Tmux (`apex-terminal-tmux`) |
| `Super + Ctrl + Return` | Launch remote server orchestration | Herdr (`apex-terminal-herdr`) |
| `Super + Shift + O` | Note-taking and knowledge base | Obsidian |
| `Super + Shift + W` | Distraction-free writing tool | Omawrite |
| `Super + Shift + D` | Docker management container TUI | Lazydocker (`apex-launch-docker-tui`) |
| `Super + Shift + M` | Music player | Spotify |
| `Super + Shift + Alt + M` | Terminal music player TUI | Cliamp |
| `Super + Shift + G` | Encrypted messaging | Signal |
| `Super + Shift + /` | Password manager | 1Password |

---

## 2. Desktop Menus & Utilities

| Keybinding | Action | Description |
|---|---|---|
| `Super + Space` | Apex Root Menu | Interactive command, app, and action runner |
| `Super + Alt + Space` | Applications Menu | Browse all installed desktop applications |
| `Super + K` | Keybindings Search Menu | Interactive searchable list of active bindings |
| `Super + Escape` | System / Power Menu | Lock, suspend, restart, shutdown options |
| `Super + Ctrl + E` | Emoji Picker | Floating emoji selector with clipboard copy |
| `Super + Ctrl + C` | Screen Capture Menu | Screenshot and recording presets |
| `Super + Ctrl + O` | Toggles Menu | Toggle bar, idle, gaps, animations, and sound |
| `Super + Ctrl + H` | Hardware Detection Menu | Inspect hardware-specific controls and tuning |
| `Super + Ctrl + Q` | Calculator | Fast desktop calculator (`omacalc`) |
| `Super + Shift + Space` | Toggle Top Bar | Show or hide the Quickshell desktop top bar |
| `Super + Ctrl + Space` | Wallpaper Switcher | Cycle and select theme backgrounds |
| `Super + Shift + Ctrl + Space` | Theme Switcher | Interactive live theme selector menu |

---

## 3. Window Management & Tiling

| Keybinding | Action | Description |
|---|---|---|
| `Super + Q` / `Super + W` | Close Window | Close the currently focused window |
| `Ctrl + Alt + Delete` | Close All Windows | Close all active client windows in workspace |
| `Super + F` | Fullscreen Toggle | Toggle true fullscreen for active window |
| `Super + Ctrl + F` | Tiled Fullscreen | Maximize window within current tile layout |
| `Super + Alt + F` | Maximize Width | Maximize window width horizontally |
| `Super + T` | Toggle Floating | Switch window between floating and tiled |
| `Super + O` | Pop Out (Float & Pin) | Float active window and pin across workspaces |
| `Super + J` | Toggle Window Split | Switch between horizontal and vertical split |
| `Super + P` | Pseudo Tiling | Preserve window aspect ratio while tiled |
| `Super + Backspace` | Window Transparency | Toggle window background opacity |
| `Super + Shift + Backspace` | Window Gaps | Toggle inner and outer tiling gaps |
| `Super + Left / Right / Up / Down` | Focus Window | Move focus to adjacent window |
| `Super + Shift + Left / Right / Up / Down` | Swap Window | Swap position of active window |
| `Alt + Tab` | Next Window | Cycle focus to next window |
| `Alt + Shift + Tab` | Previous Window | Cycle focus to previous window |

---

## 4. Workspaces & Monitors

| Keybinding | Action | Description |
|---|---|---|
| `Super + 1 .. 9, 0` | Switch Workspace | Jump directly to workspace 1 through 10 |
| `Super + Shift + 1 .. 9, 0` | Move Window to Workspace | Move active window and follow focus |
| `Super + Shift + Alt + 1 .. 9, 0` | Move Window Silently | Move window to workspace without following focus |
| `Super + Tab` | Next Workspace | Cycle forward to the next active workspace |
| `Super + Shift + Tab` | Previous Workspace | Cycle backward to previous workspace |
| `Super + S` / `Super + \`` | Toggle Scratchpad | Show/hide the dropdown floating scratchpad |
| `Super + Alt + S` | Move to Scratchpad | Send active window to the scratchpad |
| `Ctrl + Alt + Tab` | Next Monitor | Move focus to adjacent physical display |
| `Super + Shift + Alt + Left / Right` | Move Workspace Monitor | Move entire workspace to another monitor |

---

## 5. Media, Audio & Brightness

| Keybinding | Action | Description |
|---|---|---|
| `XF86AudioRaiseVolume` | Volume Up | Increase speaker volume (+5%) |
| `XF86AudioLowerVolume` | Volume Down | Decrease speaker volume (-5%) |
| `XF86AudioMute` | Mute Audio | Toggle audio mute |
| `XF86AudioMicMute` | Mute Microphone | Toggle microphone mute |
| `Alt + Volume Up / Down` | Fine Volume Control | Adjust volume in 1% increments |
| `XF86AudioPlay / Pause` | Play / Pause Media | Control active media player playback |
| `XF86AudioNext / Prev` | Next / Prev Track | Skip or rewind audio track |
| `XF86MonBrightnessUp` | Brightness Up | Increase display brightness (+5%) |
| `XF86MonBrightnessDown` | Brightness Down | Decrease display brightness (-5%) |
| `Shift + Brightness Up / Down` | Brightness Max / Min | Jump to 100% or 1% display brightness |
| `XF86KbdBrightnessUp / Down` | Keyboard Backlight | Adjust keyboard backlight illumination |

---

## 6. Screenshots & Screen Recording

| Keybinding | Action | Description |
|---|---|---|
| `Print` | Interactive Screenshot | Select window or rectangular region to capture |
| `Alt + Print` | Screen Recording | Start or stop regional/fullscreen video recording |
| `Super + Print` | Color Picker | Magnified pixel loupe with hex color copy |
| `Super + Ctrl + Print` | OCR Text Extraction | Capture screen region and copy text to clipboard |

---

## 7. Notifications

| Keybinding | Action | Description |
|---|---|---|
| `Super + ,` | Dismiss Notification | Dismiss the newest desktop notification |
| `Super + Shift + ,` | Dismiss All | Clear all visible desktop notifications |
| `Super + Ctrl + ,` | Do Not Disturb | Toggle notification silencing |
| `Super + Alt + ,` | Invoke Action | Trigger default action on newest notification |
| `Super + Shift + Alt + ,` | Notification History | View recent notifications history panel |
