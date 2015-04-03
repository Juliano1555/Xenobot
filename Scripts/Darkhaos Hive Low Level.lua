CapToLeave = 90

ManasToLeave = 100
HealthsToLeave = 50

RequiredManas = 300
RequiredHealths = 50

HealthID = 239
ManaID = 268

HealthPrice = 310
ManaPrice = 50

StaminaToLeave = 14 * 60 --in hours


LootBP = "blue backpack"
ProductBP = "red backpack"
SuppliesBP = "purple backpack"
MainBP = "backpack"

SoftBoots = false
SecondaryBoots = 4033

--Items to deposit
DepositItems =
{
	LootBP = --bp = 0
	{
		{3052, 0},
		{14087, 0},
		{3038, 0}, 
		{3326, 0},
		{14089, 0},
		{14089, 0},
		{14088, 0},
		{8084, 0},
		{3032, 0},
		{3055, 0},
		{3391, 0},
		{14086, 0},
		{14249, 0},
		{3554, 0},
		{7413, 0},
		{3036, 0},
		{14246, 0}
	},
	
	ProductBP = --bp 1
	{
		{3032, 1},
		{3029, 1},
		{14083, 1},
		{14076, 1},
		{14225, 1},
		{14080, 1},
		{14081, 1},
		{3010, 1},
		{14079, 1},
		{3033, 1},
		{14078, 1},
		{3030, 1},
		{9058, 1},
		{14077, 1},
		{281, 1},
		{282, 1},
		{14082, 1},
		{14172, 1},
		{3027, 1},
		{9057, 1}
	}
}

registerEventListener(WALKER_SELECTLABEL, "onWalkerSelectLabel")
setTargetingEnabled(true)
setLooterEnabled(true)

print([[
Hive Script by Darkhaos
]])

