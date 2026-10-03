# docs/CONFIGS.md — Upstream Omarchy Configuration Directories

**Source:** `reference/omarchy/` (config/, default/, etc/)
**Date:** 2026-10-03

Omarchy stores configuration in three trees:

| Tree | Install destination | Purpose |
|---|---|---|
| `config/` | Copied to `~/.config/` via `/etc/skel` or `omarchy-reinstall-configs` | Per-user app configs seeded at install |
| `default/` | Installed to `/usr/share/omarchy/default/` by the package | System-level defaults, templates, themed files |
| `etc/` | Installed to `/etc/` by the package | System config overrides shipped by Omarchy |

---

## `config/` — User configs copied to `~/.config/`

| Directory / File | App configured | Key files |
|---|---|---|
| `config/alacritty/` | Alacritty terminal | `alacritty.toml` — colors, font, padding |
| `config/autostart/` | XDG autostart | `limine-snapper-notify.desktop`, `org.fcitx.Fcitx5.desktop`, `print-applet.desktop` |
| `config/btop/` | btop resource monitor | `btop.conf` — theme symlink seeded by `install/user/theme.sh` |
| `config/chromium/` | Chromium browser | `Default/` — per-profile preferences |
| `config/chromium-flags.conf` | Chromium flags | Wayland and other launch flags |
| `config/fcitx5/` | Fcitx5 input method | `conf/` — input method config |
| `config/foot/` | Foot terminal | `foot.ini` — colors, font, scrollback |
| `config/ghostty/` | Ghostty terminal | `config` — colors, font |
| `config/git/` | Git | `config` — global git config template |
| `config/herdr/` | Herdr machine management | `config.toml` — machine list |
| `config/hypr/` | Hyprland compositor | `hyprland.lua`, `bindings.lua`, `input.lua`, `looknfeel.lua`, `monitors.lua`, `autostart.lua`, `hyprsunset.conf`, `xdph.conf` |
| `config/hyprland-preview-share-picker/` | Hyprland screen-share picker | `config.yaml` |
| `config/imv/` | imv image viewer | `config` — keybindings, scaling |
| `config/kitty/` | Kitty terminal (optional) | `kitty.conf` |
| `config/lazygit/` | Lazygit TUI | `config.yml` |
| `config/obsidian/` | Obsidian note-taking | `user-flags.conf` — Wayland flags |
| `config/omarchy/` | Omarchy itself | `shell.json` — bar config; `extensions/`; `hooks/`; `themed/` — themed config fragments |
| `config/opencode/` | OpenCode AI agent | `opencode.json` |
| `config/starship.toml` | Starship shell prompt | Colors, segments |
| `config/tmux/` | tmux multiplexer | `tmux.conf` — keybindings, status bar |
| `config/wireplumber/` | WirePlumber audio session manager | `wireplumber.conf.d/` — ALSA rules |
| `config/xournalpp/` | Xournal++ PDF annotator | `settings.xml` |

---

## `default/` — System defaults at `/usr/share/omarchy/default/`

| Directory | Purpose |
|---|---|
| `default/agents/` | AI agent skill symlink targets (`default/agents/skills/omarchy/`) |
| `default/alacritty/` | Alacritty theme templates |
| `default/applications/` | `.desktop` files for Omarchy-managed apps |
| `default/audio/` | EasyEffects speaker tuning presets (per-model JSON pipelines) |
| `default/bash/` | Bash env bootstrap, `.bashrc`, `.bash_profile` fragments |
| `default/chromium/` | Chromium policy JSON and managed preferences |
| `default/environment.d/` | `systemd-environment-d` files exporting `OMARCHY_PATH` etc. |
| `default/firefox/` | Firefox autoconfig for policy deployment |
| `default/fontconfig/` | `fonts.conf` — font rendering and aliasing rules |
| `default/fonts/` | Branded icon font (`omarchy.ttf`), bundled fonts |
| `default/foot/` | Foot theme template |
| `default/ghostty/` | Ghostty theme template |
| `default/gpg/` | GPG agent config |
| `default/hypr/` | Hyprland Lua config snippets, NVIDIA override, toggle files |
| `default/libalpm/` | pacman libalpm hooks (post-install scripts) |
| `default/limine/` | Limine bootloader `limine.conf` template |
| `default/nautilus-python/` | Nautilus Python extension scripts |
| `default/omarchy/` | Omarchy runtime assets: menu JSON, keybindings, shell Quickshell QML |
| `default/pacman/` | `pacman-stable.conf`, `mirrorlist-stable` — Omarchy's own mirror |
| `default/plymouth/` | Plymouth boot theme (branded splash) |
| `default/sddm/` | SDDM login theme |
| `default/snapper/` | Snapper root config template (retention policy) |
| `default/systemd/` | Systemd unit files and service drop-ins installed by the package |
| `default/tensaku/` | Tensaku OCR config |
| `default/themed/` | `*.tpl` template files with `{{ variable }}` placeholders for theme colors |
| `default/udev/` | udev rules for Elgato Cam Link, Framework 16 |
| `default/uwsm/` | UWSM session manager config (Wayland session wrapper) |
| `default/v4l2-relayd/` | v4l2-relayd camera relay config |
| `default/voxtype/` | Voxtype dictation config |
| `default/wayland-sessions/` | `.desktop` for the Omarchy/Hyprland Wayland session |
| `default/wireplumber/` | WirePlumber ALSA soft-mixer default config |
| `default/xdg-terminal-exec/` | xdg-terminal-exec preference file |
| `default/xcompose/` | Shared XCompose key table (emoji and shortcuts) |

---

## `etc/` — System overrides installed to `/etc/`

| Path | App / subsystem | Purpose |
|---|---|---|
| `etc/NetworkManager/` | NetworkManager | Connection profiles and overrides |
| `etc/cups/` | CUPS printing | `cups-files.conf` override (prevents `.pacnew` conflict) |
| `etc/docker/` | Docker daemon | `daemon.json` config |
| `etc/fastfetch/` | Fastfetch system info | `config.jsonc` |
| `etc/gnupg/` | System GnuPG | `gpg-agent.conf` |
| `etc/limine-entry-tool.d/` | Limine entry tool | Drop-in conf files for kernel cmdline additions |
| `etc/mise/` | mise (system-wide) | `config.toml` — system tool pins |
| `etc/mkinitcpio.conf.d/` | mkinitcpio | Modular initramfs config fragments (e.g., zram) |
| `etc/modprobe.d/` | Kernel modules | Module options (zstd compression, etc.) |
| `etc/nsswitch.conf` | NSS | Name resolution order (mdns, resolve) |
| `etc/plymouth/` | Plymouth | `plymouthd.conf` — theme selection |
| `etc/profile.d/` | Shell environment | `omarchy.sh` — sets `OMARCHY_PATH`, `PATH` additions |
| `etc/sddm.conf.d/` | SDDM | `omarchy.conf` — autologin, session, theme |
| `etc/security/` | PAM | `pam_env.conf` additions for SSH PATH |
| `etc/sudoers.d/` | sudo | `omarchy-sudo-keepalive` drop-in |
| `etc/sysctl.d/` | Kernel parameters | `zram-vm.conf` — swappiness for zram |
| `etc/systemd/` | systemd | System unit files, journal config, zram generator |
| `etc/sysusers.d/` | systemd-sysusers | System user/group creation |
| `etc/tmpfiles.d/` | systemd-tmpfiles | Temp/runtime dir creation |
| `etc/udev/` | udev | Additional hardware rules |
| `etc/xdg/` | XDG base dirs | Autostart entries and app defaults |
