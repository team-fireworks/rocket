local config = require("@lib/config")
local fs = require("@std/fs")
local path = require("@std/path")
local process = require("@lute/process")

local function removeSafe<Args...>(remover: (string, Args...) -> (), filepath: string, ...: Args...)
	if fs.exists(filepath) then
		remover(filepath, ...)
	end
end

do
	local cwd = process.cwd()
	removeSafe(fs.removedirectory, path.join(cwd, config.build.output), { recursive = true })
	removeSafe(fs.remove, path.join(cwd, config.sourcemap.filename))
end
