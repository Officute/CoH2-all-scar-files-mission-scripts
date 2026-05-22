-------------------------------------------------------------------------
-------------------------------------------------------------------------

-- Company of Heroes 2
-- Mission 7: Shlisselburg
-- Designer: Sacha Narine

-------------------------------------------------------------------------
-------------------------------------------------------------------------

import("ScarUtil.scar")
import("Prototype/DeploymentPoints.scar")
import("Systems/AiManager/ai.scar")
import("Beginner.scar")
import("Order227.scar")
import("Global_Values/CampaignGlobalConstants.scar")

g_useSkirmishAI = true
g_enableExtraIceDamage = true

g_isWinterMap = true

-------------------------------------------------------------------------
-- [[ SETUP ]]
-------------------------------------------------------------------------

function OnGameSetup()
	
	-- Required Players
	player1 = Setup_Player(1, 11048307, "soviet", 1)		-- player1 is always the human player
	player2 = Setup_Player(2, 11048308, "german", 2)		-- player2 is always the AI opponent
	
	-- Optional Players
	player3 = Setup_Player(3, 11048307, "soviet", 1)		-- player3 is always the AI ally
	player4 = Setup_Player(4, 11048306, "soviet", 1)		-- player3 is always the AI ally

end



function OnGameRestore()
	
	-- function takes care of restoring all global mission parameters after a save/load
	player1 = World_GetPlayerAt(1)
	player2 = World_GetPlayerAt(2)
	player3 = World_GetPlayerAt(3)
	EGroup_EnableMinimapIndicator(eg_mm_hide, false)
	UI_SetCPMeterVisibility(true)
	Rule_AddOneShot(M07_OnGameRestore, 1)
	Game_DefaultGameRestore()
end

function M07_OnGameRestore()
	UI_SetCPMeterVisibility(false)
end

function NIS_Init()
	NIS01 = "SP/CoH2_Campaign/M07-Shlisselburg/nis/m07_outro_nislet"
	nis_load(NIS01)
	
	NIS02 = "SP/CoH2_Campaign/M07-Shlisselburg/nis/m07_intro_nislet"
	nis_load(NIS02)
	
	nis_setintransitiontime(0)
	nis_setouttransitiontime(0.5)
end

-- Start up events for intro nislet 
-- Squads running on to the ice. Katyushas and howitzers firing
-- Mortars hit allied squads crossing the river.
function NIS00_Complete()
	g_katyushaIndex = 1
	sg_a_crossRiver = SGroup_CreateIfNotFound("sg_a_crossRiver")
	Rule_AddDelayedInterval(Obj1_AlliesCrossingRiver, 5, 5)
	UI_SetCPMeterVisibility(false)
	Obj1_artyOnIce()
	Obj1_fireKatyushas()
	Rule_AddInterval(Obj1_fireKatyushas, 30)
	Util_StartIntel(EVENTS.NIS00Complete)
	SGroup_SetMoodMode(sg_p_start, MM_ForceTense)
	SGroup_EnableAttention(sg_p_start, false)
	SGroup_EnableAttention(sg_a_start, false)
	g_introAllyIndex = 1
	
	Cmd_SquadPath(sg_a_t34, "riverTank1", true, LOOP_NONE, false, 0)
	Cmd_SquadPath(sg_a_t70, "riverTank2", true, LOOP_NONE, false, 0)
	Rule_AddDelayedInterval(NIS00_moveAllies, 3, 0.8)
	g_preSinkOffset1 = 35
	g_preSinkOffset2 = 35
	Player_AddAbility(player2, BP_GetAbilityBlueprint("mortar_explosion_fx_ice"))
	Rule_AddOneShot(NIS_PreSinkMortars1, 1)
	Rule_AddOneShot(NIS_PreSinkMortars2, 4)
	Rule_AddDelayedInterval(NIS_SinkAllyTank, 11, 1)
	Rule_AddDelayedInterval(NIS_SinkAllyTank2,14, 1)
	g_introMoveIndex = 3
	g_introMoveDest = Marker_GetPosition(mkr_startingDest1)
	Rule_AddDelayedInterval(NIS00_move, 3.5, 0.5)
	modID_sight = Modify_SightRadius(sg_p_start, 2)
	Rule_AddDelayedInterval(NIS00_killFodder, 5, 5)
	Rule_Add(A2M01_MissionStart)
	SGroup_SetInvulnerable(sg_p_start, true)
	Modify_WeaponDamage(sg_a_start, "hardpoint_01", 0.01)
	Modify_ReceivedAccuracy(sg_a_start, 10)
	Game_SubTextFade(11048263, 11048264, 0.5, 4, 0.5)
end

-- Move initial player squads on to the ice
function NIS00_move()
	sg_pstart_temp = SGroup_CreateIfNotFound("sg_pstart_temp")
	SGroup_Clear(sg_pstart_temp)
	SGroup_Add(sg_pstart_temp, SGroup_GetSpawnedSquadAt(sg_p_start, g_introMoveIndex))
	
	local dest = Marker_GetPosition(mkr_startingDest1)
	if g_introMoveIndex == 3 then
		dest = World_Pos(-171, 12, -183)
		g_introMoveIndex = 5
	elseif g_introMoveIndex == 5 then
		dest = World_Pos(-171, 12, -171)
		g_introMoveIndex = 2
	elseif g_introMoveIndex == 2 then
		dest = World_Pos(-169, 12, -194)
		g_introMoveIndex = 4
	elseif g_introMoveIndex == 4 then
		dest = World_Pos(-179, 12, -184)
		g_introMoveIndex = 1
	elseif g_introMoveIndex == 1 then
		dest = World_Pos(-179, 12, -169)
		g_introMoveIndex = 6
	elseif g_introMoveIndex == 6 then
		dest = World_Pos(-177, 12, -194)
		Rule_RemoveMe()
	end
	Cmd_Move(sg_pstart_temp, dest)

end

function NIS00_moveAllies()
	sg_astart_temp = SGroup_CreateIfNotFound("sg_astart_temp")
	SGroup_Clear(sg_astart_temp)
	if SGroup_Count(sg_a_start) >= g_introAllyIndex then
		SGroup_Add(sg_astart_temp, SGroup_GetSpawnedSquadAt(sg_a_start, g_introAllyIndex))
		Cmd_Move(sg_astart_temp, mkr_fodderArtillery)
		g_introAllyIndex = g_introAllyIndex + 1
	else
		Rule_RemoveMe()
	end
end

function NIS00_revertUIMode()
	Game_SetMode(UI_Normal)
	Modifier_Remove(modID_sight)
	Modifier_RemoveAllFromSGroup(sg_p_start)
	Game_SubTextFade(11048263, 11048264, 0, 0, 0)
	SGroup_SetInvulnerable(sg_p_start, false)
	local select = function (gid, idx, sid)
		Misc_SelectSquad(sid, true)
	end
	SGroup_ForEach(sg_p_start, select)
	SGroup_EnableAttention(sg_p_start, true)
	SGroup_EnableAttention(sg_a_start, true)
	SGroup_SetInvulnerable(g_enc_patrols[2].sgroup, false)
end

-- Drop off-map mortars onto allied conscripts crossing the ice
function NIS00_killFodder()
	if SGroup_IsEmpty(sg_a_start) then
		Rule_RemoveMe()
	else
		-- Check that player squads aren't hit by this arty
		local target = Util_GetRandomPosition(SGroup_GetPosition(sg_a_start), 5)
		local player1Squads = Player_GetSquads(player1)
		if not Prox_AreSquadsNearMarker(player1Squads, target, ANY, 15) then
			Cmd_Ability(player2, ABILITY.GLOBAL.SP_SINGLE_SHOT_MORTAR, sg_a_start, nil, true)
		end
	end
end

function NIS_SinkAllyTank()
	if SGroup_IsEmpty(sg_a_t34) then
		Rule_RemoveMe()
	elseif Prox_AreSquadsNearMarker(sg_a_t34, mkr_riverTankDest1, ALL) or SGroup_IsOnScreen(player1, sg_a_t34, ALL, 0.5) or World_GetGameTime() > 45 then
		local pos = Util_GetOffsetPosition(sg_a_t34, OFFSET_FRONT_LEFT, 2)
		Cmd_Ability(player2, BP_GetAbilityBlueprint("mortar_explosion_fx_ice"), pos, nil, true) 
		World_DamageIce(pos, 1.5, 3, 300, 100)
		Rule_RemoveMe()
	end
end

function NIS_SinkAllyTank_instant()
	if not SGroup_IsEmpty(sg_a_t34) then
		local pos = Util_GetOffsetPosition(sg_a_t34, OFFSET_FRONT_LEFT, 2)
		Cmd_Ability(player2, BP_GetAbilityBlueprint("mortar_explosion_fx_ice"), pos, nil, true) 
		World_DamageIce(pos, 1.5, 3, 300, 100)
		Rule_RemoveMe()
	end
end

function NIS_PreSinkMortars1()
	if not SGroup_IsEmpty(sg_a_t34) then
		local pos = Util_GetOffsetPosition(sg_a_t34, OFFSET_FRONT, g_preSinkOffset1)	
		if g_preSinkOffset1 > 16 then
			Cmd_Ability(player2, ABILITY.GLOBAL.SP_SINGLE_SHOT_MORTAR, pos, nil, true)
			g_preSinkOffset1 = g_preSinkOffset1 - 6.5
			Rule_RemoveIfExist(NIS_PreSinkMortars1)
			Rule_AddOneShot(NIS_PreSinkMortars1, 1.5)
		else
			Rule_AddOneShot(NIS_SinkAllyTank_instant, 5.75)
		end
	end
end

function NIS_SinkAllyTank2()
	if SGroup_IsEmpty(sg_a_t70) then
		Rule_RemoveMe()
	elseif Prox_AreSquadsNearMarker(sg_a_t70, mkr_riverTankDest2, ALL) or SGroup_IsOnScreen(player1, sg_a_t70, ALL, 0.5) or World_GetGameTime() > 35 then
		local pos = Util_GetOffsetPosition(sg_a_t70, OFFSET_FRONT_RIGHT, 1)
		Cmd_Ability(player2, BP_GetAbilityBlueprint("mortar_explosion_fx_ice"), pos, nil, true) 
		World_DamageIce(pos, 1.5, 3, 300, 100)
		Rule_RemoveMe()
	end
end

function NIS_PreSinkMortars2()
	if not SGroup_IsEmpty(sg_a_t70) then
		local pos = Util_GetOffsetPosition(sg_a_t70, OFFSET_FRONT, g_preSinkOffset2)
		if g_preSinkOffset1 > 11 then
			Cmd_Ability(player2, ABILITY.GLOBAL.SP_SINGLE_SHOT_MORTAR, pos, nil, true)
			g_preSinkOffset2 = g_preSinkOffset2 - 8
			Rule_RemoveIfExist(NIS_PreSinkMortars2)
			Rule_AddOneShot(NIS_PreSinkMortars2, 1.5)
		end
	end
end

Scar_AddInit(NIS_Init)

-------------------------------------------------------------------------
-- [[ ONINIT ]]
-------------------------------------------------------------------------

function OnInit()
	g_bunkerCount = -1
	
	--[[ PRESET DEBUG CONDITIONS ]]
	A2M01_Debug()
	
	--[[ SET DIFFICULTY ]]
	A2M01_Difficulty()
	
	--[[ SET RESTRICTIONS ]]
	A2M01_Restrictions()
	
	--[[ SET AI ]]
	A2M01_CpuInit()
	
	
	--[[ MISSION PRESETS ]]
	A2M01_MissionPreset()
	
	--[[ REGISTER OBJECTIVES ]]
	Initialize_Objective1()
	Initialize_Objective1A()
	Initialize_Objective1B()
	Initialize_Objective2()
	Initialize_Objective3()
	Initialize_Objective4()
	-- Bonus Objectives
	Initialize_Objective1C()
	Initialize_Objective5()

	
	--[[ GAME START CHECK ]]

	Util_StartNIS(EVENTS.NIS00, nil, nil, nil, nil, nil, true) 

end

Scar_AddInit(OnInit)

function A2M01_Debug()
	
	-- looks for the command line option [-debug]
	if Misc_IsCommandLineOptionSet("debug") then
		g_debug = true
	end

end



function A2M01_Restrictions()

	-- Utilize for setting restrictions on Units, players, etc
	-- eg: Player_SetAbilityAvailability()
	Player_SetEntityProductionAvailability(player1, EBP.SOVIET.TANK_DEPOT, ITEM_REMOVED)
	Player_SetConstructionMenuAvailability(player1, "tp_construction_soviet_engineer", ITEM_LOCKED)
	
	Player_SetSquadProductionAvailability(player1, SBP.SOVIET.T_70M, ITEM_LOCKED)
	Player_SetSquadProductionAvailability(player1, SBP.SOVIET.SU_76M, ITEM_LOCKED)
	Player_SetSquadProductionAvailability(player1, SBP.SOVIET.T_34_76_SQUAD, ITEM_REMOVED)
	Player_SetSquadProductionAvailability(player1, SBP.SOVIET.IS_2, ITEM_REMOVED)
	Player_SetSquadProductionAvailability(player1, SBP.SOVIET.M1942_ZIS_3_76MM_AT_GUN_SQUAD, ITEM_LOCKED)
	Player_SetSquadProductionAvailability(player1, SBP.SOVIET.SHOCK_TROOPS, ITEM_UNLOCKED)
	
	Player_SetPopCapOverride(player1, t_difficulty.popCapOverride1)
	Modify_PlayerResourceCap(player1, RT_Manpower, 1501, MUT_Addition)
	Modify_PlayerResourceCap(player1, RT_Munition, 601, MUT_Addition)
	Modify_PlayerResourceCap(player1, RT_Fuel, 401, MUT_Addition)
	
	Player_SetAbilityAvailability(player4, ABILITY.SOVIET.CONSCRIPT_MOLOTOV_COCKTAIL, ITEM_REMOVED)
	
	Modify_AbilityMaxCastRange(player1, ABILITY.GERMAN.HOWITZER_105MM_BARRAGE_ABILITY, t_difficulty.howitzerNerf)
end



function A2M01_CpuInit()

	-- Utilize for controlling AI functionality
	-- eg: Player_SetResource(player2, RT_Manpower, 1000)
	-- eg: AI_EnableComponent(player2, false, COMPONENT_Attacking)

	Player_CompleteUpgrade(player2, BP_GetUpgradeBlueprint("panzerfaust_slow"))
	
end



function A2M01_Difficulty()

	g_easyDiff = Misc_IsCommandLineOptionSet("easy") or Game_GetSPDifficulty() == GD_EASY
	g_hardDiff = Misc_IsCommandLineOptionSet("hard") or Game_GetSPDifficulty() == GD_HARD

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
	
	t_defaultGoalData_defendHard = {
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
			retryTimeSecs = 5,
			waitTimeSecs = 15,
		},
		{
			tacticType = TACTIC_Vehicle,
			priority = 5,
			retryTimeSecs = 10,
			waitTimeSecs = 20,
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
		-- Mission
		startingRes_Command					= Util_DifVar( {2, 0, 2, 2} ),				-- Starting Command Points
		startingRes_Manpower				= Util_DifVar( {360, 240, 240, 240} ),		-- Starting Manpower
		startingRes_Munitions				= Util_DifVar( {90, 60, 30, 15} ),		-- Starting Munition
		startingRes_Fuel					= Util_DifVar( {75, 50, 25, 0} ),		-- Starting Fuel
		resourceRate_Manpower				= Util_DifVar( {1.2, 1, 1, 1} ),		-- Resource rate modifier for manpower
		resourceRate_Munitions				= Util_DifVar( {1.5, 1, 1, 1} ),
		resourceRate_Fuel					= Util_DifVar( {1.2, 1, 1, 1} ),
		flamePioneerThreshold 			    = Util_DifVar( {9, 11, 13, 13} ),
		popCapOverride1 			    	= Util_DifVar( {75, 65, 50, 50} ),
		popCapOverride2 			    	= Util_DifVar( {125, 100, 75, 75} ),
		popCapOverride3 			    	= Util_DifVar( {150, 125, 100, 100} ),
		howitzerNerf			    		= Util_DifVar( {1, 0.667, 0.5, 0.5} ),
		veterancyRank						= Util_DifVar( {0, 1, 2, 3} ),
		-- 
		defaultAttackGoalData 					= Util_DifVar( {t_defaultGoalData_attackEasy, t_defaultGoalData_attackNormal, t_defaultGoalData_attackHard, {}}),
		defaultDefendGoalData 					= Util_DifVar( {t_defaultGoalData_defendEasy, t_defaultGoalData_defendNormal, t_defaultGoalData_defendHard, {}}),
		modifyAttackGoalData					= Util_DifVar( {t_goalData_attackEasy, {}, t_goalData_attackHard, {}}),
		modifyDefendGoalData					= Util_DifVar( {t_goalData_defendEasy, {}, t_goalData_defendHard, {}}),
	}
	
	AIAttackGoal_AdjustDefaultGoalData(t_difficulty.defaultAttackGoalData)
	AIDefendGoal_AdjustDefaultGoalData(t_difficulty.defaultDefendGoalData)	
	
	AIAttackGoal_SetModifyGoalData(t_difficulty.modifyAttackGoalData)
	AIDefendGoal_SetModifyGoalData(t_difficulty.modifyDefendGoalData)
	
	Modify_ProjectileDelayTime(player2, BP_GetEntityBlueprint("bundled_stielgranate_campaign"), CAMPAIGN_PGREN_BUNDLED_TIMER)
	
end

-------------------------------------------------------------------------
-- MISSION Preset 
-------------------------------------------------------------------------

function A2M01_MissionPreset()

 -- Player Starting Squads 
 
 	sg_p_com = SGroup_CreateIfNotFound("sg_p_com")
	sg_p_all = SGroup_CreateIfNotFound("sg_p_all")
	sg_p_islandSquad = SGroup_CreateIfNotFound("sg_p_islandSquad")
	sg_a_all = SGroup_CreateIfNotFound("sg_a_all")
	sg_a_single = SGroup_CreateIfNotFound("sg_a_single")
	sg_su76 = SGroup_CreateIfNotFound("sg_su76")
	sg_e_sw = SGroup_CreateIfNotFound("sg_e_sw")
	sg_mergehints = SGroup_CreateIfNotFound("sg_mergehints")
	sg_reinforcehints = SGroup_CreateIfNotFound("sg_reinforcehints")
	eg_reinforcehints = EGroup_CreateIfNotFound("eg_reinforcehints")
	sg_e_final= SGroup_CreateIfNotFound("sg_e_final")
	sg_e_westernLine = SGroup_CreateIfNotFound("sg_e_westernLine")
	sg_e_builtInfantry = SGroup_CreateIfNotFound("sg_e_builtInfantry")
	sg_e_builtAT = SGroup_CreateIfNotFound("sg_e_builtAT")
	
	Obj1_spawnKatyushas()
	Obj1_alliesInTrenches()
	A2M01_SetupEnemies()
	
	Player_SetResource(player1, RT_Manpower, t_difficulty.startingRes_Manpower)
	Player_SetResource(player1, RT_Munition, t_difficulty.startingRes_Munitions)
	Player_SetResource(player1, RT_Fuel, t_difficulty.startingRes_Fuel)
	
	Modify_PlayerResourceRate(player1, RT_Manpower, t_difficulty.resourceRate_Manpower)
	Modify_PlayerResourceRate(player1, RT_Munition, t_difficulty.resourceRate_Munitions)
	Modify_PlayerResourceRate(player1, RT_Fuel, t_difficulty.resourceRate_Fuel)
	
	if g_easyDiff then 
		Modify_Upkeep(player1, 0.5)
	end
	
	EGroup_SetInvulnerable(eg_trainStation, true)
	EGroup_SetInvulnerable(eg_powerPlant, true)
	local setInv = function(gid, idx, entity)
		Entity_SetInvulnerableMinCap(entity, 0.6, 0)
	end
	EGroup_ForEach(eg_germanBarracks, setInv)
	EGroup_SetSelectable(eg_germanBarracks, false)
	EGroup_SetAvgHealth(eg_barge, 0.1)
	EGroup_SetInvulnerable(eg_barge, 0.1)
	EGroup_DeSpawn(eg_flag)
	
	SGroup_SetSelectable(sg_a_howitzer, false)
	SGroup_SetSelectable(sg_a_t34, false)
	
	-- Minimap
	EGroup_EnableMinimapIndicator(eg_mm_hide, false)
	Modify_SightRadius(eg_mm_hide, 0)
	EGroup_EnableMinimapIndicator(eg_mm_unlock1, false)
	EGroup_EnableMinimapIndicator(eg_mm_unlock2, false)

	if EGroup_Exists("eg_allTeamWeapons") then
		Cmd_CriticalHit(player1, eg_allTeamWeapons, CRIT.VEHICLE_ABANDON, 0)
	end
	
	if SGroup_Exists("sg_a_t34") then
		Modify_UnitSpeed(sg_a_t34, 0.4)
	end
	if SGroup_Exists("sg_a_t70") then
		Modify_UnitSpeed(sg_a_t70, 0.4)
	end
	
	-- Default Player Upgrades
	Player_AddAbility(player1, ABILITY.SOVIET.BASE_CONSCRIPT_DISPATCH)
	Player_AddAbility(player1, BP_GetAbilityBlueprint("frontoviki_conscript_dispatch"))
	Player_AddAbility(player1, ABILITY.SOVIET.PENAL_TROOP_DISPATCH_SP)
	Player_AddAbility(player1, ABILITY.GLOBAL.TRANSFER_ORDERS)
	Player_AddAbility(player2, ABILITY.GLOBAL.OFF_MAP_ARTY_SINGLE_SHOT_INSTANT)
	Player_AddAbility(player2, ABILITY.GLOBAL.SP_SINGLE_SHOT_MORTAR)
	Player_AddAbility(player2, ABILITY.GLOBAL.OFF_MAP_ARTILLERY_PERCISE)
	
	
	-- Commander Abilities
	Player_CompleteUpgrade(player1, UPG.SOVIET.HM120_MORTAR_UNLOCK)
	Player_CompleteUpgrade(player1, UPG.SOVIET.SHOCK_TROOPS)
	
	Player_SetAbilityAvailability(player1, ABILITY.SOVIET.CONSCRIPT_OORAH, ITEM_UNLOCKED)
	Player_CompleteUpgrade(player1, BP_GetUpgradeBlueprint("upgrade\\campaign\\disable_vehicle_criticals"))
	Player_CompleteUpgrade(player3, BP_GetUpgradeBlueprint("upgrade\\campaign\\disable_abandon_critical"))
	Player_CompleteUpgrade(player3, BP_GetUpgradeBlueprint("upgrade\\campaign\\disable_vehicle_criticals"))
	Player_SetAbilityAvailability(player1, BP_GetAbilityBlueprint("cmd_shock_troops"), ITEM_REMOVED)
	Player_SetAbilityAvailability(player1, BP_GetAbilityBlueprint("cmd_120mm_mortar_crew"), ITEM_REMOVED)
	Player_AddUnspentCommandPoints(player1, 17)
	
	World_SetIceHealingRate(.005)
	Camera_ResetToDefault()
	Camera_SetDeclination(0.6)
	Camera_SetOrbit(-0.5)
	Camera_FocusOnPosition(Marker_GetPosition(mkr_playerStart), false)
	Game_ScreenFade(0, 0, 0, 255, 0)
	
	-- Bridges
	EGroup_SetSelectable(eg_bridge_small, false)
	EGroup_SetSelectable(eg_bridge_large, false)
	Modify_ReceivedDamage(eg_bridge_large, 0.5)
	
	--227
	UI_SetSoviet227Visibility(true)
	Order227_Init(75, 8)
	ConscriptProgression_AudioInit()
	
