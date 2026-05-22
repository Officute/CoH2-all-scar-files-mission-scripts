--=====================================================================================================--
--=====================================================================================================--
--==============			       CHALLENGE Indirect Fire V2					  =====================--
--==============			Designers: Eric Foster & Philippe Boulle			  =====================--
--=====================================================================================================--
--=====================================================================================================--

isCampaign = true
import("ScarUtil.scar")
import("TheatreOfWar.scar")
import("Systems/AiManager/ai.scar")
import("Global_Values/CampaignGlobalConstants.scar")

--=====================================================================================================--
--============================================ SETUP   ================================================--
--=====================================================================================================--

function OnGameSetup()
	-- Player
	player1 = Setup_Player(1, 11038758, "soviet", 1)		-- player1 is always the human player
	-- AI
	player2 = Setup_Player(2, 11038759, "german", 2)		-- player2 is always the AI opponent
end

function OnGameRestore()
	player1 = World_GetPlayerAt(1)
	player2 = World_GetPlayerAt(2)
	Game_DefaultGameRestore() 
end

function NIS_Init()
	NISOpening = "ToW\\Challenges\\Indirect_Fire_v2\\nis\\intro" 
	nis_load(NISOpening)
	nis_setintransitiontime(0)
	nis_setouttransitiontime(1.5)
end

Scar_AddInit(NIS_Init)

--=====================================================================================================--
--=========================================== ONINIT   ================================================--
--=====================================================================================================--

function OnInit()
	--[[ PRESET DEBUG CONDITIONS ]]
	Mission_Debug()
	
	--[[ SET RESTRICTIONS ]]
	Mission_Restrictions()
	
	--[[ SET DIFFICULTY ]]
	Mission_Difficulty()
	
	--[[ MISSION PRESETS ]]
	Mission_MissionPreset()
end

Scar_AddInit(OnInit)

function Mission_Debug()
	g_debug = Misc_IsCommandLineOptionSet("debug")
end

function Mission_Restrictions()
	
	Player_SetEntityProductionAvailability(player1, EBP.SOVIET.TANK_DEPOT, ITEM_REMOVED)
	Player_SetEntityProductionAvailability(player1, EBP.SOVIET.MOTORPOOL, ITEM_REMOVED)
	Player_SetEntityProductionAvailability(player1, EBP.SOVIET.WEAPON_SUPPORT_CENTER, ITEM_REMOVED)
	Player_SetEntityProductionAvailability(player1, EBP.SOVIET.BARRACKS, ITEM_REMOVED)
	
	ToW_SetUpTechTreeByYear(player1, 1941)
	ToW_SetUpTechTreeByYear(player2, 1941)
	
end

function Mission_Difficulty()
	-- get the difficulty
	g_difficulty = Game_GetSPDifficulty()  -- set a global difficulty variable 
	print("********* DIFFICULTY: "..g_difficulty)
	
	t_retalLightUnits = {
		-- conscript
		{
			{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				numSquads = 1,
			},
		},
		-- captain
		{
			{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				numSquads = 2,
			},
			{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				upgrades = {UPG.GERMAN.GRENADIER_MG42_LMG},
				numSquads = 1,
			},
		},
		-- general
		{
			{
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
				numSquads = 2,
			},
			{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				upgrades = {UPG.GERMAN.GRENADIER_MG42_LMG},
				numSquads = 2,
			},
		},
		-- expert
		{
			{
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
				numSquads = 2,
			},
			{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				upgrades = {UPG.GERMAN.GRENADIER_MG42_LMG},
				numSquads = 2,
			},
		},
	}
	
	t_retalMediumUnits = {
		-- conscript
		{
			{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				numSquads = 2,
			},
			{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				upgrades = {UPG.GERMAN.GRENADIER_MG42_LMG},
				numSquads = 1,
			},
		},
		-- captain
		{
			{
				sbp = SBP.GERMAN.SCOUTCAR_SDKFZ222,
			},
			{
				sbp = SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD,
			},
		},
		-- general
		{
			{
				sbp = SBP.GERMAN.SCOUTCAR_SDKFZ222,
				entityUpgrades = {UPG.GERMAN.SDKFZ_222_20MM_GUN},
				numSquads = 2,
			},
		},
		-- expert
		{
			{
				sbp = SBP.GERMAN.SCOUTCAR_SDKFZ222,
				entityUpgrades = {UPG.GERMAN.SDKFZ_222_20MM_GUN},
				numSquads = 2,
			},
		},
	}
	
	
	t_retalHeavyUnits = {
		-- conscript
		{
			{
				sbp = SBP.GERMAN.SCOUTCAR_SDKFZ222,
			},
		},
		-- captain
		{
			{
				sbp = SBP.GERMAN.SCOUTCAR_SDKFZ222,
				entityUpgrades = {UPG.GERMAN.SDKFZ_222_20MM_GUN},
				numSquads = 2,
			},
		},
		-- general
		{
			{
				sbp = SBP.GERMAN.SCOUTCAR_SDKFZ222,
				entityUpgrades = {UPG.GERMAN.SDKFZ_222_20MM_GUN},
			},
			{
				sbp = SBP.GERMAN.STUG_III_E_SQUAD,
			},
		},
		-- expert
		{
			{
				sbp = SBP.GERMAN.SCOUTCAR_SDKFZ222,
				entityUpgrades = {UPG.GERMAN.SDKFZ_222_20MM_GUN},
			},
			{
				sbp = SBP.GERMAN.STUG_III_E_SQUAD,
			},
		},
	}
	
	
	t_difficulty = {
		startTime			= Util_DifVar({900,  750, 600, 300}),
		rechargeMod			= Util_DifVar({0.4,  0.6, 1.0, 1.2}),
		retalLight			= Util_DifVar(t_retalLightUnits),
		retalMedium			= Util_DifVar(t_retalMediumUnits),
		retalHeavy			= Util_DifVar(t_retalHeavyUnits),
	}
	--adjust timer for panzergrenadier grenades
	Modify_ProjectileDelayTime (player2, BP_GetEntityBlueprint("bundled_stielgranate_campaign"), CAMPAIGN_PGREN_BUNDLED_TIMER)
