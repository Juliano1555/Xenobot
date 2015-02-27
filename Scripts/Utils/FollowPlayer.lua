local player = "Darkhaos"
Module.New("AutoFollow", function(module)
	for i = CREATURES_LOW, CREATURES_HIGH do
		local creature = Creature.GetFromIndex(i)
		if creature:isValid() and creature:ID() ~= Self.ID() then
			if creature:isOnScreen() and creature:isVisible() and creature:isAlive() and creature:isReachable() then
				local name = creature:Name()
				if creature:isPlayer() and creature:Name():lower() == player:lower() and not creature:isFollowed() then
					creature:Follow()
				end
			end
		end
	end
	module:Delay(1000)
end)