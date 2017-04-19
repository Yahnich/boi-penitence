-- Global scoping --
print("Initializing")
mod = RegisterMod("Penitence Item Pack", 1)
game = Game()
MIN_TEAR_DELAY = 5

--================================--
math.random(100) -- throw away first random roll

-- COLLECTIBLE ID SCOPING --
CollectibleType.COLLECTIBLE_LUCIFER = Isaac.GetItemIdByName("Lucifer")
CollectibleType.COLLECTIBLE_SMITE = Isaac.GetItemIdByName("Smite")
CollectibleType.COLLECTIBLE_DEVOTION = Isaac.GetItemIdByName("Devotion")
CollectibleType.COLLECTIBLE_ATLATL = Isaac.GetItemIdByName("Atlatl")
CollectibleType.COLLECTIBLE_IRON_MAN = Isaac.GetItemIdByName("Iron Man")
CollectibleType.COLLECTIBLE_SPIKED_WHIP = Isaac.GetItemIdByName("Spiked Whip")

-- COSTUME SCOPING --
local CostumeIds = {}
CostumeIds.COSTUME_LUCIFER = Isaac.GetCostumeIdByPath("gfx/characters/666_lucifer.anm2")


-- ITEM STATS INIT --
local COLLECTIBLE_LUCIFER_STATS = {
	MaxFireDelay = -2,
	MoveSpeed = 0.2,
	TearFlags = 1<<37, -- Holy Light
	BaseChance = 5,
	LuckChance = 1,
}

local COLLECTIBLE_SMITE_STATS = {
	MaxFireDelay = 20,
	maxColorRO = 0.8,
	maxColorGO = 0.8,
	maxColorBO = 0.2,
	maxCharge = 120,
	laserDuration = 30,
}

local COLLECTIBLE_DEVOTION_STATS = {
	MoveSpeed = -0.15,
	heartLuckCap = 10,
	heartBaseChance = 50,
	bigHeartBaseChance = 25,
	smallPayout = 1,
	bigPayout = 2,
}

local COLLECTIBLE_ATLATL_STATS = {
	ShotSpeedMultiplier = 0.6
}

-- UTILITY FUNCTIONS --
local function RollPercentage(int)
	if math.random(100) < int then
		return true
	end
	return false
end

function CalculateNewTears(bonus, player)
	local tearCapPreRed = 0
	local minRate = MIN_TEAR_DELAY
	for item, reduction in pairs(tearCapMultTable) do
		if player:HasCollectible(CollectibleType.item) then
			tearCapPreRed = tearCapPreRed + reduction
		end
	end
	minRate = math.min(1, minRate - tearCapPreRed)
	local multiplier = 
	if player:HasCollectible(CollectibleType.COLLECTIBLE_BRIMSTONE) then
		minRate = minRate * 3
		multiplier = multiplier * 3
	elseif player:HasCollectible(CollectibleType.COLLECTIBLE_DR_FETUS) then
		minRate = minRate * 2
	elseif player:HasCollectible(CollectibleType.COLLECTIBLE_MONSTROS_LUNG) or player:HasCollectible(CollectibleType.IPECAC) then
		minRate = minRate * 2
	end
	if player:HasCollectible(CollectibleType.COLLECTIBLE_BRIMSTONE) 
	or player:HasCollectible(CollectibleType.COLLECTIBLE_BRIMSTONE) 
	or player:HasCollectible(CollectibleType.COLLECTIBLE_BRIMSTONE) then
		minRate = minRate * 2
	end
	if player:HasCollectible(CollectibleType.COLLECTIBLE_SOY_MILK) then
		minRate = math.min(1, minRate / 4)
	end
	if player:HasCollectible(CollectibleType.COLLECTIBLE_EVES_MASCARA) then
		minRate = math.min(1, minRate / 4)
	end
	if player:HasCollectible(CollectibleType.COLLECTIBLE_MONSTROS_LUNG) or player:HasCollectible(CollectibleType.COLLECTIBLE_IPECAC) then
		minRate = math.min(1, minRate / 4)
	end
	if player:HasCollectible(CollectibleType.COLLECTIBLE_SOY_MILK) then
		minRate = math.min(1, minRate - 2)
	end
	if player.MaxFireDelay > minRate then
		return math.min( player.MaxFireDelay - minRate, bonus )
	else
		return 0
	end
