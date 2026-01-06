local Extension = require("@src/core/Extension")
local assets = require("@include/assets")

local plugin = script:FindFirstAncestorWhichIsA("Plugin") :: Plugin
local ext = Extension.new(plugin, {
	id = "rocket-color-picker",
	title = "Color Picker",
	description = "TBA",
	icon = assets.extensions.rocket,
	authors = { "znotfireman" },
})

ext:newCommand({
	id = "pick-from-part",
	title = "Pick Color from Part",
	description = "TODO",
}, function()
	local commandResult: Extension.CommandResult = {}

	function commandResult.renderViewport() end

	function commandResult.renderWindow() end

	return commandResult
end)

ext:newCommand({
	id = "wheel",
	title = "Color Wheel",
	description = "TODO",
}, function()
	local commandResult: Extension.CommandResult = {}

	function commandResult.renderViewport() end

	function commandResult.renderWindow() end

	return commandResult
end)

return ext
