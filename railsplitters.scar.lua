print("\tLoading mission file...")
-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- Railsplitters - Recreates the Battle of the Bulge on a smaller scale by using encounters to set up an aggressive German attack that put both teams' bases in jeopardy
-- Designer: Jim Dodge........wrapped up by Matt P.
-------------------------------------------------------------------------
-------------------------------------------------------------------------

import("ScriptSetup.scar") -- <== ### CRITICAL ELEMENT. 
import("XP1.scar")				-- Ardennes Assault functionality

-- [[ Objective files ]]
import("Railsplitters_obj_BaseDestruction.scar")

-- [[ Encounter data ]]
import("Railsplitters_encounters.scar")



-------------------------------------------------------------------------
-- [[ MISSION SETUP ]]
-------------------------------------------------------------------------
-- Initializes players
function Mission_SetupPlayers()
	-- Not used in battles
end


-- Defines key mission data and any global values used throughout the mission.
function Mission_SetupVariables()
	print("Initializing mission DATA...")
	print("LOADING BATTLE: Railsplitters")
	

	if Marker_Exists("mkr_mapidentifier_marche", "") then	-- add some extra stuff to do with beginner hints IF and ONLY IF we are playing on Marche
		import("Libraries/BattleExtras/XP1_Marche_BeginnerHintSetup.scar")
		Marche_StartUpBeginnerHints("Railsplitters")
	end
	
	
	-- ### CRITICAL ELEMENT. This table contains all the initialization data for the mission.
	g_missionData = {
		useBeginnerHints = false,					-- Whether or not to use the BeginnerHint system
		useEncounterSystem = false,					-- Whether or not to use the Encounter system
		useXP1Difficulty = true,					-- Whether or not this mission uses the XP1 Difficulty system
		missionType = MT_XP1_BATTLE,				-- What Mission Type is this mission? MT_
		introNIS = nil,			 					-- Movie filename
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
			OBJ_Victory,							-- These are the global references to the objective tables defined in the separate files.
		},
		atmosphere = nil,
		startingUnits = {							-- Units to be spawned for P1 on mission start. Follows same parameters as Encounters.

		--ADD THESE BACK IN FOR EASY MODE $$$ 

		
----------------------------------------------------------------------------------------------Starting Units--------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--~ 			{
--~ 				sbp = SBP.AEF.M20_UTILITY_CAR_SQUAD_MP,
--~ 				spawn = Util_GetOffsetPosition(mkr_assault_player_defense_01, OFFSET_FRONT_RIGHT, 5),
--~ 			},
			{
				sbp = SBP.AEF.M1_75MM_PACK_HOWITZER_SQUAD_MP,
				spawn = mkr_assault_player_defense_01,
--~ 				slotItems = {SLOT_ITEM.BAZOOKA_MP},
			},
			{
				sbp = SBP.AEF.M2HB_50CAL_HMG_SQUAD_MP,
				spawn = mkr_tankGrab_crewSpawn_02,
			},
			{
				sbp = SBP.AEF.RIFLEMEN_SQUAD_MP,
				spawn = Util_GetOffsetPosition(mkr_tankGrab_crewSpawn_03, OFFSET_BACK, 5),
			},
		},
	}
	
	--Dynamic difficulty
	--PM_PL_StartingVP = true
	--PM_PL_StartingResourceHit = true
	
	--[[GLOBAL VARIABLES]]
	i_destroyedTrucks = 0 --incremented in OnGermanBaseDestroyed()
	i_destroyToWin = 2 --added to node strength --proven but commented out for now
	
	
	--~ 		EBP.WEST_GERMAN.WEST_GERMAN_HQ_WRECK_MP,
--~ 		EBP.WRECKED_VEHICLES.WRECKED_BASE_BUILDING01,
--~ 		EBP.WRECKED_VEHICLES.WRECKED_BASE_BUILDING01_SELF_DESTRUCT,
--~ 		EBP.WRECKED_VEHICLES.WRECKED_BASE_BUILDING02,
--~ 		EBP.WRECKED_VEHICLES.WRECKED_BASE_BUILDING02_SELF_DESTRUCT,
--~ 		EBP.WRECKED_VEHICLES.WRECKED_BASE_BUILDING03,
--~ 		EBP.WRECKED_VEHICLES.WRECKED_BASE_BUILDING03_SELF_DESTRUCT,
--~ 		EBP.WRECKED_VEHICLES.WRECKED_HALFTRACK_SWS,
	t_ebp_destroyToWin = {
		"heavy_armor_support_mp",
		"infantry_support_mp",
		"light_armor_support_mp",
		"west_german_hq_mp",
		"sws_halftrack_mp",
		"infantry_support_preplaced",
		"light_armor_support_preplaced",
		"heavy_armor_support_preplaced",
	}
	t_ebp_protectOrLose = {
		"armored_rifle_command_mp",
		"armor_command_mp",
		"company_weapons_pool_mp",
		"rifle_command_mp",
	}
--~ 	eg_germanWounded = EGroup_CreateIfNotFound("eg_germanWounded")
--~ 	t_germanBasePositions = {
--~ 		Marker_GetPosition(mkr_hardpoint_vp_02_frontDefense),
--~ 		Marker_GetPosition(mkr_hardpoint_vp_02_rearDefense),
--~ 		Marker_GetPosition(mkr_hardpoint_vp_02_overwatch),
--~ 	}
	--sg_allTrucksInMobilePhase = SGroup_CreateIfNotFound("sg_allTrucksInMobilePhase")
	eg_infantryTruck = EGroup_CreateIfNotFound("eg_infantryTruck")
	eg_lightArmourTruck = EGroup_CreateIfNotFound("eg_lightArmourTruck")
	eg_heavyArmourTruck = EGroup_CreateIfNotFound("eg_heavyArmourTruck")
	b_cannotBeUnseen = false
	b_giveHint = false
	b_endOfDialogue = false
	b_oneMoreChance = true
	b_introSequence = true
	sg_flakSpotters = SGroup_CreateIfNotFound("sg_flakSpotters")
	sg_sws_01 = SGroup_CreateIfNotFound("sg_sws_01") --should go to position and change to medic station after difficulty dependant delay
	sg_sws_02 = SGroup_CreateIfNotFound("sg_sws_02") --goes to position and stays as sWS
	t_retributionCallInFunctions = {
		--declare encounters here without spawning them
	}
	germanFuelRate = 1
	germanMunitionsRate = 1 
	germanManpowerRate = 1
	id_mineHint = 0
	i_initialAttackers = 1
	g_sbp_initialAttackers = SBP.WEST_GERMAN.KUBELWAGEN_SQUAD_MP
	sg_initialAttackers = SGroup_CreateIfNotFound("sg_initialAttackers")
	i_initialAttackDelay = 45
	b_reportFollowUp = false
	b_attackSequence = false
	sg_scouts = SGroup_CreateIfNotFound("sg_scouts")
	sg_ober1 = SGroup_CreateIfNotFound("sg_ober1")
	sg_ober2 = SGroup_CreateIfNotFound("sg_ober2")
	sg_ober3 = SGroup_CreateIfNotFound("sg_ober3")
	sg_ober4 = SGroup_CreateIfNotFound("sg_ober4")
	
	sg_already_vet = SGroup_CreateIfNotFound("sg_already_vet")	-- group for units we have already given veterancy to
	
	s_player2ai = AIPlayer_GetLocalFromPlayer(player2)
 

