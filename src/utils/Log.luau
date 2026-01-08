local LocalizationService = game:GetService("LocalizationService")

local Charm = require("@pkgs/Charm")
local repr = require("@include/repr")

export type LogEvent = {
	timestamp: DateTime,
	from: Log,
	level: number,
	args: { [number]: any, n: number },
}

local LOG_LEVELS = {
	ERROR = 1,
	WARN = 2,
	INFO = 3,
	DEBUG = 4,
	TRACE = 5,
}

local LOG_LEVEL_TAGS = {
	[LOG_LEVELS.ERROR] = "ERR",
	[LOG_LEVELS.WARN] = "WRN",
	[LOG_LEVELS.INFO] = "INF",
	[LOG_LEVELS.DEBUG] = "DBG",
	[LOG_LEVELS.TRACE] = "TRC",
}

local Log = {}
Log.__index = Log
Log._maxLevel = Charm.atom(LOG_LEVELS.TRACE)
Log._events = Charm.atom({} :: { LogEvent })
Log.LOG_LEVELS = LOG_LEVELS

export type Log = setmetatable<{ read source: string | Instance, read maxLevel: number? }, typeof(Log)>

local function outputEvent(event: LogEvent)
	local timestamp = event.timestamp:FormatLocalTime("LTS", LocalizationService.RobloxLocaleId)
	local source: string = if typeof(event.from.source) == "Instance" then event.from.source.Name else event.from.source
	local prefix = `🚀 {LOG_LEVEL_TAGS[event.level]} {source}: `

	local formatted = {}
	for i = 1, event.args.n do
		local value = event.args[i]
		formatted[i] = if typeof(value) == "string" then value else repr(value)
	end

	local formattedString = prefix .. string.gsub(table.concat(formatted, " "), "\n", `\n{prefix}`)
	formattedString ..= ` - {timestamp}`

	if event.level <= LOG_LEVELS.ERROR then
		task.spawn(error, formattedString :: any, 0)
	elseif event.level <= LOG_LEVELS.WARN then
		warn(formattedString)
	else
		print(formattedString)
	end

	return formattedString
end

function Log.new(source: string | Instance, maxLevel: number?): Log
	return table.freeze(setmetatable({ source = source, maxLevel = maxLevel }, Log))
end

function Log.log(self: Log, level: number, ...: any)
	local timestamp = DateTime.now()

	local event: LogEvent = {
		timestamp = timestamp,
		from = self,
		level = level,
		args = table.pack(...),
	}

	local newEvents = table.clone(Log._events())
	table.insert(newEvents, event)
	Log._events(newEvents)

	if level <= (self.maxLevel or Log._maxLevel()) then
		outputEvent(event)
	end
end

function Log.error(self: Log, ...: any)
	self:log(LOG_LEVELS.ERROR, ...)
end

function Log.warn(self: Log, ...: any)
	self:log(LOG_LEVELS.WARN, ...)
end

function Log.info(self: Log, ...: any)
	self:log(LOG_LEVELS.INFO, ...)
end

function Log.debug(self: Log, ...: any)
	self:log(LOG_LEVELS.DEBUG, ...)
end

function Log.trace(self: Log, ...: any)
	self:log(LOG_LEVELS.TRACE, ...)
end

return table.freeze(Log)
