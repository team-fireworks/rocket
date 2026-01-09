local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")

local typeforge = require("@include/typeforge")

export type Properties = {
	Color3: Color3,
	Transparency: number,
}

export type PartialProperties = typeforge.Partial<Properties>

local RADIUS = 0.05
local POINT_RADIUS = 0.5
local BASE_PROEPRTIES = {
	Adornee = Workspace:WaitForChild("Terrain"),
	AlwaysOnTop = true,
	AdornCullingMode = Enum.AdornCullingMode.Automatic,
	Color3 = Color3.new(1, 1, 1),
	Transparency = 0,
	Visible = false,
	ZIndex = 1,
}

local classPool: { [string]: { Instance } } = {}
local previous: { GuiBase3d }, queue: { GuiBase3d } = {}, {}
local propertyStack: { { [string]: any } } = { BASE_PROEPRTIES }

local Gizmos = {}
Gizmos.RADIUS = RADIUS
Gizmos.POINT_RADIUS = POINT_RADIUS

function Gizmos.pushProperties(delta: PartialProperties)
	table.insert(propertyStack, delta :: { [string]: any })
end

function Gizmos.popProperties()
	if #propertyStack > 1 then
		table.remove(propertyStack)
	end
end

function Gizmos.style(adornment: GuiBase3d)
	for _, properties in propertyStack do
		for property, value in pairs(properties) do
			(adornment :: any)[property] = value
		end
	end
end

function Gizmos.getFolder(): Instance
	local gizmos = CoreGui:FindFirstChild("RocketGizmos") :: Instance
	if not gizmos then
		gizmos = Instance.new("Folder")
		gizmos.Name = "RocketGizmos"
		gizmos.Parent = CoreGui
		gizmos.Archivable = false
	end

	return gizmos
end

function Gizmos.getPooled(class: string): any
	local instancePool = classPool[class]
	if instancePool then
		local pooled = table.remove(instancePool)
		if pooled then
			return pooled
		end
	end

	local pooled = Instance.new(class)
	pooled.Parent = Gizmos.getFolder()
	return pooled
end

function Gizmos.releasePooled(instance: Instance)
	local class = instance.ClassName
	local instancePool = classPool[class]
	if not instancePool then
		instancePool = {}
		classPool[class] = instancePool
	end
	table.insert(instancePool, instance)
end

function Gizmos.destroyPool()
	for index, instances in classPool do
		for instanceIndex, instance in instances do
			instance:Destroy()
			instances[instanceIndex] = nil
		end
		classPool[index] = nil
	end
end

function Gizmos.step()
	for _, adornment in previous do
		adornment.Visible = false
		Gizmos.releasePooled(adornment)
	end

	table.clear(previous)

	for _, adornment in queue do
		adornment.Visible = true
	end

	previous = queue
	queue = {}
end

function Gizmos.drawSphere(transform: CFrame, radius: number?)
	local adornment: SphereHandleAdornment = Gizmos.getPooled("SphereHandleAdornment")
	Gizmos.style(adornment)
	adornment.Radius = radius or RADIUS
	adornment.CFrame = transform
	table.insert(queue, adornment)
end

function Gizmos.drawCylinder(transform: CFrame, height: number, radius: number?)
	local adornment: CylinderHandleAdornment = Gizmos.getPooled("CylinderHandleAdornment")
	Gizmos.style(adornment)
	adornment.CFrame = transform
	adornment.Radius = radius or RADIUS
	adornment.InnerRadius = 0
	adornment.Height = height
	table.insert(queue, adornment)
end

function Gizmos.drawLine(from: Vector3, to: Vector3)
	local distance = (to - from).magnitude
	local adornment: CylinderHandleAdornment = Gizmos.getPooled("CylinderHandleAdornment")
	Gizmos.style(adornment)
	adornment.Radius = RADIUS
	adornment.InnerRadius = 0
	adornment.Height = distance
	adornment.CFrame = CFrame.lookAt(from, to) * CFrame.new(0, 0, -distance * 0.5)
	table.insert(queue, adornment)
end

function Gizmos.drawArrow(from: Vector3, to: Vector3)
	local distance = (to - from).magnitude - POINT_RADIUS
	local orientation = CFrame.lookAt(from, to)

	local adornmentLine: CylinderHandleAdornment = Gizmos.getPooled("CylinderHandleAdornment")
	Gizmos.style(adornmentLine)
	adornmentLine.Radius = RADIUS
	adornmentLine.InnerRadius = 0
	adornmentLine.Height = distance
	adornmentLine.CFrame = orientation * CFrame.new(0, 0, -distance * 0.5)
	table.insert(queue, adornmentLine)

	local adornmentCone: ConeHandleAdornment = Gizmos.getPooled("ConeHandleAdornment")
	Gizmos.style(adornmentCone)
	adornmentCone.Height = POINT_RADIUS
	adornmentCone.Radius = POINT_RADIUS * 0.5
	adornmentCone.CFrame = orientation * CFrame.new(0, 0, -distance)
	table.insert(queue, adornmentCone)
end

