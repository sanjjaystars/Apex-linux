#!/bin/bash
# Apex Linux ISO Build & QEMU Smoke Test Harness
# NOTE: Marked UNTESTED on macOS host; designed to run on Arch Linux development workstations.

set -eo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

ISO_OUT_DIR="$REPO_ROOT/iso/out"
TEST_IMG="/tmp/apex-iso-smoke-disk.qcow2"
DISK_SIZE="30G"
RAM="4096"
CPUS="4"

C_RESET="\033[0m"
C_BOLD="\033[1m"
C_CYAN="\033[1;36m"
C_GREEN="\033[1;32m"
C_YELLOW="\033[1;33m"
C_RED="\033[1;31m"

notice() {
  printf "${C_YELLOW}==> %s${C_RESET}\n" "$1"
}

info() {
  printf "${C_CYAN}  -> %s${C_RESET}\n" "$1"
}

success() {
  printf "${C_GREEN}✓ %s${C_RESET}\n" "$1"
}

die() {
  printf "${C_RED}ERROR: %s${C_RESET}\n" "$1" >&2
  exit 1
}

check_prerequisites() {
  notice "Checking prerequisites for ISO testing on Arch Linux..."

  if [[ ! -f /etc/arch-release ]]; then
    echo "Host detected: $(uname -s) $(uname -m) (Not Arch Linux)."
    echo "STATUS: UNTESTED on current host."
    echo ""
    echo "To test on your Arch Linux laptop:"
    echo "  1. Install dependencies:"
    echo "     sudo pacman -S --needed archiso qemu-desktop edk2-ovmf"
    echo "  2. Run this test script:"
    echo "     sudo ./tests/iso-smoke-test.sh"
    exit 0
  fi

  command -v qemu-system-x86_64 >/dev/null 2>&1 || die "qemu-system-x86_64 is not installed. Run: sudo pacman -S qemu-desktop"
  command -v qemu-img >/dev/null 2>&1 || die "qemu-img is not installed."
  command -v mkarchiso >/dev/null 2>&1 || die "mkarchiso is not installed. Run: sudo pacman -S archiso"

  success "Prerequisites verified."
}

build_iso() {
  notice "Building Apex Linux ISO..."
  sudo "$REPO_ROOT/iso/build-iso.sh" --clean --out-dir "$ISO_OUT_DIR"
}

find_iso() {
  local iso
  iso=$(find "$ISO_OUT_DIR" -maxdepth 1 -name "apex-linux-*.iso" | sort | tail -n 1)
  if [[ -z $iso || ! -f $iso ]]; then
    die "No ISO image found in $ISO_OUT_DIR."
  fi
  echo "$iso"
}

find_ovmf() {
  local paths=(
    "/usr/share/edk2/x64/OVMF.4m.fd"
    "/usr/share/edk2-ovmf/x64/OVMF_CODE.4m.fd"
    "/usr/share/ovmf/x64/OVMF.fd"
    "/usr/share/ovmf/OVMF.fd"
  )
  for p in "${paths[@]}"; do
    if [[ -f $p ]]; then
      echo "$p"
      return 0
    fi
  done
  die "Could not find UEFI OVMF firmware. Run: sudo pacman -S edk2-ovmf"
}

run_qemu() {
  local iso_path="$1"
  local ovmf_path
  ovmf_path=$(find_ovmf)

  notice "Preparing virtual test drive of size $DISK_SIZE at $TEST_IMG..."
  rm -f "$TEST_IMG"
  qemu-img create -f qcow2 "$TEST_IMG" "$DISK_SIZE"

  notice "Launching QEMU VM with UEFI firmware..."
  info "ISO:      $iso_path"
  info "Disk:     $TEST_IMG"
  info "Firmware: $ovmf_path"
  info "RAM:      ${RAM}MB, CPUs: $CPUS"

  local accel="tcg"
  if [[ -c /dev/kvm && -w /dev/kvm ]]; then
    accel="kvm"
    info "KVM hardware virtualization enabled."
  fi

  local qemu_cmd=(
    qemu-system-x86_64
    -accel "$accel"
    -m "$RAM"
    -smp "$CPUS"
    -bios "$ovmf_path"
    -drive "file=$TEST_IMG,if=virtio,format=qcow2"
    -cdrom "$iso_path"
    -boot d
    -net nic,model=virtio
    -net user
    -vga virtio
    -display default
  )

  echo "Executing: ${qemu_cmd[*]}"
  "${qemu_cmd[@]}"

  success "QEMU VM test session exited."
}

main() {
  check_prerequisites
  build_iso
  local iso
  iso=$(find_iso)
  run_qemu "$iso"
}

main "$@"
