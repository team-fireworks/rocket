local Command = require("@src/core/Command")
local Iris = require("@src/Iris")
local LauncherStore = require("./LauncherStore")
local runCommand = require("@src/core/runCommand")
local widgets = require("@src/widgets")

local function LauncherCommand(command: Command.Command)
	if widgets.ButtonGroup({ Size = UDim2.fromScale(1, 0) }).clicked() then
		LauncherStore.isVisible(false)
		task.defer(runCommand, command)
	end

	Iris.Image({ command.metadata.icon or command.extension.metadata.icon, UDim2.fromOffset(18, 18) })
	Iris.Text({ command.metadata.title })
	widgets.Subtext({ command.extension.metadata.title })
	widgets.FlexFiller({ Mode = Enum.UIFlexMode.Fill })
	-- widgets.Subtext({ "Command" })

	Iris.End()
end

return LauncherCommand
