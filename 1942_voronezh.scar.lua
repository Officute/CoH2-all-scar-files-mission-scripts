-------------------------------------------------------------------------
-------------------------------------------------------------------------

-- 1942: Voronezh
-- Designer: Sacha Narine

-------------------------------------------------------------------------
-------------------------------------------------------------------------

import("ScarUtil.scar")
import("Systems/AiManager/ai.scar")
import("Prototype/DeploymentPoints.scar")
-- [[ IMPORT MISSION SCRIPTS ]]
import("1942_Voronezh_Obj.scar")
import("1942_Voronezh_Encounters.scar")
import("TheatreOfWar.scar")

-------------------------------------------------------------------------
-- [[ ONINIT ]]
-------------------------------------------------------------------------


function OnGameRestore()
	Game_DefaultGameRestore()
end


function OnInit()
	
	-- SGROUPS
	sg_e_all = SGroup_CreateIfNotFound("sg_e_all")
	sg_e_cityAT = SGroup_CreateIfNotFound("sg_e_cityAT")
	sg_e_westAttack1 = SGroup_CreateIfNotFound("sg_e_westAttack1")
	sg_e_westAttack2 = SGroup_CreateIfNotFound("sg_e_westAttack2")
	sg_e_eastAttack1 = SGroup_CreateIfNotFound("sg_e_eastAttack1")
	sg_e_eastAttack1_car1 = SGroup_CreateIfNotFound("sg_e_eastAttack1_car1")
	sg_e_eastAttack1_car2 = SGroup_CreateIfNotFound("sg_e_eastAttack1_car2")
	sg_e_eastAttack2 = SGroup_CreateIfNotFound("sg_e_eastAttack2")
	sg_e_eastAttack3 = SGroup_CreateIfNotFound("sg_e_eastAttack3")
	sg_e_startingSquads = SGroup_CreateIfNotFound("sg_e_startingSquads")
	sg_e_baseDefenders = SGroup_CreateIfNotFound("sg_e_baseDefenders")
	
	sg_p_fearTarget = SGroup_CreateIfNotFound("sg_p_fearTarget")
	sg_p_scorchTarget = SGroup_CreateIfNotFound("sg_p_scorchTarget")
	sg_p1_repairPioneers = SGroup_CreateIfNotFound("sg_p1_repairPioneers") -- Repair Pioneers, if player1 is AI
	sg_p1_startingVehicles = SGroup_CreateIfNotFound("sg_p1_startingVehicles")
	
	sg_miscellany = SGroup_CreateIfNotFound("sg_miscellany") -- For random gathering and filtering of squads
	
	-- EGROUPS (defined in the Worldbuilder)
	-- eg_mep_player1 -- Player 1's map entry point
	-- eg_mep_player2 -- Player 2's map entry point
	-- eg_vp_west -- The west/left Victory Point
	-- eg_vp_east -- The east/right Victory Point
	-- eg_vp_north -- The north/top Victory Point
	-- eg_bridge_north -- The north/top vehicle-width bridge crossing the river
	-- eg_bridge_south -- The south/bottom vehicle-width bridge crossing the river
	-- eg_bridge_rail -- The narrow railway bridge crossing the river
	-- eg_barricade_north_west -- The barricade (roadblock) objects on the west side of the northern bridge
	-- eg_barricade_mid -- The barricade (roadblock) on the west side of the railway bridge
	eg_miscellany = EGroup_CreateIfNotFound("eg_miscellany") -- For random gathering and filtering of entities
	
	-- Map Entry Points (replaced by new player-specific entry points)
	EGroup_DeSpawn(eg_mep_player1)
	EGroup_DeSpawn(eg_mep_player2)
	
	-- Variables
	g_p1_basePosition = Marker_GetPosition(mkr_p1_base)
	g_p2_basePosition = Marker_GetPosition(mkr_p2_base)
	time_last_propaganda_or_scorchedearth = 0
	
	g_voronezh_wrecks = {
		EBP.WRECKED_VEHICLES.WRECKED_T70, 
		EBP.WRECKED_VEHICLES.WRECKED_T_34_76, 
		EBP.WRECKED_VEHICLES.WRECKED_T_34_76_02,
		EBP.GERMAN.PAK40_75MM_AT_GUN_MP,
		EBP.SOVIET.M1942_76MM_DIVISIONAL_GUN_ZIS_3_MP,
		EBP.WRECKED_VEHICLES.WRECKED_STUG_III_G_SDKFZ_141_1,
		EBP.WRECKED_VEHICLES.WRECKED_STUG_III_E_SDKFZ_141_1,
		EBP.WRECKED_VEHICLES.WRECKED_PANZER_IV_SDKFZ_161,
		EBP.WRECKED_VEHICLES.WRECKED_M5_HALFTRACK,
		EBP.WRECKED_VEHICLES.WRECKED_M3A1_SCOUT_CAR,
		EBP.WRECKED_VEHICLES.WRECKED_KV_1,
		EBP.WRECKED_VEHICLES.WRECKED_KATYUSHA_BM_13N,
		EBP.WRECKED_VEHICLES.WRECKED_HALFTRACK_SDKFZ_251,
		EBP.WRECKED_VEHICLES.WRECKED_ATGUN_ZIS3,
		EBP.WRECKED_VEHICLES.WRECKED_ATGUN_45MM,
		EBP.WRECKED_VEHICLES.WRECKED_ARMORED_CAR_SDKFZ_222
	}
	
	g_voronezh_wrecks_small = {
		EBP.WRECKED_VEHICLES.WRECKED_T70, 
		EBP.GERMAN.PAK40_75MM_AT_GUN_MP,
		EBP.SOVIET.M1942_76MM_DIVISIONAL_GUN_ZIS_3_MP,
		EBP.WRECKED_VEHICLES.WRECKED_M5_HALFTRACK,
		EBP.WRECKED_VEHICLES.WRECKED_M3A1_SCOUT_CAR,
		EBP.WRECKED_VEHICLES.WRECKED_KATYUSHA_BM_13N,
		EBP.WRECKED_VEHICLES.WRECKED_HALFTRACK_SDKFZ_251,
		EBP.WRECKED_VEHICLES.WRECKED_ATGUN_ZIS3,
		EBP.WRECKED_VEHICLES.WRECKED_ATGUN_45MM,
		EBP.WRECKED_VEHICLES.WRECKED_ARMORED_CAR_SDKFZ_222
	}
	
	-- Variables used for releasing some scripted enemies to the skirmish AI
	g_unlockAIIndex = 1
	t_AItoUnlock = {}
	
	__Team_Init()
	
	--[[ DEFINE PLAYERS ]]
	player1, player2 = Team_DefineAllies()
	player3, player4 = Team_DefineEnemies()
	
	print("1: ".. Player_GetRaceName(player1) .. " ... Human:".. tostring(Player_IsHuman(player1)).. "  AIPlayer:".. tostring(AI_IsAIPlayer(player1)).."/Enabled:".. tostring(AI_IsEnabled(player1)))
	print("2: ".. Player_GetRaceName(player2) .. " ... Human:".. tostring(Player_IsHuman(player2)).. "  AIPlayer:".. tostring(AI_IsAIPlayer(player2)).."/Enabled:".. tostring(AI_IsEnabled(player2)))
	print("3: ".. Player_GetRaceName(player3) .. " ... Human:".. tostring(Player_IsHuman(player3)).. "  AIPlayer:".. tostring(AI_IsAIPlayer(player3)).."/Enabled:".. tostring(AI_IsEnabled(player3)))
	print("4: ".. Player_GetRaceName(player4) .. " ... Human:".. tostring(Player_IsHuman(player4)).. "  AIPlayer:".. tostring(AI_IsAIPlayer(player4)).."/Enabled:".. tostring(AI_IsEnabled(player4)))
	
	
	--[[ PRESET DEBUG CONDITIONS ]]
	Mission_Debug()
	
	--[[ SET DIFFICULTY ]]
	Mission_Difficulty()
	
	--[[ SET RESTRICTIONS ]]
	Mission_Restrictions()
	
	--[[ MISSION PRESETS ]]
	Mission_MissionPreset()

	
	--[[ GAME START CHECK ]]
	Rule_Add(Mission_MissionStart)

	Voronezh_WestBankEncounters()
	Voronezh_AntiTankEncounters()
	Voronezh_EastVPDefenders()
	Voronezh_EnemyBaseDefenders()
	Voronezh_EnemyStartingSquads()
	if g_difficulty == GD_HARD then
		Voronezh_NorthVPDefenders()
	end
	
