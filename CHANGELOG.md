# Changelog

All notable changes to **Apex Linux** are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [1.0.0] - 2026-10-03

### Genesis & Brand Independence
- Initial stable release of **Apex Linux** — an independent Linux distribution based on Arch Linux.
- Complete codebase rebranding across 1,323 files, 543 file renames, and 0 remaining upstream name leaks.
- Authored bespoke branding assets:
  - High-contrast ANSI block text logo (`logo.txt`) and modern vector SVG (`logo.svg`).
  - Branded SDDM display manager theme and Plymouth boot splash.
  - Minimalistic PNG desktop icons.
- Localized all external repository URLs and environment variables to `default/apex-env`.
- Published `README.md` with explicit third-party attribution and `THIRD_PARTY_NOTICES.md`.

### Installer Hardening & Architecture
- Re-architected `boot.sh` for maximum security: interactive TTY enforcement, strict Bash 5+ detection, and elimination of unverified piped sudo execution.
- Implemented standard logging convention across all `install/` stages (`log_step`) with idempotent reruns.
- Partitioned package sets into official Arch packages vs AUR packages:
  - `install/apex-base-official.packages` (131 verified packages)
  - `install/apex-base-aur.packages` (28 verified packages)
  - `install/apex-other-official.packages` (34 verified packages)
  - `install/apex-other-aur.packages` (23 verified packages)
- Added `bin/apex-install-preflight` and `install/helpers/preflight.sh` checking architecture, root privileges, internet connectivity, UEFI mode, and available disk space.
- Added graceful failure reporting, error traps, and `bin/apex-install-summary`.

### Themes & Visuals
- Defined authoritative theme folder contract and 26-variable `colors.toml` specification in `docs/THEMES.md`.
- Implemented 4 bespoke flagship themes:
  - **Apex Dark**: Signature deep slate and electric sky cyan (#38bdf8).
  - **Apex Light**: High-contrast paper frost and azure blue.
  - **Apex Crimson**: Stealth charcoal and carmine rose (#f43f5e).
  - **Apex Emerald**: Dark forest and mint emerald (#10b981).
- Developed `scripts/gen-wallpapers.sh` for procedural geometric and gradient wallpaper generation across all 26 themes.
- Generated high-resolution switcher cards (`preview.png`) and automated theme validation suite `tests/check-themes.sh`.

### CLI Commands, Migrations & Updates
- Audited and verified all 480 commands in `bin/apex-*` with standardized metadata tags (`apex:summary`, `apex:args`, `apex:examples`).
- Authored keybindings reference `docs/KEYS.md` and created `bin/apex-keys` terminal cheat sheet command.
- Verified timestamped migration engine `bin/apex-migrate` and added initialization migration `migrations/1791000000.sh`.
- Hardened `bin/apex-update` orchestration: pre-flight checks, Snapper Btrfs snapshotting, system pacman updates, database migrations, and non-root AUR updates.

### Bootable Live ISO & Guided Installer
- Initialized Archiso profile in `iso/` with `profiledef.sh`, `packages.x86_64` (91 curated packages), and `pacman.conf`.
- Branded bootloader environments: GRUB (UEFI), Limine, and Syslinux (BIOS) with cyan/slate palettes and `APEX_LINUX` volume label.
- Created live rootfs (`airootfs`) with autologin on `tty1`, MOTD welcome banner, and automated repository embedding (`iso/embed-repo.sh`).
- Implemented `iso/airootfs/usr/local/bin/apex-guided-installer` and `/root/install.sh`:
  - UEFI verification and disk detection.
  - Optional LUKS2 Argon2id full-disk encryption.
  - Automated Btrfs subvolume layout (`@`, `@home`, `@snapshots`, `@var_log`, `@var_cache`).
  - Snapper configuration, pacstrap base deployment, and Limine bootloader configuration.
  - Interactive uppercase `YES` confirmation guard against accidental data loss.
- Created `iso/build-iso.sh` mkarchiso builder wrapper and `tests/iso-smoke-test.sh` QEMU harness.

### Quality Assurance & Testing
- Developed comprehensive automated testing framework:
  - `tests/check-name-leaks.sh`: Zero-tolerance brand leak detection.
  - `tests/check-packages.sh`: Syntax, collision, and duplicate validation.
  - `tests/check-themes.sh`: Theme palette and asset validation.
  - `tests/check-scripts.sh`: Full codebase shellcheck (701 scripts) and Python compiler audit.
  - `tests/run-all.sh`: Master quality gate runner executing all suites.
