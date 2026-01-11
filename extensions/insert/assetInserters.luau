local types = require("./types")

local function wrapClassInserter(class: string, assetProperty: string): types.Inserter
	return function(product)
		local instance = Instance.new(class);
		(instance :: any)[assetProperty] = `rbxassetid://{product.AssetId}`
		return instance
	end
end

local insertImageOptions: { types.InsertOptions } = {
	{ label = "As Decal", insert = wrapClassInserter("Decal", "Texture") },
	{ label = "As Texture", insert = wrapClassInserter("Texture", "Texture") },
	{ label = "As ImageLabel", insert = wrapClassInserter("ImageLabel", "Image") },
	{ label = "As ImageButton", insert = wrapClassInserter("ImageButton", "Image") },
}

local insertAssetOptions = {
	{
		label = "Insert",
		insert = function(product: types.ProductInfo)
			-- InsertSevice:LoadAsset requires you to own the asset </3
			local objects = game:GetObjects(`rbxassetid://{product.AssetId}`)
			if #objects == 1 then
				return objects[1]
			end

			local container: Instance = Instance.new("Model")
			container.Name = product.Name

			for _, child in objects do
				child.Parent = container
			end

			return container
		end,
	},
}

local assetInserters: { [number]: { types.InsertOptions }? } = {
	[Enum.AssetType.Image.Value] = insertImageOptions,
	[Enum.AssetType.Decal.Value] = insertImageOptions,

	[Enum.AssetType.Lua.Value] = insertAssetOptions,
	[Enum.AssetType.Plugin.Value] = insertAssetOptions,
	[Enum.AssetType.MeshPart.Value] = insertAssetOptions,

	[Enum.AssetType.Audio.Value] = {
		{ label = "Insert", insert = wrapClassInserter("Sound", "SoundId") },
	},

	[Enum.AssetType.Mesh.Value] = {
		{
			label = "Insert",
			insert = function(product: types.ProductInfo)
				local instance = Instance.new("Part")
				instance.Anchored = true

				local mesh = Instance.new("SpecialMesh")
				mesh.MeshId = `rbxassetid://{product.AssetId}`
				mesh.Parent = instance

				return instance
			end,
		},
	},
}

return assetInserters