end

Scar_AddInit(OnInit)

function NIS_Init()
	NIS_OUTRO = "ToW/Scenarios/1942_Voronezh/nis/voronezh_outro"
	nis_load(NIS_OUTRO)
	
	nis_setintransitiontime(0)
	nis_setouttransitiontime(0.5)
end

Scar_AddInit(NIS_Init)

function Mission_Debug()

	-- looks for the command line option [-debug]
	if Misc_IsCommandLineOptionSet("debug") then
		g_debug = true
	end

end

function Mission_Difficulty()
	
	g_difficulty = Game_GetSPDifficulty() 
	
	t_defaultGoalData_attackEasy = {
	  tacticControlsList = {
		{
			tacticType = TACTIC_Cover,
			priority = 1,
			retryTimeSecs = 8,
			waitTimeSecs = 30,
		},
		{
			tacticType = TACTIC_Vehicle,
			priority = -1,
		},
		{
			tacticType = TACTIC_RushAtTarget,
			priority = -1,
		},
		{
			tacticType = TACTIC_Avoid,
			priority = -1,
		},
	  },
	}
	
	t_defaultGoalData_attackNormal = {
	  tacticControlsList = {
		{
			tacticType = TACTIC_Vehicle,
			priority = 2,
			retryTimeSecs = 12,
			waitTimeSecs = 20,
		},
	  },
	}
	
	t_defaultGoalData_attackHard = {
	  tacticControlsList = {
		{
			tacticType = TACTIC_Cover,
			priority = 15,
			retryTimeSecs = 10,
			waitTimeSecs = 10,
		},
		{
			tacticType = TACTIC_Vehicle,
			priority = 10,
			retryTimeSecs = 10,
			waitTimeSecs = 20,
		},
		{
			tacticType = TACTIC_RushAtTarget,
			priority = 5,
			retryTimeSecs = 8,
			waitTimeSecs = 20,
		},
	  },
	}
	
	t_defaultGoalData_defendEasy = {
	  tacticControlsList = {
		{
			tacticType = TACTIC_Cover,
			priority = 1,
			retryTimeSecs = 8,
			waitTimeSecs = 30,
		},
		{
			tacticType = TACTIC_Avoid,
			priority = -1,
		},
		{
			tacticType = TACTIC_Vehicle,
			priority = -1,
		},
		{
			tacticType = TACTIC_Pickup,
			priority = -1,
		},
		{
			tacticType = TACTIC_CaptureTeamWeapon,
			priority = -1,
		},
		{
			tacticType = TACTIC_Recrew,
			priority = -1,
		},
	  },
	}
	
	t_defaultGoalData_defendNormal = {
	  tacticControlsList = {
		{
			tacticType = TACTIC_Vehicle,
			priority = 2,
			retryTimeSecs = 12,
			waitTimeSecs = 20,
		},
	  },
	}
	
	t_defaultGoalData_defendHard = {
	  tacticControlsList = {
		{
			tacticType = TACTIC_Cover,
			priority = 15,
			retryTimeSecs = 10,
			waitTimeSecs = 10,
		},
		{
			tacticType = TACTIC_Vehicle,
			priority = 5,
			retryTimeSecs = 10,
			waitTimeSecs = 20,
		},

	  },
	}

	t_goalData_attackEasy = { 
		range_Multiplier = 0.9,
		movePathLengthFactor_Multiplier = 0.8,
		safeMoveWeight_Multiplier = 0.75,
	}
	t_goalData_attackHard = { 		
		range_Multiplier = 1.2,
		movePathLengthFactor_Multiplier = 1.2,
		leashRange_Multiplier = 1.2,
		safeMoveWeight_Multiplier = 1.25,
	}
	t_goalData_defendEasy = { 
		range_Multiplier = 0.9,
		leashRange_Multiplier = 0.9,
		maxAttackers_Multiplier = -2,
		safeMoveWeight_Multiplier = 0.75,
	}
	t_goalData_defendHard = { 
		range_Multiplier = 1.2,
		movePathLengthFactor_Multiplier = 1.2,
		leashRange_Multiplier = 1.2,
		safeMoveWeight_Multiplier = 1.25,
	}
	
	t_difficulty = {
 	-- Easy, Medium, Hard
		
		player_startingManpower 	= Util_DifVar( {500, 400, 300} ), 	
		player_startingMunitions 	= Util_DifVar( {180, 120, 60} ), 	
		player_startingFuel 		= Util_DifVar( {60, 30, 20} ), 	
		
		enemy_startingManpower 		= Util_DifVar( {300, 400, 500} ), 	
		enemy_startingMunitions 	= Util_DifVar( {30, 60, 90} ), 	
		enemy_startingFuel 			= Util_DifVar( {20, 30, 40} ), 
		enemy_maxPopCap				= Util_DifVar( {85, 100, 125} ),
	
		enemyUpkeepReduction		= Util_DifVar( {0.8, 0.6, 0.333} ),
		enemyBaseFuelBuff			= Util_DifVar( {0.01, 0.02, .03} ),
		enemyBaseMunitionsBuff		= Util_DifVar( {0.015, 0.03, .045} ),
		
		player1BaseFuelBuff			= Util_DifVar( {0.025, 0.02, .015} ),		-- Vehicle player
		player1BaseManpowerNerf		= Util_DifVar( {0.8, 0.75, .667} ),
		
		player2BaseFuelNerf			= Util_DifVar( {0.667, 0.5, 0.333} ),		-- Infantry player
		player2BaseManpowerBuff		= Util_DifVar( {1.3, 1.2, 1.1} ),
		
		atmosphereTransitionDelay 	= Util_DifVar( {360, 240, 120} ),
		
		westBankAttackDelay1		= Util_DifVar( {World_GetRand(630, 870), World_GetRand(480, 720), World_GetRand(330, 570)} ),
		westBankAttackDelay2		= Util_DifVar( {World_GetRand(1230, 1470), World_GetRand(1080, 1320), World_GetRand(930, 1170)} ),
		
		KV8SpawnDelay				= Util_DifVar( {World_GetRand(1500, 1750), World_GetRand(1250, 1500), World_GetRand(1000, 1250)} ),
		
		fearPropagandaDelay			= Util_DifVar( {World_GetRand(500, 680), World_GetRand(320, 500), World_GetRand(200, 380)} ),
		scorchedEarthDelay			= Util_DifVar( {World_GetRand(1200, 1380), World_GetRand(840, 1020), World_GetRand(600, 780)} ),
		
		defaultAttackGoalData 					= Util_DifVar( {t_defaultGoalData_attackEasy, t_defaultGoalData_attackNormal, t_defaultGoalData_attackHard, {}}),
		defaultDefendGoalData 					= Util_DifVar( {t_defaultGoalData_defendEasy, t_defaultGoalData_defendNormal, t_defaultGoalData_defendHard, {}}),
		modifyAttackGoalData					= Util_DifVar( {t_goalData_attackEasy, {}, t_goalData_attackHard, {}}),
		modifyDefendGoalData					= Util_DifVar( {t_goalData_defendEasy, {}, t_goalData_defendHard, {}}),
	}
	
	if g_difficulty == GD_EASY or g_difficulty == GD_NORMAL then
		EGroup_SetStrategicPointNeutral(eg_allVPs)
		modID_captureNorthVP = Modify_CaptureTime(eg_vp_north, 0.01)
		modID_captureEastVP = Modify_CaptureTime(eg_vp_east, 0.01)
		Rule_AddInterval(Voronezh_RemoveCaptureMod1, 2)
		Rule_AddInterval(Voronezh_RemoveCaptureMod2, 2)
	end
	
	if AI_IsEnabled(player1) or AI_IsEnabled(player2) then
		t_difficulty.enemy_maxPopCap = t_difficulty.enemy_maxPopCap - 15
	end

	AIAttackGoal_AdjustDefaultGoalData(t_difficulty.defaultAttackGoalData)
	AIDefendGoal_AdjustDefaultGoalData(t_difficulty.defaultDefendGoalData)	
	
	AIAttackGoal_SetModifyGoalData(t_difficulty.modifyAttackGoalData)
	AIDefendGoal_SetModifyGoalData(t_difficulty.modifyDefendGoalData)	
	
