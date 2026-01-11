local types = require("./types")

local sources: { types.Source } = {
	require("@self/sun"),
	require("@self/moon"),
}

return sources
