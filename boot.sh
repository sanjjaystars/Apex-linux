#!/bin/bash
# Apex Linux bootstrap script
# Minimal, safe, and readable entry point.
# No piped sudo surprises: never blindly executes curl | sudo bash or escalates without TTY.

set -euo pipefail

APEX_REPO_DEFAULT="${APEX_GIT_URL:-https://github.com/sanjjaystars/Apex-linux.git}"
APEX_DIR_DEFAULT="${HOME:-/root}/.local/share/apex"

show_banner() {
  local script_dir
  script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  if [[ -f "$script_dir/logo.txt" ]]; then
    cat "$script_dir/logo.txt"
    echo ""
  else
    cat <<'EOF'
   /\  _  _       |   . _       
  /--\ |_) (/_ >< |___ | | | |_|
       |                        
EOF
    echo ""
  fi
}

usage() {
  cat <<'USAGE'
Usage: boot.sh [OPTIONS]

Apex Linux Bootstrap Script
A safe, minimal entrypoint to bootstrap or launch the Apex Linux installer.

Options:
  --install       Launch the Apex Guided Installer to install onto storage drive
  --dry-run       Check prerequisites and environment without making any changes
  --target DIR    Specify target directory for Apex checkout (default: ~/.local/share/apex)
  --branch NAME   Specify git branch to clone (default: main)
  -h, --help      Show this help message
USAGE
}

log_info() {
  echo -e "\033[1;34m[INFO]\033[0m $*"
}

log_warn() {
  echo -e "\033[1;33m[WARN]\033[0m $*" >&2
}

log_error() {
  echo -e "\033[1;31m[ERROR]\033[0m $*" >&2
}

log_ok() {
  echo -e "\033[1;32m[OK]\033[0m $*"
}

# 1. Enforce interactive TTY to prevent blind curl | bash surprises
check_interactive() {
  if [[ ! -t 0 ]]; then
    log_error "Standard input is not a terminal. Refusing to run in an unattended pipe."
    log_error "To run safely, download the script first:"
    log_error "  curl -fsSL https://raw.githubusercontent.com/sanjjaystars/Apex-linux/main/boot.sh -o boot.sh"
    log_error "  bash boot.sh"
    exit 1
  fi
}

# 2. Check bash version
check_bash_version() {
  if (( BASH_VERSINFO[0] < 5 )); then
    log_error "Apex requires Bash 5.0 or newer. Current version: $BASH_VERSION"
    exit 1
  fi
}

# 3. Check distribution
check_distribution() {
  if [[ ! -f /etc/arch-release ]] && [[ ! -f /etc/artix-release ]]; then
    log_warn "Apex Linux is designed specifically for Arch Linux."
    log_warn "Current system does not appear to be Arch Linux (/etc/arch-release missing)."
    echo -n "Continue anyway? (y/N): "
    read -r response </dev/tty
    if [[ $response != "y" && $response != "Y" ]]; then
      log_info "Aborting installation."
      exit 0
    fi
  else
    log_ok "Arch Linux environment verified."
  fi
}

# 4. Check user privilege safety (no blind root / sudo surprises)
check_user_privileges() {
  if (( EUID == 0 )); then
    if [[ -d /run/archiso ]]; then
      log_info "Running in Archiso live environment as root."
    else
      log_warn "Running directly as root on an installed system."
      log_warn "Apex user commands should normally be run as a regular user with sudo privileges."
      echo -n "Do you wish to continue as root? (y/N): "
      read -r response </dev/tty
      if [[ $response != "y" && $response != "Y" ]]; then
        log_info "Aborting."
        exit 0
      fi
    fi
  else
    log_ok "Running as standard user '$USER' (EUID $EUID)."
    if ! command -v sudo >/dev/null 2>&1; then
      log_error "'sudo' command is required but not installed."
      exit 1
    fi
  fi
}

# 5. Check prerequisites
check_prerequisites() {
  local missing=()
  for cmd in git curl; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
      missing+=("$cmd")
    fi
  done

  if (( ${#missing[@]} > 0 )); then
    log_error "Missing required commands: ${missing[*]}"
    log_error "Please install them via: pacman -S ${missing[*]}"
    exit 1
  fi
  log_ok "Required tools present (git, curl)."
}

main() {
  local dry_run=0
  local install_mode=0
  local target_dir="$APEX_DIR_DEFAULT"
  local branch="main"

  while (($#)); do
    case "$1" in
      --install)
        install_mode=1
        shift
        ;;
      --dry-run)
        dry_run=1
        shift
        ;;
      --target)
        target_dir="${2:-}"
        shift 2
        ;;
      --branch)
        branch="${2:-}"
        shift 2
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

  show_banner
  log_info "Starting Apex Linux bootstrap pre-flight checks..."

  check_interactive
  check_bash_version
  check_distribution
  check_user_privileges
  check_prerequisites

  if (( dry_run )); then
    log_ok "Dry-run completed successfully. All pre-flight checks passed."
    exit 0
  fi

  local current_script_dir
  current_script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

  # If running directly inside an existing Apex repository checkout
  if [[ -f "$current_script_dir/bin/apex" ]] && [[ -d "$current_script_dir/install" ]]; then
    target_dir="$current_script_dir"
    log_ok "Running from local Apex repository at $target_dir"
  else
    if [[ ! -d "$target_dir" ]]; then
      log_info "Cloning Apex Linux ($branch) into $target_dir..."
      git clone --depth 1 -b "$branch" "$APEX_REPO_DEFAULT" "$target_dir"
      log_ok "Apex Linux repository cloned successfully."
    else
      log_info "Apex directory already exists at $target_dir."
    fi
  fi

  log_ok "Apex Linux bootstrap ready."
  log_info "To manage Apex, run: $target_dir/bin/apex"

  # If running in live Archiso environment or --install was requested, offer to launch installer
  if (( install_mode )) || [[ -d /run/archiso ]]; then
    local installer_bin="$target_dir/iso/airootfs/usr/local/bin/apex-guided-installer"
    if [[ -x "$installer_bin" ]]; then
      echo ""
      echo -n "Would you like to launch the Apex Guided Installer now to install to disk? (Y/n): "
      read -r launch_choice </dev/tty || launch_choice="y"
      if [[ $launch_choice != "n" && $launch_choice != "N" ]]; then
        exec "$installer_bin"
      fi
    fi
  fi
}

main "$@"