end

function Voronezh_RemoveCaptureMod1()
	if Team_CanSee(TEAM_HUMANS, eg_vp_north, ANY) or World_GetGameTime() > 450 then
		Modifier_Remove(modID_captureNorthVP)
		Rule_RemoveMe()
	end
end

function Voronezh_RemoveCaptureMod2()
	if Team_CanSee(TEAM_HUMANS, eg_vp_east, ANY) or World_GetGameTime() > 300 then
		Modifier_Remove(modID_captureEastVP)
		Rule_RemoveMe()
	end
end

function Voronezh_SpawnPlayer1Vehicles()
	Util_CreateSquads(player1, sg_p1_startingVehicles, SBP.GERMAN.PANZER_IV_SQUAD_MP, mkr_p1_startingP4_1)
	Util_CreateSquads(player1, sg_p1_startingVehicles, SBP.GERMAN.PANZER_IV_SQUAD_MP, mkr_p1_startingP4_2)
	Util_CreateSquads(player1, sg_p1_startingVehicles, SBP.GERMAN.STUG_III_SQUAD_MP, mkr_p1_startingStug)
	Util_CreateSquads(player1, sg_p1_startingVehicles, SBP.GERMAN.SCOUTCAR_SDKFZ222_MP, mkr_p1_startingCar1)
	Util_CreateSquads(player1, sg_p1_startingVehicles, SBP.GERMAN.SCOUTCAR_SDKFZ222_MP, mkr_p1_startingCar2)
	Util_CreateSquads(player1, sg_p1_startingVehicles, SBP.GERMAN.SDKFZ_251_HALFTRACK_SQUAD_MP, mkr_p1_startingHalftrack)
end

function Mission_Restrictions()

	-- Utilize for setting restrictions on Units, teams, etc
	Team_SetTechTreeByYear(TEAM_ALLIES, 1942)
	Team_SetTechTreeByYear(TEAM_ENEMIES, 1942)
	
	-- Player 1 : Armor
	Player_SetEntityProductionAvailability(player1, EBP.GERMAN.BEREICH_FESTUNG_MP, ITEM_REMOVED)
	Player_SetEntityProductionAvailability(player1, EBP.GERMAN.SCHWERES_KRIEGSWERK_MP, ITEM_REMOVED)
	Player_SetEntityProductionAvailability(player1, EBP.GERMAN.HINTERE_PANZERWERK_MP, ITEM_REMOVED)
	
	Player_SetSquadProductionAvailability(player1, SBP.GERMAN.PANZER_IV_SQUAD_MP, ITEM_UNLOCKED)
	Player_SetSquadProductionAvailability(player1, SBP.GERMAN.PANZER_IV_STUBBY_SQUAD_MP, ITEM_UNLOCKED)
	Player_SetSquadProductionAvailability(player1, SBP.GERMAN.STUG_III_SQUAD_MP, ITEM_UNLOCKED)
	Player_SetSquadProductionAvailability(player1, SBP.GERMAN.STUG_III_E_SQUAD_MP, ITEM_UNLOCKED)
	
	Player_SetSquadProductionAvailability(player1, SBP.GERMAN.GRENADIER_SQUAD_MP, ITEM_REMOVED)
	Player_SetSquadProductionAvailability(player1, SBP.GERMAN.PANZER_GRENADIER_SQUAD_MP, ITEM_REMOVED)
	Player_SetSquadProductionAvailability(player1, SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD_MP, ITEM_REMOVED)
	Player_SetSquadProductionAvailability(player1, SBP.GERMAN.MORTAR_TEAM_81MM_MP, ITEM_REMOVED)
	Player_SetSquadProductionAvailability(player1, SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD_MP, ITEM_REMOVED)
	Player_SetSquadProductionAvailability(player1, SBP.GERMAN.ASSAULT_OFFICER_SQUAD_MP, ITEM_REMOVED)
	Player_SetSquadProductionAvailability(player1, SBP.GERMAN.HOWITZER_105MM_LE_FH18_ARTILLERY_MP, ITEM_REMOVED)
	Player_SetSquadProductionAvailability(player1, SBP.GERMAN.SNIPER_SQUAD_MP, ITEM_REMOVED)
	Player_SetSquadProductionAvailability(player1, SBP.GERMAN.PANZER_IV_COMMAND_SQUAD_MP, ITEM_UNLOCKED)
	
	Player_SetUpgradeAvailability(player1, BP_GetUpgradeBlueprint("theatre_of_war_1941"), ITEM_LOCKED)
	
	Modify_AbilityManpowerCost(player2, ABILITY.GERMAN.MECHANIZED_ASSAULT_GROUP, 2)

	-- Player 2 : Infantry
	Player_SetEntityProductionAvailability(player2, EBP.GERMAN.HINTERE_PANZERWERK_MP, ITEM_REMOVED)
	Player_SetEntityProductionAvailability(player2, EBP.GERMAN.HINTERE_PANZERWERK_VORONEZH, ITEM_REMOVED)
	Player_SetEntityProductionAvailability(player2, EBP.GERMAN.SCHWERES_KRIEGSWERK_MP, ITEM_REMOVED)
	
	Player_SetSquadProductionAvailability(player2, SBP.GERMAN.BRUMMBAR_SQUAD_MP, ITEM_REMOVED)
	Player_SetSquadProductionAvailability(player2, SBP.GERMAN.ELEFANT_TANK_DESTROYER_SQUAD_MP, ITEM_REMOVED)
	Player_SetSquadProductionAvailability(player2, SBP.GERMAN.HOWITZER_105MM_LE_FH18_ARTILLERY_MP, ITEM_REMOVED)
	Player_SetSquadProductionAvailability(player2, SBP.GERMAN.MORTAR_250_HALFTRACK_SQUAD_MP, ITEM_REMOVED)
	Player_SetSquadProductionAvailability(player2, SBP.GERMAN.OSTWIND_SQUAD_MP, ITEM_REMOVED)
	Player_SetSquadProductionAvailability(player2, SBP.GERMAN.PAK43_88MM_AT_GUN_SQUAD_MP, ITEM_REMOVED)
	Player_SetSquadProductionAvailability(player2, SBP.GERMAN.PANTHER_SQUAD_MP, ITEM_REMOVED)
	Player_SetSquadProductionAvailability(player2, SBP.GERMAN.PANZERWERFER_SQUAD_MP, ITEM_REMOVED)
	Player_SetSquadProductionAvailability(player2, SBP.GERMAN.PANZER_IV_COMMAND_SQUAD_MP, ITEM_REMOVED)
	Player_SetSquadProductionAvailability(player2, SBP.GERMAN.PANZER_IV_SQUAD_MP, ITEM_REMOVED)
	Player_SetSquadProductionAvailability(player2, SBP.GERMAN.PANZER_IV_STUBBY_SQUAD_MP, ITEM_REMOVED)
	Player_SetSquadProductionAvailability(player2, SBP.GERMAN.SCOUTCAR_SDKFZ222_MP, ITEM_REMOVED)
	Player_SetSquadProductionAvailability(player2, SBP.GERMAN.SDKFZ_251_HALFTRACK_SQUAD_MP, ITEM_REMOVED)
	Player_SetSquadProductionAvailability(player2, SBP.GERMAN.STUG_III_E_SQUAD_MP, ITEM_REMOVED)
	Player_SetSquadProductionAvailability(player2, SBP.GERMAN.STUG_III_SQUAD_MP, ITEM_REMOVED)
	Player_SetSquadProductionAvailability(player2, SBP.GERMAN.TIGER_SQUAD_MP, ITEM_REMOVED)
	Player_SetUpgradeAvailability(player2, BP_GetUpgradeBlueprint("theatre_of_war_1941"), ITEM_LOCKED)
	
	-- Resource Caps and Modifiers
	Modify_PlayerResourceCap(player1, RT_Manpower, 2001)
	Modify_PlayerResourceCap(player1, RT_Munition, 2001)
	Modify_PlayerResourceCap(player1, RT_Fuel, 2001)
	Modify_PlayerResourceCap(player2, RT_Manpower, 2001)
	Modify_PlayerResourceCap(player2, RT_Munition, 2001)
	Modify_PlayerResourceCap(player2, RT_Fuel, 2001)
	
	Modify_PlayerResourceRate(player1, RT_Manpower, t_difficulty.player1BaseManpowerNerf)
	Modify_PlayerResourceRate(player1, RT_Fuel, 1.5)
	Modify_PlayerResourceRate(player1, RT_Fuel, t_difficulty.player1BaseFuelBuff, MUT_Addition)
	
	Modify_PlayerResourceRate(player2, RT_Manpower, t_difficulty.player2BaseManpowerBuff) 
	Modify_PlayerResourceRate(player2, RT_Fuel, t_difficulty.player2BaseFuelNerf)	

