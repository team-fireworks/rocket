local Command = require("./Command")
local CommandContext = require("./CommandContext")
local CommandStore = require("./CommandStore")
local Trove = require("@pkgs/Trove")

local plugin = script:FindFirstAncestorWhichIsA("Plugin") :: Plugin

local function runCommand(command: Command.Command, outerTrove: Trove.Trove)
	local trove = outerTrove:Extend()
	local ctx = CommandContext.new(command, plugin, trove)

	local runSuccess, runResult: Command.CommandResult = pcall(command.runner :: any, ctx)
	if runSuccess then
		if
			runResult
			and typeof(runResult) == "table"
			and (runResult.renderWindow or runResult.renderViewport) ~= nil
		then
			local newUiContexts = CommandStore.uiContexts()
			newUiContexts[command] = { ctx = ctx, result = runResult }
			CommandStore.uiContexts(newUiContexts)
			return
		end
	else
		warn(runResult)
	end

	trove:Destroy()
end

return runCommand
