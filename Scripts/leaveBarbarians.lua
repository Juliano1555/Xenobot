CapToLeave = 30
RequiredManas = 400
RequiredHealths = 100 
ManasToLeave = 50
HealthsToLeave = 20 
ManaID = 268
HealthID = 239
ManaPrice = 50
HealthPrice = 190 
StaminaToLeave = 20 * 60 
LeaveAtGold = 8000 
SoftBoots = true
LeaveNoSoftBoots = true
GoldBP = "orange backpack"
LootBP = "brocade backpack"
SecondaryBoots = 4033
HuntInTower = true

ClosedDoor = 7042

while(true) do
	if Self.Position().z == 7 and Self.ItemCount(ManaID) <= ManasToLeave or Self.ItemCount(HealthID) <= HealthsToLeave or Self.Cap() <= CapToLeave or Self.Stamina() <= StaminaToLeave or Self.Money() >= LeaveAtGold or LeaveNoSoftBoots and Self.ItemCount(6529) < 1 and Self.ItemCount(3549) < 1 then
		if getCreatureStorage(Self, "leavingBarbarians") < 1 then
			gotoLabel("Leave")
			doCreatureSetStorage(Self, "leavingBarbarians", 1)
		end
	end
	wait(1000)
end