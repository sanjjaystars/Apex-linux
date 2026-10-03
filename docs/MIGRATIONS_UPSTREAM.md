# docs/MIGRATIONS_UPSTREAM.md — Upstream Omarchy Migrations System

**Source:** `reference/omarchy/bin/omarchy-migrate`, `reference/omarchy/migrations/`
**Date:** 2026-10-03
**Total migrations:** 137 (filenames confirmed by `ls migrations/ | wc -l`)

---

## Mechanism

Migrations are numbered shell scripts in `$OMARCHY_PATH/migrations/` named
`<unix-timestamp>.sh`. They run in ascending timestamp order via `omarchy-migrate`.

**Runner logic (`bin/omarchy-migrate`):**
1. Waits for any active pacman transaction (`/var/lib/pacman/db.lck`) — up to 900 seconds.
2. For each `migrations/*.sh` file in sorted order, checks for a marker file at
   `~/.local/state/omarchy/migrations/<filename>`.
3. If the marker does not exist, runs the script with `bash -euo pipefail`.
4. On success, creates the marker file (idempotency: a migration runs exactly once per user).
5. If a migration fails, it is not marked and will retry on the next login (triggered by
   `omarchy-migrate-notify`, a systemd user unit).

`omarchy-migrate --pending` lists migration filenames that have not yet run (exits 0 if any pending, 1 if all done).

**State directory:** `~/.local/state/omarchy/migrations/` (one marker file per
completed migration; overrideable via `$OMARCHY_MIGRATION_STATE`).

**Fresh installs:** All migrations are marked complete at provisioning time
(`omarchy-provision-user` / `finalize-user`), so a new install never re-runs
historical migrations.

---

## All 137 Migrations (ascending timestamp = chronological order)

