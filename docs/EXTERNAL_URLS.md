# docs/EXTERNAL_URLS.md — Upstream External URLs

**Source:** `grep -rhoE 'https?://...' reference/omarchy/` (294 unique URLs after dedup)
**Date:** 2026-10-03

Dispositions:
- **KEEP** — points to a neutral third-party resource Apex can reuse unchanged
- **REPLACE** — Omarchy-branded or Omarchy-specific; needs Apex equivalent
- **REMOVE** — irrelevant to Apex (upstream community links, proprietary apps)
- **REVIEW** — requires human decision (external service with Omarchy credentials)

---

## Omarchy Package Repositories — REPLACE

These are the most critical: all must be replaced with Apex equivalents.

| URL | Where used | Disposition |
|---|---|---|
| `https://pkgs.omarchy.org/stable/` | `default/pacman/pacman-stable.conf`, mirror scripts | **REPLACE** → Apex pacman repo or remove |
| `https://pkgs.omarchy.org/stable/$arch` | pacman config | **REPLACE** |
| `https://pkgs.omarchy.org/rc/` | rc channel config | **REPLACE** or **REMOVE** |
| `https://pkgs.omarchy.org/rc/$arch` | rc channel config | **REPLACE** or **REMOVE** |
| `https://pkgs.omarchy.org/edge/` | edge channel config | **REPLACE** or **REMOVE** |
| `https://pkgs.omarchy.org/edge/$arch` | edge channel config | **REPLACE** or **REMOVE** |
| `https://stable-mirror.omarchy.org/` | mirrorlist | **REPLACE** or **REMOVE** |
| `https://stable-mirror.omarchy.org/$repo/os/$arch` | mirrorlist | **REPLACE** or **REMOVE** |
| `https://rc-mirror.omarchy.org/` | rc mirrorlist | **REPLACE** or **REMOVE** |
| `https://rc-mirror.omarchy.org/$repo/os/$arch` | rc mirrorlist | **REPLACE** or **REMOVE** |
| `https://github.com/NoaHimesaka1873/arch-mact2-mirror/releases/download/release` | `install/hardware/pacman.sh` | **KEEP** (Apple T2 support mirror) |
| `https://geo.mirror.pkgbuild.com/$repo/os/$arch` | pacman config | **KEEP** (official Arch mirror) |
| `https://debuginfod.archlinux.org` | pacman/gdb config | **KEEP** (official) |

## Omarchy Branding / Identity URLs — REMOVE or REPLACE

| URL | Where used | Disposition |
|---|---|---|
| `https://37signals.com/` | about screen, manual | **REMOVE** (upstream author) |
| `https://discord.gg/tXFUdasqhY` | manual, help links | **REMOVE** (Omarchy Discord) |
| `https://github.com/basecamp/omarchy` | various | **REMOVE** → replace with Apex URL |
| `https://logs.omarchy.org` | `omarchy-upload-log` | **REPLACE** → Apex equivalent or **REMOVE** |
| `https://world.hey.com/dhh/beautiful-motivations-6fef7c73` | manual | **REMOVE** |
| `https://world.hey.com/dhh/wonderful-vi-a1d034d3` | manual | **REMOVE** |

## Omarchy-Specific API Endpoints — REVIEW

| URL | Where used | Disposition |
|---|---|---|
| `https://api.anthropic.com/api/oauth/usage` | `omarchy-agent-usage-claude` | **KEEP** (Anthropic API, not Omarchy-branded) |
| `https://api.fireworks.ai` | agent usage | **KEEP** (third-party AI API) |
| `https://cli-chat-proxy.grok.com/v1/billing?format=credits` | Grok usage | **KEEP** (third-party) |
| `https://api.openai.com/auth` | Codex usage | **KEEP** |
| `https://auth.openai.com/oauth/authorize` | Codex OAuth | **KEEP** |
| `https://auth.x.ai/oauth/authorize` | Grok OAuth | **KEEP** |
| `https://claude.com/oauth/authorize` | Claude OAuth | **KEEP** |
| `https://cursor.com/cli` | Cursor install | **KEEP** |
| `https://api.meta.ai/muse-launcher.sh` | mise-work.sh | **KEEP** |

## Arch Linux Official — KEEP

| URL | Purpose |
|---|---|
| `http://ping.archlinux.org/nm-check.txt` | Network connectivity check |
| `https://archlinux.org/` | Manual/docs reference |
| `https://wiki.archlinux.org/title/Main_page` | Manual/docs |
| `https://wiki.archlinux.org/title/NVIDIA` | NVIDIA docs |
| `https://aur.archlinux.org/` | AUR reference |
| `https://aur.archlinux.org/rpc/?v=5&type=info&arg=base` | AUR API (update check) |

