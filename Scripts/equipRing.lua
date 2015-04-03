Ring = 3098

while(true) do
	if Self.Ring().id ~= Item.GetRingActiveID(Ring) then
		if Self.ItemCount(Ring) > 0 then
			Self.Equip(Ring, "ring")
		end
	end
	wait(3000)
end