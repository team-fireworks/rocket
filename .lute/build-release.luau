local Summon = require("@lib/Summon")

do
	local build = Summon.new(
		"lute",
		"run",
		"build",
		"model",
		"--mark-attribution",
		"--mark-language-mode strict",
		"--mark-optimization-level 2"
	)

	build:assert()
end
