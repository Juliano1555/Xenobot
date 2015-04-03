if not __ then return print 'You do not need to execute the config.' end

------------------------------------------------------------------------------------------------------------------
-- G E N E R A L                                                                                                 |
------------------------------------------------------------------------------------------------------------------

-- General Setup --
_Player.LevelScreenshot = true				-- Do you want to take a screenshot when you level up? (true/false)
_Player.SkullScreenshot = true				-- Do you want to take a screenshot if you get skulled? (true/false)
_Player.PlayerScreenshot = false			-- Do you want to take a screenshot when a player enters your view while in spawn? (true/false)
_Player.PlayerAlarm = false					-- Do you want to trigger an alarm when a player enters your view while in spawn? (true/false)
_Player.MinimizeMainBP = true				-- Do you want to minimize your main backpack? CAUTION: Move your health/mana bars in-game to as south as possible. (true/false)
_Player.SpeedLooter = 'off'					-- The speed at which the speed looter operates. (off/fast/med/slow)

-- Route Setup --
_Route.mountain = true						-- Whether the character continues through the mountain route. (true/false)
_Route.directMountain = false				-- Whether the character continues directly to the mountain route. (true/false)
_Route.stayMountain = false					-- Whether the character stays through the mountain route. (true/false)
_Route.firstBat = false						-- Whether the character continues to the first mutated bat. (true/false)
_Route.secondBat = false					-- Whether the character continues to the second mutated bat. (true/false)
_Route.thirdBat = false						-- Whether the character continues to the third mutated bat. (true/false)

-- Spawn Setup --
_Spawn.LureAmount = 0						-- The amount of creatures to activate lure mode. (0 to disable)
_Spawn.LureCreatures = "Mutated Human, Mutated Rat"
_Spawn.LureRange = 7						-- The distance around your character to check for creatures.
_Spawn.LureTime = 120						-- The amount of time you have to kill the lured creatures before moving on.
_Spawn.AntiTargetTime = 30					-- The amount of time targeting one specific creature to trigger if-stuck targeting. (0 to disable)
_Spawn.AntiTargetSwitch = 5					-- The amount of time until you return to regular targeting.


------------------------------------------------------------------------------------------------------------------
-- I N V E N T O R Y                                                                                             |
------------------------------------------------------------------------------------------------------------------
-- AUTOMATIC WITHDRAWING IS ENABLED BUT IS NOT REQUIRED TO REFILL.
-- Add supplies, listed in the setup below, to depot backpack #3 to automatically withdraw from the your depot.
-- The script will purchase supplies from NPCs if it fails to withdraw from the depot.

-- IF POTIONS, AMMO OR RUNES INDEPENDENTLY EQUAL MORE THAN 100, YOU WILL NEED TO CARRY A BACKPACK FOR THOSE ITEMS.
-- Example: If you change ammunition from spears to arrows and you increase the max limit to above 100,
-- you will be required to have an ammunition backpack.
-- Example: If runes max count is set to above 100, you will be required to have a rune backpack.

-- AUTOMATIC BACKPACK PRIORITY: Main, Loot, Gold, Potions, Runes, Ammunition.

-- Health Potions Setup --
_Potion.HealthID = 'strong health potion'	-- ID/Name of health potion.
_Potion.HealthCost = 100					-- The price of a single health potion.
_Potion.HealthMin = 10						-- The amount of health potions at which you will leave to go refill. 
_Potion.HealthMax = 20						-- The amount of health potions you want to buy.
_Potion.HealthWithdraw = true				-- Do you want to withdraw health potions from the depot?
_Potion.HealthAlarm = 0						-- The amount of health potions to trigger an alarm. (0 to disable)

-- Mana Potions Setup --
_Potion.ManaID = 'mana potion'				-- ID/Name of mana potion.
_Potion.ManaCost = 50						-- The price of a single mana potion.
_Potion.ManaMin = 30						-- The amount of mana potions at which you will leave to go refill. 
_Potion.ManaMax = 100						-- The amount of mana potions you want to buy.
_Potion.ManaWithdraw = true					-- Do you want to withdraw mana potions from the depot?
_Potion.ManaAlarm = 0						-- The amount of mana potions to trigger an alarm. (0 to disable)

