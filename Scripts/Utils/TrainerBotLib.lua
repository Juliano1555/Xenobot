Commands =
{
	["move"] =
	{
		Action = Self.Step,
		Parameters = DIRECTIONS
	},
	["step"] =
	{
		Action = Self.Step,
		Parameters = DIRECTIONS
	},
	["say"] =
	{
		Action = Self.Say
	}
}
			

TrainerBot = {}
TrainerBot.__index = TrainerBot

function TrainerBot.New()

	local tb = {}
	setmetatable(tb, TrainerBot)
	tb.Owner = nil
	tb.MessageProxy = nil
	tb.Channel = nil
	return tb
end

function TrainerBot:setOwner(ownerName)
	self.Owner = ownerName
end

function TrainerBot:startMessageProxy()
	LocalSpeechProxy.OnReceive("LocalSpeechProxy", messageProxyCallback)
end

function TrainerBot:openChannel()
	self.Channel = Channel.New("Trainer Bot", onSay)
	self:getChannel():SendOrangeMessage("[Trainer Bot]", "Use !commands to know the commands.")
end

function TrainerBot:sendChannelMessage(message)
	if not self:getChannel() then return false end
	self:getChannel():SendOrangeMessage('[Trainer Bot]', message)
end
--getters

function TrainerBot:getOwner()	return self.Owner end

function TrainerBot:getMessageProxy() return self.MessageProxy end

function TrainerBot:getChannel() return self.Channel end


function messageProxyCallback(proxy, mtype, speaker, level, text)

	local bot = Self.TrainerBot
	if not bot or not bot:getOwner() then return true end
	
	if speaker == bot:getOwner() then --owner speaking
		local split = text:split(':')
		local action = split[1]:lower()
		if Commands[action] then
			local param = split[2]:lower()
			Commands[action].Action(param)
			bot:sendChannelMessage(bot:getOwner() .. ' used ' .. action .. ':' .. param .. '.')
			wait(1000)
		end
	end
	return true
end




		