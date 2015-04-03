RequiredHealths = 10
RequiredManas = 30
RequiredSpears = 17

HealthsToLeave = 3
ManasToLeave = 5

CapToLeave = 10

GoldBackpack = "brocade backpack"
LootBackpack = "blue backpack"

HealthID = 266
ManaID = 268

HealthPrice = 45
ManaPrice = 50

SpearID = 7378
SpearPrice = 15
SpearsToLeave = 5

while(true) do
	if Self.Cap() <= CapToLeave or Self.ItemCount(HealthID) <= HealthsToLeave or Self.ItemCount(SpearID) <= SpearsToLeave or Self.ItemCount(ManaID) <= ManasToLeave then
		if getCreatureStorage(Self, "leavingMonos") < 1 then
			print(Self.Cap() .. " - " .. CapToLeave)
			print(Self.ItemCount(HealthID) .. " - " .. HealthsToLeave)
			print(Self.ItemCount(SpearID) .. " - " .. SpearsToLeave)
			doCreatureSetStorage(Self, "leavingMonos", 1)
			gotoLabel("Leave")
		end
	end
end
