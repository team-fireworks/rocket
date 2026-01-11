local Iris = require("@src/Iris")

export type HeaderProps = {
	text: string,
	level: number?,
}

local function Header(props: HeaderProps)
	local minSize = Iris._config.TextSize
	local decrementSize = ((props.level or 1) - 1) * 2
	local maxSize = minSize * 3

	Iris.PushConfig({
		TextSize = math.max(maxSize - decrementSize, minSize),
		TextFont = Font.fromName("SourceSansPro", Enum.FontWeight.Bold),
	})
	Iris.Text({ props.text })
	Iris.PopConfig()
end

return Header
