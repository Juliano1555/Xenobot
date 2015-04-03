dofile("lib.lua")
MIN_CAP = 60                                      	----- Cap to leave at
 
--POTIONS
USE_POTIONS = 1										----- Use potions
MANA_NAME = "mana potion"                  			----- Mana Potion name
HP_NAME = "health potion"                 			----- HP Potion name
MANA_MIN = 0                           				----- Mana Potions to leave at
HP_MIN = 0                        					----- HP Potions to leave at
MANA_BUY = 3            							----- Mana Potions to buy
HP_BUY = 0                                  		----- HP Potions to buy
MANA_PRICE = 50                                   	----- Mana Potion price
HP_PRICE = 45                              			----- HP Potion price
 
--BPS
GOLD_BP = "purple backpack"                       	----- BP For gold
BP_AMOUNT = 2										----- For auto BP resetter
 
--MISC
DROP_FLASKS = 1										----- Drop flasks or not
CAP_TO_DROP_FLASKS = 10								----- If cap is lower it will drop flasks
 
--DEPOSITER
ITEMS = {
        {"bear paw", 0},
        {"honeycomb", 0},
        {"wolf paw", 0},
        {"goblin ear", 0},
        {"small stone", 0}
       
}