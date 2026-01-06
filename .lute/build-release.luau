local io = require("@std/io")
local process = require("@lute/process")

process.exit(process.run({
	"lute",
	"run",
	"build",
	"model",
	"--mark-attribution",
	"--mark-language-mode",
	"strict",
	"--mark-optimization-level",
	"2",
}, { stdio = "inherit" }).exitcode)
