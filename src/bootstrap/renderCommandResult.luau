local Command = require("@src/core/Command")
local CommandContext = require("@src/core/CommandContext")
local Iris = require("@src/Iris")
local prefixId = require("@src/utils/prefixId")
local types = require("@src/types")

local function renderCommandResult(
	command: Command.Command,
	result: types.CommandResult,
	contexts: { [Command.Command]: CommandContext.CommandContext }
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
		contexts[command]:cleanup()
		Iris.End()
	end
end

return renderCommandResult
