-- Variables
local BuyPots = true					-- Set to false if you don't want to buy potions.
local Sellorc = true					-- Set to false if you don't want to sell creature products.
local LootID = { 10196, 11480, 11478, 11479, 11477, 11453, 11452 } 		-- items you are selling to Baxter.

-- Checker
local MinCap = 20

-- Potions Setup
local PotionMin = 5 					-- Potions to deposit on.
local PotionMax = 10					-- Amount of Potions to buy.
local PotionName = "health potion"		-- Name of Potions.
local PotionPrice = 45					-- How much Potions cost.

-- BP Setup
local GoldBP = "Purple Backpack"		-- Name of Gold Backpack.
local LootBP = "Yellow Backpack"			-- Name of Loot Backpack.

print("Thais Orcs by Retsam Frost")
registerEventListener(WALKER_SELECTLABEL, "SelectLabel")

function SelectLabel(Label)
	if (Label == "Bank") then
		local withdrawPotion = (PotionMax-Self.ItemCount(PotionName))*PotionPrice
		Walker.Stop()
		Self.SayToNpc({"hi", "deposit all", "yes", "balance"}, 65)
		if BuyPots then
			if (withdrawPotion > 0) then
				Self.SayToNpc({"withdraw " .. withdrawPotion, "yes",}, 65)
			end
		end
		Walker.Start()
	elseif (Label == "StartHunt") then
		if (BuyPots and Self.ItemCount(PotionName) < PotionMax) then
				gotoLabel("GoBank") 
		end		
	elseif (Label == "BPreset") then
		Walker.Stop()
		Self.CloseContainers()
		wait(900,1000)
		Self.OpenMainBackpack(true):OpenChildren(LootBP, GoldBP)
		Walker.Start()	
	elseif (Label == "BuyPot") then
		Walker.Stop()
		if (BuyPots and Self.ItemCount(PotionName) < PotionMax) then
			Self.SayToNpc({"hi", "vials", "yes", "trade"}, 65)
			wait(2000)
			if (Self.ItemCount(PotionName) < PotionMax) then
				Self.ShopBuyItemsUpTo(PotionName, PotionMax)
			end
			wait(200, 500)
		end
		Walker.Start()	
	elseif (Label == "Checker") then
		if (Self.Cap() > MinCap and Self.ItemCount(PotionName) > PotionMin) then
				gotoLabel("Hunt")
		end
	elseif (Label == "Gobax") then
		if Sellorc then
				gotoLabel ("Baxter")
		end
	elseif (Label == "Sellbax") then
		Walker.Stop()
		Creature.New("Baxter"):Follow()
		Self.SayToNpc({'hi', 'trade'}, 65)
		wait(2000,3000)
		for _, id in ipairs(LootID) do
			Self.ShopSellAllItems(id)
			wait(500,1000)
		end
		Walker.Start()
	elseif (Label == "GotoSH")	then
				gotoLabel ("StartHunt")	
	elseif (Label == "BaxBank") then
				gotoLabel ("GoBank")
	elseif (Label == "Depot") then
		local LootDP = 0	-- BP in DP to put Loot Into
		Self.ReachDepot()
		Self.DepositItems(
		{"skull belt", LootDP},
		{"broken helmet", LootDP},
		{"orc tooth", LootDP},
		{"orc leather", LootDP},
		{"wand of decay", LootDP},
		{"shamanic hood", LootDP},
		{"broken shamanic staff", LootDP}
		)
	end
end

