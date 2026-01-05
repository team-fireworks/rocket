local UserInputService = game:GetService("UserInputService")

local Charm = require("@pkgs/Charm")
local LauncherStore = require("@src/launcher/LauncherStore")
local handleLauncherInput = require("./handleLauncherInput")
local pluginTrove = require("@src/pluginTrove")

local function initLauncherInput()
	local launcherInputTrove = pluginTrove:Extend()
	pluginTrove:Add(Charm.subscribe(LauncherStore.isVisible, function(isVisible: boolean)
		LauncherStore.isFocused(false)
		LauncherStore.search("")
		LauncherStore.selectedIndex(1)

		launcherInputTrove:Clean()
		if isVisible then
			launcherInputTrove:Add(UserInputService.InputBegan:Connect(handleLauncherInput))
		end
	end) :: any)
end

return initLauncherInput
