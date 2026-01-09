local Iris = require("@src/Iris")
local Internal = Iris.Internal
local widgets = Internal._utility

export type ButtonGroupProps = {
	size: UDim2,
}

Internal.WidgetConstructor(
	"ButtonGroup",
	{
		hasState = false,
		hasChildren = true,
		Args = {
			size = 1,
		},
		Events = {
			clicked = widgets.EVENTS.click(function(thisWidget: any)
				return thisWidget.Instance
			end),
			rightClicked = widgets.EVENTS.rightClick(function(thisWidget: any)
				return thisWidget.Instance
			end),
			doubleClicked = widgets.EVENTS.doubleClick(function(thisWidget: any)
				return thisWidget.Instance
			end),
			ctrlClicked = widgets.EVENTS.ctrlClick(function(thisWidget: any)
				return thisWidget.Instance
			end),
			hovered = widgets.EVENTS.hover(function(thisWidget: any)
				return thisWidget.Instance
			end),
		},
		Generate = function(thisWidget)
			local ButtonGroup = Instance.new("TextButton")
			ButtonGroup.Name = "Iris_ButtonGroup"
			ButtonGroup.AutomaticSize = Enum.AutomaticSize.XY
			ButtonGroup.Size = UDim2.fromOffset(0, 0)
			ButtonGroup.BackgroundColor3 = Internal._config.ButtonColor
			ButtonGroup.BackgroundTransparency = Internal._config.ButtonTransparency
			ButtonGroup.AutoButtonColor = false
			ButtonGroup.LayoutOrder = thisWidget.ZIndex
			ButtonGroup.Text = ""

			local list = widgets.UIListLayout(
				ButtonGroup,
				Enum.FillDirection.Horizontal,
				UDim.new(0, Internal._config.ItemSpacing.X)
			)

			list.VerticalAlignment = Enum.VerticalAlignment.Center

			widgets.applyFrameStyle(ButtonGroup)

			widgets.applyInteractionHighlights("Background", ButtonGroup, ButtonGroup, {
				Color = Internal._config.ButtonColor,
				Transparency = Internal._config.ButtonTransparency,
				HoveredColor = Internal._config.ButtonHoveredColor,
				HoveredTransparency = Internal._config.ButtonHoveredTransparency,
				ActiveColor = Internal._config.ButtonActiveColor,
				ActiveTransparency = Internal._config.ButtonActiveTransparency,
			})

			return ButtonGroup
		end,
		Update = function(thisWidget)
			local ButtonGroup = thisWidget.Instance :: TextButton
			ButtonGroup.Size = thisWidget.arguments.size or UDim2.fromOffset(0, 0)
		end,
		ChildAdded = function(thisWidget)
			return thisWidget.Instance
		end,
		Discard = function(thisWidget)
			thisWidget.Instance:Destroy()
		end,
	} :: any
)

local function ButtonGroup(props: ButtonGroupProps): typeof(Iris.Button({})) & typeof(Iris.Group())
	return Internal._Insert("ButtonGroup", { props.size }) :: any
end

return ButtonGroup
