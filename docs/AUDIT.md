# docs/AUDIT.md — Upstream Omarchy Install-Flow Audit

**Task:** T1.1
**Source:** `reference/omarchy` (HEAD of cloned upstream)
**Date:** 2026-10-03
**Author:** Apex audit pass

---

## Overview

Omarchy has **no single `boot.sh` or `install.sh` at the repository root.** The
install flow is split across three execution contexts that occur in order:

1. **ISO / archiso** — runs in a live environment, partitions the disk, pacstraps
   packages, then calls `omarchy-apply-system` inside a chroot.
2. **First-boot provisioning** (`omarchy-provision-owner`) — runs on the installed
   target at first boot when a deferred-provisioning or "install for another owner"
   mode was chosen.
3. **First-run user setup** (`omarchy-provision-first-run`) — runs the first time
   the target user logs into a graphical session.

The `install/` directory contains the scripts that all three contexts share. Each
subdirectory is a *stage*; stages are orchestrated by `all.sh` files sourced in
sequence by the two `omarchy-apply-*` commands.

Package files (counts from `grep -vcE '^\s*(#|$)'`):
- `install/omarchy-base.packages` — **159 packages** (pacstrapped by ISO)
- `install/omarchy-other.packages` — **57 packages** (optional/hardware/ISO-builder extras)

---

## Stage 0 — Helpers (`install/helpers/`)

Three helper files are sourced at the top of every orchestrator before any stage runs.

**`install/helpers/logging.sh`** — defines the `run_logged` function used by
every `all.sh` to wrap each stage script. It opens or appends to
`$OMARCHY_INSTALL_LOG_FILE` (default `/var/log/omarchy-install.log`), timestamps
the start and end of every sourced script, captures both stdout and stderr, and
records the exit code. It also exports `start_install_log` / `stop_install_log`
for the outer orchestrators. The `OMARCHY_LOG_TO_STDOUT=1` environment variable
redirects all output to stdout for debugging. `OMARCHY_INSTALL_DEBUG=1` adds
`bash -x` tracing.

**`install/helpers/as-root.sh`** — defines `as_root()`, a one-liner that either
calls the given command directly (when `EUID == 0`) or prefixes it with `sudo`.
This is the privilege-escalation primitive for scripts that may run both inside a
chroot (always root) and on a live system (may be a normal user).

**`install/helpers/browser-policy.sh`** — sources into `install/config/browser-policy.sh`;
calls `browser_policy_setup_dir /etc/chromium/policies/managed` to create the
system-wide Chromium managed policy directory. The underlying helper is defined
in the helpers file and reused by both callers.

---

## Stage 1 — Provisioning / Setup Form (`install/provisioning/`)

**`install/provisioning/setup-form.sh`** — the interactive TUI form shared by
both the ISO configurator and the first-boot owner-setup path. It defines the
keyboard layout list (`$OMARCHY_KEYBOARD_LAYOUTS`, leading with English variants),
username/hostname/password validation patterns, and **six** `omarchy_prompt_*`
functions: `omarchy_prompt_keyboard`, `omarchy_prompt_username`,
`omarchy_prompt_password`, `omarchy_prompt_identity`, `omarchy_prompt_hostname`,
`omarchy_prompt_timezone` (confirmed by `grep -E '^omarchy_prompt_[a-z_]+\(\)'`).
All prompts are driven by `gum`; exit status 0 means accepted, 1 means Esc
(unwind to start), 130 means Ctrl+C (caller-specific side channel — the ISO uses
it to arm deferred provisioning or toggle encryption). This file is *sourced*,
never executed directly.

**`install/provisioning/omarchy-provision-owner.service`** — a systemd oneshot
unit that fires on first boot when `/var/lib/omarchy/provisioning/pending` exists
(written by a deferred-provisioning ISO install or by `omarchy-system-factory-reset`).
It runs before `display-manager.service` and `getty@tty1.service`, conflicts with
the getty, and executes `/usr/bin/omarchy-provision-owner` on tty1. It is not
shipped enabled; the ISO or factory-reset script installs and enables it at the
time it creates the `pending` marker.

**`install/provisioning/omarchy-system-factory-reset-finish.service`** — (inferred
from filename and service ordering comments in omarchy-provision-owner.service,
not read directly) a companion oneshot that must complete for the wipe path
before `omarchy-provision-owner.service` is allowed to start.

