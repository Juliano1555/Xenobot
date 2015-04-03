local friends = {'Darkhaos'}
local mana = 300
local porcentaje = 50

function isInArray(tb, item)
	for _, it in ipairs(tb) do
		if it == item then
			return true
		end
	end
	return false
end
Module.New("SioCriminaloso", function(module)
	for i = CREATURES_LOW, CREATURES_HIGH do
		local creature = Creature(i)
		if creature:isPlayer() and creature:ID() ~= Self.ID() then --diferente menor qlq q lacreo
			if creature:isVisible() and creature:isAlive() and creature:isReachable() then
				if isInArray(friends, creature:Name()) then
					if creature:HealthPercent() <= porcentaje then
						if Self.Mana() >= mana and Self.CanCastSpell('exura sio "' .. creature:Name()) then
							Self.Say('exura sio "' .. creature:Name())
							break
						end
					end
				end
			end
		end
	end
	module:Delay(500)
end)
						
				