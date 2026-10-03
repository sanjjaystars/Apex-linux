# docs/BIN_COMMANDS.md — Upstream Omarchy bin/ Commands

**Source:** `reference/omarchy/bin/` (479 files: 1 router + 478 sub-commands)
**Method:** `omarchy:summary=` metadata extracted via `grep -m1` from each script header.
**Date:** 2026-10-03

The `omarchy` binary is a router that dispatches to `omarchy-<group>-<subcommand>` or
`omarchy-<command>` scripts. Commands tagged `# omarchy:hidden=true` are internal;
they are included here marked **✓** in the Hidden column.

Total: **478 sub-commands** across **23 groups**.

---

## Group: `apply` (2) — System and hardware application (root, chroot)

| Command | Hidden | Summary |
|---|:---:|---|
| `omarchy-apply-hardware` | ✓ | Apply Omarchy hardware-specific packages and system configuration |
| `omarchy-apply-system` | ✓ | Apply Omarchy system setup in the installed target |

## Group: `audio` (3) — Audio input and output controls

| Command | Hidden | Summary |
|---|:---:|---|
| `omarchy-audio-output-sink` |  | Print the sink whose volume and mute a given output really uses |
| `omarchy-audio-sink-availability` |  | Print PulseAudio sink availability for the shell |
| `omarchy-audio-tuning` |  | Manage the speaker tuning for this laptop |

## Group: `bar` (1) — Omarchy shell bar layout and settings

| Command | Hidden | Summary |
|---|:---:|---|
| `omarchy-bar` |  | Configure the bar and its widget layout |

## Group: `bluetooth` (2) — Bluetooth device controls

| Command | Hidden | Summary |
|---|:---:|---|
| `omarchy-bluetooth-device` |  | Control a Bluetooth device |
| `omarchy-bluetooth-power` |  | Turn Bluetooth on or off, remembered across reboots |

## Group: `branding` (3) — About and screensaver branding

