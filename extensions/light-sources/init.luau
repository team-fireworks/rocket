local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")

local Extension = require("@src/core/Extension")
local Iris = require("@src/Iris")
local assets = require("@include/assets")
local createCoreExtension = require("@src/core/constructors/createCoreExtension")
local getRepositionState = require("@self/utils/getRepositionState")
local repositions = require("@self/repositions")
local sources = require("@self/sources")
local types = require("@self/types")

local ext = createCoreExtension {
	id = "rocket-light-sources",
	title = "Light Sources",
	description = "Artist-friendly visual control of the sun, the moon, and light instances.",
	icon = assets.extensions.lighting.sun,
	authors = { "znotfireman" },
}

for _, source in sources do
	for _, reposition in repositions do
		ext:newCommand({
			id = string.lower(`repositions-{source.name}-by-{reposition.name}`),
			title = `Reposition {source.name} by {reposition.name}`,
			description = `Repositions the {source.name} by {reposition.describedBy}.`,
		}, function(r: Extension.CommandRuntime)
			r:recordChangeHistory()
			local initial: types.RepositionState = nil :: any
			local hasInitiallyClicked = false

			local output = r:createCommandOutput()
			function output.renderViewport()
				if UserInputService:IsKeyDown(Enum.KeyCode.Escape) then
					r.trove:Clean()
					return
				end

				local isMouseDown = UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
				if hasInitiallyClicked then
					if not isMouseDown then
						initial = nil :: any
						hasInitiallyClicked = false
						r:cleanup()
						return
					end

					local now = getRepositionState(r)
					initial = initial or now
					local direction = reposition.updateDirection(initial, getRepositionState(r), true)
					if direction then
						source.updateDirection(direction)
					else
						Lighting.ClockTime = initial.clockTime
						Lighting.GeographicLatitude = initial.geographicLatitude
					end
				elseif isMouseDown then
					r:setSelection({})
					hasInitiallyClicked = true
				end
			end

			return output
		end)
	end
end

ext:newCommand({
	id = "reposition",
	title = "Reposition Light Sources",
	description = "Summons a toolbar to visually drag and adjust the sun, the moon, and light instances.",
}, function(r: Extension.CommandRuntime)
	local result = r:createCommandOutput()

	function result.renderViewport()
		if Iris.Window({ "Reposition Light Sources" }).closed() then
			r:cleanup()
			Iris.End()
			return
		end

		Iris.End()
	end

	return result
end)

return ext
