local Iris = require("@src/Iris")

export type SpacerProps = {
	X: UDim?,
	Y: UDim?,
	All: UDim?,
}

local DEFAULT_UDIM = UDim.new(0, 8)

local function Spacer(props: SpacerProps?)
	Iris.Image({
		"",
		UDim2.new(props and (props.X or props.All) or DEFAULT_UDIM, props and (props.Y or props.All) or DEFAULT_UDIM),
	})
end

return Spacer
