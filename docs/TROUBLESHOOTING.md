# Apex Linux Troubleshooting Guide

This document covers common diagnostic workflows, recovery procedures, and solutions for issues encountered during installation or daily desktop operation.

---

## 1. Diagnostic Tools & System Logs

Apex Linux includes dedicated diagnostic commands to inspect system health:

- **Full System Diagnostics**:
  ```bash
  apex debug
  ```
  Prints kernel version, GPU drivers, Hyprland socket status, audio services, and active session environment variables.

- **Check Installer Logs**:
  Installer transcripts are saved to:
  ```bash
  cat /var/log/apex-installer.log
  ```

- **Journal Logs**:
  ```bash
  # Current boot errors
  journalctl -b -p 3 -xb

  # User session desktop logs
  journalctl --user -xeu quickshell
  journalctl --user -xeu hyprland
  ```

---

## 2. Boot & Recovery (Snapper Rollback)

Apex Linux partitions use Btrfs subvolumes with automatic Snapper snapshotting. If an update or configuration change prevents normal boot:

### Step 2.1: Booting an Earlier Snapshot
1. In the Limine bootloader menu, select your fallback entry or press `Esc` to view snapshot kernels.
2. Boot into the read-only snapshot.
3. Once booted, restore the snapshot using Snapper:
   ```bash
   sudo snapper list
   sudo snapper rollback <snapshot-number>
   sudo reboot
   ```

### Step 2.2: LUKS Passphrase Recovery
If unlocking the encrypted drive fails at boot:
1. Ensure your keyboard layout matches the one used during installation.
2. In the live rescue environment:
   ```bash
   cryptsetup open /dev/nvme0n1p2 cryptroot
   mount -o subvol=@ /dev/mapper/cryptroot /mnt
   arch-chroot /mnt
   ```

---

## 3. Package Management & Pacman Issues

### 3.1 Pacman Database Lock Error (`db.lck`)
If an interrupted process leaves the pacman lock active:
```bash
# Check if pacman is actually running
pgrep pacman

# If no pacman process is active, safely remove the lock
sudo rm -f /var/lib/pacman/db.lck
```

### 3.2 Invalid or Corrupted Keyring
If package signatures fail validation:
```bash
apex update keyring
```
Or manually refresh Arch keyrings:
```bash
sudo pacman -Sy --needed archlinux-keyring
sudo pacman-key --populate archlinux
```

### 3.3 Slow Mirrors
Optimize download mirrors by running reflector:
```bash
sudo reflector --latest 20 --protocol https --sort rate --save /etc/pacman.d/mirrorlist
```

---

## 4. Audio & Media Issues

Apex Linux standardizes on PipeWire and WirePlumber.

### 4.1 No Sound or Wrong Audio Device
1. Check status of PipeWire services:
   ```bash
   systemctl --user status pipewire pipewire-pulse wireplumber
   ```
2. Restart user audio services:
   ```bash
   systemctl --user restart pipewire pipewire-pulse wireplumber
   ```
3. Verify volume levels and unmute:
   ```bash
   wpctl status
   wpctl set-mute @DEFAULT_AUDIO_SINK@ 0
   wpctl set-volume @DEFAULT_AUDIO_SINK@ 50%
   ```

---

## 5. Wayland & Hyprland Issues

### 5.1 Black Screen on NVIDIA GPUs
Ensure DRM kernel modesetting is active:
1. Check kernel command line:
   ```bash
   cat /proc/cmdline | grep nvidia-drm.modeset=1
   ```
2. If missing, ensure `/etc/modprobe.d/nvidia.conf` contains:
   ```ini
   options nvidia-drm modeset=1 fbdev=1
   ```
3. Rebuild initramfs:
   ```bash
   sudo mkinitcpio -P
   ```

### 5.2 Multi-Monitor or Display Scaling
To configure monitor resolutions and scale factors, edit `~/.config/hypr/monitors.lua` or run:
```bash
apex display scale
```

---

## 6. Themes & Visual Desync

If an application's colors do not update after switching themes:

1. Re-apply the active theme:
   ```bash
   apex theme set "$(cat ~/.config/apex/current-theme 2>/dev/null || echo 'apex-dark')"
   ```
2. Restart the Quickshell bar and desktop shell:
   ```bash
   apex restart shell
   ```
3. Clean cache records:
   ```bash
   rm -rf ~/.cache/apex/
   ```
