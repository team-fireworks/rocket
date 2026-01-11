local drawDirection = require("../gizmos/drawDirection")
local reflect = require("../utils/reflect")
local types = require("../types")

local reposition = {} :: types.Reposition
reposition.name = "Reflection"
reposition.describedBy = "casting a reflection at your mouse"

function reposition.updateDirection(_, now, isGizmos)
	local reflection = reflect(now.mouseTransform.LookVector, Vector3.new(0, 1, 0))
	local direction = CFrame.lookAt(now.mouseTransform.Position, now.mouseTransform.Position + reflection).LookVector

	if isGizmos then
		drawDirection(now.mouseTransform.Position, direction)
	end

	return direction
end

return reposition
