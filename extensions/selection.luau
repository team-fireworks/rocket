local Selection = game:GetService("Selection")
local Workspace = game:GetService("Workspace")

local Extension = require("@src/core/Extension")
local Iris = require("@src/Iris")
local RegExp = require("@pkgs/RegExp")
local assets = require("@include/assets")
local createCoreExtension = require("@src/core/constructors/createCoreExtension")
local widgets = require("@src/widgets")

local ext = createCoreExtension {
	id = "rocket-selection",
	title = "Selection",
	description = "Expanding, reducing, and transforming instance selections.",
	icon = assets.extensions.selection,
	authors = { "Team Fireworks" },
}

ext:newCommand({
	id = "select-children",
	title = "Select Children",
	description = "Selects children of the current selection.",
}, function(r: Extension.CommandRuntime)
	r:recordChangeHistory()
	local oldSelection = Selection:Get()
	local newSelection = table.clone(oldSelection)
	for _, selected in oldSelection do
		local children = selected:GetChildren()
		table.move(children, 1, #children, #newSelection + 1, newSelection)
	end
	Selection:Set(newSelection)
end)

ext:newCommand({
	id = "select-descendants",
	title = "Select Descendants",
	description = "Selects descendants of the current selection.",
}, function(r: Extension.CommandRuntime)
	r:recordChangeHistory()
	local oldSelection = Selection:Get()
	local newSelection = table.clone(oldSelection)
	for _, selected in oldSelection do
		local descendants = selected:GetDescendants()
		table.move(descendants, 1, #descendants, #newSelection + 1, newSelection)
	end
	r:setSelection(newSelection)
end)

ext:newCommand({
	id = "select-just-children",
	title = "Select Just Children",
	description = "Selects only the children of the current selection.",
}, function(r: Extension.CommandRuntime)
	r:recordChangeHistory()
	local newSelection = {}
	for _, selected in r:getSelection() do
		local children = selected:GetChildren()
		table.move(children, 1, #children, #newSelection + 1, newSelection)
	end
	r:setSelection(newSelection)
end)

ext:newCommand({
	id = "select-just-descendants",
	title = "Select Just Descendants",
	description = "Selects only the descendants of the current selection.",
}, function(r: Extension.CommandRuntime)
	r:recordChangeHistory()
	local newSelection = {}
	for _, selected in Selection:Get() do
		local descendants = selected:GetDescendants()
		table.move(descendants, 1, #descendants, #newSelection + 1, newSelection)
	end
	r:setSelection(newSelection)
end)

ext:newCommand({
	id = "select-just-first",
	title = "Select Just First",
	description = "Reduce to just your first selection.",
}, function(r: Extension.CommandRuntime)
	r:recordChangeHistory()
	r:setSelection({ r:getSelection()[1] })
end)

ext:newCommand({
	id = "select-just-last",
	title = "Select Just Last",
	description = "Reduce to just your last selection.",
}, function(r: Extension.CommandRuntime)
	r:recordChangeHistory()
	local oldSelection = Selection:Get()
	Selection:Set({ oldSelection[#oldSelection] })
end)

ext:newCommand({
	id = "deselect-all",
	title = "Deselect All",
	description = "Clears your selection.",
}, function(r: Extension.CommandRuntime)
	r:recordChangeHistory()
	r:setSelection({})
end)

ext:newCommand({
	id = "destroy-selection",
	title = "Destroy Selection",
	description = "Destroys the selection.",
}, function(r: Extension.CommandRuntime)
	r:recordChangeHistory()
	for _, instance in r:getSelection() do
		pcall(game.Destroy, instance)
	end
end)

ext:newCommand({
	id = "destroy-just-children",
	title = "Destroy Just Children",
	description = "Destroys just the children of the current selection.",
}, function(r: Extension.CommandRuntime)
	r:recordChangeHistory()
	for _, parent in r:getSelection() do
		for _, children in parent:GetChildren() do
			pcall(game.Destroy, children)
		end
	end
end)

-- TODO: unfinished
ext:newCommand({
	id = "rename-selection",
	title = "Rename Selection",
	description = "Renames the current selection to the given pattern.",
}, function(r: Extension.CommandRuntime)
	r:recordChangeHistory()

	local firstRun = true
	local output = r.createCommandOutput()

	function output.renderWindow(window: Iris.Window)
		if firstRun then
			firstRun = false

			local viewportSize = Workspace.CurrentCamera.ViewportSize
			local windowSize = viewportSize / 2
			window.state.position:set(windowSize / 2)
			window.state.size:set(windowSize)
		end

		local selection = r:getSelection()

		Iris.SameLine()

		---

		widgets.Frame { size = UDim2.fromScale(0, 1), automaticSize = Enum.AutomaticSize.None }
		widgets.Flex(Enum.UIFlexMode.Fill)

		Iris.SeparatorText { `Rename {#selection} instances` }

		local rawPattern = widgets.InstantInputText {
			Hint = "Match instances (optional)",
			Width = UDim.new(1, 0),
		}

		local _patternSuccess, _pattern = pcall(RegExp.new, rawPattern, nil)
		widgets.Spacer()

		local rawRename, renameInput = widgets.InstantInputText {
			Hint = "Rename to...",
			Width = UDim.new(1, 0),
		}

		local _renameSuccess, _rename = pcall(RegExp.new, rawRename, nil)
		widgets.Spacer()

		Iris.SameLine()
		widgets.Subtext { "Insert:" }
		if Iris.Button { "Current name" }.clicked() then
			rawRename ..= "$&"
		end
		if Iris.Button { "Number Ascending" }.clicked() then
			rawRename ..= "$nn"
		end
		if Iris.Button { "Number Descending" }.clicked() then
			rawRename ..= "$NN"
		end
		renameInput.state.text:set(rawRename)
		Iris.End()

		widgets.FlexSpacer(Enum.UIFlexMode.Fill)

		Iris.Button { "Rename" }
		widgets.Subtext { "This command supports regular expressions!" }

		Iris.End()

		widgets.Frame { size = UDim2.fromScale(1 / 3, 1), automaticSize = Enum.AutomaticSize.None }
		Iris.SeparatorText { "Preview" }
		Iris.End()

		Iris.End()

		---
	end

	return output
end)

return ext
