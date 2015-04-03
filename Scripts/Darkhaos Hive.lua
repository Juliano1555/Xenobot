Supplies =
{
	{id = 268, required = 1500, toLeave = 200, price = 50},
	{id = 7643, required = 300, toLeave = 70, price = 310}
}

CapToLeave = 90

StaminaToLeave = 14 * 60 --in hours

LootBP = "blue backpack"
ProductBP = "red backpack"
SuppliesBP = "purple backpack"
MainBP = "backpack of holding"

SoftBoots = true
SecondaryBoots = Item.GetID("depth calcei")

registerEventListener(WALKER_SELECTLABEL, "onWalkerSelectLabel")
setTargetingEnabled(true)
setLooterEnabled(true)

print([[
Hive Script by Darkhaos
]])

--wagon 7132

function onWalkerSelectLabel(labelName)

	if labelName == "Start" then
		Walker.Stop()		
		Self.CloseContainers()
		sleep(math.random(800, 1200))
		Self.OpenMainBackpack(true):OpenChildren({Item.GetID(LootBP),true}, {Item.GetID(ProductBP), true}, {Item.GetID(SuppliesBP), true})
		wait(3000)
		
		for _, supply in ipairs(Supplies) do
			if Self.ItemCount(supply.id) < supply.required then
				gotoLabel("GoToBank")
				break
			end
		end
		
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
			Self.DepositMoney()
			sleep(math.random(1000, 2117))
		end
		
		local MoneyRequired = 0
		for _, supply in ipairs(Supplies) do
			MoneyRequired = MoneyRequired + math.max((supply.required - Self.ItemCount(supply.id)) * supply.price, 0)
		end
		MoneyRequired = MoneyRequired + 100000
		
		
		Self.WithdrawMoney(MoneyRequired)
		sleep(math.random(954, 2117))
		Self.SayToNpc("balance")
		Walker.Start()
	elseif labelName == "CheckForPots" then
		Walker.Stop()
		local go = false
		for _, supply in ipairs(Supplies) do
			if Self.ItemCount(supply.id) < supply.required then
				go = true
				break
			end
		end
		if go then
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
	
		local buy = false
		for _, supply in ipairs(Supplies) do
			if math.max(supply.required - Self.ItemCount(supply.id), 0) > 0 then
				buy = true
				break
			end
		end
		
		if buy then
			Walker.Stop()
			Self.SayToNpc("hi")
			sleep(math.random(1000, 1500))
			Self.SayToNpc("trade")
			sleep(math.random(500, 800))
			local started
			for _, supply in ipairs(Supplies) do
				if math.max(supply.required - Self.ItemCount(supply.id), 0) > 0 then
					started = os.time()
					repeat
						Self.ShopBuyItem(supply.id, math.max(supply.required - Self.ItemCount(supply.id), 0))
						wait(1000)
					until Self.ItemCount(supply.id) >= supply.required or (os.time() - started) >= 10
				end
			end
			wait(1000)
			--MOVE POTS TO SUP BP
			local mainBp = Container.GetByName(MainBP) 
			local supBp = Container.GetByName(SuppliesBP)
			for _, supply in ipairs(Supplies) do
				started = os.time()
				while (mainBp:CountItemsOfID(supply.id) > 0 and (os.time() - started) < 15) do
					for spot = 0, mainBp:ItemCount() do
						local item = mainBp:GetItemData(spot) 
						if item.id == supply.id then
							mainBp:MoveItemToContainer(spot, supBp:Index(), 0) 
							wait(500) 
							break
						end
					end
				end
				wait(1000)
			end
		end
		Walker.Start()
	elseif labelName == "Check" then
		Walker.Stop()
		local hunt = true
		for _, supply in ipairs(Supplies) do
			if Self.ItemCount(supply.id) <= supply.toLeave or Self.Cap() <= CapToLeave or Self.Stamina() <= StaminaToLeave then
				hunt = false
				break
			end
		end
		if not hunt then
			gotoLabel("Leave")
		else
			gotoLabel("Hunt")
		end
		Walker.Start()
	elseif labelName == "BankDeposit" then
		Walker.Stop()
		Self.SayToNpc("hi")
		wait(1000)
		Self.DepositMoney()
		wait(1000)
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
			Self.DepositItems({3052, 0}, {14087, 0}, {3038, 0}, {3326, 0}, {14089, 0}, {14089, 0}, {14088, 0}, {8084, 0}, {3055, 0}, {3391, 0}, {14086, 0}, {14249, 0}, {3554, 0}, {7413, 0}, {3036, 0}, {14246, 0})
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
	

--[[Self.ReachDepot = function (tries)
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
            wait(3000)
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
end]]

