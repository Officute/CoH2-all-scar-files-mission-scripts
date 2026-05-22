
import("ScriptSetup.scar") -- <== ### CRITICAL ELEMENT. 
import("XP1.scar")				-- Ardennes Assault functionality

-- [[ Objective files ]]
import("Espeler_obj_DestroyHq.scar")
-- [[ Encounter data ]]
import("Espeler_encounters.scar")

-------------------------------------------------------------------------
-- [[ MISSION SETUP ]]
-------------------------------------------------------------------------
-- Initializes players
function Mission_SetupPlayers()
	
	--For Missions/Challenges:
	player1 = Setup_Player(1, 11073202, "aef", 1)		-- player1 is always the human player
	player2 = Setup_Player(2, 11073205, "west_german", 2)		-- player2 is always the AI opponent
	player3 = Setup_Player(3, 11073205, "aef", 1)		-- player3 is always the AI ally

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
		introNIS =  "XP1/Espeler_Intro",			 					-- Movie filename
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
			OBJ_DestroyBases,
		},
		atmosphere = nil,							-- Loads an atmosphere for this mission. Useful for battles and mini challenges
		startingUnits = {							-- Units to be spawned for P1 on mission start. Follows same parameters as Encounters.
		},
		secondaryObjectives = {
			{
				obj = SecondaryOBJ_KillVIP,
				data = {
					spawns = {
						{
							spawn = mkr_secondary_01, 
							ui = mkr_secondary_01,
						},
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
							spawn = mkr_secondary_01,
							ui = mkr_secondary_01,
							
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
					failTime = 6*60,
					additionalEncounters = {},
				},
				onStart = nil,
			},
--~ 			{
--~ 				obj = SecondaryOBJ_DemolitionMan,
--~ 				data = {
--~ 					target = eg_demolition,
--~ 					additionalEncounters = {
--~ 						ENCOUNTERS.ProtectTank,
--~ 					},
--~ 				},
--~ 			},
			{
				obj = SecondaryOBJ_CaptureIntel,
				data = {
					locations = {mkr_secObj_captureIntel_01, mkr_secObj_captureIntel_02, mkr_secObj_captureIntel_03, mkr_secObj_captureIntel_04, mkr_secObj_captureIntel_05},
					number_to_spawn = 2,
					number_to_capture = 2,
					base_area = mkr_secObj_captureIntel_base,
					additionalEncounters = {},
				},
			},
		},
	}
	
	--[[GLOBAL VARIABLES]]
	g_retreating_hq = false	-- flags to see if an hq is retreating
	g_total_hqs_escaped = 0		-- number of hq halftracks that escaped
	g_player_spotted = false	-- flag to check when an IR halftrack spotted the player (used for events)
	g_tank_attacking = false	-- flag to check when the tank is attacking 
	g_patrol_attacking = false	-- flag to check when the patrol is attacking 
	g_halftrack_revealed = false	-- flag to check if a halftrack was revealed to the player (used for events)
	g_artillery_last_warning_time = 0	-- the last time we warned the player not to hit the halftracks with artillery
	g_patrol_last_spawn_time = 0	-- the last time we spawned a patrol when the enemy gets spotted
	g_alert_percent = 0		-- percent of alertness for the enemy, which goes up every time player is spotted. When this is 1.0 it will cause an hq to try to escape.
	g_enc_hq1 = 0	-- encounter ids
	g_enc_hq2 = 0
	g_enc_hq3 = 0
	g_enc_left7 = 0
	g_times_player_spotted = 0	-- number of times the player was spotted by an IR halftrack (used for calculating success rating)
	
	--[[MAP GROUPS]]
	-- eg_church	-- sniper spawn
	-- eg_watchtower	-- sniper spawn
	-- eg_watchtower2	-- sniper spawn
	-- eg_upper_right_building	-- sniper spawn
	-- eg_hmg_church	-- used for an hmg team in graveyard
	-- eg_hmg_building	-- used for an hmg team in building
	-- eg_searchlights	-- spotlights
	-- eg_trench1	-- trench
	-- eg_secondary_building	-- buildingu sed for slotted secondary objective
	
	--[[GROUPS]]
	sg_temp = SGroup_CreateIfNotFound("sg_temp")
	sg_single = SGroup_CreateIfNotFound("sg_single")
	sg_player_units = SGroup_CreateIfNotFound("sg_player_units")	-- group for all player units
	sg_enemies_all = SGroup_CreateIfNotFound("sg_enemies_all")	-- group for all enemies
	sg_halftrack1 = SGroup_CreateIfNotFound("sg_halftrack1")
	sg_halftrack2 = SGroup_CreateIfNotFound("sg_halftrack2")
	sg_halftrack3 = SGroup_CreateIfNotFound("sg_halftrack3")
	sg_halftrack4 = SGroup_CreateIfNotFound("sg_halftrack4")
	sg_halftrack5 = SGroup_CreateIfNotFound("sg_halftrack5")
	sg_halftrack6 = SGroup_CreateIfNotFound("sg_halftrack6")
	sg_halftrack7 = SGroup_CreateIfNotFound("sg_halftrack7")
	sg_halftrack_patrol1 = SGroup_CreateIfNotFound("sg_halftrack_patrol1")
	sg_halftrack_patrol2 = SGroup_CreateIfNotFound("sg_halftrack_patrol2")
	sg_halftracks_all = SGroup_CreateIfNotFound("sg_halftracks_all")	-- all enemy IR halftracks
	sg_enemy_hq1 = SGroup_CreateIfNotFound("sg_enemy_hq1")
	sg_enemy_hq2 = SGroup_CreateIfNotFound("sg_enemy_hq2")
	sg_enemy_hq3 = SGroup_CreateIfNotFound("sg_enemy_hq3")
	sg_enemy_hq_all = SGroup_CreateIfNotFound("sg_enemy_hq_all")	-- all enemy HQ halftracks
	sg_tank = SGroup_CreateIfNotFound("sg_tank")	-- group for patrolling tank
	sg_patrol = SGroup_CreateIfNotFound("sg_patrol")	-- group for patrol that spawns when spotted
	sg_wandering_patrol1 = SGroup_CreateIfNotFound("sg_wandering_patrol1")	-- group for wandering infantry patrol
	sg_wandering_patrol2 = SGroup_CreateIfNotFound("sg_wandering_patrol2")	-- group for wandering infantry patrol
	sg_enemy_flak_all = SGroup_CreateIfNotFound("sg_enemy_flak_all")	-- group for flak halftracks
	sg_enc_left7_reinforcement = SGroup_CreateIfNotFound("sg_enc_left7_reinforcement")	-- group for reinforcing encounter 7
	sg_enc_left7_transport = SGroup_CreateIfNotFound("sg_enc_left7_transport")	-- group for reinforcing encounter 7
	sg_enc_left7 = SGroup_CreateIfNotFound("sg_enc_left7")	-- group for encounter 7
	sg_pak43 = SGroup_CreateIfNotFound("sg_pak43")	-- enemy pak 43
	sg_snipers = SGroup_CreateIfNotFound("sg_snipers")	-- enemy snipers

	-- table of patrol spawn points
	t_patrol_spawns = {
		mkr_patrol_spawn1,
		mkr_patrol_spawn2,
		mkr_patrol_spawn3,
		mkr_patrol_spawn4,
		mkr_patrol_spawn5,
		mkr_patrol_spawn6,
	}
