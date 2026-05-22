-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- Act 3 - Mission 1
-- Poznan
-- Designer: Neil
-- Dates: 24 January � 23 February 1945
-------------------------------------------------------------------------
-------------------------------------------------------------------------
import("ScarUtil.scar")
import("Beginner.scar")
import("Systems/AiManager/ai.scar")
import("Prototype/DeploymentPoints.scar")
import("Order227.scar")
import("Global_Values/CampaignGlobalConstants.scar")

g_isWinterMap = true

-------------------------------------------------------------------------
-- [[ SETUP ]]
-------------------------------------------------------------------------

function OnGameSetup()
	
	-- Required Players
	player1 = Setup_Player(1, 11040467, "soviet", 1)		-- player1 is always the human player				-- LOCDB [11040467] '8th Guards Army'
	player2 = Setup_Player(2, 11040468, "german", 2)		-- player2 is always the AI opponent				-- LOCDB [11040468] 'Festung Posen Garrison'
	player3 = Setup_Player(3, 11040469, "soviet", 1)		-- player3 is always the AI ally					-- LOCDB [11040469] '69th Army Rifle Division'

end

function OnGameRestore()
	
	-- function takes care of restoring all global mission parameters after a save/load
	player1 = World_GetPlayerAt(1)
	player2 = World_GetPlayerAt(2)
	player3 = World_GetPlayerAt(3)
	
	if ai_enabled_player3 == false then AI_Enable(player3, false) end

	Game_DefaultGameRestore()
	
end

function NIS_Init()
	
	NIS_Start = "SP/CoH2_Campaign/M12-Poznan/nis/m12_camera_start2"
	nis_load(NIS_Start)

	NIS_Obj2a = "SP/CoH2_Campaign/M12-Poznan/nis/m12_camera_obj2a"
	nis_load(NIS_Obj2a)
	
	NIS_Obj2b = "SP/CoH2_Campaign/M12-Poznan/nis/m12_camera_obj2b"
	nis_load(NIS_Obj2b)
	
	NIS_Finish = "SP/CoH2_Campaign/M12-Poznan/nis/m12_camera_finish"
	nis_load(NIS_Finish)

	
	nis_setintransitiontime(0)
	nis_setouttransitiontime(1)
	
end
Scar_AddInit(NIS_Init)



-------------------------------------------------------------------------
-- [[ ONINIT ]]
-------------------------------------------------------------------------

function OnInit()

	Game_StartMuted(true)
	Game_FadeToBlack(FADE_OUT, 0)
	Game_SetMode(UI_Cinematic)
	
	sg_temp = SGroup_CreateIfNotFound("sg_temp")
	eg_temp = EGroup_CreateIfNotFound("eg_temp")
	sg_blah = SGroup_CreateIfNotFound("sg_blah")
	eg_blah = EGroup_CreateIfNotFound("eg_blah")
	sg_single = SGroup_CreateIfNotFound("sg_single")
	eg_single = EGroup_CreateIfNotFound("eg_single")
	
	sg_mergehints = SGroup_CreateIfNotFound("sg_mergehints")
	sg_reinforcehints = SGroup_CreateIfNotFound("sg_reinforcehints")
	eg_reinforcehints = EGroup_CreateIfNotFound("eg_reinforcehints")
	
	sg_nis_guys = SGroup_CreateIfNotFound("sg_nis_guys")
	sg_isu152 = SGroup_CreateIfNotFound("sg_isu152")
	sg_bastion1 = SGroup_CreateIfNotFound("sg_bastion1")
	sg_bastion2 = SGroup_CreateIfNotFound("sg_bastion2")
	sg_bastion3 = SGroup_CreateIfNotFound("sg_bastion3")
	sg_bastion1_artillery = SGroup_CreateIfNotFound("sg_bastion1_artillery")
	sg_bastion2_artillery = SGroup_CreateIfNotFound("sg_bastion2_artillery")
	sg_bastion3_artillery = SGroup_CreateIfNotFound("sg_bastion3_artillery")
	sg_bastion1_atguns = SGroup_CreateIfNotFound("sg_bastion1_atguns")
	sg_bastion2_atguns = SGroup_CreateIfNotFound("sg_bastion2_atguns")
	sg_bastion3_atguns = SGroup_CreateIfNotFound("sg_bastion3_atguns")
	sg_artillery_targets = SGroup_CreateIfNotFound("sg_artillery_targets")
	sg_walldefenders = SGroup_CreateIfNotFound("sg_walldefenders")
	sg_walldefenders1 = SGroup_CreateIfNotFound("sg_walldefenders1")
	sg_walldefenders2 = SGroup_CreateIfNotFound("sg_walldefenders2")
	sg_walldefenders1_atguns = SGroup_CreateIfNotFound("sg_walldefenders1_atguns")
	sg_walldefenders2_atguns = SGroup_CreateIfNotFound("sg_walldefenders2_atguns")
	sg_leftBridge_harassers = SGroup_CreateIfNotFound("sg_leftBridge_harassers")
	sg_rightBridge_harassers = SGroup_CreateIfNotFound("sg_rightBridge_harassers")
	
	sg_cityambush1 = SGroup_CreateIfNotFound("sg_cityambush1")
	sg_cityambush2 = SGroup_CreateIfNotFound("sg_cityambush2")
	sg_cityambush3 = SGroup_CreateIfNotFound("sg_cityambush3")
	sg_cityambush4 = SGroup_CreateIfNotFound("sg_cityambush4")
	sg_cityambush5 = SGroup_CreateIfNotFound("sg_cityambush5")
	sg_cityambush6 = SGroup_CreateIfNotFound("sg_cityambush6")
	sg_cityambush7 = SGroup_CreateIfNotFound("sg_cityambush7")
	sg_cityambush8 = SGroup_CreateIfNotFound("sg_cityambush8")
	sg_cityambush9 = SGroup_CreateIfNotFound("sg_cityambush9")
	sg_cityambush10 = SGroup_CreateIfNotFound("sg_cityambush10")
	sg_cityambush11 = SGroup_CreateIfNotFound("sg_cityambush11")
	sg_cityambush12 = SGroup_CreateIfNotFound("sg_cityambush12")
	sg_cityambush13 = SGroup_CreateIfNotFound("sg_cityambush13")
	sg_cityambush14 = SGroup_CreateIfNotFound("sg_cityambush14")
	sg_cityambush15 = SGroup_CreateIfNotFound("sg_cityambush15")
	sg_usedplayersquads = SGroup_CreateIfNotFound("sg_usedplayersquads")
	
	sg_randomattackers = SGroup_CreateIfNotFound("sg_randomattackers")
	
	sg_garrison_hq1 = SGroup_CreateIfNotFound("sg_garrison_hq1")
	sg_garrison_hq2 = SGroup_CreateIfNotFound("sg_garrison_hq2")
	sg_hq1tigers = SGroup_CreateIfNotFound("sg_hq1tigers")
	sg_hq2tigers = SGroup_CreateIfNotFound("sg_hq2tigers")
	sg_hq1extras = SGroup_CreateIfNotFound("sg_hq1extras")
	sg_hq2extras = SGroup_CreateIfNotFound("sg_hq2extras")
	sg_bonus_penalbattalions = SGroup_CreateIfNotFound("sg_bonus_penalbattalions")
	
	sg_fortress_atgunL1 = SGroup_CreateIfNotFound("sg_fortress_atgunL1")
	sg_fortress_atgunL2 = SGroup_CreateIfNotFound("sg_fortress_atgunL2")
	sg_fortress_atgunR1 = SGroup_CreateIfNotFound("sg_fortress_atgunR1")
	sg_fortress_atgunR2 = SGroup_CreateIfNotFound("sg_fortress_atgunR2")
	sg_fortress_frontL1 = SGroup_CreateIfNotFound("sg_fortress_frontL1")
	sg_fortress_frontL2 = SGroup_CreateIfNotFound("sg_fortress_frontL2")
	sg_fortress_frontR1 = SGroup_CreateIfNotFound("sg_fortress_frontR1")
	sg_fortress_frontR2 = SGroup_CreateIfNotFound("sg_fortress_frontR2")
	sg_fortress_extras = SGroup_CreateIfNotFound("sg_fortress_extras")
	sg_fortress_extras_atgun1 = SGroup_CreateIfNotFound("sg_fortress_extras_atgun1")
	sg_fortress_extras_atgun2 = SGroup_CreateIfNotFound("sg_fortress_extras_atgun2")
	
	sg_citadel_howitzer = SGroup_CreateIfNotFound("sg_citadel_howitzer")
	
	
	timer_patience = 0			-- timer id's
	timer_mortarhits = 1
	
	
	--[[ PRESET DEBUG CONDITIONS ]]
	Mission_Debug()
	
	--[[ SET RESTRICTIONS ]]
	Mission_Restrictions()
	
	--[[ SET AI ]]
	Mission_CpuInit()
	
	--[[ SET DIFFICULTY ]]
	Mission_Difficulty()
	
	--[[ MISSION PRESETS ]]
	Mission_MissionPreset()
	
	--[[MISC SETUP]]
	World_EnableSharedLineOfSight(player1, player3, false)			-- disable shared LOS for the time being (it gets re-enabled when P3 announces his presence)
	UI_SetSoviet227Visibility(true)									-- some UI thingamajigs
	EGroup_EnableMinimapIndicator(eg_territorypoints_stage2, false)	-- hide minimap symbols for territory point that are currently in the soft map edge
	EGroup_EnableMinimapIndicator(eg_territorypoints_stage3, false)
	
	--[[ AUTOSAVE NAMES ]]
	-- 11049963 -- LOCDB [11049963] 'Mission 12 - Autosave 1'
	-- 11049964 -- LOCDB [11049964] 'Mission 12 - Autosave 2'
	-- 11049965 -- LOCDB [11049965] 'Mission 12 - Autosave 3'

	--[[ REGISTER OBJECTIVES ]]
	Initialize_Objective1()
	Initialize_Objective2()
	Initialize_Objective3()
	Initialize_ObjectiveBonus()
	
	--[[ GAME START CHECK ]]
	Rule_AddOneShot(Mission_Start, 1)

end

Scar_AddInit(OnInit)



function Audio_Init()

	Sound_PreCacheSoundFolder("single_player/m12")
	Sound_PreCacheSinglePlayerSpeech("mission/m12")
	g_MissionSpeechPath = "mission/m12"

end
Scar_AddInit(Audio_Init)





function Mission_Debug()
	
	-- looks for the command line option [-debug]
	if Misc_IsCommandLineOptionSet("debug") then
		g_debug = true
	end
	
	
end



function Mission_Restrictions()

	-- set up mission-specific abilities
	Player_CompleteUpgrade(player1, BP_GetUpgradeBlueprint("mission12_upgrade"))		-- unlocks all the passive upgrades for M12: Shock Troops, ISU-152, HM 120mm Mortar
	Player_CompleteUpgrade(player3, BP_GetUpgradeBlueprint("mission12_upgrade"))
	Order227_Init(105, nil, true)
	ConscriptProgression_AudioInit()

	Player_AddAbility(player1, ABILITY.SOVIET.IL_2_RECON_SP)
	Player_AddAbility(player1, ABILITY.SOVIET.IL_2_SUPPORT_SP)
	Player_AddAbility(player1, ABILITY.SOVIET.BASE_CONSCRIPT_DISPATCH)
	Player_AddAbility(player1, ABILITY.SOVIET.FRONTOVIKI_CONSCRIPT_DISPATCH)
	Player_AddAbility(player1, ABILITY.SOVIET.PENAL_TROOP_DISPATCH_SP)
	
	Player_AddAbility(player3, ABILITY.SOVIET.BASE_CONSCRIPT_DISPATCH)
	Player_AddAbility(player3, ABILITY.SOVIET.FRONTOVIKI_CONSCRIPT_DISPATCH)
	Player_AddAbility(player3, ABILITY.SOVIET.PENAL_TROOP_DISPATCH_SP)
	
	-- some cleanups to the player's tech tree 
	Player_SetSquadProductionAvailability(player1, SBP.SOVIET.GUARDS_TROOPS, ITEM_REMOVED)
	Player_SetSquadProductionAvailability(player1, SBP.SOVIET.IS_2, ITEM_REMOVED)
	
	-- add some 'hidden' abilities so they can be triggered by script
	Player_AddAbility(player1, ABILITY.SOVIET.IL_2_RECON_SINGLEPASS_SP)
	Player_AddAbility(player2, ABILITY.GLOBAL.M12_HOWITZER_BARRAGE)
	Player_SetAbilityAvailability(player1, ABILITY.SOVIET.IL_2_RECON_SINGLEPASS_SP, ITEM_REMOVED)
	
end



function Mission_CpuInit()

	-- re-initialise player 3 (the "ally") as a skirmish AI player
	AI_RestartSCAR(player3)
	
	-- ...but switch him off for now (we only enable him after the sitrep)
	AI_Enable(player3, false)
	ai_enabled_player3 = false
	
end



function Mission_Difficulty()

	-- get the difficulty
	g_difficulty = Game_GetSPDifficulty() 									-- set a global difficulty variable 
	
	t_difficulty = {
		starting_manpower 			= Util_DifVar( {600, 600, 600, 600} ),	-- Easy, Medium, Hard, Hardest (harder-er than hard)
		starting_munition			= Util_DifVar( {150, 150, 150, 150} ), 
		starting_fuel 				= Util_DifVar( {50,  50,  50,  50 } ), 
		starting_commandpoints		= Util_DifVar( {1,   1,   1,   1  } ), 
		penal_battalion_size		= Util_DifVar( {6,   5,   4,   3  } ),
		recon_flight_squad_size		= Util_DifVar( {4,   3,   2,   2  } ),
		patience_timer				= Util_DifVar( {40,  24,  12,  10 } ),	-- how long the player has before their ability to build is locked out (starts a few mins after P3 leaves map)
		randomattacker_frequency	= Util_DifVar( {240, 150, 90,  60 } ),
		mortarthit_interval_min		= Util_DifVar( {75,  45,  25,  20 } ),
		mortarthit_interval_max		= Util_DifVar( {100, 75,  45,  25 } ),
		resourcecap_manpower		= Util_DifVar( {3001,2001,1501,0  } ),
		resourcecap_munition		= Util_DifVar( {601, 501, 301, 0  } ),
		resourcecap_fuel			= Util_DifVar( {401, 401, 201, 0  } ),
		
	}	
	
	-- set grenade timers (per difficulty)
	Modify_ProjectileDelayTime(player2, BP_GetEntityBlueprint("bundled_stielgranate_campaign"), CAMPAIGN_PGREN_BUNDLED_TIMER)
	
	-- default encounter settings are for NORMAL, so if it's EASY or HARD we need to apply some modifiers to the AI encounter system
	if g_difficulty == GD_EASY then
		
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
					tacticType = TACTIC_Pickup,
					priority = -1,
				},
			},
		}
		
		t_defaultGoalData_defendEasy = {
			
			retaliateAttacks = true,			
			
			tacticControlsList = {
				{
					tacticType = TACTIC_Cover,
					priority = 1,
					retryTimeSecs = 8,
					waitTimeSecs = 30,
				},
				{
					tacticType = TACTIC_Retaliate,
					priority = 1,
					retryTimeSecs = 8,
					waitTimeSecs = 15,
				},
				{
					tacticType = TACTIC_Vehicle,
					priority = -1,
				},
				{
					tacticType = TACTIC_Pickup,
					priority = -1,
				},
			},
		}
		
		AIAttackGoal_AdjustDefaultGoalData(t_defaultGoalData_attackEasy)
		AIDefendGoal_AdjustDefaultGoalData(t_defaultGoalData_defendEasy)	
		
		t_goalData_attackEasy = { 
			range_Multiplier = 0.9,
			movePathLengthFactor_Multiplier = 0.8,
			safeMoveWeight_Multiplier = 0.75,
		}
		
		t_goalData_defendEasy = { 
			range_Multiplier = 0.9,
			leashRange_Multiplier = 0.9,
			maxAttackers_Multiplier = -2,
			safeMoveWeight_Multiplier = 0.75,
		}
		
		AIAttackGoal_SetModifyGoalData(t_goalData_attackEasy)
		AIDefendGoal_SetModifyGoalData(t_goalData_defendEasy)
		
		
	elseif g_difficulty == GD_NORMAL then
		
		t_defaultGoalData_defendNormal = {
			
			retaliateAttacks = true,	
			
		}			
		
		AIDefendGoal_AdjustDefaultGoalData(t_defaultGoalData_defendNormal)	
		
		
	elseif g_difficulty == GD_HARD then
		
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
					retryTimeSecs = 2,
					waitTimeSecs = 2,
				},
				{
					tacticType = TACTIC_RushAtTarget,
					priority = 5,
					retryTimeSecs = 8,
					waitTimeSecs = 20,
				},
				{
					tacticType = TACTIC_Pickup,
					priority = 10,
					retryTimeSecs = 5,
					waitTimeSecs = 15,
				},
			},
		}
		
		t_defaultGoalData_defendHard = {
			
			retaliateAttacks = true,			
			retaliateAttackRange = 150,	
			
			tacticControlsList = {
				{
					tacticType = TACTIC_Cover,
					priority = 15,
					retryTimeSecs = 10,
					waitTimeSecs = 10,
				},
				{
					tacticType = TACTIC_Retaliate,
					priority = 10,
					retryTimeSecs = 2,
					waitTimeSecs = 2,
				},
				{
					tacticType = TACTIC_Vehicle,
					priority = 5,
					retryTimeSecs = 2,
					waitTimeSecs = 2,
				},
				{
					tacticType = TACTIC_Pickup,
					priority = 2,
					retryTimeSecs = 5,
					waitTimeSecs = 15,
				},
			},
		}
		
		AIAttackGoal_AdjustDefaultGoalData(t_defaultGoalData_attackHard)
		AIDefendGoal_AdjustDefaultGoalData(t_defaultGoalData_defendHard)	
		
		t_goalData_attackHard = { 		
			range_Multiplier = 1.2,
			movePathLengthFactor_Multiplier = 1.2,
			leashRange_Multiplier = 1.2,
			safeMoveWeight_Multiplier = 1.25,
		}
		t_goalData_defendHard = { 
			range_Multiplier = 1.2,
			movePathLengthFactor_Multiplier = 1.2,
			leashRange_Multiplier = 1.2,
			safeMoveWeight_Multiplier = 1.25,
		}		
		
		AIAttackGoal_SetModifyGoalData(t_goalData_attackHard)
		AIDefendGoal_SetModifyGoalData(t_goalData_defendHard)
		
	end
	
	if g_difficulty <= GD_NORMAL then
		Player_CompleteUpgrade(player2, BP_GetUpgradeBlueprint("panzerfaust_slow"))	
		ABILITY.GERMAN.PANZER_GRENADIER_BUNDLED_GRENADE = ABILITY.GERMAN.PANZER_GRENADIER_BUNDLED_CAMPAIGN
	end

end

-------------------------------------------------------------------------
-- MISSION Preset 
-------------------------------------------------------------------------

function Mission_MissionPreset()

	-- Kicks off after SCAR Inits, but before MissionStart is called.
	-- Use for spawning units on the map at the start

	-- set up the starting economy
	Player_SetResource(player1, RT_Manpower, t_difficulty.starting_manpower)
	Player_SetResource(player1, RT_Munition, t_difficulty.starting_munition)
	Player_SetResource(player1, RT_Fuel, t_difficulty.starting_fuel)
	Player_SetResource(player1, RT_Command, t_difficulty.starting_commandpoints)
	
	Player_SetResource(player3, RT_Manpower, t_difficulty.starting_manpower)
	Player_SetResource(player3, RT_Munition, t_difficulty.starting_munition)
	Player_SetResource(player3, RT_Fuel, t_difficulty.starting_fuel)
	Player_SetResource(player3, RT_Command, t_difficulty.starting_commandpoints)

	Modify_PlayerResourceCap(player1, RT_Manpower, t_difficulty.resourcecap_manpower, MUT_Addition)
	Modify_PlayerResourceCap(player1, RT_Munition, t_difficulty.resourcecap_munition, MUT_Addition)
	Modify_PlayerResourceCap(player1, RT_Fuel, t_difficulty.resourcecap_fuel, MUT_Addition)

	Modify_PlayerResourceCap(player3, RT_Manpower, t_difficulty.resourcecap_manpower, MUT_Addition)
	Modify_PlayerResourceCap(player3, RT_Munition, t_difficulty.resourcecap_munition, MUT_Addition)
	Modify_PlayerResourceCap(player3, RT_Fuel, t_difficulty.resourcecap_fuel, MUT_Addition)
	
	Player_SetPopCapOverride(player1, 120)
	Player_SetPopCapOverride(player2, 100)
	Player_SetPopCapOverride(player3, 100)
	
	Modify_PlayerResourceRate(player1, RT_Manpower, 1.1)
	
	-- lock out air support abilities for now
	Player_SetAbilityAvailability(player1, ABILITY.SOVIET.IL_2_SUPPORT_SP, ITEM_REMOVED)
	Player_SetAbilityAvailability(player1, ABILITY.SOVIET.IL_2_RECON_SP, ITEM_REMOVED)
	
	-- set up the two bridges to blow during objective 1
	EGroup_SetDemolitions(player2, eg_leftWallBridge, 4)
	EGroup_SetDemolitions(player2, eg_rightWallBridge, 4)
	EGroup_SetInvulnerable(eg_bridges, true)
	
	-- set up ice heal rate to be a little faster than normal
	World_SetIceHealingRate(0.0075)
	
