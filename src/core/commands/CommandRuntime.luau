local ChangeHistoryService = game:GetService("ChangeHistoryService")
local RunService = game:GetService("RunService")
local Selection = game:GetService("Selection")

local Gizmos = require("@src/core/Gizmos")
local Iris = require("@src/Iris")
local Log = require("@src/core/Log")
local Trove = require("@pkgs/Trove")
local fzy = require("@include/fzy")
local noop = require("@src/utils/noop")
local plugin = require("@src/plugin")
local types = require("@src/types")
local useKeys = require("@src/core/hooks/useKeys")

--[=[
	@class CommandRuntime

	Represents the runtime of a command. Runtimes are scoped with a `Trove`.
	Runtimes also include utilities and references to other libraries, such as
	`Iris`, for development speed.

	Runtimes also includes plugin security polyfills for user scripts to use,
	which do not run under plugin security.

	```luau
	ext:newCommand({
		id = "hello-world",
		title = "Hello World",
		description = "A test command"
	}, function(r: Rocket.Runtime)
		local result = r.createCommandOutput()

		function result.renderWindow()
			if r.Iris.Button({ "Close command" }).clicked() then
				r:cleanup()
			end
		end

		return result
	end)
	```
]=]
local CommandRuntime = {}
CommandRuntime.__index = CommandRuntime

CommandRuntime.fzy = fzy
CommandRuntime.Gizmos = Gizmos
CommandRuntime.Iris = Iris

export type CommandRuntime = setmetatable<{ trove: Trove.Trove, command: any, log: Log.Log }, typeof(CommandRuntime)>

-- Command
function CommandRuntime.cleanup(self: CommandRuntime)
	self.trove:Clean()
end

function CommandRuntime:createCommandOutput(): types.CommandOutput
	return {}
end

-- Plugin
function CommandRuntime:getMouse()
	return assert(plugin:GetMouse())
end

function CommandRuntime:getSelection()
	return Selection:Get()
end

function CommandRuntime:setSelection(instances: { Instance })
	Selection:Set(instances)
end

-- History
export type RecordChangeHistoryOptions = {
	name: string?,
	displayName: string?,

	ignoreRobloxFailure: boolean?,
	hideRobloxFailure: boolean?,

	-- TODO: implement cancellation
	isCancellable: boolean?,
	cancelsOthers: boolean?,
}

--[=[
	@method recordChangeHistory
	@within Runtime

	Records changes made while a command is being run. Then, it commits when
	either the command is cleaned up or the returned cleanup callback is called.
]=]
function CommandRuntime.recordChangeHistory(self: CommandRuntime, recordingOptions: RecordChangeHistoryOptions?)
	local options = recordingOptions or {} :: never

	local name = if options.name then `{self.command:getFullId()}/{options.name}` else self.command:getFullId()
	local displayName = "Rocket: "
		.. if options.displayName
			then `{self.command.interface.title} - {options.displayName}`
			else self.command.interface.title

	local success, id: string? = pcall(ChangeHistoryService.TryBeginRecording, ChangeHistoryService, name, displayName)

	if id == nil then
		if not options.hideRobloxFailure then
			local reason = if not success
				then "Roblox failed to begin recording the action"
				elseif ChangeHistoryService:IsRecordingInProgress() then "an undo-able action is still running"
				elseif RunService:IsRunning() then "the game is running"
				else "there was an unknown Roblox issue"

			self.log:warn("Failed to record changes for", displayName, "because", reason, `(recording name: {name})`)
		end

		if not options.ignoreRobloxFailure then
			return noop :: (operation: Enum.FinishRecordingOperation?) -> ()
		end
	end

	local function finishRecording(operation: Enum.FinishRecordingOperation?)
		if id then
			local recordingId = id
			id = nil
			ChangeHistoryService:FinishRecording(recordingId, operation or Enum.FinishRecordingOperation.Commit)
		end
	end

	self.trove:Add(finishRecording :: any)
	return finishRecording
end

-- Keys
function CommandRuntime:useKeyDown(keyCode: Enum.KeyCode)
	return useKeys.isDown(keyCode)
end

function CommandRuntime:useKeyJustPressed(keyCode: Enum.KeyCode)
	return useKeys.isJustPressed(keyCode)
end

function CommandRuntime:useKeyJustReleased(keyCode: Enum.KeyCode)
	return useKeys.isJustReleased(keyCode)
end

function CommandRuntime:consumeKeyPressed(keyCode: Enum.KeyCode)
	return useKeys.andConsumePress(keyCode)
end

return table.freeze(CommandRuntime)