end
	
	-- Defines difficulty tables/tuning variables
function Mission_SetDifficulty(diffVal)
	-- These variables should be stored in a t_difficulty table for readability and access.
	
	g_difficulty = diffVal or Game_GetSPDifficulty() 	-- Note: Having the diffVal parameter allows for redefining difficulty settings during runtime.
	AI_OverrideDifficulty(g_difficulty)
	
	--Global difficulty table
	t_difficulty = {
		startManpower = Util_DifVar({700, 500, 400}, g_difficulty),				-- Starting Manpower
		startMunition = Util_DifVar({100, 80, 50}, g_difficulty),				-- Starting Munitions
		startFuel = Util_DifVar({50, 40, 30}, g_difficulty),					-- Starting Fuel
		alertIncrement = Util_DifVar({0.005, 0.01, 0.015}, g_difficulty)	,		-- how much the alert level increases when an IR halftrack spots the player
		hqRetreatTime = Util_DifVar({6*60.0, 4*60.0, 3*60.0}, g_difficulty),	-- how much time the player has before an hq halftrack retreats
	}
	
	Player_SetResource(player1, RT_Manpower, t_difficulty.startManpower)
	Player_SetResource(player1, RT_Munition, t_difficulty.startMunition)
	Player_SetResource(player1, RT_Fuel, t_difficulty.startFuel)

	PM_PL_StartingResourceHit = true
end
	
