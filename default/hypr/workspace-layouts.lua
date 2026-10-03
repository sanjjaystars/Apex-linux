-- Restore workspace layouts saved by apex-hyprland-workspace-layout-toggle.

local paths = require("default.hypr.paths")
local require_all = require("default.hypr.require_all")

local layouts_dir = paths.state_home .. "/apex/workspace-layouts"

require_all.files(layouts_dir, "apex.workspace-layouts", { reload = true })
