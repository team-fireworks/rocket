local Charm = require("@pkgs/Charm")
local pluginTrove = require("@src/pluginTrove")

local function set<K, V>(atom: Charm.Atom<{ [K]: V }>, key: K, value: V)
	local new = table.clone(atom())
	new[key] = value
	atom(new)
end

local function push<T>(atom: Charm.Atom<{ T }>, value: T)
	local new = table.clone(atom())
	table.insert(new, value)
	atom(new)
end

local function wrapSetDefaults(atoms: { [string]: Charm.Atom<any> })
	local atomMap = atoms
	local originalValues: { [string]: Charm.Atom<any> } = {}

	for key, atom in atomMap do
		originalValues[key] = atom()
	end

	pluginTrove:Add(function()
		table.clear(originalValues)
		atomMap = nil
	end)

	return function()
		Charm.batch(function(atomMapNow: typeof(atomMap), originalValuesNow: typeof(originalValues))
			for key, value in originalValuesNow do
				atomMapNow[key](value)
			end
		end, atomMap, originalValues)
	end
end

return table.freeze({
	set = set,
	push = push,
	wrapSetDefaults = wrapSetDefaults,
})