---

## Stage 2 — System Config (`install/config/`)

Orchestrated by `install/config/all.sh`, sourced by `omarchy-apply-system` as
the first major stage. Runs as root. Contains eleven scripts called via
`run_logged`:

**`theme-system.sh`** — seeds the system-level Chromium `initial_preferences`
file (sets color-scheme to follow the OS `color_scheme:0`, `color_scheme2:0`,
and sets `require_eula:false`) and creates symlinks in
`/usr/share/icons/Yaru/scalable/actions/` pointing at Adwaita SVGs so Nautilus
action icons render correctly. Runs `gtk-update-icon-cache` afterwards.

**`browser-policy.sh`** — sources `install/helpers/browser-policy.sh` and calls
`browser_policy_setup_dir /etc/chromium/policies/managed` to create the directory
where system-wide Chromium managed JSON policies are placed.

**`increase-lockout-limit.sh`** — edits `/etc/pam.d/system-auth` with `sed` to
change the `pam_faillock.so preauth` and `authfail` lines to use `deny=10
unlock_time=120` (10 attempts before a 2-minute lockout). Also patches
`/etc/pam.d/sddm-autologin` to add an `authsucc` line for faillock, making the
fix idempotent by deleting existing lines before re-adding.

**`lockscreen-pam.sh`** — sources and runs `omarchy-apply-lock` to apply the
lockscreen PAM configuration.

**`fix-powerprofilesctl-shebang.sh`** — patches `/usr/bin/powerprofilesctl` with
`sed` to replace `#!/usr/bin/env python3` with `#!/bin/python3` so the script
does not pick up mise's python3 instead of the system one. Guards with a
file-existence check; idempotent.

**`ssh-command-path.sh`** — appends a `PATH DEFAULT=…` line to
`/etc/security/pam_env.conf` (guarded by a grep so it only runs once) that
includes `~/.local/share/mise/shims` and `~/.local/bin`, giving SSH non-login
commands access to mise-managed tools.

**`ssh-keepalive.sh`** — writes
`/etc/ssh/ssh_config.d/20-omarchy-keepalive.conf` (guarded by file-existence
check) with `ServerAliveInterval 15`, `ServerAliveCountMax 3`, and
`ConnectTimeout 10` so dropped SSH connections are detected within ~45 seconds
rather than hours.

**`docker.sh`** — intentionally a no-op (body is just `:`). The docker group is
no longer granted to the install user by default for security reasons (docker
group = passwordless root). The daemon is still enabled via `docker.socket` in
`enable-services.sh`. Users who want sudoless docker can opt in via
`omarchy-setup-security-sudoless-docker`.

**`snapper.sh`** — creates the snapper `root` config if it does not already
exist (via `snapper create-config /`), installs the Omarchy retention template
over it, writes `/etc/conf.d/snapper` with `SNAPPER_CONFIGS="root"`, disables
`snapper-timeline.timer`, and enables `snapper-cleanup.timer` and
`limine-snapper-sync.service` so Limine boot entries stay in sync with btrfs
snapshots.

**`enable-services.sh`** — enables (but does not start — a reboot follows)
CUPS, Avahi, `linux-modules-cleanup`, `docker.socket`, `systemd-resolved`,
`NetworkManager`, `power-profiles-daemon`, `sddm`, and `systemd-oomd`; masks
`NetworkManager-wait-online.service` so it does not delay boot.

**`firewall.sh`** — sets UFW to default-deny incoming and default-allow outgoing;
opens port 53317 UDP+TCP for LocalSend; adds Docker DNS rules for the
`172.16.0.0/12` and `192.168.0.0/16` ranges; runs `ufw-docker install` via a
shim that fakes `ufw status: active` to satisfy its preflight without activating
UFW in the live ISO environment; and finally patches `/etc/ufw/ufw.conf` to set
`ENABLED=yes` and enables the `ufw` systemd service.

---

## Stage 3 — Hardware (`install/hardware/`)

Orchestrated by `install/hardware/all.sh`, called by `omarchy-apply-hardware`
(which is itself called by `omarchy-apply-system`). Runs as root. Contains
hardware-detection guards: each script checks whether its target device is
present before doing anything, making the entire stage effectively idempotent
across machine types. Key groups:

