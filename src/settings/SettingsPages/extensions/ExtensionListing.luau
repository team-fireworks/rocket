local Extension = require("@src/core/Extension")
local Iris = require("@src/Iris")
local SettingsStore = require("@src/settings/SettingsStore")
local assets = require("@include/assets")
local widgets = require("@src/widgets")

local function ExtensionListing(
	extension: Extension.Extension,
	extensionsCollapsed: { [Extension.Extension]: true },
	layoutOrder: number
)
	local extensionIcon = extension:getIcon()

	Iris.PushId(extension.interface.id)
	local header = widgets.ButtonGroup({ size = UDim2.fromScale(1, 0) })
	header.Instance.LayoutOrder = layoutOrder
	if header.clicked() then
		SettingsStore.extensions.selected(if SettingsStore.extensions.selected() == extension then nil else extension)
	end

	Iris.PushConfig({ FrameBgTransparency = 1 })
	local expand = Iris.ImageButton({
		extensionsCollapsed[extension] and assets.icons.caretright or assets.icons.caretdown,
		UDim2.fromOffset(9, 9),
	})
	Iris.PopConfig()

	if expand.clicked() then
		extensionsCollapsed[extension] = if extensionsCollapsed[extension] then nil else true
	end

	Iris.Image({ extensionIcon, UDim2.fromOffset(18, 18) })
	Iris.Text({ extension.interface.title })

	Iris.PopId()
	Iris.End()
end

return ExtensionListing
