local Iris = require("@src/Iris")

local function Spacer(spacing: Vector2 | number | nil)
	Iris.Image({
		"rbxassetid://-1",
		UDim2.fromOffset(
			(if typeof(spacing) == "Vector2" then spacing.X else spacing) or 8,
			(if typeof(spacing) == "Vector2" then spacing.Y else spacing) or 8
		),
	})
end

return Spacer
