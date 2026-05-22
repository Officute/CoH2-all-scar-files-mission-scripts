print("\tLoading mission file...")
-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- INTRO MISSION "TWIN VILLAGES"
-- Designer: NJR
-------------------------------------------------------------------------
-------------------------------------------------------------------------

import("ScriptSetup.scar") -- <== ### CRITICAL ELEMENT. 
import("XP1.scar")				-- Ardennes Assault functionality

-- [[ Objective files ]]
import("Twin_Villages_obj_Intro.scar")
import("Twin_Villages_obj_Support.scar")
import("Twin_Villages_obj_Airborne.scar")
import("Twin_Villages_obj_Mechanized.scar")


-- [[ Other data ]]
import("Twin_Villages_encounters.scar")
import("Twin_Villages.events")
import("XP1_BeginnerHints.scar")



-------------------------------------------------------------------------
-- [[ MISSION SETUP ]]
-------------------------------------------------------------------------
-- Initializes players
function Mission_SetupPlayers()
	
	locid_support_division = 11078327			-- LOCDB [11078327] 'Dog Company'
	locid_airborne_division = 11078325			-- LOCDB [11078325] 'Able Company'
	locid_mechanized_division = 11078326		-- LOCDB [11078326] 'Baker Company'
	
	locid_support_division_long = 11079550		-- LOCDB [11079550] 'Dog Company - Support'
	locid_airborne_division_long = 11079548		-- LOCDB [11079548] 'Able Company - Airborne'
	locid_mechanized_division_long = 11079549	-- LOCDB [11079549] 'Baker Company - Mechanized Infantry'
	
	--For Missions/Challenges:
	player1 = Setup_Player(1, locid_support_division, "aef", 1)					-- player1 is always the human player
	player2 = Setup_Player(2, 11073205, "west_german", 2)						-- player2 is the opponent
	player3 = Setup_Player(3, locid_support_division, "aef", 1)					-- player3 is an AI-controlled ally (WITH shared LOS to player 1)
	player4 = Setup_Player(4, locid_support_division, "aef", 1)					-- player4 is the AI-controlled ally (withOUT shared LOS) -- Support
	player5 = Setup_Player(5, locid_airborne_division, "aef", 1)				-- player5 is the AI-controlled ally (withOUT shared LOS) -- Airborne
	player6 = Setup_Player(6, locid_mechanized_division, "aef", 1)				-- player6 is the AI-controlled ally (withOUT shared LOS) -- Mechanized

end

-- Defines key mission data and any global values used throughout the mission.
function Mission_SetupVariables()
	
	print("Initializing mission DATA...")
	
	g_missionData = {
		useBeginnerHints = false,							-- Wether or not to use the BeginnerHint system
		useEncounterSystem = true,							-- Whether or not to use the Encounter system
		useXP1Difficulty = true,							-- Whether or not this mission uses the XP1 Difficulty system
		missionType = MT_XP1_CHALLENGE,						-- What Mission Type is this mission? MT_
		introNIS = "XP1/Twin_Villages_Intro",						-- Movie filename
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
			OBJ_Intro,										-- These are the global references to the objective tables defined in the separete files.
			OBJ_Support,
			OBJ_Airborne,						
			OBJ_Mechanized,						
		},