end

-------------------------------------------------------------------------
-- MISSION START 
-------------------------------------------------------------------------

function A2M01_MissionStart()

	if Event_IsAnyRunning() == false then
		
		-- update the group that contains the HQ to provide reinforce hints at
		EGroup_Clear(eg_reinforcehints)
		EGroup_AddEGroup(eg_reinforcehints, eg_p_startingBase)
		EGroup_Filter(eg_reinforcehints, EBP.SOVIET.HQ, FILTER_KEEP)
		
		-- hints about merging into damaged squads and reinforcing from halftracks and HQs
		A2M01_UpdateHintGroups()
		BeginnerHint_AddOpportunity(sg_mergehints, HINT_MERGE, true)
		BeginnerHint_AddOpportunity(sg_reinforcehints, HINT_REINFORCE, true)
		Rule_AddInterval(A2M01_UpdateHintGroups, 30)
		
		-- delay first objective
		Rule_AddOneShot(A2M01_DelayObjTitle, 1)
		
		Rule_RemoveMe()
	end
end

function A2M01_DelayObjTitle()
	Objective_Start(OBJ_River)
end

function A2M01_UpdateHintGroups()

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

-------------------- OBJECTIVE 1: Cross the river, destroy a howitzer, and capture a territory --------------------

function Initialize_Objective1()

	OBJ_River = {
		
		SetupUI = function() 
			-- Use for creating any hint points or UI Elements
			-- eg: Objective_AddUIElements()
		end,
		
		OnStart = function()
			Rule_AddDelayedInterval(Obj1_CheckCompletion, 5, 3)
			
			Rule_AddDelayedInterval(Obj1_artyOnBoat, 3, 1)
			A2M01_SetupSandbags()
			Objective_SetAlwaysShowDetails(OBJ_River, true, true, true)
			
			--SubObjective
			Objective_Start(OBJ_RiverTerritory, false)
			Rule_AddInterval(Obj1_artyCallout, 1)
			
			--Achievements
			Rule_AddInterval(Achievement_NoMortarsAllowed, 1)
			
		end,
		
		OnComplete = function()
			-- Calls from Objective_Complete(OBJ_Objective1)
			-- Fires off before Intel_Complete (unless Intel_Complete is nil)	
			World_IncreaseInteractionStage() 
			EGroup_EnableMinimapIndicator(eg_mm_unlock1, true)
			
			Player_SetSquadProductionAvailability(player1, SBP.SOVIET.T_70M, ITEM_UNLOCKED)
			Player_SetSquadProductionAvailability(player1, SBP.SOVIET.SU_76M, ITEM_UNLOCKED)
			Player_SetSquadProductionAvailability(player1, SBP.SOVIET.M1942_ZIS_3_76MM_AT_GUN_SQUAD, ITEM_UNLOCKED)
			Player_SetConstructionMenuAvailability(player1, "tp_construction_soviet_engineer", ITEM_UNLOCKED)
			
			Util_CreateSquads(player1, sg_su76, SBP.SOVIET.SU_76M, mkr_mapEntry1, Marker_GetPosition(mkr_suDest1))
			Util_CreateSquads(player1, sg_su76, SBP.SOVIET.SU_76M, mkr_mapEntry2, Marker_GetPosition(mkr_suDest2))
			Util_CreateSquads(player1, sg_su76, SBP.SOVIET.SU_76M, mkr_mapEntry3, Marker_GetPosition(mkr_suDest3))
			Util_StartNIS(EVENTS.SitRep, nil, nil, nil, nil, nil, true)
			
			Player_GetAll(player1)
			SGroup_SetInvulnerable(sg_allsquads, true)
			EGroup_SetInvulnerable(eg_allentities, true)
			Rule_AddDelayedInterval(A2M01_SetupStrats, 5, 1)	
			Obj1_SetRallyPoints(eg_p_startingBase)
			Sound_StopMusic(CAMPAIGN_MUSIC_FADEOUT,0)
		end,
		
		OnFail = function()
			-- Calls from Objective_Fail(OBJ_Objective1)
			-- Fires off before Intel_Fail (unless Intel_Fail is nil)			
		end,
		
		IsComplete = function()

		end,
		
		Intel_Start = nil, 	-- Event will play when obj starts but before any UI appears
		Intel_Complete = nil,			-- Event will play when obj completes but before UI is cleared
		Intel_Fail = nil,				-- Event will play when obj fails but before UI is cleared
		Title = 11045325, -- LOCDB [11045325] 'Secure the eastern riverbank'
		Description = 11045325,			-- Objective Description
		TitleEnd = 11045326, -- LOCDB [11045326] 'Riverbank secured'
		TitleFail = 1459052,			-- Failed Title
		Type = OT_Primary,				-- Objective Type (OT_Primary, OT_Secondary)
	}
	
	Objective_Register(OBJ_River)

end

function Obj1_SetRallyPoints(base)
	if not EGroup_IsEmpty(base) then
		Command_EntityPos(player1, base, CMD_RallyPoint, Marker_GetPosition(mkr_rallyPoint_forwardBase))
	end
end

-- Sub-objectives
-- #1 - Take out the Howitzer across the river
function Initialize_Objective1A()

	OBJ_RiverHowitzer	= {
	
	
		Parent = OBJ_River,
		
		SetupUI = function() 
			-- Use for creating any hint points or UI Elements
			-- eg: Objective_AddUIElements()
			riverPing_howitzer = Objective_AddUIElements(OBJ_RiverHowitzer, mkr_howitzer, true, 11045327, true, 2.5) -- LOCDB [11045327] 'Destroy'
		end,
		
		OnStart = function()
			
		end,
		
		OnComplete = function()
			if not SGroup_IsEmpty(sg_mortars) then
				Cmd_Retreat(sg_mortars, Marker_GetPosition(mkr_vp))
			end
			--- Start "Second Howitzer" bonus objective, to kill or capture the other Howitzer
			if not SGroup_IsEmpty(sg_e_howitzer2) then
				Objective_Start(OBJ_SecondHowitzer)
			end
		end,
		
		OnFail = function()
			-- Calls from Objective_Fail(OBJ_Objective1)
			-- Fires off before Intel_Fail (unless Intel_Fail is nil)			
		end,
		
		IsComplete = function()

		end,
		
		Intel_Start = EVENTS.German_Panic_01,	-- Event will play when obj starts but before any UI appears
		Intel_Complete = nil,			-- Event will play when obj completes but before UI is cleared
		Intel_Fail = nil,				-- Event will play when obj fails but before UI is cleared
		Title = 11045328,	-- LOCDB [11045328] 'Destroy the German Howitzer'
		Description = 11045328,			-- Objective Description
		TitleEnd = nil,				-- Completed Title
		TitleFail = nil,			-- Failed Title
		Type = OT_Primary,				-- Objective Type (OT_Primary, OT_Secondary)
	}
	
	Objective_Register(OBJ_RiverHowitzer)

end

-- #2 Capture a territory across the river
function Initialize_Objective1B()

	OBJ_RiverTerritory	= {
	
		Parent = OBJ_River,
		
		SetupUI = function() 
			-- Use for creating any hint points or UI Elements
			-- eg: Objective_AddUIElements()
			riverPing_territory = Objective_AddUIElements(OBJ_RiverTerritory, eg_strat_southWest, true, 11045329, true, 3.8) -- LOCDB [11045329] 'Capture'
		end,
		
		OnStart = function()

		end,
		
		OnComplete = function()

			
		end,
		
		OnFail = function()
			-- Calls from Objective_Fail(OBJ_Objective1)
			-- Fires off before Intel_Fail (unless Intel_Fail is nil)			
		end,
		
		IsComplete = function()

		end,
		
		Intel_Start = nil, -- Event will play when obj starts but before any UI appears
		Intel_Complete = nil,			-- Event will play when obj completes but before UI is cleared
		Intel_Fail = nil,				-- Event will play when obj fails but before UI is cleared
		Title = 11045632, -- LOCDB [11045632] 'Capture territory across the river'
		Description = 11045325,			-- Objective Description
		TitleEnd = 11045326, -- LOCDB [11045326] 'Riverbank secured'
		TitleFail = 1459052,			-- Failed Title
		Type = OT_Primary,				-- Objective Type (OT_Primary, OT_Secondary)
	}
	
	Objective_Register(OBJ_RiverTerritory)

end

function Initialize_Objective1C()

	OBJ_SecondHowitzer	= {
			
		SetupUI = function() 
			-- Use for creating any hint points or UI Elements
			-- eg: Objective_AddUIElements()
			riverPing_howitzer2 = Objective_AddUIElements(OBJ_SecondHowitzer, sg_e_howitzer2, true, 11045327, true) -- LOCDB [11045327] 'Destroy'
		end,
		
		OnStart = function()
			Rule_AddDelayedInterval(Obj1C_CheckSecondHowitzer, 5, 1)
		end,
		
		OnComplete = function()
			Rule_RemoveIfExist(_fireHowitzer2)
			
		end,
		
		OnFail = function()
			-- Calls from Objective_Fail(OBJ_Objective1)
			-- Fires off before Intel_Fail (unless Intel_Fail is nil)			
		end,
		
		IsComplete = function()

		end,
		
		Intel_Start = EVENTS.SecondHowitzer, -- Event will play when obj starts but before any UI appears
		Intel_Complete = nil,			-- Event will play when obj completes but before UI is cleared
		Intel_Fail = nil,				-- Event will play when obj fails but before UI is cleared
		Title = 11045330, -- LOCDB [11045330] 'Destroy or capture the second howitzer'
		Description = 11045330, -- LOCDB [11045330] 'Destroy or capture the second howitzer'
		TitleEnd = 11036471,
		TitleFail = nil,			-- Failed Title
		Type = OT_Secondary,				-- Objective Type (OT_Primary, OT_Secondary)
	}
	
	Objective_Register(OBJ_SecondHowitzer)

end

function Obj1_CheckCompletion()
	-- Objective completes if howitzer1 is dead, three specific nearby squads are dead, and the territory is captured
	if EGroup_IsEmpty(eg_p_hq) then
		Util_MissionTitle(11048793, 1, 5, 1)
		Rule_AddOneShot(_delayedMissionFail, 8)
		Rule_RemoveMe()
		return
	end
	if Objective_IsComplete(OBJ_RiverHowitzer) and Objective_IsComplete(OBJ_RiverTerritory) then
		Objective_Complete(OBJ_River)
		Rule_RemoveMe()
		Rule_RemoveIfExist(Obj1_fireKatyushas)
	end
	if not Objective_IsComplete(OBJ_RiverHowitzer) and (SGroup_IsEmpty(sg_e_howitzer) or SGroup_TotalMembersCount(sg_e_howitzer) == 1) then
		if g_riverHowitzerComplete == nil then
			g_riverHowitzerComplete = true
			Objective_Complete(OBJ_RiverHowitzer)
			Sound_StopMusic(6, 0)
			Rule_AddOneShot(_startHowitzerClearMusic, 6)
			Rule_AddDelayedInterval(Obj1_startAlliedArty, 15, 1)
			Objective_RemoveUIElements(OBJ_RiverHowitzer, riverPing_howitzer)
		end
	end
	if not Objective_IsComplete(OBJ_RiverTerritory) and EGroup_IsCapturedByPlayer(eg_strat_southWest, player1, ALL)  then
		if SGroup_IsEmpty(sg_e_sw) then
			if hint_enemiesSW ~= nil then
				HintPoint_Remove(hint_enemiesSW)
			end
			Objective_Complete(OBJ_RiverTerritory)
			Objective_RemoveUIElements(OBJ_RiverTerritory, riverPing_territory)
		elseif hint_enemiesSW == nil then
			-- if nearby enemies are still alive, update the objective to highlight them
			hint_enemiesSW = HintPoint_Add(sg_e_sw, true, 11047031)
			ThreatArrow_CreateGroup(sg_e_sw)
			FOW_RevealSGroup(sg_e_sw, -1)
			Objective_UpdateText(OBJ_RiverTerritory, 11048798, 11048798, true) -- LOCDB [11046433] 'Eliminate enemy squads near Isakovich'
			Objective_RemoveUIElements(OBJ_RiverTerritory, riverPing_territory)
			riverPing_enemiesInTerritory = Objective_AddUIElements(OBJ_RiverTerritory, mkr_forwardHQ, true, 11048798, true)
		end
	end
end

function Obj1C_CheckSecondHowitzer()
	if SGroup_IsEmpty(sg_e_howitzer2) or not SGroup_HasTeamWeapon(sg_e_howitzer2, ALL) then
		Objective_Complete(OBJ_SecondHowitzer)
		Objective_RemoveUIElements(OBJ_SecondHowitzer, riverPing_howitzer2)
		Rule_RemoveMe()
	end
end

function _startHowitzerClearMusic()
	Sound_PlayMusic("streamed/music/missions/m07/m07_cue_first_howitzer_clear", 0, 0)
end

--- Ally conscripts crossing the river, during Objective 1. 
function Obj1_AlliesCrossingRiver()
	if SGroup_Count(sg_a_crossRiver) < 8 and not Objective_IsStarted(OBJ_BreachDefenses) then
		local encData = {
			name = "crossRiver",
			player = player4,

			spawn = Table_GetRandomItem({mkr_allySpawn_river, mkr_allySpawn_river2, mkr_allySpawn_river3}),
			sgroups = {sg_a_crossRiver},
			units = {
				{
					sbp = SBP.SOVIET.CONSCRIPT_SQUAD,
					load = World_GetRand(3,6),
				},
			},
			onDeath = nil,
		}
		encID_crossRiver = Encounter:Create(encData)
		
		local goalData = {
			name = "Attack",
			target = Table_GetRandomItem({mkr_shoreline7, mkr_shoreline8, mkr_shoreline9}),
			useSkirmishAI = true,
			attackMove = true,
			abilityBlacklist = {ABILITY.SOVIET.CONSCRIPT_MOLOTOV_COCKTAIL},
			fallback = true,
			maxIdleTime = 5,
			fallbackParams = {
				thresholds = {0.55},
				thresholdType = Threshold_PercentageEntitiesRemaining,
				markers = {mkr_allyRiver_retreat},
				retreat = true,
				retreatDespawn = true,
			},
			onSuccess = RiverCross_GoalUpdate,
		}
		encID_crossRiver:SetGoal(goalData)
		Modify_WeaponDamage(sg_a_crossRiver, "hardpoint_01", 0)
		Modify_ReceivedDamage(sg_a_crossRiver, 2, true)
		Modify_ReceivedAccuracy(sg_a_crossRiver, 2, true)
		SGroup_EnableUIDecorator(sg_a_crossRiver, false)
	elseif Objective_IsStarted(OBJ_BreachDefenses) and SGroup_IsEmpty(sg_a_crossRiver) then
		Rule_RemoveMe()
	end

	SGroup_DestroyAllInMarker(sg_a_crossRiver, mkr_allyRiver_retreat)
	
end

RiverCross_GoalUpdate = function (enc)
	Cmd_Retreat(enc.sgroup, Marker_GetPosition(mkr_allyRiver_retreat))
end

-- Allied soldiers in trenches
function Obj1_alliesInTrenches()
	sg_alliesInTrenches = SGroup_CreateIfNotFound("sg_alliesInTrenches")
	Util_CreateSquads(player3, sg_alliesInTrenches, SBP.SOVIET.CONSCRIPT_SQUAD, mkr_allyTrench1)
	Util_CreateSquads(player3, sg_alliesInTrenches, SBP.SOVIET.SNIPER_TEAM, mkr_allyTrench2)
	Util_CreateSquads(player3, sg_alliesInTrenches, SBP.SOVIET.CONSCRIPT_SQUAD, mkr_allyTrench3)
	Util_CreateSquads(player3, sg_alliesInTrenches, SBP.SOVIET.SNIPER_TEAM, mkr_allyTrench4)
	Util_CreateSquads(player3, sg_alliesInTrenches, SBP.SOVIET.CONSCRIPT_SQUAD, mkr_allyTrench5)
	SGroup_SetMoodMode(sg_alliesInTrenches, MM_ForceTense)
	SGroup_EnableUIDecorator(sg_alliesInTrenches, false)
end

-- Allied Katyushas firing across the river
function Obj1_spawnKatyushas()
	sg_katyushas = SGroup_CreateIfNotFound("sg_katyushas")
	sg_katyushas_single = SGroup_CreateIfNotFound("sg_katyushas_single")
	Util_CreateSquads(player3, sg_katyushas, SBP.SOVIET.KATYUSHA_BM_13N_SQUAD, mkr_ally_katy1)
	Util_CreateSquads(player3, sg_katyushas, SBP.SOVIET.KATYUSHA_BM_13N_SQUAD, mkr_ally_katy2)
	Util_CreateSquads(player3, sg_katyushas, SBP.SOVIET.KATYUSHA_BM_13N_SQUAD, mkr_ally_katy3)
	Util_CreateSquads(player3, sg_katyushas, SBP.SOVIET.KATYUSHA_BM_13N_SQUAD, mkr_ally_katy4)
	Util_CreateSquads(player3, sg_katyushas, SBP.SOVIET.KATYUSHA_BM_13N_SQUAD, mkr_ally_katy5)
	SGroup_EnableUIDecorator(sg_katyushas, false)
	Modify_AbilityRechargeTime(player3, ABILITY.SOVIET.KAYTUSHA_ROCKET_TRUCK_BARRAGE, 0.1)
	Modify_AbilityMaxCastRange(player3, ABILITY.SOVIET.KAYTUSHA_ROCKET_TRUCK_BARRAGE, 2)
	Modify_ReceivedDamage(sg_katyushas, 5)
end

function Obj1_fireKatyushas()

	if SGroup_IsEmpty(sg_katyushas) then
		Rule_RemoveMe()
	else
		if g_katyushaIndex > SGroup_CountSpawned(sg_katyushas) then
			g_katyushaIndex = 1
		end
		SGroup_Add(sg_katyushas_single, SGroup_GetSpawnedSquadAt(sg_katyushas, g_katyushaIndex))  
		local target = Marker_FromName("mkr_katy_target" .. g_katyushaIndex, "")
		Cmd_Ability(sg_katyushas_single, ABILITY.SOVIET.KAYTUSHA_ROCKET_TRUCK_BARRAGE, Util_GetRandomPosition(target))
		SGroup_Clear(sg_katyushas_single)
		if g_katyushaIndex ~= 1 then
			SGroup_Add(sg_katyushas_single, SGroup_GetSpawnedSquadAt(sg_katyushas, 1)) 
			local target = Marker_FromName("mkr_katy_target" .. g_katyushaIndex, "")
			Cmd_Ability(sg_katyushas_single, ABILITY.SOVIET.KAYTUSHA_ROCKET_TRUCK_BARRAGE, Util_GetRandomPosition(target))
			SGroup_Clear(sg_katyushas_single)
		end
		g_katyushaIndex = g_katyushaIndex + 1
		
	end
	
end

-- Mortars hitting the frozen river during objective 1

function Obj1_artyOnIce()
	local rand = World_GetRand(1,5)
	Cmd_Ability(player2, ABILITY.GLOBAL.SP_SINGLE_SHOT_MORTAR, Util_GetRandomPosition((Marker_FromName("mkr_river" .. rand, "")), 3), nil, true)
	local rand = World_GetRand(6,15)
	Cmd_Ability(player2, ABILITY.GLOBAL.SP_SINGLE_SHOT_MORTAR, Util_GetRandomPosition((Marker_FromName("mkr_river" .. rand, "")), 3), nil, true)
	Rule_RemoveMe()
	local f = function (gid, idx, sid)
		if World_DistancePointToPoint(Util_GetPosition(sid), Marker_GetPosition(mkr_allyRiver_center)) < 50 then
			local target = Squad_GetPosition(sid)
			Cmd_Ability(player2, ABILITY.GLOBAL.SP_SINGLE_SHOT_MORTAR, target, nil, true)
			return true
		end
	end
	SGroup_ForEach(sg_a_crossRiver, f)
	if not Objective_IsComplete(OBJ_River) then
		Rule_AddOneShot(Obj1_artyOnIce, World_GetRand(3,6))
	end
