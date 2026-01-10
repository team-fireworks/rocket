local plugin = require("@self/plugin")
if not plugin then
	error("Rocket must be run as a plugin!")
end

local CoreGui = game:GetService("CoreGui")
local LogService = game:GetService("LogService")

local Charm = require("@pkgs/Charm")
local Command = require("@src/core/commands/Command")
local CommandRuntime = require("@src/core/commands/CommandRuntime")
local CommandStore = require("@src/core/commands/CommandStore")
local Extension = require("@src/core/Extension")
local Gizmos = require("@src/core/Gizmos")
local Iris = require("@self/Iris")
local LauncherStore = require("@src/launcher/LauncherStore")
local LauncherWindow = require("@src/launcher/LauncherWindow")
local Log = require("@src/core/Log")
local assets = require("@include/assets")
local errors = require("@src/utils/errors")
local ids = require("@src/utils/ids")
local pluginTrove = require("@self/pluginTrove")
local runCommand = require("@src/core/commands/runCommand")
local types = require("@self/types")
local useKeys = require("@src/core/hooks/useKeys")

local commandActions: { [Command.Command]: PluginAction } = {}

local function requireInstances(instances: { Instance })
	for _, instance in instances do
		if instance:IsA("ModuleScript") then
			task.spawn(pcall, require, instance)
		end
	end
end

local function renderCommandOutput(
	command: Command.Command,
	output: types.CommandOutput,
	runtimes: { [Command.Command]: CommandRuntime.CommandRuntime }
)
	if output.renderViewport then
		output.renderViewport()
	end

	if output.renderWindow then
		if output.windowConfig then
			Iris.PushConfig(table.clone(output.windowConfig))
		end

		local isOpened = Iris.State(true)
		Iris.SetNextWidgetID(`{ids.rocket(command:getFullId())}/window`)
		local window = Iris.Window(output.windowArgs :: any or { command.interface.title }, { isOpened = isOpened })

		if output.windowConfig then
			Iris.PopConfig()
		end

		if isOpened.value then
			output.renderWindow(window)
			Iris.End()
			return
		end

		-- isOpened:set(true)
		runtimes[command]:cleanup()
		Iris.End()
	end
end

local function mountUi()
	pluginTrove:Add(Charm.subscribe(LauncherStore.isVisible, function()
		LauncherStore.isFocused(false)
		LauncherStore.search("")
		LauncherStore.selectedIndex(1)
	end) :: any)

	local container = Instance.new("ScreenGui")
	container.Name = "Rocket"
	container.Parent = CoreGui

	Iris.Init(container :: any)
	Iris.UpdateGlobalConfig(Iris.TemplateConfig.sizeClear :: any)

	-- Iris.UpdateGlobalConfig(theme.config())
	-- pluginTrove:Add((Charm.subscribe :: any)(theme.config, Iris.UpdateGlobalConfig))
	-- theme.observeStudio(pluginTrove)

	pluginTrove:Add(Iris:Connect(function()
		useKeys.store.previous = useKeys.store.now
		useKeys.store.now = useKeys.getKeysDown()

		if LauncherStore.isVisible() then
			LauncherWindow()
		end

		local renderResults = CommandStore.uiOutputs()
		local contexts = CommandStore.runtimes()
		for _, command in CommandStore.commandsWithUiOutputs() do
			renderCommandOutput(command, renderResults[command], contexts)
		end

		Gizmos.step()
	end) :: any)

	pluginTrove:Add(Iris.Shutdown :: any)
	pluginTrove:Add(container)
	pluginTrove:Add(Gizmos.destroyPool)
end

local function bindVisibleToButton(isVisibleAtom: Charm.Atom<boolean>, button: PluginToolbarButton)
	pluginTrove:Add(button.Click:Connect(function()
		isVisibleAtom(not isVisibleAtom())
	end))

	pluginTrove:Add(Charm.subscribe(isVisibleAtom, function(isVisble)
		button:SetActive(isVisble)
	end) :: any)
end

local function mountToolbar()
	local toolbar = plugin:CreateToolbar("Rocket")

	local launchButton = (
		toolbar:CreateButton(ids.rocket("launch"), "Launches the Rocket command palette", assets.brand.rocket, "Launch")
	)

	local _settingsButton = (
		toolbar:CreateButton(ids.rocket("settings"), "Configure Rocket", assets.brand.settings, "Settings")
	)

	bindVisibleToButton(LauncherStore.isVisible, launchButton)
	-- bindVisibleToButton(SettingsStore.isVisible, settingsButton)
end

local function createPluginAction(id: string, title: string, description: string, icon: string)
	id = ids.rocket(id)
	local action = plugin:CreatePluginAction(id, title, description, icon)
	action.Name = id
	return action
end

local function updateCommandPluginActions(commands: { Command.Command })
	for _, command in commands do
		if commandActions[command] then
			continue
		end

		local action = createPluginAction(
			`command/{command:getFullId()}`,
			command.interface.title,
			command.interface.description,
			command:getIcon()
		)

		pluginTrove:Add(action.Triggered:Connect(function()
			runCommand(command)
		end))

		commandActions[command] = action
	end
end

local function mountPluginActions()
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
	pluginTrove:Add(task.spawn(updateCommandPluginActions, Extension._allCommands()))
	pluginTrove:Add(Charm.subscribe(Extension._allCommands, updateCommandPluginActions) :: any)
end

local function start()
	requireInstances(script:WaitForChild("extensions"):GetDescendants())
	mountUi()
	mountToolbar()
	mountPluginActions()
end

do
	LogService:ClearOutput()

	local log = Log.new(script)
	pluginTrove:Add(function()
		log:trace("Rocket shutting down!")
	end)

	local startSuccess, startError: types.Error = xpcall(start, errors.parseError, log)
	if startSuccess then
		log:info("Rocket started!")
	else
		pluginTrove:Destroy()

		local errorTrace = "\n\t" .. string.gsub(startError.trace, "\n", "\n\t")
		local errorMessage = `\nFailed to start Rocket!\nMessage: {startError.message}\n\nStack Trace:{errorTrace}`
		log:error(errorMessage, 0)
	end
end
