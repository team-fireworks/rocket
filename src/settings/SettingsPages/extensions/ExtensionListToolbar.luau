local Iris = require("@src/Iris")
local SettingsStore = require("@src/settings/SettingsStore")
local Theme = require("@src/theme")
local widgets = require("@src/widgets")

local function ExtensionListToolbar()
	local config = Theme.config()
	Theme.push({
		CellPadding = config.CellPadding,
		WindowPadding = config.WindowPadding,
		ItemSpacing = config.WindowPadding,
	})

	Iris.SameLine()

	Iris.Menu({ "Toggle All" })
	if Iris.MenuItem({ "Uncollasped" }).clicked() then
		SettingsStore.extensions.massCollapse(false)
	end
	if Iris.MenuItem({ "Collasped" }).clicked() then
		SettingsStore.extensions.massCollapse(true)
	end
	Iris.End()

	Iris.Menu({ "Filters" })
	Iris.MenuToggle({ "Show Enabled Extensions" })
	Iris.MenuToggle({ "Show Disabled Extensions" })
	Iris.Separator()
	Iris.MenuToggle({ "Show Core Extensions" })
	Iris.MenuToggle({ "Show Third-Party Extensions" })
	Iris.End()
	widgets.InstantInputText({ hint = "Search commands..." })

	Iris.End()
	Iris.PopConfig()
end

return ExtensionListToolbar
