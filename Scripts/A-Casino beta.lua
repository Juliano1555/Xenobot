--dicer by darkhaos

dofile("CasinoItems.lua")
CRYSTAL_COIN = 3043
PLATINUM_COIN = 3035
GOLD_COIN = 3031
PARTY_HAT = 6578
CFG =
{
	gamerDirection = 'west',
	myDepotDirection = 'north',
	turnToPlayer = true,
	configuring = false,
	yellInterval = 130,--segundos
	sayInterval = 30,
	usePartyHat = true,
	partyHatInterval = 5 --seconds
}

GAME =
{
	minBid = 5000,
	maxBid = 250000,
	lowValues = {1, 3},
	highValues = {4, 6},
	cards = {1, 2, 3, 4, 5, 6},
	winPercent = 80,
	gambling = false,
	droppingMoney = false,
	busy = false,
	nextYell = 0,
	nextSay = 0,
	nextPartyHat = 0,
	gamer =
	{
		id = -1,
		wins = 0,
		loses = 0,
		moneyPlayed = 0,
		moneyWon = 0,
	},
	moneyWon = 0,
	moneyLost = 0
	
	
}

topic = 0


crystalCoinsBP = "red backpack"
platinumCoinsBP = "blue backpack"
lootItemsBP = "camouflage backpack"

ITEM_POSITION =
{
	['north'] = {},
	['south'] = {}
}
GAMER_POSITION =
{
	['north'] = {},
	['south'] = {}
}
MONEY_POSITION =
{
	['north'] = {},
	['south'] = {}
}
MINBID_STR = ""
MAXBID_STR = ""

PHRASES = {}


