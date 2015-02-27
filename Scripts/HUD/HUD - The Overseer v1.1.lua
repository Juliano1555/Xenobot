	THE_OVERSEER =
	{
        SCRIPT_NAME = "The Overseer",
        SCRIPT_VERSION = "1.1",
        INITIALIZED = false,
		TOTAL_TIME = 0,
		SCRIPT_DESCRIPTION = "HUD - The Overseer v1.1 - Edited by Darkhaos."
    }

    THE_OVERSEER.SHOW_ALL_ITEMS = false
    THE_OVERSEER.ITEMS_LIST =
	{
		{NAME = "gold coin", VALUE = 1},
		{NAME = "platinum coin", VALUE = 100},
		{NAME = "Golden Legs", VALUE = 30000},
		{NAME = "Butchers Axe", VALUE = 18000},
		{NAME = "Vile Axe", VALUE = 30000},
		{NAME = "Gold Ingot", VALUE = 5000},
		{NAME = "Cats Paw", VALUE = 2000},
		{NAME = "Steel Boots", VALUE = 30000},
		{NAME = "Great Health Potion", VALUE = 190},
		{NAME = "Assassin Dagger", VALUE = 20000},
		{NAME = "Noble Axe", VALUE = 10000},
		{NAME = "Terra Rod", VALUE = 2000},
		{NAME = "Red Piece of Cloth", VALUE = 300},
		{NAME = "Small Topaz", VALUE = 200},
		{NAME = "Hellspawn Tail", VALUE = 475},
		{NAME = "Warrior Helmet", VALUE = 5000},
		{NAME = "Spiked Squelcher", VALUE = 5000},
		{NAME = "Black Skull", VALUE = 4000},
		{NAME = "Dracoyle Statue", VALUE = 5000},
		{NAME = "Onyx Flail", VALUE = 22000},
	}
    
    -- [[ DO NOT CHANGE ANYTHING BELOW THIS LINE ]] --
    TIME_HUNTING = HUD.New(0,0,"",0,0,0)
    THE_OVERSEER.TEMP_ITEMS_LIST = {}
	THE_OVERSEER.HEADS_UP_DISPLAY =
	{
		SCRIPT_HEADER = HUD.New(0,0,"",0,0,0),
		LOOT_HEADER = HUD.New(0,0,"",0,0,0),
		ITEMS_COUNT = {},
		TOTAL_LOOT_HEADER = 
		{
			TEXT = HUD.New(0,0,"",0,0,0),
			WORTH = HUD.New(0,0,"",0,0,0),
		},
		OUTCOME = HUD.New(0,0,"",0,0,0),
		TOTAL_TIME = HUD.New(0,0,"",0,0,0)
	}
    THE_OVERSEER.COLORS =
	{
        BLACK = {R = 1, G = 1, B = 1},
        ORANGE = {R = 255, G = 165, B = 0},
        BLUE = {R = 30, G = 144, B = 255},
        CORNSILK = {R = 205, G = 200, B = 177},
        WHITE = {R = 255, G = 255, B = 255},
        GREEN = {R = 107, G = 142, B = 35},
        RED = {R = 178, G = 34, B = 34},
    }
	
Stats = {}
Stats.__data = {}
Stats.__data.PLAYERS_SEEN = {}
Stats.__data.MONSTERS_SEEN = {}
Stats.__data.MONSTERS_KILLED = {}
Stats.__data.ITEMS_LOOTED = {}
Stats.__index = Stats
THE_OVERSEER.TIME_RUNNING = os.time()

