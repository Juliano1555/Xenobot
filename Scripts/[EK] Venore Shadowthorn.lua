dofile('cslib.lua')
--	  ____
--  / ____|                     _      _    _
-- | |     ___  _       _ _____| |  __| \  / |
-- | |    / _ \| |\   /| |  _  \ |/ _ \  \/ /
-- | |___| (_) | |\\_//| | |_| | |  __/  /\ \
--  \_____\___/|_|     |_|  ___|_|\___|_/  \_|
--					     | |
--					     |_|
--========DP SPOT 0 = STACKABLE========--
--========DP SPOT 1 = RARES============--
--========DP SPOT 2 = FOOD=============--

--========Backpacks====================--
mainBP = "backpack"
stackBP = "red backpack"
lootBP = "camouflage backpack"
goldBP = "green backpack"
suppliesBP = "grey backpack"

--========Mana=========================--
mPots = "Mana Potion"
maxMP = 100 --- Manas to bring
minMP = 20 --- Manas to leave

--========Health========================--
hPots = "Health Potion"
maxHP = 30 --- Healths to bring
minHP = 10 --- Healths to leave

--========Other========================--
foodID = 3725 --- Food id to withdraw from 3rd BP in DP
minCap = 20 --- Cap to leave
extraCash = 0 --- Extra cash to withdraw just in case
staminaLogout = true --- logout at 16h stamina
dropVials = true -- Drop vials?
screenShot = true -- Take Screenshot at level?
bpReopen = true -- open backpacks after ss/kick ?

--========Optional=====================--
huntDragons = false --- Do you want to hunt at the single dragon-spawns?
huntHardcore = false --- Do you want to clear the quest room?

Looter.Start()
Targeting.Start()
registerEventListener(WALKER_SELECTLABEL, "onLabel")
print("[EK] Venore Shadowthorn\nBy\n[[COMPLEX SCRIPTS]]")
--========FUNCTIONS====================--
function onLabel(label)
	if (label == "Backpacks") then
		CS.OpenBackpacks()
	elseif (label == "Deposit") then
		Self.DepositItems({9635, 0}, {5921, 0}, {11464, 0}, {12806, 0}, {11467, 0}, {10291, 0}, {5913, 0}, {11465, 0}, {3738, 0}, {237, 0}, {5922, 0}, {3061, 0}, {9647, 0}, {3027, 0}, {3030, 0}, {11457, 0}, {5877, 0}, {5920, 0}, {3028, 0}, {5897, 0}, {10310, 0}, {9636, 0})
		Self.DepositItems({7438, 1}, {3052, 1}, {3082, 1}, {3073, 1}, {3037, 1}, {3661, 1}, {3415, 1}, {3062, 1}, {8050, 1}, {3071, 1}, {3322, 1}, {3297, 1}, {3416, 1}, {7430, 1}, {3067, 1}, {7449, 1})
	elseif (label == "Stamina") then
		CS.CheckStamina()
	elseif (label == "Bank") then	
		CS.Bank()
	elseif (label == "Withdraw") then
	    CS.Withdraw(foodID, 100, 2)
	elseif (label == "BuySupplies") then
		CS.BuySupplies()
	elseif(label == "PreCheck") then
		Walker.ConditionalGoto((Self.ItemCount(Item.GetID(mPots)) < maxMP) or (Self.ItemCount(Item.GetID(hPots)) < maxHP) , "Resupply", "ToHunt")
	elseif (label == "DoorNorth") then
		CS.OpenDoor("NORTH")		
	elseif (label == "DoorSouth") then
		CS.OpenDoor("SOUTH")		
	elseif (label == "DoorWest") then
		CS.OpenDoor("WEST")	
	elseif (label == "DoorEast") then
		CS.OpenDoor("EAST")	
	elseif (label == "Check1") then
		Walker.ConditionalGoto((Self.ItemCount(Item.GetID(mPots)) <= minMP) or (Self.ItemCount(Item.GetID(hPots)) <= minHP) or (Self.Cap() <= minCap), "Leave1", "Continue1")
	elseif(label == "Check") then
		Walker.ConditionalGoto((Self.ItemCount(Item.GetID(mPots)) <= minMP) or (Self.ItemCount(Item.GetID(hPots)) <= minHP) or (Self.Cap() <= minCap), "Leave", "Continue")
	elseif (label == "JumpToLeave") then
		Walker.Goto("Leave")
	elseif (label == "CheckDragon1") then
		Walker.ConditionalGoto(huntDragons, "Dragon1", "SkipDragon1")
	elseif (label == "CheckDragon2") then
		Walker.ConditionalGoto(huntDragons, "Dragon2", "SkipDragon2")
	elseif (label == "CheckHardcore") then
		Walker.ConditionalGoto(huntHardcore, "Hardcore", "SkipHardcore")
	end
end

--========MODULES========================--
if bpReopen then
	Module.Start('BP_Reconnect')
end

if dropVials then
	Module.Start('Drop_Vials')
end

if screenShot then
	Module.Start('Screenshot')
end

Module.Start('Move_Supplies')