---------------Thais-Undeads-by-------------------
--------------------------------------------------
--------------------------------------------------
--------------------------------------------------
--------///-------------///-----------------------
--------///-------------///---------////////------
--------///--///---///--///---------///---//------
--------///--///---///--/////////--/////////------
---///--///--///---///--///---///---///-----------
---////////--/////////--/////////---/////////-----
--------------------------------------------------
--------------------------------------------------
--------------------------------------------------

-----SETTINGS--------------------------------------------------------------
--POTIONS--
--NORMAL-FLOORS-1-2-3--
local ManaID = 268 --- Which mana potions are you using? 
local MinMana = 5 --- How many mana potions until you leave the hunt.
local MaxMana = 20 --- How many mana potions you begin the hunt with.
local ManaPrice = 50 --- What is the price of your selected mana potions?
local HealthID = 266 --- Which health potions are you using? normal 266 - strong 236 - great 239
local MinHealth = 10 --- How many health potions until you leave the hunt.
local MaxHealth = 10 --- How many health potions you begin the hunt with.
local HealthPrice = 50 --- What is the price of your selected mana potions?
--FLOOR-4-AND-DRAGONS/HARDCORES--
local MinMana1 = 50 --- How many mana potions to leave Floor4, Dragons and Hardcores.
local MaxMana1 = 150 --- How many mana potions to buy if going Floor4, Dragons or Hardcores.
local MinHealth1 = 15 --- How many mana potions to leave Floor4, Dragons and Hardcores.
local MaxHealth1 = 30 --- How many health potions to buy if going Floor4, Dragons or Hardcores.

--FOOD--
local CheckFood = true --- Set this true if you want to get food from dp and leave resp if no food.
local FoodID = 3725 --- ID of the food u want to withdraw (Brown mushroom 3725).
local MaxFood = 200 --- Amount of food you want to withdraw.
local MinFood = 0 --- Amount of food you want to go refill.
--CAP--
local MinCap = 20 --- Leaves spawn when character reaches this cap.

--RESPAWNS--
local floor1 = true --- Set this true if you want to hunt this floor level 20+
local floor2 = false --- Set this true if you want to hunt this floor level 30+
local floor3 = false --- Set this true if you want to hunt this floor level 40+
local floor4 = false --- Set this true if you want to hunt this floor level 60+
local geomancer = false --- Set this true if you want to kill dwarf geomancer and 2 dwarf guards.
local Dragons = false --- Set this true if you want to kill 3x dragons. Recomend level 70+
local Drag1 = false --- Set this true if you want to kill Dragon 1. ALERT: During Dragon Eggs Patch it is DANGEROUS.

--HARDCORE--
local Hardcore = false --- Set this true if you want to kill Drag2 or Giant Spider.
local Drag2 = false --- Set this true if you want to kill Dragon 2. ALERT: During Dragon Eggs Patch it is DANGEROUS.

--GIANT-SPIDER--
local WeaponID = 7384 --- ID of the weapon you use to break Spider Web. Default Mystic Blade (7384)
local KillGS = false --- Set this true if you want to kill Giant Spider. Recomend level 80+

--BP SETUP--
local MainBp  = "purple backpack" ----- Main Backpack
local GoldBp  = "purple backpack" ---- Backpack to put gold in
local LootBp  = "orange backpack" ---- Backpack to put gold in

-----END OF SETTINGS-------------------------------------------------------
-----DO NOT EDIT BELOW HERE IF YOU DONT KNOW WHAT TO DO--------------------

registerEventListener(WALKER_SELECTLABEL, "onWalkerSelectLabel")
local info = [[
Thais Undeads by Jube]]
    print([[
Thais Undeads by Jube]])
    wait(5000)
	
--FUNCTIONS--

function buyitems(item, count)
	count = tonumber(count) or 1
	repeat
		local amnt = math.min(count, 100)
		if(Self.ShopBuyItem(item, amnt) == 0)then
			return printf("ERROR: failed to buy item: %s", tostring(item))
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