--~ 	i_timeOfSighting
	--[[MAP GROUPS]]
	
	
end

-- Defines difficulty tables/tuning variables
function Mission_SetDifficulty(diffVal)
	--TODO: Define any difficulty-related settings or variables.
	-- These variables should be stored in a t_difficulty table for readability and access.
	
	g_difficulty = diffVal or Game_GetSPDifficulty() 	-- Note: Having the diffVal parameter allows for redefining difficulty settings during runtime.
	AI_OverrideDifficulty(g_difficulty)
	
	--Global difficulty table
	t_difficulty = {

		startingManpower = Util_DifVar(
		{
			XP1_NodeDif({400, 400, 400, 400, 400}), --easy
			XP1_NodeDif({260, 260, 260, 260, 260}), --medium
			XP1_NodeDif({200, 200, 200, 200, 200}), --hard
		}, g_difficulty),
		startingMunitions = Util_DifVar(
		{
			XP1_NodeDif({240, 240, 240, 240, 240}), --easy
			XP1_NodeDif({200, 200, 200, 200, 200}), --medium
			XP1_NodeDif({120, 120, 120, 120, 120}), --hard
		}, g_difficulty),
		startingFuel = Util_DifVar(
		{
			XP1_NodeDif({120, 120, 120, 120, 120}), --easy
			XP1_NodeDif({90, 90, 90, 90, 90}), --medium
			XP1_NodeDif({60, 60, 60, 60, 60}),      --hard
		}, g_difficulty),

	}
	--original objective alteration by node strength
	--i_destroyToWin = i_destroyToWin + XP1_GetNodeStrength()
	
	--Easy
	if g_difficulty == GD_EASY then
		Util_CreateSquads(player1, nil, SBP.AEF.M1_57MM_AT_GUN_SQUAD_MP, Util_GetOffsetPosition(mkr_tankGrab_crewSpawn_01, OFFSET_FRONT_LEFT, 5)) --gives easy player the most-cost effective units to take out trucks
		Util_CreateSquads(player1, nil, SBP.AEF.M1_57MM_AT_GUN_SQUAD_MP, Util_GetOffsetPosition(mkr_tankGrab_crewSpawn_01, OFFSET_FRONT_RIGHT, 5)) --gives easy player the most-cost effective units to take out trucks
		i_destroyToWin = i_destroyToWin + 1
		germanManpowerRate = 1.05
		germanFuelRate = 1.2
		germanMunitionsRate = 1
		--buildings
		Util_CreateEntities(player2, eg_infantryTruck,    EBP.WEST_GERMAN.INFANTRY_SUPPORT_MP,    mkr_railsplitters_flak_02, 1)
		Util_CreateEntities(player2, eg_heavyArmourTruck, EBP.WEST_GERMAN.HEAVY_ARMOR_SUPPORT_MP, mkr_railsplitters_flak_01,  1) --replaces flak truck from original setup
		Util_CreateSquads(player2, sg_sws_01, SBP.WEST_GERMAN.SWS_HALFTRACK_SQUAD_MP, mkr_railsplitters_encounter_01, mkr_railsplitters_medic_01, 1) --should go to position and change to medic station after long delay
		AI_LockSquads(player2, sg_sws_01)
		Modify_UnitSpeed(sg_sws_01, 0.5)
	--Medium
	elseif g_difficulty == GD_NORMAL then
		Util_CreateSquads(player1, nil, SBP.AEF.M1_57MM_AT_GUN_SQUAD_MP, Util_GetOffsetPosition(mkr_tankGrab_crewSpawn_01, OFFSET_FRONT_RIGHT, 5)) --gives easy player the most-cost effective units to take out trucks
		i_destroyToWin = i_destroyToWin + 2
		i_initialAttackers = 2
		germanManpowerRate = 1.10 --1.15
		germanFuelRate = 1.3 --1.4
		germanMunitionsRate = 1.4 --1.4
		--buildings
		Util_CreateEntities(player2, eg_infantryTruck,    EBP.WEST_GERMAN.INFANTRY_SUPPORT_PREPLACED, EntityQuery_FindClosestOpenPositionForStructure(s_player2ai, EBP.WEST_GERMAN.INFANTRY_SUPPORT_PREPLACED, Marker_GetPosition(mkr_railsplitters_flak_01)), 1)
		Util_CreateSquads(player2, sg_sws_02, SBP.WEST_GERMAN.SWS_HALFTRACK_SQUAD_MP, Util_GetOffsetPosition(mkr_railsplitters_encounter_01, OFFSET_BACK, 15), mkr_railsplitters_flak_02, 1) --goes to position and stays as sWS
		Util_CreateSquads(player2, sg_sws_01, SBP.WEST_GERMAN.SWS_HALFTRACK_SQUAD_MP, mkr_railsplitters_encounter_01, mkr_railsplitters_medic_01, 1) --should go to position and change to medic station after short delay
		AI_LockSquads(player2, sg_sws_02)
		AI_LockSquads(player2, sg_sws_01)
		AI_LockSquads(player2, sg_sws_02)
		Modify_UnitSpeed(sg_sws_01, 0.5)
	--Hard
	elseif g_difficulty == GD_HARD  then