**`network.sh`** — disables `iwd`, `systemd-networkd` (all related units), and
`systemd-networkd-wait-online`; backs up and removes stock Archinstall `.network`
files that compete with NetworkManager; stops networkd if NetworkManager is
already running.

**`bluetooth.sh`** — enables `bluetooth.service`. Deliberately does NOT set
`AutoEnable=true` in the BlueZ config; power state is managed via rfkill soft
block by `omarchy-bluetooth-power` instead.

**`fix-fkeys.sh`** — writes `/etc/modprobe.d/hid_apple.conf` with
`options hid_apple fnmode=2` (guarded by file-existence check) so function keys
on Apple-style keyboards (including Lofree Flow84) always act as F-keys.

**`fix-synaptic-touchpad.sh`** — loads `psmouse` with `synaptics_intertouch=1`
if a Synaptics device is present in `/proc/bus/input/devices`, psmouse is not
already loaded, and `modprobe -qn` confirms the module exists for the running
kernel. Designed to be safe across chroot installs where the live ISO kernel
differs from the target.

**`set-wireless-regdom.sh`** — reads the installed system's timezone via
`/etc/localtime` symlink, maps it to an ISO country code via `zone.tab`, and
appends `WIRELESS_REGDOM="CC"` to `/etc/conf.d/wireless-regdom` if the file
exists and no domain is already set. Does not call `iw reg set` (reboot path).

**`nvidia.sh`** — detects NVIDIA GPU via `lspci`; selects `nvidia-open-dkms`
(GSP-capable) or `nvidia-580xx-dkms` (older cards) via `omarchy-hw-nvidia-gsp`
/ `omarchy-hw-nvidia-without-gsp` helpers; installs the appropriate utils and
lib32 packages; writes `/etc/modprobe.d/nvidia.conf` with `modeset=1` and
`/etc/mkinitcpio.conf.d/nvidia.conf` with the four nvidia modules for early KMS.

**`vulkan.sh`** — detects GPU vendor (Intel/AMD/Apple) via `lspci` and installs
the matching Vulkan ICD loader (`vulkan-intel`, `vulkan-radeon`, or
`vulkan-asahi`). NVIDIA Vulkan is handled by `nvidia.sh` via `nvidia-utils`.

**`speaker-tuning.sh`** — runs `omarchy-audio-tuning match` to check if a
speaker tuning exists for this machine; if so, installs `lsp-plugins-lv2` (the
LV2 lookahead limiter required by every shipped tuning graph).

**`pacman.sh`** (hardware variant) — checks for Apple T2 PCI IDs (`106b:1801`
or `106b:1802`) and if found appends the `[arch-mact2]` repository block to
`/etc/pacman.conf` (guarded by a grep so it does not duplicate on reruns).

**Vendor-specific scripts:**
- `asus-rog.sh` — installs `asusctl` if `omarchy-hw-asus-rog` returns true.
- `framework16.sh` — installs `qmk-hid` if `omarchy-hw-framework16` returns true.
- `dell-xps-touchpad-haptics.sh` — installs `dell-xps-touchpad-haptics` package if detected.
- `surface.sh` — installs `linux-firmware-marvell` if `omarchy-hw-surface` returns true.

**Intel sub-directory (`install/hardware/intel/`):**
- `video-acceleration.sh` — detects Intel GPU generation via `lspci` output; installs `intel-media-driver + libvpl + vpl-gpu-rt` for HD/UHD/Iris/Xe/Arc/Panther Lake, or `libva-intel-driver` for GMA-era (pre-2017) GPUs.
- `lpmd.sh` — detects Intel hybrid CPU by model number (Alder Lake 151/154, Raptor Lake 183/186/191, Meteor Lake 170/172, Lunar Lake 189, Panther Lake 204) on battery-present machines; installs `intel-lpmd` and enables `intel_lpmd.service`.
- `thermald.sh` — detects Intel Sandy Bridge (model ≥ 42) on battery-present machines; installs `thermald` and enables `thermald.service`.
- `ipu7-camera.sh` — checks `/sys/bus/acpi/devices/*/hid` for `OVTI08F4` (Intel IPU7 camera ACPI ID); installs `intel-ipu7-camera`.
- `fred.sh` — detects Intel Panther Lake via `omarchy-hw-intel-ptl`; appends `fred=on` to the kernel command line via a limine-entry-tool drop-in.
- `fix-wifi7-eht.sh` — detects Intel BE200/BE211 cards by PCI ID (`8086:e440` or `8086:272b`); writes `/etc/modprobe.d/iwlwifi-disable-eht.conf` to disable Wi-Fi 7 EHT (broken RX data path workaround).
- `sof-firmware.sh` — detects Intel SOF audio DSP via `omarchy-hw-intel-sof`; installs `sof-firmware`.

