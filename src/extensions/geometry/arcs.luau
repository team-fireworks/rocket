--[[
    arcs.luau

    Part of the `geometry` extension. Creates smooth arcs comprised of a selected part.

    Credit to the Archimedes plugin for the original concept and inspiration of implementation: https://devforum.roblox.com/t/introducing-archimedes-3-a-building-plugin/1610366

    Author: Sylvia
    - Roblox Profile: https://www.roblox.com/users/3814464357/profile
    - Github Profile: https://github.com/selectgender
    - Discord Username: selectgender
]]

local UserInputService = game:GetService("UserInputService")

local Extension = require("@src/Extension")
local Gizmos = require("@src/Gizmos")
local ext = require(".")

local function BoundingBoxGizmo(cframe: CFrame, size: Vector3)
	local topFrontRightCorner = cframe * Vector3.new(size.X / 2, size.Y / 2, -size.Z / 2)
	local topFrontLeftCorner = cframe * Vector3.new(-size.X / 2, size.Y / 2, -size.Z / 2)
	local topBackLeftCorner = cframe * Vector3.new(-size.X / 2, size.Y / 2, size.Z / 2)
	local topBackRightCorner = cframe * Vector3.new(size.X / 2, size.Y / 2, size.Z / 2)
	local bottomFrontRightCorner = cframe * Vector3.new(size.X / 2, -size.Y / 2, -size.Z / 2)
	local bottomFrontLeftCorner = cframe * Vector3.new(-size.X / 2, -size.Y / 2, -size.Z / 2)
	local bottomBackLeftCorner = cframe * Vector3.new(-size.X / 2, -size.Y / 2, size.Z / 2)
	local bottomBackRightCorner = cframe * Vector3.new(size.X / 2, -size.Y / 2, size.Z / 2)

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

local function SurfaceSelectionGizmo(part: BasePart, surface: Enum.NormalId)
	local cframe = part.CFrame
	local size = part.Size

	local topFrontRightCorner = cframe * Vector3.new(size.X / 2, size.Y / 2, -size.Z / 2)
	local topFrontLeftCorner = cframe * Vector3.new(-size.X / 2, size.Y / 2, -size.Z / 2)
	local topBackLeftCorner = cframe * Vector3.new(-size.X / 2, size.Y / 2, size.Z / 2)
	local topBackRightCorner = cframe * Vector3.new(size.X / 2, size.Y / 2, size.Z / 2)
	local bottomFrontRightCorner = cframe * Vector3.new(size.X / 2, -size.Y / 2, -size.Z / 2)
	local bottomFrontLeftCorner = cframe * Vector3.new(-size.X / 2, -size.Y / 2, -size.Z / 2)
	local bottomBackLeftCorner = cframe * Vector3.new(-size.X / 2, -size.Y / 2, size.Z / 2)
	local bottomBackRightCorner = cframe * Vector3.new(size.X / 2, -size.Y / 2, size.Z / 2)

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

