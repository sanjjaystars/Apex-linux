# Upstream ISO Build and Guided Installer Architecture

This document details the upstream (Omarchy) ISO generation workflow, live boot environment, guided installer orchestrator, and deferred provisioning lifecycle, based on verified source files, commit history, and test fixtures in `reference/omarchy`.

---

## 1. ISO Repository & Build Tooling

### 1.1 Sibling Repositories
The upstream project separates source content across three distinct repositories:
1. **`omarchy`** (this reference): Source code for runtime binaries (`bin/`), user and system install/finalization scripts (`install/`), themes (`themes/`), migrations (`migrations/`), shell UI (`shell/`), and configuration defaults.
2. **`omarchy-pkgs`**: PKGBUILD recipes for packaging Omarchy artifacts into Arch packages (`omarchy`, `omarchy-settings`, `omarchy-keyring`, `omarchy-nvim`, etc.).
3. **`omarchy-iso`**: The Archiso-based distribution builder and automated VM testing harness.

*(Verified from `reference/omarchy/agents/skills/acceptance-tests.md` lines 12–33 and `test/shell.d/snapper-test.sh` lines 128–146).*

### 1.2 ISO Build Entrypoint (`omarchy-iso-make`)
Building the ISO is driven by `./bin/omarchy-iso-make` within `omarchy-iso`:
```bash
./bin/omarchy-iso-make --no-boot-offer --local-source ../omarchy ../omarchy-pkgs
```
Key flags and behaviors:
- `--local-source <path1> <path2>`: Overrides package repository sources with local working checkouts, building local `.pkg.tar.zst` packages on the fly before constructing the filesystem image.
- Packages installed into the live root filesystem (`airootfs`) include:
  - Base Arch installation tools (`archiso`, `archinstall`, `mkinitcpio`, `limine`, `btrfs-progs`, `cryptsetup`).
  - Terminal presentation utilities (`gum`, `kbd`, `util-linux`, `tzupdate`).
  - Omarchy packages (`omarchy-settings`, `omarchy-keyring`, `omarchy`).
  - Offline package mirror bundling: caches all packages declared in `install/omarchy-base.packages` (159 packages) and `install/omarchy-other.packages` (57 packages), enabling 100% offline installations.

### 1.3 Acceptance Testing Harness (`omarchy-iso-test`)
The sibling harness executes end-to-end integration and acceptance tests against generated ISOs:
```bash
./bin/omarchy-iso-test release/<generated-iso>.iso --no-preview
```
- Spawns a disposable QEMU VM booting the ISO.
- Sends compositor-level shortcuts and keystrokes via QEMU QMP (QEMU Machine Protocol) virtual keyboard.
- Syncs test suites (`test/acceptance.d/`) over SSH without a pseudo-terminal.
- Automatically captures visual verification screenshots (`success-<step>.png`, `failure-<step>.png`) to `test-runs/<timestamp>/`.

---

## 2. Live Environment & Console UX

### 2.1 Bootloader & Kernel Handoff
- The live media boots using Limine or GRUB with EFI GOP graphics mode (`gfxpayload=keep`).
- The kernel command line sets up the Archiso squashfs overlays and launches the live installer target via systemd or `.automated_script.sh`.

### 2.2 Console Styling & TUI
The live installer and first-boot setup standardize terminal appearance through shared VT helpers:
1. **Tokyo Night VT Palette**:
   16 ANSI color registers are configured directly on the Linux virtual terminal via OSC escape sequences (`\e]P<index><hex>`):
   ```bash
   echo -en "\e]P01a1b26"; echo -en "\e]P1f7768e"; echo -en "\e]P29ece6a"
   echo -en "\e]P3e0af68"; echo -en "\e]P47aa2f7"; echo -en "\e]P5bb9af7"
   echo -en "\e]P67dcfff"; echo -en "\e]P7a9b1d6"; echo -en "\e]P8414868"
   echo -en "\e]P9f7768e"; echo -en "\e]PA9ece6a"; echo -en "\e]PBe0af68"
   echo -en "\e]PC7aa2f7"; echo -en "\e]PDbb9af7"; echo -en "\e]PE7dcfff"
   echo -en "\e]PFc0caf5"
   echo -en "\033[0m"
   clear
   ```
2. **Empirical Console Font Scaling**:
   Because high-resolution displays make the default 8x16 console font unreadable, `scale_console_font` dynamically iterates over standard `kbd` fonts (`default8x16`, `sun12x22`, `latarcyrheb-sun32`) using `setfont` and reads `stty size </dev/tty` to achieve a target screen density of ~48 rows while ensuring width accommodates the 81-column ASCII logo (`LOGO_WIDTH=81`).
3. **Interactive TUI Prompts via `gum`**:
   All user input is rendered using Charmbracelet's `gum` tool (`gum choose`, `gum input`, `gum confirm`, `gum filter`), styled with consistent margins, padding, and purple branding prompts (`--prompt.foreground="#845DF9"`).

