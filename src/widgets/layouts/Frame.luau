-- https://discord.com/channels/385151591524597761/1097898141396766771/1455680322279571516

local Iris = require("@src/Iris")
local Internal = Iris.Internal
local widgets = Internal._utility

export type FrameProps = {
	size: UDim2,
	automaticSize: Enum.AutomaticSize,
	verticalAlignment: Enum.VerticalAlignment?,
	horizontalAlignment: Enum.HorizontalAlignment?,
}

Internal.WidgetConstructor(
	"Frame",
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
			local frame = Instance.new("Frame")
			frame.Name = "Iris_Frame"
			frame.AutomaticSize = Enum.AutomaticSize.XY
			frame.Size = UDim2.fromOffset(0, 0)
			frame.BackgroundTransparency = 1
			frame.BorderSizePixel = 0
			frame.LayoutOrder = thisWidget.ZIndex
			frame.ClipsDescendants = true

			widgets.UIListLayout(frame, Enum.FillDirection.Vertical, UDim.new(0, Iris._config.ItemSpacing.Y))

			return frame
		end,
		Update = function(thisWidget: any)
			local frame: Frame = thisWidget.Instance
			local list: UIListLayout = (frame :: any).UIListLayout

			list.VerticalAlignment = thisWidget.arguments.VerticalAlignment or Enum.VerticalAlignment.Top
			list.HorizontalAlignment = thisWidget.arguments.HorizontalAlignment or Enum.HorizontalAlignment.Left
			frame.Size = thisWidget.arguments.Size or UDim2.fromOffset(0, 0)
			frame.AutomaticSize = thisWidget.arguments.AutomaticSize or Enum.AutomaticSize.XY
		end,
		Discard = function(thisWidget)
			thisWidget.Instance:Destroy()
		end,
		ChildAdded = function(thisWidget)
			return thisWidget.Instance
		end,
	} :: any
)

local function Frame(props: FrameProps)
	return Internal._Insert(
		"Frame",
		{ props.size, props.automaticSize, props.verticalAlignment, props.horizontalAlignment }
	)
end

return Frame
