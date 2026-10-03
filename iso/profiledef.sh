#!/bin/bash
# Profile definition for Apex Linux ISO

iso_name="apex-linux"
iso_label="APEX_LINUX"
iso_publisher="Apex Linux <https://github.com/sanjjaystars/Apex-linux>"
iso_application="Apex Linux Live and Guided Installation Media"
iso_version="$(date +%Y.%m.%d)"
install_dir="apex"
build_modes=('iso')
bootmodes=('bios.syslinux' 'uefi.systemd-boot')
arch="x86_64"
pacman_conf="pacman.conf"
airootfs_image_type="squashfs"
airootfs_image_tool_options=('-comp' 'zstd')
file_permissions=(
  ["/etc/sudoers.d/00-live"]="0:0:440"
  ["/root"]="0:0:750"
  ["/root/install.sh"]="0:0:755"
  ["/usr/local/bin/apex-guided-installer"]="0:0:755"
)
