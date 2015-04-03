---------------------------------
-------Thais Undead Cave---------
------Created By Paralyze--------
---------Happy Hunting-----------
---------------------------------

----------- BP SETUP ------------
--~ [BP 1] ~-- Main
--~ [BP 2] ~-- Creature Loot
--~ [BP 3] ~-- Gold BP
----------- DP SETUP ------------
--~ [DP 1] ~-- Products
--~ [DP 2] ~-- Items

------------ Settings -----------

-- Mana Potions --
local ManasToLeave = 10				-- How many Mana Potion before leaving to refill
local WantedManas = 50 				-- Wanted amount of Mana Potions
local ManaPotID = 268 					-- Mana Potion ID
local ManaCost = 50 					-- Mana Potion Price

-- Health Potions
local HealthPotToLeave = -1             -- How many Health Potion before leaving to refill
local WantedHealths = 0 				-- Wanted amount of Health Potions
local HealthPotID = 266 				-- Health Potion ID
local HealthCost = 45 					-- Health Potion Price

-- Backpack Setup & Extra
local GoldBP = Item.GetID('red backpack')                     -- Item ID of your gold backpack. ( Default Brocade Backpack )
local MinCap = 10                       -- Leaves spawn when character reaches this cap.
local HideEquipment = true              -- Do you want to minimize your equipment?

Targeting.Start()
Looter.Start()

--------------------------------------------------------------------
--------------------------------------------------------------------
--------------------------------------------------------------------
--------------------------------------------------------------------
--------------------------------------------------------------------

registerEventListener(WALKER_SELECTLABEL, "onWalkerSelectLabel")

local info = [[
    Thais Undead Cave by Paralyze]]
    wait(5000)
	
    print([[
    Thais Undead Cave by Paralyze]])
    wait(5000)
	
-----------------------------------------------------------------------------------------------------------------------------------------
function onWalkerSelectLabel(labelName)

	if (labelName == "Checker1") then
	    if (Self.Cap() < MinCap) or ((Self.ItemCount(ManaPotID) < ManasToLeave)) or ((Self.ItemCount(HealthPotID) < HealthPotToLeave)) then
            gotoLabel("GoTown")
        else
            gotoLabel("StartHunt")
		end

	elseif (labelName == "FullCheck") then
	    if (Self.Cap() < MinCap) or ((Self.ItemCount(ManaPotID) < WantedManas)) or ((Self.ItemCount(HealthPotID) < WantedHealths)) then
            gotoLabel("Return")
        else
            gotoLabel("GoHunt")
		end
		
	elseif (labelName == "Door1") then
		setWalkerEnabled(false)
		delayWalker(3000)
		Self.UseItemFromGround(32400, 32217, 7)
		wait(300,600)
		setWalkerEnabled(true)
		
	elseif (labelName == "CheckDoor1") then
		if (Self.Position().x == 32400 and Self.Position().y == 32217 and Self.Position().z == 7) then
       		gotoLabel("DoneDoor1")
        else
			gotoLabel("Door1")
		end
		
	elseif (labelName == "Deposit") then
		setWalkerEnabled(false)
		Self.ReachDepot()
		Self.DepositItems(7398, 3052, 3093, 9657, 11481, 11484, 5913, 10291, 11467)
		wait(1500,1900)

	elseif (labelName == "Bank") then
		setWalkerEnabled(false)
        delayWalker(5000)
        Self.Say("hi")
        sleep(math.random(700, 1400))
        Self.SayToNpc("deposit all")
        sleep(math.random(300, 1000))
        Self.SayToNpc("yes")
	    sleep(math.random(300, 1000))
	Self.SayToNpc("balance")
		setWalkerEnabled(true)
		
	elseif (labelName == "Withdraw") then
		setWalkerEnabled(false)
        delayWalker(5000)
        Self.Say("hi")
        sleep(math.random(700, 1400))
        Self.SayToNpc("deposit all")
        sleep(math.random(300, 1000))
        Self.SayToNpc("yes")
        sleep(math.random(300, 1000))
	Self.WithdrawMoney((ManaCost*(WantedManas-Self.ItemCount(ManaPotID)))+200)
        sleep(math.random(300, 1000))
	Self.SayToNpc("yes")
        sleep(math.random(300, 1000))
	Self.WithdrawMoney((HealthCost*(WantedHealths-Self.ItemCount(HealthPotID)))+200)
	    sleep(math.random(300, 1000))
	Self.SayToNpc("yes")
	    sleep(math.random(300, 1000))
	Self.SayToNpc("balance")
		setWalkerEnabled(true)
		
	elseif (labelName == "Potions") then
		setWalkerEnabled(false)
		delayWalker(10000) --Stops walker so that the character doesn't move away from the NPC.
		Self.SayToNpc("hi")
		sleep(math.random(800, 1700)) --Sleep between everything the character says to avoid suspicion.
		Self.SayToNpc({"Hi", "flasks", "yes", "yes", "yes", "Trade"}, 65)
		sleep(math.random(800, 1700)) --Sleep between everything the character says to avoid suspicion.
		Self.SayToNpc("trade")
		sleep(math.random(2000, 2400)) --Sleep between everything the character says to avoid suspicion.
        Self.ShopBuyItem(ManaPotID, (WantedManas-Self.ItemCount(ManaPotID)))
		sleep(math.random(2000, 2400)) --Sleep between everything the character says to avoid suspicion.
        Self.ShopBuyItem(HealthPotID, (WantedHealths-Self.ItemCount(HealthPotID)))
		sleep(math.random(800, 1700))
		setWalkerEnabled(true)
		
	elseif (labelName == "ResetBp") then
		Walker.Stop()
		Container.Close(GoldBP)
		wait(1000)		
		Container.GetFirst():OpenChildren(GoldBP)
		wait(1000)
		Container.GetByName(GoldBP):Minimize()
		if (HideEquipment) then
			Client.HideEquipment()
			wait(1000)
		end
		Walker.Start()	
	end
