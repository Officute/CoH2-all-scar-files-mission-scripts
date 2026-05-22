print("\tLoading encdata file...")
-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- Hardpoint - Encounters data
-- Designer: Ryan McGechaen
-------------------------------------------------------------------------
-------------------------------------------------------------------------
ENCOUNTERS = {}

-- Similar to the EVENTS file, each of these creates an encounter and returns a reference.
-- Remember to add a simple description for each encounter.
ENCOUNTERS.ai_grab_fuel1 = function(spawnPoint)
	local encData = {
		name = "Grab Fuel",
		spawn = Util_GetPosition(spawnPoint),
		sgroups = {sg_fuelGrabTeam},
--~ 		intent = ENC_INTENT.battleReverseHardpointAttack,
		units = {
			{
				sbp = XP1_NodeDif({BP_GetSquadBlueprint("volksgrenadier_squad_mp"), BP_GetSquadBlueprint("volksgrenadier_squad_mp"), BP_GetSquadBlueprint("panzerfusilier_squad_mp"), BP_GetSquadBlueprint("panzerfusilier_squad_mp"), BP_GetSquadBlueprint("fallschirmjager_squad_mp") }),
				
			},
--~ 			{
--~ 				sbp = XP1_NodeDif({BP_GetSquadBlueprint("volksgrenadier_squad_mp"), BP_GetSquadBlueprint("volksgrenadier_squad_mp"), BP_GetSquadBlueprint("volksgrenadier_squad_mp"), BP_GetSquadBlueprint("assault_pioneer_squad_mp"), BP_GetSquadBlueprint("assault_pioneer_squad_mp") }),
--~ 			},
		},
		onDeath = _pickupGroupDied,
	}
	local enc_newEncounter = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	
	local target = g_dropZone
	
	GOALS.ai_moveToFuel(enc_newEncounter, g_dropZone)
	
	return enc_newEncounter
end

ENCOUNTERS.ai_grab_fuel2 = function(spawnPoint)
	local encData = {
		name = "Grab Fuel",
		spawn = Util_GetPosition(spawnPoint),
		sgroups = {sg_fuelGrabTeam},
--~ 		intent = ENC_INTENT.battleReverseHardpointAttack,
		units = {
			{
				sbp = XP1_NodeDif({BP_GetSquadBlueprint("volksgrenadier_squad_mp"), BP_GetSquadBlueprint("volksgrenadier_squad_mp"), BP_GetSquadBlueprint("panzerfusilier_squad_mp"), BP_GetSquadBlueprint("assault_pioneer_squad_mp"), BP_GetSquadBlueprint("fallschirmjager_squad_mp") }),
			},	
		},
		onDeath = _pickupGroupDied,
	}
	local enc_newEncounter = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	
	local target = g_dropZone
	
	GOALS.ai_moveToFuel(enc_newEncounter, g_dropZone)
	
	return enc_newEncounter
end

ENCOUNTERS.ai_grab_fuel3 = function(spawnPoint)
	local encData = {
		name = "Grab Fuel",
		spawn = Util_GetPosition(spawnPoint),
		sgroups = {sg_fuelGrabTeam},
--~ 		intent = ENC_INTENT.battleReverseHardpointAttack,
		units = {
			{
				sbp = XP1_NodeDif({BP_GetSquadBlueprint("volksgrenadier_squad_mp"), BP_GetSquadBlueprint("panzerfusilier_squad_mp"), BP_GetSquadBlueprint("panzerfusilier_squad_mp"), BP_GetSquadBlueprint("panzerfusilier_squad_mp"), BP_GetSquadBlueprint("panzerfusilier_squad_mp") }),
				
			},
--~ 			{
--~ 				sbp = XP1_NodeDif({BP_GetSquadBlueprint("volksgrenadier_squad_mp"), BP_GetSquadBlueprint("volksgrenadier_squad_mp"), BP_GetSquadBlueprint("assault_pioneer_squad_mp"), BP_GetSquadBlueprint("assault_pioneer_squad_mp"), BP_GetSquadBlueprint("panzerfusilier_squad_mp") }),
--~ 			},
		},
		onDeath = _pickupGroupDied,
	}
	local enc_newEncounter = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	
	local target = g_dropZone
	
	GOALS.ai_moveToFuel(enc_newEncounter, g_dropZone)
	
	return enc_newEncounter
end

ENCOUNTERS.ai_watchtowerPatrol_1 = function(spawnPoint)
	local encData = {
		name = "Watchtower Patrol_1",
		spawn = Util_GetPosition(spawnPoint),
		sgroups = {sg_watchtowerEnemy_1, sg_watchtowerEnemy},
--~ 		intent = ENC_INTENT.battleReverseHardpointAttack,
		units = {
			{
				sbp = Table_GetRandomItem({BP_GetSquadBlueprint("volksgrenadier_squad_mp"), BP_GetSquadBlueprint("panzerfusilier_squad_mp"), BP_GetSquadBlueprint("assault_pioneer_squad_mp")}),
			},
--~ 			{
--~ 				sbp = BP_GetSquadBlueprint("volksgrenadier_squad_mp"),
--~ 			}
		},
		onDeath = nil, -- start off countdown for next spawn?  --_pickupGroupDied,
	}
	local enc_newEncounter = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	
	local target = eg_randomWatchtower
	
	GOALS.ai_watchtowerDefense(enc_newEncounter, eg_randomWatchtower)
	
	return enc_newEncounter
end

