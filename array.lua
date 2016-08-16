
--[[
	Creates a new array (actually a table with numbers as indices).

	Arguments:
		size (number): number of elements (required).
		value (any): default value of each of the elements of the array
			(default: 0).
		start (number): first index of the array (default: 1).
--]]
function array(size, value, start)
	value = value or nil
	local startIdx = start or 1
	local endIdx   = size - startIdx + 1

	newArray = {}
	for i = startIdx, endIdx do
		newArray[i] = value
	end

	return newArray
end

function printArray(a)
	for k, v in pairs(a) do
		print(k, v)
	end
end
