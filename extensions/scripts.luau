local ScriptEditorService = game:GetService("ScriptEditorService")

local Extension = require("@src/core/Extension")
local Iris = require("@src/Iris")
local UserIds = require("@src/constants/UserIds")
local assets = require("@include/assets")
local createCoreExtension = require("@src/core/constructors/createCoreExtension")
local pluginTrove = require("@src/pluginTrove")
local widgets = require("@src/widgets")

local ext = createCoreExtension {
	id = "rocket-scripts",
	title = "Scripts",
	description = "TBA",
	icon = assets.extensions.rocket,
	contributors = {
		{ type = "user", id = UserIds.znotfireman },
	},
}

local scripts: { LuaSourceContainer } = {}
local scriptIndex: { [LuaSourceContainer]: number } = {}
local function tryAddScript(script: Instance)
	if script:IsA("LuaSourceContainer") then
		table.insert(scripts, script)
		scriptIndex[script] = #scripts
	end
end
pluginTrove:Add(task.spawn(function()
	for _, d in game:GetDescendants() do
		tryAddScript(d)
	end
	pluginTrove:Add(game.DescendantAdded:Connect(tryAddScript))
end))

-- TODO: can we implement virtualized lists this is lagging rlly bad, restrain
-- to like first 50 or sm shit
ext:newCommand({
	id = "search-all-scripts",
	title = "Search All Scripts",
	description = "TBA",
}, function(r: Extension.CommandRuntime)
	local output = r:createCommandOutput()

	local search = ""
	local firstRun = true
	output.windowConfig = { WindowPadding = Vector2.zero, ItemSpacing = Vector2.zero }
	function output.renderWindow()
		widgets.List({
			captureFocus = firstRun,

			search = search,
			onSearchChange = function(newSearch)
				search = newSearch
			end,

			entries = scripts,
			getEntryTitle = function(entry: LuaSourceContainer)
				return entry:GetFullName()
			end,
			renderEntry = function(entry: LuaSourceContainer)
				Iris.Text({ entry.Name })
				widgets.Subtext({ entry:GetFullName() })
			end,
			onEntrySelected = function(entry: LuaSourceContainer)
				task.spawn(ScriptEditorService.OpenScriptDocumentAsync, ScriptEditorService, entry, nil)
			end,
		} :: widgets.ListProps<LuaSourceContainer>)

		firstRun = false
	end

	return output
end)

ext:newCommand({
	id = "search-open-scripts",
	title = "Search Open Scripts",
	description = "TBA",
}, function(r: Extension.CommandRuntime)
	local output = r:createCommandOutput()

	local firstRun = true
	output.windowConfig = { WindowPadding = Vector2.zero, ItemSpacing = Vector2.zero }

	function output.renderWindow()
		local scriptDocuments = ScriptEditorService:GetScriptDocuments() :: { ScriptDocument }
		local realDocuments = table.create(#scriptDocuments) :: { ScriptDocument }
		for _, document in scriptDocuments do
			if not document:IsCommandBar() then
				table.insert(realDocuments, document)
			end
		end

		widgets.List({
			captureFocus = firstRun,

			entries = realDocuments,
			getEntryTitle = function(entry: ScriptDocument)
				return entry:GetScript():GetFullName()
			end,
			renderEntry = function(entry: ScriptDocument)
				local entryScript = assert(entry:GetScript())
				Iris.Text({ entryScript.Name })
				widgets.Subtext({ entryScript:GetFullName() })
			end,
			onEntrySelected = function(entry: ScriptDocument)
				task.spawn(ScriptEditorService.OpenScriptDocumentAsync, ScriptEditorService, entry:GetScript(), nil)
			end,
		} :: widgets.ListProps<ScriptDocument>)

		firstRun = false
	end

	return output
end)

return ext
