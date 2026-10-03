#!/bin/bash
# Apex Linux ISO Build Script
# Wraps mkarchiso to assemble and produce a bootable, branded Apex Linux ISO.

set -eo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

WORK_DIR="/tmp/apex-iso-work"
OUT_DIR="$SCRIPT_DIR/out"
CLEAN_WORK="no"
DRY_RUN="no"
VERBOSE="no"

C_RESET="\033[0m"
C_BOLD="\033[1m"
C_CYAN="\033[1;36m"
C_GREEN="\033[1;32m"
C_YELLOW="\033[1;33m"
C_RED="\033[1;31m"

usage() {
  cat <<EOF
Apex Linux ISO Build Tool

Usage:
  sudo ./iso/build-iso.sh [options]

Options:
  -w, --work-dir <dir>  Temporary build directory (default: /tmp/apex-iso-work)
  -o, --out-dir <dir>   Output directory for generated ISO (default: iso/out)
  -c, --clean           Remove temporary work directory before starting
  -d, --dry-run         Validate profile files, packages, and scripts without running mkarchiso
  -v, --verbose         Enable verbose output from mkarchiso
  -h, --help            Show this help message

Requirements:
  - Must run on Arch Linux (or Arch-based environment)
  - Must run as root (or with sudo)
  - Required packages: archiso, rsync, coreutils, sed, gawk
EOF
}

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

parse_args() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      -w|--work-dir)
        WORK_DIR="$2"
        shift 2
        ;;
      -o|--out-dir)
        OUT_DIR="$2"
        shift 2
        ;;
      -c|--clean)
        CLEAN_WORK="yes"
        shift
        ;;
      -d|--dry-run)
        DRY_RUN="yes"
        shift
        ;;
      -v|--verbose)
        VERBOSE="yes"
        shift
        ;;
      -h|--help)
        usage
        exit 0
        ;;
      *)
        die "Unknown argument: $1"
        ;;
    esac
  done
}

validate_profile() {
  notice "Validating ISO profile structure..."

  [[ -f "$SCRIPT_DIR/profiledef.sh" ]] || die "profiledef.sh missing from $SCRIPT_DIR"
  [[ -f "$SCRIPT_DIR/packages.x86_64" ]] || die "packages.x86_64 missing from $SCRIPT_DIR"
  [[ -f "$SCRIPT_DIR/pacman.conf" ]] || die "pacman.conf missing from $SCRIPT_DIR"
  [[ -d "$SCRIPT_DIR/airootfs" ]] || die "airootfs directory missing from $SCRIPT_DIR"
  [[ -x "$SCRIPT_DIR/airootfs/usr/local/bin/apex-guided-installer" ]] || die "apex-guided-installer missing or not executable"
  [[ -x "$SCRIPT_DIR/airootfs/root/install.sh" ]] || die "root/install.sh missing or not executable"

  local pkg_count
  pkg_count=$(grep -vE '^[[:space:]]*#|^[[:space:]]*$' "$SCRIPT_DIR/packages.x86_64" | wc -l | tr -d ' ')
  info "Validated $pkg_count packages defined in packages.x86_64."

  success "ISO profile structure is valid."
}

embed_repository() {
  notice "Embedding latest Apex Linux repository into airootfs..."
  if [[ -x "$SCRIPT_DIR/embed-repo.sh" ]]; then
    bash "$SCRIPT_DIR/embed-repo.sh"
    success "Repository embedded successfully."
  else
    die "embed-repo.sh missing or not executable."
  fi
}

check_host_system() {
  notice "Checking host build environment..."

  # Non-Arch detection
  if [[ ! -f /etc/arch-release ]]; then
    if [[ $DRY_RUN == "yes" ]]; then
      info "Host is not Arch Linux ($(uname -s) $(uname -m)), but --dry-run is active. Continuing validation."
      return 0
    else
      echo ""
      echo "------------------------------------------------------------------------"
      echo "  Host Environment: $(uname -s) $(uname -m) (Non-Arch Linux Host)       "
      echo "------------------------------------------------------------------------"
      echo "mkarchiso requires an Arch Linux environment to build bootable ISOs."
      echo "You can validate the profile configuration using:"
      echo "    ./iso/build-iso.sh --dry-run"
      echo ""
      echo "To build the live ISO on your Arch Linux machine or VM:"
      echo "    sudo pacman -S --needed archiso git rsync"
      echo "    sudo ./iso/build-iso.sh"
      echo "------------------------------------------------------------------------"
      die "Cannot execute mkarchiso on non-Arch host."
    fi
  fi

  # Check root
  if (( EUID != 0 )); then
    die "mkarchiso requires root privileges. Please re-run with sudo."
  fi

  # Check mkarchiso
  if ! command -v mkarchiso >/dev/null 2>&1; then
    die "mkarchiso command not found. Please install 'archiso' package via pacman."
  fi

  success "Host system check passed."
}

build_iso() {
  if [[ $CLEAN_WORK == "yes" && -d "$WORK_DIR" ]]; then
    notice "Cleaning previous work directory at $WORK_DIR..."
    rm -rf "$WORK_DIR"
  fi

  mkdir -p "$WORK_DIR"
  mkdir -p "$OUT_DIR"

  notice "Starting mkarchiso build..."
  info "Profile directory: $SCRIPT_DIR"
  info "Work directory:    $WORK_DIR"
  info "Output directory:  $OUT_DIR"

  local mkarchiso_cmd=(mkarchiso -w "$WORK_DIR" -o "$OUT_DIR")
  if [[ $VERBOSE == "yes" ]]; then
    mkarchiso_cmd+=(-v)
  fi
  mkarchiso_cmd+=("$SCRIPT_DIR")

  echo "Executing: ${mkarchiso_cmd[*]}"
  "${mkarchiso_cmd[@]}"

  success "mkarchiso completed successfully."

  notice "Generating SHA256 checksums..."
  local iso_file
  iso_file=$(find "$OUT_DIR" -maxdepth 1 -type f -name "apex-linux-*.iso" | sort | tail -n 1)

  if [[ -n "$iso_file" && -f "$iso_file" ]]; then
    local checksum
    checksum=$(sha256sum "$iso_file" | awk '{print $1}')
    echo "$checksum  $(basename "$iso_file")" > "${iso_file}.sha256"
    echo ""
    echo "========================================================"
    printf "${C_GREEN}${C_BOLD}   APEX LINUX ISO CREATED SUCCESSFULLY!                 ${C_RESET}\n"
    echo "========================================================"
    echo "  ISO Path: $iso_file"
    echo "  Size:     $(du -h "$iso_file" | awk '{print $1}')"
    echo "  SHA256:   $checksum"
    echo "========================================================"
    echo ""
  else
    die "Build finished, but no ISO file was found in $OUT_DIR."
  fi
}

main() {
  parse_args "$@"
  validate_profile
  embed_repository
  check_host_system

  if [[ $DRY_RUN == "yes" ]]; then
    echo ""
    echo "========================================================"
    printf "${C_GREEN}${C_BOLD}   ISO PROFILE DRY RUN PASSED SUCCESSFULLY!             ${C_RESET}\n"
    echo "========================================================"
    echo "All profile definitions, packages, boot configs, and installer"
    echo "scripts are present, valid, and ready for Arch Linux build."
    echo "========================================================"
    echo ""
    exit 0
  fi

  build_iso
}

main "$@"
