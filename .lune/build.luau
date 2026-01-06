local fs = require("@lune/fs")
local process = require("@lune/process")

type BuildOutput = "model" | "plugin"
local output = process.args[1] :: BuildOutput
if output ~= "model" and output ~= "plugin" then
	print(`usage: lune run build [model|plugin]`)
	process.exit(1)
end

local INPUT_DIR = "src"
local OUTPUT_DIR = "out"
local EXEC_OPTIONS: process.ExecOptions = { stdio = "forward" }

if fs.isDir(process.cwd .. OUTPUT_DIR) then
	print("Cleaning output directory")
	fs.removeDir(process.cwd .. OUTPUT_DIR)
end

fs.copy(INPUT_DIR, OUTPUT_DIR)

local sourcemap = process.exec("rojo", { "sourcemap", "--output", "sourcemap.json" }, EXEC_OPTIONS)
local darklua = process.exec("darklua", { "process", INPUT_DIR, OUTPUT_DIR }, EXEC_OPTIONS)
local build = process.exec("rojo", {
	"build",
	if output == "model" then "--output" else "--plugin",
	"Rocket.rbxm",
	"build.project.json",
}, EXEC_OPTIONS)

if sourcemap.ok and darklua.ok and build.ok then
	process.exit(0)
end

process.exit(1)
