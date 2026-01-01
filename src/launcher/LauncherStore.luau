local Charm = require("@pkgs/Charm")
local Command = require("@src/Command")
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
LauncherStore.commandContext = nil :: Command.CommandContext?

LauncherStore.searchResults = Charm.computed(function(): { Command.Command }
	local search = LauncherStore.search()
	local allCommands = Extension.allCommands()
	local haystack = table.clone(allCommands)
	if search ~= "" then
		local results = fzy.filter(search, Extension.commandTitles(), false)
		table.sort(results, function(lhs: { number }, rhs: { number })
			return lhs[3] < rhs[3]
		end)
		haystack = table.create(#results) :: { Command.Command }
		for _, result in results do
			table.insert(haystack, allCommands[result[1]])
		end
	end
	return haystack
end)

LauncherStore.runCommand = Signal.new() :: Signal.Signal<Command.Command>

return LauncherStore
