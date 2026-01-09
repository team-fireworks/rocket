local types = require("./types")

local repositions: { types.Reposition } = {
	require("@self/cursor"),
	require("@self/face"),
	require("@self/line"),
	require("@self/shadow"),
}

return repositions
