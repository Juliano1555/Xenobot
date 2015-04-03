---------------------------------
--------Dawnport Start-----------
------------By Xux---------------
------------Enjoy!!!-------------
---------------------------------

local level = 20				--What lvl should you atleast get?

--------------------------------------------------------------------
--------------------------------------------------------------------
--------------------------------------------------------------------
--------------------------------------------------------------------
------------------------Do Not Adjust this--------------------------
local MerchantsAndItems =
{
	DawnportGear = {"Studded Helmet", "Chain Helmet"},
	DawnportOther = {"Bunch Of Troll Hair", "swampling moss", "damselfly eye", "damselfly wing", "marsh stalker feather"},
}

local betterEQ = false


Targeting.Start()
Looter.Start()

registerEventListener(WALKER_SELECTLABEL, "onWalkerSelectLabel")
	
    print([[
    Dawnport by Xux]])
    wait(5000)
	
function onWalkerSelectLabel(labelName)
	if (labelName == "checkerNormal") then
		Walker.ConditionalGoto((Self.Cap() < 50) or (Self.Level() >=level), "leaveNormal", "atNormalM")
	elseif (labelName == "gotoCityStuff") then
		Walker.ConditionalGoto((Self.Cap() < 50), "cityStuff", "cityStuff")
	elseif (labelName == "gotoPartDone") then
		Walker.ConditionalGoto((Self.Cap() < 50), "firstPartDone", "firstPartDone")
	elseif (labelName == "checkEQ") then
		print(Self.ItemCount(3361))
		Walker.ConditionalGoto((Self.ItemCount(3361)==1), "normalMonsters", "easyMonsters")
	elseif (labelName == "checkLevel") then
		if(Self.Level() >=level) then
			os.exit()
		else
			Walker.Goto("keepRolling")
		end
		

	elseif (labelName == "taskCheck") then
		Walker.ConditionalGoto((Self.GetCreatureKills("tarantula") >= taskTarantula)and(bossKills<3), "goTask", "Depot")	
		
	elseif (labelName == "hole") then
		wait(1000)

	elseif (labelName == "sellGear") then
		Walker.Stop()
		print([[Selling helmets and stuff.]])
		Self.SayToNpc({'hi','trade'}, 65)
		wait(400)
		for i = 1, #MerchantsAndItems.DawnportGear do
			if (Self.ShopGetItemSaleCount(MerchantsAndItems.DawnportGear[i]:lower()) >= 1) then
				Self.ShopSellAllItems(MerchantsAndItems.DawnportGear[i])
				wait(300, 500)
			end
		end
		Walker.Start()
	
	elseif (labelName == "sellOther") then
		Walker.Stop()
		print([[Selling creature items.]])
		Self.SayToNpc({'hi','trade'}, 65)
		wait(400)
		for i = 1, #MerchantsAndItems.DawnportOther do
			if (Self.ShopGetItemSaleCount(MerchantsAndItems.DawnportOther[i]:lower()) >= 1) then
				Self.ShopSellAllItems(MerchantsAndItems.DawnportOther[i])
				wait(300, 500)
			end
		end
		Walker.Start()

	elseif (labelName == "goMissionFirst") then
		Walker.Stop()
		Self.Equip(2920, "ammo", 1)
		wait(1500)
		Self.DropItems(Self.Position().x, Self.Position().y, Self.Position().z, 21470)
		wait(1500)
		Walker.Start()
		
	elseif (labelName == "betterEQ") then
		Walker.Stop()
		if(Self.Money() > 104 and (Self.ItemCount(3562)==1)) then
			wait(700,1100)	
			Self.SayToNpc({'hi','trade'}, 65)	
			wait(700,1100)		
			Self.ShopBuyItem("Leather Armor", 1)
			wait(700,1100)
			Self.Equip(3361, "armor", 1)
			wait(1500)
			Self.DropItems(Self.Position().x, Self.Position().y, Self.Position().z, 3562)
			wait(1100)
			Self.ShopBuyItem("Sabre", 1)
			wait(700,1100)
			Self.Equip(3273, "weapon", 1)
			wait(1500)
			Self.DropItems(Self.Position().x, Self.Position().y, Self.Position().z, 3267)
			wait(1500)
			Self.ShopBuyItem("Studded Shield", 1)
			wait(1000,2000)
			Self.Equip(3426, "shield", 1)
			wait(1500)
			Self.DropItems(Self.Position().x, Self.Position().y, Self.Position().z, 3412)
			wait(1100)
			betterEQ = true
		end	
		Walker.Start()
	
	
	elseif (labelName == "depositGold") then
		Walker.Stop()
		if(Self.ItemCount(3361)==1) then
		print("Deposit Gold")
			Self.SayToNpc({"hi", "deposit all", "yes"}, 95)
		end
		wait(2000)		
		Walker.Start()
		
	elseif (labelName == "takeMissions") then
		Walker.Stop()
		Self.SayToNpc({"hi", "mission", "trolls", "yes", "goblins", "yes", "minotaurs", "yes", "herb", "yes", "log book", "yes"}, 165)
		wait(2000)		
		Walker.Start()

	elseif (labelName == "doneLogBook") then
		Walker.Stop()
		Self.SayToNpc({"hi", "log book", "yes"}, 165)
		Self.SayToNpc({"hi", "trolls", "yes"}, 165)
		wait(2000)		
		Walker.Start()
		
	elseif (labelName == "bank") then
		local withdrawManas = math.max(MaxMana - Self.ItemCount(268), 0)*50
		local withdrawHealths = math.max(MaxHealth - Self.ItemCount(266), 0)*45
		local totalmoneyneeded = (withdrawManas + withdrawHealths)
		local MATHCEIL = (math.ceil((totalmoneyneeded/1000)))*1000
		Walker.Stop()
		Self.SayToNpc({"hi", "deposit all", "yes"}, 65)
		if (totalmoneyneeded > 0) then
			Self.SayToNpc({"withdraw " .. totalmoneyneeded, "yes"}, 65)   
		end  
		wait(2000)
		Walker.Start()

	elseif (labelName == "deposit") then
		Walker.Stop()
		Self.ReachDepot()
		Self.DepositItems({18997, 0},{18996, 0},{18993, 0},{10293, 0},{5902, 0},{5897, 0},{10279, 0},{10273, 0},{9634, 0},{10301, 0},{9686, 0},{9640, 0},{10272, 0},{11514, 0},{5883, 0},{11471, 0},{10300, 0},{647, 0},{8031, 0},{3033, 0},{11511, 0})
		Self.DepositItems({12517, 1},{3556, 1},{830, 1},{12311, 1},{3556, 1},{3348, 1},{3072, 1},{3012, 1})		
		wait(1500,1900)
		if (LogoutStamina) and (Self.Stamina() < 960) then
			Walker.Stop()
		else
			Walker.Start()
		end	

	elseif (labelName == "potions") then
		Walker.Stop()
		if (Self.ItemCount(268) < MaxMana) or (Self.ItemCount(266) < MaxHealth) then
			Self.SayToNpc({"hi", "flasks", "yes", "yes", "yes", "yes", "yes", "yes", "trade"}, 65)
			wait(2000)
			if (Self.ItemCount(268) < MaxMana) then
				BuyItems(268, MaxMana)
				wait(500)
				BuyItems(268, MaxMana)
				wait(500)
			end
			if (Self.ItemCount(266) < MaxHealth) then
				BuyItems(266, MaxHealth)
				wait(500)
			end
			wait(200, 500)
		end
		Walker.Start()	
	end
end

----------------------- Functions ----------------------
function BuyItems(item, count) -- item = item id, count = how many you want to buy up to
	wait(900, 1200)
	if (Self.ItemCount(item) < count) then
		Self.ShopBuyItem(item, (count-Self.ItemCount(item)))
		wait(200, 500)
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
local longsword = false
Checker = Module.New('longsword checker', function(mod)
	if (Self.ItemCount(3285) >0 and longsword ==false) then
		Cavebot.Stop()
		print("Holy cow!! It is the longsword!!")
		Self.Equip(3285, "weapon", 1)
		wait(1500)
		Self.DropItems(Self.Position().x, Self.Position().y, Self.Position().z, 3273)
		wait(1500)
		longsword = true
		Cavebot.Start()
		Checker:Stop()
		mod:Delay(20000)
	end
	mod:Delay(19000)
end
)

Module.New('sword dropper', function(module)
    if (Self.ItemCount(3285) > 1) then
        delayWalker(1000)
        print("Dropping longsword.")
        Self.DropItem(Self.Position().x, Self.Position().y, Self.Position().z, 3285, 1)
    else

    end
    module:Delay(2000,10000)
end)