--~ 		Util_CreateEntities(player2, eg_infantryTruck, EBP.WEST_GERMAN.INFANTRY_SUPPORT_MP, mkr_railsplitters_flak_02, 1) --creates a second flak truck to push the challenge to its limits
		i_destroyToWin = i_destroyToWin + 3
		i_initialAttackers = 2
		germanManpowerRate = 1.15
		germanFuelRate = 1.35 --1.4
		germanMunitionsRate = 1.5
		g_sbp_initialAttackers = SBP.WEST_GERMAN.ARMORED_CAR_SDKFZ_234_SQUAD_MP
		--buildings
		Util_CreateEntities(player2, eg_infantryTruck,    EBP.WEST_GERMAN.INFANTRY_SUPPORT_PREPLACED, EntityQuery_FindClosestOpenPositionForStructure(s_player2ai, EBP.WEST_GERMAN.INFANTRY_SUPPORT_PREPLACED, Marker_GetPosition(mkr_railsplitters_flak_01)), 1)
--~ 		if XP1_GetNodeStrength() >= 4 then
--~ 			Util_CreateEntities(player2, nil,    EBP.WEST_GERMAN.INFANTRY_SUPPORT_MP,    mkr_railsplitters_flak_02, 1)
--~ 		else
--~ 			Util_CreateEntities(player2, sg_sws_02, SBP.WEST_GERMAN.SWS_HALFTRACK_SQUAD_MP, Util_GetOffsetPosition(mkr_railsplitters_encounter_01, OFFSET_BACK, 15), mkr_railsplitters_flak_02, 1) --goes to position and stays as sWS
--~ 			AI_LockSquads(player2, sg_sws_02)
--~ 		end
		Util_CreateEntities(player2, eg_heavyArmourTruck, EBP.WEST_GERMAN.HEAVY_ARMOR_SUPPORT_PREPLACED, EntityQuery_FindClosestOpenPositionForStructure(s_player2ai, EBP.WEST_GERMAN.HEAVY_ARMOR_SUPPORT_PREPLACED, Marker_GetPosition(mkr_railsplitters_medic_01)),  1) --replaces  an encounter that moves in front of the flak truck in other difficulties
		
		Util_CreateSquads(player2, sg_sws_01, SBP.WEST_GERMAN.SWS_HALFTRACK_SQUAD_MP, mkr_railsplitters_encounter_01, mkr_railsplitters_medic_01, 1) --should go to position and change to medic station after short delay
		b_introSequence = false
	end
	--Adds units near HQ Trucks
	if XP1_GetNodeStrength() >= 4 then
		local sg_mg = SGroup_CreateIfNotFound("sg_mg")
		Util_CreateSquads(player2, sg_mg, SBP.WEST_GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD_WG_MP, mkr_railsplitters_encounter_02) --static
		AI_LockSquads(player2, sg_mg)
--~ 		Util_CreateSquads(player2, nil, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, mkr_railsplitters_encounter_01, mkr_railsplitters_flak_01, 2) --roaming
	end
	if XP1_GetNodeStrength() >= 4 and not  g_difficulty == GD_EASY then
		--scouting encounter on medium and hard strength only because it takes away the starting AT guns from easy players and delays their ability to attack trucks until much later
		ENCOUNTERS.ai_scout_01()
	end
	if XP1_GetNodeStrength() == 5 then
		local sg_capitan = SGroup_CreateIfNotFound("sg_capitan")
		Util_CreateSquads(player2, sg_ober1, SBP.WEST_GERMAN.OBERSOLDATEN_SQUAD_MP, Util_GetOffsetPosition(mkr_reverseHardpoint_innerVP_def02, OFFSET_LEFT, World_GetRand(5, 10) ) ) --static
--~ 		Util_CreateSquads(player2, sg_ober2, SBP.WEST_GERMAN.OBERSOLDATEN_SQUAD_MP, Util_GetOffsetPosition(mkr_railsplitters_medic_01, OFFSET_FRONT_LEFT, World_GetRand(10, 15) ) ) --static
--~ 		Util_CreateSquads(player2, sg_ober3, SBP.WEST_GERMAN.OBERSOLDATEN_SQUAD_MP, Util_GetOffsetPosition(mkr_railsplitters_flak_01, OFFSET_BACK_RIGHT, World_GetRand(10, 15) ) ) --static
--~ 		Util_CreateSquads(player2, sg_ober4, SBP.WEST_GERMAN.OBERSOLDATEN_SQUAD_MP, Util_GetOffsetPosition(mkr_railsplitters_flak_02, OFFSET_RIGHT, World_GetRand(10, 15) ) ) --static
--~ 		Util_CreateSquads(player2, sg_capitan, SBP.WEST_GERMAN.FIELD_OFFICER_SQUAD_MP, Util_GetOffsetPosition(mkr_railsplitters_flak_02, OFFSET_BACK, World_GetRand(5, 10) ) ) --roaming
		AI_LockSquads(player2, sg_ober1)
		AI_LockSquads(player2, sg_ober2)
		AI_LockSquads(player2, sg_ober3)
		AI_LockSquads(player2, sg_ober4)
		--AI_LockSquads(player2, sg_capitan))  --static currently off
		
--~ 		Util_CreateSquads(player2, nil, SBP.WEST_GERMAN.URBAN_ASSAULT_LIGHT_INFANTRY, mkr_railsplitters_encounter_01, mkr_railsplitters_flak_01, 3) --roaming
	end
	--EGroup_InstantCaptureStrategicPoint(eg_reverseHardpoint_aiCPs, player2) -- replace with capture nearest territory points as implemented in Training Grounds 
--~ 	CaptureNearbyTerritories( XP1_GetNodeStrength() )
end

