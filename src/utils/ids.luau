local function rocket(id: string)
	return `@rocket/{id}`
end

return table.freeze({
	rocket = rocket,
})
