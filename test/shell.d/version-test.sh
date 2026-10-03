#!/bin/bash

set -euo pipefail

source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/base-test.sh"

test_tmp=$(mktemp -d)
trap 'rm -rf "$test_tmp"' EXIT

stub_bin="$test_tmp/bin"
mkdir -p "$stub_bin"

# The edge channel installs apex-dev. Older builds did not declare
# provides=(apex), so a query for plain apex finds nothing there.
cat >"$stub_bin/pacman" <<'STUB'
#!/bin/bash
[[ $1 == "-Q" ]] || exit 1
shift
for package in "$@"; do
  case ",${APEX_TEST_PACKAGES:-}," in
    *",$package,"*)
      echo "$package ${APEX_TEST_VERSION:-4.0.0-1}"
      exit 0
      ;;
  esac
done
echo "error: package '$1' was not found" >&2
exit 1
STUB
chmod +x "$stub_bin/pacman"

version() {
  APEX_TEST_PACKAGES="$1" \
    APEX_PATH="${2:-/usr/share/apex}" \
    PATH="$stub_bin:$PATH" \
    "$ROOT/bin/apex-version"
}

[[ $(version apex) == "4.0.0-1" ]] || fail "version reports the stable package"
pass "version reports the stable package"

[[ $(version apex-dev) == "4.0.0-1" ]] || fail "version reports the edge package"
pass "version reports the edge package"

# A checkout reports its hash instead, so packages are irrelevant there.
[[ $(version "" "$test_tmp/checkout") == "dev" ]] || fail "version reports a dev checkout"
pass "version reports a dev checkout"

if version "" >/dev/null 2>&1; then
  fail "version fails when no Apex package is installed"
fi
pass "version fails when no Apex package is installed"

# The snapshot description is only a label, so a failed lookup must not abort
# the update under set -e.
snapshot_desc=$(
  set -e
  PATH="$stub_bin:$PATH" APEX_TEST_PACKAGES="" APEX_PATH=/usr/share/apex \
    bash -c 'DESC="$(apex-version 2>/dev/null || echo unknown)"; echo "$DESC"' 2>/dev/null
) || fail "snapshot survives an unknown version"

[[ $snapshot_desc == "unknown" ]] || fail "snapshot labels an unknown version" "actual: $snapshot_desc"
pass "snapshot survives an unknown version"
