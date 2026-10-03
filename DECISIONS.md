# DECISIONS.md – record non‑obvious choices


- Default branch is main.
- Host is macOS arm64; Arch-only steps (pacman, mkarchiso, QEMU) are UNTESTED here.
- Scripts must be GNU/Linux compatible; rebrand.sh must use perl or python3, not BSD sed.
- License holder: Sanjjay (Copyright (c) 2026 Sanjjay). Upstream MIT notice goes in THIRD_PARTY_NOTICES.md.
- qemu and archiso skipped on the Mac; they need an x86_64 Arch machine.
- Rebrand dry-run surprises: (1) 564 items renamed, 1323 files modified (14,652 occurrences); (2) 21 theme wallpaper files named *omarchy*.webp excluded during copy in T2.3 and replaced by gradient generator; (3) Binary assets protected via extension blacklist and NUL-byte check; (4) GitHub and raw URL paths mapped to sanjjaystars/Apex-linux.
