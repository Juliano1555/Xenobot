local creatures =
{
	["Kongra"] = 115,
	["Sibang"] = 105,
	["Merlkin"] = 145
}

function onTalk(c ,m)
	if m == "/d" then
		Walker.Stop()
		Targeting.Stop()
		Looter.Stop()
		c:SendOrangeMessage("[Command Channel]", "Cavebot is disabled.")
	elseif m == "/a" then
		Walker.Start()
		Targeting.Start()
		Looter.Start()
		c:SendOrangeMessage("[Command Channel]", "Cavebot is enabled.")
	elseif m == "/exp" then
		c:SendOrangeMessage("[Command Channel]", "You have gained " .. Self.Experience() - getCreatureStorage(Self, "experience") .. " experience in " .. math.floor((os.time() - getCreatureStorage(Self, "channelOpened")) / 60) .. " minutes.")
	elseif m == "/expmonster" then
		local total = 0
		for cr, c_ in pairs(creatures) do
			if Self.GetCreatureKills(cr) then
				c:SendOrangeMessage("[Command Channel]", Self.GetCreatureKills(cr) .. " " .. cr .. "(s) killed. Total exp: " .. Self.GetCreatureKills(cr) * c_ .. ".")
				total = total + Self.GetCreatureKills(cr) * c_
			end
		end
		c:SendOrangeMessage("[Command Channel]", "Total exp gained since you killed the first creature ~" .. total .. ".")
	elseif m == "/melt" then
		local c = Self.ItemCount(9058)
		for i = 1, c do
			Self.SayToNpc("melt")
			wait(200)
			Self.SayToNpc("yes")
			wait(200)
			Self.SayToNpc("yes")
			wait(200)
		end
	end
end

channel = Channel.New("Command", onTalk)
doCreatureSetStorage(Self, "experience", Self.Experience())
doCreatureSetStorage(Self, "channelOpened", os.time())