function onSay(channel, msg)
	msg = msg:lower()
	if msg == "/configure" or msg == "/config" then
		channel:SendOrangeMessage("[CONFIG]","Configuring the dice script:")
		channel:SendOrangeMessage("[CONFIG]","Please specify the depot direction where the user will be. Options are 'left'/'west', 'right'/'east', 'up'/'north' or 'down'/'south'.")
		CFG.configuring = true
		topic = 1
	elseif topic == 1 then
		if isInArray({'left', 'west', 'right', 'east', 'north', 'up', 'south', 'down'}, msg) then
			CFG.gamerDirection = (msg == 'left' or msg == 'west' and 'west' or msg == 'right' or msg == 'east' and 'east' or msg == 'south' or msg == 'down' and 'south' or msg == 'north' or msg == 'up' and 'north')
			channel:SendYellowMessage("[CONFIG]","Depot direction setted to: '" .. msg .. "'.")
			channel:SendOrangeMessage("[CONFIG]","Please specify now the minimun bid allowed.")
			topic = 2
		else
			channel:SendOrangeMessage("[CONFIG]","Invalid option. Please specify the depot direction where the user will be. Options are 'left', 'west', 'right' or 'east'.")
			topic = 1
		end
	elseif topic == 2 then
		if tonumber(msg) and tonumber(msg) > 0 then
			local n = tonumber(msg)
			channel:SendYellowMessage("[CONFIG]","Mininum bid setted to: " .. n .. " gold.")
			channel:SendOrangeMessage("[CONFIG]","Please specify now the maximun bid.")
			GAME.minBid = n
			topic = 3
		else
			if string.find(msg, 'k') and string.find(msg, 'k') == string.len(msg) then --es un string del tipo 100k
				local newStr = string.gsub(msg, "k", "") --removiendo el k
				if tonumber(newStr) and tonumber(newStr) > 0 then
					local newStr = newStr * 1000
					channel:SendYellowMessage("[CONFIG]","Minimun bid setted to: " .. newStr .. " gold.")
					channel:SendOrangeMessage("[CONFIG]","Please specify now the maximun bid.")
					GAME.minBid = newStr
					topic = 3
				else
					channel:SendOrangeMessage("[CONFIG]","Invalid number. Please specify the minimun bid allowed.")
					topic = 2
				end
			end
		end
	elseif topic == 3 then
		if tonumber(msg) and tonumber(msg) > 0 then
			local n = tonumber(msg)
			if n <= Self.Money() then
				channel:SendYellowMessage("[CONFIG]","Maximum bid setted to: " .. n .. " gold.")
				channel:SendOrangeMessage("[CONFIG]","Please specify now the win percent.")
				GAME.maxBid = n
				topic = 4
			else
				channel:SendOrangeMessage("[CONFIG]","The amount of gold you specified is higher than the one you have with you. Please specify a lower amount.")
				topic = 3
			end
		else
			if string.find(msg, 'k') and string.find(msg, 'k') == string.len(msg) then --es un string del tipo 100k
				local newStr = string.gsub(msg, "k", "") --removiendo el k
				if tonumber(newStr) and tonumber(newStr) > 0 then
					local newStr = newStr * 1000
					if newStr <= Self.Money() then
						channel:SendYellowMessage("[CONFIG]","Maximum bid setted to: " .. newStr .. " gold.")
						channel:SendOrangeMessage("[CONFIG]","Please specify now the payout percent.")
						GAME.maxBid = newStr
						topic = 4
					else
						channel:SendOrangeMessage("[CONFIG]","The amount of gold you specified is higher than the one you have with you. Please specify a lower amount.")
						topic = 3
					end
				else
					channel:SendOrangeMessage("[CONFIG]","Invalid number. Please specify the maximum bid allowed.")
					topic = 3
				end
			end
		end
	elseif topic == 4 then
		if tonumber(msg) and tonumber(msg) > 0 then
			local n = tonumber(msg)
			channel:SendYellowMessage("[CONFIG]", "Payout percent setted to: " .. n .. "%.")
			channel:SendOrangeMessage("[CONFIG]","Please specify now if your character will turn direction to users position. (yes/no)")
			GAME.winPercent = n
			topic = 5
		else
			channel:SendOrangeMessage("[CONFIG]","Invalid number. Please specify the win percent.")
			topic = 4
		end
	elseif topic == 5 then
		if msg == "yes" or msg == "no" then
			CFG.turnToPlayer = (msg == "yes" and true or false)
			channel:SendYellowMessage("[CONFIG]","Turn option setted to: " .. msg .. ".")
			channel:SendOrangeMessage("[CONFIG]","Please type now your depot direction.")
			topic = 6
		end
	elseif topic == 6 then
		if isInArray({'left', 'west', 'right', 'east', 'north', 'up', 'south', 'down'}, msg) then
			CFG.myDepotDirection = (isInArray({'east', 'right'}, msg) and 'east' or isInArray({'west', 'left'}, msg) and 'west' or isInArray({'south', 'down'}, msg) and 'south' or isInArray({'north', 'up'}, msg) and 'north')
			channel:SendYellowMessage("[CONFIG]","Depot direction setted to: '" .. CFG.myDepotDirection .. "'.")
			channel:SendOrangeMessage("[CONFIG]","Your script is now configured. To start the script just type the command '/start'. If you want to configure your script again, type the command '/configure'")
			CFG.configuring = false
			topic = 0
		else
			channel:SendOrangeMessage("[CONFIG]","Invalid option. Please specify your depot location. Options are 'left', 'west', 'right' or 'east'.")
			topic = 6
		end
	elseif msg == "/start" then
		if not CFG.configuring then
			if Self.isInDepot() then
				StartGambling(channel)
			else
				channel:SendOrangeMessage("[GAME]", "You are not in a depot.")
			end
		else
			channel:SendOrangeMessage("[CONFIG]", "You cannot start gambling while configuring the script. Please finish to configure the script first.")
		end
	elseif msg == "/stop" then
		if GAME.gambling then
			channel:SendOrangeMessage("[GAME]", "Gambling stopped.")
			GAME.gambling = false
		else
			channel:SendOrangeMessage("[GAME]", "You're not gambling yet.")
		end
	end
end

channel = Channel.New("Dice Script", onSay)
channel:SendOrangeMessage("[Dice Script]","Please type '/configure' to configure the script or '/startgambling' to start it.")

function isInArray(array, t)
	for _, item in ipairs(array) do
		if(item == t) then
			return true
		end
	end
	return false
end

Self.isInDepot = function()
	local DepotIDs = {3497, 3498, 3499, 3500}
	local ppos = Self.Position()
	local poss =
	{
		{x = ppos.x, y = ppos.y+1, z = ppos.z},
		{x = ppos.x, y = ppos.y-1, z = ppos.z},
		{x = ppos.x + 1, y = ppos.y, z = ppos.z},
		{x = ppos.x-1, y = ppos.y, z = ppos.z}
	}
	for _, id in ipairs(DepotIDs) do
		local d = Map.GetUseItems(id)
		for _, pos in ipairs(d) do
			for _, dpp in ipairs(poss) do
				if doComparePositions(pos, dpp) then
					return true
				end
			end
		end
	end
	return false
