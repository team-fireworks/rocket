-- selene: allow(unused_variable)
local Iris = require("@pkgs/Iris")
local typeforge = require("@vendor/typeforge")

export type Config = typeof(Iris._config)
export type PartialConfig = typeforge.Partial<Config>

export type Theme = {
	name: string,
	colors: PartialConfig,
}

export type StudioTheme = {
	dark: Theme,
	light: Theme,
}

return nil
