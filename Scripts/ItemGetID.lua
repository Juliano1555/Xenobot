function ParseCommand(str)
	return Item.GetID(str) or -1
end


function onTalk(c ,m)
	c:SendYellowMessage(Self.Name(), m)
	local input = ParseCommand(m)
	if input ~= "" then
		c:SendOrangeMessage("Smart Channel", input)
	end
end

string.explode = function (str, sep, limit)

	local i, pos, tmp, t = 0, 1, "", {}
	for s, e in function() return string.find(str, sep, pos) end do
		tmp = str:sub(pos, s - 1):trim()
		table.insert(t, tmp)
		pos = e + 1

		i = i + 1
		if(limit ~= nil and i == limit) then
			break
		end
	end

	tmp = str:sub(pos):trim()
	table.insert(t, tmp)
	return t
end



channel = Channel.New("ItemGetID", onTalk)