end

--=====================================================================================================--
--======================================= MISSION Preset   ============================================--
--=====================================================================================================--

function Mission_MissionPreset()
	-- Variables
	g_totalEnemyBuildings = EGroup_CountSpawned(eg_enemy_buildings)
	g_bronze = g_totalEnemyBuildings - 10
	g_silver = g_totalEnemyBuildings - 5
	g_gold = g_totalEnemyBuildings
	g_totalNeutralBuildings = EGroup_CountSpawned(eg_buildings)
	g_neutralBuildingsDestroyed = 0
	
	g_maxTime = 0
	
	t_points = {}
	t_retal = {}
	t_timer = t_difficulty.startTime
	
	t_encounters = {}
	
	GOLDENROD = 	{ r = 255, 	g = 193, 	b = 37,}
	
	--  Modifiers
	Player_AddAbility(player1, ABILITY.SOVIET.BASE_CONSCRIPT_DISPATCH)
	Modify_AbilityRechargeTime(player1, ABILITY.SOVIET.KAYTUSHA_ROCKET_TRUCK_BARRAGE, t_difficulty.rechargeMod )

	SGroup_SetAvgHealth(sg_world_katyushas, 0.5)
	g_totalAbandonnedKatyushas = SGroup_Count(sg_world_katyushas)
	Cmd_CriticalHit( player2, sg_world_katyushas, CRIT.VEHICLE_ABANDON, 1)
	
	Cmd_InstantUpgrade(eg_enemy_mg42_nest01 , UPG.GERMAN.BUNKER_MG42_ADDITION)
	Cmd_InstantUpgrade(eg_enemy_mg42_nest02 , UPG.GERMAN.BUNKER_MG42_ADDITION)
	Cmd_InstantUpgrade(eg_enemy_mg42_nest03 , UPG.GERMAN.BUNKER_MG42_ADDITION)
	Cmd_InstantUpgrade(eg_enemy_mg42_nest04 , UPG.GERMAN.BUNKER_MG42_ADDITION)
	Cmd_InstantUpgrade(eg_enemy_mg42_nest05 , UPG.GERMAN.BUNKER_MG42_ADDITION)
	
	-- Spawning Player Units & Groups
	sg_katyushas = SGroup_CreateIfNotFound("sg_katyushas")
	sg_player_starting_infantry = SGroup_CreateIfNotFound("sg_player_starting_infantry")
	sg_player_all_units = SGroup_CreateIfNotFound("sg_player_all_units")
	sg_temp  = SGroup_CreateIfNotFound("sg_temp")
	
	Util_CreateSquads(player1, sg_player_starting_infantry, SBP.SOVIET.CONSCRIPT_SQUAD, mkr_conscript_spawn, mkr_engineer_spawn)
	Util_CreateSquads(player1, sg_player_starting_infantry, SBP.SOVIET.COMBAT_ENGINEER_SQUAD, mkr_engineer_spawn)

	Util_CreateSquads(player1, sg_katyushas, SBP.SOVIET.KATYUSHA_BM_13N_SQUAD, mkr_kat_spawn_01)
	Util_CreateSquads(player1, sg_katyushas, SBP.SOVIET.KATYUSHA_BM_13N_SQUAD, mkr_kat_spawn_02)
	
	-- Spawning Enemy Units & Groups
	sg_enemy_units = SGroup_CreateIfNotFound("sg_enemy_units")
	
	sg_enemy_hmg_01 = SGroup_CreateIfNotFound("sg_enemy_hmg_01")
	sg_enemy_hmg_02 = SGroup_CreateIfNotFound("sg_enemy_hmg_02")
	
	sg_german_hmg_garrison_01 = SGroup_CreateIfNotFound("sg_german_hmg_garrison_01")
	sg_german_hmg_garrison_02 = SGroup_CreateIfNotFound("sg_german_hmg_garrison_02")
	sg_german_hmg_garrison_03 = SGroup_CreateIfNotFound("sg_german_hmg_garrison_03")
	
	Rule_AddInterval(CapSovietProgression, 3)
	
	Event_Timer(SetupEncounters, nil, 0.25)
	
	SetupAchievements()
	
	if g_debug then
		DEBUG_Beat_Selection_01()
	else
		startIntro()
	end

