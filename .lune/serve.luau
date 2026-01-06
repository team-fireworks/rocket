local DateTime = require("@lune/datetime")
local process = require("@lune/process")
local richterm = require("@lib/richterm")
local watch = require("@lib/watch")

local function clearConsole()
	print(string.rep("\n", 80))
end

watch({ "src", "include" }, function()
	local timestamp = DateTime.now():formatLocalTime("%H:%M:%S")
	local lastUpdatedAt = `Last updated at {timestamp}`

	clearConsole()
	print(richterm.bold(richterm.cyan "Rebuilding..."))
	print(lastUpdatedAt)
	print()

	local result = process.exec("lune", { "run", "build", "plugin" })

	clearConsole()
	if result.ok then
		print(richterm.bold(richterm.green "Build OK"))
	else
		print(result.stderr)
		print()
		print(richterm.bold(richterm.red "Build Failed"))
	end
	print(lastUpdatedAt)
	print()
end)
