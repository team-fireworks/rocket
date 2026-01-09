local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")

local Extension = require("@src/core/Extension")
local types = require("../types")

local function useRepositionState(ctx: Extension.CommandContext): types.RepositionState
	local mouse = ctx:getMouse()
	return {
		clockTime = Lighting.ClockTime,
		geographicLatitude = Lighting.GeographicLatitude,
		sunDirection = Lighting:GetSunDirection(),
		cameraTransform = Workspace.CurrentCamera.CFrame,
		mouseTransform = mouse.Hit,
		mouseRay = mouse.UnitRay,
	}
end

return useRepositionState