end

-------------------------------------------------------------------------
-- MISSION START 
-------------------------------------------------------------------------

function Mission_Start()

	Util_PlayMovie("m12_cin01", 0, 0)
	Rule_AddInterval(Mission_StartB, 1)
	AI_SetPersonality(player3, "campaign_m12_poznan")
	
end
function Mission_StartB()
	
	if Event_IsAnyRunning() == false then
		
		Rule_RemoveMe()
		
		UI_SetCPMeterVisibility(false)
		
		Util_StartIntel(EVENTS.Poznan_Intro)
		
		-- roll tanks in 
		Cmd_Move(sg_su76_01, mkr_su76dest_01)
		Cmd_Move(sg_su76_02, mkr_su76dest_02)
		Cmd_Move(sg_shock_01, mkr_shockdest_01)
		Cmd_Move(sg_shock_02, mkr_shockdest_02)
		Cmd_Move(sg_sniper_01, mkr_sniperdest_01)
		Cmd_Move(sg_engineers_01, mkr_engineerdest_01)
		
		Rule_Add(Mission_StartC)
		Rule_AddInterval(Mission_Fail_HQ_Destroyed, 6)
		
	end
	
end


function Mission_StartC()

	if Event_IsAnyRunning() == false then
		
		Rule_RemoveMe()
		
		Util_PlayMovie("m12_sitrep", 0, 1)
		Rule_AddOneShot(Mission_StartD, 1.5)
		
		-- change the music
		Sound_PlayMusic("streamed/music/missions/m12/m12_cue_start", 4, 0)
		
	end
	
end

function Mission_StartD()

	-- start the first objective (after a short pause)
	Rule_AddOneShot(Objective1_Start, 2)

	-- initialise things that can happen regardless of objectives, etc.
	Poznan_CityAmbushes_Init()
	
	-- hints about merging into damaged squads and reinforcing from halftracks and HQs
	Poznan_UpdateHintGroups()
	BeginnerHint_AddOpportunity(sg_mergehints, HINT_MERGE, true, nil, nil, nil, GD_EASY)
	BeginnerHint_AddOpportunity(sg_reinforcehints, HINT_REINFORCE, true, nil, nil, nil, GD_EASY)
	Rule_AddInterval(Poznan_UpdateHintGroups, 30)
	
--~ 	-- short cut to obj 3
--~ 	Rule_AddInterval(Objective3_Start, 1)
--~ 	World_IncreaseInteractionStage()
	
end

function Poznan_UpdateHintGroups()

	local conscripts = {
		SBP.SOVIET.BASE_CONSCRIPT_SQUAD,
		SBP.SOVIET.CONSCRIPT_SQUAD,
		SBP.SOVIET.PENAL_BATTALION,
	}
	Player_GetAll(player1, sg_mergehints)
	SGroup_Filter(sg_mergehints, conscripts, FILTER_KEEP)
	
	
	local infantry = {}
	local _add = function(k, v) table.insert(infantry, v) end
	table.foreach(LIST.INFANTRY, _add)
	table.foreach(LIST.ATGUNS, _add)
	table.foreach(LIST.HMGS, _add)
	
	Player_GetAll(player1, sg_reinforcehints)
	SGroup_Filter(sg_reinforcehints, infantry, FILTER_KEEP)

	
end












--------------------------------------------------------
--------------------------------------------------------
-- 
-- Objective 1:
-- Break the city walls
--
--------------------------------------------------------
--------------------------------------------------------

function Initialize_Objective1()

	OBJ_1 = {
		
		SetupUI = function() 
			-- no hints to start... they get added later in an update once you are through the wall
		end,
		
		OnStart = function()
			
			Rule_AddDelayedInterval(Poznan_AnnouncePresenceOfP3, 20, 0.5)
			Rule_AddInterval(Poznan_ThroughWalls, 1)
			
			-- start the check for objective completion
			Rule_AddInterval(Objective1_CheckLeftPoint, 1)
			Rule_AddInterval(Objective1_CheckRightPoint, 1)
			Rule_AddInterval(Objective1_Check, 1)
			
		end,
		
		OnComplete = function()
			
			BeginnerHint_RemoveAllOpportunities()
			BeginnerHint_AddOpportunity(sg_mergehints, HINT_MERGE, true, nil, nil, nil, GD_EASY)
			BeginnerHint_AddOpportunity(sg_reinforcehints, HINT_REINFORCE, true, nil, nil, nil, GD_EASY)
			
			Util_Autosave(11049963) -- LOCDB [11049963] 'Mission 12 - Autosave 1'
			
		end,
		
		OnFail = function()
			-- Calls from Objective_Fail(OBJ_1)
			-- Fires off before Intel_Fail (unless Intel_Fail is nil)			
		end,
		
		IsComplete = function()
			return false
		end,
		
		Intel_Start = EVENTS.Obj1_Intro,-- Event will play when obj starts but before any UI appears
		Intel_Complete = nil,			-- Event will play when obj completes but before UI is cleared
		Intel_Fail = nil,				-- Event will play when obj fails but before UI is cleared
		Title = 11036202,				-- LOCDB [11036202] 'Establish a foothold in the city'
		Description = 11036202,			-- LOCDB [11036202] 'Establish a foothold in the city'
		Type = OT_Primary,				-- Objective Type (OT_Primary, OT_Secondary)
		
	}
	OBJ_1a = {
		SetupUI = function()
			hp_id_gate = Objective_AddUIElements(OBJ_1, mkr_objective_maingate, true, 11043191, true)	
		end,
		OnComplete = function()
			Objective_RemoveUIElements(OBJ_1, hp_id_gate)
		end,
		Title = 11043191,				-- LOCDB [11043191] 'Breach the main gate'
		Description = 11043191,														
		Type = OT_Primary,
		Parent = OBJ_1,
	}

	OBJ_1b = {
		SetupUI = function()
			hp_id_1 = Objective_AddUIElements(OBJ_1, eg_flag_wall1, true, 11036203, true, 2.8)		-- LOCDB [11036203] 'Capture territory'
			hp_id_2 = Objective_AddUIElements(OBJ_1, eg_flag_wall2, true, 11036203, true, 2.8)
		end,
		OnComplete = function()
			Objective_RemoveUIElements(OBJ_1, hp_id_1)
			Objective_RemoveUIElements(OBJ_1, hp_id_2)
		end,
		Title = 11045636,				-- LOCDB [11045636] 'Capture territory inside Poznan's wall'
		Description = 11045636,														
		Type = OT_Primary,
		Parent = OBJ_1,
	}
	
	Objective_Register(OBJ_1)
	Objective_Register(OBJ_1a)
	Objective_Register(OBJ_1b)

end



function Objective1_Start()

	-- get sector id's for the bastions
	sectorid_bastion1 = World_GetTerritorySectorID(EGroup_GetPosition(eg_leftBastion))
	sectorid_wall1 = World_GetTerritorySectorID(EGroup_GetPosition(eg_flag_wall1))
	sectorid_bastion2 = World_GetTerritorySectorID(EGroup_GetPosition(eg_middleBastion))
	sectorid_wall2 = World_GetTerritorySectorID(EGroup_GetPosition(eg_flag_wall2))
	sectorid_bastion3 = World_GetTerritorySectorID(EGroup_GetPosition(eg_rightBastion))
	
	-- spawn the guys defending the bastions and the walls
	Poznan_Bastions_Init()
	Poznan_WallDefenders_Init()
	Poznan_Harassers_Init()
	
	-- monitor the bastions
	Rule_AddDelayedInterval(Poznan_Bastion1_Retreat, 0, 6)
	Rule_AddDelayedInterval(Poznan_Bastion2_Retreat, 2, 6)
	Rule_AddDelayedInterval(Poznan_Bastion3_Retreat, 4, 6)
	
	-- manage the artillery guns
	bastion_artilley_callout = 1
	bastion_artilley_callout_time = 0
	Rule_AddInterval(Poznan_Bastion_ArtilleryManager, 5)
	Rule_AddInterval(Poznan_Bastion_CallOutArtillery, 3)
	Rule_AddInterval(Poznan_ReconFlights, 25)
	
	-- blow up bridges if the payer gets close
	EGroup_SetInvulnerable(eg_leftWallBridge, true)
	EGroup_SetInvulnerable(eg_rightWallBridge, true)
	Rule_AddInterval(Poznan_BlowUpBridges, 3)
	
	-- switch on AI for player 3 and set up its initial capture targets
	AI_Enable(player3, true)
	ai_enabled_player3 = true
	AI_UnlockAll(player3)
	local _ZeroOutPoint = function(gid, idx, eid)
		AI_SetCaptureImportanceBonus(player3, eid, 0)
	end
	EGroup_ForEach(eg_flags_all, _ZeroOutPoint)
	AI_SetCaptureImportanceBonus(player3, EGroup_GetSpawnedEntityAt(eg_flag_wall2, 1), 100)
	AI_SetCaptureImportanceBonus(player3, EGroup_GetSpawnedEntityAt(eg_flag_wallbastion2, 1), 25)
	AI_SetCaptureImportanceBonus(player3, EGroup_GetSpawnedEntityAt(eg_flag_wallbastion3, 1), 25)
	
	-- set up info for tracking the player taking out wall sections later on
	t_wallhints = {
		{group = LAYER_destroyablewall1, marker = mkr_hint_destroyablewall1},
		{group = LAYER_destroyablewall2, marker = mkr_hint_destroyablewall2},
		{group = LAYER_destroyablewall3, marker = mkr_hint_destroyablewall3},
		{group = LAYER_destroyablewall4, marker = mkr_hint_destroyablewall4},
		{group = LAYER_destroyablewall5, marker = mkr_hint_destroyablewall5},
		{group = LAYER_destroyablewall6a, marker = mkr_hint_destroyablewall6a},
		{group = LAYER_destroyablewall6b, marker = mkr_hint_destroyablewall6b},
	}
	for index, hint in pairs(t_wallhints) do 
		hint.original_count = EGroup_Count(hint.group)
	end
	
	
	Objective_Start(OBJ_1, true)
	Objective_Start(OBJ_1a, false)

end

--
-- OBJECTIVE IS COMPLETE if either of the two territory points inside the wall are captured (either by you or your ally)
--
function Objective1_Check()
	
	if Event_IsAnyRunning() == false then
		
		-- check for the first point being captured
		if obj1_firstpoint == "P1" then
			
			Rule_RemoveMe()
			
			Util_StartIntel(EVENTS.Obj1_PointCapturedP1)
			
			Objective_Complete(OBJ_1b, false)
			Rule_AddInterval(Objective1_CheckB, 0.5)
			
		elseif obj1_firstpoint == "P3" then
			
			Rule_RemoveMe()
			
			Util_StartIntel(EVENTS.Obj1_PointCapturedP3)
			
			Objective_Complete(OBJ_1b, false)
			Rule_AddInterval(Objective1_CheckB, 0.5)
			
		end
		
	end
	
end
function Objective1_CheckB()

	if Event_IsAnyRunning() == false then
		
		Rule_RemoveMe()
		
		Objective_Complete(OBJ_1)
		Rule_AddDelayedInterval(Objective2_Start, 3, 1)
		
	end
	
end


function Objective1_CheckLeftPoint()

	if Player_OwnsEGroup(player1, eg_flag_wall1) then
		
		Rule_RemoveMe()
		
		if obj1_firstpoint == nil then
			obj1_firstpoint = "P1"
		else
			obj1_secondpoint = "P1"
		end
		
	elseif Player_OwnsEGroup(player3, eg_flag_wall1) then
		
		Rule_RemoveMe()
		
		if obj1_firstpoint == nil then
			obj1_firstpoint = "P3"
		else
			obj1_secondpoint = "P3"
		end
		
	end
	
end
function Objective1_CheckRightPoint()

	if Player_OwnsEGroup(player1, eg_flag_wall2) then
		
		Rule_RemoveMe()
		
		if obj1_firstpoint == nil then
			obj1_firstpoint = "P1"
		else
			obj1_secondpoint = "P1"
		end
		
	elseif Player_OwnsEGroup(player3, eg_flag_wall2) then
		
		Rule_RemoveMe()
		
		if obj1_firstpoint == nil then
			obj1_firstpoint = "P3"
		else
			obj1_secondpoint = "P3"
		end
		
	end
	
end


--
-- starts a wave of recon flights
--
function Poznan_ReconFlights()
	
	if Objective_IsComplete(OBJ_1) == true then
		
		Rule_RemoveMe()
		
	else
		
		-- pick a random set of the flyby markers
		local all_recon_markers = {
			mkr_recon_01,
			mkr_recon_02,
			mkr_recon_03,
			mkr_recon_04,
			mkr_recon_05,
			mkr_recon_06,
			mkr_recon_07,
		}
		t_recon_flybys = Table_GetRandomItem(all_recon_markers, t_difficulty.recon_flight_squad_size)
		
		-- call enough staggered individual flights
		Rule_AddInterval(Poznan_ReconFlight_Individual, 3.5)
		
	end
	
end

function Poznan_ReconFlight_Individual()

	-- get the position/direction of the first marker in the table
	local marker = t_recon_flybys[1]
	local position = Marker_GetPosition(marker)
	local direction = Marker_GetDirection(marker)
	
	Cmd_Ability(player1, ABILITY.SOVIET.IL_2_RECON_SINGLEPASS_SP, position, direction, true)
	
	-- remove this marker, so next pass takes the next one...
	table.remove(t_recon_flybys, 1)
	
	-- ...unless it was the last marker, in which case stop this rule
	if #t_recon_flybys == 0 then
		Rule_RemoveMe()
	end
	
end




--
-- these are the guys that wander around in front of the bridges - the first guys you come across
--
function Poznan_Harassers_Init()
	
	local encData = {
		name = "Left Bridge Harassment",
		player = player2,
		spawn = mkr_leftBridge_fallback1,
		sgroups = {sg_leftBridge_harassers},
		units = {
			{
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD, 
				upgrades = UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM,
				spawn = mkr_leftBridge_spawn1,
			},
			{
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD, 
				upgrades = UPG.GERMAN.LIGHT_INFANTRY_PACKAGE,
				spawn = mkr_leftBridge_spawn2,
			},
			{
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD, 
				upgrades = UPG.GERMAN.LIGHT_INFANTRY_PACKAGE,
				spawn = mkr_leftBridge_spawn3,
			},
		},
	}
	local goalData = {
		name = "Attack",
		target = mkr_leftBridge_harass,
		patrolParams = {
			name = "Patrol",
			marker = mkr_leftBridge_patrol,
		},
		fallbackParams = {
			thresholdType = Threshold_PercentageHealth,
			thresholds = {0.7},
			markers = {mkr_leftBridge_fallback1},
			retreat = true,
			retreatDespawn = false,
			globalPercentage = 0.3,
		},
		onTransition = Poznan_Harassers_BridgeFallback1,
	}
	
	enc_harassers_left = Encounter:Create(encData)
	enc_harassers_left:SetGoal(goalData)
	
	
	
	local encData = {
		name = "Right Bridge Harassment",
		player = player2,
		spawn = mkr_rightBridge_fallback1,
		sgroups = {sg_rightBridge_harassers},
		units = {
			{
				sbp = SBP.GERMAN.GRENADIER_SQUAD, 
				spawn = mkr_rightBridge_spawn1,
			},
			{
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD, 
				upgrades = UPG.GERMAN.LIGHT_INFANTRY_PACKAGE,
				spawn = mkr_rightBridge_spawn2,
			},
			{
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD, 
				upgrades = UPG.GERMAN.LIGHT_INFANTRY_PACKAGE,
				spawn = mkr_rightBridge_spawn3,
			},
		},
	}
	local goalData = {
		name = "Attack",
		target = mkr_rightBridge_harass,
		patrolParams = {
			name = "Patrol",
			marker = mkr_rightBridge_patrol,
		},
		fallbackParams = {
			thresholds = {0.7},
			markers = {mkr_rightBridge_fallback1},
			retreat = true,
		},
	}
	
	enc_harassers_right = Encounter:Create(encData)
	enc_harassers_right:SetGoal(goalData)
	
end


function Poznan_Harassers_BridgeFallback1(encounter, state)

	if state == AIObjectiveStage_Fallback then
		
		local goal = encounter:GetGoalData()
		
		if goal.fallbackParams.thresholds[1] == 0.7 then
			
			goal.fallbackParams.thresholds = {0.3}
			goal.fallbackParams.markers = {mkr_leftBridge_fallback1}
			goal.onTransition = Poznan_Harassers_BridgeFallback2 
			encounter:SetGoal(goal)
			
		end
		
	end
	
end
function Poznan_Harassers_BridgeFallback2(encounter, state)
	
	if state == AIObjectiveStage_Fallback then
		
		local goal = encounter:GetGoalData()
		
		if goal.fallbackParams.thresholds[1] == 0.3 then
			
			goal.fallbackParams.markers = {mkr_leftBridge_fallback2}
			goal.onTransition = nil
			encounter:SetGoal(goal)
			
		end
		
	end
	
end


function Poznan_Bastions_Init()
	
	-- create units in bastion 1
	Util_CreateSquads(player2, sg_bastion1, SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD, mkr_bastion1a, nil, 1, 2)		-- these are on the "offmap" side of the bastion, so just for show really
	Util_CreateSquads(player2, sg_bastion1, SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD, mkr_bastion1b, nil, 1, 2)
	Util_CreateSquads(player2, sg_bastion1_atguns, SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD, mkr_bastion1c, nil, 1, 3)
	Util_CreateSquads(player2, sg_bastion1_atguns, SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD, mkr_bastion1d)
	Util_CreateSquads(player2, sg_bastion1, SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD, mkr_bastion1e)
	Util_CreateSquads(player2, sg_bastion1, SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD, mkr_bastion1f)

	SGroup_AddGroup(sg_bastion1, sg_bastion1_atguns)
	Cmd_InstantSetupTeamWeapon(sg_bastion1)
	

	-- create units in bastion 2
	Util_CreateSquads(player2, sg_bastion2, SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD, mkr_bastion2a)
	Util_CreateSquads(player2, sg_bastion2, SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD, mkr_bastion2b)
	Util_CreateSquads(player2, sg_bastion2_atguns, SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD, mkr_bastion2c)
	Util_CreateSquads(player2, sg_bastion2_atguns, SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD, mkr_bastion2d)
	Util_CreateSquads(player2, sg_bastion2, SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD, mkr_bastion2e)
	Util_CreateSquads(player2, sg_bastion2, SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD, mkr_bastion2f)

	SGroup_AddGroup(sg_bastion2, sg_bastion2_atguns)
	Cmd_InstantSetupTeamWeapon(sg_bastion2)
	

	-- create units in bastion 3
	Util_CreateSquads(player2, sg_bastion3, SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD, mkr_bastion3a, nil, 1, 3)			-- trying to reduce the number of units, and this bastion doesn't get much use
	Util_CreateSquads(player2, sg_bastion3, SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD, mkr_bastion3b, nil, 1, 3)
	Util_CreateSquads(player2, sg_bastion3_atguns, SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD, mkr_bastion3c, nil, 1, 3)
	Util_CreateSquads(player2, sg_bastion3_atguns, SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD, mkr_bastion3d, nil, 1, 3)		-- these are on the "offmap" side of the bastion, so just for show really
	Util_CreateSquads(player2, sg_bastion3, SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD, mkr_bastion3e, nil, 1, 2)
	Util_CreateSquads(player2, sg_bastion3, SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD, mkr_bastion3f, nil, 1, 2)

	SGroup_AddGroup(sg_bastion3, sg_bastion3_atguns)
	Cmd_InstantSetupTeamWeapon(sg_bastion3)

	-- artillery pieces in the bastions
	Util_CreateSquads(player2, sg_bastion1_artillery, SBP.GERMAN.HOWITZER_105MM_LE_FH18_ARTILLERY, mkr_bastion1g)
	Util_CreateSquads(player2, sg_bastion2_artillery, SBP.GERMAN.HOWITZER_105MM_LE_FH18_ARTILLERY, mkr_bastion2g)
	Util_CreateSquads(player2, sg_bastion3_artillery, SBP.GERMAN.HOWITZER_105MM_LE_FH18_ARTILLERY, mkr_bastion3g)
	
	SGroup_AddGroup(sg_bastion1, sg_bastion1_artillery)
	SGroup_AddGroup(sg_bastion2, sg_bastion2_artillery)
	SGroup_AddGroup(sg_bastion3, sg_bastion3_artillery)
	
	SGroup_SetAutoTargetting(sg_bastion1_artillery, "hardpoint_01", false)
	SGroup_SetAutoTargetting(sg_bastion2_artillery, "hardpoint_01", false)
	SGroup_SetAutoTargetting(sg_bastion3_artillery, "hardpoint_01", false)
	
	t_bastionartillery = {
		{ sgroup = sg_bastion1_artillery, last_fired = -120, target = mkr_artyTarget1, dummytargets = {mkr_artyDummyTarget1a, mkr_artyDummyTarget1b, mkr_artyDummyTarget1c} },
		{ sgroup = sg_bastion2_artillery, last_fired = -80,  target = mkr_artyTarget2, dummytargets = {mkr_artyDummyTarget2a, mkr_artyDummyTarget2b, mkr_artyDummyTarget2c} },
		{ sgroup = sg_bastion3_artillery, last_fired = -40,  target = mkr_artyTarget3, dummytargets = {mkr_artyDummyTarget3a, mkr_artyDummyTarget3b, mkr_artyDummyTarget3c} },
	}
	
	BeginnerHint_AddOpportunity(sg_bastion1_atguns, {ABILITY.SOVIET.ISU_152_PIERCING_SHOT_ABILITY, ABILITY.SOVIET.SYNC_MORTAR_BARRAGE_120MM, ABILITY.SOVIET.SU_76_BARRAGE_ABILITY}, true)
	BeginnerHint_AddOpportunity(sg_bastion2_atguns, {ABILITY.SOVIET.ISU_152_PIERCING_SHOT_ABILITY, ABILITY.SOVIET.SYNC_MORTAR_BARRAGE_120MM, ABILITY.SOVIET.SU_76_BARRAGE_ABILITY}, true)
	BeginnerHint_AddOpportunity(sg_bastion3_atguns, {ABILITY.SOVIET.ISU_152_PIERCING_SHOT_ABILITY, ABILITY.SOVIET.SYNC_MORTAR_BARRAGE_120MM, ABILITY.SOVIET.SU_76_BARRAGE_ABILITY}, true)
	

