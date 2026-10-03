# Apex Linux Release Checklist

This document specifies the step-by-step verification and release checklist for publishing stable releases of **Apex Linux**.

---

## 1. Pre-Release Verification Gates

Before cutting a release tag or building distribution ISOs:

- [ ] **Working Tree Status**:
  ```bash
  git status --short
  ```
  *Working tree must be completely clean with zero untracked or uncommitted files.*

- [ ] **Master Quality Gate Suite**:
  ```bash
  ./tests/run-all.sh
  ```
  *All 5 suites (name leaks, packages, themes, shellcheck, ISO dry-run) must report 100% PASS.*

- [ ] **Documentation & Attribution**:
  - [ ] `README.md` contains required attribution statement.
  - [ ] `THIRD_PARTY_NOTICES.md` is complete and up to date.
  - [ ] `CHANGELOG.md` documents all features and fixes under the release header.

---

## 2. Git Version Tagging

1. Ensure you are on the `main` branch:
   ```bash
   git checkout main
   git pull
   ```

2. Create an annotated and signed Git tag:
   ```bash
   git tag -a v1.0.0 -m "Apex Linux 1.0.0 Release"
   ```

3. Verify tag signature and commit:
   ```bash
   git show v1.0.0
   ```

4. Push tag to the remote repository:
   ```bash
   git push origin v1.0.0
   ```

---

## 3. ISO Build & Artifact Checksums

On the Arch Linux build workstation:

1. Build the production ISO image:
   ```bash
   sudo ./iso/build-iso.sh --clean --out-dir iso/out
   ```

2. Confirm output files in `iso/out/`:
   - `apex-linux-<version>-x86_64.iso`
   - `apex-linux-<version>-x86_64.iso.sha256`

3. Generate and verify SHA256 checksum file:
   ```bash
   cd iso/out
   sha256sum apex-linux-*.iso > sha256sums.txt
   sha256sum -c sha256sums.txt
   ```

4. (Optional) Sign the checksum file using GPG:
   ```bash
   gpg --detach-sign --armor sha256sums.txt
   ```

---

## 4. QEMU Smoke Test

Before publishing the artifacts, perform a live boot test:
```bash
sudo ./tests/iso-smoke-test.sh
```
Verify:
- Bootloader menu displays Apex branding.
- Virtual terminal autologin displays ANSI logo MOTD.
- `./install.sh` launches guided installer without errors.

---

## 5. GitHub Release Publishing

1. Navigate to GitHub Releases: `https://github.com/sanjjaystars/Apex-linux/releases/new`
2. Select tag: `v1.0.0`
3. Release Title: `Apex Linux 1.0.0`
4. Copy the release notes section from `CHANGELOG.md`.
5. Attach distribution assets:
   - `apex-linux-<version>-x86_64.iso`
   - `sha256sums.txt`
   - `sha256sums.txt.asc` (if signed)
6. Publish Release.
