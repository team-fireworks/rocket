local setLightingDirection = require("../utils/setLightingDirection")
local types = require("../types")

local moon = {} :: types.Source
moon.name = "Moon"

function moon.updateDirection(direction)
	setLightingDirection(direction, -1)
end

return moon
