local ChangeHistoryService = game:GetService("ChangeHistoryService")
local Selection = game:GetService("Selection")

local Iris = require("@src/Iris")
local Log = require("@src/utils/Log")
local Trove = require("@pkgs/Trove")
local fzy = require("@vendor/fzy")
local widgets = require("@src/widgets")

local plugin = script:FindFirstAncestorWhichIsA("Plugin") :: Plugin

--[=[
	@class CommandScope
]=]
local CommandScope = {}
CommandScope.__index = CommandScope

-- FIXME: vanilla Iris is used as Rocket's types is too complex
CommandScope.Iris = Iris
CommandScope.Gizmos = {}
CommandScope.widgets = widgets
CommandScope.fzy = fzy

-- LUAU: `CommandContext.command` is typed as any to avoid cyclic requires
export type CommandScope = setmetatable<{
	read command: any,
	read trove: Trove.Trove,
	read log: Log.Log,
}, typeof(CommandScope)>

function CommandScope.new(trove: Trove.Trove, command: any): CommandScope
	return table.freeze(setmetatable({
		command = command,
		trove = trove,
		log = Log.new(tostring(command)),
	}, CommandScope))
end

function CommandScope.cleanup(self: CommandScope)
	self.trove:Destroy()
end

function CommandScope:getSelection()
	return Selection:Get()
end

function CommandScope:setSelection(instances: { Instance })
	Selection:Set(instances)
end

function CommandScope:getMouse()
	return assert(plugin:GetMouse())
end

function CommandScope.recordChanges(self: CommandScope, id: string?, title: string?)
	local changeId = ChangeHistoryService:TryBeginRecording(
		if id then self.command:formatId() .. "/" .. id else self.command:formatId(),
		if title then `Rocket - {self.command.metadata.title}: {title}` else `Rocket: {self.command.metadata.title}`
	)

	if changeId then
		self.trove:Add(function()
			ChangeHistoryService:FinishRecording(changeId, Enum.FinishRecordingOperation.Commit)
		end)
	end
end

function CommandScope.__tostring(self: CommandScope)
	return `CommandScope({string.format("%q", self.command:formatId())})`
end

return table.freeze(CommandScope)
