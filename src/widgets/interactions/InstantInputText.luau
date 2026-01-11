local Iris = require("@src/Iris")

export type InstantInputTextProps = {
	label: string?,
	hint: string?,
	captureFocus: boolean?,
	width: UDim?,
}

local function InstantInputText(
	props: InstantInputTextProps,
	initialState: { text: any }?
): (string, typeof(Iris.InputText(nil :: any)), TextBox)
	local hasStyles = props.width ~= nil
	if hasStyles then
		Iris.PushConfig({ ContentWidth = props.width })
	end

	local input = Iris.InputText({
		props.label or "",
		props.hint or "",
	}, initialState :: any)

	if hasStyles then
		Iris.PopConfig()
	end

	local inputInstance = input.Instance:FindFirstChildWhichIsA("TextBox") :: TextBox

	if props.captureFocus then
		inputInstance:CaptureFocus()
	end

	return inputInstance.Text, input, inputInstance
end

return InstantInputText
