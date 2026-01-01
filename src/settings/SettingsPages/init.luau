local types = require("./types")

local SettingsPages: { types.SettingsPage } = {
	require("@self/ExtensionsPage"),
	require("@self/AboutPage"),
}

return SettingsPages
