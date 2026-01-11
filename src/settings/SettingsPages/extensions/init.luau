local ExtensionList = require("@self/ExtensionList")
local ExtensionListToolbar = require("@self/ExtensionListToolbar")
local Info = require("@self/Info")
local Iris = require("@src/Iris")
local assets = require("@include/assets")
local types = require("../types")
local widgets = require("@src/widgets")

local extensions = {} :: types.SettingsPage
extensions.id = "extensions"
extensions.title = "Extensions"
extensions.tabIcon = assets.icons.extension
extensions.extensionIcon = assets.extensions.settings.extensions

function extensions.render()
	ExtensionListToolbar()
	Iris.Separator()

	Iris.SameLine()
	widgets.Flex(Enum.UIFlexMode.Fill)

	widgets.ScrollingFrame({ size = UDim2.fromScale(0.5, 1), automaticSize = Enum.AutomaticSize.None })
	ExtensionList()
	Iris.End()

	Iris.Separator()

	widgets.Frame({ size = UDim2.fromScale(0.5, 0), automaticSize = Enum.AutomaticSize.Y })
	Info()
	Iris.End()

	Iris.End()
end

return extensions