-- Sets up the map before the mission starts (starting units, ownership, etc.)
function Mission_Preset()
	
	-- spawn hq halftracks (main objective)
	Util_CreateSquads(player2, {sg_enemy_hq1, sg_enemy_hq_all}, SBP.WEST_GERMAN.SWS_HALFTRACK_SQUAD_MP, mkr_enemy_hq_01)
	Util_CreateSquads(player2, {sg_enemy_hq2, sg_enemy_hq_all}, SBP.WEST_GERMAN.SWS_HALFTRACK_SQUAD_MP, mkr_enemy_hq_02)
	Util_CreateSquads(player2, {sg_enemy_hq3, sg_enemy_hq_all}, SBP.WEST_GERMAN.SWS_HALFTRACK_SQUAD_MP, mkr_enemy_hq_03)
	
	-- Node strength tuning: snipers
	if XP1_GetNodeStrength() >= 4 then
		Util_CreateSquads(player2, sg_snipers, SBP.GERMAN.SNIPER_SQUAD_MP, eg_church)
		Util_CreateSquads(player2, sg_snipers, SBP.GERMAN.SNIPER_SQUAD_MP, eg_upper_right_building)
		Util_CreateSquads(player2, sg_snipers, SBP.GERMAN.SNIPER_SQUAD_MP, eg_watchtower)
		Util_CreateSquads(player2, sg_snipers, SBP.GERMAN.SNIPER_SQUAD_MP, eg_watchtower2)
	end
	
	-- infantry in buildings
	Util_CreateSquads(player2, sg_enemies_all, SBP.WEST_GERMAN.MG34_HEAVY_MACHINE_GUN_SQUAD_MP, eg_hmg_building)
	Util_CreateSquads(player2, sg_enemies_all, SBP.WEST_GERMAN.MG34_HEAVY_MACHINE_GUN_SQUAD_MP, eg_trench1)
	if g_difficulty ~= GD_EASY then
		Util_CreateSquads(player2, sg_enemies_all, SBP.WEST_GERMAN.MG34_HEAVY_MACHINE_GUN_SQUAD_MP, eg_hmg_church)
	else
		Util_CreateSquads(player2, sg_enemies_all, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, eg_hmg_church)
	end
	
	-- spawn enemy encounters
	-- left side
	ENCOUNTERS.LeftArea1()
	ENCOUNTERS.LeftArea2()
	ENCOUNTERS.LeftArea3()
	ENCOUNTERS.LeftArea6()
	g_enc_left7 = ENCOUNTERS.LeftArea7()
	ENCOUNTERS.LeftArea8()
	
	-- middle
	ENCOUNTERS.MidArea1()
	ENCOUNTERS.MidArea2()
	ENCOUNTERS.MidArea3()
	ENCOUNTERS.MidArea4()
	
	-- right side
	ENCOUNTERS.RightArea2()
	ENCOUNTERS.RightArea5()
	ENCOUNTERS.RightArea6()
	ENCOUNTERS.pak43()
	ENCOUNTERS.RightArea7()
	ENCOUNTERS.Vehicles3()
	ENCOUNTERS.Vehicles4()
	
	-- spawn wandering patrols
	ENCOUNTERS.WanderingPatrol1()
	ENCOUNTERS.WanderingPatrol2()

	-- spawn flak halftracks
	SpawnFlakHalftracks()
	-- spawn IR halftracks
	SpawnIR()
	
	-- hq encounters
	g_enc_hq1 = ENCOUNTERS.Hq1()
	g_enc_hq2 = ENCOUNTERS.Hq2()
	g_enc_hq3 = ENCOUNTERS.Hq3()
	
	-- table of enemy hqs
	t_hq_groups = {
		{sgroup = sg_enemy_hq1, encounter = g_enc_hq1},
		{sgroup = sg_enemy_hq2, encounter = g_enc_hq2},
		{sgroup = sg_enemy_hq3, encounter = g_enc_hq3},
	}
	
	-- make the hq territories give supply
	World_SetDesignerSupply(Marker_GetPosition(mkr_enemy_hq_01), true)
	World_SetDesignerSupply(Marker_GetPosition(mkr_enemy_hq_02), true)
	World_SetDesignerSupply(Marker_GetPosition(mkr_enemy_hq_03), true)
	
	-- [ EVENTS ] --------------------------------
	-- despawn hq's if they make it to the retreat point
	Event_Proximity(StartSecondaryObjective, {filterlist = LIST.AIRCRAFT, filtertype = FILTER_REMOVE}, player1, mkr_trig_secondary, nil, ANY)	-- slotted secondary objective
	Event_Proximity(DespawnHQ, {sgroup = sg_enemy_hq1}, sg_enemy_hq1, mkr_hq_retreat_01, 5.0)
	Event_Proximity(DespawnHQ, {sgroup = sg_enemy_hq2}, sg_enemy_hq2, mkr_hq_retreat_01, 5.0)
	Event_Proximity(DespawnHQ, {sgroup = sg_enemy_hq3}, sg_enemy_hq3, mkr_hq_retreat_01, 5.0)
	Event_Proximity(EnablePak43, {filterlist = LIST.AIRCRAFT, filtertype = FILTER_REMOVE}, player1, mkr_enemy_pak43, nil, ANY)	-- triggers pak43 firing
	
	-- when an hq is destroyed, reinforce the others
	Event_GroupIsDead(ReinforceHQ, nil, sg_enemy_hq1)
	Event_GroupIsDead(ReinforceHQ, nil, sg_enemy_hq2)
	Event_GroupIsDead(ReinforceHQ, nil, sg_enemy_hq3)
	
	-- when an hq dies, spawn additional vehicle encounters
	Event_GroupIsDead(SpawnTankEncounter, {sgroup = sg_enemy_hq1}, sg_enemy_hq1)
	Event_GroupIsDead(SpawnTankEncounter, {sgroup = sg_enemy_hq2}, sg_enemy_hq2)
	Event_GroupIsDead(SpawnTankEncounter, {sgroup = sg_enemy_hq3}, sg_enemy_hq3)
	
	-- grant the artillery flare ability to the Germans (so we can use it when you get spotted)
	Player_AddAbility(player2, ABILITY.WEST_GERMAN.FLARE_ARTILLERY)
	
	-- when encounter left 7 (in the middle of the road) gets attacked, spawn reinforcements
--~ 	Event_IsEngaged(ReinforceEncounterLeft7, nil, sg_enc_left7, ANY, 5.0, 10.0)
	
	-- disable Pak43 at gun (later we re-enable it on proximity trigger) and reduce its range
	Modify_WeaponEnabled(sg_pak43, "hardpoint_01", false)
	Modify_WeaponRange(sg_pak43, "hardpoint_01", 0.6)
	
	-- play a warning when player sees a sniper
	if XP1_GetNodeStrength() >= 4 then
		Rule_AddInterval(SniperWarning, 1.0)
	end
end
	

	


-------------------------------------------------------------------------
-- [[ MISSION START ]]
-------------------------------------------------------------------------
--Called once the intro nis/nislet/sitrep finishes playing.
function Mission_Start()

	
--~ 	Cmd_Ability(sg_enemy_hq1, ABILITY.WEST_GERMAN.SUPPORT_TRUCK_TARGET_SETUP, Util_GetPosition(sg_enemy_hq1))
--~ 	Cmd_Ability(sg_enemy_hq2, ABILITY.WEST_GERMAN.SUPPORT_TRUCK_TARGET_SETUP, Util_GetPosition(sg_enemy_hq2))
--~ 	Cmd_Ability(sg_enemy_hq3, ABILITY.WEST_GERMAN.SUPPORT_TRUCK_TARGET_SETUP, Util_GetPosition(sg_enemy_hq3))
	
	-- start objectives
	Objective_Start(OBJ_DestroyBases)
	
	-- start checking if player gets near halftracks to reveal them
	Rule_AddInterval(RevealHalftracks, 2.0)
	Rule_AddInterval(ManageHalftrackSearchlights, 0.25)
	
	-- move patrolling halftracks periodically
	if g_difficulty == GD_HARD then
		Rule_AddInterval(PatrolHalftrack, 4*60.0)
	end
	
	-- check when IR halftracks are under attack by player artillery (to increase alert level)
	Rule_AddInterval(CheckPlayerArtillery, 1.0)
	Rule_AddSGroupEvent(HalftrackDied, sg_halftracks_all, GE_SquadKilled)
	
	-- move wandering patrols
	Cmd_SquadPath(sg_wandering_patrol1, "path_patrol1", true, LOOP_TOGGLE_DIRECTION, true, 0)
	Cmd_SquadPath(sg_wandering_patrol2, "path_patrol2", true, LOOP_TOGGLE_DIRECTION, true, 0)
	
	-- turn on search light fx
	ToggleLights()
end


