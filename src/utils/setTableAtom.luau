local Charm = require("@pkgs/Charm")

local function setTableAtom<K, V>(atom: Charm.Atom<{ [K]: V }>, key: K, value: V)
	local new = table.clone(atom())
	new[key] = value
	atom(new)
end

return setTableAtom
