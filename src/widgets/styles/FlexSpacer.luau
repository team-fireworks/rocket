local Flex = require("./Flex")
local Iris = require("@src/Iris")

local function FlexSpacer(mode: Enum.UIFlexMode?)
	Iris.Group()
	Flex(mode)
	Iris.End()
end

return FlexSpacer
