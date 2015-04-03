Trainer = {}
Trainer.__index = Trainer

function Trainer:new()
	local t = {}
	setmetatable(t, Trainer)
	t.__BattleModule = nil
	t.__FishingModule = nil
	t.__Allies = {}
	t.__Targets = {}
	return t
end


function Trainer:addTarget(target)	table.insert(self.__Targets, target) end
function Trainer:addAlly(ally) table.insert(self.__Allies, ally) end

function Trainer:startBattleModule()
	self.__BattleModule = Module.New("BattleModule", function(module)
		--if #self.__Allies < 1 then return true
		if #self.__Targets < 1 then return true end
		--let's find a target
		if Self.TargetID() < 1 then
			for i = CREATURES_LOW, CREATURES_HIGH do
				local creature = Creature.GetFromIndex(i)
				if creature:isValid() and creature:ID() ~= Self.ID() then
					if creature:isOnScreen() and creature:isVisible() and creature:isAlive() and creature:isReachable() then
						local name = creature:Name()
						if creature:DistanceFromSelf() <= 1 then
							if table.contains(self:getTargets(), name) --target found
								if creature:HealthPercent() >= 30 then
									creature:Attack()
									break
								end
							end
						end
					end
				end
			end
		else --is attacking
			local target = Creature(Self.TargetID())
			if target:isOnScreen() and target:isVisible() and target:isAlive() and target:isReachable() then
				if target:HealthPercent() <= 20 then
					Self.StopAttack()
				end
			end
		end
		module:Delay(1000)
	end)
end




