local Extension = require("@src/core/Extension")
local assets = require("@include/assets")

local plugin = script:FindFirstAncestorWhichIsA("Plugin") :: Plugin
local ext = Extension.new(plugin, {
	id = "hello",
	title = "Hello World",
	description = "Testing extension",
	icon = assets.extensions.rocket,
	authors = { "Team Fireworks" },
})

ext:newCommand({
	id = "test-run",
	title = "Test Run",
	description = "Test Run Command",
}, function()
	print("Hello Rocket")
end)

ext:newCommand({
	id = "test-window",
	title = "Test Window",
	description = "Test Window Command",
}, function(scope: Extension.CommandScope): Extension.CommandResult
	return {
		renderWindow = function()
			scope.Iris.Text({ "Hello Rocket" })
		end,
	}
end)

return ext
