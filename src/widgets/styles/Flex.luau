local Iris = require("@src/Iris")

local function Flex(mode: Enum.UIFlexMode?)
	local instance = Instance.new("UIFlexItem")
	instance.Name = "Flex"
	instance.FlexMode = mode or Enum.UIFlexMode.None

	Iris.Append(instance)
end

return Flex
