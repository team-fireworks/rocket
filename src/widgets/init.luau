local List = require("@self/List")

export type ListProps<T> = List.ListProps<T>

local widgets = table.freeze {
	ButtonGroup = require("@self/ButtonGroup"),
	InstantInputText = require("@self/InstantInputText"),
	Frame = require("@self/Frame"),
	ScrollingFrame = require("@self/ScrollingFrame"),

	Flex = require("@self/styling/Flex"),
	FlexFiller = require("@self/styling/FlexFiller"),
	Padding = require("@self/styling/Padding"),
	Spacer = require("@self/styling/Spacer"),

	Subtext = require("@self/typography/Subtext"),

	List = List,
}

return widgets
