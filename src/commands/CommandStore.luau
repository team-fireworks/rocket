local Charm = require("@pkgs/Charm")
local Command = require("./Command")
local CommandContext = require("./CommandContext")

local CommandStore = {}
CommandStore.uiContexts = Charm.atom({} :: {
	[Command.Command]: {
		ctx: CommandContext.CommandContext,
		result: Command.CommandResult,
	},
})

return CommandStore
