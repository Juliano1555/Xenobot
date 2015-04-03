dofile('HealerLib.lua')

local healer = Healer.New()
healer:AddSpell(HealerSpell.New("exura ico", 80, TYPE_HEALTH))
healer:AddItem(HealerItem.New(Item.GetID("ultimate health potion"), 50, TYPE_HEALTH))
healer:AddItem(HealerItem.New(Item.GetID("great health potion"), 60, TYPE_HEALTH))
healer:AddItem(HealerItem.New(Item.GetID("health potion"), 70, TYPE_HEALTH))
healer:AddItem(HealerItem.New(Item.GetID("mana potion"), math.floor(700*100 / Self.MaxMana()), TYPE_MANA))

healer:Delay(300)
healer:Start()