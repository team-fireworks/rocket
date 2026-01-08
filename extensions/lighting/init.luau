local Lighting = game:GetService("Lighting")

local Extension = require("@src/core/Extension")
local assets = require("@include/assets")

local ext = Extension.new(plugin, {
	id = "rocket-lighting",
	title = "Lighting",
	description = "Artist-friendly lighting control with visual control of the sun and moon.",
	icon = assets.extensions.lighting.sun,
	authors = { "Team Fireworks" },
})

ext:newCommand({
	id = "toggle-shadows",
	title = "Toggle Shadows",
	description = "Toggles Lighting's GlobalShadows property",
}, function(ctx: Extension.CommandContext)
	ctx:recordChanges()
	Lighting.GlobalShadows = not Lighting.GlobalShadows
end)

return ext
