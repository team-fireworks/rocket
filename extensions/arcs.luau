-- Concept inspired by the Archimedes plugin:
-- 	   https://devforum.roblox.com/t/introducing-archimedes-3-a-building-plugin/1610366
-- Original PR:
--	   https://github.com/team-fireworks/rocket/pull/9

local UserInputService = game:GetService("UserInputService")

local Extension = require("@src/core/Extension")
local Gizmos = require("@src/core/Gizmos")
local Iris = require("@src/Iris")
local UserIds = require("@src/constants/UserIds")
local assets = require("@include/assets")
local createCoreExtension = require("@src/core/constructors/createCoreExtension")

local FACE_AXES: { [Enum.NormalId]: { normal: Vector3, u: Vector3, v: Vector3 } } = {
	[Enum.NormalId.Top] = { normal = Vector3.yAxis, u = Vector3.xAxis, v = -Vector3.zAxis },
	[Enum.NormalId.Bottom] = { normal = -Vector3.yAxis, u = Vector3.xAxis, v = Vector3.zAxis },
	[Enum.NormalId.Left] = { normal = -Vector3.xAxis, u = Vector3.zAxis, v = Vector3.yAxis },
	[Enum.NormalId.Right] = { normal = Vector3.xAxis, u = -Vector3.zAxis, v = Vector3.yAxis },
	[Enum.NormalId.Front] = { normal = -Vector3.zAxis, u = Vector3.xAxis, v = Vector3.yAxis },
	[Enum.NormalId.Back] = { normal = Vector3.zAxis, u = -Vector3.xAxis, v = Vector3.yAxis },
}

local ROTATION_AXES = {
	Pitch = Vector3.xAxis,
	Yaw = Vector3.yAxis,
	Roll = Vector3.zAxis,
}

local ext = createCoreExtension({
	id = "rocket-arcs",
	title = "Arcs",
	description = "Create smooth arcs from the selected parts.",
	icon = assets.extensions.rocket,
	contributors = {
		{ type = "user", id = UserIds.syylvi },
		{ type = "user", id = UserIds.znotfireman },
	},
})

local function getNextArcCFrame(
	angle: number,
	rotationType: string,
	face: Enum.NormalId,
	transform: CFrame,
	size: Vector3
): CFrame
	local axis = ROTATION_AXES[rotationType]
	local faceAxes = FACE_AXES[face]

	local sign = math.sign(angle)
	local offset = CFrame.new(faceAxes.normal.X * size.X, faceAxes.normal.Y * size.Y, faceAxes.normal.Z * size.Z)
	local pivot = (faceAxes.u * sign + faceAxes.v) * (size / 2)

	local pivotCF = CFrame.new(pivot)
	local angleCF = CFrame.fromAxisAngle(axis, angle)

	return transform * offset * pivotCF * angleCF * pivotCF:Inverse()
end

local function renderArcs(
	instances: { Instance },
	amount: number,
	angle: number,
	rotationType: string,
	face: Enum.NormalId
)
	local current = instances

	for _ = 1, amount do
		for index, instance in current do
			local isAPart = instance:IsA("BasePart")

			if not (isAPart or instance:IsA("Model")) then
				continue
			end

			local clone = instance:Clone()

			if isAPart then
				clone = clone :: BasePart
				clone.CFrame = getNextArcCFrame(angle, rotationType, face, (instance :: BasePart).CFrame, clone.Size)
			else
				clone = clone :: Model
				clone:PivotTo(
					getNextArcCFrame(angle, rotationType, face, (instance :: Model):GetPivot(), clone:GetExtentsSize())
				)
			end

			clone.Parent = instance.Parent
			current[index] = clone
		end
	end

	return current
end

ext:newCommand({
	id = "arc-part",
	title = "Arc Part",
	description = "Creates a smooth arc from the selected parts.",
}, function(r: Extension.CommandRuntime)
	local output = r:createCommandOutput()

	function output.renderWindow(window: Iris.Window)
		local windowPositionState, windowSizeState = window.state.position, window.state.size

		local mouse = r:getMouse()
		local windowPosition = windowPositionState:get()
		local windowSize = windowSizeState:get()
		local mouseIsInWindow = mouse.X > windowPosition.X
			and mouse.X < windowPosition.X + windowSize.X
			and mouse.Y > windowPosition.Y
			and mouse.Y < windowPosition.Y + windowSize.Y
		local mouseDown = UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
		local selectedFaceState = Iris.State(Enum.NormalId.Front)

		if not mouseIsInWindow and mouse.Target and mouse.TargetSurface then
			Gizmos.drawSurface(mouse.TargetSurface, mouse.Target.CFrame, mouse.Target.Size)

			if mouseDown then
				selectedFaceState:set(mouse.TargetSurface)
			end
		end

		local selectedFace = selectedFaceState:get()
		Iris.Text({ `Face: {selectedFace}` })

		local rotationTypeState = Iris.State("Pitch")
		local rotationType = rotationTypeState:get()
		local secondRotationType = if selectedFace == Enum.NormalId.Top or selectedFace == Enum.NormalId.Bottom
			then "Roll"
			else "Yaw"

		if rotationType ~= "Pitch" and rotationType ~= secondRotationType then
			rotationType = secondRotationType
			rotationTypeState:set(secondRotationType)
		end

		Iris.SameLine()
		Iris.RadioButton({ "Pitch", "Pitch" }, { index = rotationTypeState })
		Iris.RadioButton({ secondRotationType, secondRotationType }, { index = rotationTypeState })
		Iris.End()

		local angleState = Iris.State(0)
		local angleDegrees = angleState:get()
		local angleRadians = math.rad(angleDegrees)
		Iris.SliderNum({ "Angle", 1, -180, 180 }, { number = angleState })

		local selections = r:useSelection()
		for _, instance in selections do
			if instance:IsA("BasePart") then
				local size = instance.Size
				Gizmos.drawBoundingBox(
					getNextArcCFrame(angleRadians, rotationType, selectedFace, instance.CFrame, size),
					size
				)
			elseif instance:IsA("Model") then
				local size = instance:GetExtentsSize()
				Gizmos.drawBoundingBox(
					getNextArcCFrame(angleRadians, rotationType, selectedFace, instance:GetPivot(), size),
					size
				)
			end
		end

		local amountState = Iris.State(1)
		Iris.InputNum({ "Amount", 1, 1 }, { number = amountState })

		local renderAllCount = if angleDegrees == 0 then 1 else 360 // math.abs(angleDegrees) - 1
		if renderAllCount < amountState:get() then
			amountState:set(renderAllCount)
		end

		Iris.SameLine()

		if Iris.Button({ `Render ({amountState:get()})` }).clicked() then
			local finish = r:recordChangeHistory({ name = "render-all", displayName = "Render Arc Parts" })
			r:setSelection(renderArcs(r:useSelection(), amountState:get(), angleRadians, rotationType, selectedFace))
			finish(Enum.FinishRecordingOperation.Commit)
		end

		if Iris.Button({ `Render All ({renderAllCount})` }).clicked() then
			local finish = r:recordChangeHistory({ name = "render-all", displayName = "Render All in Arc Parts" })
			r:setSelection(renderArcs(r:useSelection(), renderAllCount, angleRadians, rotationType, selectedFace))
			finish(Enum.FinishRecordingOperation.Commit)
		end

		Iris.End()
	end

	return output
end)

return ext
