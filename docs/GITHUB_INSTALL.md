# Installing Apex Linux Directly From GitHub

This guide explains how to build, download, and install **Apex Linux** directly from your GitHub repository:  
**https://github.com/sanjjaystars/Apex-linux**

---

## Method 1: Download Pre-built ISO from GitHub Releases (Recommended)

Thanks to the automated GitHub Actions CI pipeline (`.github/workflows/build-iso.yml`):

1. **Triggering or Downloading the Build**:
   - Go to your repository's **Actions** tab:  
     `https://github.com/sanjjaystars/Apex-linux/actions`
   - Select **Build and Release Apex Linux ISO** -> Click **Run workflow**.
   - Or push a version tag (e.g., `git tag v1.0.0 && git push origin v1.0.0`).
2. **Download the ISO**:
   - Download `apex-linux-*.iso` and its `.sha256` checksum directly from:  
     `https://github.com/sanjjaystars/Apex-linux/releases`  
     *(or download from the Action Run Artifacts)*
3. **Flash to USB**:
   ```bash
   # Linux / macOS
   sudo dd if=apex-linux-x86_64.iso of=/dev/sdX bs=4M status=progress oflag=sync
   ```
   *(Or copy directly onto a Ventoy multiboot USB drive)*
4. **Boot & Install**:
   Boot your machine from the USB drive. On `tty1`, simply run:
   ```bash
   apex-guided-installer
   ```
   or:
   ```bash
   ./install.sh
   ```

---

## Method 2: Direct Network Install from Any Arch Linux Live Media

You don't even need to flash a custom Apex ISO! You can boot **any standard official Arch Linux live USB** (from archlinux.org) and install Apex Linux directly from GitHub over the internet:

### Step 1: Boot Standard Arch Linux Live USB
Boot into the official Arch Linux live environment (with active internet).

### Step 2: Connect to the Network (if on Wi-Fi)
```bash
iwctl
station wlan0 scan
station wlan0 connect "YourNetworkSSID"
exit
```

### Step 3: Run the Apex GitHub Installer in One Command
```bash
bash <(curl -fsSL https://raw.githubusercontent.com/sanjjaystars/Apex-linux/main/boot.sh) --install
```

Or via Git clone:
```bash
git clone --depth 1 https://github.com/sanjjaystars/Apex-linux.git
cd Apex-linux
./boot.sh --install
```

### What Happens Automatically:
1. `boot.sh` clones or updates the latest framework from `https://github.com/sanjjaystars/Apex-linux.git`.
2. It launches the interactive **Apex Guided Installer**.
3. You select your drive, configure username, password, hostname, and optional LUKS2 encryption.
4. It sets up Btrfs subvolumes (`@`, `@home`, `@snapshots`, `@var_log`, `@var_cache`), Snapper, and the Limine bootloader.
5. It deploys the entire Apex Linux system directly from your GitHub repository onto your drive.
6. Once finished, type `reboot` and unplug the USB drive!

---

## Method 3: Build the ISO Locally on an Arch Linux Laptop

If you want to compile the ISO locally from your repository clone:

```bash
git clone https://github.com/sanjjaystars/Apex-linux.git
cd Apex-linux
sudo pacman -S --needed archiso git rsync
sudo ./iso/build-iso.sh --clean --out-dir iso/out
```

The bootable ISO will be generated in `iso/out/apex-linux-<date>-x86_64.iso`.
