local Iris = require("@src/Iris")

local function InstantInputText(
	props: { Label: string?, Hint: string?, CaptureFocus: boolean?, Width: UDim? },
	initialState: { text: any }?
): (string, typeof(Iris.InputText(nil :: any)), TextBox)
	local hasStyles = props.Width ~= nil
	if hasStyles then
		Iris.PushConfig({ ContentWidth = props.Width })
	end

	local input = Iris.InputText({
		props.Label or "",
		props.Hint or "",
	}, initialState :: any)

	if hasStyles then
		Iris.PopConfig()
	end

	local inputInstance = input.Instance:FindFirstChildWhichIsA("TextBox") :: TextBox

	if props.CaptureFocus then
		inputInstance:CaptureFocus()
	end

	return inputInstance.Text, input, inputInstance
end

return InstantInputText