end




function Poznan_Bastion_ArtilleryManager()
	
	for index, artillery in pairs(t_bastionartillery) do 
		
		if SGroup_Count(artillery.sgroup) == 0 or Player_OwnsSGroup(player2, artillery.sgroup, ANY) == false or SGroup_IsRetreating(artillery.sgroup, ANY) or SGroup_HasTeamWeapon(artillery.sgroup, ANY) == false then
			
			-- artillery piece is dead, so remove this entry
			if artillery.threatarrow ~= nil then
				ThreatArrow_DestroyGroup(artillery.threatarrow)
				BeginnerHint_RemoveOpportunity(artillery.sgroup)
			end
			table.remove(t_bastionartillery, index)
			
		elseif (World_GetGameTime() - artillery.last_fired) >= 120 and World_GetRand(1, 3) == 1 then
			
			artillery.last_target = nil
			
			SGroup_Clear(sg_artillery_targets)
			
			Player_GetAllSquadsNearMarker(player1, sg_temp, artillery.target)
			SGroup_AddGroup(sg_artillery_targets, sg_temp)
			Player_GetAllSquadsNearMarker(player3, sg_temp, artillery.target)
			SGroup_AddGroup(sg_artillery_targets, sg_temp)
			
			-- filter out aircraft!
			SGroup_Filter(sg_artillery_targets, LIST.AIRCRAFT, FILTER_REMOVE)
			
			-- filter group to only those the Germans can see
			local _CheckSquad = function(gid, idx, sid)
				if Player_CanSeeSquad(player2, sid, ANY) == false then
					SGroup_Remove(gid, sid)
				end
			end
			SGroup_ForEach(sg_artillery_targets, _CheckSquad)
			
			local target_pos = nil 
			
			if SGroup_CountSpawned(sg_artillery_targets) >= 1 then
				
				-- target one of these guys if there are any left
				target_pos = Util_GetPosition(SGroup_GetRandomSpawnedSquad(sg_artillery_targets)) 
				
			else
				
				-- otherwise just fire randomly into the gun's dummy target area
				target_pos = Util_GetRandomPosition(Table_GetRandomItem(artillery.dummytargets))
				
			end
			
			Cmd_Ability(artillery.sgroup, ABILITY.GERMAN.HOWITZER_105MM_BARRAGE_ABILITY, target_pos)
			FOW_RevealSGroupOnly(artillery.sgroup, 60)
			
			artillery.last_fired = World_GetGameTime()
			artillery.last_target = pos
			if artillery.threatarrow == nil then
				artillery.threatarrow = ThreatArrow_CreateGroup(artillery.sgroup)
				BeginnerHint_AddOpportunity(artillery.sgroup, ABILITY.SOVIET.SYNC_MORTAR_BARRAGE_120MM, false, nil, nil, nil, GD_EASY)
			end
			
		end
		
	end
	
	-- if we've removed all of the artillery pieces, then kill off this rule
	if table.getn(t_bastionartillery) == 0 then
		
		Rule_RemoveMe()
		
	end
	
end


-- call out the artillery if it hits you
function Poznan_Bastion_CallOutArtillery()

	if Objective_IsComplete(OBJ_1) then
		
		Rule_RemoveMe()
		
	elseif Event_IsAnyRunning() == false and (World_GetGameTime() - bastion_artilley_callout_time) > 90 then
		
		SGroup_Clear(sg_temp)
		
		Player_GetAll(player1)
		SGroup_GetLastAttacker(sg_allsquads, sg_temp, 3)
		SGroup_Filter(sg_temp, SBP.GERMAN.HOWITZER_105MM_LE_FH18_ARTILLERY, FILTER_KEEP)
		
		if SGroup_Count(sg_temp) >= 1 then 
			
			if bastion_artilley_callout == 1 then
				
				Util_StartIntel(EVENTS.Obj1_CallOutHowitzer1)
				
				bastion_artilley_callout_time = World_GetGameTime()
				bastion_artilley_callout = 2
				
			elseif bastion_artilley_callout == 2 then
				
				local howitzer = SGroup_GetRandomSpawnedSquad(sg_temp)
				Camera_MoveTo(Util_GetPosition(howitzer), true)
				FOW_RevealArea(Util_GetPosition(howitzer), 10, 20)
				
				Util_StartIntel(EVENTS.Obj1_CallOutHowitzer2)
				
				bastion_artilley_callout_time = World_GetGameTime()
				bastion_artilley_callout = 3
				
				Rule_RemoveMe()
				
			elseif bastion_artilley_callout == 3 then
				
--~ 				local howitzer = SGroup_GetRandomSpawnedSquad(sg_temp)
--~ 				Camera_MoveTo(Util_GetPosition(howitzer), true)
--~ 				FOW_RevealArea(Util_GetPosition(howitzer), 10, 20)
--~ 				
--~ 				Util_StartIntel(EVENTS.Obj1_CallOutHowitzer2)
--~ 				
--~ 				bastion_artilley_callout_time = World_GetGameTime()
--~ 				bastion_artilley_callout = 4
--~ 				
--~ 				Rule_RemoveMe()
				
			end
			
		end
		
	end
	
end




function Poznan_Bastion1_Retreat()		-- Leftmost Bastion
	
	-- reasons for retreat:
	--  * Units reduced to a set number
	--  * Player behind the bastion
	--  * Player has captured the VP
	
	if SGroup_TotalMembersCount(sg_bastion1) <= 10 then
		
		Rule_RemoveMe()
		BeginnerHint_RemoveOpportunity(sg_bastion1_atguns)
		
		if SGroup_Count(sg_bastion1) >= 1 then
			Cmd_StaggeredRetreat(sg_bastion1, {mkr_retreat_bastion1a, mkr_retreat_bastion1b, mkr_retreat_bastion1c})
			Cmd_MoveToAndDespawn(sg_bastion1, mkr_retreat_bastion1a, false)
		end
		
	elseif bastion1_defendstarted ~= true and (Prox_AreTeamsNearMarker(Player_GetTeam(player1), sectorid_bastion1, ANY, nil, LIST.AIRCRAFT, FILTER_REMOVE) or EGroup_IsCapturedByPlayer(eg_flag_wall1, player1, ANY)) then
		
		bastion1_defendstarted = true
		BeginnerHint_RemoveOpportunity(sg_bastion1_atguns)
		
		local goalData = {
			name = "Defend",
			target = mkr_defend_bastion1,
			leashRange = mkr_defend_bastion1,
		}
		enc_bastion1_defend = Encounter:ConvertSgroup(sg_bastion1)
		enc_bastion1_defend:SetGoal(goalData)
		
	end
	
end
	
function Poznan_Bastion2_Retreat()		-- Middle Bastion
	
	if SGroup_TotalMembersCount(sg_bastion2) <= 12 then		
		
		Rule_RemoveMe()
		BeginnerHint_RemoveOpportunity(sg_bastion2_atguns)
		
		if SGroup_Count(sg_bastion2) >= 1 then
			Cmd_StaggeredRetreat(sg_bastion2, {mkr_retreat_bastion2a, mkr_retreat_bastion2b})
			Cmd_MoveToAndDespawn(sg_bastion2, mkr_retreat_bastion2a, false)
		end
		
	elseif bastion2_defendstarted ~= true and (Prox_AreTeamsNearMarker(Player_GetTeam(player1), sectorid_bastion2, ANY, nil, LIST.AIRCRAFT, FILTER_REMOVE) or ( EGroup_IsCapturedByPlayer(eg_flag_wall1, player1, ANY) and EGroup_IsCapturedByPlayer(eg_flag_wall2, player1, ANY) ) ) then
		
		bastion2_defendstarted = true
		BeginnerHint_RemoveOpportunity(sg_bastion2_atguns)
		
		local goalData = {
			name = "Defend",
			target = mkr_defend_bastion2,
			leashRange = mkr_defend_bastion2,
		}
		enc_bastion2_defend = Encounter:ConvertSgroup(sg_bastion2)
		enc_bastion2_defend:SetGoal(goalData)
		
	end
	
end

function Poznan_Bastion3_Retreat()		-- Rightmost Bastion
	
	if SGroup_TotalMembersCount(sg_bastion3) <= 10 then
		
		Rule_RemoveMe()
		BeginnerHint_RemoveOpportunity(sg_bastion3_atguns)
		
		if SGroup_Count(sg_bastion3) >= 1 then
			Cmd_StaggeredRetreat(sg_bastion3, {mkr_retreat_bastion3a, mkr_retreat_bastion3b})
			Cmd_MoveToAndDespawn(sg_bastion3, mkr_retreat_bastion3a, false)
		end
		
	elseif bastion3_defendstarted ~= true and (Prox_AreTeamsNearMarker(Player_GetTeam(player1), sectorid_bastion3, ANY, nil, LIST.AIRCRAFT, FILTER_REMOVE) or EGroup_IsCapturedByPlayer(eg_flag_wall2, player1, ANY)) then
		
		bastion3_defendstarted = true
		BeginnerHint_RemoveOpportunity(sg_bastion3_atguns)
		
		local goalData = {
			name = "Defend",
			target = mkr_defend_bastion3,
			leashRange = mkr_defend_bastion3,
		}
		enc_bastion3_defend = Encounter:ConvertSgroup(sg_bastion3)
		enc_bastion3_defend:SetGoal(goalData)
		
	end
	
end


function Poznan_WallDefenders_Init()
	
	local wall_defenders = {
		
		{marker = mkr_walldefender01, 			grp = sg_walldefenders1,		sbp = SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD,	loadout = nil},	-- next to bastion 1
		{marker = mkr_walldefender02, 			grp = sg_walldefenders1_atguns,	sbp = SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD},						-- left of bridge
		{marker = mkr_walldefender03, 			grp = sg_walldefenders1_atguns,	sbp = SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD},						-- right of bridge
		{marker = mkr_walldefender04, 			grp = sg_walldefenders1,		sbp = SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD,	loadout = nil},	-- next to bastion 2
		
		{marker = mkr_walldefender05, 			grp = sg_walldefenders2,		sbp = SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD,	loadout = nil},	-- next to bastion 2	
		{marker = mkr_walldefender06, 			grp = sg_walldefenders2_atguns,	sbp = SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD,		loadout = 2},
		{marker = mkr_walldefender07, 			grp = sg_walldefenders2,		sbp = SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD},					-- left of bridge
		{marker = mkr_walldefender08, 			grp = sg_walldefenders2_atguns,	sbp = SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD,		loadout = 2},	-- right of bridge
		{marker = mkr_walldefender09, 			grp = sg_walldefenders2,		sbp = SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD,	loadout = 2},
		
		{marker = eg_leftWallBridge_tower1, 	grp = sg_walldefenders1,		sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,		loadout = nil},
		{marker = eg_leftWallBridge_tower2, 	grp = sg_walldefenders1,		sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,		loadout = nil},
		{marker = eg_rightWallBridge_tower1, 	grp = sg_walldefenders2,		sbp = SBP.GERMAN.GRENADIER_SQUAD,				loadout = nil},
		{marker = eg_rightWallBridge_tower2, 	grp = sg_walldefenders2,		sbp = SBP.GERMAN.GRENADIER_SQUAD,				loadout = nil},
		
	}

	for index, defender in pairs(wall_defenders) do
		
		Util_CreateSquads(player2, defender.grp, defender.sbp, defender.marker, nil, nil, defender.loadout)
		
	end
	
	SGroup_AddGroup(sg_walldefenders1, sg_walldefenders1_atguns)
	SGroup_AddGroup(sg_walldefenders2, sg_walldefenders2_atguns)
	
	BeginnerHint_AddOpportunity(sg_walldefenders1_atguns, {ABILITY.SOVIET.SU_76_BARRAGE_ABILITY, ABILITY.SOVIET.SYNC_MORTAR_BARRAGE_120MM}, false, nil, nil, nil, GD_EASY)
	BeginnerHint_AddOpportunity(sg_walldefenders2_atguns, {ABILITY.SOVIET.SU_76_BARRAGE_ABILITY, ABILITY.SOVIET.SYNC_MORTAR_BARRAGE_120MM}, false, nil, nil, nil, GD_EASY)
	
	Cmd_InstantSetupTeamWeapon(sg_walldefenders1)
	Cmd_InstantSetupTeamWeapon(sg_walldefenders2)

	Rule_AddInterval(Poznan_WallDefenders_DefendWall1, 4)
	Rule_AddInterval(Poznan_WallDefenders_DefendWall2, 4)
	
end

