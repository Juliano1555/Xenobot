dofile("lib.lua")
MIN_CAP = 40                                      	----- Cap to leave at
 
--POTIONS
USE_POTIONS = 1										----- Use potions
MANA_NAME = "mana potion"                  			----- Mana Potion name
HP_NAME = "health potion"                 			----- HP Potion name
MANA_MIN = 1                           				----- Mana Potions to leave at
HP_MIN = 0                        					----- HP Potions to leave at
MANA_BUY = 3             							----- Mana Potions to buy
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
        {"damselfly wing", 0},
        {"mana potion", 0},
        {"health potion", 0},
        {"marsh stalker beak", 0},
        {"marsh stalker feather", 0},
        {"swampling moss", 0},
        {"piece of swampling wood", 0},
        {"damselfly eye", 0}
       
}