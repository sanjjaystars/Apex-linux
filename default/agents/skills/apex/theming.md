# Themes, Backgrounds, and Fonts

Read this before changing themes, backgrounds, fonts, or theme colors.

## Theme Commands

```bash
apex theme list              # Show available themes
apex theme current           # Show current theme
apex theme set <name>        # Apply theme ("Tokyo Night" and "tokyo-night" both work)
apex theme bg next           # Cycle background
apex theme install <url>     # Install from git repo
```

## Making a New Theme

1. Create a directory under `~/.config/apex/themes`.
2. See how an existing theme is done via `/usr/share/apex/themes/catppuccin`.
3. Download a matching background (or several) from the internet and put them in `~/.config/apex/themes/<name-of-new-theme>/backgrounds/`.
4. When done with the theme, run `apex theme set "Name of new theme"`.

Additional user backgrounds for any theme (stock or custom) go in
`~/.config/apex/backgrounds/<theme-slug>/`.

## What a Theme Installed From a Repo May Not Contain

A theme the user wrote by hand in `~/.config/apex/themes` is unrestricted, as
are Apex's own themes. From a theme cloned by `apex theme install`, Apex
drops only what runs code: any `*.lua` (Hyprland requires a theme's
`hyprland.lua` and `gum_env.lua` at login, Neovim loads `neovim.lua` at startup),
the terminal configs `alacritty.toml`, `foot.ini`, `ghostty.conf` and
`kitty.conf` (each names the program the terminal launches), and `vscode.json`
(names a VS Code extension to install). Those are regenerated from `colors.toml`
through `$APEX_PATH/default/themed/*.tpl`, and named on stderr.

Everything else a cloned theme ships is kept, including `btop.theme`,
`chromium.theme`, `helix.toml`, `icons.theme`, `keyboard.rgb` and `shell.toml`.
Apex tells a cloned theme from the user's own by the `.git` directory a clone
leaves behind.

To change how Apex themes an app for every theme, write the template rather
than the theme: `~/.config/apex/themed/<config-name>.tpl` overrides the
built-in one. See `docs/theming.md` in the Apex repo.

## Customizing a Stock Theme

Never edit stock themes under `/usr/share/apex/themes/` — changes are lost
on update. Two safe options:

Both write into `~/.config/apex/themes`, where a theme the user wrote is
unrestricted — the list above applies only to a theme cloned from a repo.

**Overlay (preferred for small tweaks):** create a user theme directory with
the SAME slug containing only the files you want to change. When the theme is
applied, the stock theme is copied first and your files win on top:

```bash
mkdir -p ~/.config/apex/themes/catppuccin
cp /usr/share/apex/themes/catppuccin/colors.toml ~/.config/apex/themes/catppuccin/
# Edit the copied colors.toml, then re-apply:
apex theme set catppuccin
```

**Fork:** copy the whole stock theme under a new name for a fully independent
variant:

```bash
cp -r /usr/share/apex/themes/catppuccin ~/.config/apex/themes/catppuccin-custom
# Edit ~/.config/apex/themes/catppuccin-custom/, then:
apex theme set catppuccin-custom
```

## Fonts

```bash
apex font list               # Available fonts
apex font current            # Current font
apex font set <name>         # Change font
```