end

local tearCapPreMultRedTable = {
	COLLECTIBLE_ANTI_GRAVITY = -2
	TRINKET_CANCER = -2
	COLLECTIBLE_CAPRICORN = -1
	TRINKET_CRACKED_CROWN = -1
	COLLECTIBLE_CRICKETS_BODY = -1
	COLLECTIBLE_GUILLOTINE = -1
	COLLECTIBLE_MOMS_PERFUME = -1
	COLLECTIBLE_PISCES = -1
}


-- CUSTOM ITEM SETUP --
local collectedItems = {}
local customIDs = {
	COLLECTIBLE_LUCIFER = CollectibleType.COLLECTIBLE_LUCIFER,
	COLLECTIBLE_SMITE = CollectibleType.COLLECTIBLE_SMITE,
	COLLECTIBLE_DEVOTION = CollectibleType.COLLECTIBLE_DEVOTION,
	COLLECTIBLE_ATLATL = CollectibleType.COLLECTIBLE_ATLATL,
}

SynergyColours = {
	["COLLECTIBLE_SPOON_BENDER"] = Color(0.85,0,0.85,1,0,0,0),
	["COLLECTIBLE_NUMBER_ONE"] = Color(0.85,0.85,0,1,0,0,0),
	["COLLECTIBLE_BLOOD_MARTYR"] = Color(1,0,0,1,0,0,0),
	["COLLECTIBLE_PENTAGRAM"] = Color(1,0,0,1,0,0,0),
	["COLLECTIBLE_PACT"] = Color(1,0,0,1,0,0,0),
	["COLLECTIBLE_MARK"] = Color(1,0,0,1,0,0,0),
	["COLLECTIBLE_SMALL_ROCK"] = Color(1,0,0,1,0,0,0),
	["COLLECTIBLE_MOMS_KNIFE"] = Color(0.5,0.5,0.5,1,0,0,0),
	["COLLECTIBLE_OUIJA_BOARD"] = Color(0.5,0.5,0.5,1,0,0,0),
	["COLLECTIBLE_TOOTH_PICKS"] = Color(1,0,0,1,0,0,0),
	["COLLECTIBLE_DEAD_ONION"] = Color(0.6,0.3,0,1,0,0,0),
	["COLLECTIBLE_IPECAC"] = Color(0.1,0.7,0,1,0,0,0),
	["COLLECTIBLE_MYSTERIOUS_LIQUID"] = Color(0.1,0.7,0,1,0,0,0),
	["COLLECTIBLE_SCORPIO"] = Color(0.1,0.7,0,1,0,0,0),
	["COLLECTIBLE_SERPENTS_KISS"] = Color(0.1,0.7,0,1,0,0,0),
}