Self.ReachNpc = function(name, tries)
        local npc = Creature.GetByName(name)
        if (npc:DistanceFromSelf() > 3) then
                tries =  tries or 15
                repeat
                        local nposi = npc:Position()
                        Self.UseItemFromGround(nposi.x, nposi.y, nposi.z)
                        wait(1500)
                        tries = tries - 1
                until (npc:DistanceFromSelf() <= 3) or (tries == 0)
        end
end  

setTargetingEnabled(true)
setLooterEnabled(true)

-----------------------------------------------------------------
function onWalkerSelectLabel(labelName)
----------------------------------------------------------------------------------------------------
    if (labelName == "ResetBP") then
        setWalkerEnabled(false)
        Self.CloseContainers()
        Self.OpenMainBackpack(true):OpenChildren({GoldBp, true},{LootBp, true})
		setWalkerEnabled(true) 
----------------------------------------------------------------------------------------------------
    elseif (labelName == "InitialCheck") then
            delayWalker(1000)
            setWalkerEnabled(false)
            if (Self.ItemCount(ManaID) < (MaxMana-3)) or (Self.Cap() < MinCap) or (Self.ItemCount(HealthID) < (MaxHealth)) or (CheckFood==true and (Self.ItemCount(FoodID) < MaxFood - 10)) then
                setWalkerEnabled(true)
                gotoLabel("Refill")
		print("Going to refill")
            else
                setWalkerEnabled(true)
                gotoLabel("GoHunt")
		print("Going Hunt")
            end
----------------------------------------------------------------------------------------------------
    elseif (labelName == "Bank") then
		    setWalkerEnabled(false)
	        if floor4 == true then
			local withdrawManas1 = (MaxMana1-Self.ItemCount(ManaID))*ManaPrice
			local withdrawHealths1 = (MaxHealth1-Self.ItemCount(HealthID))*HealthPrice
			Self.SayToNpc({"hi", "deposit all", "yes"}, 65)
			if (withdrawManas1 > 0) then
                Self.SayToNpc({"withdraw " .. withdrawManas1, "yes"}, 65)
            end
            if (withdrawHealths1 > 0) then
                Self.SayToNpc({"withdraw " .. withdrawHealths1, "yes",}, 65)
            end
            Self.SayToNpc({"balance"}, 65)
            setWalkerEnabled(true)
			else
			local withdrawManas = (MaxMana-Self.ItemCount(ManaID))*ManaPrice
			local withdrawHealths = (MaxHealth-Self.ItemCount(HealthID))*HealthPrice
			Self.SayToNpc({"hi", "deposit all", "yes"}, 65)
			if (withdrawManas > 0) then
                Self.SayToNpc({"withdraw " .. withdrawManas, "yes"}, 65)
            end
            if (withdrawHealths > 0) then
                Self.SayToNpc({"withdraw " .. withdrawHealths, "yes",}, 65)
            end
            Self.SayToNpc({"balance"}, 65)
            setWalkerEnabled(true)
			end
		    sleep(math.random(600, 1100))
----------------------------------------------------------------------------------------------------
    elseif (labelName == "CheckSup") then
	    	setWalkerEnabled(false)	
		    if floor4 == true then
		            if (Self.ItemCount(ManaID) < MaxMana1) or (Self.ItemCount(HealthID) < MaxHealth1) or (CheckFood==true and (Self.ItemCount(FoodID) < MaxFood - 10)) then
						print("Not enough supplies to go hunt")
				        setWalkerEnabled(true) 
			            gotoLabel("Refill")
			        else
				        print("Going Hunt")
				        setWalkerEnabled(true) 
						gotoLabel("GoHunt")
			        end
			else
					if (Self.ItemCount(ManaID) < MaxMana) or (Self.ItemCount(HealthID) < MaxHealth) or (CheckFood==true and (Self.ItemCount(FoodID) < MaxFood - 10)) then
						print("Not enough supplies to go hunt")
				        setWalkerEnabled(true) 
			            gotoLabel("Refill")
			        else
				        print("Going Hunt")
				        setWalkerEnabled(true) 
						gotoLabel("GoHunt")
			        end
		    end
