-- Global scoping --
print("Initializing")
mod = RegisterMod("Penitence Cat Pack", 1)
game = Game()
MIN_TEAR_DELAY = 5

--================================--
math.random(100) -- throw away first random roll


-- CALLBACK DEFINING --
mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.onUpdate)
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.onCacheUpdate)
mod:AddCallback(ModCallbacks.MC_INPUT_ACTION, mod.onInput)
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG , mod.onDamage)

