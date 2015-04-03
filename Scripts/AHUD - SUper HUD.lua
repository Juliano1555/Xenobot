_CONFIG =
{
	items = {},
	ready = false,
	topic = -1,
	lastItemHUDIndex = 0
}

_CHANNEL_NAMES =
{
	NORMAL = '[Loot HUD]',
	CONFIG = '[Loot HUD-Config]',
	ERROR = '[!Loot HUD-Error]'
}

_HUDS =
{
	items = {}
}

_TEXTCOLORS =
	{
        BLACK = {R = 1, G = 1, B = 1},
        ORANGE = {R = 255, G = 165, B = 0},
        BLUE = {R = 30, G = 144, B = 255},
        CORNSILK = {R = 205, G = 200, B = 177},
        WHITE = {R = 255, G = 255, B = 255},
        GREEN = {R = 107, G = 142, B = 35},
        RED = {R = 178, G = 34, B = 34},
    }

function string:split(DELIMITER) -- Working
	assert(type(DELIMITER) == [[string]], sprintf([[bad argument #1 to 'string:split' (string expected, got %s)]], type(DELIMITER)))

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


function onSay(channel, msg)

	msg = msg:lower()
	channel:SendYellowMessage(Self.Name(), msg)
	if msg == '/config' then
		if _CONFIG.ready then 
			channel:SendOrangeMessage(_CHANNEL_NAMES.NORMAL, 'El script ya se encuentra configurado.')
		else
			
			channel:SendOrangeMessage(_CHANNEL_NAMES.CONFIG, 'Ingresa los nombres/ids de los items que deseas organizar. Ejemplo: gold coin, boots of haste, 2195')
			_CONFIG.topic = 1
		end
	elseif msg ~= '' and _CONFIG.topic == 1 then
		--items 
		--parse items
		local added = 0
		local str = msg:split(',')
		if #str > 0 then --hay items
			for _, it in ipairs(str) do
				local ws = string.sub(it, 1, 1)
				if ws == ' ' then
					it = string.sub(it, 2, string.len(it))
				end
				if type(it) == 'string' then
					if Item.GetID(it) ~= '<invalid>' then
						table.insert(_CONFIG.items, {id = Item.GetID(it), looted = 0})
						added = added + 1
					else
						channel:SendOrangeMessage(_CHANNEL_NAMES.ERROR, 'Item con el nombre \'' .. it .. '\' no existe. Verifica que el nombre es correcto y no estas colocando el nombre en plural.')
					end
				elseif type(it) == 'number' then
					if Item.GetName(it) ~= '<invalid>' then
						table.insert(_CONFIG.items, {id = it, looted = 0})
						added = added + 1
					else
						channel:SendOrangeMessage(_CHANNEL_NAMES.ERROR, 'Item con el id \'' .. it .. '\' no existe. Verifica que el id es correcto.')
					end
				else
					channel:SendOrangeMessage(_CHANNEL_NAMES.ERROR, 'Elemento \'' .. it .. '\' no reconocido.')
				end
			end
		else
			channel:SendOrangeMessage(_CHANNEL_NAMES.ERROR, 'Por favor ingresa una combinacion de nombre/ids de items validos.')
		end
		
		if added > 0 then
			channel:SendOrangeMessage(_CHANNEL_NAMES.CONFIG, 'Se han agregado ' .. added .. ' items a la lista.')
			_CONFIG.ready = true
			--show items hud
			local index = 0
			local idh = 0
			for _, item in ipairs(_CONFIG.items) do
				local hud = HUD.New(0,0,'',0,0,0)
				hud:SetPosition(10, 5 + index*16)
				hud:SetText(Item.GetName(item.id) .. ': ' .. item.looted)
				hud:SetTextColor(_TEXTCOLORS.ORANGE.R, _TEXTCOLORS.ORANGE.G, _TEXTCOLORS.ORANGE.B)
				table.insert(_HUDS.items, {id = idh, hud = hud, thing = Item.GetName(item.id), count = item.looted})
				_CONFIG.lastItemHUDIndex = index
				index = index + 1
				idh = idh + 1
			end
		else
			channel:SendOrangeMessage(_CHANNEL_NAMES.ERROR, 'No se ha agregado ningun item a la lista. Por favor ingresa correctamente el nombre/id de los items, separados por comas si es mas de uno.')
			_CONFIG.topic = 1
		end
	end
end

function tablefind(t, value, field)
    for n = 1, #t do
		if(t[n].field == value)then
			return true
		end
    end
    return false
end

function ParseLootMessage(MESSAGE_POINTER, WITH_QUANTITY) -- Working
	
	local LOOT_INFO, LOOT_INFO_TEMP = {NAME = [[]], ITEMS = {}}
	
	LOOT_INFO.NAME, LOOT_INFO_TEMP = MESSAGE_POINTER:match([[Loot of (.+): (.+)]])
	if (LOOT_INFO.NAME) then
		LOOT_INFO.NAME = LOOT_INFO.NAME:gsub([[^a ]], [[]]):gsub([[^an ]], [[]]):gsub([[^the ]], [[]]):lower()
		if (LOOT_INFO_TEMP ~= [[nothing]]) then
			for _, ITEM_NAME in ipairs(LOOT_INFO_TEMP:split([[, ]])) do
				local ITEM_QUANTITY, ITEM_NAME_TEMP = tonumber(ITEM_NAME:split([[ ]])[1]) or 1, ITEM_NAME:gsub([[%d]], [[]]):gsub([[^a ]], [[]]):gsub([[^an ]], [[]]):trim():lower()
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

function LootMessageProxyCallback(proxy, message)
	local LOOT_INFO = ParseLootMessage(message, true)

	if #LOOT_INFO.NAME > 0 then
		for _, LOOT_ITEM in ipairs(LOOT_INFO.ITEMS) do
			for _, data in ipairs(_CONFIG.items) do
				if data.id == LOOT_ITEM.ID then
					data.looted = data.looted + LOOT_ITEM.QUANTITY
				end
			end
			for _, hud in ipairs(_HUDS.items) do
				if Item.GetName(LOOT_ITEM.ID) == hud.thing then
					hud.count = hud.count + LOOT_ITEM.QUANTITY
					hud.hud:SetText(hud.thing .. ': ' .. hud.count)
				end
			end
		end
	end


end

channel = Channel.New("Loot HUD", onSay)
channel:SendOrangeMessage(_CHANNEL_NAMES.NORMAL, 'Bienvenido al arreglador de loot y estadisticas. Escribe \'/config\' para configurar.')

LootMessageProxy.OnReceive("LootMessageProxy", LootMessageProxyCallback)