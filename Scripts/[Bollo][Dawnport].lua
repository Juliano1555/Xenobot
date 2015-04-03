-----------------------------------------------------------------------------------------------------------------------
-- 		   ____        ____         _____           _       __      
-- 		  / __ )____  / / /___     / ___/__________(_)___  / /______
-- 		 / __  / __ \/ / / __ \    \__ \/ ___/ ___/ / __ \/ __/ ___/
-- 		/ /_/ / /_/ / / / /_/ /   ___/ / /__/ /  / / /_/ / /_(__  ) 
--	   /_____/\____/_/_/\____/   /____/\___/_/  /_/ .___/\__/____/  
--                                      	     /_/                
-----------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------

--		SETTINGS	--
local Vocation = "knight"		--- What vocation do you want to be? "Knight" / "Paladin" / "Sorcerer" / "Druid"
local Town = "thais"		--- What town do you want to go to?

-----------------------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------------------
--- 		Misc 			---		
-----------------------------------------------------------------------------------------------------------------------
Targeting.Start()
Looter.Start()
registerEventListener(WALKER_SELECTLABEL, "onWalkerSelectLabel")
-----------------------------------------------------------------------------------------------------------------------

print([[
-----------------------------------
----This script was created by:----
-----------------------------------
---------------Bollo---------------
-----------------------------------
----If any questions or problems---
----PM me or write in my thread!---
-----------------------------------
----------Happy Hunting!-----------
-----------------------------------]])
wait(1000)

