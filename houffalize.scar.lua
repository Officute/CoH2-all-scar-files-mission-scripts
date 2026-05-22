print("\tLoading mission file...")
-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- Challenge: Houffalize
-- Designer: Byron Chow
-------------------------------------------------------------------------
-------------------------------------------------------------------------

import("ScriptSetup.scar") -- <== ### CRITICAL ELEMENT. 
import("XP1.scar")				-- Ardennes Assault functionality

-- [[ Encounter data ]]
import("Houffalize_encounters.scar")
-- [[ Objective files ]]
import("Houffalize_obj_linkUp.scar")
import("Houffalize_obj_pushEnemyOut.scar")



-------------------------------------------------------------------------
-- [[ MISSION SETUP ]]
-------------------------------------------------------------------------
-- Initializes players
function Mission_SetupPlayers()
	
	--For Missions/Challenges:
	player1 = Setup_Player(1, 11073202, "aef", 1)			-- player1 is always the human player		-- LOCDB [11073202] 'US Forces'
	player2 = Setup_Player(2, 11073205, "west_german", 2)	-- player2 is always the AI opponent		-- LOCDB [11073205] 'Oberkommando West'
	player3 = Setup_Player(3, 11079505, "aef", 1)			-- player3 is always the AI ally			-- LOCDB [11079505] '1st Army'

end

-- Defines key mission data and any global values used throughout the mission.
function Mission_SetupVariables()
	print("Initializing mission DATA...")
	
	--TODO: Define mission initialization data. Example in comments on the bottom of this file.
	-- ### CRITICAL ELEMENT. This table contains all the initialization data for the mission.
	g_missionData = {
		useBeginnerHints = false,					-- Wether or not to use the BeginnerHint system
		useEncounterSystem = true,					-- Whether or not to use the Encounter system
		useXP1Difficulty = true,					-- Whether or not this mission uses the XP1 Difficulty system
		missionType = MT_XP1_CHALLENGE,					-- What Mission Type is this mission? MT_
		introNIS = "XP1/Houffalize_Intro",			 	-- Movie filename
		introNISlet = nil,					 		-- NISlet triggered after introNIS
		introNISletSkipped = nil,	 				-- Function called if the introNISlet is skipped
		introSitRep = nil,							-- Movie (string) to play after intro nislet
		endNISlet = nil,							-- NISlet triggered on mission completion
		endNIS = nil,								-- Movie (string) to play on mission completion
		missionSpeechPath = "botb/gameplay",					-- Speech path to cache (string)
		precacheSounds = {							-- Any audio files you want precached (list of strings)
		},
		nisFiles = {								-- .nis files associated with the mission (path string)
		},
		nisInTransitionTime = 0,
		nisOutTransitionTime = 0,
		objectives = {								-- List of PARENT objective tables.
			OBJ_LinkUp,							-- These are the global references to the objective tables defined in the separete files.
			OBJ_PushEnemyOut,							-- These are the global references to the objective tables defined in the separete files.
		},
		atmosphere = nil,							-- Loads an atmosphere for this mission. Useful for battles and mini challenges
		startingUnits = {							-- Units to be spawned for P1 on mission start. Follows same parameters as Encounters.

		},
		secondaryObjectives = {
			{
				obj = SecondaryOBJ_KillVIP,
				data = {
					spawns = {
						{spawn = mkr_secondary_spawn1, ui = mkr_secondary_spawn1},
					},
					goal = nil,
					protectEncounter = ENCOUNTERS.ProtectVIP,
					additionalEncounters = {
					}
				},
				onStart = nil,
			},
			{
				obj = SecondaryOBJ_DestroyTank,
				data = {
					spawns = {
						{
							spawn = mkr_secondary_spawn1,
							ui = mkr_secondary_spawn1,
							
						},
					},
					protectEncounter = ENCOUNTERS.ProtectTank,
					additionalEncounters = {
					}
				},
			},
			{
				obj = SecondaryOBJ_RescueSquads,
				data = {
					spawns = {eg_secondary_building},
					exitOptions = {mkr_e_retreat_secObj},
					failTime = 6*60,
					additionalEncounters = {
					}
				},
				onStart = nil,
			},
--~ 			{
--~ 				obj = SecondaryOBJ_DemolitionMan,
--~ 				data = {
--~ 					target = eg_demolition,
--~ 					additionalEncounters = {
--~ 						ENCOUNTERS.Demolition,
--~ 					},
--~ 				},
--~ 			},
			{
				obj = SecondaryOBJ_CaptureIntel,
				data = {
					locations = {mkr_secObj_captureIntel_01, mkr_secObj_captureIntel_02, mkr_secObj_captureIntel_03},
					number_to_spawn = 2,
					number_to_capture = 2,
					base_area = mkr_secObj_captureIntel_base,
					additionalEncounters = {
						ENCOUNTERS.ProtectVIP,
					},
				},
			},
		},
	}
	
	
	
	--[[GLOBAL VARIABLES]]
	
	g_connectionEstablished = false -- flag for whether or not the VP at the end is owned by the player and connected to the player's base for purposes of victory (counts enemy territory as friendly too, but we need to explicitly link this with the player's base)
	g_player_near_end = false	-- flags whether or not the player is near the final encounter (used to shut off replacing the german defenses)
	flag_both_players_at_end = false -- flags whether or not the player and the ally are at the final encounter (used to shut off replacing the german waves)
	t_artillery = {mkr_artillery_01, mkr_artillery_02, mkr_artillery_03}	-- table of artillery bombardment zones
	
	--[[MAP GROUPS]]
	-- eg_ally_bunker1 
	-- eg_ally_bunker2
	-- eg_ally_bunker3
	-- eg_ally_bunker4
	-- eg_ally_vp
	-- eg_building_left3
	-- eg_building_right2
	-- eg_building_right3
	-- eg_building_right4
	-- eg_enemy_vp
	-- eg_secondary_building
	-- eg_enemy_bridge
	-- eg_demolition
	
	sg_ally_defenses = SGroup_CreateIfNotFound("sg_ally_defenses")
	sg_ally_garrison1 = SGroup_CreateIfNotFound("sg_ally_garrison1")
	sg_ally_garrison2 = SGroup_CreateIfNotFound("sg_ally_garrison2")
	sg_ally_garrison3 = SGroup_CreateIfNotFound("sg_ally_garrison3")
	sg_ally_garrison4 = SGroup_CreateIfNotFound("sg_ally_garrison4")
	sg_ally_wave1 = SGroup_CreateIfNotFound("sg_ally_wave1")
	sg_ally_wave2 = SGroup_CreateIfNotFound("sg_ally_wave2")
	sg_ally_tanks = SGroup_CreateIfNotFound("sg_ally_tanks")
	sg_ally_infantry = SGroup_CreateIfNotFound("sg_ally_infantry")
	
	sg_enemy_defense1 = SGroup_CreateIfNotFound("sg_enemy_defense1")
	sg_enemy_defense2 = SGroup_CreateIfNotFound("sg_enemy_defense2")
	sg_enemy_defense3 = SGroup_CreateIfNotFound("sg_enemy_defense3")
	sg_enemy_defense4 = SGroup_CreateIfNotFound("sg_enemy_defense4")
	sg_pak43 = SGroup_CreateIfNotFound("sg_pak43")
	sg_enemy_wave1 = SGroup_CreateIfNotFound("sg_enemy_wave1")
	sg_enemy_wave2 = SGroup_CreateIfNotFound("sg_enemy_wave2")
	sg_enemy_wave3 = SGroup_CreateIfNotFound("sg_enemy_wave3")
	sg_enemy_wave4 = SGroup_CreateIfNotFound("sg_enemy_wave4")
	sg_enemy_artillery_all = SGroup_CreateIfNotFound("sg_enemy_artillery_all")
	sg_enemy_artillery_01 = SGroup_CreateIfNotFound("sg_enemy_artillery_01")
	sg_enemy_artillery_02 = SGroup_CreateIfNotFound("sg_enemy_artillery_02")
	sg_enemy_tanks = SGroup_CreateIfNotFound("sg_enemy_tanks")
	sg_enemy_counterattack = SGroup_CreateIfNotFound("sg_enemy_counterattack")
	sg_enemy_waves = SGroup_CreateIfNotFound("sg_enemy_waves")
	sg_strong_wave1 = SGroup_CreateIfNotFound("sg_strong_wave1")
	sg_strong_wave2 = SGroup_CreateIfNotFound("sg_strong_wave2")
	sg_strong_wave_all = SGroup_CreateIfNotFound("sg_strong_wave_all")
	sg_enemies_all = SGroup_CreateIfNotFound("sg_enemies_all")	-- group for all enemies
	sg_enemies_final = SGroup_CreateIfNotFound("sg_enemies_final")	-- group for all enemies in the final area (who will be retreated at end of mission)
	
	-- groups for enemy reinforcement waves (secondary objective)
	sg_enemy_reinforcement1 = SGroup_CreateIfNotFound("sg_enemy_reinforcement1")
	sg_enemy_reinforcement2 = SGroup_CreateIfNotFound("sg_enemy_reinforcement2")

	
