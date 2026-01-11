local Boba = require("@include/boba")
local Iris = require("@src/Iris")

local AuthorUser = Boba.Struct {
	type = Boba.Literal("user").inner :: "user",
	id = Boba.Number.inner,
}:Nickname("AuthorUser")

local AuthorCustom = Boba.Struct {
	type = Boba.Literal("custom").inner :: "custom",
	image = Boba.String.inner,
	name = Boba.String.inner,
}:Nickname("AuthorCustom")

local Author = Boba
	.String
	:Or(AuthorUser)
	-- :Or(Boba.Struct {
	-- 	type = Boba.Literal("group").inner :: "group",
	-- 	id = Boba.Number.inner,
	-- })
	:Or(
		AuthorCustom
	)
	:Nickname("Author")

local ExtensionInterface = Boba.Struct {
	id = Boba.String.inner,
	title = Boba.String.inner,
	description = Boba.String:Optional().inner,
	contributors = Author:Array().inner,
	icon = Boba.String.inner,
}:Nickname("ExtensionInterface")

-- TODO: is there a better way to do this...?
local CommandArgument = Boba.Struct {
	type = Boba.Literal("text").inner :: "text",

	name = Boba.String.inner,
	placeholder = Boba.String.inner,
	required = Boba.Boolean:Optional().inner,
}
	:Or(Boba.Struct {
		type = Boba.Literal("instance-class").inner :: "instance-class",

		name = Boba.String.inner,
		placeholder = Boba.String.inner,
		required = Boba.Boolean:Optional().inner,
	}:Or(Boba.Struct {
		type = Boba.Literal("password").inner :: "password",

		name = Boba.String.inner,
		placeholder = Boba.String.inner,
		required = Boba.Boolean:Optional().inner,
	}:Or(Boba.Struct {
		type = Boba.Literal("select").inner :: "select",

		name = Boba.String.inner,
		placeholder = Boba.String.inner,
		required = Boba.Boolean:Optional().inner,

		options = Boba.Array(Boba.Struct {
			title = Boba.String.inner,
			value = Boba.String.inner,
		}).inner,
	})))
	:Nickname("CommandArgument")

local CommandInterface = Boba.Struct {
	id = Boba.String.inner,
	title = Boba.String.inner,
	description = Boba.String.inner,
	contributors = Author:Array():Optional().inner,
	icon = Boba.String:Optional().inner,

	arguments = CommandArgument:Array():Optional().inner,
}:Nickname("CommandInterface")

local CommandOutput = Boba.Struct {
	renderViewport = Boba.Function:Optional():Nickname("() -> ()?").inner :: () -> ()?,

	windowArgs = Boba.Unknown:Array():Optional().inner,
	windowConfig = Boba.String:Map(Boba.Any):Optional().inner,
	renderWindow = Boba.Function:Optional():Nickname("(Iris.Window) -> ()?").inner :: (window: Iris.Window) -> ()?,
}:Nickname("output")

export type Author = typeof(Author.inner)
export type AuthorUser = typeof(AuthorUser.inner)
export type AuthorCustom = typeof(AuthorCustom.inner)
export type ExtensionInterface = typeof(ExtensionInterface.inner)
export type CommandArgument = typeof(CommandArgument.inner)
export type CommandInterface = typeof(CommandInterface.inner)
export type CommandOutput = typeof(CommandOutput.inner)

export type Error = {
	raw: string,
	message: string,
	trace: string,
}

return table.freeze {
	ExtensionInterface = ExtensionInterface,
	CommandArgument = CommandArgument,
	CommandInterface = CommandInterface,
	CommandOutput = CommandOutput,
	Author = Author,
}
