local types = require("../types")

local cursor = {} :: types.Reposition
cursor.name = "Cursor"
cursor.describedBy = "dragging your cursor"

function cursor.updateDirection(_, now)
	return now.mouseTransform.LookVector
end

return cursor
