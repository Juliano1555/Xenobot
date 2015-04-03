
----------------------------------- ***************************** -----------------------------------
----------------------------------- ** AB TROLLCAVE BY TIBTRAK ** -----------------------------------
----------------------------------- ***************************** -----------------------------------

---CUSTOMIZE YOUR SCRIPT BELOW---

---Bp Setup---
GoldBpID = Item.GetID('green backpack') -- Put the ID of your backpack for gold
	--Have one bp in the first slot in dp to deposit loot

---Potions & Cap Setup---

--Cap
CapToRefill = 10 -- below this amount bot goes to refill
--Manas
ManaPotsID = 268 -- ID of manapotion
ManasToBuy = 0 -- Amount of mana potions to buy
ManaPotsToRefill = 0 -- below this amount bot goes to refill
ManaPotsPrice = 50 -- Price of manapotion
--Healths
HealthPotsID = 266 -- ID of healthpotion you want to buy
HealthPotsPrice = 45 -- Price of healthpotion
HealthPotsToBuy = 5 -- Amount of healthpotions to buy
HealthPotsToRefill = 0 -- below this amount bot goes to refill
--Spears
SpearID = 3277 -- ID of spear
SpearsToBuy = 0 -- Ammount of spears to buy
SpearPrice = 9 -- Price of spear
WeaponID = 7773 -- ID of the weapon you'll use if low on spears
SwitchToSpears = 0 -- Amount of spears you want to switch from weapon and back to using spears again
--Pick-up Spears
MaxSpears = 0 -- Maximum amount of spears you want to loot
Waittime = 30000 -- How long waittime for it to check the current amount of spears
--Weapon Changer
WeaponID = 3297 -- ID of the weapon you'll use if low on spears
SwitchToSpears = 3 -- Amount of spears you want to switch from weapon and back to using spears again


---Others---
Floor3 = true -- true if you want to go down to the third floor, else false
Floor4 = true -- true if you want to go down to the fourth floor, else false

	
-----------------------------------------------------------------------------------------------------
------- Do Not Touch Below! :) ----------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------

    local info = [[
	Info:
    Script name: AB TrollCave for Paladins
    Made by: Tibtrak]]
	print(info)
    wait(500)


