local Flex = require("./Flex")
local Iris = require("@src/Iris")

export type FlexProps = {
	Mode: Enum.UIFlexMode?,
}

local function FlexFiller(props: FlexProps)
	Iris.Group()
	Flex(props)
	Iris.End()
end

return FlexFiller
