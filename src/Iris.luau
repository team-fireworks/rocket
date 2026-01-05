local Iris = require("@pkgs/Iris")
local typeforge = require("@vendor/typeforge")
local types = require("@include/types")

type Cleanup = () -> ()
type WidgetCall<Class> = types.WidgetCall<Class>

export type Config = typeof(Iris._config)
export type PartialConfig = typeforge.Partial<Config>
export type State<T> = typeof(Iris.State(... :: any))
export type ID = string

type Constructors = {
	Tooltip: WidgetCall<typeof(Iris.Tooltip(...))>,
	Window: WidgetCall<typeof(Iris.Window(...))>,
	Menu: WidgetCall<typeof(Iris.Menu(...))>,
	MenuBar: WidgetCall<typeof(Iris.MenuBar())>,
	MenuItem: WidgetCall<typeof(Iris.MenuItem(...))>,
	MenuToggle: WidgetCall<typeof(Iris.MenuToggle(...))>,
	Group: WidgetCall<typeof(Iris.Group())>,
	SameLine: WidgetCall<typeof(Iris.SameLine(...))>,
	Separator: WidgetCall<typeof(Iris.Separator())>,
	InputText: WidgetCall<typeof(Iris.InputText(...))>,
	SeparatorText: WidgetCall<typeof(Iris.SeparatorText(...))>,
	Text: WidgetCall<typeof(Iris.Text(...))>,
	Button: WidgetCall<typeof(Iris.Button(...))>,
	Checkbox: WidgetCall<typeof(Iris.Checkbox(...))>,
	RadioButton: WidgetCall<typeof(Iris.RadioButton(...))>,
	SmallButton: WidgetCall<typeof(Iris.SmallButton(...))>,
	CollapsingHeader: WidgetCall<typeof(Iris.CollapsingHeader(...))>,
	Tree: WidgetCall<typeof(Iris.Tree(...))>,
	Tab: WidgetCall<typeof(Iris.Tab(...))>,
	TabBar: WidgetCall<typeof(Iris.TabBar(...))>,
	Image: WidgetCall<typeof(Iris.Image(...))>,
	ImageButton: WidgetCall<typeof(Iris.ImageButton(...))>,
	InputColor3: WidgetCall<typeof(Iris.InputColor3(...))>,
	InputColor4: WidgetCall<typeof(Iris.InputColor4(...))>,
	InputNum: WidgetCall<typeof(Iris.InputNum(...))>,
	InputRect: WidgetCall<typeof(Iris.InputRect(...))>,
	InputUDim: WidgetCall<typeof(Iris.InputUDim(...))>,
	InputUDim2: WidgetCall<typeof(Iris.InputUDim2(...))>,
	InputVector2: WidgetCall<typeof(Iris.InputVector2(...))>,
	InputVector3: WidgetCall<typeof(Iris.InputVector3(...))>,
	InputEnum: WidgetCall<typeof(Iris.InputNum(...))>,
	DragNum: WidgetCall<typeof(Iris.DragNum(...))>,
	DragRect: WidgetCall<typeof(Iris.DragRect(...))>,
	DragUDim: WidgetCall<typeof(Iris.DragUDim(...))>,
	DragUDim2: WidgetCall<typeof(Iris.DragUDim2(...))>,
	DragVector2: WidgetCall<typeof(Iris.DragVector2(...))>,
	DragVector3: WidgetCall<typeof(Iris.DragVector3(...))>,
	SliderNum: WidgetCall<typeof(Iris.SliderNum(...))>,
	SliderRect: WidgetCall<typeof(Iris.SliderRect(...))>,
	SliderUDim: WidgetCall<typeof(Iris.SliderUDim(...))>,
	SliderUDim2: WidgetCall<typeof(Iris.SliderUDim2(...))>,
	SliderVector2: WidgetCall<typeof(Iris.SliderVector2(...))>,
	SliderVector3: WidgetCall<typeof(Iris.SliderVector3(...))>,
	Combo: WidgetCall<typeof(Iris.Combo(...))>,
	ComboArray: WidgetCall<typeof(Iris.ComboArray(...))>,
	ComboEnum: WidgetCall<typeof(Iris.ComboEnum(...))>,
	Selectable: WidgetCall<typeof(Iris.Selectable(...))>,
	PlotHistogram: WidgetCall<typeof(Iris.PlotHistogram(...))>,
	PlotLines: WidgetCall<typeof(Iris.PlotLines(...))>,
	ProgressBar: WidgetCall<typeof(Iris.ProgressBar(...))>,
	Table: WidgetCall<typeof(Iris.Table(...))>,
}

