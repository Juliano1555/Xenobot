_COMMANDS = {}
_COMMANDS["soft"] = function(b) 
						if b then 
							local mod = Module.New("SoftModule", function(module) 
								if not Self.SoftModule then return true end
								if not Self.isInPz() then
									if Self.Feet().id ~= 3549 and Self.ItemCount(6529) > 0 then
										Self.Equip(6529, "feet")
									end
								else
									if Self.Feet().id ~= Item.GetID("depth calcei") and Self.ItemCount(Item.GetID("depth calcei")) > 0 then
										Self.Equip(secondary, "feet")
									end
								end
								module:Delay(1000)
								Self.SoftModule = true
							end)
						else
							Self.SoftModule = false
						end
						return "Soft Boots equiper " .. (b and "activated" or "deactivated") .. "."
					end
					
function getBooleanFromString(str)
	return str == "on" or str == "yes" or str == "start" and true or false
end

function ParseCommand(str)
	sep = str:split('->')
	func = string.lower(sep[1])
	command = string.lower(sep[2])
	if _COMMANDS[func] then
		local bool = getBooleanFromString(command)
		return _COMMANDS[func](bool)
	else
		return "Wrong command."
	end
end

function onTalk(c ,m)
	c:SendYellowMessage(Self.Name(), m)
	local input = ParseCommand(m)
	if input ~= "" then
		c:SendOrangeMessage("Smart Channel", input)
	end
end



channel = Channel.New("Smart Channel", onTalk)