**Apple sub-directory (`install/hardware/apple/`):**
- `fix-spi-keyboard.sh` — detects MacBook models needing SPI keyboard driver by DMI product name; installs `macbook12-spi-driver-dkms` and writes the appropriate `MODULES=()` to `/etc/mkinitcpio.conf.d/macbook_spi_modules.conf`.
- `fix-suspend-nvme.sh` — detects affected MacBook models by DMI; checks for the NVMe PCI device at `0000:01:00.0`; installs a systemd service that writes `0` to `d3cold_allowed` to prevent NVMe wake failures.
- `fix-t2.sh` — detects T2 chip by PCI ID (`106b:1801/1802`); installs `linux-t2`, `linux-t2-headers`, `apple-t2-audio-config`, `apple-bcm-firmware`, `t2fanrd`; writes mkinitcpio modules, kernel cmdline (`intel_iommu=on iommu=pt pm_async=off mem_sleep_default=deep`), and `t2fand.conf` with fan curves.
- `fix-brcmfmac-supplicant.sh` — detects Macs with Broadcom Wi-Fi (T2 PCI ID or BCM43xx PCI IDs) and writes `/etc/modprobe.d/brcmfmac.conf` with `feature_disable=0x82000` to hand the WPA handshake back to wpa_supplicant in software, fixing connection failures with WPA2/WPA3 transition-mode APs.

**ASUS sub-directory (`install/hardware/asus/`):**
- `fix-asus-ptl-display-backlight.sh` — detects ExpertBook B9406 or Zenbook UX5406AA; adds `xe.enable_dpcd_backlight=1` kernel cmdline via limine drop-in.
- `fix-asus-ptl-b9406-display.sh` — detects ExpertBook B9406; adds `xe.enable_panel_replay=0` kernel cmdline to fix screen-freeze on Panel Replay exit.
- `fix-asus-ptl-b9406-touchpad.sh` — detects ExpertBook B9406; writes a libinput quirks file that masks `ABS_MT_PRESSURE` and `ABS_PRESSURE` axes to fix "Touch jump detected" motion rejection.
- `fix-z13-touchpad.sh` — detects ASUS ROG + DMI match for "GZ302"; writes a udev rule marking the Z13 detachable keyboard touchpad as internal so disable-while-typing works.

**Framework sub-directory (`install/hardware/framework/`):**
- `qmk-hid.sh` — detects Framework 16; copies `framework16-qmk-hid.rules` to `/etc/udev/rules.d/50-framework16-qmk-hid.rules` for unprivileged RGB control access.

**Lenovo sub-directory (`install/hardware/lenovo/`):**
- `fix-yoga-pro7-bass-speakers.sh` — detects "Yoga Pro 7 14IAH10" via `omarchy-hw-match`; writes `/etc/modprobe.d/lenovo-yoga-pro7-bass.conf` with `hda_model=alc287-yoga9-bass-spk-pin` to route audio to both AMP speakers.