end


-------------------------------------------------------------------------
-- MISSION Preset 
-------------------------------------------------------------------------

function Mission_MissionPreset()

	-- Kicks off after SCAR Inits, but before MissionStart is called.
	-- Use for spawning units on the map at the start
	
	-- Pre-spawn player1 vehicles with appropriate skins (determined by loadout)
	Voronezh_SpawnPlayer1Vehicles()
	
	-- Starting Resources (Players)
	Player_SetResource(player1, RT_Manpower, t_difficulty.player_startingManpower)
	Player_SetResource(player2, RT_Manpower, t_difficulty.player_startingManpower)
	Player_SetResource(player1, RT_Munition, t_difficulty.player_startingMunitions)
	Player_SetResource(player2, RT_Munition, t_difficulty.player_startingMunitions)
	Player_SetResource(player1, RT_Fuel, t_difficulty.player_startingFuel)
	Player_SetResource(player2, RT_Fuel, t_difficulty.player_startingFuel)
	
	-- Starting Resources (AI)
	Player_SetResource(player3, RT_Manpower, t_difficulty.enemy_startingManpower)
	Player_SetResource(player4, RT_Manpower, t_difficulty.enemy_startingManpower)
	Player_SetResource(player3, RT_Munition, t_difficulty.enemy_startingMunitions)
	Player_SetResource(player4, RT_Munition, t_difficulty.enemy_startingMunitions)
	Player_SetResource(player3, RT_Fuel, t_difficulty.enemy_startingFuel)
	Player_SetResource(player4, RT_Fuel, t_difficulty.enemy_startingFuel)
	Player_SetPopCapOverride(player3, t_difficulty.enemy_maxPopCap)
	Player_SetPopCapOverride(player4, t_difficulty.enemy_maxPopCap)
	
	-- Starting Upgrades (Players)
	Player_CompleteUpgrade(player1, UPG.GERMAN.BATTLE_PHASE_2_MP)
	Player_CompleteUpgrade(player1, UPG.GERMAN.BATTLE_PHASE_3_MP)
	Player_CompleteUpgrade(player1, UPG.GERMAN.BATTLE_PHASE_4_MP)
	Player_CompleteUpgrade(player1, BP_GetUpgradeBlueprint("1942_voronezh"))
	Player_CompleteUpgrade(player1, BP_GetUpgradeBlueprint("1942_voronezh_infantry_lock"))
	Player_CompleteUpgrade(player1, UPG.GERMAN.STUG_III_E_UNLOCK)
	Player_CompleteUpgrade(player2, UPG.GERMAN.BATTLE_PHASE_2_MP)
	Player_CompleteUpgrade(player2, UPG.GERMAN.BATTLE_PHASE_3_MP)
	Player_CompleteUpgrade(player2, UPG.GERMAN.BATTLE_PHASE_4_MP)
	Player_CompleteUpgrade(player2, BP_GetUpgradeBlueprint("1942_voronezh"))
	Player_CompleteUpgrade(player2, BP_GetUpgradeBlueprint("1942_voronezh_vehicle_lock"))
	
	-- Modifiers (Players)
	Modify_EntityCost(player1, EBP.GERMAN.PANZER_IV_SDKFZ_AUSF1_MP, RT_Manpower, -60)
	Modify_EntityCost(player1, EBP.GERMAN.PANZER_IV_SDKFZ_AUSF1_MP, RT_Fuel, -20)
	
	-- If the ally is AI-controlled, tell them to focus on capturing the nearest VP
	if AI_IsEnabled(player1) then
		_SetAICaptureImportance(eg_vp_west, 15000, player1)
	end
	if AI_IsEnabled(player2) then
		_SetAICaptureImportance(eg_vp_north, 15000, player2)
	end
	
	_SetAICaptureImportance(eg_vp_north, 15000, player3)
	_SetAICaptureImportance(eg_vp_west, 15000, player4)
	
	-- Bridges
	Modify_ReceivedDamage(eg_bridge_rail, 0.5)
	EGroup_SetSelectable(eg_bridge_north, false)
	EGroup_SetSelectable(eg_bridge_south, false)
	EGroup_SetSelectable(eg_bridge_rail, false)
	
	-- AI Ally Setup
	Voronezh_AiAllySetup()
	
	-- Enemy AI Setup
	Voronezh_EnemyAiSetup()
	Modify_PlayerResourceRate(player3, RT_Fuel, t_difficulty.enemyBaseFuelBuff, MUT_Addition)
	Modify_PlayerResourceRate(player4, RT_Fuel, t_difficulty.enemyBaseFuelBuff, MUT_Addition)
	Modify_PlayerResourceRate(player3, RT_Munition, t_difficulty.enemyBaseMunitionsBuff, MUT_Addition)
	Modify_PlayerResourceRate(player4, RT_Munition, t_difficulty.enemyBaseMunitionsBuff, MUT_Addition)
	Modify_Upkeep(player3, t_difficulty.enemyUpkeepReduction)
	Modify_Upkeep(player3, t_difficulty.enemyUpkeepReduction)
	
	-- Starting Upgrades (Enemies)
	Player_CompleteUpgrade(player3, UPG.SOVIET.FEAR_PROPAGANDA)
	Player_CompleteUpgrade(player4, UPG.SOVIET.SCORCHED_EARTH_POLICY)
	Player_AddAbility(player3, ABILITY.SOVIET.FEAR_PROPAGANDA_ARTILLERY)
	g_scorchAbilityBP = BP_GetAbilityBlueprint("scorched_earth_policy_mp")
	Player_AddAbility(player4, g_scorchAbilityBP)
	Player_SetAbilityAvailability(player3, ABILITY.SOVIET.FEAR_PROPAGANDA_ARTILLERY, ITEM_UNLOCKED)
	Player_SetAbilityAvailability(player4, g_scorchAbilityBP, ITEM_UNLOCKED)
	
	-- A subtle atmosphere transition from morning to afternoon
	Voronezh_AtmosphereTransition()
	
	Camera_SetDefault(nil, nil, -75)
	Camera_ResetToDefault()

