local Charm = require("@pkgs/Charm")
local Command = require("@src/core/commands/Command")
local Extension = require("@src/core/Extension")
local atoms = require("@src/utils/atoms")
local types = require("./types")

local SettingsStore = {
	isVisible = Charm.atom(false),
	currentPage = Charm.atom(nil :: types.SettingsPage?),
}

SettingsStore.resetBase = atoms.wrapSetDefaults(SettingsStore)

SettingsStore.extensions = {
	showEnabled = Charm.atom(true),
	showDisabled = Charm.atom(true),
	showCore = Charm.atom(true),
	showThirdParty = Charm.atom(true),

	massCollapse = Charm.atom(nil :: boolean?),
	extensionsCollapsed = Charm.atom({} :: { [Extension.Extension]: true }),

	selected = Charm.atom(nil :: nil | Extension.Extension | Command.Command),
}

SettingsStore.resetExtensions = atoms.wrapSetDefaults(SettingsStore.extensions)

function SettingsStore.reset()
	SettingsStore.resetBase()
	SettingsStore.resetExtensions()
end

return SettingsStore
