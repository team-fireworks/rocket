local Iris = require("@iris/Iris")
local assets = require("@src/assets")
local types = require("@settings/types")

local manifest = require(script:FindFirstAncestor("Rocket").include:WaitForChild("pesde.toml"))

local AboutPage = {} :: types.SettingsPage
AboutPage.id = "about"
AboutPage.title = "About"
AboutPage.tabIcon = assets.icons.rocket
AboutPage.extensionIcon = assets.extensions.settings.about

function AboutPage.render()
	Iris.Text(`Rocket v{manifest.version}`)
end

return AboutPage