end


function SetupEncounters ()
	SetupEncounter01()
	SetupEncounter02()
	SetupEncounter03()
	SetupEncounter04()
	SetupEncounter05()
	SetupEncounter06()
	SetupEncounter07()
	SetupEncounter08()
	SetupEncounter09()
	SetupEncounter10()
	SetupEncounter11()
end


--======================================== Encounter 1: Truck Defender  ============================================--
function SetupEncounter01()

	t_encounters[1] = {}
	
	local encData = {
		player = player2,
		spawn = mkr_defend_truck,
		sgroups = {sg_defend_truck},
		units = {
			{
				name = "Truck_Defenders",
				sbp = SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD,
				spawn = mkr_enemy_base_hmg_01,
			},
			
			{
				name = "Truck_Defenders",
				sbp = SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD,
				spawn = mkr_enemy_base_hmg_02,
			},
			{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
			},
			
		},
	}
	t_encounters[1] = Encounter:Create(encData)
	t_encounters[1]:AddSgroup(sg_defend_truck_ATgun01)
	t_encounters[1]:AddSgroup(sg_defend_truck_ATgun02)
	
	local goalData = {
		name = "Defend",
		target = mkr_defend_truck,
		range = mkr_defend_truck,
		useSkirmishAI = true,
		tacticControlsList = {
			{
			tacticType = TACTIC_Recrew,
			priority = -1,
			},
		},
		fallbackParams = {
			thresholds = {0.3},
			thresholdType = Threshold_PercentageEntitiesRemaining,
			markers = {mkr_enemy_retreat},
			retreat = true,
			onFailure = DespawnMe,
		},
	}
	t_encounters[1]:SetGoal(goalData)
end
	
--======================================== Encounter 2: Truck Defender  ============================================--
function SetupEncounter02()
	
	t_encounters[2] = {}
	
	local encData = {
		player = player2,
		spawn = mkr_defend_truck_clone_02,
		sgroups = {SGroup_CreateIfNotFound("sg_enemy_enc2")},
		units = {
			{
				sbp = SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD,
				spawn = eg_enemy_garrison_04,
				numSquads = 2,
			},
			{
				sbp = SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD,
				spawn = eg_enemy_mg42_nest03,
			},
		},
	}
	t_encounters[2].garrison = Encounter:Create(encData)
	
	local encData = {
		player = player2,
		spawn = mkr_defend_truck_clone_02,
		sgroups = {SGroup_CreateIfNotFound("sg_enemy_enc2")},
		units = {
			{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				numSquads = 2,
			},
		},
	}
	t_encounters[2].defenders = Encounter:Create(encData)
	t_encounters[2].defenders:AddSgroup(sg_defend_truck2_ATgun)
	
	local goalData = {
		name = "Defend",
		target = mkr_defend_truck_clone_02,
		range = mkr_defend_truck_clone_02,
		useSkirmishAI = true,
		tacticControlsList = {
			{
			tacticType = TACTIC_Recrew,
			priority = -1,
			},
		},
	}
	t_encounters[2].defenders:SetGoal(goalData)
	
	local encData = {
		player = player2,
		spawn = mkr_defend_bridge_01,
		sgroups = {SGroup_CreateIfNotFound("sg_enemy_enc2")},
		units = {
			{
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
				numSquads = 2,
			},
		},
	}
	t_encounters[2].defendersB = Encounter:Create(encData)
	
	local goalData = {
		name = "Defend",
		target = mkr_defend_bridge_01,
		range = mkr_defend_bridge_01,
		useSkirmishAI = true,
		tacticControlsList = {
			{
			tacticType = TACTIC_Recrew,
			priority = -1,
			},
		},
	}
	t_encounters[2].defendersB:SetGoal(goalData)
end

