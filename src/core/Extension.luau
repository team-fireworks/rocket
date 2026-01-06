local Charm = require("@pkgs/Charm")
local Command = require("@src/core/Command")
local CommandContext = require("@src/core/CommandContext")
local Log = require("@src/utils/Log")
local types = require("@src/types")

local plugin = script:FindFirstAncestorWhichIsA("Plugin")

export type CommandResult = types.CommandResult
export type CommandContext = CommandContext.CommandContext

local log = Log.new(script)

local Extension = {}
Extension.__index = Extension

export type Extension = setmetatable<{
	read _plugin: Plugin,
	read commands: { Command.Command },
	read metadata: types.ExtensionMetadata,
}, typeof(Extension)>

-- TODO: flow to validate third party plugins
function Extension.new(extPlugin: Plugin, extMetadata: types.ExtensionMetadata): Extension
	if Extension._extensionsById()[extMetadata.id] then
		error(`Extension conflicts with id: {extMetadata.id}`)
	end
	local self = setmetatable({ _plugin = extPlugin, metadata = extMetadata, commands = {} }, Extension)
	local allExtensions = table.clone(Extension._allExtensions())
	allExtensions[self] = true
	Extension._allExtensions(allExtensions)
	log:trace("Registered new extension:", extMetadata.id)
	return table.freeze(self)
end

function Extension.is(x: unknown)
	return typeof(x) == "table" and getmetatable(x) == Extension
end

function Extension.isCore(self: Extension)
	return self._plugin == plugin
end

function Extension.newCommand(
	self: Extension,
	commandMetadata: types.CommandMetadata,
	commandRunner: Command.CommandRunner
)
	local command = Command.new(self, commandMetadata, commandRunner)
	log:trace("Extension", self.metadata.id, "registered new command", commandMetadata.id)
	table.insert(self.commands, command)
end

function Extension.destroy(self: Extension)
	local allExtensions = table.clone(Extension._allExtensions())
	allExtensions[self] = nil
	Extension._allExtensions(allExtensions)
end

function Extension.compareByTitle(lhs: Extension, rhs: Extension): boolean
	return lhs.metadata.title < rhs.metadata.title
end

function Extension.__tostring(self: Extension)
	return `Extension({string.format("%q", self.metadata.id)})`
end

Extension._allExtensions = Charm.atom({} :: { [Extension]: true })

Extension._extensionsSortedByTitle = Charm.computed(function(): { Extension }
	local result = {}
	for extension in Extension._allExtensions() do
		table.insert(result, extension)
	end
	table.sort(result, Extension.compareByTitle)
	return result
end)

Extension._extensionTitles = Charm.computed(function(): { string }
	local allExtensions = Extension._extensionsSortedByTitle()
	local result = table.create(#allExtensions) :: { string }
	for _, ext in allExtensions do
		table.insert(result, ext.metadata.title)
	end
	table.sort(result)
	return result
end)

Extension._extensionsById = Charm.computed(function(): { [string]: Extension }
	local result = {}
	for extension in Extension._allExtensions() do
		result[extension.metadata.id] = extension
	end
	return result
end)

Extension._allCommands = Charm.computed(function(): { Command.Command }
	local result = {}
	for extension in Extension._allExtensions() do
		table.move(extension.commands, 1, #extension.commands, #result + 1, result)
	end
	table.sort(result, Command.compareTitles)
	return result
end)

Extension._commandToIndex = Charm.computed(function(): { [Command.Command]: number }
	local allCommands = Extension._allCommands()
	local result = table.create(#allCommands) :: { [Command.Command]: number }
	for index, command in allCommands do
		result[command] = index
	end
	return result
end)

Extension._commandTitles = Charm.computed(function(): { string }
	local allCommands = Extension._allCommands()
	local result = table.create(#allCommands) :: { string }
	for i, cmd in allCommands do
		result[i] = cmd.metadata.title
	end
	return result
end)

return table.freeze(Extension)
