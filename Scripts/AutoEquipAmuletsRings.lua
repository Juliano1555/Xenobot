local FRIENDS = {"Darkhaos", "Odraw"}

local items =
{
	[3081] = --stone skin amulet
	{
		think = function(id)
			AMOUNT = 0
			for i = CREATURES_LOW, CREATURES_HIGH do
				local c = Creature.GetFromIndex(i)
				if c:isPlayer() and c:Skull() > SKULL_NONE and not isFriend(c:Name()) then
					AMOUNT = AMOUNT+1
				end
			end
			if (AMOUNT >= 3) and Self.Amulet().id ~= id then
				Self.Equip(id, "amulet")
			end
			
			if (Self.Mana() * 100 / Self.MaxMana()) <= 20 and Self.Amulet().id ~= id then
				Self.Equip(id, "amulet")
			end
		end
	},
	[3052] =
	{
		think = function(id)
			if Self.Ring().id == 0 and not Self.isInPz() then
				if Self.ItemCount(id) > 0 then
					Self.Equip(id, "ring")
				end
			end
		end
	},
	[3053] =
	{
		think = function(id)
			if Self.Ring().id == 0 and not Self.isInPz() then
				if Self.ItemCount(id) > 0 then
					Self.Equip(id, "ring")
				end
			end
		end
	},
	[3098] =
	{
		think = function(id)
			if Self.Ring().id == 0 and not Self.isInPz() then
				if Self.ItemCount(id) > 0 then
					Self.Equip(id, "ring")
				end
			end
		end
	}				
}

function isFriend(name)
	bool = false
	for _, n in ipairs(FRIENDS) do
		if n == name then
			bool = true
		end
	end
	return bool
end

while(true) do
	for id, it in pairs(items) do
		it.think(id)
	end
	wait(100)
end
			
			
			