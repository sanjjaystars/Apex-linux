# docs/PACKAGES_UPSTREAM.md — Upstream Omarchy Package Lists

**Source:** `reference/omarchy/install/omarchy-base.packages` (159 packages),
`reference/omarchy/install/omarchy-other.packages` (57 packages).
**Counts via:** `grep -vcE '^\s*(#|$)'`
**Date:** 2026-10-03

Packages marked **[AUR]** are not in the official Arch repositories and are
custom or AUR packages — these require special attention during rebranding.
Packages marked **[Omarchy-pkg]** are owned/maintained by upstream Omarchy
(custom packages, possibly in a private or custom pacman repo).

---

## omarchy-base.packages — 159 packages (pacstrapped by ISO)

These are the packages installed into the target system during the ISO install
phase via `pacstrap`.

| Package | Classification | Notes |
|---|---|---|
| `aether` | [AUR] | Omarchy proprietary app — TODO(verify) replace or vendor |
| `alsa-utils` | official | ALSA sound utilities |
| `asdcontrol` | [AUR] | Apple Studio Display brightness control |
| `avahi` | official | mDNS/DNS-SD daemon |
| `base-devel` | official | Arch base development tools group |
| `bash-completion` | official | Bash tab completion |
| `bat` | official | `cat` with syntax highlighting |
| `bluez` | official | Bluetooth protocol stack |
| `bluez-tools` | official | Bluetooth command-line tools |
| `bluez-utils` | official | Bluetooth utilities (`bluetoothctl`) |
| `bolt` | official | Thunderbolt device manager |
| `brightnessctl` | official | Display/keyboard brightness control |
| `btop` | official | Resource monitor TUI |
| `chromium` | official | Chromium web browser |
| `clang` | official | Clang C/C++ compiler |
| `cliamp` | [AUR] | TODO(verify) — CLI audio player? |
| `cups` | official | Printing system |
| `cups-filters` | official | CUPS filters |
| `cups-pk-helper` | official | PolicyKit helper for CUPS |
| `ddcutil` | official | DDC/CI monitor control |
| `docker` | official | Docker container runtime |
| `docker-buildx` | official | Docker Buildx plugin |
| `docker-compose` | official | Docker Compose |
| `dosfstools` | official | FAT filesystem tools |
| `dotnet-runtime` | official | .NET runtime |
| `dua-cli` | official | Disk usage analyzer |
| `evince` | official | PDF viewer |
| `exfatprogs` | official | exFAT filesystem tools |
| `expac` | official | pacman data extraction utility |
| `eza` | official | Modern `ls` replacement |
| `fakeroot` | official | Fake root environment for package building |
| `fastfetch` | official | System info tool |
| `fcitx5` | official | Input method framework |
| `fcitx5-gtk` | official | Fcitx5 GTK IM module |
| `fcitx5-qt` | official | Fcitx5 Qt IM module |
| `fd` | official | Fast `find` alternative |
| `ffmpeg` | official | Multimedia processing |
| `ffmpegthumbnailer` | official | Video thumbnail generator |
| `fontconfig` | official | Font configuration library |
| `foot` | official | Wayland terminal emulator |
| `fzf` | official | Fuzzy finder |
| `git` | official | Git version control |
| `gnome-keyring` | official | GNOME keyring daemon |
| `gnome-themes-extra` | official | Adwaita and other GNOME themes |
| `grim` | official | Wayland screenshot tool |
| `gpu-screen-recorder` | [AUR] | GPU-accelerated screen recorder |
| `gum` | official | Glamorous TUI scripting tool |
| `gvfs-mtp` | official | GVFS MTP (phone) backend |
| `gvfs-nfs` | official | GVFS NFS backend |
| `gvfs-smb` | official | GVFS Samba backend |
| `herdr` | [Omarchy-pkg] | Multi-machine SSH orchestration tool (Omarchy-owned) |
| `hype` | [Omarchy-pkg] | TODO(verify) — Omarchy-owned package |
| `hyprland` | official | Hyprland Wayland compositor |
| `hyprland-guiutils` | [AUR] | Hyprland GUI utilities |
| `hyprland-preview-share-picker` | [AUR] | Hyprland screen-share picker |
| `hyprpicker` | official | Hyprland color picker |
| `hyprsunset` | official | Hyprland blue light filter |
| `imagemagick` | official | Image manipulation suite |
| `imv` | official | Wayland image viewer |
| `inetutils` | official | Network utilities |
| `inotify-tools` | official | inotify file system event watcher |
| `inxi` | official | System information tool |
| `networkmanager` | official | Network connection manager |
| `jq` | official | JSON processor |
| `kdenlive` | official | Video editor |
| `kernel-modules-hook` | official | Hook to reload modules on kernel update |
| `lazydocker` | [AUR] | Docker TUI |
| `lazygit` | official | Git TUI |
| `less` | official | Pager |
| `libsecret` | official | Secret storage library |
| `libvips` | official | Image processing library |
| `libyaml` | official | YAML parser |
| `libreoffice-fresh` | official | LibreOffice suite |
| `llvm` | official | LLVM compiler infrastructure |
| `localsend` | [AUR] | Local network file sharing |
| `lua51` | official | Lua 5.1 runtime |
| `luarocks` | official | Lua package manager |
| `man-db` | official | Man page system |
| `mariadb-libs` | official | MariaDB client libraries |
| `mise-bin` | [AUR] | mise dev tool version manager (binary package) |
| `monologue` | [Omarchy-pkg] | TODO(verify) — Omarchy-owned package |
| `moonlight-qt` | [AUR] | NVIDIA GameStream client |
| `mpv` | official | Media player |
| `mpv-mpris` | [AUR] | MPRIS plugin for mpv |
| `nautilus` | official | GNOME Files file manager |
| `nautilus-python` | official | Python bindings for Nautilus |
| `gnome-disk-utility` | official | GNOME disk utility |
| `noto-fonts` | official | Noto font family |
| `noto-fonts-cjk` | official | Noto CJK fonts |
| `noto-fonts-emoji` | official | Noto emoji font |
| `nss-mdns` | official | mDNS NSS plugin |
| `nvim` | official | Neovim editor |
| `obs-studio` | official | Streaming/recording software |
| `obsidian` | [AUR] | Obsidian note-taking app |
| `omacalc` | [Omarchy-pkg] | Omarchy calculator app |
| `omacut` | [Omarchy-pkg] | Omarchy screen cut/share tool |
| `omawrite` | [Omarchy-pkg] | Omarchy writing app |
| `omarchy-nvim` | [Omarchy-pkg] | Omarchy Neovim config package |
| `omasnap` | [Omarchy-pkg] | Omarchy snapshot manager app |
| `owe` | [Omarchy-pkg] | Desktop video backgrounds |
| `owe-lockfeed` | [Omarchy-pkg] | Lock screen frame feeder |
| `pacman-contrib` | official | pacman contrib scripts (`paccache`, `pacdiff`, etc.) |
| `pamixer` | official | PulseAudio/PipeWire volume mixer CLI |
| `pinta` | official | Simple image editor |
| `plocate` | official | Fast `locate` implementation |
| `plymouth` | official | Boot splash screen |
| `postgresql-libs` | official | PostgreSQL client libraries |
| `power-profiles-daemon` | official | Power profile manager |
| `python-gobject` | official | Python GObject bindings |
| `python-poetry-core` | official | Poetry build system core |
| `qt6-base` | official | Qt 6 base libraries |
| `qt6-declarative` | official | Qt 6 QML/Quick |
| `qt6-multimedia` | official | Qt 6 multimedia |
| `qt6-svg` | official | Qt 6 SVG support |
| `qt6-wayland` | official | Qt 6 Wayland integration |
| `ttfx` | [Omarchy-pkg] | TODO(verify) — Omarchy font package |
| `qemu-user-static-binfmt` | official | QEMU static binfmt registration |
| `qrencode` | official | QR code generator |
| `qt6-imageformats` | official | Qt 6 extra image formats |
| `quickshell` | [AUR] | Qt-based Wayland shell UI toolkit |
| `ripgrep` | official | Fast grep alternative |
| `ruby` | official | Ruby runtime |
| `sddm` | official | Simple Desktop Display Manager |
| `slurp` | official | Wayland region selection |
| `socat` | official | Socket relay tool |
| `starship` | official | Cross-shell prompt |
| `sushi` | official | GNOME Sushi file previewer |
| `system-config-printer` | official | Printer configuration GUI |
| `tesseract` | official | OCR engine |
| `tesseract-data-eng` | official | Tesseract English language data |
| `tldr` | official | Simplified man pages |
| `tree-sitter-cli` | official | Tree-sitter parser generator CLI |
| `tmux` | official | Terminal multiplexer |
| `tobi-try` | [Omarchy-pkg] | TODO(verify) — Omarchy-owned package |
| `ttf-ia-writer` | [AUR] | iA Writer fonts |
| `ttf-jetbrains-mono-nerd-basic` | [AUR] | JetBrains Mono Nerd Font (basic) |
| `tzupdate` | [AUR] | Automatic timezone updater |
| `udiskie` | official | Automount daemon |
| `ufw` | official | Uncomplicated Firewall |
| `ufw-docker` | [AUR] | UFW rules for Docker |
| `unzip` | official | ZIP extraction |
| `usage` | [Omarchy-pkg] | TODO(verify) — Omarchy-owned package |
| `uwsm` | official | Universal Wayland Session Manager |
| `vi` | official | Vi editor |
| `whois` | official | WHOIS lookup |
| `wireless-regdb` | official | Wireless regulatory database |
| `wireplumber` | official | WirePlumber PipeWire session manager |
| `wl-clipboard` | official | Wayland clipboard utilities |
| `wtype` | official | Wayland keyboard input tool |
| `woff2-font-awesome` | [AUR] | Font Awesome WOFF2 |
| `xdg-desktop-portal-gtk` | official | XDG portal backend (GTK) |
| `xdg-desktop-portal-hyprland` | official | XDG portal backend (Hyprland) |
| `xdg-terminal-exec` | [AUR] | XDG terminal executor |
| `xournalpp` | official | PDF annotation tool |
| `yaru-icon-theme` | official | Yaru icon theme |
| `yay` | [AUR] | AUR helper |
| `yt-dlp` | official | Video downloader |
| `zbar` | official | Barcode/QR scanner library |
| `zoxide` | official | Smart `cd` replacement |