--~ 		secondaryObjectives = {								-- Slottable secondary objectives: (one of the following gets picked at random)
--~ 		},
		
		atmosphere = "xp1/_twin_villages_early_morning.aps",				-- Loads an atmosphere for this mission. Useful for battles and mini challenges
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
	sg_single = SGroup_CreateIfNotFound("sg_single")
	eg_temp = EGroup_CreateIfNotFound("eg_temp")
	eg_blah = EGroup_CreateIfNotFound("eg_blah")
	eg_single = EGroup_CreateIfNotFound("eg_single")
	
	sg_startingunits = SGroup_CreateIfNotFound("sg_startingunits")
	sg_intro_truck1 = SGroup_CreateIfNotFound("sg_intro_truck1")
	sg_intro_truck2 = SGroup_CreateIfNotFound("sg_intro_truck2")
	sg_intro_truck3 = SGroup_CreateIfNotFound("sg_intro_truck3")
	sg_intro_rifleman1 = SGroup_CreateIfNotFound("sg_intro_rifleman1")
	sg_intro_rifleman2 = SGroup_CreateIfNotFound("sg_intro_rifleman2")
	
	-- airborne commander (R.I.P.) (spoilers)
	sg_jackson = SGroup_CreateIfNotFound("sg_jackson")
	sg_jackson_squad1 = SGroup_CreateIfNotFound("sg_jackson_squad1")
	sg_jackson_squad2 = SGroup_CreateIfNotFound("sg_jackson_squad2")
	sg_jackson_all = SGroup_CreateIfNotFound("sg_jackson_all")
	sg_jackson_attackers = SGroup_CreateIfNotFound("sg_jackson_attackers")
	sg_jackson_aides = SGroup_CreateIfNotFound("sg_jackson_aides")
	
	-- support
	eg_support_alreadybuiltfightingpositions = EGroup_CreateIfNotFound("eg_support_alreadybuiltfightingpositions")
	eg_support_alreadybuilttanktraps = EGroup_CreateIfNotFound("eg_support_alreadybuilttanktraps")
	
	-- sentry 1 encounters
	sg_sentry1_attackers = SGroup_CreateIfNotFound("sg_sentry1_attackers")
	sg_sentry1_attackers_leftflank = SGroup_CreateIfNotFound("sg_sentry1_attackers_leftflank")
	sg_sentry1_attackers_rightflank = SGroup_CreateIfNotFound("sg_sentry1_attackers_rightflank")
	sg_sentry1_replacements = SGroup_CreateIfNotFound("sg_sentry1_replacements")
	
	-- sentry 2 encounters
	sg_sentry2_enemyencounter = SGroup_CreateIfNotFound("sg_sentry2_enemyencounter")
	sg_sentry2_enemystatic = SGroup_CreateIfNotFound("sg_sentry2_enemystatic")
	sg_sentry2_enemyall = SGroup_CreateIfNotFound("sg_sentry2_enemyall")
	sg_sentry2_replacements = SGroup_CreateIfNotFound("sg_sentry2_replacements")
	
	-- airborne section
	sg_rocherath_defenders1 = SGroup_CreateIfNotFound("sg_rocherath_defenders1")
	sg_rocherath_defenders2 = SGroup_CreateIfNotFound("sg_rocherath_defenders2")
	sg_rocherath_defenders3 = SGroup_CreateIfNotFound("sg_rocherath_defenders3")
	sg_airborne_attackers1 = SGroup_CreateIfNotFound("sg_airborne_attackers1")
	sg_airborne_attackers2 = SGroup_CreateIfNotFound("sg_airborne_attackers2")
	sg_airborne_attackers3 = SGroup_CreateIfNotFound("sg_airborne_attackers3")
	sg_airborne_attackers4 = SGroup_CreateIfNotFound("sg_airborne_attackers4")
	sg_airborne_attackers5 = SGroup_CreateIfNotFound("sg_airborne_attackers5")
	sg_airborne_periphery_gunners = SGroup_CreateIfNotFound("sg_airborne_periphery_gunners")
	sg_airborne_periphery_targets = SGroup_CreateIfNotFound("sg_airborne_periphery_targets")
	
	sg_airborne_pathfinders = SGroup_CreateIfNotFound("sg_airborne_pathfinders")
	sg_airborne_forest_defenders = SGroup_CreateIfNotFound("sg_airborne_forest_defenders")
	sg_airborne_radiotower_defenders = SGroup_CreateIfNotFound("sg_airborne_radiotower_defenders")
	
	eg_airborne_beacon = EGroup_CreateIfNotFound("eg_airborne_beacon")
	
	-- mechanized section
	sg_mechanized_attackers1 = SGroup_CreateIfNotFound("sg_mechanized_attackers1")
	sg_mechanized_attackers2 = SGroup_CreateIfNotFound("sg_mechanized_attackers2")
	sg_mechanized_attackers3 = SGroup_CreateIfNotFound("sg_mechanized_attackers3")
	sg_mechanized_sentrydefenders1 = SGroup_CreateIfNotFound("sg_mechanized_sentrydefenders1")
	sg_mechanized_sentrydefenders2 = SGroup_CreateIfNotFound("sg_mechanized_sentrydefenders2")
	sg_mechanized_sentrydefenders2_extra1 = SGroup_CreateIfNotFound("sg_mechanized_sentrydefenders2_extra1")
	sg_mechanized_sentrydefenders2_extra2 = SGroup_CreateIfNotFound("sg_mechanized_sentrydefenders2_extra2")
	sg_mechanized_sentrydefenders2_extra3 = SGroup_CreateIfNotFound("sg_mechanized_sentrydefenders2_extra3")

	sg_mechanized_static1 = SGroup_CreateIfNotFound("sg_mechanized_static1")
	sg_mechanized_static2 = SGroup_CreateIfNotFound("sg_mechanized_static2")
	sg_mechanized_static3 = SGroup_CreateIfNotFound("sg_mechanized_static3")
	sg_mechanized_static4 = SGroup_CreateIfNotFound("sg_mechanized_static4")
	
	sg_mechanized_evacuees_stage1	= SGroup_CreateIfNotFound("sg_mechanized_evacuees_stage1")
	sg_mechanized_evacuees_stage2	= SGroup_CreateIfNotFound("sg_mechanized_evacuees_stage2")
	sg_mechanized_evacuees_sent	= SGroup_CreateIfNotFound("sg_mechanized_evacuees_sent")
	
	sg_mechanized_jacksonkillers = SGroup_CreateIfNotFound("sg_mechanized_jacksonkillers")
	sg_mechanized_jacksonkillertargets = SGroup_CreateIfNotFound("sg_mechanized_jacksonkillertargets")
	sg_mechanized_jacksonattackers = SGroup_CreateIfNotFound("sg_mechanized_jacksonattackers")
	
	eg_jacksonHouse = EGroup_CreateIfNotFound("eg_jacksonHouse")
	EGroup_SetInvulnerable(eg_jacksonHouse, 0.5)
	EGroup_SetInvulnerable(eg_jacksonAideHouse, 0.5)
	
	-- base buildings
	eg_hq = EGroup_CreateIfNotFound("eg_hq")
	eg_majorbuilding = EGroup_CreateIfNotFound("eg_majorbuilding")
	eg_captainbuilding = EGroup_CreateIfNotFound("eg_captainbuilding")
	eg_lieutenantbuilding = EGroup_CreateIfNotFound("eg_lieutenantbuilding")
	eg_weaponsrack_bar = EGroup_CreateIfNotFound("eg_weaponsrack_bar")
	eg_weaponsrack_bazooka = EGroup_CreateIfNotFound("eg_weaponsrack_bazooka")
	eg_weaponsrack_lmg = EGroup_CreateIfNotFound("eg_weaponsrack_lmg")
	eg_basebuildings = EGroup_CreateIfNotFound("eg_basebuildings")
	
	eg_retreatpoint = EGroup_CreateIfNotFound("eg_retreatpoint")
	
	
	
	
