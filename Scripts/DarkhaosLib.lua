DarkhaosLib = {}
DarkhaosLib.__index = DarkhaosLib

function DarkhaosLib.New()
	local dl = {}
	setmetatable(dl, DarkhaosLib)
	
	return dl
end

Self.ReachDepot = function(tries)
	local tries = tries or 5
	
	while(tries > 0) do
		local ret = Self.GoToDepot()
		if ret then return true end
		tries = tries - 1
		wait(1000)
		printf("Attempt to reach depot was unsuccessfull. " .. tries .. " tries left.")
	end
	
	return false
end

Map.GetUseItems = function (id)
    if type(id) == "string" then
        id = Item.GetID(id)
    end
    local pos = Self.Position()
    local store = {}
    for x = -7, 7 do
        for y = -5, 5 do
            if Map.GetTopUseItem(pos.x + x, pos.y + y, pos.z).id == id then
                itemPos = {x = pos.x + x, y = pos.y + y, z = pos.z}
                table.insert(store, itemPos)
            end
        end
    end
    return store
end

Self.GoToDepot = function()
	local DepotIDs = {3497, 3498, 3499, 3500}
    local DepotPos = {}
	local depotTries = 0
	for _, id in ipairs(DepotIDs) do
		local d = Map.GetUseItems(id)
		for _, pos in ipairs(d) do
			table.insert(DepotPos, pos)
		end
	end
	
	print("Found " .. #DepotPos .. " depots.")
	for _, pos in ipairs(DepotPos) do
		depotTries = depotTries + 1
		Self.UseItemFromGround(pos.x, pos.y, pos.z)
		wait(3000)
		if Self.DistanceFromPosition(pos.x, pos.y, pos.z) <= 1 then --depot reached
			Walker.Start()
			return true
		else
			print("Something is blocking the path. Trying next depot (" .. depotTries .. ")")
		end
	end
	return false
end

DarkhaosLib.GetMonsterCount = function(name) --[name]
	local c = {}
	for i = CREATURES_LOW, CREATURES_HIGH do
		local creature = Creature.GetFromIndex(i)
		if creature:isValid() and creature:ID() ~= Self.ID() then
			if creature:isOnScreen() and creature:isVisible() and creature:isAlive() and creature:isReachable() then
				local name_ = creature:Name()
				if name then
					if name_ == name then
						table.insert(c, creature:ID())
					end
				else
					table.insert(c, creature:ID())
				end
			end
		end
	end
	return c
end