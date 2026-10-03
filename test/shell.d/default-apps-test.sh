#!/bin/bash

set -euo pipefail

source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/base-test.sh"

test_tmp=$(mktemp -d)
trap 'rm -rf "$test_tmp"' EXIT

mock_bin="$test_tmp/bin"
test_home="$test_tmp/home"
installed_dir="$test_tmp/installed"
install_log="$test_tmp/install-log"
terminal_log="$test_tmp/terminal-log"
notification_log="$test_tmp/notification-log"
setup_log="$test_tmp/setup-log"
browser_file="$test_tmp/browser"
mkdir -p "$mock_bin" "$test_home/.config" "$installed_dir"

cat >"$mock_bin/apex-cmd-missing" <<'SH'
#!/bin/bash
[[ ! -e $APEX_TEST_INSTALLED_DIR/$1 ]]
SH

cat >"$mock_bin/apex-launch-floating-terminal-with-presentation" <<'SH'
#!/bin/bash
printf '%s\0' "$@" >"$APEX_TEST_TERMINAL_LOG"
SH

cat >"$mock_bin/apex-notification-send" <<'SH'
#!/bin/bash
printf '%s\0' "$@" >>"$APEX_TEST_NOTIFICATION_LOG"
SH

cat >"$mock_bin/apex-test-setup-call" <<'SH'
#!/bin/bash
printf '%s:%s\n' "${0##*/}" "$*" >>"$APEX_TEST_SETUP_LOG"
[[ ${APEX_TEST_SETUP_FAIL:-} != "${0##*/}" ]]
SH

cat >"$mock_bin/sudo" <<'SH'
#!/bin/bash
printf 'sudo:%s\n' "$*" >>"$APEX_TEST_SETUP_LOG"
[[ ${APEX_TEST_SETUP_FAIL:-} != "sudo" ]]
SH

cat >"$mock_bin/xdg-settings" <<'SH'
#!/bin/bash
case $1 in
get) [[ -f $APEX_TEST_BROWSER_FILE ]] && cat "$APEX_TEST_BROWSER_FILE" ;;
set) printf '%s\n' "$3" >"$APEX_TEST_BROWSER_FILE" ;;
esac
SH

cat >"$mock_bin/apex-test-installer" <<'SH'
#!/bin/bash
installer=${0##*/}

if [[ $installer == "apex-install-browser" && ${APEX_TEST_REAL_BROWSER_INSTALL:-false} == "true" ]]; then
  exec "$ROOT/bin/apex-install-browser" "$@"
fi

case $installer in
apex-pkg-add|apex-pkg-aur-add)
  package=$1
  printf 'pkg:%s\n' "$package" >>"$APEX_TEST_INSTALL_LOG"
  case $package in
  chromium) command=chromium ;;
  firefox) command=firefox ;;
  zen-browser-bin) command=zen-browser ;;
  cursor-bin) command=cursor ;;
  sublime-text-4) command=subl ;;
  vim) command=vim ;;
  neovim) command=nvim ;;
  esac
  ;;
apex-install-browser)
  selection=$1
  printf 'browser:%s\n' "$selection" >>"$APEX_TEST_INSTALL_LOG"
  case $selection in
  chromium) command=chromium ;;
  chrome) command=google-chrome-stable ;;
  brave) command=brave ;;
  brave-origin) command=brave-origin ;;
  edge) command=microsoft-edge-stable ;;
  firefox) command=firefox ;;
  zen) command=zen-browser ;;
  esac
  ;;
apex-install-terminal)
  command=$1
  printf 'terminal:%s\n' "$command" >>"$APEX_TEST_INSTALL_LOG"
  ;;
apex-install-editor-*)
  editor=${installer#apex-install-editor-}
  printf 'editor:%s\n' "$editor" >>"$APEX_TEST_INSTALL_LOG"
  case $editor in
  vscode) command=code ;;
  zed) command=zeditor ;;
  helix) command=helix ;;
  emacs) command=emacs ;;
  esac
  ;;
esac

[[ ${APEX_TEST_INSTALL_FAIL:-false} != "true" ]] || exit 1
touch "$APEX_TEST_INSTALLED_DIR/$command"
SH

for installer in \
  apex-pkg-add \
  apex-pkg-aur-add \
  apex-install-browser \
  apex-install-terminal \
  apex-install-editor-vscode \
  apex-install-editor-zed \
  apex-install-editor-helix \
  apex-install-editor-emacs; do
  ln -s apex-test-installer "$mock_bin/$installer"
done
for setup_command in \
  apex-install-chromium-copy-url \
  apex-install-chromium-ytdlp \
  apex-theme-set-browser; do
  ln -s apex-test-setup-call "$mock_bin/$setup_command"
done

