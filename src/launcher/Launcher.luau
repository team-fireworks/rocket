local Command = require("@src/core/Command")
local Iris = require("@src/Iris")
local LauncherStore = require("./LauncherStore")
local LauncherWindow = require("./LauncherWindow")
local assets = require("@include/assets")
local runCommand = require("@src/core/runCommand")
local widgets = require("@src/widgets")

local function Launcher()
	Iris.PushConfig {
		WindowPadding = Vector2.zero,
		ContentWidth = UDim.new(1, 0),
		ItemSpacing = Vector2.new(8, 0),
	}

	local window = LauncherWindow()
	if window.closed() then
		LauncherStore.isVisible(false)
		Iris.End()
		Iris.PopConfig()
		return
	end

	widgets.List({
		onSearchChange = LauncherStore.search,
		captureFocus = LauncherStore.isFocused(),
		entries = LauncherStore.searchResults(),
		getEntryTitle = function(command: Command.Command)
			return command.metadata.title
		end,
		renderEntry = function(command: Command.Command)
			Iris.Image({ command.metadata.icon or command.extension.metadata.icon, UDim2.fromOffset(18, 18) })
			Iris.Text({ command.metadata.title })
			widgets.Subtext({ command.extension.metadata.title })
			widgets.FlexFiller({ Mode = Enum.UIFlexMode.Fill })
			widgets.Subtext({ "Command" })
		end,
		onEntrySelected = function(command: Command.Command)
			LauncherStore.isVisible(false)
			task.defer(runCommand, command)
		end,
	} :: widgets.ListProps<Command.Command>)

	LauncherStore.isFocused(true)

	Iris.End()
	Iris.PopConfig()
end

return Launcher
