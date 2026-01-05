local Charm = require("@pkgs/Charm")
local LauncherStore = require("@src/launcher/LauncherStore")
local SettingsStore = require("@src/settings/SettingsStore")
local assets = require("@include/assets")
local plugin = require("@src/plugin")
local pluginTrove = require("@src/pluginTrove")
local prefixId = require("@src/utils/prefixId")

local function bindVisibleToButton(isVisibleAtom: Charm.Atom<boolean>, button: PluginToolbarButton)
	pluginTrove:Add(button.Click:Connect(function()
		isVisibleAtom(not isVisibleAtom())
	end))

	pluginTrove:Add(Charm.subscribe(isVisibleAtom, function(isVisble)
		button:SetActive(isVisble)
	end) :: any)
end

local function initToolbar()
	local toolbar = plugin:CreateToolbar("Rocket")

	local launchButton = (
		toolbar:CreateButton(prefixId("launch"), "Launches the Rocket command palette", assets.brand.rocket, "Launch")
	)

	local settingsButton = (
		toolbar:CreateButton(prefixId("settings"), "Configure Rocket", assets.brand.settings, "Settings")
	)

	bindVisibleToButton(LauncherStore.isVisible, launchButton)
	bindVisibleToButton(SettingsStore.isVisible, settingsButton)
end

return initToolbar
