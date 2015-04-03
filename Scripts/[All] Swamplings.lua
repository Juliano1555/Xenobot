--      //////////////////////////////////
--      //    ___                   _   //
--      //   / _ \                 (_)  //
--      //  / /_\ \_   ____ _ _ __  _   //
--      //  |  _  \ \ / / _` | '_ \| |  //
--      //  | | | |\ V / (_| | | | | |  //
--      //  \_| |_/ \_/ \__,_|_| |_|_|  //
--      //                              //
--      //////////////////////////////////

----------- DP SETUP -----------
-- [DP 1] - Loot
-- [DP 2] - Health Potions

------------------------  SETTINGS  ---------------------------
HPotID = 266        ---- Health Potion ID
HPots = 15          ---- Amount of health potions to refill
MinHPots = 3        ---- If less then x HP, script will refill
HPCost = 45         ---- The price of one Health Potion

MinCap = 20         ---- if less, script will refill

GoldBp = "backpack"
HideEquipment = true --- Do you want to minimize your equipment?
LogoutStamina = true --- Do you want to logout at 16 hours? (Inside the depot)

---------------------------------------------------------------
-------------  DO NOT CHANGE ANYTHING BELOW  ------------------
---------------------------------------------------------------

registerEventListener(WALKER_SELECTLABEL, "onWalkerSelectLabel")

local info = [[
Venore Swamplings:
    By Avani]]

Targeting.Start()
Looter.Start()

function onWalkerSelectLabel(labelName)
	if (labelName == "Check") then
		Walker.ConditionalGoto((Self.Cap() < MinCap) or (Self.ItemCount(HPotID) <= MinHPots), "Leave", "Hunt")

	elseif (labelName == "MidCheck") then
		Walker.ConditionalGoto((Self.Cap() < MinCap) or (Self.ItemCount(HPotID) <= MinHPots), "Leave")

	elseif (labelName == "Bank") then
		local mpwith = ((HPots - Self.ItemCount(HPotID)) > 0 and ((HPots - Self.ItemCount(HPotID))* HPCost) or 0)
		Walker.Stop()
		wait(500, 900)
		Self.SayToNpc({"hi", "deposit all", "yes"}, 65)
		Self.SayToNpc({"withdraw " .. mpwith, "yes", "balance"}, 65)
		wait(500, 900)
		Walker.Start()

	elseif (labelName == "GoHunt") then
		print(info)

	elseif (labelName == "ResetBP") then
		Walker.Stop()
		wait(1000) 
		Self.CloseContainers()		
		wait(1000)
		Self.OpenMainBackpack(true):OpenChildren({Item.GetID(GoldBp),true})
		wait(2000)
		if (HideEquipment) then
			Client.HideEquipment()
			wait(1000)
		end
		Walker.Start()  

	elseif (labelName == "Potion") then
		Walker.Stop()
		Self.SayToNpc({"hi", "deposit all", "yes", "yes", "yes", "trade"}, 65)
		wait(600,800)
        Self.ShopBuyItem(HPotID, (HPots-Self.ItemCount(HPotID)))
		wait(600, 800)
		Walker.Start()  

	elseif (labelName == "Deposit") then
		Walker.Stop()
		Self.ReachDepot()
		Self.DepositItems({17823, 0},{17822, 0},{17458, 0},{17463, 0},{647, 0}, {17462, 0},{17461, 0})
		wait(1000)
		Self.WithdrawItems(1, {HPotID, 0,(HPots-Self.ItemCount(HPotID))})
		wait(1000)
		if (LogoutStamina) and (Self.Stamina() < 960) then
			Walker.Stop()
		else
			Walker.Start()
		end
	end
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