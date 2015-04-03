local started = os.clock()
local hud = HUD.New(0,0,'',0,0,0)
hud:SetPosition(10, 5 + 16)
hud:SetText('Time: 0:0:0')
hud:SetTextColor(255, 165, 0)
Module.New('Timer', function(module)

	local seconds = os.clock() - started
	local hours = math.floor(seconds / 3600)
	local minutes = math.floor(seconds / 60)
	local seconds = math.floor(seconds - ((hours * 3600) + minutes * 60))
	
	hud:SetPosition(10, 5 + 16)
	hud:SetText('Time: ' .. hours .. ':' .. minutes .. ':' .. seconds)
	hud:SetTextColor(255, 165, 0)
	module:Delay(1000)
end)