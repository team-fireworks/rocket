local Workspace = game:GetService("Workspace")

local Iris = require("@src/Iris")
local prefixId = require("@src/utils/prefixId")

local function LauncherWindow()
	Iris.SetNextWidgetID(prefixId "launcherWidget")

	local viewportSize = Workspace.CurrentCamera.ViewportSize
	local windowSize = viewportSize / 2
	local windowPositionState, windowSizeState = Iris.State(windowSize / 2), Iris.State(windowSize)

	local window = Iris.Window({
		"Rocket Launcher",
		[Iris.Args.Window.NoTitleBar] = true,
		[Iris.Args.Window.NoBackground] = true,
		[Iris.Args.Window.NoCollapse] = true,
		[Iris.Args.Window.NoMove] = true,
		[Iris.Args.Window.NoResize] = true,
		[Iris.Args.Window.NoNav] = true,
		[Iris.Args.Window.NoMenu] = true,
	}, { position = windowPositionState, size = windowSizeState })

	windowPositionState:set(windowSize / 2)
	windowSizeState:set(windowSize)

	return window
end

return LauncherWindow
