local Extension = require("@src/core/Extension")
local assets = require("@include/assets")
local constants = require("@src/constants")
local createCoreExtension = require("@src/core/constructors/createCoreExtension")

local ext = createCoreExtension({
	id = "rocket-color-picker",
	title = "Color Picker",
	description = "TBA",
	icon = assets.extensions.rocket,
	contributors = {
		{ type = "user", id = constants.userIds.znotfireman },
	},
})

ext:newCommand({
	id = "pick-from-part",
	title = "Pick Color from Part",
	description = "TODO",
}, function(r: Extension.CommandRuntime)
	local output = r:createCommandOutput()

	function output.renderViewport() end

	function output.renderWindow() end

	return output
end)

ext:newCommand({
	id = "wheel",
	title = "Color Wheel",
	description = "TODO",
}, function(r: Extension.CommandRuntime)
	local output = r:createCommandOutput()
	--
	function output.renderViewport() end

	function output.renderWindow() end

	return output
end)

return ext
