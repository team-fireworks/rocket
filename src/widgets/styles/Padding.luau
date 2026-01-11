local Iris = require("@src/Iris")

export type PaddingProps = {
	x: UDim?,
	y: UDim?,
	top: UDim?,
	bottom: UDim?,
	left: UDim?,
	right: UDim?,
	all: UDim?,
}

local ZERO_UDIM = UDim.new()

local function Padding(props: PaddingProps)
	local instance = Instance.new("UIPadding")
	instance.Name = "Padding"

	instance.PaddingTop = props.top or props.y or props.all or ZERO_UDIM
	instance.PaddingBottom = props.bottom or props.y or props.all or ZERO_UDIM
	instance.PaddingLeft = props.left or props.x or props.all or ZERO_UDIM
	instance.PaddingRight = props.right or props.x or props.all or ZERO_UDIM

	Iris.Append(instance)
end

return Padding
