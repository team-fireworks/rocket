local Iris = require("@pkgs/Iris")
local typeforge = require("@vendor/typeforge")

local ext = {
	PushConfig = Iris.PushConfig :: (deltaStyles: typeforge.Partial<typeof(Iris._config)>) -> (),

	ButtonGroup = require("@src/widgets/ButtonGroup"),
	Icon = require("@src/widgets/Icon"),
	Header = require("@src/widgets/Header"),
	Subtext = require("@src/widgets/Subtext"),
	Frame = require("@src/widgets/Frame"),
	ScrollingFrame = require("@src/widgets/ScrollingFrame"),
	Flex = require("@src/widgets/Flex"),
	FlexSpacer = require("@src/widgets/FlexSpacer"),
	Spacer = require("@src/widgets/Spacer"),
}

setmetatable(ext, { __index = Iris })
return ext
