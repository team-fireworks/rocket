local Charm = require("@pkgs/Charm")
local Command = require("./Command")
local CommandRuntime = require("./CommandRuntime")
local types = require("@src/types")

local CommandStore = {}
CommandStore.runtimes = Charm.atom({} :: { [Command.Command]: CommandRuntime.CommandRuntime })
CommandStore.uiOutputs = Charm.atom({} :: { [Command.Command]: types.CommandOutput })

CommandStore.runningCommands = Charm.computed(function()
	local result = {}
	for command in CommandStore.runtimes() do
		table.insert(result, command)
	end
	table.sort(result, Command.compareTitles)
	return result
end)

CommandStore.commandsWithUiOutputs = Charm.computed(function()
	local result = {}
	for command in CommandStore.uiOutputs() do
		table.insert(result, command)
	end
	table.sort(result, Command.compareTitles)
	return result
end)

return CommandStore
