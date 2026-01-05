local UserInputService = game:GetService("UserInputService")

local Command = require("@src/core/Command")
local CommandScope = require("@src/core/CommandScope")
local Iris = require("@src/Iris")
local prefixId = require("@src/utils/prefixId")

local function renderCommandResult(
	command: Command.Command,
	result: Command.CommandResult,
	scopes: { [Command.Command]: CommandScope.CommandScope }
)
	if result.renderViewport then
		result.renderViewport()
	end

	if result.renderWindow then
		local isOpened = Iris.State(true)
		Iris.SetNextWidgetID(`{prefixId(command:formatId())}/window`)
		Iris.Window(result.windowArgs :: any or { command.metadata.title }, {
			isOpened = isOpened,
			-- TODO: this doesnt update in subsequent reruns
			position = UserInputService:GetMouseLocation(),
		})

		if isOpened.value then
			result.renderWindow()
			Iris.End()
			return
		end

		isOpened:set(true)
		scopes[command]:cleanup()
		Iris.End()
	end
end

return renderCommandResult
