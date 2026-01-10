local Command = require("@src/core/commands/Command")
local CommandStore = require("@src/core/commands/CommandStore")
local Extension = require("@src/core/Extension")
local Iris = require("@src/Iris")
local assets = require("@include/assets")
local createCoreExtension = require("@src/core/constructors/createCoreExtension")
local widgets = require("@src/widgets")

local ext = createCoreExtension {
	id = "rocket",
	title = "Rocket",
	description = "Testing extension",
	icon = assets.extensions.rocket,
	authors = { "Basic Rocket utilities and commands." },
}

ext:newCommand({
	id = "kill-all-commands",
	title = "Kill All Commands",
	description = "Kills all currently running commands.",
}, function(r: Extension.CommandRuntime)
	for _, otherRuntime in CommandStore.runtimes() do
		if otherRuntime ~= r then
			otherRuntime:cleanup()
		end
	end
end)

ext:newCommand({
	id = "kill-commands",
	title = "Kill Commands",
	description = "Select and kill running commands.",
}, function(r: Extension.CommandRuntime)
	local output = r:createCommandOutput()

	local firstRun = true
	output.windowConfig = { WindowPadding = Vector2.zero, ItemSpacing = Vector2.zero }
	function output.renderWindow()
		widgets.List({
			captureFocus = firstRun,

			entries = CommandStore.runningCommands(),
			getEntryTitle = function(entry: Command.Command)
				return entry.interface.title
			end,
			renderEntry = function(entry: Command.Command)
				Iris.Text({ entry.interface.title })
			end,
			onEntrySelected = function(entry: Command.Command)
				CommandStore.runtimes()[entry]:cleanup()
			end,
		} :: widgets.ListProps<Command.Command>)

		firstRun = false
	end

	return output
end)

ext:newCommand({
	id = "test-list-widget",
	title = "Test List Widget",
	description = "N/A",
}, function(r: Extension.CommandRuntime)
	local output = r:createCommandOutput()

	local firstRun = true
	output.windowConfig = { WindowPadding = Vector2.zero, ItemSpacing = Vector2.zero }
	function output.renderWindow()
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

	return output
end)

return ext