end

-- Defines difficulty tables/tuning variables
function Mission_SetDifficulty(diffVal)
	--TODO: Define any difficulty-related settings or variables.
	-- These variables should be stored in a t_difficulty table for readability and access.
	
	g_difficulty = diffVal or Game_GetSPDifficulty() 	-- Note: Having the diffVal parameter allows for redefining difficulty settings during runtime.
	AI_OverrideDifficulty(g_difficulty)
	
	--Global difficulty table
	t_difficulty = {
		startManpower = Util_DifVar({500, 400, 300}, g_difficulty),				-- Starting Manpower
		startMunition = Util_DifVar({100, 80, 50}, g_difficulty),				-- Starting Munitions
		startFuel = Util_DifVar({40, 30, 20}, g_difficulty),					-- Starting Fuel
		strongWaveTimer = Util_DifVar({10*60.0, 8*60.0, 7*60.0}, g_difficulty),		-- Time between strong waves that attack the ally
		artilleryModifier = Util_DifVar({1.0, 1.5, 2.0}, g_difficulty),			-- Modify the cooldown on the player's artillery barrage
	}
	
	Player_SetResource(player1, RT_Manpower, t_difficulty.startManpower)
	Player_SetResource(player1, RT_Munition, t_difficulty.startMunition)
	Player_SetResource(player1, RT_Fuel, t_difficulty.startFuel)

	PM_PL_StartingResourceHit = true
	PM_AI_CPDefenses = true
end

-- Sets restrictions on units, teams, etc.
function Mission_SetupRestrictions()
	--TODO: Set any tech/ability restrictions on a players, as well as resource limits.
	--	Note: Resource Income/Caps should be defined in Mission_SetDifficulty()
	
	--[[ HUMAN PLAYER ]]
--~ 	Player_SetEntityProductionAvailability(player1, EBP.SOVIET.IS_2_HEAVY_TANK, ITEM_REMOVED)
	
	--[[ ALLIED PLAYER ]]
	
	--[[ ENEMY PLAYER ]]
	
