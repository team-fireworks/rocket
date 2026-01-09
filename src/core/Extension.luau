local Charm = require("@pkgs/Charm")
local Command = require("@src/core/commands/Command")
local CommandRuntime = require("@src/core/commands/CommandRuntime")
local atoms = require("@src/utils/atoms")
local createCommand = require("@src/core/constructors/createCommand")
local types = require("@src/types")

local plugin = script:FindFirstAncestorWhichIsA("Plugin")

export type CommandOutput = types.CommandOutput
export type CommandRuntime = CommandRuntime.CommandRuntime

local Extension = {}
Extension.__index = Extension

export type Extension = setmetatable<{
	_plugin: Plugin,
	_commands: { Command.Command },
	_unloadingConnection: RBXScriptConnection,
	interface: types.ExtensionInterface,
}, typeof(Extension)>

function Extension.is(x: unknown)
	return typeof(x) == "table" and getmetatable(x) == Extension
end

function Extension.isCore(self: Extension)
	return self._plugin == plugin
end

function Extension.pushCommand(self: Extension, command: Command.Command)
	if command:isHeadless() then
		command._extension = self :: any
		table.insert(self._commands, command)
		return
	end

	error(`command "{command.interface.id}" is already bounded to the extension "{command._extension.interface.id}".`)
end

function Extension.newCommand(self: Extension, interface: types.CommandInterface, runner: Command.CommandRunner)
	self:pushCommand(createCommand(interface, runner))
end

function Extension.destroy(self: Extension)
	if self._unloadingConnection and self._unloadingConnection.Connected then
		self._unloadingConnection:Disconnect()
	end
	atoms.set(Extension._allExtensions :: any, self, nil)
end

function Extension.compareByTitle(lhs: Extension, rhs: Extension): boolean
	return lhs.interface.title < rhs.interface.title
end

function Extension.__tostring(self: Extension)
	return `Extension({string.format("%q", self.interface.id)})`
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
		table.insert(result, ext.interface.title)
	end
	table.sort(result)
	return result
end)

Extension._extensionsById = Charm.computed(function(): { [string]: Extension }
	local result = {}
	for extension in Extension._allExtensions() do
		result[extension.interface.id] = extension
	end
	return result
end)

Extension._allCommands = Charm.computed(function(): { Command.Command }
	local result = {}
	for extension in Extension._allExtensions() do
		table.move(extension._commands, 1, #extension._commands, #result + 1, result)
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
		result[i] = cmd.interface.title
	end
	return result
end)

return table.freeze(Extension)
