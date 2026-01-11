local drawLine = require("../gizmos/drawLine")
local types = require("../types")

local shadow = {} :: types.Reposition
shadow.name = "Shadow"
shadow.describedBy = "moving shadows with your cursor"

function shadow.updateDirection(initial, now, isGizmos)
	local negative = (now.mouseTransform.Position - initial.mouseTransform.Position)
	local otherDistance = (now.mouseTransform.Position - initial.mouseTransform.Position).Magnitude

	if isGizmos then
		drawLine(initial.mouseTransform, now.mouseTransform)
	end

	return CFrame.lookAt(
		initial.mouseTransform.Position - initial.sunDirection * otherDistance,
		initial.mouseTransform.Position - negative
	).LookVector
end

return shadow