function string:explode(DELIMITER) -- Working
	assert(type(DELIMITER) == [[string]], sprintf([[bad argument #1 to 'string:explode' (string expected, got %s)]], type(DELIMITER)))

	local RETURN_VALUE, FROM = {}, 1
	local DELIMITER_FROM, DELIMITER_TO = string.find(self, DELIMITER, FROM)

	while (DELIMITER_FROM) do
		table.insert(RETURN_VALUE, string.sub(self, FROM, DELIMITER_FROM - 1))
		
		FROM = DELIMITER_TO + 1
		DELIMITER_FROM, DELIMITER_TO = string.find(self, DELIMITER, FROM )
	end

	table.insert(RETURN_VALUE, string.sub(self, FROM))

	return RETURN_VALUE
end

function sprintf(FORMAT_STRING, ...) -- Working
	return #{...} > 0 and tostring(FORMAT_STRING):format(...) or tostring(FORMAT_STRING)
end

function ParseLootMessage(MESSAGE_POINTER, WITH_QUANTITY) -- Working
	
	local LOOT_INFO, LOOT_INFO_TEMP = {NAME = [[]], ITEMS = {}}
	
	LOOT_INFO.NAME, LOOT_INFO_TEMP = MESSAGE_POINTER:match([[Loot of (.+): (.+)]])
	if (LOOT_INFO.NAME) then
		LOOT_INFO.NAME = LOOT_INFO.NAME:gsub([[^a ]], [[]]):gsub([[^an ]], [[]]):gsub([[^the ]], [[]]):lower()
		if (LOOT_INFO_TEMP ~= [[nothing]]) then
			for _, ITEM_NAME in ipairs(LOOT_INFO_TEMP:explode([[, ]])) do
				local ITEM_QUANTITY, ITEM_NAME_TEMP = tonumber(ITEM_NAME:explode([[ ]])[1]) or 1, ITEM_NAME:gsub([[%d]], [[]]):gsub([[^a ]], [[]]):gsub([[^an ]], [[]]):trim():lower()
				--:gsub([[s$]], [[]]) -- Plural form for items
				if (ITEM_QUANTITY > 1) then
					ITEM_NAME_TEMP = ITEM_NAME_TEMP:gsub([[s$]], [[]])
				end
				--local ITEM_ID = LOOT_ITEMS_EXCEPTIONS[ITEM_NAME_TEMP] and LOOT_ITEMS_EXCEPTIONS[ITEM_NAME_TEMP](LOOT_INFO.NAME) or Item.GetID(ITEM_NAME_TEMP)
				local ITEM_ID = Item.GetID(ITEM_NAME_TEMP)
				local ITEM_NAME = Item.GetName(ITEM_ID)
				if (#ITEM_NAME > 0) then
					if (WITH_QUANTITY) then
						local ITEM_FOUND = tablefind(LOOT_INFO.ITEMS, ITEM_ID, [[ID]])
						if (ITEM_FOUND) then
							LOOT_INFO.ITEMS[ITEM_FOUND].QUANTITY = LOOT_INFO.ITEMS[ITEM_FOUND].QUANTITY + ITEM_QUANTITY
						else
							table.insert(LOOT_INFO.ITEMS, {ID = ITEM_ID, NAME = ITEM_NAME, QUANTITY = ITEM_QUANTITY})
						end
					elseif (not table.find(LOOT_INFO.ITEMS, ITEM_NAME)) then
						table.insert(LOOT_INFO.ITEMS, ITEM_NAME)
					end
				end
			end
		end
		return LOOT_INFO
	end
	
	return {NAME = [[]], ITEMS = {}}
end
-- [[ INIT END ]] --

--- Stats.AddItemsLooted
-- @param	integer		ITEM_ID
-- @param	integer		ITEM_AMOUNT
-- @param	integer		ITEM_VALUE (optional)
-- @return	void

function Stats.AddItemsLooted(ITEM_ID, ITEM_AMOUNT, ITEM_VALUE) -- Working
	assert(([[number:string]]):find(type(ITEM_ID)), sprintf([[bad argument #1 to 'Stats.AddItemsLooted' (number or string expected, got %s)]], type(ITEM_ID)))
	assert(([[number]]):find(type(ITEM_AMOUNT)), sprintf([[bad argument #2 to 'Stats.AddItemsLooted' (number expected, got %s)]], type(ITEM_AMOUNT)))
	assert(([[number:nil]]):find(type(ITEM_VALUE)), sprintf([[bad argument #3 to 'Stats.AddItemsLooted' (number or nil expected, got %s)]], type(ITEM_VALUE)))
	
	local ITEM_ID, ITEM_AMOUNT = Item.GetID(ITEM_ID), math.max(0, ITEM_AMOUNT)
	
	if (ITEM_ID > 0) then
		if (Stats.__data.ITEMS_LOOTED[ITEM_ID]) then
			Stats.__data.ITEMS_LOOTED[ITEM_ID].QUANTITY = Stats.__data.ITEMS_LOOTED[ITEM_ID].QUANTITY + ITEM_AMOUNT
			
			if (([[number]]):find(type(ITEM_VALUE))) then
				Stats.__data.ITEMS_LOOTED[ITEM_ID].VALUE = math.max(0, ITEM_VALUE)
			end
		else
			Stats.__data.ITEMS_LOOTED[ITEM_ID] = {ID = ITEM_ID, NAME = Item.GetName(ITEM_ID), QUANTITY = ITEM_AMOUNT, VALUE = ([[number]]):find(type(ITEM_VALUE)) and math.max(0, ITEM_VALUE) or Item.GetValue(ITEM_ID)}
		end
	end
	
	return nil
end

--- Stats.GetItemsLooted
-- @param	integer		ITEM_ID (optional)
-- @return	integer

function Stats.GetItemsLooted(ITEM_ID) -- Working
	assert(([[number:string:nil]]):find(type(ITEM_ID)), sprintf([[bad argument #1 to 'Stats.GetItemsLooted' (number, string or nil expected, got %s)]], type(ITEM_ID)))
	
	if (([[number:string]]):find(type(ITEM_ID))) then
		return Stats.__data.ITEMS_LOOTED[Item.GetID(ITEM_ID)].QUANTITY or 0
	end
	
	return Stats.__data.ITEMS_LOOTED
end

--- Misc.FormatNumber
-- @param	integer		NUMBER
-- @return	string

function FormatNumber(NUMBER) -- Working
	assert(([[number:string]]):find(type(NUMBER)), sprintf([[bad argument #1 to 'Misc.FormatNumber' (number or string expected, %s)]], type(NUMBER)))

	local RESULT, SIGN, BEFORE, AFTER = [[]], string.match(tostring(NUMBER), [[^([%+%-]?)(%d*)(%.?.*)$]])
	
	while (#BEFORE > 3) do
		RESULT = [[,]] .. string.sub(BEFORE, -3, -1) .. RESULT
		BEFORE = string.sub(BEFORE, 1, -4)
	end
	
	return SIGN .. BEFORE .. RESULT .. AFTER
end

function tablefind(t, value, field)
    for n = 1, #t do
		if(t[n].field == value)then
			return true
		end
    end
    return false
end

if (not THE_OVERSEER.INITIALIZED) then
        
    for _, LOOT_ITEM in ipairs(THE_OVERSEER.ITEMS_LIST) do
        local LOOT_ITEM_ID = Item.GetID(type(LOOT_ITEM.NAME) ~= "table" and LOOT_ITEM.NAME or unpack(LOOT_ITEM.NAME))
        
        Stats.AddItemsLooted(LOOT_ITEM_ID, 0, LOOT_ITEM.VALUE)
        table.insert(THE_OVERSEER.TEMP_ITEMS_LIST, {ID = LOOT_ITEM_ID, NAME = LOOT_ITEM.NAME, VALUE = LOOT_ITEM.VALUE})
    end
    
	-- INITIALIZING HUD
	local Y_POSITION, INDEX, ITEMS_LOOTED_WORTH = 30, 0, 0

	THE_OVERSEER.HEADS_UP_DISPLAY.SCRIPT_HEADER:SetText(sprintf("%s v%s", THE_OVERSEER.SCRIPT_NAME:upper(), THE_OVERSEER.SCRIPT_VERSION))
	THE_OVERSEER.HEADS_UP_DISPLAY.SCRIPT_HEADER:SetPosition(10, Y_POSITION + (INDEX * 16))
	THE_OVERSEER.HEADS_UP_DISPLAY.SCRIPT_HEADER:SetTextColor(THE_OVERSEER.COLORS.ORANGE.R,THE_OVERSEER.COLORS.ORANGE.G,THE_OVERSEER.COLORS.ORANGE.B)

	Y_POSITION = Y_POSITION + 20

	THE_OVERSEER.HEADS_UP_DISPLAY.LOOT_HEADER:SetText("ITEMS LOOTED")
	THE_OVERSEER.HEADS_UP_DISPLAY.LOOT_HEADER:SetPosition(10, Y_POSITION + (INDEX * 16))
	THE_OVERSEER.HEADS_UP_DISPLAY.LOOT_HEADER:SetTextColor(THE_OVERSEER.COLORS.BLUE.R,THE_OVERSEER.COLORS.BLUE.G,THE_OVERSEER.COLORS.BLUE.B)

	Y_POSITION = Y_POSITION + 20
	
	THE_OVERSEER.HEADS_UP_DISPLAY.TOTAL_LOOT_HEADER.TEXT:SetText("Total:")
	THE_OVERSEER.HEADS_UP_DISPLAY.TOTAL_LOOT_HEADER.TEXT:SetPosition(10, Y_POSITION + (INDEX * 16))
	THE_OVERSEER.HEADS_UP_DISPLAY.TOTAL_LOOT_HEADER.TEXT:SetTextColor(THE_OVERSEER.COLORS.WHITE.R,THE_OVERSEER.COLORS.WHITE.G,THE_OVERSEER.COLORS.WHITE.B)
	THE_OVERSEER.HEADS_UP_DISPLAY.TOTAL_LOOT_HEADER.WORTH:SetText("0 GPs")
	THE_OVERSEER.HEADS_UP_DISPLAY.TOTAL_LOOT_HEADER.WORTH:SetPosition(10 + 40, Y_POSITION + (INDEX * 16))
	THE_OVERSEER.HEADS_UP_DISPLAY.TOTAL_LOOT_HEADER.WORTH:SetTextColor(THE_OVERSEER.COLORS.ORANGE.R,THE_OVERSEER.COLORS.ORANGE.G,THE_OVERSEER.COLORS.ORANGE.B)
	
	-- PROXY NOT IMPLEMENTED FOR SUPPLIES USED

	Y_POSITION = Y_POSITION + 20

	THE_OVERSEER.HEADS_UP_DISPLAY.OUTCOME:SetText("OUTCOME: 0 GPs (0 K/H)")
	THE_OVERSEER.HEADS_UP_DISPLAY.OUTCOME:SetPosition(10, Y_POSITION + (INDEX * 16))
	THE_OVERSEER.HEADS_UP_DISPLAY.OUTCOME:SetTextColor(THE_OVERSEER.COLORS.GREEN.R,THE_OVERSEER.COLORS.GREEN.G,THE_OVERSEER.COLORS.GREEN.B)
	
	Y_POSITION = Y_POSITION + 20
	
	THE_OVERSEER.HEADS_UP_DISPLAY.TOTAL_TIME:SetText("Time: 0h 0m 0s")
	THE_OVERSEER.HEADS_UP_DISPLAY.TOTAL_TIME:SetPosition(10, Y_POSITION + (INDEX*16))
	THE_OVERSEER.HEADS_UP_DISPLAY.TOTAL_TIME:SetTextColor(THE_OVERSEER.COLORS.GREEN.R,THE_OVERSEER.COLORS.GREEN.G,THE_OVERSEER.COLORS.GREEN.B)
	

	-- END INITIALIZING HUD
	
    THE_OVERSEER.INITIALIZED = true
	THE_OVERSEER.TOTAL_TIME = os.time()
end

function LootMessageProxyCallback(proxy, message)
	local LOOT_INFO = ParseLootMessage(message, true)

	if (#LOOT_INFO.NAME > 0) then
		Stats.__data.MONSTERS_KILLED[LOOT_INFO.NAME] = (Stats.__data.MONSTERS_KILLED[LOOT_INFO.NAME] or 0) + 1
		for _, LOOT_ITEM in ipairs(LOOT_INFO.ITEMS) do
			if (Stats.__data.ITEMS_LOOTED[LOOT_ITEM.ID]) then
				Stats.__data.ITEMS_LOOTED[LOOT_ITEM.ID].QUANTITY = Stats.__data.ITEMS_LOOTED[LOOT_ITEM.ID].QUANTITY + LOOT_ITEM.QUANTITY
			else
				local tmp_value = 0
				for _, item in pairs(THE_OVERSEER.ITEMS_LIST) do
					if item.NAME:lower() == LOOT_ITEM.NAME:lower() then
						tmp_value = item.VALUE
					end
				end
				Stats.__data.ITEMS_LOOTED[LOOT_ITEM.ID] = {ID = LOOT_ITEM.ID, NAME = LOOT_ITEM.NAME, QUANTITY = LOOT_ITEM.QUANTITY, VALUE = tmp_value}
			end
		end
	end
	local Y_POSITION, INDEX, ITEMS_LOOTED_WORTH = 30, 0, 0

	--SCRIPT VERSION

	Y_POSITION = Y_POSITION + 20

	--ITEMS LOOTED

	Y_POSITION = Y_POSITION + 20

	for _, LOOT_ITEM in pairs(Stats.GetItemsLooted()) do
		local ItemExists = false
		for _, tmp in pairs(THE_OVERSEER.TEMP_ITEMS_LIST) do
			if (tmp.ID == LOOT_ITEM.ID) then
				ItemExists = true
				break
			end
		end
		
		if ((THE_OVERSEER.SHOW_ALL_ITEMS or ItemExists) and LOOT_ITEM.QUANTITY > 0) then
			if not (THE_OVERSEER.HEADS_UP_DISPLAY.ITEMS_COUNT[LOOT_ITEM.ID]) then
				THE_OVERSEER.HEADS_UP_DISPLAY.ITEMS_COUNT[LOOT_ITEM.ID] = {}
				THE_OVERSEER.HEADS_UP_DISPLAY.ITEMS_COUNT[LOOT_ITEM.ID].ITEM = HUD.New(0,0,"",0,0,0)
				THE_OVERSEER.HEADS_UP_DISPLAY.ITEMS_COUNT[LOOT_ITEM.ID].WORTH = HUD.New(0,0,"",0,0,0)
			end
			THE_OVERSEER.HEADS_UP_DISPLAY.ITEMS_COUNT[LOOT_ITEM.ID].ITEM:SetText(((#LOOT_ITEM.NAME > 17 and sprintf("%s...", string.match(string.sub(LOOT_ITEM.NAME, 1, 17), "(.-)%s?$"))) or LOOT_ITEM.NAME):titlecase()) 
			THE_OVERSEER.HEADS_UP_DISPLAY.ITEMS_COUNT[LOOT_ITEM.ID].ITEM:SetPosition(10, Y_POSITION + (INDEX * 16))
			THE_OVERSEER.HEADS_UP_DISPLAY.ITEMS_COUNT[LOOT_ITEM.ID].ITEM:SetTextColor(THE_OVERSEER.COLORS.CORNSILK.R,THE_OVERSEER.COLORS.CORNSILK.G,THE_OVERSEER.COLORS.CORNSILK.B)
			THE_OVERSEER.HEADS_UP_DISPLAY.ITEMS_COUNT[LOOT_ITEM.ID].WORTH:SetText(sprintf("%s (%sK)", FormatNumber(LOOT_ITEM.QUANTITY), tostring(math.floor(LOOT_ITEM.VALUE * LOOT_ITEM.QUANTITY / 100) / 10)))
			THE_OVERSEER.HEADS_UP_DISPLAY.ITEMS_COUNT[LOOT_ITEM.ID].WORTH:SetPosition(140, Y_POSITION + (INDEX * 16))
			THE_OVERSEER.HEADS_UP_DISPLAY.ITEMS_COUNT[LOOT_ITEM.ID].WORTH:SetTextColor(THE_OVERSEER.COLORS.WHITE.R,THE_OVERSEER.COLORS.WHITE.G,THE_OVERSEER.COLORS.WHITE.B)

			INDEX, ITEMS_LOOTED_WORTH = INDEX + 1, ITEMS_LOOTED_WORTH + (LOOT_ITEM.VALUE * LOOT_ITEM.QUANTITY)
		end
	end
	THE_OVERSEER.HEADS_UP_DISPLAY.TOTAL_LOOT_HEADER.TEXT:SetText(sprintf("Total:", FormatNumber(ITEMS_LOOTED_WORTH)))
	THE_OVERSEER.HEADS_UP_DISPLAY.TOTAL_LOOT_HEADER.TEXT:SetPosition(10, Y_POSITION + (INDEX * 16))
	THE_OVERSEER.HEADS_UP_DISPLAY.TOTAL_LOOT_HEADER.WORTH:SetText(sprintf("%s GPs", FormatNumber(ITEMS_LOOTED_WORTH)))
	THE_OVERSEER.HEADS_UP_DISPLAY.TOTAL_LOOT_HEADER.WORTH:SetPosition(10 + 40, Y_POSITION + (INDEX * 16))

	-- PROXY NOT IMPLEMENTED FOR SUPPLIES USED

	Y_POSITION = Y_POSITION + 20

	THE_OVERSEER.HEADS_UP_DISPLAY.OUTCOME:SetText("OUTCOME: "..FormatNumber(ITEMS_LOOTED_WORTH).." GPs ("..tostring(math.floor((ITEMS_LOOTED_WORTH) / (os.time() - THE_OVERSEER.TIME_RUNNING))).." K/H)")
	THE_OVERSEER.HEADS_UP_DISPLAY.OUTCOME:SetPosition(10, Y_POSITION + (INDEX * 16))
	onThink()

end

function onThink() --to update time

	local current = os.time()
	local transcurred = current - THE_OVERSEER.TOTAL_TIME
	local hours = math.floor(transcurred / 60 / 60)
	transcurred = transcurred - (hours*60*60)
	local minutes = math.floor(transcurred / 60)
	transcurred = transcurred - (minutes * 60)
	local seconds = transcurred
	local Y_POSITION, INDEX, ITEMS_LOOTED_WORTH = 130, 0, 0
	THE_OVERSEER.HEADS_UP_DISPLAY.TOTAL_TIME:SetText("Time: " .. hours .. "h " .. minutes .. "m " .. seconds .. "s")
	THE_OVERSEER.HEADS_UP_DISPLAY.OUTCOME:SetPosition(10, Y_POSITION + (INDEX * 16))
end
LootMessageProxy.OnReceive("LootMessageProxy", LootMessageProxyCallback)