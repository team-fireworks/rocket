local Extension = require("@src/core/Extension")
local assets = require("@include/assets")
local constants = require("@src/constants")
local createCoreExtension = require("@src/core/constructors/createCoreExtension")

local ext = createCoreExtension({
	id = "rocket-tidy",
	title = "Tidy",
	description = "Keep your game organized.",
	icon = assets.extensions.rocket,
	authors = {
		{ type = "user", id = constants.userIds.znotfireman },
	},
})

local CONTAINERS = { "Folder", "Model" }

for _, containerFrom in CONTAINERS do
	for _, containerTo in CONTAINERS do
		if containerFrom == containerTo then
			continue
		end

		-- TODO: maybe move this command to a dedicated reclass plugin?
		ext:newCommand({
			id = string.lower(`{containerFrom}-to-{containerTo}`),
			title = `{containerFrom} to {containerTo}`,
			description = `Converts all {containerFrom}s in the selection to {containerTo}s.`,
		}, function(r: Extension.CommandRuntime)
			r:recordChangeHistory()

			local newSelection = {}
			for index, selected in r:useSelection() do
				if selected:IsA(containerFrom) then
					local newContainer = Instance.new(containerTo)
					newContainer.Name = selected.Name
					newContainer.Archivable = selected.Archivable

					for _, tag in selected:GetTags() do
						selected:AddTag(tag)
					end

					for attribute, value in selected:GetAttributes() do
						selected:SetAttribute(attribute, value)
					end

					for _, child in selected:GetChildren() do
						child.Parent = newContainer
					end

					newContainer.Parent = selected.Parent
					selected:Destroy()
					newSelection[index] = newContainer
				else
					newSelection[index] = selected
				end
			end

			r:setSelection(newSelection)
		end)
	end

	-- ext:newCommand({
	-- 	id = string.lower(`group-{containerFrom}`),
	-- 	title = `Group Selection into {containerFrom}`,
	-- 	description = `Groups the current selection into a new {containerFrom}.`,
	-- }, function(context: Extension.CommandRuntime)
	-- 	context:recordChangeHistory()

	-- 	local container = Instance.new(containerFrom)
	-- 	local newSelection = {}
	-- 	for index, selected in context:useSelection() do
	-- 	end

	-- 	context:setSelection({container})
	-- end)
end

ext:newCommand({
	id = "ungroup",
	title = `Ungroup Selection`,
	description = `Expands the children of the current selection, thus ungrouping it.`,
}, function(r: Extension.CommandRuntime)
	r:recordChangeHistory()

	local newSelection = {}
	for _, selected in r:useSelection() do
		local parent = selected.Parent
		for _, children in selected:GetChildren() do
			children.Parent = parent
			table.insert(newSelection, children)
		end
		selected:Destroy()
	end

	r:setSelection(newSelection)
end)

return ext