----------------------------------------------------------------------------------------------------
    elseif (labelName == "BuyPots") then
		setWalkerEnabled(false)
		if floor4 == true then
		        if (Self.ItemCount(ManaID) < MaxMana1 or Self.ItemCount(HealthID) < MaxHealth1) then
			    Self.SayToNpc({"hi", "flasks", "yes", "yes", "trade"}, 65)
		        sleep(math.random(600, 1100))
			    if (Self.ItemCount(ManaID) < MaxMana1) then
				Self.ShopBuyItem(ManaID, (MaxMana1 - Self.ItemCount(ManaID)))
		        sleep(math.random(600, 1100))
			    end
			    if (Self.ItemCount(HealthID) < MaxHealth1) then
				Self.ShopBuyItem(HealthID, (MaxHealth1 - Self.ItemCount(HealthID)))
		        sleep(math.random(600, 1100))
			    end
		        sleep(math.random(600, 1100))
				setWalkerEnabled(true)
		        end
        else
		        if (Self.ItemCount(ManaID) < MaxMana or Self.ItemCount(HealthID) < MaxHealth) then
			    Self.SayToNpc({"hi", "flasks", "yes", "yes", "trade"}, 65)
		        sleep(math.random(600, 1100))
			    if (Self.ItemCount(ManaID) < MaxMana) then
				Self.ShopBuyItem(ManaID, (MaxMana - Self.ItemCount(ManaID)))
		        sleep(math.random(600, 1100))
			    end
			    if (Self.ItemCount(HealthID) < MaxHealth) then
				Self.ShopBuyItem(HealthID, (MaxHealth - Self.ItemCount(HealthID)))
		        sleep(math.random(600, 1100))
			    end
		        sleep(math.random(600, 1100))
				setWalkerEnabled(true)
		        end
		end
	    setWalkerEnabled(true)
----------------------------------------------------------------------------------------------------
    elseif (labelName == "Deposit") then
		setWalkerEnabled(false)
            Self.ReachDepot()
            Self.DepositItems(
		{3429, 0},  	-- Black shield
		{10290, 0},  	-- Mini mummy
		{3065, 0},  	-- Terra rod
		{3418, 0},  	-- Bonelord shield	
		{7430, 0},  	-- dbone staff
		{3071, 0},  	-- woi
		{3322, 0},  	-- dragon hammer
		{3416, 0},  	-- dragon shield	
		{3297, 0},  	-- serpent sword
		{3371, 0},  	-- knight legs
		{3370, 0},  	-- knight armor
		{828, 0},  	    -- lightning headband
		{3055, 0},  	-- platinum amulet		
		{5898, 1},    	-- Bonelord Eye
		{5913, 1},   	-- Brown poc
		{5914, 1},  	-- Yellow poc
		{11481, 1}, 	-- Pelvis bone
		{9657, 1},  	-- Cyclops toe
		{11484, 1},  	-- Pile of grave earth
		{10291, 1},  	-- Rotten piece of cloth
		{9649, 1},  	-- Gauze bandage
		{11466, 1},  	-- Flask of embalming fluid
		{3027, 1},  	-- Black pearl
		{3028, 1},  	-- Small Diamond
		{10283, 1},  	-- Half-digested piece of meat
		{11512, 1},  	-- Small flask of eyedrops	
		{11457, 1},  	-- dragon's tail	
		{5877, 1},  	-- green dragon leather
		{5920, 1},  	-- green dragon scale
		{5879, 1},  	-- gs silk		
		{11467, 1} 	    -- Ghoul Snack
		)
		sleep(math.random(600, 1100))
		setWalkerEnabled(true)
