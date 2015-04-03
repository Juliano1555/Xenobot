function messageProxyCallback(proxy, message)
    ParseMessage(message)
end

BattleMessageProxy.OnReceive("BattleMessageProxy", messageProxyCallback)

local targetName = ""
local total = 0
local maxDamage = 0
local NAME_HUD = nil
local MINUTE_HUD = nil
local MAX_HUD = nil

function ParseMessage(message)
	--18:43 A monk loses 3 hitpoints due to your attack.
	if message:find("due to your attack") > 0 then --it's my attack
		local damage = tonumber(string.match(message, '%d+')) or 0
		if damage > maxDamage then
			maxDamage = damage
		end
		total = total + damage
	end
end

Module.New("DamageResetter", function(module)
	total = 0
	module:Delay(60000)
end)

--show all items and spells
NAME_HUD = HUD.New(10, 1*16, "Target: ", 255, 165, 35)
MINUTE_HUD = HUD.New(10, 2*16, "Damage per minute: ", 255, 165, 35)
MAX_HUD = HUD.New(10, 3*16, "Max hit: ", 255, 165, 35)

Module.New("HUDUpdate", function(module)
	if NAME_HUD ~= nil and Self.TargetID() > 0 then
		local target = Creature(Self.TargetID())
		if target:isOnScreen() and target:isVisible() and target:isAlive() and target:isReachable() then
			NAME_HUD:SetText("Target: " .. target:Name())
			targetName = target:Name()
		end
	end
	
	if MINUTE_HUD ~= nil and total > 0 then
		MINUTE_HUD:SetText("Damage per minute: " .. total)
	end
	
	if MAX_HUD ~= nil then
		MAX_HUD:SetText("Max hit: " .. maxDamage)
	end
	module:Delay(1000)
end)