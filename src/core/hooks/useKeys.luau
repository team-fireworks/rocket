local UserInputService = game:GetService("UserInputService")

local KEY_CODES = Enum.KeyCode:GetEnumItems()

local function getKeysDown()
	local result = {}
	for _, keyCode in KEY_CODES do
		result[keyCode] = UserInputService:IsKeyDown(keyCode)
	end
	return result
end

local store = {}
store.KEY_CODES = KEY_CODES
store.now = getKeysDown()
store.previous = getKeysDown()

local function isDown(keyCode: Enum.KeyCode)
	return store.now[keyCode]
end

local function isJustPressed(keyCode: Enum.KeyCode)
	return store.now[keyCode] and not store.previous[keyCode]
end

local function isJustReleased(keyCode: Enum.KeyCode)
	return store.previous[keyCode] and not store.now[keyCode]
end

local function andConsumePress(keyCode: Enum.KeyCode)
	local pressed = isJustPressed(keyCode)
	if pressed then
		store.previous[keyCode] = true
		return true
	end
	return pressed
end

return table.freeze({
	store = store,
	getKeysDown = getKeysDown,
	isDown = isDown,
	isJustPressed = isJustPressed,
	isJustReleased = isJustReleased,
	andConsumePress = andConsumePress,
})
