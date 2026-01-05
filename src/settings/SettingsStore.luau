local Charm = require("@pkgs/Charm")

local SettingsStore = {}
SettingsStore.isVisible = Charm.atom(false)

return SettingsStore
