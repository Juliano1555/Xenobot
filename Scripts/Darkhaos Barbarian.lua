CapToLeave = 30
RequiredManas = 300
RequiredHealths = 50
ManasToLeave = 50
HealthsToLeave = 20 
ManaID = 268
HealthID = 239
ManaPrice = 50
HealthPrice = 310 
StaminaToLeave = 10 * 60 
SoftBoots = false
LeaveNoSoftBoots = true
LootBP = "brocade backpack"
SecondaryBoots = 4033
HuntInTower = true

ClosedDoor = 7042

BuddelCampArea =
{
	{x = 32019, y = 31293, z = 7},
	{x = 32024, y = 31298, z = 7}
}

registerEventListener(WALKER_SELECTLABEL, "onWalkerSelectLabel")
setTargetingEnabled(true)
setLooterEnabled(true)


print([[
Big Barbarian Camp Script by Darkhaos
Version 2.0.0
]])

function onWalkerSelectLabel(labelName)

	if labelName == "Start" then
		Walker.Stop()
		if Self.ItemCount(ManaID) < RequiredManas or Self.ItemCount(HealthID) < RequiredHealths then
			Walker.Goto("GoToBank")
		end
		Self.CloseContainers()
		sleep(math.random(800, 1200))
		Self.OpenMainBackpack(true):OpenChildren({Item.GetID(LootBP), true})
		wait(2000,4000)
		Walker.Start()
	elseif labelName == "TalkWithBank" then
		local requiredMoneyManas = (RequiredManas - Self.ItemCount(ManaID)) * ManaPrice
		local requiredMoneyHealths = (RequiredHealths - Self.ItemCount(HealthID)) * HealthPrice
		if requiredMoneyManas < 1 then requiredMoneyManas = 0 end
		if requiredMoneyHealths < 1 then requiredMoneyHealths = 0 end
		local total = requiredMoneyManas + requiredMoneyHealths
		if SoftBoots and Self.ItemCount(6530) > 0 then
			total = total + 10500
		end
		--total = total + 500 --buddel travel
		Walker.Stop()
		delayWalker(10000)
		Self.SayToNpc("hi")
		sleep(math.random(1000, 2117))
		if Self.Money() > 0 then
			Self.SayToNpc("deposit all")
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
			if requiredManas > 0 then
				Self.ShopBuyItem(ManaID, requiredManas)
			end
			if requiredHealths > 0 then
				Self.ShopBuyItem(HealthID, requiredHealths)
			end
			sleep(math.random(600, 1000))
		end
		Walker.Start()
	elseif labelName == "CheckSoft" then
		Walker.Stop()
		if SoftBoots then
			if Self.ItemCount(6530) > 0 then
				Walker.Goto("GoToVenore")
			else
				Walker.Goto("GoToCave")
			end
		else
			Walker.Goto("GoToCave")
		end
		Walker.Start()
	elseif labelName == "Breezelda" then
		Walker.Stop()
		delayWalker(6000)
		Self.Say("hi")
		sleep(math.random(1000, 1900))
		Self.SayToNpc("venore")
		sleep(math.random(1000, 1850))
		Self.SayToNpc("yes")
		sleep(math.random(1000, 2000))
		Walker.Start()
	elseif labelName == "Aldo" then
		Walker.Stop()
		delayWalker(6000)
		Self.Say("hi")
		sleep(math.random(1000, 1927))
		Self.SayToNpc("soft boots")
		sleep(math.random(850, 1500))
		Self.SayToNpc("yes")
		sleep(math.random(500, 1000))
		Walker.Start()
	elseif labelName == "Fearless" then
		Walker.Stop()
		delayWalker(6000)
		Self.Say("hi")
		sleep(math.random(1000, 1900))
		Self.SayToNpc("svargrond")
		sleep(math.random(1000, 1850))
		Self.SayToNpc("yes")
		sleep(math.random(1000, 2000))
		Walker.Start()
	elseif labelName == "BuddelGoingTo" then
		Walker.Stop()
		delayWalker(6000)
		Self.Say("hi")
		sleep(math.random(1000, 1900))
		Self.SayToNpc("passage")
		sleep(math.random(1000, 1900))
		Self.SayToNpc("camp")
		sleep(math.random(1000, 1850))
		Self.SayToNpc("yes")
		wait(5000)
		if not Self.IsInArea(BuddelCampArea[1], BuddelCampArea[2]) then
			repeat 
				Self.Say("hi")
				sleep(math.random(1000, 1900))
				Self.SayToNpc("passage")
				sleep(math.random(1000, 1900))
				Self.SayToNpc("camp")
				sleep(math.random(1000, 1850))
				Self.SayToNpc("yes")
				wait(5000)
			until Self.IsInArea(BuddelCampArea[1], BuddelCampArea[2])
		end
		if SoftBoots then
			Self.Equip(6529, "feet")
		end
		Walker.Start()
	elseif labelName == "CheckTower" then
		Walker.Stop()
		if HuntInTower then
			Walker.Goto("GoToTower")
		else
			Walker.Goto("Floor")
		end
		Walker.Start()
	elseif labelName == "DoorEnter" then
		Walker.Stop()
		local door = Map.GetUseItems(ClosedDoor)
		if #door > 0 then
			Self.UseDoor(door[1].x, door[1].y, door[1].z)
		end
		Walker.Start()
	elseif labelName == "DoorExit" then
		Walker.Stop()
		local door = Map.GetUseItems(ClosedDoor)
		if #door > 0 then
			Self.UseDoor(door[1].x, door[1].y, door[1].z)
		end
		Walker.Start()
	elseif labelName == "Check" then
		Walker.Stop()
		if Self.Feet().id == 6530 then
			if SoftBoots and Self.ItemCount(6529) > 0 then
				Self.Equip(6529, "feet")
			else
				Self.Equip(SecondaryBoots, "feet")
			end
		end
		if Self.ItemCount(ManaID) <= ManasToLeave or Self.ItemCount(HealthID) <= HealthsToLeave or Self.Cap() <= CapToLeave or Self.Stamina() <= StaminaToLeave then
			Walker.Goto("Leave")
		else
			Walker.Goto("Hunt")
		end
		Walker.Start()
	elseif labelName == "BuddelComingF" then
		Walker.Stop()
		delayWalker(6000)
		Self.Say("hi")
		sleep(math.random(1000, 1900))
		Self.SayToNpc("passage")
		sleep(math.random(1000, 1900))
		Self.SayToNpc("svargrond")
		sleep(math.random(1000, 1850))
		Self.SayToNpc("yes")
		sleep(math.random(1000, 2000))
		
		Walker.Start()
		if SecondaryBoots > 0 and Self.Feet().id ~= SecondaryBoots then
			Self.Equip(SecondaryBoots, "feet")
		end
	elseif labelName == "Depot" then
		Walker.Stop()
		Self.CloseContainers()
		sleep(math.random(800, 1200))
		Self.OpenMainBackpack(true):OpenChildren({Item.GetID(LootBP), true})
		wait(2000,4000)
		Self.ReachDepot()
		sleep(math.random(800, 1000))
        Self.DepositItems(
        {5911, 1},          --- red piece of cloth 
		{5913, 1},			--- brown piece of cloth
        {7463, 0},			--- mammoth fur cape 
        {7290, 1},			--- shard 
		{7462, 0},			--- Ragnir helmet
		{7457, 0},			--- fur boots 
        {3344, 0},			--- beastslayer axe
        {7464, 0},			--- mammoth fur shorts 
	    {7449, 0},			--- crystal sword 
	    {3052, 2},			--- life ring
		{7379, 0},			--- brutetamer's staff 
		{819, 0},
		{7443, 0},
		{285, 1}
		)
		sleep(math.random(1500, 2324))
		Self.CloseContainers()
		sleep(math.random(800, 1200))
		Self.OpenMainBackpack(true):OpenChildren({Item.GetID(LootBP), true})
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

Self.IsInArea = function(fromPosition, toPosition)
	return (Self.Position().x >= fromPosition.x and Self.Position().y >= fromPosition.y and Self.Position().z >= fromPosition.z
		and Self.Position().x <= toPosition.x and Self.Position().y <= toPosition.y and Self.Position().z <= toPosition.z)
end