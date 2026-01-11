local Iris = require("@src/Iris")

local function AspectRatio(ratio: number?, type: Enum.AspectType?)
	local instance = Instance.new("UIAspectRatioConstraint")
	instance.Name = "AspectRatio"
	instance.AspectRatio = ratio or 1
	instance.AspectType = type or Enum.AspectType.FitWithinMaxSize
	Iris.Append(instance)
end

return AspectRatio
