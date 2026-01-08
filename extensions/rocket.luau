local Command = require("@src/core/Command")
local CommandStore = require("@src/core/CommandStore")
local Extension = require("@src/core/Extension")
local Iris = require("@src/Iris")
local assets = require("@include/assets")
local widgets = require("@src/widgets")

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
}, function(ctx: Extension.CommandContext)
	for _, otherScope in CommandStore.contexts() do
		if otherScope ~= ctx then
			otherScope:cleanup()
		end
	end
end)

ext:newCommand({
	id = "kill-commands",
	title = "Kill Commands",
	description = "Select and kill running commands.",
}, function(ctx: Extension.CommandContext)
	local commandResult = ctx:newResult()

	local firstRun = true
	commandResult.windowConfig = { WindowPadding = Vector2.zero, ItemSpacing = Vector2.zero }
	function commandResult.renderWindow()
		widgets.List({
			captureFocus = firstRun,

			entries = CommandStore.runningCommands(),
			getEntryTitle = function(entry: Command.Command)
				return entry.metadata.title
			end,
			renderEntry = function(entry: Command.Command)
				Iris.Text({ entry.metadata.title })
			end,
			onEntrySelected = function(entry: Command.Command)
				CommandStore.contexts()[entry]:cleanup()
			end,
		} :: widgets.ListProps<Command.Command>)

		firstRun = false
	end

	return commandResult
end)

ext:newCommand({
	id = "test-list-widget",
	title = "Test List Widget",
	description = "N/A",
}, function(ctx: Extension.CommandContext)
	local commandResult = ctx:newResult()

	local firstRun = true
	commandResult.windowConfig = { WindowPadding = Vector2.zero, ItemSpacing = Vector2.zero }
	function commandResult.renderWindow()
		widgets.List({
			captureFocus = firstRun,

			entries = { "Vietnam", "USA", "China", "Venezuela", "Russia" },
			renderEntry = function(entry)
				Iris.Text({ tostring(entry) })
			end,
			getEntryTitle = function(entry)
				return tostring(entry)
			end,
			onEntrySelected = function(entry)
				print(entry)
			end,
		} :: any)

		firstRun = false
	end

	return commandResult
end)

return ext
