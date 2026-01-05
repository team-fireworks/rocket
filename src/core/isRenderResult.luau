local Command = require("./Command")

local function isRenderResult(result: Command.CommandResult?)
	return result ~= nil and (result.renderViewport or result.renderWindow) ~= nil
end

return isRenderResult
