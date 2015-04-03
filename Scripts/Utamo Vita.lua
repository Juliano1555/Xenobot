local targetList = {"Kollos", "Spidris", "Spidris Elite"}

while (true) do
	AMOUNT = 0
	for i = CREATURES_LOW, CREATURES_HIGH do
		local c = Creature.GetFromIndex(i)
		if c:isMonster() and c:isOnScreen() and c:isAlive() and table.contains(targetList, c:Name()) and c:isReachable() then
			AMOUNT = AMOUNT+1
		end
	end
	if (AMOUNT >= 4) then
		if Self.CanCastSpell("utamo vita") then
			Self.Say("utamo vita")
			wait(180000)
		end
	end
	wait(1000)
end