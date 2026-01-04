local ChangeHistoryService = game:GetService("ChangeHistoryService")
local Selection = game:GetService("Selection")

local Gizmos = require("@src/Gizmos")
local Iris = require("@src/Iris")
local Trove = require("@pkgs/Trove")
local fzy = require("@vendor/fzy")

local CommandContext = {}
CommandContext.__index = CommandContext
CommandContext.iris = Iris
CommandContext.gizmos = Gizmos
CommandContext.fzy = fzy

-- LUAU: command is typed any to avoid circular requires
export type CommandContext = setmetatable<{
	command: any,
	trove: Trove.Trove,
	mouse: PluginMouse,
	state: { [any]: any },
}, typeof(CommandContext)>

function CommandContext.new(command: any, plugin: Plugin, trove: Trove.Trove): CommandContext
	local self = setmetatable({
		command = command,
		trove = trove,
		mouse = plugin:GetMouse(),
		state = {},
	}, CommandContext)

	trove:Add(function()
		table.clear(self.state)
	end)

	return self
end

function CommandContext.recordChanges(self: CommandContext, id: string?, title: string?)
	local changeId = ChangeHistoryService:TryBeginRecording(
		if id then self.command:formatId() .. "/" .. id else self.command:formatId(),
		if title then `Rocket - {self.command._metadata.title}: {title}` else `Rocket: {self.command._metadata.title}`
	)

	if changeId then
		self.trove:Add(function()
			ChangeHistoryService:FinishRecording(changeId, Enum.FinishRecordingOperation.Commit)
		end)
	end
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

function CommandContext.getState(self: CommandContext, key: any): any
	return self.state[key]
end

function CommandContext.setState<T>(self: CommandContext, key: any, value: T): T
	self.state[key] = value
	return value
end

function CommandContext.__tostring(self: CommandContext)
	return `CommandContext({string.format("%q", self.command:formatId())})`
end

return table.freeze(CommandContext)
