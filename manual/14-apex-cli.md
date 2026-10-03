# Apex CLI

Apex is usually controlled through the hotkeys and the Apex menu (`Super + Space`). But you can also control it through the `apex` CLI. This is particularly helpful when you're having an AI agent work with you on customization or configuration.

The CLI has access to all the internal tooling that is used both via the menu and otherwise. You can see everything that's available by running `apex` in the terminal.

It looks something like this:

```
~ ❯ apex
Apex command center

Usage:
  apex <command> [args...]
  apex commands [--all] [--json] [--check]
  apex <group> --help
  apex <group> <command> --help

Common commands:
  apex update              Update Apex and system packages
  apex theme list          List available themes
  apex theme set <name>    Apply a theme
  apex font list           List available fonts
  apex screenshot          Take a screenshot
  apex debug               Print debugging information

Groups:
  agent          AI coding agents, their usage, and subscription accounts
  audio          Audio input and output controls
  bar            Apex shell bar layout and settings
  battery        Battery status helpers
  bluetooth      Bluetooth device controls
  branch         Apex git branch management
  branding       About and screensaver branding
  brightness     Display and keyboard brightness
  capture        Screenshots and screen recording
  channel        Apex release channel management
  clipboard      Clipboard helpers
  cmd            Command and shortcut helpers
  config         System configuration helpers
  debug          Diagnostics and support logs
  ...
```

And you can dive deeper on every group:

```
~ ❯ apex capture
Capture commands — Screenshots and screen recording:
  apex capture qr                                                                                                                                                                                                       Decode a QR code from a screenshot region
  apex capture screenrecording [--fullscreen] [--with-desktop-audio] [--with-microphone-audio] [--with-webcam] [--webcam-device=<device>] [--webcam-size=<small|medium|large>] [--resolution=<size>] [--stop-recording]  Start or stop screen recording
  apex capture screenrecording with webcam                                                                                                                                                                              Pick a webcam and start a screen recording with it
  apex capture screenshot [smart|region|windows|fullscreen|scroll] [copy|save]                                                                                                                                          Take a screenshot
  apex capture text                                                                                                                                                                                                     Extract text from a screenshot region with OCR
  apex capture webcam resize <smaller|larger|reset|small|medium|large>                                                                                                                                                  Resize the active webcam recording overlay
```

Every command takes `--help` too, whether you ask a whole group (`apex capture --help`) or a single command (`apex capture screenshot --help`).

### Opening the menu from the terminal

The Apex menu is scriptable as well, which is handy for your own keybindings. `apex menu` opens it at the root, and you can jump straight to any point in the tree by naming it: `apex menu summon style.theme` goes right to the theme picker, `apex menu toggle system` opens the system menu and closes it again if it's already up, and `apex menu close` puts it away.
