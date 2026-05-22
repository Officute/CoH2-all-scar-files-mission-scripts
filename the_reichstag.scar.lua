-------------------------------------------------------------------------
-------------------------------------------------------------------------

-- Act 3 - Mission 3
-- The Reichstag
-- Designer: Ryan McGechaen

-------------------------------------------------------------------------
-------------------------------------------------------------------------

import("ScarUtil.scar")
import("Systems/AiManager/ai.scar")
import("Prototype/DeploymentPoints.scar")
import("Beginner.scar")
import("Order227.scar")
import("Global_Values/CampaignGlobalConstants.scar")

-------------------------------------------------------------------------
-- [[ SETUP ]]
-------------------------------------------------------------------------

function OnGameSetup()
	
	-- Required Players
	player1 = Setup_Player(1, 11040472, "soviet", 1)		-- LOCDB [11040472] '3rd Shock Army'
	player2 = Setup_Player(2, 11040473, "german", 2)		-- LOCDB [11040473] 'Remnants of Berlin Defense Forces'
	player3 = Setup_Player(3, 11040472, "soviet", 1)		-- player3 is always the AI ally

end

function OnGameRestore()
	
	-- function takes care of restoring all global mission parameters after a save/load
	player1 = World_GetPlayerAt(1)
	player2 = World_GetPlayerAt(2)
	player3 = World_GetPlayerAt(3)
	
	Game_DefaultGameRestore()
	
end




-------------------------------------------------------------------------
-- [[ ONINIT ]]
-- [[ ONINIT ]]
-- [[ ONINIT ]]
-- [[ ONINIT ]]
-------------------------------------------------------------------------

function OnInit()
	
	Game_StartMuted(true)
	Game_SetMode(UI_Cinematic)
	Game_FadeToBlack(FADE_OUT, 0)
	
	--[[ PRESET DEBUG CONDITIONS ]]
	Mission_Debug()
	
	--[[ SET DIFFICULTY ]]
	Mission_Difficulty()
	
	--[[ SET RESTRICTIONS ]]
	Mission_Restrictions()
	
	--[[ MISSION PRESETS ]]
	Mission_MissionPreset()
	
	--[[ PLAY INTRO NIS]]
	Rule_AddOneShot(Mission_Start, 1)
	
	
	
	--[[ AUTOSAVE NAMES ]]
	-- 11049966 -- LOCDB [11049966] 'Mission 14 - Autosave 1'
	-- 11049967 -- LOCDB [11049967] 'Mission 14 - Autosave 2'
	-- 11049968 -- LOCDB [11049968] 'Mission 14 - Autosave 3'	
	
	
	--[[ REGISTER OBJECTIVES ]]
	MISSION_Init_Parent_Objective()
	MOLTKE_Init_Objective()
	MOTI_Init_Objective()
	
	MISSION_Init_Kroll_Parent_Objective()
	KROLL_Init_Objective()
	
	MISSION_Init_Reichstag_Parent_Objective()
	REICHSTAG_Init_Objective()
	
	BONUS_Init_Objective()
	
	--[[ PLAY INTRO NIS]]
	Mission_Intro_Init()
	Moltke_Init()
	
	EGroup_EnableMinimapIndicator(eg_territorypoints_stage2, false)
	EGroup_EnableMinimapIndicator(eg_territorypoints_stage3, false)
	EGroup_EnableMinimapIndicator(eg_territorypoints_stage4, false)

end

Scar_AddInit(OnInit)

function Mission_Debug()
	
	-- looks for the command line option [-debug]
	if Misc_IsCommandLineOptionSet("debug") then
		g_debug = true
	end
	
	-- set up bindings for NISes
--~ 	Scar_DebugConsoleExecute("bind([[ALT+1]], [[Scar_DoString('Util_StartNIS(NIS_OPENING_BLEND)')]])")
--~ 	Scar_DebugConsoleExecute("bind([[ALT+2]], [[Scar_DoString('Util_StartNIS(NIS_CLOSING)')]])")
	
end


function Mission_Start()

	Util_PlayMovie("m14_cin01", 0, 0)
	Rule_AddInterval(Mission_StartB, 1)
	
end
function Mission_StartB()
	
 	if Event_IsAnyRunning() == false then
		
		Rule_RemoveMe()
		
		Util_StartNIS(EVENTS.INTRO_NIS)
		
		UI_SetSoviet227Visibility(true)
		Order227_Init(120, nil, true)
		ConscriptProgression_AudioInit(true, true)
		
		Sound_PlayMusic("streamed/music/missions/m14/m14_cue_start", 4, 0)
		
		Rule_AddDelayedInterval(MOLTKE_Kickoff_Objective, 2.5, 1)
		Rule_AddInterval(Mission_Fail_HQ_Destroyed, 6)
		
	end
	
end


