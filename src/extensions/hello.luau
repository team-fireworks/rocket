local Extension = require("@src/Extension")

local plugin = script:FindFirstAncestorWhichIsA("Plugin") :: Plugin
local ext = Extension.new(plugin, {
	id = "hello",
	title = "Hello World",
	description = "Testing extension",
	icon = "",
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
}, function(ctx: Extension.CommandContext): Extension.CommandResult
	return {
		renderWindow = function()
			ctx.Iris.Text({ "Hello Rocket" })
		end,
	}
end)
