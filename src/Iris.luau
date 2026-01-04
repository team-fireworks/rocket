-- TODO: Iris types don't work for some reason so I have to pull this shit

local Iris = require("@pkgs/Iris")
local typeforge = require("@vendor/typeforge")

export type State<T> = WidgetCall<typeof(Iris.State(... :: T))>

export type Tooltip = typeof(Iris.Tooltip(...))
export type Window = typeof(Iris.Window(...))
export type Menu = typeof(Iris.Menu(...))
export type MenuBar = typeof(Iris.MenuBar())
export type MenuItem = typeof(Iris.MenuItem(...))
export type MenuToggle = typeof(Iris.MenuToggle(...))
export type Group = typeof(Iris.Group())
export type SameLine = typeof(Iris.SameLine())
export type Separator = typeof(Iris.Separator())
export type InputText = typeof(Iris.InputText(...))
export type SeparatorText = typeof(Iris.SeparatorText(...))
export type Text = typeof(Iris.Text(...))
export type Button = typeof(Iris.Button(...))
export type Checkbox = typeof(Iris.Checkbox(...))
export type RadioButton = typeof(Iris.RadioButton(...))
export type SmallButton = typeof(Iris.SmallButton(...))
export type CollapsingHeader = typeof(Iris.CollapsingHeader(...))
export type Tree = typeof(Iris.Tree(...))
export type Tab = typeof(Iris.Tab(...))
export type TabBar = typeof(Iris.TabBar(...))
export type Image = typeof(Iris.Image(...))
export type ImageButton = typeof(Iris.ImageButton(...))
export type InputColor3 = typeof(Iris.InputColor3(...))
export type InputColor4 = typeof(Iris.InputColor4(...))
export type InputNum = typeof(Iris.InputNum(...))
export type InputRect = typeof(Iris.InputRect(...))
export type InputUDim = typeof(Iris.InputUDim(...))
export type InputUDim2 = typeof(Iris.InputUDim2(...))
export type InputVector2 = typeof(Iris.InputVector2(...))
export type InputVector3 = typeof(Iris.InputVector3(...))
export type InputEnum = typeof(Iris.InputEnum(...))
export type DragNum = typeof(Iris.DragNum(...))
export type DragRect = typeof(Iris.DragRect(...))
export type DragUDim = typeof(Iris.DragUDim(...))
export type DragUDim2 = typeof(Iris.DragUDim2(...))
export type DragVector2 = typeof(Iris.DragVector2(...))
export type DragVector3 = typeof(Iris.DragVector3(...))
export type SliderNum = typeof(Iris.SliderNum(...))
export type SliderRect = typeof(Iris.SliderRect(...))
export type SliderUDim = typeof(Iris.SliderUDim(...))
export type SliderUDim2 = typeof(Iris.SliderUDim2(...))
export type SliderVector2 = typeof(Iris.SliderVector2(...))
export type SliderVector3 = typeof(Iris.SliderVector3(...))
export type Combo = typeof(Iris.Combo(...))
export type ComboArray = typeof(Iris.ComboArray(...))
export type ComboEnum = typeof(Iris.ComboEnum(...))
export type Selectable = typeof(Iris.Selectable(...))
export type PlotHistogram = typeof(Iris.PlotHistogram(...))
export type PlotLines = typeof(Iris.PlotLines(...))
export type ProgressBar = typeof(Iris.ProgressBar(...))
export type Table = typeof(Iris.Table(...))

-- selene: allow(undefined_variable)
type function WidgetCall(widgetClass: type)
	local baseClass = if widgetClass.tag == "intersection" then widgetClass:components()[2] else widgetClass
	assert(baseClass.tag == "table", "expected widget class")

	local placeholder = types.singleton(nil)

	local arguments = baseClass:readproperty(types.singleton("arguments")) :: type
	if arguments then
		for key, value in arguments:properties() do
			local valueRead = value.read
			assert(valueRead, `argument {key} cannot be write only`)
			arguments:setproperty(key, valueRead)
		end
		arguments:setindexer(types.number, types.unknown)
	end

	local state = baseClass:readproperty(types.singleton("state")) :: type
	if state then
		for key, value in state:properties() do
			local stateValue = value.read
			assert(stateValue, `state {key} cannot be write only`)
			state:setproperty(key, types.unionof(stateValue, types.unknown))
		end
		state:setindexer(types.number, types.unknown)
	end

	return types.newfunction(
		{ head = {
			arguments or placeholder,
			state or placeholder,
		} },
		{ head = { widgetClass } }
	)