--======================================== Encounter 3: Defender Garrison 1 ============================================--
function SetupEncounter03()
	t_encounters[3] = {}
	
	local encData = {
		player = player2,
		sgroups = {SGroup_CreateIfNotFound("sg_german_hmg_garrison_01")},
		units = {
			{
				sbp = SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD,
				spawn = eg_enemy_garrison_01,
				numSquads = 2,
			},
		},
	}
	t_encounters[3].garrison = Encounter:Create(encData)
	local encData = {
		player = player2,
		sgroups = {SGroup_CreateIfNotFound("sg_german_hmg_garrison_01_def")},
		units = {
			{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = mkr_defend_garrison_01,
				numSquads = 2,
			},
		},
	}
	t_encounters[3].defenders = Encounter:Create(encData)
	local goalData = {
		name = "Defend",
		target = mkr_defend_garrison_01,
		range = mkr_defend_garrison_01,
		useSkirmishAI = true,
		tacticControlsList = {
			{
			tacticType = TACTIC_Recrew,
			priority = -1,
			},
		},
	}
	t_encounters[3].defenders:SetGoal(goalData)
end	

--======================================== Encounter 4: Defender Garrison 2 ============================================--
function SetupEncounter04()
	t_encounters[4] = {}
	
	local encData = {
		player = player2,
		sgroups = {SGroup_CreateIfNotFound("sg_german_hmg_garrison_02")},
		units = {
			{
				sbp = SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD,
				spawn = eg_enemy_garrison_02,
				numSquads = 2,
			},
		},
	}
	t_encounters[4].garrison = Encounter:Create(encData)
	local encData = {
		player = player2,
		sgroups = {SGroup_CreateIfNotFound("sg_german_hmg_garrison_02_def")},
		units = {
			{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = mkr_defend_garrison_02,
				numSquads = 2,
			},
		},
	}
	t_encounters[4].defenders = Encounter:Create(encData)
	local goalData = {
		name = "Defend",
		target = mkr_defend_garrison_02,
		range = mkr_defend_garrison_02,
		useSkirmishAI = true,
		tacticControlsList = {
			{
			tacticType = TACTIC_Recrew,
			priority = -1,
			},
		},
	}
	t_encounters[4].defenders:SetGoal(goalData)
end	

--======================================== Encounter 5: Defender Garrison 3 ============================================--
function SetupEncounter05()
	t_encounters[5] = {}
	local encData = {
		player = player2,
		sgroups = {SGroup_CreateIfNotFound("sg_german_hmg_garrison_03")},
		units = {
			{
				sbp = SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD,
				spawn = eg_enemy_garrison_03,
				numSquads = 2,
			},
		},
	}
	t_encounters[5] = Encounter:Create(encData)
end	

--======================================== Encounter 6: Defender AT Gun 01 ============================================--
function SetupEncounter06()
	t_encounters[6] = {}
	t_encounters[6] = Encounter:ConvertSgroup(sg_at_camp_ATgun01)
	local goalData = {
		name = "Defend",
		target = mkr_defend_at_camp_01,
		range = mkr_defend_at_camp_01,
		useSkirmishAI = true,
		tacticControlsList = {
			{
			tacticType = TACTIC_Recrew,
			priority = -1,
			},
		},
	}
	t_encounters[6]:SetGoal(goalData)
end

--======================================== Encounter 7: Defender AT Gun 02 ============================================--
function SetupEncounter07()
	t_encounters[7] = {}
	local encData = {
		player = player2,
		sgroups = {SGroup_CreateIfNotFound("sg_german_at_camp_02")},
		units = {
			{
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
				spawn = mkr_defend_at_camp_02,
			},
			{
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
				spawn = mkr_hmg_spawn_02,
			},
		},
	}
	t_encounters[7] = Encounter:Create(encData)
	t_encounters[7]:AddSgroup(sg_at_camp_ATgun02)
	
	local goalData = {
		name = "Defend",
		target = mkr_defend_at_camp_02,
		range = mkr_defend_at_camp_02,
		useSkirmishAI = true,
		tacticControlsList = {
			{
			tacticType = TACTIC_Recrew,
			priority = -1,
			},
		},
	}
	t_encounters[7]:SetGoal(goalData)
end

--======================================== Encounter 8: Defender HMG Gun 01 ============================================--
function SetupEncounter08()
	t_encounters[8] = {}
	local encData = {
		player = player2,
		sgroups = {SGroup_CreateIfNotFound("sg_enemy_hmg_01")},
		units = {
			{
				sbp = SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD,
				spawn = eg_enemy_mg42_nest04,
			},
		},
	}
	t_encounters[8] = Encounter:Create(encData)
end	

--======================================== Encounter 9: Defender HMG Gun 02 ============================================--
function SetupEncounter09()
	t_encounters[9] = {}
	local encData = {
		player = player2,
		sgroups = {SGroup_CreateIfNotFound("sg_enemy_hmg_02")},
		units = {
			{
				sbp = SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD,
				spawn = eg_enemy_mg42_nest05,
			},
		},
	}
	t_encounters[9] = Encounter:Create(encData)
end	

