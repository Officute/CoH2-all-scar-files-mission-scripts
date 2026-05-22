print("\tLoading mission file...")
-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- OUREN
-- Designer: NJR
-------------------------------------------------------------------------
-------------------------------------------------------------------------

import("ScriptSetup.scar") -- <== ### CRITICAL ELEMENT. 
import("XP1.scar")				-- Ardennes Assault functionality

-- [[ Objective files ]]
import("Ouren_obj_Bridges.scar")
import("Ouren_obj_Counterattack.scar")

-- [[ Other data ]]
import("Ouren_allies.scar")
import("Ouren_encounters.scar")



-------------------------------------------------------------------------
-- [[ MISSION SETUP ]]
-------------------------------------------------------------------------
-- Initializes players
function Mission_SetupPlayers()
	
	--For Missions/Challenges:
	player1 = Setup_Player(1, 11073202, "aef", 1)				-- player1 is always the human player					-- LOCDB [11073202] 'US Forces'
	player2 = Setup_Player(2, 11073205, "west_german", 2)		-- player2 is the opponent								-- LOCDB [11073205] 'Oberkommando West'
	player3 = Setup_Player(3, 11079506, "aef", 1)				-- player3 is the player's AI-controlled ally			-- LOCDB [11079506] '112th Regiment'
	player4 = Setup_Player(4, 11073205, "west_german", 2)		-- player4 is the counterattack player					-- LOCDB [11073205] 'Oberkommando West'

end

