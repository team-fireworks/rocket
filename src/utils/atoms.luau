local Charm = require("@pkgs/Charm")

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

return table.freeze({
	set = set,
	push = push,
})