TearFlags = {
	FLAG_NO_EFFECT = 0,
	FLAG_SPECTRAL = 1,
	FLAG_PIERCING = 1<<1,
	FLAG_HOMING = 1<<2,
	FLAG_SLOWING = 1<<3,
	FLAG_POISONING = 1<<4,
	FLAG_FREEZING = 1<<5,
	FLAG_COAL = 1<<6,
	FLAG_PARASITE = 1<<7,
	FLAG_MAGIC_MIRROR = 1<<8,
	FLAG_POLYPHEMUS = 1<<9,
	FLAG_WIGGLE_WORM = 1<<10,
	FLAG_UNK1 = 1<<11, --No noticeable effect
	FLAG_IPECAC = 1<<12,
	FLAG_CHARMING = 1<<13,
	FLAG_CONFUSING = 1<<14,
	FLAG_ENEMIES_DROP_HEARTS = 1<<15,
	FLAG_TINY_PLANET = 1<<16,
	FLAG_ANTI_GRAVITY = 1<<17,
	FLAG_CRICKETS_BODY = 1<<18,
	FLAG_RUBBER_CEMENT = 1<<19,
	FLAG_FEAR = 1<<20,
	FLAG_PROPTOSIS = 1<<21,
	FLAG_FIRE = 1<<22,
	FLAG_STRANGE_ATTRACTOR = 1<<23,
	FLAG_UNK2 = 1<<24, --Possible worm?
	FLAG_PULSE_WORM = 1<<25,
	FLAG_RING_WORM = 1<<26,
	FLAG_FLAT_WORM = 1<<27,
	FLAG_UNK3 = 1<<28, --Possible worm?
	FLAG_UNK4 = 1<<29, --Possible worm?
	FLAG_UNK5 = 1<<30, --Possible worm?
	FLAG_HOOK_WORM = 1<<31,
	FLAG_GODHEAD = 1<<32,
	FLAG_UNK6 = 1<<33, --No noticeable effect
	FLAG_UNK7 = 1<<34, --No noticeable effect
	FLAG_EXPLOSIVO = 1<<35,
	FLAG_CONTINUUM = 1<<36,
	FLAG_HOLY_LIGHT = 1<<37,
	FLAG_KEEPER_HEAD = 1<<38,
	FLAG_ENEMIES_DROP_BLACK_HEARTS = 1<<39,
	FLAG_ENEMIES_DROP_BLACK_HEARTS2 = 1<<40,
	FLAG_GODS_FLESH = 1<<41,
	FLAG_UNK8 = 1<<42, --No noticeable effect
	FLAG_TOXIC_LIQUID = 1<<43,
	FLAG_OUROBOROS_WORM = 1<<44,
	FLAG_GLAUCOMA = 1<<45,
	FLAG_BOOGERS = 1<<46,
	FLAG_PARASITOID = 1<<47,
	FLAG_UNK9 = 1<<48, --No noticeable effect
	FLAG_SPLIT = 1<<49,
	FLAG_DEADSHOT = 1<<50,
	FLAG_MIDAS = 1<<51,
	FLAG_EUTHANASIA = 1<<52,
	FLAG_JACOBS_LADDER = 1<<53,
	FLAG_LITTLE_HORN = 1<<54,
	FLAG_GHOST_PEPPER = 1<<55
}

LaserFlags = { 
	LASER_BRIMSTONE = 1,
	LASER_TECH = 2,
	LASER_SHOOP = 3,
	LASER_PRIDE = 4,
	LASER_HOLY = 5,
	LASER_MEGA = 6,
	LASER_TRACTOR = 7,
}

local function FindSynergyColour(player)
	local r
	local g
	local b
	for collectibleType, collectibleID in pairs(CollectibleType) do
		if player:HasCollectible(collectibleID) and SynergyColours[collectibleType] then
			r = r or SynergyColours[collectibleType].R
			g = g or SynergyColours[collectibleType].G
			b = b or SynergyColours[collectibleType].B
			r = (r + SynergyColours[collectibleType].R) / 2
			g = (g + SynergyColours[collectibleType].G) / 2
			b = (b + SynergyColours[collectibleType].B) / 2
		end
	end
	r = r or 1
	g = g or 1
	b = b or 1
	return Color(r,g,b,1,0,0,0)
end

local function GetEffectiveRange(player)
	return math.abs(player.TearHeight * player.ShotSpeed)
end

local function PlaySoundFromDummy(soundEffect, volume)
	local sound_entity = Isaac.Spawn(EntityType.ENTITY_FLY, 0, 0, Vector(320,300), Vector(0,0), nil):ToNPC()
	sound_entity:PlaySound(soundEffect, volume/100, 0, false, 1)
	sound_entity:Remove()
end

