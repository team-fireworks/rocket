local Extension = require("@src/Extension")
local assets = require("@src/assets")

local plugin = script:FindFirstAncestorWhichIsA("Plugin") :: Plugin
local ext = Extension.new(plugin, {
	id = "rocket-geometry",
	title = "Geometry",
	description = "TBA",
	icon = { Image = assets.extensions.settings.base },
	authors = { "Team Fireworks" },
})

return ext
