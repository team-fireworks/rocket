--[[
    arcs.luau

    Part of the `geometry` extension. Creates smooth arcs comprised of a selected part.

    Credit to the Archimedes plugin for the original concept and inspiration of implementation: https://devforum.roblox.com/t/introducing-archimedes-3-a-building-plugin/1610366

    Author: Sylvia
    - Roblox Profile: https://www.roblox.com/users/3814464357/profile
    - Github Profile: https://github.com/selectgender
    - Discord Username: selectgender
]]

-- TODO(znotfireman): more expressive authors

local UserInputService = game:GetService("UserInputService")

local Extension = require("@src/core/Extension")
local Gizmos = require("@src/core/Gizmos")
local Iris = require("@src/Iris")
local assets = require("@include/assets")
local createCoreExtension = require("@src/core/constructors/createCoreExtension")

-- TODO: this is performant but can this be simplified?
local function getNextArcCFrame(
	angle: number,
	rotationType: string,
	face: Enum.NormalId,
	cframe: CFrame,
	size: Vector3
): CFrame
	local offset: CFrame
	local pivot_offset: CFrame
	local angle_cframe: CFrame

	if face == Enum.NormalId.Top then
		offset = CFrame.new(0, size.Y, 0)

		if rotationType == "Pitch" then
			pivot_offset = CFrame.new(0, -size.Y / 2, math.sign(angle) * -size.Z / 2)
			angle_cframe = CFrame.Angles(angle, 0, 0)
		elseif rotationType == "Roll" then
			pivot_offset = CFrame.new(math.sign(angle) * size.X / 2, -size.Y / 2, 0)
			angle_cframe = CFrame.Angles(0, 0, angle)
		end
	elseif face == Enum.NormalId.Bottom then
		offset = CFrame.new(0, -size.Y, 0)

		if rotationType == "Pitch" then
			pivot_offset = CFrame.new(0, size.Y / 2, math.sign(angle) * size.Z / 2)
			angle_cframe = CFrame.Angles(angle, 0, 0)
		elseif rotationType == "Roll" then
			pivot_offset = CFrame.new(math.sign(angle) * -size.X / 2, size.Y / 2, 0)
			angle_cframe = CFrame.Angles(0, 0, angle)
		end
	elseif face == Enum.NormalId.Left then
		offset = CFrame.new(-size.X, 0, 0)

		if rotationType == "Pitch" then
			pivot_offset = CFrame.new(size.X / 2, math.sign(angle) * size.Y / 2, 0)
			angle_cframe = CFrame.Angles(0, 0, angle)
		elseif rotationType == "Yaw" then
			pivot_offset = CFrame.new(size.X / 2, 0, math.sign(angle) * -size.Z / 2)
			angle_cframe = CFrame.Angles(0, angle, 0)
		end
	elseif face == Enum.NormalId.Right then
		offset = CFrame.new(size.X, 0, 0)

		if rotationType == "Pitch" then
			pivot_offset = CFrame.new(-size.X / 2, math.sign(angle) * -size.Y / 2, 0)
			angle_cframe = CFrame.Angles(0, 0, angle)
		elseif rotationType == "Yaw" then
			pivot_offset = CFrame.new(-size.X / 2, 0, math.sign(angle) * size.Z / 2)
			angle_cframe = CFrame.Angles(0, angle, 0)
		end
	elseif face == Enum.NormalId.Front then
		offset = CFrame.new(0, 0, -size.Z)

		if rotationType == "Pitch" then
			pivot_offset = CFrame.new(0, math.sign(angle) * -size.Y / 2, size.Z / 2)
			angle_cframe = CFrame.Angles(angle, 0, 0)
		elseif rotationType == "Yaw" then
			pivot_offset = CFrame.new(math.sign(angle) * size.X / 2, 0, size.Z / 2)
			angle_cframe = CFrame.Angles(0, angle, 0)
		end
	elseif face == Enum.NormalId.Back then
		offset = CFrame.new(0, 0, size.Z)

		if rotationType == "Pitch" then
			pivot_offset = CFrame.new(0, math.sign(angle) * size.Y / 2, -size.Z / 2)
			angle_cframe = CFrame.Angles(angle, 0, 0)
		elseif rotationType == "Yaw" then
			pivot_offset = CFrame.new(math.sign(angle) * -size.X / 2, 0, -size.Z / 2)
			angle_cframe = CFrame.Angles(0, angle, 0)
		end
	end

	return cframe * offset * pivot_offset * angle_cframe * pivot_offset:Inverse()
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

local ext = createCoreExtension({
	id = "rocket-arcs",
	title = "Arcs",
	description = "Create smooth arcs from the selected parts.",
	icon = assets.extensions.rocket,
	authors = { "Sylvia" },
})

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

		local selections = r:getSelection()
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
			r:setSelection(renderArcs(r:getSelection(), amountState:get(), angleRadians, rotationType, selectedFace))
			finish()
		end

		if Iris.Button({ `Render All ({renderAllCount})` }).clicked() then
			local finish = r:recordChangeHistory({ name = "render-all", displayName = "Render All in Arc Parts" })
			r:setSelection(renderArcs(r:getSelection(), renderAllCount, angleRadians, rotationType, selectedFace))
			finish()
		end

		Iris.End()
	end

	return output
end)
