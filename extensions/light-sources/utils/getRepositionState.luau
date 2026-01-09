local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")

local Extension = require("@src/core/Extension")
local types = require("../types")

local function useRepositionState(ctx: Extension.CommandContext): types.RepositionState
	return {
		clockTime = Lighting.ClockTime,
		geographicLatitude = Lighting.GeographicLatitude,
		sunDirection = Lighting:GetSunDirection(),
		cameraTransform = Workspace.CurrentCamera.CFrame,
		mouseTransform = ctx:getMouse().Hit,
	}
end

return useRepositionState
