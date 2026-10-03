#!/bin/bash
# Apex Linux Package List Validation Test
# Ensures package lists contain valid Arch Linux package names without duplicates or collisions.

set -eo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

FAILED=0

C_RESET="\033[0m"
C_BOLD="\033[1m"
C_GREEN="\033[1;32m"
C_RED="\033[1;31m"
C_YELLOW="\033[1;33m"

echo "=== Running Apex Linux Package List Validation ==="

validate_package_file() {
  local file="$1"
  local rel_path="${file#"$REPO_ROOT"/}"

  if [[ ! -f "$file" ]]; then
    printf "${C_RED}[FAIL] File not found: %s${C_RESET}\n" "$rel_path"
    FAILED=$((FAILED + 1))
    return
  fi

  local count=0
  local duplicates=0
  local invalid=0

  # Check each non-comment, non-empty line
  while IFS= read -r pkg || [[ -n "$pkg" ]]; do
    # Trim leading/trailing whitespace
    pkg="${pkg#"${pkg%%[![:space:]]*}"}"
    pkg="${pkg%"${pkg##*[![:space:]]}"}"

    [[ -z "$pkg" || "$pkg" =~ ^# ]] && continue

    count=$((count + 1))

    # Arch package name regex
    if [[ ! "$pkg" =~ ^[a-zA-Z0-9@._+-]+$ ]]; then
      printf "${C_RED}  [ERROR] Invalid package name '%s' in %s${C_RESET}\n" "$pkg" "$rel_path"
      invalid=$((invalid + 1))
    fi
  done < "$file"

  # Check duplicates
  duplicates=$(grep -vE '^[[:space:]]*#|^[[:space:]]*$' "$file" | sort | uniq -d | wc -l | tr -d ' ')
  if (( duplicates > 0 )); then
    printf "${C_RED}  [ERROR] Found %d duplicate package(s) in %s:${C_RESET}\n" "$duplicates" "$rel_path"
    grep -vE '^[[:space:]]*#|^[[:space:]]*$' "$file" | sort | uniq -d | sed 's/^/    - /'
    FAILED=$((FAILED + 1))
  fi

  if (( invalid > 0 )); then
    FAILED=$((FAILED + 1))
  fi

  if (( duplicates == 0 && invalid == 0 )); then
    printf "${C_GREEN}[PASS] %-42s (%3d packages)${C_RESET}\n" "$rel_path" "$count"
  fi
}

# Check collision between official and AUR lists
check_collision() {
  local off_file="$1"
  local aur_file="$2"

  local off_rel="${off_file#"$REPO_ROOT"/}"
  local aur_rel="${aur_file#"$REPO_ROOT"/}"

  if [[ -f "$off_file" && -f "$aur_file" ]]; then
    local overlap
    overlap=$(comm -12 <(grep -vE '^[[:space:]]*#|^[[:space:]]*$' "$off_file" | sort) \
                      <(grep -vE '^[[:space:]]*#|^[[:space:]]*$' "$aur_file" | sort))

    if [[ -n "$overlap" ]]; then
      printf "${C_RED}[FAIL] Package collision between %s and %s:${C_RESET}\n" "$off_rel" "$aur_rel"
      echo "$overlap" | sed 's/^/  - /'
      FAILED=$((FAILED + 1))
    else
      printf "${C_GREEN}[PASS] Zero collision between %s and %s${C_RESET}\n" "$off_rel" "$aur_rel"
    fi
  fi
}

validate_package_file "$REPO_ROOT/install/apex-base-official.packages"
validate_package_file "$REPO_ROOT/install/apex-base-aur.packages"
validate_package_file "$REPO_ROOT/install/apex-other-official.packages"
validate_package_file "$REPO_ROOT/install/apex-other-aur.packages"
validate_package_file "$REPO_ROOT/iso/packages.x86_64"

check_collision "$REPO_ROOT/install/apex-base-official.packages" "$REPO_ROOT/install/apex-base-aur.packages"
check_collision "$REPO_ROOT/install/apex-other-official.packages" "$REPO_ROOT/install/apex-other-aur.packages"

echo ""
if (( FAILED == 0 )); then
  printf "${C_GREEN}${C_BOLD}✓ All package lists verified successfully.${C_RESET}\n"
  exit 0
else
  printf "${C_RED}${C_BOLD}✗ Package list validation failed with %d error(s).${C_RESET}\n" "$FAILED"
  exit 1
fi