function ItemHandling(player)
	local playerData = player:GetData()
	if player:HasCollectible(CollectibleType.COLLECTIBLE_SMITE) then
		player.FireDelay = player.MaxFireDelay
		playerData.smiteChargeUp = playerData.smiteChargeUp or 0
		playerData.laserProgress = playerData.laserProgress or COLLECTIBLE_SMITE_STATS.laserDuration
		if (Input.IsActionPressed(ButtonAction.ACTION_SHOOTLEFT, player.ControllerIndex)
		or Input.IsActionPressed(ButtonAction.ACTION_SHOOTRIGHT, player.ControllerIndex)
		or Input.IsActionPressed(ButtonAction.ACTION_SHOOTUP, player.ControllerIndex)
		or Input.IsActionPressed(ButtonAction.ACTION_SHOOTDOWN, player.ControllerIndex))
		and playerData.smiteChargeUp < COLLECTIBLE_SMITE_STATS.maxCharge and playerData.laserProgress >= COLLECTIBLE_SMITE_STATS.laserDuration then
			playerData.smiteChargeUp = math.min(COLLECTIBLE_SMITE_STATS.maxCharge, playerData.smiteChargeUp + COLLECTIBLE_SMITE_STATS.maxCharge / player.MaxFireDelay)
			local colOffset = math.ceil(255 * playerData.smiteChargeUp / COLLECTIBLE_SMITE_STATS.maxCharge )
			player:SetColor(Color(1, 1, 1, 1, math.ceil(colOffset*COLLECTIBLE_SMITE_STATS.maxColorRO), math.ceil(colOffset*COLLECTIBLE_SMITE_STATS.maxColorGO), math.ceil(colOffset*COLLECTIBLE_SMITE_STATS.maxColorBO)), 1, 1, true, false)
		elseif game:GetRoom():GetFrameCount() > 1 then
			if playerData.smiteChargeUp >= COLLECTIBLE_SMITE_STATS.maxCharge then
				playerData.laserProgress = 0
				local smiteLaser = player:SpawnMawOfVoid(COLLECTIBLE_SMITE_STATS.laserDuration)
				smiteLaser:SetBlackHpDropChance(0)
				smiteLaser.TearFlags = player.TearFlags
				playerData.smiteLaser = smiteLaser
				if player:HasCollectible(CollectibleType.COLLECTIBLE_LUCIFER) then
					if RollPercentage(COLLECTIBLE_LUCIFER_STATS.BaseChance + player.Luck * COLLECTIBLE_LUCIFER_STATS.LuckChance) then
						smiteLaser.TearFlags = smiteLaser.TearFlags | TearFlags.FLAG_HOLY_LIGHT
					end
				end
				spr = smiteLaser:GetSprite() 
				spr:Load("gfx/007.008_light ring.anm2", false)
				spr:Play("LargeRedLaser")
				spr:LoadGraphics()
				smiteLaser.Radius = GetEffectiveRange(player) * 3
				if smiteLaser.Radius > 600 then smiteLaser.Radius = 600 end
				smiteLaser.CollisionDamage = player.Damage
				smiteLaser:SetColor(FindSynergyColour(player), 0, 1, true, false)
				local subSmiteLaser = player:SpawnMawOfVoid(COLLECTIBLE_SMITE_STATS.laserDuration)
				subSmiteLaser:SetBlackHpDropChance(0)
				subSmiteLaser.TearFlags = player.TearFlags
				playerData.subSmiteLaser = subSmiteLaser
				if player:HasCollectible(CollectibleType.COLLECTIBLE_LUCIFER) then
					if RollPercentage(COLLECTIBLE_LUCIFER_STATS.BaseChance + player.Luck * COLLECTIBLE_LUCIFER_STATS.LuckChance) then
						subSmiteLaser.TearFlags = subSmiteLaser.TearFlags | TearFlags.FLAG_HOLY_LIGHT
					end
				end
				spr = subSmiteLaser:GetSprite() 
				spr:Load("gfx/007.008_light ring.anm2", false)
				spr:Play("LargeRedLaser")
				spr:LoadGraphics()
				subSmiteLaser.Radius = GetEffectiveRange(player) * 7
				if smiteLaser.Radius > 900 then smiteLaser.Radius = 900 end
				subSmiteLaser.CollisionDamage = player.Damage * 0.25
				subSmiteLaser:SetColor(FindSynergyColour(player), 0, 1, true, false)
			end
			playerData.laserProgress = math.min(COLLECTIBLE_SMITE_STATS.laserDuration, playerData.laserProgress + 1)
			playerData.smiteChargeUp = 0
		end
	else
		collectedItems.COLLECTIBLE_SMITE = false
	end
	if player:HasCollectible(CollectibleType.COLLECTIBLE_LUCIFER) then
		for _,entity in pairs(Isaac:GetRoomEntities()) do
			if entity.Type == EntityType.ENTITY_TEAR then
				local tearData = entity:GetData()
				local tear = entity:ToTear()
				if not tearData.luciferProc then
					tearData.luciferProc = true
					if RollPercentage(COLLECTIBLE_LUCIFER_STATS.BaseChance + player.Luck * COLLECTIBLE_LUCIFER_STATS.LuckChance) then
						tear.TearFlags = tear.TearFlags | TearFlags.FLAG_HOLY_LIGHT
					end
				end
			elseif entity.Type == EntityType.ENTITY_KNIFE then
				local knifeData = entity:GetData()
				local knife = entity:ToKnife()
				if not knifeData.HolyShotted then
					knife:SetColor(Color(1.0, 1, 1, 1.0, 100.0, 100.0, 200.0), 0, 0, false, false)
					knifeData.HolyShotted = true
				end
				if RollPercentage(COLLECTIBLE_LUCIFER_STATS.BaseChance + player.Luck * COLLECTIBLE_LUCIFER_STATS.LuckChance) then
					knife.TearFlags = knife.TearFlags | TearFlags.FLAG_HOLY_LIGHT
				elseif knife.TearFlags & TearFlags.FLAG_HOLY_LIGHT == TearFlags.FLAG_HOLY_LIGHT then
					knife.TearFlags = knife.TearFlags - TearFlags.FLAG_HOLY_LIGHT
				end
			end
		end
	else
		collectedItems.COLLECTIBLE_LUCIFER = false
	end
	if player:HasCollectible(CollectibleType.COLLECTIBLE_HOLY_LIGHT) then
		for _,entity in pairs(Isaac:GetRoomEntities()) do
			if entity.Type == EntityType.ENTITY_KNIFE then
				local knifeData = entity:GetData()
				local knife = entity:ToKnife()
				if not knifeData.HolyShotted then
					knife:SetColor(Color(1.0, 1, 1, 1.0, 100.0, 100.0, 200.0), 0, 0, false, false)
					knifeData.HolyShotted = true
				end
				if RollPercentage(5 + 45 * (player.Luck / 9) ) then
					knife.TearFlags = knife.TearFlags | TearFlags.FLAG_HOLY_LIGHT
				elseif knife.TearFlags & TearFlags.FLAG_HOLY_LIGHT == TearFlags.FLAG_HOLY_LIGHT then
					knife.TearFlags = knife.TearFlags - TearFlags.FLAG_HOLY_LIGHT
				end
			end
		end
	end
	NewRoomHandling(player)
	NewLevelHandling(player)