--======================================== Encounter 10: Back Point  ============================================--
function SetupEncounter10()
	
	t_encounters[10] = {}
	
	SGroup_SetAnimatorState(sg_backpoint_pIV, "vehicle_variant", "f1")
	
	local encData = {
		player = player2,
		sgroups = {sg_enemy_backpoint},
		units = {
			{
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
				spawn = mkr_backpoint_infantry_01,
			},
			{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = mkr_backpoint_infantry_02,
				upgrades = {UPG.GERMAN.GRENADIER_MG42_LMG},
			},
			{
				sbp = SBP.GERMAN.MORTAR_TEAM_81MM,
				spawn = mkr_backpoint_mortar_01,
			},
		},
	}
	t_encounters[10] = Encounter:Create(encData)
	t_encounters[10]:AddSgroup(sg_backpoint_ATgun)
	t_encounters[10]:AddSgroup(sg_backpoint_pIV)
	t_encounters[10]:AddSgroup(sg_backpoint_scoutCar)
	
	local goalData = {
		name = "Defend",
		target = mkr_backpoint_space,
		range = mkr_backpoint_space,
		useSkirmishAI = true,
		tacticControlsList = {
			{
			tacticType = TACTIC_Recrew,
			priority = -1,
			},
		},
	}
	t_encounters[10]:SetGoal(goalData)
end	

--======================================== Encounter 11: Panzer Garrison  ============================================--
function SetupEncounter11()
	t_encounters[11] = {}
	SGroup_SetAnimatorState(sg_panzer_garrison_pIV, "vehicle_variant", "f1")
	
	local encData = {
		player = player2,
		sgroups = {sg_panzer_garrison},
		units = {
			{
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
				spawn = eg_enemy_garrison_05,
			},
			{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = eg_enemy_garrison_05,
				upgrades = {UPG.GERMAN.GRENADIER_MG42_LMG},
				numSquads = 2,
			},
		},
	}
	t_encounters[11].infantry = Encounter:Create(encData)
	
	t_encounters[11].vehicles = Encounter:ConvertSgroup(sg_panzer_garrison_ATgun)
	t_encounters[11].vehicles:AddSgroup(sg_panzer_garrison_pIV)
	
	local goalData = {
		name = "Defend",
		target = mkr_panzer_garrison_space,
		range = mkr_panzer_garrison_space,
		useSkirmishAI = true,
			tacticControlsList = {
			{
			tacticType = TACTIC_Recrew,
			priority = -1,
			},
		},
	}
	t_encounters[11].vehicles:SetGoal(goalData)
end

--=====================================================================================================--
--======================================== MISSION START   ============================================--
--=====================================================================================================--

function Mission_MissionStart()

	if Event_IsAnyRunning() == false then
		Rule_RemoveMe()
		
		Mission_DelayObjTitle()
	end
end



function Mission_DelayObjTitle()

	Objective_Start(OBJ_Main) 
	Event_Timer (StartBronze, nil, 5)
	
end

function StartBronze(data)
	Objective_Start(OBJ_Silver)
	Event_Timer (StartBonus, nil, 5)
	
end

function StartBonus(data)
	Objective_Start(OBJ_Bonus)

end

--=====================================================================================================--
--========================================== Objectives  ==============================================--
--=====================================================================================================--