end

function Voronezh_AtmosphereTransition()
	Game_LoadAtmosphere("data:art/scenarios/presets/atmosphere/DLC/tow_voronezh_02.aps", 300)
end

-------------------------------------------------------------------------
-- MISSION START 
-------------------------------------------------------------------------

function Mission_MissionStart()
	if Event_IsAnyRunning() == false then
		-- Add all hints
		Mission_EnableBaseHints()
		Mission_EnableBarricadeHints()
		Mission_EnableVPHints()
		-- HAXX: Remove the tow_1941 upgrade if the player has chosen a 1941 commander
		Rule_Add(Mission_Remove1941Upgrade)
		-- HAXX: Destroy wrecks that can block pathing on bridges and narrow roads (This rule is bad for performance!)
		Rule_AddDelayedInterval(Voronezh_ClearWrecks, 120, 1)
		Rule_RemoveMe()
	end
end

----- Hintpoints -----
function Mission_EnableBaseHints()
	hint_player1Base = HintPoint_Add(mkr_hint_player1, true, 11050520)
	hint_player2Base = HintPoint_Add(mkr_hint_player2, true, 11050521)
end

function Mission_FlashProductionButtons()
	-- If the player hasn't noticed their base buildings, ping the HUD element for a base building
	local playerEntities = Player_GetEntities(Game_GetLocalPlayer())
	if EGroup_IsProducingSquads(playerEntities, ANY) then
		Rule_RemoveMe()
	elseif World_GetGameTime() >= 60 then
		if Game_GetLocalPlayer() == player1 then
			flashID_base = UI_FlashProductionBuildingButton("motor_pool_light", true)
		elseif Game_GetLocalPlayer() == player2 then
			flashID_base = UI_FlashProductionBuildingButton("armory", true)
		end
		Rule_RemoveMe()
		Rule_AddOneShot(Mission_StopFlashingProductionButtons, 8)
	end
end

function Mission_StopFlashingProductionButtons()
	if flashID_base ~= nil then
		UI_StopFlashing(flashID_base)
	end
end

function Mission_EnableBarricadeHints()
	-- Destroy barricades to open paths (on top and middle bridges)
	hint_barricadeNorth = HintPoint_Add(mkr_barricade_north, true, 11050522)
	hint_barricadeNortheast = HintPoint_Add(mkr_barricade_northeast, true, 11050522)
	hint_barricadeMid = HintPoint_Add(mkr_barricade_mid, true, 11050523)
	Rule_AddInterval(Mission_DisableBarricadeHintNorth, 1)
	Rule_AddInterval(Mission_DisableBarricadeHintMid, 1)
	Rule_AddInterval(Mission_DisableBarricadeHintNortheast, 1)
end

function Mission_EnableVPHints()
	hint_vpWest = HintPoint_Add(eg_vp_west, true, 11050518, 3.8)
	hint_vpEast = HintPoint_Add(eg_vp_east, true, 11050518, 3.8)
	hint_vpCenter = HintPoint_Add(eg_vp_north, true, 11050518, 3.8)
end

function Mission_DisableBarricadeHintNorth()
	if EGroup_Count(eg_barricade_north_west) < 1 then
		HintPoint_Remove(hint_barricadeNorth)
		Rule_RemoveMe()
	end
end

function Mission_DisableBarricadeHintNortheast()
	local group = eg_barricade_north
	EGroup_RemoveGroup(group, eg_barricade_north_west)
	if EGroup_Count(group) < 1 then
		HintPoint_Remove(hint_barricadeNortheast)
		Rule_RemoveMe()
	end
end

function Mission_DisableBarricadeHintMid()
	if EGroup_IsEmpty(eg_barricade_mid) then
		HintPoint_Remove(hint_barricadeMid)
		Rule_RemoveMe()
	end
end

function Mission_EnableVaultingHints()
	-- Tell the player they can vault over lots of walls
	if g_difficulty == GD_EASY and AI_IsEnabled(player2) == false then
		hint_vaultingMid = HintPoint_Add(mkr_vaultHint1, true, 11050928)
		hint_vaultingNorth = HintPoint_Add(mkr_vaultHint2, true, 11050927)
		hint_vaultingSouth = HintPoint_Add(mkr_vaultHint3, true, 11050929)
		Rule_AddInterval(Mission_DisableVaultingHints, 1)
	end
end

function Mission_DisableVaultingHints()
	if (g_vaultHintMidRemoved and g_vaultHintNorthRemoved and g_vaultHintSouthRemoved) then
		Rule_RemoveMe()
	else
		local player2Squads = Player_GetSquads(player2)
		if (g_vaultHintMidRemoved == nil and Prox_AreSquadsNearMarker(player2Squads, mkr_vaultHint1, ANY, 5)) or (World_GetGameTime() > 120)  then
			HintPoint_Remove(hint_vaultingMid)
			g_vaultHintMidRemoved = true
		end
		if (g_vaultHintNorthRemoved == nil and Prox_AreSquadsNearMarker(player2Squads, mkr_vaultHint2, ANY, 5)) or (World_GetGameTime() > 450) then
			HintPoint_Remove(hint_vaultingNorth)
			g_vaultHintNorthRemoved = true
		end
		if (g_vaultHintSouthRemoved == nil and Prox_AreSquadsNearMarker(player2Squads, mkr_vaultHint3, ANY, 5)) or (World_GetGameTime() > 600) then
			HintPoint_Remove(hint_vaultingSouth)
			g_vaultHintSouthRemoved = true
		end
	end
end

function Mission_MineFieldHint()
	-- Point out the minefield to the west of the bottom bridge
	if Team_CanSee(TEAM_HUMANS, eg_mines, ANY) then
		Rule_RemoveMe()
		Util_StartIntel(EVENTS.MineField)
		EventCue_Create(CUE.NORMAL, 11050930, 11050930, mkr_minefield, 11050930)
	end
