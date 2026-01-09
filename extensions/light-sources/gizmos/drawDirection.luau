local Gizmos = require("@src/Gizmos")

local LENGTH = 5

local function drawAxis(mousePosition: Vector3, axisComponent: number, axisVector: Vector3)
	Gizmos.drawLine(mousePosition, mousePosition + axisVector * math.sign(axisComponent) * LENGTH)
end

local function drawDirection(mousePosition: Vector3, direction: Vector3)
	Gizmos.pushProperties({ Transparency = 0.5 })
	drawAxis(mousePosition, direction.X, Vector3.xAxis)
	drawAxis(mousePosition, direction.Y, Vector3.yAxis)
	drawAxis(mousePosition, direction.Z, Vector3.zAxis)
	Gizmos.popProperties()

	Gizmos.drawArrow(mousePosition, mousePosition + direction * LENGTH)
end

return drawDirection
