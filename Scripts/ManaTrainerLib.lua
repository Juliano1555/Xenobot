ManaTrainer = {}
ManaTrainer.__index = ManaTrainer

function ManaTrainer.New(spellWords, spellMana, delay)
	local m = {}
	setmetatable(m, ManaTrainer)
	
	m._Words = spellWords
	m._Mana = spellMana
	m._Running = false
	m._Delay = delay or 3000 --default
	m._Fishing = Fishing.New(2000)
	m._Pk = false
	m._Started = nil
	m._Module = nil
	m._Status =
	{
		_ManaWasted = 0
	}
	m._HUD = nil
	
	return m
end

function ManaTrainer:Start()
	print("Mana Trainer Started")
	self:Running(true)
	self:StartModule()
	self:StartHUD()
	self:Started(os.time())
end

function ManaTrainer:StartModule()
	self._Module = Module.New("ManaTrainerModule", function(module)
		if self:isRunning() then
			if Self.Mana() >= self:GetMana() and Self.CanCastSpell(self:GetSpellWords()) then
				Self.Say(self:GetSpellWords())
				self:GetStatus()._ManaWasted = self:GetStatus()._ManaWasted + self:GetMana()
				self:UpdateHud()
			end
			
			if self:isPkOnScreen() and not self:isGoingToDepot() then
				self:SetPk(true)
				self:GoToDepot()
			end
		end
		module:Delay(self:GetDelay())
	end)
end

function ManaTrainer:StartHUD()
	self._HUD = HUD.New(0,0,"",0,0,0)
	self:GetHUD():SetPosition(10, 16)
	self:GetHUD():SetTextColor(255, 165, 35)
end

function ManaTrainer:UpdateHud(t)
	self:GetHUD():SetText("Mana Wasted: " .. self:GetStatus()._ManaWasted)
end

function ManaTrainer:GoToDepot()
	self:GoingDepot(true)
	self:Stop()
	self:GetFishing():Stop()
	Walker.Goto("GoToDepot")
	Walker.Start()
end


function ManaTrainer:Stop() self:Running(false) print("Mana Trainer Stopped.") end
function ManaTrainer:isRunning() return self._Running end
function ManaTrainer:GetDelay() return self._Delay end
function ManaTrainer:GetMana() return self._Mana end
function ManaTrainer:GetSpellWords() return self._Words end
function ManaTrainer:GetFishing() return self._Fishing end
function ManaTrainer:Running(bool) self._Running = bool end
function ManaTrainer:SetPk(b) self._Pk = b end
function ManaTrainer:Pk() return self._Pk end
function ManaTrainer:GoingDepot(b) self._GoingDepot = b end
function ManaTrainer:isGoingToDepot() return self._GoingDepot end
function ManaTrainer:GetStatus() return self._Status end
function ManaTrainer:GetHUD() return self._HUD end
function ManaTrainer:isStarted() return self._Started end
function ManaTrainer:Started(b) self._Started = b end

function ManaTrainer:isPkOnScreen()
	for i = CREATURES_LOW, CREATURES_HIGH do
		local creature = Creature.GetFromIndex(i)
		if creature:isValid() and creature:ID() ~= Self.ID() then
			if creature:isOnScreen() and creature:isVisible() and creature:isAlive() then
				if creature:isPlayer() and creature:Skull() == SKULL_WHITE then
					return true
				end
			end
		end
	end
	return false
end

Fishing = {}
Fishing.__index = Fishing

function Fishing.New(delay)
	local f = {}
	setmetatable(f, Fishing)
	
	f._Delay = delay or 2000
	f._Running = false
	f._Worms = 100 --default
	f._Module = nil
	return f
end

function Fishing:Start()
	print("Fishing Started")
	self:Running(true)
	self:StartModule()
end

function Fishing:StartModule()
	self._Module = Module.New("FishingModule", function(module)
		if self:isRunning() then
			for a = -7,7 do
				p=Self.Position()
				for b=-5,5 do
					if table.isStrIn({4597,4598,4599,4600,4601,4602},getTileUseID(p.x+a,p.y+b,p.z).id) and Self.Cap() >= 10 then
						selfUseItemWithGround(3483,p.x+a,p.y+b,p.z)
						wait(self:GetDelay())
					end
				end
			end
			wait(self:GetDelay())
		end
		module:Delay(self:GetDelay())
	end)
end

function Fishing:Stop() self._Running = false print("Fishing Stopped.") end
function Fishing:isRunning() return self._Running end
function Fishing:GetDelay() return self._Delay end
function Fishing:RequiredWorms() return self._Worms end
function Fishing:SetWorms(w) self._Worms = w end
function Fishing:Running(b) self._Running = b end

	