-- Ring Setup --
_Ring.RingEnabled = false					-- Do you want to use rings? (requires a normal ring)
_Ring.RingLimit = 1							-- How many creatures at which you will equip the ring? (0 to disable)
_Ring.RingHealth = 30						-- The health percentage in which you equip the ring? (0 to disable)
_Ring.RingMana = 10							-- The mana percentage in which you equip the ring? (0 to disable)
_Ring.RingID = 'sword ring'					-- ID/Name of a ring.
_Ring.RingMin = 0							-- The amount of rings at which you leave to go refill.
_Ring.RingMax = 3							-- The amount of rings you want to withdraw from the depot.
_Ring.RingAlarm = 0							-- The amount of rings to trigger an alarm. (0 to disable)

-- Amulet Setup --
_Amulet.AmuletEnabled = false				-- Do you want to use amulets? (requires a normal necklace)
_Amulet.AmuletLimit = 10					-- How many creatures at which you will equip the amulet? (0 to disable)
_Amulet.AmuletHealth = 30					-- The health percentage in which you equip the amulet? (0 to disable)
_Amulet.AmuletMana = 10						-- The mana percentage in which you equip the amulet? (0 to disable)
_Amulet.AmuletID = 'prismatic necklace'		-- ID/Name of the amulet.
_Amulet.AmuletMin = 1						-- The amount of amulets at which you leave to go refill.
_Amulet.AmuletMax = 3						-- The amount of amulets you want to withdraw from the depot.
_Amulet.AmuletAlarm = 0						-- The amount of amulets to trigger an alarm. (0 to disable)

-- Food Setup --
_Food.Enabled = true						-- Do you want to buy food? (true/false)
_Food.Min = 10								-- The amount of food at which you refill.
_Food.Max = 50								-- The amount of food you want to buy.


------------------------------------------------------------------------------------------------------------------
-- S U P P O R T                                                                                                 |
------------------------------------------------------------------------------------------------------------------

-- Softboot Equipper
_SoftBoots.Enabled = false					-- Would you like to switch to softboots at a certain mana percent? (true/false)
_SoftBoots.ManaPercent = 30					-- What mana percent to use softboots at.

-- Mana Restorer --
_Mana.RestorePercent = 50					-- Mana percent to restore mana up to while no creatures on-screen. (0 to disable)


------------------------------------------------------------------------------------------------------------------
-- S T A T U S    C H E C K S                                                                                    |
------------------------------------------------------------------------------------------------------------------

-- Capacity Checks --
_Cap.HuntMinimum = 30						-- If capacity goes below this number it will exit spawn. (0 to disable)
_Cap.DropFlasks = true						-- Drop flasks when capacity drops below this number (true/false)
_Cap.DropGold = false						-- Drop gold when capacity drops below this number (true/false)

-- Stamina Check --
_Stamina.Logout	= true						-- Would you like to log when low on stamina? (true/false)
_Stamina.Hours = 16							-- At what stamina level would you like to log out? (in hours)
_Stamina.ServerSave = 0      				-- How many hours before server save would you like to logout? (0 to disable)
_Stamina.TimeLimit = 0						-- The maximum hours to hunt if Logout is enabled (0 to disable)
_Stamina.Trainer = false					-- Would you like to log at the trainer when low on stamina? (true/false)
_Stamina.TrainSkill = 'sword'				-- The skill statue to use: sword, axe, club, spear, magic.


------------------------------------------------------------------------------------------------------------------
-- R U N E / S P E L L    S H O O T E R                                                                          |
------------------------------------------------------------------------------------------------------------------
-- MAKE SURE YOUR CHARACTER CAN CAST THE SPELLS CORRESPONDING TO EACH SECTION PRIOR TO ENABLING.

_Shooter.Utito = false						-- Would you like to use utito tempo? (true/false)
_Shooter.ExoriMin = false					-- Would you like to use exori min? (true/false)
_Shooter.ExoriG = false						-- Would you like to use exori gran? (true/false)
_Shooter.Exori = false						-- Would you like to use exori? (true/false)
_Shooter.Strikes = false					-- Would you like to use exori strike spells? (true/false)


------------------------------------------------------------------------------------------------------------------
-- H U D                                                                                                         |
------------------------------------------------------------------------------------------------------------------
_HUD.ShowIcons = true						-- Whether to show the loot icons in the HUD or not. (true/false)
_HUD.UseOutfitTheme = false					-- Enable to use your player's outfit as the HUD colors. (true/false)
_HUD.LogStatistics = false					-- Logs your statistics in a CSV file. (directory 'XenoBot/SynLog' must exist)