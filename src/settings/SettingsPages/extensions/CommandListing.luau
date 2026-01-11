local Command = require("@src/core/commands/Command")
local Iris = require("@src/Iris")
local SettingsStore = require("@src/settings/SettingsStore")
local widgets = require("@src/widgets")

local function CommandListing(command: Command.Command)
	local group = widgets.ButtonGroup({ size = UDim2.fromScale(1, 0) })
	if group.clicked() then
		SettingsStore.extensions.selected(if SettingsStore.extensions.selected() == command then nil else command)
	end
	Iris.Image({ command:getIcon(), UDim2.fromOffset(18, 18) })
	Iris.Text({ command.interface.title })
	Iris.End()
	return group
end

return CommandListing
