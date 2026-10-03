#!/usr/bin/env python3
"""Apex Linux Script Syntax and Shellcheck Linter.

Audits all shell scripts using shellcheck and compiles all Python scripts to
ensure 100% zero syntax and severity=error linting errors across the codebase.
"""

import os
import subprocess
import sys

REPO_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))

print("=== Running Apex Linux Script Verification (Shellcheck & Python) ===")

files_output = subprocess.check_output(
    ["git", "-C", REPO_ROOT, "ls-files", "bin/apex*", "install/*.sh", "install/*/*.sh", "tests/*.sh", "iso/*.sh", "migrations/*.sh"]
).decode().splitlines()

bash_files = []
py_files = []

for rel_path in files_output:
    full_path = os.path.join(REPO_ROOT, rel_path)
    if not os.path.isfile(full_path):
        continue
    try:
        with open(full_path, "rb") as fp:
            first_line = fp.readline()
            if first_line.startswith(b"#!") and b"python" in first_line:
                py_files.append(full_path)
            elif b"bash" in first_line or b"sh" in first_line or rel_path.endswith(".sh"):
                bash_files.append(full_path)
    except Exception as e:
        print(f"Error reading {rel_path}: {e}", file=sys.stderr)
        sys.exit(1)

print(f"  Discovered: {len(bash_files)} Bash scripts, {len(py_files)} Python scripts.")

# 1. Verify Python files
failed_py = 0
for pf in py_files:
    rel = os.path.relpath(pf, REPO_ROOT)
    res = subprocess.run([sys.executable, "-m", "py_compile", pf], capture_output=True, text=True)
    if res.returncode != 0:
        print(f"  [FAIL] Python syntax error in {rel}:\n{res.stderr}", file=sys.stderr)
        failed_py += 1

if failed_py == 0:
    print(f"  \033[1;32m✓ Verified {len(py_files)} Python scripts cleanly.\033[0m")
else:
    sys.exit(1)

# 2. Run Shellcheck on Bash files
failed_bash = 0
chunk_size = 50
for i in range(0, len(bash_files), chunk_size):
    chunk = bash_files[i:i + chunk_size]
    res = subprocess.run(["shellcheck", "-s", "bash", "--severity=error"] + chunk)
    if res.returncode != 0:
        failed_bash += 1

if failed_bash == 0:
    print(f"  \033[1;32m✓ Verified {len(bash_files)} Bash scripts with shellcheck (0 errors).\033[0m")
    print("\n\033[1;32m✓ All scripts passed validation successfully.\033[0m")
    sys.exit(0)
else:
    print(f"\n\033[1;31m✗ Shellcheck failed on {failed_bash} chunk(s).\033[0m", file=sys.stderr)
    sys.exit(1)
