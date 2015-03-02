local items_str = {'gold coin', 'mace', 'viking helmet', 'hatchet', 'sword', 'scale armor'}
local items = {284, 283, 285}

for _, name in ipairs(items_str) do
	table.insert(items, Item.GetID(name))
end

local containerName = 'red backpack'  -- Ex. "Purple Backpack", "Backpack of holding", "Bag" etc
local minCap = 50

local range = 3

Module.New('lootFromGround', function(module)
	if Self.Cap() >= minCap then
		if (Self.TargetID() <= 0) then
			local pos = Self.Position()
			for y = -range, range do
				for x = -range, range do
					if table.find(items, Map.GetTopMoveItem(pos.x + x, pos.y + y, pos.z).id) then
						Walker.Delay(1000)
						Map.PickupItem(pos.x+x, pos.y+y, pos.z, Container.New(containerName):Index(), 0)  
					end
				end
			end
		end
	end
end)

Collector = {}
Collector.__index = Collector

function Collector:New()

	local c = {}
	setmetatable(c, Collector)
	c.Items = {}
	c.Range = 1
	c.Cap = 50
	c.Data = {}
	c.Module = nil
	c.Running = false
	return c
end

function Collector:addItem(thing)
	if type(thing) == 'string' then
		if Item.GetID(thing) and not table.contains(self.Items, Item.GetID(thing)) then
			table.insert(self.Items, Item.GetID(thing))
			self.Data[Item.GetID(thing)] = 0
		end
	else
		if not table.contains(self.Items, thing) then
			table.insert(self.Items, thing)
			self.Data[thing] = 0
		end
	end
end

function Collector:removeItem(thing)
	if type(thing) == 'string' then
		if Item.GetID(thing) then
			local i = 0
			for _, it in ipairs(self.Items) do
				i = i + 1
				if it == Item.GetID(thing) then
					table.remove(self.Items, i)
					self.Data[it] = nil
					break
				end
			end
		end
	else
		local i = 0
		for _, it in ipairs(self.Items) do
			i = i + 1
			if it == thing then
				table.remove(self.Items, i)
				self.Data[it] = nil
				break
			end
		end
	end
end

function Collector:Resume() self.Running = true end
function Collector:Pause() self.Running = false end

function Collector:setRange(range) self.Range = range end
function Collector:getRange() return self.Range end
function Collector:setCap(cap) return self.Cap = cap end
function Collector:getCap(cap) return self.Cap end

function Collector:Start()

	self.Module = Module.New('Collector', function(module)
		if not self.Running then return true end
		if Self.Cap() >= self:getCap() then
			if (Self.TargetID() <= 0) then
				local pos = Self.Position()
				for y = -range, range do
					for x = -range, range do
						if table.find(self.Items, Map.GetTopMoveItem(pos.x + x, pos.y + y, pos.z).id) then
							local id = Map.GetTopMoveItem(pos.x + x, pos.y + y, pos.z).id
							Walker.Delay(1000)
							Map.PickupItem(pos.x+x, pos.y+y, pos.z, Container.New(containerName):Index(), 0)
							self.Data[id] = self.Data[id] + 1
						end
					end
				end
			end
		end
	end)
end
