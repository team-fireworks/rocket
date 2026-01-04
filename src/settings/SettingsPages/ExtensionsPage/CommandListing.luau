local Command = require("@src/commands/Command")
local Iris = require("@src/Iris")
local useExtensionPageState = require("./useExtensionPageState")

local function CommandListing(cmd: Command.Command, state: useExtensionPageState.ExtensionPageState)
	local group = Iris.ButtonGroup(UDim2.fromScale(1, 0))
	if group.clicked() then
		state.selected:set(cmd)
	end
	Iris.Icon(cmd.metadata.icon or cmd.extension.metadata.icon, UDim2.fromOffset(18, 18))
	Iris.Text({ cmd.metadata.title })
	Iris.End()
	return group
end

return CommandListing
