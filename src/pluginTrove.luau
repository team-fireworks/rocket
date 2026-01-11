local Trove = require("@pkgs/Trove")
local plugin = require("@src/plugin")

local pluginTrove = Trove.new()
pluginTrove:Add(plugin.Unloading:Connect(pluginTrove:WrapClean()))

return pluginTrove
