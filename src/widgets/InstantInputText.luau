local Iris = require("@src/Iris")

local function InstantInputText(
	props: { Label: string?, Placeholder: string?, CaptureFocus: boolean? },
	initialState: { text: any }?
): (string, typeof(Iris.InputText(nil :: any)))
	local input = Iris.InputText({ props.Label or "", props.Placeholder or "" }, initialState :: any)
	local inputInstance = input.Instance:FindFirstChildWhichIsA("TextBox") :: TextBox

	if props.CaptureFocus then
		inputInstance:CaptureFocus()
	end

	return inputInstance.Text, input
end

return InstantInputText
