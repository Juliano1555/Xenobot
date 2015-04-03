while(true) do
	Self.SayToNpc("melt")
	wait(10)
	for i = 1, 2 do
		Self.SayToNpc("yes")
		wait(10)
	end
end