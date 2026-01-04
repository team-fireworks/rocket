local Iris = require("@pkgs/Iris")

local function Icon(image: string, size: UDim2)
	local icon = Iris.Image({
		image,
		size,
	})

	return icon
end

return Icon