export type Iris = Constructors & {
	Internal: typeof(Iris.Internal),

	_config: Config,

	-- @see https://sirmallard.github.io/Iris/api/Iris#Disabled
	Disabled: boolean,

	-- @see https://sirmallard.github.io/Iris/api/Iris#Args
	Args: { [keyof<Constructors>]: { [string]: number } },

	-- @see https://sirmallard.github.io/Iris/api/Iris#TemplateConfig
	TemplateConfig: {
		colorDark: Config,
		colorLight: Config,
		sizeDefault: Config,
		sizeClear: Config,
		utilityDefault: Config,
	},

	--- @see https://sirmallard.github.io/Iris/api/Iris#SetFocusedWindow
	SetFocusedWindow: (window: typeof(Iris.Window(...))) -> (),
	--- @see https://sirmallard.github.io/Iris/api/Iris#Init
	Init: (
		parentInstance: Instance?,
		eventConnection: RBXScriptSignal | () -> () | false | nil,
		allowMultipleInits: boolean?
	) -> Iris,
	--- @see https://sirmallard.github.io/Iris/api/Iris#Shutdown
	Shutdown: () -> (),
	--- @see https://sirmallard.github.io/Iris/api/Iris#Append
	Append: (userInstance: Instance) -> (),
	--- @see https://sirmallard.github.io/Iris/api/Iris#End
	End: () -> (),
	--- @see https://sirmallard.github.io/Iris/api/Iris#ForceRefresh
	ForceRefresh: () -> (),
	--- @see https://sirmallard.github.io/Iris/api/Iris#UpdateGlobalConfig
	UpdateGlobalConfig: (deltaStyle: PartialConfig) -> (),
	--- @see https://sirmallard.github.io/Iris/api/Iris#PushConfig
	PushConfig: (deltaStyle: PartialConfig) -> (),
	--- @see https://sirmallard.github.io/Iris/api/Iris#PopConfig
	PopConfig: () -> (),
	--- @see https://sirmallard.github.io/Iris/api/Iris#PushID
	PushID: (id: ID) -> (),
	--- @see https://sirmallard.github.io/Iris/api/Iris#PopID
	PopID: () -> (),
	--- @see https://sirmallard.github.io/Iris/api/Iris#SetNextWidgetID
	SetNextWidgetID: (id: ID) -> (),
	--- @see https://sirmallard.github.io/Iris/api/Iris#State%3CT%3E
	State: <T>(initialValue: T) -> State<T>,
	--- @see https://sirmallard.github.io/Iris/api/Iris#WeakState%3CT%3E
	WeakState: <T>(initialValue: T) -> State<T>,
	--- @see https://sirmallard.github.io/Iris/api/Iris#VariableState%3CT%3E
	VariableState: <T>(variable: T, callback: (T) -> ()) -> State<T>,
	--- @see https://sirmallard.github.io/Iris/api/Iris#TableState%3CK,%20V%3E
	TableState: <K, V>(table: { [K]: V }, key: K, callback: ((newValue: V) -> false?)?) -> State<V>,
	--- @see https://sirmallard.github.io/Iris/api/Iris#ComputedState%3CT,%20U%3E
	ComputedState: <T, U>(firstState: State<T>, onChangeCallback: (firstValue: T) -> U) -> State<U>,
	--- @see https://sirmallard.github.io/Iris/api/Iris#ShowDemoWindow
	ShowDemoWindow: () -> (),
	--- @see https://sirmallard.github.io/Iris/api/Iris#Connect
	Connect: (self: Iris, callback: () -> ()) -> Cleanup,
}

return Iris :: Iris
