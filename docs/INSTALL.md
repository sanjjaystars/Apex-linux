# Apex Linux Installation Guide

This guide details the procedure for installing **Apex Linux** on bare-metal hardware and virtual machines.

Apex Linux can be installed using two supported methods:
1. **Live ISO & Guided Installer** (Recommended for new systems, full disk partitioning, and LUKS encryption).
2. **Bootstrap on Existing Arch Linux** (For running installations on an existing Arch system).

---

## 1. System Requirements

| Component | Minimum | Recommended |
|---|---|---|
| **Architecture** | 64-bit x86_64 | 64-bit x86_64 (Intel or AMD) |
| **Firmware** | UEFI (64-bit) | Modern UEFI with Secure Boot disabled |
| **Memory (RAM)** | 2 GB | 8 GB or more |
| **Storage** | 20 GB free space | 64 GB+ NVMe/SSD |
| **Network** | Active internet connection | Broadband Ethernet or Wi-Fi |

> [!IMPORTANT]
> Apex Linux requires UEFI boot mode. Legacy BIOS/MBR is not supported for guided installations.

---

## 2. Method A: Live ISO & Guided Installer

### Step 2.1: Prepare Installation Media
1. Download the latest `apex-linux-<version>-x86_64.iso` and its `.sha256` checksum.
2. Verify the checksum:
   ```bash
   sha256sum -c apex-linux-*.iso.sha256
   ```
3. Flash the ISO image to a USB flash drive (replace `/dev/sdX` with your target drive):
   ```bash
   sudo dd if=apex-linux-x86_64.iso of=/dev/sdX bs=4M status=progress oflag=sync
   ```

### Step 2.2: Boot the Live Media
1. Insert the USB flash drive and reboot your machine.
2. Enter your motherboard's UEFI boot menu (usually `F12`, `F11`, `F8`, or `Del`).
3. Select **Apex Linux Live & Installation Media (x86_64, UEFI)**.
4. The system will automatically log into the root terminal on `tty1`.

### Step 2.3: Connect to the Network (if using Wi-Fi)
If connected via wired Ethernet, networking is active automatically. For Wi-Fi:
```bash
iwctl
# Inside iwctl:
station wlan0 scan
station wlan0 get-networks
station wlan0 connect "YourNetworkSSID"
exit
```
Verify connectivity:
```bash
ping -c 3 archlinux.org
```

### Step 2.4: Launch the Guided Installer
Run the guided installer:
```bash
apex-guided-installer
```
*(or run `./install.sh`)*

The installer will guide you through:
- **Disk Selection**: Choose the target NVMe, SSD, or virtual drive.
- **System Identity**: Set system hostname and create primary user credentials.
- **Disk Encryption**: Optionally enable LUKS2 full-disk encryption with Argon2id.
- **Automated Partitioning**: Sets up 1024MB ESP (`fat32`) and Btrfs root with subvolumes:
  - `@` (Root system)
  - `@home` (User personal files)
  - `@snapshots` (Snapper system rollback snapshots)
  - `@var_log` (System journals and logs)
  - `@var_cache` (Pacman package cache)
- **Base Deployment**: Installs Linux kernel, firmware, base development tools, and Limine bootloader.
- **Apex Framework**: Deploys the complete Apex configuration into `/opt/apex-linux`.

### Step 2.5: Reboot
When the installer confirms success:
```bash
reboot
```
Remove the USB installation media when prompted.

---

## 3. Method B: Bootstrap on Existing Arch Linux

If you already have a running Arch Linux installation:

1. Clone or download the Apex Linux repository:
   ```bash
   git clone https://github.com/sanjjaystars/Apex-linux.git ~/.local/share/apex
   cd ~/.local/share/apex
   ```
2. Run pre-flight checks:
   ```bash
   ./bin/apex-install-preflight
   ```
3. Execute the bootstrap script:
   ```bash
   ./boot.sh
   ```
4. Follow the interactive setup prompts to finalize your theme, keyboard bindings, and applications.

---

## 4. Post-Installation Setup & Maintenance

### 4.1 First Boot & User Finalization
On initial login, Apex initializes the Quickshell desktop, audio subsystems, and themes.

### 4.2 System Updates
Keep your Apex Linux installation up to date using the automated updater:
```bash
apex update
```
This automatically takes a Btrfs pre-update snapshot via Snapper, refreshes pacman packages, runs database migrations, updates AUR tools, and verifies system integrity.

### 4.3 Hardware Tuning (ASUS ROG & Laptops)
Apex includes built-in hardware detection:
```bash
apex hw asus-rog
```
To inspect keyboard brightness, battery charge limits, and power profiles, use the hardware menu:
`Super + Ctrl + H`.
