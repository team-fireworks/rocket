local fs = require("@std/fs")
local net = require("@lute/net")
local process = require("@lute/process")

local RUN_OPTIONS: process.ProcessRunOptions = { stdio = "inherit" }

process.run({ "rojo", "sourcemap", "--output", "sourcemap.json" }, RUN_OPTIONS)

fs.writestringtofile(
	"roblox.d.luau",
	net.request("https://luau-lsp.pages.dev/globalTypes.PluginSecurity.d.luau", { method = "GET" }).body
)

local luau = process.run({
	"luau-lsp",
	"analyze",
	"--sourcemap=sourcemap.json",
	"--ignore=**/include/**",
	"--ignore=**/roblox_packages/**",
	-- FIXME: luau-lsp is analyzing other WTH projects for some reason??
	"--ignore=../../../../../..",
	"--base-luaurc=.luaurc",
	"--definitions=roblox.d.luau",
	"--flag:LuauSolverV2=true",
	"src",
}, RUN_OPTIONS)

fs.remove("roblox.d.luau")

local selene = process.run({
	"selene",
	"src",
}, RUN_OPTIONS)

local stylua = process.run({
	"stylua",
	"--check",
	"src",
}, RUN_OPTIONS)

if luau.ok and selene.ok and stylua.ok then
	process.exit(0)
	return
end

process.exit(1)
