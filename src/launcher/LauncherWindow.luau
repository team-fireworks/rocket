local Workspace = game:GetService("Workspace")

local Command = require("@src/core/commands/Command")
local Iris = require("@src/Iris")
local LauncherStore = require("./LauncherStore")
local ids = require("@src/utils/ids")
local runCommand = require("@src/core/commands/runCommand")
local useKeys = require("@src/core/hooks/useKeys")
local widgets = require("@src/widgets")

local WINDOW_SIZE = Vector2.new(640, 284)

local function LauncherWindow()
	Iris.SetNextWidgetID(ids.rocket "launcherWindow")

	local viewportSize = Workspace.CurrentCamera.ViewportSize
	local windowPosition = Iris.State(Vector2.zero)

	Iris.PushConfig {
		WindowPadding = Vector2.zero,
		ContentWidth = UDim.new(1, 0),
		ItemSpacing = Vector2.new(8, 0),
	}

	local window = Iris.Window({
		"Rocket Launcher",
		[Iris.Args.Window.NoTitleBar] = true,
		[Iris.Args.Window.NoBackground] = true,
		[Iris.Args.Window.NoCollapse] = true,
		[Iris.Args.Window.NoMove] = true,
		[Iris.Args.Window.NoResize] = true,
		[Iris.Args.Window.NoNav] = true,
		[Iris.Args.Window.NoMenu] = true,
	}, { position = windowPosition, size = WINDOW_SIZE :: any })

	windowPosition:set(viewportSize / 2 - WINDOW_SIZE / 2 - Vector2.new(0, 100))

	if window.closed() or useKeys.andConsumePress(Enum.KeyCode.Escape) then
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
			return command.interface.title
		end,
		getEntryTooltip = function(command: Command.Command)
			return command.interface.description
		end,
		renderEntry = function(command: Command.Command)
			Iris.Image({ command:getIcon(), UDim2.fromOffset(18, 18) })
			Iris.Text({ command.interface.title })
			widgets.Subtext({ command._extension.interface.title })
			widgets.FlexSpacer(Enum.UIFlexMode.Fill)
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

return LauncherWindow
