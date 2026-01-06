local DateTime = require("@lune/datetime")
local process = require("@lune/process")
local richterm = require("@lib/richterm")
local watch = require("@lib/watch")

watch({ "src", "include", "roblox_packages" }, function()
	local result = process.exec("lune", { "run", "build", "plugin" })

	print(string.rep("\n", 80))
	if result.ok then
		print(richterm.bold(richterm.green "Build OK"))
	else
		print(result.stderr)
		print()
		print(richterm.bold(richterm.red "Build Failed"))
	end

	print(richterm.dim(`Last updated at {DateTime.now():formatLocalTime("%H:%M:%S")}`))
	print()
end)
