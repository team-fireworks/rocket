local Iris = require("@src/Iris")
local LauncherCommand = require("./LauncherCommand")
local LauncherSearch = require("./LauncherSearch")
local LauncherStore = require("./LauncherStore")
local LauncherWindow = require("./LauncherWindow")
local theme = require("@src/theme")
local widgets = require("@src/widgets")

local function Launcher()
	Iris.PushConfig {
		WindowPadding = Vector2.zero,
		ContentWidth = UDim.new(1, 0),
		ItemSpacing = Vector2.new(8, 0),
	}
	local window = LauncherWindow()
	do
		if window.closed() then
			LauncherStore.isVisible(false)
			LauncherStore.isFocused(false)
			Iris.End()
			Iris.PopConfig()
			return
		end

		LauncherSearch()
		Iris.Separator()

		widgets.ScrollingFrame { Size = UDim2.fromScale(1, 0), AutomaticSize = Enum.AutomaticSize.None }
		do
			widgets.Flex { Mode = Enum.UIFlexMode.Fill }
			widgets.Padding { X = UDim.new(0, Iris._config.CellPadding.X), Y = UDim.new(0, Iris._config.CellPadding.Y) }

			local selectedIndex = LauncherStore.selectedIndex()
			for i, command in LauncherStore.searchResults() do
				Iris.PushConfig(
					if selectedIndex == i
						then theme.PRESETS.BUTTONS.HIGHLIGHTED
						else theme.PRESETS.BUTTONS.UNHIGHLIGHTED
				)
				LauncherCommand(command)
				Iris.PopConfig()
			end
		end
		Iris.End()
	end
	Iris.End()
	Iris.PopConfig()
end

return Launcher
