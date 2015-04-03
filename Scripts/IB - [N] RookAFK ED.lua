--[[ 

ZZZZ. ZZZ?.:Z7.ZZZZZZ:+ZZZZZZ ZZZZZZZ..ZZZ$..ZZ  .ZZZ?.. ZZ..      .ZZZZZZ .~ZZZZZZ7 .ZZ  ..ZZZZZZZ+
 ZZ   ZZZZ.:Z7 ZZ+   .+ZZ.    ZZ...ZZ .ZZZZ:.ZZ  .ZZZZ.  ZZ.        ZZ..ZZ..ZZ....ZZ  ZZ      +ZZ   
 ZZ   ZZ ZZ:Z7 ZZZZZZ.+ZZZZZ  ZZZZZZ=. ZZ.ZZ.ZZ. ZZ.7ZZ .ZZ.        ZZZZZZ..ZZ    ZZ: ZZ      +ZZ   
.ZZ.. ZZ..ZZZ7 ZZ+    +ZZ   ..ZZ.ZZZ . ZZ  ZZZZ..ZZZZZZ..ZZ ...     ZZ...ZZ.ZZ  ..ZZ..ZZ  ..  +ZZ   
ZZZZ..ZZ.  ZZ7 ZZ+    +ZZZZZZ.ZZ. =ZZ. ZZ   ZZZ.ZZ.  ZZZ.ZZZZZZ     ZZZZZZ$ ~ZZZZZZ7 .ZZZZZZ  +ZZ   

ROOK 100% AFK / Last updated: 30/11-2013
Version 1.6

]]

-- Config
local playAlarm = true						-- Plays alarm when you reach main. (set to false to turn off)
local weaponType = "sabre" 					-- "sabre" or "axe" is recommended.
local exptoLeave = 4200 					-- Experience to leave rook, Old default was 6000 (level 8 with 400 exp left to 9).
local goldtoBuy = 140 						-- Gold to go buy equipment on.
local PACC = false							-- Set this to true if you're PACC.
-- Going Main
local GoMain = true						-- Set to false if you don't want to go main from IoD.
local Vocation = "druid"					-- Can be: knight, druid, sorcerer or paladin (REMEMBER LOWERCASE).
local KnightWPN = "steel axe"			-- Can be: "daramian mace", "steel axe" or "jagged sword".
local Town = "ab'dendriel"						-- Town you want to go to.
local CloseClient = false					-- Set to true if you want to xlog the client when you reach main.
--- DON'T CHANGE ANYTHING BELOW THIS LINE ---
	
print([[
ROOK 100% AFK by Infernal Bolt
Config:
PACC = ]] .. tostring(PACC) .. [[.
Vocation = ]] .. Vocation..[[.
GoMain = ]] .. tostring(GoMain)..[[.
Town = ]]..Town..[[.
CloseClient = ]]..tostring(CloseClient)..[[.]])
registerEventListener(WALKER_SELECTLABEL, "SelectLabel")