end

function Obj1_artyOnBoat()
	if Prox_ArePlayersNearMarker(player1, mkr_artyOnBoat, ANY, 40) then 
		Rule_RemoveMe()
		Rule_AddInterval(Obj1_artyOnBoat_screenCheck, 1)
	end
end

function Obj1_artyOnBoat_screenCheck()
	if Misc_IsPosOnScreen(Marker_GetPosition(mkr_artyOnBoat), 0.7) then
		EGroup_SetInvulnerable(eg_barge, false)
		Cmd_Ability(player2, ABILITY.GLOBAL.OFF_MAP_ARTY_SINGLE_SHOT_INSTANT, Marker_GetPosition(mkr_artyOnBoat), nil, true)
		Event_GroupIsDead(_damageIceAroundBoat, {}, eg_barge)
		Rule_RemoveMe()
	end
end

function _damageIceAroundBoat()
	World_DamageIce(Marker_GetPosition(mkr_artyOnBoat), 4, 8, 250, 50)
end
		
--- Mortar Smoke Barrage ---
--- German mortars fire smoke onto the river during objective 1 ---
--- They should retreat once they are attacked ---
function Obj1_MortarSmokeBarrage()
	if not SGroup_IsEmpty(sg_mortars) then
		local fire = function (group, index, squad)
			SGroup_Add(sg_mortar_single, squad)
			if SGroup_GetAvgHealth(sg_mortar_single) < 1.0 then
				if not SGroup_IsRetreating(sg_mortar_single, ANY) then
					Cmd_Retreat(sg_mortar_single, Marker_GetPosition(mkr_vp))
				end
			elseif not Squad_IsUnderAttack(squad, 20) and not Squad_IsRetreating(squad) then
				if SGroup_HasTeamWeapon(sg_mortar_single, ANY) then
					if Prox_MarkerSGroup(mkr_mortar1, sg_mortar_single) < 5 then
						Cmd_Ability(sg_mortar_single, ABILITY.GERMAN.MORTAR_TEAM_SMOKE_BARRAGE, Util_GetRandomPosition(mkr_mortar1_smoke), nil, true)
					elseif Prox_MarkerSGroup(mkr_mortar2, sg_mortar_single) < 5 then
						Cmd_Ability(sg_mortar_single, ABILITY.GERMAN.MORTAR_TEAM_SMOKE_BARRAGE, Util_GetRandomPosition(mkr_mortar2_smoke), nil, true)
					elseif Prox_MarkerSGroup(mkr_mortar3, sg_mortar_single) < 5 then
						Cmd_Ability(sg_mortar_single, ABILITY.GERMAN.MORTAR_TEAM_SMOKE_BARRAGE, Util_GetRandomPosition(mkr_mortar3_smoke), nil, true)
--~ 					elseif Prox_MarkerSGroup(mkr_mortar1_2, sg_mortar_single) < 5 then																	-- Stopped these two firing smoke to reduce the number of FOW blockers generated. NJR 9th Jan
--~ 						Cmd_Ability(sg_mortar_single, ABILITY.GERMAN.MORTAR_TEAM_SMOKE_BARRAGE, Util_GetRandomPosition(mkr_mortar1_smoke), nil, true)
--~ 					elseif Prox_MarkerSGroup(mkr_mortar2_2, sg_mortar_single) < 5 then
--~ 						Cmd_Ability(sg_mortar_single, ABILITY.GERMAN.MORTAR_TEAM_SMOKE_BARRAGE, Util_GetRandomPosition(mkr_mortar2_smoke), nil, true)
					elseif Prox_MarkerSGroup(mkr_mortar3_2, sg_mortar_single) < 5 then
						Cmd_Ability(sg_mortar_single, ABILITY.GERMAN.MORTAR_TEAM_SMOKE_BARRAGE, Util_GetRandomPosition(mkr_mortar3_smoke), nil, true)
					end
				end
			end
			if not SGroup_IsEmpty(sg_mortar_single) then
				if Prox_MarkerSGroup(mkr_vp, sg_mortar_single) < 15 then
					SGroup_DestroyAllSquads(sg_mortar_single)
				end
			end
			SGroup_Clear(sg_mortar_single)
		end
		SGroup_ForEach(sg_mortars, fire)
	end
end

function Obj1_MortarRetreat()
	if not SGroup_IsEmpty(sg_mortars) then
		local retreat = function (group, index, squad)
			SGroup_Add(sg_mortar_retreat, squad)
			if SGroup_GetAvgHealth(sg_mortar_retreat) < 1.0 then
				if not SGroup_IsRetreating(sg_mortar_retreat, ANY) then
					Cmd_Retreat(sg_mortar_retreat, Marker_GetPosition(mkr_vp))
				end
			end
			if not SGroup_IsEmpty(sg_mortar_retreat) then
				if Prox_MarkerSGroup(mkr_vp, sg_mortar_retreat) < 15 then
					SGroup_DestroyAllSquads(sg_mortar_retreat)
				end
			end
			SGroup_Clear(sg_mortar_retreat)
		end
		SGroup_ForEach(sg_mortars, retreat)
	else
		Rule_RemoveMe()
	end
end

--- SU-76 Nislet ---
--- Show SU-76s arrive at the start of Objective 2 ---

function Obj1_cutToSU76s()
	Game_SetMode(UI_Cinematic)
	Camera_ResetToDefault()
	Camera_SetSlideTargetRate(0.5)
	SGroup_Kill(sg_katyushas)
	SGroup_Kill(sg_a_t34)
	SGroup_Kill(sg_a_howitzer)
	Actor_PlaySpeech(ACTOR.Russian_Soldier_02, 11036720)
	if not EGroup_IsEmpty(eg_supplyTruck) then
		EGroup_DestroyAllEntities(eg_supplyTruck)
	end
	Obj1_buildForwardBase()
	Rule_AddOneShot(Obj1_cutToHQ, 6)
	Rule_AddOneShot(Obj1_EndLetterbox, 12)
end

function Obj1_moveObstructionSquads()
	sg_p_squadsInTheWay = SGroup_CreateIfNotFound("sg_p_squadsInTheWay")
	Player_GetAllSquadsNearMarker(player1, sg_p_squadsInTheWay, mkr_how2_target1, 25)
	local sbps = {SBP.SOVIET.M1910_MAXIM_HEAVY_MACHINE_GUN_SQUAD, SBP.GERMAN.MORTAR_TEAM_81MM, SBP.SOVIET.HM_120_38_MORTAR_SQUAD, SBP.SOVIET.M5_HALFTRACK_SQUAD, SBP.SOVIET.M1937_53_K_45MM_AT_GUN_SQUAD, SBP.SOVIET.M1942_ZIS_3_76MM_AT_GUN_SQUAD}
	SGroup_Filter(sg_p_squadsInTheWay, sbps, FILTER_KEEP)
	if not SGroup_IsEmpty(sg_p_squadsInTheWay) then
		Cmd_Stop(sg_p_squadsInTheWay)
		local f = function(gid, idx, sid)
			local pos = Util_GetRandomPosition(mkr_rallyPoint_forwardBase, 5)
			Squad_WarpToPos(sid, pos)
		end
		SGroup_ForEach(sg_p_squadsInTheWay, f)
	end
end

function Obj1_cutToHQ()
	
	Camera_MoveTo(mkr_forwardHQ, true, 0.33)
end

function Obj1_StartLetterbox()
	Game_SetMode(UI_Cinematic)
end

function Obj1_EndLetterbox()
	Util_Autosave()
	Game_SetMode(UI_Normal)
	Camera_SetInputEnabled(true)
	if _player1Squads ~= nil then
		SGroup_ReSpawn(_player1Squads)
	end
	if _player1Entities ~= nil then
		EGroup_ReSpawn(_player1Entities)
	end
	SGroup_SetInvulnerable(sg_allsquads, false)
	EGroup_SetInvulnerable(eg_allentities, false)
	Util_ReinforceEvent(sg_su76)	
	Rule_AddOneShot(delayStartSecondObjective, 10)
end

function delayStartSecondObjective() 
	Objective_Start(OBJ_BreachDefenses)
end

function Obj1_artyCallout()
	if SGroup_IsEmpty(sg_e_howitzer) then
		Rule_RemoveMe()
	elseif Player_CanSeeSGroup(player1, sg_e_howitzer, ANY) and Misc_IsPosOnScreen(SGroup_GetPosition(sg_e_howitzer), 0.8) then
		--SubObjectives
		Objective_Start(OBJ_RiverHowitzer, false)
		Rule_RemoveMe()
	end
end

-- Force-construct a forward base when the player completes objective 1

function Obj1_buildForwardBase()
	sg_p_tempEngineers1 = SGroup_CreateIfNotFound("sg_p_tempEngineers1")
	sg_p_tempEngineers2 = SGroup_CreateIfNotFound("sg_p_tempEngineers2")
	sg_p_tempEngineers3 = SGroup_CreateIfNotFound("sg_p_tempEngineers3")
	sg_p_tempEngineers4 = SGroup_CreateIfNotFound("sg_p_tempEngineers4")
	Util_CreateSquads(player3, sg_p_tempEngineers1, SBP.SOVIET.COMBAT_ENGINEER_SQUAD, mkr_forwardBase_1, nil, 1, 2)
	Util_CreateSquads(player3, sg_p_tempEngineers2, SBP.SOVIET.COMBAT_ENGINEER_SQUAD, mkr_forwardBase_2, nil, 1, 2)
	Util_CreateSquads(player3, sg_p_tempEngineers3, SBP.SOVIET.COMBAT_ENGINEER_SQUAD, mkr_forwardBase_3, nil, 1, 2)
	Util_CreateSquads(player3, sg_p_tempEngineers4, SBP.SOVIET.COMBAT_ENGINEER_SQUAD, mkr_forwardHQ, nil, 1, 2)
	SGroup_SetInvulnerable(sg_p_tempEngineers1, true)
	SGroup_SetInvulnerable(sg_p_tempEngineers2, true)
	SGroup_SetInvulnerable(sg_p_tempEngineers3, true)
	SGroup_SetInvulnerable(sg_p_tempEngineers4, true)
	SGroup_SetSelectable(sg_p_tempEngineers1, false)
	SGroup_SetSelectable(sg_p_tempEngineers2, false)
	SGroup_SetSelectable(sg_p_tempEngineers3, false)
	SGroup_SetSelectable(sg_p_tempEngineers4, false)
	SGroup_EnableUIDecorator(sg_p_tempEngineers1, false)
	SGroup_EnableUIDecorator(sg_p_tempEngineers2, false)
	SGroup_EnableUIDecorator(sg_p_tempEngineers3, false)
	SGroup_EnableUIDecorator(sg_p_tempEngineers4, false)
	Player_ClearArea(player1, mkr_forwardBase_1, false)
	Player_ClearArea(player1, mkr_forwardBase_2, false)
	Player_ClearArea(player1, mkr_forwardBase_3, false)
	Player_ClearArea(player1, mkr_forwardHQ, false)
	Player_CompleteUpgrade(player3, BP_GetUpgradeBlueprint("allow_building_hq"))
	eg_p_obstructions = EGroup_CreateIfNotFound("eg_p_obstructions")
	Player_GetAllEntitiesNearMarker(player1, eg_p_obstructions, mkr_forwardHQ)
	EGroup_DestroyAllEntities(eg_p_obstructions)
	Cmd_Construct(sg_p_tempEngineers4, EBP.SOVIET.HQ, mkr_forwardHQ, Marker_GetPosition(mkr_hq_facing))
	Rule_AddOneShot(Obj1_delayedConstruction, 3)
	Rule_AddDelayedInterval(Obj1_buildForwardBase_retry, 5, 3)
	Rule_AddDelayedInterval(Obj1_removeTempEngineers, 5, 1)
	eg_p_forwardBase = EGroup_CreateIfNotFound("eg_p_forwardBase")
end


function Obj1_delayedConstruction()
	eg_p_obstructions = EGroup_CreateIfNotFound("eg_p_obstructions")
	Player_GetAllEntitiesNearMarker(player1, eg_p_obstructions, mkr_forwardBase_1)
	EGroup_DestroyAllEntities(eg_p_obstructions)
	Player_GetAllEntitiesNearMarker(player1, eg_p_obstructions, mkr_forwardBase_2)
	EGroup_DestroyAllEntities(eg_p_obstructions)
	Player_GetAllEntitiesNearMarker(player1, eg_p_obstructions, mkr_forwardBase_3)
	EGroup_DestroyAllEntities(eg_p_obstructions)
	Cmd_Construct(sg_p_tempEngineers1, EBP.SOVIET.MOTORPOOL, mkr_forwardBase_1)
	Cmd_Construct(sg_p_tempEngineers2, EBP.SOVIET.WEAPON_SUPPORT_CENTER, mkr_forwardBase_2) -- Cmd_Construct(sg_p_tempEngineers3, EBP.SOVIET.MOTORPOOL, Util_GetRandomPosition(mkr_forwardBase_3, 5))
	Cmd_Construct(sg_p_tempEngineers3, EBP.SOVIET.BARRACKS, mkr_forwardBase_3)
end

function Obj1_buildForwardBase_retry()
	if not SGroup_IsEmpty(sg_p_tempEngineers1) then
		if not SGroup_IsConstructingBuilding(sg_p_tempEngineers1, ANY) then
			Player_ClearArea(player1, mkr_forwardBase_1, false)
			Cmd_Construct(sg_p_tempEngineers1, EBP.SOVIET.MOTORPOOL, mkr_forwardBase_1)
		end
	end
	if not SGroup_IsEmpty(sg_p_tempEngineers2) then
		if not SGroup_IsConstructingBuilding(sg_p_tempEngineers2, ANY) then
			Player_ClearArea(player1, mkr_forwardBase_2, false)
			Cmd_Construct(sg_p_tempEngineers2, EBP.SOVIET.WEAPON_SUPPORT_CENTER, mkr_forwardBase_2)
		end
	end
	if not SGroup_IsEmpty(sg_p_tempEngineers3) then
		if not SGroup_IsConstructingBuilding(sg_p_tempEngineers3, ANY) then
			Player_ClearArea(player1, mkr_forwardBase_3, false)
			Cmd_Construct(sg_p_tempEngineers3, EBP.SOVIET.BARRACKS, mkr_forwardBase_3)
		end
	end
	if not SGroup_IsEmpty(sg_p_tempEngineers4) then
		if not SGroup_IsConstructingBuilding(sg_p_tempEngineers4, ANY) then
			Player_ClearArea(player1, mkr_forwardHQ, false)
			Cmd_Construct(sg_p_tempEngineers4, EBP.SOVIET.HQ, mkr_forwardHQ)
		end
	end
end

function Obj1_removeTempEngineers()
	Player_GetAllEntitiesNearMarker(player3, eg_p_forwardBase, mkr_forwardBase_1, 10)
	if not EGroup_IsEmpty(eg_p_forwardBase) then
		EGroup_Filter(eg_p_forwardBase, EBP.SOVIET.MOTORPOOL, FILTER_KEEP)
		EGroup_SetInvulnerable(eg_p_forwardBase, true)
		EGroup_FilterUnderConstruction(eg_p_forwardBase, FILTER_REMOVE)
		if not EGroup_IsEmpty(eg_p_forwardBase) and not SGroup_IsEmpty(sg_p_tempEngineers1) then
			EGroup_SetInvulnerable(eg_p_forwardBase, false)
			Util_SetPlayerOwner(eg_p_forwardBase, player1)
			SGroup_DestroyAllSquads(sg_p_tempEngineers1)
		end
	end
	Player_GetAllEntitiesNearMarker(player3, eg_p_forwardBase, mkr_forwardBase_2, 10)
	if not EGroup_IsEmpty(eg_p_forwardBase) then
		EGroup_Filter(eg_p_forwardBase, EBP.SOVIET.WEAPON_SUPPORT_CENTER, FILTER_KEEP)
		EGroup_SetInvulnerable(eg_p_forwardBase, true)
		EGroup_FilterUnderConstruction(eg_p_forwardBase, FILTER_REMOVE)
		if not EGroup_IsEmpty(eg_p_forwardBase) and not SGroup_IsEmpty(sg_p_tempEngineers2) then
			EGroup_SetInvulnerable(eg_p_forwardBase, false)
			Util_SetPlayerOwner(eg_p_forwardBase, player1)
			SGroup_DestroyAllSquads(sg_p_tempEngineers2)
		end
	end
	Player_GetAllEntitiesNearMarker(player3, eg_p_forwardBase, mkr_forwardBase_3, 10)
	if not EGroup_IsEmpty(eg_p_forwardBase) then
		EGroup_Filter(eg_p_forwardBase, EBP.SOVIET.BARRACKS, FILTER_KEEP)
		EGroup_SetInvulnerable(eg_p_forwardBase, true)
		EGroup_FilterUnderConstruction(eg_p_forwardBase, FILTER_REMOVE)
		if not EGroup_IsEmpty(eg_p_forwardBase) and not SGroup_IsEmpty(sg_p_tempEngineers3) then
			EGroup_SetInvulnerable(eg_p_forwardBase, false)
			Util_SetPlayerOwner(eg_p_forwardBase, player1)
			SGroup_DestroyAllSquads(sg_p_tempEngineers3)
		end
	end
	Player_GetAllEntitiesNearMarker(player3, eg_p_forwardBase, mkr_forwardHQ, 10)
	if not EGroup_IsEmpty(eg_p_forwardBase) then
		EGroup_Filter(eg_p_forwardBase, EBP.SOVIET.HQ, FILTER_KEEP)
		EGroup_SetInvulnerable(eg_p_forwardBase, true)
		EGroup_FilterUnderConstruction(eg_p_forwardBase, FILTER_REMOVE)
		if not EGroup_IsEmpty(eg_p_forwardBase) and not SGroup_IsEmpty(sg_p_tempEngineers4) then
			EGroup_SetInvulnerable(eg_p_forwardBase, false)
            if Player_HasUpgrade(player1, UPG.SOVIET.HQ_HEALING_AURA) then
                 Cmd_Upgrade(eg_p_forwardBase, UPG.SOVIET.HQ_HEALING_AURA, 1, true)
            end
			Util_SetPlayerOwner(eg_p_forwardBase, player1)
			SGroup_DestroyAllSquads(sg_p_tempEngineers4)
			hint_forwardBase = HintPoint_Add(eg_p_forwardBase, true, 11043305, -1, HPAT_Hint, "Icons_buildings_building_soviet_headquarters")
		end
	end
	if SGroup_IsEmpty(sg_p_tempEngineers1) and SGroup_IsEmpty(sg_p_tempEngineers2) and SGroup_IsEmpty(sg_p_tempEngineers3) and SGroup_IsEmpty(sg_p_tempEngineers4) then
		HintPoint_Remove(hint_forwardBase)
		Player_GetAllEntitiesNearMarker(player1, eg_p_forwardBase, Marker_GetPosition(mkr_forwardHQ), 30)
		local ebps = {EBP.SOVIET.BARRACKS, EBP.SOVIET.WEAPON_SUPPORT_CENTER, EBP.SOVIET.MOTORPOOL, EBP.SOVIET.HQ}
		EGroup_Filter(eg_p_forwardBase, ebps, FILTER_KEEP)
		Rule_RemoveIfExist(Obj1_buildForwardBase_retry)
		EGroup_SetPlayerOwner(eg_p_startingBase, player3)
		Obj1_SetRallyPoints(eg_p_forwardBase)
		Rule_AddInterval(Loss_NoHQ, 1)
		Rule_RemoveMe()
	end

	-- update the group that contains the HQ to provide reinforce hints at
	EGroup_Clear(eg_reinforcehints)
	EGroup_AddEGroup(eg_reinforcehints, eg_p_forwardBase)
	EGroup_Filter(eg_reinforcehints, EBP.SOVIET.HQ, FILTER_KEEP)
	
end

--- Friendly propaganda artillery begins to target the shoreline ---

function Obj1_startAlliedArty()
	if Prox_ArePlayersNearMarker(player1, mkr_howitzer, ANY, 25) then 
		if Misc_IsPosOnScreen(Marker_GetPosition(mkr_howitzer), 1.0) then
			t_shoreArtyTargets = {mkr_shoreline3, mkr_shoreline4, mkr_shoreline_pg_4, mkr_shoreline5, mkr_shoreline_pg_3, mkr_shoreline6, mkr_shoreline_pg_2}
			Player_AddAbility(player3, ABILITY.SOVIET.FEAR_PROPAGANDA_ARTILLERY)
			Player_CompleteUpgrade(player2, BP_GetUpgradeBlueprint("campaign\\disable_forced_retreat"))
			g_propagandaBarrageCount = 0
			Rule_AddInterval(Obj1_alliedArtyOnShore, 60)
			Rule_RemoveMe()
		end
	end
end
	
