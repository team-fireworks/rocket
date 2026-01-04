local Gizmos = require("@src/Gizmos")

local function LineGizmo(from: CFrame, to: CFrame)
	Gizmos.drawSphere(from, Gizmos.POINT_RADIUS)
	Gizmos.drawLine(from.Position, to.Position)
	Gizmos.drawSphere(to, Gizmos.POINT_RADIUS)
end

return LineGizmo