function Mission_Difficulty()
	
	-- get the difficulty
	g_difficulty = Game_GetSPDifficulty()  -- set a global difficulty variable 
	print("********* DIFFICULTY: "..g_difficulty)
	
	t_difficulty = {
		starting_manpower 			= Util_DifVar( {800, 700, 600, 0} ), 	-- Starting Manpower
		starting_munitions 			= Util_DifVar( {150, 100, 70,  0} ), 	-- Starting Munitions
		starting_fuel 				= Util_DifVar( {125, 100, 75,  0} ), 	-- Starting Fuel
		pop_cap						= Util_DifVar( {135, 135, 100, 0} ), 	-- Population Cap
		
		manpower_cap				= Util_DifVar( {3001,2001,1501,0} ), 	-- Manpower Cap
		munition_cap				= Util_DifVar( {601, 501, 301, 0} ), 	-- Munition Cap
		fuel_cap					= Util_DifVar( {401, 401, 201, 0} ), 	-- Fuel Cap
		
		moti_granted_munitions		= Util_DifVar( {200, 200, 100, 0} ), 	-- Fuel Cap
		moti_granted_fuel			= Util_DifVar( {100, 80,  60,  0} ), 	-- Fuel Cap
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

function Mission_Restrictions()
	
	Player_SetPopCapOverride(player1, t_difficulty.pop_cap)
	
	Cmd_Upgrade(player1, BP_GetUpgradeBlueprint("mission14_upgrade"), 1, true)
	Cmd_Upgrade(player1, UPG.SOVIET.T34_85_UNLOCK, 1, true)
	Cmd_Upgrade(player1, UPG.SOVIET.CONSCRIPT_ASSAULT_PACKAGE, 1, true)
	Cmd_Upgrade(player1, BP_GetUpgradeBlueprint("fire_artillery"), 1, true)
	Cmd_Upgrade(player1, UPG.SOVIET.IL_2_BOMB_STRIKE, 1, true)
	
	
	Player_AddAbility(player1, ABILITY.SOVIET.BASE_CONSCRIPT_DISPATCH)
	Player_AddAbility(player1, BP_GetAbilityBlueprint("frontoviki_conscript_dispatch"))
	Player_AddAbility(player1, ABILITY.SOVIET.PENAL_TROOP_DISPATCH_SP)
	Player_AddAbility(player2, BP_GetAbilityBlueprint("m14_off_map_smoke_barrage"))
	
	Player_SetAbilityAvailability(player1, BP_GetAbilityBlueprint("fire_artillery"), ITEM_REMOVED)
	Player_SetAbilityAvailability(player1, ABILITY.SOVIET.IL_2_PRECISION_BOMB_STRIKE, ITEM_REMOVED)
	Player_SetAbilityAvailability(player1, ABILITY.SOVIET.CMD_CONSCRIPT_ASSAULT_PACKAGE, ITEM_REMOVED)
	Player_SetAbilityAvailability(player1, ABILITY.SOVIET.CMD_T34_85_MEDIUM_TANK, ITEM_REMOVED)	
	
	Player_SetEntityProductionAvailability(player1, EBP.SOVIET.M1937_152MM_ML_20_ARTILLERY, ITEM_LOCKED)
	Player_SetEntityProductionAvailability(player3, EBP.SOVIET.MOTORPOOL, ITEM_UNLOCKED)
	
	Cmd_Upgrade(player2, UPG.GERMAN.BATTLE_PHASE_2, 1, true)
	Cmd_Upgrade(player2, UPG.GERMAN.BATTLE_PHASE_3, 1, true)
	Cmd_Upgrade(player2, BP_GetUpgradeBlueprint("mission14_upgrade"), 1, true)
	
	-- AI Setup
	
end

-------------------------------------------------------------------------
-- MISSION Preset 
-------------------------------------------------------------------------

function Mission_MissionPreset()
	
	sg_temp = SGroup_CreateIfNotFound("sg_temp")
	sg_blah = SGroup_CreateIfNotFound("sg_blah")
	eg_temp = EGroup_CreateIfNotFound("eg_temp")
	eg_blah = EGroup_CreateIfNotFound("eg_blah")
	
	sg_mergehints = SGroup_CreateIfNotFound("sg_mergehints")
	sg_reinforcehints = SGroup_CreateIfNotFound("sg_reinforcehints")
	eg_reinforcehints = EGroup_CreateIfNotFound("eg_reinforcehints")
	
	-- Start Parent Function
	Rule_AddDelayedInterval(Mission_MissionStart, 1, 1)
	
	-- Set camera override
	Camera_SetDefault(40, 43, 285)
	Camera_ResetToDefault()
	
	-- Set resource rate
	Player_SetResource(player1, RT_SovietProgression, 50)
	Player_SetResource(player1, RT_Command, 6)
	
	-- Set resource cap
	Modify_PlayerResourceCap(player1, RT_Manpower, t_difficulty.manpower_cap, MUT_Addition)
	Modify_PlayerResourceCap(player1, RT_Munition, t_difficulty.munition_cap, MUT_Addition)
	Modify_PlayerResourceCap(player1, RT_Fuel, t_difficulty.fuel_cap, MUT_Addition)
	
	-- Set Abandoned vehicles
	-- Brummbar 01
	Cmd_CriticalHit(player2, sg_abandon_brummbar_01, CRIT.VEHICLE_LOSE_TREADS_OR_WHEELS, 0.75)
	SGroup_SetAvgHealth(sg_abandon_brummbar_01, 0.6)
	Cmd_CriticalHit(player2, sg_abandon_brummbar_01, CRIT.VEHICLE_ABANDON, 0)
	sg_amb_e_brummbar_01 = SGroup_CreateIfNotFound("sg_amb_e_brummbar_01")
	Util_CreateSquads(player2, sg_amb_e_brummbar_01, SBP.GERMAN.OSTRUPPEN_SQUAD, mkr_amb_e_brummbar_01_def_s1, nil, 1, 3)
	Util_CreateSquads(player2, sg_amb_e_brummbar_01, SBP.GERMAN.GRENADIER_SQUAD, mkr_amb_e_brummbar_01_def_s2, nil, 1, 2)
	
	-- Stug 01
	Cmd_CriticalHit(player2, sg_moti_stug, CRIT.VEHICLE_ABANDON, 0)
	
	-- Ostwind 01
	Cmd_CriticalHit(player2, sg_abandon_ostwind_01, CRIT.VEHICLE_ABANDON, 0)
	
	-- Set Reichstag invuln
	EGroup_SetInvulnerable(eg_reichstag_all, true)
	
	-- Set Kroll walls unselectable
	EGroup_SetSelectable(eg_kroll_wall_bld_01, false)
	EGroup_SetInvulnerable(eg_kroll_wall_bld_01, true)
	
	-- Add the Order 227 UI
--~ 	UI_SetSoviet227Visibility(true)
	
	-- Upgrade the HQ
--~ 	Cmd_Upgrade(eg_p_hq, UPG.SOVIET.HQ_HEALING_AURA, 1, true)
	
	-- Set starting resources
	Player_SetResource(player1, RT_Manpower, t_difficulty.starting_manpower)
	Player_SetResource(player1, RT_Munition, t_difficulty.starting_munitions)
	Player_SetResource(player1, RT_Fuel, t_difficulty.starting_fuel)
	
	-- Set Timer Variables
	_lossTimer = 60*60
	
	-- Despawn some stuff
	
	-- Set some stuff
	
	
	-- Grant abilities
	Player_AddAbility(player2, BP_GetAbilityBlueprint("moltke_det_pack"))
	
	-- Add Rule to grant munitions to AI
	Rule_AddInterval(Mission_Grant_Munitions, 5)
	
	Rule_AddOneShot(Mission_HideCP, 1)
	
end


function Mission_Intro_Init()
	
	sg_a_truck_01 = SGroup_CreateIfNotFound("sg_a_truck_01")
	
	Util_CreateSquads(player1, sg_a_truck_01, BP_GetSquadBlueprint("us6_truck_squad"), mkr_intro_a_truck_01_spawn)
	Cmd_SquadPath(sg_a_truck_01, "pth_intro_truck_01", true, false, false, 0)
	Cmd_MoveToAndDespawn(sg_a_truck_01, mkr_intro_despawner, true)
	
	sg_a_truck_02 = SGroup_CreateIfNotFound("sg_a_truck_02")
	
	Util_CreateSquads(player1, sg_a_truck_02, BP_GetSquadBlueprint("us6_truck_squad"), mkr_intro_a_truck_02_spawn)
	Cmd_SquadPath(sg_a_truck_02, "pth_intro_truck_02", true, false, false, 0)
	Cmd_MoveToAndDespawn(sg_a_truck_02, mkr_intro_despawner, true)
	
	sg_p_con_01 = SGroup_CreateIfNotFound("sg_p_con_01")
	sg_p_con_02 = SGroup_CreateIfNotFound("sg_p_con_02")
	sg_p_con_03 = SGroup_CreateIfNotFound("sg_p_con_03")
	
	Util_CreateSquads(player1, sg_p_con_01, SBP.SOVIET.BASE_CONSCRIPT_SQUAD, mkr_intro_p_con_01_spawn)
	Util_CreateSquads(player1, sg_p_con_02, SBP.SOVIET.BASE_CONSCRIPT_SQUAD, mkr_intro_p_con_02_spawn)
	Util_CreateSquads(player1, sg_p_con_03, SBP.SOVIET.BASE_CONSCRIPT_SQUAD, mkr_intro_p_con_03_spawn)
	
	sg_p_shock_01 = SGroup_CreateIfNotFound("sg_p_shock_01")
	Util_CreateSquads(player1, sg_p_shock_01, SBP.SOVIET.SHOCK_TROOPS, mkr_intro_p_shock_spawn)
	
	sg_p_engineer_01 = SGroup_CreateIfNotFound("sg_p_engineer_01")
	Util_CreateSquads(player1, sg_p_engineer_01, SBP.SOVIET.COMBAT_ENGINEER_SQUAD, mkr_intro_p_engineer_spawn)
	
	sg_p_is2 = SGroup_CreateIfNotFound("sg_p_is2")
	Util_CreateSquads(player1, sg_p_is2, SBP.SOVIET.IS_2, mkr_intro_p_is2_spawn)

end

function Mission_Grant_Munitions()

	Player_SetResource(player2, RT_Munition, 999)

end

function Mission_MissionStart()
	
	if Event_IsAnyRunning() == false then
		Rule_RemoveMe()
		-- Capture points
		EGroup_InstantCaptureStrategicPoint(eg_player_cp, player1)
		EGroup_InstantCaptureStrategicPoint(eg_enemy_cp, player2)
		
		-- Mission Functions
		
		-- Achievements
		Before_The_Winter()
		Boots_In_The_Streets()
		Collect_Abandoned_Vehicles()
		
		-- hints about merging into damaged squads and reinforcing from halftracks and HQs
		Reichstag_UpdateHintGroups()
		BeginnerHint_AddOpportunity(sg_mergehints, HINT_MERGE, true, nil, nil, nil, GD_EASY)
		BeginnerHint_AddOpportunity(sg_reinforcehints, HINT_REINFORCE, true, nil, nil, nil, GD_EASY)
		Rule_AddInterval(Reichstag_UpdateHintGroups, 30)
		
	end

end

function Reichstag_UpdateHintGroups()

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





function Mission_Complete_Check()

	if Event_IsAnyRunning() == false then
		Rule_RemoveMe()
		
		Game_EndSP(true)
	end

end

function Mission_HideCP() 

	UI_SetCPMeterVisibility(false) 
	
end

function Mission_Autosave_01()

	Util_Autosave(11049966) -- LOCDB [11049966] 'Mission 14 - Autosave 1'

end

function Mission_Autosave_02()

	Util_Autosave(11049967) -- LOCDB [11049967] 'Mission 14 - Autosave 2'

end
----------------------------
-- ACHIEVEMENTS
----------------------------
-- Claimed For the Motherland
function Collect_Abandoned_Vehicles()
	
	sg_p_brummbar = SGroup_CreateIfNotFound("sg_p_brummbar")
	sg_p_stug = SGroup_CreateIfNotFound("sg_p_stug")
	sg_p_ostwind = SGroup_CreateIfNotFound("sg_p_ostwind")
	
	_brummbarCaptured = false
	_stugCaptured = false
	_ostwindCaptured = false
	
	Rule_AddInterval(_brummbar, 1)
	Rule_AddInterval(_stug, 1)
	Rule_AddInterval(_ostwind, 1)
	Rule_AddInterval(_Achievement_Vehicles, 1)

end

function _brummbar()

	Player_GetAllSquadsNearMarker(player1, sg_p_brummbar, mkr_brummbar)
	SGroup_Filter(sg_p_brummbar, SBP.GERMAN.BRUMMBAR_SQUAD, FILTER_KEEP)
	if SGroup_IsEmpty(sg_p_brummbar) == false then
		Rule_RemoveMe()
		_brummbarCaptured = true
	end

end

function _stug()

	Player_GetAllSquadsNearMarker(player1, sg_p_stug, mkr_stug)
	SGroup_Filter(sg_p_stug, SBP.GERMAN.STUG_III_E_SQUAD, FILTER_KEEP)
	if SGroup_IsEmpty(sg_p_stug) == false then 
		Rule_RemoveMe() 
		_stugCaptured = true 
	end

end

function _ostwind()

	Player_GetAllSquadsNearMarker(player1, sg_p_ostwind, mkr_ostwind)
	SGroup_Filter(sg_p_ostwind, SBP.GERMAN.OSTWIND_SQUAD, FILTER_KEEP)
	if SGroup_IsEmpty(sg_p_ostwind) == false then 
		Rule_RemoveMe() 
		_ostwindCaptured = true 
	end

end

function _Achievement_Vehicles()

	if _brummbarCaptured == true and _stugCaptured == true and _ostwindCaptured == true then
		Rule_RemoveMe()
		Scar_CompleteIntelBulletinTask(player1, "camp14_reichstag_recrewed")
	end

end


-- Before the Winter
function Before_The_Winter()

	tmr_beforeTheWinter = "tmr_beforeTheWinter"
	Timer_Start(tmr_beforeTheWinter, 60*60)
	
	_beforeTheWinter_failed = false
	
	Rule_AddInterval(_Achievement_Before_Winter, 1)

end

function _Achievement_Before_Winter()

	if Timer_GetRemaining(tmr_beforeTheWinter) == 0 then
		Rule_RemoveMe()
		_beforeTheWinter_failed = true
	end

end


-- Boots in the Street
function Boots_In_The_Streets()

	_vehicles = {
		SBP.SOVIET.IS_2,
		SBP.SOVIET.KATYUSHA_BM_13N_SQUAD,
		SBP.SOVIET.KV_1,
		SBP.SOVIET.KV_8,
		SBP.SOVIET.M3A1_SCOUT_CAR_SQUAD,
		SBP.SOVIET.M5_HALFTRACK_SQUAD,
		SBP.SOVIET.SU_76M,
		SBP.SOVIET.SU_85,
		SBP.SOVIET.T_34_76_SQUAD,
		SBP.SOVIET.T_34_85_SQUAD,
		SBP.SOVIET.T_70M,
	}
	
	_bootsInTheStreet_failed = false
	
	Rule_AddInterval(_Achievement_Boots, 10)

end

function _Achievement_Boots()

	Player_GetAll(player1)
	
	SGroup_RemoveGroup(sg_allsquads, sg_p_is2)
	
	if SGroup_ContainsBlueprints(sg_allsquads, _vehicles, ANY) then
		Rule_RemoveMe()
		_bootsInTheStreet_failed = true
	end

end

----------------------------
-- PARENT OBJECTIVE
----------------------------
function MISSION_Init_Parent_Objective()

	OBJ_Parent_Mission = {
		
		SetupUI = function() 
			
		end,
		
		OnStart = function()
			
		end,
		
		OnComplete = function()
			Rule_AddOneShot(Mission_Autosave_01, 4)
			Rule_AddOneShot(KROLL_Delay_Start, 7)
		end,
		
		OnFail = function()
			
		end,
		
		IsComplete = function()
			return false
		end,
		
		Intel_Start = nil,				-- Event will play when obj starts but before any UI appears
		Intel_Complete = nil,			-- Event will play when obj completes but before UI is cleared
		Intel_Fail = nil,				-- Event will play when obj fails but before UI is cleared
		Title = 11046964,				-- LOCDB [11046964] 'Capture The Goverment District'
		Type = OT_Primary,				-- Objective Type (OT_Primary, OT_Secondary)
	}
	
	Objective_Register(OBJ_Parent_Mission)

end

function Mission_SitRep_Start()

	if Event_IsAnyRunning() == false then
		
		Rule_RemoveMe()
		
		Util_PlayMovie("m14_sitrep", 1.5, 1, MOTI_Kickoff_Objective)
		
	end

end



function Mission_RoadBlocks_Init()

	eg_m14_allroadblocks = EGroup_CreateIfNotFound("eg_m14_allroadblocks")
	
	_roadBlocks = {eg_m14_roadblock_01, eg_m14_roadblock_02, eg_m14_roadblock_03, eg_m14_roadblock_04,
					eg_m14_roadblock_05, eg_m14_roadblock_06, eg_m14_roadblock_07, eg_m14_roadblock_08}
	
	for k, group in pairs(_roadBlocks) do 
		EGroup_AddEGroup(eg_m14_allroadblocks, group)
	end
	
	hpid_roadBlock = nil
	_currRoadBlock = nil
	
	_firstRoadBlockIntel = false
	_totalRoadBlocks = EGroup_CountSpawned(eg_m14_allroadblocks)
	
	Rule_AddInterval(Mission_RoadBlocks_StartHints, 1)

end

function Mission_RoadBlocks_StartHints()

	if encID_moltke_southDef:IsAlive() == false then
		
		Rule_RemoveMe()
		Rule_AddInterval(_Roadblocks, 1)
		
	end

end

function _Roadblocks()
	
	if table.getn(_roadBlocks) == 0 then 
		Rule_RemoveMe()
		return
	end
	
	for i = table.getn(_roadBlocks), 1, -1 do
		
		if EGroup_IsEmpty(_roadBlocks[i]) then 
			table.remove(_roadBlocks, i) return 
		else
			
			if EGroup_IsOnScreen(player1, _roadBlocks[i], ANY, 0.9) 
			  and Prox_ArePlayersNearMarker(player1, Util_GetPosition(_roadBlocks[i]), ANY, 20) then
				print("Found Road Block")
				if hpid_roadBlock ~= nil and _currRoadBlock ~= _roadBlocks[i] then
					-- Road Block exists
					HintPoint_Remove(hpid_roadBlock)
					hpid_roadBlock = nil
					_currRoadBlock = nil
				end
				
				if hpid_roadBlock == nil then
					hpid_roadBlock = HintPoint_Add(_roadBlocks[i], true, 11046965, 1)
					_currRoadBlock = _roadBlocks[i]
				end
				
				if _firstRoadBlockIntel == false and EGroup_CountSpawned(eg_m14_allroadblocks) == _totalRoadBlocks then
					_firstRoadBlockIntel = true
					Util_StartIntel(EVENTS.M14_ROADBLOCK_01)
				end
				return
			end
			
		end
		
	end

end


----------------------------
-- INTRO
----------------------------
function _Intro_Init()

	sg_intro_e_01 = SGroup_CreateIfNotFound("sg_intro_e_01")
	sg_intro_e_02 = SGroup_CreateIfNotFound("sg_intro_e_02")
	sg_intro_e_03 = SGroup_CreateIfNotFound("sg_intro_e_03")
	sg_intro_e_04 = SGroup_CreateIfNotFound("sg_intro_e_04")
	sg_intro_e_05 = SGroup_CreateIfNotFound("sg_intro_e_05")
	sg_intro_e_06 = SGroup_CreateIfNotFound("sg_intro_e_06")
	sg_intro_e_07 = SGroup_CreateIfNotFound("sg_intro_e_07")
	
	Util_CreateSquads(player2, sg_intro_e_01, SBP.GERMAN.OSTRUPPEN_SQUAD, mkr_intro_e_spawn_01, nil, 1, 1)
	Util_CreateSquads(player2, sg_intro_e_02, SBP.GERMAN.GRENADIER_SQUAD, mkr_intro_e_spawn_02, nil, 1, 1)
	Util_CreateSquads(player2, sg_intro_e_03, SBP.GERMAN.OSTRUPPEN_SQUAD, mkr_intro_e_spawn_03, nil, 1, 1)
	Util_CreateSquads(player2, sg_intro_e_04, SBP.GERMAN.OSTRUPPEN_SQUAD, mkr_intro_e_spawn_04, nil, 1, 1)
	Util_CreateSquads(player2, sg_intro_e_05, SBP.GERMAN.GRENADIER_SQUAD, mkr_intro_e_spawn_05, nil, 1, 1)
	Util_CreateSquads(player2, sg_intro_e_06, SBP.GERMAN.PANZER_GRENADIER_SQUAD, mkr_intro_e_spawn_06, nil, 1, 1)
	Util_CreateSquads(player2, sg_intro_e_07, SBP.GERMAN.OSTRUPPEN_SQUAD, mkr_intro_e_spawn_07, nil, 1, 1)
	
	Cmd_MoveToAndDespawn(sg_intro_e_01, mkr_intro_e_dest_01)
	Cmd_MoveToAndDespawn(sg_intro_e_02, mkr_intro_e_dest_01)
	Cmd_MoveToAndDespawn(sg_intro_e_03, mkr_intro_e_dest_01)
	Cmd_MoveToAndDespawn(sg_intro_e_04, mkr_intro_e_dest_01)
	Cmd_MoveToAndDespawn(sg_intro_e_05, mkr_intro_e_dest_02)
	Cmd_MoveToAndDespawn(sg_intro_e_06, mkr_intro_e_dest_02)
	Cmd_MoveToAndDespawn(sg_intro_e_07, mkr_intro_e_dest_02)

end
----------------------------
-- BEAT 1
-- MOLTKE BRIDGE
----------------------------
-- || INIT FUNCTIONS ||
function MOLTKE_Init_Objective()

	OBJ_MOLTKE = {
		
		SetupUI = function() 
			hpid_moltke = Objective_AddUIElements(OBJ_MOLTKE, mkr_moltke_UI_01, true, 11046966, true)	
		end,
		
		OnStart = function()
--~ 			Game_SetMode(UI_Normal)
		end,
		
		OnComplete = function()
			
			Util_StartIntel(EVENTS.MOTI_START)
			EGroup_InstantCaptureStrategicPoint(eg_moltke_cp, player1)
			
			Rule_AddDelayedInterval(Mission_SitRep_Start, 3, 1)
			
			Moti_Init()
		end,
		
		OnFail = function()
			
		end,
		
		IsComplete = function()
			return false
		end,
		
		Intel_Start = nil,				-- Event will play when obj starts but before any UI appears
		Intel_Complete = nil,			-- Event will play when obj completes but before UI is cleared
		Intel_Fail = nil,				-- Event will play when obj fails but before UI is cleared
		Title = 11046966,				-- LOCDB [11046966] 'Clear the Moltke Bridge'
		Type = OT_Primary,				-- Objective Type (OT_Primary, OT_Secondary)
		Parent = OBJ_Parent_Mission,
	}
	
	Objective_Register(OBJ_MOLTKE)
	
end
--|| OBJECTIVE FUNCTIONS ||
function MOLTKE_Kickoff_Objective()

	if Event_IsAnyRunning() == false then
		Rule_RemoveMe()
		
		Objective_Start(OBJ_Parent_Mission, false)
		Objective_Start(OBJ_MOLTKE)
	end

end

function MOLTKE_Complete_Check()

	Objective_Complete(OBJ_MOLTKE)

end
--|| BEAT FUNCTIONS ||
function Moltke_Init()
	
	-- Spawn Player Units
	sg_moltke_p_is2 = SGroup_CreateIfNotFound("sg_moltke_p_is2")
	
	sg_moltke_p_con_01 = SGroup_CreateIfNotFound("sg_moltke_p_con_01")
	sg_moltke_p_con_02 = SGroup_CreateIfNotFound("sg_moltke_p_con_02")
	sg_moltke_p_con_03 = SGroup_CreateIfNotFound("sg_moltke_p_con_03")
	
	sg_moltke_p_shock_01 = SGroup_CreateIfNotFound("sg_moltke_p_shock_01")
	
	sg_moltke_p_eng_01 = SGroup_CreateIfNotFound("sg_moltke_p_eng_01")
	
--~ 	Util_CreateSquads(player1, sg_moltke_p_is2, SBP.SOVIET.IS_2, mkr_moltke_p_is2_spawn, mkr_moltke_p_is2_dest)
--~ 	Cmd_Upgrade(sg_moltke_p_is2, UPG.SOVIET.IS2_TOP_GUNNER, 1, true)
	
--~ 	Util_CreateSquads(player1, sg_moltke_p_con_01, SBP.SOVIET.CONSCRIPT_SQUAD, mkr_moltke_p_con01)
--~ 	Util_CreateSquads(player1, sg_moltke_p_shock_01, SBP.SOVIET.SHOCK_TROOPS, mkr_moltke_p_con02)
--~ 	Util_CreateSquads(player1, sg_moltke_p_con_02, SBP.SOVIET.CONSCRIPT_SQUAD, mkr_moltke_p_con03)
	
--~ 	Util_CreateSquads(player1, sg_moltke_p_shock_01, SBP.SOVIET.SHOCK_TROOPS, mkr_moltke_p_shock01)
--~ 	Util_CreateSquads(player1, sg_moltke_p_shock_02, SBP.SOVIET.SHOCK_TROOPS, mkr_moltke_p_shock02)
	
--~ 	Util_CreateSquads(player1, sg_moltke_p_eng_01, SBP.SOVIET.COMBAT_ENGINEER_SQUAD, mkr_moltke_p_engineer)
	
	-- Spawn the reinforcement units
	sg_moltke_e_bridgeDef_rein_01 = SGroup_CreateIfNotFound("sg_moltke_e_bridgeDef_rein_01")
	sg_moltke_e_bridgeDef_rein_01_pg_01 = SGroup_CreateIfNotFound("sg_moltke_e_bridgeDef_rein_01_pg_01")
	sg_moltke_e_bridgeDef_rein_01_pg_02 = SGroup_CreateIfNotFound("sg_moltke_e_bridgeDef_rein_01_pg_02")
	
	Util_CreateSquads(player2, sg_moltke_e_bridgeDef_rein_01_pg_01, SBP.GERMAN.PANZER_GRENADIER_SQUAD, mkr_moltke_e_bridgeDef_rein_01_s1)
	Util_CreateSquads(player2, sg_moltke_e_bridgeDef_rein_01, SBP.GERMAN.OSTRUPPEN_SQUAD, mkr_moltke_e_bridgeDef_rein_01_s2)
	Util_CreateSquads(player2, sg_moltke_e_bridgeDef_rein_01, SBP.GERMAN.OSTRUPPEN_SQUAD, mkr_moltke_e_bridgeDef_rein_01_s3, nil, 1, 4)
	
	if g_difficulty == GD_HARD then Cmd_Upgrade(sg_moltke_e_bridgeDef_rein_01_pg_01, UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM, 1, true) end

	sg_moltke_e_bridgeDef_rein_02 = SGroup_CreateIfNotFound("sg_moltke_e_bridgeDef_rein_02")
	
	if g_difficulty == GD_HARD then Util_CreateSquads(player2, sg_moltke_e_bridgeDef_rein_02, SBP.GERMAN.GRENADIER_SQUAD, mkr_moltke_e_bridgeDef_rein_02_s1) end
	Util_CreateSquads(player2, sg_moltke_e_bridgeDef_rein_02, SBP.GERMAN.GRENADIER_SQUAD, mkr_moltke_e_bridgeDef_rein_02_s2)
	Util_CreateSquads(player2, sg_moltke_e_bridgeDef_rein_02, SBP.GERMAN.OSTRUPPEN_SQUAD, mkr_moltke_e_bridgeDef_rein_02_s3)
	
	-- Set Rally points
	EGroup_SetRallyPoint(eg_p_hq, mkr_moltke_hq_rally)
	EGroup_SetRallyPoint(eg_p_barracks, mkr_moltke_barracks_rally)
	EGroup_SetRallyPoint(eg_p_weaponsupport, mkr_moltke_weaponSup_rally)
	EGroup_SetRallyPoint(eg_p_motorpool, mkr_moltke_motorpool_rally)
	EGroup_SetRallyPoint(eg_p_tankdepot, mkr_moltke_tankdepot_rally)
	
	-- Despawn the Blockers
	EGroup_DeSpawn(eg_moltke_det_blocker_ALL)
	
	-- Set the Bridge Invuln
	EGroup_SetInvulnerable(eg_moltke, true)
	EGroup_SetInvulnerable(LAYER_Moltke_L_rail_01, true)
	EGroup_SetInvulnerable(LAYER_Moltke_L_rail_02, true)
	EGroup_SetInvulnerable(LAYER_Moltke_R_rail_01, true)
	EGroup_SetInvulnerable(LAYER_Moltke_R_rail_02, true)
	
	-- Set the Bridge statues Invuln
	EGroup_SetInvulnerable(eg_moltke_invulnStatue_01, 0.8)
	EGroup_SetInvulnerable(eg_moltke_invulnStatue_02, 0.5)
	EGroup_SetInvulnerable(eg_moltke_invulnStatue_03, 0.7)
	EGroup_SetInvulnerable(eg_moltke_invulnStatue_04, 0.2)
	
	-- Set the bridge objects invuln
	EGroup_SetInvulnerable(eg_moltke_indestructible, true)
	EGroup_SetInvulnerable(eg_moltke_destructible, true)
	
	-- Init Encounters
	Moltke_Encs_Init()
	
	-- Setup Rules
	Mission_RoadBlocks_Init()
	
	-- Setup Events
	g_eventID_Moltke_Demo_Prox = Event_Proximity(Moltke_Demolition, nil, player1, mkr_moltke_e_demo_trig, nil, ANY, 4)
--~ 	g_eventID_Moltke_Demo_Dead = Event_GroupLeftAlive(Moltke_Demolition, nil, sg_molke_e_bridgeDef, 4)
--~ 	eventID_Roadblock_01 = Event_GroupIsDead(_Remove_Roadblock_Hintpoints, nil, eg_moltke_roadblock_01, 1)

end



--~ function _Remove_Roadblock_Hintpoints()

--~ 	if Event_Exists(eventID_Roadblock_01) then Event_Remove(eventID_Roadblock_01) end
--~ 	
--~ 	if hpid_roadblock_01 ~= nil then HintPoint_Remove(hpid_roadblock_01) end

--~ end

function Moltke_Demolition()
	
	if blown_moltke_bridge ~= true then
		
		blown_moltke_bridge = true
		
		if Event_Exists(g_eventID_Moltke_Demo_Prox) then Event_Remove(g_eventID_Moltke_Demo_Prox) end
		if Event_Exists(g_eventID_Moltke_Demo_Dead) then Event_Remove(g_eventID_Moltke_Demo_Dead) end
		
		Util_StartIntel(EVENTS.MOLTKE_DEMO_START)
		Sound_SetMusicCombatValue(10, 10)
		
		if hpid_moltke ~= nil then Objective_RemoveUIElements(OBJ_MOLTKE, hpid_moltke) end
		
		-- Retreat Bridge Defenders
		Cmd_StaggeredRetreat(encID_moltke_bridgeDef.sgroup, {mkr_moltke_e_bridgeDef_retreat}, 5)
		
		EGroup_SetInvulnerable(eg_moltke, false)
		
		_wallIDs_L_01 = {}
		_wallIDs_L_01[1] = Entity_GetGameID(EGroup_GetSpawnedEntityAt(LAYER_Moltke_L_rail_01, 1))
		_wallIDs_L_01[2] = Entity_GetGameID(EGroup_GetSpawnedEntityAt(LAYER_Moltke_L_rail_01, 2))
		_wallIDs_L_01[3] = Entity_GetGameID(EGroup_GetSpawnedEntityAt(LAYER_Moltke_L_rail_01, 3))
		_wallIDs_L_01[4] = Entity_GetGameID(EGroup_GetSpawnedEntityAt(LAYER_Moltke_L_rail_01, 4))
		
		_wallIDs_L_02 = {}
		_wallIDs_L_02[1] = Entity_GetGameID(EGroup_GetSpawnedEntityAt(LAYER_Moltke_L_rail_02, 1))
		_wallIDs_L_02[2] = Entity_GetGameID(EGroup_GetSpawnedEntityAt(LAYER_Moltke_L_rail_02, 2))
		_wallIDs_L_02[3] = Entity_GetGameID(EGroup_GetSpawnedEntityAt(LAYER_Moltke_L_rail_02, 3))
		_wallIDs_L_02[4] = Entity_GetGameID(EGroup_GetSpawnedEntityAt(LAYER_Moltke_L_rail_02, 4))
		
		_wallIDs_R_01 = {}
		_wallIDs_R_01[1] = Entity_GetGameID(EGroup_GetSpawnedEntityAt(LAYER_Moltke_R_rail_01, 1))
		_wallIDs_R_01[2] = Entity_GetGameID(EGroup_GetSpawnedEntityAt(LAYER_Moltke_R_rail_01, 2))
		_wallIDs_R_01[3] = Entity_GetGameID(EGroup_GetSpawnedEntityAt(LAYER_Moltke_R_rail_01, 3))
		_wallIDs_R_01[4] = Entity_GetGameID(EGroup_GetSpawnedEntityAt(LAYER_Moltke_R_rail_01, 4))
		
		_wallIDs_R_02 = {}
		_wallIDs_R_02[1] = Entity_GetGameID(EGroup_GetSpawnedEntityAt(LAYER_Moltke_R_rail_02, 1))
		_wallIDs_R_02[2] = Entity_GetGameID(EGroup_GetSpawnedEntityAt(LAYER_Moltke_R_rail_02, 2))
		_wallIDs_R_02[3] = Entity_GetGameID(EGroup_GetSpawnedEntityAt(LAYER_Moltke_R_rail_02, 3))
		_wallIDs_R_02[4] = Entity_GetGameID(EGroup_GetSpawnedEntityAt(LAYER_Moltke_R_rail_02, 4))
		
		Rule_AddOneShot(_Moltke_01_Demo, 1)
		Rule_AddOneShot(_Moltke_02_Demo, 2.5)
		Rule_AddOneShot(_Moltke_03_Demo, 4)
		Rule_AddOneShot(_Moltke_CleanUpTheDead, 14.5)
		Rule_AddOneShot(MOLTKE_Complete_Check, 16)
		
	end
	
end

function _Moltke_01_Demo()

	Cmd_Ability(player2, BP_GetAbilityBlueprint("moltke_det_pack"), mkr_moltke_e_L_demo_01, nil, true)
	Cmd_Ability(player2, BP_GetAbilityBlueprint("moltke_det_pack"), mkr_moltke_e_R_demo_01, nil, true)
	Rule_AddOneShot(_Moltke_01_Demo_delay, 0.5)
	
	Rule_AddOneShot(_Moltke_01_demo_blow, 10.5)

end

function _Moltke_01_Demo_delay() Cmd_Ability(player2, BP_GetAbilityBlueprint("moltke_det_pack"), mkr_moltke_e_M_demo_01, nil, true) end
function _Moltke_02_Demo()

	Cmd_Ability(player2, BP_GetAbilityBlueprint("moltke_det_pack"), mkr_moltke_e_L_demo_02, nil, true)
	Cmd_Ability(player2, BP_GetAbilityBlueprint("moltke_det_pack"), mkr_moltke_e_M_demo_02, nil, true)
	Cmd_Ability(player2, BP_GetAbilityBlueprint("moltke_det_pack"), mkr_moltke_e_R_demo_02, nil, true)
	
	Rule_AddOneShot(_Moltke_02_demo_blow, 10)

end

function _Moltke_03_Demo()

	Cmd_Ability(player2, BP_GetAbilityBlueprint("moltke_det_pack"), mkr_moltke_e_L_demo_03, nil, true)
	Cmd_Ability(player2, BP_GetAbilityBlueprint("moltke_det_pack"), mkr_moltke_e_M_demo_03, nil, true)
	Cmd_Ability(player2, BP_GetAbilityBlueprint("moltke_det_pack"), mkr_moltke_e_R_demo_03, nil, true)
	
	Rule_AddOneShot(_Moltke_03_demo_blow, 10)

end

function _Moltke_01_demo_blow()
	
	Entity_Kill(Entity_FromWorldID(_wallIDs_L_01[3]))
	Entity_Kill(Entity_FromWorldID(_wallIDs_L_01[4]))
	
	Entity_Kill(Entity_FromWorldID(_wallIDs_R_01[3]))
	
	EGroup_ReSpawn(eg_moltke_det_blocker_L_01)
	EGroup_ReSpawn(eg_moltke_det_blocker_R_01)
	
	EGroup_SetAvgHealth(eg_moltke, 0.66)

end

function _Moltke_02_demo_blow()
	
	Entity_Kill(Entity_FromWorldID(_wallIDs_L_01[1]))
	
	Entity_Kill(Entity_FromWorldID(_wallIDs_L_02[4]))
	
	Entity_Kill(Entity_FromWorldID(_wallIDs_R_02[4]))
	
	EGroup_ReSpawn(eg_moltke_det_blocker_L_02)
	EGroup_ReSpawn(eg_moltke_det_blocker_R_02)
	
	EGroup_SetAvgHealth(eg_moltke, 0.33)

end

function _Moltke_03_demo_blow()
	
	-- kill the music now the bridge is exploding
	Sound_SetMusicCombatValue(0, 0)
	Sound_StopMusic(1, 0)
	
	Entity_Kill(Entity_FromWorldID(_wallIDs_L_02[2]))
	
	EGroup_ReSpawn(eg_moltke_det_blocker_L_03)
	EGroup_ReSpawn(eg_moltke_det_blocker_R_03)
	
	
	EGroup_SetAvgHealth(eg_moltke, 0)
	EGroup_SetInvulnerable(eg_moltke, true)

end

function _Moltke_CleanUpTheDead()

	Marker_CleanUpTheDead(ALL, mkr_moltke_dead)

end
--|| BEAT ENCOUNTERS ||
function Moltke_Encs_Init()

	Moltke_Enc_SouthDef()
	Moltke_Enc_BridgeDef()

end

function Moltke_Enc_SouthDef()

	sg_molke_e_southDef = SGroup_CreateIfNotFound("sg_molke_e_southDef")

	-- AI
	local encData = {
		name = "Moltke_SouthDef",
		player = player2,
		spawn = mkr_moltke_e_southDef,
		sgroups = {sg_molke_e_southDef},
		units = {
			{
				name = "Moltke_SouthDef_01",
				sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
				spawn = mkr_moltke_e_southDef_s0,
			},
			{
				name = "Moltke_SouthDef_02",
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = mkr_moltke_e_southDef_s1,
				load = 4,
			},
			{
				name = "Moltke_SouthDef_02",
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = mkr_moltke_e_southDef_s2,
				upgrades = {UPG.GERMAN.GRENADIER_MG42_LMG},
				load = 3,
			},
			{
				name = "Moltke_SouthDef_03",
				sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
				spawn = mkr_moltke_e_southDef_s3,
				load = 5,
			},
			{
				name = "Moltke_SouthDef_04",
				sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
				spawn = mkr_moltke_e_southDef_s4,
				load = 4,
			},
		},
	}
	encID_moltke_southDef = Encounter:Create(encData)
	
	local goalData = {
		name = "Defend",
		target = mkr_moltke_e_southDef,
		
		leashRange = 14,
		range = 45,
		
		maxAttackers = 1,
		
		tacticTargetPreference = AITacticTargetPreference_Near,
		
		coordinatedSetup = true,
		coordinatedMoveRadius = 10,
		
		coordinatedSetupFacingPositions = {
			Util_GetOffsetPosition(mkr_moltke_e_southDef, OFFSET_FRONT, 100),
		},
		
		tacticControlsList = {
			{
				tacticType = TACTIC_Avoid,
				priority = 0,
			},
			{
				tacticType = TACTIC_Cover,
				priority = 300,
			},
			{
				tacticType = TACTIC_Ability,
				priority = 0,
			},
			{
				tacticType = TACTIC_Help,
				priority = 0,
			},
		}
	}
	encID_moltke_southDef:SetGoal(goalData)

end

function Moltke_Enc_BridgeDef()

	sg_molke_e_bridgeDef = SGroup_CreateIfNotFound("sg_molke_e_bridgeDef")
	sg_moltke_e_bridgeDef_pak40 = SGroup_CreateIfNotFound("sg_moltke_e_bridgeDef_pak40")

	-- AI
	local encData = {
		name = "Moltke_BridgeDef",
		player = player2,
		spawn = mkr_moltke_e_bridgeDef_01,
		sgroups = {sg_molke_e_bridgeDef},
		units = {
			{
				name = "Moltke_SouthDef_01",
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				upgrades = {UPG.GERMAN.GRENADIER_MG42_LMG},
				load = 3,
				spawn = mkr_moltke_e_bridgeDef_01_s0,
			},
			{
				name = "Moltke_SouthDef_01",
				sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
				load = 5,
				spawn = mkr_moltke_e_bridgeDef_01_s0,
				difficulty = {GD_EASY, GD_NORMAL},
			},
			{
				name = "Moltke_SouthDef_01",
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
				veterancyRank = 2,
				load = 4,
				upgrades = {UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM, UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM_SECOND},
				spawn = mkr_moltke_e_bridgeDef_01_s0,
				difficulty = {GD_HARD},
			},
			{
				name = "Moltke_SouthDef_02",
				sbp = SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD,
				veterancyRank = 2,
				sgroups = {sg_moltke_e_bridgeDef_pak40},
				spawn = mkr_moltke_e_bridgeDef_01_s1,
			},
			{
				name = "Moltke_SouthDef_02",
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				upgrades = {UPG.GERMAN.GRENADIER_MG42_LMG},
				load = 4,
				spawn = mkr_moltke_e_bridgeDef_01_s2,
			},
			{
				name = "Moltke_SouthDef_03",
				sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
				difficulty = {GD_EASY},
				spawn = mkr_moltke_e_bridgeDef_01_s3,
			},
			{
				name = "Moltke_SouthDef_03",
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				veterancyRank = 1,
				upgrades = {UPG.GERMAN.GRENADIER_MG42_LMG},
				difficulty = {GD_NORMAL},
				spawn = mkr_moltke_e_bridgeDef_01_s3,
			},
			{
				name = "Moltke_SouthDef_03",
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
				veterancyRank = 1,
				upgrades = {UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM, UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM_SECOND},
				difficulty = {GD_HARD},
				spawn = mkr_moltke_e_bridgeDef_01_s3,
			},
		},
	}
	encID_moltke_bridgeDef = Encounter:Create(encData)
	
	local goalData = {
		name = "Defend",
		target = mkr_moltke_e_bridgeDef_01,
		
		leashRange = 22,
		range = 12,
		
		garrisonIdle = true,
		onFailure = _Response_Team_Fail,
		
		maxAttackers = 2,
		
		abilityControlsList = {
			{
				abilityPBG = ABILITY.GERMAN.GRENADIER_PANZERFAUST,
				maxCasters = 1,
				waitTimeSecs = 20,
			},
			{ 
				abilityPBG = ABILITY.GERMAN.STUG_ELEFANT_PAK40_PAK43_BRUMMBAR_CRITICAL_SHOTS,
				waitTimeSecs = 15,
			}
		},
		
		tacticTargetPreference = AITacticTargetPreference_Near,
		
		coordinatedSetup = true,
		coordinatedMoveRadius = 10,
		
		coordinatedSetupFacingPositions = {
			Util_GetOffsetPosition(mkr_moltke_e_bridgeDef_01, OFFSET_FRONT, 100),
		},
		
		tacticControlsList = {
			{
				tacticType = TACTIC_Hold,
				priority = 200,
				maxUsers = 1,
			},
			{
				tacticType = TACTIC_Avoid,
				priority = 100,
			},
			{
				tacticType = TACTIC_Cover,
				priority = 100,
				maxUsers = 2,
			},
			{
				tacticType = TACTIC_Ability,
				priority = 900,
			},
			{
				tacticType = TACTIC_Help,
				priority = -1,
			},
			{
				tacticType = TACTIC_Retaliate,
				priority = 800,
				maxUsers = 2,
			},
		}
	}
	encID_moltke_bridgeDef:SetGoal(goalData)
	
	Event_GroupLeftAlive(_Moltke_Enc_BridgeDef_Fallback_01, nil, sg_molke_e_bridgeDef, 7)
	
	-- COPY TO INIT FUNC
	_tEncs = {encID_moltke_bridgeDef}
end



function _Moltke_Enc_BridgeDef_Fallback_01()
	
	if blown_moltke_bridge ~= true then
		Objective_RemoveUIElements(OBJ_MOLTKE, hpid_moltke)
		hpid_moltke = Objective_AddUIElements(OBJ_MOLTKE, mkr_moltke_UI_02, true, 11046966, true)
	end
	
	if SGroup_IsEmpty(sg_moltke_e_bridgeDef_pak40) == false then 
		Cmd_AbandonTeamWeapon(sg_moltke_e_bridgeDef_pak40, true) 
	end
	
	
	local goalData = {
		name = "Defend",
		target = mkr_moltke_e_bridgeDef_02,
		
		leashRange = 12,
		range = 12,
		
		maxAttackers = 1,
		
		abilityControlsList = {
			{
				abilityPBG = ABILITY.GERMAN.GRENADIER_PANZERFAUST,
				maxCasters = 2,
				waitTimeSecs = 20,
			}
		},
		
		tacticTargetPreference = AITacticTargetPreference_None,
		
		coordinatedSetup = true,
		
		coordinatedSetupFacingPositions = {
			Util_GetOffsetPosition(mkr_moltke_e_bridgeDef_02, OFFSET_FRONT, 100),
		},
		
		tacticControlsList = {
			{
				tacticType = TACTIC_Avoid,
				priority = 0,
			},
			{
				tacticType = TACTIC_Cover,
				priority = 0,
			},
			{
				tacticType = TACTIC_Ability,
				priority = 300,
			},
			{
				tacticType = TACTIC_Help,
				priority = 0,
			},
		}
	}
	
	encID_moltke_bridgeDef:ClearGoal()
	encID_moltke_bridgeDef:SetGoal(goalData)
	
	if encID_moltke_bridgeDef:IsAlive() then
		encID_moltke_bridgeDef:AddSgroup(sg_moltke_e_bridgeDef_rein_01)
		encID_moltke_bridgeDef:AddSgroup(sg_moltke_e_bridgeDef_rein_01_pg_01)
		encID_moltke_bridgeDef:AddSgroup(sg_moltke_e_bridgeDef_rein_01_pg_02)
		
		SGroup_AddGroup(sg_molke_e_bridgeDef, sg_moltke_e_bridgeDef_rein_01)
		SGroup_AddGroup(sg_molke_e_bridgeDef, sg_moltke_e_bridgeDef_rein_01_pg_01)
		SGroup_AddGroup(sg_molke_e_bridgeDef, sg_moltke_e_bridgeDef_rein_01_pg_02)
	end
	
	Event_GroupLeftAlive(_Moltke_Enc_BridgeDef_Fallback_02, nil, sg_molke_e_bridgeDef, 9)
	
	Rule_AddOneShot(_Moltke_Enc_BridgeDef_Fallback_01_PartB, 1)
	
end
function _Moltke_Enc_BridgeDef_Fallback_01_PartB()
	if SGroup_IsEmpty(sg_moltke_e_bridgeDef_pak40) == false then 
		Cmd_Retreat(sg_moltke_e_bridgeDef_pak40, mkr_moltke_e_bridgeDef_retreat, mkr_moltke_e_bridgeDef_retreat, true)
	end
end



function _Moltke_Enc_BridgeDef_Fallback_02()

	if blown_moltke_bridge ~= true then
		Objective_RemoveUIElements(OBJ_MOLTKE, hpid_moltke)
		hpid_moltke = Objective_AddUIElements(OBJ_MOLTKE, mkr_moltke_UI_03, true, 11046966, true)
	end
	
	if SGroup_IsEmpty(sg_moltke_e_bridgeDef_rein_01_pg_02) == false then Cmd_AbandonTeamWeapon(sg_moltke_e_bridgeDef_rein_01_pg_02, true) end
	
	local goalData = {
		name = "Defend",
		target = mkr_moltke_e_bridgeDef_03,
		
		leashRange = 12,
		range = 12,
		
		maxAttackers = 1,
		
		abilityControlsList = {
			{
				abilityPBG = ABILITY.GERMAN.GRENADIER_PANZERFAUST,
				maxCasters = 2,
				waitTimeSecs = 20,
			}
		},
		
		tacticTargetPreference = AITacticTargetPreference_None,
		
		coordinatedSetup = true,
		
		coordinatedSetupFacingPositions = {
			Util_GetOffsetPosition(mkr_moltke_e_bridgeDef_03, OFFSET_FRONT, 100),
		},
		
		tacticControlsList = {
			{
				tacticType = TACTIC_Avoid,
				priority = 0,
			},
			{
				tacticType = TACTIC_Cover,
				priority = 0,
			},
			{
				tacticType = TACTIC_Ability,
				priority = 300,
			},
			{
				tacticType = TACTIC_Help,
				priority = 0,
			},
		}
	}
	
	encID_moltke_bridgeDef:ClearGoal()
	encID_moltke_bridgeDef:SetGoal(goalData)
	
	if encID_moltke_bridgeDef:IsAlive() then
		encID_moltke_bridgeDef:AddSgroup(sg_moltke_e_bridgeDef_rein_02)
		
		SGroup_AddGroup(sg_molke_e_bridgeDef, sg_moltke_e_bridgeDef_rein_02)
	end
	
	Rule_AddOneShot(_Moltke_Enc_BridgeDef_InvulnMod_02, 5)
	
end

function _Moltke_Enc_BridgeDef_InvulnMod_02()
	
	if blown_moltke_bridge ~= true then
		g_eventID_Moltke_Demo_Dead = Event_GroupLeftAlive(Moltke_Demolition, nil, sg_molke_e_bridgeDef, 4)
	end

end

----------------------------
-- BEAT 2
-- MINISTRY OF THE INTERIOR (MOTI)
----------------------------
-- || INIT FUNCTIONS ||
function MOTI_Init_Objective()

	OBJ_MOTI = {
		
		SetupUI = function() 
			hpid_moti = Objective_AddUIElements(OBJ_MOTI, eg_moti_cp, true, 11046967, true, 2.8)
		end,
		
		OnStart = function()
			World_IncreaseInteractionStage()
			EGroup_EnableMinimapIndicator(eg_territorypoints_stage2, true)
			
			Event_NarrativeEventsNotRunning(EventHandler_StartIntel, {intel_callback = EVENTS.MOTI_STREET_WARNING}, 2)
			Rule_AddOneShot(_Moti_Artillery_Unavailable, 4)
		end,
		
		OnComplete = function()
			Objective_RemoveUIElements(OBJ_MOTI, hpid_moti)
			
			Player_AddResource(player1, RT_Munition, 120)
			Player_AddResource(player1, RT_Fuel, 85)
		end,
		
		OnFail = function()
			
		end,
		
		IsComplete = function()
			return false
		end,
		
		Intel_Start = nil,				-- Event will play when obj starts but before any UI appears
		Intel_Complete = nil,			-- Event will play when obj completes but before UI is cleared
		Intel_Fail = nil,				-- Event will play when obj fails but before UI is cleared
		Title = 11046967,				-- LOCDB [11046967] 'Capture the Ministry of the Interior Building'
		Type = OT_Primary,				-- Objective Type (OT_Primary, OT_Secondary)
		Parent = OBJ_Parent_Mission,
	}
	
	Objective_Register(OBJ_MOTI)

end
--|| OBJECTIVE FUNCTIONS ||
function MOTI_Kickoff_Objective()

	Sound_PlayMusic("streamed/music/missions/m14/m14_cue_bridge_blown", 4, 0)		-- start music for next section
	Objective_Start(OBJ_MOTI)

end

function MOTI_Complete()

	Objective_Complete(OBJ_Parent_Mission)
	Objective_Complete(OBJ_MOTI, false)

end

--|| BEAT FUNCTIONS ||
function Moti_Init()
	
--~ 	Cmd_Upgrade(sg_moti_stugs_01, BP_GetUpgradeBlueprint("instant_german_hulldown"), 1, true)
--~ 	Cmd_Upgrade(sg_moti_e_elephant, BP_GetUpgradeBlueprint("instant_german_hulldown"), 1, true)
--~ 	
--~ 	Modify_WeaponRange(sg_moti_e_elephant, "hardpoint_01", 0.85)
	
	-- Init Encounters
	Moti_Encs_Init()
	
	-- Init the Bonus Encounters
	Howitzers_Encs_Init()
	
	-- Init the Bonus Objective Check
	Howitzers_Init()
	
	-- Other functions

end

function Moti_Mark_Stugs()

	ThreatArrow_CreateGroup(sg_moti_e_stug_01, sg_moti_e_stug_02)
	
	if Event_Exists(_eventID_stug_01_firing) then Event_Remove(_eventID_stug_01_firing) end
	if Event_Exists(_eventID_stug_02_firing) then Event_Remove(_eventID_stug_02_firing) end

end

--|| BEAT ENCOUNTERS ||
function Moti_Encs_Init()
	
	-- Ambient
	
	Moti_Encs_NorthBridge_Def()
	Moti_Encs_leftAlley_Def()
	Moti_Encs_rightRuins_Def_01()
	Moti_Encs_rightRuins_Def_02()
	Moti_Encs_rightRoad_Def_01()
	Moti_Encs_Pak43_Def()
	Moti_Encs_southMOTI_Def()
	Moti_Encs_main_Def()
	Moti_Encs_Panther_Left()
	
	-- Frontload the Kroll Entrance
--~ 	Kroll_Encs_Entrance_Def()
	-- Scripted
	sg_moti_e_SCR_gren01 = SGroup_CreateIfNotFound("sg_moti_e_SCR_gren01")
	sg_moti_e_SCR_ost01 = SGroup_CreateIfNotFound("sg_moti_e_SCR_ost01")
	sg_moti_e_SCR_ost02 = SGroup_CreateIfNotFound("sg_moti_e_SCR_ost02")
	
	Util_CreateSquads(player2, sg_moti_e_SCR_gren01, SBP.GERMAN.GRENADIER_SQUAD, mkr_moti_e_SCR_gren01)
	Cmd_Upgrade(sg_moti_e_SCR_gren01, UPG.GERMAN.GRENADIER_MG42_LMG, 1, true)
	
	Util_CreateSquads(player2, sg_moti_e_SCR_ost01, SBP.GERMAN.OSTRUPPEN_SQUAD, mkr_moti_e_SCR_ost01)
	Util_CreateSquads(player2, sg_moti_e_SCR_ost02, SBP.GERMAN.OSTRUPPEN_SQUAD, mkr_moti_e_SCR_ost02)
	
	Moti_Encs_Stug()
	
	-- Load the NorthBridge CounterAttack
	sg_moti_e_northBridge_CA = SGroup_CreateIfNotFound("sg_moti_e_northBridge_CA")
	
	-- AI
	local encData = {
		name = "Moti_NorthBridge_def01",
		player = player2,
		spawn = mkr_moti_e_northBridge_def_01,
		sgroups = {sg_moti_e_northBridge_CA},
		units = {
			{
				name = "Moltke_SouthDef_01",
				sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
				load = 5,
				spawn = mkr_moti_e_northBridge_ca_s0,
			},
			{
				name = "Moltke_SouthDef_01",
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				load = 3,
				upgrades = {UPG.GERMAN.GRENADIER_MG42_LMG},
				spawn = mkr_moti_e_northBridge_ca_s1,
			},
			{
				name = "Moltke_SouthDef_01",
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
				load = 3,
				spawn = mkr_moti_e_northBridge_ca_s2,
				difficulty = {GD_EASY, GD_NORMAL},
			},
			{
				name = "Moltke_SouthDef_01",
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
				load = 3,
				upgrades = {UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM},
				spawn = mkr_moti_e_northBridge_ca_s2,
				difficulty = {GD_HARD},
			},
			-- s3 has the Tank
		},
	}
	encID_moti_northBridge_ca = Encounter:Create(encData)
	
	-- Spawn additional Units
	sg_moti_e_northBridge_CA_tank01 = SGroup_CreateIfNotFound("sg_moti_e_northBridge_CA_tank01")
	local tankBP = nil
	if g_difficulty == GD_EASY or g_difficulty == GD_NORMAL then 
		tankBP = SBP.GERMAN.PANZER_IV_SQUAD
	elseif g_difficulty == GD_HARD then
		tankBP = SBP.GERMAN.PANTHER_SQUAD
	end
	Util_CreateSquads(player2, sg_moti_e_northBridge_CA_tank01, tankBP, mkr_moti_e_northBridge_ca_s3)
	
	sg_moti_e_northBridge_CA_tank02 = SGroup_CreateIfNotFound("sg_moti_e_northBridge_CA_tank02")
	local tankBP = nil
	if g_difficulty == GD_EASY or g_difficulty == GD_NORMAL then 
		tankBP = SBP.GERMAN.SCOUTCAR_SDKFZ222
	elseif g_difficulty == GD_HARD then
		tankBP = SBP.GERMAN.OSTWIND_SQUAD
	end
	Util_CreateSquads(player2, sg_moti_e_northBridge_CA_tank02, tankBP, mkr_moti_e_northBridge_ca_s4)
	
	sg_moti_e_northBridge_CA_s5 = SGroup_CreateIfNotFound("sg_moti_e_northBridge_CA_s5")
	sg_moti_e_northBridge_CA_s6 = SGroup_CreateIfNotFound("sg_moti_e_northBridge_CA_s6")
	sg_moti_e_northBridge_CA_s7 = SGroup_CreateIfNotFound("sg_moti_e_northBridge_CA_s7")
	
	Util_CreateSquads(player2, sg_moti_e_northBridge_CA_s5, SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD, mkr_moti_e_northBridge_ca_s5)
	Util_CreateSquads(player2, sg_moti_e_northBridge_CA_s6, SBP.GERMAN.OSTRUPPEN_SQUAD, mkr_moti_e_northBridge_ca_s6, nil, 1, 4)
	Util_CreateSquads(player2, sg_moti_e_northBridge_CA_s7, SBP.GERMAN.PANZER_GRENADIER_SQUAD, mkr_moti_e_northBridge_ca_s7)
	Cmd_Upgrade(sg_moti_e_northBridge_CA_s7, UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM, 1, true)
	
	-- Pak 40 units
	sg_moti_e_SCR_pak40_01 = SGroup_CreateIfNotFound("sg_moti_e_SCR_pak40_01")
	sg_moti_e_SCR_pak40_02 = SGroup_CreateIfNotFound("sg_moti_e_SCR_pak40_02")
	
	Util_CreateSquads(player2, sg_moti_e_SCR_pak40_01, SBP.GERMAN.GRENADIER_SQUAD, mkr_moti_e_SCR_pak40_01, nil, 1, 2)
	Util_CreateSquads(player2, sg_moti_e_SCR_pak40_02, SBP.GERMAN.GRENADIER_SQUAD, mkr_moti_e_SCR_pak40_02, nil, 1, 2)
	
	Event_PlayerCanSeeElement(_moti_pak40_runTo, nil, player1, {eg_moti_rightRoad_at_01, eg_moti_rightRoad_at_02, sg_moti_e_SCR_pak40_01, sg_moti_e_SCR_pak40_02}, ANY, 5)

end

function _moti_pak40_runTo()

	Cmd_CaptureTeamWeapon(sg_moti_e_SCR_pak40_01, eg_moti_rightRoad_at_01)
	Cmd_CaptureTeamWeapon(sg_moti_e_SCR_pak40_02, eg_moti_rightRoad_at_02)
	
	Rule_AddInterval(_moti_pak40_01, 1)
	Rule_AddInterval(_moti_pak40_02, 1)

end

function _moti_pak40_01()
	
	if SGroup_IsEmpty(sg_moti_e_SCR_pak40_01) then Rule_RemoveMe() end
	
	if SGroup_HasTeamWeapon(sg_moti_e_SCR_pak40_01, ANY) then
		Rule_RemoveMe()
		TeamWeapon_AddGroup(sg_moti_e_SCR_pak40_01)
	end
	
end

function _moti_pak40_02()
	
	if SGroup_IsEmpty(sg_moti_e_SCR_pak40_02) then Rule_RemoveMe() end
	
	if SGroup_HasTeamWeapon(sg_moti_e_SCR_pak40_02, ANY) then
		Rule_RemoveMe()
		TeamWeapon_AddGroup(sg_moti_e_SCR_pak40_02)
	end
	
end

function Moti_Encs_NorthBridge_Def()
	
	sg_moti_e_northBridge = SGroup_CreateIfNotFound("sg_moti_e_northBridge")
	
	-- AI
	local encData = {
		name = "Moti_NorthBridge_def01",
		player = player2,
		spawn = mkr_moti_e_northBridge_def_01,
		sgroups = {sg_moti_e_northBridge},
		units = {
			{
				name = "Moltke_SouthDef_01",
				sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
				load = 5,
				spawn = mkr_moti_e_northBridge_def_01_s0,
				difficulty = {GD_EASY, GD_NORMAL},
			},
			{
				name = "Moltke_SouthDef_01",
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				load = 3,
				spawn = mkr_moti_e_northBridge_def_01_s0,
				difficulty = {GD_HARD},
			},
			{
				name = "Moltke_SouthDef_01",
				sbp = SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD,
				spawn = mkr_moti_e_northBridge_def_01_s1,
			},
			{
				name = "Moltke_SouthDef_01",
				sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
				load = 5,
				spawn = mkr_moti_e_northBridge_def_01_s2,
				difficulty = {GD_EASY, GD_NORMAL},
			},
			{
				name = "Moltke_SouthDef_01",
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				load = 4,
				spawn = mkr_moti_e_northBridge_def_01_s2,
				difficulty = {GD_HARD},
			},
			{
				name = "Moltke_SouthDef_01",
				sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
				load = 5,
				spawn = mkr_moti_e_northBridge_def_01_s3,
				difficulty = {GD_EASY},
			},
			{
				name = "Moltke_SouthDef_01",
				sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
				load = 5,
				spawn = mkr_moti_e_northBridge_def_01_s3,
				slotItems = {SLOT_ITEM.PANZERSHRECK},
				difficulty = {GD_NORMAL, GD_HARD},
			},
			{
				name = "Moltke_SouthDef_01",
				sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
				load = 3,
				spawn = mkr_moti_e_northBridge_def_01_s4,
			},
		},
	}
	encID_moti_northBridge_def01 = Encounter:Create(encData)
	
	local goalData = {
		name = "Defend",
		target = mkr_moti_e_northBridge_def_01,
		
		leashRange = 20,
		range = 30,
		
		abilityControlsList = {
			{
				abilityPBG = ABILITY.GERMAN.PANZER_GRENADIER_BUNDLED_GRENADE,
				maxCasters = 1,
				maxRange = 10,
				waitTimeSecs = 20,
			},
			{
				abilityPBG = ABILITY.GERMAN.GRENADIER_PANZERFAUST,
				maxCasters = 1,
				maxRange = 10,
				waitTimeSecs = 40,
			},
		},
		
		maxAttackers = 1,
		
		tacticTargetPreference = AITacticTargetPreference_Near,
		
		coordinatedSetup = true,
		
		coordinatedSetupFacingPositions = {
			Util_GetOffsetPosition(mkr_moti_e_northBridge_def_01, OFFSET_FRONT, 100),
		},
		
		fallbackParams = {
			thresholds = {0.1},
			thresholdType = Threshold_PercentageEntitiesRemaining,
			markers = {mkr_moti_retreat},
			
			retreat = true,
			retreatDespawn = true,
		},
		
		tacticControlsList = {
			{
				tacticType = TACTIC_Avoid,
				priority = 500,
				maxUsers = 4,
			},
			{
				tacticType = TACTIC_Cover,
				priority = 100,
			},
			{
				tacticType = TACTIC_Ability,
				priority = 250,
			},
			{
				tacticType = TACTIC_Help,
				priority = -1,
			},
			{
				tacticType = TACTIC_Pickup,
				priority = 300,
			},
		}
	}
	encID_moti_northBridge_def01:SetGoal(goalData)
	
	Rule_AddInterval(_moti_northBridge_def_retreat, 1)

end

function _moti_northBridge_def_retreat(encounter, phase)

	if SGroup_IsEmpty(encID_moti_northBridge_def01.sgroup) or SGroup_IsRetreating(encID_moti_northBridge_def01.sgroup, ALL) then
		Rule_RemoveMe()
		
		Rule_AddOneShot(_moti_northBridge_CA_smoke_01, 5)
	end

end

function _moti_northBridge_CA_smoke_01()

	Cmd_Ability(player2, BP_GetAbilityBlueprint("m14_off_map_smoke_barrage"), Util_GetOffsetPosition(mkr_moti_e_northBridge_CA_smoke03, OFFSET_RIGHT, 4), nil, true)
	Cmd_Ability(player2, BP_GetAbilityBlueprint("m14_off_map_smoke_barrage"), Util_GetOffsetPosition(mkr_moti_e_northBridge_CA_smoke03, OFFSET_LEFT, 4), nil, true)
	
	Rule_AddOneShot(Moti_Encs_northBridge_CA_01, 3)
	Rule_AddOneShot(_moti_northBridge_CA_Warning, 4)

end

function _moti_northBridge_CA_smoke_02()

	Cmd_Ability(player2, BP_GetAbilityBlueprint("m14_off_map_smoke_barrage"), mkr_moti_e_northBridge_CA_smoke01, nil, true)
	Cmd_Ability(player2, BP_GetAbilityBlueprint("m14_off_map_smoke_barrage"), mkr_moti_e_northBridge_CA_smoke02, nil, true)

end

function _moti_northBridge_CA_Warning() Util_StartIntel(EVENTS.MOTI_NORTHBRIDGE_COUNTERATTACK) end
function Moti_Encs_northBridge_CA_01()
	
	local goalData = {
		name = "Attack",
		target = mkr_moti_e_northBridge_ca_01,
		
		leashRange = 20,
		range = 15,
		
		abilityControlsList = {
			{
				abilityPBG = ABILITY.GERMAN.PANZER_GRENADIER_BUNDLED_GRENADE,
				maxCasters = 1,
				maxRange = 10,
				waitTimeSecs = 20,
			},
			{
				abilityPBG = ABILITY.GERMAN.GRENADIER_PANZERFAUST,
				maxCasters = 1,
				maxRange = 10,
				waitTimeSecs = 40,
			},
		},
		
		maxAttackers = 1,
		
		tacticTargetPreference = AITacticTargetPreference_Near,
		
		tacticControlsList = {
			{
				tacticType = TACTIC_Avoid,
				priority = 200,
				maxUsers = 1,
			},
			{
				tacticType = TACTIC_Cover,
				priority = 500,
			},
			{
				tacticType = TACTIC_Ability,
				priority = 250,
			},
			{
				tacticType = TACTIC_Help,
				priority = -1,
			},
			{
				tacticType = TACTIC_CaptureTeamWeapon,
				priority = 300,
			},
		}
	}
	
	encID_moti_northBridge_ca:SetGoal(goalData)
	
	Rule_AddOneShot(_moti_northBridge_CA_smoke_02, 21)
	Rule_AddOneShot(Moti_encs_northBridge_CA_02, 25)
	
end

function Moti_encs_northBridge_CA_02()

	if encID_moti_northBridge_ca:IsAlive() then
		encID_moti_northBridge_ca:AddSgroup(sg_moti_e_northBridge_CA_s5)
		encID_moti_northBridge_ca:AddSgroup(sg_moti_e_northBridge_CA_s6)
		encID_moti_northBridge_ca:AddSgroup(sg_moti_e_northBridge_CA_s7)
		encID_moti_northBridge_ca:AddSgroup(sg_moti_e_northBridge_CA_tank02)
	else
		encID_moti_northBridge_ca_ALT_A = Encounter:ConvertSgroup(sg_moti_e_northBridge_CA_s5)
		encID_moti_northBridge_ca_ALT_A:AddSgroup(sg_moti_e_northBridge_CA_s6)
		encID_moti_northBridge_ca_ALT_A:AddSgroup(sg_moti_e_northBridge_CA_s7)
		encID_moti_northBridge_ca_ALT_A:AddSgroup(sg_moti_e_northBridge_CA_tank02)
		
		local goalData = {
			name = "Attack",
			target = mkr_moti_e_northBridge_ca_01,
			
			leashRange = 30,
			range = 15,
			
			abilityControlsList = {
				{
					abilityPBG = ABILITY.GERMAN.PANZER_GRENADIER_BUNDLED_GRENADE,
					maxCasters = 1,
					maxRange = 10,
					waitTimeSecs = 20,
				},
				{
					abilityPBG = ABILITY.GERMAN.GRENADIER_PANZERFAUST,
					maxCasters = 1,
					maxRange = 10,
					waitTimeSecs = 40,
				},
			},
			
			maxAttackers = 1,
			
			tacticTargetPreference = AITacticTargetPreference_Near,
			
			tacticControlsList = {
				{
					tacticType = TACTIC_Avoid,
					priority = 500,
					maxUsers = 4,
				},
				{
					tacticType = TACTIC_Cover,
					priority = 100,
				},
				{
					tacticType = TACTIC_Ability,
					priority = 250,
				},
				{
					tacticType = TACTIC_Help,
					priority = -1,
				},
				{
					tacticType = TACTIC_Pickup,
					priority = 300,
				},
			}
		}
		
		encID_moti_northBridge_ca_ALT_A:SetGoal(goalData)
	end
	
	Rule_AddOneShot(Moti_encs_northBridge_CA_03, 20)

end

function Moti_encs_northBridge_CA_03()

	if encID_moti_northBridge_ca:IsAlive() then
		encID_moti_northBridge_ca:AddSgroup(sg_moti_e_northBridge_CA_tank01)
	elseif encID_moti_northBridge_ca_ALT_A and encID_moti_northBridge_ca_ALT_A:IsAlive() then
		encID_moti_northBridge_ca_ALT_A:AddSgroup(sg_moti_e_northBridge_CA_tank01)
	else	
		encID_moti_northBridge_ca_ALT_B = Encounter:ConvertSgroup(sg_moti_e_northBridge_CA_tank01)
		
		local goalData = {
			name = "Attack",
			target = mkr_moti_e_northBridge_ca_01,
			
			leashRange = 30,
			range = 15,
			
			abilityControlsList = {
				{
					abilityPBG = ABILITY.GERMAN.PANZER_GRENADIER_BUNDLED_GRENADE,
					maxCasters = 1,
					maxRange = 10,
					waitTimeSecs = 20,
				},
				{
					abilityPBG = ABILITY.GERMAN.GRENADIER_PANZERFAUST,
					maxCasters = 1,
					maxRange = 10,
					waitTimeSecs = 40,
				},
			},
			
			maxAttackers = 1,
			
			tacticTargetPreference = AITacticTargetPreference_Near,
			
			tacticControlsList = {
				{
					tacticType = TACTIC_Avoid,
					priority = 500,
					maxUsers = 4,
				},
				{
					tacticType = TACTIC_Cover,
					priority = 100,
				},
				{
					tacticType = TACTIC_Ability,
					priority = 250,
				},
				{
					tacticType = TACTIC_Help,
					priority = -1,
				},
				{
					tacticType = TACTIC_Pickup,
					priority = 300,
				},
			}
		}
		
		encID_moti_northBridge_ca_ALT_B:SetGoal(goalData)
	end

end

function Moti_Encs_leftAlley_Def()
	
	sg_moti_e_leftAlley = SGroup_CreateIfNotFound("sg_moti_e_leftAlley")

	-- AI
	local encData = {
		name = "Moti_LeftAlley_def01",
		player = player2,
		spawn = mkr_moti_e_leftAlley_def_01,
		sgroups = {sg_moti_e_leftAlley},
		units = {
			{
				name = "Moltke_SouthDef_03",
				sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
				load = 4,
				spawn = mkr_moti_e_leftAlley_def_01_s1,
			},
			{
				name = "Moltke_SouthDef_04",
				sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
				load = 5,
				spawn = mkr_moti_e_leftAlley_def_01_s2,
			},
			{
				name = "Moltke_SouthDef_03",
				sbp = SBP.GERMAN.PIONEER_SQUAD,
				upgrades = {UPG.GERMAN.PIONEER_FLAMETHROWER},
				spawn = mkr_moti_e_leftAlley_def_01_s4,
			},
		},
	}
	encID_moti_leftAlley_def = Encounter:Create(encData)
	
	local goalData = {
		name = "Defend",
		target = mkr_moti_e_leftAlley_def_01,
		
		leashRange = 15,
		range = 15,
		
		abilityControlsList = {
			{
				abilityPBG = ABILITY.GERMAN.PANZER_GRENADIER_BUNDLED_GRENADE,
				maxCasters = 1,
				maxRange = 10,
				waitTimeSecs = 20,
			},
			{
				abilityPBG = ABILITY.GERMAN.GRENADIER_PANZERFAUST,
				maxCasters = 1,
				maxRange = 10,
				waitTimeSecs = 60,
			}
		},
		
		tacticTargetPreference = AITacticTargetPreference_Near,
		
		coordinatedSetup = true,
		coordinatedMoveRadius = 10,
		
		coordinatedSetupFacingPositions = {
			Util_GetOffsetPosition(mkr_moti_e_leftAlley_def_01, OFFSET_FRONT, 100),
		},
		
		tacticControlsList = {
			{
				tacticType = TACTIC_Avoid,
				priority = 100,
				maxUsers = 2,
			},
			{
				tacticType = TACTIC_Cover,
				priority = 0,
			},
			{
				tacticType = TACTIC_Ability,
				priority = 60,
			},
			{
				tacticType = TACTIC_Help,
				priority = -1,
			},
		}
	}
	encID_moti_leftAlley_def:SetGoal(goalData)

	Rule_AddInterval(Moti_Encs_leftAlley_Retaliate, 4)
	
end
function Moti_Encs_leftAlley_Retaliate()
	
	if Player_OwnsEGroup(player2, eg_point_leftAlley, ANY) == false or encID_moti_leftAlley_def:IsAlive() == false then
		
		Rule_RemoveMe()
		
		if Player_CanSeePosition(player1, Util_GetPosition(mkr_moti_e_leftAlley_def_retaliate_01)) == false then
			Util_CreateSquads(player2, sg_blah, SBP.GERMAN.OSTRUPPEN_SQUAD, mkr_moti_e_leftAlley_def_retaliate_01, mkr_moti_e_leftAlley_def_retaliate_01dest, 2)
			Util_CreateSquads(player2, sg_blah, SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD, mkr_moti_e_leftAlley_def_retaliate_01, mkr_moti_e_leftAlley_def_retaliate_01dest, 1, nil, true)
		end
		if Player_CanSeePosition(player1, Util_GetPosition(mkr_moti_e_leftAlley_def_retaliate_02)) == false then
			Util_CreateSquads(player2, sg_blah, SBP.GERMAN.PANZER_GRENADIER_SQUAD, mkr_moti_e_leftAlley_def_retaliate_02, mkr_moti_e_leftAlley_def_retaliate_02dest, 2)
		end
		
	end
	
end


function Moti_Encs_rightRuins_Def_01()
	
--~ 	sg_moti_e_rightRuins_SCRIPTED_01 = SGroup_CreateIfNotFound("sg_moti_e_rightRuins_SCRIPTED_01")
--~ 	
--~ 	Util_CreateSquads(player2, sg_moti_e_rightRuins_SCRIPTED_01, SBP.GERMAN.GRENADIER_SQUAD, eg_moti_e_rightRuins_bld01, nil, 1, 3)
--~ 	Cmd_Upgrade(sg_moti_e_rightRuins_SCRIPTED_01, UPG.GERMAN.GRENADIER_MG42_LMG, 1, true)
	
	sg_moti_e_rightRuins_01 = SGroup_CreateIfNotFound("sg_moti_e_rightRuins_01")

	-- AI
	local encData = {
		name = "Moti_RightRuins_def01",
		player = player2,
		spawn = mkr_moti_e_rightRuins_def_01,
		sgroups = {sg_moti_e_rightRuins_01},
		units = {
			{
				name = "Moltke_SouthDef_04",
				sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
				spawn = mkr_moti_e_rightRuins_def_02_s0,
				load = 4,
				difficulty = {GD_EASY, GD_NORMAL},
			},
			{
				name = "Moltke_SouthDef_04",
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
				spawn = mkr_moti_e_rightRuins_def_02_s0,
				load = 4,
				difficulty = {GD_HARD},
			},
			{
				name = "Moltke_SouthDef_03",
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = mkr_moti_e_rightRuins_def_02_s1,
				upgrades = {UPG.GERMAN.GRENADIER_MG42_LMG},
				load = 5,
			},
			{
				name = "Moltke_SouthDef_04",
				sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
				spawn = mkr_moti_e_rightRuins_def_02_s2,
				load = 4,
			},
		},
	}
	encID_moti_rightRuins_01_def = Encounter:Create(encData)
	
	local goalData = {
		name = "Defend",
		target = mkr_moti_e_rightRuins_def_01,
		
		leashRange = 20,
		range = 10,
		
		garrisonIdle = true,
		
		abilityControlsList = {
			{
				abilityPBG = ABILITY.GERMAN.PANZER_GRENADIER_BUNDLED_GRENADE,
				maxCasters = 1,
				maxRange = 10,
				waitTimeSecs = 20,
			}
		},
		
		maxAttackers = 2,
		
		tacticTargetPreference = AITacticTargetPreference_Near,
		
		coordinatedSetup = true,
		coordinatedMoveRadius = 10,
		
		coordinatedSetupFacingPositions = {
			Util_GetOffsetPosition(mkr_moti_e_rightRuins_def_01, OFFSET_FRONT, 100),
		},
		
		tacticControlsList = {
			{
				tacticType = TACTIC_Avoid,
				priority = 100,
				maxUsers = 1,
			},
			{
				tacticType = TACTIC_Cover,
				priority = 0,
			},
			{
				tacticType = TACTIC_Ability,
				priority = 200,
			},
			{
				tacticType = TACTIC_Help,
				priority = -1,
			},
			{
				tacticType = TACTIC_Hold,
				priority = 400,
				maxUsers = 1,
			},
		}
	}
	encID_moti_rightRuins_01_def:SetGoal(goalData)

end

function Moti_Encs_rightRuins_Def_02()
	
	if g_difficulty == GD_NORMAL or g_difficulty == GD_HARD then
		sg_moti_e_rightRuins_02_hmg = SGroup_CreateIfNotFound("sg_moti_e_rightRuins_02_hmg")
		
		Util_CreateSquads(player2, sg_moti_e_rightRuins_02_hmg, SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD, Util_GetOffsetPosition(mkr_moti_e_rightRuins_def_02_HMG, OFFSET_BACK, 5))
		Cmd_Move(sg_moti_e_rightRuins_02_hmg, mkr_moti_e_rightRuins_def_02_HMG, false, nil, Util_GetOffsetPosition(mkr_moti_e_rightRuins_def_02_HMG, OFFSET_FRONT, 4))
		
		TeamWeapon_AddGroup(sg_moti_e_rightRuins_02_hmg)
	end
	
	sg_moti_e_rightRuins_02 = SGroup_CreateIfNotFound("sg_moti_e_rightRuins_02")
	
	-- AI
	local encData = {
		name = "Moti_RightRuins_def02",
		player = player2,
		spawn = mkr_moti_e_rightRuins_def_02,
		sgroups = {sg_moti_e_rightRuins_02},
		units = {
			{
				name = "Moltke_SouthDef_01",
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
				spawn = mkr_moti_e_rightRuins_def_02_s0,
				load = 3,
			},
			{
				name = "Moltke_SouthDef_03",
				sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
				spawn = mkr_moti_e_rightRuins_def_02_s1,
				load = 4,
			},
			{
				name = "Moltke_SouthDef_03",
				sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
				spawn = mkr_moti_e_rightRuins_def_02_s2,
				load = 5,
			},
		},
	}
	encID_moti_rightRuins_02_def = Encounter:Create(encData)
	
	local goalData = {
		name = "Defend",
		target = mkr_moti_e_rightRuins_def_02,
		
		leashRange = 15,
		range = 15,
	}
	encID_moti_rightRuins_02_def:SetGoal(goalData)

end


function Moti_Encs_rightRoad_Def_01()
	
	sg_moti_e_rightRoad_01 = SGroup_CreateIfNotFound("sg_moti_e_rightRoad_01")

	-- AI
	local encData = {
		name = "Moti_RightRoad_def01",
		player = player2,
		spawn = mkr_moti_e_rightRoad_def_01,
		sgroups = {sg_moti_e_rightRoad_01},
		units = {
			{
				name = "Moltke_SouthDef_01",
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = mkr_moti_e_rightRoad_def_01_s0,
				upgrades = {UPG.GERMAN.GRENADIER_MG42_LMG},
				load = 4,
			},
			{
				name = "Moltke_SouthDef_03",
				sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
				spawn = mkr_moti_e_rightRoad_def_01_s1,
				difficulty = {GD_EASY},
			},
			{
				name = "Moltke_SouthDef_03",
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = mkr_moti_e_rightRoad_def_01_s1,
				difficulty = {GD_NORMAL, GD_HARD}
			},
			{
				name = "Moltke_SouthDef_01",
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
				spawn = mkr_moti_e_rightRoad_def_01_s2,
				upgrades = {UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM, UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM_SECOND},
			},
		},
	}
	encID_moti_rightRoad_def_01 = Encounter:Create(encData)
	
	Event_Proximity(_moti_encs_rightRoad_Ambush, nil, player1, mkr_moti_e_rightRoad_def_01, nil, ANY)
	
end

function _moti_encs_rightRoad_Ambush()

	local goalData = {
		name = "Attack",
		target = mkr_moti_e_rightRoad_def_01,
		
		leashRange = 11,
		range = 13,
		
		abilityControlsList = {
			{
				abilityPBG = ABILITY.GERMAN.PANZER_GRENADIER_BUNDLED_GRENADE,
				maxCasters = 1,
				maxRange = 10,
				waitTimeSecs = 40,
			},
			{
				abilityPBG = ABILITY.GERMAN.GRENADIER_PANZERFAUST,
				maxCasters = 3,
				maxRange = 20,
			}
		},
		
		maxAttackers = 2,
		
		tacticTargetPreference = AITacticTargetPreference_Near,
		
		tacticControlsList = {
			{
				tacticType = TACTIC_Avoid,
				priority = 500,
				maxUsers = 4,
			},
			{
				tacticType = TACTIC_Cover,
				priority = 100,
				waitTimeSecs = 60,
			},
			{
				tacticType = TACTIC_Ability,
				priority = 800,
			},
			{
				tacticType = TACTIC_Help,
				priority = -1,
			},
		}
	}
	encID_moti_rightRoad_def_01:SetGoal(goalData)
	
	Util_StartIntel(EVENTS.MOTI_MAINSTREET_DIFFICULT)

end

function Moti_Encs_Pak43_Def()
	
	sg_moti_e_pak43_def = SGroup_CreateIfNotFound("sg_moti_e_pak43_def")
	sg_moti_e_pak43_pak43 = SGroup_CreateIfNotFound("sg_moti_e_pak43_pak43")

	-- AI
	local encData = {
		name = "Moti_Elephant_Def",
		player = player2,
		spawn = mkr_moti_e_pak43_def_pak43,
		sgroups = {sg_moti_e_pak43_def},
		units = {
			{
				name = "Moltke_SouthDef_01",
				sbp = SBP.GERMAN.PAK43_88MM_AT_GUN_SQUAD,
				sgroups = {sg_moti_e_pak43_pak43},
				spawn = mkr_moti_e_pak43_def_pak43,
			},
			{
				name = "Moltke_SouthDef_01",
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				load = 4,
				spawn = mkr_moti_e_pak43_def_s0,
				upgrades = {UPG.GERMAN.GRENADIER_MG42_LMG},
			},
			{
				name = "Moltke_SouthDef_01",
				sbp = SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD,
				spawn = mkr_moti_e_pak43_def_s1,
				difficulty = {GD_HARD}
			},
			{
				name = "Moltke_SouthDef_03",
				sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
				load = 5,
				spawn = mkr_moti_e_pak43_def_s2,
				difficulty = {GD_EASY, GD_NORMAL},
			},
			{
				name = "Moltke_SouthDef_03",
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = mkr_moti_e_pak43_def_s2,
				difficulty = {GD_HARD},
			},
			{
				name = "Moltke_SouthDef_04",
				sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
				load = 5,
				spawn = mkr_moti_e_pak43_def_s3,
				difficulty = {GD_EASY, GD_NORMAL},
			},
			{
				name = "Moltke_SouthDef_04",
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
				spawn = mkr_moti_e_pak43_def_s4,
				upgrades = {UPG.GERMAN.GRENADIER_MG42_LMG},
			},
			{
				name = "Moltke_SouthDef_04",
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = mkr_moti_e_pak43_def_s5,
				difficulty = {GD_EASY, GD_NORMAL},
			},
			{
				name = "Moltke_SouthDef_04",
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
				spawn = mkr_moti_e_pak43_def_s5,
				upgrades = {UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM},
				difficulty = {GD_HARD},
			},
			{
				name = "Moltke_SouthDef_04",
				sbp = SBP.GERMAN.SCOUTCAR_SDKFZ222,
				spawn = mkr_moti_e_pak43_def_s6,
				difficulty = {GD_NORMAL},
			},
			{
				name = "Moltke_SouthDef_04",
				sbp = SBP.GERMAN.OSTWIND_SQUAD,
				spawn = mkr_moti_e_pak43_def_s6,
				difficulty = {GD_HARD},
			},
		},
	}
	encID_moti_pak43_def = Encounter:Create(encData)
	
	local goalData = {
		name = "Defend",
		target = mkr_moti_e_pak43_def_pak43,
		
		leashRange = 20,
		range = 30,
		
		abilityControlsList = {
			{
				abilityPBG = ABILITY.GERMAN.PANZER_GRENADIER_BUNDLED_GRENADE,
				maxCasters = 1,
				maxRange = 10,
				waitTimeSecs = 40,
			}
		},
		
		maxAttackers = 2,
		
		tacticTargetPreference = AITacticTargetPreference_Near,
		
		tacticControlsList = {
			{
				tacticType = TACTIC_Avoid,
				priority = 500,
				maxUsers = 4,
			},
			{
				tacticType = TACTIC_Cover,
				priority = 0,
			},
			{
				tacticType = TACTIC_Ability,
				priority = 80,
			},
			{
				tacticType = TACTIC_Help,
				priority = -1,
			},
		}
	}
	encID_moti_pak43_def:SetGoal(goalData)
	
	Modify_WeaponRange(sg_moti_e_pak43_pak43, "hardpoint_01", 1.4)
	Event_PlayerCanSeeElement(_Seen_Pak43, {sg_moti_e_pak43_pak43}, player1, sg_moti_e_pak43_pak43, nil, 2)
	
	Rule_AddDelayedInterval(Kroll_Encs_Entrance_Def, 3, 1)

end

function Moti_Encs_southMOTI_Def()
	
	sg_moti_e_southMOTI_def = SGroup_CreateIfNotFound("sg_moti_e_southMOTI_def")
	
	-- AI
	local encData = {
		name = "Moti_Elephant_Def",
		player = player2,
		spawn = mkr_moti_e_southMOTI_def,
		sgroups = {sg_moti_e_southMOTI_def},
		units = {
			{
				name = "Moltke_SouthDef_01",
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = mkr_moti_e_southMOTI_def_s0,
				load = 3,
				upgrades = {UPG.GERMAN.GRENADIER_MG42_LMG},
			},
			{
				name = "Moltke_SouthDef_03",
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
				spawn = mkr_moti_e_southMOTI_def_s1,
			},
			{
				name = "Moltke_SouthDef_03",
				sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
				spawn = mkr_moti_e_southMOTI_def_s2,
				load = 4,
				difficulty = {GD_NORMAL, GD_HARD},
			},
			{
				name = "Moltke_SouthDef_04",
				sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
				spawn = mkr_moti_e_southMOTI_def_s3,
				load = 3,
			},
			{
				name = "Moltke_SouthDef_04",
				sbp = SBP.GERMAN.SDKFZ_251_HALFTRACK_SQUAD,
				spawn = mkr_moti_e_southMOTI_def_s4,
			},
		},
	}
	encID_moti_southMOTI_def = Encounter:Create(encData)
	
	local goalData = {
		name = "Defend",
		target = mkr_moti_e_southMOTI_def,
		
		leashRange = 12,
		range = 15,
		
		maxAttackers = 2,
		
		tacticTargetPreference = AITacticTargetPreference_Near,
		
		abilityControlsList = {
			{
				abilityPBG = ABILITY.GERMAN.PANZER_GRENADIER_BUNDLED_GRENADE,
				maxCasters = 1,
				maxRange = 10,
				waitTimeSecs = 20,
			},
			{
				abilityPBG = ABILITY.GERMAN.GRENADIER_PANZERFAUST,
				maxCasters = 1,
				maxRange = 10,
				waitTimeSecs = 30,
			},
		},
		
		coordinatedSetup = true,
		
		coordinatedSetupFacingPositions = {
			Util_GetOffsetPosition(mkr_moti_e_southMOTI_def, OFFSET_FRONT, 100),
		},
		
		tacticControlsList = {
			{
				tacticType = TACTIC_Avoid,
				priority = 500,
				maxUsers = 2,
			},
			{
				tacticType = TACTIC_Cover,
				priority = -1,
			},
			{
				tacticType = TACTIC_Ability,
				priority = 400,
			},
			{
				tacticType = TACTIC_Help,
				priority = -1,
			},
		}
	}
	encID_moti_southMOTI_def:SetGoal(goalData)

end

function Moti_Encs_main_Def()
	
	sg_moti_e_main_def = SGroup_CreateIfNotFound("sg_moti_e_main_def")
	
	-- AI
	local encData = {
		name = "Moti_Elephant_Def",
		player = player2,
		spawn = mkr_moti_e_main_def,
		sgroups = {sg_moti_e_main_def},
		units = {
			{
				name = "Moltke_SouthDef_01",
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
				spawn = mkr_moti_e_main_def_s0,
				load = 4,
			},
			{
				name = "Moltke_SouthDef_01",
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
				spawn = mkr_moti_e_main_def_s1,
				load = 3,
				difficulty = {GD_NORMAL, GD_HARD},
			},
			{
				name = "Moltke_SouthDef_01",
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
				spawn = mkr_moti_e_main_def_s2,
				load = 2,
			},
			{
				name = "Moltke_SouthDef_01",
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
				spawn = mkr_moti_e_main_def_s3,
				load = 4,
				difficulty = {GD_NORMAL, GD_HARD},
			},
		},
	}
	encID_moti_main_def = Encounter:Create(encData)
	
	local goalData = {
		name = "Defend",
		target = mkr_moti_e_main_def,
		
		leashRange = 21,
		range = 21,
		
		maxAttackers = 2,
		
		abilityControlsList = {
			{
				abilityPBG = ABILITY.GERMAN.PANZER_GRENADIER_BUNDLED_GRENADE,
				maxCasters = 2,
				waitTimeSecs = 8,
			},
		},
		
		tacticTargetPreference = AITacticTargetPreference_Near,
		
		coordinatedSetup = true,
		
		coordinatedSetupFacingPositions = {
			Util_GetOffsetPosition(mkr_moti_e_main_def, OFFSET_FRONT, 100),
		},
		
		tacticControlsList = {
			{
				tacticType = TACTIC_Avoid,
				priority = 500,
				maxUsers = 4,
			},
			{
				tacticType = TACTIC_Cover,
				priority = 100,
				waitTimeSecs = 60,
				maxUsers = 2,
				maxRange = 1,
			},
			{
				tacticType = TACTIC_Ability,
				priority = 400,
			},
			{
				tacticType = TACTIC_Help,
				priority = -1,
			},
		}
	}
	encID_moti_main_def:SetGoal(goalData)
	
	Event_PlayerOwnsTerritory(MOTI_Complete, nil, player1, World_GetTerritorySectorID(Util_GetPosition(eg_moti_cp)), 1)
	
end

function Moti_Encs_Panther_Left()
	
	sg_moti_e_panther_left_all = SGroup_CreateIfNotFound("sg_moti_e_panther_left_all")
	
	-- AI
	local encData = {
		name = "Moti_NorthBridge_def01",
		player = player2,
		spawn = mkr_moti_e_panther_left_s01,
		sgroups = {sg_moti_e_panther_left_all},
		units = {
			{
				name = "Moltke_SouthDef_01",
				sbp = SBP.GERMAN.PANTHER_SQUAD,
				spawn = mkr_moti_e_panther_left_s01,
			},
			{
				name = "Moltke_SouthDef_02",
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				upgrades = {UPG.GERMAN.GRENADIER_MG42_LMG},
				spawn = mkr_moti_e_panther_left_s02,
			},
			{
				name = "Moltke_SouthDef_02",
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				load = 3,
				spawn = mkr_moti_e_panther_left_s03,
				difficulty = {GD_EASY},
			},
			{
				name = "Moltke_SouthDef_02",
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
				load = 4,
				spawn = mkr_moti_e_panther_left_s03,
				difficulty = {GD_NORMAL, GD_HARD},
			},
		},
	}
	encID_moti_panther_left = Encounter:Create(encData)
	
	Event_Proximity(_moti_encs_panther_left_enable, nil, player1, mkr_moti_e_panther_left_atk, nil, ANY)

end

function _moti_encs_panther_left_enable()

	local goalData = {
		name = "Attack",
		target = mkr_moti_e_panther_left_atk,
		
		leashRange = 17,
		range = 30,
		
		abilityControlsList = {
			{
				abilityPBG = ABILITY.GERMAN.PANZER_GRENADIER_BUNDLED_GRENADE,
				maxCasters = 1,
				maxRange = 10,
				waitTimeSecs = 20,
			}
		},
		
		maxAttackers = 3,
		
		tacticTargetPreference = AITacticTargetPreference_HighDamage,
		
		tacticControlsList = {
			{
				tacticType = TACTIC_Avoid,
				priority = 500,
				maxUsers = 4,
			},
			{
				tacticType = TACTIC_Cover,
				priority = 100,
			},
			{
				tacticType = TACTIC_Ability,
				priority = 250,
			},
			{
				tacticType = TACTIC_Help,
				priority = -1,
			},
		}
	}
	encID_moti_panther_left:SetGoal(goalData)

end

function Moti_Encs_Stug()

	sg_moti_e_stug_def_01 = SGroup_CreateIfNotFound("sg_moti_e_stug_def_01")
	sg_moti_e_stug_def_02 = SGroup_CreateIfNotFound("sg_moti_e_stug_def_02")
	sg_moti_e_stug_def_03 = SGroup_CreateIfNotFound("sg_moti_e_stug_def_03")
	
	Util_CreateSquads(player2, sg_moti_e_stug_def_01, SBP.GERMAN.GRENADIER_SQUAD, mkr_moti_e_stug_def_s01)
	Util_CreateSquads(player2, sg_moti_e_stug_def_03, SBP.GERMAN.GRENADIER_SQUAD, mkr_moti_e_stug_def_s03)
	
	Cmd_Upgrade(sg_moti_e_stug_def_01, UPG.GERMAN.GRENADIER_MG42_LMG, 1, true)
	Cmd_Upgrade(sg_moti_e_stug_def_02, UPG.GERMAN.GRENADIER_MG42_LMG, 1, true)
	
	Util_CreateSquads(player2, sg_moti_e_stug_def_02, SBP.GERMAN.PIONEER_SQUAD, mkr_moti_e_stug_def_s02, nil, 1, 3)
	
	Event_Proximity(_Moti_Stug_Trig, nil, player1, mkr_moti_stug_trig, nil, ANY)
	
end

function _Moti_Stug_Trig()
	
	eg_stug_abandon = EGroup_CreateIfNotFound("eg_stug_abandon")
	World_GetNeutralEntitiesNearPoint(eg_stug_abandon, Util_GetPosition(mkr_moti_e_stug_def_s03), 7)
	EGroup_Filter(eg_stug_abandon, EBP.GERMAN.STUG_III_E_SDKFZ_141_1, FILTER_KEEP)
	
	if SGroup_IsEmpty(sg_moti_e_stug_def_01) == false then Cmd_Move(sg_moti_e_stug_def_01, mkr_moti_e_stug_def_d01) end
	if SGroup_IsEmpty(sg_moti_e_stug_def_03) == false then Cmd_Move(sg_moti_e_stug_def_03, mkr_moti_e_stug_def_d03) end
	
	Rule_AddOneShot(_Moti_Stug_Pioneer_A, 2)

end

function _Moti_Stug_Pioneer_A()
	
	if SGroup_IsEmpty(sg_moti_e_stug_def_02) == false then
		Cmd_Move(sg_moti_e_stug_def_02, mkr_moti_e_stug_def_d02_A)
		
		Rule_AddInterval(_Moti_Stug_Pioneer_B, 1)
		
		Event_PlayerCanSeeElement(EventHandler_StartIntel, {intel_callback = EVENTS.MOTI_STUG_CREW_SPOTTED}, player1, sg_moti_e_stug_def_02, ANY)
		Rule_AddInterval(_Moti_Stug_Remove_HP, 2)
		
	end

end

function _Moti_Stug_Pioneer_B()

	if SGroup_IsEmpty(sg_moti_e_stug_def_02) == false and SGroup_IsMoving(sg_moti_e_stug_def_02, ANY) == false then
		Rule_RemoveMe()
		Cmd_Move(sg_moti_e_stug_def_02, mkr_moti_e_stug_def_d02_B)
		
		Rule_AddInterval(_Moti_Stug_Pioneer_C, 1)
	end

end

function _Moti_Stug_Pioneer_C()
	
	if SGroup_IsEmpty(sg_moti_e_stug_def_02) == false and SGroup_IsMoving(sg_moti_e_stug_def_02, ANY) == false then
		Rule_RemoveMe()
		Cmd_Move(sg_moti_e_stug_def_02, mkr_moti_e_stug_def_d02_C)
		
		Rule_AddInterval(_Moti_Stug_Pioneer_Stug, 1)
	end

end

function _Moti_Stug_Pioneer_Stug()

	if SGroup_IsEmpty(sg_moti_e_stug_def_02) == false and EGroup_IsEmpty(eg_stug_abandon) == false and SGroup_IsMoving(sg_moti_e_stug_def_02, ALL) == false then 
		Rule_RemoveMe()
		
		Cmd_Move(sg_moti_e_stug_def_02, Util_GetOffsetPosition(eg_stug_abandon, OFFSET_RIGHT, 3))
		Cmd_RecrewVehicle(sg_moti_e_stug_def_02, eg_stug_abandon, true)
		
	end

end

function _Moti_Stug_Remove_HP() 
	if SGroup_TotalMembersCount(sg_moti_e_stug_def_02) < 3 or EGroup_IsEmpty(eg_stug_abandon) == true then
		
		Rule_RemoveMe()
		
		if hpid_moti_stug_crew ~= nil then
			HintPoint_Remove(hpid_moti_stug_crew)
		end
		if threatid_moti_stug_crew ~= nil then
			ThreatArrow_DestroyGroup(threatid_moti_stug_crew)
		end
		
		moti_stug_crew_hintpoints_removed = true
		
	end
end

function _Moti_Artillery_Unavailable() Util_StartIntel(EVENTS.MOTI_ARTILLERY_UNAVAIL) end


----------------------------
-- PARENT OBJECTIVE
----------------------------
function MISSION_Init_Kroll_Parent_Objective()

	OBJ_Kroll_Parent = {
		
		SetupUI = function() 
			
		end,
		
		OnStart = function()
			Kroll_Init()
			
			World_IncreaseInteractionStage()
			EGroup_EnableMinimapIndicator(eg_territorypoints_stage3, true)
			
			Sound_StopMusic(CAMPAIGN_MUSIC_FADEOUT, 0)
			Sound_PlayMusic("streamed/music/missions/m14/m14_cue_capture_operahouse", 4, 4)		-- start music for next section
			
			Event_NarrativeEventsNotRunning(EventHandler_StartIntel, {intel_callback = EVENTS.KROLL_ALTERNATE_ENTRANCE}, 4)
		end,
		
		OnComplete = function()
			
			Rule_AddOneShot(Mission_Autosave_02, 4)
			Rule_AddOneShot(REICHSTAG_Kickoff_Objective, 7)
			
			Reichstag_Init()
			
			World_IncreaseInteractionStage()
			EGroup_EnableMinimapIndicator(eg_territorypoints_stage4, true)
			
			if Objective_IsComplete(OBJ_KROLL_01) == false then Objective_Complete(OBJ_KROLL_01, false) end
			if Objective_IsComplete(OBJ_KROLL_02) == false then Objective_Complete(OBJ_KROLL_02, false) end
		end,
		
		OnFail = function()
			
		end,
		
		IsComplete = function()
			return false
		end,
		
		Intel_Start = EVENTS.KROLL_START,				-- Event will play when obj starts but before any UI appears
		Intel_Complete = nil,			-- Event will play when obj completes but before UI is cleared
		Intel_Fail = nil,				-- Event will play when obj fails but before UI is cleared
		Title = 11046968,				-- LOCDB [11046968] 'Clear the Kroll Opera House'
		Type = OT_Primary,				-- Objective Type (OT_Primary, OT_Secondary)
	}
	
	Objective_Register(OBJ_Kroll_Parent)

end
----------------------------
-- BEAT 3
-- KROLL OPERA HOUSE
----------------------------
-- || INIT FUNCTIONS ||
function KROLL_Init_Objective()

	OBJ_KROLL_01 = {
		
		SetupUI = function() 
			hpid_kroll_01 = Objective_AddUIElements(OBJ_KROLL_01, eg_kroll_lobby, true, 11046969, true, 2.8)			-- LOCDB [11046969] 'Secure the Lobby'
		end,
		
		OnStart = function()
			Event_PlayerOwnsTerritory(KROLL_01_Complete, nil, player1, eg_kroll_lobby)
			
			Modify_EntityBuildTime(player3, EBP.SOVIET.HQ, 0.7)
			Modify_EntityBuildTime(player3, EBP.SOVIET.BARRACKS, 0.7)
			Modify_EntityBuildTime(player3, EBP.SOVIET.WEAPON_SUPPORT_CENTER, 0.7)
			Modify_EntityBuildTime(player3, EBP.SOVIET.MOTORPOOL, 0.7)
			Modify_EntityBuildTime(player3, EBP.SOVIET.TANK_DEPOT, 0.7)
			
			-- Check for Base Building
			Rule_AddInterval(Forward_Base_Init, 1)
		end,
		
		OnComplete = function()
			
		end,
		
		OnFail = function()
			
		end,
		
		IsComplete = function()
			return false
		end,
		
		Intel_Start = nil,				-- Event will play when obj starts but before any UI appears
		Intel_Complete = nil,			-- Event will play when obj completes but before UI is cleared
		Intel_Fail = nil,				-- Event will play when obj fails but before UI is cleared
		Title = 11046969,				-- LOCDB [11046969] 'Secure the Lobby'
		Type = OT_Primary,				-- Objective Type (OT_Primary, OT_Secondary)
		Parent = OBJ_Kroll_Parent,
	}
	
	Objective_Register(OBJ_KROLL_01)
	
	OBJ_KROLL_02 = {
		
		SetupUI = function() 
			hpid_kroll_02 = Objective_AddUIElements(OBJ_KROLL_02, eg_kroll_auditorium, true, 11046970, true, 2.8)
		end,
		
		OnStart = function()
			Event_PlayerOwnsTerritory(KROLL_02_Complete, nil, player1, eg_kroll_auditorium)
		end,
		
		OnComplete = function()
			
		end,
		
		OnFail = function()
			
		end,
		
		IsComplete = function()
			return false
		end,
		
		Intel_Start = nil,				-- Event will play when obj starts but before any UI appears
		Intel_Complete = nil,			-- Event will play when obj completes but before UI is cleared
		Intel_Fail = nil,				-- Event will play when obj fails but before UI is cleared
		Title = 11046970,				-- LOCDB [11046970] 'Secure the Auditorium'
		Type = OT_Primary,				-- Objective Type (OT_Primary, OT_Secondary)
		Parent = OBJ_Kroll_Parent,
	}
	
	Objective_Register(OBJ_KROLL_02)

end
--|| OBJECTIVE FUNCTIONS ||
function KROLL_Delay_Start()

	Objective_Start(OBJ_Kroll_Parent, true)

end
function KROLL_Kickoff_Objective()

	Objective_Start(OBJ_Kroll_Parent, true)
	Objective_Start(OBJ_KROLL_01, false)
	Objective_Start(OBJ_KROLL_02, false)
	
	Rule_AddInterval(KROLL_Complete, 1)
	
end

function KROLL_01_Complete()
	
	if Objective_IsComplete(OBJ_KROLL_02) then
		Objective_Complete(OBJ_KROLL_01, false)
	else
		Objective_Complete(OBJ_KROLL_01)
	end
	

end

function KROLL_02_Complete()
	
	if Objective_IsComplete(OBJ_KROLL_01) then
		Objective_Complete(OBJ_KROLL_02, false)
	else
		Objective_Complete(OBJ_KROLL_02)
	end

end

function KROLL_Complete()

	if Objective_IsComplete(OBJ_KROLL_01) and Objective_IsComplete(OBJ_KROLL_02) then
		Rule_RemoveMe()
		
		Objective_Complete(OBJ_Kroll_Parent)
		
--~ 		Sound_SetMusicCombatValue(2, 60*99999999)
	end

end

--|| BEAT FUNCTIONS ||
function Kroll_Init()
	
	-- DEBUG
	if Objective_IsStarted(OBJ_Kroll_Parent) == false then Rule_AddOneShot(KROLL_Kickoff_Objective, 2) end
	
	-- Rules
	Rule_AddInterval(_kroll_lobby_tank, 1)
	
	-- Init Encounters
	Kroll_Encs_Init()

end

function _kroll_lobby_tank()

	if Player_GetStrategicPointCaptureProgress(player1, EGroup_GetSpawnedEntityAt(eg_kroll_lobby, 1)) > -0.9 then
		Rule_RemoveMe()
		
		sg_kroll_e_SCR_tank_01 = SGroup_CreateIfNotFound("sg_kroll_e_SCR_tank_01")
		
		Util_CreateSquads(player2, sg_kroll_e_SCR_tank_01, SBP.GERMAN.PANZER_IV_SQUAD, mkr_kroll_e_SCR_tank_01, mkr_kroll_e_SCR_tank_01_dest)
	end

end

-- Base
function Forward_Base_Init()
	
	if Event_IsAnyRunning() == false and Player_OwnsEGroup(player1, eg_base_cp) 
	  and (SGroup_IsEmpty(sg_moti_e_pak43_def) or SGroup_IsRetreating(sg_moti_e_pak43_def, ALL)) then
		Rule_RemoveMe()
		
		EGroup_SetRallyPoint(eg_p_hq, mkr_a_hq)
		EGroup_SetRallyPoint(eg_p_barracks, mkr_a_barracks)
		EGroup_SetRallyPoint(eg_p_weaponsupport, mkr_a_weapon)
		EGroup_SetRallyPoint(eg_p_motorpool, mkr_a_motor)
		EGroup_SetRallyPoint(eg_p_tankdepot, mkr_a_tank)
	end
	
end

--|| BEAT ENCOUNTERS ||
function Kroll_Encs_Init()

	Kroll_Encs_Lobby_Def()
	
	Kroll_Encs_Ruins_A_Def()
	
	Kroll_Encs_Auditorium_Def_01()
	Kroll_Encs_Auditorium_Def_02()
	Kroll_Encs_Ruins_Def_01()
	Kroll_Encs_Ruins_Def_02()
	
	Kroll_Encs_Road_Def()

end

function Kroll_Encs_Entrance_Def()
	
	if SGroup_IsEmpty(sg_moti_e_pak43_def) or SGroup_IsRetreating(sg_moti_e_pak43_def, ALL) then
		Rule_RemoveMe()
		
		sg_kroll_e_entrance = SGroup_CreateIfNotFound("sg_kroll_e_entrance")
		
		-- AI
		local encData = {
			name = "Kroll_Entrance_Def",
			player = player2,
			spawn = mkr_kroll_e_entrance_def,
			sgroups = {sg_kroll_e_entrance},
			units = {
				{
					name = "Moltke_SouthDef_01",
					sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
					load = 5,
					spawn = mkr_kroll_e_entrance_def_s0,
				},
				{
					name = "Moltke_SouthDef_03",
					sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
					spawn = mkr_kroll_e_entrance_def_s1,
					load = 4,
				},
			},
		}
		encID_kroll_entrance_def = Encounter:Create(encData)
		
		local goalData = {
			name = "Attack",
			target = mkr_kroll_e_entrance_def,
			
			leashRange = 17,
			range = 15,
			
			attackMove = false,
			attackEngagementMove = false,
			
			abilityControlsList = {
				{
					abilityPBG = ABILITY.GERMAN.GRENADIER_PANZERFAUST,
					maxCasters = 2,
					waitTimeSecs = 20,
				}
			},
			
			maxAttackers = 2,
			
			tacticTargetPreference = AITacticTargetPreference_HighDamage,
			
			tacticControlsList = {
				{
					tacticType = TACTIC_Avoid,
					priority = 500,
					maxUsers = 2,
				},
				{
					tacticType = TACTIC_Cover,
					priority = 900,
				},
				{
					tacticType = TACTIC_Ability,
					priority = 80,
				},
				{
					tacticType = TACTIC_Help,
					priority = -1,
				},
				{
					tacticType = TACTIC_CaptureTeamWeapon,
					priority = 250,
					waitTimeSecs = 40,
				},
			}
		}
		encID_kroll_entrance_def:SetGoal(goalData)
		
		Rule_AddOneShot(_Kroll_Encs_Entrance_Delay, 3)
	end
	
--~ 	Event_GroupIsDead(_Kroll_Delete_Opera_Wall, nil, sg_kroll_e_entrance_SCRIPTED)
	
end

function _Kroll_Encs_Entrance_Delay()

	-- Scripted
	sg_kroll_e_entrance_SCRIPTED = SGroup_CreateIfNotFound("sg_kroll_e_entrance_SCRIPTED")
	
	Util_CreateSquads(player2, sg_kroll_e_entrance_SCRIPTED, SBP.GERMAN.GRENADIER_SQUAD, eg_kroll_wall_bld_01, nil, 1, 3)
	Cmd_Upgrade(sg_kroll_e_entrance_SCRIPTED, UPG.GERMAN.GRENADIER_MG42_LMG, 1, true)
	
	EGroup_SetSelectable(eg_kroll_wall_bld_01, true)
	EGroup_SetInvulnerable(eg_kroll_wall_bld_01, false)
	
	Event_GroupIsDead(_Kroll_Encs_Revert_Wall_01, nil, sg_kroll_e_entrance_SCRIPTED)

end

function _Kroll_Encs_Revert_Wall_01()

	EGroup_SetSelectable(eg_kroll_wall_bld_01, false)

end

function _Kroll_Delete_Opera_Wall()

	EGroup_Kill(eg_kroll_wall_bld_01)

end

function Kroll_Encs_Lobby_Def()
	
	sg_kroll_e_lobby = SGroup_CreateIfNotFound("sg_kroll_e_lobby")
	
		-- AI
	local encData = {
		name = "Kroll_Lobby_Def",
		player = player2,
		spawn = mkr_kroll_e_lobby_A_def,
		sgroups = {sg_kroll_e_lobby},
		units = {
			{
				name = "Moltke_SouthDef_01",
				sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
				spawn = mkr_kroll_e_lobby_def_s0,
				load = 4,
				difficulty = {GD_EASY, GD_NORMAL},
			},
			{
				name = "Moltke_SouthDef_01",
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
				spawn = mkr_kroll_e_lobby_def_s0,
				load = 3,
				difficulty = {GD_HARD},
			},
			{
				name = "Moltke_SouthDef_02",
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				upgrades = {UPG.GERMAN.GRENADIER_MG42_LMG},
				spawn = mkr_kroll_e_lobby_def_s1,
			},
			{
				name = "Moltke_SouthDef_02",
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
				upgrades = {UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM, UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM_SECOND},
				spawn = mkr_kroll_e_lobby_def_s2,
			},
			{
				name = "Moltke_SouthDef_04",
				sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
				spawn = mkr_kroll_e_lobby_def_s3,
				load = 3,
				difficulty = {GD_HARD},
			},
		},
	}
	encID_kroll_lobby_def = Encounter:Create(encData)
	
	local goalData = {
		name = "Defend",
		target = mkr_kroll_e_lobby_A_def,
		
		leashRange = 15,
		range = 15,
		
		abilityControlsList = {
			{
				abilityPBG = ABILITY.GERMAN.GRENADIER_PANZERFAUST,
				maxCasters = 2,
				waitTimeSecs = 20,
			},
			{
				abilityPBG = ABILITY.GERMAN.PANZER_GRENADIER_BUNDLED_GRENADE,
				maxCasters = 1,
				waitTimeSecs = 30,
			},
		},
		
		maxAttackers = 2,
		
		tacticTargetPreference = AITacticTargetPreference_HighDamage,
		
		coordinatedSetup = true,
		
		coordinatedSetupFacingPositions = {
			Util_GetOffsetPosition(mkr_kroll_e_lobby_A_def, OFFSET_FRONT, 100),
		},
		
		tacticControlsList = {
			{
				tacticType = TACTIC_Avoid,
				priority = 500,
				maxUsers = 2,
			},
			{
				tacticType = TACTIC_Cover,
				priority = -1,
			},
			{
				tacticType = TACTIC_Ability,
				priority = 80,
			},
			{
				tacticType = TACTIC_Help,
				priority = -1,
			},
		}
	}
	encID_kroll_lobby_def:SetGoal(goalData)
	

end

function Kroll_Encs_Ruins_A_Def()
	
	sg_kroll_e_ruins_A = SGroup_CreateIfNotFound("sg_kroll_e_ruins_A")
	
		-- AI
	local encData = {
		name = "Kroll_Ruins_A_Def",
		player = player2,
		spawn = mkr_kroll_e_ruins_A,
		sgroups = {sg_kroll_e_ruins_A},
		units = {
			{
				name = "Moltke_SouthDef_01",
				sbp = SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD,
				load = 4,
				spawn = mkr_kroll_e_ruins_A_s0,
			},
			{
				name = "Moltke_SouthDef_01",
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
				load = 3,
				spawn = mkr_kroll_e_ruins_A_s1,
			},
			{
				name = "Moltke_SouthDef_01",
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				load = 3,
				spawn = mkr_kroll_e_ruins_A_s2,
			},
		},
	}
	encID_kroll_ruins_A_def = Encounter:Create(encData)
	
	local goalData = {
		name = "Defend",
		target = mkr_kroll_e_ruins_A,
		
		leashRange = 15,
		range = 15,
		
		abilityControlsList = {
			{
				abilityPBG = ABILITY.GERMAN.GRENADIER_PANZERFAUST,
				maxCasters = 2,
				waitTimeSecs = 20,
			},
			{
				abilityPBG = ABILITY.GERMAN.PANZER_GRENADIER_BUNDLED_GRENADE,
				maxCasters = 1,
				waitTimeSecs = 30,
			},
		},
		
		maxAttackers = 2,
		
		tacticTargetPreference = AITacticTargetPreference_HighDamage,
		
		coordinatedSetup = true,
		
		coordinatedSetupFacingPositions = {
			Util_GetOffsetPosition(mkr_kroll_e_lobby_A_def, OFFSET_FRONT, 100),
		},
		
		tacticControlsList = {
			{
				tacticType = TACTIC_Avoid,
				priority = 500,
				maxUsers = 2,
			},
			{
				tacticType = TACTIC_Cover,
				priority = -1,
			},
			{
				tacticType = TACTIC_Ability,
				priority = 80,
			},
			{
				tacticType = TACTIC_Help,
				priority = -1,
			},
		}
	}
	encID_kroll_ruins_A_def:SetGoal(goalData)

end



function Kroll_Encs_Auditorium_Def_01()
	
	sg_kroll_e_aud_def_01 = SGroup_CreateIfNotFound("sg_kroll_e_aud_def_01")
	
	-- AI
	local encData = {
		name = "Kroll_Lobby_Def",
		player = player2,
		spawn = mkr_kroll_e_aud_01,
		sgroups = {sg_kroll_e_aud_def_01},
		units = {
			{
				name = "Moltke_SouthDef_02",
				sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
				load = 3,
				spawn = mkr_kroll_e_aud_01_s0,
				difficulty = {GD_EASY, GD_NORMAL},
			},
			{
				name = "Moltke_SouthDef_02",
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				load = 2,
				spawn = mkr_kroll_e_aud_01_s0,
				difficulty = {GD_HARD},
			},
--~ 			{
--~ 				name = "Moltke_SouthDef_02",
--~ 				sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
--~ 				spawn = mkr_kroll_e_aud_01_s2,
--~ 				load = 4,
--~ 			},
			{
				name = "Moltke_SouthDef_03",
				sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
				spawn = mkr_kroll_e_aud_01_s3,
				load = 3,
				difficulty = {GD_EASY, GD_NORMAL},
			},
			{
				name = "Moltke_SouthDef_03",
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = mkr_kroll_e_aud_01_s3,
				load = 3,
				difficulty = {GD_HARD},
			},
			{
				name = "Moltke_SouthDef_04",
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
				upgrades = {UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM},
				spawn = mkr_kroll_e_aud_01_s4,
			},
		},
	}
	encID_kroll_aud_def_01 = Encounter:Create(encData)
	
	local goalData = {
		name = "Defend",
		target = mkr_kroll_e_aud_01,
		
		leashRange = 30,
		range = 15,
		
		abilityControlsList = {
			{
				abilityPBG = ABILITY.GERMAN.PANZER_GRENADIER_BUNDLED_GRENADE,
				maxCasters = 2,
				waitTimeSecs = 20,
			}
		},
		
		maxAttackers = 3,
		
		tacticTargetPreference = AITacticTargetPreference_HighDamage,
		
		coordinatedSetup = true,
		
		coordinatedSetupFacingPositions = {
			Util_GetOffsetPosition(mkr_kroll_e_aud_01, OFFSET_FRONT, 100),
		},
		
		tacticControlsList = {
			{
				tacticType = TACTIC_Avoid,
				priority = 500,
				maxUsers = 2,
			},
			{
				tacticType = TACTIC_Cover,
				priority = -1,
			},
			{
				tacticType = TACTIC_Ability,
				priority = 250,
			},
			{
				tacticType = TACTIC_Help,
				priority = -1,
			},
		}
	}
	encID_kroll_aud_def_01:SetGoal(goalData)
	
	Event_Proximity(_Kroll_Encs_Aud_Counter_Attack, nil, player1, mkr_kroll_e_aud_01, nil, ANY)
	
end

function Kroll_Encs_Auditorium_Def_02()
	
	sg_kroll_e_aud_def_02 = SGroup_CreateIfNotFound("sg_kroll_e_aud_def_02")
	
		-- AI
	local encData = {
		name = "Kroll_Lobby_Def",
		player = player2,
		spawn = mkr_kroll_e_aud_02,
		sgroups = {sg_kroll_e_aud_def_02},
		units = {
			{
				name = "Moltke_SouthDef_01",
				sbp = SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD,
				spawn = mkr_kroll_e_aud_02_s0,
			},
--~ 			{
--~ 				name = "Moltke_SouthDef_02",
--~ 				sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
--~ 				spawn = mkr_kroll_e_aud_02_s1,
--~ 			},
		},
	}
	encID_kroll_aud_def_02 = Encounter:Create(encData)
	
	local goalData = {
		name = "Defend",
		target = mkr_kroll_e_aud_02,
		
		leashRange = 8,
		range = 8,
		
		tacticTargetPreference = AITacticTargetPreference_Near,
		
		coordinatedSetup = true,
		
		coordinatedSetupFacingPositions = {
			Util_GetOffsetPosition(mkr_kroll_e_aud_02, OFFSET_FRONT, 100),
		},
		
		tacticControlsList = {
			{
				tacticType = TACTIC_Avoid,
				priority = 500,
				maxUsers = 3,
			},
			{
				tacticType = TACTIC_Cover,
				priority = -1,
			},
			{
				tacticType = TACTIC_Ability,
				priority = -1,
			},
			{
				tacticType = TACTIC_Help,
				priority = -1,
			},
		}
	}
	encID_kroll_aud_def_02:SetGoal(goalData)
	
end


function _Kroll_Encs_Aud_Counter_Attack()
	
	if krollauditorium_counterattack_triggered ~= true then
		
		krollauditorium_counterattack_triggered = true
		
		sg_kroll_e_aud_CA = SGroup_CreateIfNotFound("sg_kroll_e_aud_CA")
		
		-- AI
		local encData = {
			name = "Kroll_Lobby_Def",
			player = player2,
			spawn = mkr_kroll_e_aud_reinforce,
			sgroups = {sg_kroll_e_aud_CA},
			units = {
				{
					name = "Moltke_SouthDef_02",
					sbp = SBP.GERMAN.GRENADIER_SQUAD,
					load = 3,
				},
				{
					name = "Moltke_SouthDef_02",
					sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
				},
			},
		}
		encID_kroll_aud_CA = Encounter:Create(encData)
		
		local goalData = {
			name = "Attack",
			target = mkr_kroll_e_aud_03,
			
			leashRange = 30,
			range = 15,
			
			abilityControlsList = {
				{
					abilityPBG = ABILITY.GERMAN.PANZER_GRENADIER_BUNDLED_GRENADE,
					maxCasters = 2,
					waitTimeSecs = 20,
				}
			},
			
			tacticTargetPreference = AITacticTargetPreference_Near,
			
			tacticControlsList = {
				{
					tacticType = TACTIC_Avoid,
					priority = 100,
					maxUsers = 2,
				},
				{
					tacticType = TACTIC_Cover,
					priority = 500,
				},
				{
					tacticType = TACTIC_Ability,
					priority = -1,
				},
				{
					tacticType = TACTIC_Help,
					priority = -1,
				},
			}
		}
		encID_kroll_aud_CA:SetGoal(goalData)
		
	end
	
end

function Kroll_Encs_Ruins_Def_01()
	
	sg_kroll_e_ruins_def_01 = SGroup_CreateIfNotFound("sg_kroll_e_ruins_def_01")
	
		-- AI
	local encData = {
		name = "Kroll_Lobby_Def",
		player = player2,
		spawn = mkr_kroll_e_ruins_def_01,
		sgroups = {sg_kroll_e_ruins_def_01},
		units = {
			{
				name = "Moltke_SouthDef_01",
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
				spawn = mkr_kroll_e_ruins_def_01_s0,
				upgrades = {UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM},
				load = 3,
			},
			{
				name = "Moltke_SouthDef_02",
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
				spawn = mkr_kroll_e_ruins_def_01_s1,
			},
		},
	}
	encID_kroll_aud_ruins_01 = Encounter:Create(encData)
	
	local goalData = {
		name = "Defend",
		target = mkr_kroll_e_ruins_def_01,
		
		leashRange = 15,
		range = 6,
		
		tacticTargetPreference = AITacticTargetPreference_Near,
		
		coordinatedSetup = true,
		
		coordinatedSetupFacingPositions = {
			Util_GetOffsetPosition(mkr_kroll_e_ruins_def_01, OFFSET_FRONT, 100),
		},
		
		tacticControlsList = {
			{
				tacticType = TACTIC_Avoid,
				priority = 500,
				maxUsers = 3,
			},
			{
				tacticType = TACTIC_Cover,
				priority = -1,
			},
			{
				tacticType = TACTIC_Ability,
				priority = 200,
			},
			{
				tacticType = TACTIC_Help,
				priority = -1,
			},
		}
	}
	encID_kroll_aud_ruins_01:SetGoal(goalData)
	
end

function Kroll_Encs_Ruins_Def_02()
	
	sg_kroll_e_ruins_def_02 = SGroup_CreateIfNotFound("sg_kroll_e_ruins_def_02")
	
		-- AI
	local encData = {
		name = "Kroll_Lobby_Def",
		player = player2,
		spawn = mkr_kroll_e_ruins_def_02,
		sgroups = {sg_kroll_e_ruins_def_02},
		units = {
			{
				name = "Moltke_SouthDef_01",
				sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
				spawn = mkr_kroll_e_ruins_def_02_s0,
				load = 4,
			},
			{
				name = "Moltke_SouthDef_02",
				sbp = SBP.GERMAN.PIONEER_SQUAD,
				upgrades = {UPG.GERMAN.PIONEER_FLAMETHROWER},
				spawn = mkr_kroll_e_ruins_def_02_s1,
			},
		},
	}
	encID_kroll_ruins_02 = Encounter:Create(encData)
	
	local goalData = {
		name = "Defend",
		target = mkr_kroll_e_ruins_def_02,
		
		leashRange = 8,
		range = 12,
		
		tacticTargetPreference = AITacticTargetPreference_Near,
		
		coordinatedSetup = true,
		
		coordinatedSetupFacingPositions = {
			Util_GetOffsetPosition(mkr_kroll_e_ruins_def_02, OFFSET_FRONT, 100),
		},
		
		tacticControlsList = {
			{
				tacticType = TACTIC_Avoid,
				priority = 500,
				maxUsers = 3,
			},
			{
				tacticType = TACTIC_Cover,
				priority = -1,
			},
			{
				tacticType = TACTIC_Ability,
				priority = 200,
			},
			{
				tacticType = TACTIC_Help,
				priority = -1,
			},
		}
	}
	encID_kroll_ruins_02:SetGoal(goalData)
	
end

function Kroll_Encs_Road_Def()
	
	sg_kroll_e_road = SGroup_CreateIfNotFound("sg_kroll_e_road")
	sg_kroll_e_road_stug = SGroup_CreateIfNotFound("sg_kroll_e_road_stug")
	
		-- AI
	local encData = {
		name = "Kroll_Lobby_Def",
		player = player2,
		spawn = mkr_kroll_e_road_def_01,
		sgroups = {sg_kroll_e_road},
		units = {
			{
				name = "Moltke_SouthDef_01",
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
				spawn = mkr_kroll_e_road_def_01_s0,
			},
			{
				name = "Moltke_SouthDef_02",
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				upgrades = {UPG.GERMAN.GRENADIER_MG42_LMG},
				spawn = mkr_kroll_e_road_def_01_s1,
			},
			{
				name = "Moltke_SouthDef_03",
				sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
				spawn = mkr_kroll_e_road_def_01_s2,
			},
			{
				name = "Moltke_SouthDef_04",
				sbp = SBP.GERMAN.PANZER_IV_SQUAD,
				sgroups = {sg_kroll_e_road_stug},
				spawn = mkr_kroll_e_road_def_01_s3,
			},
		},
	}
	encID_kroll_road_def = Encounter:Create(encData)
	
	local goalData = {
		name = "Defend",
		target = mkr_kroll_e_road_def_01,
		
		leashRange = 18,
		range = 15,
		
		abilityControlsList = {
			{
				abilityPBG = ABILITY.GERMAN.GRENADIER_PANZERFAUST,
				maxCasters = 2,
				waitTimeSecs = 20,
			},
			{
				abilityPBG = ABILITY.GERMAN.PANZER_GRENADIER_BUNDLED_GRENADE,
				maxCasters = 1,
				waitTimeSecs = 30,
			},
		},
		
		maxAttackers = 2,
		
		tacticTargetPreference = AITacticTargetPreference_HighDamage,
		
		coordinatedSetup = true,
		
		coordinatedSetupFacingPositions = {
			Util_GetOffsetPosition(mkr_kroll_e_road_def_01, OFFSET_FRONT, 100),
		},
		
		tacticControlsList = {
			{
				tacticType = TACTIC_Avoid,
				priority = 500,
				maxUsers = 2,
			},
			{
				tacticType = TACTIC_Cover,
				priority = -1,
			},
			{
				tacticType = TACTIC_Ability,
				priority = 80,
			},
			{
				tacticType = TACTIC_Help,
				priority = -1,
			},
		}
	}
	encID_kroll_road_def:SetGoal(goalData)
	
	Cmd_Upgrade(sg_kroll_e_road_stug, BP_GetUpgradeBlueprint("instant_german_hulldown"), 1, true)
	

end
----------------------------
-- BEAT 4
-- THE REICHSTAG
----------------------------
-- || INIT FUNCTIONS ||
function MISSION_Init_Reichstag_Parent_Objective()

	OBJ_Reichstag_Parent = {
		
		SetupUI = function() 
			
		end,
		
		OnStart = function()
			
			Sound_StopMusic(CAMPAIGN_MUSIC_FADEOUT, 0)
			Sound_PlayMusic("streamed/music/missions/m14/m14_cue_capture_reichstag", 4, 4)
			
			EGroup_SetPlayerOwner(eg_reichstag_all, player2)
			
			Rule_AddOneShot(Reichstag_Artillery_Available, 3)
			Rule_Add(_reichstag_Init_Tigers)
			
			Objective_Start(OBJ_REICH_ENTRANCE, false)
			
			Rule_AddInterval(REICHSTAG_Start_Tigers, 1)
			Rule_AddInterval(REICHSTAG_Mission_Complete, 1)
			
		end,
		
		OnComplete = function()
			-- End the mission
			Rule_AddDelayedInterval(Mission_Complete_Check, 1.5, 1)
		end,
		
		OnFail = function()
			
		end,
		
		IsComplete = function()
			return false
		end,
		
		Intel_Start = EVENTS.REICH_START,				-- Event will play when obj starts but before any UI appears
		Intel_Complete = EVENTS.OUTRO_NIS,				-- Event will play when obj completes but before UI is cleared
		Intel_Fail = nil,				-- Event will play when obj fails but before UI is cleared
		Title = 11046971,				-- LOCDB [11046971] 'Capture the Reichstag'
		Type = OT_Primary,				-- Objective Type (OT_Primary, OT_Secondary)
	}
	
	Objective_Register(OBJ_Reichstag_Parent)
	
	OBJ_REICH_ENTRANCE = {
		
		SetupUI = function() 
			hpid_reich = Objective_AddUIElements(OBJ_REICH_ENTRANCE, eg_reichstag_cp, true, 11046972, true, 2.8)
		end,
		
		OnStart = function()
			ehid_reich_entrance = Event_PlayerOwnsTerritory(EventHandler_ObjectiveComplete, {objective = OBJ_REICH_ENTRANCE}, player1, eg_reichstag_cp, ANY, 1)
			Event_PlayerCanSeeElement(_Seen_Reichstag, nil, player1, eg_reichstag_all, ANY)
		end,
		
		OnComplete = function()
			Objective_RemoveUIElements(OBJ_REICH_ENTRANCE, hpid_reich)
		end,
		
		OnFail = function()
			
		end,
		
		IsComplete = function()
			return false
		end,
		
		Intel_Start = nil,				-- Event will play when obj starts but before any UI appears
		Intel_Complete = nil,			-- Event will play when obj completes but before UI is cleared
		Intel_Fail = nil,				-- Event will play when obj fails but before UI is cleared
		Title = 11046972,				-- LOCDB [11046972] 'Secure the Main Entrance'
		Type = OT_Primary,				-- Objective Type (OT_Primary, OT_Secondary)
		Parent = OBJ_Reichstag_Parent,
	}
	
	Objective_Register(OBJ_REICH_ENTRANCE)

end

function REICHSTAG_Init_Objective()

	OBJ_REICH_TIGERS = {
		
		SetupUI = function() 
			hpid_reich_tiger_01 = Objective_AddUIElements(OBJ_REICH_TIGERS, sg_reich_e_tiger_01, true, 11046973)
			hpid_reich_tiger_02 = Objective_AddUIElements(OBJ_REICH_TIGERS, sg_reich_e_tiger_02, true, 11046973)
		end,
		
		OnStart = function()
			Event_GroupIsDead(REICHSTAG_Objective_Complete, nil, sg_reich_e_tiger_both, 2)
			
			sg_p_isu_152 = SGroup_CreateIfNotFound("sg_p_isu_152")
			Util_CreateSquads(player1, sg_p_isu_152, SBP.SOVIET.ISU_152, mkr_p_isu_152_spawn, mkr_p_isu_152)
			
			local popcap = Player_GetMaxPopulation(player1, CT_Personnel)
			Player_SetPopCapOverride(player1, (popcap+20))
			
			Rule_AddOneShot(_reichstag_isu_on_field, 8)
		end,
		
		OnComplete = function()
			
		end,
		
		OnFail = function()
			
		end,
		
		IsComplete = function()
			return false
		end,
		
		Intel_Start = EVENTS.REICH_TIGERS_SPOTTED,				-- Event will play when obj starts but before any UI appears
		Intel_Complete = nil,			-- Event will play when obj completes but before UI is cleared
		Intel_Fail = nil,				-- Event will play when obj fails but before UI is cleared
		Title = 11046973,				-- LOCDB [11046973] 'Destroy the Tigers'
		Type = OT_Primary,				-- Objective Type (OT_Primary, OT_Secondary)
		Parent = OBJ_Reichstag_Parent,
	}
	
	Objective_Register(OBJ_REICH_TIGERS)
end
--|| OBJECTIVE FUNCTIONS ||
function REICHSTAG_Kickoff_Objective()

	Objective_Start(OBJ_Reichstag_Parent, true)

end

function REICHSTAG_Start_Tigers()
	
	if SGroup_Exists("sg_reich_e_tiger_both") and (SGroup_IsEmpty(sg_reich_e_tiger_both) == false and Player_CanSeeSGroup(player1, sg_reich_e_tiger_both, ANY)) then
		Rule_RemoveMe()
		
		Objective_Start(OBJ_REICH_TIGERS)
	end

end

function REICHSTAG_Start_Objective()
	
--~ 	Objective_RemoveUIElements(OBJ_Reichstag_Parent, hpid_reich)
	
--~ 	Objective_Start(OBJ_REICH_TIGERS)

end

function REICHSTAG_Objective_Complete()
	
	if ehid_reich_entrance ~= nil and Objective_IsComplete(OBJ_REICH_ENTRANCE) == false then
		Event_Remove(ehid_reich_entrance)							-- since we just completed the tiger objective, if the capture obj isn't done yet then stop it completing (we are gonna complete the parent objective anyway without it)
	end	
	
	Objective_Complete(OBJ_REICH_TIGERS)

end

function REICHSTAG_Mission_Complete()

	if Objective_IsComplete(OBJ_REICH_TIGERS) then
		
		Rule_RemoveMe()
		Rule_AddOneShot(REICHSTAG_Mission_Complete_Delay, 2)
		
	end

end

function REICHSTAG_Mission_Complete_Delay()

	Objective_Complete(OBJ_Reichstag_Parent, false)
	
	if _beforeTheWinter_failed == false then
		print("COMPLETING camp14_reichstag_fast_win")
		Scar_CompleteIntelBulletinTask(player1, "camp14_reichstag_fast_win")
	end
	
	if _bootsInTheStreet_failed == false then
		print("COMPLETING camp14_reichstag_no_vehicles")
		Scar_CompleteIntelBulletinTask(player1, "camp14_reichstag_no_vehicles")
	end

end


--|| BEAT FUNCTIONS ||
function Reichstag_Init()
	
--~ 	Player_AddAbilityLockoutZone(player1, ABILITY.SOVIET.ML_20_152MM_BARRAGE_ABILITY, mkr_reich_lockout)
	g_capMod = Modify_CaptureTime(eg_reichstag_cp, 0.5)
	
	-- Hulldown
	Cmd_Upgrade(sg_reich_e_panther, BP_GetUpgradeBlueprint("instant_german_hulldown"), 1, true)
	
	-- DEBUG
--~ 	if Objective_IsStarted(OBJ_Reichstag_Parent) == false then Rule_AddOneShot(REICHSTAG_Kickoff_Objective, 2) end
	
	-- Init Encounters
	Reichstag_Encs_Init()
	
	-- Other Rules
--~ 	Rule_AddDelayedInterval(Reichstag_Panzerwerfer_01, 20, 75)
--~ 	Rule_AddDelayedInterval(Reichstag_Panzerwerfer_02, 50, 75)
	
--~ 	Event_Proximity(_Reichstag_southBridge_demo, nil, player1, mkr_reich_southBridge_demo_trig)
--~ 	Event_Proximity(_Reichstag_northBridge_demo, nil, player1, mkr_reich_northBridge_demo_trig)
	
end

function Reichstag_Panzerwerfer_01()
	
	if SGroup_IsEmpty(sg_reich_e_panzerWerfer_01) then Rule_RemoveMe() return end
	
	_panzerwerfer_01_target = Player_GetSquadConcentration(player1, false, nil, nil, false, mkr_reich_panzerWerfer_01_tar)
	
	if _panzerwerfer_01_target ~= nil and SGroup_IsEmpty(_panzerwerfer_01_target) == false then
		Util_StartIntel(EVENTS.REICH_PANZERWERFER)
		EventCue_Create(CUE.ATTACKED, 11046974,11046974, _target)	-- LOCDB [11046974] 'Incoming Barrage'
		
		Rule_AddOneShot(_Reichstag_Panzerwerfer_01_Fire, 3)
	end

end

function _Reichstag_Panzerwerfer_01_Fire()

	Cmd_Ability(sg_reich_e_panzerWerfer_01, ABILITY.GERMAN.PANZERWERFER_ROCKET_BARRAGE, _panzerwerfer_01_target, nil, true)

end

function Reichstag_Panzerwerfer_02()
	
	if SGroup_IsEmpty(sg_reich_e_panzerWerfer_02) then Rule_RemoveMe() return end
	
	_panzerwerfer_02_target = Player_GetSquadConcentration(player1, false, nil, nil, false, mkr_reich_panzerWerfer_02_tar)
	
	if _panzerwerfer_02_target ~= nil and SGroup_IsEmpty(_panzerwerfer_02_target) == false then
		Util_StartIntel(EVENTS.REICH_PANZERWERFER)
		EventCue_Create(CUE.ATTACKED, 11046974, 11046974, _target)
		
		Rule_AddOneShot(_Reichstag_Panzerwerfer_02_Fire, 3)
	end

end

function _Reichstag_Panzerwerfer_02_Fire()

	Cmd_Ability(sg_reich_e_panzerWerfer_02, ABILITY.GERMAN.PANZERWERFER_ROCKET_BARRAGE, _panzerwerfer_02_target, nil, true)

end

function Reichstag_Artillery_Available()

	Util_StartIntel(EVENTS.REICH_ARTILLERY_AVAILABLE)
	
	Player_SetEntityProductionAvailability(player1, EBP.SOVIET.M1937_152MM_ML_20_ARTILLERY, ITEM_UNLOCKED)
	Player_SetAbilityAvailability(player1, ABILITY.SOVIET.FIRE_ARTILLERY, ITEM_DEFAULT)
	Player_SetAbilityAvailability(player1, ABILITY.SOVIET.IL_2_PRECISION_BOMB_STRIKE, ITEM_DEFAULT)

end




function _reichstag_isu_on_field() EventCue_Create(CUE.VEHICLE, 11047719, 11047719, sg_p_isu_152) end		-- LOCDB [11047719] 'ISU-152 Granted'
--|| BEAT ENCOUNTERS ||
function Reichstag_Encs_Init()
	
	-- Scripted
	sg_reich_e_SCR_hmg01 = SGroup_CreateIfNotFound("sg_reich_e_SCR_hmg01")
	Util_CreateSquads(player2, sg_reich_e_SCR_hmg01, SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD, Util_GetOffsetPosition(mkr_reich_e_SCR_hmg01, OFFSET_BACK, 5))
	Cmd_Move(sg_reich_e_SCR_hmg01, mkr_reich_e_SCR_hmg01, false, nil, Util_GetOffsetPosition(mkr_reich_e_SCR_hmg01, OFFSET_FRONT, 10))
	TeamWeapon_AddGroup(sg_reich_e_SCR_hmg01)
	
	sg_reich_e_SCR_hmg02 = SGroup_CreateIfNotFound("sg_reich_e_SCR_hmg02")
	Util_CreateSquads(player2, sg_reich_e_SCR_hmg02, SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD, Util_GetOffsetPosition(mkr_reich_e_SCR_hmg02, OFFSET_BACK, 5))
	Cmd_Move(sg_reich_e_SCR_hmg02, mkr_reich_e_SCR_hmg02, false, nil, Util_GetOffsetPosition(mkr_reich_e_SCR_hmg02, OFFSET_FRONT, 10))
	TeamWeapon_AddGroup(sg_reich_e_SCR_hmg02)
	
	if g_difficulty == GD_NORMAL or g_difficulty == GD_HARD then
		sg_reich_e_SCR_hmg03 = SGroup_CreateIfNotFound("sg_reich_e_SCR_hmg03")
		Util_CreateSquads(player2, sg_reich_e_SCR_hmg03, SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD, Util_GetOffsetPosition(mkr_reich_e_SCR_hmg03, OFFSET_BACK, 5))
		Cmd_Move(sg_reich_e_SCR_hmg03, mkr_reich_e_SCR_hmg03, false, nil, Util_GetOffsetPosition(mkr_reich_e_SCR_hmg03, OFFSET_FRONT, 10))
		TeamWeapon_AddGroup(sg_reich_e_SCR_hmg03)
	end
	
	sg_reich_e_SCR_hmg04 = SGroup_CreateIfNotFound("sg_reich_e_SCR_hmg04")
	Util_CreateSquads(player2, sg_reich_e_SCR_hmg04, SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD, Util_GetOffsetPosition(mkr_reich_e_SCR_hmg04, OFFSET_BACK, 5))
	Cmd_Move(sg_reich_e_SCR_hmg04, mkr_reich_e_SCR_hmg04, false, nil, Util_GetOffsetPosition(mkr_reich_e_SCR_hmg04, OFFSET_FRONT, 10))
	TeamWeapon_AddGroup(sg_reich_e_SCR_hmg04)
	
	if g_difficulty == GD_HARD then
		sg_reich_e_SCR_hmg05 = SGroup_CreateIfNotFound("sg_reich_e_SCR_hmg05")
		Util_CreateSquads(player2, sg_reich_e_SCR_hmg05, SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD, Util_GetOffsetPosition(mkr_reich_e_SCR_hmg05, OFFSET_BACK, 5))
		Cmd_Move(sg_reich_e_SCR_hmg05, mkr_reich_e_SCR_hmg05, false, nil, Util_GetOffsetPosition(mkr_reich_e_SCR_hmg05, OFFSET_FRONT, 10))
		TeamWeapon_AddGroup(sg_reich_e_SCR_hmg05)
	end
	
	sg_reich_e_SCR_hmg06 = SGroup_CreateIfNotFound("sg_reich_e_SCR_hmg06")
	Util_CreateSquads(player2, sg_reich_e_SCR_hmg06, SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD, Util_GetOffsetPosition(mkr_reich_e_SCR_hmg06, OFFSET_BACK, 5))
	Cmd_Move(sg_reich_e_SCR_hmg06, mkr_reich_e_SCR_hmg06, false, nil, Util_GetOffsetPosition(mkr_reich_e_SCR_hmg06, OFFSET_FRONT, 10))
	TeamWeapon_AddGroup(sg_reich_e_SCR_hmg06)
	
	sg_reich_e_SCR_hmg07 = SGroup_CreateIfNotFound("sg_reich_e_SCR_hmg07")
	Util_CreateSquads(player2, sg_reich_e_SCR_hmg07, SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD, Util_GetOffsetPosition(mkr_reich_e_SCR_hmg07, OFFSET_BACK, 5))
	Cmd_Move(sg_reich_e_SCR_hmg07, mkr_reich_e_SCR_hmg07, false, nil, Util_GetOffsetPosition(mkr_reich_e_SCR_hmg07, OFFSET_FRONT, 10))
	TeamWeapon_AddGroup(sg_reich_e_SCR_hmg07)
	
	sg_reich_e_SCR_at01 = SGroup_CreateIfNotFound("sg_reich_e_SCR_at01")
	Util_CreateSquads(player2, sg_reich_e_SCR_at01, SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD, mkr_reich_e_SCR_at01)
	TeamWeapon_AddGroup(sg_reich_e_SCR_at01)
	
	if g_difficulty == GD_NORMAL then
		sg_reich_e_SCR_at02 = SGroup_CreateIfNotFound("sg_reich_e_SCR_at02")
		Util_CreateSquads(player2, sg_reich_e_SCR_at02, SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD, mkr_reich_e_SCR_at02)
		TeamWeapon_AddGroup(sg_reich_e_SCR_at02)
	end
	
	sg_reich_e_SCR_gren01 = SGroup_CreateIfNotFound("sg_reich_e_SCR_gren01")
	Util_CreateSquads(player2, sg_reich_e_SCR_gren01, SBP.GERMAN.GRENADIER_SQUAD, mkr_reich_e_SCR_gren01)
	Cmd_Upgrade(sg_reich_e_SCR_gren01, UPG.GERMAN.GRENADIER_MG42_LMG, 1, true)
	
	if g_difficulty == GD_NORMAL or g_difficulty == GD_HARD then
		sg_reich_e_SCR_tank01 = SGroup_CreateIfNotFound("sg_reich_e_SCR_tank01")
		Util_CreateSquads(player2, sg_reich_e_SCR_tank01, SBP.GERMAN.PANZER_IV_SQUAD, mkr_reich_e_SCR_tank01)
		Cmd_Upgrade(sg_reich_e_SCR_tank01, BP_GetUpgradeBlueprint("instant_german_hulldown"), 1, true)
	end
	
	if g_difficulty == GD_HARD then
		sg_reich_e_SCR_tank02 = SGroup_CreateIfNotFound("sg_reich_e_SCR_tank02")
		Util_CreateSquads(player2, sg_reich_e_SCR_tank02, SBP.GERMAN.STUG_III_SQUAD, mkr_reich_e_SCR_tank02)
		Cmd_Upgrade(sg_reich_e_SCR_tank02, BP_GetUpgradeBlueprint("instant_german_hulldown"), 1, true)
	end
	
	if g_difficulty == GD_HARD then
		sg_reich_e_SCR_tank03 = SGroup_CreateIfNotFound("sg_reich_e_SCR_tank03")
		Util_CreateSquads(player2, sg_reich_e_SCR_tank03, SBP.GERMAN.STUG_III_SQUAD, mkr_reich_e_SCR_tank03)
		Cmd_Upgrade(sg_reich_e_SCR_tank03, BP_GetUpgradeBlueprint("instant_german_hulldown"), 1, true)
	end
	
	Reichstag_LeftBridge_Plaza()
	Reichstag_RightBridge_Plaza()
	
	Reichstag_Brummbar_Def()
	
	Reichstag_RightPlaza_North()
	
	Reichstag_Pak43_01()
	Reichstag_Pak43_02()
	
	Reichstag_LineA_01()
	Reichstag_LineA_02()
	Reichstag_LineA_03()
	Reichstag_LineA_03()
	Reichstag_LineA_04()
	Reichstag_LineA_05()
	
	Reichstag_LineB_01()
	Reichstag_LineB_02()
	
	Rule_AddInterval(Reichstag_Refresh_Defenders, 6)
--~ 	Rule_AddInterval(Reichstag_MentionSubway, 5)
	
end



function Reichstag_MentionSubway()
	
	Player_GetAll(player1)
	
	if Event_IsAnyRunning() == false and SGroup_IsUnderAttack(sg_allsquads, ANY, 5) == false then
		
		for k, marker in pairs( {mkr_subway1, mkr_subway2, mkr_subway3, mkr_subway4, mkr_subway5, mkr_subway6} ) do 
			
			local pos =  Marker_GetPosition(marker)
			
			if Player_CanSeePosition(player1, pos) and Misc_IsPosOnScreen(pos, 0.85) then
				
				Util_StartIntel(EVENTS.COLLAPSED_SUBWAY)
				Camera_MoveTo(Util_GetPositionFromAtoB(Camera_GetTargetPos(), marker, 0.5), true, 0.2)
				
				Rule_RemoveMe()
				
				break
				
			end
			
		end
		
	end
	
end

function Reichstag_LeftBridge_Plaza()
	
	sg_reich_leftBridge_plaza_tank = SGroup_CreateIfNotFound("sg_reich_leftBridge_plaza_tank")
	
	if g_difficulty == GD_EASY or g_difficulty == GD_NORMAL then
		Util_CreateSquads(player2, sg_reich_leftBridge_plaza_tank, SBP.GERMAN.PANZER_IV_SQUAD, mkr_reich_e_leftBridge_plaza_def_s0)
	elseif g_difficulty == GD_HARD then
		Util_CreateSquads(player2, sg_reich_leftBridge_plaza_tank, SBP.GERMAN.PANTHER_SQUAD, mkr_reich_e_leftBridge_plaza_def_s0)
	end
	
	Cmd_Upgrade(sg_reich_leftBridge_plaza_tank, BP_GetUpgradeBlueprint("instant_german_hulldown"), 1, true)
	
	sg_reich_leftBridge_plaza = SGroup_CreateIfNotFound("sg_reich_leftBridge_plaza")
	
	-- AI
	local encData = {
		name = "Kroll_Entrance_Def",
		player = player2,
		spawn = mkr_reich_e_leftBridge_plaza,
		sgroups = {sg_reich_leftBridge_plaza},
		units = {
			{
				name = "Moltke_SouthDef_01",
				sbp = SBP.GERMAN.MORTAR_TEAM_81MM,
				spawn = mkr_reich_e_leftBridge_plaza_def_s1,
			},
			{
				name = "Moltke_SouthDef_02",
				sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
				spawn = mkr_reich_e_leftBridge_plaza_def_s2,
				difficulty = {GD_EASY},
			},
			{
				name = "Moltke_SouthDef_02",
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				upgrades = {UPG.GERMAN.GRENADIER_MG42_LMG},
				spawn = mkr_reich_e_leftBridge_plaza_def_s2,
				difficulty = {GD_NORMAL},
			},
			{
				name = "Moltke_SouthDef_02",
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
				upgrades = {UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM},
				spawn = mkr_reich_e_leftBridge_plaza_def_s2,
				difficulty = {GD_HARD},
			},
			{
				name = "Moltke_SouthDef_03",
				sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
				spawn = mkr_reich_e_leftBridge_plaza_def_s3,
				load = 4,
			},
			{
				name = "Moltke_SouthDef_03",
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = mkr_reich_e_leftBridge_plaza_def_s4,
				load = 4,
			},
			{
				name = "Moltke_SouthDef_03",
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = mkr_reich_e_leftBridge_plaza_def_s5,
				difficulty = {GD_EASY},
			},
			{
				name = "Moltke_SouthDef_03",
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				upgrades = {UPG.GERMAN.GRENADIER_MG42_LMG},
				spawn = mkr_reich_e_leftBridge_plaza_def_s5,
				difficulty = {GD_NORMAL, GD_HARD},
			},
		},
	}
	encID_reich_leftBridge_plaza_def = Encounter:Create(encData)
	
	local goalData = {
		name = "Defend",
		target = mkr_reich_e_leftBridge_plaza,
		
		leashRange = 26,
		range = 35,
		
		tacticTargetPreference = AITacticTargetPreference_HighDamage,
		
--~ 		coordinatedSetup = true,
--~ 		
--~ 		coordinatedSetupFacingPositions = {
--~ 			Util_GetOffsetPosition(mkr_reich_e_leftBridge_plaza, OFFSET_FRONT, 100),
--~ 		},
		
		tacticControlsList = {
			{
				tacticType = TACTIC_Avoid,
				priority = 500,
				maxUsers = 2,
			},
			{
				tacticType = TACTIC_Cover,
				priority = 900,
			},
			{
				tacticType = TACTIC_Ability,
				priority = 80,
			},
			{
				tacticType = TACTIC_Help,
				priority = -1,
			},
		}
	}
	encID_reich_leftBridge_plaza_def:SetGoal(goalData)

end

function Reichstag_RightBridge_Plaza()
	
	sg_reich_e_rightBridge_plaza_gren01 = SGroup_CreateIfNotFound("sg_reich_e_rightBridge_plaza_gren01")
	Util_CreateSquads(player2, sg_reich_e_rightBridge_plaza_gren01, SBP.GERMAN.GRENADIER_SQUAD, eg_reich_rightBridge_plaza_trench01)
	Cmd_Upgrade(sg_reich_e_rightBridge_plaza_gren01, UPG.GERMAN.GRENADIER_MG42_LMG, 1, true)
	
	sg_reich_e_rightBridge_plaza_gren02 = SGroup_CreateIfNotFound("sg_reich_e_rightBridge_plaza_gren02")
	Util_CreateSquads(player2, sg_reich_e_rightBridge_plaza_gren02, SBP.GERMAN.GRENADIER_SQUAD, eg_reich_rightBridge_plaza_trench02)
	Cmd_Upgrade(sg_reich_e_rightBridge_plaza_gren02, UPG.GERMAN.GRENADIER_MG42_LMG, 1, true)
	
	sg_reich_rightBridge_plaza = SGroup_CreateIfNotFound("sg_reich_rightBridge_plaza")
	sg_reich_rightBridge_plaza_extras = SGroup_CreateIfNotFound("sg_reich_rightBridge_plaza_extras")
	sg_reich_rightBridge_plaza_pak43 = SGroup_CreateIfNotFound("sg_reich_rightBridge_plaza_pak43")
	
	-- AI
	local encData = {
		name = "Reichstag_RightBridge_Def",
		player = player2,
		spawn = mkr_reich_e_rightBridge_plaza,
		sgroups = {sg_reich_rightBridge_plaza},
		units = {
			{
				name = "Reichstag_RightBridge_Def",
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = mkr_reich_e_rightBridge_plaza_def_s2,
				upgrades = {UPG.GERMAN.GRENADIER_MG42_LMG},
			},
		},
	}
	encID_reich_rightBridge_plaza_def = Encounter:Create(encData)
	
	local goalData = {
		name = "Defend",
		target = mkr_reich_e_rightBridge_plaza,
		
		leashRange = 26,
		range = 35,
		
		tacticTargetPreference = AITacticTargetPreference_HighDamage,
		
--~ 		coordinatedSetup = true,
--~ 		
--~ 		coordinatedSetupFacingPositions = {
--~ 			Util_GetOffsetPosition(mkr_reich_e_leftBridge_plaza, OFFSET_FRONT, 100),
--~ 		},
		
		tacticControlsList = {
			{
				tacticType = TACTIC_Avoid,
				priority = 500,
				maxUsers = 2,
			},
			{
				tacticType = TACTIC_Cover,
				priority = 900,
			},
			{
				tacticType = TACTIC_Ability,
				priority = 80,
			},
			{
				tacticType = TACTIC_Help,
				priority = -1,
			},
		}
	}
	encID_reich_rightBridge_plaza_def:SetGoal(goalData)

	
	if g_difficulty == GD_HARD then
		Util_CreateSquads(player2, sg_reich_rightBridge_plaza_pak43, SBP.GERMAN.PAK43_88MM_AT_GUN_SQUAD, mkr_reich_e_rightBridge_plaza_def_s0)
		SGroup_AddGroup(sg_reich_rightBridge_plaza_extras, sg_reich_rightBridge_plaza_pak43)
	else
		Util_CreateSquads(player2, sg_reich_rightBridge_plaza_extras, SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD, mkr_reich_e_rightBridge_plaza_def_s0)
	end
	Util_CreateSquads(player2, sg_reich_rightBridge_plaza_extras, SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD, mkr_reich_e_rightBridge_plaza_def_s1)
	Event_PlayerCanSeeElement(Reichstag_RightBridge_Plaza_SeenATGuns, nil, player1, sg_reich_rightBridge_plaza_extras, ALL, 6)
	
	if SGroup_IsEmpty(sg_reich_rightBridge_plaza_pak43) == false then
		Event_PlayerCanSeeElement(_Seen_Pak43, {sg_reich_rightBridge_plaza_pak43}, player1, sg_reich_rightBridge_plaza_pak43, nil, 2)
	end
	
end
function Reichstag_RightBridge_Plaza_SeenATGuns(data)
	encID_reich_rightBridge_plaza_def:AddSgroup(sg_reich_rightBridge_plaza_extras)
end

function Reichstag_RightPlaza_North()
	
	sg_reich_rightPlaza_tank = SGroup_CreateIfNotFound("sg_reich_rightPlaza_tank")
	
	if g_difficulty == GD_EASY then
		Util_CreateSquads(player2, sg_reich_rightPlaza_tank, SBP.GERMAN.STUG_III_SQUAD, mkr_reich_e_rightPlaza_north)
	elseif g_difficulty == GD_NORMAL then
		Util_CreateSquads(player2, sg_reich_rightPlaza_tank, SBP.GERMAN.PANZER_IV_SQUAD, mkr_reich_e_rightPlaza_north)
	elseif g_difficulty == GD_Hard then
		Util_CreateSquads(player2, sg_reich_rightPlaza_tank, SBP.GERMAN.PANTHER_SQUAD, mkr_reich_e_rightPlaza_north)
	end
	
	Cmd_Upgrade(sg_reich_rightPlaza_tank, BP_GetUpgradeBlueprint("instant_german_hulldown"), 1, true)
	
	sg_reich_rightPlaza = SGroup_CreateIfNotFound("sg_reich_rightPlaza")
	
	-- AI
	local encData = {
		name = "Kroll_Entrance_Def",
		player = player2,
		spawn = mkr_reich_e_rightPlaza_north,
		sgroups = {sg_reich_rightPlaza},
		units = {
			{
				name = "Moltke_SouthDef_01",
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = mkr_reich_e_rightPlaza_north_def_s0,
			},
			{
				name = "Moltke_SouthDef_01",
				sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
				spawn = mkr_reich_e_rightPlaza_north_def_s1,
			},
			{
				name = "Moltke_SouthDef_01",
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				upgrades = {UPG.GERMAN.GRENADIER_MG42_LMG},
				spawn = mkr_reich_e_rightPlaza_north_def_s2,
			},
		},
	}
	encID_reich_rightPlaza_north_def = Encounter:Create(encData)
	
	local goalData = {
		name = "Defend",
		target = mkr_reich_e_rightPlaza_north,
		
		leashRange = 26,
		range = 35,
		
		tacticTargetPreference = AITacticTargetPreference_HighDamage,
		
--~ 		coordinatedSetup = true,
--~ 		
--~ 		coordinatedSetupFacingPositions = {
--~ 			Util_GetOffsetPosition(mkr_reich_e_leftBridge_plaza, OFFSET_FRONT, 100),
--~ 		},
		
		tacticControlsList = {
			{
				tacticType = TACTIC_Avoid,
				priority = 500,
				maxUsers = 2,
			},
			{
				tacticType = TACTIC_Cover,
				priority = 900,
			},
			{
				tacticType = TACTIC_Ability,
				priority = 80,
			},
			{
				tacticType = TACTIC_Help,
				priority = -1,
			},
		},
		
		fallbackParams = {
			thresholds = {0.33},
			markers = {mkr_reich_e_rightPlaza_north_retreatDest},
			globalPercentage = 0.6,
			retreat = true,
		},
		
		onTransition = Reichstag_RightPlaza_RetreatToBridge,
	}
	encID_reich_rightPlaza_north_def:SetGoal(goalData)

end


function Reichstag_RightPlaza_RetreatToBridge(encounter, state)
	
	if state == AIObjectiveStage_Fallback then
		encounter:Disable()
		encID_reich_rightBridge_plaza_def:AddSgroup(encounter.sgroup)
	end
	
end


function Reichstag_Brummbar_Def()

	sg_reich_brummbar_def = SGroup_CreateIfNotFound("sg_reich_brummbar_def")
	
	-- AI
	local encData = {
		name = "Kroll_Entrance_Def",
		player = player2,
		spawn = mkr_reich_e_brummbar_def,
		sgroups = {sg_reich_brummbar_def},
		units = {
			{
				name = "Moltke_SouthDef_01",
				sbp = SBP.GERMAN.BRUMMBAR_SQUAD,
				spawn = mkr_reich_e_brummbar_def_s2,
			},
			{
				name = "Moltke_SouthDef_02",
				sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
				spawn = mkr_reich_e_brummbar_def_s0,
				difficulty = {GD_EASY, GD_NORMAL},
			},
			{
				name = "Moltke_SouthDef_02",
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				upgrades = {UPG.GERMAN.GRENADIER_MG42_LMG},
				spawn = mkr_reich_e_brummbar_def_s0,
				difficulty = {GD_HARD},
			},
		},
	}
	encID_reich_brummbar_def = Encounter:Create(encData)
	
	local goalData = {
		name = "Defend",
		target = mkr_reich_e_brummbar_def,
		
		leashRange = 26,
		range = 35,
		
		tacticTargetPreference = AITacticTargetPreference_HighDamage,
		
		coordinatedSetup = true,
		
		coordinatedSetupFacingPositions = {
			Util_GetOffsetPosition(mkr_reich_e_brummbar_def, OFFSET_FRONT, 100),
		},
		
		tacticControlsList = {
			{
				tacticType = TACTIC_Avoid,
				priority = 500,
				maxUsers = 2,
			},
			{
				tacticType = TACTIC_Cover,
				priority = 900,
			},
			{
				tacticType = TACTIC_Ability,
				priority = 80,
			},
			{
				tacticType = TACTIC_Help,
				priority = -1,
			},
		}
	}
	encID_reich_brummbar_def:SetGoal(goalData)

end

function Reichstag_Pak43_01()

	sg_reich_e_pak43_01 = SGroup_CreateIfNotFound("sg_reich_e_pak43_01")
	
	-- AI
	local encData = {
		name = "Kroll_Entrance_Def",
		player = player2,
		spawn = mkr_reich_e_pak43_01,
		sgroups = {sg_reich_e_pak43_01},
		units = {
			{
				name = "Moltke_SouthDef_01",
				sbp = SBP.GERMAN.PAK43_88MM_AT_GUN_SQUAD,
			},
		},
	}
	encID_reich_pak43_01 = Encounter:Create(encData)
	
	local goalData = {
		name = "Defend",
		target = mkr_reich_e_pak43_01,
		
		leashRange = 26,
		range = 80,
		
		tacticTargetPreference = AITacticTargetPreference_HighDamage,
		
		coordinatedSetup = true,
		
		coordinatedSetupFacingPositions = {
			Util_GetOffsetPosition(mkr_reich_e_pak43_01, OFFSET_FRONT, 100),
		},
		
		tacticControlsList = {
			{
				tacticType = TACTIC_Avoid,
				priority = -1,
			},
			{
				tacticType = TACTIC_Cover,
				priority = -1,
			},
			{
				tacticType = TACTIC_Ability,
				priority = 800,
			},
			{
				tacticType = TACTIC_Help,
				priority = -1,
			},
		}
	}
	encID_reich_pak43_01:SetGoal(goalData)
	
	SGroup_IncreaseVeterancyRank(sg_reich_e_pak43_01, 3)
	Event_PlayerCanSeeElement(_Seen_Pak43, {sg_reich_e_pak43_01}, player1, sg_reich_e_pak43_01, nil, 2)
	
	Modify_Vulnerability(sg_reich_e_pak43_01, 0.75)

end

function Reichstag_Pak43_02()

	sg_reich_e_pak43_02 = SGroup_CreateIfNotFound("sg_reich_e_pak43_02")
	
	-- AI
	local encData = {
		name = "Kroll_Entrance_Def",
		player = player2,
		spawn = mkr_reich_e_pak43_02,
		sgroups = {sg_reich_e_pak43_02},
		units = {
			{
				name = "Moltke_SouthDef_01",
				sbp = SBP.GERMAN.PAK43_88MM_AT_GUN_SQUAD,
			},
		},
	}
	encID_reich_pak43_02 = Encounter:Create(encData)
	
	local goalData = {
		name = "Defend",
		target = mkr_reich_e_pak43_02,
		
		leashRange = 26,
		range = 80,
		
		tacticTargetPreference = AITacticTargetPreference_HighDamage,
		
		coordinatedSetup = true,
		
		coordinatedSetupFacingPositions = {
			Util_GetOffsetPosition(mkr_reich_e_pak43_02, OFFSET_FRONT, 100),
		},
		
		tacticControlsList = {
			{
				tacticType = TACTIC_Avoid,
				priority = -1,
			},
			{
				tacticType = TACTIC_Cover,
				priority = -1,
			},
			{
				tacticType = TACTIC_Ability,
				priority = 800,
			},
			{
				tacticType = TACTIC_Help,
				priority = -1,
			},
		}
	}
	encID_reich_pak43_02:SetGoal(goalData)
	
	SGroup_IncreaseVeterancyRank(sg_reich_e_pak43_02, 3)
	Event_PlayerCanSeeElement(_Seen_Pak43, {sg_reich_e_pak43_02}, player1, sg_reich_e_pak43_02, nil, 2)
	
	Modify_Vulnerability(sg_reich_e_pak43_02, 0.75)

end

function Reichstag_LineA_01()

	sg_reich_e_lineA_01 = SGroup_CreateIfNotFound("sg_reich_e_lineA_01")
	
	-- AI
	local encData = {
		name = "Kroll_Entrance_Def",
		player = player2,
		spawn = mkr_reich_e_lineA_01,
		sgroups = {sg_reich_e_lineA_01},
		units = {
			{
				name = "Moltke_SouthDef_01",
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = mkr_reich_e_lineA_01_def_s0,
				difficulty = {GD_EASY, GD_NORMAL},
			},
			{
				name = "Moltke_SouthDef_01",
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = mkr_reich_e_lineA_01_def_s0,
				upgrades = {UPG.GERMAN.GRENADIER_MG42_LMG},
				difficulty = {GD_HARD},
			},
			{
				name = "Moltke_SouthDef_01",
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = mkr_reich_e_lineA_01_def_s1,
				upgrades = {UPG.GERMAN.GRENADIER_MG42_LMG},
			},
			{
				name = "Moltke_SouthDef_01",
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
				spawn = mkr_reich_e_lineA_01_def_s2,
				upgrades = {UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM, UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM_SECOND},
			},
--~ 			{
--~ 				name = "Moltke_SouthDef_01",
--~ 				sbp = SBP.GERMAN.GRENADIER_SQUAD,
--~ 				spawn = mkr_reich_e_lineA_01_def_s3,
--~ 				difficulty = {GD_EASY},
--~ 			},
--~ 			{
--~ 				name = "Moltke_SouthDef_01",
--~ 				sbp = SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD,
--~ 				spawn = mkr_reich_e_lineA_01_def_s3,
--~ 				difficulty = {GD_NORMAL, GD_HARD},
--~ 			},
		},
	}
	encID_reich_lineA_01 = Encounter:Create(encData)
	
	local goalData = {
		name = "Defend",
		target = mkr_reich_e_lineA_01,
		
		leashRange = 10,
		
		tacticTargetPreference = AITacticTargetPreference_HighDamage,
		
		coordinatedSetup = true,
		
		coordinatedSetupFacingPositions = {
			Util_GetOffsetPosition(mkr_reich_e_lineA_01, OFFSET_FRONT, 100),
		},
		
		tacticControlsList = {
			{
				tacticType = TACTIC_Avoid,
				priority = 900,
				maxUsers = 2,
			},
			{
				tacticType = TACTIC_Cover,
				priority = 500,
			},
			{
				tacticType = TACTIC_Ability,
				priority = 800,
			},
			{
				tacticType = TACTIC_Help,
				priority = -1,
			},
		},
		
		fallbackParams = {
			thresholds = {0.4},
			markers = {mkr_reich_e_lineB_01},
			globalPercentage = 0.6,
			retreat = true,
		},
		
		onTransition = Reichstag_LineA_RetreatToB1,
		
	}
	encID_reich_lineA_01:SetGoal(goalData)

end

function Reichstag_LineA_02()

	sg_reich_e_lineA_02 = SGroup_CreateIfNotFound("sg_reich_e_lineA_02")
	
	-- AI
	local encData = {
		name = "Kroll_Entrance_Def",
		player = player2,
		spawn = mkr_reich_e_lineA_02,
		sgroups = {sg_reich_e_lineA_02},
		units = {
			{
				name = "Moltke_SouthDef_01",
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = mkr_reich_e_lineA_02_def_s0,
				upgrades = {UPG.GERMAN.GRENADIER_MG42_LMG},
			},
			{
				name = "Moltke_SouthDef_01",
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = mkr_reich_e_lineA_01_def_s2,
				difficulty = {GD_EASY, GD_NORMAL},
			},
			{
				name = "Moltke_SouthDef_01",
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = mkr_reich_e_lineA_01_def_s2,
				upgrades = {UPG.GERMAN.GRENADIER_MG42_LMG},
				difficulty = {GD_HARD},
			},
		},
	}
	encID_reich_lineA_02 = Encounter:Create(encData)
	
	local goalData = {
		name = "Defend",
		target = mkr_reich_e_lineA_02,
		
		leashRange = 10,
		
		tacticTargetPreference = AITacticTargetPreference_HighDamage,
		
		coordinatedSetup = true,
		
		coordinatedSetupFacingPositions = {
			Util_GetOffsetPosition(mkr_reich_e_lineA_02, OFFSET_FRONT, 100),
		},
		
		tacticControlsList = {
			{
				tacticType = TACTIC_Avoid,
				priority = 900,
				maxUsers = 2,
			},
			{
				tacticType = TACTIC_Cover,
				priority = 500,
			},
			{
				tacticType = TACTIC_Ability,
				priority = 800,
			},
			{
				tacticType = TACTIC_Help,
				priority = -1,
			},
		},
		
		fallbackParams = {
			thresholds = {0.4},
			markers = {mkr_reich_e_lineB_01},
			globalPercentage = 0.6,
			retreat = true,
		},
		
		onTransition = Reichstag_LineA_RetreatToB1,
		
	}
	encID_reich_lineA_02:SetGoal(goalData)

end

function Reichstag_LineA_03()

	sg_reich_e_lineA_03 = SGroup_CreateIfNotFound("sg_reich_e_lineA_03")
	
	-- AI
	local encData = {
		name = "Kroll_Entrance_Def",
		player = player2,
		spawn = mkr_reich_e_lineA_03,
		sgroups = {sg_reich_e_lineA_03},
		units = {
			{
				name = "Moltke_SouthDef_01",
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
				spawn = mkr_reich_e_lineA_03_def_s0,
				upgrades = {UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM},
			},
			{
				name = "Moltke_SouthDef_01",
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = mkr_reich_e_lineA_03_def_s1,
				difficulty = {GD_EASY, GD_NORMAL}
			},
			{
				name = "Moltke_SouthDef_01",
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = mkr_reich_e_lineA_03_def_s1,
				upgrades = {UPG.GERMAN.GRENADIER_MG42_LMG},
				difficulty = {GD_HARD},
			},
			{
				name = "Moltke_SouthDef_01",
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = mkr_reich_e_lineA_03_def_s2,
				difficulty = {GD_NORMAL, GD_HARD},
			},
			{
				name = "Moltke_SouthDef_01",
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = mkr_reich_e_lineA_03_def_s3,
				difficulty = {GD_HARD},
			},
		},
	}
	encID_reich_lineA_03 = Encounter:Create(encData)
	
	local goalData = {
		name = "Defend",
		target = mkr_reich_e_lineA_03,
		
		leashRange = 10,
		
		tacticTargetPreference = AITacticTargetPreference_HighDamage,
		
		coordinatedSetup = true,
		
		coordinatedSetupFacingPositions = {
			Util_GetOffsetPosition(mkr_reich_e_lineA_03, OFFSET_FRONT, 100),
		},
		
		tacticControlsList = {
			{
				tacticType = TACTIC_Avoid,
				priority = 900,
				maxUsers = 2,
			},
			{
				tacticType = TACTIC_Cover,
				priority = 500,
			},
			{
				tacticType = TACTIC_Ability,
				priority = 800,
			},
			{
				tacticType = TACTIC_Help,
				priority = -1,
			},
		},
		
		fallbackParams = {
			thresholds = {0.4},
			markers = {mkr_reich_e_lineB_01},
			globalPercentage = 0.6,
			retreat = true,
		},
		
		onTransition = Reichstag_LineA_RetreatToB1,
		
	}
	encID_reich_lineA_03:SetGoal(goalData)

end

function Reichstag_LineA_04()

	sg_reich_e_lineA_04 = SGroup_CreateIfNotFound("sg_reich_e_lineA_04")
	
	-- AI
	local encData = {
		name = "Kroll_Entrance_Def_LineA4",
		player = player2,
		spawn = mkr_reich_e_lineA_04,
		sgroups = {sg_reich_e_lineA_04},
		units = {
			{
				name = "Moltke_SouthDef_01",
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = mkr_reich_e_lineA_04_def_s0,
				difficulty = {GD_EASY, GD_NORMAL},
			},
			{
				name = "Moltke_SouthDef_01",
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = mkr_reich_e_lineA_04_def_s0,
				upgrades = {UPG.GERMAN.GRENADIER_MG42_LMG},
				difficulty = {GD_HARD},
			},
			{
				name = "Moltke_SouthDef_01",
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
				spawn = mkr_reich_e_lineA_04_def_s2,
				upgrades = {UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM, UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM_SECOND},
			},
		},
	}
	encID_reich_lineA_04 = Encounter:Create(encData)
	
	local goalData = {
		name = "Defend",
		target = mkr_reich_e_lineA_04,
		
		leashRange = 10,
		
		tacticTargetPreference = AITacticTargetPreference_HighDamage,
		
		coordinatedSetup = true,
		
		coordinatedSetupFacingPositions = {
			Util_GetOffsetPosition(mkr_reich_e_lineA_04, OFFSET_FRONT, 100),
		},
		
		tacticControlsList = {
			{
				tacticType = TACTIC_Avoid,
				priority = 900,
				maxUsers = 2,
			},
			{
				tacticType = TACTIC_Cover,
				priority = 500,
			},
			{
				tacticType = TACTIC_Ability,
				priority = 800,
			},
			{
				tacticType = TACTIC_Help,
				priority = -1,
			},
		},
		
		fallbackParams = {
			thresholds = {0.4},
			markers = {mkr_reich_e_lineB_02},
			globalPercentage = 0.6,
			retreat = true,
		},
		
		onTransition = Reichstag_LineA_RetreatToB2,
		
	}
	encID_reich_lineA_04:SetGoal(goalData)

end

function Reichstag_LineA_05()

	sg_reich_e_lineA_05 = SGroup_CreateIfNotFound("sg_reich_e_lineA_05")
	
	-- AI
	local encData = {
		name = "Kroll_Entrance_Def_LineA5",
		player = player2,
		spawn = mkr_reich_e_lineA_05,
		sgroups = {sg_reich_e_lineA_05},
		units = {
			{
				name = "Moltke_SouthDef_01",
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
				spawn = mkr_reich_e_lineA_05_def_s0,
				difficulty = {GD_EASY, GD_NORMAL},
			},
			{
				name = "Moltke_SouthDef_01",
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
				spawn = mkr_reich_e_lineA_05_def_s0,
				difficulty = {GD_HARD},
				upgrades = {UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM},
			},
			{
				name = "Moltke_SouthDef_01",
				sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
				spawn = mkr_reich_e_lineA_05_def_s1,
			},
			{
				name = "Moltke_SouthDef_01",
				sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
				spawn = mkr_reich_e_lineA_04_def_s1,
			},
		},
	}
	encID_reich_lineA_05 = Encounter:Create(encData)
	
	local goalData = {
		name = "Defend",
		target = mkr_reich_e_lineA_05,
		
		leashRange = 10,
		
		tacticTargetPreference = AITacticTargetPreference_HighDamage,
		
		coordinatedSetup = true,
		
		coordinatedSetupFacingPositions = {
			Util_GetOffsetPosition(mkr_reich_e_lineA_05, OFFSET_FRONT, 100),
		},
		
		tacticControlsList = {
			{
				tacticType = TACTIC_Avoid,
				priority = 900,
				maxUsers = 2,
			},
			{
				tacticType = TACTIC_Cover,
				priority = 500,
			},
			{
				tacticType = TACTIC_Ability,
				priority = 800,
			},
			{
				tacticType = TACTIC_Help,
				priority = -1,
			},
		},
		
		fallbackParams = {
			thresholds = {0.4},
			markers = {mkr_reich_e_lineB_02},
			globalPercentage = 0.6,
			retreat = true,
		},
		
		onTransition = Reichstag_LineA_RetreatToB2,
		
	}
	encID_reich_lineA_05:SetGoal(goalData)

end


function Reichstag_LineA_RetreatToB1(encounter, state)
	
	if state == AIObjectiveStage_Fallback then
		encounter:Disable()
		encID_reich_lineB_01:AddSgroup(encounter.sgroup)
	end
	
end
function Reichstag_LineA_RetreatToB2(encounter, state)
	
	if state == AIObjectiveStage_Fallback then
		encounter:Disable()
		encID_reich_lineB_02:AddSgroup(encounter.sgroup)
	end
	
end


function Reichstag_LineB_01()

	sg_reich_e_lineB_01 = SGroup_CreateIfNotFound("sg_reich_e_lineB_01")
	
	-- AI
	local encData = {
		name = "Kroll_Entrance_Def",
		player = player2,
		spawn = mkr_reich_e_lineB_01,
		sgroups = {sg_reich_e_lineB_01},
		units = {
			{
				name = "Moltke_SouthDef_01",
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = mkr_reich_e_lineB_01_def_s0,
				load = 4,
			},
			{
				name = "Moltke_SouthDef_01",
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = mkr_reich_e_lineB_01_def_s1,
				upgrades = {UPG.GERMAN.GRENADIER_MG42_LMG},
				difficulty = {GD_EASY, GD_NORMAL},
				load = 4,
			},
			{
				name = "Moltke_SouthDef_01",
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
				spawn = mkr_reich_e_lineB_01_def_s1,
				upgrades = {UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM},
				difficulty = {GD_HARD},
				load = 4,
			},
			{
				name = "Moltke_SouthDef_01",
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
				spawn = mkr_reich_e_lineB_01_def_s2,
			},
			{
				name = "Moltke_SouthDef_01",
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
				spawn = mkr_reich_e_lineB_01_def_s3,
				upgrades = {UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM},
			},
		},
	}
	encID_reich_lineB_01 = Encounter:Create(encData)
	
	local goalData = {
		name = "Defend",
		target = mkr_reich_e_lineB_01,
		
		leashRange = 10,
		
		tacticTargetPreference = AITacticTargetPreference_HighDamage,
		
		coordinatedSetup = true,
		
		coordinatedSetupFacingPositions = {
			Util_GetOffsetPosition(mkr_reich_e_lineB_01, OFFSET_FRONT, 100),
		},
		
		tacticControlsList = {
			{
				tacticType = TACTIC_Avoid,
				priority = 900,
				maxUsers = 2,
			},
			{
				tacticType = TACTIC_Cover,
				priority = 500,
			},
			{
				tacticType = TACTIC_Ability,
				priority = 800,
			},
			{
				tacticType = TACTIC_Help,
				priority = -1,
			},
		}
	}
	encID_reich_lineB_01:SetGoal(goalData)

end

function Reichstag_LineB_02()

	sg_reich_e_lineB_02 = SGroup_CreateIfNotFound("sg_reich_e_lineB_02")
	
	-- AI
	local encData = {
		name = "Kroll_Entrance_Def",
		player = player2,
		spawn = mkr_reich_e_lineB_02,
		sgroups = {sg_reich_e_lineB_02},
		units = {
			{
				name = "Moltke_SouthDef_01",
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = mkr_reich_e_lineB_02_def_s0,
				upgrades = {UPG.GERMAN.GRENADIER_MG42_LMG},
				load = 4,
			},
			{
				name = "Moltke_SouthDef_01",
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
				spawn = mkr_reich_e_lineB_02_def_s1,
				difficulty = {GD_EASY, GD_NORMAL},
				load = 4,
			},
			{
				name = "Moltke_SouthDef_01",
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
				spawn = mkr_reich_e_lineB_02_def_s1,
				upgrades = {UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM},
				difficulty = {GD_HARD},
				load = 4,
			},
			{
				name = "Moltke_SouthDef_01",
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = mkr_reich_e_lineB_02_def_s2,
			},
		},
	}
	encID_reich_lineB_02 = Encounter:Create(encData)
	
	local goalData = {
		name = "Defend",
		target = mkr_reich_e_lineB_02,
		
		leashRange = 10,
		
		tacticTargetPreference = AITacticTargetPreference_HighDamage,
		
		coordinatedSetup = true,
		
		coordinatedSetupFacingPositions = {
			Util_GetOffsetPosition(mkr_reich_e_lineB_02, OFFSET_FRONT, 100),
		},
		
		tacticControlsList = {
			{
				tacticType = TACTIC_Avoid,
				priority = 900,
				maxUsers = 2,
			},
			{
				tacticType = TACTIC_Cover,
				priority = 500,
			},
			{
				tacticType = TACTIC_Ability,
				priority = 800,
			},
			{
				tacticType = TACTIC_Help,
				priority = -1,
			},
		}
	}
	encID_reich_lineB_02:SetGoal(goalData)

end

function Reichstag_Refresh_Defenders()

	sg_reich_south_corner_all = SGroup_CreateIfNotFound("sg_reich_south_corner_all")
	sg_reich_north_corner_all = SGroup_CreateIfNotFound("sg_reich_north_corner_all")
	sg_reich_east_01_all = SGroup_CreateIfNotFound("sg_reich_east_01_all")
	sg_reich_east_02_all = SGroup_CreateIfNotFound("sg_reich_east_02_all")
	sg_reich_mainEntrance_all = SGroup_CreateIfNotFound("sg_reich_mainEntrance_all")
	
	if SGroup_TotalMembersCount(sg_reich_south_corner_all) <= 0 then
		Rule_AddOneShot(Reichstag_Refresh_Defenders_A, 5)
	end
	
	if SGroup_TotalMembersCount(sg_reich_north_corner_all) <= 0 then
		Rule_AddOneShot(Reichstag_Refresh_Defenders_B, 5)
	end
	
	if SGroup_TotalMembersCount(sg_reich_east_01_all) <= 0 then
		Rule_AddOneShot(Reichstag_Refresh_Defenders_C, 5)
	end
	
	if SGroup_TotalMembersCount(sg_reich_east_02_all) <= 0 then
		Rule_AddOneShot(Reichstag_Refresh_Defenders_D, 5)
	end
	
	if SGroup_TotalMembersCount(sg_reich_mainEntrance_all) <= 0 then
		Rule_AddOneShot(Reichstag_Refresh_Defenders_E, 5)
	end

end
function Reichstag_Refresh_Defenders_A()
	Util_CreateSquads(player2, sg_reich_south_corner_all, SBP.GERMAN.GRENADIER_SQUAD, eg_reichstag_south_corner, nil, 1, 3)
	Util_CreateSquads(player2, sg_reich_south_corner_all, SBP.GERMAN.OSTRUPPEN_SQUAD, eg_reichstag_south_corner, nil, 1, 2)
end
function Reichstag_Refresh_Defenders_B()
	Util_CreateSquads(player2, sg_reich_north_corner_all, SBP.GERMAN.GRENADIER_SQUAD, eg_reichstag_north_corner, nil, 1, 2)
	Util_CreateSquads(player2, sg_reich_north_corner_all, SBP.GERMAN.OSTRUPPEN_SQUAD, eg_reichstag_north_corner, nil, 1, 2)
end
function Reichstag_Refresh_Defenders_C()
	Util_CreateSquads(player2, sg_reich_east_01_all, SBP.GERMAN.OSTRUPPEN_SQUAD, eg_reichstag_east_01, nil, 1, 4)
	Util_CreateSquads(player2, sg_reich_east_01_all, SBP.GERMAN.OSTRUPPEN_SQUAD, eg_reichstag_east_01, nil, 1, 3)
end
function Reichstag_Refresh_Defenders_D()
	Util_CreateSquads(player2, sg_reich_east_02_all, SBP.GERMAN.GRENADIER_SQUAD, eg_reichstag_east_02, nil, 1, 3)
	Util_CreateSquads(player2, sg_reich_east_02_all, SBP.GERMAN.OSTRUPPEN_SQUAD, eg_reichstag_east_02, nil, 1, 3)
end
function Reichstag_Refresh_Defenders_E()
	Util_CreateSquads(player2, sg_reich_mainEntrance_all, SBP.GERMAN.OSTRUPPEN_SQUAD, eg_reichstag_entrance, nil, 1, 3)
end







function _reichstag_Init_Tigers()
	
	if Player_GetStrategicPointCaptureProgress(player1, EGroup_GetSpawnedEntityAt(eg_reichstag_cp, 1)) >= -0.75 then
		Rule_RemoveMe()
		
		sg_reich_e_tiger_both = SGroup_CreateIfNotFound("sg_reich_e_tiger_both")
		
		sg_reich_e_tiger_01 = SGroup_CreateIfNotFound("sg_reich_e_tiger_01")
		
		-- AI
		local encData = {
			name = "Kroll_Entrance_Def",
			player = player2,
			spawn = mkr_reich_e_tigerSpawn_01,
			sgroups = {sg_reich_e_tiger_01, sg_reich_e_tiger_both},
			units = {
				{
					name = "Moltke_SouthDef_01",
					sbp = SBP.GERMAN.TIGER_SQUAD,
				},
			},
		}
		encID_reich_tiger_01 = Encounter:Create(encData)
		
		local goalData = {
			name = "Attack",
			target = mkr_reich_e_tiger_01,
			
			leashRange = 26,
			range = 80,
			
			tacticTargetPreference = AITacticTargetPreference_HighDamage,
			
			tacticControlsList = {
				{
					tacticType = TACTIC_Avoid,
					priority = -1,
				},
				{
					tacticType = TACTIC_Vehicle,
					priority = 900,
				},
				{
					tacticType = TACTIC_Ability,
					priority = 800,
				},
				{
					tacticType = TACTIC_Help,
					priority = -1,
				},
			}
		}
		encID_reich_tiger_01:SetGoal(goalData)
		
		-- Tiger 02
		sg_reich_e_tiger_02 = SGroup_CreateIfNotFound("sg_reich_e_tiger_02")
		
		-- AI
		local encData = {
			name = "Kroll_Entrance_Def",
			player = player2,
			spawn = mkr_reich_e_tigerSpawn_02,
			sgroups = {sg_reich_e_tiger_02, sg_reich_e_tiger_both},
			units = {
				{
					name = "Moltke_SouthDef_01",
					sbp = SBP.GERMAN.TIGER_SQUAD,
				},
			},
		}
		encID_reich_tiger_02 = Encounter:Create(encData)
		
		local goalData = {
			name = "Attack",
			target = mkr_reich_e_tiger_02,
			
			leashRange = 26,
			range = 80,
			
			tacticTargetPreference = AITacticTargetPreference_HighDamage,
			
			coordinatedSetup = true,
			
			tacticControlsList = {
				{
					tacticType = TACTIC_Avoid,
					priority = -1,
				},
				{
					tacticType = TACTIC_Vehicle,
					priority = 900,
				},
				{
					tacticType = TACTIC_Ability,
					priority = 800,
				},
				{
					tacticType = TACTIC_Help,
					priority = -1,
				},
			}
		}
		encID_reich_tiger_02:SetGoal(goalData)
	end

end

----------------------------
-- SECONDARY OBJ
-- HOWITZERS
----------------------------
-- || INIT FUNCTIONS ||
function BONUS_Init_Objective()

	OBJ_Howitzers = {
		
		SetupUI = function() 
			Objective_SetCounter(OBJ_Howitzers, 1, 4)
		end,
		
		OnStart = function()
			Rule_AddOneShot(_Howitzers_No_Ammo, 5)
			
			-- Start Checks
			if SGroup_IsEmpty(sg_BONUS_e_howitzer_01) == false or SGroup_IsRetreating(sg_BONUS_e_howitzer_01, ANY) == true then
				if Player_CanSeeSGroup(player1, sg_BONUS_e_howitzer_01, ANY) then
					hpid_bonus_01 = Objective_AddUIElements(OBJ_Howitzers, sg_BONUS_e_howitzer_01, true, 11046975, true, 2)
					Event_GroupIsDead(EventHandler_RemoveObjectiveUI, {objective = OBJ_Howitzers, element = hpid_bonus_01}, sg_BONUS_e_howitzer_01, nil, true)
				else
					Event_PlayerCanSeeElement(_Howitzer_Mark_01, nil, player1, sg_BONUS_e_howitzer_01, ANY, 2)
				end
				
				Event_GroupIsDead(_Howitzer_Dead, nil, sg_BONUS_e_howitzer_01, 2, true)
			end
			
			if SGroup_IsEmpty(sg_BONUS_e_howitzer_02) == false or SGroup_IsRetreating(sg_BONUS_e_howitzer_02, ANY) == true then
				if Player_CanSeeSGroup(player1, sg_BONUS_e_howitzer_02, ANY) then
					hpid_bonus_02 = Objective_AddUIElements(OBJ_Howitzers, sg_BONUS_e_howitzer_02, true, 11046975, true, 2)
					Event_GroupIsDead(EventHandler_RemoveObjectiveUI, {objective = OBJ_Howitzers, element = hpid_bonus_02}, sg_BONUS_e_howitzer_02, nil, true)
				else
					Event_PlayerCanSeeElement(_Howitzer_Mark_02, nil, player1, sg_BONUS_e_howitzer_02, ANY, 2)
				end
				
				Event_GroupIsDead(_Howitzer_Dead, nil, sg_BONUS_e_howitzer_02, 2, true)
			end
			
			if SGroup_IsEmpty(sg_BONUS_e_howitzer_03) == false or SGroup_IsRetreating(sg_BONUS_e_howitzer_03, ANY) == true then
				if Player_CanSeeSGroup(player1, sg_BONUS_e_howitzer_03, ANY) then
					hpid_bonus_03 = Objective_AddUIElements(OBJ_Howitzers, sg_BONUS_e_howitzer_03, true, 11046975, true, 2)
					Event_GroupIsDead(EventHandler_RemoveObjectiveUI, {objective = OBJ_Howitzers, element = hpid_bonus_03}, sg_BONUS_e_howitzer_03, nil, true)
				else
					Event_PlayerCanSeeElement(_Howitzer_Mark_03, nil, player1, sg_BONUS_e_howitzer_03, ANY, 2)
				end
				
				Event_GroupIsDead(_Howitzer_Dead, nil, sg_BONUS_e_howitzer_03, 2, true)
			end
			
			if SGroup_IsEmpty(sg_BONUS_e_howitzer_04) == false or SGroup_IsRetreating(sg_BONUS_e_howitzer_04, ANY) == true then
				if Player_CanSeeSGroup(player1, sg_BONUS_e_howitzer_04, ANY) then
					hpid_bonus_04 = Objective_AddUIElements(OBJ_Howitzers, sg_BONUS_e_howitzer_04, true, 11046975, true, 2)
					Event_GroupIsDead(EventHandler_RemoveObjectiveUI, {objective = OBJ_Howitzers, element = hpid_bonus_04}, sg_BONUS_e_howitzer_04, nil, true)
				else
					Event_PlayerCanSeeElement(_Howitzer_Mark_04, nil, player1, sg_BONUS_e_howitzer_04, ANY, 2)
				end
				
				Event_GroupIsDead(_Howitzer_Dead, nil, sg_BONUS_e_howitzer_04, 2, true)
			end
		end,
		
		OnComplete = function()
			Scar_CompleteIntelBulletinTask(player1, "camp14_reichstag_howitzers")
			
			Rule_Remove(_Howitzer_FireAll)
		end,
		
		OnFail = function()
			
		end,
		
		IsComplete = function()
			return false
		end,
		
		Intel_Start = EVENTS.HOWITZERS_START,				-- Event will play when obj starts but before any UI appears
		Intel_Complete = nil,			-- Event will play when obj completes but before UI is cleared
		Intel_Fail = nil,				-- Event will play when obj fails but before UI is cleared
		Title = 11046975,				-- LOCDB [11046975] 'Disable German Howitzers'
		Type = OT_Secondary,				-- Objective Type (OT_Primary, OT_Secondary)
	}
	
	Objective_Register(OBJ_Howitzers)
end
--|| OBJECTIVE FUNCTIONS ||
function Howitzers_Start_Check()

	if Event_Exists(_eventID_howitzer01_dead) then Event_Remove(_eventID_howitzer01_dead) end
	if Event_Exists(_eventID_howitzer02_dead) then Event_Remove(_eventID_howitzer02_dead) end
	if Event_Exists(_eventID_howitzer03_dead) then Event_Remove(_eventID_howitzer03_dead) end
	if Event_Exists(_eventID_howitzer04_dead) then Event_Remove(_eventID_howitzer04_dead) end
	
	Objective_Start(OBJ_Howitzers)

end

function Howitzers_End()

	Objective_Complete(OBJ_Howitzers)

end

--|| BEAT FUNCTIONS ||
function Howitzers_Init()

	_eventID_howitzer01_dead = Event_GroupIsDead(Howitzers_Start_Check, nil, sg_BONUS_e_howitzer_01, 3, true)
	_eventID_howitzer02_dead = Event_GroupIsDead(Howitzers_Start_Check, nil, sg_BONUS_e_howitzer_02, 3, true)
	_eventID_howitzer03_dead = Event_GroupIsDead(Howitzers_Start_Check, nil, sg_BONUS_e_howitzer_03, 3, true)
	_eventID_howitzer04_dead = Event_GroupIsDead(Howitzers_Start_Check, nil, sg_BONUS_e_howitzer_04, 3, true)

end

function _Howitzers_No_Ammo()

	Util_StartIntel(EVENTS.HOWITZERS_NO_AMMO)

end

function _Howitzer_Mark_01()

	Util_StartIntel(EVENTS.HOWITZERS_GUN_FOUND_01)
	
	hpid_bonus_01 = Objective_AddUIElements(OBJ_Howitzers, sg_BONUS_e_howitzer_01, true, 11046975, true, 2)
	Event_GroupIsDead(EventHandler_RemoveObjectiveUI, {objective = OBJ_Howitzers, element = hpid_bonus_01}, sg_BONUS_e_howitzer_01, nil, true)
	
end

function _Howitzer_Mark_02()

	Util_StartIntel(EVENTS.HOWITZERS_GUN_FOUND_02)
	
	hpid_bonus_02 = Objective_AddUIElements(OBJ_Howitzers, sg_BONUS_e_howitzer_02, true, 11046975, true, 2)
	Event_GroupIsDead(EventHandler_RemoveObjectiveUI, {objective = OBJ_Howitzers, element = hpid_bonus_02}, sg_BONUS_e_howitzer_02, nil, true)

end

function _Howitzer_Mark_03()

	Util_StartIntel(EVENTS.HOWITZERS_GUN_FOUND_03)
	
	hpid_bonus_03 = Objective_AddUIElements(OBJ_Howitzers, sg_BONUS_e_howitzer_03, true, 11046975, true, 2)
	Event_GroupIsDead(EventHandler_RemoveObjectiveUI, {objective = OBJ_Howitzers, element = hpid_bonus_03}, sg_BONUS_e_howitzer_03, nil, true)

end

function _Howitzer_Mark_04()

	Util_StartIntel(EVENTS.HOWITZERS_GUN_FOUND_04)
	
	hpid_bonus_04 = Objective_AddUIElements(OBJ_Howitzers, sg_BONUS_e_howitzer_04, true, 11046975, true, 2)
	Event_GroupIsDead(EventHandler_RemoveObjectiveUI, {objective = OBJ_Howitzers, element = hpid_bonus_04}, sg_BONUS_e_howitzer_04, nil, true)

end

-- Util_CreateSquads(player1, sg_temp, BP_GetSquadBlueprint("howitzer_105mm_dummy_squad"), mkr_moltke_weaponSup_rally)
function _Howitzer_Dead()
	
	if Objective_IsStarted(OBJ_Howitzers) == true and Objective_IsComplete(OBJ_Howitzers) == false then
		
		Objective_SetCounter(OBJ_Howitzers, (Objective_GetCounter(OBJ_Howitzers)+1), 4)
		
		if Objective_GetCounter(OBJ_Howitzers) == 2 then
			Util_StartIntel(EVENTS.HOWITZERS_GUN_DEAD_01)
		elseif Objective_GetCounter(OBJ_Howitzers) == 3 then
			Util_StartIntel(EVENTS.HOWITZERS_GUN_DEAD_02)
		elseif Objective_GetCounter(OBJ_Howitzers) == 4 then
			Rule_AddOneShot(Howitzers_End, 2)
		end
		
	end
	
end



function _Howitzer_FireAll()

	if (SGroup_IsEmpty(sg_BONUS_e_howitzer_01) == false and SGroup_IsRetreating(sg_BONUS_e_howitzer_01, ALL) == false)
	  and Player_CanSeeSGroup(player1, sg_BONUS_e_howitzer_01, ANY) and SGroup_HasTeamWeapon(sg_BONUS_e_howitzer_01, ANY) == true then
		Cmd_Ability(sg_BONUS_e_howitzer_01, BP_GetAbilityBlueprint("howitzer_105mm_dummy"), mkr_BONUS_e_howitzer01_tar, nil, true)
	end
	
	if (SGroup_IsEmpty(sg_BONUS_e_howitzer_02) == false and SGroup_IsRetreating(sg_BONUS_e_howitzer_02, ALL) == false)
	  and Player_CanSeeSGroup(player1, sg_BONUS_e_howitzer_02, ANY) and SGroup_HasTeamWeapon(sg_BONUS_e_howitzer_02, ANY) == true then
		Cmd_Ability(sg_BONUS_e_howitzer_02, BP_GetAbilityBlueprint("howitzer_105mm_dummy"), mkr_BONUS_e_howitzer02_tar, nil, true)
	end
	
	if (SGroup_IsEmpty(sg_BONUS_e_howitzer_03) == false and SGroup_IsRetreating(sg_BONUS_e_howitzer_03, ALL) == false)
	  and Player_CanSeeSGroup(player1, sg_BONUS_e_howitzer_03, ANY) and SGroup_HasTeamWeapon(sg_BONUS_e_howitzer_03, ANY) == true then
		Cmd_Ability(sg_BONUS_e_howitzer_03, BP_GetAbilityBlueprint("howitzer_105mm_dummy"), mkr_BONUS_e_howitzer03_tar, nil, true)
	end
	
	if (SGroup_IsEmpty(sg_BONUS_e_howitzer_04) == false and SGroup_IsRetreating(sg_BONUS_e_howitzer_04, ALL) == false)
	  and Player_CanSeeSGroup(player1, sg_BONUS_e_howitzer_04, ANY) and SGroup_HasTeamWeapon(sg_BONUS_e_howitzer_04, ANY) == true then
		Cmd_Ability(sg_BONUS_e_howitzer_04, BP_GetAbilityBlueprint("howitzer_105mm_dummy"), mkr_BONUS_e_howitzer04_tar, nil, true)
	end
	
end

--|| BEAT ENCOUNTERS ||
function Howitzers_Encs_Init()

	Howitzers_Encs_01()
	Howitzers_Encs_02()
	Howitzers_Encs_03()
	Howitzers_Encs_04()
	
	Rule_AddInterval(_Howitzer_FireAll, 5)

end

function Howitzers_Encs_01()

	sg_BONUS_e_howitzer_01 = SGroup_CreateIfNotFound("sg_BONUS_e_howitzer_01")
	
	Util_CreateSquads(player2, sg_BONUS_e_howitzer_01, BP_GetSquadBlueprint("howitzer_105mm_dummy_squad"), mkr_BONUS_e_howitzer01)
	
	Util_LogSyncWpn(sg_BONUS_e_howitzer_01, false)
	
	-- AI
	sg_BONUS_e_howitzer_01_def = SGroup_CreateIfNotFound("sg_BONUS_e_howitzer_01_def")
	sg_BONUS_e_howitzer_01_def_pak43 = SGroup_CreateIfNotFound("sg_BONUS_e_howitzer_01_def_pak43")
	
	-- AI
	local encData = {
		name = "Reich_Pak43_Def",
		player = player2,
		spawn = mkr_BONUS_e_howitzer01,
		sgroups = {sg_BONUS_e_howitzer_01_def},
		units = {
			{
				name = "Moltke_SouthDef_01",
				sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
				load = 4, 
				spawn = mkr_BONUS_e_howitzer01_s0,
				difficulty = {GD_EASY},
			},
			{
				name = "Moltke_SouthDef_01",
				sbp = SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD,
				load = 4, 
				spawn = mkr_BONUS_e_howitzer01_s0,
				difficulty = {GD_NORMAL, GD_HARD},
			},
			{
				name = "Moltke_SouthDef_02",
				sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
				load = 3,
				spawn = mkr_BONUS_e_howitzer01_s1,
			},
			{
				name = "Moltke_SouthDef_02",
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				upgrades = {UPG.GERMAN.GRENADIER_MG42_LMG},
				load = 3,
				spawn = mkr_BONUS_e_howitzer01_s2,
			},
			{
				name = "Moltke_SouthDef_02",
				sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
				load = 3,
				spawn = mkr_BONUS_e_howitzer01_s3,
				difficulty = {GD_EASY, GD_NORMAL},
			},
			{
				name = "Moltke_SouthDef_02",
				sbp = SBP.GERMAN.STUG_III_SQUAD,
				spawn = mkr_BONUS_e_howitzer01_s3,
				difficulty = {GD_NORMAL},
			},
			{
				name = "Moltke_SouthDef_02",
				sbp = SBP.GERMAN.PAK43_88MM_AT_GUN_SQUAD,
				spawn = mkr_BONUS_e_howitzer01_s3,
				sgroups = {sg_BONUS_e_howitzer_01_def_pak43},
				difficulty = {GD_HARD},
			},
			{
				name = "Moltke_SouthDef_02",
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
				load = 3,
				spawn = mkr_BONUS_e_howitzer01_s4,
			},
		},
	}
	encID_howitzer01_def = Encounter:Create(encData)
	
	local goalData = {
		name = "Defend",
		target = mkr_BONUS_e_howitzer01,
		
		leashRange = 24,
		range = 55,
		
		coordinatedSetup = true,
		
		coordinatedSetupFacingPositions = {
			Util_GetOffsetPosition(mkr_BONUS_e_howitzer01, OFFSET_BACK, 100),
		},
		
		tacticTargetPreference = AITacticTargetPreference_Near,
		
		tacticControlsList = {
			{
				tacticType = TACTIC_Avoid,
				priority = -1,
			},
			{
				tacticType = TACTIC_Cover,
				priority = -1,
			},
			{
				tacticType = TACTIC_Ability,
				priority = 200,
			},
			{
				tacticType = TACTIC_Help,
				priority = -1,
			},
			{
				tacticType = TACTIC_Hold,
				priority = 100,
				maxUsers = 1,
			},
		}
	}
	encID_howitzer01_def:SetGoal(goalData)
	
	if SGroup_IsEmpty(sg_BONUS_e_howitzer_01_def_pak43) == false then 
		Modify_WeaponRange(sg_BONUS_e_howitzer_01_def_pak43, "hardpoint_01", 0.85)
		Event_PlayerCanSeeElement(_Seen_Pak43, {sg_BONUS_e_howitzer_01_def_pak43}, player1, sg_BONUS_e_howitzer_01_def_pak43, nil, 2)
	end

end

function Howitzers_Encs_02()

	sg_BONUS_e_howitzer_02 = SGroup_CreateIfNotFound("sg_BONUS_e_howitzer_02")
	
	Util_CreateSquads(player2, sg_BONUS_e_howitzer_02, BP_GetSquadBlueprint("howitzer_105mm_dummy_squad"), mkr_BONUS_e_howitzer02)
	
	Util_LogSyncWpn(sg_BONUS_e_howitzer_02, false)
	
	-- AI
	sg_BONUS_e_howitzer_02_def = SGroup_CreateIfNotFound("sg_BONUS_e_howitzer_02_def")
	
	-- AI
	local encData = {
		name = "Reich_Pak43_Def",
		player = player2,
		spawn = mkr_BONUS_e_howitzer02,
		sgroups = {sg_BONUS_e_howitzer_02_def},
		units = {
			{
				name = "Moltke_SouthDef_01",
				sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
				load = 4, 
				spawn = mkr_BONUS_e_howitzer02_s0,
			},
			{
				name = "Moltke_SouthDef_02",
				sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
				load = 3,
				spawn = mkr_BONUS_e_howitzer02_s1,
			}, 
		},
	}
	encID_howitzer02_def = Encounter:Create(encData)
	
	local goalData = {
		name = "Defend",
		target = sg_BONUS_e_howitzer_02,
		
		leashRange = 10,
		range = 18,
		
		tacticTargetPreference = AITacticTargetPreference_Near,
		
		tacticControlsList = {
			{
				tacticType = TACTIC_Avoid,
				priority = -1,
			},
			{
				tacticType = TACTIC_Cover,
				priority = -1,
			},
			{
				tacticType = TACTIC_Ability,
				priority = 200,
			},
			{
				tacticType = TACTIC_Help,
				priority = -1,
			},
			{
				tacticType = TACTIC_Hold,
				priority = 100,
				maxUsers = 1,
			},
		}
	}
	encID_howitzer02_def:SetGoal(goalData)

end

function Howitzers_Encs_03()

	sg_BONUS_e_howitzer_03 = SGroup_CreateIfNotFound("sg_BONUS_e_howitzer_03")
	
	Util_CreateSquads(player2, sg_BONUS_e_howitzer_03, BP_GetSquadBlueprint("howitzer_105mm_dummy_squad"), mkr_BONUS_e_howitzer03)
	
	Util_LogSyncWpn(sg_BONUS_e_howitzer_03, false)

end

function Howitzers_Encs_04()

	sg_BONUS_e_howitzer_04 = SGroup_CreateIfNotFound("sg_BONUS_e_howitzer_04")
	
	Util_CreateSquads(player2, sg_BONUS_e_howitzer_04, BP_GetSquadBlueprint("howitzer_105mm_dummy_squad"), mkr_BONUS_e_howitzer04)
	
	Util_LogSyncWpn(sg_BONUS_e_howitzer_04, false)
	
	-- AI
	sg_BONUS_e_howitzer_04_def = SGroup_CreateIfNotFound("sg_BONUS_e_howitzer_04_def")
	
	-- AI
	local encData = {
		name = "Reich_Pak43_Def",
		player = player2,
		spawn = mkr_BONUS_e_howitzer04,
		sgroups = {sg_BONUS_e_howitzer_04_def},
		units = {
			{
				name = "Moltke_SouthDef_01",
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				upgrades = {UPG.GERMAN.GRENADIER_MG42_LMG},
				load = 4, 
				spawn = mkr_BONUS_e_howitzer04_def_s1,
			},
			{
				name = "Moltke_SouthDef_02",
				sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
				load = 3,
				spawn = mkr_BONUS_e_howitzer04_def_s2,
			},
			{
				name = "Moltke_SouthDef_01",
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
				load = 4, 
				upgrades = {UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM, UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM_SECOND},
				spawn = mkr_BONUS_e_howitzer04_def_s3,
				difficulty = {GD_HARD},
			},
		},
	}
	encID_howitzer04_def = Encounter:Create(encData)
	
	local goalData = {
		name = "Defend",
		target = sg_BONUS_e_howitzer_04,
		
		leashRange = 15,
		range = 20,
		
		tacticTargetPreference = AITacticTargetPreference_Near,
		
		tacticControlsList = {
			{
				tacticType = TACTIC_Avoid,
				priority = -1,
			},
			{
				tacticType = TACTIC_Cover,
				priority = -1,
			},
			{
				tacticType = TACTIC_Ability,
				priority = 200,
			},
			{
				tacticType = TACTIC_Help,
				priority = -1,
			},
			{
				tacticType = TACTIC_Hold,
				priority = 100,
				maxUsers = 1,
			},
		}
	}
	encID_howitzer04_def:SetGoal(goalData)

end




-- called when the player first sees the Reichstag building
function _Seen_Reichstag()

	FOW_RevealEGroup(eg_reichstag_all, 0.1)

end





-- called when the player sees a Pak43, and adds a Threat Arrow onto it
function _Seen_Pak43(data)
	
	local sgroup = data[1]
	local threat_id = ThreatArrow_CreateGroup(sgroup) 
	Event_GroupIsDead(_Killed_Pak43, {threat_id}, sgroup, nil, true)
	
end

function _Killed_Pak43(data)
	
	local threat_id = data[1]
	ThreatArrow_DestroyGroup(threat_id)
	
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
	






