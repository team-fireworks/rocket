local Iris = require("@src/Iris")
local assets = require("@include/assets")
local types = require("../types")
local widgets = require("@src/widgets")

local manifest = require(script:FindFirstAncestor("Rocket").include:WaitForChild("pesde.toml"))

local about = {} :: types.SettingsPage
about.id = "about"
about.title = "About"
about.tabIcon = assets.icons.rocket
about.extensionIcon = assets.extensions.settings.about

function about.render()
	widgets.Frame({
		size = UDim2.fromScale(1, 0),
		automaticSize = Enum.AutomaticSize.Y,
		horizontalAlignment = Enum.HorizontalAlignment.Center,
	})
	Iris.Image({ assets.brand.rocket, UDim2.fromOffset(128, 128) })
	widgets.Header({ text = `Rocket v{manifest.version}` })
	Iris.PushConfig({ ImageColor = Iris._config.TextColor })

	Iris.SameLine({ nil, Enum.VerticalAlignment.Center, Enum.HorizontalAlignment.Center })
	Iris.Image({ assets.brand.github, UDim2.fromOffset(24, 24) })
	Iris.Text({ "team-fireworks/rocket" })
	Iris.End()

	widgets.Spacer(12)

	Iris.PushConfig({ ImageTransparency = 0.5 })
	Iris.Image({ assets.brand.teamfireworks, UDim2.new(1, 0, 0, 32), Rect.new(0, 0, 0, 0), Enum.ScaleType.Fit })
	Iris.PopConfig()

	Iris.PopConfig()
	Iris.End()

	widgets.Spacer(12)

	if Iris.CollapsingHeader({ "Credits" }).state.isUncollapsed.value then
		Iris.Text({ "(TODO)" })
	end
	Iris.End()
end

return about