end
	
-- this sets the capture importance for every entity in the group to the desired level, and does it for every AI player
function _SetAICaptureImportance(group, level, player)

	local _ResetPoint = function(gid, idx, eid)
		AI_SetCaptureImportanceBonus(player, eid, level)
	end
	
	if AI_IsEnabled(player) then
		EGroup_ForEach(group, _ResetPoint)
	end
	
end

-- Modify VP capture importance as the game goes on --
-- Helps the AI go after the correct Victory Point --
function Voronezh_ChangeCaptureImportance()
	if Team_OwnsEGroup(TEAM_ALLIES, eg_vp_west) then
		_SetAICaptureImportance(eg_vp_west, 10001, player3)
		_SetAICaptureImportance(eg_vp_west, 12500, player4)
	else
		-- Enemy
		_SetAICaptureImportance(eg_vp_west, 0, player3)
		_SetAICaptureImportance(eg_vp_west, 0, player4)
		-- Ally
		_SetAICaptureImportance(eg_vp_west, 15000, player1)
	end
	
	if Team_OwnsEGroup(TEAM_ALLIES, eg_vp_north) then
		_SetAICaptureImportance(eg_vp_north, 12500, player3)
		_SetAICaptureImportance(eg_vp_north, 10001, player4)
	else
		-- Enemy
		_SetAICaptureImportance(eg_vp_north, 0, player3)
		_SetAICaptureImportance(eg_vp_north, 0, player4)
		-- Ally
		_SetAICaptureImportance(eg_vp_north, 15000, player2)
	end
	
	if Team_OwnsEGroup(TEAM_ALLIES, eg_vp_east) then
		_SetAICaptureImportance(eg_vp_east, 15000, player3)
		_SetAICaptureImportance(eg_vp_east, 15000, player4)
	else
		_SetAICaptureImportance(eg_vp_east, 0, player3)
		_SetAICaptureImportance(eg_vp_east, 0, player4)
	end
end

-- WIN MESSAGE --
function VPVictoryMessage()
	if (EVENTS) and (EVENTS.VPVictoryMessage) then
		Rule_RemoveAll()
		Team_GetAll(TEAM_ENEMIES, sg_miscellany, eg_miscellany)
		EGroup_Filter(eg_miscellany, {EBP.SOVIET.HQ_MP, EBP.SOVIET.BARRACKS_MP, EBP.SOVIET.MOTORPOOL_MP, EBP.SOVIET.TANK_DEPOT_MP}, FILTER_KEEP)
		Modify_ReceivedDamage(sg_miscellany, 10)
		Modify_ReceivedDamage(eg_miscellany, 10)
		Modify_ReceivedAccuracy(sg_miscellany, 100)
		Modify_ReceivedAccuracy(eg_miscellany, 100)
		Modify_Armor(sg_miscellany, 0.1)
		Modify_Armor(eg_miscellany, 0.1)
		Util_StartIntel(EVENTS.VPVictoryMessage)
		Rule_AddOneShot(_outroStukaBomb1, 21)
		Rule_AddOneShot(_outroStukaBomb2, 24)
		Rule_AddOneShot(_outroComplete, 40)
		Rule_RemoveIfExist(VPTicker_DelayedWin)
		if not Rule_Exists(Voronezh_BurnEnemyBase) then
			Player_SetAbilityAvailability(player3, BP_GetAbilityBlueprint("fire_dot"), ITEM_UNLOCKED)
			Player_AddAbility(player3, BP_GetAbilityBlueprint("fire_dot"))
			Rule_AddInterval(Voronezh_BurnEnemyBase, 20)
		end
	end
end

function _outroStukaBomb1()
	Team_GetAllSquadsNearMarker(TEAM_ALLIES, sg_miscellany, mkr_enemyBaseBox)
	SGroup_DeSpawn(sg_miscellany)
	Player_AddAbility(player1, ABILITY.GERMAN.STUKA_FRAGMENTATION_BOMB)
	Player_SetAbilityAvailability(player1, ABILITY.GERMAN.STUKA_FRAGMENTATION_BOMB, ITEM_UNLOCKED)
	Cmd_Ability(player1, ABILITY.GERMAN.STUKA_FRAGMENTATION_BOMB, mkr_enemyBaseEntrance, Marker_GetPosition(mkr_enemyBase_rear), true)
end

function _outroStukaBomb2()
	Player_AddAbility(player2, ABILITY.GERMAN.STUKA_FRAGMENTATION_BOMB)
	Player_SetAbilityAvailability(player2, ABILITY.GERMAN.STUKA_FRAGMENTATION_BOMB, ITEM_UNLOCKED)
	Cmd_Ability(player2, ABILITY.GERMAN.STUKA_FRAGMENTATION_BOMB, mkr_enemyBase_rear, Marker_GetPosition(mkr_enemyBaseEntrance), true)
end

function _outroComplete()
	World_SetTeamWin (Player_GetTeam(World_GetPlayerAt(1)))
	World_SetGameOver()
	nis_stop()
	Game_Letterbox(false, 0)
end	

-- AI base nerf --
-- Make the AI's base quicker to destroy if the player is going to win by annihilate --
function Voronezh_IsPlayerNearEnemyBase()
	if Team_CanSee(TEAM_HUMANS, mkr_enemyBaseEntrance, ANY) then
		Rule_RemoveMe()
		Rule_AddInterval(Voronezh_IsEnemyBaseFalling, 1)
	end
end

function Voronezh_IsEnemyBaseFalling()
	if SGroup_IsEmpty(sg_e_baseDefenders) then
		Rule_RemoveMe()
		Team_GetAllEntitiesNearMarker(TEAM_ENEMIES, eg_miscellany, mkr_enemyBaseBox)
		EGroup_Filter(eg_miscellany, EBP.SOVIET.MACHINE_GUN_NEST_MP, FILTER_REMOVE)
		Modify_ReceivedDamage(eg_miscellany, 3)
		Modify_Armor(eg_miscellany, 0.5)
		if not Rule_Exists(Voronezh_BurnEnemyBase) then
			Player_SetAbilityAvailability(player3, BP_GetAbilityBlueprint("fire_dot"), ITEM_UNLOCKED)
			Player_AddAbility(player3, BP_GetAbilityBlueprint("fire_dot"))
			Rule_AddInterval(Voronezh_BurnEnemyBase, 20)
		end
	end
end

-- Set enemy base buildings on fire if the player is going to win by annihilate
function Voronezh_BurnEnemyBase()
	Team_GetAllEntitiesNearMarker(TEAM_ENEMIES, eg_miscellany, mkr_enemyBaseBox)
	EGroup_Filter(eg_miscellany, EBP.SOVIET.MACHINE_GUN_NEST_MP, FILTER_REMOVE)
	if not EGroup_IsEmpty(eg_miscellany) and (Team_CanSee(TEAM_HUMANS, mkr_enemyBaseEntrance, ANY) or Team_CanSee(TEAM_HUMANS, mkr_enemyBase_rear, ANY)) then
		local f = function (gid, idx, entity)
			Cmd_Ability(player3, BP_GetAbilityBlueprint("fire_dot"), entity, nil, true)
		end
		EGroup_ForEach(eg_miscellany, f)
	end
end

