local Lighting = game:GetService("Lighting")

local TAU = math.pi * 2

local function setLightingDirection(direction: Vector3, longitudeFactor: number)
	local latitude = math.atan2(direction.Z, math.sqrt(direction.X ^ 2 + direction.Y ^ 2))
	local longtitude = math.atan2(direction.Y * -longitudeFactor, direction.X * -longitudeFactor)

	local clockTime = (longtitude / TAU) * 24 - 6
	local geographicLatitude = (latitude / TAU) * 360 + 23.5

	Lighting.ClockTime = clockTime % 24
	Lighting.GeographicLatitude = geographicLatitude
end

return setLightingDirection
