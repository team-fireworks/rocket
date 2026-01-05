local Iris = require("@src/Iris")

export type SpacerProps = {
	X: UDim?,
	Y: UDim?,
	All: UDim?,
}

local ZERO_UDIM = UDim.new()

local function Spacer(props: SpacerProps)
	local instance = Instance.new("Frame")
	instance.Name = "Spacer"
	instance.BackgroundTransparency = 1
	instance.BorderSizePixel = 0
	instance.Size = UDim2.new(props.X or props.All or ZERO_UDIM, props.Y or props.All or ZERO_UDIM)
	Iris.Append(instance)
end

return Spacer
