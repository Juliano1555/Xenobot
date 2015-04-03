---------------------------------
-------Venore Swamp Trolls-------
----By Xiaospike & Joshwa534-----
-------Scripted by Kopper--------
------------Enjoy!!!-------------
---------------------------------     

--------- BP SETUP ----------
-- [BP 1] - Main/Stackables
-- [BP 2] - Rares
-- [BP 3] - Gold

--------- DP SETUP ----------
-- [DP 1] - Rares

------ REFILL SETTINGS ------
local MinHealth = 2 --- How many health potions until you leave the hunt.
local MaxHealth = 15  --- How many health potions you begin the hunt with.
------- HUNT SETTINGS --------
local LootBP = "red backpack"
local GoldBP = "green backpack" --- Item ID of your gold backpack. (Default is brocade backpack)
local MinCap = 20 --- Leaves spawn when character reaches this cap.
------- EXTRA SETTINGS -------
local HideEquipment = true --- Do you want to minimize your equipment?
local LogoutStamina = false --- Do you want to logout at 16 hours? (Inside the depot)

local HealthID = 266

--------------------------------------------------------------------
--------------------------------------------------------------------
--------------------------------------------------------------------
--------------------------------------------------------------------
--------------------------------------------------------------------

Targeting.Start()
Looter.Start()

registerEventListener(WALKER_SELECTLABEL, "onWalkerSelectLabel")

    print([[
    Venore Swamp Trolls by Xiaospike & Joshwa534
	Scripted by Kopper]])
    wait(5000)

function onWalkerSelectLabel(labelName)
	if (labelName == "Checker") then
		Walker.ConditionalGoto((Self.Cap() < MinCap) or (Self.ItemCount(HealthID) <= MinHealth) or ((LogoutStamina) and (Self.Stamina() < 840)), "Leave", "Hunt")

	elseif (labelName == "Potions") then
		Walker.Stop()
		if (Self.ItemCount(HealthID) < MaxHealth) then
			Self.SayToNpc({"hi", "flasks", "yes", "yes", "yes", "yes", "yes", "yes", "trade"}, 65)
			wait(2000)
			if (Self.ItemCount(HealthID) < MaxHealth) then
				BuyItems(HealthID, MaxHealth)
				wait(500)
			end
			wait(200, 500)
		end
		Walker.Start()

	elseif (labelName == "CheckStuff") then
		Walker.ConditionalGoto((Self.ItemCount(HealthID) < MaxHealth), "Bank", "ToHunt")

	elseif (labelName == "Bank") then
		local withdrawHealths = math.max(MaxHealth - Self.ItemCount(HealthID), 0)*45
		local totalmoneyneeded = (withdrawHealths - Self.ItemCount(285)*5)
		local MATHCEIL = (totalmoneyneeded)
		Walker.Stop()
		Self.SayToNpc({"hi", "deposit all", "yes"}, 65)
		if (totalmoneyneeded > 0) then
			Self.SayToNpc({"withdraw " .. MATHCEIL, "yes", "balance"}, 65)   
		end  
		wait(2000)
		Walker.Start()
		
	elseif (labelName == "Deposit") then
	
		Walker.Stop()
		Self.CloseContainers()
		sleep(math.random(800, 1200))
		Self.OpenMainBackpack(true):OpenChildren({Item.GetID(LootBP),true}, {Item.GetID(GoldBP), true})
		wait(2000,4000)
		
		Self.ReachDepot()
		local bp = Container.New(Item.GetID(LootBP))
		
		repeat
			Self.DepositItems({12517,0})
			bp:UseItem(((bp:ItemCount() - 1) > 0 and (bp:ItemCount() - 1) or 0), true)
			wait(1000)
		until (bp:ItemCount() - 1) < 1
		
		Self.DepositItems({9686,1}, {5894, 1})
		wait(1000)
		Self.WithdrawItems(1, {HealthID, 0,(MaxHealth-Self.ItemCount(HealthID))})
		wait(1000)
		Self.CloseContainers()
		wait(1000)
		Self.OpenMainBackpack(true):OpenChildren({Item.GetID(LootBP),true}, {Item.GetID(GoldBP), true})
		if (LogoutStamina) and (Self.Stamina() < 960) then
			Walker.Stop()
		else
			Walker.Start()
		end

	elseif (labelName == "ResetBP") then
		Walker.Stop()
		Self.CloseContainers()
		wait(1000)
		Self.OpenMainBackpack(true):OpenChildren({Item.GetID(LootBP),true}, {Item.GetID(GoldBP), true})
		wait(1000)
		if (HideEquipment) then
			Client.HideEquipment()
			wait(1000)
		end
		Walker.Start()	
	end
end

----------------------- Functions ----------------------
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

Self.DepositBackpack = function(id, data)
	local bp = Container.New(id)
	local deposited = {}
	local list = {}
	if not bp:isOpen() then return false end
	for spot = 0, bp:ItemCount() do	
		local item = bp:GetItemData(spot)
		for _, dt in ipairs(data) do
			if item.id == dt[1] and not isInArray(deposited, item.id) then --item id in list
				table.insert(deposited, item.id)
				table.insert(list, {item.id, data[2]})
			end
		end
	end	
	local start = os.time()
	repeat
		Self.DepositItems(list)
		bp:UseItem(((bp:ItemCount() - 1) > 0 and (bp:ItemCount() - 1) or 0), true)
		wait(1000)
	until (bp:ItemCount() - 1) < 1 or os.time() - start >= 90 --90 seconds depositing
	return true
end