function Initialize_Objectives()

	OBJ_Main = {
		
		SetupUI = function() 
		end,
		
		OnStart = function()
			Objective_StartTimer(OBJ_Main, COUNT_DOWN, t_difficulty.startTime, 60)
			g_maxTime = t_difficulty.startTime
			Obj_ShowProgress2 (11038788, 1)
			Rule_AddInterval(TimerCheck, 1)
			Rule_AddInterval(Mission_Fail_HQ_Destroyed, 5)
			Rule_AddDelayedInterval(CheckTargetBuildings, 3, 1)
			SetupHints()
		end,
		
		OnComplete = function()
			Game_EndSP(true)
		end,
		
		OnFail = function()
			Game_EndSP(false)
		end,
		
		IsComplete = function()
			return false
		end,
		
		Intel_Start = nil,				-- Event will play when obj starts but before any UI appears
		Intel_Complete = nil,			-- Event will play when obj completes but before UI is cleared
		Intel_Fail = nil,				-- Event will play when obj fails but before UI is cleared
		Title = 11038789,  -- LOCDB [11038789] 'Destroy the German structures before time runs out.'
		Description = 0,			-- Objective Description
		Type = OT_Primary,				-- Objective Type (OT_Primary, OT_Secondary)
	}


	OBJ_Silver = {
		Parent = OBJ_Main,
		SetupUI = function() 
		end,
		
		OnStart = function()
			Objective_SetCounter (OBJ_Silver, 0, g_silver)
		end,
		
		OnComplete = function()
			Rule_AddInterval(StartGold,1)
		end,
		
		OnFail = function()
		end,
		
		IsComplete = function()
			return false
		end,
		
		Intel_Start = nil,				-- Event will play when obj starts but before any UI appears
		Intel_Complete = nil,			-- Event will play when obj completes but before UI is cleared
		Intel_Fail = nil,				-- Event will play when obj fails but before UI is cleared
		Title = Loc_FormatText(11047611,Loc_ConvertNumber(g_silver)),				-- LOCDB [11038790] '%1LEVEL%: Destroy %2NUMBER% German structures'
		Description = 0,			-- Objective Description
		Type = OT_Secondary,				-- Objective Type (OT_Primary, OT_Secondary)
	}


	OBJ_Gold = {
		SetupUI = function() 
		end,
		
		OnStart = function()
			Objective_SetCounter (OBJ_Gold, 0, g_gold - g_silver)
		end,
		
		OnComplete = function()
			Achieve ("tow_indirect_fire_indirect_gold")
			Mission_MissionComplete()
		end,
		
		OnFail = function()
		end,
		
		IsComplete = function()
			return false
		end,
		
		Intel_Start = EVENTS.Bonus,				-- Event will play when obj starts but before any UI appears
		Intel_Complete = nil,			-- Event will play when obj completes but before UI is cleared
		Intel_Fail = nil,				-- Event will play when obj fails but before UI is cleared
		Title = Loc_FormatText(11038790,11047614,Loc_ConvertNumber(g_gold - g_silver)),				-- LOCDB [11038790] '%1LEVEL%: Destroy %2NUMBER% German structures'
		Description = 0,			-- Objective Description
		Type = OT_Secondary,				-- Objective Type (OT_Primary, OT_Secondary)
	}

	OBJ_Bonus = {
		
		SetupUI = function() 
		end,
		
		OnStart = function()
			Rule_AddOneShot(SetupBonusTime,1)
			Rule_AddOneShot(SetupPoints,1)
			Objective_SetCounter(OBJ_Bonus, 0, g_totalNeutralBuildings)
		end,
		
		OnComplete = function()
		end,
		
		OnFail = function()
			Util_MissionTitle(11046243)
			if Objective_IsComplete(OBJ_Silver) then
--~ 				Util_MissionTitle (LOC("You have covered our withdrawal from the city." ))
			end
			Mission_MissionComplete()
		end,
		
		IsComplete = function()
			return false
		end,
		
		Intel_Start = nil,				-- Event will play when obj starts but before any UI appears
		Intel_Complete = nil,			-- Event will play when obj completes but before UI is cleared
		Intel_Fail = nil,				-- Event will play when obj fails but before UI is cleared
		Title = 11038793, -- LOCDB [11038793] 'Destroy neutral buildings for extra time.'
		Description = 0,			-- Objective Description
		Type = OT_Secondary,				-- Objective Type (OT_Primary, OT_Secondary)
	}

	Objective_Register(OBJ_Main)
	Objective_Register(OBJ_Silver)
	Objective_Register(OBJ_Bonus)
	Objective_Register(OBJ_Gold)
end

function StartGold()
	if not Event_IsAnyRunning() then
		Rule_RemoveMe()
		Objective_Start(OBJ_Gold)
	end
end


--======================================== Intro Functions  ===========================================--
--=====================================================================================================--
function DEBUG_Beat_Selection_01()
	UI_MessageBoxSetText(LOC("SELECT START"), LOC("Select the Mission beat to play"))
	UI_MessageBoxSetButton(DB_Button1, LOC("WITH INTRO"), LOC("Part 1"), "", true)
	UI_MessageBoxSetButton(DB_Button2, LOC("NO INTRO"), LOC("Part 2"), "", true)
	UI_MessageBoxSetButton(DB_Button3, LOC("NO MISSION"), LOC("Part 3"), "", true)
	UI_MessageBoxShow(DC_Default, DEV_SelectPhase_Menu_01)
end

function DEV_SelectPhase_Menu_01(button)

	if button == DB_Button1 then
		startIntro()
	elseif button == DB_Button2 then
		EGroup_Hide(eg_enemy_buildings, true)
		EGroup_Hide(eg_enemy_garrison_01, false)
		FOW_PlayerRevealAll(player1)
		Rule_AddOneShot(introReturn, 0.5)
		
	elseif button == DB_Button3 then
		_ToWDebugDisplay("No mission!", "gold")
		
	end
end


function startIntro()
	EGroup_Hide(eg_enemy_buildings, true)
	EGroup_Hide(eg_enemy_garrison_01, false)
	FOW_PlayerExploreAll(player1)
	Camera_SetInputEnabled(false)
	Game_Letterbox(true, 2)
	UI_SetForceShowSubtitles(true)
	Util_StartIntel(EVENTS.Intro)
end

function introReturn()
	EGroup_Hide(eg_enemy_buildings, false)
	Game_Letterbox(false, 2)
	Camera_SetInputEnabled(true)
	Initialize_Objectives()
	Rule_Add(Mission_MissionStart)
