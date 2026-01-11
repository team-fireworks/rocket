local Iris = require("@src/Iris")
local SettingsPages = require("./SettingsPages")
local SettingsStore = require("./SettingsStore")
local widgets = require("@src/widgets")

local function SettingsSidebar()
	for _, page in SettingsPages do
		if widgets.ButtonGroup({ size = UDim2.fromScale(1, 0) }).clicked() then
			SettingsStore.currentPage(page)
		end

		Iris.Image({ page.tabIcon, UDim2.fromOffset(18, 18) })
		Iris.Text({ page.title })

		Iris.End()
	end
end

return SettingsSidebar
