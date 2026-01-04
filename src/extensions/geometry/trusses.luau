local UserInputService = game:GetService("UserInputService")

local Extension = require("@src/Extension")
local ext = require(".")

type TrussMaterial = { name: string, properties: { [string]: any } }

local function createSurfaceProperties(surface: Enum.SurfaceType): { [string]: any }
	return {
		TopSurface = surface,
		BottomSurface = surface,
		RightSurface = surface,
		LeftSurface = surface,
		FrontSurface = surface,
		BackSurface = surface,
	}
end

local TRUSS_MATERIALS: { TrussMaterial } = {
	{ name = "Neon", properties = { Material = Enum.Material.Neon } },
	{ name = "Granite", properties = { Material = Enum.Material.Granite } },
	{ name = "Glass", properties = { Material = Enum.Material.Glass, Transparency = 0.5 } },
	{ name = "Plastic", properties = { Material = Enum.Material.Plastic } },
	{ name = "Stud", properties = createSurfaceProperties(Enum.SurfaceType.Studs) },
	{ name = "Inlet", properties = createSurfaceProperties(Enum.SurfaceType.Inlet) },
	{ name = "Universal", properties = createSurfaceProperties(Enum.SurfaceType.Universal) },
	{ name = "Smooth", properties = createSurfaceProperties(Enum.SurfaceType.Smooth) },
	{ name = "Glue", properties = createSurfaceProperties(Enum.SurfaceType.Glue) },
}

local TRUSS_MATERIAL_NAMES = {}
local TRUSS_MATERIALS_BY_NAMES = {}
for i, material in TRUSS_MATERIALS do
	TRUSS_MATERIAL_NAMES[i] = material.name
	TRUSS_MATERIALS_BY_NAMES[material.name] = material
end

local TRUSS_FILLER_TAG = `Rocket Geometry: Truss Filler`

local function fill(truss: TrussPart, material: TrussMaterial)
	local filler: BasePart
	local fillerName = truss.Name .. "Fill"

	local existing = truss:FindFirstChild(fillerName)
	if existing and existing:HasTag(TRUSS_FILLER_TAG) and existing:IsA("BasePart") then
		filler = existing
	end

	filler = filler or Instance.new("Part")

	filler.Anchored = true
	filler.CanCollide = false
	filler.CastShadow = truss.CastShadow
	filler.CFrame = truss.CFrame
	filler.Color = truss.Color
	filler.Name = fillerName
	filler.Reflectance = truss.Reflectance
	filler.Size = truss.Size - Vector3.new(0.5, 0.5, 0.5)
	filler.Transparency = truss.Transparency

	for property, value in material.properties do
		(filler :: any)[property] = value
	end

	filler.Parent = truss
	filler:AddTag(TRUSS_FILLER_TAG)
end

local function fillRecursive(instances: { Instance }, material: TrussMaterial)
	for _, child in instances do
		if child:IsA("TrussPart") then
			fill(child, material)
		end

		fillRecursive(child:GetChildren(), material)
	end
end

for _, material in TRUSS_MATERIALS do
	ext:newCommand({
		id = `fill-trusses-with-{string.lower(material.name)}`,
		title = `Fill Trusses with {material.name}`,
		description = `Fills selected TrussParts with {material.name} parts.`,

		run = function(ctx: Extension.CommandContext)
			ctx:recordChanges()
			fillRecursive(ctx:getSelection(), material)
		end,
	})
end

ext:newCommand({
	id = "fill-trusses",
	title = "Select and Fill Trusses",
	description = "Fills selected TrussParts with the given material",

	run = function(ctx: Extension.CommandContext)
		ctx:recordChanges()
		ctx:setState("firstRun", true)
	end,

	renderInViewport = function(ctx: Extension.CommandContext)
		local Iris = ctx.iris
		local window = Iris.Window(
			{ "Select material to fill trusses" },
			{ position = UserInputService:GetMouseLocation() } :: any
		)

		if window.closed() then
			ctx:cleanup()
			Iris.End()
			return
		end

		local search = ""
		local inputField = Iris.InputText({ "", "Search materials..." })
		local input = inputField.Instance:FindFirstChildWhichIsA("TextBox")
		if input then
			search = input.Text
			if ctx:getState("firstRun") then
				ctx:setState("firstRun", false)
				input:CaptureFocus()
			end
		end

		local searchResults: { string } = TRUSS_MATERIAL_NAMES
		if search ~= "" then
			local results = ctx.fzy.filter(search, TRUSS_MATERIAL_NAMES)
			searchResults = table.create(#results) :: { string }
			for i, result in results do
				searchResults[i] = TRUSS_MATERIAL_NAMES[result[1]]
			end
		end

		local selectedMaterial: TrussMaterial?
		for _, name in searchResults do
			if Iris.Button(name, UDim2.fromScale(1, 0)).clicked() then
				selectedMaterial = TRUSS_MATERIALS_BY_NAMES[name]
			end
		end

		if not selectedMaterial then
			if inputField.textChanged() then
				local first = searchResults[1]
				if first then
					selectedMaterial = TRUSS_MATERIALS_BY_NAMES[first]
				end
			end
		end

		if selectedMaterial then
			fillRecursive(ctx:getSelection(), selectedMaterial)
			ctx:cleanup()
		end

		Iris.End()
	end,
})

ext:newCommand({
	id = "delete-truss-fill",
	title = "Delete Truss Fill",
	description = "Deletes fills in selected TrussParts that was added by this extension.",

	run = function(ctx: Extension.CommandContext)
		ctx:recordChanges()

		for _, selected in ctx:getSelection() do
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
	end,
})

return nil