| Command | Hidden | Summary |
|---|:---:|---|
| `omarchy-branding-about` |  | Edit, set, or reset About branding |
| `omarchy-branding-about-animation` | ✓ | Shared helpers for animating the About branding (source this, don't run it). |
| `omarchy-branding-screensaver` |  | Edit, set, or reset screensaver branding |

## Group: `capture` (5) — Screenshots and screen recording

| Command | Hidden | Summary |
|---|:---:|---|
| `omarchy-capture-qr` |  | Decode a QR code from a screenshot region |
| `omarchy-capture-screenrecording` |  | Start or stop screen recording |
| `omarchy-capture-screenshot` |  | Take a screenshot |
| `omarchy-capture-text` |  | Extract text from a screenshot region with OCR |
| `omarchy-capture-webcam-resize` |  | Resize the active webcam recording overlay |

## Group: `clipboard` (3) — Clipboard helpers

| Command | Hidden | Summary |
|---|:---:|---|
| `omarchy-clipboard-open` | ✓ | Open a clipboard history entry |
| `omarchy-clipboard-paste-file` | ✓ | Copy a file to the clipboard and paste it |
| `omarchy-clipboard-paste-text` | ✓ | Copy text to the clipboard and type or paste it |

## Group: `debug` (1) — Diagnostics and support logs

| Command | Hidden | Summary |
|---|:---:|---|
| `omarchy-debug-idle` |  | Show idle, screensaver, and lock diagnostics |

## Group: `dev` (4) — Omarchy development tools

| Command | Hidden | Summary |
|---|:---:|---|
| `omarchy-dev-link` |  | Point Omarchy at a local checkout after reboot |
| `omarchy-dev-pkg-test` |  | Build and install an Omarchy package from a local checkout |
| `omarchy-dev-status` |  | Show the current Omarchy dev-link state |
| `omarchy-dev-unlink` |  | Restore Omarchy to the package install after reboot |

## Group: `hook` (1) — User hook runner

| Command | Hidden | Summary |
|---|:---:|---|
| `omarchy-hook-install` |  | Install a hook into ~/.config/omarchy/hooks/<type>.d/ |

## Group: `install` (4) — Optional software installers

| Command | Hidden | Summary |
|---|:---:|---|
| `omarchy-install-gaming-geforce-now` |  | Install and launch Geforce Now. |
| `omarchy-install-gaming-gpu-lib32` |  | Install lib32 graphics drivers (Vulkan + NVIDIA) for any detected GPUs. |
| `omarchy-install-gaming-xbox-cloud` |  | Install Xbox Cloud Gaming as a web app and launch it. |
| `omarchy-install-gaming-xbox-controllers` |  | Install support for using Xbox controllers with Steam/RetroArch/etc. |

## Group: `menu` (8) — Omarchy menu commands

| Command | Hidden | Summary |
|---|:---:|---|
| `omarchy-menu-clipboard` |  | Launch the clipboard manager |
| `omarchy-menu-emoji` |  | Launch emojis |
| `omarchy-menu-emoji-insert` | ✓ | Insert an emoji into the focused application |
| `omarchy-menu-file` |  | Pick a file from a menu |
| `omarchy-menu-input` |  | Prompt for text input from a menu |
| `omarchy-menu-plugin` |  | Pick a shell plugin to enable, disable, clone, or remove |
| `omarchy-menu-select` |  | Pick one option from a menu |
| `omarchy-menu-timezone` |  | Select and set the system timezone |

## Group: `monitor` (1) — Monitor status helpers

| Command | Hidden | Summary |
|---|:---:|---|
| `omarchy-monitor-state` |  | Print monitor panel state for the shell |

## Group: `network` (5) — Network status helpers

| Command | Hidden | Summary |
|---|:---:|---|
| `omarchy-network-band` |  | Show or pin the Wi-Fi band for the active connection |
| `omarchy-network-password` |  | Print the active Wi-Fi connection's password |
| `omarchy-network-qr` |  | Generate a Wi-Fi QR matrix for the shell |
| `omarchy-network-speedtest` |  | Measure live internet speed for one direction |
| `omarchy-network-status` |  | Print active network status for the shell |

## Group: `plugin` (9) — Omarchy shell plugin and bar widget management

| Command | Hidden | Summary |
|---|:---:|---|
| `omarchy-plugin-add` |  | Add a shell plugin from git |
| `omarchy-plugin-catalog` | ✓ | Emit every first-party and user plugin manifest as JSON |
| `omarchy-plugin-clone` |  | Clone a built-in Omarchy shell plugin into your own config |
| `omarchy-plugin-disable` |  | Disable a shell plugin |
| `omarchy-plugin-enable` |  | Enable a shell plugin |
| `omarchy-plugin-list` |  | List discovered shell plugins |
| `omarchy-plugin-remove` |  | Remove an installed shell plugin |
| `omarchy-plugin-update` |  | Update installed git-managed plugins |
| `omarchy-plugin-validate` |  | Validate a plugin folder against the Omarchy plugin manifest schema |

## Group: `remove` (2) — Removal workflows

| Command | Hidden | Summary |
|---|:---:|---|
| `omarchy-remove-gaming-geforce-now` |  | Remove the GeForce NOW Flatpak app and its data. |
| `omarchy-remove-gaming-xbox-controllers` |  | Remove the xpadneo Xbox controller driver and undo its module/blacklist config. |

## Group: `setup` (1) — Interactive setup wizards

| Command | Hidden | Summary |
|---|:---:|---|
| `omarchy-system-factory-reset` |  | Factory-reset this machine back to its freshly-installed state |

## Group: `share` (1) — 

| Command | Hidden | Summary |
|---|:---:|---|
| `omarchy-menu-share` |  | Share clipboard, files, or folders with LocalSend |

## Group: `system` (6) — System status, reboot, shutdown, logout, and lock

| Command | Hidden | Summary |
|---|:---:|---|
| `omarchy-system-lid-close` | ✓ | Lock and reconcile displays when the laptop lid closes |
| `omarchy-system-lock` |  | Lock the computer and turn off the display |
| `omarchy-system-sleep-lock` | ✓ | Lock before suspend and wait for the session lock to become secure |
| `omarchy-system-sleep-monitor` | ✓ | Monitor sleep preparation and lock before suspend |
| `omarchy-system-stats` |  | Print CPU and memory stats for the shell |
| `omarchy-system-wake` |  | Wake displays and restore brightness after idle |

## Group: `theme` (1) — Theme management

| Command | Hidden | Summary |
|---|:---:|---|
| `omarchy-theme-bg-switcher` |  | Open the Omarchy background switcher |

## Group: `toggle` (1) — Toggle Omarchy features

| Command | Hidden | Summary |
|---|:---:|---|
| `omarchy-toggle-idle` |  | Toggle idle behavior so the system either idles normally or stays awake |

## Group: `transcode` (2) — Image and video transcoding

| Command | Hidden | Summary |
|---|:---:|---|
| `omarchy-transcode` |  | Transcode pictures and videos for sharing |
| `omarchy-transcode-ascii` |  | Transcode an image into ASCII/Unicode art text |

## Group: `ungrouped` (412) — (no explicit group tag)

| Command | Hidden | Summary |
|---|:---:|---|
| `omarchy-agent` |  | Launch the default coding agent in a terminal |
| `omarchy-agent-account-add` |  | Sign in to a Claude, Codex, or Grok subscription |
| `omarchy-agent-account-home` | ✓ | Print the config home of the active Claude, Codex, or Grok account |
| `omarchy-agent-account-list` |  | List Claude, Codex, and Grok subscription accounts and their limits |
| `omarchy-agent-account-mode` |  | Switch Claude, Codex, or Grok accounts automatically near a limit, or only notify |
| `omarchy-agent-account-remove` |  | Forget an added Claude, Codex, or Grok account |
| `omarchy-agent-account-rename` |  | Rename a Claude, Codex, or Grok subscription account |
| `omarchy-agent-account-state` | ✓ | Read and change the registry of Claude, Codex, and Grok subscription accounts |
| `omarchy-agent-account-use` |  | Choose which Claude, Codex, or Grok account new sessions use |
| `omarchy-agent-crash` |  | Diagnose a crashed process with the default coding agent |
| `omarchy-agent-prompt` |  | Launch the default coding agent with a prompt |
| `omarchy-agent-usage-claude` | ✓ | Print the Claude Code usage record as JSON |
| `omarchy-agent-usage-codex` | ✓ | Print the Codex usage record as JSON |
| `omarchy-agent-usage-fireworks` | ✓ | Print the Fireworks usage record as JSON |
| `omarchy-agent-usage-grok` | ✓ | Print the Grok usage record as JSON |
| `omarchy-agent-usage-update` |  | Regenerate the AI agent usage data files |
| `omarchy-apply-lock` | ✓ | Configure Quickshell lock screen authentication |
| `omarchy-ascii` |  | Render text as ASCII art in the font the Omarchy logo is drawn in |
| `omarchy-audio-input-mute` |  | Toggle microphone mute. Drives the hardware mic-mute LED on laptops that expose one. |
| `omarchy-audio-input-set-default` |  | Set the default audio input and move active streams |
| `omarchy-audio-output-set-default` |  | Set the default audio output and move active streams |
| `omarchy-audio-output-switch` |  | Switch between audio outputs while preserving the mute status |
| `omarchy-audio-output-volume` |  | Adjust output volume and show the Omarchy OSD |
| `omarchy-audio-source-switch` |  | Cycle to the next media source and transfer playback when the current source is playing |
| `omarchy-bar-text-color` | ✓ | Choose a legible transparent bar text color |
| `omarchy-battery-low` | ✓ | Send the low battery warning notification and run battery-low hooks. |
| `omarchy-battery-present` |  | Returns true if a battery is present on the system. |
| `omarchy-battery-status` |  | Returns a formatted battery status string with percentage and power draw/charge. |
| `omarchy-brightness-display` |  | Show or adjust brightness on the focused display. |
| `omarchy-brightness-display-apple` |  | Show or adjust Apple Studio Display and Apple XDR Display brightness using asdcontrol. |
| `omarchy-brightness-display-ddc` |  | Show or adjust DDC/CI display brightness for a Hyprland monitor. |
| `omarchy-brightness-keyboard` |  | Adjust keyboard backlight brightness using available steps. |
| `omarchy-brightness-keyboard-mute` |  | Set the mic-mute indicator LED on laptops that expose a platform::micmute LED node. |
| `omarchy-capture-region` | ✓ | Pick a screen region over frozen screen content |
| `omarchy-capture-screenrecording-with-webcam` |  | Pick a webcam and start a screen recording with it |
| `omarchy-capture-webcam-list` | ✓ | List webcam devices that support video capture |
| `omarchy-channel-current` |  | Print the active Omarchy package channel |
| `omarchy-channel-set` |  | Set the Omarchy package channel. |
| `omarchy-chromium-copy-url-host` | ✓ | Native messaging host: copy a Chromium tab URL to the clipboard |
| `omarchy-chromium-ytdlp-host` | ✓ | Native messaging host: download the URL sent by the yt-dlp Chromium extension |
| `omarchy-cmd-browser-handoff` | ✓ | Hand a command line to the running Chromium-based browser |
| `omarchy-cmd-default-browser` | ✓ | Print the desktop entry ID of the default web browser |
| `omarchy-cmd-missing` |  | Check whether any required commands are missing |
| `omarchy-cmd-present` |  | Check whether all required commands are available |
| `omarchy-cmd-terminal-cwd` | ✓ | Print the current working directory of the active terminal window |
| `omarchy-crash-mute` |  | Silence crash notifications for one program, or list what is silenced |
| `omarchy-crash-watch` | ✓ | Watch for process crashes and offer an AI diagnosis |
| `omarchy-debug` |  | Print debugging information |
| `omarchy-default-agent` |  | Set and launch the default coding agent |
| `omarchy-default-browser` |  | Set the default browser for Omarchy and XDG handlers |
| `omarchy-default-editor` |  | Set the default editor used by omarchy-launch-editor |
| `omarchy-default-terminal` |  | Set the default terminal used by xdg-terminal-exec |
| `omarchy-dev-add-migration` |  | Create a new Omarchy migration in the current source tree. |
| `omarchy-dev-benchmark-cli` |  | Measure Omarchy CLI response times |
| `omarchy-dev-benchmark-theme-switcher` |  | Measure theme switcher cache and selector prep times |
| `omarchy-dev-font` |  | Add branded glyphs to the Omarchy icon font |
| `omarchy-dev-install-ydoo` |  | Install and enable ydotool mouse automation for Omarchy development |
| `omarchy-dev-theme-preview` |  | Preview an Omarchy theme palette in the terminal |
| `omarchy-dev-ui-preview` |  | Open the omarchy-shell dev gallery (qs.Ui kit preview) |
| `omarchy-disk-speedtest` |  | Measure live disk read and write speed |
| `omarchy-display-text-size` |  | Scale text everywhere — omarchy shell, GTK apps, and terminals |
| `omarchy-dns` |  | Show or configure the system DNS provider |
| `omarchy-done` | ✓ | Check or mark completed Omarchy setup tasks |
| `omarchy-drive-info` |  | Print drive information such as size, model, and mount details |
| `omarchy-drive-password` |  | Set a new encryption password for a drive selected. |
| `omarchy-drive-select` |  | Select a drive from a list with info that includes space and brand. Used by omarchy-drive-password. |
| `omarchy-file-select` |  | Pick files with the desktop file chooser |
| `omarchy-font-current` |  | Show current monospace font |
| `omarchy-font-list` |  | List available monospace fonts |
| `omarchy-font-set` |  | Set the system monospace font |
| `omarchy-games-retro-cores` |  | List installed RetroArch core names |
| `omarchy-games-retro-install` |  | Create a desktop launcher for a RetroArch game |
| `omarchy-git-url-check` | ✓ | Check that a git URL names a repository, not a transport helper |
| `omarchy-hibernation-available` |  | Check if hibernation is supported |
| `omarchy-hibernation-remove` |  | Remove hibernation setup including swap and boot resume settings |
| `omarchy-hibernation-setup` |  | Set up hibernation with swap and boot resume configuration |
| `omarchy-hook` |  | Run a named hook from ~/.config/omarchy/hooks/<name> and ~/.config/omarchy/hooks/<name>.d/. |
| `omarchy-hw-asus-expertbook-b9406` |  | Detect ASUS ExpertBook B9406 series laptops on Intel Panther Lake. |
| `omarchy-hw-asus-rog` |  | Detect whether the computer is an Asus ROG machine. |
| `omarchy-hw-asus-zenbook-ux5406aa` |  | Detect ASUS Zenbook UX5406AA series laptops on Intel Panther Lake. |
| `omarchy-hw-clamshell` | ✓ | Returns true when clamshell mode is active |
| `omarchy-hw-dell-xps-haptic-touchpad` |  | Match Dell XPS systems with the Synaptics haptic touchpad. |
| `omarchy-hw-dell-xps-oled` |  | Match Dell XPS systems with LG OLED panel on Intel Panther Lake (Xe3) GPU. |
| `omarchy-hw-dell-xps13-sidecar-amps` |  | Match the Dell XPS 13 DX13260 that requires the sidecar amplifier workaround. |
| `omarchy-hw-display` |  | Print the most likely display backlight device. |
| `omarchy-hw-elgato-camlink-4k` |  | Detect whether an Elgato Cam Link 4K is plugged in. |
| `omarchy-hw-external-monitors` |  | Returns true when an external monitor is physically connected. |
| `omarchy-hw-fingerprint` | ✓ | Returns true when a fingerprint reader is present |
| `omarchy-hw-framework16` |  | Detect whether the computer is a Framework Laptop 16. |
| `omarchy-hw-hybrid-gpu` |  | Detect whether the system has an active hybrid GPU configuration |
| `omarchy-hw-intel` |  | Detect whether the computer has an Intel CPU. |
| `omarchy-hw-intel-ptl` |  | Detect whether the computer has an Intel Panther Lake GPU. |
| `omarchy-hw-intel-sof` |  | Detect an Intel SOF-capable audio DSP |
| `omarchy-hw-laptop` |  | Returns true when running on a laptop (has a lid or laptop chassis). |
| `omarchy-hw-laptop-closed` | ✓ | Returns true when the laptop lid is closed |
| `omarchy-hw-match` |  | Match against the computer's DMI product name or product family (case-insensitive). |
| `omarchy-hw-nvidia` |  | Detect whether the computer has an NVIDIA GPU. |
| `omarchy-hw-nvidia-display` |  | Detect whether NVIDIA drives the display (rather than a hybrid iGPU). |
| `omarchy-hw-nvidia-gsp` |  | Detect whether the computer has an NVIDIA GPU with GSP firmware (Turing or newer). |
| `omarchy-hw-nvidia-without-gsp` |  | Detect whether the computer has an NVIDIA GPU without GSP firmware (Maxwell/Pascal/Volta). |
| `omarchy-hw-recover-internal-monitor` |  | Clear the internal-monitor-disable toggle if no external display is connected. |
| `omarchy-hw-surface` |  | Detect whether the computer is a Microsoft Surface device. |
| `omarchy-hw-touchpad` |  | Print the detected Hyprland touchpad or trackpad device name |
| `omarchy-hw-touchscreen` |  | Print the detected Hyprland touchscreen or tablet device name |
| `omarchy-hw-vm` |  | Returns true when running in a virtual machine. |
| `omarchy-hw-vulkan` |  | Detect whether Vulkan is available. |
| `omarchy-hw-webcam` |  | Check whether a webcam is available |
| `omarchy-hyprland-focus-app` |  | Focus a Hyprland window by application identity |
| `omarchy-hyprland-monitor-clamshell` | ✓ | Apply clamshell display state to Hyprland monitors |
| `omarchy-hyprland-monitor-external-active` | ✓ | Returns true when Hyprland has an active external monitor |
| `omarchy-hyprland-monitor-focused` |  | Print the name of the currently focused Hyprland monitor. |
| `omarchy-hyprland-monitor-focused-apple` |  | Return success if the focused or named Hyprland monitor is an Apple display. |
| `omarchy-hyprland-monitor-internal` |  | Enable, disable, toggle, or recover the internal laptop display |
| `omarchy-hyprland-monitor-internal-mirror` |  | Enable, disable, toggle, or recover mirroring the internal display to an external monitor |
| `omarchy-hyprland-monitor-laptop` |  | Print the name of the built-in laptop display, including disabled outputs. |
| `omarchy-hyprland-monitor-modeless` | ✓ | Returns true when Hyprland has an enabled monitor with no mode |
| `omarchy-hyprland-monitor-scaling` |  | Show, set, or adjust focused Hyprland monitor scaling |
| `omarchy-hyprland-monitor-watch` |  | Watch Hyprland monitor events and recover monitor toggles when a monitor is removed |
| `omarchy-hyprland-reload-guard` | ✓ | Pause or resume Hyprland config auto-reload around package transactions. |
| `omarchy-hyprland-session-locked` | ✓ | Returns true when the compositor holds a session lock |
| `omarchy-hyprland-toggle` |  | Toggle permanent Hyprland flags by copying them into a directory that's sourced entirely. |
| `omarchy-hyprland-toggle-disabled` |  | Check if a Hyprland toggle is currently disabled (missing). |
| `omarchy-hyprland-toggle-enabled` |  | Check if a Hyprland toggle is currently enabled. |
| `omarchy-hyprland-window-close-all` |  | Close all open windows |
| `omarchy-hyprland-window-gaps-toggle` |  | Toggles the window gaps globally between no gaps and the default. |
| `omarchy-hyprland-window-pop` |  | Toggle to pop-out a tile to stay fixed on a display basis. |
| `omarchy-hyprland-window-single-square-aspect-toggle` |  | Toggle single-window square aspect ratio. |
| `omarchy-hyprland-window-tiled-fullscreen-toggle` |  | Toggle tiled fullscreen for the focused Hyprland window |
| `omarchy-hyprland-window-transparency-toggle` |  | Toggles transparency for the currently focused window. |
| `omarchy-hyprland-window-width` |  | Save or restore the focused Hyprland window width |
| `omarchy-hyprland-workspace-layout-toggle` |  | Toggle the layout on the current active workspace between dwindle and scrolling |
| `omarchy-install-ai-chatgpt` |  | Install the ChatGPT desktop app |
| `omarchy-install-ai-claude` |  | Install the Claude desktop app |
| `omarchy-install-ai-hermes` |  | Install the Hermes desktop app |
| `omarchy-install-ai-openclaw` |  | Install the OpenClaw agent platform and its Control UI web app |
| `omarchy-install-ai-t3-code` |  | Install T3 Code and point it at the Omarchy palette |
| `omarchy-install-and-launch` |  | Install a packaged app and launch it once it finishes |
| `omarchy-install-app` |  | Install a packaged app, surfacing the install in a floating terminal |
| `omarchy-install-browser` |  | Install a supported browser |
| `omarchy-install-chromium-claude` |  | Install the Claude extension for Chromium-based browsers |
| `omarchy-install-chromium-copy-url` |  | Install the native messaging host for the Copy URL Chromium extension |
| `omarchy-install-chromium-google-account` |  | Allow Chromium to sign in to Google accounts by adding the required OAuth credentials |
| `omarchy-install-chromium-ytdlp` |  | Install the native messaging host for the yt-dlp Chromium extension |
| `omarchy-install-dev-env` |  | Install a supported development environment |
| `omarchy-install-docker-dbs` |  | Install one of the supported databases in a Docker container with the suitable development options. |
| `omarchy-install-editor-emacs` |  | Install Emacs with Omarchy theme and font integration via the omarchy-emacs AUR package |
| `omarchy-install-editor-helix` |  | Install Helix and configure it to use the current Omarchy theme |
| `omarchy-install-editor-vscode` |  | Install VS Code and configure Omarchy defaults for secrets, updates, and theme |
| `omarchy-install-editor-zed` |  | Install Zed Editor and configure it with the current Omarchy theme |
| `omarchy-install-font` |  | Install a Nerd Font package and switch the system to it |
| `omarchy-install-gaming-battlenet` |  | Install Battle.net standalone via umu-launcher + GE-Proton (no Steam, no Lutris, no Heroic). |
| `omarchy-install-gaming-heroic` |  | Install Heroic Games Launcher (Epic, GOG, Amazon Prime Gaming) with graphics drivers. |
| `omarchy-install-gaming-lutris` |  | Install Lutris with Wine + DXVK for running Windows games (Battle.net, EA, Ubisoft Connect, etc.) |
| `omarchy-install-gaming-retroarch` |  | Install RetroArch with the full libretro core set plus FBNeo and a ~/Games ROM directory. |
| `omarchy-install-gaming-steam` |  | Install Steam and graphics drivers selected for this system |
| `omarchy-install-hermes-cli` |  | Install Hermes Desktop for the default agent; its runtime provides the hermes command |
| `omarchy-install-openclaw-cli` |  | Install OpenClaw for the default agent as the self-updating copy under ~/.openclaw |
| `omarchy-install-preinstalls` |  | Restore the preinstalled Omarchy applications (web apps, TUIs, and selected packages). |
| `omarchy-install-service-1password` |  | Install 1Password and its Chromium extension. |
| `omarchy-install-service-dropbox` |  | Install and start the Dropbox service. Must then be authenticated via the web. |
| `omarchy-install-service-nordvpn` |  | Install the NordVPN service with optional GUI. |
| `omarchy-install-service-once` |  | Install the ONCE service, enable its background service, and launch the TUI. |
| `omarchy-install-service-signal` |  | Install Signal and launch it. |
| `omarchy-install-service-spotify` |  | Install Spotify. |
| `omarchy-install-service-sunshine` |  | Install Sunshine and open Moonlight streaming ports for LAN and Tailscale. |
| `omarchy-install-service-tailscale` |  | Install the Tailscale mesh VPN service and a web app for the Tailscale Admin Console. |
| `omarchy-install-terminal` |  | Install one of the approved terminals and set it as the default for Omarchy (Super + Return etc). |
| `omarchy-installed-service-dropbox` | ✓ | Check whether Dropbox is installed and running |
| `omarchy-installed-service-tailscale` | ✓ | Check whether Tailscale is installed and running |
| `omarchy-launch-1password` |  | Launch 1Password or start its installer when missing. |
| `omarchy-launch-about` |  | Launch the fastfetch TUI that gives information about the current system. |
| `omarchy-launch-battlenet` |  | Launch the installed Battle.net client via umu-launcher + GE-Proton. |
| `omarchy-launch-browser` |  | Launch the default browser as determined by xdg-settings. |
| `omarchy-launch-config-editor` |  | Open a config file in the user's editor and surface a toast |
| `omarchy-launch-discord-community` |  | Open the Omarchy Discord community in the Discord app or a browser. |
| `omarchy-launch-docker-tui` | ✓ | Open the Docker TUI (lazydocker) with access to the Docker daemon |
| `omarchy-launch-editor` |  | Launch the default editor selected via Omarchy defaults. |
| `omarchy-launch-floating-terminal-with-presentation` |  | Launch a floating terminal with the Omarchy presentation wrapper |
| `omarchy-launch-nautilus` |  | Launch Files |
| `omarchy-launch-nautilus-cwd` |  | Launch Files in the active terminal's current directory |
| `omarchy-launch-openclaw` |  | Open the OpenClaw Control UI (or its terminal UI with --tui), onboarding or starting the gateway first when needed. |
| `omarchy-launch-or-focus` |  | Launch an app or focus an existing window matching a pattern |
| `omarchy-launch-or-focus-tui` |  | Launch a TUI or focus an existing terminal window for it |
| `omarchy-launch-or-focus-webapp` |  | Launch or focus on a given web app identified by the window-pattern. |
| `omarchy-launch-screensaver` |  | Launch the Omarchy screensaver in the default terminal on the system with the correct font configuration. |
| `omarchy-launch-shell` | ✓ | Launch the Omarchy shell with its log kept in the journal |
| `omarchy-launch-signal` |  | Launch Signal or start its installer when missing. |
| `omarchy-launch-spotify` |  | Launch Spotify or start its installer when missing. |
| `omarchy-launch-terminal` |  | Launch a terminal in the active terminal's current directory |
| `omarchy-launch-terminal-herdr` |  | Launch or attach to the persistent herdr session in a terminal |
| `omarchy-launch-terminal-tmux` |  | Launch or attach to the Work tmux session in a terminal |
| `omarchy-launch-tui` |  | Launch a TUI command in the default terminal with Omarchy styling |
| `omarchy-launch-webapp` |  | Launch a URL as a web app in the default supported browser |
| `omarchy-menu` |  | Control the Omarchy menu (toggle / summon / close / refresh) |
| `omarchy-menu-herdr-keybindings` |  | Display annotated Herdr keybindings using an interactive search menu. |
| `omarchy-menu-images` |  | Open a generic image selector menu |
| `omarchy-menu-keybindings` |  | Display Hyprland keybindings defined in your configuration using an interactive search menu. |
| `omarchy-menu-tmux-keybindings` |  | Display annotated Tmux keybindings using an interactive search menu. |
| `omarchy-migrate` |  | Run pending Omarchy migrations. |
| `omarchy-migrate-notify` |  | Notify the user when Omarchy has pending migrations |
| `omarchy-mise-install` |  | Install a small mise-backed wrapper for a given tool. |
| `omarchy-notification-battery` |  | Show the current battery status notification |
| `omarchy-notification-dismiss` |  | Dismiss a notification by summary substring. Used by the first-run notifications to dismiss them after clicking for action. |
| `omarchy-notification-send` |  | Send an Omarchy desktop notification |
| `omarchy-notification-time` |  | Show the current time and date notification |
| `omarchy-notification-wait` | ✓ | Wait for the desktop notification server to accept notifications |
| `omarchy-notification-weather` |  | Toggle the current weather panel |
| `omarchy-openclaw-onboard` |  | Run OpenClaw's setup wizard the way Omarchy needs it: in the terminal, installing the gateway as a user service, and returning when it is done. |
| `omarchy-osd` |  | Show the Omarchy Quickshell on-screen display |
| `omarchy-pkg-add` |  | Install Arch packages if they are missing |
| `omarchy-pkg-aur-accessible` |  | Returns true if the AUR is up and available. |
| `omarchy-pkg-aur-add` |  | Add the named packages to the system from the AUR if they're missing. Returns false if it couldn't be done. |
| `omarchy-pkg-aur-install` |  | Show a fuzzy-finder TUI for picking new AUR packages to install. |
| `omarchy-pkg-drop` |  | Remove all the named packages from the system if they're installed (otherwise ignore). |
| `omarchy-pkg-install` |  | Show a fuzzy-finder TUI for picking new Arch and OPR packages to install. |
| `omarchy-pkg-missing` |  | Returns true if any of the named packages are missing from the system (or false if they're all there). |
| `omarchy-pkg-present` |  | Returns true if all of the named packages are installed on the system (or false if any of them are missing). |
| `omarchy-pkg-remove` |  | Show a fuzzy-finder TUI for picking packages installed on the system to be removed. |
| `omarchy-plymouth-current` |  | Show which theme is styling the Plymouth boot screen |
| `omarchy-plymouth-list` |  | List themes that can style the Plymouth boot screen |
| `omarchy-plymouth-preview` |  | Preview a Plymouth boot screen with custom colors and logo |
| `omarchy-plymouth-reset` |  | Restore the default Omarchy Plymouth boot theme and SDDM login screen |
| `omarchy-plymouth-set` |  | Set the Plymouth boot theme colors and logo |
| `omarchy-plymouth-set-by-theme` |  | Set the Plymouth boot theme from an Omarchy theme |
| `omarchy-plymouth-switcher` |  | Open the Plymouth unlock screen switcher |
| `omarchy-power-present` |  | Returns true if external power is connected. |
| `omarchy-powerprofiles-init` |  | Set the correct power profile on boot based on current AC/battery state. |
| `omarchy-powerprofiles-list` |  | Returns a list of all the available power profiles on the system. |
| `omarchy-powerprofiles-set` |  | Set and remember the power profile for AC or battery use |
| `omarchy-provision-first-run` | ✓ | Finish first-login setup for Omarchy. |
| `omarchy-provision-owner` | ✓ | First-boot provisioning: create the user on a machine installed in deferred provisioning |
| `omarchy-provision-user` | ✓ | Finalize Omarchy user setup (runtime tweaks /etc/skel can't do) |
| `omarchy-refresh-applications` |  | Ensure default application launchers and mise wrappers are installed. |
| `omarchy-refresh-chromium` |  | Refresh the ~/.config/chromium-flags.conf file from the Omarchy defaults. |
| `omarchy-refresh-config` |  | Copy a shipped user config from $OMARCHY_PATH/config into ~/.config (backs up your version). |
| `omarchy-refresh-herdr` |  | Overwrite the user herdr config with the Omarchy default and reload herdr. |
| `omarchy-refresh-hyprland` |  | Overwrite all the user Hyprland Lua configs in ~/.config/hypr with the Omarchy defaults. |
| `omarchy-refresh-hyprsunset` |  | Overwrite the user config for hyprsunset with the Omarchy default and restart the service. |
| `omarchy-refresh-limine` |  | Overwrite the user config for the Limine bootloader and rebuild it. |
| `omarchy-refresh-pacman` |  | Overwrite the package configuration for /etc/pacman with the Omarchy default of using its dedicated mirrors and repositories, then update all packages. |
| `omarchy-refresh-plymouth` |  | Overwrite the user config for the Plymouth drive decryption and boot sequence with the Omarchy default and rebuild it. |
| `omarchy-refresh-sddm` |  | Refresh the SDDM theme from default |
| `omarchy-refresh-shell` |  | Reset shell.json to Omarchy defaults |
| `omarchy-refresh-tmux` |  | Overwrite the user tmux config with the Omarchy default and reload tmux. |
| `omarchy-reinstall` |  | Reinstall Omarchy packages and reset default configs |
| `omarchy-reinstall-configs` |  | Reset Omarchy user configs and shipped defaults in $HOME (destructive) |
| `omarchy-reinstall-pkgs` |  | Reinstall all default Omarchy packages from the stable channel |
| `omarchy-reminder` |  | Set and show lightweight desktop notification reminders |
| `omarchy-remove-ai-chatgpt` |  | Remove the ChatGPT desktop app along with its configuration and caches. |
| `omarchy-remove-ai-claude` |  | Remove the Claude desktop app along with its configuration and caches. |
| `omarchy-remove-ai-grok-bot` |  | Remove Grok Bot along with its settings and data. |
| `omarchy-remove-ai-hermes` |  | Remove the Hermes desktop app along with the Hermes runtime it installed. |
| `omarchy-remove-ai-lm-studio` |  | Remove LM Studio along with its configuration and every model it downloaded. |
| `omarchy-remove-ai-ollama` |  | Remove Ollama along with every model it pulled. |
| `omarchy-remove-ai-openclaw` |  | Remove the OpenClaw agent platform along with its gateway service and web app. |
| `omarchy-remove-ai-perplexity` |  | Remove the Perplexity desktop app along with its runtime caches. |
| `omarchy-remove-ai-t3-code` |  | Remove T3 Code along with its configuration and workspaces. |
| `omarchy-remove-browser` |  | Remove a supported browser and clean up Omarchy browser defaults |
| `omarchy-remove-dev-env` |  | Remove a development environment that was previously installed via omarchy-install-dev-env. |
| `omarchy-remove-gaming-battlenet` |  | Remove Battle.net, its Proton prefix, installed games, and desktop entry. |
| `omarchy-remove-gaming-heroic` |  | Remove Heroic Games Launcher and its game libraries, configs, and caches. |
| `omarchy-remove-gaming-lutris` |  | Remove Lutris, Wine, umu-launcher, and all their configs and caches. |
| `omarchy-remove-gaming-minecraft` |  | Remove the Minecraft launcher along with its worlds, mods, and caches. |
| `omarchy-remove-gaming-retroarch` |  | Remove RetroArch, all libretro cores, and its config/saves. Leaves ~/Games/roms and ~/Games/bios alone. |
| `omarchy-remove-gaming-steam` |  | Remove Steam and all of its game libraries, configs, and caches. |
| `omarchy-remove-gaming-xbox-cloud` |  | Remove the Xbox Cloud Gaming web app. |
| `omarchy-remove-launcher-entry` | ✓ | Remove or uninstall the selected launcher entry |
| `omarchy-remove-preinstalls` |  | Remove preinstalled Omarchy applications (web apps, TUIs, and selected packages). |
| `omarchy-remove-security-fido2` |  | Remove FIDO2 authentication from sudo and polkit |
| `omarchy-remove-security-fingerprint` |  | Remove fingerprint authentication from sudo, polkit, and lock screen |
| `omarchy-remove-security-sshd` |  | Disable the OpenSSH server, remove standard firewall rules, and optionally remove authorized keys |
| `omarchy-remove-security-sudoless-docker` |  | Disable sudoless Docker by removing your user from the docker group |
| `omarchy-remove-service-1password` |  | Remove 1Password and its Chromium extension. |
| `omarchy-remove-service-dropbox` |  | Remove Dropbox and its bar plugin. |
| `omarchy-remove-service-ssh-agent` |  | Disable the gcr-ssh-agent SSH agent and its environment override. |
| `omarchy-remove-service-sunshine` |  | Remove Sunshine and close Omarchy-managed Moonlight streaming ports. |
| `omarchy-remove-service-tailscale` |  | Remove Tailscale and its bar plugin. |
| `omarchy-restart-app` |  | Restart an application by killing it and relaunching via uwsm. |
| `omarchy-restart-audio` |  | Restart audio services and recover stuck USB audio devices. |
| `omarchy-restart-bluetooth` |  | Unblock and restart the bluetooth service. |
| `omarchy-restart-btop` |  | Reload btop configuration (used by the Omarchy theme switching). |
| `omarchy-restart-gum` | ✓ | Export the current theme's gum styling into the environment |
| `omarchy-restart-helix` |  | Reload Helix configuration |
| `omarchy-restart-herdr` |  | Reload herdr if running with the latest configuration |
| `omarchy-restart-hyprctl` |  | Reload hyprland configuration (used by the Omarchy theme switching). |
| `omarchy-restart-hyprsunset` |  | Restart the hyprsunset service (used for blue light filtering/night light). |
| `omarchy-restart-opencode` |  | Reload opencode configuration (used by the Omarchy theme switching). |
| `omarchy-restart-shell` |  | Restart the Omarchy shell |
| `omarchy-restart-terminal` |  | Reload supported terminal emulators after config changes |
| `omarchy-restart-tmux` |  | Restart tmux if running with the latest configuration |
| `omarchy-restart-trackpad` |  | Reset the trackpad by unbinding and rebinding its driver. |
| `omarchy-restart-wifi` |  | Unblock and restart the Wi-Fi service. |
| `omarchy-restart-xcompose` |  | Restart the XCompose input method service (fcitx5) to apply new compose key settings. |
| `omarchy-screensaver` |  | Run the Omarchy screensaver using random effects from TTE. |
| `omarchy-security-functions` | ✓ | Provide internal helpers for command-scoped sudo authentication |
| `omarchy-setup-direct-boot` |  | Add or remove an EFI boot entry for the Omarchy UKI, allowing the system to boot directly |
| `omarchy-setup-security-fido2` |  | Set up FIDO2 authentication for sudo and polkit |
| `omarchy-setup-security-fingerprint` |  | Set up fingerprint authentication for sudo, polkit, and lock screen |
| `omarchy-setup-security-ssh-agent` |  | Enable an SSH agent (gcr-ssh-agent) that prompts for key passphrases graphically. |
| `omarchy-setup-security-sshd` |  | Set up the OpenSSH server, open the firewall, and authorize an SSH key |
| `omarchy-setup-security-sudoless-docker` |  | Enable sudoless Docker by adding your user to the docker group (root-equivalent!) |
| `omarchy-shell` |  | Send an IPC call to the running Omarchy shell |
| `omarchy-shell-config` | ✓ | Shared helpers for editing ~/.config/omarchy/shell.json (source this, don't run it). |
| `omarchy-show-done` |  | Display a "Done!" or "Failed!" message and wait for user to press any key. |
| `omarchy-show-logo` |  | Display the Omarchy logo in the terminal using green color. |
| `omarchy-snapshot` |  | Create or restore system snapshots with snapper |
| `omarchy-state` | ✓ | Manage persistent state files for Omarchy toggles and settings. |
| `omarchy-sudo-docker` | ✓ | Succeed when Docker needs sudo, fail when it can be used directly |
| `omarchy-sudo-keepalive` |  | Prompt for sudo once and keep the credential alive in the background. |
| `omarchy-sudo-passwordless` |  | Toggle passwordless sudo for the current user. |
| `omarchy-system-factory-reset-finish` | ✓ | First-boot worker that finishes an omarchy-system-factory-reset reset |
| `omarchy-system-logout` |  | Log out after closing application windows |
| `omarchy-system-reboot` |  | Reboot after closing application windows |
| `omarchy-system-shutdown` |  | Shut down after closing application windows |
| `omarchy-tailscale-receive` |  | Save incoming Taildrop files and announce them |
| `omarchy-tailscale-send` |  | Send files to a machine on your tailnet with Taildrop |
| `omarchy-theme-bg-cache` |  | Cache background switcher thumbnails for the current theme |
| `omarchy-theme-bg-current` |  | Show current background |
| `omarchy-theme-bg-install` |  | Open the current theme's user background folder |
| `omarchy-theme-bg-next` |  | Cycle to the next background for the current theme |
| `omarchy-theme-bg-set` |  | Set the current background image or video |
| `omarchy-theme-color` | ✓ | Resolve semantic colors from an Omarchy theme colors.toml |
| `omarchy-theme-colors-from-alacritty` | ✓ | Generate a theme's colors.toml from its alacritty.toml palette |
| `omarchy-theme-current` |  | Show current theme |
| `omarchy-theme-dir` |  | Print the directory holding a theme, preferring a user-installed copy |
| `omarchy-theme-extras` |  | List the user-installed themes that came from a git clone |
| `omarchy-theme-install` |  | Install a theme from a git repository |
| `omarchy-theme-list` |  | List available themes |
| `omarchy-theme-osc` | ✓ | Print OSC sequences for an Omarchy color theme |
| `omarchy-theme-refresh` |  | Refresh the current theme from its templates. |
| `omarchy-theme-remove` |  | Remove a user-installed theme |
| `omarchy-theme-set` |  | Apply an Omarchy theme |
| `omarchy-theme-set-browser` | ✓ | Apply the current theme color to Chromium, Chrome, Edge, and Brave |
| `omarchy-theme-set-browser-policy` | ✓ | Write the current theme color into the browser policy directories |
| `omarchy-theme-set-claude` | ✓ | Sync the generated Omarchy theme to Claude Code |
| `omarchy-theme-set-foot` | ✓ | Apply current Omarchy theme colors to running Foot terminals |
| `omarchy-theme-set-gnome` | ✓ | Apply the current theme to GNOME color mode and icon settings |
| `omarchy-theme-set-herdr-machines` | ✓ | Mirror the current theme to your herdr machines that run Omarchy |
| `omarchy-theme-set-hermes` | ✓ | Sync the generated Omarchy theme to Hermes as a skin |
| `omarchy-theme-set-hunk` | ✓ | Tell running Hunk sessions to pick up the new terminal colors |
| `omarchy-theme-set-keyboard` | ✓ | Apply the current theme keyboard color to supported keyboards |
| `omarchy-theme-set-keyboard-asus-rog` | ✓ | Apply the current theme keyboard color to ASUS ROG keyboards |
| `omarchy-theme-set-keyboard-f16` | ✓ | Apply the current theme keyboard color to Framework Laptop 16 keyboards |
| `omarchy-theme-set-obsidian` | ✓ | Sync Omarchy theme to all Obsidian vaults |
| `omarchy-theme-set-pi` | ✓ | Sync the generated Omarchy Pi theme |
| `omarchy-theme-set-t3code` | ✓ | Sync the generated Omarchy theme to T3 Code |
| `omarchy-theme-set-templates` | ✓ | Generate themed config files from Omarchy templates |
| `omarchy-theme-set-tmux` | ✓ | Sync current Omarchy theme environment into tmux |
| `omarchy-theme-set-vscode` | ✓ | Sync Omarchy theme to VS Code, VSCodium, and Cursor |
| `omarchy-theme-switcher` |  | Open the Omarchy theme switcher |
| `omarchy-theme-update` |  | Update user-installed git themes |
| `omarchy-toggle` |  | Toggle Omarchy features between enabled and disabled |
| `omarchy-toggle-animations` |  | Toggle animations, transparency and other effects that are slow without a GPU |
| `omarchy-toggle-bar` |  | Toggle bar visibility without killing the Omarchy shell |
| `omarchy-toggle-crash-capture` |  | Toggle crash capture notifications |
| `omarchy-toggle-enabled` |  | Check if a toggle is enabled (flag file exists) |
| `omarchy-toggle-fullscreen-desktop` |  | Toggle a full screen desktop: hide the top bar and remove the window gaps together |
| `omarchy-toggle-hybrid-gpu` |  | Toggle dedicated vs integrated GPU mode via supergfxd (for hybrid gpu laptops, like Asus G14). |
| `omarchy-toggle-input-device` | ✓ | Enable, disable, or toggle a Hyprland input device |
| `omarchy-toggle-nightlight` |  | Toggle nightlight screen temperature |
| `omarchy-toggle-notification-silencing` |  | Toggle notification do-not-disturb mode |
| `omarchy-toggle-screensaver` |  | Toggle screensaver availability |
| `omarchy-toggle-suspend` |  | Toggle suspend availability in the system menu |
| `omarchy-toggle-theme-sync` |  | Toggle mirroring theme changes to and from your herdr machines |
| `omarchy-toggle-touchpad` |  | Enable, disable, or toggle the touchpad |
| `omarchy-toggle-touchscreen` |  | Enable, disable, or toggle the touch functionality of the screen |
| `omarchy-tui-install` |  | Create a desktop launcher for a terminal UI app |
| `omarchy-tui-remove` |  | Remove a terminal UI desktop launcher |
| `omarchy-tui-remove-all` |  | Remove all TUIs installed via omarchy-tui-install. |
| `omarchy-update` |  | Update Omarchy and system packages |
| `omarchy-update-analyze-logs` |  | Check the update log for known failure conditions |
| `omarchy-update-aur-pkgs` |  | Update AUR packages if any are installed |
| `omarchy-update-available` |  | Check whether Omarchy updates are available. |
| `omarchy-update-confirm` |  | Prompt for confirmation before starting an update |
| `omarchy-update-dev` |  | Update the active Omarchy dev checkout |
| `omarchy-update-firmware` |  | Update system firmware using fwupd. Ensures the fwupd EFI binary is installed |
| `omarchy-update-keyring` |  | Ensure the Omarchy and Arch keyring packages are installed and populated |
| `omarchy-update-lock` | ✓ | Run a command while holding the Omarchy update lock |
| `omarchy-update-mise` |  | Update mise-managed tools |
| `omarchy-update-orphan-pkgs` |  | Review and optionally remove orphaned system packages after updates |
| `omarchy-update-pacman` | ✓ | Run a pacman transaction for the Omarchy update flow, shielded from desktop session teardown. |
| `omarchy-update-pacman-guard` | ✓ | Prevent direct pacman system upgrades from bypassing omarchy update. |
| `omarchy-update-pkg-prune` |  | Prune superseded versions from the pacman package cache |
| `omarchy-update-requires-free-space` | ✓ | Check free disk space required for an update |
| `omarchy-update-restart` |  | Prompt for required reboot or service restarts after updates |
| `omarchy-update-status` | ✓ | Refresh the shell update status |
| `omarchy-update-stay-awake` | ✓ | Manage sleep and idle inhibition during an update |
| `omarchy-update-system-pkgs` |  | Update system packages with pacman |
| `omarchy-update-system-pkgs-when-conflicted` | ✓ | Retry a system package update that hit a conflict |
| `omarchy-update-time` |  | Restart system time synchronization |
| `omarchy-update-user-notify` | ✓ | Compatibility wrapper for omarchy-migrate-notify. |
| `omarchy-upgrade-to-quattro` |  | Upgrade a legacy Omarchy install to the package-backed Omarchy quattro layout. |
| `omarchy-upload-log` | ✓ | Upload logs to logs.omarchy.org |
| `omarchy-version` |  | Print the installed Omarchy version |
| `omarchy-version-branch` | ✓ | Print the active Omarchy dev-link git branch |
| `omarchy-version-channel` |  | Print the active Omarchy mirror and package channel |
| `omarchy-version-pkgs` |  | Print when system packages were last upgraded |
| `omarchy-voxtype-config` |  | Open Voxtype configuration |
| `omarchy-voxtype-install` |  | Install and configure Voxtype dictation |
| `omarchy-voxtype-model` |  | Open Voxtype AI model setup |
| `omarchy-voxtype-remove` |  | Remove Voxtype dictation and its configuration |
| `omarchy-voxtype-status` |  | Stream voxtype --follow status as bar-friendly JSON |
| `omarchy-weather-icon` |  | Returns a weather condition icon, adjusted for live sunrise and sunset. |
| `omarchy-weather-location` |  | Show or set the location used for weather reports |
| `omarchy-weather-status` |  | Returns a formatted weather status string with temperature and wind speed. |
| `omarchy-webapp-handler-hey` |  | Open HEY webmail and translate mailto links |
| `omarchy-webapp-handler-zoom` |  | Open Zoom web meetings from browser protocol links |
| `omarchy-webapp-install` |  | Create a desktop launcher for a web app |
| `omarchy-webapp-remove` |  | Remove a web app desktop launcher |
| `omarchy-webapp-remove-all` |  | Remove all web apps installed via omarchy-webapp-install. |
| `omarchy-windows-key` |  | Print the OEM Windows product key stored in firmware |
| `omarchy-windows-vm` |  | Install, launch, stop, inspect, or remove the Windows VM |

