local CommandRuntime = require("./CommandRuntime")
local assets = require("@include/assets")
local types = require("@src/types")

export type CommandRunner =
	| ((r: CommandRuntime.CommandRuntime) -> ())
	| ((r: CommandRuntime.CommandRuntime) -> types.CommandOutput)
	| ((r: CommandRuntime.CommandRuntime) -> types.CommandOutput?)

local Command = {}
Command.__index = Command

-- LUAU: `Command.extension` is typed as any to avoid cyclic requires
export type Command = setmetatable<{
	_extension: any,
	_runner: CommandRunner,
	interface: types.CommandInterface,
}, typeof(Command)>

function Command.is(x: unknown)
	return typeof(x) == "table" and getmetatable(x) == Command
end

function Command.isHeadless(self: Command)
	return self._extension == nil
end

function Command.getAuthors(self: Command): { types.Author }
	return self.interface.authors or self._extension.interface.authors or {}
end

function Command.getIcon(self: Command): string
	return self.interface.icon or self._extension.interface.icon or assets.extensions.rocket
end

function Command.getFullId(self: Command)
	return self._extension.metadata.id .. ":" .. self.interface.id
end

function Command.compareTitles(lhs: Command, rhs: Command)
	return lhs.interface.title < rhs.interface.title
end

function Command.__tostring(self: Command)
	return `Command({string.format("%q", self:getFullId())})`
end

return table.freeze(Command)
