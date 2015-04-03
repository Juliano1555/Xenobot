RequiredHealths = 30
RequiredManas = 300
RequiredSpears = 0

HealthsToLeave = 3
ManasToLeave = 5

CapToLeave = 10

GoldBackpack = "red backpack"
LootBackpack = "brocade backpack"

HealthID = 239
ManaID = 268

HealthPrice = 190
ManaPrice = 50

SpearID = 7367
SpearPrice = 15
SpearsToLeave = 0

StaminaToLeave = 16 * 60

registerEventListener(WALKER_SELECTLABEL, "onWalkerSelectLabel")
setTargetingEnabled(true)
setLooterEnabled(true)

print([[
Scarabs Script by Darkhaos
]])

function onWalkerSelectLabel(labelName)
	
	if labelName == "Start" then
		setWalkerEnabled(false)
		if Self.ItemCount(HealthID) < RequiredHealths or Self.ItemCount(SpearID) < RequiredSpears or Self.ItemCount(ManaID) < RequiredManas then
			gotoLabel("GoToBank")
		else
			gotoLabel("GoToCave")
		end
		setWalkerEnabled(true)
	elseif labelName == "TalkWithBank" then
		setWalkerEnabled(false)
		delayWalker(10000)
		Self.SayToNpc("hi")
		sleep(math.random(1000, 2117))
		if Self.Money() > 0 then
			Self.SayToNpc("deposit all")
			sleep(math.random(1000, 2117))
			Self.SayToNpc("yes")
			sleep(math.random(1000, 2117))
		end
		local moneyHealths = math.max((RequiredHealths - Self.ItemCount(HealthID)) * HealthPrice, 0)
		local moneySpears = math.max((RequiredSpears - Self.ItemCount(SpearID)) * SpearPrice, 0)
		local moneyManas = math.max((RequiredManas - Self.ItemCount(ManaID)) * ManaPrice, 0)
		local total = moneyManas + moneySpears + moneyHealths - Self.Money()
		if total > 0 then
			Self.WithdrawMoney(total)
		end
		sleep(math.random(957, 2025))
		Self.SayToNpc("balance")
		setWalkerEnabled(true)
	elseif labelName == "CheckPots" then
		setWalkerEnabled(false)
		if Self.ItemCount(HealthID) < RequiredHealths or Self.ItemCount(ManaID) < RequiredManas then
			gotoLabel("GoBuyPots")
		else
			if Self.ItemCount(SpearID) < RequiredSpears then
				gotoLabel("CheckAmmo")
			else
				gotoLabel("GoToCave")
			end
		end
		setWalkerEnabled(true)
	elseif labelName == "CheckAmmo" then
		setWalkerEnabled(false)
		if Self.ItemCount(SpearID) < RequiredSpears then
			gotoLabel("GoBuyAmmo")
		else
			gotoLabel("GoToCave")
		end
		setWalkerEnabled(true)
	elseif labelName == "BuyAmmo" then
		setWalkerEnabled(false)
		
		local requiredSpears = math.max(RequiredSpears - Self.ItemCount(SpearID), 0)
		if requiredSpears > 0 then
			Self.SayToNpc("hi")
			sleep(math.random(1000, 1500))
			Self.SayToNpc("trade")
			sleep(math.random(500, 800))
			Self.ShopBuyItem(SpearID, requiredSpears)
			sleep(math.random(600, 1000))
		end
		setWalkerEnabled(true)
		
	elseif labelName == "BuyPotions" then
		setWalkerEnabled(false)
		Self.SayToNpc("hi")
		sleep(math.random(1000, 1500))
		Self.SayToNpc("trade")
		sleep(math.random(500, 800))
		local requiredHealths = math.max(RequiredHealths - Self.ItemCount(HealthID), 0)
		local requiredManas = math.max(RequiredManas - Self.ItemCount(ManaID), 0)
		if requiredHealths > 0 then
			Self.ShopBuyItem(HealthID, requiredHealths)
			sleep(math.random(600, 1000))
		end
		if requiredManas > 0 then
			Self.ShopBuyItem(ManaID, requiredManas)
			sleep(math.random(600, 1000))
		end
		setWalkerEnabled(true)
	elseif labelName == "Check" then
		setWalkerEnabled(false)
		if Self.ItemCount(HealthID) < HealthsToLeave or Self.ItemCount(SpearID) < SpearsToLeave or Self.Cap() <= CapToLeave or Self.Stamina() <= StaminaToLeave or Self.ItemCount(ManaID) <= ManasToLeave then
			gotoLabel("Leave")
		else
			gotoLabel("Hunt")
		end
		setWalkerEnabled(true)
	elseif labelName == "BankDeposit" then
		setWalkerEnabled(false)
		delayWalker(math.random(9000, 10000))
		Self.SayToNpc("hi")
		sleep(math.random(1000, 2117))
		Self.SayToNpc("deposit all")
		sleep(math.random(954, 2117))
		Self.SayToNpc("yes")
		sleep(math.random(500, 900))
		setWalkerEnabled(true)
	elseif labelName == "Depot" then
		setWalkerEnabled(false)
		sleep(math.random(800, 1300))
		Self.ReachDepot()
		sleep(math.random(800, 1000))
        Self.DepositItems({11471, 0}, {3084, 0}, {3357, 0}, {3093, 0}, {11511, 0}, {5883, 0}, {3072, 0}, {3033, 0}, {3348, 0}, {268, 0})
		sleep(math.random(1500, 2324))
		Self.CloseContainers()
		sleep(math.random(800, 1200))
		Self.OpenMainBackpack(true):OpenChildren({Item.GetID(LootBackpack), true})
		wait(2000,4000)
		--[[
		if Refill and Self.Stamina() > StaminaToLeave then
			gotoLabel("Start")
			setWalkerEnabled(true)
		else
			if TrainOffline then
				gotoLabel("Train")
				setWalkerEnable(true)
			else
				gotoLabel("Finish")
			end
		end
		]]
		gotoLabel("Start")
		setWalkerEnabled(true)
	elseif labelName == "Finish" then
		setWalkerEnabled(false)
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
    setWalkerEnabled(false)
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
                    setWalkerEnabled(true)
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
    setWalkerEnabled(false)
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
    setWalkerEnabled(true)
    return true
end
