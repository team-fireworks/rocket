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
		if result.windowConfig then
			Iris.PushConfig(table.clone(result.windowConfig))
		end

		local isOpened = Iris.State(true)
		Iris.SetNextWidgetID(`{prefixId(command:formatId())}/window`)
		local window = Iris.Window(result.windowArgs :: any or { command.metadata.title }, { isOpened = isOpened })

		if result.windowConfig then
			Iris.PopConfig()
		end

		if isOpened.value then
			result.renderWindow(window)
			Iris.End()
			return
		end

		isOpened:set(true)
		scopes[command]:cleanup()
		Iris.End()
	end
end

return renderCommandResult