-- Defines key mission data and any global values used throughout the mission.
function Mission_SetupVariables()
	
	print("Initializing mission DATA...")
	
	g_missionData = {
		useBeginnerHints = false,							-- Wether or not to use the BeginnerHint system
		useEncounterSystem = true,							-- Whether or not to use the Encounter system
		useXP1Difficulty = true,							-- Whether or not this mission uses the XP1 Difficulty system
		missionType = MT_XP1_CHALLENGE,						-- What Mission Type is this mission? MT_
		introNIS =  "XP1/Ouren_Intro", 			 							-- Movie filename
		introNISlet = nil,					 				-- NISlet triggered after introNIS
		introNISletSkipped = nil,	 						-- Function called if the introNISlet is skipped
		introSitRep = nil,									-- Movie (string) to play after intro nislet
		endNISlet = nil,									-- NISlet triggered on mission completion
		endNIS = nil,										-- Movie (string) to play on mission completion
		missionSpeechPath = "botb/gameplay",							-- Speech path to cache (string)
		precacheSounds = {									-- Any audio files you want precached (list of strings)
		},
		nisFiles = {										-- .nis files associated with the mission (path string)
		},
		nisInTransitionTime = 0,
		nisOutTransitionTime = 0,
		objectives = {										-- List of PARENT objective tables.
			OBJ_Bridges,									-- These are the global references to the objective tables defined in the separete files.
			OBJ_Counterattack,						
		},
		secondaryObjectives = {								-- Slottable secondary objectives: (one of the following gets picked at random)
			{
				obj = SecondaryOBJ_CaptureIntel,			-- Capture the Intel
				data = {
					locations = {mkr_intel_1, mkr_intel_2, mkr_intel_3, mkr_intel_4, mkr_intel_5, mkr_intel_6, mkr_intel_7},
					number_to_spawn = 3,
					number_to_capture = 3,
					base_area = mkr_base,
				},
			},
			{
				obj = SecondaryOBJ_KillVIP,
				data = {
					spawns = {
						{spawn = mkr_stronghold3_encounterarea, ui = mkr_stronghold3_encounterarea},
					},
					protectEncounter = ENCOUNTERS.protectVIP,
				},
			},
			{
				obj = SecondaryOBJ_DestroyTank,
				data = {
					spawns = {
						{spawn = mkr_stronghold3_encounterarea, ui = mkr_stronghold3_encounterarea},
					},
					protectEncounter = ENCOUNTERS.protectVIP,
				},
			},
		},
		
		atmosphere = nil,									-- Loads an atmosphere for this mission. Useful for battles and mini challenges
--~ 		startingUnits = {									-- Units to be spawned for P1 on mission start. Follows same parameters as Encounters.
--~ 			{
--~ 				sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
--~ 				spawn = mkr_troopDrop,
--~ 				upgrades = nil,
--~ 				entityUpgrades = nil,
--~ 				slotItems = nil,
--~ 				numSquads = nil,
--~ 				load = nil,
--~ 				veterancyRank = nil,
--~ 				difficulty = nil,
--~ 				conditions = nil,
--~ 				commanderDivision = nil,
--~ 			},
--~ 			{
--~ 				sbp = SBP.GERMAN.GRENADIER_SQUAD,
--~ 				spawn = mkr_troopDrop,
--~ 			},
--~ 		}
	}
	
	__Team_Init()
	
	
	--[[GLOBAL VARIABLES]]
	sg_temp = SGroup_CreateIfNotFound("sg_temp")
	sg_blah = SGroup_CreateIfNotFound("sg_blah")
	eg_temp = EGroup_CreateIfNotFound("eg_temp")
	eg_blah = EGroup_CreateIfNotFound("eg_blah")
	
	-- south bridge groups
	sg_southbridge_hmg1 = SGroup_CreateIfNotFound("sg_southbridge_hmg1")
	sg_southbridge_hmg2 = SGroup_CreateIfNotFound("sg_southbridge_hmg2")
	sg_southbridge_mortar1 = SGroup_CreateIfNotFound("sg_southbridge_mortar1")
	sg_southbridge_atgun1 = SGroup_CreateIfNotFound("sg_southbridge_atgun1")
	sg_southbridge_infantry1 = SGroup_CreateIfNotFound("sg_southbridge_infantry1")
	sg_southbridge_infantry2 = SGroup_CreateIfNotFound("sg_southbridge_infantry2")
	sg_southbridge_infantry3 = SGroup_CreateIfNotFound("sg_southbridge_infantry3")
	sg_southbridge_encounter = SGroup_CreateIfNotFound("sg_southbridge_encounter")
	sg_southbridge_southdefenders = SGroup_CreateIfNotFound("sg_southbridge_southdefenders")
	sg_southbridge_all = SGroup_CreateIfNotFound("sg_southbridge_all")
	
	-- north bridge groups
	sg_northbridge_hmg1 = SGroup_CreateIfNotFound("sg_northbridge_hmg1")
	sg_northbridge_hmg2 = SGroup_CreateIfNotFound("sg_northbridge_hmg2")
	sg_northbridge_atgun1 = SGroup_CreateIfNotFound("sg_northbridge_atgun1")
	sg_northbridge_encounter = SGroup_CreateIfNotFound("sg_northbridge_encounter")
	sg_northbridge_all = SGroup_CreateIfNotFound("sg_northbridge_all")
	sg_northbridge_hmg1_recrew = SGroup_CreateIfNotFound("sg_northbridge_hmg1_recrew")
	sg_northbridge_hmg2_recrew = SGroup_CreateIfNotFound("sg_northbridge_hmg2_recrew")
	sg_northbridge_atgun1_recrew = SGroup_CreateIfNotFound("sg_northbridge_atgun1_recrew")
	
	sg_northfield_hmg1 = SGroup_CreateIfNotFound("sg_northfield_hmg1")
	sg_northfield_atgun1 = SGroup_CreateIfNotFound("sg_northfield_atgun1")
	sg_northfield_encounter = SGroup_CreateIfNotFound("sg_northfield_encounter")
	sg_northfield_all = SGroup_CreateIfNotFound("sg_northfield_all")
	
	-- allies
	sg_allies_muster1 = SGroup_CreateIfNotFound("sg_allies_muster1")
	sg_allies_muster2 = SGroup_CreateIfNotFound("sg_allies_muster2")
	sg_allies_muster3 = SGroup_CreateIfNotFound("sg_allies_muster3")
	sg_allies_muster4 = SGroup_CreateIfNotFound("sg_allies_muster4")
	sg_allies_muster5 = SGroup_CreateIfNotFound("sg_allies_muster5")
	sg_allies_stage1_encounter = SGroup_CreateIfNotFound("sg_allies_stage1_encounter")
	sg_allies_stage2_northencounter = SGroup_CreateIfNotFound("sg_allies_stage2_northencounter")
	sg_allies_stage2_midencounter = SGroup_CreateIfNotFound("sg_allies_stage2_midencounter")
	sg_allies_stage2_southencounter = SGroup_CreateIfNotFound("sg_allies_stage2_southencounter")
	
	-- counterattack
	sg_counterattack_all = SGroup_CreateIfNotFound("sg_counterattack_all")
	sg_counterattack_stage1_encounter = SGroup_CreateIfNotFound("sg_counterattack_stage1_encounter")
	sg_counterattack_stage2_northencounter = SGroup_CreateIfNotFound("sg_counterattack_stage2_northencounter")
	sg_counterattack_stage2_midencounter = SGroup_CreateIfNotFound("sg_counterattack_stage2_midencounter")
	sg_counterattack_stage2_southencounter = SGroup_CreateIfNotFound("sg_counterattack_stage2_southencounter")
	
	sg_counterattack_simpleinfantry = SGroup_CreateIfNotFound("sg_counterattack_simpleinfantry")
	sg_counterattack_specialistinfantry = SGroup_CreateIfNotFound("sg_counterattack_specialistinfantry")
	sg_counterattack_simplevehicles = SGroup_CreateIfNotFound("sg_counterattack_simplevehicles")
	sg_counterattack_mediumvehicles = SGroup_CreateIfNotFound("sg_counterattack_mediumvehicles")
	sg_counterattack_heavyvehicles = SGroup_CreateIfNotFound("sg_counterattack_heavyvehicles")
	
	
	
	--[[MAP GROUPS]]
	--TODO: Document any egroups that are defined within the worldbuilder. For example:
	-- eg_bunkerP1: This egroup contains all the player-controlled bunkers placed on the map.
	
	-- Node strength flags
	g_mortars = false				--  There will be Infantry Support Guns on the map
	g_elite_infantry = false		-- There will be Obersoldaten squads
	g_tanks = false					-- There will be heavier armour
	
