local setLightingDirection = require("../utils/setLightingDirection")
local types = require("../types")

local sun = {} :: types.Source
sun.name = "Sun"

function sun.updateDirection(direction)
	setLightingDirection(direction, 1)
end

return sun
