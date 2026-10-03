# Apex installer pre-flight check helper library

check_is_arch() {
  if [[ -f /etc/arch-release ]] || [[ -f /etc/artix-release ]]; then
    return 0
  fi
  if [[ -f /etc/os-release ]]; then
    if grep -qE '^ID=.*(arch|endeavouros|manjaro|garuda)' /etc/os-release; then
      return 0
    fi
  fi
  return 1
}

check_not_root() {
  (( EUID != 0 ))
}

check_internet() {
  if curl -sSf --connect-timeout 3 --max-time 5 https://archlinux.org >/dev/null 2>&1 || \
     curl -sSf --connect-timeout 3 --max-time 5 https://1.1.1.1 >/dev/null 2>&1 || \
     ping -c 1 -W 3 1.1.1.1 >/dev/null 2>&1; then
    return 0
  fi
  return 1
}

check_free_disk() {
  local target="${1:-/}"
  local min_gb="${2:-20}"
  local avail_kb
  avail_kb=$(df -k "$target" 2>/dev/null | awk 'NR==2 {print $4}')
  if [[ -n "$avail_kb" ]]; then
    local avail_gb=$((avail_kb / 1024 / 1024))
    if (( avail_gb >= min_gb )); then
      return 0
    fi
  fi
  return 1
}

check_uefi() {
  [[ -d /sys/firmware/efi ]]
}

run_all_preflight_checks() {
  local target_disk="${1:-/}"
  local min_disk_gb="${2:-20}"
  local failures=0

  echo "=== Running Apex Pre-Flight Checks ==="

  # 1. Check Arch
  if check_is_arch; then
    echo "  [PASS] Operating System: Arch Linux detected"
  else
    echo "  [FAIL] Operating System: Arch Linux not detected (/etc/arch-release missing)"
    (( failures++ ))
  fi

  # 2. Check not root
  if check_not_root; then
    echo "  [PASS] User Privileges: Running as standard user '$USER' (EUID $EUID)"
  else
    echo "  [FAIL] User Privileges: Running as root. Apex user setup must run as standard user."
    (( failures++ ))
  fi

  # 3. Check internet
  if check_internet; then
    echo "  [PASS] Network: Active internet connection detected"
  else
    echo "  [FAIL] Network: No active internet connection detected"
    (( failures++ ))
  fi

  # 4. Check free disk
  if check_free_disk "$target_disk" "$min_disk_gb"; then
    local avail_kb avail_gb
    avail_kb=$(df -k "$target_disk" 2>/dev/null | awk 'NR==2 {print $4}')
    avail_gb=$((avail_kb / 1024 / 1024))
    echo "  [PASS] Disk Space: ${avail_gb} GB free on $target_disk (minimum: ${min_disk_gb} GB)"
  else
    echo "  [FAIL] Disk Space: Less than ${min_disk_gb} GB free on $target_disk"
    (( failures++ ))
  fi

  # 5. Check UEFI
  if check_uefi; then
    echo "  [PASS] Firmware: UEFI mode detected (/sys/firmware/efi present)"
  else
    echo "  [FAIL] Firmware: UEFI mode not detected (/sys/firmware/efi missing)"
    (( failures++ ))
  fi

  echo "======================================"
  if (( failures == 0 )); then
    echo "All pre-flight checks passed successfully."
    return 0
  else
    echo "Pre-flight checks completed with $failures failure(s)."
    return 1
  fi
}