**Remaining hardware fixes:**
- `fix-bcm43xx.sh` — detects BCM4360 (`14e4:43a0`) or BCM4331 (`14e4:4331`) via `lspci`; installs `broadcom-wl-dkms`.
- `fix-surface-keyboard.sh` — detects Surface devices via `omarchy-hw-surface`; autodetects the `pinctrl_*` module from `lsmod` and writes it plus Surface aggregator/HID modules to `mkinitcpio.conf.d`.
- `fix-yt6801-ethernet-adapter.sh` — intentional no-op; notes that fresh installs use the kernel's upstream `dwmac-motorcomm` driver; the DKMS fallback is retired by migration 1788279117 on existing systems.
- `fix-tuxedo-backlight.sh` — detects TUXEDO or Slimbook chassis via `sys_vendor`; installs `tuxedo-drivers-nocompatcheck-dkms`; blacklists `clevo_xsm_wmi` module and removes orphaned copies.
- `fix-elgato-camlink-4k.sh` — detects Elgato Cam Link 4K via `omarchy-hw-elgato-camlink-4k`; installs `v4l2loopback-dkms`, `v4l2loopback-utils`, `v4l2-relayd`; writes udev rules, relay config, and systemd services to expose it as a 1280x720 virtual camera.
- `dell-xps13-sidecar-amps.sh` — detects via `omarchy-hw-dell-xps13-sidecar-amps`; installs `dell-xps13-sidecar-amps` package and runs `dell-xps13-sidecar-amps-apply`; placed last in `all.sh` because it rebuilds the boot image.

---

## Stage 4 — Login Manager (`install/login/`)

Orchestrated by `install/login/all.sh`; contains a single script:

**`sddm.sh`** — removes the `-auth pam_gnome_keyring.so` and
`-password pam_gnome_keyring.so` lines from `/etc/pam.d/sddm` using `sed -i /…/d`
to prevent SDDM from creating an encrypted login keyring on password entry, which
would conflict with Omarchy's passwordless default keyring setup.

---

## Stage 5 — Post-Install (`install/post-install/`)

Orchestrated by `install/post-install/all.sh`; three scripts:

**`pacman.sh`** — copies `$OMARCHY_PATH/default/pacman/pacman-${OMARCHY_MIRROR:-stable}.conf`
to `/etc/pacman.conf` and the matching `mirrorlist-stable` to
`/etc/pacman.d/mirrorlist`, restoring the final mirrors after the ISO's offline
pacstrap. Also installs `etc-overrides/cups-cups-files.conf` over
`/etc/cups/cups-files.conf` (removing any `.pacnew`) to prevent a CUPS config
conflict on future updates. Then re-sources `install/hardware/pacman.sh` to
finalize hardware-conditional repos (e.g., the `[arch-mact2]` block).

**`udev.sh`** — runs `udevadm control --reload` and
`udevadm trigger --subsystem-match=power_supply` so package-owned udev rules
take effect in the live install session without a reboot.

**`localdb.sh`** — runs `updatedb --prune-bind-mounts=no --add-prunepaths=/.snapshots`
so `locate` can find newly installed system files immediately.

---

## Stage 6 — User Setup (`install/user/`)

Orchestrated by `install/user/all.sh`, sourced by `omarchy-provision-user`
(itself called by `omarchy-provision-owner` and `omarchy-provision-first-run`).
Runs as the **target user** (not root). Contains fourteen scripts:

**`theme.sh`** — creates `~/.config/omarchy/themes/`; seeds the default "Tokyo
Night" theme via `omarchy-theme-set` if no theme is already active (uses
`OMARCHY_THEME_HEADLESS=1` in chroot/provision context); removes Chromium
`SingletonLock`; activates the Pi AI theme via `omarchy-theme-set-pi --activate`;
symlinks `~/.config/btop/themes/current.theme` to the active theme's btop file.

**`chromium.sh`** — installs two Chromium native messaging extensions by running
`omarchy-install-chromium-copy-url` and `omarchy-install-chromium-ytdlp` (needed
because Chromium is in the base package set, not installed via the browser
installer, so these extensions would otherwise never be set up).

**`git.sh`** — sets `user.name` and `user.email` in `~/.gitconfig` from
`$OMARCHY_USER_NAME` / `$OMARCHY_USER_EMAIL`; guards each with a non-empty check
so skipped fields do not write blank values.

**`xcompose.sh`** — writes `~/.XCompose` with an include for
`/usr/share/omarchy/default/xcompose` and two Compose sequences binding
`<Multi_key> <space> <n>` to `$OMARCHY_USER_NAME` and `<space> <e>` to
`$OMARCHY_USER_EMAIL`.

**`mise-work.sh`** — creates `~/Work/` and `~/Work/tries/`; installs Node.js
from the bundled ISO tarball when `$OMARCHY_SETUP_CONTEXT` is `iso-chroot` or
`provision-owner` (unpacking from `/opt/packages` or
`/var/lib/omarchy/provisioning/packages` respectively, then loosening the pin to
`latest`); falls back to `mise use -g node@latest` on live systems.

