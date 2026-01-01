local types = require("../types")

local iris = {} :: types.Theme
iris.name = "Iris"

iris.colors = {
	TextColor = Color3.fromRGB(255, 255, 255),
	TextDisabledColor = Color3.fromRGB(128, 128, 128),

	BorderColor = Color3.fromRGB(110, 110, 125),
	BorderActiveColor = Color3.fromRGB(160, 160, 175),

	WindowBgColor = Color3.fromRGB(15, 15, 15),
	PopupBgColor = Color3.fromRGB(20, 20, 20),

	ScrollbarGrabColor = Color3.fromRGB(79, 79, 79),

	TitleBgColor = Color3.fromRGB(10, 10, 10),
	TitleBgActiveColor = Color3.fromRGB(41, 74, 122),
	TitleBgCollapsedColor = Color3.fromRGB(0, 0, 0),

	MenubarBgColor = Color3.fromRGB(36, 36, 36),

	FrameBgColor = Color3.fromRGB(41, 74, 122),
	FrameBgHoveredColor = Color3.fromRGB(66, 150, 250),
	FrameBgActiveColor = Color3.fromRGB(66, 150, 250),

	ButtonColor = Color3.fromRGB(66, 150, 250),
	ButtonHoveredColor = Color3.fromRGB(66, 150, 250),
	ButtonActiveColor = Color3.fromRGB(15, 135, 250),

	ImageColor = Color3.fromRGB(255, 255, 255),

	SliderGrabColor = Color3.fromRGB(66, 150, 250),
	SliderGrabActiveColor = Color3.fromRGB(66, 150, 250),

	HeaderColor = Color3.fromRGB(66, 150, 250),

	HeaderHoveredColor = Color3.fromRGB(66, 150, 250),
	HeaderActiveColor = Color3.fromRGB(66, 150, 250),

	TabColor = Color3.fromRGB(46, 89, 148),
	TabHoveredColor = Color3.fromRGB(66, 150, 250),
	TabActiveColor = Color3.fromRGB(51, 105, 173),

	SelectionImageObjectColor = Color3.fromRGB(255, 255, 255),
	SelectionImageObjectBorderColor = Color3.fromRGB(255, 255, 255),

	TableBorderStrongColor = Color3.fromRGB(79, 79, 89),
	TableBorderLightColor = Color3.fromRGB(59, 59, 64),
	TableRowBgColor = Color3.fromRGB(0, 0, 0),
	TableRowBgAltColor = Color3.fromRGB(255, 255, 255),
	TableHeaderColor = Color3.fromRGB(48, 48, 51),

	NavWindowingHighlightColor = Color3.fromRGB(255, 255, 255),
	NavWindowingDimBgColor = Color3.fromRGB(204, 204, 204),

	SeparatorColor = Color3.fromRGB(110, 110, 128),

	CheckMarkColor = Color3.fromRGB(66, 150, 250),

	PlotLinesColor = Color3.fromRGB(156, 156, 156),
	PlotLinesHoveredColor = Color3.fromRGB(255, 110, 89),
	PlotHistogramColor = Color3.fromRGB(230, 179, 0),
	PlotHistogramHoveredColor = Color3.fromRGB(255, 153, 0),

	ResizeGripColor = Color3.fromRGB(66, 150, 250),
	ResizeGripHoveredColor = Color3.fromRGB(66, 150, 250),
	ResizeGripActiveColor = Color3.fromRGB(66, 150, 250),
}

return table.freeze(iris)
