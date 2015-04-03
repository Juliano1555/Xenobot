local item = 7643
local whiteList = {'Kroser Welka'}
local healthPercent = 60

function isInArray(array, t)
	for _, item in ipairs(array) do
		if(item == t) then
			return true
		end
	end
	return false
end

function onThink()
	for i = CREATURES_LOW, CREATURES_HIGH do
		local creature = Creature.GetFromIndex(i)
		if(creature:isValid() and creature:ID() ~= Self.ID())then
			if(creature:isOnScreen() and creature:isVisible() and creature:isAlive() and creature:isPlayer())then
				if creature:DistanceFromSelf() < 3 then
					if(isInArray(whiteList, creature:Name())) then
						if(creature:HealthPercent() <= healthPercent) then
							Self.UseItemWithCreature(item, creature:ID())
						end
					end
				end
			end
		end
	end
end

while(true)do
	onThink()
	wait(100)
end