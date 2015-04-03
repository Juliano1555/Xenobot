---------------------------------
-----Yalahar Minos or Elves------
----By Xiaospike & Joshwa534-----
------------Enjoy!!!-------------
---------------------------------

--------- BP SETUP ----------
-- [BP 1] - Main + Rares
-- [BP 2] - Products
-- [BP 3] - Gold

--------- DP SETUP ----------
-- [DP 1] - Rares
-- [DP 2] - Products

------ REFILL SETTINGS ------
local MinMana = 10 --- How many mana potions until you leave the hunt.
local MaxMana = 30 --- How many mana potions you begin the hunt with.

local MinHealth = 10 --- How many health potions until you leave the hunt.
local MaxHealth = 20 --- How many health potions you begin the hunt with.


local MinCap = 5 --- Leaves spawn when character reaches this cap.
local HideEquipment = true --- Do you want to minimize your equipment?
local LogoutStamina = true --- Do you want to logout at 16 hours? (Inside the depot)

local MaxAmmo = 18 --- How many spears you begin the hunt with.
local MinAmmo = 5 --- How many spears left when you leave the hunt.

----- LOCATION SETTINGS -----
local Elves = false --- Do you want to hunt the Elves?

local GoldBP = "brocade backpack"
local LootBP = "blue backpack"

--------------------------------------------------------------------
--------------------------------------------------------------------
--------------------------------------------------------------------
-------------------- DO NOT TOUCH THIS CODE ------------------------
---------------------- IF YOU DO NOT KNOW --------------------------
---------------------- WHAT YOU ARE DOING --------------------------
--------------------------------------------------------------------
--------------------------------------------------------------------
--------------------------------------------------------------------
 
registerEventListener(WALKER_SELECTLABEL, "onWalkerSelectLabel")
 
    print([[
    Yalahar Minotaurs or Elves by Xiaospike & Joshwa534]])
    wait(5000)
       
function onWalkerSelectLabel(labelName) 
    if (labelName == "checker1") then
		Walker.ConditionalGoto((Self.ItemCount(268) <= MinMana) or (Self.Cap() < MinCap) or (Self.ItemCount(266) <= MinHealth) or (Self.ItemCount(7378) <= MinAmmo) or ((LogoutStamina) and (Self.Stamina() < 840)), "leave1", "keepHunting1")

	elseif (labelName == "checker2") then
		Walker.ConditionalGoto((Self.ItemCount(268) <= MinMana) or (Self.Cap() < MinCap) or (Self.ItemCount(266) <= MinHealth) or (Self.ItemCount(7378) <= MinAmmo) or ((LogoutStamina) and (Self.Stamina() < 840)), "leave2", "keepHunting2")
			
	elseif (labelName == "checkHuntSpot") then
		Walker.ConditionalGoto((Elves), "toElves", "toMinos")
		Self.Equip(6529, "feet")
				
	elseif (labelName == "GotoTown") then
		Walker.Goto("toTown")		
               
    elseif (labelName == "checkstuff") then
		local ESTMana = (MaxMana-20)
		Walker.ConditionalGoto((Self.ItemCount(268) < MaxMana) or (Self.ItemCount(266) < MaxHealth) or (Self.ItemCount(7378) < MaxAmmo), "resupply", "tohunt")
			
	elseif (labelName == "bank") then
		
		local moneyManas = (MaxMana - Self.ItemCount(268)) * 50
		local moneyHealths = (MaxHealth - Self.ItemCount(266)) * 45
		local moneyAmmo = (MaxAmmo - Self.ItemCount(7378)) * 15
		if moneyManas < 1 then moneyManas = 0 end
		if moneyHealths < 1 then moneyHealths = 0 end
		if moneyAmmo < 1 then moneyAmmo = 0 end
		local total = moneyManas + moneyHealths + moneyAmmo
		Walker.Stop()
		Self.SayToNpc({"hi", "deposit all", "yes"}, 65)
		wait(2000)
		if (total > 0) then
			Self.WithdrawMoney(total) 
		end  
		wait(2000)
		Walker.Start()
 
    elseif (labelName == "deposit") then
        Walker.Stop()
        Self.ReachDepot()
        Self.DepositItems({7438, 0}, {3073, 0}, {3037, 0}, {7401, 0}, {7425, 0}, {3082, 0})
        Self.DepositItems({5922, 1},{5921, 1},{11473, 1},{11465, 1}, {3061, 1}, {237, 1}, {5878, 1}, {11472, 1}, {11464, 1}, {11482, 1}, {9635, 1}, {11451, 1}, {11483, 1})
		Self.DepositItems({285, 0})
		if (LogoutStamina) and (Self.Stamina() < 960) then
			Walker.Stop()
		else
			Walker.Start()
		end
 
 	elseif (labelName == "potions") then
		Walker.Stop()
		if (Self.ItemCount(268) < MaxMana) or (Self.ItemCount(266) < MaxHealth) then
			Self.SayToNpc({"hi", "flasks", "yes", "yes", "yes", "yes", "yes", "yes", "trade"}, 65)
			wait(2000)
			if (Self.ItemCount(268) < MaxMana) then
				BuyItems(268, MaxMana)
				wait(500)			
			end
			if (Self.ItemCount(266) < MaxHealth) then
				BuyItems(266, MaxHealth)
				wait(500)
			end
			wait(200, 500)
		end
		Walker.Start()

	elseif (labelName == "buyammo") then
		Walker.Stop()
		Self.SayToNpc({"hi", "trade"}, 65)
		wait(1000)
		if (Self.ItemCount(7378) < (MaxAmmo)) then
			BuyItems(7378, MaxAmmo)
			wait(500)
		end
		Walker.Start()
				
	elseif (labelName == "resetbp") then
		Walker.Stop()
		Self.CloseContainers()
		sleep(math.random(800, 1200))
		Self.OpenMainBackpack(true):OpenChildren({Item.GetID(LootBP),true}, {Item.GetID(GoldBP), true})
		wait(1000)
		Container.GetByName(GoldBP):Minimize()
		Container.GetByName(LootBP):Minimize()
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