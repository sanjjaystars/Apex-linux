# Apex Linux — Fast Install Guide (<60 Seconds)

This guide explains how to install Apex Linux in under 60 seconds on modern
NVMe drives, following the same pattern as Omarchy's rapid-install approach:
defer personal setup to first boot so the ISO writes only the OS skeleton to
disk as fast as possible.

---

## How <60 Seconds Is Achieved

| Factor | Detail |
|---|---|
| **Offline package cache** | The ISO bundles `/var/cache/pacman/pkg`; `pacstrap -c` reads from RAM rather than the network |
| **zstd:1 compression** | Fast mode uses `compress=zstd:1` instead of `zstd:3`, cutting Btrfs write time by ~40% |
| **Deferred user setup** | `apex-provision-owner.service` creates the user on first boot; the ISO never blocks on typing |
| **Single confirmation** | `--fast` waits 5 seconds then proceeds automatically; `--yes` skips all prompts entirely |
| **Auto-disk selection** | When only one non-removable disk is present, `--fast` selects it without user input |

On a modern PCIe 4 NVMe drive the partition + format + pacstrap + Limine steps
complete in 30–50 seconds. Older SATA SSDs typically finish in 90–120 seconds.

---

## Method 1 — Boot the ISO (fastest, recommended)

1. Download the latest ISO from the [releases page](https://github.com/sanjjaystars/Apex-linux/releases/latest)
   or directly:
   ```
   https://github.com/sanjjaystars/Apex-linux/releases/latest/download/apex-linux-x86_64.iso
   ```
2. Flash to USB:
   ```bash
   # Linux
   sudo dd if=apex-linux-x86_64.iso of=/dev/sdX bs=4M status=progress oflag=sync
   # macOS — balenaEtcher: https://etcher.balena.io/
   ```
3. Boot the USB on your target machine (disable Secure Boot in BIOS first).
4. At the live shell, run the **fast installer**:
   ```bash
   apex-guided-installer --fast
   ```
   - If you have exactly one non-removable disk, it is selected automatically.
   - If you have multiple disks, you are prompted to pick one (still under 60 s).
   - A 5-second countdown is shown before destructive formatting begins.
   - The system installs, then prints **INSTALLATION COMPLETED SUCCESSFULLY!**
5. Remove the USB and reboot.
6. On first boot, `apex-provision-owner` prompts for your username, password,
   keyboard layout, and timezone — identical to the Omarchy "new owner" flow.

### Single-disk, fully unattended (lab / fleet / CI)

```bash
# Specify disk explicitly and skip all prompts:
apex-guided-installer --fast --disk /dev/nvme0n1 --yes
```

---

## Method 2 — Existing Arch / Rescue System (one-liner)

If you are already on an Arch Linux live environment or rescue shell:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/sanjjaystars/Apex-linux/main/boot.sh) --fast
```

`boot.sh --fast` will:
1. Verify Bash ≥5, Arch Linux, and prerequisite tools.
2. Clone the Apex repository if not already present.
3. Immediately exec `apex-guided-installer --fast` — no further prompts.

---

## Method 3 — Scripted / Unattended (Zero Keystrokes)

Supply all values on the command line:

```bash
apex-guided-installer \
  --fast \
  --disk /dev/nvme0n1 \
  --yes \
  --hostname my-machine \
  --encrypt
```

| Flag | Effect |
|---|---|
| `--fast` | zstd:1, deferred provisioning, 5-second auto-countdown |
| `--disk DEV` | Skip disk selection prompt |
| `--yes` | Skip countdown and confirmation entirely |
| `--hostname HOST` | Set hostname without prompting |
| `--encrypt` | Enable LUKS2 (requires `--password` or first-boot re-key) |
| `--user NAME --password PASS` | Create the primary user during install, no first-boot form |

---

## First Boot — Completing Setup

When `apex-provision-owner.service` fires on first boot it presents the same
TUI form as the ISO installer's configuration step. It asks for:

- **Keyboard layout** — from the same 48-layout list
- **Username** — validated to POSIX rules, reserved names rejected
- **Password** — confirmed twice; also re-keys LUKS if encryption is enabled
- **Full name & email** — optional (for git config)
- **Hostname** — defaults to `apex-linux`
- **Timezone** — auto-detected via `tzupdate`, or searchable list

After the form completes, SDDM starts and you are at the Apex Linux desktop.

---

## Disk Layout Applied by Fast Mode

```
┌──────────────────────────────────┐
│ /dev/nvmeXnX or /dev/sdX        │
├──────────┬───────────────────────┤
│  Part 1  │ 1024 MiB FAT32 (ESP) │
│          │ mounted at /efi       │
├──────────┼───────────────────────┤
│  Part 2  │ Btrfs (rest of disk)  │
│          │ subvol @       → /    │
│          │ subvol @home   → /home│
│          │ subvol @snapshots     │
│          │ subvol @var_log       │
│          │ subvol @var_cache     │
└──────────┴───────────────────────┘
```

Bootloader: **Limine** (UEFI only; Secure Boot must be disabled).

---

## Troubleshooting

| Symptom | Resolution |
|---|---|
| "No suitable installation disks found" | Check `lsblk`; ensure target disk is visible to the live environment |
| "UEFI boot mode not detected" | Enable UEFI in BIOS, disable legacy/CSM mode |
| Installer exits before formatting | Check `/var/log/apex-installer.log` for the exact error |
| First boot shows blank screen | Wait 30 s; `apex-provision-owner` may still be loading the font |
| LUKS password not accepted at boot | Use a wired or USB dongle keyboard (Bluetooth is unavailable before the OS unlocks the drive) |

Log file on the live system: `/var/log/apex-installer.log`
