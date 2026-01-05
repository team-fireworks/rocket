local Iris = require("@src/Iris")

export type FlexProps = {
	Mode: Enum.UIFlexMode?,
}

local function Flex(props: FlexProps)
	local instance = Instance.new("UIFlexItem")
	instance.Name = "Flex"
	instance.FlexMode = props.Mode or Enum.UIFlexMode.None
	Iris.Append(instance)
end

return Flex