chmod +x "$mock_bin"/*

export HOME="$test_home"
export PATH="$mock_bin:$ROOT/bin:$PATH"
export APEX_PATH="$ROOT"
export APEX_TEST_INSTALLED_DIR="$installed_dir"
export APEX_TEST_INSTALL_LOG="$install_log"
export APEX_TEST_TERMINAL_LOG="$terminal_log"
export APEX_TEST_NOTIFICATION_LOG="$notification_log"
export APEX_TEST_SETUP_LOG="$setup_log"
export APEX_TEST_BROWSER_FILE="$browser_file"

assert_missing_opens_installer() {
  local type=$1
  local selection=$2

  : >"$terminal_log"
  "apex-default-$type" "$selection"
  mapfile -d '' -t terminal_args <"$terminal_log"
  [[ ${terminal_args[*]} == "apex-default-$type --install $selection" ]] ||
    fail "missing $selection opens its default installer in a terminal"
}

browser_cases=(
  'chromium chromium browser:chromium'
  'chrome google-chrome-stable browser:chrome'
  'brave brave browser:brave'
  'brave-origin brave-origin browser:brave-origin'
  'edge microsoft-edge-stable browser:edge'
  'firefox firefox browser:firefox'
  'zen zen-browser browser:zen'
)

terminal_cases=(
  'alacritty Alacritty.desktop'
  'foot foot.desktop'
  'ghostty com.mitchellh.ghostty.desktop'
  'kitty kitty.desktop'
)

editor_cases=(
  'code code editor:vscode'
  'cursor cursor pkg:cursor-bin'
  'zed zeditor editor:zed'
  'sublime_text subl pkg:sublime-text-4'
  'helix helix editor:helix'
  'vim vim pkg:vim'
  'emacs emacs editor:emacs'
  'nvim nvim pkg:neovim'
)

for entry in "${browser_cases[@]}"; do
  read -r selection command installer <<<"$entry"
  assert_missing_opens_installer browser "$selection"
done
for entry in "${terminal_cases[@]}"; do
  read -r selection desktop_id <<<"$entry"
  assert_missing_opens_installer terminal "$selection"
done
for entry in "${editor_cases[@]}"; do
  read -r selection command installer <<<"$entry"
  assert_missing_opens_installer editor "$selection"
done
pass "missing defaults open visible installers for every supported app"

for entry in "${browser_cases[@]}"; do
  read -r selection command installer <<<"$entry"
  rm -f "$installed_dir/$command"
  : >"$install_log"
  apex-default-browser --install "$selection"
  [[ $(<"$install_log") == "$installer" ]] || fail "$selection uses its browser installer"
  [[ $(apex-default-browser) == "$selection" ]] || fail "$selection becomes the default browser after installation"
done
pass "browser defaults install every missing browser before selection"

: >"$install_log"
: >"$setup_log"
rm -f "$installed_dir/chromium"
APEX_TEST_REAL_BROWSER_INSTALL=true apex-default-browser --install chromium >/dev/null
[[ $(<"$install_log") == "pkg:chromium" ]] || fail "Chromium browser installer installs the package"
[[ $(apex-default-browser) == "chromium" ]] || fail "Chromium becomes the default after its full installer succeeds"
cmp -s "$ROOT/config/chromium-flags.conf" "$test_home/.config/chromium-flags.conf" ||
  fail "Chromium browser installer copies the default flags"
grep -Fxq 'sudo:install -d -m 0755 -o root -g root /etc/chromium' "$setup_log" ||
  fail "Chromium browser installer creates a root-owned Chromium policy parent"
grep -Fxq 'sudo:install -d -m 0755 -o root -g root /etc/chromium/policies' "$setup_log" ||
  fail "Chromium browser installer creates a root-owned Chromium policies parent"
grep -Fxq 'sudo:install -d -m 0755 -o root -g root /etc/chromium/policies/managed' "$setup_log" ||
  fail "Chromium browser installer creates a root-owned managed policy directory"
grep -Fxq 'sudo:find /etc/chromium/policies/managed -mindepth 1 -maxdepth 1 ! -user root -exec rm -rf -- {} +' "$setup_log" ||
  fail "Chromium browser installer drops non-root files from its policy directory"
if grep -E 'groupadd|usermod|apex-browser-policy' "$setup_log" >/dev/null; then
  fail "Chromium browser installer does not create a browser-policy group" "$(cat "$setup_log")"
fi
grep -Fxq 'apex-install-chromium-copy-url:' "$setup_log" ||
  fail "Chromium browser installer registers the Copy URL host"
grep -Fxq 'apex-install-chromium-ytdlp:' "$setup_log" ||
  fail "Chromium browser installer registers the yt-dlp host"
grep -Fxq 'apex-theme-set-browser:' "$setup_log" ||
  fail "Chromium browser installer applies the current theme"
pass "Chromium browser installer restores the complete Apex setup"

: >"$install_log"
: >"$setup_log"
rm -f "$installed_dir/firefox"
APEX_TEST_REAL_BROWSER_INSTALL=true apex-default-browser --install firefox >/dev/null
[[ $(<"$install_log") == "pkg:firefox" ]] || fail "Firefox browser installer installs the package"
[[ $(apex-default-browser) == "firefox" ]] || fail "Firefox becomes the default after its full installer succeeds"
grep -Fxq 'sudo:install -d -m 0755 -o root -g root /usr/lib/firefox/distribution' "$setup_log" ||
  fail "Firefox browser installer creates its distribution directory"
grep -Fxq 'sudo:find /usr/lib/firefox/distribution -mindepth 1 -maxdepth 1 ! -user root -exec rm -rf -- {} +' "$setup_log" ||
  fail "Firefox browser installer drops non-root files from its distribution directory"
grep -Fxq "sudo:install -m 644 -o root -g root -T $ROOT/default/firefox/policies.json /usr/lib/firefox/distribution/policies.json" "$setup_log" ||
  fail "Firefox browser installer copies policies.json without following a destination symlink"
[[ -e $installed_dir/firefox ]] || fail "Firefox browser installer marks firefox installed"
pass "Firefox browser installer restores the complete Apex setup"

: >"$install_log"
: >"$setup_log"
rm -f "$installed_dir/zen-browser"
APEX_TEST_REAL_BROWSER_INSTALL=true apex-default-browser --install zen >/dev/null
[[ $(<"$install_log") == "pkg:zen-browser-bin" ]] || fail "Zen browser installer installs the package"
[[ $(apex-default-browser) == "zen" ]] || fail "Zen becomes the default after its full installer succeeds"
grep -Fxq 'sudo:install -d -m 0755 -o root -g root /opt/zen-browser/distribution' "$setup_log" ||
  fail "Zen browser installer creates its distribution directory"
grep -Fxq 'sudo:find /opt/zen-browser/distribution -mindepth 1 -maxdepth 1 ! -user root -exec rm -rf -- {} +' "$setup_log" ||
  fail "Zen browser installer drops non-root files from its distribution directory"
grep -Fxq "sudo:install -m 644 -o root -g root -T $ROOT/default/firefox/policies.json /opt/zen-browser/distribution/policies.json" "$setup_log" ||
  fail "Zen browser installer copies policies.json without following a destination symlink"
[[ -e $installed_dir/zen-browser ]] || fail "Zen browser installer marks zen-browser installed"
pass "Zen browser installer restores the complete Apex setup"

apex-default-browser zen
rm -f "$installed_dir/chromium"
if APEX_TEST_REAL_BROWSER_INSTALL=true APEX_TEST_INSTALL_FAIL=true \
  apex-default-browser --install chromium >"$test_tmp/browser-package-failure" 2>&1; then
  fail "failed Chromium package installation returns an error"
fi
[[ $(apex-default-browser) == "zen" ]] || fail "failed Chromium package installation preserves the default browser"
[[ ! -e $installed_dir/chromium ]] || fail "failed Chromium package installation does not mark it installed"
pass "failed Chromium package installation preserves the current default"

if APEX_TEST_REAL_BROWSER_INSTALL=true APEX_TEST_SETUP_FAIL=sudo \
  apex-default-browser --install chromium >"$test_tmp/browser-install-failure" 2>&1; then
  fail "failed Chromium setup returns an error"
fi
[[ $(apex-default-browser) == "zen" ]] || fail "failed Chromium setup preserves the default browser"
grep -Fq 'Installing Chromium' "$test_tmp/browser-install-failure" ||
  fail "failed Chromium setup keeps progress visible in the terminal"
pass "failed Chromium setup preserves the current default"

for entry in "${terminal_cases[@]}"; do
  read -r selection desktop_id <<<"$entry"
  rm -f "$installed_dir/$selection"
  : >"$install_log"
  apex-default-terminal --install "$selection"
  [[ $(<"$install_log") == "terminal:$selection" ]] || fail "$selection uses the terminal installer"
  [[ $(tail -n 1 "$test_home/.config/xdg-terminals.list") == "$desktop_id" ]] ||
    fail "$selection becomes the default terminal after installation"
done
pass "terminal defaults install every missing terminal before selection"

for entry in "${editor_cases[@]}"; do
  read -r selection command installer <<<"$entry"
  rm -f "$installed_dir/$command"
  : >"$install_log"
  apex-default-editor --install "$selection"
  [[ $(<"$install_log") == "$installer" ]] || fail "$selection uses its editor installer"
  [[ $(apex-default-editor) == "$command" ]] || fail "$selection becomes the default editor after installation"
done
pass "editor defaults install every missing editor before selection"

: >"$install_log"
: >"$terminal_log"
apex-default-browser zen
apex-default-terminal kitty
apex-default-editor nvim
[[ ! -s $install_log && ! -s $terminal_log ]] || fail "installed defaults skip installation"
pass "installed defaults are selected immediately"

previous_editor=$(apex-default-editor)
rm -f "$installed_dir/vim"
if APEX_TEST_INSTALL_FAIL=true apex-default-editor --install vim >"$test_tmp/install-failure" 2>&1; then
  fail "failed default installation returns an error"
fi
[[ $(apex-default-editor) == "$previous_editor" ]] || fail "failed installation preserves the default"
pass "failed installation preserves the current default"