---

## 3. Shared Setup Form Contract (`install/provisioning/setup-form.sh`)

To eliminate code drift between the live ISO installer and deferred first-boot setup, all user configuration prompts are isolated in `install/provisioning/setup-form.sh`.

### 3.1 Prompt Exit Codes
Every prompt function in `setup-form.sh` adheres to a strict 3-state exit status contract:
- `0`: Field successfully provided and validated; advance to next step.
- `1` (`OMARCHY_FORM_BACK`): User pressed `Esc`; unwinds back to the beginning of the setup form.
- `130` (`OMARCHY_FORM_SIGNAL`): User pressed `Ctrl+C`; caller-specific signal (the ISO installer toggles deferred provisioning / encryption; first-boot setup prompts for system reboot).

### 3.2 Prompts & Validation Rules
1. **Keyboard Layout** (`omarchy_prompt_keyboard`):
   Presents 48 layouts (`OMARCHY_KEYBOARD_LAYOUTS`) via `gum choose`. `English (US)` leads, followed by UK, Dvorak, Colemak, and 44 alphabetical international layouts.
2. **Username** (`omarchy_prompt_username`):
   Validated against POSIX regex `^[a-z_][a-z0-9_-]*[$]?$`. Rejects 30 reserved system usernames (`root`, `bin`, `daemon`, `systemd-*`, `sddm`, etc.) and calls `omarchy_username_taken` (no-op on blank target disk; checks `getent passwd` on live machine).
3. **Password & Confirmation** (`omarchy_prompt_password`):
   Double-entry masked input (`gum input --password`). Enforces non-empty and identical match. Applied to root, user account, and LUKS container.
4. **Git Identity** (`omarchy_prompt_identity`):
   Prompts for Full Name and Email Address. Optional (pressing Return skips).
5. **Hostname** (`omarchy_prompt_hostname`):
   Validated against RFC regex `^[A-Za-z0-9]([A-Za-z0-9-]{0,61}[A-Za-z0-9])?$`. Defaults to `omarchy` on empty Return.
6. **Timezone** (`omarchy_prompt_timezone`):
   Attempts auto-location via `tzupdate -p`. If detected, pre-selects in `gum choose`; otherwise offers searchable `gum filter` over `timedatectl list-timezones`. Falls back to `UTC`.

---

## 4. Guided Installer Orchestrator Architecture

The guided installer was refactored in Git history (commits `2beda6ab`, `c6ccd625`, and `9800b5b7`) from a multi-stage shell script into a modular Python orchestrator located in `configs/airootfs/usr/share/omarchy-iso/orchestrator/`.

### 4.1 Orchestrator Module Layout
- `main.py`: Entrypoint CLI (`--config`, `--creds`, `--full-name-file`, etc.). Constructs and dispatches phase list.
- `context.py`: `InstallContext` data container tracking paths, target mountpoint (`/mnt`), credentials, and shared phase state.
- `phases.py`: State-machine engine handling step transitions, stdout logging, and exception bubbling (`PhaseError`).
- `phases_impl.py`: Concrete phase implementations.
- `archinstall_adapter.py`: Strict isolation layer around `archinstall.lib.*` imports (`FilesystemHandler`, `Installer`, `MirrorListHandler`).
- `ui.py`: Subprocess wrappers for `gum` styling.

### 4.2 Installation Phases & Ordering Invariants

```
┌──────────────────────────────────────────────────────────────────┐
│ Phase 1: prepare_live                                            │
│ - Load archinstall config & credentials JSON                     │
│ - Initialize offline MirrorListHandler                           │
└────────────────────────────────┬─────────────────────────────────┘
                                 │
┌────────────────────────────────▼─────────────────────────────────┐
│ Phase 2: arch_install                                            │
│ - Partition, format, and encrypt disks (FilesystemHandler)       │
│ - Mount layout to target (/mnt)                                  │
│ - Minimal installation pacstrap (base, kernel, mkinitcpio)       │
│ - Configure swap & install bootloader (Limine)                   │
│ - CRITICAL: Inject /etc/default/limine & /etc/kernel/cmdline     │
│ - Install EARLY_PACKAGES (base-devel, git, settings, installer)  │
│ - Create target user (copies populated /etc/skel into $HOME)     │
│ - Install runtime packages (omarchy + omarchy-base.packages)     │
│ - Configure timezone, ntp, root password, and genfstab           │
└────────────────────────────────┬─────────────────────────────────┘
                                 │
┌────────────────────────────────▼─────────────────────────────────┐
│ Phase 3: run_chroot_finalizer                                    │
│ - arch-chroot -u $USER into target                               │
│ - Root pass: omarchy-apply-system (config, hardware, login, post)│
│ - User pass: omarchy-provision-user --force --first-install      │
└────────────────────────────────┬─────────────────────────────────┘
                                 │
┌────────────────────────────────▼─────────────────────────────────┐
│ Phase 4: validate_boot                                           │
│ - Assert /boot/limine.conf exists & contains entry               │
│ - Assert cryptdevice parameter is present if encrypted           │
│ - Assert UKI image exists in /boot/EFI/Linux/*_linux*.efi        │
└────────────────────────────────┬─────────────────────────────────┘
                                 │
┌────────────────────────────────▼─────────────────────────────────┐
│ Phase 5: finish                                                  │
│ - Prompt user for reboot via UI confirm                          │
└──────────────────────────────────────────────────────────────────┘
```