function Obj1_alliedArtyOnShore()
	if #t_shoreArtyTargets == 0 or g_propagandaBarrageCount >= 4 then
		Rule_RemoveMe()
	else
		local target = Marker_GetPosition(mkr_strat_northWest3)
		for k,v in pairs(t_shoreArtyTargets) do
			if Prox_AreSquadsNearMarker(sg_allShoreline, v, ANY, 30) then
				local findSquadTarget = function (gid, idx, sid)
					if Util_GetDistance(sid, v) < 30 then
						target = Squad_GetPosition(sid) 
						return true
					end
				end
				SGroup_ForEach(sg_allShoreline, findSquadTarget)
				break
			else
				table.remove(t_shoreArtyTargets, k)
			end
		end
		if target ~= Marker_GetPosition(mkr_vp) then
			target = Util_GetRandomPosition(target, 5)
			g_propagandaBarrageCount = g_propagandaBarrageCount + 1
			Cmd_Ability(player3, ABILITY.SOVIET.FEAR_PROPAGANDA_ARTILLERY, target, nil, true)
		end
	end
end
	
-------------------- OBJECTIVE 2: Capture the German HQ Sector --------------------

function Initialize_Objective2()

	OBJ_BreachDefenses = {
		
		SetupUI = function() 
			-- Use for creating any hint points or UI Elements
			-- eg: Objective_AddUIElements()
		end,
		
		OnStart = function()
			Sound_PlayMusic("streamed/music/missions/m07/m07_cue_take_hq", 0, 0)
			Player_CompleteUpgrade(player1, UPG.SOVIET.FEAR_PROPAGANDA)
			Rule_AddDelayedInterval(Obj2_pingFearArtillery, 25, 1)
			Rule_AddDelayedInterval(Obj2_CheckCompletion, 5, 3)
			vpPing = Objective_AddUIElements(OBJ_BreachDefenses, eg_vp, true, 2099301, true, 8.2)
			A2M01_SetupPatrols(2)
			A2M01_SetupBaseInterior()
			Player_SetPopCapOverride(player1, t_difficulty.popCapOverride2)
			eventCue_popCapIncrease = UI_CreateEventCue("Icons_events_event_cue_upgrade", "", 11045310, 11045310, 30, true) -- LOCDB [11045310] 'Population Cap Increased'
			function _flashEventCue() flashID_popCap = UI_FlashEventCue(eventCue_popCapIncrease, true) end
			function _stopFlashingEventCue() UI_StopFlashing(flashID_popCap) end
			Rule_AddOneShot(_flashEventCue, 1)
			Rule_AddOneShot(_stopFlashingEventCue, 10)
			
			-- Secondary Howitzer
			if not SGroup_IsEmpty(sg_e_howitzer2) and not g_easyDiff then
				g_secondHowitzerIndex = 1
				g_secondHowitzerTime = World_GetGameTime()
				Rule_AddDelayedInterval(Obj2_fireSecondHowitzer, 15, 75)
			end
			
			-- Add Beginner Hints for SU-76 and mortar barrage
			if not g_easyDiff and not g_hardDiff then
				eg_HMG_garrisons = EGroup_CreateIfNotFound("eg_HMG_garrisons")
				EGroup_AddEGroup(eg_HMG_garrisons, eg_HMG1)
				EGroup_AddEGroup(eg_HMG_garrisons, eg_HMG2)
				EGroup_AddEGroup(eg_HMG_garrisons, eg_HMG3)
				EGroup_AddEGroup(eg_HMG_garrisons, eg_HMG4)
				local f = function(gid, idx, eid)
					if Entity_IsValid(Entity_GetGameID(eid)) then
						if (Entity_IsAlive(eid) == false) or Util_GetPlayerOwner(eid) ~= player2 then
							EGroup_Remove(eg_HMG_garrisons, eid)
						end
					end
				end
				EGroup_ForEach(eg_HMG_garrisons, f)
				if not EGroup_IsEmpty(eg_HMG_garrisons) then
					g_barrageTargetCount = EGroup_Count(eg_HMG_garrisons)
					if g_easyDiff then
						hintID_barrage = BeginnerHint_AddOpportunity(eg_HMG_garrisons,{ABILITY.SOVIET.SYNC_MORTAR_BARRAGE_120MM, ABILITY.SOVIET.SU_76_BARRAGE_ABILITY}, nil, 11043081, nil, nil, nil, true)
					else
						hintID_barrage = BeginnerHint_AddOpportunity(eg_HMG_garrisons,{ABILITY.SOVIET.SYNC_MORTAR_BARRAGE_120MM, ABILITY.SOVIET.SU_76_BARRAGE_ABILITY}, nil, 11043081)
					end
					Rule_AddInterval(BegHint_barrageUpdate, 1)
				end
			end
			
			Rule_AddDelayedInterval(Ambient_FlavorSpeech1, 30, 10)
			
			-- Achievements
			Rule_AddInterval(Achievement_Vet3Suchka, 1)
			
		end,
		
		OnComplete = function()
			-- Calls from Objective_Complete(OBJ_Objective1)
			-- Fires off before Intel_Complete (unless Intel_Complete is nil)	
			function delayStartThirdObjective() Objective_Start(OBJ_DefendTerritory) end
			Rule_AddOneShot(delayStartThirdObjective, 6)
			Player_SetEntityProductionAvailability(player1, EBP.SOVIET.MOTORPOOL, ITEM_UNLOCKED)
			EGroup_DeSpawn(eg_bigBlocker)
			EGroup_DeSpawn(eg_bigBlocker2)
			Sound_StopMusic(CAMPAIGN_MUSIC_FADEOUT,0)
		end,
		
		OnFail = function()
			-- Calls from Objective_Fail(OBJ_Objective1)
			-- Fires off before Intel_Fail (unless Intel_Fail is nil)			
		end,
		
		IsComplete = function()

		end,
		
		
		Intel_Start = nil,				-- Event will play when obj starts but before any UI appears
		Intel_Complete = EVENTS.BreachComplete,			-- Event will play when obj completes but before UI is cleared
		Intel_Fail = nil,				-- Event will play when obj fails but before UI is cleared
		Title = 11045331, -- LOCDB [11045331] 'Capture the German HQ sector'
		Description = 11045325,
		TitleEnd = 11045332, -- LOCDB [11045332] 'Enemy sector captured'
		TitleFail = nil,			-- Failed Title
		Type = OT_Primary,				-- Objective Type (OT_Primary, OT_Secondary)

	}
	
	Objective_Register(OBJ_BreachDefenses)


end

function Obj2_CheckCompletion()
	-- Objective completes if German HQ territory is captured
	if ( EGroup_IsCapturedByPlayer(eg_vp, player1, ALL) ) and SGroup_IsEmpty(sg_e_baseInterior) then -- 
		if not EGroup_IsEmpty(eg_germanBaseBuildings) then
			Modify_ReceivedDamage(eg_germanBaseBuildings, 10)
			Player_SetAbilityAvailability(player2, BP_GetAbilityBlueprint("fire_dot"), ITEM_UNLOCKED)
			Player_AddAbility(player2, BP_GetAbilityBlueprint("fire_dot"))
			Cmd_Ability(player2, BP_GetAbilityBlueprint("fire_dot"), EGroup_GetPosition(eg_germanBaseBuildings), nil, true)
			Rule_AddInterval(Obj2_burnEnemyBase, 20)
		end
		Objective_Complete(OBJ_BreachDefenses)
		Rule_RemoveMe()
	end
end

function Obj2_burnEnemyBase()
	if EGroup_IsEmpty(eg_germanBaseBuildings) then
		Rule_RemoveMe()
	else
		Cmd_Ability(player2, BP_GetAbilityBlueprint("fire_dot"), EGroup_GetPosition(eg_germanBaseBuildings), nil, true)
	end
end

function Obj2_pingFearArtillery()
	if Player_GetResource(player1, RT_Munition) > 100 then
		flashID_fear = UI_FlashAbilityButton(ABILITY.SOVIET.FEAR_PROPAGANDA_ARTILLERY, true)
		Rule_AddOneShot(Obj2_removeFearPing, 4)
		Rule_RemoveMe()
	end
end

function Obj2_removeFearPing()
	if flashID_fear ~= nil then
		UI_StopFlashing(flashID_fear)
	end
end

function BegHint_barrageUpdate()
	if EGroup_IsEmpty(eg_HMG_garrisons) then
		Rule_RemoveMe()
		return
	end
	local f = function(gid, idx, eid)
		if Entity_IsValid(Entity_GetGameID(eid)) then 
			if (Entity_IsAlive(eid) == false) or Util_GetPlayerOwner(eid) ~= player2 then
				EGroup_Remove(eg_HMG_garrisons, eid)
			end
		end
	end
	EGroup_ForEach(eg_HMG_garrisons, f)
	if not EGroup_IsEmpty(eg_HMG_garrisons) then
		g_barrageTargetCount = EGroup_Count(eg_HMG_garrisons)
	end
end

function Ambient_FlavorSpeech1()
	local player1Squads = Player_GetSquads(player1)
	if SGroup_IsUnderAttack(player1Squads, ANY, 10) == false and SGroup_IsDoingAttack(player1Squads, ANY, 10) == false then
		local f = function (gid, idx, sid) 
			if not Misc_IsSquadOnScreen(sid, 0.75) then
				SGroup_Remove(player1Squads, sid)
			end
		end
		SGroup_ForEach(player1Squads, f)
		if not SGroup_IsEmpty(player1Squads) and not Event_IsAnyRunning() then
			Sound_PlayOnSquad("speech/sp/mission/m07/11046843", player1Squads)
			Rule_RemoveMe()
		end
	end
end


-------------------- OBJECTIVE 3: Hold out against a German counter-attack --------------------

function Initialize_Objective3()

	OBJ_DefendTerritory = {
		
		SetupUI = function() 
			-- Use for creating any hint points or UI Elements
			-- eg: Objective_AddUIElements()
			vpPing = Objective_AddUIElements(OBJ_DefendTerritory, eg_vp, true, 11008183, true, 3.5, nil, HPAT_Objective)
			flashID_defend = UI_FlashObjectiveIcon(OBJ_DefendTerritory.ID, true)
		end,
		
		OnStart = function()
			Sound_PlayMusic("streamed/music/missions/m07/m07_cue_hold_hq", 0, 0)
			Player_CompleteUpgrade(player1, UPG.SOVIET.SCORCHED_EARTH_POLICY)
			EGroup_SetWorldOwned(eg_germanBarracks)
			
			--The counterAttack encounter
			g_enc_counterAttacks = nil
			sg_counterAttackers = SGroup_CreateIfNotFound("sg_counterAttackers")
			sg_counterAttackers_armor = SGroup_CreateIfNotFound("sg_counterAttackers_armor")
			sg_counterAttackers_inf = SGroup_CreateIfNotFound("sg_counterAttackers_inf")
			g_armorTable = {SBP.GERMAN.STUG_III_E_SQUAD, SBP.GERMAN.PANZER_IV_SQUAD, SBP.GERMAN.SCOUTCAR_SDKFZ222}
			g_infantryTable = {SBP.GERMAN.OSTRUPPEN_SQUAD, SBP.GERMAN.GRENADIER_SQUAD, SBP.GERMAN.PANZER_GRENADIER_SQUAD}
			g_counterAttackCount = 1
			Rule_AddDelayedInterval(Obj3_CheckCompletion, 5, 5)

			--Using AI Manager
			g_enc_counterAttack_inf = {}
			g_enc_counterAttack_arm = {}
			g_enemiesRemaining = 1
			Rule_AddOneShot(Obj3_WaveManager, 20)
			g_loseTerritoryCounter = 0
			A2M01_SetupPatrols(3)
			
			-- Tell the player to set rally points near captured German HQ
			hint_rally = HintPoint_Add(mkr_rallyPoint, true, 11045333, nil, HPAT_RallyPoint, "Icons_commands_icon_command_rallypoint") -- LOCDB [11045333] 'Set rally points here for faster squad deployment'
			g_hasSeenRally = false
			_m7_removeRallyHint = function()
				if g_hasSeenRally then
					HintPoint_Remove(hint_rally)
				elseif Player_CanSeePosition(player1, Marker_GetPosition(mkr_rallyPoint)) and Misc_IsPosOnScreen(Marker_GetPosition(mkr_rallyPoint), 0.5) then 
					g_hasSeenRally = true
					Rule_RemoveMe()
					Rule_AddOneShot(_m7_removeRallyHint, 20)
				end
			end
			Rule_AddInterval(_m7_removeRallyHint, 2)
			Obj3_SetRallyPoints()
			
			-- Try to keep the player off the footbridge
			Rule_AddInterval(_clearFootbridge, 8)
			
		end,
		
		OnComplete = function()
			Sound_StopMusic(CAMPAIGN_MUSIC_FADEOUT,0)
			Util_StartAmbient(EVENTS.German_Panic_03)
			-- Calls from Objective_Complete(OBJ_Objective1)
			-- Fires off before Intel_Complete (unless Intel_Complete is nil)	
			
			EGroup_ReSpawn(eg_flag)
			Rule_AddOneShot(delayStartFourthObjective, 6)
			Rule_RemoveIfExist(Obj3_CheckCompletion)
			World_IncreaseInteractionStage()
			EGroup_EnableMinimapIndicator(eg_mm_unlock2, true)			
			eg_p_retreatPoints = EGroup_CreateIfNotFound("eg_p_retreatPoints")
			EGroup_SetPlayerOwner(eg_germanBarracks, player1)
			Player_RemoveUpgrade(player1, UPG.SOVIET.HQ_HEALING_AURA)
			Cmd_InstantUpgrade(eg_forwardHQ, UPG.SOVIET.HQ_HEALING_AURA)
			sg_p_reinforcingSquads = SGroup_CreateIfNotFound("sg_p_reinforcingSquads")
			hint_retreatPoint = HintPoint_Add(eg_forwardHQ, true, 11045334) -- LOCDB [11045334] 'Field HQ:  Infantry can now reinforce and heal at this location'
			Util_SetPlayerOwner(eg_germanBarracks, player1)
			EGroup_SetSelectable(eg_germanBarracks, true)
			Rule_AddDelayedInterval(Obj3_RemoveBaseHint, 15, 5)
		end,
		OnFail = function()
			Game_EndSP(false)
		end,
		
		IsComplete = function()
		end,
		
		
		Intel_Start = EVENTS.DefendStart,				-- Event will play when obj starts but before any UI appears
		Intel_Complete = nil,			-- Event will play when obj completes but before UI is cleared
		Intel_Fail = EVENTS.LostHQ,				-- Event will play when obj fails but before UI is cleared
		Title = 11045335, -- LOCDB [11045335] 'Defend the German HQ sector'
		Description = 11045335, -- LOCDB [11045335] 'Defend the German HQ sector'
		TitleEnd = 11045336,	-- LOCDB [11045336] 'Sector defended'
		TitleFail = 11019373,			-- Failed Title
		Type = OT_Primary,				-- Objective Type (OT_Primary, OT_Secondary)
	}
	
	Objective_Register(OBJ_DefendTerritory)

end

function delayStartFourthObjective()
	Game_Letterbox(true, 1)
	Camera_ResetToDefault()
	Camera_SetSlideTargetRate(0.5)
	Rule_AddOneShot(_showForwardHQ1, 2)
end

function _showForwardHQ1()
	Camera_MoveTo(eg_forwardHQ, true, 0.5)  
	Rule_AddOneShot(_showForwardHQ2, 2)
end

function _showForwardHQ2()
	Game_Letterbox(false, 1) 
	Camera_SetInputEnabled(true)
	Objective_Start(OBJ_DestroyStrongholds)
end


function Obj3_SetRallyPoints()
	if not EGroup_IsEmpty(eg_p_hq) then
		Command_EntityPos(player1, eg_p_hq, CMD_RallyPoint, Marker_GetPosition(mkr_rallyPoint))
	end
	if not EGroup_IsEmpty(eg_p_barracks) then
		Command_EntityPos(player1, eg_p_barracks, CMD_RallyPoint, Marker_GetPosition(mkr_rallyPoint))
	end
	if not EGroup_IsEmpty(eg_p_wsc) then
		Command_EntityPos(player1, eg_p_wsc, CMD_RallyPoint, Marker_GetPosition(mkr_rallyPoint))
	end
	if not EGroup_IsEmpty(eg_p_lightfactory) then
		Command_EntityPos(player1, eg_p_lightfactory, CMD_RallyPoint, Marker_GetPosition(mkr_rallyPoint))
	end
end

function Obj3_RemoveBaseHint()
	Player_GetAllSquadsNearMarker(player1, sg_p_reinforcingSquads, mkr_retreatPoint, 15)
	if SGroup_IsReinforcing(sg_p_reinforcingSquads, ANY) then
		HintPoint_Remove(hint_retreatPoint)
		SGroup_Destroy(sg_p_reinforcingSquads)
		Rule_RemoveMe()
	end
end

function Obj3_CheckCompletion()
	-- Objective completes if enemy attackers are defeated and HQ territory is held
	-- Objective and mission is failed if HQ territory is captured and held by Germans for too long
	if g_defended and SGroup_IsEmpty(sg_counterAttackers) then
		if flashID_defend ~= nil then
			UI_StopFlashing(flashID_defend)
		end
		Objective_Complete(OBJ_DefendTerritory)
		Rule_RemoveIfExist(_losingHQReminder)
		Rule_RemoveMe()
	elseif Util_GetPlayerOwner(eg_vp) == player2 then
		if g_loseTerritoryCounter == 0 then
			Objective_StartTimer(OBJ_DefendTerritory, COUNT_DOWN, 120, 90)
			Objective_UpdateText(OBJ_DefendTerritory, 11045337, 11045337, true) -- LOCDB [11045337] 'Reclaim the German HQ sector'
			Objective_SetAlwaysShowDetails(OBJ_DefendTerritory, true, false, false)
			flashID_defend = UI_FlashObjectiveIcon(OBJ_DefendTerritory.ID, true)
			Rule_AddOneShot(_losingHQReminder, 30)
		end
		g_loseTerritoryCounter = g_loseTerritoryCounter + 5
		if g_loseTerritoryCounter <= 120 then
			local timerSeconds = Objective_GetTimerSeconds(OBJ_DefendTerritory)
			local message = Loc_FormatText(11045653, Loc_ConvertNumber(timerSeconds)) -- LOCDB [11045653] 'Sector lost in %1SECONDS% seconds'
			UI_CreateEntityKickerMessage(World_GetPlayerAt(1), EGroup_GetRandomSpawnedEntity(eg_vp), message)
		end
		if g_loseTerritoryCounter > 120 then
			Objective_Fail(OBJ_DefendTerritory)
			Rule_RemoveMe()
		end
	elseif (World_OwnsEGroup(eg_vp, ANY) or Util_GetPlayerOwner(eg_vp) == player1) and g_loseTerritoryCounter > 0 then
		g_loseTerritoryCounter = 0
		UI_StopFlashing(flashID_defend)
		Objective_UpdateText(OBJ_DefendTerritory, 11045335, 11045335, false) -- LOCDB [11045335] 'Defend the German HQ sector'
		Objective_SetAlwaysShowDetails(OBJ_DefendTerritory, false, false, false)
		Objective_StopTimer(OBJ_DefendTerritory)
	end
	
end

function _losingHQReminder()
	if Util_GetPlayerOwner(eg_vp) == player2 then 
		Util_StartIntel(EVENTS.LosingHQ)
	end
end

function _clearFootbridge()
	if g_defended or EGroup_IsEmpty(eg_bridge_small) then
		Rule_RemoveMe()
	else
		sg_p_onFootbridge = SGroup_CreateIfNotFound("sg_p_onFootbridge")
		Player_GetAllSquadsNearMarker(player1, sg_p_onFootbridge, mkr_footbridge)
		if not SGroup_IsEmpty(sg_p_onFootbridge) then
			Cmd_Ability(player2, ABILITY.GLOBAL.SP_SINGLE_SHOT_MORTAR, sg_p_onFootbridge, nil, true)
		end
	end
end

function Obj3_WaveManager()
	-- German attackers during Objective 3
	ThreatArrow_CreateGroup(sg_counterAttackers)
	Util_ClearWrecksFromMarker(mkr_clearWrecks)
	if(g_counterAttackCount == 1) then
		Util_StartAmbient(EVENTS.German_Panic_02)
		Obj_ShowProgress(11045338, 1) -- LOCDB [11045338] 'Enemies remaining...'
		g_counterAttackCount = g_counterAttackCount + 1
		Obj3_SpawnInfantry(1)
		Obj3_SpawnArmor(1)
		Rule_AddSGroupEvent(Obj3_EnemiesRemaining, sg_counterAttackers, GE_SquadKilled)
		Objective_RemoveUIElements(OBJ_DefendTerritory, vpPing)
		UI_StopFlashing(flashID_defend)
		vpPing = Objective_AddUIElements(OBJ_DefendTerritory, eg_vp, true, nil, true, nil, nil, HPAT_Objective)
		Rule_AddOneShot(Obj3_ClearAttackerGroup, 120)
	elseif(g_counterAttackCount == 2 and SGroup_Count(sg_counterAttackers) < 2) then
		g_counterAttackCount = g_counterAttackCount + 1
		Obj3_SpawnInfantry(2)
		Obj3_SpawnArmor(2)
		Rule_RemoveSGroupEvent(Obj3_EnemiesRemaining, sg_counterAttackers)
		Rule_AddSGroupEvent(Obj3_EnemiesRemaining, sg_counterAttackers, GE_SquadKilled)
		Rule_RemoveIfExist(Obj3_ClearAttackerGroup)
		Rule_AddOneShot(Obj3_ClearAttackerGroup, 150)
	elseif(g_counterAttackCount == 3 and SGroup_Count(sg_counterAttackers) < 2) then
		Util_StartIntel(EVENTS.DefendTankArrival)
		g_counterAttackCount = g_counterAttackCount + 1
		Obj3_SpawnInfantry(3)
		Obj3_SpawnArmor(3)
		Rule_RemoveSGroupEvent(Obj3_EnemiesRemaining, sg_counterAttackers)
		Rule_AddSGroupEvent(Obj3_EnemiesRemaining, sg_counterAttackers, GE_SquadKilled)
		Rule_RemoveIfExist(Obj3_ClearAttackerGroup)
		Rule_AddOneShot(Obj3_ClearAttackerGroup, 180)
	elseif(g_counterAttackCount == 4 and SGroup_Count(sg_counterAttackers) < 2) then
		Util_StartIntel(EVENTS.DefendAlmostDone)
		g_counterAttackCount = g_counterAttackCount + 1
		Obj3_SpawnInfantry(4)
		Obj3_SpawnArmor(4)
		Rule_RemoveSGroupEvent(Obj3_EnemiesRemaining, sg_counterAttackers)
		Rule_AddSGroupEvent(Obj3_EnemiesRemaining, sg_counterAttackers, GE_SquadKilled)
		Rule_RemoveIfExist(Obj3_ClearAttackerGroup)
		Rule_AddOneShot(Obj3_ClearAttackerGroup, 180)
	elseif(g_counterAttackCount >= 5 and SGroup_IsEmpty(sg_counterAttackers)) then
		g_defended = true
		Rule_RemoveSGroupEvent(Obj3_EnemiesRemaining, sg_counterAttackers)
		Obj_HideProgress()
	end
	ThreatArrow_CreateGroup(sg_counterAttackers)