function onWalkerSelectLabel(labelName)
     if (labelName == "CheckLevel") then
        Walker.Stop()	
		if (Self.Experience() > 4200) then
			Walker.Goto("Level8")
			print([[Enough experience to leave Dawnport, leaving..]])
		else
			Walker.Goto("StartHunt")
			print([[Not level 8 yet, keep hunting..]])
		end
		Walker.Start()
		
	elseif (labelName == "Oressa") then  
		Walker.Stop()
		Creature.Follow("Oressa")
		Self.SayToNpc("hi")
		wait(900,1200)
		Self.SayToNpc("choose")
		wait(900,1200)
		if (Vocation == "Druid" or Vocation == "druid") then
			print([[Vocation == Druid]])
			Self.SayToNpc("distance")
			wait(1400,1600)
			Self.SayToNpc("magic")
			wait(1400,1600)
			Self.SayToNpc("heal")
			wait(1400,1600)
			Self.SayToNpc("yes")
		elseif (Vocation == "Paladin" or Vocation == "paladin") then
			print([[Vocation == Paladin]])
			Self.SayToNpc("distance")
			wait(1400,1600)
			Self.SayToNpc("bow")
			wait(1400,1600)
			Self.SayToNpc("yes")
		elseif (Vocation == "Sorcerer" or Vocation == "sorcerer") then
			print([[Vocation == Sorcerer]])
			Self.SayToNpc("distance")
			wait(1400,1600)
			Self.SayToNpc("magic")
			wait(1400,1600)
			Self.SayToNpc("death")
			wait(1400,1600)
			Self.SayToNpc("yes")
		elseif (Vocation == "Knight" or Vocation == "knight") then
			print([[Vocation == Knight]])	
			Self.SayToNpc("close")
			wait(1400,1600)
			Self.SayToNpc("yes")
		else
			print([[Vocation == ??? ERROR!]])
		end
		Walker.Start()

	
	elseif (labelName == "Travel") then  
		Walker.Stop()
		Creature.Follow("Captain Dreadnaught")
		wait(900,1200)
		Self.SayToNpc("hi")
		wait(900,1200)
		Self.SayToNpc("yes")
		wait(900,1200)
		Self.SayToNpc("yes")
		wait(900,1200)
		Self.SayToNpc("cities")
		wait(900,1200)
		Self.SayToNpc("sail")
		wait(900,1200)
		Self.SayToNpc(Town)
		wait(900,1200)
		Self.SayToNpc("yes")
		wait(2000,2200)
		Walker.Start()
		
	elseif (labelName == "VocationDoor") then  
		Walker.Stop()
		if (Vocation == "Knight" or Vocation == "knight") then
			Walker.Goto("Knight")
		elseif (Vocation == "Paladin" or Vocation == "paladin") then
			Walker.Goto("Paladin")
		elseif (Vocation == "Sorcerer" or Vocation == "sorcerer") then
			Walker.Goto("Sorcerer")
		elseif (Vocation == "Druid" or Vocation == "druid") then
			Walker.Goto("Druid")
		end
		Walker.Start()	
		
	
	elseif (labelName == "VenoreAnk") then  
		Walker.Stop()
		Creature.Follow("Captain Fearless")
		wait(1400,1600)
		Self.SayToNpc("hi")
		wait(900,1200)
		Self.SayToNpc("ankrahmun")
		wait(900,1200)
		Self.SayToNpc("yes")
		wait(1400,1600)
		Walker.Start()
		
	elseif (labelName == "AnkDara") then  
		Walker.Stop()
		Creature.Follow("captain sinbeard")
		wait(1400,1600)
		Self.SayToNpc("hi")
		wait(900,1200)
		Self.SayToNpc("darashia")
		wait(900,1200)
		Self.SayToNpc("yes")
		wait(900,1200)
		Walker.Start()
		
	elseif (labelName == "wait") then  
		Walker.Stop()
		wait(900,1200)
		Walker.Start()	
		
	elseif (labelName == "Backpack") then  
		Walker.Stop()
		print([[Opening Backpack..]])
		wait(1000,1500)
		Self.CloseContainers()
		wait(2000,3000)
		Self.OpenMainBackpack(true)
		wait(900,1200)
		Walker.Start()	

	elseif (labelName == "KnightDoor") then
		Walker.Stop()
		wait(700,1200)
		Self.UseItemFromGround(32069, 31885, 6)
		wait(700,1200)
		Self.UseItemFromGround(32069, 31885, 6)
		wait(2000,2500)
		Self.UseItemFromGround(32068, 31882, 6)
		wait(1200,1500)
		Self.UseItemFromGround(32068, 31882, 6)
		wait(700,1200)
		Walker.Goto("ReconnectAll")
		Walker.Start()
		
	elseif (labelName == "SorcererDoor") then
		Walker.Stop()
		wait(700,1200)
		Self.UseItemFromGround(32055, 31885, 6)
		wait(700,1200)
		Self.UseItemFromGround(32055, 31885, 6)
		wait(2000,2500)
		Self.UseItemFromGround(32054, 31882, 6)
		wait(700,1200)
		Self.UseItemFromGround(32054, 31882, 6)
		wait(1200,1500)
		Walker.Goto("ReconnectAll")
		Walker.Start()
		
	elseif (labelName == "PaladinDoor") then
		Walker.Stop()
		wait(700,1200)
		Self.UseItemFromGround(32059, 31885, 6)
		wait(700,1200)
		Self.UseItemFromGround(32059, 31885, 6)
		wait(2000,2500)
		Self.UseItemFromGround(32059, 31882, 6)
		wait(700,1200)
		Self.UseItemFromGround(32059, 31882, 6)
		wait(700,1200)
		Walker.Goto("ReconnectAll")
		Walker.Start()
		
	elseif (labelName == "DruidDoor") then
		Walker.Stop()
		wait(700,1200)
		Self.UseItemFromGround(32073, 31885, 6)
		wait(700,1200)
		Self.UseItemFromGround(32073, 31885, 6)
		wait(2000,2500)
		Self.UseItemFromGround(32073, 31882, 6)
		wait(700,1200)
		Self.UseItemFromGround(32073, 31882, 6)
		wait(700,1200)
		Walker.Goto("ReconnectAll")
		Walker.Start()
	
	elseif (labelName == "ScriptDONE") then
		Walker.Stop()
		print([[You reached the Mainland! Script made by Bollo.]])
		
end
	
end
	
-----


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

-----



