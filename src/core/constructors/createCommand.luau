local Command = require("@src/core/commands/Command")
local types = require("@src/types")

local function createCommand(interface: types.CommandInterface, runner: Command.CommandRunner): Command.Command
	return setmetatable({
		_extension = nil,
		_runner = runner,
		interface = table.freeze(table.clone(interface)),
	}, Command) :: Command.Command
end

return createCommand