end

-- Defines difficulty tables/tuning variables
function Mission_SetDifficulty(diffVal)
	--TODO: Define any difficulty-related settings or variables.
	-- These variables should be stored in a t_difficulty table for readability and access.
	
	g_difficulty = diffVal or Game_GetSPDifficulty() 	-- Note: Having the diffVal parameter allows for redefining difficulty settings during runtime.
	AI_OverrideDifficulty(g_difficulty)
	
	--Global difficulty table
	t_difficulty = {
		startManpower = 		Util_DifVar({400, 400, 300}, g_difficulty),			-- Starting Manpower
		startMunition = 		Util_DifVar({100, 80, 50}, g_difficulty),			-- Starting Munitions
		startFuel = 			Util_DifVar({70, 50, 30}, g_difficulty),			-- Starting Fuel
		CountdownStartTime = 	Util_DifVar({600, 480, 390}, g_difficulty),			-- Latest time the countdown will start (may trigger earlier based on player progress)
		CountdownLength =		Util_DifVar({600, 480, 390}, g_difficulty),			-- How long the countdown lasts (roughly - it will expand and contract a bit, again, based on player progress)
		CounterattackSize = 	Util_DifVar({30, 40, 55}, g_difficulty),			-- How many units the counterattack will comprise of
		CounterattackLullTime = Util_DifVar({150, 120, 90}, g_difficulty),			-- The length of the lull between the first and second wave of the counterattack
		AlliesMaxSize =			Util_DifVar({30, 22, 15}, g_difficulty),			-- max number of units the allies can contain
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
	
end

-- Sets restrictions on units, teams, etc.
function Mission_SetupRestrictions()
	--TODO: Set any tech/ability restrictions on a players, as well as resource limits.
	--	Note: Resource Income/Caps should be defined in Mission_SetDifficulty()
	
	--[[ HUMAN PLAYER ]]

	Player_SetEntityProductionAvailability(player1, EBP.AEF.FIGHTING_POSITION_MP, ITEM_LOCKED)
	Player_SetEntityProductionAvailability(player1, EBP.AEF.OBSERVATION_POST_MUNITION_AEF_MP, ITEM_LOCKED)
	Player_SetEntityProductionAvailability(player1, EBP.AEF.AEF_TANK_TRAP_MP, ITEM_LOCKED)
	Player_SetEntityProductionAvailability(player1, EBP.AEF.OBSERVATION_POST_FUEL_AEF_MP, ITEM_LOCKED)
	Player_SetEntityProductionAvailability(player1, EBP.AEF.AEF_SANDBAG_FENCE, ITEM_LOCKED)	
	Player_SetEntityProductionAvailability(player1, EBP.AEF.AEF_BARBED_WIRE_FENCE_MP, ITEM_LOCKED)
	Player_SetSquadProductionAvailability(player1, SBP.AEF.RIFLEMEN_SQUAD_MP, ITEM_LOCKED)	
	Player_SetSquadProductionAvailability(player1, SBP.AEF.DODGE_WC51_AMBULANCE_SQUAD_MP, ITEM_LOCKED)	
	Player_SetSquadProductionAvailability(player1, SBP.AEF.REAR_ECHELON_SQUAD_MP, ITEM_LOCKED)	
	Player_SetUpgradeAvailability(player1, UPG.AEF.FIGHTING_POSITION_MG_ADDITION_MP, ITEM_LOCKED)
	Player_SetUpgradeAvailability(player1, UPG.AEF.WEAPON_RACK_UPGRADE_MP, ITEM_LOCKED)
	
	Player_SetAbilityAvailability(player1, BP_GetAbilityBlueprint("pm_man_the_defenses"), ITEM_LOCKED)
	Player_SetAbilityAvailability(player1, BP_GetAbilityBlueprint("assault_engineer_call_in"), ITEM_LOCKED)
	Player_SetAbilityAvailability(player1, BP_GetAbilityBlueprint("pm_artillery_support_105mm"), ITEM_LOCKED)
	Player_SetAbilityAvailability(player1, BP_GetAbilityBlueprint("pm_artillery_support_anti_tank"), ITEM_LOCKED)
	
	Player_SetAbilityAvailability(player1, BP_GetAbilityBlueprint("pm_airborne_strafe"), ITEM_LOCKED)
	Player_SetAbilityAvailability(player1, BP_GetAbilityBlueprint("pm_airborne_supply"), ITEM_LOCKED)
	Player_SetAbilityAvailability(player1, BP_GetAbilityBlueprint("pm_airborne_rocket"), ITEM_LOCKED)
	Player_SetAbilityAvailability(player1, BP_GetAbilityBlueprint("pm_airborne_paratroopers"), ITEM_LOCKED)
	
	
	
	--[[ ALLIED PLAYER ]]
	
	--[[ ENEMY PLAYER ]]
	
end

-- Sets up the map before the mission starts (starting units, ownership, etc.)
function Mission_Preset()

	-- make sure P1 doesn't share LOS with P4 (Support), P5 (Airborne) or P6 (Mechanized)
	World_EnableSharedLineOfSight(player1, player4, false)
	World_EnableSharedLineOfSight(player1, player5, false)
	World_EnableSharedLineOfSight(player1, player6, false)
	World_EnableSharedLineOfSight(player3, player4, false)
	World_EnableSharedLineOfSight(player3, player5, false)
	World_EnableSharedLineOfSight(player3, player6, false)
	
	World_EnableSharedLineOfSight(player4, player5, false)
	World_EnableSharedLineOfSight(player4, player6, false)
	World_EnableSharedLineOfSight(player5, player6, false)
	
	World_EnableSharedLineOfSight(player1, player3, true)	-- make sure P1 can see P3, though :)
	
	
	-- fix flashing territories
	World_SetDesignerSupply(Util_GetPosition(eg_point_enemy3), true)
	World_SetDesignerSupply(Util_GetPosition(eg_point_rocherath), true)

	
	-- assign base buildings to groups
	EGroup_Clear(eg_temp)
	Player_GetAllEntitiesNearMarker(player1, eg_temp, mkr_playerBase_target)
	EGroup_Filter(eg_temp, EBP.AEF.RIFLE_COMMAND_MP, FILTER_REMOVE, eg_hq)
	EGroup_Filter(eg_temp, EBP.AEF.ARMORED_RIFLE_COMMAND_MP, FILTER_REMOVE, eg_lieutenantbuilding)
	EGroup_Filter(eg_temp, EBP.AEF.COMPANY_WEAPONS_POOL_MP, FILTER_REMOVE, eg_captainbuilding)
	EGroup_Filter(eg_temp, EBP.AEF.ARMOR_COMMAND_MP, FILTER_REMOVE, eg_majorbuilding)
	EGroup_Filter(eg_temp, EBP.AEF.AEF_WEAPON_RACK_BROWNING_AUTOMATIC_RIFLE_MP, FILTER_REMOVE, eg_weaponsrack_bar)
	EGroup_Filter(eg_temp, EBP.AEF.AEF_WEAPON_RACK_BAZOOKA_MP, FILTER_REMOVE, eg_weaponsrack_bazooka)
	EGroup_Filter(eg_temp, EBP.AEF.AEF_WEAPON_RACK_M1919_LMG, FILTER_REMOVE, eg_weaponsrack_lmg)

	Player_GetAllEntitiesNearMarker(player1, eg_basebuildings, mkr_playerBase_target)
	local list = {
		EBP.AEF.RIFLE_COMMAND_MP,
		EBP.AEF.ARMORED_RIFLE_COMMAND_MP,
		EBP.AEF.COMPANY_WEAPONS_POOL_MP,
		EBP.AEF.ARMOR_COMMAND_MP,
		EBP.AEF.AEF_WEAPON_RACK_BROWNING_AUTOMATIC_RIFLE_MP,
		EBP.AEF.AEF_WEAPON_RACK_BAZOOKA_MP,
		EBP.AEF.AEF_WEAPON_RACK_M1919_LMG,
		EBP.AEF.AEF_MG_NEST_AEF_BASE,
		EBP.AEF.AEF_SUPPLYTENT,
		EBP.AEF.AEF_STORAGEBUNKER,
		EBP.AEF.AEF_GARRISON,
		EBP.AEF.AEF_BARRACKS,
		EBP.AEF.AEF_WEAPON_RACK_M1C_GARAND,
		
	}
	EGroup_Filter(eg_basebuildings, list, FILTER_KEEP)

	
	-- do some upgrades
	Cmd_Upgrade(player1, UPG.AEF.RIFLE_COMMAND_GRENADE_MP, 1, true)
	Modify_SightRadius(eg_point_radiotower, 0.1)
	Modify_UpgradeBuildTime(player1, UPG.AEF.WEAPON_RACK_UPGRADE_MP, 0.5)
	Modify_UpgradeBuildTime(player1, UPG.AEF.FIGHTING_POSITION_MG_ADDITION_MP, 0.5)
	
	-- remove the initial rear echelon	
	Player_GetAll(player1)
	SGroup_Filter(sg_allsquads, SBP.AEF.REAR_ECHELON_SQUAD_MP, FILTER_KEEP)
	SGroup_DestroyAllSquads(sg_allsquads)
	
	-- set up the player as SUPPORT division
	Mission_SwitchCommander(CD_SUPPORT, true)

	-- reset camera (there's a new default, so make sure we're at that instead of the usual angle/declination)
	Camera_ResetToDefault()
	
