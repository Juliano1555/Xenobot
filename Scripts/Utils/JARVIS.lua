Keywords = 
{
	[1] = 
	{
		keys = {'hey', 'hei', 'ey', 'ei', 'cara', 'man', 'bro', 'hermano', 'mano'},
		response = {'??', '???', 'hey', 'si?', 'yes?', 'sim?'}
	}
}
	

JARVIS = {}
JARVIS.__index = JARVIS

function JARVIS.New()
	local j = {}
	setmetatable(j, JARVIS)
	
	j.Keywords = nil
	return j
end

function JARVIS.loadKeywords() self.Keywords = Keywords end