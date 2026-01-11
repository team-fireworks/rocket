local Iris = require("@pkgs/Iris")
local typeforge = require("@include/typeforge")
local types = require("@include/types")

type Cleanup = () -> ()
type WidgetCall<Class> = types.WidgetCall<Class>

export type Config = typeof(Iris._config)
export type PartialConfig = typeforge.Partial<Config>
export type State<T> = typeof(Iris.State(... :: any))
export type ID = string

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

type IrisPatches = {
	Connect: (self: any, callback: () -> ()) -> Cleanup,
	Append: (userInstance: Instance) -> (),
	UpdateGlobalConfig: (deltaStyles: PartialConfig) -> (),
	PushConfig: (deltaStyles: PartialConfig) -> (),
}

type Iris = setmetatable<IrisPatches, { __index: typeof(Iris) }>

return Iris :: Iris