end



-------------------------------------------------------------------------
-- [[ MISSION START ]]
-------------------------------------------------------------------------
--Called once the intro nis/nislet/sitrep finishes playing.
function Mission_Start()
	
	Game_LoadAtmosphere("data:art/scenarios/presets/atmosphere/xp1/_twin_villages_mid_morning.aps", 600)			-- Start fading atmosphere to the break of dawn
	
--~ 	-- shortcut to airborne section
--~ 	World_IncreaseInteractionStage()
--~ 	Airborne_Init()
--~ 	Rule_AddOneShot(Airborne_Start, 1)
	
--~ 	-- shortcut to mechanized section
--~ 	World_IncreaseInteractionStage()
--~ 	World_IncreaseInteractionStage()
--~ 	World_IncreaseInteractionStage()
--~ 	Mechanized_Init()
--~ 	Rule_AddOneShot(Mechanized_Start, 1)

	Intro_Start()
	
end











-- switch to the any given commander (default NOT instant but with a fade in/out: total time about 2 seconds)
function Mission_SwitchCommander(commander, instant, location)
	
	-- mark a transition as in progress
	g_transition_in_progress = true
	
	-- set some defaults
	instant = instant or false
	location = location or mkr_playerBase_target
	
	local data = {commander = commander, location = location, instant = instant}
	
	if instant == true then
		
		Mission_SwitchCommander_PartB(data)
		
	else
		
		Game_Letterbox(true, 0.75)
		
		Event_Timer(Mission_SwitchCommander_PartB, data, 1)
		Event_Timer(Mission_SwitchCommander_PartC, data, 1.25)
		
	end
	
