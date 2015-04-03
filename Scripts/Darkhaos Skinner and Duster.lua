local corpses = {
 [5908] = {4173, 4011, 4025, 4047, 4052, 4057, 4062, 4112, 4212, 4321, 4324, 4327, 10352, 10356, 10360, 10364, 10368}, -- Obsidian Knife
 [5942] = {4097, 4137} -- Blessed Wooden Stake
} 

while(true) do
    if (Self.ItemCount(5942) >= 1) and (Self.TargetID() <= 0) then
        for y = -5, 5 do
            for x = -7, 7 do
                if table.contains(corpses[5942], Map.GetTopUseItem(Self.Position().x + x, Self.Position().y + y, Self.Position().z).id) then
                    Walker.Stop()
                    Looter.Stop()
                    Self.UseItemWithGround(5942, Self.Position().x + x, Self.Position().y + y, Self.Position().z)
                    sleep(math.random(2000, 3000))
                    Walker.Start()
                    Looter.Start()
					wait(3000)
                end
            end
        end
    end
    if (Self.ItemCount(5908) >= 1) and (Self.TargetID() <= 0) then
        for y = -5, 5 do
            for x = -7, 7 do
                if table.contains(corpses[5908], Map.GetTopUseItem(Self.Position().x + x, Self.Position().y + y, Self.Position().z).id) then
                    Walker.Stop()
                    Looter.Stop()
                    Self.UseItemWithGround(5908, Self.Position().x + x, Self.Position().y + y, Self.Position().z)
                    sleep(math.random(2000, 3000))
                    Walker.Start()
                    Looter.Start()
					wait(3000)
                end
            end
        end
    end
	wait(1000)
end