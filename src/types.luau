local Iris = require("@src/Iris")

export type ExtensionMetadata = {
	id: string,
	title: string,
	description: string,
	icon: string,
	authors: { string },
}

export type CommandMetadata = {
	read id: string,
	read title: string,
	read description: string,
	read authors: { string }?,
	read icon: string?,
}

export type CommandResult = {
	renderViewport: () -> ()?,

	renderWindow: (window: Iris.Window) -> ()?,
	windowArgs: { unknown }?,
	windowConfig: Iris.PartialConfig?,
}

export type Error = {
	raw: string,
	message: string,
	trace: string,
}

return nil
