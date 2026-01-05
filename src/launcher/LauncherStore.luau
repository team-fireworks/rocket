local Charm = require("@pkgs/Charm")
local Command = require("@src/core/Command")
local Extension = require("@src/core/Extension")
local fzy = require("@vendor/fzy")

local LauncherStore = {}
LauncherStore.isVisible = Charm.atom(false)
LauncherStore.isFocused = Charm.atom(false)
LauncherStore.selectedIndex = Charm.atom(1)
LauncherStore.search = Charm.atom("")

LauncherStore.searchResults = Charm.computed(function(): { Command.Command }
	local search = LauncherStore.search()
	local allCommands = Extension._allCommands()
	local commandToIndex = Extension._commandToIndex()

	local haystack = table.clone(allCommands)
	if search ~= "" then
		local commandResults = fzy.filter(search, Extension._commandTitles(), false)

		local extensions = Extension._extensionsSortedByTitle()
		local extensionResults = fzy.filter(search, Extension._extensionTitles(), false)

		local combined: { [number]: { number } } = {}
		for _, result in commandResults do
			-- command titles has priority over extension titles
			result[3] *= 1000
			combined[result[1]] = result
		end

		for _, result in extensionResults do
			for _, command in extensions[result[1]].commands do
				local commandIndex = commandToIndex[command]
				local commandResult = combined[commandIndex]
				if commandResult then
					commandResult[3] += result[3]
				else
					combined[commandIndex] = { commandToIndex[command], 0, result[3] }
				end
			end
		end

		table.sort(combined, function(lhs: { number }, rhs: { number })
			-- There are going to be gaps because some commands will be
			-- filtered.
			return if lhs and rhs then lhs[3] < rhs[3] else not not rhs
		end)

		haystack = table.create(#combined) :: { Command.Command }
		for _, result in combined do
			table.insert(haystack, allCommands[result[1]])
		end
	end

	return haystack
end)

return LauncherStore
