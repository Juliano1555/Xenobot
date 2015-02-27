TYPE_HEALTH = 1
TYPE_MANA = 2

Healer = {}
Healer.__index = Healer

function Healer.New()

	local h = {}
	setmetatable(h, Healer)
	h._Spells = {}
	h._Items = {}
	h._Module = nil
	h._Running = false
	h._Busy = false
	h._DangerPercent = 0
	h._Delay = 300
	h._HUDS = {}
	return h
	
end

function Healer:Start()
	table.sort(self._Items, function(a, b) return a:GetPercent() < b:GetPercent() and a:GetType() < b:GetType() end) --healer will check first the ones that requires less health percent
	table.sort(self._Spells, function(a, b) return a:GetPercent() < b:GetPercent() end)
	self:Running(true)
	self:StartModule()
	self:StartHUD()
	self:ShowInfo()
	Self.Healer = self
end

function Healer:Stop()
	self:Running(false)
	self:GetModule():Stop()
end

function Healer:StartModule()
	self._Module = Module.New("HealerModule", function(module)
		if not self:isRunning() then return true end
		--first the items
		self:Busy(true)
		for _, ite in ipairs(self:GetItems()) do
			local percent = ite:GetPercent()
			local current = (ite:GetType() == TYPE_HEALTH and Self.Health() * 100 / Self.MaxHealth() or Self.Mana() * 100 / Self.MaxMana())
			if current <= percent and ite:CanBeUsed() then
				ite:Use()
				break
			end
		end
		
		for _, spell in ipairs(self:GetSpells()) do
			local percent = spell:GetPercent()
			local current = (spell:GetType() == TYPE_HEALTH and Self.Health() * 100 / Self.MaxHealth() or Self.Mana() * 100 / Self.MaxMana())
			if current <= percent and spell:CanBeCasted() then
				spell:Cast()
				break
			end
		end
		self:Busy(false)
		module:Delay(self:GetDelay())
	end)
end

function Healer:AddSpell(spell) table.insert(self._Spells, spell) end
function Healer:AddItem(item) table.insert(self._Items, item) end

function Healer:StartHUD() 
	--show all items and spells
	local index = 0
	for _, item in ipairs(self:GetItems()) do
		table.insert(self._HUDS, HUD.New(10, index*16, Item.GetName(item:GetID()) .. ": " .. item:GetPercent() .. "%", 255, 165, 35))
		index = index + 1
	end
	
end

function Healer:GetModule() return self._Module end
function Healer:Running(b) self._Running = b end
function Healer:isRunning() return self._Running end
function Healer:GetItems() return self._Items end
function Healer:GetSpells() return self._Spells end
function Healer:isBusy() return self._Busy end
function Healer:Busy(b) self._Busy = b end
function Healer:SetDangerPercent(n) self._DangerPercent = n end
function Healer:GetDangerPercent() return self._DangerPercent end
function Healer:Delay(n) self._Delay = n end
function Healer:GetDelay() return self._Delay end

function Healer:ShowInfo()
	local str = ""
	for _, ite in ipairs(self:GetItems()) do
		str = str .. Item.GetName(ite:GetID()) .. ": " .. ite:GetPercent() .. "\n"
	end
	
	for _, spell in ipairs(self:GetSpells()) do
		str = str .. spell:GetWords() .. ": " .. spell:GetPercent() .. "\n"
	end
	print(str)
end
		

HealerItem = {}
HealerItem.__index = HealerItem

function HealerItem.New(id, percent, typ)
	local hi = {}
	setmetatable(hi, HealerItem)
	
	hi._Id = id
	hi._Percent = percent
	hi._Type = typ or TYPE_HEALTH
	
	return hi
end

function HealerItem:GetPercent() return self._Percent end
function HealerItem:GetID() return self._Id end
function HealerItem:GetType() return self._Type end

function HealerItem:CanBeUsed() return Self.ItemCount(self:GetID()) > 0 end
function HealerItem:Use()
	Self.UseItemWithMe(self:GetID())
end

HealerSpell = {}
HealerSpell.__index = HealerSpell

function HealerSpell.New(words, percent, typ)
	local hs = {}
	setmetatable(hs, HealerSpell)
	
	hs._Words = words
	hs._Percent = percent
	hs._Type = typ or TYPE_HEALTH
	
	return hs
end

function HealerSpell:GetPercent() return self._Percent end
function HealerSpell:GetWords() return self._Words end
function HealerSpell:CanBeCasted() return Self.CanCastSpell(self:GetWords()) end
function HealerSpell:GetType() return self._Type end

function HealerSpell:Cast()
	if self:CanBeCasted() then
		Self.Say(self:GetWords())
	end
end
	
		