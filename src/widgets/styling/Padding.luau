local Iris = require("@src/Iris")

export type PaddingProps = {
	X: UDim?,
	Y: UDim?,
	Top: UDim?,
	Bottom: UDim?,
	Left: UDim?,
	Right: UDim?,
	All: UDim?,
}

local ZERO_UDIM = UDim.new()

local function Padding(props: PaddingProps)
	local instance = Instance.new("UIPadding")
	instance.Name = "Padding"

	instance.PaddingTop = props.Top or props.Y or props.All or ZERO_UDIM
	instance.PaddingBottom = props.Bottom or props.Y or props.All or ZERO_UDIM
	instance.PaddingLeft = props.Left or props.X or props.All or ZERO_UDIM
	instance.PaddingRight = props.Right or props.X or props.All or ZERO_UDIM

	-- In reality, Iris.Append accepts all Instances and not just GuiObjects.
	Iris.Append(instance)
end

return Padding
