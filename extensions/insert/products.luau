local MarketplaceService = game:GetService("MarketplaceService")

local pluginTrove = require("@src/pluginTrove")
local types = require("./types")

local cache: { [number]: types.ProductInfo } = {}
local threads = {}
local invalidIds = {}

local function fetch(assetId: number): types.ProductInfo?
	local existing = cache[assetId]
	if existing then
		return existing
	end

	if not (threads[assetId] or invalidIds[assetId]) then
		threads[assetId] = task.spawn(function(assetId: number)
			local productExists, productInfo =
				pcall(MarketplaceService.GetProductInfoAsync, MarketplaceService, assetId, nil)

			if productExists then
				cache[assetId] = productInfo
			else
				invalidIds[assetId] = true
			end

			threads[assetId] = nil
		end, assetId)
	end

	return nil
end

pluginTrove:Add(function()
	for _, thread in threads do
		pcall(task.cancel, thread)
	end

	table.clear(cache)
	table.clear(threads)
	table.clear(invalidIds)
end)

return table.freeze({
	cache = cache,
	threads = threads,
	invalidIds = invalidIds,
	fetch = fetch,
})
