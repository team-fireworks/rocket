local Charm = require("@pkgs/Charm")
local Command = require("./Command")
local CommandContext = require("./CommandContext")
local types = require("@src/types")

local CommandStore = {}
CommandStore.contexts = Charm.atom({} :: { [Command.Command]: CommandContext.CommandContext })
CommandStore.renderResults = Charm.atom({} :: { [Command.Command]: types.CommandResult })

CommandStore.runningCommands = Charm.computed(function()
	local result = {}
	for command in CommandStore.contexts() do
		table.insert(result, command)
	end
	table.sort(result, Command.compareTitles)
	return result
end)

CommandStore.commandsWithRenderResults = Charm.computed(function()
	local result = {}
	for command in CommandStore.renderResults() do
		table.insert(result, command)
	end
	table.sort(result, Command.compareTitles)
	return result
end)

return CommandStore
