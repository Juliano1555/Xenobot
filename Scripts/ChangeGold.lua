local coins = {3031, 3035}

while true do
	local cont = Container.GetFirst()
	for spot = 0, cont:ItemCount() - 1 do
		local item = cont:GetItemData(spot)
		if item.count == 100 and table.contains(coins, item.id) then
			cont:UseItem(spot)
		end
	end
	wait(100)
end