-- Sets restrictions on units, teams, etc. $$$THE SCRIPT BELOW REQUIRES REFERENCE TO PLAYERS SET UP IN [[ MISSION START ]]
function Mission_SetupRestrictions()
	--TODO: Set any tech/ability restrictions on a players, as well as resource limits.
	--	Note: Resource Income/Caps should be defined in Mission_SetDifficulty()
	
	--[[ HUMAN PLAYER ]]
	--~ 	Player_SetEntityProductionAvailability(player1, EBP.SOVIET.IS_2_HEAVY_TANK, ITEM_REMOVED)
	Player_SetResource(player1, RT_Manpower, t_difficulty.startingManpower)
	Player_SetResource(player1, RT_Munition, t_difficulty.startingMunitions)
	Player_SetResource(player1, RT_Fuel, t_difficulty.startingFuel)

	--[[ ALLIED PLAYER ]]
	
	
	
	--[[ ENEMY PLAYER ]]
--~ 	Player_SetMaxCapPopulation(player2, CT_Personnel, 200) --Basic Tuning Values for this mode
--~ 	Player_SetMaxCapPopulation(player2, CT_Vehicle, 140) --Basic Tuning Values for this mode
--~ 	Player_SetMaxPopulation(player2, CT_Personnel, 200) --Basic Tuning Values for this mode
--~ 	Player_SetMaxPopulation(player2, CT_Vehicle, 160) --Basic Tuning Values for this mode

--~ 	Modify_PlayerResourceRate(player2, RT_Manpower, germanFuelRate, MUT_Multiplication) --Basic Tuning Values for this mode
--~ 	Modify_PlayerResourceRate(player2, RT_Munition, germanMunitionsRate, MUT_Multiplication) --Basic Tuning Values for this mode
--~ 	Modify_PlayerResourceRate(player2, RT_Fuel, germanFuelRate, MUT_Multiplication) --Basic Tuning Values for this mode
	


	
end

-- Sets up the map before the mission starts (starting units, ownership, etc.)
function Mission_Preset()
	--Locate all the victory points and create a group for them so we can destroy all victory forever
	local _vPoints = EGroup_CreateIfNotFound("_vPoints")
	World_GetStrategyPoints(_vPoints, true)
	EGroup_Filter(_vPoints, BP_GetEntityBlueprint("victory_point"), FILTER_KEEP)
	EGroup_DestroyAllEntities(_vPoints)
end


-------------------------------------------------------------------------
-- [[ MISSION START ]]
-------------------------------------------------------------------------
function Override_Player_Setup() --Use this if you want to reference players by player1 and player2
	local playerCount = World_GetPlayerCount()
	
	for i = 1, playerCount do
		local index = i
		if Player_IsHuman(World_GetPlayerAt(index)) then
			player1 = World_GetPlayerAt(index)
		else
			player2 = World_GetPlayerAt(index)
		end
	end
end

--Called once the intro nis/nislet/sitrep finishes playing.
function Mission_Start()
	
	AI_SetPersonality(player2, "botb_skirmish_railsplitters")
	
	Objective_Start(OBJ_Victory)

	Rule_AddGlobalEvent(ScoreEvent, GE_EntityKilled)

	--capture a point to allow medic HQ to build
	Util_CreateSquads(player2, sg_scouts, SBP.WEST_GERMAN.JAEGER_LIGHT_INFANTRY_RECON_SQUAD_MP, Util_GetOffsetPosition(mkr_railsplitters_flak_01,OFFSET_RIGHT, 10), World_GetTerritorySectorPosition( World_GetTerritorySectorID(Marker_GetPosition(mkr_railsplitters_encounter_02))), 1)
	AI_LockSquads(player2, sg_scouts)
	SpawnMoreEnemyBuildings()

	Cmd_Upgrade(player2, UPG.WEST_GERMAN.FIRST_SWS_HALFTRACK_LOCKOUT)

	Rule_AddInterval(RailsplittersUpdate, 1)
	Rule_AddInterval(PlayerHQAlert, 1)
	
	NodeUnitRestrictions1() ----restricts certain ai units at different node strengths
	
	AirSupport() ----adds commander air support abilities based on node strengths

	
	-- grant veterancy to all units the ai produces based on node strength
	
	Rule_AddInterval(GrantEnemyVeterancy, 1)
	
	Support() ------grants different support units based on node strength
	Update_Scoreboard()	
	
end
	
function SpawnMoreEnemyBuildings() --once the location of all building spawns now it only spawns the radar truck building that is consistent between easy/medium/hard. see other buildings in difficulty settings.
--~ 	--Util_CreateSquads(player2, nil, SBP.WEST_GERMAN.SWS_HALFTRACK_SQUAD_MP, mkr_reverseHardpoint_lightArmourSupport, 1)
--~ 	Util_CreateEntities(player2, eg_infantryTruck,    EBP.WEST_GERMAN.INFANTRY_SUPPORT_MP,    mkr_railsplitters_flak_01, 1)
--~ 	Util_CreateEntities(player2, sg_sws_02, SBP.WEST_GERMAN.SWS_HALFTRACK_SQUAD_MP, Util_GetOffsetPosition(mkr_railsplitters_encounter_01, OFFSET_BACK, 15), mkr_railsplitters_flak_01, 1) --goes to position and stays as sWS
--~ 	--Util_CreateEntities(player2, nil,    EBP.WEST_GERMAN.INFANTRY_SUPPORT_MP,    mkr_railsplitters_flak_02, 1)
	Util_CreateEntities(player2, eg_lightArmourTruck, EBP.WEST_GERMAN.LIGHT_ARMOR_SUPPORT_PREPLACED, EntityQuery_FindClosestOpenPositionForStructure(s_player2ai, EBP.WEST_GERMAN.LIGHT_ARMOR_SUPPORT_PREPLACED, Marker_GetPosition(mkr_railsplitters_radar_01)), 1)  --this is always placed in the same way ignoring difficulty
--~ 	Util_CreateEntities(player2, eg_heavyArmourTruck, EBP.WEST_GERMAN.HEAVY_ARMOR_SUPPORT_MP, mkr_railsplitters_medic_01,  1) --replaced with an encounter that moves in front of the flak truck
--~ 	Util_CreateSquads(player2, sg_sws_01, SBP.WEST_GERMAN.SWS_HALFTRACK_SQUAD_MP, mkr_railsplitters_encounter_01, mkr_railsplitters_medic_01, 1) --should go to position and change to medic station
	--Cmd_Ability(eg_infantryTruck, CONSTRUCT_INFANTRY_BARRACKS, mkr_hardpoint_vp_02_frontDefense, nil, false) --flak
	--Cmd_Ability(eg_heavyArmourTruck, CONSTRUCT_TANK_COMMAND, mkr_hardpoint_vp_02_overwatch, nil, false) --schwerer