Self.ReachDepot = function(ATTEMPTS)
	--Made by Rydan
	--Inspired by Forgee

	local ATTEMPTS = ATTEMPTS or 5
	local DP_IDS = {3497, 3498, 3499, 3500}
	local DP_POSITIONS = {}
	
	Walker.Stop()
	local function reachDP()
		for i = 1, #DP_IDS do
			for POS_X = -7, 7, 1 do
				for POS_Y = -5, 5, 1 do
					if (Map.GetTopUseItem(Self.Position().x + POS_X, Self.Position().y + POS_Y, Self.Position().z).id == DP_IDS[i]) then
						DP_POSITION = {x = Self.Position().x + POS_X, y = Self.Position().y + POS_Y, z = Self.Position().z}
						table.insert(DP_POSITIONS, DP_POSITION)
					end
				end
			end
		end
		print("XenoBot has found "..#DP_POSITIONS.." depots around you.")
		wait(2000)
		for i = 1, #DP_POSITIONS do
			local LAST_POSITION = Self.Position()
			local BLOCKED = 0
			local COORDINATES = DP_POSITIONS[i]
			for j = CREATURES_LOW, CREATURES_HIGH do
				local CREATURE = Creature.GetFromIndex(j)
				if (CREATURE:isPlayer() and CREATURE:ID() ~= Self.ID() and CREATURE:isOnScreen()) then
					if (Map.GetTopUseItem(COORDINATES.x, COORDINATES.y, COORDINATES.z).id == DP_IDS[1]) then
						--SOUTH
						if ((CREATURE:Position().x == COORDINATES.x and CREATURE:Position().y == COORDINATES.y-1) or (CREATURE:Position().x == COORDINATES.x and CREATURE:Position().y == COORDINATES.y-2) or (Map.IsTileWalkable(COORDINATES.x, COORDINATES.y-1, COORDINATES.z) == false) or (Map.IsTileWalkable(COORDINATES.x, COORDINATES.y-2, COORDINATES.z) == false)) then
							BLOCKED = BLOCKED+1
						end		
					end
					if (Map.GetTopUseItem(COORDINATES.x, COORDINATES.y, COORDINATES.z).id == DP_IDS[2]) then
						--WEST
						if ((CREATURE:Position().x == COORDINATES.x+1 and CREATURE:Position().y == COORDINATES.y) or (CREATURE:Position().x == COORDINATES.x+2 and CREATURE:Position().y == COORDINATES.y) or (Map.IsTileWalkable(COORDINATES.x+1, COORDINATES.y, COORDINATES.z) == false) or (Map.IsTileWalkable(COORDINATES.x+2, COORDINATES.y, COORDINATES.z) == false)) then
							BLOCKED = BLOCKED+1
						end
					end
					if (Map.GetTopUseItem(COORDINATES.x, COORDINATES.y, COORDINATES.z).id == DP_IDS[3]) then
						--NORTH
						if ((CREATURE:Position().x == COORDINATES.x and CREATURE:Position().y == COORDINATES.y+1) or (CREATURE:Position().x == COORDINATES.x and CREATURE:Position().y == COORDINATES.y+2) or (Map.IsTileWalkable(COORDINATES.x, COORDINATES.y+1, COORDINATES.z) == false) or (Map.IsTileWalkable(COORDINATES.x, COORDINATES.y+2, COORDINATES.z) == false)) then
							BLOCKED = BLOCKED+1
						end
					end
					if (Map.GetTopUseItem(COORDINATES.x, COORDINATES.y, COORDINATES.z).id == DP_IDS[4]) then
						--EAST
						if ((CREATURE:Position().x == COORDINATES.x-1 and CREATURE:Position().y == COORDINATES.y) or (CREATURE:Position().x == COORDINATES.x-2 and CREATURE:Position().y == COORDINATES.y) or (Map.IsTileWalkable(COORDINATES.x-1, COORDINATES.y, COORDINATES.z) == false) or (Map.IsTileWalkable(COORDINATES.x-2, COORDINATES.y, COORDINATES.z) == false)) then
							BLOCKED = BLOCKED+1
						end
					end
				end
			end
			if (BLOCKED == 0) then
				print("XenoBot is now trying to reach a free depot.")
				Self.UseItemFromGround(COORDINATES.x, COORDINATES.y, COORDINATES.z)
				wait(2000, 4000)
				if (Self.DistanceFromPosition(LAST_POSITION.x, LAST_POSITION.y, LAST_POSITION.z) >= 1) then
					wait(5000, 10000)
					if (Self.DistanceFromPosition(COORDINATES.x, COORDINATES.y, COORDINATES.z) == 1) then
						print("XenoBot has successfully reached a free depot and will now proceed with following actions.")
						wait(2000)
						return true
					end
				end
			end
		end
		return false
	end
	
	while (ATTEMPTS > 0) do
		if (reachDP()) then
			return true
		end
		ATTEMPTS = ATTEMPTS-1
		wait(100)
	end
	return false
end