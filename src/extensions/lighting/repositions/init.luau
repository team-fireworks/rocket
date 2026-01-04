local types = require("./types")

return table.freeze({
	require("@self/CursorReposition"),
	require("@self/FaceReposition"),
	require("@self/LineReposition"),
	require("@self/ReflectionReposition"),
	require("@self/ShadowReposition"),
} :: { types.Reposition })
