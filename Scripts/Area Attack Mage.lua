local config = {
	delay = 400, -- delay time in between checks [default = 500ms]
	attacks = {
		['exevo gran mas flam'] = {
			min = 5,
			spellRadius = 5,
			checkRadius = 6,
			countPlayers = false,
			attackMode = 'none'
		},
		['exori gran flam'] =
		{
			min = 1,
			max = 2,
			spellRadius = 4,
			checkRadius = 4,
			countPlayers = false,
			attackMode = 'none',
			needTarget = true,
			targetList = {"Kollos", "Spidris", "Spidris Elite", "Spitter", "Waspoid", "Crawler"},
			healthPercent = 30
		},
		['exori max flam'] =
		{
			min = 1,
			max = 2,
			spellRadius = 4,
			checkRadius = 4,
			countPlayers = false,
			attackMode = 'none',
			needTarget = true,
			targetList = {"Kollos", "Spidris", "Spidris Elite", "Spitter"},
			healthPercent = 60
		},
		['exori flam'] =
		{
			min = 1,
			max = 2,
			spellRadius = 4,
			checkRadius = 4,
			countPlayers = false,
			attackMode = 'none',
			needTarget = true,
			targetList = {"Kollos", "Spidris", "Spidris Elite", "Spitter", "Waspoid", "Crawler"}
		},
		['exori frigo'] =
		{
			min = 1,
			spellRadius = 4,
			checkRadius = 4,
			countPlayers = false,
			attackMode = 'none',
			needTarget = true,
			targetList = {"Dragon Lord", "Dragon", "Dragon Hatchling", "Dragon Lord Hatchling"}
		},
		['exori gran vis'] =
		{
			min = 1,
			spellRadius = 4,
			checkRadius = 4,
			countPlayers = false,
			attackMode = 'none',
			needTarget = true,
			targetList = {"Dragon Lord", "Dragon", "Dragon Hatchling", "Dragon Lord Hatchling"}
		},
		['exori max vis'] =
		{
			min = 1,
			spellRadius = 4,
			checkRadius = 4,
			countPlayers = false,
			attackMode = 'none',
			needTarget = true,
			targetList = {"Dragon Lord", "Dragon", "Dragon Hatchling", "Dragon Lord Hatchling"}
		}
	}
}

Ignore = {}

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
	for words, spell in pairs(config.attacks) do
		local amount = getTargetCount(Self.Position(), spell.spellRadius, spell.checkRadius, spell.countPlayers, spell.attackMode)
		if amount then
			local max = spell.max or amount
			if amount >= spell.min and amount <= max then
				if spell.useBuff and Self.CanCastSpell(spell.buffSpell) then
					if not nextBuff[spell.buffSpell] then
						nextBuff[spell.buffSpell] = 0
					end
					if os.time() >= nextBuff[spell.buffSpell] then
						Self.Say(spell.buffSpell)
						nextBuff[spell.buffSpell] = os.time() + spell.buffDelay
						wait(200)
					end
				end
				if(spell.needTarget)then
					local target = Creature.GetByID(Self.TargetID())
					local percent = spell.healthPercent or 1
					if(target:isValid() and target:isOnScreen() and target:isVisible() and target:isAlive())then
						if target:DistanceFromSelf() <= spell.spellRadius and table.contains(spell.targetList, target:Name()) and target:HealthPercent() >= percent then
							if Self.CanCastSpell(words) then
								--para dl
								if Self.ItemCount(3155) < 1 then
									Self.Say(words)
									return true
								end
							end
						end
					end
				else
					if Self.CanCastSpell(words) then
						Self.Say(words)
						return true
					end
				end
			end
		end
	end
	wait(config.delay)
end
	

while(true)do
	onThink()
	wait(config.delay)
end