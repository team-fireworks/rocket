local CommandStore = require("@src/core/CommandStore")
local Extension = require("@src/core/Extension")
local assets = require("@include/assets")

local plugin = script:FindFirstAncestorWhichIsA("Plugin") :: Plugin
local ext = Extension.new(plugin, {
	id = "rocket",
	title = "Rocket",
	description = "Testing extension",
	icon = assets.extensions.rocket,
	authors = { "Basic Rocket utilities and commands." },
})

ext:newCommand({
	id = "kill-all-commands",
	title = "Kill All Commands",
	description = "Kills all currently running commands.",
}, function(scope: Extension.CommandScope)
	for _, otherScope in CommandStore.scopes() do
		if otherScope ~= scope then
			otherScope:cleanup()
		end
	end
end)

return ext