--Attacks on Player 1's base, if player team is doing well--
function Voronezh_WestBankAttack1()
	if VPTicker_GetTeamTickers(0) >= 350 or g_difficulty == GD_HARD then
		Voronezh_SpawnWestBankAttackers1()
		Util_StartIntel(EVENTS.AttackWarning1)
	end
end

function Voronezh_WestBankAttack2()
	if VPTicker_GetTeamTickers(0) >= 250 or g_difficulty == GD_HARD then
		Voronezh_SpawnWestBankAttackers2()
		Util_StartIntel(EVENTS.AttackWarning2)
	end
end

--Attacks on Player 2's base, on Normal and Hard--
function Voronezh_EastBankAttack1()
	Voronezh_SpawnEastBankAttackers1()
	Util_StartIntel(EVENTS.CityAttackWarning1)
	if g_difficulty == GD_NORMAL then
		Objective_UpdateText(SOBJ_ArmorIncoming, 11050550, 11050550, false)
		Objective_StartTimer(SOBJ_ArmorIncoming, COUNT_DOWN, g_secondAttackTimer, 30)
	end
end

function Voronezh_EastBankAttack2()
	Voronezh_SpawnEastBankAttackers2()
	Util_StartIntel(EVENTS.CityAttackWarning2)
	if g_difficulty == GD_NORMAL then
		Objective_StartTimer(SOBJ_ArmorIncoming, COUNT_DOWN, g_thirdAttackTimer, 30)
	end
end

function Voronezh_EastBankAttack3()
	Voronezh_SpawnEastBankAttackers3()
	Util_StartIntel(EVENTS.CityAttackWarning3)
	Cmd_Ability(player3, ABILITY.SOVIET.IL_2_PRECISION_BOMB_STRIKE, mkr_bombOnWall, nil, true)
	if g_difficulty == GD_NORMAL then
		Objective_StopTimer(SOBJ_ArmorIncoming)
		Objective_Show(SOBJ_ArmorIncoming, false)
	end
end 

--- AI ALLY buffs and nerfs ---
--- Ensure that people playing solo can have a decent experience with an AI ally ---
function Voronezh_AiAllySetup()
	if AI_IsAIPlayer(player1) then
		local player1Squads = Player_GetSquads(player1)
		SGroup_Filter(player1Squads, SBP.GERMAN.PIONEER_SQUAD_MP, FILTER_KEEP)
		Cmd_InstantUpgrade(player1Squads, UPG.GERMAN.PIONEER_MINESWEEPER_MP)
		local player1Squads = Player_GetSquads(player1)
		SGroup_Filter(player1Squads, SBP.GERMAN.PIONEER_SQUAD_MP, FILTER_REMOVE)
		local armorMod = Util_DifVar({1.3, 1.15, 1})
		local weaponMod = Util_DifVar({1.3, 1.15, 1})
		Modify_Armor(player1Squads, armorMod)
		Modify_WeaponPenetration(player1Squads, "hardpoint_01", weaponMod)
		AI_SetPersonality(player1, "tow_voronezh_ally_armor")
		Rule_AddInterval(Voronezh_Player1RepairPioneers, 10)
		EGroup_SetWorldOwned(eg_mines)
	elseif AI_IsAIPlayer(player2) then
		Player_AddResource(player2, RT_Munition, 200)
		AI_SetPersonality(player2, "tow_voronezh_ally_infantry")
	end
end

function Voronezh_Player1RepairPioneers()
	if SGroup_Count(sg_p1_repairPioneers) < 1 then
		Util_CreateSquads(player1, sg_p1_repairPioneers, SBP.GERMAN.PIONEER_SQUAD_MP, mkr_repairPioneers)
		if AI_IsEnabled(player1) then
			AI_LockSquads(player1, sg_p1_repairPioneers)
		end
	elseif Prox_AreSquadsNearMarker(sg_p1_repairPioneers, mkr_repairPioneers, ALL, 30) == false then
		Cmd_Move(sg_p1_repairPioneers, mkr_repairPioneers)
	elseif SGroup_IsDoingAbility(sg_p1_repairPioneers, ABILITY.SOVIET.SOVIET_REPAIR_ABILITY_MP, ANY) == false then
		Player_GetAllSquadsNearMarker(player1, sg_miscellany, mkr_p1_base, 20)
		SGroup_Filter(sg_miscellany, SBP.GERMAN.PIONEER_SQUAD_MP, FILTER_REMOVE)
		if not SGroup_IsEmpty(sg_miscellany) then
			local f = function(gid, idx, sid)
				if Squad_GetHealthPercentage(sid) < 1 then 
					SGroup_Clear(sg_miscellany)
					SGroup_Add(sg_miscellany, sid)
					Cmd_Ability(sg_p1_repairPioneers, ABILITY.SOVIET.SOVIET_REPAIR_ABILITY_MP, sg_miscellany, nil, true, true)
					return true
				end
			end
			SGroup_ForEach(sg_miscellany, f)
		end
	end
end
	

--- ENEMY AI Personalities ---
--- Special priorities for capturing and attacking territories and victory points ---
function Voronezh_EnemyAiSetup()
	if AI_IsAIPlayer(player3) then
		AI_SetPersonality(player3, "tow_voronezh_enemy1")
	end
	if AI_IsAIPlayer(player4) then
		AI_SetPersonality(player4, "tow_voronezh_enemy2")
	end
end

function Voronezh_EnemyStartingSquads()
	-- Tell pre-spawned AT gun to defend the enemy base
	Team_GetAllSquadsNearMarker(TEAM_ENEMIES, sg_e_startingSquads, mkr_enemyBaseBox)
	SGroup_Filter(sg_e_startingSquads, SBP.SOVIET.M1942_ZIS_3_76MM_AT_GUN_SQUAD_MP, FILTER_KEEP)
	encID_startingAT = Encounter:ConvertSgroup(sg_e_startingSquads)
	if AI_IsEnabled(player4) then
		AI_LockSquads(player4, encID_startingAT.sgroup)
	end
	local goalData = {
		name = "Defend",
		target = mkr_enemyBase_rear,
		leashRange = 25,
		range = 50,
		coordinatedSetup = true,
		coordinatedSetupFacingPositions = {
			mkr_enemyBaseEntrance,
		},
		useSkirmishAI = true,
		tacticControlsList = {
			{
				tacticType = TACTIC_Cover,
				priority = -1,
			},
		},
	}
	encID_startingAT:SetGoal(goalData)
	
	-- Tell pre-spawned scout car to patrol the major northern road
	Team_GetAllSquadsNearMarker(TEAM_ENEMIES, sg_e_startingSquads, mkr_enemyBaseBox)
	SGroup_Filter(sg_e_startingSquads, SBP.SOVIET.M3A1_SCOUT_CAR_SQUAD_MP, FILTER_KEEP)
	encID_startingCar = Encounter:ConvertSgroup(sg_e_startingSquads)
	if AI_IsEnabled(player4) then
		AI_LockSquads(player4, encID_startingCar.sgroup)
	end
	local goalData = {
		name = "Defend",
		target = mkr_carPatrol1,
		patrolParams = {
			path = "scoutCar1",
			wait = 5,
			attackMove = true,
		}
	}
	encID_startingCar:SetGoal(goalData)
	
end