function onWalkerSelectLabel(labelName)

	if labelName == "Start" then
		Walker.Stop()
		if Self.ItemCount(ManaID) < RequiredManas or Self.ItemCount(HealthID) < RequiredManas then
			gotoLabel("GoToBank")
		end
		Self.CloseContainers()
		sleep(math.random(800, 1200))
		Self.OpenMainBackpack(true):OpenChildren({Item.GetID(LootBP),true}, {Item.GetID(ProductBP), true}, {Item.GetID(SuppliesBP), true})
		wait(2000,4000)
		if Self.Stamina() > StaminaToLeave then
			Walker.Start()
		else
			return true
		end
	elseif labelName == "TalkWithBank" then
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
		Self.SayToNpc("withdraw")
		sleep(math.random(954, 2117))
		
		local moneyManas = math.max((RequiredManas - Self.ItemCount(ManaID)) * ManaPrice, 0)
		local moneyHealths = math.max((RequiredHealths - Self.ItemCount(HealthID)) * HealthPrice, 0)
		local total = moneyManas + moneyHealths
		if SoftBoots and Self.ItemCount(3549) < 1 and Self.ItemCount(6529) < 1 and Self.ItemCount(6530) > 0 then
			total = total + 10500 --10000 for boots and 500 for travel?
		end
		--total = total + 100000 --for blessings in case of dead
		if total > 0 then
			Self.WithdrawMoney(total)
		end
		sleep(math.random(957, 2025))
		Self.SayToNpc("balance")
		Walker.Start()
	elseif labelName == "CheckForPots" then
		Walker.Stop()
		if Self.ItemCount(ManaID) < RequiredManas or Self.ItemCount(HealthID) < RequiredManas then
			gotoLabel("GoBuyPots")
		else
			gotoLabel("GoToCave")
		end
		Walker.Start()
	elseif labelName == "Hunt" then
		Walker.Stop()
		if SoftBoots then
			if Self.ItemCount(6529) > 0 then
				Self.Equip(6529, "feet")
			end
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
			if requiredManas > 0 then
				repeat
					Self.ShopBuyItem(ManaID, requiredManas)
				until Self.ItemCount(ManaID) > requiredManas - 10
			end
			if requiredHealths > 0 then
				repeat
					Self.ShopBuyItem(HealthID, requiredHealths)
				until Self.ItemCount(HealthID) > requiredHealths - 5
			end
			sleep(math.random(600, 1000))
			--MOVE POTS TO SUP BP
			local mainBp = Container.GetByName(MainBP) 
			local supBp = Container.GetByName(SuppliesBP)
			while (mainBp:CountItemsOfID(ManaID) > 0) do
				for spot = 0, mainBp:ItemCount() do
					local item = mainBp:GetItemData(spot) 
					if (item.id == ManaID) then
						mainBp:MoveItemToContainer(spot, supBp:Index(), 0) 
						wait(500, 1500) 
						break
					end
				end
			end
			sleep(math.random(600, 1000))
			while (mainBp:CountItemsOfID(HealthID) > 0) do
				for spot = 0, mainBp:ItemCount() do
					local item = mainBp:GetItemData(spot) 
					if (item.id == HealthID) then
						mainBp:MoveItemToContainer(spot, supBp:Index(), 0) 
						wait(500, 1500) 
						break
					end
				end
			end
			sleep(math.random(600, 1000))
		end
		Walker.Start()
	elseif labelName == "Check" then
		Walker.Stop()
		if Self.ItemCount(ManaID) <= ManasToLeave or Self.ItemCount(HealthID) <= HealthsToLeave or Self.Cap() <= CapToLeave or Self.Stamina() <= StaminaToLeave then
			gotoLabel("Leave")
		else
			gotoLabel("Hunt")
		end
		Walker.Start()
	elseif labelName == "BankDeposit" then
		Walker.Stop()
		if Self.Money() > 0 then
			Self.SayToNpc("hi")
			sleep(math.random(1000, 2117))
			Self.SayToNpc("deposit all")
			sleep(math.random(954, 2117))
			Self.SayToNpc("yes")
			sleep(math.random(500, 900))
		end
		if SoftBoots then
			Self.Equip(SecondaryBoots, "feet")
		end
		Walker.Start()
	elseif labelName == "Depot" then
		Walker.Stop()
		Self.CloseContainers()
		sleep(math.random(800, 1200))
		Self.OpenMainBackpack(true):OpenChildren({Item.GetID(LootBP),true}, {Item.GetID(ProductBP), true}, {Item.GetID(SuppliesBP), true})
		wait(2000,4000)
		
		Self.ReachDepot()
		local bp = Container.New(Item.GetID(LootBP))
		local start = os.time()
		repeat
			Self.DepositItems({3052, 0}, {14087, 0}, {3038, 0}, {3326, 0}, {14089, 0}, {14089, 0}, {14088, 0}, {8084, 0}, {3032, 0}, {3055, 0}, {3391, 0}, {14086, 0}, {14249, 0}, {3554, 0}, {7413, 0}, {3036, 0}, {14246, 0})
			bp:UseItem(((bp:ItemCount() - 1) > 0 and (bp:ItemCount() - 1) or 0), true)
			wait(1000)
		until (bp:ItemCount() - 1) < 1
		bp = Container.New(Item.GetID(ProductBP))
		start = os.time()
		repeat
			Self.DepositItems({3032, 1}, {3029, 1}, {14083, 1}, {14076, 1}, {14225, 1}, {14080, 1}, {14081, 1}, {3010, 1}, {14079, 1}, {3033, 1}, {14078, 1}, {3030, 1}, {9058, 1}, {14077, 1}, {281, 1}, {282, 1}, {14082, 1}, {14172, 1}, {3027, 1}, {9057, 1})
			bp:UseItem(((bp:ItemCount() - 1) > 0 and (bp:ItemCount() - 1) or 0), true)
			wait(1000)
		until (bp:ItemCount() - 1) < 1
		--[[for i = 1, 3 do
			Self.DepositItems({3052, 0}, {14087, 0}, {3038, 0}, {3326, 0}, {14089, 0}, {14089, 0}, {14088, 0}, {8084, 0}, {3032, 0}, {3055, 0}, {3391, 0}, {14086, 0}, {14249, 0}, {3554, 0}, {7413, 0}, {3036, 0}, {14246, 0})
			bp:UseItem(((bp:ItemCount() - 1) > 0 and (bp:ItemCount() - 1) or 0), true)
			wait(1000)
		end
		bp = Container.New(Item.GetID(ProductBP))
		for i = 1, 2 do
			Self.DepositItems({3032, 1}, {3029, 1}, {14083, 1}, {14076, 1}, {14225, 1}, {14080, 1}, {14081, 1}, {3010, 1}, {14079, 1}, {3033, 1}, {14078, 1}, {3030, 1}, {9058, 1}, {14077, 1}, {281, 1}, {282, 1}, {14082, 1}, {14172, 1}, {3027, 1}, {9057, 1})
			bp:UseItem(((bp:ItemCount() - 1) > 0 and (bp:ItemCount() - 1) or 0), true)
			wait(1000)
		end]]
		sleep(math.random(1500, 2324))
		gotoLabel("Start")
		Walker.Start()
	end
end

Self.ReachDepot = function(tries)
	local tries = tries or 5
	
	while(tries > 0) do
		local ret = Self.GoToDepot()
		if ret then return true end
		tries = tries - 1
		wait(1000)
		printf("Attempt to reach depot was unsuccessfull. " .. tries .. " tries left.")
	end
	
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

Self.GoToDepot = function()
	local DepotIDs = {3497, 3498, 3499, 3500}
    local DepotPos = {}
	local depotTries = 0
	for _, id in ipairs(DepotIDs) do
		local d = Map.GetUseItems(id)
		for _, pos in ipairs(d) do
			table.insert(DepotPos, pos)
		end
	end
	
	print("Found " .. #DepotPos .. " depots.")
	for _, pos in ipairs(DepotPos) do
		depotTries = depotTries + 1
		Self.UseItemFromGround(pos.x, pos.y, pos.z)
		wait(3000)
		if Self.DistanceFromPosition(pos.x, pos.y, pos.z) <= 1 then --depot reached
			Walker.Start()
			return true
		else
			print("Something is blocking the path. Trying next depot (" .. depotTries .. ")")
		end
	end
	return false
end

