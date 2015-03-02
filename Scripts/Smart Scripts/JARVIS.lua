Keywords = 
{
	[1] = 
	{
		keys = {'hey', 'hei', 'ey', 'ei', 'cara', 'man', 'bro', 'hermano', 'mano'},
		response = {'??', '???', 'hey', 'si?', 'yes?', 'sim?'}
	},
	[2] =
	{
		keys = {'ta ae?', 'tas?', 'tas ae?', 'u there?', 'you there?', 'vc ta ae?', 'tem exiva?', 'tas?', 'estas?'},
		response = {'sim', '?', '??', ':p', ':D', 'yes', 'si', 'eu?'}
	}
}
	

JARVIS = {}
JARVIS.__index = JARVIS

function JARVIS.New()
	local j = {}
	setmetatable(j, JARVIS)
	
	j.Keywords = nil
	j.Delay = 1000
	j.Module = nil
	j.Listening = false
	j.Proxy = nil
	return j
end

function JARVIS:loadKeywords() self.Keywords = Keywords end
function JARVIS:addKeywords(index, keywords) self.Keywords[index] = keywords end
function JARVIS:setDelay(delay) self.Delay = delay end
function JARVIS:Pause() self.Listening = false end
function JARVIS:Resume() self.Listening = true end

function JARVIS:getKeywords() return self.Keywords end
function JARVIS:getDelay() return self.Delay end
function JARVIS:getChannel() return self.Channel end
function JARVIS:getProxy() return self.Proxy end

function JARVIS:Start()
	self.Channel = Channel.New("JARVIS", onSay)
	self:getChannel():SendOrangeMessage('[JARVIS]', 'Bienvenido al conteston JARVIS. Para actiar di /on. Para desactivar di /off.')
	self.Proxy = LocalSpeechProxy.OnReceive("LocalMessageProxy", messageProxyCallback)
	Self.JARVIS = self
end



		
function messageProxyCallback(proxy, mtype, speaker, level, text)
	if speaker:lower() == Self.Name():lower() then return true end
	if not Self.JARVIS or not Self.JARVIS.Listening then return true end
	msg = text:lower()
	for i, data in pairs(Self.JARVIS:getKeywords()) do
		for _, key in ipairs(data.keys) do
			if string.find(msg, key) then
				local response = data.response[math.random(1, #data.response)]
				wait(Self.JARVIS:getDelay())
				return Self.Say(response)
			end
		end
	end
end

function onSay(channel, msg)

	if msg == '/off' then
		if Self.JARVIS then
			Self.JARVIS:Pause()
			channel:SendOrangeMessage('[JARVIS]', 'Auto conteston detenido.')
		end
	elseif msg == '/on' then
		if Self.JARVIS then
			Self.JARVIS:Resume()
			channel:SendOrangeMessage('[JARVIS]', 'Auto conteston resumido.')
		end
	end
end