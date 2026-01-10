local Lighting = game:GetService("Lighting")

local Extension = require("@src/core/Extension")
local assets = require("@include/assets")
local constants = require("@src/constants")
local createCoreExtension = require("@src/core/constructors/createCoreExtension")

local ext = createCoreExtension {
	id = "rocket-lighting",
	title = "Lighting",
	description = "Artist-friendly lighting control with visual control of the sun and moon.",
	icon = assets.extensions.lighting.sun,
	authors = {
		{ type = "user", id = constants.userIds.znotfireman },
	},
}

ext:newCommand({
	id = "toggle-shadows",
	title = "Toggle Shadows",
	description = "Toggles Lighting's GlobalShadows property",
}, function(r: Extension.CommandRuntime)
	r:recordChangeHistory()
	Lighting.GlobalShadows = not Lighting.GlobalShadows
end)

return ext