registerEventListener(WALKER_SELECTLABEL, "onWalkerSelectLabel")
function onWalkerSelectLabel(labelName)
	if (labelName == "Start") then
		Targeting.Start()
		Looter.Start()
		wait(500)
	elseif (labelName == "CheckStatus") then
		Cavebot.Stop()
		if ((Self.ItemCount(ManaPotsID) < ManaPotsToRefill)) or (Self.Cap() < CapToRefill) or ((Self.ItemCount(HealthPotsID) < HealthPotsToRefill)) then
			Cavebot.Start()
			Walker.Goto("ToTown")
		else
			Cavebot.Start()
			Walker.Goto("Hunt")
		end
	elseif (labelName == "CheckManas") then
		Walker.Stop()
		if (Self.ItemCount(ManaPotsID) < ManasToBuy) then
            Walker.Start()
            Walker.Goto("GoManas")
        else
			Walker.Start()
        end
	--[[elseif (labelName == "CheckSpears1") then
		Walker.Stop()
		if (Self.ItemCount(SpearID) < SpearsToBuy) then
            Walker.Start()
            Walker.Goto("GoSpears")
        else
			Walker.Start()
        end
	elseif (labelName == "CheckSpears2") then
		Walker.Stop()
		if (Self.ItemCount(SpearID) < SpearsToBuy) then
            Walker.Start()
            Walker.Goto("GoSpears")
        else
			Walker.Goto("Start")
			Walker.Start()
        end]]--
	elseif (labelName == "ReopenBps") then
        Walker.Stop()
		wait(1000,2000)
        Self.CloseContainers()
		wait(1000,2000)
		Self.OpenMainBackpack():OpenChildren(GoldBpID)
		wait(1000,2000)
		Walker.Start()
	elseif (labelName == "Floor3") then
		Walker.Stop()
		if Floor3 == true then
			Walker.Start()
		else
			Walker.Goto("No3")
			Walker.Start()
		end
	elseif (labelName == "Floor4") then
		Walker.Stop()
		if Floor4 == true then
			Walker.Start()
		else
			Walker.Goto("No4")
			Walker.Start()
		end
	elseif (labelName == "DepositCash") then
		Walker.Stop()
		wait(1000,2000)
		Self.SayToNpc({"hi", "deposit all", "yes"}, 65)
		wait(1000,2000)
		Walker.Start()
	elseif (labelName == "WithdrawCash") then
		Walker.Stop()
		Self.SayToNpc('hi')
		wait(1000,2000)
		local GoldToManas = ((ManasToBuy-Self.ItemCount(ManaPotsID))*ManaPotsPrice)
		local GoldToHealth = ((HealthPotsToBuy-Self.ItemCount(HealthPotsID))*HealthPotsPrice)
		local GoldToMP = math.ceil(GoldToManas / 1000) * 1000
		local GoldToHP = math.ceil(GoldToHealth / 1000) * 1000
		Self.SayToNpc("withdraw " .. GoldToMP + GoldToHP)
		wait(1000,2000)
		Self.SayToNpc('yes')
		wait(1000,2000)
		Walker.Start()
	elseif (labelName == "DepositLoot") then
		Walker.Stop()
		Self.DepositItems({9689, 0}, {11515, 0})
		wait(1000,2000)
		Walker.Start()
	elseif (labelName == "BuyPotions") then
		Walker.Stop()
		Self.SayToNpc({"Hi", "Trade"}, 65)
		wait(1000,2000)
		Self.ShopSellItem(284, (Self.ItemCount(284)))
		wait(1000,2000)
		Self.ShopSellItem(285, (Self.ItemCount(285)))
		wait(1000,2000)
		Self.ShopBuyItemsUpTo(HealthPotsID, HealthPotsToBuy)
		wait(1000,2000)
		Self.ShopBuyItemsUpTo(ManaPotsID, ManasToBuy)
		wait(1000, 2000)
		Walker.Start()
	--[[elseif (labelName == "BuySpears") then
		Walker.Stop()
		Self.SayToNpc({"Hi", "Trade"}, 65)
		wait(1000,2000)
		Self.ShopBuyItemsUpTo(SpearID, SpearsToBuy)
		wait(1000, 2000)
		Walker.Start()]]--
	elseif (labelName == "CheckPotions") then
		Walker.Stop()
		if ((Self.ItemCount(ManaPotsID) < ManasToBuy)) then
			Walker.Start()
			Walker.Goto("BeforePotions")
		else
			Walker.Start()
		end
	elseif (labelName == "OpenDoorSKey") then
		Walker.Stop()
	    if not (Map.IsTileWalkable(Self.Position().x, Self.Position().y+1, Self.Position().z)) then --is door already open
			Self.UseDoor(Self.Position().x, Self.Position().y+1, Self.Position().z)
			wait(900,1200)
			if not (Map.IsTileWalkable(Self.Position().x, Self.Position().y+1, Self.Position().z)) then --it is locked
				useKeyOnDoor(2969, Self.Position().x, Self.Position().y+1, Self.Position().z)
				wait(900,1200)
			end
		end
		Walker.Start()
	elseif (labelName == "OpenDoorNKey") then
		Walker.Stop()
	    if not (Map.IsTileWalkable(Self.Position().x, Self.Position().y-1, Self.Position().z)) then --is door already open
			Self.UseDoor(Self.Position().x, Self.Position().y-1, Self.Position().z)
			wait(900,1200)
			if not (Map.IsTileWalkable(Self.Position().x, Self.Position().y-1, Self.Position().z)) then --it is locked
				useKeyOnDoor(2969, Self.Position().x, Self.Position().y-1, Self.Position().z)
				wait(900,1200)
			end
		end
		Walker.Start()
	elseif (labelName == "ReachDepot") then	
		local attempt = attempt or 4
		Walker.Stop()
		local DepotIDs = {3497, 3498, 3499, 3500}
		local DepotPos = {}
		for i = 1, #DepotIDs do
			local dps = Map.GetUseItems(DepotIDs[i])
			for d = 1, #dps do
				table.insert(DepotPos, dps[d])
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
					print("There is something blocking the path.")
				end
			end
			return false
		end
		repeat
			reachedDP = gotoDepot()
			if reachedDP then
				return true
			end
			attempt = attempt - 1
			sleep(100)
			print("Attempt to reach depot was unsuccessfull. " .. attempt .. " attempts left.")
		until attempt <= 0
		return false
	end
end

--[[Find Certain Items On Screen]]--
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

function useKeyOnDoor(keyID, x, y, z)
    local Cont = Container.New(0) -- check in main backpack (index is 0)
    if Cont:CountItemsOfID(keyID) > 0 then
        for s = 0, Cont:ItemCount() do --find specific itemid spot
            local item = Cont:GetItemData(s)
            if item.id == keyID then
                Cont:UseItemWithGround(s, x, y, z)
            end
        end
    end
end