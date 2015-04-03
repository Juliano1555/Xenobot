local trainer = "Monk"
local lastTarget = 0
Module.New("BattleModule", function(module)
	--let's find a target
	if Self.TargetID() < 1 then
		for i = CREATURES_LOW, CREATURES_HIGH do
			local creature = Creature.GetFromIndex(i)
			if creature:isValid() and creature:ID() ~= Self.ID() then
				if creature:isOnScreen() and creature:isVisible() and creature:isAlive() and creature:isReachable() then
					local name = creature:Name()
					if creature:DistanceFromSelf() <= 1 then
						if name == trainer then --target found
							if creature:HealthPercent() >= 30 then
								if lastTarget > 0 and Creature(lastTarget):isAlive() then
									if creature:ID() == lastTarget then
										creature:Attack()
										break
									end
								else
									creature:Attack()
									lastTarget = creature:ID()
									break
								end
							end
						end
					end
				end
			end
		end
	else --is attacking
		local target = Creature(Self.TargetID())
		if target:isOnScreen() and target:isVisible() and target:isAlive() and target:isReachable() then
			if target:HealthPercent() <= 20 then
				Self.StopAttack()
			else
				if not target:isTarget() then
					target:Attack()
				end
			end
		end
	end
	module:Delay(1000)
end)