end
function Mission_SwitchCommander_PartB(data)
	
	-- now things are black, we can switch commander
	XP1_SetActiveCommander(data.commander, false)
	XP1_StopCompanyStatTracking()
	
	-- reset the player's resources
	Player_SetResource(player1, RT_Manpower, t_difficulty.startManpower)
	Player_SetResource(player1, RT_Munition, t_difficulty.startMunition)
	Player_SetResource(player1, RT_Fuel, t_difficulty.startFuel)
	Player_SetResource(player1, RT_Command, 0)
	Player_SetResource(player1, RT_Action, 0)
	
	-- and set the camera to the desired location
	if data.instant == true then
		Camera_FocusOnPosition(Util_GetPosition(data.location), false)				-- no pan
	else
		Camera_MoveTo(Util_GetPosition(data.location), true, 0.10, true, true)		-- with pan (and locks out camera input)
	end
	
end
function Mission_SwitchCommander_PartC(data)

	Player_GetAll(player1)
	SGroup_Filter(sg_allsquads, {SBP.AEF.CAPTAIN_SQUAD_MP, SBP.AEF.LIEUTENANT_SQUAD_MP, SBP.AEF.MAJOR_SQUAD_MP}, FILTER_KEEP)
	SGroup_DestroyAllSquads(sg_allsquads)
	
	if data.instant == true then
		
		g_transition_in_progress = false
		
	else
		
		if Util_GetDistance(Camera_GetCurrentTargetPos(), data.location) < 10 then
			
			Game_Letterbox(false, 0.75)
			Camera_SetInputEnabled(true)
			
			-- show a titlecard for the new commander
			if XP1_GetDivision() == CD_SUPPORT then
				Util_MissionTitle(locid_support_division_long)
			elseif XP1_GetDivision() == CD_AIRBORNE then
				Util_MissionTitle(locid_airborne_division_long)
			elseif XP1_GetDivision() == CD_MECHANIZED then
				Util_MissionTitle(locid_mechanized_division_long)
			end
			
			g_transition_in_progress = false
			
		else
			
			Event_Timer(Mission_SwitchCommander_PartC, data, 0.25)
			
		end
	
	end
