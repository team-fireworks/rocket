local Summon = require("@lib/Summon")
local fs = require("@std/fs")
local path = require("@std/path")
local process = require("@lute/process")
local system = require("@lute/system")

do
	local now = os.time()
	Summon.new("lute", "run", "build-release"):assert()

	if system.os == "Darwin" then
		local model = path.join(process.cwd(), "Rocket.rbxm")
		local timestamp = os.date("(%B %d, %Y at %I:%M:%S %p)", now)
		local filename = `Rocket Pre-Alpha {timestamp}.rbxm`
		local destination = path.join(process.homedir(), "Downloads", filename)

		fs.copy(model, destination)
		print("Exported to " .. path.format(destination))
		process.exit(0)
	else
		print("Unsupported operating system: " .. system.os)
		process.exit(1)
	end
end
