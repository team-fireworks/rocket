local Extension = require("@src/core/Extension")
local assets = require("@include/assets")

local plugin = script:FindFirstAncestorWhichIsA("Plugin") :: Plugin
local ext = Extension.new(plugin, {
	id = "rocket-geometry",
	title = "Geometry",
	description = "TBA",
	icon = assets.extensions.rocket,
	authors = { "Team Fireworks" },
})

return ext
