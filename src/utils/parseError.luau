local types = require("@src/types")

local function parseError(err: string): types.Error
	return {
		raw = err,
		message = err:gsub("^.+:%d+:%s*", ""),
		trace = debug.traceback(nil, 2),
	}
end

return parseError