-------------------------------------------------------------------------
-- [[ Functions ]]
-------------------------------------------------------------------------

-- Utility functions ---------------------------------

-- called at mission preset
-- turns on the search light fx
function ToggleLights()
	
	local _toggleLights = function(gid, id, eid)
		if Entity_IsAlive(eid) then
			Entity_SetAnimatorState(eid, "light", "on")
		end 
	end
	
	if EGroup_IsEmpty(eg_searchlights) == false then
		EGroup_ForEach(eg_searchlights, _toggleLights)
	end
end

-- starts the slotted secondary objective
-- called by proximity trigger
function StartSecondaryObjective()
	Mission_StartSecondaryObjective(true, false)
end


-- The Pak 43 is disabled until the player gets close enough
-- called only once
function EnablePak43()
	Modify_WeaponEnabled(sg_pak43, "hardpoint_01", true)
	Util_StartIntel(EVENTS.Pak43)
end

-- plays a warning the first time the player spots a sniper
function SniperWarning()
	if Player_CanSeeSGroup(player1, sg_snipers, ANY) then
		Rule_RemoveMe()
		Util_StartIntel(EVENTS.SniperSpotted)
	end
end





-- calculates final mission score
function CalculateMissionScore()
	
	-- no hqs escaped
	if g_total_hqs_escaped == 0 then
		XP1_IncrementMissionSuccessLevel(1)
	end
	
	-- all IR halftracks destroyed
	if SGroup_Count(sg_halftracks_all) == 0 then
		XP1_IncrementMissionSuccessLevel(1)
	end

end

-- Flak halftracks ---------------------------

-- spawns flak halftracks and sets them up
-- triggered during mission preset
function SpawnFlakHalftracks()

	-- spawn all of the flak halftracks
	Util_CreateSquads(player2, sg_enemy_flak_all, SBP.WEST_GERMAN.SDKFZ_251_17_FLAK_HALFTRACK_SQUAD_MP, mkr_flak_01)
--~ 	Util_CreateSquads(player2, sg_enemy_flak_all, SBP.WEST_GERMAN.SDKFZ_251_17_FLAK_HALFTRACK_SQUAD_MP, mkr_flak_02)
	Util_CreateSquads(player2, sg_enemy_flak_all, SBP.WEST_GERMAN.SDKFZ_251_17_FLAK_HALFTRACK_SQUAD_MP, mkr_flak_03)
	

end


-- IR Halftracks -----------------------------

-- spawns IR halftracks
-- triggered during mission preset
function SpawnIR()
	
	-- spawn all of the IR halftracks
	Util_CreateSquads(player2, {sg_halftrack1, sg_halftracks_all}, SBP.WEST_GERMAN.SDKFZ_251_20_IR_SEARCHLIGHT_HALFTRACK_SQUAD_SP, mkr_halftrack_01)
	Util_CreateSquads(player2, {sg_halftrack2, sg_halftracks_all}, SBP.WEST_GERMAN.SDKFZ_251_20_IR_SEARCHLIGHT_HALFTRACK_SQUAD_SP, mkr_halftrack_03)
	Util_CreateSquads(player2, {sg_halftrack3, sg_halftracks_all}, SBP.WEST_GERMAN.SDKFZ_251_20_IR_SEARCHLIGHT_HALFTRACK_SQUAD_SP, mkr_halftrack_04)
	Util_CreateSquads(player2, {sg_halftrack4, sg_halftracks_all}, SBP.WEST_GERMAN.SDKFZ_251_20_IR_SEARCHLIGHT_HALFTRACK_SQUAD_SP, mkr_halftrack_06)
	Util_CreateSquads(player2, {sg_halftrack5, sg_halftracks_all}, SBP.WEST_GERMAN.SDKFZ_251_20_IR_SEARCHLIGHT_HALFTRACK_SQUAD_SP, mkr_halftrack_07)
	Util_CreateSquads(player2, {sg_halftrack6, sg_halftracks_all}, SBP.WEST_GERMAN.SDKFZ_251_20_IR_SEARCHLIGHT_HALFTRACK_SQUAD_SP, mkr_halftrack_08)
	Util_CreateSquads(player2, {sg_halftrack7, sg_halftracks_all}, SBP.WEST_GERMAN.SDKFZ_251_20_IR_SEARCHLIGHT_HALFTRACK_SQUAD_SP, mkr_halftrack_10)
	
	-- this table is used to keep track of whether or not we've turned on/off their searchlights
	t_halftrack_searchlight_status = {
		{group = sg_halftrack1},
		{group = sg_halftrack2},
		{group = sg_halftrack3},
		{group = sg_halftrack4},
		{group = sg_halftrack5},
		{group = sg_halftrack6},
		{group = sg_halftrack7},
	}
	
	for index, halftrack in pairs(t_halftrack_searchlight_status) do 
		halftrack.modid_disable = Modify_WeaponEnabled( halftrack.group, "hardpoint_01", false) 
	end
	
	-- patrolling halftracks
	if g_difficulty == GD_HARD then
		Util_CreateSquads(player2, {sg_halftrack_patrol2, sg_halftracks_all}, SBP.WEST_GERMAN.SDKFZ_251_20_IR_SEARCHLIGHT_HALFTRACK_SQUAD_SP, mkr_patrol2_halftrack_01)
	end
	

end



