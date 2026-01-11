local Boba = require("@include/boba")

local Error = Boba.Struct {
	raw = Boba.String.inner,
	message = Boba.String.inner,
	trace = Boba.String.inner,
}

export type Error = typeof(Error.inner)

local function parseError(err: string): Error
	return {
		raw = err,
		message = err:gsub("^.+:%d+:%s*", ""),
		trace = debug.traceback(nil, 2),
	}
end

return table.freeze({
	Error = Error,
	parseError = parseError,
})
