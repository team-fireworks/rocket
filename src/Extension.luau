local Charm = require("@pkgs/Charm")
local Command = require("@src/commands/Command")
local CommandContext = require("@src/commands/CommandContext")
local types = require("@src/types")

local plugin = script:FindFirstAncestorWhichIsA("Plugin")

export type CommandContext = CommandContext.CommandContext

export type ExtensionMetadata = {
	id: string,
	title: string,
	description: string,
	icon: string,
	authors: { string },
}

local Extension = {}
Extension.__index = Extension

export type Extension = setmetatable<{
	read _plugin: Plugin,
	read commands: { Command.Command },
	read metadata: ExtensionMetadata,
}, typeof(Extension)>

Extension.allExtensions = Charm.atom({} :: { [Extension]: true })

Extension.sortedByTitle = Charm.computed(function(): { Extension }
	local result = {}
	for extension in Extension.allExtensions() do
		table.insert(result, extension)
	end
	table.sort(result, function(lhs: Extension, rhs: Extension): boolean
		return lhs.metadata.title < rhs.metadata.title
	end)
	return result
end)

Extension.extensionTitles = Charm.computed(function(): { string }
	local allExtensions = Extension.sortedByTitle()
	local result = table.create(#allExtensions) :: { string }
	for _, ext in allExtensions do
		table.insert(result, ext.metadata.title)
	end
	table.sort(result)
	return result
end)

Extension.allCommands = Charm.computed(function(): { Command.Command }
	local result = {}
	for extension in Extension.allExtensions() do
		table.move(extension.commands, 1, #extension.commands, #result + 1, result)
	end
	table.sort(result, Command.compareTitles)
	return result
end)

Extension.commandToIndex = Charm.computed(function(): { [Command.Command]: number }
	local allCommands = Extension.allCommands()
	local result = table.create(#allCommands) :: { [Command.Command]: number }
	for index, command in allCommands do
		result[command] = index
	end
	return result
end)

Extension.commandTitles = Charm.computed(function(): { string }
	local allCommands = Extension.allCommands()
	local result = table.create(#allCommands) :: { string }
	for i, cmd in allCommands do
		result[i] = cmd.metadata.title
	end
	return result
end)

Extension.extensionsById = Charm.computed(function(): { [string]: Extension }
	local result = {}
	for extension in Extension.allExtensions() do
		result[extension.metadata.id] = extension
	end
	return result
end)

-- TODO: flow to validate third party plugins
function Extension.new(extPlugin: Plugin, extMetadata: ExtensionMetadata): Extension
	if Extension.extensionsById()[extMetadata.id] then
		error(`Extension conflicts with id: {extMetadata.id}`)
	end
	local self = setmetatable({ _plugin = extPlugin, metadata = extMetadata, commands = {} }, Extension)
	local allExtensions = table.clone(Extension.allExtensions())
	allExtensions[self] = true
	Extension.allExtensions(allExtensions)
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
	commandMetadata: Command.CommandMetadata,
	commandRunner: Command.CommandRunner
)
	local command = Command.new(self, commandMetadata, commandRunner)
	table.insert(self.commands, command)
end

function Extension.destroy(self: Extension)
	local allExtensions = table.clone(Extension.allExtensions())
	allExtensions[self] = nil
	Extension.allExtensions(allExtensions)
end

function Extension.__tostring(self: Extension)
	return `Extension({string.format("%q", self.metadata.id)})`
end

return table.freeze(Extension)