-- Detects when player is spotted by an IR halftrack
-- Triggered by the scar function call on the weapon for the IR halftrack
function SpottedPlayer(halftrack, target)
	
	local alert_increase = t_difficulty.alertIncrement
	
	if Player_OwnsEntity(player1, target) and Objective_IsComplete(OBJ_DestroyBases) == false then
		
		if Entity_IsVehicle(target) then
			alert_increase = alert_increase * 10
		end
		
		if Entity_GetSquad(target) ~= nil then
			
			-- increase the alert level (based on difficulty)
			g_alert_percent = g_alert_percent + alert_increase
			Obj_ShowProgress2(11074845, g_alert_percent)      -- LOCDB [11074845] 'Enemy Alert Level'
			Obj_SetProgressBlinking(true) 
			
			SGroup_Clear(sg_temp)
			local current_time = World_GetGameTime()
			
			if scartype(halftrack) == ST_SQUAD then
				SGroup_Add(sg_temp, halftrack)
			elseif scartype(halftrack) == ST_ENTITY then
				SGroup_Add(sg_temp, Entity_GetSquad(halftrack))
			end
			

			-- send the patrol to attack the position where the player was spotted
			if g_patrol_attacking == false and current_time - g_patrol_last_spawn_time >= 40.0 then
				-- spawn the enemies (if enough time has passed since the last one)
				PatrolManager(target)
				g_patrol_attacking = true
				g_patrol_last_spawn_time = current_time
			
				-- play the artillery flares where the player was spotted
				Cmd_Ability(player2, ABILITY.WEST_GERMAN.FLARE_ARTILLERY, target, nil, true)
			end
			
			-- if alert level is max, time to trigger an hq retreat
			if g_alert_percent  >= 1.0 and g_retreating_hq == false then
				
				-- play warning and flag that an hq is retreating (only one may retreat at a time)
				Util_StartIntel(EVENTS.RetreatHqWarning1)
				g_retreating_hq = true
				
				-- figure out which is the closer hq and select it to retreat
				local group = SGroup_GetClosestHQ(halftrack, t_hq_groups)
				
				if SGroup_IsAlive(group) then
					RetreatHQ(group)

				else
					-- we couldn't figure out which hq is closer so just pick one of them to retreat
					if SGroup_IsAlive(sg_enemy_hq1) then
						RetreatHQ(sg_enemy_hq1)
					elseif SGroup_IsAlive(sg_enemy_hq2) then
						RetreatHQ(sg_enemy_hq2)
					elseif SGroup_IsAlive(sg_enemy_hq3) then
						RetreatHQ(sg_enemy_hq3)
					end
				end
				
			-- if spotted but not at a full alert, play a warning
			elseif g_player_spotted == false and SGroup_IsAlive(sg_patrol) then
				-- play an alert to the player
				g_player_spotted = true
				Util_StartIntel(EVENTS.PlayerSpotted)
				Rule_AddOneShot(ResetPlayerSpottedAlert, 90.0)

			end
		end
	end
end



-- reveals IR halftracks when player gets near them
-- triggered at start of mission
function RevealHalftracks()
	
	if SGroup_Count(sg_halftracks_all) == 0 then
		Rule_RemoveMe()
	else
		-- reveal IR halftracks when player gets close to them
		for i = 1, SGroup_CountSpawned(sg_halftracks_all) do
		
			local halftrack = SGroup_GetSpawnedSquadAt(sg_halftracks_all, i)
			
			-- when player gets near a halftrack, reveal it
			if Prox_ArePlayersNearMarker(player1, Squad_GetPosition(halftrack), ANY, 80.0) then
				
				SGroup_Clear(sg_temp)
				SGroup_Add(sg_temp, halftrack)
--~ 				Modify_WeaponEnabled( sg_temp, "hardpoint_01", true) 
				FOW_RevealSGroupOnly(sg_temp, 2.0)
				
				-- if it's been a while since we last played a warning about the halftracks, play an event
				if g_halftrack_revealed == false then
					g_halftrack_revealed = true
					Util_StartIntel(EVENTS.HalftrackSpotted)
					Rule_AddOneShot(ResetHalftrackWarning, 150.0)

				end
			end
		end
	end
end



-- turns on/off the IR halftrack searchlights when seen by player so that they don't show up in the FOW while hidden
-- called by a rule at mission start
function ManageHalftrackSearchlights()
		
	if SGroup_Count(sg_halftracks_all) == 0 then
		Rule_RemoveMe()
	else
		for index, halftrack in pairs(t_halftrack_searchlight_status) do 
			
			if SGroup_Count(halftrack.group) >= 1 then
				
				if halftrack.modid_disable ~= nil then
					
					if Player_CanSeeSGroup(player1, halftrack.group, ANY) and SGroup_HasCritical(halftrack.group, CRIT.VEHICLE_DESTROY_MAINGUN, ANY) == false then
						
						Modifier_Remove(halftrack.modid_disable)
						halftrack.modid_disable = nil

					end
				
				else
					-- if the player can't see the halftrack, turn off its light
					if Player_CanSeeSGroup(player1, halftrack.group, ANY) == false then
						halftrack.modid_disable = Modify_WeaponEnabled(halftrack.group, "hardpoint_01", false) 
					end
				end
			end
		end
	end
end



-- moves the patrolling halftracks
-- called periodically by a rule
function PatrolHalftrack()
	if SGroup_IsAlive(sg_halftrack_patrol1) == false and SGroup_IsAlive(sg_halftrack_patrol2) == false then
		Rule_RemoveMe()
	else
		local marker1 = nil
		local marker2 = nil
		
		if SGroup_IsAlive(sg_halftrack_patrol1) then
		
			if Prox_AreSquadsNearMarker(sg_halftrack_patrol1, mkr_patrol1_halftrack_01, ALL, 5.0) then
				marker1 = mkr_patrol1_halftrack_02
			else
				marker1 = mkr_patrol1_halftrack_01
			end
			print("MOVING HALFTRACK 1")
			print(Marker_GetName(marker1))
			Cmd_Move(sg_halftrack_patrol1, marker1, false, nil, Util_GetOffsetPosition(marker1, OFFSET_FRONT, 5.0))
		end
		
		if SGroup_IsAlive(sg_halftrack_patrol2) then
		
			if Prox_AreSquadsNearMarker(sg_halftrack_patrol2, mkr_patrol2_halftrack_01, ALL, 5.0) then
				marker2 = mkr_patrol2_halftrack_02
			else
				marker2 = mkr_patrol2_halftrack_01
			end
			print("MOVING HALFTRACK 2")
			print(Marker_GetName(marker2))
			Cmd_Move(sg_halftrack_patrol2, marker2, false, nil, Util_GetOffsetPosition(marker2, OFFSET_FRONT, 5.0))
		end
	end
