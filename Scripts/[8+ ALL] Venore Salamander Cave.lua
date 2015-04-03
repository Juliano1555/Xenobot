dofile('[CONFIG] Venore Salamander Cave.lua')
dofile('ssLib.lua')
registerEventListener(WALKER_SELECTLABEL, "onLabel")

Targeting.Start()
Looter.Start()

function onLabel(label)
	if(label == "Backpacks") then
		Client.HideEquipment()
		repeat
			Self.CloseContainers()
			wait(200, 400)
			Self.OpenMainBackpack(true):OpenChildren({_goldBackpack, true})
			wait(200, 400)
		until SolidScripts.CheckBackpacks(2)
	elseif(label == "Stamina") then
		SolidScripts.CheckStamina(false)
	elseif(label == "BankNPC") then
		SolidScripts.WithdrawMoney()
	elseif(label == "PotionsNPC") then
		SolidScripts.BuyPotions(false)
	elseif(label == "CheckSupplies") then
		SolidScripts.CheckSupplies()
	elseif(label == "Check") then
		SolidScripts.Check()
	elseif(label == "Deposit") then
		SolidScripts.ReachDepot()
		Self.DepositItems({17461, 0}, {17462, 0}, {17822, 0}, {17823, 0}, {17458, 0}, {17463, 0})
	elseif(label == "rope1") then
		SolidScripts.UseRope(32924, 32106)
	elseif(label == "rope2") then
		SolidScripts.UseRope(32818, 32143)
	elseif(label == "rope3") then
		SolidScripts.UseRope(32919, 32142)
	elseif(label == "rope4") then
		SolidScripts.UseRope(32924, 32148)
	end
end

if(_dropVials) then
	Module.Start('vial-dropper')
end

if(_screenLevel) then
	Module.Start('screen-shooter')
end