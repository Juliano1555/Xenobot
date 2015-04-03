local RingID = 3052

while true do
    if Self.Ring().id == 0 then
        Self.Equip(RingID, "ring")
    end
    wait(100,6000)
end  