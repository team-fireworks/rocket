local Summon = require("@lib/Summon")
local path = require("@std/path")
local process = require("@lute/process")

Summon.new("bun", "run", "dev"):withCwd(path.format(path.join(process.cwd(), "docs"))):assert()
