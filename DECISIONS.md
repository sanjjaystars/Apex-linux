# DECISIONS.md – record non‑obvious choices


- Default branch is main.
- Host is macOS arm64; Arch-only steps (pacman, mkarchiso, QEMU) are UNTESTED here.
- Scripts must be GNU/Linux compatible; rebrand.sh must use perl or python3, not BSD sed.
- License holder: Sanjjay (Copyright (c) 2026 Sanjjay). Upstream MIT notice goes in THIRD_PARTY_NOTICES.md.
- qemu and archiso skipped on the Mac; they need an x86_64 Arch machine.
