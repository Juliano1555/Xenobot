local config = {
	delay = 100, -- delay time in between checks [default = 500ms]
	attacks = {
		['exori gran'] = {
			min = 3,
			spellRadius = 1,
			checkRadius = 2,
			countPlayers = false,
			attackMode = 'none',
			useBuff = false,
			buffSpell = 'utito tempo',
			buffDelay = 10
		},
		['exori'] =
		{
			min = 2,
			spellRadius = 1,
			checkRadius = 2,
			countPlayers = false,
			attackMode = 'none',
			cooldown = 2000
		},
		['exori gran ico'] =
		{
			min = 1,
			spellRadius = 3,
			checkRadius = 3,
			countPlayers = false,
			attackMode = 'none',
			needTarget = true,
			targetList = {"Kollos", "Spidris", "Spidris Elite", "Spitter", "Deepling Elite", "Deepling Guard", "Deepling Tyrant", "Deepling Warrior"},
			useBuff = false,
			buffSpell = 'utito tempo',
			buffDelay = 10,
			healthPercent = 30
		},
		['exori ico'] =
		{
			min = 1,
			spellRadius = 3,
			checkRadius = 3,
			countPlayers = false,
			attackMode = 'none',
			needTarget = true,
			targetList = {"Waspoid", "Crawler", "Deepling Brawler", "Deepling Warrior", "Deepling Master Librarian", "Deepling Scout", "Deepling Spellsinger"},
			cooldown = 15000
		},
		['exori hur'] =
		{
			min = 1,
			spellRadius = 3,
			checkRadius = 3,
			countPlayers = false,
			attackMode = 'none',
			needTarget = true,
			targetList = {"Spitter", "Insectoid Worker", "Spidris", "Kollos", "Deepling Warrior", "Deepling Master Librarian", "Deepling Scout", "Deepling Spellsinger"},
			cooldown = 15000
		},
		['utori kor'] =
		{
			min = 1,
			spellRadius = 3,
			checkRadius = 3,
			countPlayers = false,
			attackMode = 'none',
			needTarget = true,
			targetList = {"Kollos", "Spidris", "Deepling Guard", "Deepling Tyrant"},
			healthPercent = 50
		},


		['exori min'] =
		{
			func = function()
				local countPlayers = false
				local useBuff = false
				local buffSpell = 'utito tempo'
				local buffDelay = 10

				local nextBuff = {}
				local nextUtito = 0
				local tmp =
				{
					{dir = "north", t = {}},
					{dir = "south", t = {}},
					{dir = "east", t = {}},
					{dir = "west", t = {}}
				}
				local p = Self.Position()
				local positions =
				{
					["north"] =
					{
						{x = p.x - 1, y = p.y - 1, z = p.z},
						{x = p.x, y = p.y - 1, z = p.z},
						{x = p.x + 1, y = p.y - 1, z = p.z}
					},
					["south"] =
					{
						{x = p.x - 1, y = p.y + 1, z = p.z},
						{x = p.x, y = p.y + 1, z = p.z},
						{x = p.x + 1, y = p.y + 1, z = p.z}
					},
					["east"] =
					{
						{x = p.x + 1, y = p.y + 1, z = p.z},
						{x = p.x + 1, y = p.y, z = p.z},
						{x = p.x + 1, y = p.y - 1, z = p.z}
					},
					["west"] =
					{
						{x = p.x - 1, y = p.y + 1, z = p.z},
						{x = p.x - 1, y = p.y, z = p.z},
						{x = p.x - 1, y = p.y - 1, z = p.z}
					}
				}
				for k, v in pairs(positions) do
					for i = CREATURES_LOW, CREATURES_HIGH do
						local creature = Creature.GetFromIndex(i)
						if(creature:isValid() and creature:ID() ~= Self.ID())then
							if(creature:isOnScreen() and creature:isVisible() and creature:isAlive())then
								if creature:DistanceFromSelf() < 3 then
									if not countPlayers and creature:isPlayer() then
										return false
									end
								
									for _, p in ipairs(v) do
										if doComparePositions(p, creature:Position()) then
											for _, info in ipairs(tmp) do
												if info.dir == k then
													table.insert(info.t, creature)
												end
											end
										end
									end
								end
							end
						end
					end
				end

				table.sort(tmp, function(a, b) return #a.t > #b.t end)
				if #tmp[1].t >=2 then
					Self.Turn(tmp[1].dir)
					if useBuff and Self.CanCastSpell(buffSpell) then
						if not nextBuff[buffSpell] then
							nextBuff[buffSpell] = 0
						end
						if os.time() >= nextBuff[buffSpell] then
							Self.Say(buffSpell)
							nextBuff[buffSpell] = os.time() + buffDelay
							wait(1000)
						end
					end
					if Self.CanCastSpell('exori min') then
						Self.Say('exori min')
						return true
					end
				end
			end
		}
	}
}

Ignore = {"Jellyfish", "Fish", "Deepling Worker", "Deepling Scout", "Lesser Swarmer"}

function getTargetCount(pos, atkRadius, chkRadius, incPlayers, atkMode)
	local n = 0
	for i = CREATURES_LOW, CREATURES_HIGH do
		local creature = Creature.GetFromIndex(i)
		if(creature:isValid() and creature:ID() ~= Self.ID())then
			if(creature:isOnScreen() and creature:isVisible() and creature:isAlive() and creature:isReachable())then
				local name = creature:Name()
				if(getDistanceBetween(creature:Position(), pos) <= chkRadius)then
					if(atkMode == 'none' and creature:isPlayer() and not creature:isFriendly()) and creature:PvPIcon() ~= PVP_GUILDMATE then
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

nextBuff = {}
nextUtito = 0
UtoriTargets = {}
function onThink()
	local ma = Self.MaxHealth()
	local cu = Self.Health()
	if math.floor(cu*100/ma) <= 60 then return true end
	for words, spell in pairs(config.attacks) do
		if spell.func then
			spell.func()
		else
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
							wait(70)
						end
					end
					if(spell.needTarget)then
						local target = Creature.GetByID(Self.TargetID())
						local percent = spell.healthPercent or 1
						if(target:isOnScreen() and target:isVisible() and target:isAlive())then
							if target:DistanceFromSelf() <= spell.spellRadius and table.contains(spell.targetList, target:Name()) and target:HealthPercent() >= percent then
								if Self.CanCastSpell(words) then
									local deny = false
									if words == 'utori kor' and table.contains(UtoriTargets, Self.TargetID()) then
										deny = true
									end
									if not deny then
										Self.Say(words)
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
	end
	wait(config.delay)
end

function doComparePositions(position, positionEx)
	return position.x == positionEx.x and position.y == positionEx.y and position.z == positionEx.z
end

while(true)do
	local spell = config.attacks['exori']
	local amount = getTargetCount(Self.Position(), spell.spellRadius, spell.checkRadius, spell.countPlayers, spell.attackMode)
	local percent = 70
	local r = math.floor((Self.Health() * 100 / Self.MaxHealth()))
	--[[if amount and amount <= 2 and r <= percent then
		Self.Say("exura ico")
	end]]
	onThink()
	wait(config.delay)
end