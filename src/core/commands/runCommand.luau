local Command = require("@src/core/commands/Command")
local CommandStore = require("@src/core/commands/CommandStore")
local atoms = require("@src/utils/atoms")
local constructors = require("@src/core/constructors")
local isOutputsUi = require("@src/core/commands/isOutputsUi")
local pluginTrove = require("@src/pluginTrove")
local types = require("@src/types")

local function runCommand(command: Command.Command)
	local existing = CommandStore.runtimes()[command]
	if existing then
		existing.log:warn(
			"Cannot concurrently run a command multiple times."
				.. " If a command is misbehaving, use the Kill Command from the Rocket extension."
		)
		return
	end

	local trove = pluginTrove:Extend()
	local runtime = constructors.createCommandRuntime(trove, command)

	atoms.set(CommandStore.runtimes, command, runtime)
	trove:Add(function()
		atoms.set(CommandStore.runtimes, command, nil :: never)
		atoms.set(CommandStore.uiOutputs, command, nil :: never)
	end)

	runtime.log:trace("Running command", command:getFullId())

	local runSuccess, runOutput: types.CommandOutput = pcall(command._runner :: any, runtime)
	if runSuccess then
		local output = types.CommandOutput:cast(runOutput)
		if isOutputsUi(output) then
			atoms.set(CommandStore.uiOutputs, command, output :: never)
			return
		end
	else
		runtime.log:error("Failed to run command:", runOutput)
	end

	trove:Destroy()
end

return runCommand