**`mise.sh`** — **distinct from `mise-work.sh`** (confirmed by diff). Installs
the same AI CLI and developer tools as `mise-work.sh` (same `omarchy-mise-install`
call list: `codex`, `claude`, `crush`, `antigravity-cli`/`agy`, `gh`,
`copilot`, `opencode`, `npm:playwright`, `pi`, `oh-my-pi`/`omp`, `grok`,
`cursor-agent`, `npm:@kitlangton/ghui`, `aqua:modem-dev/hunk`, `hey`,
`basecamp`, `npm:cf`, `ori`, `muse`), but does **not** create `~/Work/` or
handle the offline Node tarball. It also sets `upgrade.auto_prune false` before
installing. Purpose: installs AI/dev CLIs for the standard user. `mise-work.sh`
is for the work/offline-install path that also sets up Node from the ISO bundle.

**`default-keyring.sh`** — creates
`~/.local/share/keyrings/Default_keyring.keyring` with `lock-on-idle=false` and
`lock-after=false` (guarded by file-existence check), and
`~/.local/share/keyrings/default` pointing to it. Sets permissions: 700 on the
dir, 600 on the keyring, 644 on the pointer.

**Hardware sub-scripts (`install/user/hardware/`):**
- `asus/fix-audio-mixer.sh` — copies `alsa-soft-mixer.conf` into WirePlumber config and uses `amixer` to unmute/set the ALC285 Master level to 80% on ASUS ROG laptops.
- `asus/fix-mic.sh` — uses `amixer` to set ALC285 Internal Mic Boost to 0 and Capture to 70% unmute, then stores ALSA state, on ASUS ROG laptops.
- `dell/xps13-text-scaling.sh` — calls `omarchy-display-text-size 11` on the Dell XPS 13 (DX13260) to reduce the default text size slightly for its 2560x1600 panel.
- `fix-nouveau-cursor.sh` — detects nouveau kernel driver via `lspci -k`; appends a Hyprland Lua config block enabling `no_hardware_cursors` to `~/.config/hypr/looknfeel.lua` if it exists and doesn't already have the setting.
- `framework/fix-f13-amd-audio-input.sh` — uses `pactl` to find the AMD audio card and set its profile to `HiFi (Mic1, Mic2, Speaker)`.
- `vm-no-animations.sh` — detects virtual machine via `omarchy-hw-vm`; copies the `no-animations.lua` toggle file into `~/.local/state/omarchy/toggles/hypr/` to disable Hyprland animations and transparency without a live session.

---

## Stage 7 — First-Run (`install/user/first-run/`)

Executed by `omarchy-provision-first-run`, which is invoked on the user's first
graphical login. Runs as the target user.

**`enable-user-units.sh`** — calls `systemctl --user daemon-reload` then
`systemctl --user enable --now` for `bt-agent.service`, `owed.service`,
`omarchy-recover-internal-monitor.service`, `omarchy-sleep-lock.service`,
`omarchy-migrate-notify.service`, `omarchy-fcitx5.service`, and
`omarchy-crash-watch.service`. Also installs the owe theme-set hook via
`omarchy-hook-install theme-set /usr/share/owe/10-owe-sync`.

**`gnome-theme.sh`** — runs three `gsettings set` calls: `gtk-theme` →
`Adwaita-dark`, `color-scheme` → `prefer-dark`, `icon-theme` → `Yaru-blue`.

**`gtk-primary-paste.sh`** — runs `gsettings set
org.gnome.desktop.interface gtk-enable-primary-paste true` to enable GTK
middle-click primary paste.

**`audio-tuning.sh`** — runs `omarchy-audio-tuning on` to apply the speaker EQ
tuning for this machine (a no-op on machines with no matching tuning). Runs at
first-run rather than finalize-user because the PipeWire sink does not exist in
the ISO chroot.

