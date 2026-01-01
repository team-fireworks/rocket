local Extension = require("@src/Extension")
local assets = require("@src/assets")

local plugin = script:FindFirstAncestorWhichIsA("Plugin") :: Plugin
local ext = Extension.new(plugin, {
	id = "rocket-temp",
	title = "Test",
	description = "Test Extension",
	icon = { Image = assets.extensions.rocket },
	authors = { "Team Fireworks" },
})

for i = 1, 20 do
	ext:newCommand({
		id = tostring(i),
		title = `Test #{i}`,
		description = `Test command`,
		renderInLauncher = function(ctx: Extension.CommandContext)
			if ctx.iris.Button({ "stop" }).clicked() then
				ctx.trove:Clean()
			end
		end,
	})
end

return ext