end






-- check if the player used artillery to hit the halftracks and increase the alert level
-- called by a rule at mission start
function CheckPlayerArtillery()
	
	-- table of artillery units we want to discourage the player from using on IR halftracks
	local t_artillery = {
		SBP.AEF.M8A1_HMC_SQUAD_MP, 
		SBP.AEF.M7B1_PRIEST_SQUAD_MP, 
		SBP.AEF.M1_81MM_MORTAR_SQUAD_MP,
		SBP.AEF.AEF_AIR_SUPPORT_ROCKET,
		SBP.AEF.AEF_AIR_SUPPORT_STRAFE,
		SBP.AEF.AEF_ATTACK_PLANE_SQUAD,
		SBP.AEF.P47_MG_STRAFE,
		SBP.AEF.P47_RECON,
		SBP.AEF.P47_RECON_PLANE_SWEEP,
		SBP.AEF.P47_RECON_TRACKING,
		SBP.AEF.P47_ROCKETS,
		SBP.AEF.P47_ROCKETS_STRAFE,
		SBP.AEF.P47_STRAFES,
		BP_GetSquadBlueprint("aef_air_support_rocket_elite"),
		BP_GetSquadBlueprint("aef_air_support_strafe_elite"),
		BP_GetSquadBlueprint("pm_aef_airborne_paratroopers_plane_paras"),
		SBP.AEF.PM_AEF_AIRBORNE_PARATROOPERS_PLANE_STRAFE,
		SBP.AEF.M1_75MM_PACK_HOWITZER_SQUAD_MP,
	}
	
	if SGroup_Count(sg_halftracks_all) == 0 then
		Rule_RemoveMe()
		
	else
	
		if SGroup_IsUnderAttack(sg_halftracks_all, ANY, 1.0) then
			SGroup_Clear(sg_temp)
			SGroup_GetLastAttacker(sg_halftracks_all, sg_temp, 1.0)

			-- if the player used an artillery unit to hit the halftrack
			if SGroup_IsEmpty(sg_temp) or SGroup_ContainsBlueprints(sg_temp, t_artillery, ANY) then
				IncreaseAlertLevel()
			end
		end
	end

end


function HalftrackDied(victim)

	SGroup_Clear(sg_temp)
--~ 	SGroup_Single(sg_single, victim)
--~ 	SGroup_GetLastAttacker(sg_single, sg_temp, 0.5)
	Squad_GetLastAttacker(victim, sg_temp)
	print("halftrack died")
	
	-- table of artillery units we want to discourage the player from using on IR halftracks
	local t_artillery = {
		SBP.AEF.M8A1_HMC_SQUAD_MP, 
		SBP.AEF.M7B1_PRIEST_SQUAD_MP, 
		SBP.AEF.M1_81MM_MORTAR_SQUAD_MP,
		SBP.AEF.AEF_AIR_SUPPORT_ROCKET,
		SBP.AEF.AEF_AIR_SUPPORT_STRAFE,
		SBP.AEF.AEF_ATTACK_PLANE_SQUAD,
		SBP.AEF.P47_MG_STRAFE,
		SBP.AEF.P47_RECON,
		SBP.AEF.P47_RECON_PLANE_SWEEP,
		SBP.AEF.P47_RECON_TRACKING,
		SBP.AEF.P47_ROCKETS,
		SBP.AEF.P47_ROCKETS_STRAFE,
		SBP.AEF.P47_STRAFES,
		SBP.AEF.PM_AEF_AIRBORNE_PARATROOPERS_PLANE_STRAFE,
		SBP.AEF.M1_75MM_PACK_HOWITZER_SQUAD_MP,
	}
	

	-- if the player used an artillery unit to hit the halftrack
	if SGroup_IsEmpty(sg_temp) or SGroup_ContainsBlueprints(sg_temp, t_artillery, ANY) then
		
		IncreaseAlertLevel()
	end

end


function IncreaseAlertLevel()
	-- if alert level is max, time to trigger an hq retreat
	if g_alert_percent  >= 1.0 and g_retreating_hq == false then
		-- play warning and flag that an hq is retreating (only one may retreat at a time)
		Util_StartIntel(EVENTS.RetreatHqWarning1)
		g_retreating_hq = true
		
	
		-- we couldn't figure out which hq is closer so just pick one of them to retreat
		if SGroup_IsAlive(sg_enemy_hq1) then
			RetreatHQ(sg_enemy_hq1)
		elseif SGroup_IsAlive(sg_enemy_hq2) then
			RetreatHQ(sg_enemy_hq2)
		elseif SGroup_IsAlive(sg_enemy_hq3) then
			RetreatHQ(sg_enemy_hq3)
		end
	
	
	-- increase the alert level
	elseif g_alert_percent < 1.0 then
		g_alert_percent = g_alert_percent + 0.15
		Obj_ShowProgress2(11074845, g_alert_percent)	-- LOCDB [11074845] 'Enemy Alert Level'
	end
	
	
	-- play a warning if enough time has passed since the last warning
	local current_time = World_GetGameTime()
	if current_time - g_artillery_last_warning_time > 20.0 then
		Util_StartIntel(EVENTS.ArtilleryWarning)
		g_artillery_last_warning_time = current_time
	end
end




-- HQ functions -----------------------------------------------------------------------