end

function doComparePositions(pos1, pos2)
	if pos1.x == pos2.x and pos1.y == pos2.y and pos1.z == pos2.z then return true end
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

function StartGambling(channel)

	channel:SendOrangeMessage("[GAME]", "Starting...")
	GAME.gambling = false
	GAME.busy = false
	GAME.droppingMoney = false
	channel:SendOrangeMessage("[GAME]", "Loading modules...")
	local p = Self.Position()
	ITEM_POSITION['north'] =
	{
		['east'] = {x = p.x + 1, y = p.y - 1, z = p.z},
		['west'] = {x = p.x - 1, y = p.y - 1, z = p.z}
	}
	ITEM_POSITION['south'] =
	{
		['east'] = {x = p.x + 1, y = p.y + 1, z = p.z},
		['west'] = {x = p.x - 1, y = p.y + 1, z = p.z}
	}
	GAMER_POSITION['north'] =
	{
		['east'] = {x = p.x + 2, y = p.y, z = p.z},
		['west'] = {x = p.x - 2, y = p.y, z = p.z}
	}
	GAMER_POSITION['south'] =
	{
		['east'] = {x = p.x + 2, y = p.y, z = p.z},
		['west'] = {x = p.x - 2, y = p.y, z = p.z}
	}
	MONEY_POSITION['north'] =
	{
		['east'] = {x = p.x + 1, y = p.y - 1, z = p.z},
		['west'] = {x = p.x - 1, y = p.y - 1, z = p.z}
	}
	MONEY_POSITION['south'] =
	{
		['east'] = {x = p.x + 1, y = p.y + 1, z = p.z},
		['west'] = {x = p.x - 1, y = p.y + 1, z = p.z}
	}
	MINBID_STR = (GAME.minBid / 1000) .. "k"
	MAXBID_STR = (GAME.maxBid / 1000) .. "k"
	PHRASES =
	{
		"BEST CASINO!, COME HERE AND GET RICH ROLLING THE DICE OR PLAYING BLACKJACK!",
		"BEST CASINO IN SHADOWCORES! " .. GAME.winPercent .. "% OF PAYOUT!",
		"COME HERE AND PLAY! TASTE YOUR LUCK!",
		"MIN BID IS " .. MINBID_STR .. " AND MAX BIS IS " .. MAXBID_STR .. ", TASTE YOUR LUCK!",
		"FEELING LUCKY TODAY? WIN SOME MONEY HERE, THE BEST CASINO ON SHADOW CORES!",
		"ROLL THE DICE OR PLAY BLACKJACK, PLAY HERE!",
		"BEST CASINO! [H/L] - BLACKJACK - " .. GAME.winPercent .. "% OF PAYOUT!"
	}
	channel:SendOrangeMessage("[GAME]", "Opening required containers...")
	Self.Turn(CFG.myDepotDirection)
	wait(100)
	Self.CloseContainers()
	wait(1000)
	Self.OpenMainBackpack(true)
	wait(200)
	local depot = Self.OpenDepot()
	local deny = false
	local bpsInDepot = 0
	wait(2000)
	if depot then --depot opened?
		local indexes = Container.GetIndexes()
		local dchest = Container.GetByName("depot chest")
		local offset = 0
		for spot = 0, 1 do -- loop through all items in depot
			if Item.isContainer(dchest:GetItemData(spot).id) then
				dchest:UseItem(spot, false)
				bpsInDepot = bpsInDepot + 1
				wait(1000)
			end
		end
	else
		channel:SendOrangeMessage("[GAME]", "Depot could not be opened.")
		deny = true
	end
	
	if bpsInDepot < 2 then --if there is not enough bps in depot, cancel start
		channel:SendOrangeMessage("[GAME]", "You need at least 2 bps in your depot (The first 2 items in depot).")
		deny = true
	end
	
	if Self.Money() < GAME.maxBid + (math.floor(GAME.winPercent*GAME.maxBid/100)) then --not neought money (maxbid+ percent of payout)
		channel:SendOrangeMessage("[GAME]", "You do not have enough money to start gambling (You need at least " .. GAME.maxBid + (math.floor(GAME.winPercent*GAME.maxBid/100)) .. " gold to start playing).")
		deny = true
	end
	
	if not deny then
		GAME.gambling = true
		channel:SendOrangeMessage("[GAME]", "Everything looks good... Gambling started!")
	end --start
	
end


