local Extension = require("@src/core/Extension")
local createExtension = require("./createExtension")
local plugin = require("@src/plugin")
local types = require("@src/types")

local function createCoreExtension(interface: types.ExtensionInterface): Extension.Extension
	return createExtension(plugin, interface)
end

return createCoreExtension