end

-- Sets up the map before the mission starts (starting units, ownership, etc.)
function Mission_Preset()
	
	-- despawn unused map entyr points that were only there because stupid world builder doesn't let you save without them
	EGroup_DeSpawn(eg_delete_on_startup)
	
	-- spawn enemy encounters
	-- left path
	ENCOUNTERS.startLeftArea1()
	ENCOUNTERS.startLeftArea2()
	ENCOUNTERS.leftArea3()
	ENCOUNTERS.leftArea3b()
	ENCOUNTERS.rightArea3()
	-- right path
	ENCOUNTERS.rightArea1()
	ENCOUNTERS.rightArea2()
	ENCOUNTERS.rightArea2b()
	ENCOUNTERS.rightArea3Infantry()
	-- in the alleys
	g_enc_alley2 = ENCOUNTERS.encounter7()
	g_enc_alley1 = ENCOUNTERS.encounter8()
	-- left hill
	ENCOUNTERS.LeftHill()
	ENCOUNTERS.LeftHillMG()
	-- final area
	ENCOUNTERS.encounter10()
	ENCOUNTERS.centerBuildings()
--~ 	ENCOUNTERS.encounterMortars()
	ENCOUNTERS.encounterFinal()
	ENCOUNTERS.pak43()
	
	g_enc_tanks = ENCOUNTERS.encounterMedArmour()
	
	-- spawn allies
	Util_CreateSquads(player3, sg_ally_garrison1, SBP.AEF.RIFLEMEN_SQUAD_MP, eg_ally_bunker1)
	Util_CreateSquads(player3, sg_ally_garrison2, SBP.AEF.RIFLEMEN_SQUAD_MP, eg_ally_bunker2)
	Util_CreateSquads(player3, sg_ally_garrison3, SBP.AEF.RIFLEMEN_SQUAD_MP, eg_ally_bunker3)
	Util_CreateSquads(player3, sg_ally_garrison4, SBP.AEF.RIFLEMEN_SQUAD_MP, eg_ally_bunker4)
	Util_CreateSquads(player3, {sg_ally_infantry, sg_ally_wave1}, SBP.AEF.RIFLEMEN_SQUAD_MP, mkr_ally_defense1, mkr_enemy_zone, 1, nil, true)
	Util_CreateSquads(player3, {sg_ally_infantry, sg_ally_wave1}, SBP.AEF.RIFLEMEN_SQUAD_MP, mkr_ally_defense2, mkr_enemy_zone, 1, nil, true)
	Util_CreateSquads(player3, {sg_ally_infantry, sg_ally_wave2}, SBP.AEF.RIFLEMEN_SQUAD_MP, mkr_ally_defense3, mkr_enemy_zone, 1, nil, true)
	SGroup_AddGroups(sg_ally_defenses, {sg_ally_garrison1, sg_ally_garrison2, sg_ally_garrison3, sg_ally_garrison4})
	
	-- make the defensive positions tougher
	Modify_ReceivedDamage(sg_ally_defenses, 0.25)
	Modify_ReceivedDamage(eg_ally_bunker1, 0.25)
	Modify_ReceivedDamage(eg_ally_bunker2, 0.25)
	Modify_ReceivedDamage(eg_ally_bunker3, 0.25)
	Modify_ReceivedDamage(eg_ally_bunker4, 0.25)

	
	-- spawn starting enemies fighting the ally
	Util_CreateSquads(player2, sg_enemy_waves, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, mkr_enemy_start_01, mkr_ally_zone, 1, nil, true)
	Util_CreateSquads(player2, sg_enemy_waves, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, mkr_enemy_start_02, mkr_ally_zone, 1, nil, true)
	Util_CreateSquads(player2, sg_enemy_waves, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, mkr_enemy_start_03, mkr_ally_zone, 1, nil, true)
	
	-- spawn enemy defense line
	Util_CreateSquads(player2, {sg_enemy_defense3, sg_enemies_final}, SBP.WEST_GERMAN.MG34_HEAVY_MACHINE_GUN_SQUAD_MP, mkr_enemy_defense3)
	Util_CreateSquads(player2, {sg_enemy_defense2, sg_enemies_final}, SBP.WEST_GERMAN.MG34_HEAVY_MACHINE_GUN_SQUAD_MP, mkr_enemy_defense2)
	Util_CreateSquads(player2, {sg_enemy_defense1, sg_enemies_final}, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, mkr_enemy_defense1)
	SGroup_AddGroups(sg_enemies_all, {sg_enemy_defense1, sg_enemy_defense2, sg_enemy_defense3})
	
	-- spawn raketenwerfer in building
	if g_difficulty ~= GD_EASY and XP1_GetNodeStrength() >= 3 then
		Util_CreateSquads(player2, sg_enemies_final, SBP.WEST_GERMAN.RAKETENWERFER43_88MM_PUPPCHEN_ANTITANK_GUN_SQUAD_MP, eg_building_right4)
	end
	
	-- make the victory point near the end provide supply
	World_SetDesignerSupply(Marker_GetPosition(mkr_enemy_zone), true)
	
	-- set enemy bridge at top of map as invulnerable (because if it is destroyed the mission breaks!)
	EGroup_SetInvulnerable(eg_enemy_bridge, true)
	
	-- increase range of the artillery's bombardment ability