---

## omarchy-other.packages — 57 packages (hardware/optional/ISO-builder extras)

These are packages listed for the ISO builder to ensure offline availability,
or hardware-conditional packages installed by `install/hardware/` scripts.

| Package | Classification | Notes |
|---|---|---|
| `autoconf-archive` | official | GNU Autoconf macro archive |
| `asusctl` | [AUR] | ASUS ROG hardware control daemon |
| `base` | official | Arch Linux base meta-package |
| `base-devel` | official | Development tools group |
| `broadcom-wl-dkms` | [AUR] | Broadcom wireless driver (BCM4360/BCM4331) |
| `btrfs-progs` | official | Btrfs filesystem tools |
| `dkms` | official | Dynamic Kernel Module Support |
| `egl-wayland` | official | EGL Wayland integration |
| `gst-plugin-pipewire` | official | PipeWire GStreamer plugin |
| `gtk4-layer-shell` | [AUR] | GTK4 layer shell library |
| `libpulse` | official | PulseAudio client library |
| `intel-ipu7-camera` | [AUR] | Intel IPU7 MIPI camera support |
| `intel-lpmd` | [AUR] | Intel Low Power Mode Daemon |
| `intel-media-driver` | official | Intel hardware video acceleration |
| `libva-intel-driver` | official | Legacy Intel VA-API driver |
| `libva-nvidia-driver` | [AUR] | NVIDIA VA-API driver |
| `limine` | official | Limine UEFI/BIOS bootloader |
| `limine-mkinitcpio-hook` | [AUR] | Limine mkinitcpio rebuild hook |
| `limine-snapper-sync` | [AUR] | Syncs Limine entries with Snapper snapshots |
| `linux-firmware` | official | Linux firmware files |
| `linux-omarchy` | [Omarchy-pkg] | Omarchy custom kernel |
| `linux-omarchy-headers` | [Omarchy-pkg] | Omarchy custom kernel headers |
| `macbook12-spi-driver-dkms` | [AUR] | MacBook SPI keyboard driver |
| `nvidia-580xx-dkms` | [AUR] | NVIDIA 580xx series open kernel module |
| `nvidia-dkms` | official | NVIDIA open DKMS kernel module |
| `nvidia-open-dkms` | official | NVIDIA open-source DKMS module |
| `nvidia-580xx-utils` | [AUR] | NVIDIA 580xx utilities |
| `nvidia-utils` | official | NVIDIA driver utilities |
| `lib32-nvidia-580xx-utils` | [AUR] | 32-bit NVIDIA 580xx utils |
| `lib32-nvidia-utils` | official | 32-bit NVIDIA utilities |
| `pipewire` | official | PipeWire audio/video server |
| `pipewire-alsa` | official | PipeWire ALSA backend |
| `pipewire-jack` | official | PipeWire JACK backend |
| `pipewire-pulse` | official | PipeWire PulseAudio replacement |
| `qt6-wayland` | official | Qt 6 Wayland integration (also in base) |
| `snapper` | official | Btrfs snapshot manager |
| `sof-firmware` | official | Sound Open Firmware (Intel audio DSPs) |
| `thermald` | official | Intel thermal daemon |
| `webp-pixbuf-loader` | official | WebP image loader |
| `yay-debug` | [AUR] | yay debug symbols package |
| `tuxedo-drivers-nocompatcheck-dkms` | [AUR] | Tuxedo keyboard backlight driver |
| `zram-generator` | official | zram swap setup |
| `libvpl` | official | Intel Video Processing Library |
| `vpl-gpu-rt` | [AUR] | Intel VPL GPU runtime |
| `vulkan-intel` | official | Intel Vulkan ICD |
| `vulkan-radeon` | official | AMD Vulkan ICD (RADV) |
| `vulkan-asahi` | [AUR] | Apple Silicon Vulkan ICD (Asahi) |
| `linux-firmware-marvell` | official | Marvell firmware (Surface Wi-Fi) |
| `dell-xps-touchpad-haptics` | [AUR] | Dell XPS haptic touchpad driver |
| `dell-xps13-sidecar-amps` | [AUR] | Dell XPS 13 2026 sidecar amplifier support |
| `lsp-plugins-lv2` | official | LSP LV2 plugins (speaker tuning dependency) |
| `apple-bcm-firmware` | [AUR] | Apple Broadcom Wi-Fi firmware (T2 Macs) |
| `apple-t2-audio-config` | [AUR] | Apple T2 audio codec config |
| `linux-t2` | [AUR] | T2 Mac kernel |
| `linux-t2-headers` | [AUR] | T2 Mac kernel headers |
| `t2fanrd` | [AUR] | T2 Mac fan control daemon |
| `qmk-hid` | [AUR] | Framework 16 RGB keyboard control |

---

## Summary

| Category | Count |
|---|---|
| `omarchy-base.packages` total | 159 |
| `omarchy-other.packages` total | 57 |
| **Grand total** | **216** |
| Omarchy-owned packages (`[Omarchy-pkg]`) | ~11 (aether, herdr, hype, monologue, omacalc, omacut, omawrite, omarchy-nvim, omasnap, owe, owe-lockfeed, tobi-try, ttfx, usage, linux-omarchy, linux-omarchy-headers) |
| AUR packages | ~40+ (see table) |

> **Note:** Omarchy-pkg packages (`linux-omarchy`, `omacalc`, `herdr`, etc.) are
> distributed through Omarchy's own pacman repository (see `default/pacman/pacman-stable.conf`).
> These must be replaced, re-packaged, or removed for Apex Linux. See
> `docs/UPSTREAM_DEPS.md` for the disposition plan.
