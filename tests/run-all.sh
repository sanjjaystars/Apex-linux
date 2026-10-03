#!/bin/bash
# Apex Linux Master Quality Gate Test Runner
# Orchestrates all unit, regression, style, and integration tests across the repository.

set -eo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

TOTAL_SUITES=0
PASSED_SUITES=0
FAILED_SUITES=0

C_RESET="\033[0m"
C_BOLD="\033[1m"
C_GREEN="\033[1;32m"
C_RED="\033[1;31m"
C_CYAN="\033[1;36m"
C_YELLOW="\033[1;33m"

echo "========================================================"
echo "          APEX LINUX MASTER TEST RUNNER                 "
echo "========================================================"
echo "Root: $REPO_ROOT"
echo "Host: $(uname -s) $(uname -m)"
echo ""

run_suite() {
  local name="$1"
  local cmd="$2"

  TOTAL_SUITES=$((TOTAL_SUITES + 1))
  printf "${C_CYAN}==> [Suite %d/%d] Running %s...${C_RESET}\n" "$TOTAL_SUITES" "5" "$name"

  if eval "$cmd"; then
    printf "${C_GREEN}✓ [PASS] %s${C_RESET}\n\n" "$name"
    PASSED_SUITES=$((PASSED_SUITES + 1))
  else
    printf "${C_RED}✗ [FAIL] %s${C_RESET}\n\n" "$name"
    FAILED_SUITES=$((FAILED_SUITES + 1))
  fi
}

# Suite 1: Name Leak Detection
run_suite "Name Leak Detection" \
  "$REPO_ROOT/tests/check-name-leaks.sh"

# Suite 2: Package List Validation
run_suite "Package Lists & Collision Verification" \
  "$REPO_ROOT/tests/check-packages.sh"

# Suite 3: Themes & Wallpapers Validation
run_suite "Theme Palettes & Wallpapers Validation" \
  "$REPO_ROOT/tests/check-themes.sh"

# Suite 4: Shellcheck Linting & Python Compilation
run_suite "Shellcheck Linting & Python Compilation" \
  "$REPO_ROOT/tests/check-scripts.sh"

# Suite 5: ISO Profile & Guided Installer Dry Run
run_suite "ISO Build Profile & Guided Installer Dry Run" \
  "$REPO_ROOT/iso/build-iso.sh --dry-run"

echo "========================================================"
printf "${C_BOLD}                   TEST RUN SUMMARY                     ${C_RESET}\n"
echo "========================================================"
printf "  Total Suites:  %d\n" "$TOTAL_SUITES"
printf "  ${C_GREEN}Passed:        %d${C_RESET}\n" "$PASSED_SUITES"
if (( FAILED_SUITES > 0 )); then
  printf "  ${C_RED}Failed:        %d${C_RESET}\n" "$FAILED_SUITES"
  echo "========================================================"
  exit 1
else
  printf "  ${C_GREEN}Failed:        0${C_RESET}\n"
  echo "========================================================"
  printf "${C_GREEN}${C_BOLD}✓ ALL QUALITY GATES PASSED! SYSTEM IS CLEAN AND STABLE.${C_RESET}\n"
  echo ""
  exit 0
fi