DicerModule = Module.New("Dicer", function(module)
	if not GAME.gambling or GAME.busy or GAME.droppingMoney then return true end 
	--yell
	if os.time() >= GAME.nextYell then
		local phrase = PHRASES[math.random(1, #PHRASES)]
		Self.Yell(phrase)
		GAME.nextYell = os.time() + CFG.yellInterval
	end
	if os.time() >= GAME.nextSay then
		local phrase = PHRASES[math.random(1, #PHRASES)]
		Self.Say(phrase)
		GAME.nextSay = os.time() + CFG.sayInterval
	end
	
	if os.time() >= GAME.nextPartyHat and CFG.usePartyHat then
		local hat = Self.Head()
		if hat.id == PARTY_HAT then
			Self.UseItemFromEquipment("head")
			GAME.nextPartyHat = os.time() + CFG.partyHatInterval
		end
	end
	
	--first, let's update our direction, check for money, bps opened and things.
	--let's check our money and shit
	local money = Self.Money()
	--if money < maxbid then stop playing
	if money < (GAME.maxBid + math.floor(80*GAME.maxBid/100)) then
		GAME.gambling = false
		channel:SendOrangeMessage("[GAME]", "Money is off. Stopping script.")
		writelogline("Money is off. Stopping script.")
		return true
	end
	
	local indexes = Container.GetIndexes()
	if #indexes < 4 then
		GAME.gambling = false
		channel:SendOrangeMessage("[GAME]", "You do not have all required bps opened. Stopping script.")
		writelogline("You do not have all required bps opened. Stopping script.")
		return true
	end
	
	--Now lets check for player to play
	local gamerPosition = GAMER_POSITION[CFG.myDepotDirection][CFG.gamerDirection]
	if not gamerPosition then
		GAME.gambling = false
		channel:SendOrangeMessage("[GAME]", "Cannot check for gamer position. Please reconfigure and restart the script. Depot direction " .. CFG.gamerDirection .. ".")
		writelogline("Cannot check for gamer position. Please reconfigure and restart the script. Depot direction " .. CFG.gamerDirection .. ".")
		return true
	end

	--get player
	if not GAME.busy and not GAME.droppingMoney then
		local foundPlayer = false
		for i = CREATURES_LOW, CREATURES_HIGH do
			local creature = Creature.GetFromIndex(i)
			if(creature:isValid() and creature:ID() ~= Self.ID())then
				if(creature:isOnScreen() and creature:isVisible() and creature:isAlive() and creature:isPlayer() and creature:DistanceFromSelf() < 3)then
					if doComparePositions(creature:Position(), gamerPosition) then --is in the position
						if GAME.gamer.id ~= creature:ID() then
							GAME.gamer.id = creature:ID()
							GAME.gamer.wins = 0
							GAME.gamer.loses = 0
							GAME.gamer.moneyPlayed = 0
							GAME.gamer.moneyWon = 0
							wait(200)
							Self.Turn(CFG.gamerDirection)
							wait(200)
							Self.Say("Welcome " .. creature:Name() .. ". Wanna get rich? Min bid is " .. MINBID_STR .. " and Max bid is " .. MAXBID_STR .. ".")
							GAME.busy = false
							GAME.droppingMoney = false
						end
						foundPlayer = true
						break
					end
				end
			end
		end
		if not foundPlayer then
			if(GAME.gamer.id > 0) then
				if GAME.gamer.moneyPlayed < 1 then --didn't played
					Self.Say("Uh!, maybe next time!")
					wait(200)
				end
			end
			Self.Turn(CFG.myDepotDirection)
			GAME.gamer.id = -1
			GAME.gamer.wins = 0
			GAME.gamer.loses = 0
			GAME.gamer.moneyPlayed = 0
			GAME.gamer.moneyWon = 0
			GAME.busy = false
			GAME.droppingMoney = false
			return true
		end
	end
	module:Delay(100)
end)

function messageProxyCallback(proxy, mtype, speaker, level, text)
	if not GAME.gambling or GAME.busy or GAME.droppingMoney then return true end
	GAME.busy = true
	if speaker == Creature(GAME.gamer.id):Name() then
		if isInArray({"h", "high", "higher", "l", "lower", "low"}, text:lower()) then
			local itemPosition = ITEM_POSITION[CFG.myDepotDirection][CFG.gamerDirection]
			local item = Map.GetTopMoveItem(itemPosition.x, itemPosition.y, itemPosition.z)
			local value = Item.getValue(item.id)
			if value >= GAME.minBid and value <= GAME.maxBid then
				local myThing
				local thinIShouldHave
				local count
				if Item.isMoney(item.id) then
					myThing = Self.Money()
					thingIShouldHave = myThing + value
					count = value
				else --is an item
					myThing = Self.ItemCount(item.id)
					thingIShouldHave = myThing + item.count
					count = item.count
				end
				local bpToMove = (item.id == CRYSTAL_COIN and crystalCoinsBP or item.id == PLATINUM_COIN and platinumCoinsBP or lootItemsBP)
				local ret = Map.PickupItem(itemPosition.x, itemPosition.y, itemPosition.z, Container.New(bpToMove):Index(), 0)
				wait(500)
				if ret > 0 and (myThing + count) == thingIShouldHave then
					if Item.isMoney(item.id) then
						GAME.gamer.moneyPlayed = GAME.gamer.moneyPlayed + value
					end
					local roll = math.random(1, 6)
					local minI = (isInArray({"h", "high", "higher"}, text:lower()) and 3 or 0)
					local maxI = (isInArray({"h", "high", "higher"}, text:lower()) and 6 or 3)
					local gambText = (isInArray({"h", "high", "higher"}, text:lower()) and "high" or "low")
					if value >= 150000 then
						local rand = math.random(1, 100)
						if rand <= 10 then
							if gambText == "high" then
								roll = math.random(1, 3)
							else
								roll = math.random(4, 6)
							end
						end
					end
					if roll > minI and roll <= maxI then
						GAME.droppingMoney = true
						Self.Say("You bet for " .. gambText .. " and the dice rolled " .. roll .. ". You won.")
						
						local moneyWon = value + (value * GAME.winPercent / 100)
						GAME.gamer.moneyWon = GAME.gamer.moneyWon + (value * GAME.winPercent / 100)
						writelogline("Player " .. speaker .. " bet for " .. gambText .. " and the dice rolled " .. roll .. ". Player won. [BET: " .. value .. ", WON: " .. moneyWon .. ", CURRENTMONEY: " .. Self.Money() .. "]")
						print("Player " .. speaker .. " bet for " .. gambText .. " and the dice rolled " .. roll .. ". Player won. [BET: " .. value .. ", WON: " .. moneyWon .. ", CURRENTMONEY: " .. Self.Money() .. "]")
						GAME.moneyLost = GAME.moneyLost + (value * GAME.winPercent / 100)
						local crystalsToGive = math.floor(moneyWon / 10000)
						moneyWon = moneyWon - (crystalsToGive * 10000)
						local platinumsToGive = math.floor(moneyWon / 100)
						moneyWon = moneyWon - (platinumsToGive * 100)
						local goldToGive = moneyWon
						wait(200)
						local cont = Container.GetByName(crystalCoinsBP)
						local spot = -1
						if(crystalsToGive > 0) then
							for spot = 0, cont:ItemCount() do 
								local item = cont:GetItemData(spot) 
								if (item.id == CRYSTAL_COIN and item.count >= crystalsToGive) then
									spot_ = spot
									break
								end 
							end
							cont:MoveItemToGround(spot_, itemPosition.x, itemPosition.y, itemPosition.z, crystalsToGive)
							crystalsToGive = 0
							wait(2000)
						end
						if(platinumsToGive > 0) then
							cont = Container.GetByName(platinumCoinsBP)
							spot = -1
							for spot = 0, cont:ItemCount() do 
								local item = cont:GetItemData(spot) 
								if (item.id == PLATINUM_COIN and item.count >= platinumsToGive) then
									spot_ = spot
									break
								end 
							end
							cont:MoveItemToGround(spot_, itemPosition.x, itemPosition.y, itemPosition.z, platinumsToGive)
							platinumsToGive = 0
							wait(2000)
						end
						if(goldToGive > 0) then
							cont = Container.GetByName(goldCoinsBP)
							spot = -1
							for spot = 0, cont:ItemCount() do 
								local item = cont:GetItemData(spot) 
								if (item.id == GOLD_COIN and item.count >= goldToGive) then
									spot_ = spot
									break
								end 
							end
							cont:MoveItemToGround(spot_, itemPosition.x, itemPosition.y, itemPosition.z, goldToGive)
							goldToGive = 0
							wait(2000)
						end
						GAME.droppingMoney = false
						GAME.busy = false
					else
						Self.Say("You bet for " .. gambText .. " and the dice rolled " .. roll .. ". You lost.")
						writelogline("Player " .. speaker .. " bet for " .. gambText .. " and the dice rolled " .. roll .. ". Player lost. [BET: " .. money .. ", CURRENTMONEY: " .. Self.Money() .. "]")
						print("Player " .. speaker .. " bet for " .. gambText .. " and the dice rolled " .. roll .. ". Player lost. [BET: " .. money .. ", CURRENTMONEY: " .. Self.Money() .. "]")
						GAME.moneyWon = GAME.moneyWon + money
						GAME.busy = false
						GAME.droppingMoney = false
					end
				else
					Self.Say("Can't take money or item")
					GAME.busy = false
					GAME.droppingMoney = false
				end
			else
				Self.Say("Min bid is " .. MINBID_STR .. " and Max bid is " .. MAXBID_STR .. ".")
				GAME.busy = false
				GAME.droppingMoney = false
			end
		elseif isInArray({'bj', 'blackjack', 'black jack'}, text:lower()) then
			--adding blackjack
			
			local itemPosition = ITEM_POSITION[CFG.myDepotDirection][CFG.gamerDirection]
			local item = Map.GetTopMoveItem(itemPosition.x, itemPosition.y, itemPosition.z)
			local money = (item.id == CRYSTAL_COIN and item.count * 10000 or item.id == PLATINUM_COIN and item.count * 100 or item.id == GOLD_COIN and item.count or 0)
			if money >= GAME.minBid then
				local myMoney = Self.Money()
				local moneyIShouldHave = myMoney + money
				local bpToMove = (item.id == CRYSTAL_COIN and crystalCoinsBP or item.id == PLATINUM_COIN and platinumCoinsBP)
				local ret = Map.PickupItem(itemPosition.x, itemPosition.y, itemPosition.z, Container.New(bpToMove):Index(), 0)
				wait(500)
				if ret > 0 and (myMoney + money) == moneyIShouldHave then
					GAME.gamer.moneyPlayed = GAME.gamer.moneyPlayed + money
					local playerHits = {}
					local playerHitsValue = 0
					local casinoHits = {}
					local casinoHitsValue = 0
					local moneyWon = 0
					local nCards = #GAME.cards
					for i = 1, 5 do
						local deny = false
						local cn, card
						repeat
							cn = math.random(1, nCards)
							card = GAME.cards[cn]
							deny = false
							local cardrep = 0
							if #playerHits > 0 then
								for k = 1, #playerHits do
									if playerHits[k] == card then
										cardrep = cardrep + 1
									end
								end
							end
							if cardrep > 4 then
								deny = true
							end
						until not deny or deny == false
						table.insert(playerHits, card)
						playerHitsValue = playerHitsValue + card
					end
					for i = 1, 5 do
						local deny = false
						local cn, card
						repeat
							cn = math.random(1, nCards)
							card = GAME.cards[cn]
							deny = false
							local cardrep = 0
							if #casinoHits > 0 then
								for k = 1, #casinoHits do
									if casinoHits[k] == card then
										cardrep = cardrep + 1
									end
								end
							end
							if cardrep > 4 then
								deny = true
							end
						until not deny or deny == false
						table.insert(casinoHits, card)
						casinoHitsValue = casinoHitsValue + card
					end
					
					--truck
					local rand = math.random(1, 100)
					if money >= 100000 and rand <= 20 then
						playerHits = {math.random(3, 5), math.random(5, 6), math.random(4, 6), math.random(3, 6), math.random(2, 6)}
						casinoHits = {math.random(1, 5), math.random(1, 4), math.random(1, 3), math.random(1, 3), math.random(2, 6)}
						playerHitsValue = 0
						casinoHitsValue = 0
						for t = 1, 5 do
							playerHitsValue = playerHitsValue + playerHits[t]
						end
						for t = 1, 5 do
							casinoHitsValue = casinoHitsValue + casinoHits[t]
						end
					end
					Self.Say("Your hits: " .. playerHits[1] .. ", " .. playerHits[2] .. ", " .. playerHits[3] .. ", " .. playerHits[4] .. ", " .. playerHits[5] .. ".")
					wait(300)
					Self.Say("My hits: " .. casinoHits[1] .. ", " .. casinoHits[2] .. ", " .. casinoHits[3] .. ", " .. casinoHits[4] .. ", " .. casinoHits[5] .. ".")
					wait(300)
					Self.Say("You: " .. playerHitsValue .. ". Me: " .. casinoHitsValue .. ".")
					wait(300)
					local cancel = false
					if playerHitsValue == casinoHitsValue and not cancel then --draw
						moneyWon = money
						Self.Say("It's a draw!")
						wait(300)
						cancel = true
						
					elseif playerHitsValue > 21 and not cancel then
						if casinoHitsValue > 21 then --both > 21, win the nearest
							local pVal = playerHitsValue - 21
							local cVal = casinoHitsValue - 21
							if pVal < cVal then --player won
								moneyWon = money + (money * GAME.winPercent / 100)
								Self.Say("You won!")
								cancel = true
								wait(300)
							else
								moneyWon = 0
								Self.Say("You lost!")
								cancel = true
								wait(300)
							end
						else --player lost
							moneyWon = 0
							Self.Say("You lost!")
							cancel = true
							wait(300)
						end
					elseif casinoHitsValue > 21 and not cancel then
						if playerHitsValue > 21 then --both > 21, win the nearest
							local pVal = playerHitsValue - 21
							local cVal = casinoHitsValue - 21
							if pVal < cVal then --player won
								moneyWon = money + (money * GAME.winPercent / 100)
								Self.Say("You won!")
								cancel = true
								wait(300)
							else
								moneyWon = 0
								Self.Say("You lost!")
								cancel = true
								wait(300)
							end
						else --player won
							moneyWon = money + (money * GAME.winPercent / 100)
							Self.Say("You won!")
							cancel = true
							wait(300)
						end
					elseif playerHitsValue == 21 and not cancel then
						if casinoHitsValue > 21 or casinoHitsValue < 21 then
							moneyWon = money + (money * GAME.winPercent / 100)
							Self.Say("You won!")
							cancel = true
							wait(300)
						end
					elseif casinoHitsValue == 21 and not cancel then
						if playerHitsValue > 21 or playerHitsValue < 21 then
							moneyWon = 0
							Self.Say("You lost!")
							cancel = true
							wait(300)
						end
					elseif playerHitsValue < 21 and casinoHitsValue < 21 and not cancel then
						if playerHitsValue > casinoHitsValue then --won
							moneyWon = money + (money * GAME.winPercent / 100)
							Self.Say("You won!")
							cancel = true
							wait(300)
						else
							moneyWon = 0
							Self.Say("You lost!")
							cancel = true
							wait(300)
						end
					end
					if moneyWon > 0 then
						GAME.gamer.moneyWon = GAME.gamer.moneyWon + moneyWon
						writelogline("Player " .. speaker .. " won the blackjack. [BET: " .. money .. ", WON: " .. moneyWon .. ", CURRENTMONEY: " .. Self.Money() .. "]")
						print("Player " .. speaker .. " won the blackjack. [BET: " .. money .. ", WON: " .. moneyWon .. ", CURRENTMONEY: " .. Self.Money() .. "]")
						local crystalsToGive = math.floor(moneyWon / 10000)
						moneyWon = moneyWon - (crystalsToGive * 10000)
						local platinumsToGive = math.floor(moneyWon / 100)
						moneyWon = moneyWon - (platinumsToGive * 100)
						local goldToGive = moneyWon
						wait(200)
						local cont = Container.GetByName(crystalCoinsBP)
						local spot = -1
						if(crystalsToGive > 0) then
							for spot = 0, cont:ItemCount() do 
								local item = cont:GetItemData(spot) 
								if (item.id == CRYSTAL_COIN and item.count >= crystalsToGive) then
									spot_ = spot
									break
								end 
							end
							cont:MoveItemToGround(spot_, itemPosition.x, itemPosition.y, itemPosition.z, crystalsToGive)
							crystalsToGive = 0
							wait(2000)
						end
						if(platinumsToGive > 0) then
							cont = Container.GetByName(platinumCoinsBP)
							spot = -1
							for spot = 0, cont:ItemCount() do 
								local item = cont:GetItemData(spot) 
								if (item.id == PLATINUM_COIN and item.count >= platinumsToGive) then
									spot_ = spot
									break
								end 
							end
							cont:MoveItemToGround(spot_, itemPosition.x, itemPosition.y, itemPosition.z, platinumsToGive)
							platinumsToGive = 0
							wait(2000)
						end
						if(goldToGive > 0) then
							cont = Container.GetByName(goldCoinsBP)
							spot = -1
							for spot = 0, cont:ItemCount() do 
								local item = cont:GetItemData(spot) 
								if (item.id == GOLD_COIN and item.count >= goldToGive) then
									spot_ = spot
									break
								end 
							end
							cont:MoveItemToGround(spot_, itemPosition.x, itemPosition.y, itemPosition.z, goldToGive)
							goldToGive = 0
							wait(2000)
						end
						GAME.droppingMoney = false
						GAME.busy = false
					end
				else
					Self.Say("Can't take money")
					GAME.busy = false
					GAME.droppingMoney = false
				end
			else
				Self.Say("Min bid is " .. MINBID_STR .. ".")
				GAME.busy = false
				GAME.droppingMoney = false
			end
		elseif text:lower() == "info" then
			Self.Say("Roll the dice! Low numbers are from 1 to 3, higher from 4 to 6. " .. GAME.winPercent .. "% of payout! Let's play!")
			GAME.busy = false
			GAME.droppingMoney = false
		elseif text:lower() == "yes" then
			Self.Say("MIN bid is " .. GAME.minBid .. " and MAX bid is " .. MAXBID_STR .. ". Say 'low' or 'high' to roll the dice or 'bj' to play blackjack.")
			GAME.busy = false
			GAME.droppingMoney = false
		elseif text:lower() == "games" then
			Self.Say("Place the money and say 'high' or 'low' to roll the dice or 'bj' to play blackjack.")
			GAME.busy = false
			GAME.droppingMoney = false
		elseif text:lower() == "rates" then
			Self.Say("Min bid is " .. MINBID_STR .. " and Max bid is " .. MAXBID_STR .. ". " .. GAME.winPercent .. "% payout.")
			GAME.busy = false
			GAME.droppingMoney = false
		elseif text:lower() == "hi" then
			Self.Say("Hello " .. speaker .. ". Wanna get rich? Min bid is " .. MINBID_STR .. " and Max bid is " .. MAXBID_STR .. ".")
			GAME.busy = false
			GAME.droppingMoney = false
		elseif text:lower() == "commands" or text:lower() == "words" then
			Self.Say("Say 'low' or 'high' to roll the dice. 'rates' to know the bids and 'status' to check your game status.")
			GAME.busy = false
			GAME.droppingMoney = false
		elseif text:lower() == "no" then
			Self.Say("You don't want to play? Then get out of that depot you fearful!")
			GAME.busy = false
			GAME.droppingMoney = false
		elseif text:lower() == "bye" then
			Self.Say("Why you leaving so fast? I feel the next move might be lucky.")
			GAME.busy = false
			GAME.droppingMoney = false
		elseif text:lower() == "status" then
			if(GAME.gamer.moneyPlayed > 0) then
				Self.Say("You has played " .. GAME.gamer.moneyPlayed .. " gold and won " .. GAME.gamer.moneyWon .. " gold.")
			else
				Self.Say("You haven't played yet.")
			end
			GAME.busy = false
			GAME.droppingMoney = false
		end
	end
	HUDS.CURRENTMONEY:SetText("Current money: " .. Self.Money())
	GAME.busy = false
	return true
end

function writelogline(str)
	local logFile = "..//Log//" .. Self.Name() .. ".txt"
	local f = io.open(logFile, "a+")
	if f ~= nil then
		f:write("[" .. os.date() .. "] >> " ..  str .. "\n")
		f:close()
	end
end

LocalSpeechProxy.OnReceive("LocalSpeechProxy", messageProxyCallback)

--HUD
HUDS =
{
	CURRENTMONEY = HUD.New(0, 0, "", 0, 0, 0),
	MONEYWON = HUD.New(0, 0, "", 0, 0, 0),
	MONEYLOST = HUD.New(0, 0, "", 0, 0, 0)
}

COLORS =
{
	BLACK = {R = 1, G = 1, B = 1},
	ORANGE = {R = 255, G = 165, B = 0},
	BLUE = {R = 30, G = 144, B = 255},
	CORNSILK = {R = 205, G = 200, B = 177},
	WHITE = {R = 255, G = 255, B = 255},
	GREEN = {R = 107, G = 142, B = 35},
	RED = {R = 178, G = 34, B = 34},
}

HUDS.CURRENTMONEY:SetText("Current money: " .. Self.Money())
HUDS.CURRENTMONEY:SetPosition(10, 32)
HUDS.CURRENTMONEY:SetTextColor(COLORS.ORANGE.R, COLORS.ORANGE.G, COLORS.ORANGE.B)

