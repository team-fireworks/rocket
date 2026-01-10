-- TODO: virtual lists
-- TODO: pagination

local ButtonGroup = require("../interactions/ButtonGroup")
local Flex = require("../styles/Flex")
local Iris = require("@src/Iris")
local Padding = require("../styles/Padding")
local ScrollingFrame = require("./ScrollingFrame")
local fzy = require("@include/fzy")
local useKeys = require("@src/core/hooks/useKeys")
-- local theme = require("@src/theme")

export type ListProps<T> = {
	searchPlaceholder: string?,
	onSearchChange: (search: string) -> ()?,
	caseSensitive: boolean?,
	captureFocus: boolean?,
	filterEntries: ((search: string, props: ListProps<T>) -> { T })?,

	entries: { T },
	renderEntry: (entry: T, props: ListProps<T>) -> (),
	getEntryTitle: (entry: T, props: ListProps<T>) -> string,
	getEntryTooltip: ((entry: T, props: ListProps<T>) -> string)?,

	onEntrySelected: (T) -> ()?,
}

local PREVIOUS_KEYCODE = Enum.KeyCode.Up
local NEXT_KEYCODE = Enum.KeyCode.Down
local SELECT_KEYCODE = Enum.KeyCode.Return

local function defaultFilterEntries(search: string, props: ListProps<any>)
	local entryTitles: { string } = {}
	for i, entry in props.entries do
		entryTitles[i] = props.getEntryTitle(entry, props)
	end

	local filtered = fzy.filter(search, entryTitles, props.caseSensitive or false)
	local result = table.create(#filtered) :: { any }

	local entryScores: { [any]: number } = {}
	for i, entry in filtered do
		local realEntry = props.entries[entry[1]]
		result[i] = realEntry
		entryScores[realEntry] = entry[3]
	end

	table.sort(result, function(lhs, rhs)
		return entryScores[lhs] < entryScores[rhs]
	end)

	return result
end

--[=[
	@function List

	Creates a list layout.
]=]
local function List<T>(props: ListProps<T>)
	Iris.PushConfig({ FrameRounding = 0, FramePadding = Iris._config.FramePadding * 2, ContentWidth = UDim.new(1, 0) })
	local searchInput = Iris.InputText({ "", props.searchPlaceholder or "Search..." })
	local searchInstance = searchInput.Instance:FindFirstChildWhichIsA("TextBox") :: TextBox
	local search = searchInstance.Text
	if props.captureFocus then
		searchInstance:CaptureFocus()
	end
	Iris.PopConfig()

	if props.onSearchChange then
		props.onSearchChange(search)
	end

	local filtered = if search == ""
		then props.entries
		else (props.filterEntries or defaultFilterEntries)(search, props)

	local lenFiltered = #filtered
	local selectedIndex = Iris.State(1)

	local oldSelectedIndex = selectedIndex:get()
	local newSelectedIndex = oldSelectedIndex

	if lenFiltered == 0 then
		newSelectedIndex = 1
	else
		if useKeys.andConsumePress(PREVIOUS_KEYCODE) then
			newSelectedIndex -= 1
		end

		if useKeys.andConsumePress(NEXT_KEYCODE) then
			newSelectedIndex += 1
		end

		newSelectedIndex = math.clamp(newSelectedIndex, 1, lenFiltered)

		if useKeys.andConsumePress(SELECT_KEYCODE) then
			if lenFiltered > 0 and props.onEntrySelected then
				props.onEntrySelected(filtered[newSelectedIndex] or filtered[lenFiltered])
			end
		end
	end

	Iris.Separator()
	Iris.PushConfig({ ItemSpacing = Vector2.new(Iris._config.ItemSpacing.X, 0) })
	local scroller = ScrollingFrame({ size = UDim2.fromScale(1, 0), automaticSize = Enum.AutomaticSize.Y })
	local selectedPosition, selectedSize = Vector2.zero, Vector2.zero
	Flex(Enum.UIFlexMode.Fill)
	Padding({ x = UDim.new(0, Iris._config.CellPadding.X), y = UDim.new(0, Iris._config.CellPadding.Y) })
	local tooltipVisible = false
	for i, entry in filtered do
		local isSelected = i == newSelectedIndex
		-- local buttonConfig = if isSelected
		-- then theme.PRESETS.BUTTONS.HIGHLIGHTED
		-- else theme.PRESETS.BUTTONS.UNHIGHLIGHTED

		-- Iris.PushConfig(buttonConfig)
		local button = ButtonGroup({ size = UDim2.fromScale(1, 0) })
		local buttonInstance = button.Instance
		buttonInstance.LayoutOrder = i + 100
		if isSelected then
			selectedPosition = buttonInstance.AbsolutePosition
			selectedSize = buttonInstance.AbsoluteSize
		end

		props.renderEntry(entry, props)
		Iris.End()
		-- Iris.PopConfig()

		if not tooltipVisible and props.getEntryTooltip and button.hovered() then
			tooltipVisible = true
			Iris.Tooltip({ props.getEntryTooltip(entry, props) })
		end

		if props.onEntrySelected and button.clicked() then
			props.onEntrySelected(entry)
		end
	end
	Iris.End()
	Iris.PopConfig()

	-- TODO: scrolling down is a bit janky
	local sign = math.sign(newSelectedIndex - oldSelectedIndex)
	if sign ~= 0 then
		local scrollingFrame = scroller.Instance :: ScrollingFrame

		local canvasPosition = scrollingFrame.CanvasPosition
		local frameTop = scrollingFrame.AbsolutePosition.Y + Iris._config.FramePadding.Y
		local frameBottom = frameTop + scrollingFrame.AbsoluteWindowSize.Y + Iris._config.FramePadding.Y

		local itemTop = selectedPosition.Y
		local itemBottom = itemTop + selectedSize.Y

		if itemTop < frameTop then
			scrollingFrame.CanvasPosition = Vector2.new(canvasPosition.X, canvasPosition.Y - (frameTop - itemTop))
		end

		if itemBottom > frameBottom then
			scrollingFrame.CanvasPosition =
				Vector2.new(canvasPosition.X, canvasPosition.Y + (itemBottom - frameBottom) + selectedSize.Y)
		end
	end

	selectedIndex:set(newSelectedIndex)
end

return List
