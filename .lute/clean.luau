local Summon = require("@lib/Summon")
local process = require("@lute/process")

do
	process.exit(Summon.codeFromMany(Summon.new("lute", "clean-build"), Summon.new("lute", "clean-pkgs")))
end