end

function Obj3_EnemiesRemaining(squad)	
	if scartype(squad) == ST_SQUAD then
		if Squad_IsValid(Squad_GetGameID(squad)) then
			g_enemiesRemaining = math.max((g_enemiesRemaining - 0.04), 0.05)
			Obj_ShowProgress(11045338, g_enemiesRemaining) -- LOCDB [11045338] 'Enemies remaining...'
		end
	end
end

function Obj3_ClearAttackerGroup()
	if g_counterAttackCount < 5 and table.getn(g_enc_counterAttack_inf) >= (g_counterAttackCount - 1) then
		if Player_OwnsEGroup(player1, eg_vp) then
			g_enc_counterAttack_inf[(g_counterAttackCount - 1)]:SetOnDeath(nil)
			Obj3_WaveManager()
		else
			Rule_RemoveIfExist(Obj3_ClearAttackerGroup)
			Rule_AddOneShot(Obj3_ClearAttackerGroup, 30)
		end
	end
end

function Obj3_SpawnInfantry(num)
	local sbp1 = g_infantryTable[1]
	local sbp2 = g_infantryTable[2]

	if num == 2 then
		sbp1 = g_infantryTable[2]
		sbp2 = g_infantryTable[1]		
	elseif num == 3 then
		sbp1 = g_infantryTable[2]
		sbp2 = g_infantryTable[3]	
	elseif num == 4 then
		sbp1 = g_infantryTable[3]
		sbp2 = g_infantryTable[2]	
	end
	
	local encData = {
		name = "counterAttackWave_inf_" .. num,
		player = player2,
		sgroups = {sg_counterAttackers, sg_counterAttackers_inf},
		units = {
			{
				name = "counter_inf_" .. num,
				spawn = mkr_counterAttack2,
				sbp = sbp1,
				veterancyRank = World_GetRand(0, t_difficulty.veterancyRank),
			},
			{
				name = "counter_inf2_" .. num,
				spawn = mkr_counterAttack2,
				sbp = sbp1,
				veterancyRank = World_GetRand(0, t_difficulty.veterancyRank),
			},
			{
				name = "counter_inf3_" .. num,
				spawn = mkr_counterAttack3,
				sbp = sbp2,
				veterancyRank = World_GetRand(0, t_difficulty.veterancyRank),
			}
		},
		onDeath = Obj3_WaveManager
	}
	
	if num == 2 then
		encData.units[1].upgrades = {UPG.GERMAN.GRENADIER_MG42_LMG}
	elseif num == 3 then
		encData.units[2].upgrades = {UPG.GERMAN.GRENADIER_MG42_LMG}
	elseif num == 4 then
		encData.units[2].upgrades = {UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM}
		encData.units[2].dropItems = {{slotItem = SLOT_ITEM.PANZERSHRECK, dropChance = 0, exclusive = true}}
	end
	
	if Player_GetCurrentPopulation(player1, CT_Personnel) >= 75 and not g_easyDiff then
		table.insert(encData.units, encData.units[table.getn(encData.units)])
	elseif Player_GetCurrentPopulation(player1, CT_Personnel) < 40 then
		if table.getn(encData.units) > 1 then
			table.remove(encData.units)
		end
	end
	
	g_enc_counterAttack_inf[num] = Encounter:Create(encData)
	
	local goalData = {
		name = "Defend",
		target = mkr_vp,
		safeMoveWeight = 0,
		useSkirmishAI = g_useSkirmishAI,
		range = 35,
		coordinatedMoveRadius = 75,
		leashRange = 18
	}
	g_enc_counterAttack_inf[num]:SetGoal(goalData)
end

function Obj3_SpawnArmor(num)
	local encData = {
		name = "counterAttackWave_arm_" .. num,
		player = player2,
		sgroups = {sg_counterAttackers},
		units = {
			{
				name = "counter_arm_" .. num .. "-1",
				sbp = g_armorTable[1],
				spawn = mkr_counterAttack1,
				veterancyRank = World_GetRand(0, t_difficulty.veterancyRank),
			},
			{
				name = "counter_arm_" .. num .. "-2",
				sbp = g_armorTable[2],
				spawn = mkr_counterAttack4,
				veterancyRank = World_GetRand(0, t_difficulty.veterancyRank),
			}
		},
		onDeath = Obj3_WaveManager
	}
	
	if(num == 1 or num == 2) then
		encData.units = {
			{
				name = "counter_arm_" .. num,
				sbp = g_armorTable[3],
				spawn = mkr_counterAttack1
			}
		}
		if num  == 2 then
			encData.units[1].entityUpgrades = {UPG.GERMAN.SDKFZ_222_20MM_GUN}
		end
	end
	-- Add more attacking squads if player's army is large
	-- Remove attacking squads if player's army is small
	if Player_GetCurrentPopulation(player1, CT_Personnel) > 75 and not g_easyDiff then
		table.insert(encData.units, encData.units[table.getn(encData.units)])
	elseif Player_GetCurrentPopulation(player1, CT_Personnel) < 40 then
		if table.getn(encData.units) > 1 then
			table.remove(encData.units)
		end
	end
	
	g_enc_counterAttack_arm[num]  = Encounter:Create(encData)
	
--~ 	sg_p_nearCenter = SGroup_CreateIfNotFound("sg_p_nearCenter")
--~ 	sg_p_nearCenter_target = SGroup_CreateIfNotFound("sg_p_nearCenter_target")
--~ 	Player_GetAllSquadsNearMarker(player1, sg_p_nearCenter, World_GetTerritorySectorID(World_Pos(12, 21, -62)))
--~ 	local attackTarget = mkr_vp
--~ 	if(not SGroup_IsEmpty(sg_p_nearCenter)) then
--~ 		SGroup_Add(sg_p_nearCenter_target, SGroup_GetRandomSpawnedSquad(sg_p_nearCenter))
--~ 	end

	local attackTarget = Marker_FromName("mkr_enemyDefendLeash" .. tostring(num), "")
	
	local goalData = {
		name = "Attack",
		target = attackTarget,
		useSkirmishAI = g_useSkirmishAI,
		safeMoveWeight = 0, 
		range = 40,
		leashRange = 22,
		coordinatedMoveRadius = 25,
		tacticControlsList = {
			{
				tacticType = TACTIC_Vehicle,
				maxUsers = 1,
				maxRange = 10,
				retryTimeSecs = 45,
				waitTimeSecs = 22,
				useInitialWaitTime = true,
				priority = 1,
			},
			{
				tacticType = TACTIC_Avoid,
				priority = -1,
			},
		}
	}	
	
	if num == 1 or num == 2 then
		goalData.safeMoveWeight = 0
	end
	
	g_enc_counterAttack_arm[num]:SetGoal(goalData)
	
end

-------------------- OBJECTIVE 4: Destroy the remaining enemy garrisons --------------------

function Initialize_Objective4()

	OBJ_DestroyStrongholds = {
		
		SetupUI = function() 
			-- Use for creating any hint points or UI Elements
			-- eg: Objective_AddUIElements()
		end,
		
		OnStart = function()
			Sound_PlayMusic("streamed/music/missions/m07/m07_cue_destroy_strongholds", 0, 0)
			g_trainStationCleared = false
			g_powerPlantCleared = false
			trainStationPing = Objective_AddUIElements(OBJ_DestroyStrongholds, EGroup_GetPosition(eg_trainStation), true, 11047613, true, 15)
			powerPlantPing = Objective_AddUIElements(OBJ_DestroyStrongholds, EGroup_GetPosition(eg_powerPlant), true, 11047613, true, 15)
			Rule_AddDelayedInterval(Obj4_CheckCompletion, 5, 3)
			Obj4_SetupStrongholds()
			SGroup_SetInvulnerable(sg_e_westernLine, false)
			Modify_ReceivedDamage(sg_e_westernLine, 3)
			Modify_WeaponAccuracy(sg_e_westernLine, "hardpoint_01", 0.1)
			
			Modifier_Remove(mod_receivedAcc)
			EGroup_SetInvulnerable(eg_trainStation, false)
			EGroup_SetAvgHealth(eg_trainStation, 0.65)
			EGroup_SetInvulnerable(eg_powerPlant, false)
			EGroup_SetAvgHealth(eg_powerPlant, 0.55)
			A2M01_SetupBunkerLine(2)			Player_SetPopCapOverride(player1, t_difficulty.popCapOverride3)
			eventCue_popCapIncrease = UI_CreateEventCue("Icons_events_event_cue_upgrade", "", 11045310, 11045310, 30, true)
			function _flashEventCue() flashID_popCap = UI_FlashEventCue(eventCue_popCapIncrease, true) end
			function _stopFlashingEventCue() UI_StopFlashing(flashID_popCap) end
			Rule_RemoveIfExist(_flashEventCue)
			Rule_RemoveIfExist(_stopFlashingEventCue)
			Rule_AddOneShot(_flashEventCue, 1)
			Rule_AddOneShot(_stopFlashingEventCue, 10)
			
			if not g_hardDiff then
				BeginnerHint_AddOpportunity({mkr_smokeGrenadeHint1, mkr_smokeGrenadeHint2, mkr_smokeGrenadeHint3},ABILITY.SOVIET.RGD_1_SMOKE_GRENADE)
			end
			
			-- Start bonus objective: capture two high-ground territories
			Rule_AddDelayedInterval(Obj4_StartBonusObjective, 30, 3)
			
			sg_e_counterArty = SGroup_CreateIfNotFound("sg_e_counterArty")
			sg_p_northHowitzer = SGroup_CreateIfNotFound("sg_p_northHowitzer")
			g_counterArtyInterval = 60
			g_counterArtySuccessCount = 0
			Rule_AddDelayedInterval(Obj4_counterPlayerArtilllery, 30, g_counterArtyInterval)
			
		end,
		
		OnComplete = function()
			-- Calls from Objective_Complete(OBJ_Objective1)
			-- Fires off before Intel_Complete (unless Intel_Complete is nil)	
		end,
		
		OnFail = function()
			-- Calls from Objective_Fail(OBJ_Objective1)
			-- Fires off before Intel_Fail (unless Intel_Fail is nil)			
		end,
		
		IsComplete = function()

		end,
		
		
		Intel_Start = EVENTS.DestroyStart,				-- Event will play when obj starts but before any UI appears
		Intel_Complete = EVENTS.DestroyComplete,			-- Event will play when obj completes but before UI is cleared
		Intel_Fail = nil,				-- Event will play when obj fails but before UI is cleared
		Title = 11045339,	-- LOCDB [11045339] 'Destroy the two remaining strongholds'
		Description = 11045339,	-- LOCDB [11045339] 'Destroy the two remaining strongholds'
		TitleEnd = 11045340, -- LOCDB [11045340] 'German forces are in retreat'
		TitleFail = 1459052,			-- Failed Title
		Type = OT_Primary,				-- Objective Type (OT_Primary, OT_Secondary)
	}
	
	Objective_Register(OBJ_DestroyStrongholds)

end

function Obj4_CheckCompletion()
	-- Objective completes and mission is won if both garrisons are destroyed or empty
	if (EGroup_IsEmpty(eg_trainStation) or not EGroup_IsHoldingAny(eg_trainStation)) and not g_trainStationCleared then
		Objective_RemoveUIElements(OBJ_DestroyStrongholds, trainStationPing)
		g_trainStationCleared = true
		Util_MissionTitle(11045341) -- LOCDB [11045341] 'German stronghold destroyed'
		if not g_powerPlantCleared then
			g_panicSoundEntity = EGroup_GetRandomSpawnedEntity(eg_train_sound)
			Util_StartIntel(EVENTS.German_Panic_04)
		end
		if not g_volkhovAlliesSpawned then
			Obj4_SpawnAllies()
		end
	end
	if (EGroup_IsEmpty(eg_powerPlant) or not EGroup_IsHoldingAny(eg_powerPlant)) and not g_powerPlantCleared then
		Objective_RemoveUIElements(OBJ_DestroyStrongholds, powerPlantPing)
		g_powerPlantCleared = true
		Util_MissionTitle(11045341) -- LOCDB [11045341] 'German stronghold destroyed'
		if not g_trainStationCleared then
			g_panicSoundEntity = EGroup_GetRandomSpawnedEntity(eg_power_sound)
			Util_StartIntel(EVENTS.German_Panic_04)
		end
		if not g_volkhovAlliesSpawned then
			Obj4_SpawnAllies()
		end
	end
	if (g_trainStationCleared and g_powerPlantCleared) or SGroup_IsEmpty(sg_e_final) then
		local enemySquads = Player_GetSquads(player2)
		Modify_ReceivedDamage(enemySquads, 10)
		Modify_ReceivedAccuracy(enemySquads, 10)
		Modify_Armor(enemySquads, 0.1)
		Cmd_UngarrisonSquad(enemySquads)
		Cmd_Retreat(enemySquads, World_Pos(-160, 8, 0))
		Cmd_UngarrisonSquad(sg_e_builtAT)
		Cmd_Retreat(sg_e_builtAT, World_Pos(-160, 8, 0))
		Cmd_UngarrisonSquad(sg_e_builtInfantry)
		Cmd_Retreat(sg_e_builtInfantry, World_Pos(-160, 8, 0))
		Objective_Complete(OBJ_DestroyStrongholds)
		Rule_RemoveMe()
		
		--Achievements
		Achievement_CloseRange()
		if Rule_Exists(Achievement_NoMortarsAllowed) then
			Scar_CompleteIntelBulletinTask(player1, "camp07_landbridge_mortars")
			Rule_Remove(Achievement_NoMortarsAllowed)
		end
	end
end

function Obj4_StartBonusObjective()
	if Player_CanSeeEGroup(player1, eg_objStrats, ANY) and EGroup_IsOnScreen(player1, eg_objStrats, ANY) then
		if not g_volkhovAlliesSpawned then
			Objective_Start(OBJ_HighGround, true)
		end
		Rule_RemoveMe()
	end
end


function Obj4_SetupStrongholds()
	-- Spawn enemy squads in and around final garrisons
	-- Retreat some other enemy squads to those locations
	g_enc_powerPlant = {}
	g_enc_trainStation = {}
	
	sg_e_atPowerPlant = SGroup_CreateIfNotFound("sg_e_atPowerPlant")
	sg_e_atTrainStation = SGroup_CreateIfNotFound("sg_e_atTrainStation")
	sg_e_powerTanks = SGroup_CreateIfNotFound("sg_e_powerTanks")
	sg_e_trainTanks = SGroup_CreateIfNotFound("sg_e_trainTanks")
	sg_e_pak43s = SGroup_CreateIfNotFound("sg_e_pak43s")
	
	if g_enc_counterAttack_inf ~= nil then
		for k,v in pairs(g_enc_counterAttack_inf) do
			if v:IsAlive() then
				v:Disable()
			end
		end
	end
	
	if g_enc_sandbags ~= nil then
		for k,v in pairs(g_enc_sandbags) do
			if v:IsAlive() then
				v:Disable()
			end
		end
	end
	
	if g_enc_shoreline ~= nil then
		for k,v in pairs(g_enc_shoreline) do
			if v:IsAlive() then
				v:Disable()
			end
		end
	end
	
	Player_GetAll(player2, sg_e_all)
	SGroup_Filter(sg_e_all, {SBP.GERMAN.GRENADIER_SQUAD, SBP.GERMAN.PANZER_GRENADIER_SQUAD, SBP.GERMAN.OSTRUPPEN_SQUAD}, FILTER_KEEP)
	
	for k,v in pairs(g_enc_patrols) do 
		if v:IsAlive() then
			SGroup_RemoveGroup(sg_e_all, v.sgroup)
		end
	end
	
	for k,v in pairs(g_enc_strats) do 
		if v:IsAlive() then
			SGroup_RemoveGroup(sg_e_all, v.sgroup)
		end
	end
	
	local groupCount = SGroup_Count(sg_e_all)
	if groupCount >= 2 then
		_sgp_all1 = SGroup_CreateIfNotFound("_sgp_all1")
		_sgp_all2 = SGroup_CreateIfNotFound("_sgp_all2")
		for i = 1, math.floor(groupCount/2) do 
			SGroup_Add(_sgp_all1, SGroup_GetSpawnedSquadAt(sg_e_all, i))
			SGroup_Add(sg_e_atTrainStation, SGroup_GetSpawnedSquadAt(sg_e_all, i))
			Cmd_Retreat(_sgp_all1, Util_GetRandomPosition(mkr_trainStation))
			SGroup_Clear(_sgp_all1)
		end
		for i = math.ceil(groupCount/2), groupCount do 
			SGroup_Add(_sgp_all2, SGroup_GetSpawnedSquadAt(sg_e_all, i))
			SGroup_Add(sg_e_atPowerPlant, SGroup_GetSpawnedSquadAt(sg_e_all, i))
			Cmd_Retreat(_sgp_all2, Util_GetRandomPosition(mkr_powerPlant))
			SGroup_Clear(_sgp_all2)
		end
	end
	
	----- Power Plant
	local data = {
		name = "powerPlant1",
		player = player2,
		sgroups = {sg_e_final},
		units = {
			{
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
				upgrades = {UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM},
				spawn = eg_powerPlant,
			},
		}
	}
	g_enc_powerPlant[1] = Encounter:Create(data)
	
	local data = {
		name = "powerPlant2",
		player = player2,
		sgroups = {sg_e_final},
		units = {
			{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = eg_powerPlant,
			},
		}
	}
	g_enc_powerPlant[2] = Encounter:Create(data)
	
	local data = {
		name = "powerPlant3",
		player = player2,
		sgroups = {sg_e_final},
		units = {
			{
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
				upgrades = {UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM},
				spawn = eg_powerPlant,
			},
		}
	}
	g_enc_powerPlant[3] = Encounter:Create(data)
	
	local data = {
		name = "powerPlant4",
		player = player2,
		sgroups = {sg_e_final},
		units = {
			{
				sbp = SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD,
				spawn = eg_power_bunker1
			},
		}
	}
	g_enc_powerPlant[4] = Encounter:Create(data)
	
	local data = {
		name = "powerPlant5",
		player = player2,
		sgroups = {sg_e_final},
		units = {
			{
				sbp = SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD,
				spawn = eg_power_bunker2
			},
		}
	}
	g_enc_powerPlant[5] = Encounter:Create(data)
	
	local data = {
		name = "powerPlant6",
		player = player2,
		sgroups = {sg_e_final, sg_e_powerTanks},
		units = {
			{
				sbp = SBP.GERMAN.PANZER_IV_SQUAD,
				spawn = mkr_powerTank1
			},
		}
	}
	g_enc_powerPlant[6] = Encounter:Create(data)
	
		local goalData = {
			name = "Defend",
			useSkirmishAI = g_useSkirmishAI,
			target = mkr_powerTank1_defend,
			fallbackParams = {
				markers = {mkr_powerTank1},
				thresholds = {0.3},
			}
		}
		g_enc_powerPlant[6]:SetGoal(goalData)
	
	local data = {
		name = "powerPlant7",
		player = player2,
		sgroups = {sg_e_final, sg_e_powerTanks},
		units = {
			{
				sbp = SBP.GERMAN.STUG_III_SQUAD,
				spawn = mkr_powerTank2
			},
		}
	}
	g_enc_powerPlant[7] = Encounter:Create(data)
		
		goalData.target = mkr_powerTank2_defend
		goalData.fallbackParams = {
			markers = {mkr_powerTank2},
			thresholds = {0.4},
		}
		g_enc_powerPlant[7]:SetGoal(goalData)
		
	local data = {
		name = "powerPlant8",
		player = player2,
		sgroups = {sg_e_final, sg_e_pak43s},
		units = {
			{
				sbp = SBP.GERMAN.PAK43_88MM_AT_GUN_SQUAD,
				spawn = mkr_power_pak43
			},
		}
	}
	g_enc_powerPlant[8] = Encounter:Create(data)
	
		goalData.target = mkr_power_pak43
		goalData.range = 85
		g_enc_powerPlant[8]:SetGoal(goalData)
	
	----- Train Station
	local data = {
		name = "trainStation1",
		player = player2,
		sgroups = {sg_e_final},
		units = {
			{
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
				upgrades = {UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM},
				spawn = eg_trainStation,
			},
		}
	}
	g_enc_trainStation[1] = Encounter:Create(data)

	local data = {
		name = "trainStation2",
		player = player2,
		sgroups = {sg_e_final},
		units = {
			{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = eg_trainStation,
			},
		}
	}
	g_enc_trainStation[2] = Encounter:Create(data)	
	
	local data = {
		name = "trainStation3",
		player = player2,
		sgroups = {sg_e_final},
		units = {
			{
				sbp = SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD,
				spawn = eg_train_bunker1,
			},
		}
	}
	g_enc_trainStation[3] = Encounter:Create(data)	

	local data = {
		name = "trainStation4",
		player = player2,
		sgroups = {sg_e_final},
		units = {
			{
				sbp = SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD,
				spawn = eg_train_bunker2,
			},
		}
	}
	g_enc_trainStation[4] = Encounter:Create(data)	
	
	local data = {
		name = "trainStation5",
		player = player2,
		sgroups = {sg_e_final, sg_e_trainTanks},
		units = {
			{
				sbp = SBP.GERMAN.STUG_III_SQUAD,
				spawn = mkr_trainTank1,
			},
		}
	}
	g_enc_trainStation[5] = Encounter:Create(data)	
	
		local goalData = {
			name = "Defend",
			useSkirmishAI = g_useSkirmishAI,
			target = mkr_trainTank1_defend,
			fallbackParams = {
				markers = {mkr_trainTank1},
				thresholds = {0.3},
			}
		}
		g_enc_trainStation[5]:SetGoal(goalData)
	
	local data = {
		name = "trainStation6",
		player = player2,
		sgroups = {sg_e_final, sg_e_trainTanks},
		units = {
			{
				sbp = SBP.GERMAN.PANZER_IV_SQUAD,
				spawn = mkr_trainTank2,
			},
		}
	}
	g_enc_trainStation[6] = Encounter:Create(data)	
	
		goalData.target = mkr_trainTank2_defend
		goalData.fallbackParams = {
			markers = {mkr_trainTank2},
			thresholds = {0.4},
		}
		g_enc_trainStation[6]:SetGoal(goalData)
		
	local data = {
		name = "trainStation7",
		player = player2,
		sgroups = {sg_e_final, sg_e_pak43s},
		units = {
			{
				sbp = SBP.GERMAN.PAK43_88MM_AT_GUN_SQUAD,
				spawn = mkr_train_pak43
			},
		}
	}
	g_enc_trainStation[7] = Encounter:Create(data)
		
			goalData.target = mkr_train_pak43
			goalData.range = 85
		g_enc_trainStation[7]:SetGoal(goalData)
	if g_hardDiff then
		Modify_WeaponRange(sg_e_pak43s, "hardpoint_01", 1.666)
		Modify_SightRadius(sg_e_pak43s, 2)
	else
		Modify_WeaponRange(sg_e_pak43s, "hardpoint_01", 1.333)
	end
	
	sg_e_inPowerPlant = SGroup_CreateIfNotFound("sg_e_inPowerPlant")
	sg_e_inTrainStation = SGroup_CreateIfNotFound("sg_e_inTrainStation")
	sg_p_nearPowerPlant = SGroup_CreateIfNotFound("sg_p_nearPowerPlant")
	sg_p_nearTrainStation = SGroup_CreateIfNotFound("sg_p_nearTrainStation")
	EGroup_GetSquadsHeld(eg_powerPlant, sg_e_inPowerPlant)
	EGroup_GetSquadsHeld(eg_trainStation, sg_e_inTrainStation)
	modID_inPowerPlant = Modify_ReceivedDamage(sg_e_inPowerPlant, 0.1)
	modID_inTrainStation = Modify_ReceivedDamage(sg_e_inTrainStation, 0.1)
	Rule_AddInterval(Obj4_removeTrainStationMod, 1)
	Rule_AddInterval(Obj4_removePowerPlantMod, 1)
	Rule_AddDelayedInterval(Obj4_destroyTrainStation, 5, 1)
	Rule_AddDelayedInterval(Obj4_destroyPowerPlant, 5, 1)
	
	Rule_AddDelayedInterval(Obj4_SetGarrisonGoal, 15, 2)

	Rule_AddInterval(Obj4_PakCallout, 1)
	
