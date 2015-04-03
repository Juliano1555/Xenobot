dofile("ManaTrainerLib.lua")

registerEventListener(WALKER_SELECTLABEL, "onWalkerSelectLabel")

print([[
Mana Trainer Script by Darkhaos
]])

trainer = ManaTrainer.New("exura vita", 160)
MANA_WASTED = HUD.New(0,0,"",0,0,0)
function onWalkerSelectLabel(labelName)

	if labelName == "MainReached" then
		Walker.Stop()
		print("Main position reached.")
		trainer:Start()
		trainer:GetFishing():Start()
		--start mana trainer
	elseif labelName == "DepotReached" then
		Walker.Stop()
		if trainer:Pk() then
			trainer:SetPk(false)
			trainer:GoingDepot(false)
		end
		if Self.ItemCount(Item.GetID("worm")) < trainer:GetFishing():RequiredWorms() then
			Walker.Goto("GoBuyWorms")
			Walker.Start()
		end
		Walker.Start()
	elseif labelName == "Bank" then
		Walker.Stop()
		local money = trainer:GetFishing():RequiredWorms() * 1
		Self.SayToNpc("hi")
		sleep(math.random(1000, 1500))
		Self.SayToNpc("withdraw " .. money)
		sleep(math.random(1000, 1500))
		Self.SayToNpc("yes")
		wait(200)
		Walker.Start()
	elseif labelName == "BuyWorms" then
		Walker.Stop()
		local requiredWorms = trainer:GetFishing():RequiredWorms() - Self.ItemCount(Item.GetID("worm"))
		if requiredWorms > 0 then
			Self.SayToNpc("hi")
			sleep(math.random(1000, 1500))
			Self.SayToNpc("trade")
			sleep(math.random(500, 800))
			repeat
					Self.ShopBuyItem(Item.GetID("worm"), requiredWorms)
			until Self.ItemCount(Item.GetID("worm")) >= trainer:GetFishing():RequiredWorms()
			sleep(math.random(600, 1000))
		end
		Walker.Start()		
	end
end