end

function NewRoomHandling(player)
	local playerData = player:GetData()
	if playerData.lastRoomVisited ~= game:GetLevel():GetCurrentRoomIndex() then
		playerData.lastRoomVisited = game:GetLevel():GetCurrentRoomIndex()
		if player:HasCollectible(CollectibleType.COLLECTIBLE_DEVOTION) and not game:GetLevel():GetCurrentRoomDesc().Clear then
			if RollPercentage(math.min(100, COLLECTIBLE_DEVOTION_STATS.heartBaseChance + (100 - COLLECTIBLE_DEVOTION_STATS.heartBaseChance) * player.Luck / COLLECTIBLE_DEVOTION_STATS.heartLuckCap)) then
				if RollPercentage(math.min(50, COLLECTIBLE_DEVOTION_STATS.bigHeartBaseChance + (100 - COLLECTIBLE_DEVOTION_STATS.heartBaseChance) * player.Luck / COLLECTIBLE_DEVOTION_STATS.heartLuckCap)) then
					player:AddSoulHearts(COLLECTIBLE_DEVOTION_STATS.bigPayout)
				else
					player:AddSoulHearts(COLLECTIBLE_DEVOTION_STATS.smallPayout)
				end
				PlaySoundFromDummy(SoundEffect.SOUND_HOLY, 65)
			end
		end
	end