--~ 	Modify_AbilityMaxCastRange(player1, BP_GetAbilityBlueprint("howitzer_105mm_long_range_barrage"), 1.5)
--~ 	Modify_AbilityMaxCastRange(player2, BP_GetAbilityBlueprint("howitzer_105mm_long_range_barrage"), 1.5)
--~ 	Modify_AbilityMaxCastRange(player1, ABILITY.GERMAN.HOWITZER_105MM_BARRAGE_ABILITY, 1.5)
--~ 	Modify_AbilityMaxCastRange(player2, ABILITY.GERMAN.HOWITZER_105MM_BARRAGE_ABILITY, 1.5)

	-- change how often you can use the howitzer ability
	Modify_AbilityRechargeTime(player1, BP_GetAbilityBlueprint("howitzer_105mm_long_range_barrage"), t_difficulty.artilleryModifier)
--~ 	Modify_AbilityRechargeTime(player1, ABILITY.GERMAN.HOWITZER_105MM_BARRAGE_ABILITY, t_difficulty.artilleryModifier)
	
	-- Events
	Event_Proximity(StartSecondaryObjective, {filterlist = LIST.AIRCRAFT, filtertype = FILTER_REMOVE}, player1, mkr_trigger_secondary_objective, nil, ANY)	-- slotted secondary objective
	event_tanks = Event_Proximity(StartTankAttack, {filterlist = LIST.AIRCRAFT, filtertype = FILTER_REMOVE}, player1, mkr_trigger_tanks, nil, ANY)	-- triggers tanks to move forward
	Event_Proximity(LeftSideAmbush, {filterlist = LIST.AIRCRAFT, filtertype = FILTER_REMOVE}, player1, mkr_enc_left3_01, 35.0, ANY)	-- triggers troops in alley to flank on left side
	Event_Proximity(RightSideAmbush, {filterlist = LIST.AIRCRAFT, filtertype = FILTER_REMOVE}, player1, mkr_enc_right2_02, 25.0, ANY)	-- triggers troops in alley to flank on right side
	Event_Proximity(RightUpperAmbush, {filterlist = LIST.AIRCRAFT, filtertype = FILTER_REMOVE}, player1, mkr_enc_right3_02, 25.0, ANY)	-- triggers troops in alley to flank on upper right side
	Event_Proximity(LeftUpperAmbush, {filterlist = LIST.AIRCRAFT, filtertype = FILTER_REMOVE}, player1, mkr_enc9_04, 25.0, ANY)	-- triggers troops in alley to flank on upper left side
	Rule_AddInterval(RespawnTanks, 1)		-- triggers tank ambush if the player somehow manages to start capturing the VP just outside of the trigger for event_tanks
	
	-- Node strength tuning -----------------------------------------------------------------------
	
	-- counterattack at higher node strength
	if XP1_GetNodeStrength() >= 5 then
		Event_Proximity(CounterattackWarning, {filterlist = LIST.AIRCRAFT, filtertype = FILTER_REMOVE}, player1, mkr_trigger_counterattack, nil, ANY)	-- triggers light armour counterattack
	end
	
	-- Pak 43 at higher node strength
	if XP1_GetNodeStrength() >= 3 then
		-- disable Pak43 at gun (later we re-enable it on proximity trigger)
		Modify_WeaponEnabled(sg_pak43, "hardpoint_01", false)
		Event_Proximity(EnablePak43, {filterlist = LIST.AIRCRAFT, filtertype = FILTER_REMOVE}, player1, mkr_enemy_pak43, nil, ANY)	-- triggers pak43 firing
	end
end



