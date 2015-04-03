local secondary = (Self.Name() == "Darkhaos" and Item.GetID("depth calcei") or Item.GetID("boots of haste")) --las botas normales
local soft = 
{
	normal = 6529,
	using = 3549
}
while true do
	if not Self.isInPz() then
		if Self.Feet().id ~= soft.using and Self.ItemCount(soft.normal) > 0 then
			Self.Equip(soft.normal, "feet")
		end
	else
		if Self.Feet().id ~= secondary and Self.ItemCount(secondary) > 0 then
			Self.Equip(secondary, "feet")
		end
	end
	wait(1000)
end