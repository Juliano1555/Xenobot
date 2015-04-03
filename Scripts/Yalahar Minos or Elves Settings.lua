--[[ [EK] Yalahar Pirates Settings File
		
		- Vial Dropper
		
			Please view more of our great, free lua scripts:
			http://forums.xenobot.net/showthread.php?11556-Xenobot-Community-Scripts&p=139024&viewfull=1#post139024

		This script is proudly brought to you by JXScripts!
]]

local flasks = {283, 284, 285}
Module.New('vial dropper', function()
    local vialIndex = -1
    for i = 0, #Container.GetAll() do
        local c = Container.New(i)
        for s = 0, c:ItemCount() do
            local item = c:GetItemData(s)
            if table.contains(flasks, item.id) then
                vialIndex = c:Index()
                break
            end
        end
        if vialIndex > 0 then
            break
        end
    end
    local vialBp = Container.New(vialIndex)
    if Self.Cap() < 200 or vialBp:EmptySlots() < 5 then
        for s = 0, vialBp:ItemCount() do
            local item = vialBp:GetItemData(s)
            if table.contains(flasks, item.id) then
                vialBp:MoveItemToGround(s, Self.Position().x, Self.Position().y, Self.Position().z, 100)
                return
            end
        end
    end
end)