local Iris = require("@iris/Iris")
local SettingsPages = require("@settings/SettingsPages")
local SettingsStore = require("@settings/SettingsStore")
local Theme = require("@theme/Theme")

local function SettingsSidebar()
	Theme.push(Theme.presets.subtext)
	Iris.Text("Settings")
	Theme.pop()

	for _, page in SettingsPages do
		local button = Iris.ButtonGroup()
		button.Instance.Size = UDim2.fromScale(1, 0)

		Iris.Image(page.tabIcon, UDim2.fromOffset(18, 18))
		Iris.Text(page.title)

		Iris.End()

		if button.clicked() then
			SettingsStore.currentPage(page)
		end
	end
end

return SettingsSidebar
