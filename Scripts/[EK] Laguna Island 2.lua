Supplies =
{
	{id = 268, required = 150, toLeave = 10, price = 50},
	{id = 236, required = 50, toLeave = 5, price = 100}
}

CapToLeave = 10

StaminaToLeave = 14 * 60 --in hours

LootBP = "Orange backpack"
GoldBP = "Green backpack"
SuppliesBP = "Purple backpack"
MainBP = "Beach Backpack"

registerEventListener(WALKER_SELECTLABEL, "onWalkerSelectLabel")
setTargetingEnabled(true)
setLooterEnabled(true)

print([[
Laguna Island for EK by Darkhaos
]])

--wagon 7132

function onWalkerSelectLabel(labelName)

	if labelName == "Start" then
		Walker.Stop()		
		Self.CloseContainers()
		sleep(math.random(800, 1200))
		Self.OpenMainBackpack(true):OpenChildren({Item.GetID(GoldBP),true}, {Item.GetID(LootBP), true}, {Item.GetID(SuppliesBP), true})
		wait(3000)
		
		for _, supply in ipairs(Supplies) do
			if Self.ItemCount(supply.id) < supply.required then
				gotoLabel("GoToBank")
				break
			end
		end
		
		if Self.Stamina() > StaminaToLeave then
			Walker.Start()
			Looter.Start()
			Targeting.Start()
		else
			return true
		end
	elseif labelName == "Bank" then
		Walker.Stop()
		Self.Say("hi")
		sleep(math.random(1000, 2117))
		if Self.Money() > 0 then
			Self.DepositMoney()
			sleep(math.random(1000, 2117))
		end
		
		local MoneyRequired = 0
		for _, supply in ipairs(Supplies) do
			MoneyRequired = MoneyRequired + math.max((supply.required - Self.ItemCount(supply.id)) * supply.price, 0)
		end
		MoneyRequired = MoneyRequired + 100 --passage
		
		
		Self.WithdrawMoney(MoneyRequired)
		sleep(math.random(954, 2117))
		Walker.Start()
	elseif labelName == "CheckSupp" then
		Walker.Stop()
		local go = false
		for _, supply in ipairs(Supplies) do
			if Self.ItemCount(supply.id) < supply.required then
				go = true
				break
			end
		end
		if go then
			gotoLabel("GoShop")
		else
			gotoLabel("GoToCave")
		end
		Walker.Start()
	elseif labelName == "BuySupp" then
	
		local buy = false
		for _, supply in ipairs(Supplies) do
			if math.max(supply.required - Self.ItemCount(supply.id), 0) > 0 then
				buy = true
				break
			end
		end
		
		if buy then
			Walker.Stop()
			Self.Say("hi")
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
	elseif labelName == "PegLeg" then
		Walker.Stop()
		Self.Say("hi")
		wait(1000)
		Self.SayToNpc('peg leg')
		wait(300)
		Self.SayToNpc('yes')
		wait(1000)
		Walker.Start()
	elseif labelName == "Liberty Bay" then
		Walker.Stop()
		Self.Say("hi")
		wait(1000)
		Self.SayToNpc('liberty bay')
		wait(300)
		Self.SayToNpc('yes')
		wait(1000)
		Walker.Start()
	elseif labelName == "Malunga" then
		Walker.Stop()
		Self.Say('hi')
		wait(500)
		Self.SayToNpc('trade')
		wait(1000)
		Self.ShopSellItem(9643, Self.ItemCount(9643))
		wait(500)
		Self.ShopSellItem(9640, Self.ItemCount(9640))
		wait(700)
		Walker.Start()
	elseif labelName == "Deposit" then
		Walker.Stop()
		Self.CloseContainers()
		sleep(math.random(800, 1200))
		Self.OpenMainBackpack(true):OpenChildren({Item.GetID(GoldBP),true}, {Item.GetID(LootBP), true}, {Item.GetID(SuppliesBP), true})
		wait(2000,4000)
		
		Self.ReachDepot()
		local bp = Container.New(Item.GetID(LootBP))
		local start = os.time()
		repeat
			Self.DepositItems({3279, 1}, {9633, 0}, {3026, 0}, {3027, 0}, {5899, 0}, {10272, 0})
			bp:UseItem(((bp:ItemCount() - 1) > 0 and (bp:ItemCount() - 1) or 0), true)
			wait(1000)
		until (bp:ItemCount() - 1) < 1
		sleep(math.random(1500, 2324))
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

