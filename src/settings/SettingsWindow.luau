local Workspace = game:GetService("Workspace")

local Iris = require("@pkgs/Iris")
local SettingsPages = require("./SettingsPages")
local SettingsSidebar = require("./SettingsSidebar")
local SettingsStore = require("./SettingsStore")

local SIDEBAR_WIDTH = 256
local WINDOW_ARGS = {
	"Rocket Settings",
	[Iris.Args.Window.NoCollapse] = true,
	[Iris.Args.Window.NoMove] = true,
	[Iris.Args.Window.NoResize] = true,
}

local function SettingsWindow()
	Iris.PushConfig({ WindowPadding = Vector2.zero })
	local viewportSize = Workspace.CurrentCamera.ViewportSize
	local windowSize = viewportSize * 0.8
	local windowState: any = { position = (viewportSize - windowSize) / 2, size = windowSize }
	local window = Iris.Window(WINDOW_ARGS, windowState)
	if window.closed() then
		SettingsStore.isVisible(false)
		window.state.isOpened:set(true)
		Iris.End()
		Iris.PopConfig()
		return
	end

	local layout = Iris.Table({ 2, false, false, false, true, true, true })
	layout.state.widths:set({ SIDEBAR_WIDTH, windowSize.X - SIDEBAR_WIDTH })
	layout.Instance.Size = UDim2.new(layout.Instance.Size.X.Scale, layout.Instance.Size.X.Offset, 1, 0)
		- UDim2.fromOffset(0, Iris._config.CellPadding.Y)
	do
		SettingsSidebar()
		Iris.NextColumn()
		local currentPage = SettingsStore.currentPage() or SettingsPages[1]
		currentPage.render()
	end
	Iris.End()

	Iris.End()
	Iris.PopConfig()
end

return SettingsWindow
