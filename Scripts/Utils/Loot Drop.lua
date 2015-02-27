local items_str = {'plate armor', 'two-handed sword'}
local items_id = {}

for _, n in ipairs(items_str) do
	table.insert(items_id, Item.GetID(n))
end

Module.New('Loot droper', function(module)

	local corpse = Container.GetLast()
	local pos = Self.Position()
	if corpse:GetName():find('dead') then --container name has word 'dead' ie: dead orc
		local items = corpse:iItems()
		for spot, item in pairs(items) do
			if table.contains(items_id, item.id) then --match!
				if item:GetWeight() > Self.Cap() then
					Walker.Delay(1000)
					corpse:MoveItemToGround(spot, pos.x, pos.y, pos.z, item:ItemCount())
				end
			end
		end
	end
end)


			