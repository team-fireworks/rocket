local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local Extension = require("@src/core/Extension")
local Iris = require("@src/Iris")
local UserIds = require("@src/constants/UserIds")
local assetInserters = require("@self/assetInserters")
local assets = require("@include/assets")
local createCoreExtension = require("@src/core/constructors/createCoreExtension")
local products = require("@self/products")
local types = require("@self/types")
local widgets = require("@src/widgets")

local ext = createCoreExtension {
	id = "rocket-insert",
	title = "Insert",
	description = "TBA",
	icon = assets.extensions.rocket,
	contributors = {
		{ type = "user", id = UserIds.znotfireman },
	},
}

ext:newCommand({
	id = "insert-asset",
	title = "Insert Asset",
	description = "Fetches and inserts the given asset ID into the game.",
}, function(r: Extension.CommandRuntime)
	local output = r:createCommandOutput()

	function output.renderWindow(window: Iris.Window)
		local maybeAssetId, assetInput = widgets.InstantInputText({ hint = "ie. 1234567890", label = "Asset ID" })

		if r.isFirstRun then
			window.state.position:set(UserInputService:GetMouseLocation())
			assetInput.state.text:set("")
			maybeAssetId = ""
		end

		local assetId = tonumber(maybeAssetId)
		if not assetId then
			return
		end

		local product = products.fetch(assetId)
		if not product then
			widgets.Subtext({
				if products.invalidIds[assetId] then `Invalid asset ID "{assetId}"!` else "Fetching asset...",
			})
			return
		end

		local assetTypeId = product.AssetTypeId
		-- selene: allow(incorrect_standard_library_use)
		local maybeAssetType = Enum.AssetType:FromValue(assetTypeId)
		local assetTypeName = if maybeAssetType then maybeAssetType.Name else "Unknown"

		local inserter = assetInserters[assetTypeId]
		if not inserter then
			Iris.Text({ `Rocket doesn't support inserting assets of type {assetTypeName}!` })
			widgets.Subtext({ `asset type ID: {assetTypeId}` })
			return
		end

		widgets.Subtext({ `Got asset of type {assetTypeName}! (asset type ID: {assetTypeId})` })

		Iris.SameLine()
		for _, options in inserter do
			if not Iris.Button({ options.label }).clicked() then
				continue
			end

			task.spawn(function(r: Extension.CommandRuntime, product: types.ProductInfo)
				window.state.isOpened:set(false)
				local finishRecording = r:recordChangeHistory()

				local success, inserted: Instance = pcall(options.insert, product)
				local recordingOperation = Enum.FinishRecordingOperation.Commit
				if success then
					r.log:trace(`Successfully inserted "{product.Name}" (ID: {product.AssetId}) as`, inserted)
					inserted.Parent = r:useSelection()[1] or Workspace
					r:setSelection({ inserted })
				else
					r.log:warn(`Failed to insert "{product.Name}" (ID: {product.AssetId}):`, inserted)
					recordingOperation = Enum.FinishRecordingOperation.Cancel
				end

				finishRecording(recordingOperation)
				window.state.isOpened:set(true)
				r:cleanup()
			end, r, product)
		end
		Iris.End()
	end

	return output
end)

ext:newCommand({
	id = "insert-avatar",
	title = "Insert Avatar",
	description = "Search, fetches, and inserts the given user's avatar into the game.",
}, function()
	-- TODO
end)

ext:newCommand({
	id = "insert-pkg-pesde",
	title = "Insert Package from pesde",
	description = "Search, fetches, and inserts from the pesde package manager.",
}, function()
	-- TODO
end)

ext:newCommand({
	id = "insert-pkg-wally",
	title = "Insert Package from Wally",
	description = "Search, fetches, and inserts from the Wally package manager.",
}, function()
	-- TODO
end)

ext:newCommand({
	id = "insert-git",
	title = "Insert from Git",
	description = "Inserts a Git repository into the game.",
}, function()
	-- TODO
end)

return ext