end

function NewLevelHandling(player)
	local playerData = player:GetData()
	if playerData.previousLevelStage ~= game:GetLevel():GetStage() then
		playerData.previousLevelStage = game:GetLevel():GetStage()
		if player:HasCollectible(CollectibleType.COLLECTIBLE_DEVOTION) then
			if RollPercentage(math.min(50, COLLECTIBLE_DEVOTION_STATS.bigHeartBaseChance + (100 - COLLECTIBLE_DEVOTION_STATS.heartBaseChance) * player.Luck / COLLECTIBLE_DEVOTION_STATS.heartLuckCap)) then
				player:AddSoulHearts(COLLECTIBLE_DEVOTION_STATS.bigPayout * 2)
			else
				player:AddSoulHearts(COLLECTIBLE_DEVOTION_STATS.bigPayout)
			end
			PlaySoundFromDummy(SoundEffect.SOUND_HOLY, 65)
		end
	end
end

function DevilRoomHandling(player)

end

function mod:onUpdate(player)
	ItemHandling(player)
	DevilRoomHandling(player)
end

function mod:onCacheUpdate(player, cacheFlag)
	local playerData = player:GetData()
	if cacheFlag == CacheFlag.CACHE_FIREDELAY then
		playerData.playerFireDelay = playerData.playerFireDelay or player.MaxFireDelay
		if player:HasCollectible(CollectibleType.COLLECTIBLE_SMITE) and not collectedItems.COLLECTIBLE_SMITE then
			player.MaxFireDelay = playerData.playerFireDelay + COLLECTIBLE_SMITE_STATS.MaxFireDelay
			playerData.playerFireDelay = player.MaxFireDelay
			collectedItems.COLLECTIBLE_SMITE = true
		end
		if player:HasCollectible(CollectibleType.COLLECTIBLE_LUCIFER) and not collectedItems.COLLECTIBLE_LUCIFER then
			player.MaxFireDelay = playerData.playerFireDelay + COLLECTIBLE_LUCIFER_STATS.MaxFireDelay
			playerData.playerFireDelay = player.MaxFireDelay
			if CostumeIds.COSTUME_LUCIFER ~= -1 then	
				player:AddNullCostume(CostumeIds.COSTUME_LUCIFER)
			end
			player:SetColor(Color(1.0, 1, 1, 1.0, 100.0, 100.0, 100.0), 0, 0, false, false) --R/G/B/A/ROFFSET/GOFFSET/BLUEOFFSET; duration; priority; fade;share
			collectedItems.COLLECTIBLE_LUCIFER = true
		end
	end
	if cacheFlag == CacheFlag.CACHE_SPEED then
		if player:HasCollectible(CollectibleType.COLLECTIBLE_LUCIFER) then
			player.MoveSpeed = player.MoveSpeed + COLLECTIBLE_LUCIFER_STATS.MoveSpeed
			collectedItems.COLLECTIBLE_LUCIFER = true
		end
		if player:HasCollectible(CollectibleType.COLLECTIBLE_DEVOTION) then
			player.MoveSpeed = player.MoveSpeed + COLLECTIBLE_DEVOTION_STATS.MoveSpeed
			collectedItems.COLLECTIBLE_DEVOTION = true
		end
	end
	if cacheFlag == CacheFlag.CACHE_DAMAGE then
		if player:HasCollectible(CollectibleType.COLLECTIBLE_ATLATL) then
			playerData.AtlatlBoostedDamage = player.Damage * player.ShotSpeed * COLLECTIBLE_ATLATL_STATS.ShotSpeedMultiplier
			player.Damage = player.Damage + playerData.AtlatlBoostedDamage
			Isaac.DebugString(player.Damage.."1d")
			Isaac.DebugString(playerData.AtlatlBoostedDamage.."2d")
			collectedItems.COLLECTIBLE_ATLATL = true
		end
	end
	if cacheFlag == CacheFlag.CACHE_SHOTSPEED then
		if player:HasCollectible(CollectibleType.COLLECTIBLE_ATLATL) then
			local originalDamage = player.Damage - playerData.AtlatlBoostedDamage
			Isaac.DebugString(player.Damage.."1ss")
			Isaac.DebugString(playerData.AtlatlBoostedDamage.."2ss")
			Isaac.DebugString(originalDamage.."3ss")
			playerData.AtlatlBoostedDamage = originalDamage * player.ShotSpeed * COLLECTIBLE_ATLATL_STATS.ShotSpeedMultiplier
			player.Damage = originalDamage + playerData.AtlatlBoostedDamage
			collectedItems.COLLECTIBLE_ATLATL = true
		end
	end
