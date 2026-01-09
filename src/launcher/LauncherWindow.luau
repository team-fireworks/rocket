local Workspace = game:GetService("Workspace")

local Iris = require("@src/Iris")
local prefixId = require("@src/utils/prefixId")

local WINDOW_SIZE = Vector2.new(640, 284)

local function LauncherWindow()
	Iris.SetNextWidgetID(prefixId "launcherWidget")

	local viewportSize = Workspace.CurrentCamera.ViewportSize
	local windowPosition = Iris.State(Vector2.zero)

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

	return window
end

return LauncherWindow
