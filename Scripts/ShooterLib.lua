Shooter = {}
Shooter.__index = Shooter

function Shooter.New()
	local s = {}
	setmetatable(s, Shooter)
	
	s._Spells = {}
	s._Module = nil
	s._Running = false
	s._Delay = 300
	return s
end

function Shooter:Start()
	self:Running(true)
	self:StartModule()
	self:StartHUD()
	Self.Shooter = self
	Self.NextBuff = 0
end

function Shooter:Stop() 
	self:Running(false) 
	self:GetModule():Stop()
end

function Shooter:StartModule()
	self._Module = Module.New("ShooterModule", function(module)
		if not self:isRunning() then return true end
		if Self.Healer ~= nil and Self.Healer:isBusy() then return true end
		for _, spell in ipairs(self:GetSpells()) do

			local amount = Shooter.GetTargetCount(spell:GetRadius(), spell:GetCheckRadius(), spell:CountPlayers(), spell:GetIgnoreList())
			local m = math.max(spell:GetMax(), (amount or 0))
			if amount and amount >= spell:GetMin() and amount <= m then
				if spell:NeedsTarget() then
					local target = Creature(Self.TargetID())
					if target and target:isValid() and not target:isSelf() and target:isTarget() and target:isMonster() and target:isOnScreen() and target:isVisible() and target:isAlive() and target:isReachable() then
						if target:DistanceFromSelf() <= spell:GetRadius() then
							if spell:CanBeCasted() then
								if spell:UseBuff() then
									spell:CastBuff()
								end
								spell:Cast()
								break
							end
						end
					end
				else
					spell:Cast()
					break
				end
			end
		end
		module:Delay(self:GetDelay())
	end)
end

function Shooter.GetTargetCount(radius, checkRadius, countPlayers, ignoreList)
	local n = 0
	for i = CREATURES_LOW, CREATURES_HIGH do
		local creature = Creature.GetFromIndex(i)
		if creature:isValid() and creature:ID() ~= Self.ID() then
			if creature:isOnScreen() and creature:isVisible() and creature:isAlive() and creature:isReachable() then
				local name = creature:Name()
				if creature:DistanceFromSelf() <= checkRadius then
					if creature:DistanceFromSelf() <= radius then
						if creature:isPlayer() then
							if countPlayers then
								n = n + 1
							else
								return false
							end
						else
							if ignoreList and #ignoreList > 0 then
								if not table.contains(ignoreList, creature:Name()) then
									n = n + 1
								end
							else
								n = n + 1
							end
						end
					end
				end
			end
		end
	end
	return n
end
		
function Shooter:GetModule() return self._Module end
function Shooter:AddSpell(spell) table.insert(self._Spells, spell) end
function Shooter:StartHUD() end
function Shooter:Running(b) self._Running = b end

function Shooter:GetSpells() return self._Spells end
function Shooter:isRunning() return self._Running end
function Shooter:Delay(n) self._Delay = n end
function Shooter:GetDelay() return self._Delay end


Spell = {}
Spell.__index = Spell

function Spell.New(words, min, radius, checkRadius, needsTarget, countPlayers, useBuff, buffWords, buffDelay, ignoreList)

	local sp = {}
	setmetatable(sp, Spell)
	
	sp._Words = words
	sp._Min = min
	sp._Max = 0
	sp._Radius = radius
	sp._CheckRadius = checkRadius
	sp._NeedsTarget = needsTarget
	sp._CountPlayers = countPlayers
	sp._UseBuff = useBuff
	sp._BuffWords = buffWords
	sp._BuffDelay = buffDelay
	sp._IgnoreList = ignoreList
	
	return sp
end

function Spell:Ignore(name) table.insert(self._IgnoreList, name) end
function Spell:Cast() Self.Say(self:GetWords()) end
function Spell:SetMax(n) self._Max = n end

function Spell:GetWords() return self._Words end
function Spell:GetMin() return self._Min end
function Spell:GetMax() return self._Max end
function Spell:GetRadius() return self._Radius end
function Spell:GetCheckRadius() return self._CheckRadius end
function Spell:NeedsTarget() return self._NeedsTarget end
function Spell:CountPlayers() return self._CountPlayers end
function Spell:UseBuff() return self._UseBuff end
function Spell:GetBuff() return self._BuffWords end
function Spell:GetBuffDelay() return self._BuffDelay end
function Spell:GetIgnoreList() return self._IgnoreList end
function Spell:CanBeCasted() return Self.CanCastSpell(self:GetWords()) end

function Spell:CastBuff()
	if Self.CanCastSpell(self:GetBuff()) and (os.time() - Self.NextBuff) >= (self:GetBuffDelay() / 1000) then
		Self.Say(self:GetBuff())
		Self.NextBuff = os.time() + (self:GetBuffDelay() / 1000)
		wait(50)
	end
end
