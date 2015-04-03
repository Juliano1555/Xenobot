---------------------------------
----------Goroma Hydra-----------
------Created By Paralyze--------
---------Happy Hunting-----------
---------------------------------

----------- BP SETUP ------------
--~ [BP 1] ~-- Main
--~ [BP 2] ~-- Products
--~ [BP 3] ~-- Rares
--~ [BP 4] ~-- Gold

----------- DP SETUP ------------
--~ [DP 1] ~-- Rares
--~ [DP 2] ~-- Products

------------ Settings -----------

-- Mana Potions --
local ManasToLeave = 100				-- How many Mana Potion before leaving to refill
local WantedManas = 300 				-- Wanted amount of Mana Potions
local ManaPotID = 237 					-- Mana Potion ID
local ManaCost = 80 					-- Mana Potion Price

-- Health Potions
local HealthPotToLeave = 0             -- How many Health Potion before leaving to refill
local WantedHealths = 0 				-- Wanted amount of Health Potions
local HealthPotID = 7642 				-- Health Potion ID
local HealthCost = 190					-- Health Potion Price

-- Spears
local SpearsToLeave = 0                -- How many Spears before leaving to refill
local WantedSpears = 1                 -- How many Spears you start your hunt with
local SpearID = 6528                   -- The Spear ID
local SpearCost = 1                    -- Spear Price

-- Backpack Setup & Extra
local GoldBP = 0                     -- Item ID of your gold backpack. ( Default Brocade Backpack )
local MinCap = 25                       -- Leaves spawn when character reaches this cap.
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
    Goroma Hydra by Paralyze]]
    wait(5000)
	
    print([[
    Goroma Hydra by Paralyze]])
    wait(5000)
	
-----------------------------------------------------------------------------------------------------------------------------------------
function onWalkerSelectLabel(labelName)

	if (labelName == "Checker") then
	    if (Self.Cap() < MinCap) or ((Self.ItemCount(ManaPotID) < ManasToLeave)) or ((Self.ItemCount(HealthPotID) < HealthPotToLeave)) or ((Self.ItemCount(SpearID) <= SpearsToLeave))then
            gotoLabel("TownRefill")
        else
            gotoLabel("Spears")
		end

	elseif (labelName == "PotCheck") then
	    if (Self.Cap() < MinCap) or ((Self.ItemCount(ManaPotID) < WantedManas)) or ((Self.ItemCount(HealthPotID) < WantedHealths)) then
            gotoLabel("BuyPot")
        else
            gotoLabel("Spears")
		end
		
	elseif (labelName == "Deposit") then
		setWalkerEnabled(false)
		Self.ReachDepot()
		Self.DepositItems({3079, 3392, 3436, 3369, 3081, 3370, 3098})
		Self.DepositItems({10282, 1}, {3029, 1}, {4839, 1})
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
	Self.WithdrawMoney((ManaCost*(WantedManas-Self.ItemCount(ManaPotID))))
        sleep(math.random(300, 1000))
	Self.SayToNpc("yes")
        sleep(math.random(300, 1000))
	Self.SayToNpc("balance")
		setWalkerEnabled(true)
	elseif (labelName == "reachDepot") then		
		Self.ReachDepot()
	
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

	elseif (labelName == "SpearCash") then
		setWalkerEnabled(false)
		delayWalker(5000) --Stops walker so that the character doesn't move away from the NPC.
		Self.SayToNpc("hi")
		sleep(math.random(700, 1400)) --Sleep between everything the character says to avoid suspicion.
        Self.SayToNpc("deposit all")
        sleep(math.random(300, 1000))
        Self.SayToNpc("yes")
		Self.WithdrawMoney((SpearCost*(WantedSpears-Self.ItemCount(SpearID))))
		sleep(math.random(800, 1500))
		Self.SayToNpc("yes")
		setWalkerEnabled(true)
				
		elseif (labelName == "BuySpear") then
		Walker.Stop()
		Self.SayToNpc({"hi", "trade"}, 65)
		wait(1000)
		if (Self.ItemCount(SpearID) < (WantedSpears)) then
			Self.ShopBuyItemsUpTo(SpearID, WantedSpears)
		wait(100)
		Self.ShopBuyItemsUpTo(SpearID, WantedSpears)
		wait(100)
		Self.ShopBuyItemsUpTo(SpearID, WantedSpears)
		wait(100)
		Self.ShopBuyItemsUpTo(SpearID, WantedSpears)
		wait(100)
		end
		Walker.Start()	
		
   elseif (labelName == "FullCheck") then
		if (Self.Cap() < MinCap) or ((Self.ItemCount(ManaPotID) < WantedManas)) or ((Self.ItemCount(HealthPotID) < WantedHealths)) or ((Self.ItemCount(SpearID) < WantedSpears)) then
            gotoLabel("TownRefill")
        else
            gotoLabel("LetHunt")
		end

	elseif (labelName == "TravelGor") then
			delayWalker(10000)
		Self.SayToNpc({"hi", "Goroma", "yes"}, 65)
			sleep(math.random(2000, 3000))				

	elseif (labelName == "Up1") then
			delayWalker(100)
		Self.Say({"Exani tera"}, 65)
			sleep(math.random(2000, 3000))
			
	elseif (labelName == "SupplyCheck") then
	    if (Self.Cap() < MinCap) or ((Self.ItemCount(ManaPotID) < ManasToLeave)) or ((Self.ItemCount(HealthPotID) < HealthPotToLeave)) or ((Self.ItemCount(SpearID) <= SpearsToLeave))then
            gotoLabel("RefillMe")
        else
            gotoLabel("ContinueHunt")
		end

	elseif (labelName == "TravelLib") then
			delayWalker(10000)
		Self.SayToNpc({"hi", "Liberty Bay", "yes"}, 65)
			sleep(math.random(2000, 3000))

   elseif (labelName == "Ext") then
		if (Self.Cap() < minCap) or ((Self.ItemCount(ManaPotID) < ManasToLeave)) or ((Self.ItemCount(HealthPotID) < HealthPotToLeave)) or ((Self.ItemCount(SpearID) <= SpearsToLeave)) then
            gotoLabel("TownRefill")
        else
            gotoLabel("LetHunt")
		end
			
	elseif (labelName == "resetbp") then
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