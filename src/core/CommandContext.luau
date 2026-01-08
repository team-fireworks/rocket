local ChangeHistoryService = game:GetService("ChangeHistoryService")
local Selection = game:GetService("Selection")

local Iris = require("@src/Iris")
local Log = require("@src/utils/Log")
local Trove = require("@pkgs/Trove")
local fzy = require("@include/fzy")
local types = require("@src/types")
local widgets = require("@src/widgets")

local plugin = script:FindFirstAncestorWhichIsA("Plugin") :: Plugin

--[=[
	@class CommandContext
]=]
local CommandContext = {}
CommandContext.__index = CommandContext

-- FIXME: vanilla Iris is used as Rocket's types is too complex
CommandContext.Iris = Iris
CommandContext.Gizmos = {}
CommandContext.widgets = widgets
CommandContext.fzy = fzy

-- LUAU: `CommandContext.command` is typed as any to avoid cyclic requires
export type CommandContext = setmetatable<{
	read command: any,
	read trove: Trove.Trove,
	read log: Log.Log,
}, typeof(CommandContext)>

function CommandContext.new(trove: Trove.Trove, command: any): CommandContext
	return table.freeze(setmetatable({
		command = command,
		trove = trove,
		log = Log.new(tostring(command)),
	}, CommandContext))
end

function CommandContext.cleanup(self: CommandContext)
	self.trove:Destroy()
end

function CommandContext:getSelection()
	return Selection:Get()
end

function CommandContext:setSelection(instances: { Instance })
	Selection:Set(instances)
end

function CommandContext:getMouse()
	return assert(plugin:GetMouse())
end

function CommandContext.recordChanges(self: CommandContext, id: string?, title: string?)
	local changeId = ChangeHistoryService:TryBeginRecording(
		if id then self.command:formatId() .. "/" .. id else self.command:formatId(),
		if title then `Rocket - {self.command.metadata.title}: {title}` else `Rocket: {self.command.metadata.title}`
	)

	local function finish()
		if changeId then
			ChangeHistoryService:FinishRecording(changeId, Enum.FinishRecordingOperation.Commit)
			changeId = nil
		end
	end

	self.trove:Add(finish)

	return finish
end

function CommandContext:newResult(): types.CommandResult
	return {}
end

function CommandContext.__tostring(self: CommandContext)
	return `CommandContext({string.format("%q", self.command:formatId())})`
end

return table.freeze(CommandContext)
