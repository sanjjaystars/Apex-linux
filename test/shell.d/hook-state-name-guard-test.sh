#!/bin/bash

set -euo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/base-test.sh"

work_dir=$(mktemp -d)
trap 'rm -rf "$work_dir"' EXIT

fake_home="$work_dir/home"
mkdir -p "$fake_home/.config/apex/hooks" "$fake_home/.local/state/apex"

# --- apex-hook --------------------------------------------------------------

# A hook name is a label, not a path. One carrying a slash, or one that is a
# bare `.` or `..`, would run a script from outside the hooks directory.

cat >"$fake_home/.config/apex/hooks/test-hook" <<'SH'
touch "$HOME/hook-ran"
SH

HOME="$fake_home" "$ROOT/bin/apex-hook" test-hook
[[ -f $fake_home/hook-ran ]] ||
  fail "apex hook runs a named hook from the hooks directory"
pass "apex hook runs a named hook from the hooks directory"

# Dots inside a name are not a path. a..b stays inside the hooks directory.
cat >"$fake_home/.config/apex/hooks/a..b" <<'SH'
touch "$HOME/dotted-hook-ran"
SH

HOME="$fake_home" "$ROOT/bin/apex-hook" a..b
[[ -f $fake_home/dotted-hook-ran ]] ||
  fail "apex hook accepts a hook name with dots in the middle"
pass "apex hook accepts a hook name with dots in the middle"

for name in . ..; do
  status=0
  HOME="$fake_home" "$ROOT/bin/apex-hook" "$name" >/dev/null 2>&1 || status=$?
  (( status == 2 )) ||
    fail "apex hook refuses a hook name of $name" "exit: $status"
  pass "apex hook refuses a hook name of $name"
done

# This file sits where a name of ../../evil would resolve: hooks/../.. is
# ~/.config.
cat >"$fake_home/.config/evil" <<'SH'
touch "$HOME/escape-ran"
SH
chmod +x "$fake_home/.config/evil"

status=0
HOME="$fake_home" "$ROOT/bin/apex-hook" "../../evil" >/dev/null 2>&1 || status=$?
(( status == 2 )) ||
  fail "apex hook refuses a hook name with a dot-dot" "exit: $status"
[[ ! -e $fake_home/escape-ran ]] ||
  fail "apex hook runs nothing when it refuses the name"
pass "apex hook refuses a hook name with a dot-dot"

status=0
HOME="$fake_home" "$ROOT/bin/apex-hook" "sub/dir" >/dev/null 2>&1 || status=$?
(( status == 2 )) ||
  fail "apex hook refuses a hook name with a slash" "exit: $status"
pass "apex hook refuses a hook name with a slash"

# --- apex-hook-install ------------------------------------------------------

# The installer joins the type into ~/.config/apex/hooks/<type>.d before
# mkdir/cp. The runner already refuses a slashed type; install must too, or a
# name the runner will not run still lands on disk.

source_hook="$work_dir/source-hook"
cat >"$source_hook" <<'SH'
#!/bin/bash
true
SH

HOME="$fake_home" "$ROOT/bin/apex-hook-install" post-update "$source_hook" >/dev/null
[[ -f $fake_home/.config/apex/hooks/post-update.d/source-hook ]] ||
  fail "apex hook install still installs a named hook"
pass "apex hook install still installs a named hook"

HOME="$fake_home" "$ROOT/bin/apex-hook-install" a..b "$source_hook" >/dev/null
[[ -f $fake_home/.config/apex/hooks/a..b.d/source-hook ]] ||
  fail "apex hook install accepts a hook name with dots in the middle"
pass "apex hook install accepts a hook name with dots in the middle"

for name in . ..; do
  status=0
  HOME="$fake_home" "$ROOT/bin/apex-hook-install" "$name" "$source_hook" >/dev/null 2>&1 || status=$?
  (( status == 2 )) ||
    fail "apex hook install refuses a hook name of $name" "exit: $status"
  [[ ! -e $fake_home/.config/apex/hooks/${name}.d ]] ||
    fail "apex hook install creates no directory for a hook name of $name"
  pass "apex hook install refuses a hook name of $name"
done

# hooks/../../evil.d is ~/.config/evil.d. The guard must fire before mkdir.
status=0
HOME="$fake_home" "$ROOT/bin/apex-hook-install" "../../evil" "$source_hook" >/dev/null 2>&1 || status=$?
(( status == 2 )) ||
  fail "apex hook install refuses a hook name with a dot-dot" "exit: $status"
[[ ! -e $fake_home/.config/evil.d ]] ||
  fail "apex hook install creates nothing outside the hooks directory"
pass "apex hook install refuses a hook name with a dot-dot"

status=0
HOME="$fake_home" "$ROOT/bin/apex-hook-install" "sub/dir" "$source_hook" >/dev/null 2>&1 || status=$?
(( status == 2 )) ||
  fail "apex hook install refuses a hook name with a slash" "exit: $status"
[[ ! -e $fake_home/.config/apex/hooks/sub ]] ||
  fail "apex hook install creates no nested directory from a slashed name"
pass "apex hook install refuses a hook name with a slash"

# --- apex-state -------------------------------------------------------------

state_dir="$fake_home/.local/state/apex"

HOME="$fake_home" "$ROOT/bin/apex-state" set reboot-required
[[ -f $state_dir/reboot-required ]] ||
  fail "apex state set still creates a plain state file"
pass "apex state set still creates a plain state file"

HOME="$fake_home" "$ROOT/bin/apex-state" set v1..2
[[ -f $state_dir/v1..2 ]] ||
  fail "apex state set accepts a state name with dots in the middle"
pass "apex state set accepts a state name with dots in the middle"

for name in . ..; do
  status=0
  HOME="$fake_home" "$ROOT/bin/apex-state" set "$name" >/dev/null 2>&1 || status=$?
  (( status == 2 )) ||
    fail "apex state set refuses a state name of $name" "exit: $status"
  pass "apex state set refuses a state name of $name"
done

# state/../.. is ~/.local. The guard must fire before touch gets there.
status=0
HOME="$fake_home" "$ROOT/bin/apex-state" set "../../escape" >/dev/null 2>&1 || status=$?
(( status == 2 )) ||
  fail "apex state set refuses a state name with a dot-dot" "exit: $status"
[[ ! -e $fake_home/.local/escape ]] ||
  fail "apex state set creates nothing outside the state directory"
pass "apex state set refuses a state name with a dot-dot"

status=0
HOME="$fake_home" "$ROOT/bin/apex-state" set "sub/dir" >/dev/null 2>&1 || status=$?
(( status == 2 )) ||
  fail "apex state set refuses a state name with a slash" "exit: $status"
pass "apex state set refuses a state name with a slash"

# clear takes patterns by design ("state-name-or-pattern") and matches
# basenames through find -name, so it can never walk out of the directory.
touch "$state_dir/restart-a-required" "$state_dir/restart-b-required" "$state_dir/keep-me"
HOME="$fake_home" "$ROOT/bin/apex-state" clear "restart-*-required"
[[ ! -e $state_dir/restart-a-required && ! -e $state_dir/restart-b-required && -f $state_dir/keep-me ]] ||
  fail "apex state clear still clears matching patterns only"
pass "apex state clear still clears matching patterns only"
