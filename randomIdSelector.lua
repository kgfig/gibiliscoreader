--[[
	Random id selector from a set of ids
--]]

local module = {}

module.idTable = {}

module.getNextIds = function ( setCount )
	local idCounter = 0
	local startId = 1
	local lastId = 944
	local idSet = {}
	
	repeat
		local selectedId = math.random( startId, lastId )
		
		if module.idTable[selectedId] == nil then
			idCounter = idCounter + 1
			module.idTable[selectedId] = 1
			table.insert( idSet, selectedId )
		end
		
	until idCounter == setCount or table.getn( module.idTable ) == 944
	
	return idSet
end

return module