**`welcome.sh`** — sends the welcome desktop notification ("Super+K for
cheatsheet; Super+Space for Omarchy Menu") via `omarchy-notification-send -u
critical` with an action to open `omarchy-menu-keybindings`.

**`wifi.sh`** — waits for NetworkManager startup complete (`nm-online -q -s -t
30`), then either sends a "Setup Wi-Fi" notification (if offline) or a "Update
System" notification (if online), in a detached background process so a slow
connection never blocks the rest of first-run.

Additionally `omarchy-provision-first-run` installs three post-update hooks via
`omarchy-hook-install post-update`: Voxtype, fingerprint setup, and agent setup.

---

## Orchestrator Commands (summary)

| Command | Runs as | Calls |
|---|---|---|
| `omarchy-apply-system` | root | `install/config/all.sh` → `omarchy-apply-hardware` → `install/login/all.sh` → `install/post-install/all.sh` |
| `omarchy-apply-hardware` | root | `install/hardware/all.sh` |
| `omarchy-provision-owner` | root (service) | TUI form → creates user → calls `omarchy-provision-user` as target user |
| `omarchy-provision-user` | target user | `install/user/all.sh` + XDG dirs + default browser/mailto |
| `omarchy-provision-first-run` | target user | `omarchy-provision-user` + `install/user/first-run/*.sh` |

---

## Key Design Patterns Observed

- **No single entry-point script.** The ISO (not tracked in this repo) is the
  true entry point; it calls `omarchy-apply-system` in a chroot after
  pacstrapping from `install/omarchy-base.packages`.
- **`run_logged` wrapping.** Every sub-script is sourced (not exec'd) through
  `run_logged`, so failures are captured and logged but do not abort the parent
  orchestrator's `set -euo pipefail` — each sub-script failure is isolated.
- **Hardware detection is guard-based.** Scripts check `lspci`, `omarchy-hw-*`
  commands, or file-existence tests before acting; the hardware stage is safe to
  re-run on any machine (idempotent in practice).
- **Deferred provisioning.** When installing "for another owner" or via
  unattended ISO, `--defer-provisioning` skips user-creation during the chroot;
  a systemd oneshot unit handles it on first boot.
- **Environment variables as the API.** `$OMARCHY_PATH`, `$OMARCHY_INSTALL`,
  `$OMARCHY_INSTALL_USER`, `$OMARCHY_FIRST_INSTALL`, `$OMARCHY_SETUP_CONTEXT`,
  and `$OMARCHY_INSTALL_LOG_FILE` are exported before any stage runs and
  consumed throughout. No config files are parsed at runtime.
- **Scripts under `install/` omit shebangs intentionally** — they are sourced,
  not executed, so a shebang would be misleading.

---

## Files Opened for This Audit

### Read (cat / viewed — content confirmed)

```
reference/omarchy/README.md
reference/omarchy/AGENTS.md
reference/omarchy/manual/02-getting-started.md
reference/omarchy/install/provisioning/setup-form.sh
reference/omarchy/install/provisioning/omarchy-provision-owner.service
reference/omarchy/install/helpers/logging.sh
reference/omarchy/install/helpers/as-root.sh
reference/omarchy/install/config/all.sh
reference/omarchy/install/config/theme-system.sh
reference/omarchy/install/config/browser-policy.sh
reference/omarchy/install/config/increase-lockout-limit.sh
reference/omarchy/install/config/lockscreen-pam.sh
reference/omarchy/install/config/fix-powerprofilesctl-shebang.sh
reference/omarchy/install/config/ssh-command-path.sh
reference/omarchy/install/config/ssh-keepalive.sh
reference/omarchy/install/config/docker.sh
reference/omarchy/install/config/snapper.sh
reference/omarchy/install/config/enable-services.sh
reference/omarchy/install/config/firewall.sh
reference/omarchy/install/hardware/all.sh
reference/omarchy/install/hardware/network.sh
reference/omarchy/install/hardware/bluetooth.sh
reference/omarchy/install/hardware/nvidia.sh
reference/omarchy/install/hardware/vulkan.sh
reference/omarchy/install/hardware/fix-fkeys.sh
reference/omarchy/install/hardware/fix-synaptic-touchpad.sh
reference/omarchy/install/hardware/set-wireless-regdom.sh
reference/omarchy/install/hardware/speaker-tuning.sh
reference/omarchy/install/hardware/pacman.sh
reference/omarchy/install/hardware/asus-rog.sh
reference/omarchy/install/hardware/framework16.sh
reference/omarchy/install/hardware/dell-xps-touchpad-haptics.sh
reference/omarchy/install/hardware/surface.sh
reference/omarchy/install/hardware/intel/video-acceleration.sh
reference/omarchy/install/hardware/intel/lpmd.sh
reference/omarchy/install/hardware/intel/thermald.sh
reference/omarchy/install/hardware/intel/ipu7-camera.sh
reference/omarchy/install/hardware/intel/fred.sh
reference/omarchy/install/hardware/intel/fix-wifi7-eht.sh
reference/omarchy/install/hardware/intel/sof-firmware.sh
reference/omarchy/install/hardware/apple/fix-spi-keyboard.sh
reference/omarchy/install/hardware/apple/fix-suspend-nvme.sh
reference/omarchy/install/hardware/apple/fix-t2.sh
reference/omarchy/install/hardware/apple/fix-brcmfmac-supplicant.sh
reference/omarchy/install/hardware/asus/fix-asus-ptl-display-backlight.sh
reference/omarchy/install/hardware/asus/fix-asus-ptl-b9406-display.sh
reference/omarchy/install/hardware/asus/fix-asus-ptl-b9406-touchpad.sh
reference/omarchy/install/hardware/asus/fix-z13-touchpad.sh
reference/omarchy/install/hardware/framework/qmk-hid.sh
reference/omarchy/install/hardware/lenovo/fix-yoga-pro7-bass-speakers.sh
reference/omarchy/install/hardware/dell-xps13-sidecar-amps.sh
reference/omarchy/install/hardware/fix-bcm43xx.sh
reference/omarchy/install/hardware/fix-surface-keyboard.sh
reference/omarchy/install/hardware/fix-yt6801-ethernet-adapter.sh
reference/omarchy/install/hardware/fix-tuxedo-backlight.sh
reference/omarchy/install/hardware/fix-elgato-camlink-4k.sh
reference/omarchy/install/login/all.sh
reference/omarchy/install/login/sddm.sh
reference/omarchy/install/post-install/all.sh
reference/omarchy/install/post-install/pacman.sh
reference/omarchy/install/post-install/udev.sh
reference/omarchy/install/post-install/localdb.sh
reference/omarchy/install/user/all.sh
reference/omarchy/install/user/theme.sh
reference/omarchy/install/user/chromium.sh
reference/omarchy/install/user/git.sh
reference/omarchy/install/user/xcompose.sh
reference/omarchy/install/user/mise-work.sh
reference/omarchy/install/user/mise.sh
reference/omarchy/install/user/default-keyring.sh
reference/omarchy/install/user/hardware/asus/fix-audio-mixer.sh
reference/omarchy/install/user/hardware/asus/fix-mic.sh
reference/omarchy/install/user/hardware/dell/xps13-text-scaling.sh
reference/omarchy/install/user/hardware/fix-nouveau-cursor.sh
reference/omarchy/install/user/hardware/framework/fix-f13-amd-audio-input.sh
reference/omarchy/install/user/hardware/vm-no-animations.sh
reference/omarchy/install/user/first-run/welcome.sh
reference/omarchy/install/user/first-run/wifi.sh
reference/omarchy/install/user/first-run/enable-user-units.sh
reference/omarchy/install/user/first-run/gnome-theme.sh
reference/omarchy/install/user/first-run/gtk-primary-paste.sh
reference/omarchy/install/user/first-run/audio-tuning.sh
reference/omarchy/install/omarchy-base.packages
reference/omarchy/install/omarchy-other.packages
reference/omarchy/bin/omarchy-apply-system
reference/omarchy/bin/omarchy-apply-hardware
reference/omarchy/bin/omarchy-provision-owner
reference/omarchy/bin/omarchy-provision-user
reference/omarchy/bin/omarchy-provision-first-run
```

### Listed only (not read — directory listing or `ls` only; no cat/view)

```
reference/omarchy/install/provisioning/omarchy-system-factory-reset-finish.service
reference/omarchy/install/helpers/browser-policy.sh
```

_(All other files in `install/` that appear in the descriptions above were
read in full during this audit session. The two files above were not directly
read; descriptions for them are inferred from service ordering comments in
`omarchy-provision-owner.service` and from how `install/config/browser-policy.sh`
calls the helper respectively.)_
