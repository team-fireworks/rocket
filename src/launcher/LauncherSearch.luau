local Iris = require("@src/Iris")
local LauncherStore = require("@src/launcher/LauncherStore")
local widgets = require("@src/widgets")

local function LauncherSearch()
	Iris.PushConfig { FrameRounding = 0, FramePadding = Iris._config.FramePadding * 2 }
	LauncherStore.search((widgets.InstantInputText {
		Placeholder = "Search commands...",
		CaptureFocus = not LauncherStore.isFocused(),
	}))
	LauncherStore.isFocused(true)
	Iris.PopConfig()
end

return LauncherSearch