end

function Obj4_removeTrainStationMod()
	if SGroup_IsEmpty(sg_e_inTrainStation) then
		Rule_RemoveMe()
	else
		Player_GetAllSquadsNearMarker(player1, sg_p_nearTrainStation, mkr_trainStation, 45)
		if not SGroup_IsEmpty(sg_p_nearTrainStation) then
			g_closeToTrainStation = true
			Modifier_Remove(modID_inTrainStation)
			Rule_RemoveMe()
		end
	end
end

function Obj4_removePowerPlantMod()
	if SGroup_IsEmpty(sg_e_inPowerPlant) then
		Rule_RemoveMe()
	else
		Player_GetAllSquadsNearMarker(player1, sg_p_nearPowerPlant, mkr_powerPlant, 45)
		if not SGroup_IsEmpty(sg_p_nearPowerPlant) then
			g_closeToPowerPlant = true
			Modifier_Remove(modID_inTrainStation)
			Rule_RemoveMe()
		end
	end
end

function Obj4_destroyTrainStation()
	if EGroup_IsEmpty(eg_trainStation) then
		Rule_RemoveMe()
	elseif SGroup_IsEmpty(sg_e_inTrainStation) and Misc_IsPosOnScreen(Marker_GetPosition(mkr_trainStation), 1) then
		EGroup_Kill(eg_trainStation)
		Rule_RemoveMe()
	end
end

function Obj4_destroyPowerPlant()
	if EGroup_IsEmpty(eg_powerPlant) then
		Rule_RemoveMe()
	elseif SGroup_IsEmpty(sg_e_inPowerPlant) and Misc_IsPosOnScreen(Marker_GetPosition(mkr_powerPlant), 1) then
		EGroup_Kill(eg_powerPlant)
		Rule_RemoveMe()
	end
end


function Obj4_SetGarrisonGoal()
	-- Once enemy squads have retreated to garrisons, give them a Defend goal
	SGroup_RemoveGroup(sg_e_atTrainStation, sg_e_atPowerPlant)
	SGroup_RemoveGroup(sg_e_atPowerPlant, sg_e_atTrainStation)
	
	if not SGroup_IsRetreating(sg_e_atTrainStation, ANY) and not SGroup_IsRetreating(sg_e_atPowerPlant, ANY) then
		local goalData = {
			name = "Defend",
			useSkirmishAI = g_useSkirmishAI,
			target = mkr_trainStation_defend,
			leashRange = 35,
			garrison = false,
			garrisonIdle = false,
			coordinatedSetup = true,
			coordinatedSetupFacingPositions = {mkr_train_face1, mkr_train_face2, mkr_train_face3}
		}
		if not SGroup_IsEmpty(sg_e_atTrainStation) then
			g_enc_atTrainStation = Encounter:ConvertSgroup(sg_e_atTrainStation)
			g_enc_atTrainStation:SetGoal(goalData)
		end
		
		if not SGroup_IsEmpty(sg_e_atPowerPlant) then
			g_enc_atPowerPlant = Encounter:ConvertSgroup(sg_e_atPowerPlant)
			goalData.target = mkr_powerPlant_defend
			goalData.coordinatedSetupFacingPositions = {mkr_power_face1, mkr_power_face2, mkr_power_face3}
			g_enc_atPowerPlant:SetGoal(goalData)
		end
		
		Rule_AddInterval(Obj4_RevealPowerPlant, 5)
		Rule_AddInterval(Obj4_RevealTrainStation, 5)
		
		Rule_RemoveMe()
	end
end

function Obj4_RevealPowerPlant()
	if EGroup_IsUnderAttack(eg_powerPlant, ANY, 5) then
		FOW_RevealMarker(mkr_powerPlant, -1)
		Rule_RemoveMe()
	end
end

function Obj4_RevealTrainStation()
	if EGroup_IsUnderAttack(eg_trainStation, ANY, 5) then
		FOW_RevealMarker(mkr_trainStation, -1)
		Rule_RemoveMe()
	end
end

function Obj4_SpawnAllies()
	-- Allied squads spawn during the final objective and help the player
	g_volkhovAlliesSpawned = true
	Util_StartIntel(EVENTS.Breakthrough)

	sg_allies = SGroup_CreateIfNotFound("sg_allies")
	g_enc_allies = {}
	
	local data = {
		name = "ally1",
		player = player3,
		sgroups = {sg_allies},
		units = {
			{
				sbp = SBP.SOVIET.GUARDS_TROOPS,
				spawn = mkr_allyStart1,
			},
			{
				sbp = SBP.SOVIET.T_70M, 
				spawn = mkr_allyStart1,
			},
			{
				sbp = SBP.SOVIET.CONSCRIPT_SQUAD,
				spawn = mkr_allyStart1,
			},
		}
	}
	
	local goalData = {
		name = "Attack",
		useSkirmishAI = g_useSkirmishAI,
		attackMove = true,
		safeMoveWeight = 0,
		pickupWeapons = 1,
		coordinatedMoveRadius = 0,
		target = mkr_perimeter5,
		tacticTargetPreference = AITacticTargetPreference_Near,
		maxIdleTime = 600,
		abilityControlsList = {
			{
				abilityPBG = ABILITY.SOVIET.CONSCRIPT_MOLOTOV_COCKTAIL,
				maxCasters = 3,
				maxRange = 25,
				retryTimeSecs = 10,
				waitTimeSecs = 10,
			},
			{
				abilityPBG = ABILITY.SOVIET.GUARDS_THROW_DEFENSIVE_GRENADE,
				maxCasters = 3,
				maxRange = 25,
				retryTimeSecs = 10,
				waitTimeSecs = 10,
			},
			{
				abilityPBG = ABILITY.SOVIET.CONSCRIPT_OORAH,
				maxCasters = 3,
				retryTimeSecs = 15,
				waitTimeSecs = 15,
			},
		},
		tacticControlsList = {
			{
				tacticType = TACTIC_Ability,
				priority = 500,
				maxUsers = 3,
				maxRange = 25,
				retryTimeSecs = 10,
				waitTimeSecs = 10,
			},
			{
				tacticType = TACTIC_ForceAttack,
				priority = 250,
				retryTimeSecs = 5,
				waitTimeSecs = 5,
			},
			{
				tacticType = TACTIC_RushAtTarget,
				priority = 125,
				maxUsers = 3,
				retryTimeSecs = 7,
				waitTimeSecs = 7,
			},
			{
				tacticType = TACTIC_Retaliate,
				priority = 62,
				maxUsers = 3,			
				retryTimeSecs = 6,
				waitTimeSecs = 6,
			},
			{
				tacticType = TACTIC_Cover,
				priority = 31,
				maxUsers = 3,			
				retryTimeSecs = 8,
				waitTimeSecs = 8,
			},
			{
				tacticType = TACTIC_Vehicle,
				priority = 5,
				maxUsers = 3,			
				retryTimeSecs = 9,
				waitTimeSecs = 9,
			},
		},
		
	}
	
	g_enc_allies[1] = Encounter:Create(data)
	g_enc_allies[1]:SetGoal(goalData)
	
	--
	data.name = "ally2"
	data.units[1].spawn = mkr_allyStart2
	data.units[2].spawn = mkr_allyStart2
	data.units[3].spawn = mkr_allyStart2
	data.units[2].sbp = SBP.SOVIET.T_34_76_SQUAD
	goalData.target = mkr_trainStation
	g_allySpawnPos = mkr_allyStart2
	g_enc_allies[2] = Encounter:Create(data)
	g_enc_allies[2]:SetGoal(goalData)	
	
	--
	data.name = "ally3"
	data.units[1].spawn = mkr_allyStart3
	data.units[2].spawn = mkr_allyStart3
	data.units[3].spawn = mkr_allyStart3
	data.units[2].sbp = SBP.SOVIET.T_70M
	goalData.target = mkr_perimeter3
	g_allySpawnPos = mkr_allyStart3
	g_enc_allies[3] = Encounter:Create(data)
	g_enc_allies[3]:SetGoal(goalData)	
	
	--
	data.name = "ally4"
	data.units[1].spawn = mkr_allyStart4
	data.units[2].spawn = mkr_allyStart4
	data.units[3].spawn = mkr_allyStart4
	data.units[2].sbp = SBP.SOVIET.T_34_76_SQUAD
	goalData.target = mkr_powerPlant
	g_allySpawnPos = mkr_allyStart4
	g_enc_allies[4] = Encounter:Create(data)
	g_enc_allies[4]:SetGoal(goalData)	
	
	--
	data.name = "ally5"
	data.units[1].spawn = mkr_allyStart5
	data.units[2].spawn = mkr_allyStart5
	data.units[3].spawn = mkr_allyStart5
	data.units[2].sbp = SBP.SOVIET.T_70M
	goalData.target = mkr_perimeter1
	g_allySpawnPos = mkr_allyStart5
	g_enc_allies[5] = Encounter:Create(data)
	g_enc_allies[5]:SetGoal(goalData)	
	
	Player_AddResource(player3, RT_Munition, 500)
	Player_SetAbilityAvailability(player3, ABILITY.SOVIET.CONSCRIPT_MOLOTOV_COCKTAIL, ITEM_UNLOCKED)
	Player_SetAbilityAvailability(player3, ABILITY.SOVIET.CONSCRIPT_OORAH, ITEM_UNLOCKED)
	Player_SetAbilityAvailability(player3, ABILITY.SOVIET.GUARDS_THROW_DEFENSIVE_GRENADE, ITEM_UNLOCKED)
	Player_AddAbility(player3, ABILITY.GLOBAL.OFF_MAP_ARTY_SINGLE_SHOT_INSTANT)
	Player_SetAbilityAvailability(player3, ABILITY.GLOBAL.OFF_MAP_ARTY_SINGLE_SHOT_INSTANT, ITEM_UNLOCKED)
	
	Rule_AddDelayedInterval(Obj4_barrageEasternDefenses, 10, 10)
	
end	

function Obj4_barrageEasternDefenses()
	if EGroup_IsEmpty(eg_e_volkhovBarrageTarget) then
		Rule_RemoveMe()
	else
		local hold = EGroup_GetRandomSpawnedEntity(eg_e_volkhovBarrageTarget)
		if Entity_IsHoldingAny(hold) then
			Cmd_Ability(player3, ABILITY.GLOBAL.OFF_MAP_ARTY_SINGLE_SHOT_INSTANT, Entity_GetPosition(hold), nil, true)
		else
			EGroup_Remove(eg_e_volkhovBarrageTarget, hold)
			Obj4_barrageEasternDefenses()
		end
	end
end

function __testAllyFriendGuys()
	World_IncreaseInteractionStage()
	World_IncreaseInteractionStage()
	A2M01_SetupBunkerLine(2)
	Obj4_SetupStrongholds()
	Obj4_SpawnAllies()
	SGroup_SetInvulnerable(sg_allies, true)
end

function Obj4_PakCallout()
	if SGroup_IsEmpty(sg_e_pak43s) then
		Rule_RemoveMe()
	elseif SGroup_IsDoingAttack(sg_e_pak43s, ANY, 5) or SGroup_IsUnderAttack(sg_e_pak43s, ANY, 5) then
		sg_pak43_attacking = SGroup_CreateIfNotFound("sg_pak43_attacking")
		local f = function (gid, idx, sid)
			if Squad_IsAttacking(sid, 10) then
				SGroup_Add(sg_pak43_attacking, sid)
				return true
			end
		end
		SGroup_ForEach(sg_e_pak43s, f)
		FOW_RevealSGroup(sg_pak43_attacking, 30)
		EventCue_Create(CUE.ATTACKED, 11007007, 11007007, sg_pak43_attacking, 11007007)
		Util_StartIntel(EVENTS.Pak43)
		Rule_RemoveMe()
	end
end

