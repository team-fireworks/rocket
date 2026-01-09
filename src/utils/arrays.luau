local function map<I, O>(array: { I }, mapper: (I) -> O): { O }
	local result = {}
	for i, value in array do
		result[i] = mapper(value)
	end
	return result
end

local function filter<T>(array: { T }, predicate: (T) -> boolean): { T }
	local result = {}
	for _, value in array do
		if predicate(value) then
			table.insert(result, value)
		end
	end
	return result
end

local function slice<T>(array: { T }, min: number, max: number): { T }
	return table.move(array, min, max, 1, {})
end

local function concat<T>(destination: { T }, src: { T }): { T }
	return table.move(src, 1, #src, #destination + 1, destination)
end

local function concatAll<T>(destination: { T }, ...: { T }): { T }
	for i = 1, select("#", ...) do
		destination = concat(destination, select(i, ...))
	end
	return destination
end

return table.freeze({
	map = map,
	filter = filter,
	slice = slice,
	concat = concat,
	concatAll = concatAll,
})
