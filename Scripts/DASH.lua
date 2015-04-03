Module.New("Dash", function(module)
	if Self.LookDirection() == NORTH then --north
		Self.UseItemFromGround(Self.Position().x, Self.Position().y - 3, Self.Position().z)
	elseif Self.LookDirection() == EAST then --east
		Self.UseItemFromGround(Self.Position().x + 3, Self.Position().y, Self.Position().z)
	elseif Self.LookDirection() == SOUTH then --south
		Self.UseItemFromGround(Self.Position().x, Self.Position().y + 3, Self.Position().z)
	elseif Self.LookDirection() == WEST then
		Self.UseItemFromGround(Self.Position().x - 3, Self.Position().y, Self.Position().z)
	end
	
	module:Delay(1)
end)