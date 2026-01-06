local Command = require("./Command")
local CommandContext = require("./CommandContext")
local CommandStore = require("./CommandStore")
local isRenderResult = require("./isRenderResult")
local pluginTrove = require("@src/pluginTrove")
local setTableAtom = require("@src/utils/setTableAtom")
local types = require("@src/types")

local function runCommand(command: Command.Command)
	local existingScope = CommandStore.contexts()[command]
	if existingScope then
		existingScope.log:warn("Cannot concurrently run a command multiple times.")
		return
	end

	local trove = pluginTrove:Extend()
	local context = CommandContext.new(trove, command)

	setTableAtom(CommandStore.contexts, command, context)
	trove:Add(function()
		setTableAtom(CommandStore.contexts, command, nil :: never)
		setTableAtom(CommandStore.renderResults, command, nil :: never)
	end)

	context.log:trace("Running command", command:formatId())

	local runSuccess, runResult: types.CommandResult = pcall(command.runner :: any, context)
	if runSuccess then
		if isRenderResult(runResult) then
			setTableAtom(CommandStore.renderResults, command, runResult)
			return
		end
	else
		context.log:error("Failed to run command:", runResult)
	end

	trove:Destroy()
end

return runCommand
