# Apex Shell: Bar, Plugins, and Idle

Read this before changing the status bar, notifications, shell plugins,
widgets, or idle/lock behavior.

The bar, notification daemon, settings panel, and assorted overlays all run
inside a single long-running Quickshell process (`apex-shell`).

```
~/.config/apex/shell.json             # User overrides: bar, plugins, idle
~/.config/apex/plugins/<plugin-id>/   # User-owned shell plugins
$APEX_PATH/config/apex/shell.json  # Canonical defaults
```

The shell hot-reloads `shell.json` on save — no restart needed for layout
changes. `idle.screensaver` and `idle.lock` are seconds since user idle began.

**Commands:** `apex restart shell`, `apex refresh shell`

## Bar Layout

Use the `apex bar` group to move and manage widgets:

```bash
apex bar move apex.clock --section right
```

For layout edits beyond what the commands cover, edit the bar configuration
in `~/.config/apex/shell.json`; it hot-reloads on save.

## Customizing Built-In Plugins and Widgets

To customize a built-in bar widget, never edit `$APEX_PATH/shell/plugins/`.
Clone it into the user plugin directory instead:

```bash
apex plugin clone apex.workspaces
# Edit ~/.config/apex/plugins/<username>.workspaces/; saved changes reload automatically.
```

Cloning switches the bar to the cloned copy (e.g. `<username>.workspaces`),
which is yours to edit and survives updates.

Saving a file anywhere under `~/.config/apex/plugins/` reloads plugin code
automatically. If a change somehow fails to apply, force a reload with
`apex-shell shell rescanPlugins`.

## Idle and Lock

Set `idle.screensaver` and `idle.lock` in `~/.config/apex/shell.json`,
in seconds since user idle began. Example: "lock after ten minutes" means
setting `idle.lock` to `600`.
