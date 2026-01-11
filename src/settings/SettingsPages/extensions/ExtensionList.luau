local Command = require("@src/core/commands/Command")
local CommandListing = require("./CommandListing")
local Extension = require("@src/core/Extension")
local ExtensionListing = require("./ExtensionListing")
local Iris = require("@src/Iris")
local SettingsStore = require("@src/settings/SettingsStore")
local theme = require("@src/theme")

local function getRowThemePreset(row: number, selectable: Extension.Extension | Command.Command): Iris.PartialConfig
	if SettingsStore.extensions.selected() == selectable then
		return theme.presets.button.selected
	end

	return if row % 2 == 0 then theme.presets.button.unhighlighted else theme.presets.button.highlighted
end

local function ExtensionList()
	local extensionsCollapsed = table.clone(SettingsStore.extensions.extensionsCollapsed())
	local row = 1

	for i, extension in Extension._extensionsSortedByTitle() do
		-- local isCoreExtension = extension:isCore()
		-- if not (SettingsStore.extensions.showCore() and isCoreExtension) then
		-- 	continue
		-- elseif SettingsStore.extensions.showThirdParty() and not isCoreExtension then
		-- 	continue
		-- end

		row += 1

		local massCollapse = SettingsStore.extensions.massCollapse()
		if massCollapse ~= nil then
			extensionsCollapsed[extension] = massCollapse or nil
		end

		local layoutOrder = i * 100
		theme.push(getRowThemePreset(row, extension))
		ExtensionListing(extension, extensionsCollapsed, layoutOrder)
		theme.pop()

		if extensionsCollapsed[extension] then
			continue
		end

		Iris.PushId(extension.interface.id .. "/commands")
		Iris.Indent().Instance.LayoutOrder = layoutOrder + 1
		if next(extension._commands) == nil then
			Iris.Text({ "<i>This extension has no commands.</i>" })
		else
			for cmdIndex, command in extension._commands do
				row += 1
				Iris.PushId(command:getFullId())
				Iris.PushConfig(getRowThemePreset(row, command))
				CommandListing(command).Instance.LayoutOrder = cmdIndex
				theme.pop()
				Iris.PopId()
			end
		end
		Iris.End()
		Iris.PopId()
	end
	SettingsStore.extensions.extensionsCollapsed(extensionsCollapsed)
end

return ExtensionList
