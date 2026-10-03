#!/bin/bash
# Synchronize the clean Apex Linux repository into the ISO airootfs

set -eo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
TARGET_DIR="$SCRIPT_DIR/airootfs/opt/apex-linux"

echo "==> Preparing live environment Apex repository target at $TARGET_DIR..."
mkdir -p "$TARGET_DIR"

echo "==> Syncing repository files (excluding git and build artifacts)..."
rsync -a --delete \
  --exclude='.git' \
  --exclude='.github' \
  --exclude='reference' \
  --exclude='iso' \
  --exclude='test' \
  --exclude='tests' \
  --exclude='*.tmp' \
  --exclude='*.log' \
  --exclude='__pycache__' \
  "$REPO_ROOT/" "$TARGET_DIR/"

echo "==> Setting directory permissions..."
chmod -R u=rwX,go=rX "$TARGET_DIR"

echo "==> Apex repository embedded successfully in airootfs/opt/apex-linux."
