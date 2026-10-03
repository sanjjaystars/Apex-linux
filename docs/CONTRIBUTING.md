# Contributing to Apex Linux

Thank you for your interest in contributing to **Apex Linux**!

Apex Linux is an independent Linux distribution based on Arch Linux and inspired by Omarchy. We welcome contributions ranging from bug fixes and documentation improvements to new desktop themes and tool integrations.

---

## 1. Code of Conduct & Core Principles

- **Independence & Clean Branding**: Apex Linux is strictly independent. No upstream trademarks, logos, or unlocalized URLs are permitted. All codebase references must use `Apex` / `apex` / `APEX`.
- **Transparency & Attribution**: We honor upstream lineage through clear, respectful third-party attribution in `README.md` and `THIRD_PARTY_NOTICES.md`.
- **System Stability & Safety**: Destructive system operations (formatting, disk partitioning) must always require explicit confirmation guards.

---

## 2. Repository Layout

```
apex-linux/
├── bin/            # Apex CLI commands (apex-*, routed via bin/apex)
├── config/         # Default user configurations copied to ~/.config/
├── default/        # Shared system defaults (themes, fonts, branding)
├── docs/           # Architecture, installation, and reference documentation
├── install/        # Modular installation stages and package specifications
├── iso/            # Archiso profile, boot configs, and live guided installer
├── migrations/     # Versioned state migration scripts (timestamp-based)
├── shell/          # Quickshell Wayland desktop UI and widgets
├── themes/         # Desktop themes (colors.toml, wallpapers, previews)
└── tests/          # Quality assurance test suites (name leaks, shellcheck)
```

---

## 3. Coding Guidelines & Style

### 3.1 Shell Scripting (`bin/`, `install/`, `tests/`)
- **Shebang**: Use `#!/bin/bash` exclusively (never `#!/usr/bin/env bash`).
- **Conditionals**: Use Bash 5 `[[ ... ]]` for string and file tests; use `(( ... ))` for numeric comparisons.
- **Variable Quoting**: Always quote paths and string variables (e.g., `"$APEX_PATH/bin"`). Do not quote unexpanded variables inside `[[ ]]` when testing strings.
- **Indentation**: Two spaces, no tabs.
- **Command Naming**: Commands in `bin/` follow the `apex-<group>-<action>` convention.
- **Metadata Headers**: Every user command in `bin/` must start with metadata tags:
  ```bash
  #!/bin/bash

  # apex:group=cmd
  # apex:summary=One-line clear description of what this command does
  # apex:args=[optional-args]
  # apex:examples=apex example
  ```

### 3.2 Themes (`themes/`)
- Every theme directory must provide:
  - `colors.toml`: Complete 26-variable palette definition conforming to `docs/THEMES.md`.
  - `wallpaper.png`: 1920x1080 desktop wallpaper (must be procedurally generated or original, no third-party copyrighted art).
  - `preview.png`: 320x180 theme switcher card.

---

## 4. Quality Gates & Pre-Commit Verification

Before submitting changes, all contributions must pass our automated quality gates:

1. **Check for Name Leaks**:
   Ensure zero accidental upstream brand leaks remain:
   ```bash
   ./tests/check-name-leaks.sh
   ```
   *Must report 0 leaks.*

2. **Shellcheck Linting**:
   Ensure zero syntax or runtime errors:
   ```bash
   shellcheck -s bash --severity=error $(git ls-files "*.sh" "bin/apex-*")
   ```

3. **Theme Validation**:
   If modifying themes:
   ```bash
   ./tests/check-themes.sh
   ```

4. **Run Master Test Runner**:
   ```bash
   ./tests/run-all.sh
   ```

---

## 5. Submitting Changes

1. Fork the repository on GitHub.
2. Create a feature branch:
   ```bash
   git checkout -b feature/my-enhancement
   ```
3. Keep commits atomic and self-contained with concise commit messages:
   ```bash
   git commit -m "feat(audio): add fine volume stepping helper"
   ```
4. Push your branch to GitHub and open a Pull Request.
5. Ensure your PR description details the motivation and tests performed.
