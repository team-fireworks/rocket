-- https://discord.com/channels/385151591524597761/1097898141396766771/1455680322279571516

local Iris = require("@src/Iris")
local Internal = Iris.Internal
local widgets = Internal._utility

Internal.WidgetConstructor(
	"ScrollingFrame",
	{
		hasState = false,
		hasChildren = true,
		Args = {
			Size = 1,
			AutomaticSize = 2,
			VerticalAlignment = 3,
			HorizontalAlignment = 4,
		},
		Events = {},
		Generate = function(thisWidget)
			local frame = Instance.new("ScrollingFrame")
			frame.Name = "Iris_ScrollingFrame"
			frame.AutomaticSize = Enum.AutomaticSize.XY
			frame.Size = UDim2.fromOffset(0, 0)
			frame.BackgroundTransparency = 1
			frame.BorderSizePixel = 0
			frame.LayoutOrder = thisWidget.ZIndex
			frame.ClipsDescendants = true

			frame.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar
			frame.TopImage = widgets.ICONS.BLANK_SQUARE
			frame.MidImage = widgets.ICONS.BLANK_SQUARE
			frame.BottomImage = widgets.ICONS.BLANK_SQUARE
			frame.ScrollBarImageColor3 = Iris._config.ScrollbarGrabColor
			frame.ScrollBarThickness = Iris._config.ScrollbarSize
			frame.ScrollBarImageTransparency = Iris._config.ScrollbarGrabTransparency

			widgets.UIListLayout(frame, Enum.FillDirection.Vertical, UDim.new(0, Iris._config.ItemSpacing.Y))

			return frame
		end,
		Update = function(thisWidget)
			local frame: ScrollingFrame = thisWidget.Instance
			local list: UIListLayout = (frame :: any).UIListLayout

			list.VerticalAlignment = thisWidget.arguments.VerticalAlignment or Enum.VerticalAlignment.Top
			list.HorizontalAlignment = thisWidget.arguments.HorizontalAlignment or Enum.HorizontalAlignment.Left
			frame.Size = thisWidget.arguments.Size or UDim2.fromOffset(0, 0)
			frame.AutomaticSize = thisWidget.arguments.AutomaticSize or Enum.AutomaticSize.XY
		end,
		GenerateState = function(thisWidget)
			if thisWidget.state.scrollPosition == nil then
				thisWidget.state.scrollPosition = Iris.Internal._widgetState(thisWidget, "scrollPosition", Vector2.zero)
			end
		end,
		UpdateState = function(thisWidget)
			local frame: ScrollingFrame = thisWidget.Instance
			thisWidget.state.scrollPosition:set(frame.CanvasPosition)
		end,
		Discard = function(thisWidget)
			thisWidget.Instance:Destroy()
		end,
		ChildAdded = function(thisWidget)
			return thisWidget.Instance
		end,
	} :: any
)

local function ScrollingFrame(props: {
	Size: UDim2,
	AutomaticSize: Enum.AutomaticSize,
	VerticalAlignment: Enum.VerticalAlignment?,
	HorizontalAlignment: Enum.HorizontalAlignment?,
})
	return Internal._Insert(
		"ScrollingFrame",
		{ props.Size, props.AutomaticSize, props.VerticalAlignment, props.HorizontalAlignment }
	)
end

return ScrollingFrame