--~ 	AI_LockSquads(player2, sg_sws_01)
--~ 	AI_LockSquads(player2, sg_sws_02)
--~ 	Modify_UnitSpeed(sg_sws_01, 0.5)
end

function RailsplittersUpdate() -- gives player text cues when trucks are sighted, except if they are first sighted by recon run (the player will not get intel related to finding the trucks because they know already)
	if b_introSequence then
		OnSightingFirstSWS()
		-- Check if the first SWS truck squad exists.  Player has a good chance of kill the SWS truck before the scout infantry is able to capture the territory.
		if SGroup_Count("sg_sws_01") > 0 then
  		if World_DistanceSGroupToPoint(sg_sws_01, Marker_GetPosition(mkr_railsplitters_medic_01), true) < 10 and World_IsTerritorySectorOwnedByPlayer(player2, World_GetTerritorySectorID(Marker_GetPosition(mkr_railsplitters_encounter_02)) ) then
  			Cmd_Ability(sg_sws_01, ABILITY.WEST_GERMAN.CONSTRUCT_ARMORED_INFANTRY_COMMAND, mkr_railsplitters_medic_01, mkr_railsplitters_encounter_02, false) --medic --PUT WAYNE'S CODE HERE $$$
  			b_introSequence = false
  			AI_UnlockSquads(player2, sg_scouts)
  		end
 	  else -- medic SWS truck is already dead
        b_introSequence = false
        AI_UnlockSquads(player2, sg_scouts)
		end
	end
--~ 	OnSightingInitialAttackers()
	local sg_major = SGroup_Create("sg_major")
	Player_GetAll(player1)
	if not flyoverCheck then
		SGroup_Filter(sg_allsquads, SBP.AEF.MAJOR_SQUAD_MP, FILTER_REMOVE, sg_major)
		--if the player uses either of the abilities below, then many lines of dialogue do not appear
		if not SGroup_IsEmpty(sg_major) and ( Squad_IsDoingAbility(SGroup_GetSpawnedSquadAt(sg_major, 1), ABILITY.AEF.MAJOR_QUICK_RECON_RUN) or Squad_IsDoingAbility(SGroup_GetSpawnedSquadAt(sg_major, 1), ABILITY.AEF.MAJOR_QUICK_RECON_RUN_IMPROVED) ) then
			flyoverCheck = true
		end
		OnSightingFlakTruck()
		OnSightingRadarTruck()
	end
	SGroup_Destroy(sg_major)
end

function ScoreEvent(entityVictim, entityKiller)
	-- make sure everything is valid
	if entityVictim ~= nil and entityKiller ~= nil then
		if Entity_IsValid(Entity_GetGameID(entityVictim)) and Entity_IsValid(Entity_GetGameID(entityKiller)) then
			-- FRIENDLY FIRE STILL ALLOWS THE OTHER TEAM TO SCORE
			-- check the victim is of the appropriate EBP
			local ebp_victim = BP_GetName(Entity_GetBlueprint(entityVictim))
			print(ebp_victim)
			if Table_Contains(t_ebp_destroyToWin, ebp_victim) then 
				OnGermanBaseDestroyed()
--~ 				Retribution()
--~ 			elseif Table_Contains(t_ebp_protectOrLose, ebp_victim) then
--~ 				OnUSBaseDestroyed()
			end
		end
	end
end

--~ function OnUSBaseDestroyed()
--~ 	if b_oneMoreChance then
--~ 		--Util_StartQuickIntel( "Icons_portraits_dialogue_aef_officer_lieutenant_s_portrait" , LOC("Me and my men are getting ourselves out of here if any more buildings get destroyed. And that's it.")  )
--~ 		Util_StartIntel(EVENTS.Near_Losing)
--~ 		b_oneMoreChance = false
--~ 	else
--~ 		 Objective_Fail(OBJ_Victory, true, false)
--~ 	end
--~ end

function OnGermanBaseDestroyed()
	i_destroyedTrucks = i_destroyedTrucks + 1
	--update Objective title
--~ 	local newString = "Destroy " .. tostring(i_destroyToWin - i_destroyedTrucks) .. " German Command Trucks to halt their advance"
--~ 	if (i_destroyToWin - i_destroyedTrucks) > 1 then 
--~ 		Objective_UpdateText(OBJ_Victory, LOC(newString), nil, true)
--~ 	else
	if (i_destroyToWin - i_destroyedTrucks) == 1 then 
		Util_StartIntel(EVENTS.Near_Winning)
--~ 		Objective_UpdateText(OBJ_Victory, LOC("Destroy one more German Command Truck to halt their advance"), nil, true)
--~ 	elseif (i_destroyToWin - i_destroyedTrucks) < 0 then
--~ 		fatal("attempting to update the main objective after main objective has been completed")
	end
	
	Objective_SetCounter(OBJ_Victory, i_destroyedTrucks, i_destroyToWin)
	Update_Scoreboard()
	
end

function InitialAttack()
	for i = 1, i_initialAttackers do
		local sg_addThisToGroup = SGroup_Create("sg_addThisToGroup")
		--the attackers target a point past the minefield marker mkr_railsplitters_encounter_04 in the direction that marker is facing so reposition it to align with where attackers are coming from
		Util_CreateSquads(player2, sg_addThisToGroup, g_sbp_initialAttackers, mkr_reverseHardpoint_point2, Util_GetRandomPosition(Util_GetOffsetPosition(mkr_railsplitters_encounter_04, OFFSET_FRONT, 10), 15), 1) 
		SGroup_AddGroup(sg_initialAttackers, sg_addThisToGroup)
		SGroup_Destroy("sg_addThisToGroup")
	end
	AI_LockSquads(player2, sg_initialAttackers)
	Modify_UnitSpeed(sg_initialAttackers, 0.66)
	--consider decreasing rate of fire for sg_initialAttackers
	b_attackSequence = true
end