-- if players breach the walls, then those defenders reassemble around the point.
function Poznan_WallDefenders_DefendWall1()

	if Prox_AreTeamsNearMarker(Player_GetTeam(player1), sectorid_wall1, ANY, nil, LIST.AIRCRAFT, FILTER_REMOVE) then
		
		Rule_RemoveMe()
		
		BeginnerHint_RemoveOpportunity(sg_walldefenders1_atguns)
		
		-- create some new units at the back (in an area that's in the soft map edge)
		Util_CreateSquads(player2, sg_walldefenders1, SBP.GERMAN.PANZER_GRENADIER_SQUAD, mkr_wall1_reinforce_a, nil, nil, nil, true)
		Util_CreateSquads(player2, sg_walldefenders1, SBP.GERMAN.PANZER_GRENADIER_SQUAD, mkr_wall1_reinforce_c)
		if g_difficulty == GD_HARD then
			Util_CreateSquads(player2, sg_walldefenders1, SBP.GERMAN.PANZER_IV_SQUAD, mkr_wall1_reinforce_b, nil, nil, nil, true, nil, UPG.GERMAN.PANZER_TOP_GUNNER)
			Util_CreateSquads(player2, sg_walldefenders1, SBP.GERMAN.STUG_III_SQUAD, mkr_wall1_reinforce_a, nil, nil, nil, true, nil, UPG.GERMAN.STUG_TOP_GUNNER)
			Util_CreateSquads(player2, sg_walldefenders1, SBP.GERMAN.PANZER_GRENADIER_SQUAD, mkr_wall2_reinforce_c, nil, nil, nil, true, nil, UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM)
		else
			Util_CreateSquads(player2, sg_walldefenders1, SBP.GERMAN.PANZER_IV_SQUAD, mkr_wall1_reinforce_b, nil, nil, nil, true)
			Util_CreateSquads(player2, sg_walldefenders1, SBP.GERMAN.STUG_III_SQUAD, mkr_wall1_reinforce_a, nil, nil, nil, true)
		end
		
		-- put those units AND all remaining wall defenders of this area in a defend encounter
		if SGroup_Count(sg_walldefenders1) >= 1 then
			local goalData = {
				name = "Defend",
				target = mkr_defend_wall1,
				range = Marker_GetProximityRadius(mkr_defend_wall1) + 25,
				leashRange = mkr_defend_wall1,
				retaliateAttacks = true,
			}
			enc_WallDefenders1 = Encounter:ConvertSgroup(sg_walldefenders1)
			enc_WallDefenders1:SetGoal(goalData)
		end
		
	end
	
end

function Poznan_WallDefenders_DefendWall2()

	if Prox_AreTeamsNearMarker(Player_GetTeam(player1), sectorid_wall2, ANY, nil, LIST.AIRCRAFT, FILTER_REMOVE) then
		
		Rule_RemoveMe()
		
		BeginnerHint_RemoveOpportunity(sg_walldefenders2_atguns)
		
		-- create some new units at the back (in an area that's in the soft map edge)
		Util_CreateSquads(player2, sg_walldefenders2, SBP.GERMAN.PANZER_GRENADIER_SQUAD, mkr_wall2_reinforce_a)
		Util_CreateSquads(player2, sg_walldefenders2, SBP.GERMAN.PANZER_GRENADIER_SQUAD, mkr_wall2_reinforce_c, nil, nil, nil, true)
		if g_difficulty == GD_HARD then
			Util_CreateSquads(player2, sg_walldefenders2, SBP.GERMAN.STUG_III_SQUAD, mkr_wall2_reinforce_b, nil, nil, nil, true, nil, UPG.GERMAN.STUG_TOP_GUNNER)
			Util_CreateSquads(player2, sg_walldefenders2, SBP.GERMAN.STUG_III_SQUAD, mkr_wall2_reinforce_c, nil, nil, nil, true, nil, UPG.GERMAN.STUG_TOP_GUNNER)
			Util_CreateSquads(player2, sg_walldefenders2, SBP.GERMAN.PANZER_GRENADIER_SQUAD, mkr_wall2_reinforce_a, nil, nil, nil, true, nil, UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM)
		else
			Util_CreateSquads(player2, sg_walldefenders2, SBP.GERMAN.STUG_III_SQUAD, mkr_wall2_reinforce_b, nil, nil, nil, true)
			Util_CreateSquads(player2, sg_walldefenders2, SBP.GERMAN.STUG_III_SQUAD, mkr_wall2_reinforce_c, nil, nil, nil, true)
		end
		
		-- put those units AND all remaining wall defenders of this area in a defend encounter
		if SGroup_Count(sg_walldefenders2) >= 1 then
			local goalData = {
				name = "Defend",
				target = mkr_defend_wall2,
				range = Marker_GetProximityRadius(mkr_defend_wall2) + 25,
				leashRange = mkr_defend_wall2,
				retaliateAttacks = true,
			}
			enc_WallDefenders2 = Encounter:ConvertSgroup(sg_walldefenders2)
			enc_WallDefenders2:SetGoal(goalData)
		end
		
	end
	
end


--
-- blow up the bridges when the player gets close, and provide hints at taking out the walls afterwards
--
function Poznan_BlowUpBridges()
	
	if Objective_IsComplete(OBJ_1) then
		
		Rule_RemoveMe()
		
	else
		
		if (EGroup_Count(eg_leftWallBridge) >= 1 and Player_CanSeePosition(player1, Util_GetPosition(eg_leftWallBridge)) and Prox_ArePlayersNearMarker(player1, Util_GetPosition(eg_leftWallBridge), ANY, 50, LIST.AIRCRAFT, FILTER_REMOVE))
		or (SGroup_CountSpawned(sg_leftBridge_harassers) >= 1 and Prox_AreSquadMembersNearMarker(sg_leftBridge_harassers, mkr_leftBridge_fallback2, ALL)) then
			
			EGroup_SetInvulnerable(eg_leftWallBridge, false)
			
			World_DamageIce(Util_GetPosition(eg_leftWallBridge), 8, 15, 250, 0)
			
			Modify_ReceivedDamage(eg_leftWallBridge, 10)
			Cmd_DetonateDemolitions(player2, eg_leftWallBridge)
			
			Rule_AddOneShot(Poznan_BridgeBlown, 3)
			Rule_AddDelayedInterval(Poznan_HintWalls_Init, 11, 1)
			Rule_RemoveMe()
			
		elseif EGroup_Count(eg_rightWallBridge) >= 1 and Player_CanSeePosition(player1, Util_GetPosition(eg_rightWallBridge)) and Prox_ArePlayersNearMarker(player1, Util_GetPosition(eg_rightWallBridge), ANY, 50, LIST.AIRCRAFT, FILTER_REMOVE) then
			
			EGroup_SetInvulnerable(eg_rightWallBridge, false)
			
			World_DamageIce(Util_GetPosition(eg_rightWallBridge), 8, 15, 250, 0)
			
			Modify_ReceivedDamage(eg_rightWallBridge, 10)
			Cmd_DetonateDemolitions(player2, eg_rightWallBridge)
			
			Rule_AddOneShot(Poznan_BridgeBlown, 3)
			Rule_AddDelayedInterval(Poznan_HintWalls_Init, 11, 1)
			Rule_RemoveMe()
			
		end
		
	end

end

function Poznan_BridgeBlown()
	Util_StartIntel(EVENTS.Obj1_BridgeOut)
end


-- Mention the alternate way for getting into Poznan, and add hintpoints to the walls
function Poznan_HintWalls_Init()
	
	if Event_IsAnyRunning() == false then
		
		Rule_RemoveMe()
		
		Util_StartIntel(EVENTS.Obj1_HintAtCrushingWalls)
		
		Rule_AddInterval(Poznan_HintWalls_InitB, 1)
		
	end
	
end
function Poznan_HintWalls_InitB()
	
	if Event_IsAnyRunning() == false then
		
		Rule_RemoveMe()
		
		-- update the objective title
		Objective_RemoveUIElements(OBJ_1, hp_id_gate)
		Objective_UpdateText(OBJ_1a, 11036201, 11036201)											-- LOCDB [11036201] 'Breach the city walls'
		
		-- bring in an ISU-152
		Util_CreateSquads(player1, sg_isu152, SBP.SOVIET.ISU_152, mkr_isuspawn_01, mkr_isudest_01)
		EventCue_Create(CUE.VEHICLE_BUILT, 11037836, 0, sg_isu152)									-- LOCDB [11037836] 'ISU-152 on site'
		
		-- add hintpoints to all of the destroyable wall sections...
		for index, hint in pairs(t_wallhints) do 
			hint.hpid = HintPoint_Add(hint.marker, true, 11036204)									-- LOCDB [11036204] 'Weak wall section'
			EGroup_SetPlayerOwner(hint.group, player2)
		end
		
		-- ...and kick off the manager that removes those hints as necessary
		Rule_AddInterval(Poznan_HintWalls_Manage, 0.5)
		
	end
	
end
function Poznan_HintWalls_Manage()
	
	local hints_remaining = false
	
	for index, hint in pairs(t_wallhints) do 
		if hint.hpid ~= nil then
			if (Objective_IsComplete(OBJ_1) or EGroup_Count(hint.group) < hint.original_count) then
				HintPoint_Remove(hint.hpid)
				hint.hpid = nil 
			else
				hints_remaining = true		-- flag that there are still some hints remaining (so we don't remove this rule)
			end
		end
	end
	
	if hints_remaining == false then
		Rule_RemoveMe()
	end
	
end


-- when the first player gets through the wall, call it out with some speech
function Poznan_ThroughWalls()
	
	if Event_IsAnyRunning() == false then
		
		local event_to_play = nil 
		
		if Prox_ArePlayersNearMarker(player1, mkr_wall_inside, ANY, nil, LIST.AIRCRAFT, FILTER_REMOVE) then
			event_to_play = EVENTS.Obj1_ThroughWallP1
		elseif Prox_ArePlayersNearMarker(player3, mkr_wall_inside, ANY, nil, LIST.AIRCRAFT, FILTER_REMOVE) then
			event_to_play = EVENTS.Obj1_ThroughWallP3
		end
		
		
		if event_to_play ~= nil then
			
			Rule_RemoveMe()
			
			Objective_Complete(OBJ_1a, false)
			
			Util_StartIntel(event_to_play)
			Rule_AddInterval(Poznan_ThroughWallsB, 0.5)
			
		end
		
	end
	
end
function Poznan_ThroughWallsB()

	if Event_IsAnyRunning() == false then
		
		Rule_RemoveMe()
		
		Objective_Start(OBJ_1b, true)
		
	end
	
end























--------------------------------------------------------
--------------------------------------------------------
--
-- Objective 2:
-- Capture the two outposts
--
--------------------------------------------------------
--------------------------------------------------------

function Initialize_Objective2()

	OBJ_2 = {
		
		SetupUI = function() 
			-- none, the UI is set up in the subobjectives
		end,
		
		OnStart = function()
			
			-- open up the next area of the map 
			World_IncreaseInteractionStage()
			EGroup_EnableMinimapIndicator(eg_territorypoints_stage2, true)
			
			-- set up rules to manage the HQs
			Rule_AddInterval(Poznan_ApproachHQ1, 0.5)
			Rule_AddInterval(Poznan_ApproachHQ2, 0.5)
			
			-- set up some events that need to happen during this objective
			Rule_AddDelayedInterval(ObjectiveBonus_Start, 25, 1)
			Rule_AddOneShot(Poznan_RandomAttacks_Init, 20)
			Rule_AddOneShot(Poznan_MortarHits_Init, 20)
			
			-- start the check for objective completion
			Rule_AddInterval(Objective2_Check, 1)
			
		end,
		
		OnComplete = function()
			
			BeginnerHint_RemoveAllOpportunities()
			BeginnerHint_AddOpportunity(sg_mergehints, HINT_MERGE, true, nil, nil, nil, GD_EASY)
			BeginnerHint_AddOpportunity(sg_reinforcehints, HINT_REINFORCE, true, nil, nil, nil, GD_EASY)
			
			Util_Autosave(11049964) -- LOCDB [11049964] 'Mission 12 - Autosave 2'
			
		end,
		
		OnFail = function()
			-- Calls from Objective_Fail(OBJ_1)
			-- Fires off before Intel_Fail (unless Intel_Fail is nil)			
		end,
		
		IsComplete = function()
			return false
		end,
		
		Intel_Start = EVENTS.Obj2_Intro,-- Event will play when obj starts but before any UI appears
		Intel_Complete = nil,			-- Event will play when obj completes but before UI is cleared
		Intel_Fail = nil,				-- Event will play when obj fails but before UI is cleared
		Title = 11036205,				-- LOCDB [11036205] 'Establish Forward Position in city'
		Description = 11036206,			-- LOCDB [11036206] 'Clear out the two major German outposts in the city'
		Type = OT_Primary,				-- Objective Type (OT_Primary, OT_Secondary)
	}

	OBJ_2a = {
		SetupUI = function()
			hpid_hq1 = Objective_AddUIElements(OBJ_2, mkr_arrow_objective2a, true, 11036207, true)		-- LOCDB [11036207] 'Capture or destroy the Outpost'
		end,
		OnComplete = function()
			Objective_RemoveUIElements(OBJ_2, hpid_hq1)
		end,
		Title = 11036207,
		Description = 11036687,															-- LOCDB [11036687] 'Capture or destroy the Outpost, located at the square in the west of the city'
		Type = OT_Primary,
		Parent = OBJ_2,
	}

	OBJ_2b = {
		SetupUI = function()
			hpid_hq2 = Objective_AddUIElements(OBJ_2, mkr_arrow_objective2b, true, 11036208, true)		-- LOCDB [11036208] 'Capture or destroy the City Hall'
		end,
		OnComplete = function()
			Objective_RemoveUIElements(OBJ_2, hpid_hq2)
		end,
		Title = 11036208,
		Description = 11036688,															-- LOCDB [11036688] 'Capture or destroy the City Hall, located at the market square in the east of the city'
		Type = OT_Primary,
		Parent = OBJ_2,
	}
	
	Objective_Register(OBJ_2)
	Objective_Register(OBJ_2a)
	Objective_Register(OBJ_2b)
	
end





function Objective2_Start()

	if Event_IsAnyRunning() == false then
		
		Rule_RemoveMe()
		Rule_AddOneShot(Objective2_StartB, 4)
		
	end
	
end
function Objective2_StartB()

	-- set up ai preferences for this part of the mission
	AI_SetCaptureImportanceBonus(player3, EGroup_GetSpawnedEntityAt(eg_flag_wall2, 1), 40)			-- reduce importance of Obj1's territories
	AI_SetCaptureImportanceBonus(player3, EGroup_GetSpawnedEntityAt(eg_flag_wallbastion2, 1), 10)
	AI_SetCaptureImportanceBonus(player3, EGroup_GetSpawnedEntityAt(eg_flag_wallbastion3, 1), 10)
	AI_SetCaptureImportanceBonus(player3, EGroup_GetSpawnedEntityAt(eg_flag_city2, 1), 50)			-- these are Ob2's territories
	AI_SetCaptureImportanceBonus(player3, EGroup_GetSpawnedEntityAt(eg_flag_city5, 1), 50)
	
	local _Entity = function(gid, idx, eid)
		AI_SetMilitaryPointImportance(player3, eid, 100)
	end
	EGroup_ForEach(eg_hq2, _Entity)
	
	local _Entity = function(gid, idx, eid)
		AI_SetMilitaryPointImportance(player3, eid, 75)
	end
	EGroup_ForEach(eg_hq1, _Entity)
	
	-- start up the objectives
	Objective_Start(OBJ_2)
	Objective_Start(OBJ_2a, false)	-- do these two silently, as we're already showing the parent objective title
	Objective_Start(OBJ_2b, false)	-- 

	Rule_AddDelayedInterval(Objective2_StartC, 4, 1)
	
end
function Objective2_StartC()

	if Event_IsAnyRunning() == false then
		
		Rule_RemoveMe()
		
		Rule_AddOneShot(Objective2_StartD, 3)
		
	end
	
end
function Objective2_StartD()

	-- unlock player's air support abilities
	Player_SetAbilityAvailability(player1, ABILITY.SOVIET.IL_2_SUPPORT_SP, ITEM_DEFAULT)
	Player_SetAbilityAvailability(player1, ABILITY.SOVIET.IL_2_RECON_SP, ITEM_DEFAULT)
	UI_NewHUDFeature(HUDF_None, 11048321, "Icons_commander_cmdr_soviet_il2_recon_plane", 5)	-- LOCDB [11048321] 'Allied air support is now under your command'

end



function Objective2_Check()
	
	-- check for the first point being captured
	if obj2_firstsquare == "P1" then
		
		Rule_RemoveMe()
		
		Util_StartIntel(EVENTS.Obj2_SquareCapturedP1)
		
		Rule_AddInterval(Objective2_CheckSecond, 1)
		Rule_AddDelayedInterval(Poznan_AnnounceP3IsLeaving, 10, 1)
		
	elseif obj2_firstsquare == "P3" then
		
		Rule_RemoveMe()
		
		Util_StartIntel(EVENTS.Obj2_SquareCapturedP3)
		
		Rule_AddInterval(Objective2_CheckSecond, 1)
		Rule_AddDelayedInterval(Poznan_AnnounceP3IsLeaving, 10, 1)
		
	end

end

function Objective2_CheckSecond()		-- now the first point has been captured, start checking for the second point
	
	if Event_IsAnyRunning() == false then
		
		if obj2_secondsquare == "P1" then
			
			Rule_RemoveMe()
			
			if obj2_firstsquare == "P1" then
				Util_StartIntel(EVENTS.Obj2_SquareCapturedP1P1)
			elseif obj2_firstsquare == "P3" then
				Util_StartIntel(EVENTS.Obj2_SquareCapturedP3P1)
			end
			
			Objective_Complete(OBJ_2)
			Rule_AddInterval(Objective3_Start, 1)
			
		elseif obj2_secondsquare == "P3" then
			
			Rule_RemoveMe()
			
			if obj2_firstsquare == "P1" then
				Util_StartIntel(EVENTS.Obj2_SquareCapturedP1P3)
			elseif obj2_firstsquare == "P3" then
				Util_StartIntel(EVENTS.Obj2_SquareCapturedP3P3)
			end
			
			Objective_Complete(OBJ_2)
			Rule_AddInterval(Objective3_Start, 1)
			
		end
		
	end
	
end






--
-- Manage HQ1 (on the player's side)... Populate it when you get close, and abandon it when necessary
--
function Poznan_ApproachHQ1()
	
	if Prox_AreTeamsNearMarker(Player_GetTeam(player1), mkr_hq1_trigger, ANY) or EGroup_GetAvgHealth(eg_hq1) <= 0.8 then
		
		-- create the defences in the area
		local encData = {
			name = "HQ1 Defence",
			spawn = mkr_hq1_trigger,
			units = {
				{sbp = SBP.GERMAN.TIGER_SQUAD, 					spawn = mkr_hq1_spawn1},
				
				{sbp = SBP.GERMAN.STUG_III_SQUAD,				spawn = mkr_hq1_spawn2,		difficulty = GD_EASY},
				{sbp = SBP.GERMAN.TIGER_SQUAD, 					spawn = mkr_hq1_spawn2,		difficulty = GD_NORMAL},
				{sbp = SBP.GERMAN.TIGER_SQUAD, 					spawn = mkr_hq1_spawn2,		difficulty = GD_HARD, upgrades = UPG.GERMAN.TIGER_TOP_GUNNER},
				
				{sbp = SBP.GERMAN.GRENADIER_SQUAD, 				spawn = mkr_hq1_spawn1},
				{sbp = SBP.GERMAN.GRENADIER_SQUAD, 				spawn = mkr_hq1_spawn2,		difficulty = GD_HARD, veterancyRank = 2},
			},
		}
		local goalData = {
			name = "Defend",
			target = mkr_hq1_trigger,
			range = Marker_GetProximityRadius(mkr_hq1_trigger) + 10,
			leashRange = Marker_GetProximityRadius(mkr_hq1_trigger),
			garrison = false,
			garrisonIdle = false,
			retaliateAttacks = true,
		}
		enc_HQ1 = Encounter:Create(encData)
		enc_HQ1:SetGoal(goalData)
		
		-- guys in the hq
		if EGroup_Count(eg_hq1) >= 1 then
			Util_CreateSquads(player2, sg_hq1extras, SBP.GERMAN.PANZER_GRENADIER_SQUAD, eg_hq1)
		end
		
		-- extra guys in the square
		Util_CreateSquads(player2, sg_hq1extras, SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD, mkr_hq1_spawn4)
		Util_CreateSquads(player2, sg_hq1extras, SBP.GERMAN.GRENADIER_SQUAD, mkr_hq1_spawn5)
		Util_CreateSquads(player2, sg_hq1extras, SBP.GERMAN.MORTAR_TEAM_81MM, mkr_hq1_spawn6)
		if g_difficulty == GD_HARD then
			SGroup_IncreaseVeterancyRank(sg_hq1extras, 1, true)
		end		
		
		-- add hints to the tigers
		SGroup_Duplicate(enc_HQ1.sgroup, sg_hq1tigers)
		SGroup_Filter(sg_hq1tigers, SBP.GERMAN.TIGER_SQUAD, FILTER_KEEP)
		BeginnerHint_AddOpportunity(sg_hq1tigers, ABILITY.SOVIET.ISU_152_PIERCING_SHOT_ABILITY)
		
		Rule_RemoveMe()
		Rule_AddInterval(Poznan_MentionApproachingHQ1, 1)
		Rule_AddInterval(Poznan_AddExtrasToHQ1, 1)
		Rule_AddInterval(Poznan_AbandonHQ1, 1)
		Rule_AddInterval(Poznan_GetAllyToGarrisonHQ1, 2)
		
	end
	
end

function Poznan_MentionApproachingHQ1()

	-- commander mentions that they're approaching the marktplatz
	if Prox_ArePlayersNearMarker(player1, mkr_hq1_trigger, ANY, nil, LIST.AIRCRAFT, FILTER_REMOVE) then
		Util_StartIntel(EVENTS.Obj2_AtWestSquareP1)
		Rule_RemoveMe()
	elseif Prox_ArePlayersNearMarker(player3, mkr_hq1_trigger, ANY, nil, LIST.AIRCRAFT, FILTER_REMOVE) then
		Util_StartIntel(EVENTS.Obj2_AtWestSquareP3)
		Rule_RemoveMe()
	end

end

function Poznan_AddExtrasToHQ1()

	if SGroup_Count(sg_hq1extras) <= 2 then
		Rule_RemoveMe()
		Rule_AddOneShot(Poznan_AddExtrasToHQ1B, 5)
	end
	
end
function Poznan_AddExtrasToHQ1B()
	enc_HQ1:AddSgroup(sg_hq1extras)
	if Player_OwnsEGroup(player2, eg_hq1) then
		Cmd_EjectOccupants(eg_hq1, mkr_hq1_exit_dest)
	end
end

function Poznan_AbandonHQ1()

	local attacker = nil
	
	if Player_OwnsEGroup(player1, eg_hq1, ANY) or (World_OwnsEGroup(eg_hq1, ANY) and Player_AreSquadsNearMarker(player1, mkr_hq1_objective_check) == true and Player_AreSquadsNearMarker(player2, mkr_hq1_objective_check) == false) then
		
		-- the player has captured the building
		attacker = "P1"
		
	elseif Player_OwnsEGroup(player3, eg_hq1, ANY) or (World_OwnsEGroup(eg_hq1, ANY) and Player_AreSquadsNearMarker(player3, mkr_hq1_objective_check) == true and Player_AreSquadsNearMarker(player2, mkr_hq1_objective_check) == false) then
		
		-- the ally has captured the building
		attacker = "P3"
		
	elseif EGroup_Count(eg_hq1) == 0 then
		
		-- the hq was blown up, so we'll try and figure out who has the most units in the area
		Player_GetAllSquadsNearMarker(player1, sg_temp, mkr_hq1_trigger)
		Player_GetAllSquadsNearMarker(player3, sg_blah, mkr_hq1_trigger)
		
		if SGroup_CountSpawned(sg_temp) >= SGroup_CountSpawned(sg_blah) then
			attacker = "P1"
		else
			attacker = "P3"
		end
		
	end
	
	if attacker ~= nil then
		
		Rule_RemoveMe()
		
		-- retreat any remaining defenders
		local goalData = {
			name = "Defend",
			target = mkr_hq1_retreat_defend,
			leashRange = mkr_hq1_retreat_defend,
		}
		enc_HQ1:SetGoal(goalData)
		
		-- mark the winner of this square
		if obj2_firstsquare == nil then
			obj2_firstsquare = attacker
			obj2_firstsquare_nis = NIS_Obj2a
		else
			obj2_secondsquare = attacker
			obj2_secondsquare_nis = NIS_Obj2a
		end
		
		hq1_attacker = attacker
		
		Rule_AddOneShot(Poznan_CapturedHQ1, 4)
		
	end
	
end


function Poznan_GetAllyToGarrisonHQ1()

	-- because the AI won't naturally garrison the HQ (which is the requirement), this function will try to force it

	if EGroup_Count(eg_hq1) == 0 or Player_OwnsEGroup(player1, eg_hq1, ANY) or p3_status ~= "active" then
		
		-- hq is gone, forget about it
		Rule_RemoveMe()
		AI_UnlockSquads(player3, sg_garrison_hq1)
		
	elseif Player_OwnsEGroup(player3, eg_hq1, ANY) then
		
		-- ally got the hq, awesome!
		Rule_RemoveMe()
		AI_UnlockSquads(player3, sg_garrison_hq1)
		
		
	elseif World_OwnsEGroup(eg_hq1, ALL) then
		
		-- building is empty, go get it!
		
		if SGroup_Count(sg_garrison_hq1) == 0 then		-- if someone has already been sent in, they'll be in the group, so only send a new guy in if it�s empty
			
			local infantry = {
				SBP.SOVIET.CONSCRIPT_SQUAD,
				SBP.SOVIET.SNIPER_TEAM,
				SBP.SOVIET.SHOCK_TROOPS,
				SBP.SOVIET.GUARDS_TROOPS,
				SBP.SOVIET.PM_82_41_MORTAR_SQUAD,
				SBP.SOVIET.HM_120_38_MORTAR_SQUAD,
				SBP.SOVIET.COMBAT_ENGINEER_SQUAD,
				SBP.SOVIET.M1910_MAXIM_HEAVY_MACHINE_GUN_SQUAD,
				SBP.SOVIET.BASE_CONSCRIPT_SQUAD,
			}
			
			-- get all the ally's squads, and filter it down to infantry
			Player_GetAll(player3)
			SGroup_Filter(sg_allsquads, infantry, FILTER_KEEP)
			
			-- now find the closest squad
			local closest_distance = 999999
			local closest_squad = nil 
			local _CheckSquad = function(gid, idx, sid)
				
				local this_distance = World_DistanceEGroupToPoint(eg_hq1, Util_GetPosition(sid), false)
				
				if this_distance < closest_distance then
					closest_distance = this_distance
					closest_squad = sid
				end
				
			end
			SGroup_ForEach(sg_allsquads, _CheckSquad)
			
			if closest_squad ~= nil then
				
				SGroup_Add(sg_garrison_hq1, closest_squad)
				
				-- lock him out of AI control
				AI_LockSquads(player3, sg_garrison_hq1)
				
				-- and finally - send him in!!!
				Cmd_Garrison(sg_garrison_hq1, eg_hq1)
				
			end
			
		end
		
	end

end

function Poznan_CapturedHQ1()

	-- remove the minimap ping
	Objective_Complete(OBJ_2a)
	
	-- may or may not award guys (only actually does something on the first call)
	Poznan_AwardPenalBattalion(eg_hq1, hq1_attacker)	
	
	if (obj2_firstsquare == "P1" and obj2_secondsquare == nil) or (obj2_firstsquare == "P3" and obj2_secondsquare == "P1") then
		BeginnerHint_AddOpportunity(mkr_hq1_trigger, HINT_RALLYPOINT, false)
	end
	
end






--
-- Manage HQ2 (on the ally's side)... Populate it when you get close, and abandon it when necessary
--
function Poznan_ApproachHQ2()
	
	if Prox_AreTeamsNearMarker(Player_GetTeam(player1), mkr_hq2_trigger, ANY) or EGroup_GetAvgHealth(eg_hq2) <= 0.8 then
		
		-- create the defences in the area
		local encData = {
			name = "HQ2 Defence",
			spawn = mkr_hq2_trigger,
			units = {
				{sbp = SBP.GERMAN.PANZER_IV_SQUAD, 				spawn = mkr_hq2_spawn1},
				{sbp = SBP.GERMAN.PANZER_IV_SQUAD, 				spawn = mkr_hq2_spawn2, 	difficulty = {GD_NORMAL, GD_HARD}},
				
				{sbp = SBP.GERMAN.TIGER_SQUAD, 					spawn = mkr_hq2_spawn3, 	difficulty = {GD_EASY, GD_NORMAL}},
				{sbp = SBP.GERMAN.TIGER_SQUAD, 					spawn = mkr_hq2_spawn3,		difficulty = GD_HARD, upgrades = UPG.GERMAN.TIGER_TOP_GUNNER},
				
				{sbp = SBP.GERMAN.GRENADIER_SQUAD, 				spawn = mkr_hq2_spawn1},
				{sbp = SBP.GERMAN.GRENADIER_SQUAD, 				spawn = mkr_hq2_spawn2,		difficulty = GD_HARD, veterancyRank = 2},
			},
		}
		local goalData = {
			name = "Defend",
			target = mkr_hq2_trigger,
			range = Marker_GetProximityRadius(mkr_hq2_trigger) + 20,
			leashRange = Marker_GetProximityRadius(mkr_hq2_trigger) - 10,
			garrison = false,
			garrisonIdle = false,
			retaliateAttacks = true,
		}
		enc_HQ2 = Encounter:Create(encData)
		enc_HQ2:SetGoal(goalData)
		
		-- guys in the city hall
		if EGroup_Count(eg_hq2) >= 1 then
			Util_CreateSquads(player2, sg_hq2extras, SBP.GERMAN.PANZER_GRENADIER_SQUAD, eg_hq2)
		end
		
		-- extra guys in the square
		Util_CreateSquads(player2, sg_hq2extras, SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD, mkr_hq2_spawn4)
		Util_CreateSquads(player2, sg_hq2extras, SBP.GERMAN.GRENADIER_SQUAD, mkr_hq2_spawn5)
		Util_CreateSquads(player2, sg_hq2extras, SBP.GERMAN.MORTAR_TEAM_81MM, mkr_hq2_spawn6)
		if g_difficulty == GD_HARD then
			SGroup_IncreaseVeterancyRank(sg_hq2extras, 1, true)
		end
		
		-- add hints to the tigers
		SGroup_Duplicate(enc_HQ2.sgroup, sg_hq2tigers)
		SGroup_Filter(sg_hq2tigers, SBP.GERMAN.TIGER_SQUAD, FILTER_KEEP)
		BeginnerHint_AddOpportunity(sg_hq2tigers, ABILITY.SOVIET.ISU_152_PIERCING_SHOT_ABILITY)
		
		Rule_RemoveMe()
		Rule_AddInterval(Poznan_MentionApproachingHQ2, 1)
		Rule_AddInterval(Poznan_AddExtrasToHQ2, 1)
		Rule_AddInterval(Poznan_AbandonHQ2, 1)
		Rule_AddInterval(Poznan_GetAllyToGarrisonHQ2, 2)
		
	end

end

function Poznan_MentionApproachingHQ2()

	-- commander mentions that they're approaching the city hall
	if Prox_ArePlayersNearMarker(player1, mkr_hq2_trigger, ANY, nil, LIST.AIRCRAFT, FILTER_REMOVE) then
		Util_StartIntel(EVENTS.Obj2_AtEastSquareP1)
		Rule_RemoveMe()
	elseif Prox_ArePlayersNearMarker(player3, mkr_hq2_trigger, ANY, nil, LIST.AIRCRAFT, FILTER_REMOVE) then
		Util_StartIntel(EVENTS.Obj2_AtEastSquareP3)
		Rule_RemoveMe()
	end

end	

function Poznan_AddExtrasToHQ2()

	if SGroup_Count(sg_hq2extras) <= 2 then
		Rule_RemoveMe()
		Rule_AddOneShot(Poznan_AddExtrasToHQ2B, 5)
	end
	
end
function Poznan_AddExtrasToHQ2B()
	enc_HQ2:AddSgroup(sg_hq2extras)
	if Player_OwnsEGroup(player2, eg_hq2) then
		Cmd_EjectOccupants(eg_hq2, mkr_hq2_exit_dest)
	end
end

function Poznan_AbandonHQ2()
	
	local attacker = nil
	
	if Player_OwnsEGroup(player1, eg_hq2, ANY) or (World_OwnsEGroup(eg_hq2, ANY) and Player_AreSquadsNearMarker(player1, mkr_hq2_objective_check) == true and Player_AreSquadsNearMarker(player2, mkr_hq2_objective_check) == false) then
		
		-- the player has captured the building
		attacker = "P1"
		
	elseif Player_OwnsEGroup(player3, eg_hq2, ANY) or (World_OwnsEGroup(eg_hq2, ANY) and Player_AreSquadsNearMarker(player3, mkr_hq2_objective_check) == true and Player_AreSquadsNearMarker(player2, mkr_hq2_objective_check) == false)  then
		
		-- the ally has captured the building
		attacker = "P3"
		
	elseif EGroup_Count(eg_hq2) == 0 then
		
		-- the hq was blown up, so we'll try and figure out who has the most units in the area
		Player_GetAllSquadsNearMarker(player1, sg_temp, mkr_hq2_trigger)
		Player_GetAllSquadsNearMarker(player3, sg_blah, mkr_hq2_trigger)
		
		if SGroup_CountSpawned(sg_temp) >= SGroup_CountSpawned(sg_blah) then
			attacker = "P1"
		else
			attacker = "P3"
		end
		
	end
	
	if attacker ~= nil then
		
		Rule_RemoveMe()
		
		-- mark the winner of this square
		if obj2_firstsquare == nil then
			obj2_firstsquare = attacker
			obj2_firstsquare_nis = NIS_Obj2b
		else
			obj2_secondsquare = attacker
			obj2_secondsquare_nis = NIS_Obj2b
		end
		
		-- retreat any remaining defenders
		local goalData = {
			name = "Defend",
			target = mkr_hq2_retreat_defend,
			leashRange = mkr_hq2_retreat_defend,
		}
		enc_HQ2:SetGoal(goalData)
		
		hq2_attacker = attacker
		
		Rule_AddOneShot(Poznan_CapturedHQ2, 4)
		
	end
	
end


function Poznan_GetAllyToGarrisonHQ2()

	-- because the AI won't naturally garrison the HQ (which is the requirement), this function will try to force it

	if EGroup_Count(eg_hq2) == 0 or Player_OwnsEGroup(player1, eg_hq2, ANY) or p3_status ~= "active" then
		
		-- hq is gone, forget about it
		Rule_RemoveMe()
		AI_UnlockSquads(player3, sg_garrison_hq2)
		
	elseif Player_OwnsEGroup(player3, eg_hq2, ANY) then
		
		-- ally got the hq, awesome!
		Rule_RemoveMe()
		AI_UnlockSquads(player3, sg_garrison_hq2)
		
		
	elseif World_OwnsEGroup(eg_hq2, ALL) then
		
		-- building is empty, go get it!
		
		if SGroup_Count(sg_garrison_hq2) == 0 then
			
			local infantry = {
				SBP.SOVIET.CONSCRIPT_SQUAD,
				SBP.SOVIET.SNIPER_TEAM,
				SBP.SOVIET.SHOCK_TROOPS,
				SBP.SOVIET.GUARDS_TROOPS,
				SBP.SOVIET.PM_82_41_MORTAR_SQUAD,
				SBP.SOVIET.HM_120_38_MORTAR_SQUAD,
				SBP.SOVIET.COMBAT_ENGINEER_SQUAD,
				SBP.SOVIET.M1910_MAXIM_HEAVY_MACHINE_GUN_SQUAD,
				SBP.SOVIET.BASE_CONSCRIPT_SQUAD,
			}
			
			-- get all the ally's squads, and filter it down to infantry
			Player_GetAll(player3)
			SGroup_Filter(sg_allsquads, infantry, FILTER_KEEP)
			
			-- now find the closest squad
			local closest_distance = 999999
			local closest_squad = nil 
			local _CheckSquad = function(gid, idx, sid)
				
				local this_distance = World_DistanceEGroupToPoint(eg_hq2, Util_GetPosition(sid), false)
				
				if this_distance < closest_distance then
					closest_distance = this_distance
					closest_squad = sid
				end
				
			end
			SGroup_ForEach(sg_allsquads, _CheckSquad)
			
			if closest_squad ~= nil then
				
				SGroup_Add(sg_garrison_hq2, closest_squad)
				
				-- lock him out of AI control
				AI_LockSquads(player3, sg_garrison_hq2)
				
				-- and finally - send him in!!!
				Cmd_Garrison(sg_garrison_hq2, eg_hq2)
				
			end
			
		end
		
	end

end

function Poznan_CapturedHQ2()		
	
	-- remove the minimap ping
	Objective_Complete(OBJ_2b)
	
	-- may or may not award guys (only actually does something on the first call)
	Poznan_AwardPenalBattalion(eg_hq2, hq2_attacker)	
	
	if (obj2_firstsquare == "P1" and obj2_secondsquare == nil) or (obj2_firstsquare == "P3" and obj2_secondsquare == "P1") then
		BeginnerHint_AddOpportunity(mkr_hq2_trigger, HINT_RALLYPOINT, false)
	end
	
end








function Poznan_CityAmbushes_Init()
	
	t_cityambushes = {
		
		-- 
		-- ROUTES FROM OBJ 1 (WALL AREA) TO OBJ 2 (CITY AREA)		-- usually a vehicle/infantry mix
		--
		{
			trigger = mkr_ambush01_trigger, 	-- leftmost route
			group = sg_cityambush1,
			units = {
				{ sbp = SBP.GERMAN.SDKFZ_251_HALFTRACK_SQUAD,		spawn = mkr_ambushspawn02, 	dynamicSpawnTarget = mkr_ambush01_trigger, difficulty = GD_EASY },
				{ sbp = SBP.GERMAN.SDKFZ_251_HALFTRACK_SQUAD,		spawn = mkr_ambushspawn02, 	dynamicSpawnTarget = mkr_ambush01_trigger, difficulty = {GD_NORMAL, GD_HARD}, entityUpgrades = UPG.GERMAN.SDKFZ_251_HALFTRACK_FLAMMPANZERWAGEN_UPGRADE },
				
				{ sbp = SBP.GERMAN.STUG_III_SQUAD,					spawn = mkr_ambushspawn05, 	dynamicSpawnTarget = mkr_ambush01_trigger },
				
				{ sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,			spawn = mkr_ambushspawn04, 	dynamicSpawnTarget = mkr_ambush01_trigger, difficulty = {GD_EASY, GD_NORMAL} },
				{ sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,			spawn = mkr_ambushspawn04, 	dynamicSpawnTarget = mkr_ambush01_trigger, difficulty = GD_HARD, veterancyRank = 1 },
				
				{ sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,			spawn = mkr_ambushspawn07, 	dynamicSpawnTarget = mkr_ambush01_trigger, difficulty = {GD_EASY, GD_NORMAL} },
				{ sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,			spawn = mkr_ambushspawn07, 	dynamicSpawnTarget = mkr_ambush01_trigger, difficulty = GD_HARD, veterancyRank = 2 },
			},
			artilleryResponse = true,
--~ 			tacticType = {
--~ 			},
		},
		{
			trigger = mkr_ambush02_trigger, 
			group = sg_cityambush2,
			units = {
				{ sbp = SBP.GERMAN.SDKFZ_251_HALFTRACK_SQUAD, 		spawn = mkr_ambushspawn05, 	dynamicSpawnTarget = mkr_ambush02_trigger, difficulty = GD_EASY },
				{ sbp = SBP.GERMAN.SDKFZ_251_HALFTRACK_SQUAD, 		spawn = mkr_ambushspawn05, 	dynamicSpawnTarget = mkr_ambush02_trigger, difficulty = {GD_NORMAL, GD_HARD}, entityUpgrades = UPG.GERMAN.SDKFZ_251_HALFTRACK_FLAMMPANZERWAGEN_UPGRADE  },
				
				{ sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,			spawn = mkr_ambushspawn01, 	dynamicSpawnTarget = mkr_ambush02_trigger, difficulty = {GD_EASY, GD_NORMAL} },
				{ sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,			spawn = mkr_ambushspawn01, 	dynamicSpawnTarget = mkr_ambush02_trigger, difficulty = GD_HARD, veterancyRank = 1 },
				
				{ sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,			spawn = eg_ambush2_building1, 	backupspawn = mkr_ambush2_building1_backup, difficulty = {GD_EASY, GD_NORMAL}  },
				{ sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,			spawn = eg_ambush2_building1, 	backupspawn = mkr_ambush2_building1_backup, difficulty = GD_HARD, veterancyRank = 2 },
			},
			artilleryResponse = true,
		},
		{
			trigger = mkr_ambush03_trigger, 
			group = sg_cityambush3,
			units = {
				{ sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,			spawn = mkr_ambushspawn01, 	dynamicSpawnTarget = mkr_ambush03_trigger, difficulty = {GD_EASY, GD_NORMAL} },
				{ sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,			spawn = mkr_ambushspawn01, 	dynamicSpawnTarget = mkr_ambush03_trigger, difficulty = GD_HARD, veterancyRank = 1 },
				
				{ sbp = SBP.GERMAN.STUG_III_SQUAD, 					spawn = mkr_ambushspawn04, 	dynamicSpawnTarget = mkr_ambush03_trigger },
				
				{ sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,			spawn = mkr_ambushspawn05, 	dynamicSpawnTarget = mkr_ambush03_trigger, difficulty = {GD_EASY, GD_NORMAL} },
				{ sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,			spawn = mkr_ambushspawn05, 	dynamicSpawnTarget = mkr_ambush03_trigger, difficulty = GD_HARD, veterancyRank = 2 },
				
				{ sbp = SBP.GERMAN.SDKFZ_251_HALFTRACK_SQUAD,		spawn = mkr_ambushspawn07, 	dynamicSpawnTarget = mkr_ambush03_trigger, difficulty = GD_EASY },
				{ sbp = SBP.GERMAN.SDKFZ_251_HALFTRACK_SQUAD,		spawn = mkr_ambushspawn07, 	dynamicSpawnTarget = mkr_ambush03_trigger, difficulty = {GD_NORMAL, GD_HARD}, entityUpgrades = UPG.GERMAN.SDKFZ_251_HALFTRACK_FLAMMPANZERWAGEN_UPGRADE },
			},
			artilleryResponse = true,
		},
		{
			trigger = mkr_ambush04_trigger, 	-- rightmost route
			group = sg_cityambush4,
			units = {
				{ sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,			spawn = mkr_ambushspawn01, 	dynamicSpawnTarget = mkr_ambush04_trigger, difficulty = {GD_EASY, GD_NORMAL} },
				{ sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,			spawn = mkr_ambushspawn01, 	dynamicSpawnTarget = mkr_ambush04_trigger, difficulty = GD_HARD, veterancyRank = 1 },
				
				{ sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,			spawn = mkr_ambushspawn04, 	dynamicSpawnTarget = mkr_ambush04_trigger, difficulty = {GD_EASY, GD_NORMAL} },
				{ sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,			spawn = mkr_ambushspawn04, 	dynamicSpawnTarget = mkr_ambush04_trigger, difficulty = GD_HARD, veterancyRank = 2 },
				
				{ sbp = SBP.GERMAN.SDKFZ_251_HALFTRACK_SQUAD,		spawn = mkr_ambushspawn07, 	dynamicSpawnTarget = mkr_ambush04_trigger, difficulty = GD_EASY },
				{ sbp = SBP.GERMAN.SDKFZ_251_HALFTRACK_SQUAD,		spawn = mkr_ambushspawn07, 	dynamicSpawnTarget = mkr_ambush04_trigger, difficulty = {GD_NORMAL, GD_HARD}, entityUpgrades = UPG.GERMAN.SDKFZ_251_HALFTRACK_FLAMMPANZERWAGEN_UPGRADE  },
			},
			artilleryResponse = true,
		},
		
		
		
		-- 
		-- SECOND LAYER JUST BEFORE OBJ 2 (CITY AREA)			-- try and keep these predominatly infantry
		--
		{
			trigger = mkr_ambush05_trigger, -- left of the map, south of the square
			group = sg_cityambush5,
			units = {
				{ sbp = SBP.GERMAN.GRENADIER_SQUAD,					spawn = mkr_ambushspawn03, 	dynamicSpawnTarget = mkr_ambush05_trigger },
				{ sbp = SBP.GERMAN.GRENADIER_SQUAD, 				spawn = mkr_ambushspawn02, 	dynamicSpawnTarget = mkr_ambush05_trigger },
				{ sbp = SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD,			spawn = mkr_ambushspawn03, 	dynamicSpawnTarget = mkr_ambush05_trigger },
				{ sbp = SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD,	spawn = eg_ambush05_building1, 	backupspawn = mkr_ambush05_building1_backup },
				{ sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD, 			spawn = mkr_ambushspawn08, 	dynamicSpawnTarget = mkr_ambush05_trigger, upgrades = UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM },
			},
			artilleryResponse = true,
		},
		{
			trigger = mkr_ambush06_trigger, -- south end of the main boulvard between the squares
			group = sg_cityambush6,
			units = {
				{ sbp = SBP.GERMAN.GRENADIER_SQUAD, 				spawn = mkr_ambushspawn01, 	dynamicSpawnTarget = mkr_ambush06_trigger },
				{ sbp = SBP.GERMAN.GRENADIER_SQUAD, 				spawn = mkr_ambushspawn05, 	dynamicSpawnTarget = mkr_ambush06_trigger },
				{ sbp = SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD,	spawn = mkr_ambush_middlespawn2, moveTo = mkr_ambush_middlespawn2_dest},
				
				{ sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD, 			spawn = mkr_ambushspawn04, 	dynamicSpawnTarget = mkr_ambush06_trigger, difficulty = {GD_EASY, GD_NORMAL} },
				{ sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD, 			spawn = mkr_ambushspawn04, 	dynamicSpawnTarget = mkr_ambush06_trigger, difficulty = GD_HARD, veterancyRank = 2 },
			},
			artilleryResponse = true,
		},
		{
			trigger = mkr_ambush07_trigger, -- right of the map, south of the city
			group = sg_cityambush7,
			units = {
				{ sbp = SBP.GERMAN.GRENADIER_SQUAD, 				spawn = mkr_ambushspawn01, 	dynamicSpawnTarget = mkr_ambush07_trigger },
				{ sbp = SBP.GERMAN.GRENADIER_SQUAD, 				spawn = eg_ambush7_building1, 	backupspawn = mkr_ambush7_building1_backup },
				{ sbp = SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD, 		spawn = mkr_ambushspawn09, 	dynamicSpawnTarget = mkr_ambush07_trigger },
				{ sbp = SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD, 	spawn = mkr_ambushspawn05, 	dynamicSpawnTarget = mkr_ambush07_trigger },
				
				{ sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD, 			spawn = mkr_ambushspawn08, 	dynamicSpawnTarget = mkr_ambush07_trigger, difficulty = {GD_EASY, GD_NORMAL} },
				{ sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD, 			spawn = mkr_ambushspawn08, 	dynamicSpawnTarget = mkr_ambush07_trigger, difficulty = GD_HARD, veterancyRank = 2 },
			},
			artilleryResponse = true,
		},
		{
			trigger = mkr_ambush08_trigger,	-- in the city, to the left of the square
			group = sg_cityambush8,
			units = {
				{ sbp = SBP.GERMAN.GRENADIER_SQUAD, 				spawn = mkr_ambushspawn05, 	dynamicSpawnTarget = mkr_ambush08_trigger },
				{ sbp = SBP.GERMAN.GRENADIER_SQUAD, 				spawn = mkr_ambushspawn08, 	dynamicSpawnTarget = mkr_ambush08_trigger },
				
				{ sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD, 			spawn = eg_ambush8_building1, backupspawn = mkr_ambush8_building1_backup, difficulty = GD_EASY },
				{ sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD, 			spawn = eg_ambush8_building1, backupspawn = mkr_ambush8_building1_backup, difficulty = {GD_EASY, GD_NORMAL} },
				
				{ sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD, 			spawn = eg_ambush8_building1, backupspawn = mkr_ambush8_building1_backup, difficulty = {GD_NORMAL, GD_HARD}, veterancyRank = 1 },
				{ sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD, 			spawn = eg_ambush8_building1, backupspawn = mkr_ambush8_building1_backup, difficulty = GD_HARD, veterancyRank = 2 },
				
			},
			artilleryResponse = true,
		},
		{
			trigger = mkr_ambush09_trigger, -- park on the far left, behind the square
			group = sg_cityambush9,
			units = {
				{ sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD, 			spawn = mkr_ambushspawn01, 	dynamicSpawnTarget = mkr_ambush09_trigger },
				{ sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD, 			spawn = mkr_ambushspawn04, 	dynamicSpawnTarget = mkr_ambush09_trigger },
				
				{ sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD, 			spawn = mkr_ambushspawn05, 	dynamicSpawnTarget = mkr_ambush09_trigger, difficulty = GD_EASY  },
				{ sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD, 			spawn = mkr_ambushspawn05, 	dynamicSpawnTarget = mkr_ambush09_trigger, difficulty = {GD_NORMAL, GD_HARD}, veterancyRank = 1 },
				
				{ sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD, 			spawn = mkr_ambushspawn07, 	dynamicSpawnTarget = mkr_ambush09_trigger, difficulty = {GD_EASY, GD_NORMAL} },
				{ sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD, 			spawn = mkr_ambushspawn07, 	dynamicSpawnTarget = mkr_ambush09_trigger, difficulty = GD_HARD, veterancyRank = 2 },
			},
			artilleryResponse = true,
		},
		
		
		
		-- 
		-- END OF MIDDLE ROUTE
		--
		{
			trigger = mkr_ambush10_trigger, 
			group = sg_cityambush10,
			units = {
				{ sbp = SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD,	spawn = mkr_ambush_middlespawn1 },
				{ sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,	spawn = mkr_ambushspawn03,	dynamicSpawnTarget = mkr_ambush10_trigger },
				{ sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,	spawn = mkr_ambushspawn06,	dynamicSpawnTarget = mkr_ambush10_trigger },
				{ sbp = SBP.GERMAN.GRENADIER_SQUAD,			spawn = mkr_ambushspawn04,	dynamicSpawnTarget = mkr_ambush10_trigger },
				{ sbp = SBP.GERMAN.GRENADIER_SQUAD,			spawn = mkr_ambushspawn02,	dynamicSpawnTarget = mkr_ambush10_trigger },
			},
			artilleryResponse = true,
		},
		{
			trigger = mkr_ambush15_trigger, 
			group = sg_cityambush15,
			units = {
				{ sbp = SBP.GERMAN.GRENADIER_SQUAD,			spawn = mkr_ambushspawn05,	dynamicSpawnTarget = mkr_ambush10_trigger },
				{ sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,	spawn = mkr_ambushspawn04,	dynamicSpawnTarget = mkr_ambush10_trigger },
				{ sbp = SBP.GERMAN.STUG_III_SQUAD,			spawn = mkr_ambushspawn08,	dynamicSpawnTarget = mkr_ambush10_trigger },
				{ sbp = SBP.GERMAN.GRENADIER_SQUAD,			spawn = mkr_ambushspawn08,	dynamicSpawnTarget = mkr_ambush10_trigger },
				{ sbp = SBP.GERMAN.GRENADIER_SQUAD,			spawn = mkr_ambushspawn02,	dynamicSpawnTarget = mkr_ambush10_trigger },
				{ sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,	spawn = eg_ambush15_building1, backupspawn = mkr_ambush15_building1_backup},
			},
			artilleryResponse = true,
		},
		
		
		-- 
		-- SMALL PATCHES
		--
		{
			trigger = mkr_ambush11_trigger, 
			group = sg_cityambush11,
			reveal_fow = false,
			units = {
				{ sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,	spawn = mkr_ambushspawn03,	dynamicSpawnTarget = mkr_ambush11_trigger },
				{ sbp = SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD,	spawn = mkr_ambush_middlespawn1, dynamicSpawnTarget = mkr_ambush11_trigger },
			},
		},
		{
			trigger = mkr_ambush12_trigger, 
			group = sg_cityambush12,
			reveal_fow = false,
			units = {
				{ sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,	spawn = mkr_ambushspawn03,	dynamicSpawnTarget = mkr_ambush12_trigger },
				{ sbp = SBP.GERMAN.GRENADIER_SQUAD,			spawn = mkr_ambushspawn05,	dynamicSpawnTarget = mkr_ambush12_trigger },
			},
		},
		{
			trigger = mkr_ambush13_trigger, 
			group = sg_cityambush13,
			reveal_fow = false,
			units = {
				{ sbp = SBP.GERMAN.GRENADIER_SQUAD,			spawn = mkr_ambushspawn03,	dynamicSpawnTarget = mkr_ambush13_trigger },
				{ sbp = SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD,	spawn = mkr_ambushspawn05,	dynamicSpawnTarget = mkr_ambush13_trigger },
			},
		},
		{
			trigger = mkr_ambush14_trigger, 
			group = sg_cityambush14,
			reveal_fow = false,
			units = {
				{ sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,	spawn = mkr_ambushspawn05,	dynamicSpawnTarget = mkr_ambush14_trigger },
			},
		},
		
		
		
	}
	
	Rule_Add(Poznan_CityAmbushes_Manager)
	cityambush_index = 0
	cityambush_spawning = false
	
end

function Poznan_CityAmbushes_Manager()
	
	-- get all Player 1's selected squads and add them to my group (this means that squads that have never been selected don't trigger ambushes - i.e. not when they are in the process of coming onto the map)
	Misc_GetSelectedSquads(sg_temp, false)
	SGroup_Filter(sg_temp, LIST.AIRCRAFT, FILTER_REMOVE)
	SGroup_RemoveGroup(sg_temp, sg_usedplayersquads)
	
	local _CheckPlayer = function(gid, idx, sid)
		if World_OwnsSquad(sid) ~= true and Squad_GetPlayerOwner(sid) == player1 then
			SGroup_Add(sg_usedplayersquads, sid)
		end
	end
	SGroup_ForEach(sg_temp, _CheckPlayer)
	
	
	-- check to see if we need to trigger an ambush
	if #t_cityambushes == 0 or Objective_IsComplete(OBJ_2) == true then
		
		Rule_RemoveMe()
		
	elseif cityambush_spawning ~= true then -- make sure we didn't just trigger a spawn and are going through the process - we need to leave indexes alone while that's going on
		
		-- increase the index (we're checking the zones round-robin style)
		cityambush_index = cityambush_index + 1
		if cityambush_index > #t_cityambushes then
			cityambush_index = 1
		end
		
		-- get the ambush data
		local ambush = t_cityambushes[cityambush_index]
		
		
		-- check to see if either ally is in the trigger zone (using the no_aircraft flag)
		if Prox_AreSquadsNearMarker(sg_usedplayersquads, ambush.trigger, ANY, nil) then
			
			-- open the FOW in the area first
			if ambush.reveal_fow ~= false then
				FOW_RevealMarker(ambush.trigger, 20)
			end
			
			cityambush_spawning = true
			Rule_AddOneShot(Poznan_CityAmbushes_SpawnEncounter, 1)
			
		end
		
	end
	
	

	
end


function Poznan_CityAmbushes_SpawnEncounter()

	local ambush = t_cityambushes[cityambush_index]
	if ambush.tacticControlsList == nil then
		ambush.tacticControlsList = {
			{
				tacticType = TACTIC_Avoid,
				priority = -1,
			}
		}
	end
	
	-- check unit spawn locations for EGroups - if they're empty, use the backup location instead!
	for k, unit in pairs(ambush.units) do 
		if scartype(unit.spawn) == ST_EGROUP and EGroup_Count(unit.spawn) == 0 then
			unit.spawn = unit.backupspawn
		end
	end
	
	-- then create the encounter (stuff shouldn't spawn in the area as the FOW was revealed)
	local encData = {
		name = "Ambush "..Marker_GetName(ambush.trigger),
		player = player2,
		sgroups = {ambush.group},
		units = ambush.units,
	}
	local goalData = {
		name = "Attack",
		target = ambush.trigger,
		range = Marker_GetProximityRadius(ambush.trigger) + 15,
		leashRange = Marker_GetProximityRadius(ambush.trigger) + 40,
		garrison = true,
	}
	if ambush.artilleryResponse == true then
		goalData.retaliateAttacks = true
	end
	ambush.encounter_id = Encounter:Create(encData)
	ambush.encounter_id:SetGoal(goalData)

	-- remove the ambush from the list
	table.remove(t_cityambushes, cityambush_index)
	
	-- re-allow subsequent ambushes
	cityambush_spawning = false
	
end




--
-- This system will create a small attack to go after a random squad if the player hasn't been in combat for a certain threshold of time
--
function Poznan_RandomAttacks_Init()
	
	randomattack_not_attacked_since = World_GetGameTime()
	randomattack_last_spawn_time = World_GetGameTime()
	randomattack_quiet_threshold = World_GetRand(t_difficulty.randomattacker_frequency, t_difficulty.randomattacker_frequency*1.5)
	
	Rule_AddInterval(Poznan_RandomAttacks_Manager, 5)
	
end

function Poznan_RandomAttacks_Manager()
	
	if Objective_IsComplete(OBJ_2) == true then
		
		-- if the objective is over, we don't need to do this anymore
		Rule_RemoveMe()
		
	else
		
		-- see if the player has been under attack recently
		Player_GetAll(player1)
		if SGroup_IsUnderAttack(sg_allsquads, ANY, 5) == true then
			
			-- if so, just mark the time
			randomattack_not_attacked_since = World_GetGameTime()
			
		elseif SGroup_Count(sg_randomattackers) <= 4 then
			
			-- if enough time has passed since the last spawn and since the player was last under attack...
			if (World_GetGameTime() - randomattack_not_attacked_since) >= randomattack_quiet_threshold and
			   (World_GetGameTime() - randomattack_last_spawn_time) >= 20 then
				
				-- ...then it's time to spawn a random attacker of some sort!
				
				-- pick a target squad, origin, spawnpos, etc
				Player_GetAllSquadsNearMarker(player1, sg_temp, mkr_wall_inside)
				SGroup_Filter(sg_temp, LIST.AIRCRAFT, FILTER_REMOVE)
				
				if SGroup_CountSpawned(sg_temp) >= 1 then
					
					local target = SGroup_GetRandomSpawnedSquad(sg_temp)
					local targetpos = Util_GetPosition(target)
					local origin = Table_GetRandomItem({mkr_ambushspawn01, mkr_ambushspawn02, mkr_ambushspawn03, mkr_ambushspawn04, mkr_ambushspawn05, mkr_ambushspawn06, mkr_ambushspawn07, mkr_ambushspawn08, mkr_ambushspawn09})
					local spawnpos = World_GetHiddenPositionOnPath(player1, origin, targetpos, CHECK_IN_FOW)
					
					if spawnpos ~= nil then
						
						local units = nil
						
						local difficulty_modifier = 0
						if g_difficulty == GD_NORMAL then
							if Player_GetPopulationPercentage(player1, CT_Personnel) <= 0.75 then
								difficulty_modifier = 1
							else
								difficulty_modifier = 2
							end
						elseif g_difficulty == GD_HARD then
							difficulty_modifier = 3
						end
						
						if Table_Contains(LIST.INFANTRY, Squad_GetBlueprint(target)) then
							
							-- stuff to target infantry
							local rand = World_GetRand(1, 10) + difficulty_modifier
							if rand <= 4 then												-- 1, 2, 3 or 4
								units = {
									{bp = SBP.GERMAN.GRENADIER_SQUAD},
								}
							elseif rand <= 7 then											-- 5, 6 or 7
								units = {
									{bp = SBP.GERMAN.PANZER_GRENADIER_SQUAD, upg = UPG.GERMAN.LIGHT_INFANTRY_PACKAGE},
								}
							elseif rand <= 9 then											-- 8 or 9
								units = {
									{bp = SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD},
									{bp = SBP.GERMAN.GRENADIER_SQUAD},
								}
							else															-- 10 or more
								units = {
									{bp = SBP.GERMAN.SCOUTCAR_SDKFZ222},
									{bp = SBP.GERMAN.GRENADIER_SQUAD},
									{bp = SBP.GERMAN.GRENADIER_SQUAD},
								}
							end
							
						else
							
							-- stuff to target tanks
							local rand = World_GetRand(1, 8) + difficulty_modifier
							if rand <= 4 then												-- 1, 2, 3 or 4	
								units = {
									{bp = SBP.GERMAN.PANZER_GRENADIER_SQUAD, upg = UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM},
								}
							elseif rand <= 7 then											-- 5, 6 or 7
								units = {
									{bp = SBP.GERMAN.STUG_III_SQUAD},
								}
							elseif rand <= 9 then											-- 8 or 9
								units = {
									{bp = SBP.GERMAN.OSTWIND_SQUAD},
									{bp = SBP.GERMAN.PANZER_GRENADIER_SQUAD},
								}
							else															-- 10 or more
								units = {
									{bp = SBP.GERMAN.PANZER_IV_SQUAD},
								}
							end
							
						end
						
						for k, unit in pairs(units) do
							Util_CreateSquads(player2, sg_randomattackers, unit.bp, spawnpos, targetpos, 1, nil, true, nil, unit.upg, targetpos)		-- create the unit and attackmove it to it's target
						end
						
						randomattack_last_spawn_time = World_GetGameTime()
						randomattack_quiet_threshold = World_GetRand(t_difficulty.randomattacker_frequency, t_difficulty.randomattacker_frequency*2)
						
					end
					
				end
				
			end
			
		end
		
	end
	
	
end




--
-- This system will drop the occasional howitzer shell (in an area of little consquence) just to add to the vibe
--
function Poznan_MortarHits_Init()

	-- these are the marker locations we can sort of safely drop a mortar - they're all in ruins, etc
	t_mortarhit_locations = {
		{marker = mkr_mortar_01, },						{marker = mkr_mortar_02, },						{marker = mkr_mortar_03, },						{marker = mkr_mortar_04, },
		{marker = mkr_mortar_05, },						{marker = mkr_mortar_06, },						{marker = mkr_mortar_07, },						{marker = mkr_mortar_08, },
		{marker = mkr_mortar_09, },						{marker = mkr_mortar_10, },						{marker = mkr_mortar_11, },						{marker = mkr_mortar_12, },
		{marker = mkr_mortar_13, },						{marker = mkr_mortar_14, },						{marker = mkr_mortar_15, },						{marker = mkr_mortar_16, },
		{marker = mkr_mortar_17, },						{marker = mkr_mortar_18, },						{marker = mkr_mortar_19, },						{marker = mkr_mortar_20, },
		{marker = mkr_mortar_21, check_area = true },	{marker = mkr_mortar_22, check_area = true },	{marker = mkr_mortar_23, check_area = true },	{marker = mkr_mortar_24, check_area = true },
		{marker = mkr_mortar_25, check_area = true },	{marker = mkr_mortar_26, },						{marker = mkr_mortar_27, },						{marker = mkr_mortar_28, },
	}
	t_mortarhit_data = {
		called_out = false,
	}
	
	Timer_Start(timer_mortarhits, World_GetRand(t_difficulty.mortarthit_interval_min, t_difficulty.mortarthit_interval_max))

	Rule_AddInterval(Poznan_MortarHits_Manager, 3)
	
end



function Poznan_MortarHits_Manager()
	
	if Objective_IsComplete(OBJ_2) then
		
		Rule_RemoveMe()
		
	elseif Timer_GetRemaining(timer_mortarhits) <= 0 and Event_IsAnyRunning() == false then
		
		-- make a shortlist of markers that are on screen
		local possibles = {}
		for k, item in pairs(t_mortarhit_locations) do
			
			if Misc_IsPosOnScreen(Util_GetPosition(item.marker), 0.85) then
				
				if item.check_area == true then
					
					local prox = Marker_GetProximityRadius(item.marker) + 15
					if (Prox_ArePlayersNearMarker(player1, item.marker, ANY, prox) == false and Prox_ArePlayersNearMarker(player2, item.marker, ANY, prox) == false) then
						
						table.insert(possibles, item.marker)
						
					end
					
				else
					
					table.insert(possibles, item.marker)
					
				end
				
			end
		end
		
		-- choose one of them, and drop a mortar there
		if #possibles >= 1 then
			
			-- play sound of artillery firing
			if EGroup_CountSpawned(eg_hq3) >= 1 then
				Sound_Play3D("campaign/m12_howitzer_fire", EGroup_GetSpawnedEntityAt(eg_hq3, 1))	
			end
			
			-- queue up the next two firing sounds (ability has three shells)
			Rule_AddOneShot(Poznan_MortarHits_ManagerB, World_GetRand(15, 25) / 10 )		-- sound of second shell firing
			Rule_AddOneShot(Poznan_MortarHits_ManagerC, World_GetRand(35, 45) / 10 )		-- sound of third shell firing
			Rule_AddOneShot(Poznan_MortarHits_ManagerD, World_GetRand(45, 55) / 10 )		-- sound of units reacting
			Rule_AddOneShot(Poznan_MortarHits_ManagerE, 10)									-- possible explicit callout
			
			-- choose the location and trigger the actual mortarhits
			mortarhit_location =  Util_GetRandomPosition(Table_GetRandomItem(possibles))
			Cmd_Ability(player2, ABILITY.GLOBAL.M12_HOWITZER_BARRAGE, mortarhit_location, nil, true)
			
			-- set timer for next attack
			Timer_Start(timer_mortarhits, World_GetRand(t_difficulty.mortarthit_interval_min, t_difficulty.mortarthit_interval_max))
			
		end
		
	end

end
function Poznan_MortarHits_ManagerB()

	-- play sound of artillery firing
	if EGroup_CountSpawned(eg_hq3) >= 1 then
		Sound_Play3D("campaign/m12_howitzer_fire", EGroup_GetSpawnedEntityAt(eg_hq3, 1))	
	end

end
function Poznan_MortarHits_ManagerC()
	
	-- play sound of artillery firing
	if EGroup_CountSpawned(eg_hq3) >= 1 then
		Sound_Play3D("campaign/m12_howitzer_fire", EGroup_GetSpawnedEntityAt(eg_hq3, 1))	
	end
	
end
function Poznan_MortarHits_ManagerD()
	
	-- play some reaction speech 
	if EGroup_CountSpawned(eg_hq3) >= 1 and Event_IsAnyRunning() == false then
		
		-- get guys near the mortar location
		Player_GetAllSquadsNearMarker(player1, sg_temp, mortarhit_location, 80)
		SGroup_Filter(sg_temp, LIST.INFANTRY, FILTER_KEEP)
		
		if SGroup_CountSpawned(sg_temp) >= 1 then
			
			-- pick a random entity from a random squad nearby to call the howitzer out
			local squad = SGroup_GetRandomSpawnedSquad(sg_temp)
			local entity = Squad_EntityAt(squad, World_GetRand(1, Squad_Count(squad)) - 1)
			
			Sound_Play3D("speech/sp/mission/m12/ambient/artillery_incoming", entity)		-- Howitzer reaction speech
			
		end
		
	end
	
end

function Poznan_MortarHits_ManagerE()
	
	if t_mortarhit_data.called_out ~= true and Event_IsAnyRunning() == false then
		
		if World_GetRand(1, 3) == 1 then
			
			Player_GetAll(player1)
			if SGroup_IsUnderAttack(sg_allsquads, ANY, 15) == false then
				
				-- so there should be NO events running currently, the player hasn't been under fire in the last short while, and an extra random element on top of that...
				Util_StartIntel(EVENTS.Obj2_MortarChatter)
				
				-- set flag so this never triggers again
				t_mortarhit_data.called_out = true
				
			end
			
		end
		
	end
	
end






--------------------------------------------------------
--------------------------------------------------------
-- 
-- Objective 3:
-- Capture the fortress
-- 
--------------------------------------------------------
--------------------------------------------------------

function Initialize_Objective3()

	OBJ_3 = {
		
		SetupUI = function() 
			hp_id_1 = Objective_AddUIElements(OBJ_3, mkr_arrow_objective3, true, 11036209, true) 				-- LOCDB [11036209] 'Capture the Citadel'
		end,
		
		OnStart = function()
			
			-- open up the next area of the map 
			World_IncreaseInteractionStage()
			EGroup_EnableMinimapIndicator(eg_territorypoints_stage3, true)
			
			-- change the music
			Sound_StopMusic(CAMPAIGN_MUSIC_FADEOUT, 0)
			Sound_PlayMusic("streamed/music/missions/m12/m12_cue_castle_breakthrough", 4, 4)
			
			-- start the check for objective completion
			Rule_AddInterval(Objective3_Check, 3)
			
		end,
		
		OnComplete = function()
			Rule_AddOneShot(Poznan_Fortress_SurrenderPartC, 1)
		end,
		
		OnFail = function()
			-- Calls from Objective_Fail(OBJ_1)
			-- Fires off before Intel_Fail (unless Intel_Fail is nil)			
		end,
		
		IsComplete = function()
			return false
		end,
		
		Intel_Start = EVENTS.Obj3_Intro,-- Event will play when obj starts but before any UI appears
		Intel_Complete = nil,			-- Event will play when obj completes but before UI is cleared
		Intel_Fail = nil,				-- Event will play when obj fails but before UI is cleared
		Title = 11036209,				-- LOCDB [11036209] 'Capture the Citadel'
		Description = 11036210,			-- LOCDB [11036210] 'Capture the final German defensive position in Fort Winery'
		Type = OT_Primary,				-- Objective Type (OT_Primary, OT_Secondary)
		
	}
	
	Objective_Register(OBJ_3)
	
	-- things that should ALWAYS be running (in case the player gets ahead of the objectives)
	Rule_AddInterval(Poznan_Fortress_Init, 2)
	
end


function Objective3_Start()

	if Event_IsAnyRunning() == false then
		
		Rule_RemoveMe()
		Rule_AddOneShot(Objective3_StartB, 5)
		
	end
	
end
function Objective3_StartB()
	
	Objective_Start(OBJ_3)

end


function Objective3_Check()
	
	if obj3_fortress_init == true and 
	    (	EGroup_Count(eg_hq3) <= 0 or 							-- HQ is destroyed...
			EGroup_GetAvgHealth(eg_hq3) <= 0.65 or 					-- or at least severely damaged...
			Player_OwnsEGroup(player2, eg_hq3, ANY) == false or		-- or no longer occupied by enemy infantry any more...
			enc_Fortress:IsAlive() == false 						-- or you've killed everyone defending the HQ from the outside
		) then	
		
		Rule_RemoveMe()
		
		Objective_RemoveUIElements(OBJ_3, hp_id_1)
		
		Rule_AddOneShot(Poznan_Fortress_Surrender, 0.5)
		
	end

end





function Poznan_Fortress_Init()
	
	if (Objective_IsStarted(OBJ_2) == true or Objective_IsStarted(OBJ_3) == true) and Prox_AreTeamsNearMarker(Player_GetTeam(player1), mkr_fortress_init, ANY) then
		
		Rule_RemoveMe()
		
		-- two buildings that face out by the gates
		Util_CreateSquads(player2, sg_blah, SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD, eg_fortressgate_building1)
		Util_CreateSquads(player2, sg_blah, SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD, eg_fortressgate_building2)
		
		-- two buildings at the back of the courtyard
		Util_CreateSquads(player2, sg_blah, SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD, eg_fortressgate_building3)
		
		-- AT guns
		Util_CreateSquads(player2, sg_fortress_atgunL1, SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD, mkr_fortress_defendgates_spawn1a)
		Util_CreateSquads(player2, sg_fortress_atgunL2, SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD, mkr_fortress_defendgates_spawn1b)
		Util_CreateSquads(player2, sg_fortress_atgunR1, SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD, mkr_fortress_defendgates_spawn2a)
		Util_CreateSquads(player2, sg_fortress_atgunR2, SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD, mkr_fortress_defendgates_spawn2b)
		
		-- Infantry defending the guns out front
		Util_CreateSquads(player2, sg_fortress_frontL2, SBP.GERMAN.PANZER_GRENADIER_SQUAD, mkr_fortress_defendgates_spawn4, nil, 1, 4)
		Util_CreateSquads(player2, sg_fortress_frontL1, SBP.GERMAN.PANZER_GRENADIER_SQUAD, mkr_fortress_defendgates_spawn5, nil, 1, 2)
		Util_CreateSquads(player2, sg_fortress_frontL2, SBP.GERMAN.PANZER_GRENADIER_SQUAD, mkr_fortress_defendgates_spawn6, nil, 1, 2)
		Util_CreateSquads(player2, sg_fortress_frontL1, SBP.GERMAN.PANZER_GRENADIER_SQUAD, mkr_fortress_defendgates_spawn11, nil, 1, 1)
		Util_CreateSquads(player2, sg_fortress_frontR1, SBP.GERMAN.PANZER_GRENADIER_SQUAD, mkr_fortress_defendgates_spawn7, nil, 1, 2)
		Util_CreateSquads(player2, sg_fortress_frontR2, SBP.GERMAN.PANZER_GRENADIER_SQUAD, mkr_fortress_defendgates_spawn8, nil, 1, 2)
		Util_CreateSquads(player2, sg_fortress_frontR2, SBP.GERMAN.PANZER_GRENADIER_SQUAD, mkr_fortress_defendgates_spawn9, nil, 1, 4)
		Util_CreateSquads(player2, sg_fortress_frontR1, SBP.GERMAN.PANZER_GRENADIER_SQUAD, mkr_fortress_defendgates_spawn10, nil, 1, 2)
		
		-- defend encounter in the courtyard
		local encData = {
			name = "Fortress Gates",
			player = player2,
			units = {
				{ sbp = SBP.GERMAN.TIGER_SQUAD, spawn = mkr_fortress_defendgates_spawn3 },
			},
		}
		local goalData = {
			name = "Defend",
			target = mkr_fortress_defendgates,
			range = Marker_GetProximityRadius(mkr_fortress_defendgates) + 30,
			leashRange = Marker_GetProximityRadius(mkr_fortress_defendgates),
		}
		enc_FortressGates = Encounter:Create(encData)
		enc_FortressGates:SetGoal(goalData)
		
		
		
		t_fortress_outsidegroups = {
			{atguns = sg_fortress_atgunL1, infantry = sg_fortress_frontL1, fallback_function = Poznan_Fortress_RetreatIntoCourtyardL1},
			{atguns = sg_fortress_atgunL2, infantry = sg_fortress_frontL2, fallback_function = Poznan_Fortress_RetreatIntoCourtyardL2},
			{atguns = sg_fortress_atgunL1, infantry = sg_fortress_frontR1, fallback_function = Poznan_Fortress_RetreatIntoCourtyardR1},
			{atguns = sg_fortress_atgunL2, infantry = sg_fortress_frontR2, fallback_function = Poznan_Fortress_RetreatIntoCourtyardR2},
		}
		for k, item in pairs(t_fortress_outsidegroups) do 
			item.atguns_threshold = SGroup_TotalMembersCount(item.atguns, true) - 1
			item.infantry_threshold = SGroup_TotalMembersCount(item.infantry) / 2
		end
		
		-- add the next stage of the init, when they get into the courtyard
		Rule_AddInterval(Poznan_Fortress_InitMainArea, 0.5)
		Rule_AddInterval(Poznan_Fortress_PlayerInCourtyard, 2)
		Rule_AddInterval(Poznan_Fortress_PlayerInMainArea, 2)
		Rule_AddInterval(Poznan_Fortress_RetreatIntoCourtyard, 1)
		Rule_AddInterval(Poznan_Fortress_RetreatIntoMainArea, 1)
		
	end

end


-- withdraw the forces that are outside the gate back into to fortress courtyard when attacked, encroached upon, etc
function Poznan_Fortress_RetreatIntoCourtyard()
	
	local all_done = true
	
	for k, item in pairs(t_fortress_outsidegroups) do 
		
		if item.retreated ~= true then
			
			if SGroup_TotalMembersCount(item.atguns, true) <= item.atguns_threshold or
			   SGroup_TotalMembersCount(item.infantry) <= item.infantry_threshold or
			   Prox_ArePlayersNearMarker(player1, Util_GetPosition(item.atguns), ANY, 20) or
			   Rule_Exists(Poznan_Fortress_PlayerInCourtyard) == false then
				
				item.retreated = true
				
				if scartype(item.fallback_function) == ST_FUNCTION then
					item.fallback_function()
				end
				
			else
				
				all_done = false		-- something *isn't* done yet
				
			end
			
		end
		
	end
	
	if all_done == true then
		Rule_RemoveMe()
	end
	
end

function Poznan_Fortress_RetreatIntoCourtyardL1()

	-- move the at guns back and add the infantry to the encounter in the courtyard
	Cmd_Move(sg_fortress_atgunL1, mkr_fortress_defendgates_atgunL1dest, nil, nil, mkr_fortress_defendgates_atgun_aim)
	enc_FortressGates:AddSgroup(sg_fortress_frontL1)

end

function Poznan_Fortress_RetreatIntoCourtyardL2()

	-- move the at guns back beyond the courtyard
	if SGroup_CountSpawned(sg_fortress_atgunR2) == 0 or obj3_fortress_atgun_retreated_to_hq ~= true then
		Cmd_Move(sg_fortress_atgunL2, mkr_fortress_defend_atgun1, nil, nil, mkr_fortress_defend_center)
		SGroup_AddGroup(sg_fortress_extras_atgun1, sg_fortress_atgunL2)
		obj3_fortress_atgun_retreated_to_hq = true
	else
		Cmd_Move(sg_fortress_atgunL2, mkr_fortress_defendgates_atgunL2dest, nil, nil, mkr_fortress_defendgates_atgun_aim)
	end
	
	-- and create a new encounter there for the infantry
	local goalData = {
		name = "Defend",
		target = mkr_fortress_defend_left,
		range = Marker_GetProximityRadius(mkr_fortress_defend_left) + 30,
		leashRange = Marker_GetProximityRadius(mkr_fortress_defend_left),
	}
	
	if(SGroup_Count(sg_fortress_frontL2) > 0) then
		enc_FortessGates_Left = Encounter:ConvertSgroup(sg_fortress_frontL2)
		enc_FortessGates_Left:SetGoal(goalData)
	end
end

function Poznan_Fortress_RetreatIntoCourtyardR1()

	-- move the at guns back and add the infantry to the encounter in the courtyard
	Cmd_Move(sg_fortress_atgunR1, mkr_fortress_defendgates_atgunR1dest, nil, nil, mkr_fortress_defendgates_atgun_aim)
	enc_FortressGates:AddSgroup(sg_fortress_frontR1)

end

function Poznan_Fortress_RetreatIntoCourtyardR2()

	-- move the at guns back beyond the courtyard
	if SGroup_CountSpawned(sg_fortress_atgunL2) == 0 or obj3_fortress_atgun_retreated_to_hq ~= true then
		Cmd_Move(sg_fortress_atgunR2, mkr_fortress_defend_atgun1, nil, nil, mkr_fortress_defend_center)
		SGroup_AddGroup(sg_fortress_extras_atgun1, sg_fortress_atgunR2)
		obj3_fortress_atgun_retreated_to_hq = true
	else
		Cmd_Move(sg_fortress_atgunR2, mkr_fortress_defendgates_atgunR2dest, nil, nil, mkr_fortress_defendgates_atgun_aim)
	end
	
	-- and create a new encounter there for the infantry
	local goalData = {
		name = "Defend",
		target = mkr_fortress_defend_right,
		range = Marker_GetProximityRadius(mkr_fortress_defend_right) + 30,
		leashRange = Marker_GetProximityRadius(mkr_fortress_defend_right),
	}
	
	if(SGroup_Count(sg_fortress_frontR2) > 0) then
		enc_FortessGates_Right = Encounter:ConvertSgroup(sg_fortress_frontR2)
		enc_FortessGates_Right:SetGoal(goalData)
	end
end



-- bring in any stragglers from the gate area as reinforcements
function Poznan_Fortress_RetreatIntoMainArea()
	
	if obj3_fortress_init == true and SGroup_CountSpawned(enc_FortressGates.sgroup) <= 4 then
		
		Rule_RemoveMe()
		
		local sgroup = enc_FortressGates.sgroup
		enc_FortressGates:Disable()
		enc_Fortress:AddSgroup(sgroup)
		
	end
	
end


-- when the main citadel area is exposed, create all the units that need to be there
function Poznan_Fortress_InitMainArea()

	-- init the area behind the courtyard
	if Prox_AreTeamsNearMarker(Player_GetTeam(player1), mkr_fortress_defendgates, ANY) then
		
		Rule_RemoveMe()
		
		-- units in the hq building
		Util_CreateSquads(player2, sg_blah, SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD, eg_hq3, nil, 1)
		Util_CreateSquads(player2, sg_blah, SBP.GERMAN.PANZER_GRENADIER_SQUAD, eg_hq3, nil, 2)
		
		-- create the howitzer
		Util_CreateSquads(player2, sg_citadel_howitzer, SBP.GERMAN.HOWITZER_105MM_LE_FH18_ARTILLERY, mkr_fortress_defend_spawn1)
		SGroup_IncreaseVeterancyRank(sg_citadel_howitzer, 3, true)
		
		-- encounter with all the guys in the area
		local encData = {
			name = "Fortress",
			player = player2,
			units = {
				{ sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD, 	spawn = mkr_fortress_defend_spawn2, veterancyRank = 3 },
				{ sbp = SBP.GERMAN.OSTRUPPEN_SQUAD, 		spawn = mkr_fortress_defend_spawn3, veterancyRank = 1 },
				{ sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD, 	spawn = mkr_fortress_defend_spawn4, veterancyRank = 2 },
				{ sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD, 	spawn = mkr_fortress_defend_spawn5, veterancyRank = 2 },
				
				{ difficulty = GD_EASY,   sbp = SBP.GERMAN.OSTRUPPEN_SQUAD, 		spawn = mkr_fortress_defend_spawn6, veterancyRank = 0 },
				{ difficulty = GD_EASY,   sbp = SBP.GERMAN.GRENADIER_SQUAD, 		spawn = mkr_fortress_defend_spawn7, veterancyRank = 1 },
				{ difficulty = GD_EASY,   sbp = SBP.GERMAN.STUG_III_SQUAD, 			spawn = mkr_fortress_defend_spawn4, upgrades = UPG.GERMAN.STUG_TOP_GUNNER},
				
				{ difficulty = GD_NORMAL, sbp = SBP.GERMAN.OSTRUPPEN_SQUAD, 		spawn = mkr_fortress_defend_spawn6, veterancyRank = 1 },
				{ difficulty = GD_NORMAL, sbp = SBP.GERMAN.GRENADIER_SQUAD, 		spawn = mkr_fortress_defend_spawn7, veterancyRank = 2 },
				{ difficulty = GD_NORMAL, sbp = SBP.GERMAN.PANZER_IV_SQUAD, 		spawn = mkr_fortress_defend_spawn4 },
				
				{ difficulty = GD_HARD,   sbp = SBP.GERMAN.GRENADIER_SQUAD, 		spawn = mkr_fortress_defend_spawn6, veterancyRank = 2 },
				{ difficulty = GD_HARD,   sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,	spawn = mkr_fortress_defend_spawn7, veterancyRank = 3 },
				{ difficulty = GD_HARD,   sbp = SBP.GERMAN.TIGER_SQUAD, 			spawn = mkr_fortress_defend_spawn4 },
			},
		}
		local goalData = {
			name = "Defend",
			target = mkr_fortress_defend,
			range = Marker_GetProximityRadius(mkr_fortress_defend) + 30,
			leashRange = Marker_GetProximityRadius(mkr_fortress_defend),
		}
		enc_Fortress = Encounter:Create(encData)
		enc_Fortress:SetGoal(goalData)
		enc_Fortress:AddSgroup(sg_citadel_howitzer)
		
		obj3_fortress_init = true
		
		Rule_AddInterval(Poznan_Fortress_AllHowitzersDestroyed, 1)
		
	end
	
end

function Poznan_Fortress_PlayerInCourtyard()

	if Prox_ArePlayersNearMarker(player1, mkr_fortress_defendgates, ANY, nil, LIST.AIRCRAFT, FILTER_REMOVE) then
		
		Util_StartIntel(EVENTS.Obj3_InCourtyard)
		Rule_RemoveMe()
		
	end
	
end



-- check to see if all the howitzers have been destroyed (only possible now we've actually spawned the final one!)
function Poznan_Fortress_AllHowitzersDestroyed()

	if SGroup_Count(sg_citadel_howitzer) + SGroup_Count(sg_bastion1_artillery) + SGroup_Count(sg_bastion2_artillery) + SGroup_Count(sg_bastion3_artillery) == 0 then
		
		Rule_RemoveMe()
		
		Scar_CompleteIntelBulletinTask(player1, "camp12_poznan_destroyed_all_howitzers")
		
	end

end




-- now player is in main area
function Poznan_Fortress_PlayerInMainArea()
	
	if Prox_ArePlayersNearMarker(player1, mkr_fortress_defend, ANY, nil, LIST.AIRCRAFT, FILTER_REMOVE) then
		
		Rule_RemoveMe()
		
		-- pull in the defenders
		local goalData = {
			name = "Defend",
			target = mkr_fortress_defend,
			range = 75,
			leashRange = 45,
		}
		enc_Fortress:SetGoal(goalData)
		
		Rule_AddInterval(Poznan_Fortress_PlayerInMainAreaB, 3)
	end
	
end
function Poznan_Fortress_PlayerInMainAreaB()

	if Prox_ArePlayersNearMarker(player1, mkr_fortress_defend, ANY, 40, LIST.AIRCRAFT, FILTER_REMOVE) or SGroup_CountSpawned(enc_Fortress.sgroup) <= 3 then
		
		Rule_RemoveMe()
		
		-- add a final hurrah of extra defenders
		Util_CreateSquads(player2, sg_fortress_extras, SBP.GERMAN.PANZER_GRENADIER_SQUAD, mkr_fortress_defend_spawnbastion2, mkr_fortress_defend_spawn4, 2)
		Util_CreateSquads(player2, sg_fortress_extras, SBP.GERMAN.PANZER_GRENADIER_SQUAD, mkr_fortress_defend_spawnbastion3, mkr_fortress_defend_spawn2, 2)
		enc_Fortress:AddSgroup(sg_fortress_extras)
		
		Player_GetAllSquadsNearMarker(player1, sg_temp, mkr_fortress_defend)
		SGroup_Filter(sg_temp, LIST.INFANTRY, FILTER_REMOVE)
		SGroup_Filter(sg_temp, LIST.AIRCRAFT, FILTER_REMOVE)
		
		if SGroup_Count(sg_fortress_extras_atgun1) == 0 and SGroup_Count(sg_temp) >= 1 then
			Util_CreateSquads(player2, sg_fortress_extras_atgun1, SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD, mkr_fortress_defend_spawnbastion2, mkr_fortress_defend_atgun1)
			Cmd_Move(sg_fortress_extras_atgun2, mkr_fortress_defend_atgun1, nil, nil, mkr_fortress_defend_center)
		end
		
		Util_CreateSquads(player2, sg_fortress_extras_atgun2, SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD, mkr_fortress_defend_spawnbastion3, mkr_fortress_defend_atgun2)
		Cmd_Move(sg_fortress_extras_atgun2, mkr_fortress_defend_atgun2, nil, nil, mkr_fortress_defend_center)
	end

end



function Poznan_Fortress_Surrender()

	-- and trigger the mission end sequence
	Util_StartIntel(EVENTS.Mission_CompleteA)		-- german general says he surrenders
	
	Rule_AddInterval(Poznan_Fortress_SurrenderPartB, 0.5)
	
end
function Poznan_Fortress_SurrenderPartB()

	if Event_IsAnyRunning() == false then
		
		Rule_RemoveMe()
		
		-- implement a ceasefire on both sides
		Player_GetAll(player1)
		SGroup_Filter(sg_allsquads, LIST.AIRCRAFT, FILTER_REMOVE)
		SGroup_SetSelectable(sg_allsquads, false)
		SGroup_SetAutoTargetting(sg_allsquads, "hardpoint_01", false)
		Modify_WeaponEnabled(sg_allsquads, "hardpoint_01", false)
		Cmd_Stop(sg_allsquads)
		
		Player_GetAll(player2)
		SGroup_SetSelectable(sg_allsquads, false)
		SGroup_SetAutoTargetting(sg_allsquads, "hardpoint_01", false)
		Modify_WeaponEnabled(sg_allsquads, "hardpoint_01", false)
		Cmd_Stop(sg_allsquads)
		
		Objective_Complete(OBJ_3)
		
	end
	
end



function Poznan_Fortress_SurrenderPartC()

	Util_StartIntel(EVENTS.Mission_CompleteB)		-- ally congratulates you

	Rule_AddInterval(Poznan_Fortress_SurrenderPartD, 0.5)
	
end
function Poznan_Fortress_SurrenderPartD()

	if Event_IsAnyRunning() == false then
		
		Rule_RemoveMe()
		
		-- we'll fade out and back in to the victory pos
		Game_FadeToBlack(FADE_OUT, 0.8)
		Rule_AddOneShot(Poznan_Fortress_SurrenderPartE, 1)
		
	end
	
end

function Poznan_Fortress_SurrenderPartE()
	
	Camera_SetInputEnabled(false)
	FOW_RevealMarker(mkr_fortress_defend, -1)
	
	Player_GetAll(player1)
	SGroup_Filter(sg_allsquads, LIST.AIRCRAFT, FILTER_KEEP)
	SGroup_DestroyAllSquads(sg_allsquads)
	
	-- and trigger the mission end sequence
	Util_StartIntel(EVENTS.Mission_CompleteC)
	
	-- spawn surrendered squads from HQ
	if EGroup_Count(eg_hq3) >= 1 then
		Cmd_EjectOccupants(eg_hq3)
		Util_CreateSquads(player2, sg_blah, SBP.GERMAN.OSTRUPPEN_SQUAD, eg_hq3, mkr_fortress_defend_spawn1, 2) 
		Util_CreateSquads(player2, sg_blah, SBP.GERMAN.OSTRUPPEN_SQUAD, eg_hq3, mkr_fortress_defend_spawn2, 2) 
	end
	
	
	Player_GetAll(player2)
	Cmd_Surrender(sg_allsquads, nil, mkr_fortress_defend_spawn1, false, true)
	
	
	Rule_AddDelayedInterval(Poznan_MissionEnd, 7, 0.5)
	
end







--------------------------------------------------------
--------------------------------------------------------
-- 
-- Bonus Objective: 
-- First player to clear a square gets bonus squads
-- 
--------------------------------------------------------
--------------------------------------------------------

function Initialize_ObjectiveBonus()

	OBJ_Bonus = {
		
		SetupUI = function() 
			-- none
		end,
		
		OnStart = function()
			Rule_AddInterval(ObjectiveBonus_Check, 1)
		end,
		
		OnComplete = function()
			-- Calls from Objective_Complete(OBJ_1)
			-- Fires off before Intel_Complete (unless Intel_Complete is nil)			
		end,
		
		OnFail = function()
			-- Calls from Objective_Fail(OBJ_1)
			-- Fires off before Intel_Fail (unless Intel_Fail is nil)			
		end,
		
		IsComplete = function()
			return false
		end,
		
		Intel_Start = EVENTS.ObjBonus_Intro,	-- Event will play when obj starts but before any UI appears
		Intel_Complete = nil,					-- Event will play when obj completes but before UI is cleared
		Intel_Fail = nil,						-- Event will play when obj fails but before UI is cleared
		Title = 11036211,						-- LOCDB [11036211] 'Search for imprisoned Penal Battalions'
		Description = 0,			
		Type = OT_Secondary,					-- Objective Type (OT_Primary, OT_Secondary)
	}
	
	Objective_Register(OBJ_Bonus)

end


function ObjectiveBonus_Start()
	
	if time_bonusobj_start == nil then
		time_bonusobj_start = World_GetGameTime()
	end
	Player_GetAllSquadsNearMarker(player1, sg_temp, Camera_GetCurrentTargetPos(), 80)
	
	if (World_GetGameTime() - time_bonusobj_start) >= 30 or SGroup_IsUnderAttack(sg_temp, ANY, 4) == false then					-- try and find a quiet spot
		
		if Event_IsAnyRunning() == false then
			
			Rule_RemoveMe()
			Objective_Start(OBJ_Bonus)
			
		end
		
	end
	
end


function ObjectiveBonus_Check()
	
	if penalbattalion_player == player1 then
		
		-- the player won the guys
		Rule_RemoveMe()
		
		Util_StartIntel(EVENTS.ObjBonus_WinP1)
		Objective_Complete(OBJ_Bonus)
		
	elseif penalbattalion_player == player3 then
		
		-- player 3 won the guys
		Rule_RemoveMe()
		
		Util_StartIntel(EVENTS.ObjBonus_WinP3)
		Objective_Complete(OBJ_Bonus)
		
	elseif ( EGroup_Count(eg_hq1) + EGroup_Count(eg_hq2) ) == 0 then
		
		-- both HQs were destroyed
		Rule_RemoveMe()
		
		Util_StartIntel(EVENTS.ObjBonus_BuildingsDestroyed)
		Objective_Fail(OBJ_Bonus)
		
	end
	
end



-- this is actually called from the function that monitors for the player capturing a square
function Poznan_AwardPenalBattalion(egroup, attacker)
	
	if penalbattalion_unitsspawned == nil and EGroup_Count(egroup) ~= 0 then
		
		penalbattalion_unitsspawned = true
		
		-- figure out which player did the capturing - they're going to get the award
		if attacker == "P1" then
			penalbattalion_player = player1
		else
			penalbattalion_player = player3
		end
		
		-- figure out which square was captured - that will dictate spawn locations and rally points
		if egroup == eg_hq1 then
			penalbattalion_spawn = eg_hq1
			penalbattalion_destination = mkr_hq1_penal_dest
		else
			penalbattalion_spawn = eg_hq2
			penalbattalion_destination = mkr_hq2_penal_dest
		end
		
		-- queue up a limited number of spawns, so that it's staggered
		Rule_AddIntervalEx(Poznan_AwardPenalBattalion_SpawnOneSquad, 2, t_difficulty.penal_battalion_size)
		Rule_AddDelayedInterval(Poznan_AwardPenalBattalion_TrackExtraPopCap, (t_difficulty.penal_battalion_size * 2), 1)
		
	end
	
end


function Poznan_AwardPenalBattalion_SpawnOneSquad()

	local this_destination = Util_GetRandomPosition(penalbattalion_destination)
	
	-- boost the popcap to allow for this new squad
	local total = 120 + ( (SGroup_Count(sg_bonus_penalbattalions) + 1) * 3) + SGroup_TotalMembersCount(sg_bonus_penalbattalions) + 9
	Player_SetPopCapOverride(penalbattalion_player, total)

	
	SGroup_Clear(sg_temp)
	Util_CreateSquads(penalbattalion_player, sg_temp, SBP.SOVIET.PENAL_BATTALION, penalbattalion_spawn, this_destination, 1)
	Cmd_Ability(sg_temp, ABILITY.SOVIET.CONSCRIPT_OORAH, nil, nil, true)
	
	SGroup_AddGroup(sg_bonus_penalbattalions, sg_temp)
	
end



-- after the spawns have finished, track the penal batallion squads to remove the popcap bonus as they die
function Poznan_AwardPenalBattalion_TrackExtraPopCap()

	-- calculate and set the popcap boost
	local total = 120 + (SGroup_Count(sg_bonus_penalbattalions) * 3) + SGroup_TotalMembersCount(sg_bonus_penalbattalions)
	Player_SetPopCapOverride(penalbattalion_player, total)

	-- if they're all dead and we're back to normal, then we don't need to check anymore
	if SGroup_Count(sg_bonus_penalbattalions) == 0 then
		Rule_RemoveMe()
	end
	
end






--------------------------------------------------------
-- Mission End stuff
--------------------------------------------------------

function Poznan_MissionEnd()

	if Event_IsAnyRunning() == false then
		
		Rule_RemoveMe()
		Game_EndSP(true)
		
	end

end















--------------------------------------------------------
-- Other stuff (not related to any partiular objective)
--------------------------------------------------------

--
-- Functions dealing with the arrival and dismissal of the allied player
--
function Poznan_AnnouncePresenceOfP3()

	if Event_IsAnyRunning() == false then
		
		Rule_RemoveMe()
		
		Util_StartIntel(EVENTS.Poznan_MeetTheAlly)
		World_EnableSharedLineOfSight(player1, player3, true)
		
		p3_status = "active"
		
	end

end


-- called after the first square is captured
function Poznan_AnnounceP3IsLeaving()
	
	if Event_IsAnyRunning() == false then
		
		Rule_RemoveMe()
		
		Rule_AddDelayedInterval(Poznan_AnnounceP3IsLeavingB, 30, 1)
		
	end
	
end
function Poznan_AnnounceP3IsLeavingB()
	
	if Event_IsAnyRunning() == false then
		
		Rule_RemoveMe()
		
		Util_StartIntel(EVENTS.Poznan_AllyWithdraws)
		AI_Enable(player3, false)
		
		p3_status = "leaving"
		
		Rule_AddInterval(Poznan_P3RallyAroundPoints, 1)
		
	end
	
end
function Poznan_P3RallyAroundPoints()
	
	if Event_IsAnyRunning() == false then
		
		Rule_RemoveMe()
		
		-- get all of the map's territory points
		EGroup_Clear(eg_temp)
		World_GetStrategyPoints(eg_temp, false)
		
		-- for each territory point...
		local _CheckTerritory = function(gid, idx, eid)
			
			-- get the position and sector id it represents
			local flagpos = Entity_GetPosition(eid)
			local sectorid = World_GetTerritorySectorID(flagpos)
			
			-- nor get all P3 squads in this sector
			Player_GetAllSquadsNearMarker(player3, sg_temp, sectorid)
			
			-- move each squad _individually_ towards the point
			local _MoveToTerritoryPoint = function(gid, idx, sid)
				
				SGroup_Single(sg_single, sid)
				
				-- remove and replace any criticals that may cause a unit to be immobile
				if SGroup_HasCritical(sg_single, CRIT.VEHICLE_DESTROY_ENGINE, ANY) == true then
					Entity_RemoveCritical(Squad_EntityAt(sid, 0), CRIT.VEHICLE_DESTROY_ENGINE)
					Entity_ApplyCritical(Squad_EntityAt(sid, 0), CRIT.VEHICLE_ENGINE_BURNING, 0.9)
				end
				if SGroup_HasCritical(sg_single, CRIT.VEHICLE_LIGHT_DESTROY_ENGINE, ANY) == true then
					Entity_RemoveCritical(Squad_EntityAt(sid, 0), CRIT.VEHICLE_LIGHT_DESTROY_ENGINE)
					Entity_ApplyCritical(Squad_EntityAt(sid, 0), CRIT.VEHICLE_LIGHT_DAMAGE_ENGINE, 0.9)
				end
				if SGroup_HasCritical(sg_single, CRIT.VEHICLE_LOSE_TREADS_OR_WHEELS, ANY) == true then
					Entity_RemoveCritical(Squad_EntityAt(sid, 0), CRIT.VEHICLE_LOSE_TREADS_OR_WHEELS)
					Entity_ApplyCritical(Squad_EntityAt(sid, 0), CRIT.VEHICLE_LIGHT_DAMAGE_ENGINE, 0.9)
				end
				
				Cmd_Move(sg_single, flagpos)
				
			end
			SGroup_ForEach(sg_temp, _MoveToTerritoryPoint)
			
		end
		EGroup_ForEach(eg_temp, _CheckTerritory)
		
		
		Rule_AddOneShot(Poznan_P3LeaveMap, 7)
		
	end
	
end
function Poznan_P3LeaveMap()
	
	if Event_IsAnyRunning() == false then
		
		Rule_RemoveMe()
		
		Player_GetAll(player3)
		Cmd_Move(sg_allsquads, mkr_p3exit, nil, mkr_p3exit)
		
		Rule_AddDelayedInterval(Poznan_HintPatienceTimer, 130, 2)
		Rule_AddDelayedInterval(Poznan_StartPatienceTimer, 270, 2)
		
		Rule_AddInterval(Poznan_P3LeaveMap_Cleanup, 5)
		
	end
	
end
function Poznan_P3LeaveMap_Cleanup()

	Player_GetAll(player3)
	
	if SGroup_Count(sg_allsquads) == 0 then
		
		Rule_RemoveMe()
		
	else
		
		Cmd_Move(sg_allsquads, mkr_p3exit, nil, mkr_p3exit)
		
	end

end










--
-- Functions dealing with the "Soviet Patience" countdown and potential mission loss condition for the player 
--

function Poznan_HintPatienceTimer()

	-- hint to the player that some sort of deadline might be in their future...
	
	if time_first_tried_hintpatience == nil then
		time_first_tried_hintpatience = World_GetGameTime()
	end
	Player_GetAllSquadsNearMarker(player1, sg_temp, Camera_GetCurrentTargetPos(), 80)
	
	if (World_GetGameTime() - time_first_tried_hintpatience) >= 30 or SGroup_IsUnderAttack(sg_temp, ANY, 4) == false then					-- try and find a quiet spot
		
		if Event_IsAnyRunning() == false and Objective_IsComplete(OBJ_3) == false then
			
			Rule_RemoveMe()
			
			Util_StartIntel(EVENTS.Poznan_PatienceHint)
			
		end
		
	end
	
end

function Poznan_StartPatienceTimer()
	
	-- bring up the deadline, and explain what it means for them
	
	if time_first_tried_startpatience == nil then
		time_first_tried_startpatience = World_GetGameTime()
	end
	Player_GetAllSquadsNearMarker(player1, sg_temp, Camera_GetCurrentTargetPos(), 80)
	
	if (World_GetGameTime() - time_first_tried_startpatience) >= 30 or SGroup_IsUnderAttack(sg_temp, ANY, 4) == false then					-- try and find a quiet spot
		
		if Event_IsAnyRunning() == false and Objective_IsComplete(OBJ_3) == false then
			
			Rule_RemoveMe()
			
			Util_StartIntel(EVENTS.Poznan_StartPatienceTimer)
			
			Rule_AddInterval(Poznan_StartPatienceTimerB, 0.5)
			
		end
		
	end
	
end
function Poznan_StartPatienceTimerB()

	if Event_IsAnyRunning() == false and Objective_IsComplete(OBJ_3) == false then	
		
		Rule_RemoveMe()
		
		-- calculate timer length in SECONDS and start the internal timer
		local length = t_difficulty.patience_timer * 60
		Timer_Start(timer_patience, length)
		
		-- display the stopwatch, and kick off the rule to update it every second
		Poznan_PatienceTimerUpdate()
		Rule_AddInterval(Poznan_PatienceTimerUpdate, 1)
		
		-- wait until next event for this timer
		Rule_AddInterval(Poznan_PatienceTimerRunningLow, 1)
		
	end

end
function Poznan_PatienceTimerRunningLow()

	if Event_IsAnyRunning() == false and Timer_GetRemaining(timer_patience) < 600 and Objective_IsComplete(OBJ_3) == false then	
		
		Rule_RemoveMe()
		
		-- Announce that time remaining is running low
		Util_StartIntel(EVENTS.Poznan_PatienceTimerRunningLow)
		
		-- wait until next event for this timer
		Rule_AddInterval(Poznan_EndPatienceTimer, 1)
		
	end

end
function Poznan_EndPatienceTimer()

	if Objective_IsComplete(OBJ_3) == true then
		
		-- hide the timer and kill the update rule
		Obj_HideProgress()
		Rule_RemoveIfExist(Poznan_PatienceTimerUpdate)
		
		Rule_RemoveMe()
		
	elseif Event_IsAnyRunning() == false and Timer_GetRemaining(timer_patience) <= 0 then	
		
		Rule_RemoveMe()
		
		Util_StartIntel(EVENTS.Poznan_EndPatienceTimer)
		
		Rule_AddOneShot(Poznan_EndPatienceTimerB, 3)
		
	end

end
function Poznan_EndPatienceTimerB()

	-- hide the timer and kill the update rule
	Obj_HideProgress()
	Rule_RemoveIfExist(Poznan_PatienceTimerUpdate)
	
	-- lock out all unit construction! (it's their own fault)
	local list = {
		SBP.SOVIET.COMBAT_ENGINEER_SQUAD,
		SBP.SOVIET.SHOCK_TROOPS,
		SBP.SOVIET.SNIPER_TEAM,
		SBP.SOVIET.CONSCRIPT_SQUAD,
		SBP.SOVIET.HM_120_38_MORTAR_SQUAD,
		SBP.SOVIET.M1910_MAXIM_HEAVY_MACHINE_GUN_SQUAD,
		SBP.SOVIET.M1937_53_K_45MM_AT_GUN_SQUAD,
		SBP.SOVIET.M1942_ZIS_3_76MM_AT_GUN_SQUAD,
		SBP.SOVIET.M3A1_SCOUT_CAR_SQUAD,
		SBP.SOVIET.M5_HALFTRACK_SQUAD,
		SBP.SOVIET.ISU_152,
		SBP.SOVIET.T_34_76_SQUAD,
		SBP.SOVIET.T_70M,
		SBP.SOVIET.SU_76M,
		SBP.SOVIET.SU_85,
	}
	for k, unit in pairs(list) do 
		Player_SetSquadProductionAvailability(player1, unit, ITEM_LOCKED)
	end
	Player_SetAbilityAvailability(player1, ABILITY.SOVIET.IL_2_RECON, ITEM_LOCKED)
	Player_SetAbilityAvailability(player1, ABILITY.SOVIET.IL_2_SUPPORT, ITEM_LOCKED)
	Player_SetAbilityAvailability(player1, ABILITY.SOVIET.BASE_CONSCRIPT_DISPATCH, ITEM_LOCKED)
	Player_SetAbilityAvailability(player1, BP_GetAbilityBlueprint("frontoviki_conscript_dispatch"), ITEM_LOCKED)
	Player_SetAbilityAvailability(player1, ABILITY.SOVIET.PENAL_TROOP_DISPATCH_SP, ITEM_LOCKED)
	
	-- nix the player's resource stream
	Modify_PlayerResourceRate(player1, RT_Manpower, 0)
	Modify_PlayerResourceRate(player1, RT_Munition, 0)
	Modify_PlayerResourceRate(player1, RT_Fuel, 0)
	
	-- now start looking for mission fail conditions
	Rule_AddDelayedInterval(Poznan_AllUnitsLost, 15, 1)

end



-- update the timer - called every second
function Poznan_PatienceTimerUpdate()

 	local time_remaining = math.ceil(Timer_GetRemaining(timer_patience))
 	local total_time = t_difficulty.patience_timer * 60
	
	Obj_ShowProgress2(11037833, (time_remaining / total_time) )	-- LOCDB [11037833] 'Soviet Command's Deadline'
	
end


-- now we know they aren't generating new units - this waits until everyone is dead and fails the mission
function Poznan_AllUnitsLost()

	Player_GetAll(player1)
	SGroup_Filter(sg_allsquads, LIST.AIRCRAFT, FILTER_REMOVE)
	
	if Event_IsAnyRunning() == false and SGroup_Count(sg_allsquads) == 0 then	
		
		Rule_RemoveMe()
		
		Rule_AddOneShot(Poznan_AllUnitsLostB, 3)
		
	end

end
function Poznan_AllUnitsLostB()
	
	Game_EndSP(false)
	
end




function Mission_Fail_HQ_Destroyed()

	if Player_HasBuilding(player1, {EBP.SOVIET.HQ}) == false then
		
		-- STOP EVERYTHING! We're failin' this mission!
		Rule_RemoveAll()
		
		Util_MissionTitle(11048793, 1, 5, 1)
		Rule_AddOneShot(Mission_Fail_HQ_Destroyed_PartB, 7)
		
	end
	
end
function Mission_Fail_HQ_Destroyed_PartB()
	
	Game_EndSP(false)
	
end
	



