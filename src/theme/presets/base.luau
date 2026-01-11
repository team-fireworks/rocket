local types = require("../types")

local base: types.PartialConfig = {
	TextTransparency = 0,
	TextDisabledTransparency = 0,

	BorderTransparency = 0.5,
	BorderActiveTransparency = 0.3,

	WindowBgTransparency = 0.06,
	PopupBgTransparency = 0.06,

	ScrollbarGrabTransparency = 0,

	TitleBgTransparency = 0,
	TitleBgActiveTransparency = 0,
	TitleBgCollapsedTransparency = 0.5,

	MenubarBgTransparency = 0,

	FrameBgTransparency = 0.46,
	FrameBgHoveredTransparency = 0.46,
	FrameBgActiveTransparency = 0.33,

	ButtonTransparency = 0.6,
	ButtonHoveredTransparency = 0,
	ButtonActiveTransparency = 0,

	ImageTransparency = 0,

	SliderGrabTransparency = 0,
	SliderGrabActiveTransparency = 0,

	HeaderTransparency = 0.69,
	HeaderHoveredTransparency = 0.2,
	HeaderActiveTransparency = 0,

	TabTransparency = 0.14,
	TabHoveredTransparency = 0.2,
	TabActiveTransparency = 0,

	SelectionImageObjectTransparency = 0.8,
	SelectionImageObjectBorderTransparency = 0,

	TableBorderStrongTransparency = 0,
	TableBorderLightTransparency = 0,
	TableRowBgTransparency = 1,
	TableRowBgAltTransparency = 0.94,
	TableHeaderTransparency = 0,
	NavWindowingHighlightTransparency = 0.3,
	NavWindowingDimBgTransparency = 0.65,

	SeparatorTransparency = 0.5,

	CheckMarkTransparency = 0,

	PlotLinesTransparency = 0,
	PlotLinesHoveredTransparency = 0,
	PlotHistogramTransparency = 0,
	PlotHistogramHoveredTransparency = 0,

	ResizeGripTransparency = 0.8,
	ResizeGripHoveredTransparency = 0.33,
	ResizeGripActiveTransparency = 0.05,

	ItemWidth = UDim.new(1, 0),
	-- ContentWidth = UDim.new(1, 0),
	ContentHeight = UDim.new(0, 0),

	WindowPadding = Vector2.new(12, 8),
	WindowResizePadding = Vector2.new(8, 8),
	FramePadding = Vector2.new(6, 4),
	ItemSpacing = Vector2.new(8, 0),
	ItemInnerSpacing = Vector2.new(8, 8),
	CellPadding = Vector2.new(4, 4),
	DisplaySafeAreaPadding = Vector2.new(8, 8),
	SeparatorTextPadding = Vector2.new(24, 6),
	IndentSpacing = 25,

	TextFont = Font.fromEnum(Enum.Font.SourceSans),
	TextSize = 18,
	FrameBorderSize = 0,
	FrameRounding = 4,
	GrabRounding = 4,
	WindowRounding = 4,
	WindowBorderSize = 1,
	WindowTitleAlign = Enum.LeftRight.Center,
	PopupBorderSize = 1,
	PopupRounding = 4,
	ScrollbarSize = 9,
	GrabMinSize = 14,
	SeparatorTextBorderSize = 4,
	ImageBorderSize = 4,

	UseScreenGUIs = true,
	IgnoreGuiInset = true,
	ScreenInsets = Enum.ScreenInsets.None,
	Parent = nil,
	RichText = true,
	TextWrapped = false,
	DisplayOrderOffset = 127,
	ZIndexOffset = 0,

	MouseDoubleClickTime = 0.30,
	MouseDoubleClickMaxDist = 6.0,

	HoverColor = Color3.fromRGB(255, 255, 0),
	HoverTransparency = 0.1,
}

return base