function Retribution() --described but not implemented because may not be needed with proper difficulty tuning

	--create an encounter that spawns near the German base and moves towards mkr_railsplitters_encounter_01 every time a german base is destroyed
--~ 	if not Game_GetSPDifficulty() == 0 then
	-- use t_sbp_retributionCallIns and direct them to mkr_railsplitters_encounter_03 (strategic entry point to player base) or mkr_railsplitters_encounter_04 (directly at the player base)
	--can give armour if i_destroyedTrucks >3
	-- otherwise give glass cannons like infantry with panzershreks and infantry support guns, also units that try to steal team weapons from the player
		if i_destroyedTrucks == 1 then
			ENCOUNTERS.ai_retribution_01()
			if SGroup_Exists("sg_ober3") then
				AI_UnlockSquads( player2, sg_ober3 ) --"guarding" sg_sws_02 but set free so they do not guard empty area when the truck moves away
			end
			if SGroup_Exists("sg_sws_02") then
				AI_UnlockSquads( player2, sg_sws_02 )
			end
		elseif i_destroyedTrucks == 2 then
--~ 			ENCOUNTERS.ai_retribution_02()
			ENCOUNTERS.ai_retribution_03()
		elseif i_destroyedTrucks == 3 then
--~ 			ENCOUNTERS.ai_retribution_03()
			ENCOUNTERS.ai_retribution_04()
		elseif i_destroyedTrucks == 4 then
--~ 			ENCOUNTERS.ai_retribution_04()
			ENCOUNTERS.ai_retribution_05()
--~ 		elseif i_destroyedTrucks == 5 then
--~ 			ENCOUNTERS.ai_retribution_05()
		end
--~ 	else print("easy mode")
--~ 	end
end

function OnSightingFlakTruck()
	
	if not b_cannotBeUnseen and EGroup_Exists("eg_infantryTruck") and Player_CanSeeEGroup(player1, eg_infantryTruck, false) then
		Util_StartIntel(EVENTS.Strategy_Hint) --Util_StartQuickIntel( "Icons_portraits_dialogue_aef_riflemen_01_s_portrait" , LOC("Shit, that Flak Truck is gonna eat us alive!")  )
		b_cannotBeUnseen = true
--~ 		b_giveHint = true --move this elsewhere $$$ but requires this line to be spoken first
--~ 		
--~ 		--get player units within a wide perimeter from the flak truck
--~ 		Player_GetAllSquadsNearMarker(player1, sg_flakSpotters, mkr_railsplitters_flak_01, 80) --does not handle rear flak truck elegantly because it does not use mkr_railsplitters_flak_02
--~ 		
--~ 	elseif b_giveHint then 
--~ 		if not SGroup_IsAlive(sg_flakSpotters) then --bool prevents elseif statement from failing with an empty SGroup
--~ 			Util_StartQuickIntel( "Icons_portraits_dialogue_aef_officer_lieutenant_s_portrait" , LOC("Let's find a way around that Flak Truck, sir. We could route them from here.")  )
--~ 			Rule_AddOneShot(ShowReport, 2)
--~ 			b_giveHint = false
--~ 		elseif tonumber(World_DistanceSGroupToPoint(sg_flakSpotters, Marker_GetPosition(mkr_railsplitters_flak_01), true)) > 80 then
--~ 			Util_StartQuickIntel( "Icons_portraits_dialogue_aef_officer_lieutenant_s_portrait" , LOC("Let's find a way around that Flak Truck, sir. We could route them from here.")  )
--~ 			Rule_AddOneShot(ShowReport, 2)
--~ 			b_giveHint = false
--~ 		end
	Event_Proximity(FollowUpReport, {filterlist = LIST.AIRCRAFT, filtertype = FILTER_REMOVE}, player1, mkr_railsplitters_hint, 40, ANY)
	end
	
end

function OnSightingRadarTruck()
	if not b_endOfDialogue and EGroup_Exists("eg_infantryTruck") and EGroup_Exists("eg_lightArmourTruck") and Player_CanSeeEGroup(player1, eg_lightArmourTruck, true) then --and not b_giveHint 
		Util_StartIntel(EVENTS.Explain_Retribution) -- Util_StartQuickIntel( "Icons_portraits_dialogue_aef_riflemen_01_s_portrait" , LOC("Get that truck quick, and then let's defend our base! My gut says there will be hell to pay for taking out their command trucks.")  )
		b_endOfDialogue = true
	end
end

function OnSightingInitialAttackers() --does not work as intended, initial attackers roll past when player sees them before their destination (but this is ok for now)
	if b_attackSequence and SGroup_Exists("sg_initialAttackers") and not SGroup_IsEmpty(sg_initialAttackers) and World_DistanceSGroupToPoint(sg_initialAttackers, Marker_GetPosition(mkr_railsplitters_encounter_04), true) > 100 and Player_CanSeeSGroup(player1, sg_initialAttackers, false) then 
		AI_UnlockSquads(player2, sg_initialAttackers)
		Modify_UnitSpeed(sg_initialAttackers, 1)
		b_attackSequence = false
--~ 		Objective_RemoveUIElements(OBJ_Victory, id_mineHint)
	elseif b_attackSequence and World_DistanceSGroupToPoint(sg_initialAttackers, Marker_GetPosition(mkr_railsplitters_encounter_04), false) < 6 then
		AI_UnlockSquads(player2, sg_initialAttackers)
		Modify_UnitSpeed(sg_initialAttackers, 1)
		b_attackSequence = false
--~ 		Objective_RemoveUIElements(OBJ_Victory, id_mineHint)
	end
end

function OnSightingFirstSWS() --currently broken $$$ the event does not get called any more
	if b_introSequence and SGroup_Exists("sg_sws_01") and Player_CanSeeSGroup(player1, sg_sws_01, false) then
		AI_UnlockSquads(player2, sg_sws_01)
		Modify_UnitSpeed(sg_sws_01, 1)
		--call an event to mention that this is a scoring target
		Util_StartIntel(EVENTS.Explain_Scoring)
		b_introSequence = false
	end
end

function ShowReport()
	prevPingID = UI_CreateMinimapBlip(Marker_GetPosition(mkr_railsplitters_hint), 15, BT_AttackHere)
	Rule_AddOneShot(ClearReport, 15)
	b_reportFollowUp = true
	Rule_RemoveMe()
