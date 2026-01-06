local cli = require("@batteries/cli")
local config = require("../rocket.config")
local fs = require("@std/fs")
local path = require("@std/path")
local process = require("@lute/process")

local RUN_OPTIONS: process.ProcessRunOptions = { stdio = "inherit" }

local args = cli.parser()
args:add("output", "positional", { help = "Output as a 'plugin' or 'model'", required = true })
args:add("mark-language-mode", "option", { help = "Marks 'strict', 'nonstrict', or 'nocheck' language mode" })
args:add("mark-optimization-level", "option", { help = "Marks '0', '1', or '2' optimization level" })
args:add("mark-attribution", "flag", { help = "Include Rocket's attribution comment" })

local function createHeaderComment()
	local headerComment = {}

	local languageMode = args:get("mark-language-mode")
	if languageMode then
		table.insert(headerComment, `--!{languageMode}`)
	end

	local optimizationLevel = args:get("mark-optimization-level")
	if optimizationLevel then
		table.insert(headerComment, `--!optimize {optimizationLevel}`)
	end

	if #headerComment > 0 then
		table.insert(headerComment, "")
	end

	if args:has("mark-attribution") then
		table.insert(headerComment, `-- Copyright (c) 2025–2026 The Rocket Authors`)
		table.insert(headerComment, `--`)
		table.insert(headerComment, `-- This Source Code Form is subject to the terms of the Mozilla Public License,`)
		table.insert(headerComment, `-- v. 2.0. If a copy of the MPL was not distributed with this file, You can`)
		table.insert(headerComment, `-- obtain one at http://mozilla.org/MPL/2.0/.`)
		table.insert(headerComment, "\n")
	end

	return headerComment
end

local commandArgs = { ... }
table.remove(commandArgs, 1)
if #commandArgs == 0 or commandArgs[1] == "help" then
	args:help()
	return
end

args:parse(commandArgs)

local cwd = process.cwd()

local model = "Rocket.rbxm"
local inputPath, outputPath = path.join(cwd, config.INPUT_DIR), path.join(cwd, config.OUTPUT_DIR)
local inputFormatted = path.format(inputPath)
local headerComment = createHeaderComment()
local shouldAddHeaderComment, headerCommentFormatted = #headerComment > 0, table.concat(headerComment, "\n")

if fs.exists(outputPath) then
	fs.removedirectory(outputPath, { recursive = true })
end

-- `fs.copy` doesn't work bro
local walkInput = fs.walk(inputPath, { recursive = true })
local entry = walkInput()
local outputPaths = {}
while entry do
	local relative = string.sub(path.format(entry), #inputFormatted + 2)
	local destination = path.join(outputPath, relative)
	if fs.type(entry) == "file" then
		fs.createdirectory(path.dirname(destination), { makeparents = true })
		fs.copy(entry, destination)
		outputPaths[destination] = true
		print(destination)
	end
	entry = walkInput()
end

local sourcemapPath = path.join(cwd, "sourcemap.json")
if fs.exists(sourcemapPath) then
	fs.remove(sourcemapPath)
end

local sourcemap = process.run({
	"rojo",
	"sourcemap",
	"--output",
	"sourcemap.json",
}, RUN_OPTIONS)

local darklua = process.run({
	"darklua",
	"process",
	config.INPUT_DIR,
	config.OUTPUT_DIR,
}, RUN_OPTIONS)

if shouldAddHeaderComment then
	for out in outputPaths do
		fs.writestringtofile(out, headerCommentFormatted .. fs.readfiletostring(out))
	end
end

local output = args:get("output")
local modelPath = path.join(cwd, model)
if output == "model" and fs.exists(modelPath) then
	fs.remove(modelPath)
end

local build = process.run({
	"rojo",
	"build",
	if args:get("output") == "plugin" then "--plugin" else "--output",
	"Rocket.rbxm",
	"build.project.json",
}, RUN_OPTIONS)

if sourcemap.ok and darklua.ok and build.ok then
	process.exit(0)
	return
end

process.exit(1)
