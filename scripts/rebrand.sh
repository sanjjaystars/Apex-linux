#!/usr/bin/env bash
#
# scripts/rebrand.sh — Apex Linux rebranding tool
#
# Renames files/directories and replaces text across all case forms:
#   omarchy -> apex
#   Omarchy -> Apex
#   OMARCHY -> APEX
#
# Usage:
#   scripts/rebrand.sh [--dry-run|--apply] [TARGET_DIR]
#
# Default mode is --dry-run.

set -euo pipefail

MODE="dry-run"
TARGET_DIR="."

usage() {
  cat <<EOF
Usage: $0 [OPTIONS] [TARGET_DIR]

Options:
  --dry-run   Simulate all renames and text replacements without modifying files (default)
  --apply     Apply renames and text replacements to the filesystem
  -h, --help  Show this help message

Arguments:
  TARGET_DIR  Root directory to process (default: current directory '.')
EOF
}

while (($#)); do
  case "$1" in
    --dry-run)
      MODE="dry-run"
      shift
      ;;
    --apply)
      MODE="apply"
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    -*)
      echo "Error: Unknown option '$1'" >&2
      usage >&2
      exit 1
      ;;
    *)
      TARGET_DIR="$1"
      shift
      ;;
  esac
done

if [[ ! -d "$TARGET_DIR" ]]; then
  echo "Error: Target directory '$TARGET_DIR' does not exist." >&2
  exit 1
fi

python3 - "$MODE" "$TARGET_DIR" <<'PYEOF'
import sys
import os
import re

mode = sys.argv[1]
root_target = os.path.abspath(sys.argv[2])
is_dry_run = (mode != "apply")

# Directories and files to strictly skip
SKIP_DIRS = {
    ".git",
    "reference",
    "docs",
    ".agents",
    ".gemini",
    "__pycache__",
}

SKIP_FILES = {
    "TASKS.md",
    "PROGRESS.md",
    "DECISIONS.md",
    "OPEN_QUESTIONS.md",
    "THIRD_PARTY_NOTICES.md",
    "rebrand.sh",
}

BINARY_EXTENSIONS = {
    ".png", ".jpg", ".jpeg", ".gif", ".webp", ".ico", ".svgz",
    ".ttf", ".otf", ".woff", ".woff2", ".eot",
    ".gz", ".bz2", ".xz", ".zst", ".tar", ".zip", ".7z",
    ".iso", ".img", ".qcow2", ".vmdk",
    ".so", ".a", ".dylib", ".bin", ".o",
    ".pdf", ".mp3", ".mp4", ".ogg", ".wav", ".flac",
}

def is_binary(path):
    _, ext = os.path.splitext(path)
    if ext.lower() in BINARY_EXTENSIONS:
        return True
    try:
        with open(path, "rb") as f:
            chunk = f.read(1024)
            if b"\0" in chunk:
                return True
    except OSError:
        return True
    return False

def replace_text(content):
    # Specific URL mappings first
    content = content.replace("https://github.com/basecamp/omarchy", "https://github.com/sanjjaystars/Apex-linux")
    content = content.replace("https://raw.githubusercontent.com/basecamp/omarchy/main", "https://raw.githubusercontent.com/sanjjaystars/Apex-linux/main")
    content = content.replace("git@github.com:basecamp/omarchy.git", "git@github.com:sanjjaystars/Apex-linux.git")

    # Case forms
    content = content.replace("OMARCHY", "APEX")
    content = content.replace("Omarchy", "Apex")
    content = content.replace("omarchy", "apex")
    return content

def rename_str(name):
    new_name = name.replace("OMARCHY", "APEX")
    new_name = new_name.replace("Omarchy", "Apex")
    new_name = new_name.replace("omarchy", "apex")
    return new_name

print(f"=== Apex Rebranding Tool ({mode.upper()}) ===")
print(f"Target: {root_target}")
print()

# Step 1: File Content Replacement
modified_files_count = 0
total_replacements_count = 0

for dirpath, dirnames, filenames in os.walk(root_target):
    # Prune skipped dirs
    dirnames[:] = [d for d in dirnames if d not in SKIP_DIRS and not d.startswith(".git")]
    rel_dir = os.path.relpath(dirpath, root_target)
    if any(part in SKIP_DIRS for part in rel_dir.split(os.sep)):
        continue

    for fname in filenames:
        if fname in SKIP_FILES:
            continue
        fpath = os.path.join(dirpath, fname)
        if os.path.islink(fpath):
            continue
        if is_binary(fpath):
            continue

        try:
            with open(fpath, "r", encoding="utf-8", errors="ignore") as f:
                original = f.read()
        except OSError as e:
            print(f"[ERROR READING] {fpath}: {e}")
            continue

        updated = replace_text(original)
        if updated != original:
            # Count changes
            diff_count = (original.count("omarchy") + original.count("Omarchy") + original.count("OMARCHY"))
            modified_files_count += 1
            total_replacements_count += diff_count
            rel_path = os.path.relpath(fpath, root_target)
            print(f"[CONTENT] {rel_path} (~{diff_count} occurrences)")
            if not is_dry_run:
                with open(fpath, "w", encoding="utf-8") as f:
                    f.write(updated)

print()
print(f"Content phase: {modified_files_count} files identified for modification ({total_replacements_count} total occurrences).")
print()

# Step 2: Path Renaming (Bottom-Up)
renamed_items = []

for dirpath, dirnames, filenames in os.walk(root_target, topdown=False):
    rel_dir = os.path.relpath(dirpath, root_target)
    if any(part in SKIP_DIRS for part in rel_dir.split(os.sep)):
        continue

    # Files first
    for fname in filenames:
        if fname in SKIP_FILES:
            continue
        new_fname = rename_str(fname)
        if new_fname != fname:
            old_path = os.path.join(dirpath, fname)
            new_path = os.path.join(dirpath, new_fname)
            renamed_items.append(("FILE", old_path, new_path))

    # Directories
    for dname in dirnames:
        if dname in SKIP_DIRS:
            continue
        new_dname = rename_str(dname)
        if new_dname != dname:
            old_path = os.path.join(dirpath, dname)
            new_path = os.path.join(dirpath, new_dname)
            renamed_items.append(("DIR", old_path, new_path))

for item_type, old_p, new_p in renamed_items:
    rel_old = os.path.relpath(old_p, root_target)
    rel_new = os.path.relpath(new_p, root_target)
    print(f"[RENAME {item_type}] {rel_old} -> {rel_new}")
    if not is_dry_run:
        os.rename(old_p, new_p)

print()
print(f"Rename phase: {len(renamed_items)} items identified for renaming.")
if is_dry_run:
    print("\nDry-run complete. No files were modified on disk. Pass --apply to execute.")
else:
    print("\nRebrand complete. All changes applied successfully.")
PYEOF
