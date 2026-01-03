-- Inspired by EzLight and Elttob Relight
-- Reposition logic partially based on EzLight

local ChangeHistoryService = game:GetService("ChangeHistoryService")
local Lighting = game:GetService("Lighting")
local Selection = game:GetService("Selection")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local Extension = require("@src/Extension")
-- local Gizmos = require("@src/Gizmos")
local assets = require("@src/assets")
local types = require("@self/types")

local TAU = math.pi * 2
-- local GIZMO_COLOR = Color3.fromHex("#AC7400")
-- local GIZMO_PROPERTIES: Gizmos.PartialProperties = { Color3 = GIZMO_COLOR }

local plugin = script:FindFirstAncestorWhichIsA("Plugin") :: Plugin

local sources = {
	{ id = "sun", title = "Sun", longtitudeFactor = 1, icon = assets.extensions.lighting.sun },
	{ id = "moon", title = "Moon", longtitudeFactor = -1, icon = assets.extensions.lighting.moon },
}

local repositions: { types.Reposition } = {
	require("@self/repositions/CursorReposition"),
	require("@self/repositions/FaceReposition"),
	require("@self/repositions/LineReposition"),
	require("@self/repositions/ReflectionReposition"),
	require("@self/repositions/ShadowReposition"),
}

local ext = Extension.new(plugin, {
	id = "rocket-lighting",
	title = "Lighting",
	description = "Artist-friendly lighting control with visual control of the sun and moon.",
	icon = { Image = assets.extensions.lighting.sun },
	authors = { "Team Fireworks" },
})

local function useRepositionState(ctx: Extension.CommandContext): types.RepositionState
	return {
		clockTime = Lighting.ClockTime,
		geographicLatitude = Lighting.GeographicLatitude,
		sunDirection = Lighting:GetSunDirection(),
		cameraTransform = Workspace.CurrentCamera.CFrame,
		cameraPosition = Workspace.CurrentCamera.CFrame.Position,
		cameraDirection = Workspace.CurrentCamera.CFrame.LookVector,
		mouseTransform = ctx.mouse.Hit,
		mousePosition = ctx.mouse.Hit.Position,
		mouseDirection = ctx.mouse.UnitRay.Direction,
	}
end

local function repositionDirection(direction: Vector3, longitudeFactor: number)
	local latitude = math.atan2(direction.Z, math.sqrt(direction.X ^ 2 + direction.Y ^ 2))
	local longtitude = math.atan2(direction.Y * -longitudeFactor, direction.X * -longitudeFactor)

	local clockTime = (longtitude / TAU) * 24 - 6
	local geographicLatitude = (latitude / TAU) * 360 + 23.5

	Lighting.ClockTime = clockTime % 24
	Lighting.GeographicLatitude = geographicLatitude
end

for _, source in sources do
	for _, reposition in repositions do
		local initial: types.RepositionState?
		local hasInitiallyClicked = false
		ext:newCommand({
			id = `reposition-{source.id}-by-{reposition.id}`,
			title = `Reposition {source.title} by {reposition.title}`,
			description = `Reposition the {source.title} by {reposition.describedBy}.`,
			icon = { Image = source.icon },

			run = function(ctx: Extension.CommandContext)
				ctx:recordChanges()
			end,

			renderInViewport = function(ctx: Extension.CommandContext)
				if UserInputService:IsKeyDown(Enum.KeyCode.Escape) then
					ctx.trove:Clean()
					return
				end

				local isMouseDown = UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
				if hasInitiallyClicked then
					if not isMouseDown then
						initial = nil
						hasInitiallyClicked = false
						ctx.trove:Clean()
						return
					end

					local now = useRepositionState(ctx)
					initial = initial or now

					-- Gizmos.pushProperties(GIZMO_PROPERTIES)
					local direction = reposition.update(initial :: types.RepositionState, now, true)
					-- Gizmos.popProperties()

					if direction then
						repositionDirection(direction, source.longtitudeFactor)
					else
						Lighting.ClockTime = (initial :: types.RepositionState).clockTime
						Lighting.GeographicLatitude = (initial :: types.RepositionState).geographicLatitude
					end
				elseif isMouseDown then
					Selection:Set({})
					hasInitiallyClicked = true
				end
			end,
		})
	end
end

ext:newCommand({
	id = "toggle-shadows",
	title = "Toggle Shadows",
	description = "Toggles Lighting's GlobalShadows property",

	run = function(ctx: Extension.CommandContext)
		ctx:recordChanges("toggle-shadows", "Toggle Shadows")
		Lighting.GlobalShadows = not Lighting.GlobalShadows
	end,
})

return ext
