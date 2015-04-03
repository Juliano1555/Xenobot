local items_str = {'gold coin', 'mace', 'viking helmet', 'hatchet', 'sword', 'scale armor'}
local items = {284, 283, 285}

for _, name in ipairs(items_str) do
	table.insert(items, Item.GetID(name))
end

local containerName = 'red backpack'  -- Ex. "Purple Backpack", "Backpack of holding", "Bag" etc
local minCap = 50

local range = 3

Module.New('lootFromGround', function(module)
	if Self.Cap() >= minCap then
		if (Self.TargetID() <= 0) then
			local pos = Self.Position()
			for y = -range, range do
				for x = -range, range do
					if table.find(items, Map.GetTopMoveItem(pos.x + x, pos.y + y, pos.z).id) then
						Walker.Delay(1000)
						Map.PickupItem(pos.x+x, pos.y+y, pos.z, Container.New(containerName):Index(), 0)  
					end
				end
			end
		end
	end
end)