ENCOUNTERS.ai_watchtowerPatrol_2 = function(spawnPoint)
	local encData = {
		name = "Watchtower Patrol_2",
		spawn = Util_GetPosition(spawnPoint),
		sgroups = {sg_watchtowerEnemy_2, sg_watchtowerEnemy},
--~ 		intent = ENC_INTENT.battleReverseHardpointAttack,
		units = {
			{
				sbp = BP_GetSquadBlueprint("volksgrenadier_squad_mp"),
			},
			{
				sbp = Table_GetRandomItem({BP_GetSquadBlueprint("volksgrenadier_squad_mp"), BP_GetSquadBlueprint("panzerfusilier_squad_mp"), BP_GetSquadBlueprint("panzerfusilier_squad_mp")}),
			},
		},
		onDeath = nil, -- start off countdown for next spawn?  --_pickupGroupDied,
	}
	local enc_newEncounter = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	
	local target = eg_randomWatchtower
	
	GOALS.ai_watchtowerDefense(enc_newEncounter, eg_randomWatchtower)
	
	return enc_newEncounter
end

ENCOUNTERS.ai_watchtowerPatrol_3 = function(spawnPoint)
	local encData = {
		name = "Watchtower Patrol_3",
		spawn = Util_GetPosition(spawnPoint),
		sgroups = {sg_watchtowerEnemy_3, sg_watchtowerEnemy},
--~ 		intent = ENC_INTENT.battleReverseHardpointAttack,
		units = {
			{
				sbp = BP_GetSquadBlueprint("panzerfusilier_squad_mp"),
			},
			{
				sbp = Table_GetRandomItem({BP_GetSquadBlueprint("assault_pioneer_squad_mp"), BP_GetSquadBlueprint("assault_pioneer_squad_mp"), BP_GetSquadBlueprint("panzerfusilier_squad_mp"), BP_GetSquadBlueprint("panzerfusilier_squad_mp")}),
			},
		},
		onDeath = nil, -- start off countdown for next spawn?  --_pickupGroupDied,
	}
	local enc_newEncounter = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	
	local target = eg_randomWatchtower
	
	GOALS.ai_watchtowerDefense(enc_newEncounter, eg_randomWatchtower)
	
	return enc_newEncounter
end

ENCOUNTERS.ai_watchtowerPatrol_4 = function(spawnPoint)
	local encData = {
		name = "Watchtower Patrol_4",
		spawn = Util_GetPosition(spawnPoint),
		sgroups = {sg_watchtowerEnemy_4, sg_watchtowerEnemy},
--~ 		intent = ENC_INTENT.battleReverseHardpointAttack,
		units = {
			{
				sbp = BP_GetSquadBlueprint("fallschirmjager_squad_mp"),
			},
			{
				sbp = Table_GetRandomItem({BP_GetSquadBlueprint("volksgrenadier_squad_mp"), BP_GetSquadBlueprint("volksgrenadier_squad_mp"), BP_GetSquadBlueprint("panzerfusilier_squad_mp"), BP_GetSquadBlueprint("panzerfusilier_squad_mp") }),
			},
		},
		onDeath = nil, -- start off countdown for next spawn?  --_pickupGroupDied,
	}
	local enc_newEncounter = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	
	local target = eg_randomWatchtower
	
	GOALS.ai_watchtowerDefense(enc_newEncounter, eg_randomWatchtower)
	
	return enc_newEncounter
end

ENCOUNTERS.ai_watchtowerPatrol_5 = function(spawnPoint)
	local encData = {
		name = "Watchtower Patrol_5",
		spawn = Util_GetPosition(spawnPoint),
		sgroups = {sg_watchtowerEnemy_5, sg_watchtowerEnemy},
--~ 		intent = ENC_INTENT.battleReverseHardpointAttack,
		units = {
			{
				sbp = BP_GetSquadBlueprint("fallschirmjager_squad_mp"),
			},
			{
				sbp = Table_GetRandomItem({BP_GetSquadBlueprint("panzerfusilier_squad_mp"), BP_GetSquadBlueprint("panzerfusilier_squad_mp"), BP_GetSquadBlueprint("fallschirmjager_squad_mp") }),
			},
		},
		onDeath = nil, -- start off countdown for next spawn?  --_pickupGroupDied,
	}
	local enc_newEncounter = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	
	local target = eg_randomWatchtower
	
	GOALS.ai_watchtowerDefense(enc_newEncounter, eg_randomWatchtower)
	
	return enc_newEncounter
end


GOALS = {}

-- A goal that will be assigned to multiple encounters throughout the course of a single mission
GOALS.ai_moveToFuel = function(encounter, attackTar)
	local goalData = {
		name = "Move",
		target = attackTar,
		range = 20,
		leashRange = 60,
		tacticControlsList = {
			{
				tacticType = TACTIC_Cover,
				priority = 500,
			},
		},
		onSuccess = Capture_Fuel_Reserves,
	}
	
	encounter:SetGoal(goalData)
end


-- A goal that will be assigned to multiple encounters throughout the course of a single mission
GOALS.ai_watchtowerDefense = function(encounter, defTar)
	local goalData = {
		name = "Move",
		target = defTar,
		attackMove = true,
		range = 20,
		leashRange = 60,
		tacticControlsList = {
			{
				tacticType = TACTIC_Hold,
				priority = 500,
			},
		},
		onSuccess = WatchtowerCheckKickoff,
	}
	
	encounter:SetGoal(goalData)
end