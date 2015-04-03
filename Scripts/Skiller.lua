Skiller = {}
Skiller.__index = Skiller

function Skiller:New()
	local s = {}
	setmetatable(s, Skiller)
	
	t._Count = 2
	t._MainCreature = nil
	t._Others = {}
	t._AcceptOthers = true
	t._Module = nil
	t._Running = false
	t._Fishing = Fishing.New()
	t._MainWeapon = nil
	t._TrainWeapon = nil
	t._MainShield = nil
	t._TrainShield = nil
	
	t._RefillAmmo = false
	t._AmmoID = nil
	
	t._Started = nil
	
	t._Combat = Combat:New()
	t._Pk = false
	
	return t
end

function Skiller:Start()
	self:Running(true)
	self:StartModule()
	self:StartHUD()
	self:GetFishing():Start()
	print("Skiller Started.")
end

function Skiller:StartModule()
	self._Module = Module.New("SkillerModule", function(module)
		local creatures = self:GetCreatures(self:GetMain())
		if Self.TargetID() > 0 then
			local target = Creature(Self.TargetID())
			if target:HealthPercent() < 20 then
				for _, cid in ipairs(creatures) do
					local c_ = Creature(cid)
					if c_:ID() ~= Self.ID() and c_:ID() ~= Self.TargetID() and c_:HealthPercent() >= 20 then
						c_:Attack()
						break
					end
				end
			end
		else
			Walker.Goto("FindMonster")
			Walker.Start()
		end
		module:Delay(1000)
	end)
end

function Skiller:StartHUD()
	--add hud
end

function Skiller:GetCreatures(_name)
	local t = {}
	for i = CREATURES_LOW, CREATURES_HIGH do
		local creature = Creature.GetFromIndex(i)
		if creature:isValid() and creature:ID() ~= Self.ID() then
			if creature:isOnScreen() and creature:isVisible() and creature:isAlive() and creature:isReachable() and creature:isMonster() and creature:DistanceFromSelf() <= 2 then
				local name = creature:Name()
				if name == _name then
					table.insert(t, creature:ID())
				end
			end
		end
	end
	return t
end

function Skiller:SetMain(name) self._MainCreature = name end
function Skiller:GetMain() return self._MainCreature end
function Skiller:SetOthers(tab) self._Others = tab end
function Skiller:AddOther(name) table.insert(self._Others, name) end
function Skiller:SetCount(n) self._Count = n end
function Skiller:AcceptOthers(b) self._AcceptOthers = b end
function Skiller:CanAcceptOthers() return self._AcceptOthers end
function Skiller:Running(b) self._Running = b end
function Skiller:isRunning() return self._Running end

function Skiller:GetCombat() return self._Combat end

Combat = {}
Combat.__index = Combat

function Combat:New()
	local c = {}
	setmetatable(c, Combat)
	
	c._Target = nil
	c._DamageDeal = 0,
	c._DamageTaken = 0,
	c._DamageDealPerSecond = 0,
	c._DamageTakenPerSecond = 0
	
	return c
emd

function Combat:SetTarget(id)
	self._Target = id
end