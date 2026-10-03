-- Learn how to configure Hyprland: https://wiki.hypr.land/Configuring/Start/

-- Apex's bootstrap keeps path setup out of this user config.
dofile((os.getenv("APEX_PATH") or "/usr/share/apex") .. "/default/hypr/bootstrap.lua")

-- Disable all Apex default bindings. Add your own in hypr/bindings.lua.
-- apex_default_bindings = false
--
-- Or disable only bindings for Apex's preinstalled apps/web apps while
-- keeping core window-manager bindings:
-- apex_preinstalled_bindings = false

-- Load Apex defaults.
require("default.hypr.apex")

-- Put your personal overrides in these files. They're loaded after Apex's
-- defaults so package updates can improve the defaults without rewriting your
-- ~/.config/hypr files.
require("hypr.monitors")
require("hypr.input")
require("hypr.bindings")
require("hypr.looknfeel")
require("hypr.autostart")

-- Toggle config flags dynamically.
require("default.hypr.toggles")

-- Add any other personal Hyprland configuration below.
-- o.window("qemu", { workspace = "5" })
