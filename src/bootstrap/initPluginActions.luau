local Charm = require("@pkgs/Charm")
local Command = require("@src/core/Command")
local Extension = require("@src/core/Extension")
local LauncherStore = require("@src/launcher/LauncherStore")
local assets = require("@include/assets")
local plugin = require("@src/plugin")
local pluginTrove = require("@src/pluginTrove")
local prefixId = require("@src/utils/prefixId")
local runCommand = require("@src/core/runCommand")

local function createPluginAction(id: string, title: string, description: string, icon: string)
	id = prefixId(id)
	local action = plugin:CreatePluginAction(id, title, description, icon)
	action.Name = id
	return action
end

local commandActions: { [Command.Command]: PluginAction } = {}
local function initCommandPluginActions(commands: { Command.Command })
	for _, command in commands do
		if commandActions[command] then
			continue
		end

		local action = createPluginAction(
			`command/{command:formatId()}`,
			command.metadata.title,
			command.metadata.description,
			command.metadata.icon or command.extension.metadata.icon or assets.extensions.rocket
		)

		pluginTrove:Add(action.Triggered:Connect(function()
			runCommand(command)
		end))

		commandActions[command] = action
	end
end

local function initPluginActions()
	local enableAction = createPluginAction(
		"launcher/enable",
		"Enable Rocket",
		"Enables the Rocket command launcher",
		assets.brand.rocket
	)

	local disableAction = createPluginAction(
		"launcher/disable",
		"Disable Rocket",
		"Disables the Rocket command launcher",
		assets.brand.rocket
	)

	local toggleAction = createPluginAction(
		"launcher/toggle",
		"Enable/Disable Rocket",
		"Toggles the Rocket command launcher",
		assets.brand.rocket
	)

	pluginTrove:Add(enableAction.Triggered:Connect(function()
		LauncherStore.isVisible(true)
	end))

	pluginTrove:Add(disableAction.Triggered:Connect(function()
		LauncherStore.isVisible(false)
	end))

	pluginTrove:Add(toggleAction.Triggered:Connect(function()
		LauncherStore.isVisible(not LauncherStore.isVisible())
	end))

	-- TODO: command removals?
	pluginTrove:Add(task.spawn(initCommandPluginActions, Extension._allCommands()))
	pluginTrove:Add(Charm.subscribe(Extension._allCommands, initCommandPluginActions) :: any)
end

return initPluginActions