----------------------------------------------------------------------------				
elseif (labelName == "Food") then
local withdrawFood = (MaxFood - (Self.ItemCount(FoodID)))
       	setWalkerEnabled(false)	
		if ((Self.ItemCount(FoodID)) < MaxFood) then
                Self.WithdrawItems(2, {FoodID, 0, withdrawFood})
		end
       	setWalkerEnabled(true)	
 ----------------------------------------------------------------------------------------------------
    elseif (labelName == "Check1") then
       	setWalkerEnabled(false)	
		if (Self.Cap() < MinCap) or (Self.ItemCount(ManaID) < MinMana) or (Self.ItemCount(HealthID) < MinHealth) or (CheckFood==true and (Self.ItemCount(FoodID) < MinFood)) then
                setWalkerEnabled(true)
		print("Leaving to resupply")
                gotoLabel("Leave1")
            else
                setWalkerEnabled(true)
            end
 ----------------------------------------------------------------------------------------------------
    elseif (labelName == "Down1") then
            setWalkerEnabled(false)
               if (Self.ItemCount(ManaID) <= MinMana) or (Self.Cap() <= MinCap) or (Self.ItemCount(HealthID) <= MinHealth) or (CheckFood==true and (Self.ItemCount(FoodID) < MinFood)) or (floor2 == false and floor3 == false) then
                setWalkerEnabled(true)
		print("No supplies or no floor 2")
                gotoLabel("Floor1")
            else
                setWalkerEnabled(true)
		print("Enough supplies- Going floor 2")
            end
 ----------------------------------------------------------------------------------------------------
    elseif (labelName == "Check2") then
       	setWalkerEnabled(false)	
		if (Self.Cap() < MinCap) or (Self.ItemCount(ManaID) < MinMana) or (Self.ItemCount(HealthID) < MinHealth) or (CheckFood==true and (Self.ItemCount(FoodID) < MinFood)) then
                setWalkerEnabled(true)
		print("Leaving to resupply")
                gotoLabel("Leave2")
            else
                setWalkerEnabled(true)
            end
 ----------------------------------------------------------------------------------------------------
    elseif (labelName == "Check3") then
       	setWalkerEnabled(false)	
		if (Self.Cap() < MinCap) or (Self.ItemCount(ManaID) < MinMana) or (Self.ItemCount(HealthID) < MinHealth) or (CheckFood==true and (Self.ItemCount(FoodID) < MinFood)) then
                setWalkerEnabled(true)
		print("Leaving to resupply")
                gotoLabel("Leave3")
            else
                setWalkerEnabled(true)
            end
 ----------------------------------------------------------------------------------------------------
    elseif (labelName == "Down2") then
            setWalkerEnabled(false)
               if (Self.ItemCount(ManaID) <= MinMana) or (Self.Cap() <= MinCap) or (Self.ItemCount(HealthID) <= MinHealth) or (CheckFood==true and (Self.ItemCount(FoodID) < MinFood)) or (floor3 == false and floor4 == false) then
                setWalkerEnabled(true)
		print("No supplies or no floor 3")
                gotoLabel("CheckFloor1")
            else
                setWalkerEnabled(true)
		print("Enough supplies- Going floor 3")
            end
 ----------------------------------------------------------------------------------------------------
    elseif (labelName == "Floor4") then
            setWalkerEnabled(false)
               if (Self.ItemCount(ManaID) <= MinMana1) or (Self.Cap() <= MinCap) or (Self.ItemCount(HealthID) <= MinHealth1) or (CheckFood==true and (Self.ItemCount(FoodID) < MinFood)) or (floor4 == false) then
                setWalkerEnabled(true)
		print("No supplies or no floor 4")
                gotoLabel("NoFloor4")
            else
                setWalkerEnabled(true)
		print("Enough supplies- Going floor 4")
            end
----------------------------------------------------------------------------
elseif (labelName == "Floor1") then
            delayWalker(1000)
            setWalkerEnabled(false)
               if floor1 == false then
                setWalkerEnabled(true)
		print("Not hunting floor 1")
                gotoLabel("NoFloor1")
            else
                setWalkerEnabled(true)
		print("Hunting Floor 1")
            end
----------------------------------------------------------------------------
elseif (labelName == "Geomancer") then
            delayWalker(1000)
            setWalkerEnabled(false)
               if geomancer == false then
                setWalkerEnabled(true)
		print("Not killing Dwarfs")
                gotoLabel("NoGeomancer")
            else
                setWalkerEnabled(true)
		print("Killing Dwarfs")
            end