-- Code from the Arc Parts PR:
-- https://github.com/team-fireworks/rocket/pull/9
function Gizmos.drawBoundingBox(transform: CFrame, size: Vector3)
	local topFrontRightCorner = transform * Vector3.new(size.X / 2, size.Y / 2, -size.Z / 2)
	local topFrontLeftCorner = transform * Vector3.new(-size.X / 2, size.Y / 2, -size.Z / 2)
	local topBackLeftCorner = transform * Vector3.new(-size.X / 2, size.Y / 2, size.Z / 2)
	local topBackRightCorner = transform * Vector3.new(size.X / 2, size.Y / 2, size.Z / 2)
	local bottomFrontRightCorner = transform * Vector3.new(size.X / 2, -size.Y / 2, -size.Z / 2)
	local bottomFrontLeftCorner = transform * Vector3.new(-size.X / 2, -size.Y / 2, -size.Z / 2)
	local bottomBackLeftCorner = transform * Vector3.new(-size.X / 2, -size.Y / 2, size.Z / 2)
	local bottomBackRightCorner = transform * Vector3.new(size.X / 2, -size.Y / 2, size.Z / 2)

	-- Top surface
	Gizmos.drawLine(topFrontRightCorner, topFrontLeftCorner)
	Gizmos.drawLine(topFrontLeftCorner, topBackLeftCorner)
	Gizmos.drawLine(topBackLeftCorner, topBackRightCorner)
	Gizmos.drawLine(topBackRightCorner, topFrontRightCorner)

	-- Side edges
	Gizmos.drawLine(topFrontRightCorner, bottomFrontRightCorner)
	Gizmos.drawLine(topFrontLeftCorner, bottomFrontLeftCorner)
	Gizmos.drawLine(topBackLeftCorner, bottomBackLeftCorner)
	Gizmos.drawLine(topBackRightCorner, bottomBackRightCorner)

	-- Buttom surface
	Gizmos.drawLine(bottomFrontRightCorner, bottomFrontLeftCorner)
	Gizmos.drawLine(bottomFrontLeftCorner, bottomBackLeftCorner)
	Gizmos.drawLine(bottomBackLeftCorner, bottomBackRightCorner)
	Gizmos.drawLine(bottomBackRightCorner, bottomFrontRightCorner)
end

-- Code from the Arc Parts PR:
-- https://github.com/team-fireworks/rocket/pull/9
function Gizmos.drawSurface(surface: Enum.NormalId, transform: CFrame, size: Vector3)
	local topFrontRightCorner = transform * Vector3.new(size.X / 2, size.Y / 2, -size.Z / 2)
	local topFrontLeftCorner = transform * Vector3.new(-size.X / 2, size.Y / 2, -size.Z / 2)
	local topBackLeftCorner = transform * Vector3.new(-size.X / 2, size.Y / 2, size.Z / 2)
	local topBackRightCorner = transform * Vector3.new(size.X / 2, size.Y / 2, size.Z / 2)
	local bottomFrontRightCorner = transform * Vector3.new(size.X / 2, -size.Y / 2, -size.Z / 2)
	local bottomFrontLeftCorner = transform * Vector3.new(-size.X / 2, -size.Y / 2, -size.Z / 2)
	local bottomBackLeftCorner = transform * Vector3.new(-size.X / 2, -size.Y / 2, size.Z / 2)
	local bottomBackRightCorner = transform * Vector3.new(size.X / 2, -size.Y / 2, size.Z / 2)

	if surface == Enum.NormalId.Top then
		Gizmos.drawLine(topFrontRightCorner, topFrontLeftCorner)
		Gizmos.drawLine(topFrontLeftCorner, topBackLeftCorner)
		Gizmos.drawLine(topBackLeftCorner, topBackRightCorner)
		Gizmos.drawLine(topBackRightCorner, topFrontRightCorner)
	elseif surface == Enum.NormalId.Bottom then
		Gizmos.drawLine(bottomFrontRightCorner, bottomFrontLeftCorner)
		Gizmos.drawLine(bottomFrontLeftCorner, bottomBackLeftCorner)
		Gizmos.drawLine(bottomBackLeftCorner, bottomBackRightCorner)
		Gizmos.drawLine(bottomBackRightCorner, bottomFrontRightCorner)
	elseif surface == Enum.NormalId.Left then
		Gizmos.drawLine(topFrontLeftCorner, topBackLeftCorner)
		Gizmos.drawLine(topBackLeftCorner, bottomBackLeftCorner)
		Gizmos.drawLine(bottomBackLeftCorner, bottomFrontLeftCorner)
		Gizmos.drawLine(bottomFrontLeftCorner, topFrontLeftCorner)
	elseif surface == Enum.NormalId.Right then
		Gizmos.drawLine(topFrontRightCorner, topBackRightCorner)
		Gizmos.drawLine(topBackRightCorner, bottomBackRightCorner)
		Gizmos.drawLine(bottomBackRightCorner, bottomFrontRightCorner)
		Gizmos.drawLine(bottomFrontRightCorner, topFrontRightCorner)
	elseif surface == Enum.NormalId.Front then
		Gizmos.drawLine(topFrontLeftCorner, topFrontRightCorner)
		Gizmos.drawLine(topFrontRightCorner, bottomFrontRightCorner)
		Gizmos.drawLine(bottomFrontRightCorner, bottomFrontLeftCorner)
		Gizmos.drawLine(bottomFrontLeftCorner, topFrontLeftCorner)
	elseif surface == Enum.NormalId.Back then
		Gizmos.drawLine(topBackLeftCorner, topBackRightCorner)
		Gizmos.drawLine(topBackRightCorner, bottomBackRightCorner)
		Gizmos.drawLine(bottomBackRightCorner, bottomBackLeftCorner)
		Gizmos.drawLine(bottomBackLeftCorner, topBackLeftCorner)
	end
end

return table.freeze(Gizmos)