end

-- Defines difficulty tables/tuning variables
function Mission_SetDifficulty(diffVal)
	--TODO: Define any difficulty-related settings or variables.
	-- These variables should be stored in a t_difficulty table for readability and access.
	
	g_difficulty = diffVal or Game_GetSPDifficulty() 	-- Note: Having the diffVal parameter allows for redefining difficulty settings during runtime.
	AI_OverrideDifficulty(g_difficulty)
	
	--Global difficulty table
	t_difficulty = {
		startManpower = 		Util_DifVar({500, 400, 300}, g_difficulty),			-- Starting Manpower
		startMunition = 		Util_DifVar({100, 80, 50}, g_difficulty),			-- Starting Munitions
		startFuel = 			Util_DifVar({70, 50, 30}, g_difficulty),			-- Starting Fuel
		CountdownStartTime = 	Util_DifVar({600, 480, 390}, g_difficulty),			-- Latest time the countdown will start (may trigger earlier based on player progress)
		CountdownLength =		Util_DifVar({600, 480, 390}, g_difficulty),			-- How long the countdown lasts (roughly - it will expand and contract a bit, again, based on player progress)
		CounterattackSize = 	Util_DifVar({20, 27, 38}, g_difficulty),			-- How many units the counterattack will comprise of
		MaxSimpleInfantry = 	Util_DifVar({8, 9, 14}, g_difficulty),				-- How many units at once during the counterattack can be spawned at any one time
		MaxSpecialistInfantry = Util_DifVar({3, 5, 13}, g_difficulty),				-- How many units at once during the counterattack can be spawned at any one time
		MaxSimpleVehicles = 	Util_DifVar({3, 5, 13}, g_difficulty),				-- How many units at once during the counterattack can be spawned at any one time
		MaxMediumVehicles = 	Util_DifVar({1, 3, 5}, g_difficulty),				-- How many units at once during the counterattack can be spawned at any one time
		MaxHeavyVehicles = 		Util_DifVar({1, 2, 3}, g_difficulty),				-- How many units at once during the counterattack can be spawned at any one time
		CounterattackLullTime = Util_DifVar({150, 120, 90}, g_difficulty),			-- The length of the lull between the first and second wave of the counterattack
		AlliesMaxSize =			Util_DifVar({30, 22, 15}, g_difficulty),			-- max number of units the allies can contain
		AlliesSpawnScaler = 	Util_DifVar({0.75, 1.0, 1.25}, g_difficulty),			-- how much to slow down/speed up the spawning rate of allied units
		CounterattackSpawnScaler = Util_DifVar({1.25, 1.0, 0.75}, g_difficulty),			-- how much to slow down/speed up the spawning rate of units during the counterattack
	}
	
	Player_SetResource(player1, RT_Manpower, t_difficulty.startManpower)
	Player_SetResource(player1, RT_Munition, t_difficulty.startMunition)
	Player_SetResource(player1, RT_Fuel, t_difficulty.startFuel)

	-- player dynamic difficulty settings
	PM_PL_StartingResourceHit = true
	
	-- enemy dynamic difficulty settings
	PM_AI_CPDefenses = true	
	PM_AI_BaseDefenses = true
	PM_AI_Defensiveness = true
	
	
	-- NODE STRENGTH ---------------------------------------
	-- set flags for different levels of node strength
	if XP1_GetNodeStrength() >= 3 then
		g_mortars = true
	end
	
	if XP1_GetNodeStrength() >= 4 then
		g_elite_infantry = true
	end
	
	if XP1_GetNodeStrength() >= 5 then
		g_tanks = true
	end
	
