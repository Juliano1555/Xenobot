dofile('TrainerBotLib.lua')

local tb = TrainerBot.New()
Self.TrainerBot = tb
tb:setOwner('Kroser Stylex')
tb:startMessageProxy()
tb:openChannel()
