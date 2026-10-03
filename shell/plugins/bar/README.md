# Apex bar

This is the Quickshell implementation of the Apex status bar. It is
shipped as a first-party plugin of [`apex-shell`](../../README.md), the
long-running shell host. The bar is mounted at startup and lives inside
the shell for its whole session.

- `manifest.json` declares the plugin (`id: apex.bar`, `kind: bar`) and points at `Bar.qml` as the entry point.
- `Bar.qml` is Apex-owned bar engine code, loaded by the apex-shell host. Users should not edit it directly.
- `widgets/` holds simple first-party bar widgets with sibling manifests.
- Feature plugins such as `../panels/audio/`, `../panels/network/`, `../panels/power/`, and `../agents/` provide richer popup bar plugins.
- The bar receives its config from the host shell as a `barConfig` property; the host loads it from `~/.config/apex/shell.json` (or `config/apex/shell.json` when the user has no file).
- `apex bar position` updates only the user shell.json file.

## Customizing

The bar config lives under the `bar:` key of [`~/.config/apex/shell.json`](../../../docs/apex-shell.md#shelljson). Out of the box the shell uses [`config/apex/shell.json`](../../../config/apex/shell.json). Once you customize anything via the bar gestures, `apex bar ...`, or by editing shell.json directly, your file is canonical — there is no deep-merge.

The bar is configured directly on the bar itself: drag empty bar space (or click-and-hold) to move the bar to another screen edge, double-left-click empty center-bar space to toggle transparency, and drag widgets to reorder them. The `apex bar position`, `apex bar transparent`, `apex bar move`, and `apex bar set` commands do the same from scripts. Enable or disable widgets with `apex plugin enable` and `apex plugin disable` (widget ids come from `apex plugin list`).

Example `shell.json` (bar subtree only shown):

```json
{
  "version": 1,
  "bar": {
    "position": "top",
    "transparent": false,
    "centerAnchor": "apex.clock",
    "layout": {
      "left": [
        { "id": "apex.menu" },
        { "id": "apex.spacer", "size": 12 },
        { "id": "apex.workspaces" }
      ],
      "center": [
        { "id": "apex.media" },
        { "id": "apex.clock", "format": "HH:mm" }
      ],
      "right": [
        { "id": "apex.audio" },
        { "id": "apex.power" }
      ]
    }
  }
}
```

`centerAnchor` pins one center module to the exact horizontal/vertical center and flanks others around it. Set to an empty string to disable anchoring (the center list is centered as a group).

## Module catalogue

### First-party interactive widgets

| Name | What it does | Interactions |
|---|---|---|
| `apex.menu` | Apex menu launcher | left = menu · right = terminal |
| `apex.workspaces` | Hyprland workspace switcher | left = focus workspace |
| `apex.clock` | Date/time label + popup with a month grid, ISO week numbers, and month stepping | left = popup · right = cycle label format · middle = timezone selector |
| `apex.media` | MPRIS now-playing — scrolling track + artist, cover-art popup | left = play/pause · middle = next · scroll = prev/next · right = popup |
| `apex.indicators` | Manual state indicators | left = indicator action |
| `apex.system-update` | Available update indicator | left = update |
| `apex.tray` | System tray | hover = reveal drawer · right on chevron = manage |
| `apex.weather` | Weather icon + popup with forecast | left = popup · right = full notification |
| `apex.microphone` | Mic icon + scroll volume | left = mute toggle · middle = audio panel · scroll = source volume |

| `apex.audio` | Volume icon + popup with master slider, output-device picker, per-app mixer | left = popup · right = mute · middle = popup · scroll = volume |
| `apex.network` | Wi-Fi/Ethernet icon + popup with Wi-Fi scan, signal, connect, DNS provider selection | left = popup |
| `apex.tailscale` | Tailscale status, connection switcher, machine browser, and copy actions | left = popup · right = toggle · middle = refresh |
| `apex.agents` | AI coding agent limits with pace, today, last week, and all-time model breakdown | left = panel · right = launch agent · middle = next subscription |
| `apex.power` | Battery/AC icon + popup with battery stats, power profiles, and system info | left = popup · right = toggle percentage |
| `apex.bluetooth` | Bluetooth icon + popup with device list, connect/disconnect, battery | left = popup · right = toggle radio |
| `apex.monitor` | Brightness and laptop display controls | left = popup |

The `apex.indicators` widget loads individual bar indicators from `indicators/`. Omit `items` (or set it to an empty array) to show all indicators in the default order, or set `items` to a subset such as `["Dnd", "Reminder", "NightLight"]`. Set `alwaysShow` to `true` to keep inactive indicators visible instead of revealing them only on hover. Multiple `apex.indicators` instances are allowed, so different sections can show different subsets.

## Orientation

All widgets work in `top`, `bottom`, `left`, and `right` positions. Popups anchor on the side opposite the bar edge, sliding into the workspace. Vertical bars use 28px width; widgets that show text fall back to compact icon-only forms (e.g. `media` hides its scrolling label).

## Custom user modules

The schema accepts arbitrary module ids that you provide. Set `type` to `command` for shell-driven output or `qml` for a custom QML widget. Both still go under `bar.layout.<section>` in `shell.json`.

Command module:

```json
{
  "version": 1,
  "bar": {
    "layout": {
      "right": [
        { "id": "apex.tray" },
        { "id": "vpn", "type": "command", "exec": "~/.config/apex/bar/scripts/vpn-status", "interval": 5, "tooltip": "VPN", "onClick": "nm-connection-editor" },
        { "id": "apex.audio" }
      ]
    }
  }
}
```

The command may print plain text or Waybar-style JSON, for example:

```json
{"text":"󰌆","tooltip":"Work VPN","class":"active"}
```

QML module:

```json
{
  "version": 1,
  "bar": {
    "layout": {
      "right": [
        { "id": "gpu", "type": "qml" },
        { "id": "apex.audio" }
      ]
    }
  }
}
```

Then create `~/.config/apex/bar/modules/gpu.qml`. If you want to store it elsewhere, add a `source` path.

Custom QML modules should be an `Item` with `implicitWidth` and `implicitHeight`. They may optionally define these properties, which the bar fills after loading:

```qml
import QtQuick

Item {
  property var bar
  property string moduleName
  property var settings

  implicitWidth: 28
  implicitHeight: bar ? bar.barSize : 26

  Text {
    anchors.centerIn: parent
    text: "GPU"
    color: bar ? bar.foreground : "white"
    font.family: bar ? bar.fontFamily : "monospace"
    font.pixelSize: 12
  }

  MouseArea {
    anchors.fill: parent
    onClicked: if (bar) bar.run("apex-launch-or-focus-tui btop")
  }
}
```

## Bar properties available to widgets

Widgets receive `bar` (the shell root), `moduleName` (string), and `settings` (object) injected at load time. The bar exposes:

- `bar.foreground`, `bar.background`, `bar.urgent` — theme colors (live-updated)
- `bar.fontFamily` — current monospace family
- `bar.position` — `"top" | "bottom" | "left" | "right"`
- `bar.vertical` — boolean shortcut
- `bar.barSize` — 26 horizontal / 28 vertical
- `bar.run(command)` — fire-and-forget bash exec (quote arguments with `Util.shellQuote` from `qs.Commons`)
- `bar.showTooltip(target, text)` / `bar.hideTooltip(target)` — shared tooltip popup
- `bar.requestPopout(owner)` / `bar.releasePopout(owner)` — one-popup-at-a-time coordinator

First-party bar widgets are manifest-backed just like third-party widgets.
Simple widgets carry sibling manifests such as `widgets/Workspaces.manifest.json`;
richer popup plugins live in feature directories such as `../panels/audio/`,
`../panels/network/`, and `../agents/`; and feature plugins such as
`apex.menu` and `apex.media` declare their bar-widget entry points in their own
`manifest.json`. Bar layout ids are namespaced, e.g. `apex.audio`,
`apex.network`, and `apex.clock`.

Third-party widgets ship as separate plugins under `~/.config/apex/plugins/<plugin-id>/` with their own `manifest.json` declaring `kinds: ["bar-widget"]` and a `barWidget` entry point. See the [shell reference](../../../docs/apex-shell.md#plugin-manifest) for the manifest schema. Rescan, enable, and place third-party plugins with `apex-shell shell rescanPlugins`, `apex plugin enable`, and `apex bar move`.
