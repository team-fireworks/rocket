local Charm = require("@pkgs/Charm")
local Iris = require("@src/Iris")
local Trove = require("@pkgs/Trove")
local types = require("@self/types")

export type Theme = types.Theme
export type StudioTheme = types.StudioTheme

local THEMES = table.freeze({
	IRIS = require("@self/themes/iris"),
})

local PRESETS = table.freeze({
	BASE = require("@self/presets/base"),
	BUTTONS = table.freeze({
		HIGHLIGHTED = require("@self/presets/buttons/highlighted"),
		UNHIGHLIGHTED = require("@self/presets/buttons/unhighlighted"),
		SELECTED = require("@self/presets/buttons/selected"),
	}),
})

local function getStudio(): "dark" | "light"
	local studioBG = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.MainBackground)
	local isDark = studioBG.R + studioBG.G + studioBG.B < 1.5
	return if isDark then "dark" else "light"
end

local studio = Charm.atom(getStudio())
local function observeStudio(trove: Trove.Trove)
	trove:Add(settings().Studio.ThemeChanged:Connect(function()
		studio(getStudio())
	end))
end

local userPreferredTheme = Charm.atom(THEMES.IRIS) :: Charm.Atom<Theme | StudioTheme>

local selectedUserTheme = Charm.computed(function(): Theme
	local userPreferredThemeNow = userPreferredTheme()
	local asTheme, asStudio = userPreferredThemeNow :: Theme, userPreferredThemeNow :: StudioTheme
	return if asTheme.name then asTheme else (asStudio :: any)[studio()]
end)

local config = Charm.computed(function(): Iris.PartialConfig
	local result = table.clone(PRESETS.BASE)
	for key, value in selectedUserTheme() :: { [string]: any } do
		(result :: any)[key] = value
	end
	return result
end)

return table.freeze {
	THEMES = THEMES,
	PRESETS = PRESETS,

	studio = studio,
	getStudio = getStudio,
	observeStudio = observeStudio,

	userPreferredTheme = userPreferredTheme,
	selectedUserTheme = selectedUserTheme,
	config = config,
}
