#!/usr/bin/env bash
#
# tests/check-name-leaks.sh — Verify that no upstream name leaks remain in the codebase
#
# Fails if any case form of the old name (omarchy, Omarchy, OMARCHY) remains anywhere
# in the codebase outside of explicitly allowed attribution and tracking documents.

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

echo "=== Running Name Leak Detection ==="

# Directories to exclude from check:
# - .git: Git VCS history
# - reference: Read-only upstream reference checkout
# - docs: Stage 1 upstream audit documentation
EXCLUDE_DIRS=(
  --exclude-dir=".git"
  --exclude-dir="reference"
  --exclude-dir="docs"
  --exclude-dir=".agents"
  --exclude-dir=".gemini"
)

# Files to exclude from check:
# - THIRD_PARTY_NOTICES.md: Legal attribution
# - README.md: Required project inspiration and attribution statement
# - scripts/rebrand.sh: Contains the literal rebranding mapping rules
# - Tracking files: TASKS.md, PROGRESS.md, DECISIONS.md, OPEN_QUESTIONS.md
EXCLUDE_FILES=(
  --exclude="THIRD_PARTY_NOTICES.md"
  --exclude="README.md"
  --exclude="rebrand.sh"
  --exclude="check-name-leaks.sh"
  --exclude="TASKS.md"
  --exclude="PROGRESS.md"
  --exclude="DECISIONS.md"
  --exclude="OPEN_QUESTIONS.md"
)

# Search for any case variation of the upstream name across text files
LEAKS=$(grep -rnI -i "omarchy" "${EXCLUDE_DIRS[@]}" "${EXCLUDE_FILES[@]}" . || true)

if [[ -n "$LEAKS" ]]; then
  echo "❌ FAIL: Upstream name leaks detected in the codebase:" >&2
  echo "" >&2
  echo "$LEAKS" >&2
  echo "" >&2
  echo "Total offending lines: $(echo "$LEAKS" | wc -l | tr -d ' ')" >&2
  exit 1
fi

echo "✓ PASS: Zero name leaks found across the codebase."
exit 0
