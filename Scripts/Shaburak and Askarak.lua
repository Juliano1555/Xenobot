CapToLeave = 30

ManasToLeave = 50
SDsToLeave = 30

RequiredManas = 100
RequiredSDs = 200

SDID = 3155
ManaID = 238

SDPrice = 108
ManaPrice = 120

SecondarySuppliesToLeave = 30

SecondarySupplies =
{
	{id = 3191, required = 400, price = 45},
	{id = 3175, required = 400, price = 37},
}

StaminaToLeave = 14 * 60 --in hours

GoldBP = "orange backpack"
LootBP = "yellow backpack"
ProductBP = "backpack"

registerEventListener(WALKER_SELECTLABEL, "onWalkerSelectLabel")
setTargetingEnabled(true)
setLooterEnabled(true)

print([[
Hive Script for Mages by Darkhaos
]])

function onWalkerSelectLabel(labelName)

	if labelName == "Start" then
		Walker.Stop()
		local needSecondary = false
		for _, sec in ipairs(SecondarySupplies) do
			if Self.ItemCount(sec.id) < sec.required then
				needSecondary = true
			end
		end
		if Self.ItemCount(ManaID) < RequiredManas or Self.ItemCount(SDID) < RequiredSDs or needSecondary then
			gotoLabel("GoToBank")
		end
		Self.CloseContainers()
		sleep(math.random(800, 1200))
		Self.OpenMainBackpack(true):OpenChildren({Item.GetID(LootBP),true}, {Item.GetID(ProductBP), true})
		wait(2000,4000)
		Walker.Start()
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
		local moneySDs = math.max((RequiredSDs - Self.ItemCount(SDID)) * SDPrice, 0)
		local moneySecondarySupplies = 0
		for _, sup in ipairs(SecondarySupplies) do
			moneySecondarySupplies = moneySecondarySupplies + (math.max((sup.required - Self.ItemCount(sup.id)) * sup.price, 0))
		end
		local total = moneyManas + moneySDs + moneySecondarySupplies
		total = total + 100000 --bless
		if total > 0 then
			Self.WithdrawMoney(total)
		end
		sleep(math.random(957, 2025))
		if total > 0 and Self.Money() < 1 then --not enough money? let's withdraw without money for bless.
			total = moneyManas + moneySDs + moneySecondarySupplies
			if total > 0 then
				Self.WithdrawMoney(total)
			end
			sleep(math.random(957, 2025))
		end
		Self.SayToNpc("balance")
		Walker.Start()
	elseif labelName == "CheckForPots" then
		Walker.Stop()
		local needSecondary = false
		for _, sec in ipairs(SecondarySupplies) do
			if Self.ItemCount(sec.id) < sec.required then
				needSecondary = true
			end
		end
		if Self.ItemCount(ManaID) < RequiredManas or Self.ItemCount(SDID) < RequiredSDs or needSecondary then
			gotoLabel("GoBuyPots")
		else
			gotoLabel("GoToCave")
		end
		Walker.Start()
	elseif labelName == "BuyPotions" then
	
		local requiredManas = math.max(RequiredManas - Self.ItemCount(ManaID), 0)
		--[[local requiredSDs = math.max(RequiredSDs - Self.ItemCount(SDID), 0)
		local requiredSecondarySupplies = 0
		for _, sup in ipairs(SecondarySupplies) do
			requiredSecondarySupplies = requiredSecondarySupplies + (math.max((sup.required - Self.ItemCount(sup.id)), 0))
		end]]--
		if requiredManas > 0 then
			Walker.Stop()
			Self.SayToNpc("hi")
			sleep(math.random(1000, 1500))
			Self.SayToNpc("trade")
			sleep(math.random(500, 800))
			if requiredManas > 0 then
				repeat
					Self.ShopBuyItem(ManaID, requiredManas)
					wait(100)
				until Self.ItemCount(ManaID) >= RequiredManas
			end
			--[[if requiredSDs > 0 then
				repeat
					Self.ShopBuyItem(SDID, requiredSDs)
					wait(100)
				until Self.ItemCount(SDID) >= RequiredSDs
			end
			if requiredSecondarySupplies > 0 then
				for _, sup in ipairs(SecondarySupplies) do
					repeat 
						Self.ShopBuyItem(sup.id, math.max(sup.required - Self.ItemCount(sup.id), 0))
						wait(100)
					until Self.ItemCount(sup.id) >= sup.required
				end
			end]]--
			sleep(math.random(600, 1000))
		end
		Walker.Start()
	elseif labelName == "BuyStoneShower" then
		local reqSt = 0
		for _, sup in ipairs(SecondarySupplies) do
			if sup.id == 3175 then
				reqSt = sup.required
			end
		end
		local requiredStones = math.max(reqSt - Self.ItemCount(3175), 0)
		if requiredStones > 0 then
			Walker.Stop()
			Self.SayToNpc("hi")
			sleep(math.random(1000, 1500))
			Self.SayToNpc("trade")
			sleep(math.random(500, 800))
			if requiredStones > 0 then
				repeat
					Self.ShopBuyItem(3175, requiredStones)
					wait(100)
				until Self.ItemCount(3175) >= requiredStones
			end
			sleep(math.random(600, 1000))
		end
		Walker.Start()
	elseif labelName == "TravelIsland" then
		Walker.Stop()
		Self.SayToNpc("hi")
		sleep(math.random(1000, 2117))
		Self.SayToNpc("gray island")
		sleep(math.random(954, 2117))
		Self.SayToNpc("yes")
		sleep(math.random(500, 900))
		Walker.Start()
	elseif labelName == "GoIntoVortex1" then
		Walker.Stop()
		Self.Step("east")
		Walker.Start()
	elseif labelName == "GoIntoVortex2" then
		Walker.Stop()
		Self.Step("south")
		Walker.Start()
	elseif labelName == "Walk" then
		Walker.Stop()
		Self.UseItemFromGround(33454, 31345, 8)
		Walker.Start()
	elseif labelName == "ExaniTera" then
		Walker.Stop()
		Self.Say("exani tera")
		sleep(math.random(500, 1000))
		Walker.Start()
	elseif labelName == "BuyFireball" then
		local reqFb = 0
		for _, sup in ipairs(SecondarySupplies) do
			if sup.id == 3191 then
				reqFb = sup.required
			end
		end
		local requiredFireball = math.max(reqFb - Self.ItemCount(3191), 0)
		if requiredFireball > 0 then
			Walker.Stop()
			Self.SayToNpc("hi")
			sleep(math.random(1000, 1500))
			Self.SayToNpc("trade")
			sleep(math.random(500, 800))
			if requiredFireball > 0 then
				repeat
					Self.ShopBuyItem(3191, requiredFireball)
					wait(100)
				until Self.ItemCount(3191) >= requiredFireball
			end
			sleep(math.random(600, 1000))
		end
		Walker.Start()
	elseif labelName == "TravelEdron" then
		Walker.Stop()
		Self.SayToNpc("hi")
		sleep(math.random(1000, 2117))
		Self.SayToNpc("travel")
		sleep(math.random(954, 2117))
		Self.SayToNpc("edron")
		sleep(math.random(500, 900))
		Walker.Start()
	elseif labelName == "Check" then
		Walker.Stop()
		local NoSupplies = false
		for _, sec in ipairs(SecondarySupplies) do
			if Self.ItemCount(sec.id) < SecondarySuppliesToLeave then
				NoSupplies = true
			end
		end
		if Self.ItemCount(ManaID) <= ManasToLeave or Self.ItemCount(SDID) <= SDsToLeave or Self.Cap() <= CapToLeave or Self.Stamina() <= StaminaToLeave or NoSupplies then
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
			Self.DepositItems({2995, 0}, {3071, 0}, {821, 0}, {826, 0}, {3554, 0}, {7412, 0}, {812, 0}, {8084, 0}, {811, 0}, {7419, 0}, {3281, 0})
			bp:UseItem(((bp:ItemCount() - 1) > 0 and (bp:ItemCount() - 1) or 0), true)
			wait(1000)
		end
		bp = Container.New(Item.GetID(ProductBP))
		for i = 1, 2 do
			Self.DepositItems({3030, 1}, {5904, 1}, {14541, 1}, {3032, 1})
			bp:UseItem(((bp:ItemCount() - 1) > 0 and (bp:ItemCount() - 1) or 0), true)
			wait(1000)
		end
		sleep(math.random(1500, 2324))
		Walker.Start()
	elseif labelName == "Final" then
		Walker.Stop()
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