ext:newCommand({
	id = "arc-part",
	title = "Arc Part",
	description = "Creates a smooth arc of selected part.",

	run = function(ctx: Extension.CommandContext)
		ctx:recordChanges()
	end,

	renderInViewport = function(ctx: Extension.CommandContext)
		local Iris = ctx.iris
		local mouse = ctx.mouse
		local windowPositionState = Iris.State(UserInputService:GetMouseLocation())
		local windowSizeState = Iris.State(Vector2.new(275, 250))
		local window =
			Iris.Window({ "Arc Settings" }, { position = windowPositionState, size = windowSizeState } :: any)

		if window.closed() then
			ctx:cleanup()
			-- @TEMPORARY: for some reason the window would not reopen after it was closed for a first time.
			window.state.isOpened:set(true)
			Iris.End()

			return
		end

		local windowPosition = windowPositionState:get()
		local windowSize = windowSizeState:get()
		local mouseIsInWindow = mouse.X > windowPosition.X
			and mouse.X < windowPosition.X + windowSize.X
			and mouse.Y > windowPosition.Y
			and mouse.Y < windowPosition.Y + windowSize.Y
		local mouseDown = UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
		local selectedPartState = Iris.State(mouse.Target)
		local selectedSurfaceState = Iris.State(mouse.TargetSurface)
		local target = mouse.Target

		if not mouseIsInWindow and target then
			SurfaceSelectionGizmo(target, mouse.TargetSurface)

			if mouseDown then
				selectedPartState:set(mouse.Target)
				selectedSurfaceState:set(mouse.TargetSurface)
			end
		end

		local selectedPart = selectedPartState:get()
		local selectedSurface = selectedSurfaceState:get()

		Iris.Text(`Part: {if selectedPart then selectedPart:GetFullName() else "none"}`)
		Iris.Text(`Face: {if selectedSurface then selectedSurface.Name else "none"}`)

		local rotationTypeState = Iris.State("Pitch")
		Iris.SameLine()
		Iris.RadioButton({ "Pitch", "Pitch" }, { index = rotationTypeState })
		Iris.RadioButton({ "Yaw", "Yaw" }, { index = rotationTypeState })
		Iris.End()

		local angleState = Iris.State(0)
		Iris.SliderNum({ "Angle", 1, -180, 180 }, { number = angleState })

		local previewCFrame: CFrame? = nil
		if selectedPart and selectedSurface then
			local angle = math.rad(angleState:get())
			local rotationType = rotationTypeState:get()
			local cframe = selectedPart.CFrame
			local size = selectedPart.Size

			-- CFrame.identity is a placeholder :D
			local offset = CFrame.identity
			local pivot_offset = CFrame.identity
			local angle_cframe = CFrame.identity

			if selectedSurface == Enum.NormalId.Top then
				offset = CFrame.new(0, size.Y, 0)

				if rotationType == "Pitch" then
					pivot_offset = CFrame.new(0, -size.Y / 2, math.sign(angle) * -size.Z / 2)
					angle_cframe = CFrame.Angles(angle, 0, 0)
				elseif rotationType == "Yaw" then -- the correct term here is "Roll"... but when have we ever cared about correctness.... smh.....
					pivot_offset = CFrame.new(math.sign(angle) * size.X / 2, -size.Y / 2, 0)
					angle_cframe = CFrame.Angles(0, 0, angle)
				end
			elseif selectedSurface == Enum.NormalId.Bottom then
				offset = CFrame.new(0, -size.Y, 0)

				if rotationType == "Pitch" then
					pivot_offset = CFrame.new(0, size.Y / 2, math.sign(angle) * size.Z / 2)
					angle_cframe = CFrame.Angles(angle, 0, 0)
				elseif rotationType == "Yaw" then
					pivot_offset = CFrame.new(math.sign(angle) * -size.X / 2, size.Y / 2, 0)
					angle_cframe = CFrame.Angles(0, 0, angle)
				end
			elseif selectedSurface == Enum.NormalId.Left then
				offset = CFrame.new(-size.X, 0, 0)

				if rotationType == "Pitch" then
					pivot_offset = CFrame.new(size.X / 2, math.sign(angle) * size.Y / 2, 0)
					angle_cframe = CFrame.Angles(0, 0, angle)
				elseif rotationType == "Yaw" then
					pivot_offset = CFrame.new(size.X / 2, 0, math.sign(angle) * -size.Z / 2)
					angle_cframe = CFrame.Angles(0, angle, 0)
				end
			elseif selectedSurface == Enum.NormalId.Right then
				offset = CFrame.new(size.X, 0, 0)

				if rotationType == "Pitch" then
					pivot_offset = CFrame.new(-size.X / 2, math.sign(angle) * -size.Y / 2, 0)
					angle_cframe = CFrame.Angles(0, 0, angle)
				elseif rotationType == "Yaw" then
					pivot_offset = CFrame.new(-size.X / 2, 0, math.sign(angle) * size.Z / 2)
					angle_cframe = CFrame.Angles(0, angle, 0)
				end
			elseif selectedSurface == Enum.NormalId.Front then
				offset = CFrame.new(0, 0, -size.Z)

				if rotationType == "Pitch" then
					pivot_offset = CFrame.new(0, math.sign(angle) * -size.Y / 2, size.Z / 2)
					angle_cframe = CFrame.Angles(angle, 0, 0)
				elseif rotationType == "Yaw" then
					pivot_offset = CFrame.new(math.sign(angle) * size.X / 2, 0, size.Z / 2)
					angle_cframe = CFrame.Angles(0, angle, 0)
				end
			elseif selectedSurface == Enum.NormalId.Back then
				offset = CFrame.new(0, 0, size.Z)

				if rotationType == "Pitch" then
					pivot_offset = CFrame.new(0, math.sign(angle) * size.Y / 2, -size.Z / 2)
					angle_cframe = CFrame.Angles(angle, 0, 0)
				elseif rotationType == "Yaw" then
					pivot_offset = CFrame.new(math.sign(angle) * -size.X / 2, 0, -size.Z / 2)
					angle_cframe = CFrame.Angles(0, angle, 0)
				end
			end

			previewCFrame = cframe * offset * pivot_offset * angle_cframe * pivot_offset:Inverse()
			BoundingBoxGizmo(previewCFrame, size)
		end

		local amountState = Iris.State(1)
		Iris.InputNum({ "Amount", 1, 1 }, { number = amountState })

		local renderAllCount = if angleState:get() == 0 then 1 else 360 // math.abs(angleState:get()) - 1
		if renderAllCount < amountState:get() then
			amountState:set(renderAllCount)
		end

		Iris.SameLine()

		if Iris.Button(`Render ({amountState:get()})`).clicked() and previewCFrame then
			local clone = selectedPart:Clone()
			clone.CFrame = previewCFrame
			clone.Parent = workspace

			selectedPartState:set(clone)
		end

		Iris.Button(`Render All ({renderAllCount})`)
		Iris.End()

		Iris.End()
	end,
})
