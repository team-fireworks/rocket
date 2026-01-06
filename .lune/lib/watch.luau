local DateTime = require("@lune/datetime")
local fs = require("@lune/fs")
local task = require("@lune/task")

local CHECK_SOMETIMES = 10

local function readDirRecursive(dir: string): { string }
	local result = {}
	if fs.isDir(dir) then
		for _, child in fs.readDir(dir) do
			local childPath = `{dir}/{child}`
			if fs.isFile(childPath) then
				table.insert(result, childPath)
			elseif fs.isDir(childPath) then
				local childResult = readDirRecursive(childPath)
				table.move(childResult, 1, #childResult, #result + 1, result)
			end
		end
	end
	return result
end

local function bulkLastModifiedAt(paths: { string }): { DateTime.DateTime }
	local result = {}
	for i, file in paths do
		result[i] = fs.metadata(file).modifiedAt
	end
	return result
end

local function bulkReadDirRecursive(paths: { string })
	local result: { string } = {}
	for _, path in paths do
		local children = readDirRecursive(path)
		table.move(children, 1, #children, #result + 1, result)
	end
	return result
end

local function watch(paths: { string }, callback: () -> ())
	local nextIndex = 0

	local watchPaths = bulkReadDirRecursive(paths)
	local pathsLastModifiedAt = bulkLastModifiedAt(watchPaths)

	local function check(index: number): boolean
		local path = watchPaths[index]
		local nowLastModifiedAt: DateTime.DateTime = fs.metadata(path).modifiedAt
		local wasLastModifiedAt = pathsLastModifiedAt[index]

		if nowLastModifiedAt ~= wasLastModifiedAt then
			return true
		end

		return false
	end

	callback()

	while task.wait(0.1) do
		local update = false

		for _ = 1, CHECK_SOMETIMES do
			nextIndex %= #watchPaths
			nextIndex += 1

			update = update or check(nextIndex)
		end

		if update then
			callback()
			task.wait(1)
			watchPaths = bulkReadDirRecursive(paths)
			pathsLastModifiedAt = bulkLastModifiedAt(watchPaths)
		end
	end
end

return watch
