dofile('[CONFIG] Apes -2.lua')
dofile('ssLib.lua')
registerEventListener(WALKER_SELECTLABEL, "onLabel")
print("BANUTA APES -2. CHECK OUT WWW.SolidScripts.TK FOR MORE SCRIPTS.")

Targeting.Start()
Looter.Start()

function onLabel(label)
	if(label == "Backpacks") then
		Client.HideEquipment()
		repeat
			Self.CloseContainers()
			wait(200, 400)
			Self.OpenMainBackpack(true):OpenChildren({_stackBackpack, true}, {_rareBackpack, true}, {_goldBackpack, true}, {_suppliesBackpack, true})
			wait(200, 400)
		until SolidScripts.CheckBackpacks(5)
	elseif(label == "Stamina") then
		SolidScripts.CheckStamina(false)
	elseif(label == "BankNPC") then
		SolidScripts.WithdrawMoney()
	elseif(label == "PotionsNPC") then
		SolidScripts.BuyPotions(false)
	elseif(label == "CheckSofts") then
		SolidScripts.CheckSofts()
	elseif(label == "CheckSupplies") then
		SolidScripts.CheckSupplies()
	elseif(label == "Check") then
		SolidScripts.Check()
	elseif(label == "Deposit") then
		SolidScripts.ReachDepot()
		Self.DepositItems({3357, 0}, {3093, 0}, {3084, 0}, {3050, 0}, {3072, 0})
		Self.DepositItems({5883, 1}, {11471, 1}, {11511, 1}, {266, 1})
	end
end

if(_dropVials) then
	Module.Start('vial-dropper')
end

if(_refillMana) then
	Module.Start('mana-refiller')
end

if(_useSoftBoots) then
	Module.Start('equip-softs')
end

if(_screenLevel) then
	Module.Start('screen-shooter')
end

if(_useRecoverySpell) then
    Module.Start('recovery-caster')
end

Module.Start('sort-supplies')