end

function ClearReport()
	UI_DeleteMinimapBlip(prevPingID)
	Rule_RemoveMe()
end 

function FollowUpReport()
	--call an event to prompt the player upon following lieutenants suggestion
	Util_StartIntel(EVENTS.Follow_Up)
	b_reportFollowUp = false
	Rule_RemoveMe()
end

--these two functions remove dependancies on EGroups
function OrderTerritoriesByDistFromHQ(v1, v2) --accepts EGroups
	if World_DistancePointToPoint(Player_GetStartingPosition(player2), Entity_GetPosition(v1)) < World_DistancePointToPoint(Player_GetStartingPosition(player2), Entity_GetPosition(v2)) then
		return true
	else
		return false
	end
end

function CaptureNearbyTerritories(n)

	local t_entities_territories = {}
	local eg_strategicPoints = EGroup_CreateIfNotFound("eg_strategicPoints")
	World_GetStrategyPoints(eg_strategicPoints, false)
	EGroup_Filter(eg_strategicPoints, BP_GetEntityBlueprint("victory_point"), FILTER_REMOVE) --just to be safe
	
	for index = 1, EGroup_Count(eg_strategicPoints) do
		table.insert(t_entities_territories, EGroup_GetSpawnedEntityAt(eg_strategicPoints, index))
	end
	table.sort( t_entities_territories, OrderTerritoriesByDistFromHQ )
	
	for index = 1, n do
		Entity_InstantCaptureStrategicPoint( t_entities_territories[index], player2 )
	end
	
end


-- Veterancy functions ---------------------------------------------------------------------------------------------------------

-- add veterancy based on node strength
function RandomVeterancy(group, index, squadid)
	
	if SGroup_ContainsSquad(sg_already_vet, Squad_GetGameID(squadid)) == false then
		
		if Squad_GetVeterancyRank(squadid) == 0 then
			Squad_IncreaseVeterancyRank(squadid, XP1_GetNodeStrengthVeterancy(), true)
		end
		
		-- add to list of already vet units so they don't get veterancy again
		SGroup_Add(sg_already_vet, squadid)
	end
end

-- increase veterancy for units produced by ai player
-- called by a rule
function GrantEnemyVeterancy(sgroup, index, squad)
	local	sg_temp = SGroup_CreateIfNotFound("sg_temp")
	Player_GetAll(player2, sg_temp)
	SGroup_ForEach(sg_temp, RandomVeterancy)
end


-- alert to play when player's HQs are getting destroyed
function PlayerHQAlert()
	if EGroup_Count(eg_XP1_player_base) <= 3 then
		Util_StartIntel(EVENTS.Near_Losing)
		Rule_RemoveMe()
	end
end


-------------------------------------------------------------------------------------------------------------------------------------


----------------------------------------------Unit Restrictions on Node Strengths---------------------------------------------

function NodeUnitRestrictions1()

	if XP1_GetNodeStrength() == 1 then
	
	
	------disabled infantry----

		Player_SetSquadProductionAvailability(player2, SBP.WEST_GERMAN.MG34_HEAVY_MACHINE_GUN_SQUAD_MP, ITEM_LOCKED)
		Player_SetSquadProductionAvailability(player2, SBP.WEST_GERMAN.LE_IG_18_INF_SUPPORT_GUN_SQUAD_MP, ITEM_LOCKED)
		Player_SetSquadProductionAvailability(player2, SBP.WEST_GERMAN.OBERSOLDATEN_SQUAD_MP, ITEM_LOCKED)
		Player_SetSquadProductionAvailability(player2, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP, ITEM_LOCKED)
		Player_SetSquadProductionAvailability(player2, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, ITEM_LOCKED)
		
	----disabled armor----
		
		Player_SetSquadProductionAvailability(player2, SBP.WEST_GERMAN.KING_TIGER_SQUAD_MP, ITEM_LOCKED)
		Player_SetSquadProductionAvailability(player2, SBP.WEST_GERMAN.PANTHER_AUSF_G_SQUAD_MP, ITEM_LOCKED)
		Player_SetSquadProductionAvailability(player2, SBP.WEST_GERMAN.STURMTIGER_SQUAD_MP, ITEM_LOCKED)
		Player_SetSquadProductionAvailability(player2, SBP.WEST_GERMAN.JAGDTIGER_TD_SQUAD_MP, ITEM_LOCKED)
		Player_SetSquadProductionAvailability(player2, SBP.WEST_GERMAN.PANZER_II_LUCHS_SQUAD_MP, ITEM_LOCKED)
		
	----disabled base buildings----
		
		Player_SetSquadProductionAvailability(player2, SBP.WEST_GERMAN.FLAK_EMPLACEMENT_BASE, ITEM_LOCKED)
		
	----disabled unit abilities----
	
		Player_SetAbilityAvailability(player2, ABILITY.WEST_GERMAN.VOLKSGRENADIER_GRENADE_MP, ITEM_LOCKED)

		
		
		elseif XP1_GetNodeStrength() == 2 then
		
		------disabled infantry----

		
			Player_SetSquadProductionAvailability(player2, SBP.WEST_GERMAN.OBERSOLDATEN_SQUAD_MP, ITEM_LOCKED)
			Player_SetSquadProductionAvailability(player2, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP, ITEM_LOCKED)
			Player_SetSquadProductionAvailability(player2, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, ITEM_LOCKED)
			
		----disabled armor----

			Player_SetSquadProductionAvailability(player2, SBP.WEST_GERMAN.KING_TIGER_SQUAD_MP, ITEM_LOCKED)
			Player_SetSquadProductionAvailability(player2, SBP.WEST_GERMAN.STURMTIGER_SQUAD_MP, ITEM_LOCKED)
			Player_SetSquadProductionAvailability(player2, SBP.WEST_GERMAN.JAGDTIGER_TD_SQUAD_MP, ITEM_LOCKED)
			Player_SetSquadProductionAvailability(player2, SBP.WEST_GERMAN.PANZER_II_LUCHS_SQUAD_MP, ITEM_LOCKED)
	
		elseif XP1_GetNodeStrength() == 3 then
		
		------disabled infantry----

		
			Player_SetSquadProductionAvailability(player2, SBP.WEST_GERMAN.OBERSOLDATEN_SQUAD_MP, ITEM_LOCKED)
			Player_SetSquadProductionAvailability(player2, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP, ITEM_LOCKED)
			Player_SetSquadProductionAvailability(player2, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, ITEM_LOCKED)
			
		----disabled armor----

			Player_SetSquadProductionAvailability(player2, SBP.WEST_GERMAN.KING_TIGER_SQUAD_MP, ITEM_LOCKED)
			Player_SetSquadProductionAvailability(player2, SBP.WEST_GERMAN.STURMTIGER_SQUAD_MP, ITEM_LOCKED)
			Player_SetSquadProductionAvailability(player2, SBP.WEST_GERMAN.JAGDTIGER_TD_SQUAD_MP, ITEM_LOCKED)
			Player_SetSquadProductionAvailability(player2, SBP.WEST_GERMAN.PANZER_II_LUCHS_SQUAD_MP, ITEM_LOCKED)
	
	
		----disabled unit abilities----
	
			Player_SetAbilityAvailability(player2, ABILITY.WEST_GERMAN.VOLKSGRENADIER_GRENADE_MP, ITEM_LOCKED)
	
		
	end
