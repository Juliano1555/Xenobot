------------------------------------------------------
---------INFORMATION---------
-- BP SETUP
-- [BP 1] -- Main
-- [BP 2] -- Loot
-- [BP 3] -- Gold

--DP SETUP
-- [BP 1] -- Stackables
-- [BP 2] -- Non-stackables
------------------------------------------------------
---------SETTINGS---------
-- BP ID
local goldBP = 8860 					-- ID of your Gold BP

-- Cap
local minCap = 90 						--Cap to leave spawn

-- MP
local manasToLeave = 40 				--Manas to leave spawn
local wantedMPS = 90 					--Wanted amount of manapotions
local manaPotID = 268 					--Manapotion ID
local manaCost = 50 					--Manapotion price

-- HP
local wantedHPS = 0 					--Wanted amount of strong health potions
local hPotID = 266 						--Healthpotion ID
local hPotCost = 0 					--Healthpotion price

-- Food
local maxFood = 400
local minFood = 0

-- Other
local safeCheckID = 10279 				-- Set an item which is looted regurlary. The script will, after depositting, check for this item to ensure it has depositted -- and if not it will try depositting again.
------------------------------------------------------
displayInformationMessage("Port Hope: Dworcs \n -- Brought to you by TibiaNeant.com -- \n\n\n\n(Remember to post your feedback in my thread!)")
registerEventListener(WALKER_SELECTLABEL, "onWalkerSelectLabel")
function onWalkerSelectLabel(labelName)
   if (labelName == "checker") then
        if (Self.Cap() < minCap) or ((Self.ItemCount(manaPotID) < manasToLeave)) or ((Self.ItemCount(3606) < minFood))  then
            gotoLabel("leaveSpawn")
        else
            gotoLabel("keepHunting")
		end		
		
	elseif (labelName == "skip") then
    gotoLabel("checker")	
		
	elseif (labelName == "posCheck1") then
		if (Self.Position().x == 32798 and Self.Position().y == 32155 and Self.Position().z == 8) then
       		gotoLabel("AfterPosCheck1")
		else
			gotoLabel("checkShovel1")
			end

	elseif (labelName == "floor3") then
		if not (floor3) then
		    gotoLabel("cont1")
			end
			
	elseif (labelName == "checkBreakWall1") then
	local item1 = Map.GetTopUseItem(32652, 32899, 8)
	local item2 = Map.GetTopUseItem(32654, 32897, 8)
        if ((item1.id == 2295) or (item2.id == 2295)) or ((item1.id == 2296) or (item2.id == 2296)) then  
		gotoLabel("breakWall1")
	else
		gotoLabel("cont1")
	end
	
	elseif (labelName == "breakWall1") then	
	sleep(math.random(100, 200))
	Self.UseItemWithGround(Self.Weapon().id, 32652, 32899, 8) 
	sleep(math.random(500, 1000))
	Self.UseItemWithGround(Self.Weapon().id, 32654, 32897, 8)
		gotoLabel("checkBreakWall1")		

	elseif (labelName == "checkBreakWall2") then
	local item1 = Map.GetTopUseItem(32632, 32877, 8)
	local item2 = Map.GetTopUseItem(32631, 32877, 8)
        if ((item1.id == 2295) or (item2.id == 2296)) and ((item1.id == 2295) or (item2.id == 2296)) then  
		gotoLabel("breakWall2")
	else
		gotoLabel("cont2")
	end
	
	elseif (labelName == "breakWall2") then	
	sleep(math.random(100, 200))
	Self.UseItemWithGround(Self.Weapon().id, 32632, 32877, 8) 
	sleep(math.random(500, 1000))
	Self.UseItemWithGround(Self.Weapon().id, 32631, 32877, 8)
		gotoLabel("checkBreakWall2")

	elseif (labelName == "checkShovel1") then
	sleep(math.random(1000, 2000))	
	local item = Map.GetTopUseItem(32613, 32703, 7) 
        if (item.id == 867) then  
		gotoLabel("shovel1")
	else
		gotoLabel("cont3")
		end

	elseif (labelName == "shovel1") then
	setWalkerEnabled(false)
	Self.UseItemWithGround(shovelID, 32613, 32703, 7)
	sleep(math.random(1100, 3000))
	setWalkerEnabled(true)
		
	elseif (labelName == "cut1") then
	setWalkerEnabled(false)
	Self.UseItemWithGround(macheteID, 32855, 32109, 7)
	sleep(math.random(1100, 3000))
	setWalkerEnabled(true)

	elseif (labelName == "looterOff1") then
		setLooterEnabled(false)

	elseif (labelName == "looterOn1") then
		setLooterEnabled(true)

    elseif (labelName == "backpackReset") then		
	delayWalker(2000)
	setWalkerEnabled(false)
	Container.Close(goldBP)	
	sleep(math.random(500, 1000))
	Container.GetFirst():OpenChildren(goldBP)	
	sleep(math.random(500, 1000))
	setWalkerEnabled(true)

	elseif (labelName == "bank") then
		setWalkerEnabled(false)
        delayWalker(5000)
        Self.Say("hi")
        sleep(math.random(700, 1400))
        Self.SayToNpc("deposit all")
        sleep(math.random(300, 1000))
        Self.SayToNpc("yes")
        sleep(math.random(300, 1000))
	Self.WithdrawMoney((manaCost*(wantedMPS-Self.ItemCount(manaPotID)))+200)
        sleep(math.random(300, 1000))
	Self.SayToNpc("yes")
	    sleep(math.random(300, 1000))
    Self.WithdrawMoney((hPotCost*(wantedHPS-Self.ItemCount(hPotID))))
         sleep(math.random(700, 1400)) --f
	Self.SayToNpc("yes")
        sleep(math.random(300, 1000))
    Self.WithdrawMoney((2*(maxFood-Self.ItemCount(3606))))
         sleep(math.random(700, 1400)) --f
	Self.SayToNpc("yes")
        sleep(math.random(300, 1000))
	Self.SayToNpc("balance")
		setWalkerEnabled(true)
		
	elseif (labelName == "reachDepot") then		
		Self.ReachDepot()

	elseif (labelName == "deposit") then
		Self.DepositItems(
		{3560, 1},       	
		{647, 0},         	 
		{11514, 0},          
		{10301, 0},      	
		{10281, 0},      	
		{10273, 0},      	 
		{3053, 1},        	 
		{3002, 1},       
		{3058, 0},     
		{3406, 0}      	
		)
		sleep(math.random(500, 1000))  					
		
	elseif (labelName == "trade") then
        setWalkerEnabled(false)
		setTargetingEnabled(true)
        wait(3000)
		setTargetingEnabled(false)
        Self.SayToNpc({"hi", "trade"}, 65)
        wait(500, 1000)
		Self.ShopSellAllItems(3403)
        wait(500, 1000)
		Self.ShopSellAllItems(3346)
        wait(500, 1000)
        setWalkerEnabled(true)		
		
	elseif (labelName == "buyManas") then
		local healthCount = (wantedHPS-Self.ItemCount(hPotID))
		setWalkerEnabled(false)
		delayWalker(7000)
		Self.Say("hi")
		sleep(math.random(500, 1000))
		Self.SayToNpc("vials")
		sleep(math.random(500, 1000))
		Self.SayToNpc("yes")
		sleep(math.random(500, 1000))
		Self.SayToNpc("trade")
		sleep(math.random(500, 1000))
			while (Self.ItemCount(hPotID) < wantedHPS) do
			Self.ShopBuyItem(hPotID, healthCount)
			sleep(math.random(500, 1000))
		end
        buyManas(manaPotID, (wantedMPS-Self.ItemCount(manaPotID)))
		sleep(math.random(500, 1000))
		setWalkerEnabled(true)
		
	elseif (labelName == "trade2") then
		setWalkerEnabled(false)
		delayWalker(7000)
		Self.Say("hi")
		sleep(math.random(500, 1000))
		Self.SayToNpc("trade")
		sleep(math.random(500, 1000))
        buyManas(3606, (maxFood-Self.ItemCount(3606)))
		sleep(math.random(500, 1000))
		setWalkerEnabled(true)
	
	elseif (labelName == "checkManas2") then
			if (Self.ItemCount(manaPotID) < wantedMPS) then
				gotoLabel("goBank")
			else
		        gotoLabel("goHunt")
			end
		
	elseif (labelName == "checkDepo") then
        if (Self.ItemCount(safeCheckID) > 1) then
            gotoLabel("goDeposit")
			end

 	elseif (labelName == "gate2")then
		Self.UseItemFromGround(32729, 31199, 5)	
		end
	end

function buyManas(item, count)
	count = tonumber(count) or 1
	repeat
		local amnt = math.min(count, 100)
		if(Self.ShopBuyItem(item, amnt) == 0)then
			return printf("ERROR", tostring(item))
		end
        wait(200,500)
		count = (count - amnt)
	until count <= 0
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