RequiredManas = 300
ManaID = 268
ManaPrice = 45
ManasToLeave = 15

RequiredHealths = 50
HealthID = 239
HealthPrice = 190
HealthsToLeave = 5

CapToLeave = 10
StaminaToLeave = 16 * 60

LootBP = "brocade backpack" --loot
ProductBP = "red backpack" --creature products


registerEventListener(WALKER_SELECTLABEL, "onWalkerSelectLabel")
setTargetingEnabled(true)
setLooterEnabled(true)


print([[
Darashia DLs Script by Darkhaos
Version 2.0.0
]])

function onWalkerSelectLabel(labelName)

	if labelName == "Start" then
		Walker.Stop()
		Self.CloseContainers()
		sleep(math.random(800, 1200))
		Self.OpenMainBackpack(true):OpenChildren({Item.GetID(LootBP),true}, {Item.GetID(ProductBP), true})
		wait(2000,4000)
		Walker.Start()
	elseif labelName == "TalkWithBank" then
		local requiredMoneyManas = math.max((RequiredManas - Self.ItemCount(ManaID)) * ManaPrice, 0)
		local requiredMoneyHealths = math.max((RequiredHealths - Self.ItemCount(HealthID)) * HealthPrice, 0)
		local total = requiredMoneyManas + requiredMoneyHealths
		Walker.Stop()
		Self.SayToNpc("hi")
		sleep(math.random(1000, 2117))
		if Self.Money() > 0 then
			Self.SayToNpc("deposit")
			sleep(math.random(1000, 2117))
			Self.SayToNpc(Self.Money())
			sleep(math.random(1000, 2117))
			Self.SayToNpc("yes")
			sleep(math.random(1000, 2117))
		end
		if total > 0 then
			Self.WithdrawMoney(total)
			sleep(math.random(1000, 2114))
		end
		Self.SayToNpc("balance")
		sleep(math.random(1000, 2115))
		if Self.Money() > 0 then
			Walker.Goto("GoBuyPots")
		else
			Walker.Goto("NothingToDo")
		end
		Walker.Start()
	elseif labelName == "CheckForPots" then
		local rManas = RequiredManas - Self.ItemCount(ManaID)
		local rHealths = RequiredHealths - Self.ItemCount(HealthID)
		if rManas < 1 then rManas = 0 end
		if rHealths < 1 then rHealths = 0 end
		
		Walker.Stop()
		if rManas > 0 or rHealths > 0 then
			Walker.Goto("GoBuyPots")
		end
		Walker.Start()
	elseif labelName == "BuyPotions" then
		local requiredManas = math.max(RequiredManas - Self.ItemCount(ManaID), 0)
		local requiredHealths = math.max(RequiredHealths - Self.ItemCount(HealthID), 0)
		if requiredManas > 0 or requiredHealths > 0 then
			Walker.Stop()
			Self.SayToNpc("hi")
			sleep(math.random(1000, 1500))
			Self.SayToNpc("trade")
			sleep(math.random(500, 800))
			if requiredHealths > 0 then
				Self.ShopBuyItem(HealthID, requiredHealths)
			end
			if requiredManas > 0 then
				Self.ShopBuyItem(ManaID, requiredManas)
			end
			sleep(math.random(600, 1000))
		end
		Walker.Start()
	elseif labelName == "DoorEnter" then
		Walker.Stop()
		local door = Map.GetUseItems(5293)
		if #door > 0 then
			Self.UseDoor(door[1].x, door[1].y, door[1].z)
		end
		Walker.Start()
	elseif labelName == "DoorExit" then
		Walker.Stop()
		local door = Map.GetUseItems(5293)
		if #door > 0 then
			Self.UseDoor(door[1].x, door[1].y, door[1].z)
		end
		Walker.Start()
	elseif labelName == "Check" then
		Walker.Stop()
		if Self.ItemCount(ManaID) <= ManasToLeave or Self.ItemCount(HealthID) <= HealthsToLeave or Self.Cap() <= CapToLeave or Self.Stamina() <= StaminaToLeave then
			Walker.Goto("Leave")
		else
			Walker.Goto("Hunt")
		end
		Walker.Start()
	elseif labelName == "Depot" then
		Walker.Stop()
		Self.CloseContainers()
		sleep(math.random(800, 1200))
		Self.OpenMainBackpack(true):OpenChildren({Item.GetID(LootBP),true}, {Item.GetID(ProductBP), true})
		wait(2000,4000)
		Self.ReachDepot()
		sleep(math.random(800, 1000))
        Self.DepositItems({3386, 0},{3392, 0},{3280, 0},{7402, 0},{3428, 0},{7399, 0},{3416, 0},{3322, 0})
		Self.DepositItems({3029, 1},{5882, 1},{5948, 1},{5877, 1},{5920, 1})
		sleep(math.random(1500, 2324))
		Self.CloseContainers()
		sleep(math.random(800, 1200))
		Self.OpenMainBackpack(true):OpenChildren({Item.GetID(LootBP),true}, {Item.GetID(ProductBP), true})
		wait(2000,4000)
		Walker.Goto("Start")
		Walker.Start()
	end
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