function SelectLabel(Label)
	if (Label == "checkExpFACC") then -- FACC
		if (Self.Experience() > exptoLeave) then
			gotoLabel("goIodFACC")
		else
			gotoLabel("startFACC")
		end
	elseif (Label == "checkExpPACC") then -- PACC
		if (Self.Experience() > exptoLeave) then
			gotoLabel("goIodPACC")
		else
			gotoLabel("startPACC")
		end
	elseif (Label == "checkPACC") then -- PACC CHECKER
		if PACC then
			print("Going PACC Area")
			gotoLabel("goPACC")
		else
			print("Going FACC Area")
			gotoLabel("goFACC")
		end
	elseif (Label == "checkCap") then
		moneyMeat = Self.Money()+(Self.ItemCount(3577)*2)
		print("Current Money: " .. Self.Money() .. "\nMoney In Meat: " .. (Self.ItemCount(3577)*2) .. "\nTotal: " .. moneyMeat)
		if (Self.Cap() < 100 or moneyMeat > goldtoBuy) then
			gotoLabel("goSell")
		else
			gotoLabel("getFood")
		end
	elseif (Label == "checkMoney") then
		print("Current Money: " .. Self.Money())
		if (Self.Money() > goldtoBuy) then
			gotoLabel("goBuyEq")
		else
			gotoLabel("getFood")
		end
	elseif (Label == "checkEq") then
		if (Self.ItemCount(3559) < 1) or (Self.ItemCount(3361) < 1) or (Self.ItemCount(3355)) < 1 or (Self.ItemCount(3426) < 1) then 
			gotoLabel("buyEq")
		end
	elseif (Label == "checkWeapon") then
		print("Weapon Count: " .. Self.ItemCount(Item.GetID(weaponType)))
		if (Self.ItemCount(Item.GetID(weaponType)) > 0) then
			print("Weapon Bought Successfully.")
		else
			gotoLabel("goBuyEq")
			print("Failed To Buy Weapon.\n" .. weaponType .. " is not sold in NPC?\nCheck Lua File.\nWalker Stopped.")
			alert()
			Walker.Stop()
		end
	elseif (Label == "skipTutorial") then
		setWalkerEnabled(false)
		Self.SayToNpc({"hi", "skip tutorial", "yes"}, 65)
		wait(10000)
		setWalkerEnabled(true)
	elseif (Label == "talkOracle") then
		setWalkerEnabled(false)
		Self.SayToNpc({"hi", "yes", "yes"}, 65)
		wait(2000)
		setWalkerEnabled(true)
	elseif (Label == "buyWeapon") then
		setWalkerEnabled(false)
		Self.SayToNpc({"hi", "trade"}, 65)
		wait(1800, 2500)
		Self.ShopBuyItem(Item.GetID(weaponType), 1)
		wait(2500)
		setWalkerEnabled(true)
	elseif (Label == "buyBp") then
		setWalkerEnabled(false)
		Self.SayToNpc({"hi", "trade"}, 65)
		wait(1800, 2500)
		Self.ShopBuyItem(2854, 1)
		wait(1500)
		Self.SayToNpc({"bye"}, 65)
		setWalkerEnabled(true)
	elseif (Label == "buyEq") then
		setWalkerEnabled(false)
		Self.SayToNpc({"hi", "trade"}, 65)
		wait(800, 1500)
		Self.ShopBuyItem(3355, 1)
		wait(200, 500)
		Self.ShopBuyItem(3361, 1)
		wait(200, 500)
		Self.ShopBuyItem(3559, 1)
		wait(200, 500)
		Self.ShopBuyItem(3426, 1)
		wait(200, 500)
		wait(1500)
		setWalkerEnabled(true)
	elseif (Label == "sellFood") then
		setWalkerEnabled(false)
		Self.SayToNpc({"hi", "trade"}, 65)
		wait(800, 1500)
		Self.ShopSellAllItems(3577)
		wait(1500)
		setWalkerEnabled(true)
	elseif (Label == "equipWeapon") then
		setWalkerEnabled(false)
		Self.Equip(Item.GetID(weaponType), "weapon", 1)
		wait(1000,2000)
		Self.DropItems(Self.Position().x, Self.Position().y, Self.Position().z, 3270)
		wait(1500)
		setWalkerEnabled(true)
	elseif (Label == "equipArmor") then
		setWalkerEnabled(false)
		Self.Equip(3361, "armor", 1)
		wait(200, 500)
		Self.DropItems(Self.Position().x, Self.Position().y, Self.Position().z, 3561)
		wait(1500)
		setWalkerEnabled(true)
	elseif (Label == "OpenBag") then
		setWalkerEnabled(false)
		wait(1500)
		Self.OpenMainBackpack()
		wait(600,1200)
		Self.DropItems(Self.Position().x, Self.Position().y, Self.Position().z, 2853)
		Self.UseItem(3585)
		wait(1500,2000)
		setWalkerEnabled(true)
	elseif (Label == "OpenBp") then
		setWalkerEnabled(false)
		wait(1000)
		Container.GetFirst():OpenChildren(2854)
		wait(1500,2000)
		setWalkerEnabled(true)
	elseif (Label == "depositGold") then
		setWalkerEnabled(false)
		wait(1000)
		Self.SayToNpc({"hi", "deposit all", "yes"}, 65) -- deposit gold
		wait(1000,2000)
		if (Self.ItemCount(3031) > 100) then
			local getPlat = math.floor(Self.ItemCount(3031)/100)
			print("Getting " .. getPlat .. " Platinum Coins.")
			Self.SayToNpc({"change gold", "" .. getPlat, "yes"}, 65) -- get platinum coins
		end
		wait(2000)
		gotoLabel(Vocation)
		setWalkerEnabled(true)
	elseif (Label == "GetVOC") then
		setWalkerEnabled(false)
		wait(1000)
		Self.SayToNpc({"hi", Vocation, Vocation, "yes", "yes"}, 65)
		setWalkerEnabled(true)
	elseif (Label == "GetWPN") then
		setWalkerEnabled(false)
		Self.Equip(3409, "shield", 1)
		wait(1000,2000)
		Self.Equip(3375, "head", 1)
		wait(1000,2000)
		Self.DropItems(Self.Position().x, Self.Position().y, Self.Position().z, 3426)
		Self.DropItems(Self.Position().x, Self.Position().y, Self.Position().z, 3355)
		wait(1000)
		Self.SayToNpc({"hi", "choice", KnightWPN, "yes"}, 65)
		wait(1500,2000)
		Self.Equip(Item.GetID(KnightWPN), "weapon", 1)
		wait(1000,2000)
		Self.DropItems(Self.Position().x, Self.Position().y, Self.Position().z, Item.GetID(weaponType))
		wait(1500)
		setWalkerEnabled(true)
	elseif (Label == "travelMain") then
		setWalkerEnabled(false)
		wait(1000)
		Self.SayToNpc({"hi", "travel", Town, "yes"}, 65)
		wait(4000)
		print("Thank you for using\nInfernal Bolt's Rook 100% AFK Script\nCavebot, Targeting and Looter = OFF")
		if playAlarm then
			alert()
		end
		setLooterEnabled(false) 
		setTargetingEnabled(false)
		wait(3000)
		if CloseClient then
			os.exit()
		end
	elseif (Label == "botOff") then
		setWalkerEnabled(false) 
		if not GoMain then
			print("Thank you for using\nInfernal Bolt's Rook 100% AFK Script\nCavebot, Targeting and Looter = OFF")
			if playAlarm then
				alert()
			end
			setLooterEnabled(false) 
			setTargetingEnabled(false)
			wait(3000)
			if CloseClient then
				os.exit()
			end
		else
			print("Going to Isle of Destiny.")
			setWalkerEnabled(true)
		end
	end
end

Module.New('Drop Food',function(module)
	if (Self.Level() > 2 and Self.ItemCount("meat", 0) > 5) then
		local getMeatCount = (Self.ItemCount("meat", 0)-5)
		Self.DropItem(Self.Position().x,Self.Position().y,Self.Position().z,"meat", getMeatCount)
	end
	module:Delay(12000,26000)
end)

Module.New('Eat Food', function(module)
	if (Self.Level() > 2 and Self.ItemCount("meat", 0) > 0) then
		Self.UseItem(3577)
	end
	module:Delay(37000,56000)
end)

Module.New('Health Checker', function(module)
	local hppc = math.ceil((Self.Health() / Self.MaxHealth()) * 100)
	if (Self.Level() > 3 and hppc < 50) then
		print("Health Low, waiting for regeneration.")
		Walker.Delay(15000)
		module:Delay(14000)
	end
end)