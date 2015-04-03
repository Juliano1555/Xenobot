--      //////////////////////////////////
--      //    ___                   _   //
--      //   / _ \                 (_)  //
--      //  / /_\ \_   ____ _ _ __  _   //
--      //  |  _  \ \ / / _` | '_ \| |  //
--      //  | | | |\ V / (_| | | | | |  //
--      //  \_| |_/ \_/ \__,_|_| |_|_|  //
--      //                              //
--      //////////////////////////////////

---------------------------------------------------------------
------------------------  SETTINGS  ---------------------------
---------------------------------------------------------------

    LevelUp     = true -- Will take screenshot when leveling up
    Death       = true -- Will take screenshot upon death
    Stamina     = false -- Will take screenshot if below 14:00 stamina

---------------------------------------------------------------
-------------  DO NOT CHANGE ANYTHING BELOW  ------------------
---------------------------------------------------------------
level = Self.Level()


while true do
    if (LevelUp) then
        if Self.Level() > level then
            wait(150)
            screenshot(Self.Name() ..  "_level_" .. Self.Level())
            wait(1000)
            level = Self.Level()
        end
    end

    if (Death) then
        if Self.Health() == 0 then
            screenshot(Self.Name() .. "_death_" .. os.date("%H.%M"))
            wait(1000)
            Death = false
        end
    end


    if (Stamina) then
        if Self.Stamina() < 840 then
            screenshot(Self.Name() .. "_LowStamina_" .. os.date("%H.%M"))
            wait(1000)
            Stamina = false
        end
    end

    wait(5000)
end