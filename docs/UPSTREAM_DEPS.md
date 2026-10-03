# Upstream Dependencies & Custom Package Audit (`docs/UPSTREAM_DEPS.md`)

This document analyzes all custom, non-standard, and upstream-owned packages identified in `install/omarchy-base.packages` and `install/omarchy-other.packages`, and establishes the definitive disposition (**KEEP**, **REPLACE**, **REMOVE**, or **BLOCKED**) for Apex Linux.

---

## 1. Upstream-Owned Package Summary

Upstream Omarchy ships its own custom binary package repository (`pkgs.omarchy.org`), containing proprietary utilities, patched kernels, and custom GUI applications. An independent distribution cannot rely on a third-party, single-vendor repository.

| Package Name | Upstream Purpose | Current Source | Apex Disposition | Apex Alternative / Resolution |
| :--- | :--- | :--- | :--- | :--- |
| `linux-omarchy` | Custom patched Arch kernel | Omarchy Repo | **REPLACE** | Official `linux` or `linux-zen` kernel |
| `linux-omarchy-headers` | Custom kernel headers | Omarchy Repo | **REPLACE** | Official `linux-headers` or `linux-zen-headers` |
| `omarchy-settings` | Pre-install system configs & `/etc/skel` defaults | Omarchy Repo | **REPLACE** | `apex-settings` (generated from `config/`, `etc/`, `default/`) |
| `omarchy-keyring` | Distro pacman GPG keys | Omarchy Repo | **REPLACE** | `apex-keyring` or standard `archlinux-keyring` |
| `omarchy-nvim` | Pre-configured Neovim distribution | Omarchy Repo | **REPLACE** | Shipped directly via `/etc/skel/.config/nvim/` or `apex-nvim` |
| `omasnap` | Screenshot capture and interactive editor | Omarchy Repo | **REPLACE** | Official `satty` + `grim` + `slurp` (standard Wayland stack) |
| `omacalc` | Minimal calculator GUI app | Omarchy Repo | **REMOVE** | `kcalc`, `qalculate-gtk`, or CLI `qalc` |
| `omacut` | Screen cutting / snippet tool | Omarchy Repo | **REMOVE** | Standard `grim` + `slurp` cropping |
| `omawrite` | Distraction-free markdown editor | Omarchy Repo | **REMOVE** | `ghostwriter`, `apostrophe`, or Neovim/Helix |
| `herdr` | Multi-machine SSH fleet sync tool | Omarchy Repo | **REMOVE** | Non-essential; disable `apex-toggle-theme-sync` |
| `hype` | Preinstalled utility application | Omarchy Repo | **REMOVE** | Drop from preinstalled package list |
| `monologue` | Voice/audio recording utility | Omarchy Repo | **REMOVE** | Drop from preinstalled package list |
| `owe` | Open Wallpaper Engine (video backgrounds) | Omarchy Repo | **REMOVE** | `mpvpaper` or native static wallpapers (`hyprpaper`/`swww`) |
| `owe-lockfeed` | Video frame feeder for lockscreen | Omarchy Repo | **REMOVE** | Static blur via Hyprlock / Swaylock |
| `ttfx` | Rust port of terminaltexteffects | Omarchy Repo | **REPLACE** | `python-terminaltexteffects` (AUR/pip) or `cmatrix` |
| `tobi-try` | Code experiment sandbox manager | GitHub/AUR | **REMOVE** | Drop from base; optional user utility |
| `usage` | CLI specification & completion tool | Arch/AUR/Cargo | **KEEP** | Standard open source CLI by jdx (`mise` ecosystem) |
| `aether` | Proprietary Omarchy desktop app | Omarchy Repo | **REMOVE** | Drop from preinstalled package list |
| `cliamp` | Terminal music player / streamer | AUR | **REMOVE** | Drop from base preinstalls; user-installable |

---

## 2. In-Depth Analysis & Replacement Strategies

### 2.1 Kernel Stack (`linux-omarchy` → `linux` / `linux-zen`)
- **Upstream Reality:** Omarchy maintains a custom kernel build (`linux-omarchy`), introducing maintenance overhead, compilation costs, and binary repository dependency.
- **Apex Strategy:** Replace entirely with official Arch Linux packages:
  - Default: `linux` (and `linux-headers`) from Arch `[core]`.
  - Recommended Desktop Alternative: `linux-zen` (and `linux-zen-headers`) from Arch `[extra]`, providing optimized responsiveness, low-latency scheduling, and broad hardware support without custom kernel compilation infrastructure.

### 2.2 Screenshot and Annotation (`omasnap` → `satty` + `grim` + `slurp`)
- **Upstream Reality:** In migration `1788129995.sh`, upstream replaced `satty` and `tensaku-edit` with their custom `omasnap` binary.
- **Apex Strategy:** Return to the proven, battle-tested open source Wayland screenshot suite:
  - `grim` for screen capture.
  - `slurp` for interactive region selection.
  - `satty` for interactive on-screen annotation, drawing, and cropping.
  - Update `bin/apex-capture-screenshot` and `config/imv/config` shortcuts (`<Ctrl+e>`) to invoke `satty`.

### 2.3 Wallpaper & Animation Stack (`owe` / `ttfx`)
- **Upstream Reality:** `owe` (Open Wallpaper Engine) and `owe-lockfeed` run video background rendering. `ttfx` is a standalone Rust binary port of `python-terminaltexteffects` used for console splash animations and terminal screensavers.
- **Apex Strategy:**
  - Video backgrounds are resource-intensive luxuries. Apex defaults to hardware-accelerated static wallpaper rendering via `hyprpaper` or `swww`.
  - For the screensaver (`apex-screensaver`), support standard `python-terminaltexteffects` if installed, or fallback gracefully to lightweight alternatives (`cmatrix`, `pipes-sh`, or ASCII banner display).

### 2.4 Editor Configuration (`omarchy-nvim` → Direct Skel Dotfiles)
- **Upstream Reality:** Upstream builds a separate package `omarchy-nvim` that installs to `/etc/skel/.config/nvim/`.
- **Apex Strategy:** Include the curated Neovim configuration directly in `config/nvim/`, which `rebrand.sh` deploys to `/etc/skel/.config/nvim/` and `/usr/share/apex/config/nvim/`. No external package build is required.

### 2.5 Preinstalled Desktop Applications
- **Upstream Reality:** `omarchy-install-preinstalls` and `omarchy-remove-preinstalls` track a hardcoded list of 15 desktop apps: `aether`, `cliamp`, `libreoffice-fresh`, `xournalpp`, `pinta`, `obsidian`, `obs-studio`, `kdenlive`, `moonlight-qt`, `lazydocker`, `omacut`, `monologue`, `omacalc`, `omawrite`, `hype`.
- **Apex Strategy:**
  - Remove all vendor-proprietary binaries (`aether`, `cliamp`, `omacut`, `monologue`, `omacalc`, `omawrite`, `hype`).
  - Retain standard open-source applications (`libreoffice-fresh`, `obs-studio`, `xournalpp`, `pinta`, etc.) or make them opt-in via `apex-install-app`.

---

## 3. Package Lists Impact

### Cleaned Base Package Set (`apex-base.packages`)
Removing the ~11 custom Omarchy packages leaves ~148 clean upstream Arch Linux official and standard AUR packages in `apex-base.packages`, ensuring the base distribution can be built and installed completely from standard Arch Linux mirrors.