end

function mod:onInput(entity, hook, action)
	if entity then
		local player = entity:ToPlayer()
		if player and player:HasCollectible(CollectibleType.COLLECTIBLE_SMITE) then
			if action >= ButtonAction.ACTION_SHOOTLEFT and action <= ButtonAction.ACTION_SHOOTDOWN then
				if hook == InputHook.GET_ACTION_VALUE then
					return 0
				else
					return false
				end
			end
		end
	end
end

function mod:onDamage(entity, amt, flag, source, countdown)
	if source.Type == EntityType.ENTITY_PLAYER then
		local player = source.Entity:ToPlayer()
		if player:HasCollectible(CollectibleType.COLLECTIBLE_LUCIFER) and 
		(player:HasCollectible(CollectibleType.COLLECTIBLE_BRIMSTONE) or 
		player:HasCollectible(CollectibleType.COLLECTIBLE_SMITE) or 
		player:HasCollectible(CollectibleType.COLLECTIBLE_TECHNOLOGY_2) or 
		player:HasCollectible(CollectibleType.COLLECTIBLE_TECHNOLOGY) or 
		player:HasCollectible(CollectibleType.COLLECTIBLE_TECH_5) or 
		player:HasCollectible(CollectibleType.COLLECTIBLE_TECH_X) ) then
			if RollPercentage(COLLECTIBLE_LUCIFER_STATS.BaseChance + player.Luck * COLLECTIBLE_LUCIFER_STATS.LuckChance) then
				local beam = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CRACK_THE_SKY, 0, entity.Position + Vector(math.random(5,50), math.random(5,35)), Vector(0,0), player):ToEffect()
				beam.CollisionDamage = player.Damage * 4
			end
		elseif player:HasCollectible(CollectibleType.COLLECTIBLE_HOLY_LIGHT) and 
		(player:HasCollectible(CollectibleType.COLLECTIBLE_BRIMSTONE) or 
		player:HasCollectible(CollectibleType.COLLECTIBLE_SMITE) or 
		player:HasCollectible(CollectibleType.COLLECTIBLE_TECHNOLOGY_2) or 
		player:HasCollectible(CollectibleType.COLLECTIBLE_TECHNOLOGY) or 
		player:HasCollectible(CollectibleType.COLLECTIBLE_TECH_5) or 
		player:HasCollectible(CollectibleType.COLLECTIBLE_TECH_X) ) then
			if RollPercentage(5 + 45 * (player.Luck / 9) ) then
				local beam = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CRACK_THE_SKY, 0, entity.Position + Vector(math.random(5,50), math.random(5,35)), Vector(0,0), player):ToEffect()
				beam.CollisionDamage = player.Damage * 4
			end
		end
	elseif source.Type == EntityType.ENTITY_KNIFE then
		if source.Entity:ToKnife().TearFlags & TearFlags.FLAG_HOLY_LIGHT == TearFlags.FLAG_HOLY_LIGHT then
			local beam = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CRACK_THE_SKY, 0, entity.Position + Vector(math.random(5,50), math.random(5,35)), Vector(0,0), player):ToEffect()
			beam.CollisionDamage = amt * 4
		end
	end
end

-- CALLBACK DEFINING --
mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.onUpdate)
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.onCacheUpdate)
mod:AddCallback(ModCallbacks.MC_INPUT_ACTION, mod.onInput)
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG , mod.onDamage)