end

-- Sets restrictions on units, teams, etc.
function Mission_SetupRestrictions()
	--TODO: Set any tech/ability restrictions on a players, as well as resource limits.
	--	Note: Resource Income/Caps should be defined in Mission_SetDifficulty()
	
	--[[ HUMAN PLAYER ]]
	Player_AddAbilityLockoutZone(player1, BP_GetAbilityBlueprint("pm_airborne_paratroopers"), mkr_abilitylockout_1)
	Player_AddAbilityLockoutZone(player1, BP_GetAbilityBlueprint("pm_airborne_paratroopers"), mkr_abilitylockout_2)
	
	Player_AddAbilityLockoutZone(player1, BP_GetAbilityBlueprint("pm_airborne_paratroopers_accurate"), mkr_abilitylockout_1)
	Player_AddAbilityLockoutZone(player1, BP_GetAbilityBlueprint("pm_airborne_paratroopers_accurate"), mkr_abilitylockout_2)
	
	Player_AddAbilityLockoutZone(player1, BP_GetAbilityBlueprint("pm_airborne_supply"), mkr_abilitylockout_1)
	Player_AddAbilityLockoutZone(player1, BP_GetAbilityBlueprint("pm_airborne_supply"), mkr_abilitylockout_2)
	
	Player_AddAbilityLockoutZone(player1, BP_GetAbilityBlueprint("pm_airborne_dispatch_pathfinders"), mkr_abilitylockout_1)
	Player_AddAbilityLockoutZone(player1, BP_GetAbilityBlueprint("pm_airborne_dispatch_pathfinders"), mkr_abilitylockout_2)
	
	--[[ ALLIED PLAYER ]]
	
	--[[ ENEMY PLAYER ]]
	
end

-- Sets up the map before the mission starts (starting units, ownership, etc.)
function Mission_Preset()

	-- make the bridges a bit tougher
	Modify_ReceivedDamage(eg_bridge_north, 0.25)
	Modify_ReceivedDamage(eg_bridge_south, 0.5)
	
	-- Set the ice heal rate to 0 so it never heals
	World_SetIceHealingRate(0)
	
	-- remove superflous map entry points (only there to make the map save properly!)
	EGroup_DestroyAllEntities(eg_to_delete_on_startup)
	
	-- lock down up the german's trucks
--~ 	Cmd_Ability(sg_truck_munitionspoint, ABILITY.WEST_GERMAN.SUPPORT_TRUCK_TARGET_SETUP, SGroup_GetPosition(sg_truck_munitionspoint), Squad_GetHeading(SGroup_GetSpawnedSquadAt(sg_truck_munitionspoint, 1)), true)
--~ 	Cmd_Ability(sg_truck_fuelpoint, ABILITY.WEST_GERMAN.SUPPORT_TRUCK_TARGET_SETUP, SGroup_GetPosition(sg_truck_fuelpoint), Squad_GetHeading(SGroup_GetSpawnedSquadAt(sg_truck_fuelpoint, 1)), true)
--~ 	Rule_AddOneShot(Mission_PresetB, 2)
	
	-- add supply to the allies' territory on the north of the map
	World_SetDesignerSupply(Util_GetPosition(mkr_ally_spawn1), true)
	
	-- grab the enemy hq
	Player_GetAll(player2)
	EGroup_Filter(eg_allentities, EBP.WEST_GERMAN.WEST_GERMAN_HQ_MP, FILTER_KEEP)
	EGroup_AddEGroup(eg_base_hq, eg_allentities)
	
	-- make the hospital capturable once the hq is destroyed
	World_SetDesignerSupply(Util_GetPosition(eg_base_hospital), true)

	Event_GroupIsDead(EnemyBase_BaseDestroyed, nil, eg_base_hq)
	
end
function Mission_PresetB()
	
	-- convert the german's trucks into bases (had to be delayed for some reason!)
