local config = require("../rocket.config")
local fs = require("@lute/fs")
local path = require("@std/path")
local process = require("@lute/process")
local richterm = require("@batteries/richterm")
local task = require("@lute/task")

local commandArgs = { "lute", "build", "plugin" }
table.move({ ... }, 2, select("#", ...), #commandArgs + 1, commandArgs)

local cwd = process.cwd()

local watchers: { [string]: fs.WatchHandle } = {}
local knownEntries, numFiles, numDirs = {} :: { [string]: true }, 0, 0
local needsRebuild, isRebuilding = false, false
local lastRebuiltAt = os.time()
local watchRocket

local function clearOutput()
	print((string.rep("\n", 120)))
end

local function printStatus(color: richterm.Formatter, status: string)
	local out = ` ⋅ Last rebuilt at {os.date("%H:%M:%S", lastRebuiltAt)}`
	out ..= ` ⋅ Watching {numFiles} files and {numDirs} directories`
	out = richterm.bold(color("→ " .. status)) .. richterm.gray(out)
	print(out)
	print()
end

local function setRebuildNeeded()
	needsRebuild = true
end

local function rebuild()
	if isRebuilding then
		return
	end

	isRebuilding = true
	needsRebuild = false
	lastRebuiltAt = os.time()

	clearOutput()
	printStatus(richterm.cyan, "Rebuilding...")

	local result = process.run(commandArgs)
	clearOutput()
	print((string.gsub(result.stdout .. result.stderr, "\\n$", "")))
	if result.ok then
		printStatus(richterm.green, "Build success!")
	else
		printStatus(richterm.red, "Build failed!")
	end
	watchRocket()

	isRebuilding = false
end

local function watchRecursive(dir: string)
	for _, entry in fs.listdir(dir) do
		local fullPath = path.format(path.join(dir, entry.name))

		-- TODO: removed files
		if not knownEntries[fullPath] then
			knownEntries[fullPath] = true
			setRebuildNeeded()
		end

		if entry.type ~= "dir" then
			numFiles += 1
			continue
		end
		if watchers[fullPath] == nil then
			watchers[fullPath] = fs.watch(fullPath, setRebuildNeeded)
			numDirs += 1
		end
		watchRecursive(fullPath)
	end
end

function watchRocket()
	watchRecursive(path.format(path.join(cwd, config.INPUT_DIR)))
	watchRecursive(path.format(path.join(cwd, config.EXTENSIONS_DIR)))
end

watchRocket()
while task.wait(0.1) do
	if needsRebuild then
		rebuild()
	end
end
