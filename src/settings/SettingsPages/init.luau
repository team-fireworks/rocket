local types = require("./types")

local SettingPages: { types.SettingsPage } = {
	require("@self/extensions"),
	require("@self/about"),
}

return SettingPages
