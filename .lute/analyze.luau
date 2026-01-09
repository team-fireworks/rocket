local Summon = require("./lib/Summon")
local config = require("@lib/config")()
local fs = require("@std/fs")
local net = require("@lute/net")
local process = require("@lute/process")

local ROBLOX_TYPEDEFS_FILENAME = "roblox.d.luau"

do
	fs.writestringtofile(
		ROBLOX_TYPEDEFS_FILENAME,
		net.request("https://luau-lsp.pages.dev/globalTypes.PluginSecurity.d.luau", { method = "GET" }).body
	)

	Summon.new("rojo", "sourcemap", "--output", config.sourcemap.filename, config.sourcemap.project):assert()
	process.exit(Summon.codeFromMany(
		Summon.new(
			"luau-lsp",
			"analyze",
			`--sourcemap={config.sourcemap.filename}`,
			'--ignore="**/include/**"',
			'--ignore="**/roblox_packages/**"',
			-- FIXME: luau-lsp is analyzing other WTH projects for some reason??
			"--ignore=../../../../../..",
			"--base-luaurc=.luaurc",
			`--definitions=roblox.d.luau`,
			"--flag:LuauSolverV2=true",
			"src"
		),
		Summon.new("selene", "src"),
		Summon.new("stylua", "--check", "src")
	))
end
