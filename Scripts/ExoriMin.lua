--EXORI MIN BY DARKHAOS

function doComparePositions(position, positionEx)
	return position.x == positionEx.x and position.y == positionEx.y and position.z == positionEx.z
end

countPlayers = false
useBuff = true
buffSpell = 'utito tempo'
buffDelay = 10

nextBuff = {}
nextUtito = 0
function onThink()
	countPlayers = false
	useBuff = true
	buffSpell = 'utito tempo'
	buffDelay = 10

	nextBuff = {}
	nextUtito = 0
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
			{x = p.x +-1, y = p.y - 1, z = p.z}
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
				wait(70)
			end
		end
		if Self.CanCastSpell('exori min') then
			Self.Say('exori min')
			return true
		end
	end
end

while(true) do
	onThink()
	wait(300)
end
				
		