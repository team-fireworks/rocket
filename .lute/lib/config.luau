local Boba = require("@include/boba")
local fs = require("@std/fs")
local path = require("@std/path")
local process = require("@lute/process")
local toml = require("@batteries/toml")

local Config = Boba.Struct {
	version = Boba.String.inner,
	copyright = Boba.String.inner,

	flags = Boba.Map(Boba.String, Boba.Unknown).inner,

	sourcemap = Boba.Struct {
		filename = Boba.String.inner,
		project = Boba.String.inner,
	}.inner,

	build = Boba.Struct {
		src = Boba.String.inner,
		extensions = Boba.String.inner,

		output = Boba.String.inner,
		model = Boba.String.inner,
		project = Boba.String.inner,
	}.inner,
}:Nickname("Config")

export type Config = typeof(Config.inner)

local function config()
	local CONFIG_PATH = path.join(process.cwd(), "rocket.config.toml")
	if fs.exists(CONFIG_PATH) then
		return Config:assert(toml.deserialize(fs.readfiletostring(CONFIG_PATH)))
	end
	print("Missing `rocket.config.toml` configuration!")
	return process.exit(1)
end

return config
