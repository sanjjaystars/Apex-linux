#!/bin/bash
# Apex Linux VM Smoke Test Runner & Documentation
# Tests fresh Arch / Apex ISO boot, services, and installation in a virtual machine.
# Marked UNTESTED on macOS host (requires QEMU and Arch Linux environment).

set -euo pipefail

usage() {
  cat <<'USAGE'
Usage: tests/vm-smoke-test.sh [OPTIONS]

Apex Linux VM Smoke Test Runner

Options:
  --iso PATH      Path to the built Apex ISO image (required for VM boot)
  --disk PATH     Path to test virtual disk image (default: /tmp/apex-test-disk.qcow2)
  --size SIZE     Disk size if creating a new test image (default: 32G)
  --ram RAM       VM memory in MB (default: 4096)
  --cpus CPUS     VM CPU cores (default: 4)
  --manual        Display the manual testing procedure and exit
  -h, --help      Show this help message

Manual Testing Procedure (on Arch Linux host):
  1. Build the ISO:
       sudo ./iso/build-iso.sh
  2. Launch VM with QEMU:
       qemu-system-x86_64 -enable-kvm -m 4096 -smp 4 \
         -bios /usr/share/ovmf/x64/OVMF.fd \
         -cdrom out/apex-linux-*.iso \
         -boot d -drive file=test-apex.qcow2,format=qcow2,if=virtio \
         -net nic,model=virtio -net user
  3. Verify Live Boot:
       - System boots to graphical desktop or login prompt
       - SDDM service active: systemctl is-active sddm
       - Audio active: systemctl --user is-active pipewire
       - Network active: nmcli general status
  4. Perform Installation:
       - Run installer / setup form
       - Check /var/log/apex-install.log for zero errors
  5. Post-Install Boot:
       - Remove CD-ROM and boot from virtual disk
       - Verify autologin / user login
       - Verify Hyprland session and top bar
USAGE
}

check_qemu() {
  if command -v qemu-system-x86_64 >/dev/null 2>&1; then
    echo "qemu-system-x86_64"
  elif command -v qemu-system-aarch64 >/dev/null 2>&1; then
    echo "qemu-system-aarch64"
  else
    return 1
  fi
}

main() {
  local iso_path=""
  local disk_path="/tmp/apex-test-disk.qcow2"
  local disk_size="32G"
  local ram="4096"
  local cpus="4"
  local manual_only=0

  while (($#)); do
    case "$1" in
      --iso)
        iso_path="${2:-}"
        shift 2
        ;;
      --disk)
        disk_path="${2:-}"
        shift 2
        ;;
      --size)
        disk_size="${2:-}"
        shift 2
        ;;
      --ram)
        ram="${2:-}"
        shift 2
        ;;
      --cpus)
        cpus="${2:-}"
        shift 2
        ;;
      --manual)
        manual_only=1
        shift
        ;;
      -h|--help)
        usage
        exit 0
        ;;
      *)
        echo "Unknown option: $1" >&2
        usage >&2
        exit 1
        ;;
    esac
  done

  if (( manual_only )); then
    usage
    exit 0
  fi

  local qemu_bin
  if ! qemu_bin=$(check_qemu); then
    echo "======================================================"
    echo "QEMU is not installed on this host ($(uname -s) $(uname -m))."
    echo "This test is marked UNTESTED on macOS host."
    echo "======================================================"
    echo ""
    echo "Please execute the smoke test on an Arch Linux workstation with QEMU:"
    usage
    exit 0
  fi

  if [[ -z "$iso_path" ]]; then
    echo "Error: --iso PATH is required to launch VM." >&2
    echo "Run with --help or --manual for the procedure." >&2
    exit 1
  fi

  if [[ ! -f "$iso_path" ]]; then
    echo "Error: ISO file '$iso_path' does not exist." >&2
    exit 1
  fi

  # Create test virtual disk if needed
  if [[ ! -f "$disk_path" ]]; then
    echo "Creating virtual disk: $disk_path ($disk_size)..."
    qemu-img create -f qcow2 "$disk_path" "$disk_size"
  fi

  local accel=()
  if [[ $(uname -s) == "Linux" ]] && [[ -e /dev/kvm ]]; then
    accel=(-enable-kvm)
  elif [[ $(uname -s) == "Darwin" ]]; then
    accel=(-accel hvf)
  fi

  echo "Launching QEMU VM with Apex ISO..."
  "$qemu_bin" \
    "${accel[@]}" \
    -m "$ram" \
    -smp "$cpus" \
    -cdrom "$iso_path" \
    -drive "file=$disk_path,format=qcow2,if=virtio" \
    -net nic,model=virtio -net user \
    -vga virtio
}

main "$@"
