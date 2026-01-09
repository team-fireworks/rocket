local Iris = require("@src/Iris")
local drawDirection = require("../gizmos/drawDirection")
local reflect = require("../utils/reflect")
local types = require("../types")

local face = {} :: types.Reposition
face.name = "Face"
face.describedBy = "shinning the surface of a part"

function face.updateDirection(_, now, isGizmos)
	local rayDirection = CFrame.lookAt(now.cameraTransform.Position, now.mouseTransform.Position)
	local raycast = workspace:Raycast(now.cameraTransform.Position, rayDirection.LookVector * 10_000)

	if not raycast then
		Iris.Tooltip({ "Cursor must be on a face!" })
		return nil
	end

	local reflection = reflect(rayDirection.LookVector, raycast.Normal)
	local direction = CFrame.lookAt(raycast.Position, raycast.Position + reflection).LookVector

	if isGizmos then
		drawDirection(now.mouseTransform.Position, direction)
	end

	return direction
end

return face