--~ 	Cmd_Ability(sg_truck_munitionspoint, ABILITY.WEST_GERMAN.CONSTRUCT_INFANTRY_BARRACKS, nil, nil, true, true)
--~ 	Cmd_Ability(sg_truck_fuelpoint, ABILITY.WEST_GERMAN.CONSTRUCT_ARMORED_INFANTRY_COMMAND, nil, nil, true, true)
	
end



-------------------------------------------------------------------------
-- [[ MISSION START ]]
-------------------------------------------------------------------------
--Called once the intro nis/nislet/sitrep finishes playing.
function Mission_Start()
	
	-- three strongholds around the enemy base
	ENCOUNTERS.Stronghold1()
	ENCOUNTERS.Stronghold2()
	ENCOUNTERS.Stronghold3()
	
	-- the enemy base itself
	enc_EnemyBase = ENCOUNTERS.EnemyBase()
	
	-- two major encounter areas
	ENCOUNTERS.FuelDepotEncounter()
	ENCOUNTERS.MunitionsDepotEncounter()
	

	-- call the init functions for each bridge - a lot of the setup occurs there
	Rule_AddOneShot(SouthBridge_Init, 1)
	Rule_AddOneShot(NorthBridge_Init, 1)
	
	-- start the main objective
	Objective_Start(OBJ_Bridges)
	Objective_Start(SOBJ_SouthBridge, false)	-- silent
	Objective_Start(SOBJ_NorthBridge, false)	-- silent
	
	-- set up secondary objective trigger
	Event_Proximity(Mission_TriggerSecondaryObjective, nil, player1, mkr_trigger_secondaryobjective, nil, ANY, 3)
	
	-- set up a rule to mention infantry support guns if they are enabled at this node strength
	if g_mortars == true then
		Rule_AddInterval(Mission_SpottedAnInfantrySupportGun, 5)
	end
	
end



-- kick off the secondary objective when player is midway across the map
function Mission_TriggerSecondaryObjective()
	
	Mission_StartSecondaryObjective(true, false)
	
	-- and start the wanderers shortly after
	Mission_StartWanderingEncounters()
	
end




-- play an event when the player spots an infantry support gun for the first time (runs infrequently)
function Mission_SpottedAnInfantrySupportGun()

	if Event_IsAnyRunning() == false then
		
		Player_GetAll(player2)
		SGroup_Filter(sg_allsquads, SBP.WEST_GERMAN.LE_IG_18_INF_SUPPORT_GUN_SQUAD_MP, FILTER_KEEP)
	
		if Player_CanSeeSGroup(player1, sg_allsquads, ANY) then
		
			Rule_RemoveMe()
			Util_StartIntel(EVENTS.PlayerSpottedInfantrySupportGun)
			
		elseif counterattack_units_still_to_spawn ~= nil then
			
			Player_GetAll(player4)
			SGroup_Filter(sg_allsquads, SBP.WEST_GERMAN.LE_IG_18_INF_SUPPORT_GUN_SQUAD_MP, FILTER_KEEP)
		
			if Player_CanSeeSGroup(player1, sg_allsquads, ANY) then
			
				Rule_RemoveMe()
				Util_StartIntel(EVENTS.PlayerSpottedInfantrySupportGun)
				
			end
			
		end
		
	end
	
end




function Mission_StartWanderingEncounters()

	-- units that wander around the map on paths (there are lots just to break them up, not because there's a lot of units doing this)
	Event_Timer(Mission_StartWanderingEncounters_Individual, {encounter = ENCOUNTERS.WanderingEncounter1}, 3)
	Event_Timer(Mission_StartWanderingEncounters_Individual, {encounter = ENCOUNTERS.WanderingEncounter2}, 6)
	Event_Timer(Mission_StartWanderingEncounters_Individual, {encounter = ENCOUNTERS.WanderingEncounter3}, 11)
	Event_Timer(Mission_StartWanderingEncounters_Individual, {encounter = ENCOUNTERS.WanderingEncounter4}, 18)
	Event_Timer(Mission_StartWanderingEncounters_Individual, {encounter = ENCOUNTERS.WanderingEncounter5}, 27)
	Event_Timer(Mission_StartWanderingEncounters_Individual, {encounter = ENCOUNTERS.WanderingEncounter6}, 38)
	
end
function Mission_StartWanderingEncounters_Individual(data)
	data.encounter()
end


-- do some jiggery-pokery when the enemy base is destroyed
function EnemyBase_BaseDestroyed(data)

	World_SetDesignerSupply(Util_GetPosition(eg_base_hospital), false)		-- they need to lose the fake supply point (it was only for the enemy, we don't want the player getting supply from this location)
	
end

