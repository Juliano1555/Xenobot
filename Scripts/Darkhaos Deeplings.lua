CapToLeave = 90

ManasToLeave = 200
HealthsToLeave = 70

RequiredManas = 1000
RequiredHealths = 300

HealthID = 7643
ManaID = 268

HealthPrice = 310
ManaPrice = 50

StaminaToLeave = 14 * 60 --in hours

GoldBP = "orange backpack"
LootBP = "blue backpack"
ProductBP = "backpack"
SuppliesBP = "backpack of holding"
MainBP = "jewelled backpack"

registerEventListener(WALKER_SELECTLABEL, "onWalkerSelectLabel")
setTargetingEnabled(true)
setLooterEnabled(true)

print([[
----Deeplings Script by Darkhaos----
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
		total = total + 100000 --for blessings in case of dead
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
		Walker.Start()
	elseif labelName == "Depot" then
		Walker.Stop()
		Self.CloseContainers()
		sleep(math.random(800, 1200))
		Self.OpenMainBackpack(true):OpenChildren({Item.GetID(LootBP),true}, {Item.GetID(ProductBP), true})
		wait(2000,4000)
		Self.ReachDepot()
		local bp = Container.New(Item.GetID(LootBP))
		for i = 1, 3 do
			Self.DepositItems({12683, 0}, {14040, 0}, {14042, 0}, {14250, 0}, {14043, 0}, {14248, 0}, {14247, 0}, {12308, 0}, {7426, 0}, {7424, 0}, {3566, 0}, {3067, 0}, {3055, 0}, {2995, 0}, {5668, 0}, {5801, 0}, {3071, 0}, {3567, 0}, {3324, 0}, {3052, 0}, {14142, 0}, {13987, 0}, {13990, 0}, {281, 0})
			bp:UseItem(((bp:ItemCount() - 1) > 0 and (bp:ItemCount() - 1) or 0), true)
			wait(500)
		end
		bp = Container.New(Item.GetID(ProductBP))
		for i = 1, 2 do
			Self.DepositItems({12730, 1}, {14017, 1}, {14041, 1}, {14012, 1}, {14013, 1}, {14011, 1}, {14044, 1}, {14010, 1}, {14008, 1}, {5895, 1}, {3029, 1}, {3030, 1}, {3032, 1}, {3033, 1})
			bp:UseItem(((bp:ItemCount() - 1) > 0 and (bp:ItemCount() - 1) or 0), true)
			wait(500)
		end
		sleep(math.random(1500, 2324))
		gotoLabel("Start")
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

function closeBackpacks()
    local displayName = "CloseBackpacks"
    local tmpBP = Container.GetFirst() 
    local cascaded = {}
    while tmpBP:isOpen() do
        for spot = 0, tmpBP:ItemCount() do
            local item = tmpBP:GetItemData(spot)
            if item.id == tmpBP:ID() then
                table.insert(cascaded, tmpBP:ID())
                tmpBP = tmpBP:GetNext()
            end
        end
        tmpBP = Container.GetFirst()
        if not table.contains(cascaded, tmpBP:ID()) or tmpBP:ItemCount() == 0 then -- Backpack is main or last cascaded. Closing...
            Self.UseItem(tmpBP:ID())
            wait(500, 900)
        end
        if #cascaded > 0 then -- Any cascaded backpacks?
            for i = 1, #cascaded do
                if tmpBP:ID() == cascaded[i] then -- Found cascaded backpack.
                    if tmpBP:ItemCount() > 0 then -- Backpack contains atleast one item, check for another bp.
                        for spot = 0, tmpBP:ItemCount() do
                            local item = tmpBP:GetItemData(spot)
                            if item.id == tmpBP:ID() then -- Found anoter cascade bp, opening...
                                tmpBP:UseItem(spot, true)
                                break
                            end
                        end
                    end
                end
            end
        end
        wait(500, 900)
        tmpBP = Container.GetFirst() -- Get a new bp to check.
        if tmpBP:ID() == 0 then -- No more open backpacks.
            print("All backpacks were successfully closed.")
        end
    end
    return true
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

function openBackpacks(...)
    local displayName = "OpenBackpacks"
    local backpacks = {...}
    Self.UseItem(Self.Backpack().id) -- Open main backpack.
    print("Opening main backpack.")
    wait(500, 900)
    main = Container.GetFirst()
    if #backpacks > 0 then
        for i = 1, #backpacks do
            if type(backpacks[i]) == 'table' then -- Is parent container specified?
                tmpBP = Container.GetByName(backpacks[i][1])
                for spot = 0, tmpBP:ItemCount() do
                    item = tmpBP:GetItemData(spot)
                    if item.id == backpacks[i][2] then
                        tmpBP:UseItem(spot)
                        print("Opening backpack from list. " .. backpacks[i][1] .. ", " .. backpacks[i][2])
                        wait(500, 800)
                    end
                end
            else -- If there is no parent specified we will use the main bp.
                for spot = 0, main:ItemCount() do
                    item = main:GetItemData(spot)
                    if item.id == backpacks[i] then
                        main:UseItem(spot)
                        print("Opening backpack from list, " .. backpacks[i])
                        wait(500, 800)
                    end
                end
            end
        end
        local indexes = Container.GetIndexes()
        for i = 1, #indexes do
            if type(backpacks[i]) == "table" then
                if Container.GetFromIndex(indexes[i]):ID() ~= backpacks[i][1] then
                    return false
                end
            else
                if Container.GetFromIndex(indexes[i]):ID() ~= backpacks[i] then
                    return false
                end
            end
        end
        return true
    end
end

function getOpenBackpacks()
    local indexes = Container.GetIndexes() -- Find index for all open backpacks
    local open = {} -- Create a place to store our open backpacks
    for i = 1, #indexes do -- Search all open backpacks
        tmpBP = Container.GetFromIndex(indexes[i])
        table.insert(open, tmpBP:ID()) -- Store this backpack
    end
    return open -- Return found backpacks
end

function resetBackpacks(tries)
    Walker.Stop()
    local open = getOpenBackpacks() -- Save a list of open backpacks
    local tries = 3 -- Give the script 3 tries to achieve a successful reset.
    repeat
        closeBackpacks() -- Close all backpacks
        wait(600, 800) -- wait a little bit
        local reopen = openBackpacks(unpack(open)) -- I store the return from openBackpacks, true if successfull, false otherwise
        if tries == 0 then -- Check how many tries function has left
            print("BackpackReset failed!") -- Tell the user reset has failed
            return false
        end
        tries = tries - 1 -- One try has been spent
    until reopen -- If reopen is true it means all backpacks were opened successfully and function is done
    print("BackpackReset was successfull!") -- Tell user reset was successful
    Walker.Start()
    return true
end