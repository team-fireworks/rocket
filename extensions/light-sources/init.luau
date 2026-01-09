local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")

local Extension = require("@src/core/Extension")
local assets = require("@include/assets")
local getRepositionState = require("@self/utils/getRepositionState")
local repositions = require("@self/repositions")
local sources = require("@self/sources")
local types = require("@self/types")

local plugin = script:FindFirstAncestorWhichIsA("Plugin") :: Plugin
local ext = Extension.new(plugin, {
	id = "rocket-light-sources",
	title = "Light Sources",
	description = "Artist-friendly visual control of the sun, the moon, and light instances.",
	icon = assets.extensions.lighting.sun,
	authors = { "znotfireman" },
})

for _, source in sources do
	for _, reposition in repositions do
		ext:newCommand({
			id = string.lower(`repositions-{source.name}-by-{reposition.name}`),
			title = `Reposition {source.name} by {reposition.name}`,
			description = `Repositions the {source.name} by {reposition.describedBy}.`,
		}, function(ctx: Extension.CommandContext)
			ctx:recordChanges()
			local hasInitiallyClicked = false

			local commandResult = ctx:newResult()
			function commandResult.renderViewport()
				if UserInputService:IsKeyDown(Enum.KeyCode.Escape) then
					ctx.trove:Clean()
					return
				end

				local initial: types.RepositionState
				local isMouseDown = UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
				if hasInitiallyClicked then
					if not isMouseDown then
						initial = nil :: any
						hasInitiallyClicked = false
						ctx.trove:Clean()
						return
					end

					local now = getRepositionState(ctx)
					initial = initial or now

					local direction = reposition.updateDirection(initial, now, true)
					if direction then
						source.updateDirection(direction)
					else
						Lighting.ClockTime = initial.clockTime
						Lighting.GeographicLatitude = initial.geographicLatitude
					end
				elseif isMouseDown then
					ctx:setSelection({})
					hasInitiallyClicked = true
				end
			end

			return commandResult
		end)
	end
end

return ext
