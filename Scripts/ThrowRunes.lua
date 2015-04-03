Runes =
{
	[3191] =
	{
		min = 3,
		runeRadius = 6,
		checkRadius = 8,
		countPlayers = false,
		attackMode = 'none',
		needTarget = true
	}
}

Ignore = {}		
function getTargetTargetCount(Target, atkRadius, chkRadius, incPlayers, atkMode)
	local n = 0
	for i = CREATURES_LOW, CREATURES_HIGH do
		local creature = Creature.GetFromIndex(i)
		if(creature:isValid() and creature:ID() ~= Self.ID() and creature:ID() ~= Target:ID())then
			if(creature:isOnScreen() and creature:isVisible() and creature:isAlive() and creature:isReachable())then
				local name = creature:Name()
				if(getDistanceBetween(creature:Position(), Target:Position()) <= chkRadius)then
					if(atkMode == 'none' and creature:isPlayer() and not creature:isFriendly())then
						return false
					elseif(atkMode == 'enemies' and (creature:isFriendly() or creature:isInnocent()))then
						return false
					elseif(atkMode == 'strangers' and creature:isFriendly())then
						return false
					elseif(atkMode == 'friends' and creature:isInnocent())then
						return false
					end
					if(getDistanceBetween(creature:Position(), Target:Position()) <= atkRadius)then
						if(not creature:isPlayer() or incPlayers or creature:isFriendly() or creature:ID() ~= Target:ID())then
							local deny = false
							if table.contains(Ignore, creature:Name()) then
								deny = true
							end
							if not deny then
								n = n + 1
							end
						end
					end
				end
			end
		end
	end
	return n
end

function getTargetCount(pos, atkRadius, chkRadius, incPlayers, atkMode)
	local n = 0
	for i = CREATURES_LOW, CREATURES_HIGH do
		local creature = Creature.GetFromIndex(i)
		if(creature:isValid() and creature:ID() ~= Self.ID())then
			if(creature:isOnScreen() and creature:isVisible() and creature:isAlive() and creature:isReachable())then
				local name = creature:Name()
				if(getDistanceBetween(creature:Position(), pos) <= chkRadius)then
					if(atkMode == 'none' and creature:isPlayer() and not creature:isFriendly())then
						return false
					elseif(atkMode == 'enemies' and (creature:isFriendly() or creature:isInnocent()))then
						return false
					elseif(atkMode == 'strangers' and creature:isFriendly())then
						return false
					elseif(atkMode == 'friends' and creature:isInnocent())then
						return false
					end
					if(getDistanceBetween(creature:Position(), pos) <= atkRadius)then
						if(not creature:isPlayer() or incPlayers or creature:isFriendly())then
							local deny = false
							if table.contains(Ignore, creature:Name()) then
								deny = true
							end
							if not deny then
								n = n + 1
							end
						end
					end
				end
			end
		end
	end
	return n
end

function onThink()
	for id, rune in pairs(Runes) do
		if rune.needTarget then
			local target = Creature.GetByID(Self.TargetID())
			if(target:isOnScreen() and target:isVisible() and target:isAlive())then
				local amount = getTargetTargetCount(target, rune.runeRadius, rune.checkRadius, rune.countPlayers, rune.attackMode)
				if amount then
					local max = rune.max or amount
					if amount >= rune.min and amount <= max then
						local percent = rune.healthPercent or 1
						if target:DistanceFromSelf() <= rune.runeRadius and target:HealthPercent() >= percent then
							if Self.ItemCount(id) > 0 then
								Self.UseItemWithTarget(id)
								return true
							end
						end
					end
				end
			end
		else
			local amount getTargetCount(Self.Position(), rune.runeRadius, rune.checkRadius, rune.countPlayers, rune.attackMode)
			if amount then
				local max = rune.max or amount
				if amount >= rune.min and amount <= max then
					if Self.ItemCount(id) > 0 then
						Self.UseItemWithMe(id)
						return true
					end
				end
			end
		end
	end
end
	

while(true)do
	onThink()
	wait(2000)
end