end



----------------------------------grants the ai with different air support abilities based on node strength---------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------


function AirSupport()

	if XP1_GetNodeStrength() == 2 then

	
	
	elseif XP1_GetNodeStrength() == 3 then
	
	Player_SetResource ( player2, RT_Command, 15 )
	
	Player_AddAbility(player2, ABILITY.GERMAN.AIR_DROPPED_MEDICAL_SUPPLIES)
	Player_CompleteUpgrade(player2, UPG.GERMAN.AIR_DROP_MEDICAL_SUPPLIES)
	
	Player_AddAbility(player2, ABILITY.GERMAN.STUKA_AIR_RECON)
	Player_CompleteUpgrade(player2, UPG.GERMAN.RECON_PLANE)
	
	Player_AddAbility(player2, ABILITY.GERMAN.STUKA_SMOKE_BOMB)
	Player_CompleteUpgrade(player2, UPG.GERMAN.STUKA_SMOKE_BOMB)
	
	Player_AddAbility(player2, ABILITY.GERMAN.STUKA_STRAFING_RUN)
	Player_CompleteUpgrade(player2, UPG.GERMAN.STUKA_STRAFE)
	
	elseif XP1_GetNodeStrength() == 4 then
	
	Player_SetResource ( player2, RT_Command, 15 )
	
	Player_AddAbility(player2, ABILITY.GERMAN.AIR_DROPPED_MEDICAL_SUPPLIES)
	Player_CompleteUpgrade(player2, UPG.GERMAN.AIR_DROP_MEDICAL_SUPPLIES)

	Player_AddAbility(player2, ABILITY.GERMAN.STUKA_CLOSE_AIR_SUPPORT)
	Player_CompleteUpgrade(player2, UPG.GERMAN.STUKA_CLOSE_AIR_SUPPORT)
	
	Player_AddAbility(player2, ABILITY.GERMAN.STUKA_STRAFING_RUN)
	Player_CompleteUpgrade(player2, UPG.GERMAN.STUKA_STRAFE)
	
	Player_AddAbility(player2, ABILITY.GERMAN.STUKA_INCENDIARY_BOMBS)
	Player_CompleteUpgrade(player2, UPG.GERMAN.STUKA_FLAME_STRIKE)
	
	Player_AddAbility(player2, ABILITY.GERMAN.STUKA_AIR_RECON)
	Player_CompleteUpgrade(player2, UPG.GERMAN.RECON_PLANE)

	elseif XP1_GetNodeStrength() == 5 then
	
	Player_SetResource ( player2, RT_Command, 15 )
	
--~ 	Player_AddAbility(player2, ABILITY.GERMAN.STUKA_BOMBING_STRIKE)
--~ 	Player_CompleteUpgrade(player2, UPG.GERMAN.STUKA_BOMBING_RUN_UPGRADE)

	Player_AddAbility(player2, ABILITY.GERMAN.STUKA_FRAGMENTATION_BOMB)
	Player_CompleteUpgrade(player2, UPG.GERMAN.STUKA_FRAGMENTATION_BOMB)

	
	Player_AddAbility(player2, ABILITY.GERMAN.STUKA_AERIAL_SUPERIORITY_CLOSE_AIR_SUPPORT)
	Player_CompleteUpgrade(player2, UPG.GERMAN.AERIAL_SUPERIORITY_STUKA_CLOSE_AIR_SUPPORT)
	
	Player_AddAbility(player2, ABILITY.GERMAN.STUKA_STRAFING_RUN)
	Player_CompleteUpgrade(player2, UPG.GERMAN.STUKA_STRAFE)
	
	Player_AddAbility(player2, ABILITY.GERMAN.STUKA_AIR_RECON)
	Player_CompleteUpgrade(player2, UPG.GERMAN.RECON_PLANE)
	
	
	end
end




--------------------------------------specific unit support for different node strengths----------------------------------------------


function Support()

	if XP1_GetNodeStrength() >= 2 then
	
	Rule_AddInterval(CreatePanzer, 240)
		
	end
end



function CreatePanzer()


	
	Util_CreateSquads(player2, sg_e_all, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP, mkr_reverseHardpoint_point1)
	

end
	


	
	
	
function Update_Scoreboard()
	
	-- clear the existing scoreboard
	WinWarning_ScoreDisplayIconsClear()	
	
	-- add new set of icons
	for n = 1, i_destroyToWin do
		
		if n <= i_destroyedTrucks then
			-- crossed off truck
			WinWarning_ScoreDisplayIconAdd("Icons_symbols_vehicle_west_german_halftrack_sws_strike_symbol", 255, 255, 255, 0, 11079362, 11079363, "Icons_resources_flag_truck")
		else
			-- truck still to kill
			WinWarning_ScoreDisplayIconAdd("Icons_symbols_vehicle_west_german_halftrack_sws_symbol", 255, 255, 255, 0, 11079362, 11079363, "Icons_resources_flag_truck")
		end
		
	end

end
