#!/bin/bash

set -euo pipefail

source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/base-test.sh"

test_tmp=$(mktemp -d)
trap 'rm -rf "$test_tmp"' EXIT

mock_bin="$test_tmp/bin"
test_home="$test_tmp/home"
marker="$test_home/.local/state/apex/preinstalls-removed"
pkg_log="$test_tmp/packages"
mkdir -p "$mock_bin" "$test_home/.local/state/apex"

for command in apex-webapp-remove-all apex-tui-remove-all apex-refresh-applications hyprctl; do
  printf '#!/bin/bash\nexit 0\n' >"$mock_bin/$command"
done

cat >"$mock_bin/gum" <<'SH'
#!/bin/bash
[[ $1 == confirm ]] && exit "${APEX_TEST_CONFIRM:-0}"
exit 0
SH

cat >"$mock_bin/apex-pkg-add" <<'SH'
#!/bin/bash
printf '%s\n' "$@" >"$APEX_TEST_PKG_LOG"
exit "${APEX_TEST_PKG_ADD_STATUS:-0}"
SH

cat >"$mock_bin/apex-pkg-drop" <<'SH'
#!/bin/bash
printf '%s\n' "$@" >"$APEX_TEST_PKG_LOG"
SH

chmod +x "$mock_bin"/*

# $ROOT/bin after the mocks, so the real helpers answer wherever a mock does not
# shadow them.
export PATH="$mock_bin:$ROOT/bin:$PATH"
export HOME="$test_home"
export APEX_TEST_PKG_LOG="$pkg_log"

# Both scripts restore and remove the same set, and every package in it has to be
# one Apex actually ships, or Remove Preinstalls takes out an app the user
# chose from the menu and Install Preinstalls puts back one we retired.
mapfile -t shipped < <(sed -e 's/[[:space:]]*#.*$//' -e '/^[[:space:]]*$/d' "$ROOT/install/apex-base.packages")

"$ROOT/bin/apex-install-preinstalls" >/dev/null
mapfile -t restored <"$pkg_log"

"$ROOT/bin/apex-remove-preinstalls" >/dev/null
mapfile -t dropped <"$pkg_log"

[[ ${restored[*]} == "${dropped[*]}" ]] ||
  fail "Install and Remove Preinstalls cover the same packages" \
    "restored: ${restored[*]}
dropped:  ${dropped[*]}"
pass "Install and Remove Preinstalls cover the same packages"

for package in "${restored[@]}"; do
  printf '%s\n' "${shipped[@]}" | grep -qxF "$package" ||
    fail "every preinstall is shipped in apex-base.packages" "$package is not shipped"
done
pass "every preinstall is shipped in apex-base.packages"

for package in omacut monologue omacalc omawrite hype; do
  printf '%s\n' "${restored[@]}" | grep -qxF "$package" ||
    fail "preinstalls cover the Omacom apps" "$package is missing"
done
pass "preinstalls cover the Omacom apps"

# The bindings key off the marker, so clearing it before the packages land would
# point them at apps that never came back.
touch "$marker"
APEX_TEST_PKG_ADD_STATUS=1 "$ROOT/bin/apex-install-preinstalls" >/dev/null && status=0 || status=$?
(( status == 1 )) || fail "restore reports a failed package transaction" "exit status was $status"
[[ -f $marker ]] || fail "restore keeps the opt-out marker when packages fail to install"
pass "restore keeps the opt-out marker when packages fail to install"

"$ROOT/bin/apex-install-preinstalls" >/dev/null
[[ ! -e $marker ]] || fail "restore clears the opt-out marker once the packages are back"
pass "restore clears the opt-out marker once the packages are back"

rm -f "$marker"
APEX_TEST_CONFIRM=1 "$ROOT/bin/apex-remove-preinstalls" >/dev/null
[[ ! -e $marker ]] || fail "declining Remove Preinstalls changes nothing"
pass "declining Remove Preinstalls changes nothing"

"$ROOT/bin/apex-remove-preinstalls" >/dev/null
[[ -f $marker ]] || fail "Remove Preinstalls records the opt-out"
pass "Remove Preinstalls records the opt-out"
