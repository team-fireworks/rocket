local Extension = require("@src/core/Extension")
local atoms = require("@src/utils/atoms")
local types = require("@src/types")

local function createExtension(plugin: Plugin, interface: types.ExtensionInterface): Extension.Extension
	types.ExtensionInterface:assert(interface)
	if Extension._extensionsById()[interface.id] then
		error(`got duplicate extension with ID "{interface.id}"`)
	end

	local self: Extension.Extension
	self = setmetatable({
		_commands = {},
		_unloadingConnection = plugin.Unloading:Connect(function()
			self:destroy()
		end),
		interface = table.freeze(table.clone(interface)),
	}, Extension) :: Extension.Extension

	atoms.set(Extension._allExtensions, self, true :: true)
	return table.freeze(self :: any)
end

return createExtension
