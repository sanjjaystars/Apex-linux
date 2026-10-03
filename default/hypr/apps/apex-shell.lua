-- Window and layer rules for the Apex Quickshell surfaces. The
-- shell-wide bar / menu / popouts are layer-shell.

-- Keep the bar instant: no layer-shell fade/slide animation.
hl.layer_rule({ match = { namespace = "apex-bar" }, no_anim = true, animation = "none" })

-- Launcher, image selector, emojis, clipboard overlays, the OSD, reminders, the
-- Wi-Fi QR code and keyboard-driven panels should pop without compositor layer
-- animations. The overlays stay mapped between opens and grow from a parked
-- 1x1 when shown, which Hyprland would otherwise animate as a slide in from
-- the corner. Panels keep their own QML opacity transition for normal
-- open/close, and skip it for panel handoff.
hl.layer_rule({ match = { namespace = "^(apex-menu|apex-image-selector|apex-emojis|apex-clipboard|apex-keyboard-panel|apex-osd|apex-reminders|apex-network-qr)$" }, no_anim = true, animation = "none" })

-- Dev gallery is the main shell workbench; open it maximized like
-- SUPER+ALT+F so component previews have the whole workspace.
o.window({ class = "^org.quickshell$", title = "^Apex shell – dev gallery$" }, { maximize = true })