end

----------------------- Functions ----------------------
function SellItems(item) -- item = item ID
	wait(300, 1700)
	Self.ShopSellItem(item, Self.ShopGetItemSaleCount(item))
	wait(900, 1200)
end

function BuyItems(item, count) -- item = item id, count = how many you want to buy up to
	wait(900, 1200)
	if (Self.ItemCount(item) < count) then
	Self.ShopBuyItem(item, (count-Self.ItemCount(item)))
	wait(200, 500)
	end
end

Self.ReachDepot = function (tries)
	local tries = tries or 3
	Walker.Stop()
	local DepotIDs = {3497, 3498, 3499, 3500}
	local DepotPos = {}
	for i = 1, #DepotIDs do
		local dps = Map.GetUseItems(DepotIDs[i])
		for j = 1, #dps do
			table.insert(DepotPos, dps[j])
		end
	end
	local function gotoDepot()
		local pos = Self.Position()
		print("Depots found: " .. tostring(#DepotPos))
		for i = 1, #DepotPos do
			location = DepotPos[i]
			Self.UseItemFromGround(location.x, location.y, location.z)
			wait(1000, 2000)
			if Self.DistanceFromPosition(pos.x, pos.y, pos.z) >= 1 then
				wait(5000, 6000)
				if Self.DistanceFromPosition(location.x, location.y, location.z) == 1 then
					Walker.Start()
					return true
				end
			else
				print("Something is blocking the path. Trying next depot.")
			end
		end
		return false
	end
	
	repeat
		reachedDP = gotoDepot()
		if reachedDP then
			return true
		end
		tries = tries - 1
		sleep(100)
		print("Attempt to reach depot was unsuccessfull. " .. tries .. " tries left.")
	until tries <= 0

	return false
end

Map.GetUseItems = function (id)
    if type(id) == "string" then
        id = Item.GetID(id)
    end
    local pos = Self.Position()
	local store = {}
    for x = -7, 7 do
        for y = -5, 5 do
            if Map.GetTopUseItem(pos.x + x, pos.y + y, pos.z).id == id then
                itemPos = {x = pos.x + x, y = pos.y + y, z = pos.z}
				table.insert(store, itemPos)
            end
        end
    end
    return store
end