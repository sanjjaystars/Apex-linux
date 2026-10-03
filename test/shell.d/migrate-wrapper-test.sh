#!/bin/bash

set -euo pipefail

source "$(dirname "$0")/base-test.sh"

test_tmp=$(mktemp -d)
trap 'rm -rf "$test_tmp"' EXIT

test_root="$test_tmp/apex"
test_home="$test_tmp/home"
stub_bin="$test_tmp/bin"
mkdir -p "$test_root/migrations" "$test_home" "$stub_bin"

cat >"$stub_bin/apex-notification-dismiss" <<'SH'
#!/bin/bash
printf '%s\n' "$1" >>"$TEST_DISMISSALS"
SH
chmod +x "$stub_bin/apex-notification-dismiss"

cat >"$test_root/migrations/100-migration.sh" <<'SH'
echo migration >>"$TEST_CALLS"
SH

run_migrate() {
  HOME="$test_home" \
  APEX_PATH="$test_root" \
  PATH="$stub_bin:$ROOT/bin:$PATH" \
  TEST_CALLS="$test_tmp/calls" \
  TEST_DISMISSALS="$test_tmp/dismissals" \
    "$ROOT/bin/apex-migrate" "$@"
}

: >"$test_tmp/calls"
run_migrate >"$test_tmp/migrate.out"
[[ $(sed -n '1p' "$test_tmp/calls") == "migration" ]] || fail "apex-migrate runs pending migrations"
pass "apex-migrate runs migrations without force"

grep -Fx 'Apex Migrations' "$test_tmp/dismissals" >/dev/null || fail "apex-migrate dismisses migration notifications"
pass "apex-migrate clears completed migration notifications"

rm -rf "$test_home/.local/state/apex/migrations"
run_migrate --pending >"$test_tmp/pending.out"
grep -q '^100-migration\.sh$' "$test_tmp/pending.out" || fail "apex-migrate --pending lists pending migrations"
pass "apex-migrate --pending lists pending migrations"

run_migrate >"$test_tmp/migrate-second.out"
if run_migrate --pending >"$test_tmp/not-pending.out"; then
  fail "apex-migrate --pending exits non-zero without pending migrations"
fi
[[ ! -s $test_tmp/not-pending.out ]] || fail "apex-migrate --pending stays quiet without pending migrations"
pass "apex-migrate --pending reports no pending migrations"

if run_migrate --force >"$test_tmp/force.out" 2>&1; then
  fail "apex-migrate rejects obsolete --force option"
fi
grep -q 'Unknown option: --force' "$test_tmp/force.out" || fail "apex-migrate reports obsolete --force option"
pass "apex-migrate no longer needs --force"