end

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

	Tooltip = Iris.Tooltip :: WidgetCall<Tooltip>,
	Window = Iris.Window :: WidgetCall<Window>,
	Menu = Iris.Menu :: WidgetCall<Menu>,
	MenuBar = Iris.MenuBar :: WidgetCall<MenuBar>,
	MenuItem = Iris.MenuItem :: WidgetCall<MenuItem>,
	MenuToggle = Iris.MenuToggle :: WidgetCall<MenuToggle>,
	Group = Iris.Group :: WidgetCall<Group>,
	SameLine = Iris.SameLine :: WidgetCall<SameLine>,
	Separator = Iris.Separator :: WidgetCall<Separator>,
	InputText = Iris.InputText :: WidgetCall<InputText>,
	SeparatorText = Iris.SeparatorText :: WidgetCall<SeparatorText>,
	Text = Iris.Text :: WidgetCall<Text>,
	Button = Iris.Button :: WidgetCall<Button>,
	Checkbox = Iris.Checkbox :: WidgetCall<Checkbox>,
	RadioButton = Iris.RadioButton :: WidgetCall<RadioButton>,
	SmallButton = Iris.SmallButton :: WidgetCall<SmallButton>,
	CollapsingHeader = Iris.CollapsingHeader :: WidgetCall<CollapsingHeader>,
	Tree = Iris.Tree :: WidgetCall<Tree>,
	Tab = Iris.Tab :: WidgetCall<Tab>,
	TabBar = Iris.TabBar :: WidgetCall<TabBar>,
	Image = Iris.Image :: WidgetCall<Image>,
	ImageButton = Iris.ImageButton :: WidgetCall<ImageButton>,
	InputColor3 = Iris.InputColor3 :: WidgetCall<InputColor3>,
	InputColor4 = Iris.InputColor4 :: WidgetCall<InputColor4>,
	InputNum = Iris.InputNum :: WidgetCall<InputNum>,
	InputRect = Iris.InputRect :: WidgetCall<InputRect>,
	InputUDim = Iris.InputUDim :: WidgetCall<InputUDim>,
	InputUDim2 = Iris.InputUDim2 :: WidgetCall<InputUDim2>,
	InputVector2 = Iris.InputVector2 :: WidgetCall<InputVector2>,
	InputVector3 = Iris.InputVector3 :: WidgetCall<InputVector3>,
	InputEnum = Iris.InputEnum :: WidgetCall<InputNum>,
	DragNum = Iris.DragNum :: WidgetCall<DragNum>,
	DragRect = Iris.DragRect :: WidgetCall<DragRect>,
	DragUDim = Iris.DragUDim :: WidgetCall<DragUDim>,
	DragUDim2 = Iris.DragUDim2 :: WidgetCall<DragUDim2>,
	DragVector2 = Iris.DragVector2 :: WidgetCall<DragVector2>,
	DragVector3 = Iris.DragVector3 :: WidgetCall<DragVector3>,
	SliderNum = Iris.SliderNum :: WidgetCall<SliderNum>,
	SliderRect = Iris.SliderRect :: WidgetCall<SliderRect>,
	SliderUDim = Iris.SliderUDim :: WidgetCall<SliderUDim>,
	SliderUDim2 = Iris.SliderUDim2 :: WidgetCall<SliderUDim2>,
	SliderVector2 = Iris.SliderVector2 :: WidgetCall<SliderVector2>,
	SliderVector3 = Iris.SliderVector3 :: WidgetCall<SliderVector3>,
	Combo = Iris.Combo :: WidgetCall<Combo>,
	ComboArray = Iris.ComboArray :: WidgetCall<ComboArray>,
	ComboEnum = Iris.ComboEnum :: WidgetCall<ComboEnum>,
	Selectable = Iris.Selectable :: WidgetCall<Selectable>,
	PlotHistogram = Iris.PlotHistogram :: WidgetCall<PlotHistogram>,
	PlotLines = Iris.PlotLines :: WidgetCall<PlotLines>,
	ProgressBar = Iris.ProgressBar :: WidgetCall<ProgressBar>,
	Table = Iris.Table :: WidgetCall<Table>,
}

setmetatable(ext, { __index = Iris })
return ext
