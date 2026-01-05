local Iris = require("@src/Iris")

export type Theme = {
	name: string,
	colors: Iris.PartialConfig,
}

export type StudioTheme = {
	dark: Theme,
	light: Theme,
}

return nil