end




function Mission_SetProductionItems(availability)

	local list = {
		-- hq
		-- {upg = UPG.AEF.BAR_UPGRADE_MP},
		-- {upg = UPG.AEF.BAZOOKA_UPGRADE_MP},
		{upg = UPG.AEF.WEAPON_RACK_UPGRADE_MP},
		
		-- lieutenant building
		{upg = UPG.AEF.LIEUTENANT_DISPATCHED_UPGRADE_MP},
		{sbp = SBP.AEF.M20_UTILITY_CAR_SQUAD_MP},
		{sbp = SBP.AEF.M15A1_AA_HALFTRACK_SQUAD_MP},
		{sbp = SBP.AEF.M1_57MM_AT_GUN_SQUAD_BOB},
		{sbp = SBP.AEF.DODGE_WC51_50CAL_SQUAD_MP},
		{sbp = SBP.AEF.M2HB_50CAL_HMG_SQUAD_MP},
		{sbp = SBP.AEF.LIEUTENANT_SQUAD_MP},
		
		-- captain building
		{upg = UPG.AEF.CAPTAIN_DISPATCHED_UPGRADE_MP},
		{sbp = SBP.AEF.M1_57MM_AT_GUN_SQUAD_MP},
		{sbp = SBP.AEF.M1_75MM_PACK_HOWITZER_SQUAD_MP},
		{sbp = SBP.AEF.M1_81MM_MORTAR_SQUAD_MP},
		{sbp = SBP.AEF.M5A1_STUART_SQUAD_MP},
		{sbp = SBP.AEF.ASSAULT_ENGINEER_SQUAD_MP},
		{sbp = SBP.AEF.CAPTAIN_SQUAD_MP},
		
		-- major building
		{upg = UPG.AEF.MAJOR_DISPATCHED_UPGRADE_MP},
		{sbp = SBP.AEF.M4A3_76MM_SHERMAN_BULLDOZER_SQUAD_MP},
		{sbp = SBP.AEF.M4A3_76MM_SHERMAN_SQUAD_MP},
		{sbp = SBP.AEF.M4A3_SHERMAN_SQUAD_MP},
		{sbp = SBP.AEF.M8A1_HMC_SQUAD_MP},
		{sbp = SBP.AEF.M36_TANK_DESTROYER_SQUAD_MP},
		{sbp = SBP.AEF.MAJOR_SQUAD_MP},
	}

	for index, item in pairs(list) do
		if item.sbp ~= nil then
			Player_SetSquadProductionAvailability(player1, item.sbp, availability)
		elseif item.upg ~= nil then
			Player_SetUpgradeAvailability(player1, item.upg, availability)
		end
	end
	
end





function __DoNothing()
end

