# Apex Linux ISO Build and Verification Guide

This document describes how to build, test, and verify the bootable Apex Linux installation ISO on an Arch Linux system or virtual machine.

> **Status on macOS development host:** Marked `UNTESTED` per distribution development rules. Neither `mkarchiso` nor `qemu-system-x86_64` are native to Darwin arm64. Build and execution testing must be conducted on an Arch Linux workstation.

---

## 1. Prerequisites on Arch Linux

Install the required Archiso, QEMU, and virtualization packages:

```bash
sudo pacman -S --needed archiso qemu-desktop edk2-ovmf rsync
```

Ensure hardware virtualization (KVM) is available:
```bash
ls -l /dev/kvm
```

---

## 2. Automated Build & Smoke Test Harness

Run the automated test runner from the root of the repository:

```bash
sudo ./tests/iso-smoke-test.sh
```

This harness automatically:
1. Validates the profile in `iso/`
2. Syncs the latest Apex repository into `iso/airootfs/opt/apex-linux`
3. Executes `mkarchiso` to produce `iso/out/apex-linux-*.iso`
4. Creates a virtual 30GB test drive (`/tmp/apex-iso-smoke-disk.qcow2`)
5. Boots the generated ISO in QEMU under UEFI with OVMF firmware

---

## 3. Manual Build Commands

### Step 3.1: Profile Dry-Run Validation
Verify all files, packages, and scripts without starting the build:
```bash
./iso/build-iso.sh --dry-run
```

### Step 3.2: Build the ISO
```bash
sudo ./iso/build-iso.sh --clean --out-dir iso/out
```

Output artifacts generated in `iso/out/`:
- `apex-linux-<YYYY.MM.DD>-x86_64.iso`
- `apex-linux-<YYYY.MM.DD>-x86_64.iso.sha256`

---

## 4. Manual QEMU Boot Commands

To boot-test the built ISO manually in QEMU with UEFI:

```bash
# 1. Create a 30GB virtual disk
qemu-img create -f qcow2 /tmp/apex-test.qcow2 30G

# 2. Boot the ISO with UEFI OVMF
qemu-system-x86_64 \
  -enable-kvm \
  -m 4096 \
  -smp 4 \
  -cpu host \
  -bios /usr/share/edk2/x64/OVMF.4m.fd \
  -drive file=/tmp/apex-test.qcow2,if=virtio,format=qcow2 \
  -cdrom iso/out/apex-linux-*-x86_64.iso \
  -boot d \
  -net nic,model=virtio \
  -net user \
  -vga virtio \
  -display default
```

---

## 5. Live Installer Verification Checklist

Once booted into the live environment:

1. **Bootloader Menu**:
   - [ ] Confirm Cyan/Dark Slate Apex styling appears.
   - [ ] Verify entry reads "Apex Linux Live & Installation Media (x86_64, UEFI)".

2. **Console MOTD & Login**:
   - [ ] Autologin to `root` on `tty1` succeeds.
   - [ ] Branded ANSI logo and welcome text appear.
   - [ ] Hostname is `apex-live`.

3. **Guided Installer**:
   - [ ] Launch with `apex-guided-installer` or `./install.sh`.
   - [ ] Verify disk list includes `/tmp/apex-test.qcow2` (or `/dev/vda`).
   - [ ] Test option prompts: hostname, username, password, LUKS encryption.
   - [ ] Confirm uppercase `YES` verification prompt protects against accidental format.
   - [ ] Verify Btrfs subvolumes created: `@`, `@home`, `@snapshots`, `@var_log`, `@var_cache`.
   - [ ] Confirm Limine UEFI bootloader installed and configured.
   - [ ] Verify `/opt/apex-linux` deployed into the target system.