function Obj4_counterPlayerArtilllery()
	-- Find player howitzers, mortars and SU-76
	-- Send enemy squads to attack them if they stay still for too long
	local player1Squads = Player_GetSquads(player1)
	local blueprints = {SBP.SOVIET.HM_120_38_MORTAR_SQUAD, SBP.SOVIET.SU_76M, SBP.GERMAN.HOWITZER_105MM_LE_FH18_ARTILLERY}
	SGroup_Filter(player1Squads, blueprints, FILTER_KEEP)
	if SGroup_IsEmpty(player1Squads) then
		return
	else
		local checkStatic = function (gid, idx, sid)
			if Squad_IsMoving(sid) or Squad_IsUnderAttack(sid, 30) then
				SGroup_Remove(player1Squads, sid)
			end
		end
		SGroup_ForEach(player1Squads, checkStatic)
		if SGroup_IsEmpty(player1Squads) then
			return
		elseif SGroup_Count(sg_e_counterArty) <= 2 then
			local attackSquad = SBP.GERMAN.PANZER_GRENADIER_SQUAD
			local weaponUpgrade = nil
			if SGroup_HasSquadBlueprint(player1Squads, SBP.SOVIET.HM_120_38_MORTAR_SQUAD, ANY) then
				--
			elseif SGroup_HasSquadBlueprint(player1Squads, SBP.GERMAN.HOWITZER_105MM_LE_FH18_ARTILLERY, ANY) then
				weaponUpgrade = UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM
			elseif SGroup_HasSquadBlueprint(player1Squads, SBP.SOVIET.SU_76M, ANY) then
				weaponUpgrade = UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM
			end
			
			local t_spawnMarkers = {mkr_trainStation, mkr_powerPlant}
			if g_trainStationCleared then
				t_spawnMarkers[1] = nil
			end
			if g_powerPlantCleared then
				t_spawnMarkers[2] = nil
			end
			if (#t_spawnMarkers == 0) or (t_spawnMarkers == nil) then
				return
			end
			local encData = {
				name = "counterArty",
				player = player2,
				dynamicSpawnTarget = SGroup_GetPosition(player1Squads),
				spawn = Table_GetRandomItem(t_spawnMarkers),
				sgroups = {sg_e_counterArty},
				units = {
					{
						sbp = attackSquad,
						upgrades = {weaponUpgrade},
					},
				},
			}
			if scartype(encData.spawn) == ST_MARKER then
				if not (Player_CanSeePosition(player1, Marker_GetPosition(encData.spawn)) and Misc_IsPosOnScreen(Marker_GetPosition(encData.spawn), 1)) then
					if g_hardDiff and Player_GetPopulationPercentage(player1, CT_Personnel) > 0.66 then
						encData.units[2] = {
							sbp = SBP.GERMAN.MORTAR_TEAM_81MM
						}
					end
					g_enc_counterArty = Encounter:Create(encData)

					local goalData = {
						name = "Attack",
						attackMove = false,
						target = player1Squads,
						safeMoveWeight = 0.75,
						coordinatedMoveRadius = 15,
						pickupWeapons = -1,
						onSuccess = Obj4_counterPA_onSuccess,
					}
					g_enc_counterArty:SetGoal(goalData)		
				end
			end
			Player_GetAllSquadsNearMarker(player1, sg_p_northHowitzer, mkr_howitzer2, 10)
			if not SGroup_IsEmpty(sg_p_northHowitzer) then
				SGroup_Filter(sg_p_northHowitzer, SBP.GERMAN.HOWITZER_105MM_LE_FH18_ARTILLERY, FILTER_KEEP)
				if not SGroup_IsEmpty(sg_p_northHowitzer) then
					if scartype(encData.spawn) == ST_MARKER then
						if not (Player_CanSeePosition(player1, Marker_GetPosition(encData.spawn)) and Misc_IsPosOnScreen(Marker_GetPosition(encData.spawn), 1)) then
							encData.dynamicSpawnTarget = mkr_howitzer2
							encData.units[1].sbp = SBP.GERMAN.GRENADIER_SQUAD
							encData.units[1].upgrades = nil
							g_enc_counterArty2 = Encounter:Create(encData)
							local goalData = {
								name = "Attack",
								attackMove = false,
								target = sg_p_northHowitzer,
								safeMoveWeight = 0.25,
								coordinatedMoveRadius = 15,
								pickupWeapons = -1,
								onSuccess = Obj4_counterPA_onSuccess,
							}
							g_enc_counterArty2:SetGoal(goalData)		
						end
					end
				end
			end
			if g_counterArtySuccessCount >= 5 then
				Rule_RemoveMe()
			else
				g_counterArtyInterval = g_counterArtyInterval + 10
				Rule_ChangeInterval(Obj4_counterPlayerArtilllery, g_counterArtyInterval)
			end
		end
	end
end

function Obj4_counterPA_onSuccess(enc)
	if enc:IsAlive() and not SGroup_IsEmpty(enc.sgroup) then
		g_counterArtySuccessCount = g_counterArtySuccessCount + 1
		local player1Squads = Player_GetSquads(player1)
		local attackTarget = mkr_forwardHQ
		if SGroup_Count(player1Squads) > 0 then
			attackTarget = SGroup_GetRandomSpawnedSquad(player1Squads)
		end
		local goalData = {
			name = "Attack",
			attackMove = true,
			target = attackTarget,
			safeMoveWeight = 0.75,
			coordinatedMoveRadius = 15,
			pickupWeapons = -1,
			onSuccess = Obj4_counterPA_onSuccess,
		}
		enc:SetGoal(goalData)		
	end
end

---------------------- SECONDARY OBJECTIVE: Capture two of three high-ground territories --------------------
function Initialize_Objective5()

	OBJ_HighGround = {
	-- Starts when one of the target territory_points is spotted
		
		SetupUI = function() 

		end,
		
		OnStart = function()
			t_pings_highGround = {}
			t_pings_highGround[1] = Objective_AddUIElements(OBJ_HighGround, Entity_GetPosition(EGroup_GetSpawnedEntityAt(eg_objStrats, 1)), true, nil, nil, 3.8)
			t_pings_highGround[2] = Objective_AddUIElements(OBJ_HighGround, Entity_GetPosition(EGroup_GetSpawnedEntityAt(eg_objStrats, 2)), true, nil, nil, 3.8)
			t_pings_highGround[3] = Objective_AddUIElements(OBJ_HighGround, Entity_GetPosition(EGroup_GetSpawnedEntityAt(eg_objStrats, 3)), true, nil, nil, 3.8)
			Rule_AddDelayedInterval(Obj5_IsComplete, 5, 1)
		end,
		
		OnComplete = function()

		end,
		
		OnFail = function()

		end,
		
		IsComplete = function()
			return false
		end,
		
		Intel_Start = EVENTS.HighGround,				-- Event will play when obj starts but before any UI appears
		Intel_Complete = nil,			-- Event will play when obj completes but before UI is cleared
		Intel_Fail = nil,				-- Event will play when obj fails but before UI is cleared
		Title = 11045342, -- LOCDB [11045342] 'Capture two high-ground territories'
		Description = 11045342,
		TitleEnd = 11045344, -- LOCDB [11045344] 'High ground captured'
		TitleFail = nil,
		Type = OT_Secondary,				-- Objective Type (OT_Primary, OT_Secondary)
	}
	
	Objective_Register(OBJ_HighGround)

end

function Obj5_IsComplete()
	-- Objective is completed if two marked strategic points are captured
	if EGroup_Count(eg_objStrats) <= 1 then
		if not g_volkhovAlliesSpawned then
			Obj4_SpawnAllies()
		end
		Objective_Complete(OBJ_HighGround)
		Rule_RemoveMe()
	else
		local removePing = function(group, index, strat)
			if Util_GetPlayerOwner(strat) == player1 or Util_GetPlayerOwner(strat) == player3 then
				Objective_RemoveUIElements(OBJ_HighGround, t_pings_highGround[index])
				table.remove(t_pings_highGround, index)
				EGroup_Remove(eg_objStrats, strat)
				Modify_PlayerSightRadius(player1, 1.25)
				Modify_PlayerSightRadius(player3, 1.25)
				eventCue_sightIncrease = UI_CreateEventCue("Icons_events_event_cue_upgrade", "", 11045343, 11045343, 30, true) -- LOCDB [11045343] 'Sight Radius Increased'
			end
		end
		EGroup_ForEach(eg_objStrats, removePing)
	end
end	

---------------------------- MISSION COMPLETE --------------------------------------

function A2M01_MissionComplete()

	Rule_AddDelayedInterval(A2M01_MissionEnd, 1.5, 1)

end

function A2M01_MissionEnd()

	if Event_IsAnyRunning() == false then
		Game_EndSP(true)
	end

end

function A2M01_MissionEndInstant()
	Game_FadeToBlack(FADE_OUT, 1)
	Game_EndSP(true)

end

------- Enemy Spawning -------

function A2M01_SetupEnemies()
	-- This function is called on mission start
	-- It spawns enemies on the shoreline and on the river
	sg_e_all = SGroup_CreateIfNotFound("sg_e_all")
	sg_e_reducedRange = SGroup_CreateIfNotFound("sg_e_reducedRange")
	
	Player_AddResource(player2, RT_Munition, 200)
	Player_CompleteUpgrade(player2, UPG.GERMAN.BATTLE_PHASE_2)
	Player_SetAbilityAvailability(player2, ABILITY.GERMAN.GRENADIER_RIFLE_GRENADE_ABILITY, ITEM_REMOVED)
	Player_SetAbilityAvailability(player2, ABILITY.GERMAN.PANZER_GRENADIER_BUNDLED_CAMPAIGN, ITEM_UNLOCKED)
	
	g_enc_strats = {}
	
	A2M01_SetupBunkerLine(1)
	A2M01_SetupPatrols(1)
	A2M01_SetupHowitzer()
	
end

function A2M01_SetupHowitzer()
	sg_e_howitzer = SGroup_CreateIfNotFound("sg_e_howitzer")
	Util_CreateSquads(player2, sg_e_howitzer, SBP.GERMAN.HOWITZER_105MM_LE_FH18_ARTILLERY, mkr_howitzer)
	Modify_AbilityRechargeTime(player2, ABILITY.GERMAN.HOWITZER_105MM_BARRAGE_ABILITY, 0.05)
	Modify_AbilityMaxCastRange(player2, ABILITY.GERMAN.HOWITZER_105MM_BARRAGE_ABILITY, 1.5)

	sg_e_howitzer2 = SGroup_CreateIfNotFound("sg_e_howitzer2")
	Util_CreateSquads(player2, sg_e_howitzer2, SBP.GERMAN.HOWITZER_105MM_LE_FH18_ARTILLERY, mkr_howitzer2)
	
	Obj1_fireHowitzer()
	Rule_AddDelayedInterval(Obj1_fireHowitzer, 15, 10)
	
	g_allyBarrageTarget = mkr_allyBarrageTarget1
	Player_SetAbilityAvailability(player3, ABILITY.SOVIET.ML_20_152MM_BARRAGE_ABILITY, ITEM_UNLOCKED)
	Modify_AbilityMaxCastRange(player3, ABILITY.SOVIET.ML_20_152MM_BARRAGE_ABILITY, 3)
	Obj1_fireAllyHowitzer()
	Rule_AddDelayedInterval(Obj1_fireAllyHowitzer, 20, 45)
	
end

function Obj1_fireHowitzer()
	if not (SGroup_CountSpawned(sg_katyushas) == 0) and not SGroup_IsEmpty(sg_e_howitzer) then
		local target = SGroup_GetSpawnedSquadAt(sg_katyushas, 1)
		if Squad_IsValid(Squad_GetGameID(target)) then
			if Squad_Count(target) > 0 then
				if SGroup_HasTeamWeapon(sg_e_howitzer, ANY) then
					Cmd_Ability(sg_e_howitzer, ABILITY.GERMAN.HOWITZER_105MM_BARRAGE_ABILITY, Squad_GetPosition(target))
				end
			end
		end
		Rule_AddOneShot(_fireHowitzer2, 9)
	elseif not SGroup_IsEmpty(sg_e_howitzer) then
		local target = Table_GetRandomItem({mkr_allyTrench1, mkr_allyTrench2, mkr_allyTrench3, mkr_allyTrench4})
		if SGroup_HasTeamWeapon(sg_e_howitzer, ANY) then
			Cmd_Ability(sg_e_howitzer, ABILITY.GERMAN.HOWITZER_105MM_BARRAGE_ABILITY, target) 
		end
	elseif SGroup_IsEmpty(sg_e_howitzer) then
		Rule_RemoveMe()
		Rule_AddInterval(_fireHowitzer2, 15)
	end
end

_fireHowitzer2 = function()
	if not SGroup_IsEmpty(sg_e_howitzer2) and not SGroup_IsEmpty(sg_katyushas) then
		local target = SGroup_GetSpawnedSquadAt(sg_katyushas, SGroup_CountSpawned(sg_katyushas))
		if Squad_IsValid(Squad_GetGameID(target)) then
			if Squad_Count(target) > 0 then
				if SGroup_HasTeamWeapon(sg_e_howitzer2, ANY) then
					Cmd_Ability(sg_e_howitzer2, ABILITY.GERMAN.HOWITZER_105MM_BARRAGE_ABILITY, Squad_GetPosition(target))
				end
			end
		end
	elseif not SGroup_IsEmpty(sg_e_howitzer2) and not SGroup_IsEmpty(sg_a_howitzer) then
		if SGroup_HasTeamWeapon(sg_e_howitzer2, ANY) then
			Cmd_Ability(sg_e_howitzer2, ABILITY.GERMAN.HOWITZER_105MM_BARRAGE_ABILITY, SGroup_GetPosition(sg_a_howitzer))
		end
	end
end

function Obj2_fireSecondHowitzer()
	if SGroup_IsEmpty(sg_e_howitzer2) or SGroup_IsRetreating(sg_e_howitzer2, ALL) or (World_GetGameTime() > g_secondHowitzerTime + 1500) or SGroup_HasTeamWeapon(sg_e_howitzer2, ANY) == false then
		Rule_RemoveMe()
	elseif EGroup_Count(eg_p_forwardBase) > 0 then
		local pos = Util_GetRandomPosition(mkr_how2_target2)
		if g_secondHowitzerIndex == 1 then
			pos = Util_GetRandomPosition(mkr_how2_target1)
			if g_artyOnHQSpeechDone == nil then
				Util_StartIntel(EVENTS.ArtyOnHQ)
				g_artyOnHQSpeechDone = true
			end
			g_secondHowitzerIndex = 2
		else
			g_secondHowitzerIndex = 1
		end
		FOW_RevealSGroupOnly(sg_e_howitzer2, 25)
		EventCue_Create(CUE.ATTACKED, 11050128, 11050128, pos)
		hintID_secondHowitzerTarget = HintPoint_Add(pos, true, 11050128, 3, HPAT_Critical) -- LOCDB [11050128] 'Artillery Barrage Incoming'
		Rule_AddOneShot(Obj2_removeHowitzer2Hint, 20)
		Cmd_Ability(sg_e_howitzer2, ABILITY.GERMAN.HOWITZER_105MM_BARRAGE_ABILITY, pos)
	end
end

function Obj2_removeHowitzer2Hint()
	HintPoint_Remove(hintID_secondHowitzerTarget)
end

function Obj1_fireAllyHowitzer()
	if SGroup_IsEmpty(sg_a_howitzer) or World_GetGameTime() > 240 or SGroup_HasTeamWeapon(sg_a_howitzer, ANY) == false then
		Rule_RemoveMe()
	elseif SGroup_HasTeamWeapon(sg_a_howitzer, ALL) then
		Cmd_Ability(sg_a_howitzer, ABILITY.SOVIET.ML_20_152MM_BARRAGE_ABILITY, g_allyBarrageTarget, nil, true)
		if g_allyBarrageTarget == mkr_allyBarrageTarget1 then
			g_allyBarrageTarget = mkr_allyBarrageTarget2
		else
			g_allyBarrageTarget = mkr_allyBarrageTarget1
		end
	end
end	

function A2M01_SetupBunkerLine(num)

	sg_inTrenches = SGroup_CreateIfNotFound("sg_inTrenches")
	eg_tempTrench = EGroup_CreateIfNotFound("eg_tempTrench")
	sg_inBunkers = SGroup_CreateIfNotFound("sg_inBunkers")
	eg_tempBunker = EGroup_CreateIfNotFound("eg_tempBunker")
	
	sg_inEastTrenches = SGroup_CreateIfNotFound("sg_inEastTrenches")
	sg_inEastBunkers = SGroup_CreateIfNotFound("sg_inEastBunkers")
	
	g_trenchSquadSize = 2

	local fillTrench = function (group, index, trench)
		local sgroup = sg_inTrenches
		if group == eg_e_easternTrenches then
			sgroup = sg_inEastTrenches
		end
		EGroup_Clear(eg_tempTrench)
		EGroup_Add(eg_tempTrench, trench)
		if g_trenchSquadSize == 2 then
			Util_CreateSquads(player2, sgroup, SBP.GERMAN.GRENADIER_SQUAD, eg_tempTrench, nil, nil, g_trenchSquadSize)
			g_trenchSquadSize = 4
		else
			Util_CreateSquads(player2, sgroup, SBP.GERMAN.OSTRUPPEN_SQUAD, eg_tempTrench, nil, nil, g_trenchSquadSize)
			g_trenchSquadSize = 2
		end
	end
	
	local fillBunker = function (group, index, bunker)
		local sgroup = sg_inBunkers
		if group == eg_e_easternBunkers then
			sgroup = sg_inEastBunkers
		end
		local squadSize = World_GetRand(2,3)
		EGroup_Clear(eg_tempBunker)
		EGroup_Add(eg_tempBunker, bunker)
		Util_CreateSquads(player2, sgroup, SBP.GERMAN.PANZER_GRENADIER_SQUAD, eg_tempBunker, nil, nil, squadSize)
	end
	
	if num == 1 then
		g_enc_shoreline = {}
		

		sg_allShoreline = SGroup_CreateIfNotFound("sg_allShoreline")
		local data = {
			name = "shoreline1",
			player = player2,
			sgroups = {sg_allShoreline},
			units = {
				{
					sbp = SBP.GERMAN.GRENADIER_SQUAD,
					spawn = mkr_shoreline1,
					load = 3,
					upgrades = {UPG.GERMAN.GRENADIER_MG42_LMG}
				},
				{
					sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
					spawn = mkr_shoreline2,
					load = 4,
				},
				{
					sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
					spawn = mkr_shoreline_pg_5,
					load = 2,
					dropItems = {{slotItem = SLOT_ITEM.PANZERSHRECK, dropChance = 0, exclusive = true}},
					upgrades = {UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM}
				},
			}
		}
		if g_easyDiff then
			data.units[1].upgrades = nil
			data.units[3].upgrades = {UPG.GERMAN.PANZERBUSCHE_39}
		end
		table.insert(g_enc_shoreline, Encounter:Create(data))
		
		local goalData = {
			name = "Defend",
			target = mkr_shore_leash1,
			coordinatedSetupFacingPositions = {mkr_mortar3_smoke, mkr_mortar2_smoke, mkr_mortar1_smoke},
			leashRange = 25,
			range = 15,
			useSkirmishAI = g_useSkirmishAI,
		}
		g_enc_shoreline[table.getn(g_enc_shoreline)]:SetGoal(goalData)
		
		local data = {
			name = "shoreline2",
			player = player2,
			sgroups = {sg_allShoreline},
			units = {
				{
					sbp = SBP.GERMAN.GRENADIER_SQUAD,
					spawn = mkr_shoreline3,
					load = 2,
				},
			}
		}
		table.insert(g_enc_shoreline, Encounter:Create(data))
		goalData.target = mkr_shoreline3
		goalData.coordinatedSetupFacingPositions = {mkr_mortar2_smoke}
		g_enc_shoreline[table.getn(g_enc_shoreline)]:SetGoal(goalData)
		
		local data = {
			name = "shoreline3",
			player = player2,
			sgroups = {sg_allShoreline},
			units = {
				{
					sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
					spawn = mkr_shoreline4,
					load = 4,
				},
			}
		}
		table.insert(g_enc_shoreline, Encounter:Create(data))
		goalData.target = mkr_shoreline4
		goalData.coordinatedSetupFacingPositions = {mkr_mortar1_smoke}
		g_enc_shoreline[table.getn(g_enc_shoreline)]:SetGoal(goalData)
		
		local data = {
			name = "shoreline4",
			player = player2,
			sgroups = {sg_allShoreline},
			units = {
				{
					sbp = SBP.GERMAN.GRENADIER_SQUAD,
					spawn = mkr_shoreline5,
					load = 3,
					upgrades = {UPG.GERMAN.GRENADIER_MG42_LMG}
				},
			}
		}
		if g_easyDiff then
			data.units[1].upgrades = nil
		end
		table.insert(g_enc_shoreline, Encounter:Create(data))
		goalData.target = mkr_shoreline5
		goalData.coordinatedSetupFacingPositions = {mkr_river1}
		g_enc_shoreline[table.getn(g_enc_shoreline)]:SetGoal(goalData)
		
		local data = {
			name = "shoreline5",
			player = player2,
			sgroups = {sg_allShoreline},
			units = {
				{
					sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
					spawn = mkr_shoreline6,
					load = 4,
				},
			}
		}
		table.insert(g_enc_shoreline, Encounter:Create(data))
		goalData.target = mkr_shoreline6
		g_enc_shoreline[table.getn(g_enc_shoreline)]:SetGoal(goalData)
		
		local data = {
			name = "shoreline6",
			player = player2,
			sgroups = {sg_allShoreline},
			units = {
				{
					sbp = SBP.GERMAN.GRENADIER_SQUAD,
					spawn = mkr_shoreline7,
					load = 2,
				},
			}
		}
		table.insert(g_enc_shoreline, Encounter:Create(data))
		goalData.target = mkr_shoreline7
		goalData.coordinatedSetupFacingPositions = {mkr_river5}
		g_enc_shoreline[table.getn(g_enc_shoreline)]:SetGoal(goalData)
		
		local data = {
			name = "shoreline7",
			player = player2,
			sgroups = {sg_allShoreline},
			units = {
				{
					sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
					spawn = mkr_shoreline_pg_4,
					load = 2,
					dropItems = {{slotItem = SLOT_ITEM.PANZERSHRECK, dropChance = 0, exclusive = true}},
					upgrades = {UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM}
				},
			}
		}
		
		if g_easyDiff then
			data.units[1].upgrades = {UPG.GERMAN.PANZERBUSCHE_39}
		end

		table.insert(g_enc_shoreline, Encounter:Create(data))
		goalData.target = mkr_shoreline_pg_4
		g_enc_shoreline[table.getn(g_enc_shoreline)]:SetGoal(goalData)
		
		data.name = "shoreline8"
		data.units[1].spawn = mkr_shoreline_pg_3
		table.insert(g_enc_shoreline, Encounter:Create(data))
		goalData.target = mkr_shoreline_pg_3
		g_enc_shoreline[table.getn(g_enc_shoreline)]:SetGoal(goalData)
		
		data.name = "shoreline9"
		data.units[1].spawn = mkr_shoreline_pg_2
		table.insert(g_enc_shoreline, Encounter:Create(data))
		goalData.target = mkr_shoreline_pg_2
		g_enc_shoreline[table.getn(g_enc_shoreline)]:SetGoal(goalData)
		
		data.name = "shoreline10"
		data.units[1].spawn = mkr_shoreline_pg_1
		table.insert(g_enc_shoreline, Encounter:Create(data))
		goalData.target = mkr_shoreline_pg_1
		g_enc_shoreline[table.getn(g_enc_shoreline)]:SetGoal(goalData)
		
		local data = {
			name = "shoreline11",
			player = player2,
			sgroups = {sg_allShoreline},
			units = {
				{
					sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
					spawn = mkr_shoreline8,
					load = 4,
				},
			}
		}
		table.insert(g_enc_shoreline, Encounter:Create(data))
		goalData.target = mkr_shoreline8
		goalData.coordinatedSetupFacingPositions = {mkr_river6}
		g_enc_shoreline[table.getn(g_enc_shoreline)]:SetGoal(goalData)
		
		local data = {
			name = "shoreline12",
			player = player2,
			sgroups = {sg_allShoreline},
			units = {
				{
					sbp = SBP.GERMAN.GRENADIER_SQUAD,
					spawn = mkr_shoreline9,
					load = 3,
					upgrades = {UPG.GERMAN.GRENADIER_MG42_LMG}
				},
			}
		}
		
		if g_easyDiff then
			data.units[1].upgrades = nil
		end		
		
		table.insert(g_enc_shoreline, Encounter:Create(data))
		goalData.target = mkr_shoreline9
		g_enc_shoreline[table.getn(g_enc_shoreline)]:SetGoal(goalData)
		
		A2M01_SpawnStratDefense("northWest")
		EGroup_RemoveGroup(eg_strats, eg_strat_northWest)

		-- Fill bunkers
		EGroup_ForEach(eg_e_allbunkers, fillBunker)

		-- Setup Mortars
		sg_mortars = SGroup_CreateIfNotFound("sg_mortars")
		Util_CreateSquads(player2, sg_mortars, SBP.GERMAN.MORTAR_TEAM_81MM, mkr_mortar1, nil, 1)
		Util_CreateSquads(player2, sg_mortars, SBP.GERMAN.MORTAR_TEAM_81MM, mkr_mortar1_2, nil, 1)
		Util_CreateSquads(player2, sg_mortars, SBP.GERMAN.MORTAR_TEAM_81MM, mkr_mortar2, nil, 1)
		Util_CreateSquads(player2, sg_mortars, SBP.GERMAN.MORTAR_TEAM_81MM, mkr_mortar2_2, nil, 1)
		Util_CreateSquads(player2, sg_mortars, SBP.GERMAN.MORTAR_TEAM_81MM, mkr_mortar3, nil, 1)
		Util_CreateSquads(player2, sg_mortars, SBP.GERMAN.MORTAR_TEAM_81MM, mkr_mortar3_2, nil, 1)
		Util_LogSyncWpn(sg_mortars)
		if g_hardDiff then
			Modify_WeaponDamage(sg_mortars, "hardpoint_01", 0.75)
		else
			Modify_WeaponDamage(sg_mortars, "hardpoint_01", 0.25)
		end
		-- Setup first HMGs 
		if not g_easyDiff then
			sg_HMGs = SGroup_CreateIfNotFound("sg_HMGs")
			Util_CreateSquads(player2, sg_HMGs, SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD, eg_HMG4)
			Util_CreateSquads(player2, {sg_HMGs, sg_e_sw}, SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD, eg_HMG5)
			if not g_hardDiff then
				Modify_WeaponDamage(sg_HMGs, "hardpoint_01", 0.1)
			end
		end
		
		-- Mortar Smoke Barrage
		Modify_AbilityRechargeTime(player2, ABILITY.GERMAN.MORTAR_TEAM_SMOKE_BARRAGE, 0)
		Modify_AbilityMunitionsCost(player2, ABILITY.GERMAN.MORTAR_TEAM_SMOKE_BARRAGE, 0)
		Modify_AbilityMaxCastRange(player2, ABILITY.GERMAN.MORTAR_TEAM_SMOKE_BARRAGE, 3)
		sg_mortar_single = SGroup_CreateIfNotFound("sg_mortar_single")
		sg_mortar_retreat = SGroup_CreateIfNotFound("sg_mortar_retreat")
		Obj1_MortarSmokeBarrage()
		Cmd_InstantSetupTeamWeapon(sg_mortars)
		Rule_AddDelayedInterval(Obj1_MortarSmokeBarrage, 1, 20)
		Rule_AddDelayedInterval(Obj1_MortarRetreat, 2, 3)
		
		-- Enemies near forward base area
		local data = {
			name = "stratSouthwest",
			player = player2,
			sgroups = {sg_e_all, sg_e_sw},
		}		
		
		data.units = {
			{
				sbp = SBP.GERMAN.SNIPER_SQUAD,
				spawn = mkr_strat_southWest1,
			},
			{
				sbp = SBP.GERMAN.SNIPER_SQUAD,
				difficulty = {GD_NORMAL, GD_HARD},
				spawn = mkr_strat_southWest2,
			},
			{
				sbp = SBP.GERMAN.SNIPER_SQUAD,
				difficulty = {GD_HARD},
				spawn = mkr_strat_southWest3,
			},
		}
		Encounter:Create(data)
		
		-- Flamer Pioneers
		Rule_AddDelayedInterval(A2M01_FlamePioneers, 30, 1)
		
	elseif num == 2 then
		-- Spawn enemies on the eastern defensive line at the start of the final objective
		g_enc_eastDefenseLine = {}
		
		EGroup_ForEach(eg_e_easternTrenches, fillTrench)
		EGroup_ForEach(eg_e_easternBunkers, fillBunker)
		Cmd_InstantUpgrade(sg_inEastBunkers, UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM)
	end
	
end

-- Flamer pioneers arrive on the riverbank once the player has killed a couple squads
function A2M01_FlamePioneers()
	local attackTarget = Player_GetSquads(player1)
	
	if SGroup_Count(sg_allShoreline) < t_difficulty.flamePioneerThreshold and SGroup_CountSpawned(attackTarget) > 0 then
	
		local encData = {
			name = "flamePioneers",
			player = player2,
			dynamicSpawnTarget = mkr_perimeter2,
			spawn = mkr_flamePioneers_far,
			sgroups = {SGroup_CreateIfNotFound("sg_allShoreline")},
			units = {
				{
					sbp = SBP.GERMAN.PIONEER_SQUAD,
					upgrades = {UPG.GERMAN.PIONEER_FLAMETHROWER},
					dropItems = {{slotItem = SLOT_ITEM.PIONEER_FLAMETHROWER, dropChance = 0, exclusive = true}}
				},
				{
					sbp = SBP.GERMAN.PIONEER_SQUAD,
					upgrades = {UPG.GERMAN.PIONEER_FLAMETHROWER},
				},
			},
		}
		g_enc_flamePioneers = Encounter:Create(encData)

		local goalData = {
			name = "Attack",
			useSkirmishAI = g_useSkirmishAI,
			attackMove = true,
			target = attackTarget,
			range = 35,
			leashRange = 70,
			safeMoveWeight = 0,
			coordinatedMoveRadius = 15,
			pickupWeapons = -1,
			onSuccess = FlamePioneers_OnSuccess,
			tacticControlsList = {
				{
					tacticType = TACTIC_Cover,
					priority = -1,
				},
			},	
		}
		g_enc_flamePioneers:SetGoal(goalData)
		
		Rule_RemoveMe()
	end
end

function FlamePioneers_OnSuccess()
	Rule_AddInterval(FlamePioneers_WaitForTargets, 4)
end	

function FlamePioneers_WaitForTargets()
	local attackTarget = Player_GetSquads(player1)
	
	if SGroup_CountSpawned(attackTarget) > 0 then
		Rule_RemoveMe()
		
		local goalData = {
			name = "Attack",
			useSkirmishAI = g_useSkirmishAI,
			attackMove = true,
			target = attackTarget,
			safeMoveWeight = 0,
			coordinatedMoveRadius = 15,
			pickupWeapons = -1,
			onSuccess = FlamePioneers_OnSuccess,
		}
		g_enc_flamePioneers:SetGoal(goalData)
	end
end

---- Spawn enemies defending strategic points when the player gets close
function A2M01_SetupStrats()
	if EGroup_IsEmpty(eg_strats) then
		EGroup_Destroy(eg_strat_west)
		EGroup_Destroy(eg_strat_east)
		EGroup_Destroy(eg_strat_northEast)
		EGroup_Destroy(eg_strat_south)
		EGroup_Destroy(eg_strat_southEast)
		Rule_RemoveMe()
	else
		
		local proxCheck = function (group, index, strat)
			if Prox_AreTeamsNearMarker(Player_GetTeam(player1), Util_GetPosition(strat), ANY, 60) then 
				EGroup_Remove(eg_strats, strat)
				if EGroup_ContainsEntity(eg_strat_west, strat) then
					A2M01_SpawnStratDefense("west")
				elseif EGroup_ContainsEntity(eg_strat_east, strat) then
					A2M01_SpawnStratDefense("east")
				elseif EGroup_ContainsEntity(eg_strat_northEast, strat) then
					A2M01_SpawnStratDefense("northEast")
				elseif EGroup_ContainsEntity(eg_strat_south, strat) then
					A2M01_SpawnStratDefense("south")
				elseif EGroup_ContainsEntity(eg_strat_southEast, strat) then
					A2M01_SpawnStratDefense("southEast")
				end
			end
		end
		EGroup_ForEach(eg_strats, proxCheck)		
	end
end

-- Spawn enemies defending strategic points
function A2M01_SpawnStratDefense(area)
	local goalData = {
		name = "Defend",
		useSkirmishAI = g_useSkirmishAI,
	}
	local data = {
		name = "strat" .. area,
		player = player2,
		sgroups = {sg_e_all},
	}

	if area == "west" then
		data.units = {
			{
				sbp = SBP.GERMAN.SCOUTCAR_SDKFZ222,
				spawn = mkr_strat_west1,
			},
		}
		goalData.target = mkr_strat_west1
		goalData.range = 25
	elseif area == "east" then
		data.units = {
			{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				upgrades = {UPG.GERMAN.GRENADIER_MG42_LMG},
				spawn = mkr_strat_east1,
			},
			{
				sbp = SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD,
				spawn = mkr_strat_east2,
			},
		}
		goalData.target = eg_strat_east
		goalData.range = 35
		goalData.leashRange = 45
		goalData.coordinatedSetupFacingPositions = {World_Pos(88, 15, -40), World_Pos(198, 14.4, -28)}
		goalData.garrison = false
		goalData.garrisonIdle = false
	elseif area == "northEast" then	
		data.units = {
			{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				upgrades = {UPG.GERMAN.GRENADIER_MG42_LMG},
				spawn = mkr_strat_northEast1,
			},
			{
				sbp = SBP.GERMAN.MORTAR_TEAM_81MM,
				spawn = mkr_strat_northEast2,
			},
			{
				sbp = SBP.GERMAN.MORTAR_TEAM_81MM,
				spawn = mkr_strat_northEast3,
			},
		}
		goalData.garrison = false
		goalData.garrisonIdle = false
	elseif area == "northWest" then	
		data.units = {
			{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				upgrades = {UPG.GERMAN.GRENADIER_MG42_LMG},
				spawn = mkr_strat_northWest1,
			},
			{
				sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
				spawn = mkr_strat_northWest2,
			},
			{
				sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
				spawn = mkr_strat_northWest3,
			},
		}
		goalData.target = eg_strat_northWest
		goalData.range = 25
		goalData.leashRange = 20
		goalData.garrison = true
		goalData.garrisonIdle = false
	elseif area == "south" then	
		data.units = {
			{
				sbp = SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD,
				spawn = mkr_strat_south1,
			},
			{
				sbp = SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD,
				spawn = mkr_strat_south2,
			},
			{
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
				spawn = mkr_strat_south3,
			},
		}
		goalData.target = eg_strat_south
		goalData.range = 25
		goalData.leashRange = 20
	elseif area == "southEast" then	
		data.units = {
			{
				sbp = SBP.GERMAN.PANZER_IV_SQUAD,
				spawn = mkr_strat_southEast1,
			},
			{
				sbp = SBP.GERMAN.PANZER_IV_SQUAD,
				spawn = mkr_strat_southEast2,
			},
		}
		goalData.target = eg_strat_southEast
		goalData.range = 30
		goalData.leashRange = 40
	end
	if table.getn(data.units) > 0 then
		g_enc_strats[area] = Encounter:Create(data)
		g_enc_strats[area]:SetGoal(goalData)
	end
	
end

------ Patrolling enemies, spawned as objectives are started
------ Two groups patrol on the river and four more patrol near the center of the map	
function A2M01_SetupPatrols(num)
	
	local data = {
		name = "patrol3",
		player = player2,
		sgroups = {sg_e_all},
		units = {
			{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = mkr_trenchPatrol1,
			},
			{
				sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
				spawn = mkr_trenchPatrol1,
			}
		}
	}
	
	local goalData = {
		name = "Defend",
		useSkirmishAI = g_useSkirmishAI,
		pickupWeapons = -1,
		patrolParams = {
			path = "trenchPath1",
			wait = 5,
		},
		fallbackParams = {
			thresholds = {0.3},
		},
	    tacticControlsList = {
			{
				tacticType = TACTIC_Ability,
				priority = 100,
				retryTimeSecs = 2,
				waitTimeSecs = 4,
			},
			{
				tacticType = TACTIC_Avoid,
				priority = 50,
				retryTimeSecs = 3,
				waitTimeSecs = 6,
			},
			{
				tacticType = TACTIC_Retaliate,
				priority = 25,
				retryTimeSecs = 4,
				waitTimeSecs = 8,
			},
		},
	}
	
	if num == 1 then
		-- Enemies patrolling on the frozen river
		g_enc_patrols = {}
		
		data.name = "riverPatrol1"
		data.units = {
			{
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
				spawn = Util_GetRandomPosition(mkr_riverPatrol1, 8),
			},
			{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = Util_GetRandomPosition(mkr_riverPatrol1, 8),
			},
			{
				sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
				spawn = Util_GetRandomPosition(mkr_riverPatrol1, 8),
			}
		}
		table.insert(g_enc_patrols, Encounter:Create(data))
		goalData.patrolParams.path = "riverPath1"
		goalData.patrolParams.walk  = false
		goalData.onFailure = EncUpdate_DestroyPatrollers 
		goalData.fallbackParams = {
			thresholds = {0.7}, 
			globalPercentage = 0.6,
			thresholdType = Threshold_PercentageEntitiesRemaining,
			markers = {mkr_vp}, 
			retreat = true, 
		}
		g_enc_patrols[1]:SetGoal(goalData)

		data.name = "riverPatrol2"
		data.units = {
			{
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
				spawn = Util_GetRandomPosition(mkr_riverPatrol2, 8),
			},
			{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = Util_GetRandomPosition(mkr_riverPatrol2, 8),
			},
			{
				sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
				spawn = Util_GetRandomPosition(mkr_riverPatrol2, 8),
			}
		}
		table.insert(g_enc_patrols, Encounter:Create(data))
		goalData.patrolParams.path = "riverPath2"
		g_enc_patrols[2]:SetGoal(goalData)
		FOW_RevealSGroupOnly(g_enc_patrols[2].sgroup, 45)
		SGroup_SetInvulnerable(g_enc_patrols[2].sgroup, true)
		goalData.onFailure = nil
		
	elseif num == 2 then
		-- Enemies patrolling near the center of the map
		table.insert(g_enc_patrols, Encounter:Create(data))
		
		g_enc_patrols[3]:SetGoal(goalData)
		
		
		data.name = "patrol4"
		data.units = {
			{
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
				upgrades = {UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM},
				dropItems = {{slotItem = SLOT_ITEM.PANZERSHRECK, dropChance = 0, exclusive = true}},
				spawn = mkr_trenchPatrol2,
			},
			{
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
				spawn = mkr_trenchPatrol2,
			}
		}
		table.insert(g_enc_patrols, Encounter:Create(data))
		
		goalData.patrolParams.path = "trenchPath2"
		g_enc_patrols[4]:SetGoal(goalData)
		
	elseif num == 3 then
		-- Enemies patrolling further east, during the final objective
		data.name = "patrol5"
		data.units = {
			{
				sbp = SBP.GERMAN.SDKFZ_251_HALFTRACK_SQUAD,
				entityUpgrades = {UPG.GERMAN.SDKFZ_251_HALFTRACK_FLAMMPANZERWAGEN_UPGRADE},
				spawn = mkr_trenchPatrol3,
			},
			{
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
				upgrades = {UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM},
				dropItems = {{slotItem = SLOT_ITEM.PANZERSHRECK, dropChance = 0, exclusive = true}},
				spawn = mkr_trenchPatrol3,
			}
		}
		table.insert(g_enc_patrols, Encounter:Create(data))
	
		goalData.patrolParams.path = "trenchPath3"
		g_enc_patrols[5]:SetGoal(goalData)
		
		data.name = "patrol6"
		data.units = {
			{
				sbp = SBP.GERMAN.STUG_III_SQUAD,
				spawn = mkr_trenchPatrol4,
			},
			{
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
				upgrades = {UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM},
				dropItems = {{slotItem = SLOT_ITEM.PANZERSHRECK, dropChance = 0, exclusive = true}},
				spawn = mkr_trenchPatrol4,
			}
		}
		table.insert(g_enc_patrols, Encounter:Create(data))
		goalData.patrolParams.path = "trenchPath4"
		g_enc_patrols[6]:SetGoal(goalData)
	end
	
end

function EncUpdate_DestroyPatrollers(enc)
	if not Rule_Exists(EncUpdate_DestroyPatrollers_rule) then
		Rule_AddInterval(EncUpdate_DestroyPatrollers_rule, 1)
		t_patrollers = {enc.sgroup}
	else
		table.insert(t_patrollers, enc.sgroup)
	end
end

function EncUpdate_DestroyPatrollers_rule()
	for k,v in pairs(t_patrollers) do
		if not SGroup_IsOnScreen(player1, v, ANY) and not Player_CanSeeSGroup(player1, v, ANY) then
			SGroup_DestroyAllSquads(v)
		end
	end
end

function A2M01_SetupSandbags()
	g_enc_sandbags = {}
	
	local data = {
		name = "sandbag1",
		player = player2,
		sgroups = {sg_e_all},
		units = {
			{
				name = "sandbag1",
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = mkr_sandbags1,
			},
		}
	}
	table.insert(g_enc_sandbags, Encounter:Create(data))
	
	local goalData = {
		name = "Defend",
		useSkirmishAI = g_useSkirmishAI,
		fallbackParams = {
			thresholds = {0.3},
			retreat = true
		}
	}
	for k,enc in pairs(g_enc_sandbags) do
		goalData.target =  enc.units[1].spawn
		enc:SetGoal(goalData)
	end
	
end


function A2M01_SetupBaseInterior()
	-- Squads defending the German HQ structure
	g_enc_baseInterior = {}
	sg_e_baseInterior = SGroup_CreateIfNotFound("sg_e_baseInterior")
	local data = {
		name = "baseInteriorSandbags1",
		player = player2,
		sgroups = {sg_e_all, sg_e_baseInterior},
		units = {
			{
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
				spawn = mkr_baseInterior1,
			},
			{
				sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
				spawn = mkr_clearWrecks,
			},
			{
				sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
				spawn = mkr_enemyDefendLeash4,
			},
			{
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
				upgrades = {UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM},
				dropItems = {{slotItem = SLOT_ITEM.PANZERSHRECK, dropChance = 0, exclusive = true}},
				spawn = mkr_pickups,
			}
		}
	}
	g_enc_baseInterior[1] = Encounter:Create(data)
	
	local goalData = {
		name = "Defend",
		target = mkr_vp,
		range = 50,
		leashRange = 25,
		coordinatedSetupFacingPositions = {mkr_allyBarrageTarget1, mkr_rallyPoint, mkr_katy_target4, mkr_footbridge}
	}
	g_enc_baseInterior[1]:SetGoal(goalData)
	
		
	-- Setup second HMGs 
	if not g_easyDiff then
		sg_HMGs2 = SGroup_CreateIfNotFound("sg_HMGs2")
		if not EGroup_IsEmpty(eg_HMG1) then
			Util_CreateSquads(player2, sg_HMGs2, SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD, eg_HMG1)
		end
		if not EGroup_IsEmpty(eg_HMG2) then
			Util_CreateSquads(player2, sg_HMGs2, SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD, eg_HMG2)
		end
		if not EGroup_IsEmpty(eg_HMG3) then
			Util_CreateSquads(player2, sg_HMGs2, SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD, eg_HMG3)
		end
		if not g_hardDiff then
			Modify_WeaponDamage(sg_HMGs2, "hardpoint_01", 0.1)
		end
	end
	
end

function M07_OutroSquads()
	local player1Squads = Player_GetSquads(player1)
	local player3Squads = Player_GetSquads(player3)
	local player4Squads = Player_GetSquads(player4)
	SGroup_DeSpawn(player1Squads)
	SGroup_DeSpawn(player3Squads)
	SGroup_DeSpawn(player4Squads)
	sg_a_outro = SGroup_CreateIfNotFound("sg_a_outro")
	
	Util_CreateSquads(player3, sg_a_outro, SBP.SOVIET.T_34_76_SQUAD, mkr_outroSouth1, Marker_GetPosition(mkr_outroSouth1_dest))
	Util_CreateSquads(player3, sg_a_outro, SBP.SOVIET.M5_HALFTRACK_SQUAD, mkr_outroSouth2, Marker_GetPosition(mkr_outroSouth2_dest))
	Util_CreateSquads(player3, sg_a_outro, SBP.SOVIET.SNIPER_TEAM, mkr_outroSouth3)
	Util_CreateSquads(player3, sg_a_outro, SBP.SOVIET.GUARDS_TROOPS, mkr_outroSouth4)
	Rule_AddOneShot(M07_OutroSquads2, 7)
end

function M07_OutroSquads2()
	Util_CreateSquads(player3, sg_a_outro, SBP.SOVIET.T_34_76_SQUAD, mkr_outroNorth1, Marker_GetPosition(mkr_outroNorth1_dest))
	Util_CreateSquads(player3, sg_a_outro, SBP.SOVIET.SU_76M, mkr_outroNorth2, Marker_GetPosition(mkr_outroNorth2_dest))
	Util_CreateSquads(player3, sg_a_outro, SBP.SOVIET.SHOCK_TROOPS, mkr_outroNorth3)
	Util_CreateSquads(player3, sg_a_outro, SBP.SOVIET.GUARDS_TROOPS, mkr_outroNorth4)
end

-- FAIL CONDITION: The player has no HQ
function Loss_NoHQ()
	local playerEntities = Player_GetEntities(player1)
	local ebps = {EBP.SOVIET.HQ, BP_GetEntityBlueprint("forward_hq")}
	EGroup_Filter(playerEntities, ebps, FILTER_KEEP)
	if EGroup_IsEmpty(playerEntities) then
		Util_MissionTitle(11048793, 1, 5, 1) -- LOCDB [11048793] 'Mission Failed: Headquarters Destroyed'
		Rule_AddOneShot(_delayedMissionFail, 8)
		Rule_RemoveMe()
	end
end

function _delayedMissionFail()
	Game_EndSP(false)
end
------------------------- TEST FUNCTIONS --------------------------

--Skips an objective
function SkipObjective(num)
	if(num == 1) then
		EGroup_InstantCaptureStrategicPoint(eg_strat_southWest, player1)
		SGroup_Kill(sg_inTrenches)
		SGroup_Kill(sg_inBunkers)
		SGroup_Kill(sg_HMGs)
		SGroup_Kill(sg_e_howitzer)
		SGroup_Kill(sg_mortars)
		SGroup_Kill(sg_e_sw)
	elseif(num == 2) then
		Objective_Complete(OBJ_BreachDefenses)
		Player_GetAll(player1)
		SGroup_WarpToPos(sg_allsquads, Marker_GetPosition(mkr_vp))
		EGroup_InstantCaptureStrategicPoint(eg_vp, player1)
		Camera_FocusOnPosition(Marker_GetPosition(mkr_vp), false)
	elseif(num == 3) then
		Objective_Complete(OBJ_DefendTerritory)
	elseif(num == 4) then
		Objective_Complete(OBJ_DestroyStrongholds)
	end
end


----- ACHIEVEMENTS -----

-- Complete the mission without using mortars
function Achievement_NoMortarsAllowed()
	local playerSquads = Player_GetSquads(player1)
	local mortars = {SBP.SOVIET.PM_82_41_MORTAR_SQUAD, SBP.SOVIET.HM_120_38_MORTAR_SQUAD, SBP.GERMAN.MORTAR_TEAM_81MM}
	SGroup_Filter(playerSquads, mortars, FILTER_KEEP)
	if not SGroup_IsEmpty(playerSquads) then
		Rule_RemoveMe()
	end
end

-- Promote an Su-76 to veterancy rank 3
function Achievement_Vet3Suchka()
	local playerSquads = Player_GetSquads(player1)
	SGroup_Filter(playerSquads, SBP.SOVIET.SU_76M, FILTER_KEEP)
	if not SGroup_IsEmpty(playerSquads) then
		local f = function (gid, idx, sid)
			if Squad_GetVeterancyRank(sid) == 3 then
				Scar_CompleteIntelBulletinTask(player1, "camp07_landbridge_su76")
				Rule_RemoveMe()
				return true
			end
		end
		SGroup_ForEach(playerSquads, f)
	end
end

-- Get close to both of the final German strongholds
function Achievement_CloseRange()
	if g_closeToTrainStation and g_closeToPowerPlant and g_hardDiff then
		Scar_CompleteIntelBulletinTask(player1, "camp07_landbridge_close")
	end
end

