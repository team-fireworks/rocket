local Command = require("@src/core/commands/Command")
local CommandRuntime = require("@src/core/commands/CommandRuntime")
local Log = require("@src/core/Log")
local Trove = require("@pkgs/Trove")

local function createCommandRuntime(trove: Trove.Trove, command: Command.Command): CommandRuntime.CommandRuntime
	return setmetatable({
		trove = trove,
		command = command,
		log = Log.new(tostring(command)),
		isFirstRun = true,
	}, CommandRuntime) :: CommandRuntime.CommandRuntime
end

return createCommandRuntime
