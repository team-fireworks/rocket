local Iris = require("@src/Iris")

local function Subtext(props: { string })
	Iris.PushConfig { TextTransparency = 0.5 }
	Iris.Text({ table.concat(props, " ") })
	Iris.PopConfig()
end

return Subtext
