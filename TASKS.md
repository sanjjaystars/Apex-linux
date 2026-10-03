# TASKS.md - checklist of all tasks (unchecked)

## STAGE 0: Setup
- [x] T0.1 Create repo skeleton, git init, .gitignore, clone upstream into reference/.
- [x] T0.2 Create TASKS.md, PROGRESS.md, DECISIONS.md, OPEN_QUESTIONS.md.
- [x] T0.3 Detect the environment (OS, is it Arch?, root access?, QEMU available?, internet?) and record it in PROGRESS.md. State what you can and cannot execute here.
- [x] T0.4 Install tooling if possible: shellcheck, shfmt, git, qemu, archiso.

## STAGE 1: Audit (no code changes to Apex yet)
- [x] T1.1 Map upstream's install flow: boot.sh -> install.sh -> each install/ stage. Write docs/AUDIT.md with one paragraph per stage.
- [x] T1.2 List every command in bin/ with a one-line purpose each.
- [x] T1.3 List every config directory and which app it configures.
- [x] T1.4 Extract the complete package list (official vs AUR) into docs/PACKAGES_UPSTREAM.md.
- [x] T1.5 List every external URL and domain upstream uses -> docs/EXTERNAL_URLS.md, marking each: KEEP / REPLACE / REMOVE.
- [x] T1.6 List every occurrence of the name in all case forms and paths: counts per file -> docs/NAME_OCCURRENCES.md.
- [x] T1.7 Document how themes work and how the theme switcher reloads each app.
- [x] T1.8 Document how migrations work.
- [x] T1.9 Document how the ISO is built and how the guided installer works.

## STAGE 2: Rebrand
- [x] T2.1 Write scripts/rebrand.sh with --dry-run (default) and --apply. It renames files/dirs and replaces text in all case forms (omarchy/Omarchy/OMARCHY -> apex/Apex/APEX). It must skip .git and reference/. Dry run prints every change.
- [x] T2.2 Run dry-run, review the output, record surprises in DECISIONS.md.
- [x] T2.3 Copy upstream files into the Apex tree (excluding .git, logos, wallpapers), then run --apply.
- [x] T2.4 Replace upstream-owned URLs with placeholders from default/apex-env.
- [x] T2.5 Fix every path (~/.local/share/apex etc.) consistently. Grep to prove there are zero stray old paths.
- [ ] T2.6 Write tests/check-name-leaks.sh that fails if any case form of the old name remains anywhere except THIRD_PARTY_NOTICES.md. Run it; it must pass.
- [ ] T2.7 Run shellcheck on every script; fix errors.
- [ ] T2.8 Replace branding assets (section 3, L3).
- [ ] T2.9 Rewrite README.md and add LICENSE + THIRD_PARTY_NOTICES.md.

## STAGE 3: Installer hardening
- [ ] T3.1 Make boot.sh minimal, safe and readable (no piped sudo surprises).
- [ ] T3.2 Make every install/ stage idempotent; add the logging convention.
- [ ] T3.3 Separate official and AUR package lists; verify every package name.
- [ ] T3.4 Add pre-flight checks (is Arch, not root, internet, free disk, UEFI).
- [ ] T3.5 Add a final summary screen and a clear failure message with log path.
- [ ] T3.6 Write tests/vm-smoke-test.sh (or document the manual procedure) for a fresh Arch VM; run it if QEMU is available.

## STAGE 4: Themes and visuals
- [ ] T4.1 Define the theme folder contract in docs/THEMES.md (which files, which variables).
- [ ] T4.2 Implement/port apex-theme-set and apex-theme-list; reload every app.
- [ ] T4.3 Create "Apex Dark" plus 3 more themes.
- [ ] T4.4 Write scripts/gen-wallpapers.sh (gradients/shapes only).
- [ ] T4.5 Add theme previews and a docs/THEMES.md gallery table.
- [ ] T4.6 Test: switching through all themes leaves no app with mismatched colors (document the manual checklist; automate what you can).

## STAGE 5: Commands, menu, migrations, updates
- [ ] T5.1 Port and verify each bin/apex-* command. For each: --help works, shellcheck passes, no references to the old name.
- [ ] T5.2 Implement the migrations runner and one sample migration.
- [ ] T5.3 Implement apex-update: snapshot -> pacman update -> migrations -> report.
- [ ] T5.4 Write docs/KEYS.md and the keybinding cheat sheet command.

## STAGE 6: ISO
- [ ] T6.1 Create iso/ from the archiso releng profile; write the package list.
- [ ] T6.2 Brand the boot menu, volume label, splash and MOTD.
- [ ] T6.3 Embed the Apex repo and installer in the live environment.
- [ ] T6.4 Write a guided installer (disk select, LUKS, btrfs subvolumes, snapper, bootloader, user creation). Destructive actions require TEST_TARGET or an explicit interactive confirmation.
- [ ] T6.5 Write iso/build-iso.sh (runs mkarchiso in an Arch environment).
- [ ] T6.6 Build and boot-test in QEMU if possible; otherwise mark UNTESTED and give exact commands.

## STAGE 7: Docs, tests, release
- [ ] T7.1 docs/INSTALL.md, docs/TROUBLESHOOTING.md, docs/CONTRIBUTING.md.
- [ ] T7.2 tests/run-all.sh (shellcheck, name-leak check, package verification).
- [ ] T7.3 Release checklist: version tag, ISO checksums (sha256), changelog.
- [ ] T7.4 Final audit: re-run tests/check-name-leaks.sh and all tests; list everything still UNTESTED or TODO(verify).