---- Enemy Commander Abilities -----
---- Fear Propaganda Barrage (player3) and Scorched Earth Policy (player4) ----
function Voronezh_FearPropaganda()

	if World_GetGameTime() >= time_last_propaganda_or_scorchedearth then		-- both scorched earth and propaganda set this time when they occur, so these two things shouldn't happen on top of each other
		
		local player2Squads = Player_GetSquads(player2)
		local list = {
			SBP.GERMAN.STUKA_GROUND_ANTI_TANK_SQUAD_MP,
			SBP.GERMAN.STUKA_AIR_CAP_SQUAD_MP,
			SBP.GERMAN.STUKA_GROUND_ATTACK_SQUAD_MP,
			SBP.GERMAN.STUKA_SMOKE_SQUAD_MP,
			SBP.GERMAN.STUKA_GROUND_FRAGMENTATION_SQUAD_MP,
		}
		SGroup_Filter(player2Squads, list, FILTER_REMOVE)
		local f = function(gid, idx, sid)
			if Squad_IsAttacking(sid, 5) and Squad_IsInHoldEntity(sid) == false and Squad_IsInHoldSquad(sid) == false and Squad_GetPosition(sid).y <= 15 then		-- try to discount aircraft, their positions are weird
				if not Squad_IsPinned(sid) and not Squad_IsRetreating(sid) then
					SGroup_Clear(sg_p_fearTarget)
					SGroup_Add(sg_p_fearTarget, sid)
					-- Ensure target squads aren't in the players' bases
					if Prox_AreSquadsNearMarker(sg_p_fearTarget, mkr_p1_base, ANY) == false and Prox_AreSquadsNearMarker(sg_p_fearTarget, mkr_p2_base, ANY) == false then
						FOW_PlayerRevealArea(player3, SGroup_GetPosition(sg_p_fearTarget), 5, 1)
						EventCue_Create(CUE.NORMAL, 11050798, 11050798, SGroup_GetPosition(sg_p_fearTarget), 11050798, nil, 30, true) -- LOCDB [11050798] 'Soviet Propaganda Barrage' 
						Rule_RemoveIfExist(Voronezh_DelayedFirePropArty)
						Rule_AddOneShot(Voronezh_DelayedFirePropArty, 5)
						if g_fearSuccess == nil then
							Util_StartIntel(EVENTS.FearPropaganda)
						end
						g_fearSuccess = true
						return true
					end
				end
			end
		end
		SGroup_ForEach(player2Squads, f)
		
		if g_fearSuccess then
			
			Rule_RemoveMe()
			
			time_last_propaganda_or_scorchedearth = World_GetGameTime() + 30 + 120		-- (30 secs duration, plus two minutes)
			
			local delay = Util_DifVar({World_GetRand(11*60, 13*60), World_GetRand(9*60, 11*60), World_GetRand(7*60, 9*60)})
			Rule_AddDelayedInterval(Voronezh_FearPropaganda, delay, 5)
			g_fearSuccess = false
			
		end
		
	end
	
end

function Voronezh_DelayedFirePropArty()
	if not SGroup_IsEmpty(sg_p_fearTarget) then
		local pos = Util_GetPosition(sg_p_fearTarget)
		pos.y = 10		-- fix the y position (it was occasionally was underground!)
		Cmd_Ability(player3, ABILITY.SOVIET.FEAR_PROPAGANDA_ARTILLERY, pos, nil, true)
	end
end

function Voronezh_ScorchedEarth()
	
	if World_GetGameTime() >= time_last_propaganda_or_scorchedearth then			-- both scorched earth and propaganda set this time when they occur, so these two things shouldn't happen on top of each other
		
		Team_GetAll(TEAM_ENEMIES, sg_miscellany, eg_miscellany)
		EGroup_Filter(eg_miscellany, {BP_GetEntityBlueprint("territory_point"), BP_GetEntityBlueprint("victory_point")}, FILTER_KEEP)
		local position = EGroup_GetPosition(eg_vp_east)
		if not EGroup_IsEmpty(eg_miscellany) then
			local strat = EGroup_GetSpawnedEntityAt(eg_miscellany, 1)
			position = Entity_GetPosition(strat)
		end
		position.z = position.z + 1.5
		position.x = position.x - 3.5
		EventCue_Create(CUE.NORMAL, 11050799, 11050799, position, 11050799, nil, 30, true) -- LOCDB [11050799] 'Soviet Artillery Overwatch is Active'
		Cmd_Ability(player4, g_scorchAbilityBP, nil, nil, true)
		
		if g_scorchSpeechIndex == nil then
			Util_StartIntel(EVENTS.ScorchedEarthStart)
			g_scorchSpeechIndex = 1
		elseif g_scorchSpeechIndex == 1 then
			Util_StartIntel(EVENTS.ScorchedEarth1)
			g_scorchSpeechIndex = 2
		elseif g_scorchSpeechIndex == 2 then
			Util_StartIntel(EVENTS.ScorchedEarth2)
			g_scorchSpeechIndex = 1
		end
		
		time_last_propaganda_or_scorchedearth = World_GetGameTime() + 75 + 120		-- (75 secs duration, plus two minutes)
		
		Rule_RemoveMe()
		
		local delay = Util_DifVar({World_GetRand(13*60, 15*60), World_GetRand(11*60, 13*60), World_GetRand(9*60, 11*60)})
		Rule_AddDelayedInterval(Voronezh_ScorchedEarth, delay, 5)
		
	end
	
end
	
--- Speech/Narrative Events ---
function Voronezh_Speech_AttackEnemyBase()
	if Team_OwnsEGroup(TEAM_ALLIES, eg_allVPs, ALL) then
		Rule_RemoveMe()
		Util_StartIntel(EVENTS.AllVpsCaptured)
	end
end

function Voronezh_Speech_CrossTheRiver()
	Player_GetAllSquadsNearMarker(player1, sg_miscellany, mkr_city)
	SGroup_Filter(sg_miscellany, SBP.GERMAN.PIONEER_SQUAD_MP, FILTER_REMOVE)
	if SGroup_IsEmpty(sg_miscellany) then
		Rule_RemoveMe()
		Util_StartIntel(EVENTS.BridgeReminder)
	end
end


--- HAXX ---
function Mission_Remove1941Upgrade()
	if Player_HasUpgrade(player1, BP_GetUpgradeBlueprint("theatre_of_war_1941")) then
		Player_RemoveUpgrade(player1, BP_GetUpgradeBlueprint("theatre_of_war_1941"))
	end
	if Player_HasUpgrade(player2, BP_GetUpgradeBlueprint("theatre_of_war_1941")) then
		Player_RemoveUpgrade(player2, BP_GetUpgradeBlueprint("theatre_of_war_1941"))
	end
	if Player_HasUpgrade(player3, BP_GetUpgradeBlueprint("theatre_of_war_1941")) then
		Player_RemoveUpgrade(player3, BP_GetUpgradeBlueprint("theatre_of_war_1941"))
	end
	if Player_HasUpgrade(player4, BP_GetUpgradeBlueprint("theatre_of_war_1941")) then
		Player_RemoveUpgrade(player4, BP_GetUpgradeBlueprint("theatre_of_war_1941"))
	end
end

function Voronezh_ClearWrecks()
	Util_ClearWrecksFromMarker(mkr_clearWrecks1, nil, g_voronezh_wrecks)
	Util_ClearWrecksFromMarker(mkr_clearWrecks2, nil, g_voronezh_wrecks)
	Util_ClearWrecksFromMarker(mkr_clearWrecks3, nil, g_voronezh_wrecks_small)
	Util_ClearWrecksFromMarker(mkr_clearWrecks4, nil, g_voronezh_wrecks_small)
	Util_ClearWrecksFromMarker(mkr_clearWrecks5, nil, g_voronezh_wrecks_small)
end
