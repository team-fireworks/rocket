local Extension = require("@src/core/Extension")
local assets = require("@include/assets")
local createCoreExtension = require("@src/core/constructors/createCoreExtension")

local ext = createCoreExtension {
	id = "rocket-trusses",
	title = "Trusses",
	description = "Quickly fill TrussParts with solid materials for obbies.",
	icon = assets.extensions.rocket,
	authors = { "Team Fireworks" },
}

local TRUSS_FILLER_TAG = `Rocket Geometry: Truss Filler`

local function fill(truss: TrussPart)
	local filler: BasePart
	local fillerName = "TrussFill"

	local existing = truss:FindFirstChild(fillerName)
	if existing then
		if existing:IsA("BasePart") and existing:HasTag(TRUSS_FILLER_TAG) then
			filler = existing
		else
			existing:Destroy()
		end
	end

	filler = filler or Instance.new("Part")

	filler.Anchored = true
	filler.CanCollide = false
	filler.CastShadow = truss.CastShadow
	filler.CFrame = truss.CFrame
	filler.Color = truss.Color
	filler.Material = truss.Material
	filler.Name = fillerName
	filler.Reflectance = truss.Reflectance
	filler.Size = truss.Size - Vector3.new(0.5, 0.5, 0.5)
	filler.Transparency = truss.Transparency

	filler.Parent = truss
	filler:AddTag(TRUSS_FILLER_TAG)

	return filler
end

local function fillRecursive(instances: { Instance }): { Instance }
	local result = {}
	for _, child in instances do
		if child:IsA("TrussPart") then
			table.insert(result, fill(child))
		end

		local childFillers = fillRecursive(child:GetChildren())
		table.move(childFillers, 1, #childFillers, #result, result)
	end
	return result
end

ext:newCommand({
	id = `fill-trusses`,
	title = `Fill Trusses`,
	description = `Fills the insides of selected TrussParts, then selects the fills.`,
}, function(context: Extension.CommandRuntime)
	context:recordChangeHistory()
	context:setSelection(fillRecursive(context:getSelection()))
end)

ext:newCommand({
	id = "delete-truss-fill",
	title = "Delete Truss Fill",
	description = "Deletes fills in selected TrussParts that was created by this extension.",
}, function(context: Extension.CommandRuntime)
	context:recordChangeHistory()

	for _, selected in context:getSelection() do
		if selected:HasTag(TRUSS_FILLER_TAG) then
			selected:Destroy()
			continue
		end

		for _, descendant in selected:GetDescendants() do
			if descendant:HasTag(TRUSS_FILLER_TAG) then
				descendant:Destroy()
			end
		end
	end
end)

return ext
