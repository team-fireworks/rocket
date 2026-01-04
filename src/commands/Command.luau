local CommandContext = require("./CommandContext")

type CommandContext = CommandContext.CommandContext

export type CommandMetadata = {
	read id: string,
	read title: string,
	read description: string,
	read icon: string?,
}

export type CommandResult = {
	renderViewport: () -> ()?,
	renderWindow: () -> ()?,
}

export type CommandRunner =
	| ((ctx: CommandContext) -> ())
	| ((ctx: CommandContext) -> CommandResult)
	| ((ctx: CommandContext) -> CommandResult?)

local Command = {}
Command.__index = Command

-- LUAU: `Command.extension` is typed as any to avoid cyclic requires
export type Command = setmetatable<{
	read extension: any,
	read metadata: CommandMetadata,
	read runner: CommandRunner,
}, typeof(Command)>

function Command.new(extension: any, metadata: CommandMetadata, runner: CommandRunner): Command
	return table.freeze(setmetatable({
		extension = extension,
		metadata = table.freeze(table.clone(metadata)),
		runner = runner,
	}, Command))
end

function Command.is(x: unknown)
	return typeof(x) == "table" and getmetatable(x) == Command
end

function Command.formatId(self: Command)
	return self.extension.metadata.id .. ":" .. self.metadata.id
end

function Command.compareTitles(lhs: Command, rhs: Command)
	return lhs.metadata.title < rhs.metadata.title
end

function Command.__tostring(self: Command)
	return `Command({string.format("%q", self:formatId())})`
end

return table.freeze(Command)