end

--=====================================================================================================--
--======================================== Mission Complete ===========================================--
--=====================================================================================================--

------- 	MISSION END FUNCTIONS -----	

function Mission_MissionComplete()
	Game_SetMode(UI_Cinematic)
	if Objective_IsComplete(OBJ_Silver) then
		Camera_MoveTo(mkr_panzer_garrison_space, true, 0.05)
		Util_StartIntel(EVENTS.VPVictoryMessage)
	end
	Rule_RemoveIfExist(Mission_MissionEnd)
	Rule_AddDelayedInterval(Mission_MissionEnd, 1.5, 1)
end

function Mission_MissionEnd()
	if Event_IsAnyRunning() == false then
		Rule_RemoveMe()
		if Objective_IsComplete(OBJ_Silver) then
			Game_EndSP (true)
		else
			Game_EndSP(false)
		end
	end
end

--=====================================================================================================--
--==================================     Mission Functions      =====================================--
--=====================================================================================================--


function CheckTargetBuildings()

	local eg_player2 = Player_GetEntities(player2)
	
	EGroup_Intersection(eg_player2, eg_enemy_buildings)
	
	local remain = EGroup_CountSpawned(eg_player2)
	local count = g_totalEnemyBuildings - remain
	local count2 = count
	local goal = 0
	local obj = nil
	local current = 0
	
	if Objective_IsStarted(OBJ_Gold) then
		obj = OBJ_Gold
		goal = g_gold - g_silver
		count = count - g_silver
	elseif Objective_IsStarted(OBJ_Silver) then
		obj = OBJ_Silver
		goal = g_silver
	end
	
	if (obj) then
		if Objective_IsCounterSet(obj) then
			current = Objective_GetCounter(obj)
		end
		if (current ~= count) then
			Objective_SetCounter(obj, count, goal)
			if count2 == 5 then
				LaunchRetaliation (t_difficulty.retalLight)
			elseif count2 == 10 then
				LaunchRetaliation (t_difficulty.retalMedium)
			elseif count2 == 15 and (current > 0) then
				LaunchRetaliation (t_difficulty.retalHeavy)
			elseif count2 == 18 then
				LaunchRetaliation (t_difficulty.retalHeavy)
			end
		end
		
		if count >= goal then
			Objective_Complete(obj)
		end
	end
end

function LaunchRetaliation (units)
	local index = #t_retal + 1
	t_retal[index] = {}
	
	local encData = {
		spawn = mkr_enemy_retreat,
		units = units,
	}
	
	local goalData = {
		name = "Attack",
		target = sg_katyushas,
	}
	
	if SGroup_CountSpawned (sg_katyushas) > 0 then	
		t_retal[index] = Encounter:Create(encData)
		t_retal[index]:SetGoal(goalData)	
	end
end


function SetupBonusTime()
	EGroup_ForEach(eg_buildings, AddBonusTimeEvent)
end

function AddBonusTimeEvent (group, index, entity)
	local group = EGroup_CreateIfNotFound("eg_building" .. index)
	EGroup_Add(group, entity)
	Event_GroupIsDead(BonusTime, {pos = Entity_GetPosition(entity), type="building"}, group)
end

function BonusTime (data)
	if data.type == "building" then
		g_neutralBuildingsDestroyed = g_neutralBuildingsDestroyed + 1
	end
	local timeLeft = Objective_GetTimerSeconds(OBJ_Main)
	Objective_StopTimer(OBJ_Main)
	timeLeft = timeLeft + 60
	if timeLeft > g_maxTime then
		g_maxTime = timeLeft
	end
	Objective_StartTimer(OBJ_Main, COUNT_DOWN, timeLeft, 60)
	UI_CreateColouredPositionKickerMessage(player1, data.pos, 11038794, GOLDENROD.r, GOLDENROD.g, GOLDENROD.b, 0) -- LOCDB [11038794] '+1 min.'
	Objective_SetCounter(OBJ_Bonus, g_neutralBuildingsDestroyed, g_totalNeutralBuildings)
end

function TimerCheck ()
	local timeLeft = Objective_GetTimerSeconds(OBJ_Main)
	if timeLeft < 1 then
		Rule_Remove(TimerCheck)
		Obj_HideProgress()
		if not Objective_IsComplete(OBJ_Gold) then
			Objective_Fail (OBJ_Bonus, false)
		end
	else
		Obj_ShowProgress2(11038788, timeLeft/g_maxTime)
	end
end


--------------------- STRATEGIC POINTS TRACKING ----------

function SetupPoints()
	eg_points = EGroup_CreateIfNotFound("eg_points")
	World_GetStrategyPoints(eg_points, false)
	EGroup_ForEach(eg_points, PopulatePointsTable)
	Rule_AddDelayedInterval(PointCheck, 10, 1)