-- called by SpottedPlayer
-- starts the timer for when an hq will retreat and gives warning to the player
function RetreatHQ(sgroup)
	
	if SGroup_IsAlive(sgroup) then
		Event_Timer(MoveHQ, {hq = sgroup}, t_difficulty.hqRetreatTime)
		Objective_StartTimer(SOBJ_DestroyHqs, COUNT_DOWN, t_difficulty.hqRetreatTime)
		Rule_AddInterval(ResetObjTimer, 1.0)
		-- when the hq dies/despawns reset the alert state and all flags related to hq retreating
		Event_GroupLeftAlive(ResetAlertState, {hq = sgroup}, sgroup, 0)
		Event_Timer(RetreatWarning1, {sgroup = sgroup}, 60.0)
		g_retreat_ping_id = UI_CreateMinimapBlip(sgroup, -1, BT_AttackHere) 
		Event_GroupLeftAlive(EventHandler_RemoveMinimapBlip, {blip = g_retreat_ping_id}, sgroup, 0)
	end
end

-- resets the obejctive timer for hq retreat sequence
-- called by RetreatHQ
function ResetObjTimer()

	if Objective_GetTimerSeconds(SOBJ_DestroyHqs) <= 0 then
		Objective_StopTimer(SOBJ_DestroyHqs)
		Rule_RemoveMe()
	end
end

-- causes an hq to move off map and despawn
-- called by RetreatHQ
function MoveHQ(data)

	local sgroup = data.hq
	
	if SGroup_IsAlive(sgroup) then

		Modify_UnitSpeed(sgroup, 0.5)
		Cmd_Move(sgroup, mkr_hq_retreat_01, true)

		
		-- play warning
		Util_StartIntel(EVENTS.RetreatHqWarning3)
	
	-- otherwise the hq has been destroyed before it could get away	
	
	end

end


-- despawn HQ's when they escape
-- called by a proximity event to the despawn marker
function DespawnHQ(data)

	-- despawn hq, increment the count and reset the alert status
	SGroup_DestroyAllSquads(data.sgroup)
	Util_StartIntel(EVENTS.HqEscaped)
	g_total_hqs_escaped = g_total_hqs_escaped + 1
end

-- plays alerts for when the hq is about to retreat
-- called by RetreatHQ
function RetreatWarning1(data)
	if SGroup_IsAlive(data.sgroup) then
		Util_StartIntel(EVENTS.RetreatHqWarning2)
	end
end

-- resets alert state
-- called by RetreatHQ when an hq escapes (or killed before it can escape)
function ResetAlertState(data)

	local sgroup = data.hq
	
	g_retreating_hq = false
	g_alert_percent = 0
	Objective_StopTimer(SOBJ_DestroyHqs)
	Rule_Remove(ResetObjTimer)
	Obj_ShowProgress2(11074845, g_alert_percent)	-- LOCDB [11074845] 'Enemy Alert Level'
	
	-- remove objective ping
	if SGroup_Compare(sg_enemy_hq1, sgroup) then
		Objective_RemoveUIElements(SOBJ_DestroyHqs, g_hq_arrow_id1)
	elseif SGroup_Compare(sg_enemy_hq2, sgroup) then
		Objective_RemoveUIElements(SOBJ_DestroyHqs, g_hq_arrow_id2)
	elseif SGroup_Compare(sg_enemy_hq3, sgroup) then
		Objective_RemoveUIElements(SOBJ_DestroyHqs, g_hq_arrow_id3)	
	else
		Objective_RemoveUIElements(SOBJ_DestroyHqs, g_hq_arrow_id4)	
	end
end


-- reinforces hq encounters each time an hq is destroyed
-- called by event on death of an hq
function ReinforceHQ()
	
	-- only 1 hq left
	if SGroup_Count(sg_enemy_hq_all) == 1 then
		
		-- for each hq left alive, add units to their encounters
		for i = 1, table.getn(t_hq_groups) do
		
			if SGroup_IsAlive(t_hq_groups[i].sgroup) then
				local encounter = t_hq_groups[i].encounter
					
				-- Setup the data for the unit
				local unitData = {
					name = "MyNewUnit",
					sbp = SBP.WEST_GERMAN.OBERSOLDATEN_SQUAD_MP,
					spawn = World_GetClosest(t_hq_groups[i].sgroup, {mkr_patrol_spawn2, mkr_patrol_spawn3, mkr_patrol_spawn5, mkr_patrol_spawn6, mkr_vehicle_spawn_01}),
--~ 					spawn = World_GetClosest(t_hq_groups[i].sgroup, t_patrol_spawns),
				}
				 
				-- Verify that the encounter is still alive before adding the unit
				if(encounter:IsAlive()) then
					encounter:AddUnit(unitData)
				end
			end
		end
		
	-- only 2 hq's left
	elseif SGroup_Count(sg_enemy_hq_all) == 2 then
		
		-- for each hq left alive, add units to their encounters
		for i = 1, table.getn(t_hq_groups) do
			
			if SGroup_IsAlive(t_hq_groups[i].sgroup) then
				local encounter = t_hq_groups[i].encounter
					
				-- Setup the data for the unit
				local unitData = {
					name = "MyNewUnit",
					sbp = SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP,
					upgrades = {UPG.WEST_GERMAN.ASSAULT_PIONEER_COMBAT_UPGRADE},
					spawn = World_GetClosest(t_hq_groups[i].sgroup, {mkr_patrol_spawn2, mkr_patrol_spawn3, mkr_patrol_spawn5, mkr_patrol_spawn6, mkr_vehicle_spawn_01}),
--~ 					spawn = World_GetClosest(t_hq_groups[i].sgroup, t_patrol_spawns),
				}
				 
				-- Verify that the encounter is still alive before adding the unit
				if(encounter:IsAlive()) then
					encounter:AddUnit(unitData)
				end
			end
		end
	end

end	

-- gets the closest hq to an sgroup from the table of hq halftracks
-- returns the group for the hq that is closest to the group
-- called by SpottedPlayer
function SGroup_GetClosestHQ(group, list)
	
	local item
	local min_distance = 9999999999999.0
	
	for i = 1, table.getn(list) do
	
		if SGroup_IsAlive(list[i].sgroup) then
			local current_distance = Util_GetDistance(group, list[i].sgroup)
			
			if  current_distance < min_distance then
				item = list[i].sgroup
				min_distance = current_distance
			end
		end
	end
	
	return item
