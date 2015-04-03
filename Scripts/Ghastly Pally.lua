CapToLeave = 90

Supplies =
{
	{id = Item.GetID("strong mana potion"), required = 300, toLeave = 80, price = 80}
}

StaminaToLeave = 14 * 60 --in hours

LootBP = "red backpack"
ProductBP = "blue backpack"
SuppliesBP = "purple backpack"
MainBP = "backpack"

SoftBoots = true
SecondaryBoots = Item.GetID("boots of haste")

registerEventListener(WALKER_SELECTLABEL, "onWalkerSelectLabel")
setTargetingEnabled(true)
setLooterEnabled(true)


MailInfo =
{
	Parcels = 0,
	Labels = 0,
	Moved = 0,
	Dropped = 0
}
	

print([[
Ghastly Dragon Script for Paladins by Darkhaos
]])

--wagon 7132
LEAVING = false
function onWalkerSelectLabel(labelName)

	if labelName == "Start" then
		Walker.Stop()		
		Self.CloseContainers()
		sleep(math.random(800, 1200))
		Self.OpenMainBackpack(true):OpenChildren({Item.GetID(LootBP),true}, {Item.GetID(ProductBP), true}, {Item.GetID(SuppliesBP), true})
		wait(3000)
		
		if Self.Stamina() > StaminaToLeave then
			Walker.Start()
			Looter.Start()
			LEAVING = false
		else
			return true
		end
	elseif labelName == "CheckSupp" then
		Walker.Stop()
		local go = false
		for _, supply in ipairs(Supplies) do
			if Self.ItemCount(supply.id) < supply.required then
				go = true
				break
			end
		end
		if go then
			gotoLabel("GoBuySupp")
		else
			gotoLabel("GoToCave")
		end
		Walker.Start()
	elseif labelName == "ExaniTera" then
		Walker.Stop()
		local pos = Self.Position()
		local tries = 0
		repeat
			Self.Say("exani tera")
			tries = tries + 1
			wait(1000)
		until pos.z ~= Self.Position().z or tries >= 5
		wait(1000)
		Walker.Start()
	elseif labelName == "ShovelWest" then
		Walker.Stop()
		local shovels = {Item.GetID("shovel"), Item.GetID("light shovel"), Item.GetID("squeezing gear of girlpower")}
		local shovel
		for _, id in ipairs(shovels) do
			if Self.ItemCount(id) > 0 then
				shovel = id
				break
			end
		end
		
		local holePos = Self.Position()
		holePos.x = holePos.x - 1 --west
		for i = 1, 3 do
			Self.UseItemWithGround(shovel, holePos.x, holePos.y, holePos.z)
			wait(1000)
		end
		Walker.Start()
	elseif labelName == "ShovelEast" then
		Walker.Stop()
		local shovels = {Item.GetID("shovel"), Item.GetID("light shovel"), Item.GetID("squeezing gear of girlpower")}
		local shovel
		for _, id in ipairs(shovels) do
			if Self.ItemCount(id) > 0 then
				shovel = id
				break
			end
		end
		
		local holePos = Self.Position()
		holePos.x = holePos.x + 1 --east
		for i = 1, 3 do
			Self.UseItemWithGround(shovel, holePos.x, holePos.y, holePos.z)
			wait(1000)
		end
		Walker.Start()
	elseif labelName == "DoorWest" then
		Walker.Stop()
		local doorPosition = Self.Position()
		local tries = 0
		doorPosition.x = doorPosition.x - 1 --west
		repeat
			Self.UseDoor(doorPosition.x, doorPosition.y, doorPosition.z)
			tries = tries + 1
			wait(1000)
		until Self.Position().x == doorPosition.x or tries >= 15
		Walker.Start()
	elseif labelName == "DoorEast" then
		Walker.Stop()
		local doorPosition = Self.Position()
		local tries = 0 
		doorPosition.x = doorPosition.x + 1 --east
		repeat
			Self.UseDoor(doorPosition.x, doorPosition.y, doorPosition.z)
			tries = tries + 1
			wait(1000)
		until Self.Position().x == doorPosition.x or tries >= 15
		Walker.Start()
	elseif labelName == "Hunt" then
		Walker.Stop()
		if SoftBoots then
			if Self.ItemCount(6529) > 0 then
				Self.Equip(6529, "feet")
			end
		end
		Walker.Start()
	elseif labelName == "BuySupp" then
	
		local buy = false
		for _, supply in ipairs(Supplies) do
			if math.max(supply.required - Self.ItemCount(supply.id), 0) > 0 then
				buy = true
				break
			end
		end
		
		if buy then
			Walker.Stop()
			Self.SayToNpc("hi")
			sleep(math.random(1000, 1500))
			Self.SayToNpc("trade")
			sleep(math.random(500, 800))
			local started
			for _, supply in ipairs(Supplies) do
				if math.max(supply.required - Self.ItemCount(supply.id), 0) > 0 then
					started = os.time()
					repeat
						Self.ShopBuyItem(supply.id, math.max(supply.required - Self.ItemCount(supply.id), 0))
						wait(1000)
					until Self.ItemCount(supply.id) >= supply.required or (os.time() - started) >= 10
				end
			end
			wait(1000)
			--MOVE POTS TO SUP BP
			local mainBp = Container.GetByName(MainBP) 
			local supBp = Container.GetByName(SuppliesBP)
			for _, supply in ipairs(Supplies) do
				started = os.time()
				while (mainBp:CountItemsOfID(supply.id) > 0 and (os.time() - started) < 15) do
					for spot = 0, mainBp:ItemCount() do
						local item = mainBp:GetItemData(spot) 
						if item.id == supply.id then
							mainBp:MoveItemToContainer(spot, supBp:Index(), 0) 
							wait(500) 
							break
						end
					end
				end
				wait(1000)
			end
		end
		Walker.Start()
	elseif labelName == "Check" then
		Walker.Stop()
		local hunt = true
		for _, supply in ipairs(Supplies) do
			if Self.ItemCount(supply.id) <= supply.toLeave or Self.Cap() <= CapToLeave or Self.Stamina() <= StaminaToLeave then
				hunt = false
				break
			end
		end
		if not hunt then
			gotoLabel("Leave")
			Looter.Stop()
			Targeting.Stop()
			LEAVING = true
		else
			gotoLabel("Hunt")
		end
		Walker.Start()
	elseif labelName == "Reorganize" then
		Walker.Stop()
		if Self.Cap() <= 100 then
			Self.DropItem(Self.Position().x, Self.Position().y, Self.Position().z, Item.GetID("strong mana potion"), 50)
		end
		Walker.Start()
	elseif labelName == "BuyParcel" then
		Walker.Stop()
		Self.SayToNpc("hi")
		wait(1000)
		Self.SayToNpc("trade")
		wait(1000)
		Self.ShopBuyItem(3503, 1)
		wait(1000)
		MailInfo.Parcels = MailInfo.Parcels + 1
		--now let's fill the parcel
		
		--let's move the empty loot bps to supp bp
		print("Moving empty loot bp to supp bp...")
		local lootBp = Container.GetByName(LootBP)
		local suppBp = Container.GetByName(SuppliesBP)
		for spot = 0, lootBp:ItemCount() do
			local item = lootBp:GetItemData(spot)
			if item.id == Item.GetID(LootBP) then --is the red bp
				lootBp:MoveItemToContainer(spot, suppBp:Index(), 0)
				print("Empty loot bp moved to supp bp")
				break
			end
		end
		wait(1000)
		--bp moved, now lets put the lootbp of the main bp, inside the parcel
		
		--lets find the label inside suppbp and then put it inside parcel
		print("Searching for label inside supp bp...")
		suppBp = Container.GetByName(SuppliesBP) --update the parcel data
		local labelSpot = -1
		for spot = 0, suppBp:ItemCount() do
			local item = suppBp:GetItemData(spot)
			if item.id == 3507 then --label
				--we now found the spot with label, let's find the spot with the parcel
				labelSpot = spot
				print("Label found at spot: " .. labelSpot .. ".")
				break
			end
		end
		local parcelSpot = -1
		local mainBp = Container.GetByName(MainBP)
		print("Moving label inside parcel...")
		MailInfo.Labels = MailInfo.Labels + 1
		for spot = 0, mainBp:ItemCount() do
			local item = mainBp:GetItemData(spot)
			if item.id == 3503 and labelSpot ~= -1 then --is the parcel
				--lets move the label inside this
				parcelSpot = spot
				suppBp:MoveItemToContainer(labelSpot, mainBp:Index(), parcelSpot)
				print("Label moved. Parcel spot: " .. parcelSpot .. ".")
				MailInfo.Moved = MailInfo.Moved + 1
				break
			end
		end
		wait(1000)
		--now lets move the bp with loot located in mainbp, to the parcel
		print("Moving loot bp located in mainbp to parcel...")
		mainBp = Container.GetByName(MainBP)
		for spot = 0, mainBp:ItemCount() do
			local item = mainBp:GetItemData(spot)
			if item.id == Item.GetID(LootBP) then
				mainBp:MoveItemToContainer(spot, mainBp:Index(), parcelSpot)
				print("Loot bp moved.")
				break
			end
		end
		wait(1000)
		--now let's move the empty loot bp inside supplies bp, to main bp
		print("Moving empty loot bps to main again...")
		suppBp = Container.GetByName(SuppliesBP)
		for spot = 0, suppBp:ItemCount() do
			local item = suppBp:GetItemData(spot)
			if item.id == Item.GetID(LootBP) then
				suppBp:MoveItemToContainer(spot, mainBp:Index(), 0)
				print("BP moved.")
				break
			end
		end
		Walker.Goto("GoParcel")
		Walker.Start()
		--already done!
	elseif labelName == "SendParcel" then
		Walker.Stop()
		local dropPos = {x = Self.Position().x - 1, y = Self.Position().y, z = Self.Position().z}
		Self.DropItem(dropPos.x, dropPos.y, dropPos.z, 3503, 1)
		MailInfo.Dropped = MailInfo.Dropped + 1
		wait(1000)
		local thing = Map.GetTopMoveItem(dropPos.x, dropPos.y, dropPos.z)
		if thing then
			if thing.itemid == 3503 then --parcel not sent, above mailbox
				Map.PickupItem(dropPos.x, dropPos.y, dropPos.z, Container.GetFirst(), 0, 1)
				alert()
			end
		end
		Walker.Start()
	elseif labelName == "PassTeleport" then
		Walker.Stop()
		
	elseif labelName == "Finish" then
		Walker.Stop()
		Walker.Goto("Start")
		Walker.Start()
	end
end

Module.New("AutoEquipSoft", function(module)
	local secondary = (Self.Name() == "Darkhaos" and Item.GetID("depth calcei") or Item.GetID("boots of haste")) --las botas normales
	local soft = 
	{
		normal = 6529,
		using = 3549
	}
	if not Self.isInPz() then
		if Self.Feet().id ~= soft.using and Self.ItemCount(soft.normal) > 0 then
			Self.Equip(soft.normal, "feet")
		end
	else
		if Self.Feet().id ~= secondary and Self.ItemCount(secondary) > 0 then
			Self.Equip(secondary, "feet")
		end
	end
	module:Delay(1000)
end)

Module.New("AutoExanaMort", function(module)
	if Self.CanCastSpell("exana mort") then
		Self.Say("exana mort")
	end
	module:Delay(10000)
end)

Module.New("WalkerStuck", function(module)
	if not LEAVING then return true end
	--is leaving
	if Walker.IsStuck() then
		Targeting.Start()
	else
		Targeting.Stop()
	end
	module:Delay(1000)
end)

