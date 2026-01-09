local Iris = require("@src/Iris")

export type SpacerProps = {
	x: UDim?,
	y: UDim?,
	all: UDim?,
}

local DEFAULT_UDIM = UDim.new(0, 8)

local function Spacer(props: SpacerProps?)
	Iris.Image({
		"",
		UDim2.new(props and (props.x or props.all) or DEFAULT_UDIM, props and (props.y or props.all) or DEFAULT_UDIM),
	})
end

return Spacer