-------------------------------------------------------------------------
-- [[ MISSION START ]]
-------------------------------------------------------------------------
--Called once the intro nis/nislet/sitrep finishes playing.
function Mission_Start()

	-- set ice healing rate (so that the ice doesn't stay permanently destroyed)
	World_SetIceHealingRate(0.01)
	
	-- start main objective
	Objective_Start(OBJ_LinkUp)
	
	Rule_AddInterval(PointConnectionDeterminer, 1) -- start checking to see if the objective requirement for connecting territories is true
	
	-- start allied/enemy wave spawning behaviour (wave after wave of allies fight the germans)
	Rule_AddInterval(AllyWave, 10.0)
	Rule_AddDelayedInterval(EnemyWave, 15.0, 1.0)
	
	-- start checking if the ally is struggling (this handles the warning to the player)
	Rule_AddDelayedInterval(CheckAllyIsLosing, 3*60.0, 10.0)
	-- start timer for strong enemy wave against ally
	Rule_AddOneShot(SpawnStrongWave, t_difficulty.strongWaveTimer)
end


-------------------------------------------------------------------------
-- [[ Functions ]]
-------------------------------------------------------------------------


-- starts the slotted secondary objective when the player enters a trigger
function StartSecondaryObjective()
	Mission_StartSecondaryObjective(true, false)
end

-- The Pak 43 is disabled until the player gets close enough
-- called only once
function EnablePak43()
	Modify_WeaponEnabled(sg_pak43, "hardpoint_01", true)
	Modify_WeaponRange(sg_pak43, "hardpoint_01", 0.7)
	Util_StartIntel(EVENTS.Pak43)
end



-- calculates final mission score
function CalculateMissionScore()
	local game_time = World_GetGameTime()/60.0
	local artillery_captured  = 0
	
	if SyncWeapon_IsOwnedByPlayer(g_artillery_id1, player1) then
		artillery_captured = artillery_captured + 1
	end
	
	if SyncWeapon_IsOwnedByPlayer(g_artillery_id2, player1) then
		artillery_captured = artillery_captured + 1
	end
	
	-- captured both artillery
	if artillery_captured >= 2 then
		XP1_IncrementMissionSuccessLevel(1)
	end
	
	-- finished quickly
	if game_time <= 25 then
		XP1_IncrementMissionSuccessLevel(1) 
	end

end

------------------------------------------------------------------------
-- Encounter behaviour 
------------------------------------------------------------------------

-- gives the tank encounter near the victory point a goal to defend the area
-- triggered by player moving into proximity marker
function StartTankAttack()
	
	if Rule_Exists(RespawnTanks) == true then
		Rule_Remove(RespawnTanks)
	end
	
	if SGroup_IsAlive(sg_enemy_tanks) == false then
		-- respawn tanks if dead
		ENCOUNTERS.RespawnTanks()
	else
	
		local goalData = {
			name = "Defend",
			target = mkr_tank_defend_area,
			range = 30,
			leashRange = 50,
			tacticControlList = {
				{tacticType = TACTIC_Vehicle, priority = 200},
			},
		}
		
		g_enc_tanks:SetGoal(goalData)
	end
	
	Cmd_Move(sg_enemy_tanks, mkr_enc_med_armour_dest)
	-- when the tanks attack, warn the player
	Event_IsEngaged(PlayTankWarning, nil, sg_enemy_tanks, ANY, 10.0)
end


-- plays intel event about tanks
-- triggered by StartTankAttack()
function PlayTankWarning()
	Util_StartIntel(EVENTS.PanzerAttack)
end

-- when player approaches left side, the alley troops move to flank
-- triggered by player moving into proximity marker
function LeftSideAmbush()

	local goalData = {
		name = "Defend",
		target = mkr_enc_left3_01,
		range = 45,
		leashRange = 55,
	}
	
	g_enc_alley1:SetGoal(goalData)
end

-- if player managed to destroy the tank ambush and start capturing the objective point, then respawn the tanks
function RespawnTanks()
	if 	Player_GetStrategicPointCaptureProgress(player1, EGroup_GetSpawnedEntityAt(eg_enemy_vp, 1)) > -1 then

		Event_Remove(event_tanks)	-- removing the original trigger for the tank ambush
		StartTankAttack()
		Rule_RemoveMe()
	end
end



-- when player approaches right side, the alley troops move to flank
-- triggered by player moving into proximity marker
function RightSideAmbush()

	local goalData = {
		name = "Defend",
		target = mkr_enc_right2_02,
		range = 60,
		leashRange = 60,
	}
	
	g_enc_alley1:SetGoal(goalData)
end


-- when player approaches right side, the alley troops move to flank
-- triggered by player moving into proximity marker
function RightUpperAmbush()

	local goalData = {
		name = "Defend",
		target = mkr_enc_right3_02,
		range = 60,
		leashRange = 60,
	}
	
	g_enc_alley2:SetGoal(goalData)
end

-- when player approaches left side, the alley troops move to flank
-- triggered by player moving into proximity marker
function LeftUpperAmbush()

	local goalData = {
		name = "Defend",
		target = mkr_enc9_04,
		range = 60,
		leashRange = 60,
	}
	
	g_enc_alley2:SetGoal(goalData)
end

function CounterattackWarning()
	-- warn the player and spawn encounter
	Util_StartIntel(EVENTS.Counterattack)
	
	Rule_AddOneShot(SpawnCounterattack, 45.0)
end

-- Spawns enemy light armour and picks one of the artillery locations to counterattack
-- triggered by proximity marker
function SpawnCounterattack()

	local goaldata
	
	g_enc_counterattack = ENCOUNTERS.counterattack()
	-- set goal data for encounter
	if SyncWeapon_IsOwnedByPlayer(g_artillery_id1, player1) then
		goalData = {
			name = "Attack",
			target = mkr_enemy_artillery_01,
			range = 30,
			leashRange = 40,
			attackMove = true,
		}
	elseif SyncWeapon_IsOwnedByPlayer(g_artillery_id2, player1) then
		goalData = {
			name = "Attack",
			target = mkr_enemy_artillery_02,
			range = 30,
			leashRange = 40,
			attackMove = true,
		}
	-- check if the first artillery position is in player's supply
	elseif World_IsInSupply(player1, Util_GetPosition(mkr_enemy_artillery_01)) or SGroup_IsAlive(sg_enemy_artillery_01) == false then
		goalData = {
			name = "Attack",
			target = mkr_enemy_artillery_01,
			range = 30,
			leashRange = 40,
			attackMove = true,
		}
	else 
		goalData = {
			name = "Attack",
			target = mkr_enemy_artillery_02,
			range = 30,
			leashRange = 40,
			attackMove = true,
		}
	end
	
	g_enc_counterattack:SetGoal(goalData)
	
	-- show a ping
	UI_CreateMinimapBlip(goalData.target, 20.0, BT_DefendHere)
end



------------------------------------------------------------------------
-- Ally wave behaviour 
------------------------------------------------------------------------

-- checks if the ally needs help and alerts the player
function CheckAllyIsLosing()

	if EGroup_IsCapturedByPlayer(eg_ally_vp, player2, ANY) == false and SGroup_GetAvgHealth(sg_enemy_waves) > 0.5 and SGroup_CountSpawned(sg_enemy_waves) > 1 then
		
		-- if the strong enemy wave is pushing far against the ally, warn the player
		if Prox_AreSquadsNearMarker(sg_strong_wave_all, mkr_neutral_zone, ANY) and SGroup_CountSpawned(sg_strong_wave_all) > 1 then
			Util_StartIntel(EVENTS.HelpAllyStrong)
			Rule_RemoveMe()
			Rule_AddDelayedInterval(CheckAllyIsLosing, 30.0, 10.0)
			Objective_RemoveUIElements(SOBJ_PreventCapture, g_artillery_warning_id)
			g_artillery_warning_id = Objective_AddUIElements(SOBJ_PreventCapture, mkr_artillery_hint_01, false, 11074778, true, 3.0)  -- LOCDB [11074778] 'Use Artillery'
			UI_CreateMinimapBlip(mkr_neutral_zone, 15.0, BT_AttackHere)
		
		-- if the regular enemy wave is pushing far against the ally, warn the player
		elseif Prox_AreSquadsNearMarker(sg_enemy_waves, mkr_warning_02, ANY) then
		
			Util_StartIntel(EVENTS.HelpAlly)
			Rule_RemoveMe()
			Rule_AddDelayedInterval(CheckAllyIsLosing, 40.0, 10.0)
			Objective_RemoveUIElements(SOBJ_PreventCapture, g_artillery_warning_id)
			g_artillery_warning_id = Objective_AddUIElements(SOBJ_PreventCapture, mkr_artillery_hint_02, false, 11074778, true, 3.0) -- LOCDB [11074778] 'Use Artillery'
			UI_CreateMinimapBlip(mkr_artillery_hint_02, 15.0, BT_AttackHere)
			
		
		elseif Prox_AreSquadsNearMarker(sg_enemy_waves, mkr_warning_01, ANY) then
			Util_StartIntel(EVENTS.HelpAlly)
			Rule_RemoveMe()
			Rule_AddDelayedInterval(CheckAllyIsLosing, 40.0, 10.0)
			Objective_RemoveUIElements(SOBJ_PreventCapture, g_artillery_warning_id)
			g_artillery_warning_id = Objective_AddUIElements(SOBJ_PreventCapture, mkr_artillery_hint_01, false, 11074778, true, 3.0) -- LOCDB [11074778] 'Use Artillery'
			UI_CreateMinimapBlip(mkr_artillery_hint_01, 15.0, BT_AttackHere)
			
		else
			Objective_RemoveUIElements(SOBJ_PreventCapture, g_artillery_warning_id)
		end
	end
end


-- spawns more allies if they are dead
function AllyWave()
	
	local wait_time = 8.0	-- squads will pause along each point on their path unless player is near the end
	
	-- if the enemy has captured the point then stop spawning allies
	if EGroup_IsCapturedByPlayer(eg_ally_vp, player2, ANY) == true then
		Rule_RemoveMe()
		
	else
		local number_of_squads = 2
		-- spawn more allies if player has captured the enemy victory point
		if EGroup_IsCapturedByPlayer(eg_enemy_vp, player1, ALL) == true then
			number_of_squads = 3
		end
		
		-- spawn new allies when they're low enough
		if SGroup_GetAvgHealth(sg_ally_infantry) < 0.5 and SGroup_CountSpawned(sg_ally_infantry) < 3 then
			Util_CreateSquads(player3, {sg_ally_infantry, sg_ally_wave1}, SBP.AEF.RIFLEMEN_SQUAD_MP, mkr_ally_spawn, nil, number_of_squads)
			Util_CreateSquads(player3, {sg_ally_infantry, sg_ally_wave2}, SBP.AEF.RIFLEMEN_SQUAD_MP, mkr_ally_spawn, nil, number_of_squads)
			
			-- if we're at the final push
			if g_player_near_end == true then
				
				wait_time = 0	-- squads should just rush along their path instead of pausing
				
				-- respawn tanks if they died
				if SGroup_CountSpawned(sg_ally_tanks) <= 1 then
					Util_CreateSquads(player3, {sg_ally_wave1, sg_ally_tanks}, SBP.AEF.M4A3_SHERMAN_SQUAD_MP, mkr_ally_spawn)
					Util_CreateSquads(player3, {sg_ally_wave2, sg_ally_tanks}, SBP.AEF.M4A3_SHERMAN_SQUAD_MP, mkr_ally_spawn, nil, 2)
				end
			end
			
			-- troops move along paths towards enemy lines
			Cmd_SquadPath(sg_ally_wave1, "path_ally_wave1", true, false, true, wait_time) 
			Cmd_SquadPath(sg_ally_wave2, "path_ally_wave2", true, false, true, wait_time) 
			
		end	
	end
end


------------------------------------------------------------------------
-- Enemy wave behaviour 
------------------------------------------------------------------------


-- spawns more enemies to push against the ally 
-- handles respawning of enemy defenses
function EnemyWave()
	
	-- if the player is near the end, we don't want to reinforce the germans anymore
	if EGroup_IsCapturedByPlayer(eg_enemy_vp, player1, ALL) == false then
		
		if SGroup_GetAvgHealth(sg_enemy_waves) < 0.6 and SGroup_Count(sg_enemy_waves) < 4 then
			Util_CreateSquads(player2, {sg_enemy_wave1, sg_enemy_waves, sg_enemies_final}, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, mkr_enemy_wave_spawn, nil, 1)
			Util_CreateSquads(player2, {sg_enemy_wave2, sg_enemy_waves, sg_enemies_final}, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, mkr_enemy_wave_spawn, nil, 1)
			Util_CreateSquads(player2, {sg_enemy_wave3, sg_enemy_waves, sg_enemies_final}, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, mkr_enemy_wave_spawn, nil, 1)
			Util_CreateSquads(player2, {sg_enemy_wave4, sg_enemy_waves, sg_enemies_final}, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, mkr_enemy_wave_spawn, nil, 1)
			Cmd_SquadPath(sg_enemy_wave1, "path_enemy_wave1", true, false, true, 1.0) 
			Cmd_SquadPath(sg_enemy_wave2, "path_enemy_wave2", true, false, true, 5.0) 
			Cmd_SquadPath(sg_enemy_wave3, "path_enemy_wave3", true, false, true, 5.0) 
			Cmd_SquadPath(sg_enemy_wave4, "path_enemy_wave4", true, false, true, 1.0) 
			
			Rule_RemoveMe()
			Rule_AddDelayedInterval(EnemyWave, 15.0, 5.0)
		end
		

		-- also need to respawn defenses at the german side in the event that the player has killed them too early
		if SGroup_IsAlive(sg_enemy_defense3) == false then
			Util_CreateSquads(player2, {sg_enemy_defense3, sg_enemies_final}, SBP.WEST_GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD_WG_MP, mkr_enemy_wave_spawn, mkr_enemy_defense3, 1, nil, true)
		end
		
		if SGroup_IsAlive(sg_enemy_defense2) == false then
			Util_CreateSquads(player2, {sg_enemy_defense2, sg_enemies_final}, SBP.WEST_GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD_WG_MP, mkr_enemy_wave_spawn, mkr_enemy_defense2, 1, nil, true)
		end
		
		if SGroup_IsAlive(sg_enemy_defense1) == false then
			Util_CreateSquads(player2, {sg_enemy_defense1, sg_enemies_final}, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, mkr_enemy_wave_spawn, mkr_enemy_defense1, 1, nil, true)		
		end
		
	
	-- if the player is on the 2nd objective but the ally and the player haven't yet reached the end zone, keep reinforcing the final defense of the enemy line
	elseif EGroup_IsCapturedByPlayer(eg_enemy_vp, player1, ALL) == true and flag_both_players_at_end == false then
		
		if SGroup_GetAvgHealth(sg_enemy_waves) < 0.7 and SGroup_Count(sg_enemy_waves) <= 2 then
			Util_CreateSquads(player2, {sg_enemy_wave1, sg_enemy_waves, sg_enemies_final}, SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP, mkr_enemy_wave_spawn, nil, 1)
			Util_CreateSquads(player2, {sg_enemy_wave2, sg_enemy_waves, sg_enemies_final}, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, mkr_enemy_wave_spawn, nil, 1)
			Util_CreateSquads(player2, {sg_enemy_wave3, sg_enemy_waves, sg_enemies_final}, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, mkr_enemy_wave_spawn, nil, 1)
			Cmd_SquadPath(sg_enemy_wave1, "path_enemy_wave1", true, false, true, 5.0) 
			Cmd_SquadPath(sg_enemy_wave2, "path_enemy_wave2", true, false, true, 5.0) 
			Cmd_SquadPath(sg_enemy_wave3, "path_enemy_wave3", true, false, true, 5.0) 
			
			Rule_RemoveMe()
			Rule_AddDelayedInterval(EnemyWave, 15.0, 1.0)
		end
		
	elseif flag_both_players_at_end == true then
	
		Rule_RemoveMe()
	end
end


-- handles spawning the occasional strong enemy wave to push against the ally
function SpawnStrongWave()
	
	if g_player_near_end == false then
	
		Util_CreateSquads(player2, {sg_strong_wave1, sg_strong_wave_all, sg_enemies_all, sg_enemies_final}, SBP.WEST_GERMAN.OBERSOLDATEN_SQUAD_MP, mkr_enemy_wave_spawn)
		Util_CreateSquads(player2, {sg_strong_wave2, sg_strong_wave_all, sg_enemies_all, sg_enemies_final}, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP, mkr_enemy_wave_spawn)
		Util_CreateSquads(player2, {sg_strong_wave2, sg_strong_wave_all, sg_enemies_all, sg_enemies_final}, SBP.WEST_GERMAN.OBERSOLDATEN_SQUAD_MP, mkr_enemy_wave_spawn)
		Util_CreateSquads(player2, {sg_strong_wave1, sg_strong_wave_all, sg_enemies_all, sg_enemies_final}, SBP.WEST_GERMAN.PANZER_II_LUCHS_SQUAD_MP, mkr_enemy_wave_spawn)
		Cmd_SquadPath(sg_strong_wave1, "path_enemy_wave3", true, false, true, 15.0) 
		Cmd_SquadPath(sg_strong_wave2, "path_enemy_wave4", true, false, true, 15.0) 
		Rule_AddInterval(CheckStrongWaveRetreat, 1.0)
	else
		Rule_RemoveMe()
	end
end

-- checks to see if the strong wave is hurt bad and retreats them
function CheckStrongWaveRetreat()
	if ( ( SGroup_GetAvgHealth(sg_strong_wave_all) < 0.5 and SGroup_CountSpawned(sg_strong_wave_all) <= 3 ) or SGroup_CountSpawned(sg_strong_wave_all) <= 2 )  then
	
		Cmd_StaggeredRetreat(sg_strong_wave_all, {mkr_enemy_wave_spawn}, 3, true)
		Rule_RemoveMe()
		Rule_AddOneShot(SpawnStrongWave, t_difficulty.strongWaveTimer)
	end
end

-- checks if the ally has pushed far enough in before stopping the spawning of the enemy waves
function DisableEnemyWaves()
	if Prox_ArePlayersNearMarker(player3, mkr_ally_destination, ANY) then
		Rule_RemoveMe()
		flag_both_players_at_end = true
	end
end


------------------------------------------------------------------------
-- Secondary Objective: Enemy artillery behaviour 
------------------------------------------------------------------------

-- grabs the id's of the artillery weapons
-- triggered by the start of SOBJ_DestroyArtillery
function GrabArtilleryID()
	g_artillery_id1 = SyncWeapon_GetFromSGroup(sg_enemy_artillery_01)
	g_artillery_id2 = SyncWeapon_GetFromSGroup(sg_enemy_artillery_02)
end

-- when one of the howitzers is destroyed, this makes the other one invulnerable (so that there's at least one howitzer left on the map)
-- called by SOBJ_DestroyArtillery
function MakeArtilleryInvulnerable()
	if SyncWeapon_Exists(g_artillery_id1) == false and SyncWeapon_Exists(g_artillery_id2) then
		Entity_SetInvulnerable(SyncWeapon_GetEntity(g_artillery_id2), true, 0.0)
		Rule_RemoveMe()
	elseif SyncWeapon_Exists(g_artillery_id2) == false and SyncWeapon_Exists(g_artillery_id1) then
		Entity_SetInvulnerable(SyncWeapon_GetEntity(g_artillery_id1), true, 0.0)
		Rule_RemoveMe()
	end
end

-- check if the player has captured at least one artillery weapon, then starts the enemy strong wave behavior and warnings
-- triggered by start of SOBJ_DestroyArtillery
function CheckPlayerCapturedArtillery()
	if SyncWeapon_IsOwnedByPlayer(g_artillery_id1, player1) or SyncWeapon_IsOwnedByPlayer(g_artillery_id2, player1) then
		
		-- remind player about using artillery to help ally
		Util_StartIntel(EVENTS.CapturedArtillery)
		Rule_AddOneShot(HintArtillery, 20.0)
		
		Rule_RemoveMe()
	end
end


-- Displays a tip reminding player they can use artillery to help ally
-- called only once
function HintArtillery()
	Util_NewHUDFeatureEvent(HUDF_AbilityCard, 11074779, "Icons_abilities_ability_soviet_artillery_barrage", 5.0)	-- LOCDB [11074779] 'You can use artillery to support the 1st Army'
end


-- Handles firing of artillery
-- stops checking when artillery is dead or player has reached the end of the mission
-- called at start of SOBJ_DestroyArtillery
function ArtilleryManager()
	
	-- end manager if artillery is all dead
	if SGroup_IsAlive(sg_enemy_artillery_all) == false or g_player_near_end == true then
		Rule_RemoveMe()
		
	else
		-- if ally is in the artillery marker, the artillery shoots at them
		if Prox_ArePlayersNearMarker(player3, mkr_neutral_zone, ANY) then
		
			local count = World_GetRand(1, SGroup_CountSpawned(sg_enemy_artillery_all))
			local target = mkr_enemy_artillery_01
			
			-- decide on an artillery target
			for i = 1, table.getn(t_artillery) do
				
				if Prox_AreSquadsNearMarker(sg_enemy_waves, t_artillery[i], ANY) == false then
					target = t_artillery[i]
					break
				end
			end
			
			-- decide on which artillery gun will fire
			if count == 1 and SGroup_IsAlive(sg_enemy_artillery_01) and SGroup_HasTeamWeapon(sg_enemy_artillery_01, ANY) then 
				Cmd_Ability(sg_enemy_artillery_01, BP_GetAbilityBlueprint("howitzer_105mm_long_range_barrage"), target)
--~ 				Cmd_Ability(sg_enemy_artillery_01, ABILITY.GERMAN.HOWITZER_105MM_BARRAGE_ABILITY, target)
			elseif SGroup_IsAlive(sg_enemy_artillery_02) and SGroup_HasTeamWeapon(sg_enemy_artillery_02, ANY) then
				Cmd_Ability(sg_enemy_artillery_02, BP_GetAbilityBlueprint("howitzer_105mm_long_range_barrage"), target)
--~ 				Cmd_Ability(sg_enemy_artillery_02, ABILITY.GERMAN.HOWITZER_105MM_BARRAGE_ABILITY, target)
			end
			
			Rule_RemoveMe()
			Rule_AddDelayedInterval(ArtilleryManager, 150.0, 10.0)
		end

	end
end

-- displays a hint point above each artillery unit
-- removes them as each unit dies
-- called at start of SOBJ_DestroyArtillery
function ArtilleryHintpoints()
	
	if SGroup_IsAlive(sg_enemy_artillery_all) == false then
		Rule_RemoveMe()
	else
		if SyncWeapon_IsOwnedByPlayer(g_artillery_id1, player1) or SyncWeapon_Exists(g_artillery_id1) == false then
			Objective_RemoveUIElements(SOBJ_DestroyArtillery, g_artillery_arrow_id1)
		end
		
		if SyncWeapon_IsOwnedByPlayer(g_artillery_id2, player1) or SyncWeapon_Exists(g_artillery_id2) == false then
			Objective_RemoveUIElements(SOBJ_DestroyArtillery, g_artillery_arrow_id2)
		end
	end
end

-- determines if the VP is directly connected to the player base or not
function PointConnectionDeterminer()
	if g_connectionEstablished == false then
	
		if EGroup_IsCapturedByPlayer(eg_connectPoint1, player1, ALL) 
			and (
					(EGroup_IsCapturedByPlayer(eg_connectPoint2, player1, ALL) and EGroup_IsCapturedByPlayer(eg_connectPoint4, player1, ALL)) or
					(EGroup_IsCapturedByPlayer(eg_connectPoint3, player1, ALL) and (EGroup_IsCapturedByPlayer(eg_connectPoint4, player1, ALL) or EGroup_IsCapturedByPlayer(eg_connectPoint5, player1, ALL))) 
				) 
			and EGroup_IsCapturedByPlayer(eg_enemy_vp, player1, ALL) then
			
			g_connectionEstablished = true		
			Rule_RemoveMe()
		end
	end
end