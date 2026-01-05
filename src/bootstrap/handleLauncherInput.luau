local LauncherStore = require("@src/launcher/LauncherStore")
local runCommand = require("@src/core/runCommand")

local function handleLauncherInput(input: InputObject)
	local keycode = input.KeyCode

	if keycode == Enum.KeyCode.Up then
		LauncherStore.selectedIndex(math.max(LauncherStore.selectedIndex() - 1, 1))
	elseif keycode == Enum.KeyCode.Down then
		LauncherStore.selectedIndex(math.min(LauncherStore.selectedIndex() + 1, #LauncherStore.searchResults()))
	elseif keycode == Enum.KeyCode.Return then
		local command = LauncherStore.searchResults()[LauncherStore.selectedIndex()]
		if command then
			LauncherStore.isVisible(false)
			task.defer(runCommand, command)
		end
	elseif keycode == Enum.KeyCode.Escape then
		LauncherStore.isVisible(false)
	end
end

return handleLauncherInput