| Filename | Description |
|---|---|
| `1778623107.sh` | Install MPRIS support for mpv |
| `1780057136.sh` | Make Shift+Enter distinguishable for terminals and Codex |
| `1780294774.sh` | Remove leading zero from bar clock date |
| `1780517689.sh` | Add yt-dlp download extension to Chromium-based browsers |
| `1780739888.sh` | Use dua for Disk Usage TUI |
| `1781043107.sh` | Move current Omarchy theme state to ~/.local/state |
| `1781063758.sh` | Update Hyprland Lua entrypoint to load Omarchy bootstrap |
| `1781158082.sh` | Relink Neovim theme to Omarchy current state |
| `1781286586.sh` | Replace Satty with Tensaku |
| `1781485962.sh` | Move stock Hyprland user overrides into package defaults |
| `1781587663.sh` | Enable secure remote Neovim clipboard support |
| `1781793381.sh` | Auto-mount removable drives by default with udiskie |
| `1781984677.sh` | Normalize Snapper snapshot services |
| `1782002156.sh` | Retire systemd-networkd in favor of NetworkManager |
| `1782049344.sh` | Disable Limine Snapper warning notifier |
| `1784401744.sh` | Backfill hardware support and tmux settings added before Omarchy quattro |
| `1784476564.sh` | Keep non-Latin keyboard layouts out of the initramfs so the LUKS passphrase stays typeable |
| `1784479832.sh` | Enable Kitty cwd lookup through a remote control socket |
| `1784508556.sh` | Pin browser password store to gnome-libsecret (prevents cookie/login loss on Hyprland) |
| `1784510887.sh` | Switch Brave Origin from the beta to the stable release |
| `1785002349.sh` | Repair Neovim theme symlinks the earlier relink missed |
| `1785013000.sh` | Move zram tuning to a vendor drop-in |
| `1785090473.sh` | Repair fingerprint support left without a libfprint |
| `1785095882.sh` | Only check for pending migrations at login, not on every package update |
| `1785101000.sh` | Save incoming Taildrop files to ~/Downloads |
| `1785166747.sh` | Register the native messaging hosts for the bundled Chromium extensions |
| `1785167800.sh` | Supervise fcitx5 so CapsLock compose sequences can't silently die |
| `1785189600.sh` | Remove the tmux alert hooks and its bar indicator |
| `1785273276.sh` | Rename the T2 Mac BCE module (apple-bce → t2bce) and repair the boot image |
| `1785344985.sh` | Add the agents widget to the bar |
| `1785351479.sh` | Drop Kvantum now that Qt apps follow the theme through the GTK platform theme |
| `1785424256.sh` | Let systemd-oomd kill a runaway app instead of the whole session |
| `1785511354.sh` | Install qrencode for Wi-Fi QR sharing |
| `1785543725.sh` | Add WhatsApp Slim extension to Chromium-based browsers |
| `1785591762.sh` | Add WhatsApp Slim extension to Brave Origin flags for existing installs |
| `1785608166.sh` | Repair the pre-suspend lock monitor's graphical session environment |
| `1785608251.sh` | Install ddcutil for external monitor brightness control |
| `1785617047.sh` | Install oh-my-pi (omp) via mise wrapper |
| `1785633225.sh` | Speed up mouse scrolling in foot |
| `1785637426.sh` | Replace GNOME Calculator with Omacalc |
| `1785846769.sh` | Install default coding agent mise wrappers |
| `1785944594.sh` | Update T2 Mac suspend, Touch Bar, and fan defaults |
| `1786098807.sh` | Relink agent skill symlinks to default/agents/skills/omarchy |
| `1786099804.sh` | Rename the model usage widget to agents and prime its data files |
| `1786137597.sh` | Re-run the T2 defaults migration that a broken hardware check skipped |
| `1786181929.sh` | Give SSH commands the user-level tool paths via the PAM environment |
| `1786183928.sh` | Refresh mise stubs so tools take new releases immediately |
| `1786273938.sh` | Install herdr from the Omarchy package repo and seed its config |
| `1786278735.sh` | Detect dropped SSH connections quickly instead of leaving terminals hung |
| `1786279107.sh` | Add the keyboard layout widget to the bar |
| `1786355450.sh` | Replace terminaltexteffects with ttfx |
| `1786380259.sh` | Remember Bluetooth on and off through the rfkill soft block |
| `1786386460.sh` | Generate image picker thumbnails with libvips |
| `1786391100.sh` | Run the WPA handshake in software on Macs with Broadcom Wi-Fi |
| `1786447584.sh` | Install QR code scanning support |
| `1786451567.sh` | Repair theme symlinks the state-move migration left dangling |
| `1786482992.sh` | Rebuild the boot image when it predates the Limine kernel command line |
| `1786517850.sh` | Drop the retired notification image cache |
| `1786539345.sh` | Announce process crashes and offer an AI diagnosis |
| `1786549201.sh` | Invite existing installs to pick a default agent |
| `1786567036.sh` | Unmask wpa_supplicant so NetworkManager can bring wifi back |
| `1786605598.sh` | Rebuild the initramfs so NVIDIA-only systems shed nouveau's unused GSP firmware |
| `1786609204.sh` | Native video dependencies are superseded by the OWE migration |
| `1786643346.sh` | Repair the Copy URL shortcut for profiles that predate its pinned extension id |
| `1786719479.sh` | Replace the Gemini coding agent with Antigravity |
| `1786782461.sh` | Remove the literal \n[text-bindings] line an earlier migration wrote into foot.ini |
| `1786952219.sh` | Switch mise to the mise-bin package from the Omarchy repo |
| `1787133200.sh` | Add webp decoding to the shell |
| `1787215483.sh` | Stop mise upgrades from pruning versions still in use |
| `1787215824.sh` | Install hey (hey-cli) via mise wrapper |
| `1787342993.sh` | Install ori (OpenRouter's agent harness) via mise wrapper |
| `1787399318.sh` | Switch back to the packaged quickshell now that 0.3.1 kills synchronously |
| `1787481315.sh` | Re-stage the current theme so an installed theme's code is dropped |
| `1787494718.sh` | Take ownership of the FIDO2 authfile so it cannot be rewritten without root |
| `1787515927.sh` | Stop world-writable Chromium and Firefox policy directories |
| `1787573629.sh` | Regenerate mise wrappers that still print mise's own output to stdout |
| `1787580187.sh` | Move this install to the opt-in docker group default |
| `1787589206.sh` | Require signed packages from the Omarchy repository |
| `1787618700.sh` | Store Hyprland input-device names as data instead of generated Lua |
| `1787666837.sh` | Enable Dell XPS 13 sidecar speaker amplifiers |
| `1787691200.sh` | Skip Chromium's new first-run EULA on machines already on Quattro |
| `1787760281.sh` | Install the Hermes CLI wrapper for existing installs |
| `1787815267.sh` | Separate printer discovery from root and print-filter access |
| `1787843905.sh` | Link Omarchy agent skills into Hermes skill directories |
| `1787865477.sh` | Drop the default input group grant, which allowed unprivileged keylogging |
| `1788009111.sh` | Temporarily remove automatic printer discovery |
| `1788025225.sh` | Remove privileged files left behind by retired Omarchy installers |
| `1788102906.sh` | Repair legacy XCompose and remove vulnerable Omarchy 3 power udev rules |
| `1788112314.sh` | Point rc-channel installs at the rc package repository |
| `1788124236.sh` | Disable SSH password authentication, or sshd itself when no key is authorized |
| `1788129995.sh` | Replace Satty and Tensaku with Omasnap |
| `1788163635.sh` | Remove legacy temporary passwordless sudo grants |
| `1788279117.sh` | Replace the YT6801 vendor DKMS driver with the upstream kernel driver |
| `1788577553.sh` | Install Cursor CLI via mise wrapper |
| `1788595060.sh` | Register the Chromium extension native messaging hosts for Brave Origin |
| `1788596255.sh` | Add vi as a standard terminal editor |
| `1788619462.sh` | Hand Hermes Desktop the Omarchy theme as a skin |
| `1788662350.sh` | Repair user-owned system-sleep hooks and hybrid GPU service configuration |
| `1788724825.sh` | Install Muse Code via mise wrapper |
| `1788745941.sh` | Update Kitty configuration |
| `1788848726.sh` | Retire the stock user icon font missed by the Quattro upgrade |
| `1788862626.sh` | Expose the Elgato Cam Link 4K as a 16:9 virtual camera |
| `1788941927.sh` | Install basecamp (basecamp-cli) via mise wrapper |
| `1788996284.sh` | Repair remote Neovim clipboard yanks and paste |
| `1789091250.sh` | Activate the Omarchy theme for existing T3 Code installs |
| `1789095456.sh` | Remove automatic project bin directories from PATH |
| `1789130779.sh` | Keep the KEF LSX II LT USB sink from suspending |
| `1789294350.sh` | Switch TCP congestion control to BBR with fq pacing |
| `1789310715.sh` | Install cf (Cloudflare CLI) via mise wrapper |
| `1789325478.sh` | Install the Omarchy kernel and make it the first Limine boot entry |
| `1789444024.sh` | Install missing headers for the Omarchy or T2 kernel |
| `1789764927.sh` | Enable OWE desktop video backgrounds and lock feed |
| `1790017600.sh` | Retire the Hermes that mise built; Hermes now updates itself |
| `1790042972.sh` | Put Elsewhen, the world clock, on the bar |
| `1790282866.sh` | Apply the NVIDIA video driver fix on hybrid laptops |
| `1790397381.sh` | Move OpenClaw to a self-updating install under ~/.openclaw |
| `1790457067.sh` | Loosen the offline install's exact Node pin so mise up tracks new releases |
| `1790528634.sh` | Move Elsewhen, the world clock, into Omarchy as omarchy.elsewhen |
| `1790539857.sh` | Install Monologue, the webcam recorder |
| `1790542069.sh` | Install Hype, the Markdown presentation app |
| `1790702362.sh` | Install the compiler and Qt pieces for building Omarchy-style apps |
| `1790702606.sh` | Link the omarchy-app agent skill for building apps |
| `1790863209.sh` | Install Grok through mise's first-party package |

> All 137 migration first lines confirmed by `head -2` in this session.

---

## Apex Rebrand Impact

- Migrations reference `$OMARCHY_PATH`, `$HOME/.local/state/omarchy/migrations/`,
  and `omarchy-*` commands throughout.
- All 137 migrations will be copied to `migrations/` in the Apex tree.
- The rebrand script will rename: `OMARCHY_PATH` → `APEX_PATH`, state paths, command prefixes.
- Migration timestamps are preserved (they are Unix epoch seconds).
- Fresh Apex installs will mark all upstream migrations complete at provisioning time
  (same as upstream) so they never re-run on new machines.
- Apex-specific migrations start at a new timestamp (at or after the current upstream HEAD).
