local SpearMax = 20 -- Buy this many spears before going on hunt.
local SpearLeave = 5 -- How many spears to leave cave?
local MinCap = 5 --How much cap to leave cave?
local SpearPrice = 10


local GoldBP = 'red backpack' -- Name of your gold stacking backpack 
--- Your #1 BP Inside depot will recieve stackables

local SpearID = 3277 	-- 	Change to royal spear if u want. 
						--	3277 = spear. Royal spear = 7378 
						
						
local CashWithdraw = SpearMax*SpearPrice	

registerEventListener(WALKER_SELECTLABEL, "onWalkerSelectLabel")


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
wait(7000)



function onWalkerSelectLabel(labelName)
   if (labelName == "checker") then
        if (Self.Cap() < MinCap) then
            Walker.Goto("leaveCave")
		elseif (Self.ItemCount(SpearID) < SpearLeave) then
			Walker.Goto("leaveCave")
        else
            Walker.Goto("keepHunting")			
end

elseif (labelName == 'refiller') then
		Walker.Stop()
		sleep(math.random(800, 1300))
		Self.Say("hi")
		sleep(math.random(800, 1300))
		Self.SayToNpc("trade")
		sleep(math.random(800, 1300))
		local t = SpearMax - Self.ItemCount(SpearID)
		Self.ShopBuyItemsUpTo(SpearID, t)
		sleep(math.random(800, 1300))
		Walker.Start()

elseif (labelName == "BackpackReset") then  
        Walker.Stop()
		wait(2000,4000)
		Self.CloseContainers()
		wait(2000,4000)
		Self.OpenMainBackpack(true):OpenChildren({Item.GetID(GoldBP),true})
			wait(2000,4000)
		Walker.Start()


elseif (labelName == "bank") then
        Walker.Stop()
		sleep(math.random(1500, 1700))
        Self.Say("hi")
        sleep(math.random(1500, 1700)) 
        Self.SayToNpc("deposit all")
        sleep(math.random(900, 1000))
        Self.SayToNpc("yes")
		sleep(math.random(900, 1000))
		local moneySpears = (SpearMax - Self.ItemCount(SpearID)) * SpearPrice
		Self.WithdrawMoney(moneySpears)
		sleep(math.random(800, 1000))
		Walker.Start()
		setTargetingEnabled(true)
    
elseif (labelName == "deposit") then
		Walker.Stop()
		sleep(math.random(800, 1300))
		Self.ReachDepot()
		sleep(math.random(800, 1000))
        Self.DepositItems({11485, 0}, {9634, 0}, {11481, 0}, {10291, 0}, {11467, 0}, {11484, 0}, {3052, 0}, {5913, 0})  
		wait(1500)
		Walker.Start()

elseif (labelName == "Shovel") then
Self.UseItemWithGround(3457, 32613, 32703, 7)
wait(600, 1400)
end
end

Self.ReachDepot = function (tries)
    local tries = tries or 3
    setWalkerEnabled(false)
    delayWalker(1000)
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
            wait(1000, 1500)
            if Self.DistanceFromPosition(pos.x, pos.y, pos.z) >= 1 then
                wait(1000, 2000)
                if Self.DistanceFromPosition(location.x, location.y, location.z) == 1 then
		    Self.DepositItems({'3033','0'}, {'3032', '0'}, {'3042', '0'}, {'9641', '0'})
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