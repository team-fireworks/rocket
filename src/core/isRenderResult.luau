local types = require("@src/types")

local function isRenderResult(result: types.CommandResult?)
	return result ~= nil and (result.renderViewport or result.renderWindow) ~= nil
end

return isRenderResult
