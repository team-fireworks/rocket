local types = require("@src/types")

local function isOutputsUi(output: types.CommandOutput?)
	return output ~= nil and (output.renderViewport or output.renderWindow) ~= nil
end

return isOutputsUi
