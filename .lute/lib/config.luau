local fs = require("@std/fs")
local path = require("@std/path")
local process = require("@lute/process")
local toml = require("@batteries/toml")

export type Config = {
	version: string,
	copyright: string,

	flags: { [string]: unknown },

	sourcemap: {
		filename: string,
		project: string,
	},

	build: {
		src: string,
		extensions: string,

		output: string,
		model: string,
		project: string,
	},
}

local function config()
	local CONFIG_PATH = path.join(process.cwd(), "rocket.config.toml")
	if fs.exists(CONFIG_PATH) then
		local deserialized: Config = toml.deserialize(fs.readfiletostring(CONFIG_PATH)) :: any
		return deserialized
	end
	print("Missing `rocket.config.toml` configuration!")
	return process.exit(1)
end

return config
