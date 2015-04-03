while(true) do
	local p = Self.Position()
	while(Self.UseItemFromGround(p.x, p.y-1, p.z) == 0) do
		wait(100)
	end
	wait(10000)
end