local ChangeHistoryService = game:GetService("ChangeHistoryService")
local Selection = game:GetService("Selection")

local Gizmos = require("@src/Gizmos")
local Iris = require("@src/Iris")
local Trove = require("@pkgs/Trove")
local fzy = require("@vendor/fzy")

local CommandContext = {}
CommandContext.__index = CommandContext
CommandContext.Iris = Iris
CommandContext.Gizmos = Gizmos
CommandContext.fzy = fzy

-- LUAU: `CommandContext.command` is typed as any to avoid cyclic requires
export type CommandContext = setmetatable<{
	read command: any,
	read trove: Trove.Trove,
	read mouse: PluginMouse,
}, typeof(CommandContext)>

function CommandContext.new(command: any, plugin: Plugin, trove: Trove.Trove): CommandContext
	return table.freeze(setmetatable({
		command = command,
		trove = trove,
		mouse = plugin:GetMouse(),
	}, CommandContext))
end

function CommandContext.cleanup(self: CommandContext)
	self.trove:Destroy()
end

function CommandContext.addCleanup(self: CommandContext, trackable: Trove.Trackable)
	self.trove:Add(trackable)
end

function CommandContext:getSelection()
	return Selection:Get()
end

function CommandContext:setSelection(instances: { Instance })
	Selection:Set(instances)
end

function CommandContext.recordChanges(self: CommandContext, id: string?, title: string?)
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

function CommandContext.__tostring(self: CommandContext)
	return `CommandContext({string.format("%q", self.command:formatId())})`
end

return table.freeze(CommandContext)
