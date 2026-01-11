local Summon = require("@lib/Summon")
local cli = require("@batteries/cli")
local config = require("@lib/config")()
local fs = require("@std/fs")
local path = require("@std/path")
local process = require("@lute/process")
local tableext = require("@std/tableext")

local args = cli.parser()
args:add("output", "positional", { help = "Output as a 'plugin' or 'model'", required = true })
args:add("mark-language-mode", "option", { help = "Marks 'strict', 'nonstrict', or 'nocheck' language mode" })
args:add("mark-optimization-level", "option", { help = "Marks '0', '1', or '2' optimization level" })
args:add("mark-attribution", "flag", { help = "Include Rocket's attribution comment" })

local cwd = process.cwd()

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
		table.insert(headerComment, `-- {config.copyright}:`)
		table.insert(headerComment, `-- https://github.com/team-fireworks/rocket`)
		table.insert(headerComment, `--`)
		table.insert(headerComment, `-- This Source Code Form is subject to the terms of the Mozilla Public License,`)
		table.insert(headerComment, `-- v. 2.0. If a copy of the MPL was not distributed with this file, You can`)
		table.insert(headerComment, `-- obtain one at http://mozilla.org/MPL/2.0/.`)
		table.insert(headerComment, "\n")
	end

	return headerComment
end

local function copy(from: string, to: string)
	local walkInput = fs.walk(from, { recursive = true })
	local entry = walkInput()
	local copied = {}

	while entry do
		local relative = string.sub(path.format(entry), #from + 2)
		local destination = path.join(to, relative)
		if fs.type(entry) == "file" then
			fs.createdirectory(path.dirname(destination), { makeparents = true })
			fs.copy(entry, destination)
			copied[destination] = true
		end
		entry = walkInput()
	end

	return copied
end

local function prepareTooling()
	local output = args:get("output")
	local modelPath = path.join(cwd, config.build.model)

	if output == "model" and fs.exists(modelPath) then
		fs.remove(modelPath)
	end

	local sourcemapPath = path.join(cwd, config.sourcemap.filename)
	if fs.exists(sourcemapPath) then
		fs.remove(sourcemapPath)
	end
end

local function prepareOutput()
	local output = path.join(cwd, config.build.output)
	if fs.exists(path.join(cwd, config.build.output)) then
		fs.removedirectory(output, { recursive = true })
	end

	return tableext.combine(
		copy(path.format(path.join(cwd, config.build.src)), path.format(output)),
		copy(
			path.format(path.join(cwd, config.build.extensions)),
			path.format(path.join(cwd, config.build.output, config.build.extensions))
		)
	)
end

local function prepareBuild()
	prepareTooling()
	return prepareOutput()
end

local function parseArgs(...: any)
	local commandArgs = { ... }
	table.remove(commandArgs, 1)
	if #commandArgs == 0 or commandArgs[1] == "help" then
		args:help()
		return
	end

	args:parse(commandArgs)
end

parseArgs(...)
do
	local buildFiles = prepareBuild()

	Summon.new("rojo", "sourcemap", "--output", config.sourcemap.filename, config.sourcemap.project):assert()
	Summon.new("darklua", "process", config.build.src, config.build.output):assert()
	Summon.new(
		"darklua",
		"process",
		config.build.extensions,
		path.format(path.join(config.build.output, config.build.extensions))
	):assert()

	local headerComment = createHeaderComment()
	if next(headerComment) ~= nil then
		local formattedHeaderComment = table.concat(headerComment, "\n")
		for out in buildFiles do
			fs.writestringtofile(out, formattedHeaderComment .. fs.readfiletostring(out))
		end
	end

	Summon.new(
		"rojo",
		"build",
		if args:get("output") == "plugin" then "--plugin" else "--output",
		config.build.model,
		config.build.project
	):assert()

	process.exit(0)
end
