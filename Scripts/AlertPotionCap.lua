Self.Module = Module.New("AlertPotion", function(module)
	if Self.ItemCount(Item.GetID("strong mana potion")) <= 100 or Self.Cap() <= 100 or Self.ItemCount(6529) < 1 and Self.Feet().id ~= 3549 then
		alert()
	end
	module:Delay(3000)
end)