### 4.3 Critical Architectural Decisions in Phase Ordering
1. **Limine Default Configuration Timing**:
   Upstream inserts `_write_limine_defaults()` immediately after `installer.add_bootloader()` and *before* `installer.add_additional_packages()`. This extracts the kernel command-line arguments (including UUIDs and `cryptdevice=`) from `/mnt/boot/limine.conf`, replaces `@@CMDLINE@@` in the template, and writes `/mnt/etc/default/limine` and `/mnt/etc/kernel/cmdline`. When `limine-mkinitcpio-hook` fires during the subsequent package installation, the Unified Kernel Image (UKI) is generated with correct parameters on the first attempt without requiring a rebuild.
2. **Two-Stage Package Installation for `/etc/skel`**:
   `EARLY_PACKAGES` (`base-devel`, `git`, `omarchy-keyring`, `omarchy-settings`, `omarchy-installer`) are installed *before* `installer.create_users()`. `omarchy-settings` populates `/etc/skel` with default dotfiles, so when `useradd -m` is invoked by archinstall, `$HOME` is correctly seeded from `/etc/skel`.
3. **Chroot Finalization Separation**:
   Target-side configuration is delegated to `omarchy-apply-system` (running as root in chroot) and `omarchy-provision-user` (running as the unprivileged user).

---

## 5. Deferred Provisioning (OEM / Factory Setup)

For pre-installed systems or factory deployments where the end-user is unknown at install time, upstream provides a deferred provisioning workflow:

1. **Installation Invocation**:
   ```bash
   omarchy apply system --defer-provisioning --first-install
   ```
   Runs without creating an initial user. Instead of calling `usermod`, scripts that assign group permissions record them in `/var/lib/omarchy/provisioning/groups`.
2. **Pending Trigger**:
   The installer creates marker file `/var/lib/omarchy/provisioning/pending` and enables `omarchy-provision-owner.service`.
3. **First-Boot Execution (`omarchy-provision-owner`)**:
   - `omarchy-provision-owner.service` runs on `tty1` before `display-manager.service` (SDDM) starts.
   - Clears Plymouth splash (`plymouth quit`).
   - Runs `setup-form.sh` to prompt for keyboard layout, username, password, git identity, and timezone.
   - Creates the user account and applies the recorded groups from `/var/lib/omarchy/provisioning/groups`.
   - Re-keys the LUKS partition encryption from the temporary installation passphrase to the user's password.
   - Runs `omarchy-provision-user --force --first-install`.
   - Removes `/var/lib/omarchy/provisioning/pending` and starts SDDM.
4. **Factory Reset Integration**:
   `omarchy-system-factory-reset` arms `/var/lib/omarchy/provisioning/wipe-pending`. On reboot, `omarchy-system-factory-reset-finish.service` deletes and recreates `@home` and `@log` Btrfs subvolumes before mounting them, resetting the machine to the factory pending state.

---

## 6. Architecture & Implementation Plan for Apex Linux

When constructing the Apex Linux ISO and installer in Stage 6:

1. **Archiso Releng Profile**:
   - Base profile in `iso/` deriving from upstream Arch `releng`.
   - Provide custom `profiledef.sh`, `packages.x86_64`, `airootfs/`, `efiboot/`, and syslinux/grub configs.
2. **Apex Guided Installer**:
   - Rebrand all prompts and default values (`apex`, `Apex Linux`, `/usr/share/apex`, `/var/lib/apex/provisioning`).
   - Implement `apex-install` / `apex-installer` supporting both interactive guided installation (disk selection, LUKS2 encryption, Btrfs subvolume layout `@`, `@home`, `@log`, `@snapshots`, `@pkg`, Limine/systemd-boot) and deferred provisioning.
3. **Safety & Destructive Actions Guard**:
   - Require `TEST_TARGET` environment variable or explicit typed confirmation before running any destructive disk partitioning or formatting operations (`sgdisk`, `cryptsetup`, `mkfs.btrfs`).
4. **Offline Package Repository**:
   - Build script `iso/build-iso.sh` to assemble local pacman repository mirroring official and custom Apex packages.
