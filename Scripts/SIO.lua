local friends = {{name = 'Darkhaos', percent = 50}, {name = 'Royall Khaos', percent = 80}}
local mana = 140
local porcentaje = 80

function isInArray(tb, item)
	return table.contains(tb, item)
end
Module.New("SioCriminaloso", function(module)
	for i = CREATURES_LOW, CREATURES_HIGH do
		local creature = Creature(i)
		if creature:isPlayer() and creature:ID() ~= Self.ID() then --diferente menor qlq q lacreo
			if creature:isVisible() and creature:isAlive() and creature:isReachable() then
				for _, data in ipairs(friends) do
					if data.name:lower() == creature:Name():lower() then
						if creature:HealthPercent() <= data.percent then
							if Self.Mana() >= mana and Self.CanCastSpell('exura sio "' .. creature:Name()) then
								Self.Say('exura sio "' .. creature:Name())
								break
							end
						end
					end
				end
			end
		end
	end
	module:Delay(100)
end)
						
				