local t =
{
	["askarak demon"] = 16115,
	["askarak prince"] = 16115,
	["askarak lord"] = 16115,
	["shaburak demon"] = 8094,
	["shaburak prince"] = 8094,
	["shaburak lord"] = 8094
}

while(true)do
	local target = Creature.GetByID(Self.TargetID())
	if target:isAlive() and target:isValid() and target:isOnScreen() and target:isVisible() then
		local w = t[target:Name():lower()]
		if w and Self.ItemCount(w) > 0 and w ~= Self.Weapon().id then
			Self.Equip(w, "weapon")
		end
	end
	wait(1000)
end