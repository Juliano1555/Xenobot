while(true) do
	if Self.Soul() >= 5 and Self.Mana() >= 985 and Self.ItemCount(3147) > 0 then
		Self.Say("adori gran mort")
	elseif Self.Mana() >= 440 and Self.Soul() < 5 then 
		Self.Say("utana vid") 
	end
	wait(100)
end