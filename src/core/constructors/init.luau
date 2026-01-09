-- Constructors are separate from the classes as to disallow the end-user from
-- constructing their own instances.

return table.freeze({
	createCommand = require("@self/createCommand"),
	createCommandRuntime = require("@self/createCommandRuntime"),
	createExtension = require("@self/createExtension"),
})