end


-- Enemy Patrol functions ----------------------------------------------------------

-- send a Kubelwagen with a squad inside to unload at the encounter
-- called by event when encounter is attacked
function ReinforceEncounterLeft7()

	-- Verify that the encounter is still alive before adding the unit
	if(g_enc_left7:IsAlive()) then

		Util_CreateSquads(player2, {sg_enc_left7_transport, sg_enc_left7_reinforcement}, SBP.WEST_GERMAN.KUBELWAGEN_SQUAD_MP, mkr_patrol_spawn6, mkr_enc_left7_area)
		-- when the transport gets to the encounter area, add it to the encounter so it unloads the squad
		g_enc_left7:AddSgroup(sg_enc_left7_reinforcement)
	end
end



-- spawns enemy patrol to attack where a player was spotted by an IR halftrack
-- called by SpottedPlayer
function PatrolManager(target)
	print("** PATROL IS ATTACKING *******")
	
	-- get closest spawn marker
	local spawnloc = World_GetClosest(target, t_patrol_spawns)
	
	-- spawn encounter
	if SGroup_Count(sg_enemy_hq_all) >= 1 then
	
		-- spawn patrol strength depending on alert level
		if g_alert_percent >= 0.7 then
			g_enc_patrol_id = ENCOUNTERS.PatrolStrong(spawnloc)
			
		elseif g_alert_percent >= 0.4 then
			g_enc_patrol_id = ENCOUNTERS.PatrolMed(spawnloc)
			
		else
			g_enc_patrol_id = ENCOUNTERS.PatrolWeak(spawnloc)
		end
	end
	
	
	-- somebody was spotted, set goal to attack the area
	local goalData = {
		name = "Attack",
		target = Util_GetPosition(target),
		attackMove = true,
		range = 15,
		leashRange = 25,
		maxIdleTime = 20,
		retaliateAttacks = false,
		onSuccess = DespawnPatrol,
		tacticControlList = {
		},
	}
	g_enc_patrol_id:SetGoal(goalData)
	
	-- increment count of number of times player was spotted
	g_times_player_spotted = g_times_player_spotted + 1

end

-- sends the patrol to despawn off map
-- called by onSuccess of the patrol's goal, set by PatrolManager
function DespawnPatrol()
	print("** PATROL DESPAWNING *******")
	g_patrol_attacking = false
	local marker = World_GetClosest(sg_patrol, t_patrol_spawns)
	Cmd_MoveToAndDespawn(sg_patrol, marker, false)
end

-- after a delay, calls the function to reset the flag for spawning reinforcements
-- called by onDeath in patrol encounters
function StartResetPatrol()
	if Rule_Exists(ResetPatrol) == false then
		Rule_AddOneShot(ResetPatrol, 30.0)
	end
end


-- reset flag to allow more patrols to spawn
-- called by onDeath of patrol encounter
function ResetPatrol()
	g_patrol_attacking = false
end



-- spawns additional vehicle encounters and sends them to defend an area depending on which hq has died
-- triggered by an event on hq death
function SpawnTankEncounter(data)

	print(SGroup_GetName(data.sgroup))
	local goal_data
	local encounter_id
	local spawn

	-- only spawn another vehicle encounter if there's at least one hq left
	if SGroup_Count(sg_enemy_hq_all) >= 1 then
	
		-- if left side hq died then spawn vehicles on the left side
		if data.sgroup == sg_enemy_hq2 then
		
			goal_data = {
				name = "Defend",
				target = mkr_enc_left_vehicles_area,
				range = 45,
				leashRange = 55,
				tacticControlList = {
					{tacticType = TACTIC_Vehicle, priority = 200},
				},
			}
			
			print("left side 1")
			
			spawn = mkr_vehicle_spawn_02
			
		-- if right side hq died then spawn vehicles on the right side
		elseif data.sgroup == sg_enemy_hq1 then
		
			goal_data = {
				name = "Defend",
				target = mkr_enc_right_vehicles_area,
				range = 45,
				leashRange = 55,
				tacticControlList = {
					{tacticType = TACTIC_Vehicle, priority = 200},
				},
			}
			
			print("right side 1")
			
			spawn = mkr_vehicle_spawn_01
			
		else
		
			local target_marker
			
			if SGroup_IsAlive(sg_enemy_hq2) then
				target_marker = mkr_enc_left_vehicles_area
				print("left side 2")
				spawn = mkr_vehicle_spawn_02
				
			else
				target_marker = mkr_enc_right_vehicles_area
				print("right side 2")
				spawn = mkr_vehicle_spawn_01
			end
			
			goal_data = {
				name = "Defend",
				target = target_marker,
				range = 45,
				leashRange = 55,
				tacticControlList = {
					{tacticType = TACTIC_Vehicle, priority = 200},
				},
			}
			
		
		end
		
		-- spawn an encounter based on how many hq's are left
		if SGroup_Count(sg_enemy_hq_all) == 2 then
			-- spawn first group of vehicles
			encounter_id = ENCOUNTERS.Vehicles1(spawn)
		
		elseif SGroup_Count(sg_enemy_hq_all) == 1 then
			-- spawn second group of vehicles
			encounter_id = ENCOUNTERS.Vehicles2(spawn)
		end
		
		encounter_id:SetGoal(goal_data)
	end
end

-- Event functions --------------------------------------------------------------------

-- resets the flag for playing events related to revealing halftracks
-- triggered by function RevealHalftracks
function ResetHalftrackWarning()
	g_halftrack_revealed = false

end

-- resets the flag for playing events related to IR halftracks spotting the player
-- triggered by SpottedPlayer
function ResetPlayerSpottedAlert()
	g_player_spotted = false
end

