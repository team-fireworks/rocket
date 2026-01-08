local fs = require("@std/fs")
local path = require("@std/path")
local process = require("@lute/process")

local PESDE_ARTIFACTS: { [string]: (string) -> () } = {
	luau_packages = fs.removedirectory,
	lune_packages = fs.removedirectory,
	roblox_packages = fs.removedirectory,

	["pesde.lock"] = fs.remove,
}

do
	local cwd = process.cwd()
	for artifact, remover in PESDE_ARTIFACTS do
		local artifactPath = path.join(cwd, artifact)
		if fs.exists(artifactPath) then
			remover(artifactPath, { recursive = true })
		end
	end
end
