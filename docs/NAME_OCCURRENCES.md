# docs/NAME_OCCURRENCES.md — Upstream "omarchy" Name Occurrences

**Source:** `grep -r` across `reference/omarchy/`
**Date:** 2026-10-03

All counts are from live grep/find commands run against `reference/omarchy/`.
Binary files excluded unless noted.

---

## Raw Counts

| Metric | Count | Command |
|---|---|---|
| Files containing `omarchy` (any case) | 1269 | `grep -rl 'omarchy' \| wc -l` |
| Total line occurrences of `omarchy` | 10040 | `grep -rc 'omarchy' \| awk sum` |
| Files containing `Omarchy` (capitalized) | 461 | `grep -rl 'Omarchy' \| wc -l` |
| Files containing `OMARCHY` (all caps) | 415 | `grep -rl 'OMARCHY' \| wc -l` |
| Filenames containing `omarchy` | 566 | `find -name '*omarchy*' \| wc -l` |
| Filenames in `bin/` with `omarchy*` | 479 | `find bin/ -name 'omarchy*' \| wc -l` |
| Unique `OMARCHY_*` environment variable names | 323 | `grep -roh 'OMARCHY_[A-Z_]*' \| sort -u \| wc -l` |
| Files referencing `.local/share/omarchy`, `.config/omarchy`, or `.local/state/omarchy` | 313 | `grep -rl 'share/omarchy\|.config/omarchy\|state/omarchy' \| wc -l` |

---

## Name Forms Needing Replacement

During the rebrand pass (Task C: `scripts/rebrand.sh`), all of the following
forms must be replaced with their Apex equivalents:

| Form | Replacement | Notes |
|---|---|---|
| `omarchy` (lowercase) | `apex` | Command prefixes, file names, variable names |
| `Omarchy` (title case) | `Apex` | Display text, docs, comments |
| `OMARCHY` (uppercase) | `APEX` | Environment variable names |
| `OMARCHY_*` variables | `APEX_*` | All 323 unique env vars |
| `~/.local/share/omarchy` | `~/.local/share/apex` | User data directory |
| `~/.config/omarchy` | `~/.config/apex` | User config directory |
| `~/.local/state/omarchy` | `~/.local/state/apex` | User state directory |
| `/etc/omarchy` | `/etc/apex` | System config directory |
| `/usr/share/omarchy` | `/usr/share/apex` | System data directory |
| `OMARCHY_PATH` | `APEX_PATH` | Primary install path variable |
| `omarchy-*` (command prefix) | `apex-*` | All 479 bin/ commands |
| `/var/lib/omarchy` | `/var/lib/apex` | System state directory |
| `/dev/shm/omarchy` | `/dev/shm/apex` | Shared memory paths |
| `omarchy.org` URLs | Apex equivalents | See EXTERNAL_URLS.md |
| `pkgs.omarchy.org` | Apex pacman repo or removed | See UPSTREAM_DEPS.md |
| `linux-omarchy` (kernel) | `linux-apex` or upstream kernel | See PACKAGES_UPSTREAM.md |
| `omarchy-nvim` | `apex-nvim` or upstream nvim config | See PACKAGES_UPSTREAM.md |
| `[omarchy]` pacman section | `[apex]` | pacman.conf repo name |
| Omarchy SDDM theme | Apex SDDM theme | `default/sddm/omarchy/` → `default/sddm/apex/` |
| `agent/skills/omarchy/` | `agent/skills/apex/` | AI agent skill directory |
| `boot/EFI/Linux/omarchy` | `boot/EFI/Linux/apex` | EFI binary path |

---

## Selective Non-Replacements

These occurrences should be **preserved verbatim** as they refer to upstream
projects, not to Omarchy itself:

| Pattern | Location | Reason to keep |
|---|---|---|
| `github.com/basecamp/omarchy` | Comments and docs | Attribution to upstream source |
| `https://37signals.com` | Comments | Attribution |
| `THIRD_PARTY_NOTICES.md` | Root | Legal attribution |
| References in `reference/` | All of `reference/` | Read-only upstream mirror |

---

## Environment Variables (OMARCHY_*) — Full Unique List

The 323 unique `OMARCHY_*` variable names (sample; see full grep output):

Core runtime: `OMARCHY_PATH`, `OMARCHY_INSTALL`, `OMARCHY_INSTALL_USER`,
`OMARCHY_INSTALL_LOG_FILE`, `OMARCHY_INSTALL_DEBUG`, `OMARCHY_FIRST_INSTALL`,
`OMARCHY_SETUP_CONTEXT`, `OMARCHY_BIN_DIR`, `OMARCHY_CONF`

User setup form: `OMARCHY_USER_NAME`, `OMARCHY_USER_EMAIL`,
`OMARCHY_KEYBOARD_LAYOUTS`, `OMARCHY_HOSTNAME_DEFAULT`,
`OMARCHY_HOSTNAME_PATTERN`, `OMARCHY_FORM_BACK`, `OMARCHY_FORM_SIGNAL`

Hardware testing: `OMARCHY_SYNAPTIC_INPUT_DEVICES`, `OMARCHY_DRM_PATH`,
`OMARCHY_BACKLIGHT_PATH`, `OMARCHY_BRCMFMAC_CONF`, `OMARCHY_DOCKER_SOCKET`,
`OMARCHY_NVIDIA_MODPROBE_CONFIG`

Acceptance tests: `OMARCHY_ACCEPTANCE_DIR`, `OMARCHY_ACCEPTANCE_BOOT_TIMEOUT`,
`OMARCHY_ACCEPTANCE_SSHD_KEY`, `OMARCHY_ACCEPTANCE_SUDO_PASSWORD`

ISO/provision: `OMARCHY_ISO_PATH`, `OMARCHY_DEFER_REBOOT`, `OMARCHY_MIRROR_URL`,
`OMARCHY_REPO_URL`, `OMARCHY_RAW_URL`, `OMARCHY_GIT_URL`

> All 323 variable names will be renamed `APEX_*` by `scripts/rebrand.sh`.
