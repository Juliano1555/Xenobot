--  How to use this:
--  Make a Label Just Outside TP and put a line:
--  crocModule:Start()
-- When exiting the boss Room you should:
-- crocModule:Stop() 
 
function getContainerByIndex(myIndex)
    for index, container in Container.iContainers() do
        if(index == myIndex) then
        return container
        end
    end
    return nil
end
 
local crocModule = Module.New("LootSpidrisBoss", function()
	local position
	local lootItems = {Item.GetID("violet gem"), Item.GetID("carapace shield"), Item.GetID("hive scythe"), Item.GetID("Calopteryx Cape")}  	-- Please modify it to include the Croc Rare Items
	local productItems = {Item.GetID("spidris mandible"), Item.GetID("compund eye"), Item.GetID("small ruby")}
	local goldContainer = getContainerByIndex(1)                                                                        -- 1 Second Backpack
	local cpContainer = getContainerByIndex(2)    	-- 2 Third Backpack
	local prodContainer = getContainerByIndex(3)
	local target = Creature.New(Self.TargetID)                                                                              -- Must create the Creature Object from the current Target
	if target:Name() == "Spidris" then   
                                                                               -- If the Creature Name is "The Snapper" then
		if target:isAlive() then                                                                                                        -- If it's alive...
			position = target:Position()                                                                                                -- Lets save the position so we loot it later
		end
		if not target:isAlive() and position ~= nil then                                                                    -- If there is a position and the Croc died then we can loot it
			Looter.Stop()                                                                                                                          -- Time to loot the snapper
			Self.UseItemFromGround(position.x, position.y, position.z)                                              -- Attempt to open Crocodile Boss Corpse
			wait(300)
			local crocBody = Container.GetLast()                                                                                -- Container object for the just opened Boss Corpse
			for slot, item in crocBody:iItems() do                                                                              -- Iterate all Items in the Croc Body
				if table.contains(lootItems, item.id) then                                                                          -- If the item is in the list then loot it
					crocBody:MoveItemToContainer(slot, cpContainer, cpContainer:ItemCount() - 1)        -- This should loot all rares into your Creature Product Backpcak
				end
				if(item.id == 3031 or item.id == Item.GetID("platinum coin")) then                                                                                            -- If the Item is Gold Coins
					crocBody:MoveItemToContainer(slot, goldContainer, goldContainer:ItemCount() - 1)    -- This should loot all gold Coins into your Gold Backpack
				end
				if table.contains(productItems, item.id) then                                                                          -- If the item is in the list then loot it
					crocBody:MoveItemToContainer(slot, prodContainer, prodContainer:ItemCount() - 1)        -- This should loot all rares into your Creature Product Backpcak
				end
				module:Delay(600)                                                                                                   -- Lets wait 600 MS until we move next item shall we?
			end
			Looter.Start()
			position = nil                                                                                                                  -- We finished looting the Crocodile, lets clear this just to be safe
		end
	end
end, false)