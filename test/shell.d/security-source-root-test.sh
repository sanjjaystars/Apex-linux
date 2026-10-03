#!/bin/bash

set -euo pipefail

source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/base-test.sh"
source "$SHELL_TEST_DIR/fixtures/sudo-boundary-test.sh"
source "$SUDO_TEST_ROOT/bin/apex-security-functions"

rm -f "$SUDO_TEST_ROOT/bin/apex-update"
copy_boundary_file bin/apex-update
apex_security_require_source_root "$SUDO_TEST_ROOT/bin/apex-update" || fail "matching checkout root was rejected"
pass "a canonical checkout matches its own entrypoint"

mkdir "$boundary_tmp/other-root"
ln -s "$SUDO_TEST_ROOT" "$boundary_tmp/root-link"
for root in "$boundary_tmp/other-root" "$boundary_tmp/root-link" .; do
  if APEX_PATH="$root" apex_security_require_source_root "$SUDO_TEST_ROOT/bin/apex-update" >"$boundary_tmp/output" 2>&1; then
    fail "a different or noncanonical source root was accepted"
  fi
done
pass "different, symlink and relative roots are rejected"

# Redirect only the two package-layout literals into the fixture. Resolution
# still uses real readlink/realpath; no host /usr/bin file is changed or run.
package_root="$boundary_tmp/usr/share/apex"
package_bin="$boundary_tmp/usr/bin"
mkdir -p "$package_root/bin" "$package_bin"
cp "$SUDO_TEST_ROOT/bin/apex-update" "$package_bin/apex-update"
cp "$SUDO_TEST_ROOT/bin/apex-update" "$package_bin/different-command"
ln -s "$package_bin/apex-update" "$package_root/bin/apex-update"
python3 - "$SUDO_TEST_ROOT/bin/apex-security-functions" "$boundary_tmp/package-library" "$package_root" "$package_bin" <<'PY'
import sys
from pathlib import Path
source, output, root, binaries = sys.argv[1:]
text = Path(source).read_text()
text = text.replace('"/usr/share/apex"', f'"{root}"')
text = text.replace('"/usr/bin/$command_name"', f'"{binaries}/$command_name"')
Path(output).write_text(text)
PY
source "$boundary_tmp/package-library"
APEX_PATH="$package_root" apex_security_require_source_root "$package_bin/apex-update" || fail "package binary was rejected"
APEX_PATH="$package_root" apex_security_require_source_root "$package_root/bin/apex-update" || fail "package link was rejected"
pass "the package binary and its matching source-tree link are accepted"

ln -sfn "$package_bin/different-command" "$package_root/bin/apex-update"
if APEX_PATH="$package_root" apex_security_require_source_root "$package_root/bin/apex-update" >"$boundary_tmp/output" 2>&1; then
  fail "a package link to a different command was accepted"
fi
pass "a package link must resolve to its named command"

# Run the protected entrypoints themselves with a mismatched root. These must
# stop before any sudo or operational fixture command, not merely validate in
# an isolated library test.
for command in apex-update apex-refresh-pacman apex-update-stay-awake apex-channel-set; do
  rm -f "$SUDO_TEST_ROOT/bin/$command"
  copy_boundary_file "bin/$command"
  for root in "$boundary_tmp/other-root" .; do
    reset_boundary
    if APEX_PATH="$root" "$SUDO_TEST_ROOT/bin/$command" >"$boundary_tmp/output" 2>&1; then
      fail "$command accepted a mismatched root"
    fi
    [[ ! -s $SUDO_TEST_LOG ]] || fail "$command ran work before rejecting its root"
  done
  pass "$command rejects mismatched and relative roots before work"
done
