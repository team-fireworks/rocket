local Charm = require("@pkgs/Charm")
local Command = require("./Command")
local CommandScope = require("./CommandScope")

local CommandStore = {}
CommandStore.scopes = Charm.atom({} :: { [Command.Command]: CommandScope.CommandScope })
CommandStore.renderResults = Charm.atom({} :: { [Command.Command]: Command.CommandResult })

CommandStore.commandsWithRenderResults = Charm.computed(function()
	local result = {}
	for command in CommandStore.renderResults() do
		table.insert(result, command)
	end
	table.sort(result, Command.compareTitles)
	return result
end)

return CommandStore