----------------------------------------------------------------------------
elseif (labelName == "Drag1") then
            delayWalker(1000)
            setWalkerEnabled(false)
               if Drag1 == false then
                setWalkerEnabled(true)
		print("Not killing this Dragon and Hatchlings")
                gotoLabel("NoDrag1")
            else
                setWalkerEnabled(true)
		print("Killing Dragon and Hatchlings")
            end
----------------------------------------------------------------------------
elseif (labelName == "Hardcore") then
            delayWalker(1000)
            setWalkerEnabled(false)
               if Hardcore == false then
                setWalkerEnabled(true)
		print("Not going to Hardcore")
                gotoLabel("NoHardcore")
            else
                setWalkerEnabled(true)
		print("Going to Hardcore")
            end
----------------------------------------------------------------------------
elseif (labelName == "Drag2") then
            delayWalker(1000)
            setWalkerEnabled(false)
               if Drag2 == false then
                setWalkerEnabled(true)
		print("Not killing this Dragon and Hatchlings")
                gotoLabel("NoDrag2")
            else
                setWalkerEnabled(true)
		print("Killing Dragon and Hatchlings")
            end
----------------------------------------------------------------------------
elseif (labelName == "KillGS") then
            delayWalker(1000)
            setWalkerEnabled(false)
               if KillGS == false then
                setWalkerEnabled(true)
		print("Not killing Giant Spider")
                gotoLabel("NoKillGS")
            else
                setWalkerEnabled(true)
		print("Going to kill Giant Spider")
            end
----------------------------------------------------------------------------
elseif (labelName == "Dragons") then
            delayWalker(1000)
            setWalkerEnabled(false)
               if Dragons == false then
                setWalkerEnabled(true)
		print("Not killing Dragons")
                gotoLabel("NoDragons")
            else
                setWalkerEnabled(true)
		print("Killing 3x Dragons")
            end
----------------------------------------------------------------------------
elseif (labelName == "BreakSilk") then
            delayWalker(1000)
            setWalkerEnabled(false)
            repeat
            Self.UseItemWithGround(WeaponID, 32433, 31993, 14)
		    sleep(math.random(600, 1100))
            until tostring(Map.IsTileWalkable(32433, 31993, 14)) == "true"
            setWalkerEnabled(true)
----------------------------------------------------------------------------
elseif (labelName == "Floor2") then
            delayWalker(1000)
            setWalkerEnabled(false)
               if floor2 == false then
                setWalkerEnabled(true)
		print("Not hunting floor 2")
                gotoLabel("NoFloor2")
            else
                setWalkerEnabled(true)
		print("Hunting Floor 2")
            end
----------------------------------------------------------------------------
elseif (labelName == "Floor3") then
            delayWalker(1000)
            setWalkerEnabled(false)
               if floor3 == false then
                setWalkerEnabled(true)
		print("Not hunting floor 3")
                gotoLabel("NoFloor3")
            else
                setWalkerEnabled(true)
		print("Hunting Floor 3")
            end
----------------------------------------------------------------------------------------------------
    elseif (labelName == "CheckUp") then
            delayWalker(1000)
            setWalkerEnabled(false)
               if (floor2 == true) or (floor1 == true) then
                setWalkerEnabled(true)
		print("Going up")
            else
                setWalkerEnabled(true)
		print("Not hunting floors Up")
                gotoLabel("Floor3")
            end
------------------------------------------------------
elseif (labelName == "CheckFloor1") then
            delayWalker(1000)
            setWalkerEnabled(false)
               if floor1 == true then
                setWalkerEnabled(true)
		print("Going to Floor 1")
            else
                setWalkerEnabled(true)
		print("Hunting Floor 2")
                gotoLabel("Floor2")
            end
------------------------------------------------------
elseif (labelName == "ToFloor1") then
            delayWalker(1000)
		print("Hunting floor 1")
                gotoLabel("Floor1")
------------------------------------------------------
elseif (labelName == "ToRefill") then
            delayWalker(1000)
		print("Refilling")
                gotoLabel("Refill")
----------------------------------------------------------------------------------------------------
end
end