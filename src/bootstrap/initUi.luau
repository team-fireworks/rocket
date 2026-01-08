local CoreGui = game:GetService("CoreGui")

local Charm = require("@pkgs/Charm")
local CommandStore = require("@src/core/CommandStore")
local Gizmos = require("@src/Gizmos")
local Iris = require("@src/Iris")
local Launcher = require("@src/launcher/Launcher")
local LauncherStore = require("@src/launcher/LauncherStore")
local pluginTrove = require("@src/pluginTrove")
local renderCommandResult = require("./renderCommandResult")
local theme = require("@src/theme")

local function initUi()
	local container = Instance.new("ScreenGui")
	container.Name = "Rocket"
	container.Parent = CoreGui

	Iris.Init(container :: any)
	Iris.UpdateGlobalConfig(Iris.TemplateConfig.sizeClear :: any)

	Iris.UpdateGlobalConfig(theme.config())
	pluginTrove:Add((Charm.subscribe :: any)(theme.config, Iris.UpdateGlobalConfig))
	theme.observeStudio(pluginTrove)

	pluginTrove:Add(Iris:Connect(function()
		if LauncherStore.isVisible() then
			Launcher()
		end

		local renderResults = CommandStore.renderResults()
		local contexts = CommandStore.contexts()
		for _, command in CommandStore.commandsWithRenderResults() do
			renderCommandResult(command, renderResults[command], contexts)
		end

		Gizmos.step()
	end) :: any)

	pluginTrove:Add(Iris.Shutdown :: any)
	pluginTrove:Add(container)
	pluginTrove:Add(Gizmos.destroyPool)
end

return initUi