## Hyprland / Wayland Official — KEEP

| URL | Purpose |
|---|---|
| `https://wiki.hypr.land/` | Hyprland docs |
| `https://wiki.hypr.land/Configuring/...` | Hyprland config refs (multiple) |
| `https://quickshell.org/` | Quickshell shell |

## Weather / Location APIs — KEEP

| URL | Purpose |
|---|---|
| `https://api.open-meteo.com/v1/forecast` | Weather data (free API) |
| `https://geocoding-api.open-meteo.com/v1/search` | Geocoding (free API) |
| `https://wttr.in/` | Alternative weather data |

## Tool Installation URLs — KEEP

| URL | Tool | Disposition |
|---|---|---|
| `https://astral.sh/uv/install.sh` | uv (Python package manager) | **KEEP** |
| `https://sh.rustup.rs` | Rust toolchain | **KEEP** |
| `https://raw.githubusercontent.com/ocaml/opam/master/shell/install.sh` | opam | **KEEP** |
| `https://cli.github.com/` | GitHub CLI | **KEEP** |
| `https://downloader.battle.net/...` | Battle.net installer | **KEEP** (gaming optional) |

## Optional App / Service URLs (documented in README/manual) — KEEP or REMOVE

| URL | Purpose | Disposition |
|---|---|---|
| `https://1password.com/` | 1Password password manager | **KEEP** (optional install) |
| `https://tailscale.com/` | Tailscale VPN | **KEEP** (optional install) |
| `https://signal.org/` | Signal messenger | **KEEP** (optional install) |
| `https://spotify.com/` | Spotify | **KEEP** (optional install) |
| `https://www.dropbox.com/` | Dropbox | **KEEP** (optional install) |
| `https://app.lizardbyte.dev/Sunshine/` | Sunshine game streaming | **KEEP** (optional) |
| `https://voxtype.io/` | Voxtype dictation | **KEEP** (optional) |
| `https://zoom.us/` | Zoom | **KEEP** (optional) |
| `https://www.hey.com/` | HEY email | **REMOVE** (37signals branding) |
| `https://app.hey.com` | HEY webapp | **REMOVE** |
| `https://basecamp.com/` | Basecamp | **REMOVE** (37signals product) |
| `https://bitwarden.com/` | Bitwarden | **KEEP** (optional alternative) |
| `https://chatgpt.com` | ChatGPT | **KEEP** (optional install) |

## GitHub Source References — KEEP (documentation only)

These appear in comments and manual pages as source attribution. No code action needed.

| URL | Notes |
|---|---|
| `https://github.com/bjarneo/aether` | Aether app source |
| `https://github.com/dockur/windows` | Windows VM source |
| `https://github.com/chaifeng/ufw-docker` | ufw-docker source |
| `https://github.com/can1357/oh-my-pi` | oh-my-pi source |
| `https://github.com/charmbracelet/crush` | crush source |
| `https://github.com/ajeetdsouza/zoxide` | zoxide source |
| `https://github.com/BurntSushi/ripgrep` | ripgrep source |
| `https://github.com/Byron/dua-cli` | dua-cli source |
| `https://github.com/aristocratos/btop` | btop source |
| `https://codeberg.org/dnkl/foot` | foot terminal source |

## Image / Icon CDN URLs — REVIEW

| URL | Where used | Disposition |
|---|---|---|
| `https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/...` | webapp icon fetching | **KEEP** (neutral CDN) |
| `https://www.google.com/s2/favicons?domain=...` | webapp favicon fetching | **KEEP** |
| `https://simpleicons.org/icons/...` | optional app icons | **KEEP** |
| `https://clients2.google.com/service/update2/crx` | Chromium extension updates | **KEEP** |
| `https://aur.archlinux.org/cgit/aur.git/plain/t3code-icon.png` | T3 Code icon | **REVIEW** (AUR icon) |

## Upstream Community / Reference — REMOVE from Apex

| URL | Notes |
|---|---|
| `https://discord.com/channels/@me` | General Discord, not Apex-specific |
| `https://devhints.io/bash` | Bash reference (keep in docs only) |
| `https://asahilinux.org/` | Asahi Linux (referenced for Apple Silicon) |
| `https://asahi-alarm.org/` | Asahi Linux Alarm |

---

## Summary

| Disposition | Count (approximate) |
|---|---|
| **KEEP** | ~180 |
| **REPLACE** | ~12 (all Omarchy pkg repo URLs) |
| **REMOVE** | ~15 (37signals/HEY/Omarchy identity) |
| **REVIEW** | ~10 (OAuth/API endpoints) |

> **Action items:** See `docs/UPSTREAM_DEPS.md` for the replacement plan for
> Omarchy package repository URLs.
