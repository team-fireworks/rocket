local drawLine = require("../gizmos/drawLine")
local types = require("../types")

local line = {} :: types.Reposition
line.name = "Line"
line.describedBy = "a line that shadows will follow"

function line.updateDirection(initial, now, isGizmos)
	local transform = CFrame.lookAt(now.mouseTransform.Position, initial.mouseTransform.Position)
	if isGizmos then
		drawLine(initial.mouseTransform, now.mouseTransform)
	end
	return transform.LookVector
end

return line
