local Command = require("./Command")
local CommandScope = require("./CommandScope")
local CommandStore = require("./CommandStore")
local isRenderResult = require("./isRenderResult")
local pluginTrove = require("@src/pluginTrove")
local setTableAtom = require("@src/utils/setTableAtom")

local function runCommand(command: Command.Command)
	local existingScope = CommandStore.scopes()[command]
	if existingScope then
		existingScope.log:warn("Cannot concurrently run a command multiple times.")
		return
	end

	local trove = pluginTrove:Extend()
	local scope = CommandScope.new(trove, command)

	setTableAtom(CommandStore.scopes, command, scope)
	trove:Add(function()
		setTableAtom(CommandStore.scopes, command, nil :: never)
		setTableAtom(CommandStore.renderResults, command, nil :: never)
	end)

	scope.log:trace("Running command", command:formatId())

	local runSuccess, runResult: Command.CommandResult = pcall(command.runner :: any, scope)
	if runSuccess then
		if isRenderResult(runResult) then
			setTableAtom(CommandStore.renderResults, command, runResult)
			return
		end
	else
		scope.log:error("Failed to run command:", runResult)
	end

	trove:Destroy()
end

return runCommand
