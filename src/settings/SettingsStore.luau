local Charm = require("@pkgs/Charm")
local SettingsPages = require("@settings/SettingsPages")

local SettingsStore = {}
SettingsStore.isVisible = Charm.atom(false)
SettingsStore.currentPage = Charm.atom(SettingsPages[1])

return SettingsStore
