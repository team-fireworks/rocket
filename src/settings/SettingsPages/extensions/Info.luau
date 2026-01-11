local Command = require("@src/core/commands/Command")
local Iris = require("@src/Iris")
local SettingsStore = require("@src/settings/SettingsStore")
local ids = require("@src/utils/ids")
local types = require("@src/types")
local widgets = require("@src/widgets")

local function Info()
	local selected = SettingsStore.extensions.selected()
	if not selected then
		return
	end

	widgets.Padding({ right = UDim.new(0, Iris._config.ScrollbarSize * 2 + Iris._config.FramePadding.X) })

	local asCmd = selected :: Command.Command
	local isCommand = Command.is(asCmd)

	widgets.Spacer(8)
	Iris.SameLine({ 8, Enum.VerticalAlignment.Top })
	Iris.Image({ (selected :: any):getIcon(), UDim2.fromOffset(42, 42) })
	Iris.Group()
	widgets.Flex(Enum.UIFlexMode.Fill)
	Iris.Text({
		`<b>{selected.interface.title}</b><br/>{selected.interface.description}`,
		[Iris.Args.Text.Wrapped] = true,
	})
	Iris.End()
	Iris.End()

	Iris.SeparatorText({ "Preferences" })
	Iris.Checkbox({ "Enabled" })
	if isCommand then
		Iris.Checkbox({ "Run on Startup" })
	end

	Iris.SeparatorText({ "Contributors" })
	Iris.SameLine()
	for _, author: types.Author in (selected :: any):getcontributors() do
		local authorImage, authorName: string = "rbxassetid://-1", "Unknown"
		if typeof(author) == "string" then
			authorName = `{author} (Custom)`
		else
			author = author :: types.AuthorUser | types.AuthorCustom
			if author.type == "user" then
				authorImage = ids.getUserThumbnail(author.id, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
				authorName = `{ids.getUsername(author.id)} (User, ID: {author.id})`
			elseif author.type == "custom" then
				authorImage = author.image
				authorName = `{author.name} (Custom)`
			end
		end

		if Iris.Image({ authorImage, UDim2.fromOffset(32, 32) }).hovered() then
			Iris.Tooltip({ authorName })
		end
	end
	Iris.End()

	Iris.SeparatorText({ "Debug" })
	widgets.Subtext({ `ID: {selected.interface.id}` })
	if isCommand then
		widgets.Subtext({ `Full ID: {asCmd:getFullId()}` })
	end
end

return Info
