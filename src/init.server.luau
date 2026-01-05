local plugin = require("@self/plugin")
if not plugin then
	error("Rocket must be run as a plugin!")
end

local LogService = game:GetService("LogService")

local Log = require("@self/utils/Log")
local initLauncherInput = require("@src/bootstrap/initLauncherInput")
local initPluginActions = require("@src/bootstrap/initPluginActions")
local initToolbar = require("@self/bootstrap/initToolbar")
local initUi = require("@src/bootstrap/initUi")
local parseError = require("@src/utils/parseError")
local pluginTrove = require("@self/pluginTrove")
local requireInstances = require("@src/utils/requireInstances")
local types = require("@self/types")

local function start()
	requireInstances(script:WaitForChild("extensions"):GetDescendants())
	initToolbar()
	initUi()
	initLauncherInput()
	initPluginActions()
end

do
	LogService:ClearOutput()

	local log = Log.new(script)
	pluginTrove:Add(function()
		log:trace("Rocket shutting down!")
	end)

	local bootstrapSuccess, bootstrapError: types.Error = xpcall(start, parseError, log)
	if bootstrapSuccess then
		log:info("Rocket started!")
	else
		pluginTrove:Destroy()

		local errorTrace = "\n\t" .. string.gsub(bootstrapError.trace, "\n", "\n\t")
		local errorMessage = `\nFailed to start Rocket!\nMessage: {bootstrapError.message}\n\nStack Trace:{errorTrace}`
		log:error(errorMessage, 0)
	end
end
