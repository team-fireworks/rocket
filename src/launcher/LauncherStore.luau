local Charm = require("@pkgs/Charm")
local Command = require("@src/Command")
local CommandContext = require("@src/CommandContext")
local Extension = require("@src/Extension")
local Signal = require("@pkgs/Signal")
local fzy = require("@vendor/fzy")

local LauncherStore = {}
LauncherStore.isVisible = Charm.atom(false)
LauncherStore.isFocused = Charm.atom(false)
LauncherStore.selectedIndex = Charm.atom(1)
LauncherStore.search = Charm.atom("")

-- FIXME: atoms dont work here...?
LauncherStore.commandToRender = nil :: Command.Command?
LauncherStore.commandContext = nil :: CommandContext.CommandContext?

LauncherStore.searchResults = Charm.computed(function(): { Command.Command }
	local search = LauncherStore.search()
	local allCommands = Extension.allCommands()
	local commandToIndex = Extension.commandToIndex()

	local haystack = table.clone(allCommands)
	if search ~= "" then
		local commandResults = fzy.filter(search, Extension.commandTitles(), false)

		local extensions = Extension.sortedByTitle()
		local extensionResults = fzy.filter(search, Extension.extensionTitles(), false)

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

LauncherStore.runCommand = Signal.new() :: Signal.Signal<Command.Command>

return LauncherStore
