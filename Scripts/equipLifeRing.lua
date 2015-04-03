while(true) do
	if Self.Ring().id ~= Item.GetRingActiveID(3052) then
		if Self.ItemCount(3052) > 0 then
			Self.Equip(3052, "ring")
		end
	end
	wait(3000)
end