end

function PopulatePointsTable(egroup, index, entity)
	local playerOwner = -1
	if World_OwnsEntity(entity) then
		playerOwner = -1
	else
		playerOwner = Entity_GetPlayerOwner(entity)
	end
	if playerOwner ~= player1 then
		local data = {
			id = entity,
			owner = playerOwner,
		}
		table.insert (t_points, data)
	end
	return false
end


function PointCheck()
	for k, point in pairs (t_points) do
		if point.owner ~= player1 then
			local currentOwner = -1
			if not World_OwnsEntity(point.id) then
				currentOwner = Entity_GetPlayerOwner(point.id)
			end
			if currentOwner == player1 then
				BonusTime({pos=Entity_GetPosition(point.id),type="point"})
				point.owner = player1
			end
		end
	end
end

------------------------------------------ HELPER FUNCTIONS ------------------------------------------------

function DespawnMe(enc)
	SGroup_DestroyAllSquads(enc.sgroup)
end


function SetupHints()
	_ToWDebugDisplay("SetupHints", "gold")
	t_hints = {}
	local function CreateHints(egroup, index, entity)
		local group = EGroup_CreateIfNotFound("eg_enemy_building"..tostring(index))
		EGroup_Add(group, entity)
		local hint = uiChecker(index, group)
		t_hints[index] = {
			group = group,
			uiCheck = hint,
			hintPoint = nil,
		}
	end
	EGroup_ForEach(eg_enemy_buildings, CreateHints)
end

function uiChecker (i, egroup)
	_ToWDebugDisplay("uiChecker" .. i, "gold")
	local data = 
	{
		i = i,
		egroup = egroup,
	}
	local id = 	Event_PlayerCanSeeElement(uiChecker_AddArrow, data, player1, egroup)
	return id
end

function uiChecker_AddArrow(data)
	_ToWDebugDisplay("uiChecker_AddArrow" .. data.i, "gold")
	local index = data.i
	local egroup = data.egroup
	if (EGroup_CountAlive(egroup)>0) and (World_OwnsEGroup(egroup, ALL)==false) and (Player_OwnsEGroup(player2, egroup)) then
		local hintPoint = HintPoint_Add(egroup, true, 0, 3, HPAT_Objective, "Icons_commands_icon_command_attackmove")
		t_hints[index].hintPoint = hintPoint
		if not Rule_Exists (uiClearRule) then
			Rule_AddInterval(uiClearRule, 0.5)
		end
	end
end

function uiClearRule ()
	for i=1,#t_hints do
		if (t_hints[i].hintPoint) then
			local egroup = t_hints[i].group
			local hintPoint = t_hints[i].hintPoint
			local clear = true
			local endCheck = true
			if (EGroup_CountAlive(egroup)>0) and (World_OwnsEGroup(egroup, ALL)==false) and (Player_OwnsEGroup(player2, egroup)) then
				endCheck = false
				if Player_CanSeeEGroup(player1, egroup, ANY) then
					clear = false
				end
			end
			if clear == true then
				_ToWDebugDisplay("uiClearRule" .. i .. " cleared hint", "gold")
				HintPoint_Remove(hintPoint)
				t_hints[i].hintPoint = nil
				if endCheck == false then
					local data = {	i = i, egroup = egroup,	}
					Event_PlayerCanSeeElement(uiChecker_AddArrow, data, player1, egroup)
				end
			end
		end
	end
end

function CapSovietProgression()
	Player_SetResource(player1, RT_SovietProgression, 25)
end


function Achieve(data)
	if scartype (data) == ST_STRING then
		data = { id = data }
	end
	_ToWDebugDisplay("ACHIEVEMENT: " .. data.id, "gold")
	Scar_CompleteIntelBulletinTask(player1, data.id)
end

function SetupAchievements()
	local num = math.floor(EGroup_Count(eg_buildings) *0.25)
	Event_GroupLeftAlive (Achieve, {id="tow_indirect_fire_massive_destruction"}, eg_buildings, num)
	g_katyushaCount = 2
	Rule_AddInterval(AchievementCheck, 1)
end


function CountKatyushas(sgroup, index, squad)	
	if not SGroup_ContainsSquad(sg_katyushas, Squad_GetGameID(squad)) then
		g_katyushaCount = g_katyushaCount + 1
		SGroup_Add(sg_katyushas, squad)
	end
end

function AchievementCheck()
	Player_GetAll(player1)
	SGroup_Filter(sg_allsquads, SBP.SOVIET.KATYUSHA_BM_13N_SQUAD, FILTER_KEEP)
	SGroup_ForEach(sg_allsquads, CountKatyushas)
	if g_katyushaCount >= (g_totalAbandonnedKatyushas + 2) then
		Achieve ("tow_indirect_fire_rocket_recovery")
		Rule_RemoveMe()
	end
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

