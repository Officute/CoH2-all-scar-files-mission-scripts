-------------------------------------------------------------------------
-------------------------------------------------------------------------

-- Company of Heroes 2
-- Mission 3: Moscow_Outskirts
-- Designers: Ryan McGechaen / Sacha Narine

-------------------------------------------------------------------------
-------------------------------------------------------------------------
isCampaign = true
import("ScarUtil.scar")
import("Prototype/DeploymentPoints.scar")
import("Systems/AiManager/ai.scar")
import("Beginner.scar")
import("Global_Values/CampaignGlobalConstants.scar")

-------------------------------------------------------------------------
-- [[ SETUP ]]
-------------------------------------------------------------------------

function OnGameSetup()
	
	player1 = Setup_Player(1, 11038758, "soviet", 1)		-- player1 is always the human player
	player2 = Setup_Player(2, 11038759, "german", 2)		-- player2 is always the AI opponent
	player3 = Setup_Player(3, 11038758, "soviet", 1)		-- player3 is always the AI ally

end



function OnGameRestore()
	
	player1 = World_GetPlayerAt(1)
	player2 = World_GetPlayerAt(2)
	player3 = World_GetPlayerAt(3)
	EGroup_EnableMinimapIndicator(eg_mm_hide, false)
	UI_SetCPMeterVisibility(true)
	Rule_AddOneShot(M03_OnGameRestore, 1)
	Game_DefaultGameRestore()
end

function M03_OnGameRestore()
	UI_SetCPMeterVisibility(false)
end


-------------------------------------------------------------------------
-- [[ ONINIT ]]
-------------------------------------------------------------------------

function OnInit()
	
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
	
	--[[ PLAY INTRO NIS]]
	Game_FadeToBlack(FADE_OUT, 0)
	Rule_Add(Mission_NISStart)
	
	--[[ REGISTER OBJECTIVES ]]
	Initialize_HoldTheRidge()
	Initialize_RetakeRidgePoint()
	Initialize_SecondaryOBJ()
	Initialize_RidgeMortars()
	Initialize_HoldTheVillage()
	Initialize_RetakeVillagePoint()
	Initialize_DefendCapturePointsTIMER()
	Initialize_DCP_SquadsInCover()
	Initialize_DCP_MinesOrDemo()
	Initialize_PingATGuns()
	Initialize_RetakeTheRidge()
	Initialize_RetakeTheRidge_Capture()
	Initialize_RetakeTheRidge_Kill()

end
Scar_AddInit(OnInit)

g_useSkirmishAI = true
g_useWithdraw = true
g_enableExtraIceDamage = true

g_isWinterMap = true

function Mission_NISStart()

	Rule_RemoveMe()
	
	UI_SetDecoratorsEnabled(false)
	Util_StartNIS(EVENTS.NIS01, nil, nil, nil, nil, nil, true)
	Rule_AddDelayedInterval(Mission_MissionStart, 1, 0.1)
end

function Mission_Debug()
	
	-- looks for the command line option [-debug]
	if Misc_IsCommandLineOptionSet("framedump") then
		g_debug = true
		Rule_RemoveAll()
		
		Game_FadeToBlack(FADE_IN, 0)
		
		Scar_DebugConsoleExecute("bind([[ALT+1]], [[Scar_DoString('Util_StartNIS(EVENTS.NIS01)')]])")
		Scar_DebugConsoleExecute("bind([[ALT+2]], [[Scar_DoString('Util_StartNIS(EVENTS.NIS02)')]])")
		Scar_DebugConsoleExecute("bind([[ALT+3]], [[Scar_DoString('Util_StartNIS(EVENTS.NIS03)')]])")
	end
	
end

function Mission_Restrictions()
	
	Player_SetEntityProductionAvailability(player1, EBP.SOVIET.BARRACKS, ITEM_REMOVED)
	Player_SetEntityProductionAvailability(player1, EBP.SOVIET.MOTORPOOL, ITEM_REMOVED)
	Player_SetEntityProductionAvailability(player1, EBP.SOVIET.TANK_DEPOT, ITEM_REMOVED)
	
	Player_SetSquadProductionAvailability(player1, SBP.SOVIET.M1937_53_K_45MM_AT_GUN_SQUAD, ITEM_REMOVED)
	Player_SetSquadProductionAvailability(player1, SBP.SOVIET.PM_82_41_MORTAR_SQUAD, ITEM_REMOVED)
	Player_SetSquadProductionAvailability(player1, SBP.SOVIET.M1942_ZIS_3_76MM_AT_GUN_SQUAD, ITEM_REMOVED)
	Player_SetSquadProductionAvailability(player1, SBP.SOVIET.M3A1_SCOUT_CAR_SQUAD, ITEM_REMOVED)
	Player_SetSquadProductionAvailability(player1, SBP.SOVIET.SNIPER_TEAM, ITEM_REMOVED)
	Player_SetSquadProductionAvailability(player1, SBP.SOVIET.M5_HALFTRACK_SQUAD, ITEM_REMOVED)
	Player_SetSquadProductionAvailability(player1, SBP.SOVIET.T_70M, ITEM_REMOVED)
	Player_SetSquadProductionAvailability(player1, SBP.SOVIET.SU_76M, ITEM_REMOVED)
	Player_SetSquadProductionAvailability(player1, SBP.SOVIET.PENAL_BATTALION, ITEM_REMOVED)
	
	Player_SetAbilityAvailability(player1, ABILITY.SOVIET.CONSCRIPT_MOLOTOV_COCKTAIL, ITEM_UNLOCKED)
	Player_SetAbilityAvailability(player1, ABILITY.SOVIET.CONSCRIPT_OORAH, ITEM_UNLOCKED)
	Player_SetAbilityAvailability(player1, ABILITY.SOVIET.ANTI_TANK_GRENADE, ITEM_REMOVED)
	Player_SetAbilityAvailability(player1, ABILITY.SOVIET.SATCHEL_CHARGE_THROW_ABILITY_MP, ITEM_REMOVED)
	
	Player_SetUpgradeAvailability(player1, UPG.SOVIET.PENAL_BATTALION_FLAMETHROWER_PACKAGE, ITEM_REMOVED)
	Player_SetUpgradeAvailability(player1, UPG.SOVIET.HQ_ANTI_TANK_GRENADE, ITEM_REMOVED)
	
	Player_SetCommandAvailability(player1, SCMD_Retreat, ITEM_LOCKED)
	
end

function Mission_CpuInit()

	-- Utilize for controlling AI functionality
	-- eg: Player_SetResource(player2, RT_Manpower, 1000)
	-- eg: AI_EnableComponent(player2, false, COMPONENT_Attacking)

	Player_SetAbilityAvailability(player2, ABILITY.GERMAN.GRENADIER_PANZERFAUST, ITEM_LOCKED)
	g_bombardFX = BP_GetAbilityBlueprint("bombardment_fx")
	Player_AddAbility(player2, g_bombardFX)
	Player_AddAbility(player2, ABILITY.GLOBAL.SP_SINGLE_SHOT_MORTAR)
	Player_CompleteUpgrade(player2, BP_GetUpgradeBlueprint("campaign/howitzer_barrage_short_upgrade"))
	Player_CompleteUpgrade(player2, BP_GetUpgradeBlueprint("rifle_grenade_slow"))
end

function Mission_Difficulty()

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
	  abilityControlsList = {
		{
			abilityPBG = ABILITY.GERMAN.GRENADIER_RIFLE_GRENADE_ABILITY,
			maxCasters = 1,
			retryTimeSecs = 30,
			waitTimeSecs = 60,
			useInitialWaitTime = false,
		},
	  }
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
			retryTimeSecs = 5,
			waitTimeSecs = 15,
		},
		{
			tacticType = TACTIC_RushAtTarget,
			priority = 5,
			retryTimeSecs = 8,
			waitTimeSecs = 12,
		},
	  },
	  abilityControlsList = {
		{
			abilityPBG = ABILITY.GERMAN.GRENADIER_RIFLE_GRENADE_ABILITY,
			maxCasters = 2,
			retryTimeSecs = 30,
			waitTimeSecs = 30,
			useInitialWaitTime = false,
		},
	  }
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


	t_modifyGoalData_attackEasy = { 
		range_Multiplier = 0.9,
		movePathLengthFactor_Multiplier = 0.5,
		safeMoveWeight_Multiplier = 0.333,
		fallbackParams = 
		{
			thresholds_Multiplier = 1.33,
		},
	}
	t_modifyGoalData_attackHard = { 		
		range_Multiplier = 1.33,
		movePathLengthFactor_Multiplier = 1.2,
		leashRange_Multiplier = 1.33,
		safeMoveWeight_Multiplier = 1.25,
		fallbackParams = 
		{
			thresholds_Multiplier = 0.5,
		},

	}
	t_modifyGoalData_defendEasy = { 
		range_Multiplier = 0.9,
		leashRange_Multiplier = 0.9,
		maxAttackers_Multiplier = -2,
		safeMoveWeight_Multiplier = 0.75,
	}
	t_modifyGoalData_defendHard = { 
		range_Multiplier = 1.2,
		movePathLengthFactor_Multiplier = 1.2,
		leashRange_Multiplier = 1.2,
		safeMoveWeight_Multiplier = 1.25,
	}
	
	-- get the difficulty
	g_difficulty = Game_GetSPDifficulty()  -- set a global difficulty variable 
	print("********* DIFFICULTY: "..g_difficulty)
	
	t_difficulty = {
		-- Mission
		startingRes_Command					= Util_DifVar( {2, 2, 2, 2} ),				-- Starting Command Points
		startingRes_Manpower				= Util_DifVar( {500, 360, 360, 360} ),		-- Starting Manpower
		startingRes_Munitions				= Util_DifVar( {90, 60, 30, 15} ),		-- Starting Munition
		startingRes_Fuel					= Util_DifVar( {0, 0, 0, 0} ),		-- Starting Fuel
		resourceRate_Manpower				= Util_DifVar( {1.2, 1, 1, 1} ),		-- Resource rate modifier for manpower
		resourceRate_Munitions				= Util_DifVar( {1.5, 1, 1, 1} ),
		-- Waves
		-- Ridge
		ice_heal_rate							= Util_DifVar( {0.002, 0.002, 0.002, 0.002} ),	-- How fast the ice re-freezes
		
		-- Village
		vil_first_HMGs							= Util_DifVar( {false, false, true, true} ),	-- Early Village HMGs
		vil_second_HMGs							= Util_DifVar( {false, true, true, true} ),	-- Later Village HMGs
		vil_start_time							= Util_DifVar( {4*60, 3.5*60, 3*60, 2.5*60} ), -- how much time before the Germans attack
		
		-- 
		bundledGrenadeLimit 					= Util_DifVar( {4, 3, 2, 1}),
		defaultAttackGoalData 					= Util_DifVar( {t_defaultGoalData_attackEasy, t_defaultGoalData_attackNormal, t_defaultGoalData_attackHard, {}}),
		defaultDefendGoalData 					= Util_DifVar( {t_defaultGoalData_defendEasy, t_defaultGoalData_defendNormal, t_defaultGoalData_defendHard, {}}),
		modifyAttackGoalData					= Util_DifVar( {t_modifyGoalData_attackEasy, {}, t_modifyGoalData_attackHard, {}}),
		modifyDefendGoalData					= Util_DifVar( {t_modifyGoalData_defendEasy, {}, t_modifyGoalData_defendHard, {}}),
	}

	AIAttackGoal_AdjustDefaultGoalData(t_difficulty.defaultAttackGoalData)
	AIDefendGoal_AdjustDefaultGoalData(t_difficulty.defaultDefendGoalData)	
	
	AIAttackGoal_SetModifyGoalData(t_difficulty.modifyAttackGoalData)
	AIDefendGoal_SetModifyGoalData(t_difficulty.modifyDefendGoalData)

	
	g_disableCoverTactic = {
		{
			tacticType = TACTIC_Cover,
			priority = -1,
		},
	}
	
	g_ampCoverTactic = {
		{
			tacticType = TACTIC_Cover,
			priority = 100,
			retryTimeSecs = 3,
			waitTimeSecs = 0,
		},
		{
			tacticType = TACTIC_RushAtTarget,
			priority = -1,
		},
	}
	
	g_disableForceAttackTactic = {
		{
			tacticType = TACTIC_ForceAttack,
			priority = -1,
		},
	}
	
	g_disableVehicleTactic = {
		{
			tacticType = TACTIC_Vehicle,
			priority = -1,
		},
		{
			tacticType = TACTIC_Retaliate,
			priority = -1,
		},
		{
			tacticType = TACTIC_Help,
			priority = -1,
		},
	}

	if not g_easyDiff then
		Player_SetAbilityAvailability(player2, ABILITY.GERMAN.GRENADIER_RIFLE_GRENADE_ABILITY, ITEM_UNLOCKED)
		Modify_AbilityRechargeTime(player2, ABILITY.GERMAN.GRENADIER_RIFLE_GRENADE_ABILITY, 2)
	end
	
	Modify_ProjectileDelayTime(player2, BP_GetEntityBlueprint("bundled_stielgranate_campaign"), CAMPAIGN_PGREN_BUNDLED_TIMER)
	
end


-------------------------------------------------------------------------
-- MISSION Preset 
-------------------------------------------------------------------------

function Mission_MissionPreset()
	
	Player_CompleteUpgrade(player1, BP_GetUpgradeBlueprint("campaign/mission03_upgrade"))
	
	Player_CompleteUpgrade(player2, BP_GetUpgradeBlueprint("upgrade/campaign/disable_abandon_critical"))
	
	Modify_AbilityMaxCastRange(player1, ABILITY.SOVIET.CONSCRIPT_MOLOTOV_COCKTAIL, 1.2)
	
	Player_CompleteUpgrade(player2, BP_GetUpgradeBlueprint("upgrade/campaign/disable_abandon_critical"))
	Player_CompleteUpgrade(player3, BP_GetUpgradeBlueprint("upgrade/campaign/disable_abandon_critical"))
	Player_CompleteUpgrade(player2, BP_GetUpgradeBlueprint("panzer_grenadier_mp40"))
	
	-- Set up abilities and upgrade
	Player_AddAbility(player1, ABILITY.SOVIET.BASE_CONSCRIPT_DISPATCH)
	Player_AddAbility(player1, BP_GetAbilityBlueprint("frontoviki_conscript_dispatch"))
	Player_AddAbility(player1, ABILITY.SOVIET.PENAL_TROOP_DISPATCH_SP)
	Player_AddAbility(player1, ABILITY.GLOBAL.TRANSFER_ORDERS)
	Player_AddAbility(player2, ABILITY.GLOBAL.OFF_MAP_ARTY_SINGLE_SHOT_INSTANT)
	Player_AddAbility(player3, ABILITY.GLOBAL.OFF_MAP_ARTILLERY)
	
	-- Set up Resources
	Resources_Disable()
	
	Player_SetPopCapOverride(player1, 75)
	
	World_SetIceHealingRate(0)
	
	Modifier_Remove(g_munitions_zero)

	Player_SetResource(player1, RT_Manpower, 0)
	Player_SetResource(player1, RT_Munition, t_difficulty.startingRes_Munitions)
	Player_SetResource(player1, RT_Fuel, 0)
	Modify_PlayerResourceRate(player1, RT_Munition, t_difficulty.resourceRate_Munitions)
	if g_easyDiff then
		Modify_Upkeep(player1, 0.5)
	end
	
	Modify_PlayerResourceCap(player1, RT_SovietProgression, -50, MUT_Addition)
	Player_AddUnspentCommandPoints(player1, 1)
	
	modID_manpowerCap = Modify_PlayerResourceCap(player1, RT_Manpower, 1, MUT_Addition)
	Modify_PlayerResourceCap(player1, RT_Munition, 601, MUT_Addition)
	modID_fuelCap = Modify_PlayerResourceCap(player1, RT_Fuel, 1, MUT_Addition)

	-- give the enemy resources for abilities
	Player_SetResource(player2, RT_Munition, 999999999)

	eg_p_hq = EGroup_CreateIfNotFound("eg_p_hq")
	
	FOW_EnableTint(false)
	Camera_SetDeclination(0.5)
	Camera_SetZoomDist(21)
	Camera_SetOrbit(-1.1)
	Camera_MoveTo(mkr_startCamera)

	EGroup_DeSpawn(eg_germanMines)
	EGroup_InstantCaptureStrategicPoint(eg_POS_A_Points, player1)
	
	-- Spawn munitions structures
	eg_p_munitions_01 = EGroup_CreateIfNotFound("eg_p_munitions_01")
	eg_p_munitions_02 = EGroup_CreateIfNotFound("eg_p_munitions_02")
	eg_p_munitions_03 = EGroup_CreateIfNotFound("eg_p_munitions_03")
	eg_p_munitions_04 = EGroup_CreateIfNotFound("eg_p_munitions_04")
	Util_CreateEntities(player1, eg_p_munitions_01, EBP.SOVIET.OBSERVATION_POST_MUNITION, mkr_p_munitions01, 1)
	Entity_ForceConstruct(EGroup_GetSpawnedEntityAt(eg_p_munitions_01, 1))
	
	Util_CreateEntities(player1, eg_p_munitions_02, EBP.SOVIET.OBSERVATION_POST_MUNITION, mkr_p_munitions02, 1)
	Entity_ForceConstruct(EGroup_GetSpawnedEntityAt(eg_p_munitions_02, 1))

	Util_CreateEntities(player1, eg_p_munitions_03, EBP.SOVIET.OBSERVATION_POST_MUNITION, mkr_p_munitions03, 1)
	Entity_ForceConstruct(EGroup_GetSpawnedEntityAt(eg_p_munitions_03, 1))
	
	sg_p_conscript01 = SGroup_CreateIfNotFound("sg_p_conscript01")
	sg_p_conscript02 = SGroup_CreateIfNotFound("sg_p_conscript02")
	sg_p_conscript03 = SGroup_CreateIfNotFound("sg_p_conscript03")
	sg_p_conscript04 = SGroup_CreateIfNotFound("sg_p_conscript04")
	sg_p_conscript05 = SGroup_CreateIfNotFound("sg_p_conscript05")
	sg_p_conscript06 = SGroup_CreateIfNotFound("sg_p_conscript06")
	sg_p_conscriptIntro = SGroup_CreateIfNotFound("sg_p_conscriptIntro")
	
	sg_mergehints = SGroup_CreateIfNotFound("sg_mergehints")
	sg_reinforcehints = SGroup_CreateIfNotFound("sg_reinforcehints")
	
	Util_CreateSquads(player1, {sg_p_conscript01, sg_p_conscriptIntro}, SBP.SOVIET.BASE_CONSCRIPT_SQUAD, mkr_a_t34_02_postNIS_RDG, Marker_GetPosition(mkr_p_RDG_conscript_01))
	Util_CreateSquads(player1, {sg_p_conscript01, sg_p_conscriptIntro}, SBP.SOVIET.BASE_CONSCRIPT_SQUAD, mkr_friendly_artillery_B_02, Marker_GetPosition(mkr_p_RDG_conscript_02))
	Util_CreateSquads(player1, {sg_p_conscript01, sg_p_conscriptIntro}, SBP.SOVIET.BASE_CONSCRIPT_SQUAD, mkr_friendly_artillery_B_01, Marker_GetPosition(mkr_p_RDG_conscript_03))
	Util_CreateSquads(player1, sg_p_conscript01, SBP.SOVIET.BASE_CONSCRIPT_SQUAD, mkr_e_RDG_pnzrIII_02_def, Marker_GetPosition(mkr_p_RDG_conscript_04))
	Util_CreateSquads(player1, sg_p_conscript01, SBP.SOVIET.BASE_CONSCRIPT_SQUAD, mkr_e_RDG_pnzrIII_03_def, Marker_GetPosition(mkr_p_RDG_conscript_05))
	Util_CreateSquads(player1, sg_p_conscript01, SBP.SOVIET.BASE_CONSCRIPT_SQUAD, mkr_e_RDG_pnzrIII_02_def, Marker_GetPosition(mkr_p_RDG_conscript_06))
	Util_CreateSquads(player1, sg_p_conscript01, SBP.SOVIET.BASE_CONSCRIPT_SQUAD, mkr_friendly_artillery_A_05, Marker_GetPosition(mkr_p_RDG_conscript_07))
	Util_CreateSquads(player1, sg_p_conscript01, SBP.SOVIET.BASE_CONSCRIPT_SQUAD, mkr_p_RDG_conscript_10, Marker_GetPosition(mkr_p_RDG_conscript_08))
	Util_CreateSquads(player1, sg_p_conscript01, SBP.SOVIET.BASE_CONSCRIPT_SQUAD, mkr_RDG_canSeeRight, Marker_GetPosition(mkr_p_RDG_conscript_09))
	Util_CreateSquads(player1, sg_p_conscript01, SBP.SOVIET.BASE_CONSCRIPT_SQUAD, mkr_p_arty_salvo_07, Marker_GetPosition(mkr_p_RDG_conscript_10))
	
	-- Intro Trucks, for nislet
	sg_a_introTruck1 = SGroup_CreateIfNotFound("sg_a_introTruck1")
	sg_a_introTruck2 = SGroup_CreateIfNotFound("sg_a_introTruck2")
	Util_CreateSquads(player1, sg_a_introTruck1, SBP.SOVIET.ZIS_6_TRANSPORT_TRUCK , mkr_introTruck1, Marker_GetPosition(mkr_a_RDG_truck_dest))
	Util_CreateSquads(player1, sg_a_introTruck2, SBP.SOVIET.ZIS_6_TRANSPORT_TRUCK , mkr_introTruck2, Marker_GetPosition(mkr_friendly_artillery_B_03))
	Cmd_CriticalHit(player1, sg_a_introTruck1, CRIT.VEHICLE_DAMAGE_ENGINE, 0)
	Cmd_CriticalHit(player1, sg_a_introTruck2, CRIT.VEHICLE_DAMAGE_ENGINE_REAR, 0)
	SGroup_SetAnimatorState(sg_a_introTruck1, "supplies_loaded", "partial")
	SGroup_SetAnimatorState(sg_a_introTruck2, "supplies_loaded", "full")
	
	sg_a_hmg = SGroup_CreateIfNotFound("sg_a_hmg")
	Util_CreateSquads(player3, sg_a_hmg, SBP.SOVIET.M1910_MAXIM_HEAVY_MACHINE_GUN_SQUAD, mkr_a_RDG_HMG, nil, 1, 2)

	SGroup_EnableMinimapIndicator(sg_a_hmg, false)
	SGroup_EnableUIDecorator(sg_a_hmg, false)
	SGroup_SetSelectable(sg_a_hmg, false)
	
	Modify_WeaponDamage(sg_a_hmg, "hardpoint_01", 0.1)
	
	EGroup_DeSpawn(eg_p_MEP_02)
	
	EGroup_DeSpawn(eg_gravestones)
	
	EGroup_EnableMinimapIndicator(eg_mm_hide, false)
	EGroup_EnableMinimapIndicator(eg_mm_unlock1, false)
	
	-- Set AT guns to be invuln until second barrage in village
	g_at_01_id = Entity_GetGameID(EGroup_GetSpawnedEntityAt(eg_VIL_at_01, 1))
	g_at_02_id = Entity_GetGameID(EGroup_GetSpawnedEntityAt(eg_VIL_at_02, 1))
	g_at_03_id = Entity_GetGameID(EGroup_GetSpawnedEntityAt(eg_VIL_at_03, 1))
	
	Entity_SetInvulnerable(Entity_FromWorldID(g_at_01_id), true, -1)
	Entity_SetInvulnerable(Entity_FromWorldID(g_at_02_id), true, -1)
	Entity_SetInvulnerable(Entity_FromWorldID(g_at_03_id), true, -1)
	
	Cmd_CriticalHit(player1, eg_VIL_atGuns, CRIT.VEHICLE_ABANDON, 0)
	
	SBP.GERMAN.STUG_III_SQUAD = BP_GetSquadBlueprint("stug_iii_e_squad")
	
	sg_pioneers_flame = SGroup_CreateIfNotFound("sg_pioneers_flame")
	g_flamePioCount = 0
	g_enc_flamePioneers = {}
	
	UI_SetSoviet227Visibility(true)
	
	g_missionFailed = false

end


-------------------------------------------------------------------------
-- UTILITY FUNCTIONS
-------------------------------------------------------------------------
function __findHiddenSpawn(loc1, loc2)
	
	local hiddenPos = World_GetHiddenPositionOnPath(player1, loc1, loc2, CHECK_IN_FOW)
	if hiddenPos ~= nil then
		local hiddenPos_plus = Util_GetPositionFromAtoB(hiddenPos, loc1, 10)
		if hiddenPos_plus ~= nil then
			return hiddenPos_plus
		else
			return loc1
		end
	else
		return loc1
	end

end

function __monitorPopulation()

	local num = Player_GetNumStrategicPoints(player1)
	
	g_basePop = 30
	local additional = num*8
	
	local total = g_basePop + additional
	
	Player_SetPopCapOverride(player1, total)

end

function __trash()
	
	sg_e_trash = SGroup_CreateIfNotFound("sg_e_trash")
	
	Player_GetAllSquadsNearMarker(player2, sg_e_trash, mkr_trash)
	
	local _sortTrash = function(gid, idx, sid)
		if Squad_IsRetreating(sid) then
			Squad_Destroy(sid)
		end
	end
	
	SGroup_ForEach(sg_e_trash, _sortTrash)

end

function __getTeamWeapon_Facing(sgroup)
	
	if SGroup_IsEmpty(sgroup) == false then
		local entityID = nil
		
		local count = Squad_Count(SGroup_GetSpawnedSquadAt(sgroup, 1))
		
		if count == 0 then
			print("Squad is empty")
			return nil
		else
			print(count)
			for i = 1, count do
				local sid = SGroup_GetSpawnedSquadAt(sgroup, 1)
				local eid = Entity_GetGameID(Squad_EntityAt(sid, (i-1)))
				
				if Entity_IsSyncWeapon(Entity_FromWorldID(eid)) then
					entityID = eid
				end
			end
		end
		
		if entityID == nil then
			print("Could not find team weapon in SGroup")
		else
			return Util_GetOffsetPosition(Entity_FromWorldID(entityID), OFFSET_FRONT, 10)
		end
	else
		print("SGroup is empty")
	end

end

function __destroyAbandoned()
	
	eg_abandoned = EGroup_CreateIfNotFound("eg_abandoned")
	
	local center = Util_ScarPos(0,0)
	
	local x = World_GetLength()
	local y = World_GetWidth()
	
	if x > y then
		World_GetNeutralEntitiesNearPoint(eg_abandoned, center, x)
	elseif x < y then
		World_GetNeutralEntitiesNearPoint(eg_abandoned, center, y)
	end
	
	EGroup_Filter(eg_abandoned, EBP.GERMAN.STUG_III_G_SDKFZ_141_1, FILTER_KEEP)
	
	EGroup_DestroyAllEntities(eg_abandoned)

end

-- Lower Grenadier weapon range to put them close enough for Molotovs and Grenades
function __reduceGrenadierRange()
	if mod_grenRange ~= nil then
		Modifier_Remove(mod_grenRange)
	end
	_player2Squads = Player_GetSquads(player2)
	if not SGroup_IsEmpty(_player2Squads) then
		SGroup_Filter(_player2Squads, SBP.GERMAN.GRENADIER_SQUAD, FILTER_KEEP)
	end
	if not SGroup_IsEmpty(_player2Squads) then
		mod_grenRange = Modify_WeaponRange(_player2Squads, "hardpoint_01", 0.75)
	end
end

function __countPlayerSlotItems()
	local player1Squads = Player_GetSquads(player1)
	if not SGroup_IsEmpty(player1Squads) then
		local flamerCount = SGroup_GetNumSlotItem(player1Squads, SLOT_ITEM.PIONEER_FLAMETHROWER)
		g_playerFlamerCount = math.max(flamerCount, g_playerFlamerCount)
		local lmgCount = SGroup_GetNumSlotItem(player1Squads, SLOT_ITEM.GRENADIER_MG42_LMG)
		g_playerLmgCount = math.max(lmgCount, g_playerLmgCount)
	end
end

function __countMortarsKilled()
	g_playerMortarCount = g_playerMortarCount + 1
end

-------------------------------------------------------------------------
-- MISSION START 
-------------------------------------------------------------------------
function Mission_MissionStart()
	
	if Event_IsAnyRunning() == false then
		Rule_RemoveMe()
		
		Rule_AddOneShot(HTR_Speech_Cold, 15)

		Util_StartIntel(EVENTS.Intro)
		
		eg_temp = EGroup_CreateIfNotFound("eg_temp")
		eg_blah = EGroup_CreateIfNotFound("eg_blah")
		sg_temp = SGroup_CreateIfNotFound("sg_temp")
		sg_blah = SGroup_CreateIfNotFound("sg_blah")
		
		-- Re-enable resources, set the new rates
		Resources_Enable()
		modID_manpowerRate = Modify_PlayerResourceRate(player1, RT_Manpower, 0)
		Modify_PlayerResourceRate(player1, RT_Fuel, 0)
		
		-- hints about merging into damaged squads and reinforcing from halftracks and HQs
		Moscow_UpdateHintGroups()
		BeginnerHint_AddOpportunity(sg_reinforcehints, HINT_REINFORCE, true)		-- NOTE: The generic merge hint opportunity is added later, after the special case about the Maxim HMG has played out
		Rule_AddInterval(Moscow_UpdateHintGroups, 30)

		Rule_Add(__trash)
		
		Game_EnableInput(true)
		UI_SetDecoratorsEnabled(true)
		
		Sound_PlayMusic("streamed/music/missions/m03/m03_cue_start_defend_ridge", 20, 0)
		
		-- DEV
		-- Wave timings
		g_dev_rdg_wave2 = 0
		g_dev_rdg_wave3 = 0
		g_dev_rdg_wave4 = 0
		g_dev_rdg_wave5 = 0
		
		g_dev_vil_wave2 = 0
		g_dev_vil_wave3 = 0
		g_dev_vil_wave4 = 0
		g_dev_vil_wave5 = 0
		g_dev_vil_wave6 = 0
		
	end
	
end

function Moscow_UpdateHintGroups()
	
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




----------------------
-- Objective: Hold the Positions
-- PRIMARY
----------------------
function Mission_OBJ_HLR_DelayStart()
	Objective_Start(OBJ_HoldTheRidge)
end

function HTR_Speech_Cold()
	Sound_PlayOnSquad("speech/sp/mission/m03/11035350", sg_p_conscriptIntro)
end

function Initialize_HoldTheRidge()

	OBJ_HoldTheRidge = {
		
		SetupUI = function() 
			hpid_pos_A = Objective_AddUIElements(OBJ_HoldTheRidge, mkr_e_RDG_leftDest, true, 11008183, true)
			hpid_pos_B = Objective_AddUIElements(OBJ_HoldTheRidge, mkr_e_RDG_midDest, true, 11008183, true)
			hpid_pos_C = Objective_AddUIElements(OBJ_HoldTheRidge, mkr_e_RDG_rightDest, true, 11008183, true)
			-- LOCDB [11008183] 'Defend this Territory'
		end,
		
		OnStart = function()

			sg_e_ambientOstruppen = SGroup_CreateIfNotFound("sg_e_ambientOstruppen")
			
			Rule_AddOneShot(OBJ_HTR_Wave1, 3.5)
			Rule_AddDelayedInterval(HTR_Wave1_Speech, 4, 1)
			Rule_AddDelayedInterval(Hint_trenchWalls, 5, 1)
			Rule_AddDelayedInterval(Hint_conscriptSMG, 60, 1)
			Rule_AddDelayedInterval(OBJ_HTR_PreventSpawnCamp, 30, 5)
			Objective_SetAlwaysShowDetails(OBJ_HoldTheRidge, true, true, true)
			

			CapturePoints_Set({eg_POS_A_Points_01, eg_POS_A_Points_02, eg_POS_A_Points_03}, OBJ_HoldTheRidge, OBJ_RetakeRidgePoint)
			
			-- Set variables
			g_leftPointOwner = player1
			g_midPointOwner = player1
			g_rightPointOwner = player1

			g_phase = "RIDGE"
			
			g_RDGpointsLost = 0
			
			g_RDG_RetakeTime = 1.2*60
			
			_t_lanes = {}
			_t_lanes[1] = {}
			_t_lanes[1].spawn = mkr_e_RDG_leftSpawn_01
			_t_lanes[1].altSpawn1 = mkr_e_RDG_leftForestSpawn_01
			_t_lanes[1].altSpawn2 = mkr_e_RDG_leftForestSpawn_01
			_t_lanes[1].target = mkr_e_RDG_leftDest
			
			_t_lanes[2] = {}
			_t_lanes[2].spawn = mkr_e_RDG_midSpawn_01
			_t_lanes[2].altSpawn1 = mkr_e_RDG_leftForestSpawn_01
			_t_lanes[2].altSpawn2 = mkr_e_RDG_rightForestSpawn_01
			_t_lanes[2].target = mkr_e_RDG_midDest
			
			_t_lanes[3] = {}
			_t_lanes[3].spawn = mkr_e_RDG_rightSpawn_01
			_t_lanes[3].altSpawn1 = mkr_e_RDG_rightForestSpawn_01
			_t_lanes[3].altSpawn2 = mkr_e_RDG_rightForestSpawn_02
			_t_lanes[3].target = mkr_e_RDG_rightDest
			
			
			-- Wave Timers
			tmr_RDG_wave2 = "tmr_RDG_wave2"
			tmr_RDG_wave2A = "tmr_RDG_wave2A"
			tmr_RDG_wave3 = "tmr_RDG_wave3"
			tmr_RDG_wave4 = "tmr_RDG_wave4"
			tmr_RDG_wave5 = "tmr_RDG_wave5"
			
			local ridgeTimerScale = 1
			if g_hardDiff then
				ridgeTimerScale = 0.85
			end
			
			g_RDG_wave2 = 1.5*60*ridgeTimerScale -- 1.5*60 -- original timings in comments
			g_RDG_wave2A = 1.25*60*ridgeTimerScale-- 1.5*60
			g_RDG_wave3 = 1.25*60*ridgeTimerScale -- 3*60
			g_RDG_wave4 = 1.5*60*ridgeTimerScale -- 3*60	
			g_RDG_wave5 = 1.5*60*ridgeTimerScale -- 2*60
			
			-- Warning timers
			tmr_left_loss = "tmr_left_loss"
			tmr_mid_loss = "tmr_mid_loss"
			tmr_right_loss = "tmr_right_loss"
			
			-- Slot Items
			g_playerFlamerCount = 0
			g_playerLmgCount = 0
			g_playerMortarCount = 0
			
		end,
		
		OnComplete = function()
			if hpid_pos_A ~= nil then Objective_RemoveUIElements(OBJ_HoldTheRidge, hpid_pos_A) end
			if hpid_pos_B ~= nil then Objective_RemoveUIElements(OBJ_HoldTheRidge, hpid_pos_B) end
			if hpid_pos_C ~= nil then Objective_RemoveUIElements(OBJ_HoldTheRidge, hpid_pos_C) end
			
			if Rule_Exists(__capturePoints_Manager) then Rule_Remove(__capturePoints_Manager) end
			
			if Objective_IsStarted(OBJ_RetakeRidgePoint) then Objective_Complete(OBJ_RetakeRidgePoint, false) end
			
			Player_SetAbilityAvailability(player2, BP_GetAbilityBlueprint("panzer_grenadier_bundled_campaign"), ITEM_UNLOCKED)
			Rule_RemoveIfExist(__reduceGrenadierRange)
			Rule_RemoveIfExist(OBJ_HTR_PreventSpawnCamp)
		end,
		
		OnFail = function()
			if g_missionFailed == false then
				g_missionFailed = true
				Rule_AddDelayedInterval(Mission_Fail, 1.5, 1)			
			end		
		end,
		
		IsComplete = function()
			return false
		end, -- LOCDB [11008184] 'Defend the Ridge'
		
		Intel_Start = nil,				-- Event will play when obj starts but before any UI appears
		Intel_Complete = nil,			-- Event will play when obj completes but before UI is cleared
		Intel_Fail = EVENTS.MISSION_LOST_RIDGE,				-- Event will play when obj fails but before UI is cleared
		Title = 11035336,-- LOCDB [11035336] 'Defend all three territories on the ridge'
		Description = 11008185,			-- LOCDB [11008185] 'The Germans are pressing hard towards Moscow. Defend the three points along the ridge and do not let them encircle you!'
		TitleEnd = 11008186,				-- LOCDB [11008186] 'Ridge Held'
		TitleFail = 11008187,			-- LOCDB [11008187] 'Ridge Lost'
		Type = OT_Primary,				-- Objective Type (OT_Primary, OT_Secondary)
	}
	
	Objective_Register(OBJ_HoldTheRidge)
	
end

---- HINT: Trench walls provide green cover ----
function Hint_trenchWalls()
	if not SGroup_IsInCover(sg_p_conscriptIntro, ANY) and g_hint_trench == nil then
		hintID_trench = HintPoint_Add(mkr_hint_trenchWalls, true, 11035338, nil, HPAT_CoverGreen, "Icons_tooltips_cover_1") -- LOCDB [11035338] 'Trench walls provide optimal (green) cover'
		Timer_Start(40506, 30)
		g_hint_trench = true
	elseif (SGroup_IsInCover(sg_p_conscriptIntro, ALL) and hintID_trench ~= nil) or SGroup_IsEmpty(sg_p_conscriptIntro) or (Timer_Exists(40506) and Timer_GetElapsed(40506) >= 20) then
		Rule_RemoveMe()
		HintPoint_Remove(hintID_trench)
	end
end

---- HINT: Conscripts can be upgraded with SMGs ----
function Hint_conscriptSMG()
	if Player_GetResource(player1, RT_SovietProgression) >= 50 then
		local player1Squads = Player_GetSquads(player1)
		SGroup_Filter(player1Squads, SBP.SOVIET.BASE_CONSCRIPT_SQUAD, FILTER_KEEP)
		if SGroup_IsEmpty(player1Squads) then
			if g_hint_conscriptSMG then 
				HintPoint_Remove(hint_conscriptSMG)
			end
			Rule_RemoveMe()
		elseif SGroup_HasUpgrade(player1Squads, UPG.SOVIET.PPSH_41_SUB_MACHINE_GUN_UPGRADE, ANY) or SGroup_IsUpgrading(player1Squads, UPG.SOVIET.PPSH_41_SUB_MACHINE_GUN_UPGRADE, ANY) or Rule_Exists(DCP_Timer_StartCheck) then
			HintPoint_Remove(hint_conscriptSMG)
			Rule_RemoveMe()
		elseif g_hint_conscriptSMG == nil then
			if Player_GetResource(player1, RT_Munition) >= 60 then
				local squad = SGroup_GetSpawnedSquadAt(player1Squads, math.ceil(SGroup_Count(player1Squads)/2))
				hint_conscriptSMG = HintPoint_Add(squad, true, 11047599, nil, HPAT_Hint, "Icons_upgrades_icon_upgrade_soviet_conscript_assault_package") -- LOCDB [11047599] 'Frontoviki Conscripts can be upgraded with submachine guns'
			end
			Util_StartIntel(EVENTS.FRONTOVIKI_UNLOCK)
			g_hint_conscriptSMG = true
		end
	end
end

function CapturePoints_Set(tableid, masterObjID, timerObjID)
	
	if Rule_Exists(__capturePoints_Manager) then Rule_Remove(__capturePoints_Manager) end
	
	__tCapturePoints = {}
	
	__tCapturePoints.timer = 2*60
	
	__tCapturePoints.masterID = masterObjID
	__tCapturePoints.timerID = timerObjID
	
	__tCapturePoints.cps = {}
	
	for i = 1, table.getn(tableid) do
		local t = {}
		t.eid = Entity_FromWorldID(Entity_GetGameID(EGroup_GetSpawnedEntityAt(tableid[i], 1)))
		t.playerCapturing = false
		t.enemyCapturing = false
		t.owner = Entity_GetPlayerOwner(t.eid)
		t.egroup = tableid[i]
		
		table.insert(__tCapturePoints.cps, t)
	end
	
	if Rule_Exists(__capturePoints_Manager) == false then Rule_Add(__capturePoints_Manager) end

end

function __capturePoints_Manager()
	
	-- If the enemy captures a point, start a countdown
	-- -- If the player re-takes the point before the countdown ends, loss is avoided
	-- -- If the player is capturing a point when the countdown ends, loss is avoided
	-- -- -- unless they lose the point
	-- If the enemy captures a second point, there is a 10 second grace period
	-- -- If the player is re-taking one of the points, loss is avoided
	
	local t = __tCapturePoints
	
	_t_capturedEIDs = {}
	
	for k, this in pairs(t.cps) do
		if World_OwnsEntity(this.eid) and not Player_HasCapturingSquadNearStrategicPoint(player1, this.eid) then
			table.insert(_t_capturedEIDs, this.eid)
		elseif Player_OwnsEntity(player2, this.eid) and not Player_HasCapturingSquadNearStrategicPoint(player1, this.eid) then
			table.insert(_t_capturedEIDs, this.eid)
		elseif Player_OwnsEntity(player1, this.eid) or Player_HasCapturingSquadNearStrategicPoint(player1, this.eid) then
			local f = function (index, value)
				if value == this.eid then
					table.remove(_t_capturedEIDs, index)
					return true
				end
			end
			table.foreach(_t_capturedEIDs, f)
		end
	end
	
	-- Count how many are in captured
	local numCapped = table.getn(_t_capturedEIDs)
	
	if g_fallbackToHQ then
		if Objective_IsTimerSet(t.timerID) then
			Objective_StopTimer(t.timerID)
			if hint_retake ~= nil then
				HintPoint_Remove(hint_retake)
			end
		end
		if Objective_IsVisible(t.timerID) then
			Objective_Show(t.timerID, false)
		end
	elseif numCapped > 0 and not Objective_IsTimerSet(t.timerID) then
		-- One point is owned by the enemy
		if Objective_IsStarted(t.timerID) == false then
			Objective_Start(t.timerID, false)
		end
		
		if Objective_IsVisible(t.timerID) == false then
			Objective_Show(t.timerID, true)
		end
		
		if Objective_IsTimerSet(t.timerID) == false then
			Objective_StartTimer(t.timerID, COUNT_DOWN, t.timer, 30)
			if #_t_capturedEIDs >= 1 then
				local pos = Entity_GetPosition(_t_capturedEIDs[1])
				pos.z = pos.z - 6
				hint_retake = HintPoint_Add(pos, true, 11008188, nil, HPAT_Critical)
			end
		end
	elseif numCapped == 0 and Objective_IsTimerSet(t.timerID) then
		if Objective_IsStarted(t.timerID) == false then
			Objective_Start(t.timerID, false)
		end
		
		-- Player controls or is capturing all points
		if Objective_IsTimerSet(t.timerID) then
			Objective_StopTimer(t.timerID)
			if hint_retake ~= nil then
				HintPoint_Remove(hint_retake)
			end
		end
		
		if Objective_IsVisible(t.timerID) then
			Objective_Show(t.timerID, false)
		end
	elseif (Objective_IsTimerSet(t.timerID) and Objective_GetTimerSeconds(t.timerID) <= 60) then -- numCapped >= 2 or 
		if Objective_GetTimerSeconds(t.timerID) <= 0 then
			-- Player loses
			Rule_RemoveMe()
			
			if Objective_IsStarted(OBJ_HoldTheVillage) then
				Rule_RemoveIfExist(OBJ_HTV_SpeechEvent_01)
				Rule_RemoveIfExist(OBJ_HTV_SpeechEvent_02)
				g_villageFailed = true
				Objective_Fail(OBJ_HoldTheVillage)
			else
				Objective_Fail(OBJ_HoldTheRidge)
			end
		else
			if Objective_IsStarted(OBJ_HoldTheVillage) and not g_lossTimerVillage then
				g_lossTimerVillage = true
				Util_StartIntel(EVENTS.LOSS_TIMER_02)
			elseif not g_lossTimerRidge and not Objective_IsStarted(OBJ_HoldTheVillage) then
				g_lossTimerRidge = true
				Util_StartIntel(EVENTS.LOSS_TIMER_01)
			end
		end
	end
	
end


-- Re-take Point OBJ
function Initialize_RetakeRidgePoint()

	OBJ_RetakeRidgePoint = {
	
		Parent = OBJ_HoldTheRidge,
		
		SetupUI = function() 
			
		end,
		
		OnStart = function()
			Rule_AddInterval(Obj_HTR_IsPoint3Lost, 1)
		end,
		
		OnComplete = function()
			
		end,
		
		OnFail = function()
			Objective_Fail(OBJ_HoldTheRidge)	
		end,
		
		IsComplete = function()
			return false
		end,
		
		Intel_Start = nil,				-- Event will play when obj starts but before any UI appears
		Intel_Complete = nil,			-- Event will play when obj completes but before UI is cleared
		Intel_Fail = nil,				-- Event will play when obj fails but before UI is cleared
		Title = 11008188,				-- LOCDB [11008188] 'Move a squad to the lost strategic point'
		Description = 11008189,			-- LOCDB [11008189] 'Re-take the lost point before the Germans can encircle you!'
		TitleEnd = nil,				-- LOCDB [11007291] 'Village Held'
		TitleFail = nil,			-- LOCDB [11007292] 'Ridge Lost'
		Type = OT_Primary,				-- Objective Type (OT_Primary, OT_Secondary)
	}
	
	Objective_Register(OBJ_RetakeRidgePoint)
	
end
-----SachaHacks, disable HMG and Panzer Grenadier objectives if the player loses the right-most territory
function Obj_HTR_IsPoint3Lost()
	if Util_GetPlayerOwner(eg_POS_A_Points_03) ~= player1 then
		g_ridgePoint3Lost = true
		Rule_RemoveMe()
	end
end
-----

-- Secondary objective
function Initialize_SecondaryOBJ()

	OBJ_SecondaryOBJ = {
		
		SetupUI = function() 
			
		end,
		
		OnStart = function()
			
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
		Title = 11008190,				-- LOCDB [11008190] 'Re-crew the Maxim HMG'
		Description = 11008191,			-- LOCDB [11008191] 'Re-crew the Maxim HMG'
		TitleEnd = nil,				-- LOCDB [11007291] 'Village Held'
		TitleFail = nil,			-- LOCDB [11007292] 'Ridge Lost'
		Type = OT_Secondary,				-- Objective Type (OT_Primary, OT_Secondary)
	}
	
	Objective_Register(OBJ_SecondaryOBJ)
	
end

-- Secondary objective for HARD difficulty -- Enemy mortars attack on the ridge
function Initialize_RidgeMortars()

	OBJ_RidgeMortars = {
		
		SetupUI = function()
			if SGroup_Exists("sg_e_ridgeMortar") and not SGroup_IsEmpty(sg_e_ridgeMortar) then
				Objective_AddUIElements(OBJ_RidgeMortars, SGroup_GetRandomSpawnedSquad(sg_e_ridgeMortar), true)
			end
		end,
		
		OnStart = function()
			if SGroup_Exists("sg_e_ridgeMortar") and not SGroup_IsEmpty(sg_e_ridgeMortar) then
				threatArrowID_mortars = ThreatArrow_CreateGroup(sg_e_ridgeMortar)
			end
		end,
		
		OnComplete = function()
			
		end,
		
		OnFail = function()
					
		end,
		
		IsComplete = function()
			return false
		end,
		
		Intel_Start = EVENTS.GermanMortars,			
		Intel_Complete = nil,			-- Event will play when obj completes but before UI is cleared
		Intel_Fail = nil,				-- Event will play when obj fails but before UI is cleared
		Title = 11036751,-- LOCDB [11036751] 'Eliminate enemy mortar teams'
		Description = 11036751,			-- 
		TitleEnd = nil,				-- 
		TitleFail = nil,			-- 
		Type = OT_Secondary,				-- Objective Type (OT_Primary, OT_Secondary)
	}
	
	Objective_Register(OBJ_RidgeMortars)
	
end

-- Collect Maxim: Player should re-crew the Maxim HMG
function OBJ_HTR_CollectMaxim()
	
	eg_maxim = EGroup_CreateIfNotFound("eg_maxim")
	
	World_GetNeutralEntitiesNearMarker(eg_maxim, mkr_a_RDG_HMG)
	
	MAXIM_EBP = BP_GetEntityBlueprint("ebps/props/soviet/m1910_maxim_heavy_machine_gun")
	
	EGroup_Filter(eg_maxim, MAXIM_EBP, FILTER_KEEP)

end

function OBJ_HTR_PreventSpawnCamp()
	local player1Squads = Player_GetSquads(player1)
	if Prox_AreSquadMembersNearMarker(player1Squads, mkr_RDG_midEdge, ANY, 12) then
		Cmd_Ability(player2, ABILITY.GLOBAL.SP_SINGLE_SHOT_MORTAR, Util_GetRandomPosition(mkr_RDG_midEdge, 6))
	end
	if Prox_AreSquadMembersNearMarker(player1Squads, mkr_RDG_leftEdge, ANY, 12) then
		Cmd_Ability(player2, ABILITY.GLOBAL.SP_SINGLE_SHOT_MORTAR, Util_GetRandomPosition(mkr_RDG_leftEdge, 6))
	end
	if Prox_AreSquadMembersNearMarker(player1Squads, mkr_RDG_rightEdge, ANY, 12) then
		Cmd_Ability(player2, ABILITY.GLOBAL.SP_SINGLE_SHOT_MORTAR, Util_GetRandomPosition(mkr_RDG_rightEdge, 6))
	end
end

----------------
-- RIDGE ATTACK: Enemy attacks in the northern part of the map, for Objective 1
----------
-- Fire off the ambient attacks; these guys do less damage and are mostly Ostruppen
function Ambient_Attacks_Init()
	
	g_tar = "RIDGE"
	
	__t_ambient = {}
	__t_ambient.tar = "RIDGE"
	__t_ambient.active = true
	__t_ambient.phase = 1
	
	__t_ambient.lanes = {}
	------------------------------
	-- LEFT LANE
	__t_ambient.lanes[1] = {}
	__t_ambient.lanes[1].active = true
	__t_ambient.lanes[1].id = "left"
	__t_ambient.lanes[1].sgroups = {SGroup_CreateIfNotFound("sg_e_leftAmb")}
	__t_ambient.lanes[1].encID = encID_leftAmb
	__t_ambient.lanes[1].spawn = mkr_e_RDG_leftSpawn_01
	__t_ambient.lanes[1].units = {}
	
	__t_ambient.lanes[1].retreatPoint = mkr_e_retreat_01
	
	__t_ambient.lanes[1].tmrID = "tmr_ambient_left"
	
	-- Ridge
	__t_ambient.lanes[1].RDGDynSpawn = mkr_e_RDG_leftDest
	__t_ambient.lanes[1].RDGTar = mkr_e_RDG_leftDest
	
	-- Village
	__t_ambient.lanes[1].VILDynSpawn = mkr_e_VIL_leftTar_01
	__t_ambient.lanes[1].VILTar = mkr_e_VIL_leftTar_01
	------------------------------
	-- MID LANE
	__t_ambient.lanes[2] = {}
	__t_ambient.lanes[2].active = true
	__t_ambient.lanes[2].id = "mid"
	__t_ambient.lanes[2].sgroups = {SGroup_CreateIfNotFound("sg_e_midAmb")}
	__t_ambient.lanes[2].encID = encID_midAmb
	__t_ambient.lanes[2].spawn = mkr_e_RDG_midSpawn_01
	__t_ambient.lanes[2].units = {}
	
	__t_ambient.lanes[2].retreatPoint = mkr_e_retreat_02
	
	__t_ambient.lanes[2].tmrID = "tmr_ambient_mid"
	
	-- Ridge
	__t_ambient.lanes[2].RDGDynSpawn = mkr_e_RDG_midDest
	__t_ambient.lanes[2].RDGTar = mkr_e_RDG_midDest
	
	-- Village
	__t_ambient.lanes[2].VILDynSpawn = mkr_e_VIL_midTar_01
	__t_ambient.lanes[2].VILTar = mkr_e_VIL_midTar_01
	------------------------------
	-- RIGHT LANE
	__t_ambient.lanes[3] = {}
	__t_ambient.lanes[3].active = true
	__t_ambient.lanes[3].id = "right"
	__t_ambient.lanes[3].sgroups = {SGroup_CreateIfNotFound("sg_e_rightAmb")}
	__t_ambient.lanes[3].encID = encID_rightAmb
	__t_ambient.lanes[3].spawn = mkr_e_RDG_rightSpawn_01
	__t_ambient.lanes[3].units = {}
	
	__t_ambient.lanes[3].retreatPoint = mkr_e_retreat_03
	
	__t_ambient.lanes[3].tmrID = "tmr_ambient_right"
	
	-- Ridge
	__t_ambient.lanes[3].RDGDynSpawn = mkr_e_RDG_rightDest
	__t_ambient.lanes[3].RDGTar = mkr_e_RDG_rightDest
	
	-- Village
	__t_ambient.lanes[3].VILDynSpawn = mkr_e_VIL_rightTar_01
	__t_ambient.lanes[3].VILTar = mkr_e_VIL_rightTar_01
	
	if Rule_Exists(__ambient_Attacks_Monitor) == false then Rule_AddInterval(__ambient_Attacks_Monitor, 1) end
	

end

function __ambient_Attacks_Monitor()

	local _selectPackage = function()
		local package = nil
		
		local t = {}
		
		if __t_ambient.phase == 1 then
			package = World_GetRand(1, 2)
			if package == 1 then
				t = {
					{
						name = "LeftAmbient",
						sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
						load = 4,
					},
					{
						name = "LeftAmbient",
						sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
						load = 4,
					},
				}
			elseif package == 2 then
				t = {
					{
						name = "LeftAmbient",
						sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
					},
				}
			end
		elseif __t_ambient.phase == 2 then
			package = World_GetRand(1, 2)
			if package == 1 then
				t = {
					{
						name = "LeftAmbient",
						sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
						load = 5,
					},
					{
						name = "LeftAmbient",
						sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
						load = 5,
					},
				}
			elseif package == 2 then
				t = {
					{
						name = "LeftAmbient",
						sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
					},
					{
						name = "LeftAmbient",
						sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
						load = 5,
					},
				}
			end
		elseif __t_ambient.phase == 3 then
			package = World_GetRand(1, 3)
			if package == 1 then
				t = {
					{
						name = "LeftAmbient",
						sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
						load = 5,
					},
					{
						name = "LeftAmbient",
						sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
						load = 5,
					},
				}
			elseif package == 2 then
				t = {
					{
						name = "LeftAmbient",
						sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
					},
					{
						name = "LeftAmbient",
						sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
						load = 5,
					},
				}
			elseif package == 3 then
				t = {
					{
						name = "LeftAmbient",
						sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
					},
				}
			end
		end
		---- Difficulty Variation: HARD ----
		-- Add an extra squad to each ambient attack wave
		if g_hardDiff then
			local unit = t[#t]
			table.insert(t, unit)
		end
		return t
	end
	
	for k, this in pairs(__t_ambient.lanes) do
		if SGroup_IsEmpty(this.sgroups[1]) and __t_ambient.active == true and this.active == true then
			print("RUNNING")
			if Timer_Exists(this.tmrID) and Timer_GetRemaining(this.tmr) <= 0 then
				print("SPAWN")
				Timer_End(this.tmrID)
				-- Determine the package
				local unitPackage = _selectPackage()
				
				-- Are we on village or ridge?
				local dynSpawn = nil
				local tar = nil
				
				if __t_ambient.tar == "RIDGE" then
					dynSpawn = this.RDGDynSpawn
					tar = this.RDGTar
				elseif __t_ambient.tar == "VILLAGE" then
					dynSpawn = this.VILDynSpawn
					tar = this.VILTar
				end
				
				-- Create the encounter table
				local encData = {
					name = this.id,
					player = player2,
					dynamicSpawnTarget = dynSpawn,
					sgroups = this.sgroups,
					spawn = this.spawn,
					units = unitPackage,
				}
				this.encID = Encounter:Create(encData)
				SGroup_AddGroup(sg_e_ambientOstruppen, this.sgroups[1])
				
				local attackData = {
					name = "Attack",
					target = tar,
					useSkirmishAI = g_useSkirmishAI,
					
					attackMove = true,
					safeMoveWeight = 0,
					fallbackParams = {
						thresholds = {0.26},
						thresholdType = Threshold_PercentageEntitiesRemaining,
						markers = {this.spawn},
						retreat = true,
					},					
				}
				this.encID:SetGoal(attackData)
				
				-- Once they're spawned, we're going to weaken these guys
				Modifier_RemoveAllFromSGroup(this.sgroups[1])
				Modify_WeaponRange(this.sgroups[1], "hardpoint_01", 0.75)
				
				if g_flamePioCount < 3 then
					_addFlamePioneers(this.spawn, tar)
				end

			elseif Timer_Exists(this.tmrID) == false then
				Timer_Start(this.tmrID, World_GetRand(6, 9))
			end
		end
	end

end

_addFlamePioneers = function (spawnPosition, targetPosition)
	-- Add flame-pioneers to the attacking force on the ridge
	local targetMarkers = {mkr_RDG_leftTarget, mkr_RDG_midTarget, mkr_RDG_rightTarget}
	local spawnMarkers = {mkr_e_RDG_leftSpawn_01, mkr_e_RDG_midSpawn_01, mkr_e_RDG_rightSpawn_01}
	
	if not Objective_IsComplete(OBJ_HoldTheRidge) and g_recrewMaximStarted then
		if SGroup_IsEmpty(sg_pioneers_flame) then 
			if not Event_Exists(eventID_germanFlamer) then
				local encData = {
					name = "FlamePioneers",
					player = player2,
					spawn = spawnMarkers[g_flamePioCount + 1], 
					sgroups = {sg_pioneers_flame},
					units = {
						{
							sbp = SBP.GERMAN.PIONEER_SQUAD,
						},
					},
				}
				SGroup_Clear(sg_pioneers_flame)
				table.insert(g_enc_flamePioneers, Encounter:Create(encData))
				local goalData = {
					name = "Attack",
					target = targetMarkers[g_flamePioCount + 1], 
					leashRange = 25,
					range = 45,
					attackMove = true,
					safeMoveWeight = 0,
					maxIdleTime = 15,
				    tacticControlsList = {
					  {
						tacticType = TACTIC_RushAtTarget,
						priority = 25,
					  },
				    },
				}
				g_enc_flamePioneers[#g_enc_flamePioneers]:SetGoal(goalData)
				
				Modify_WeaponRange(sg_pioneers_flame, "hardpoint_01", 0.667)
				SGroup_AddSlotItemToDropOnDeath(sg_pioneers_flame, BP_GetSlotItemBlueprint("pioneer_flamethrower"), 1, true)
				Squad_GiveSlotItem(SGroup_GetRandomSpawnedSquad(sg_pioneers_flame), BP_GetSlotItemBlueprint("pioneer_flamethrower"))
				eventID_germanFlamer = Event_GroupIsDead(onDeath_flamerGerman, {pos = Util_GetPosition(goalData.target)}, sg_pioneers_flame)
				g_flamePioCount = g_flamePioCount + 1
			end
		end
	end
end

function Ambient_Attacks_RetreatAndHold(group)
	
	-- if group is set, do it only for that lane; otherwise apply to all
	if group == nil then
		
		-- First, halt the spawning
		__t_ambient.active = false
		
		-- Retreat all current squads

		for k, this in pairs(__t_ambient.lanes) do
			if SGroup_IsEmpty(this.sgroups[1]) == false then
				local retreatPoint = World_GetClosest(this.sgroups[1], {mkr_e_retreat_01, mkr_e_retreat_02, mkr_e_retreat_03})
				
				Cmd_Retreat(this.sgroups[1], this.retreatPoint, this.retreatPoint)
			end
		end
	else
		-- find the lane
		for k, this in pairs(__t_ambient.lanes) do
			if this.sgroups[1] == SGroup_FromName(group) then
				-- Found the lane; disable it
				this.active = false
				
				-- retreat the squads
				if SGroup_IsEmpty(this.sgroups[1]) == false then
					local retreatPoint = World_GetClosest(this.sgroups[1], {mkr_e_retreat_01, mkr_e_retreat_02, mkr_e_retreat_03})
					
					Cmd_Retreat(this.sgroups[1], this.retreatPoint, this.retreatPoint)
				end
			end
		end
	end

end

function Ambient_Attacks_RestartLane(group)
	if group == nil then
		for k, this in pairs(__t_ambient.lanes) do
			this.active = true
		end
	else
		if __t_ambient.active == false then __t_ambient.active = true end
		for k, this in pairs(__t_ambient.lanes) do
			if this.sgroups[1] == SGroup_FromName(group) then
				this.active = true
			end
		end
	end

end

function EncUpdate_HTR_Capture(enc)
	local goalData = enc:GetGoalData()
	if goalData.target == mkr_RDG_leftTarget then
		goalData.target = mkr_e_RDG_leftDest
	elseif goalData.target == mkr_RDG_midTarget then
		goalData.target = mkr_e_RDG_midDest
	elseif goalData.target == mkr_RDG_rightTarget then
		goalData.target = mkr_e_RDG_rightDest
	end
	enc:SetGoal(goalData)
end

--**Wave1**--
function OBJ_HTR_Wave1()
	Ambient_Attacks_Init()
	Ambient_Attacks_RetreatAndHold("sg_e_leftAmb")
	Ambient_Attacks_RetreatAndHold("sg_e_midAmb")
	Ambient_Attacks_RetreatAndHold("sg_e_rightAmb")
	
	Rule_AddInterval(__countPlayerSlotItems, 5)
	
	-- First, determine which lanes are still open and fire off spawn functions
	if g_leftPointOwner == player1 then
		-- Spawn Main force
		local encData = {
			name = "Wave1_Left",
			player = player2,
			dynamicSpawnTarget = mkr_e_RDG_leftDest,
			spawn = mkr_e_RDG_leftSpawn_01,
			sgroups = {SGroup_CreateIfNotFound("sg_e_RDG_wave1"), SGroup_CreateIfNotFound("sg_e_RDG_wave1_left")},
			units = {
				{
					name = "Wave1_Left_A",
					sbp = SBP.GERMAN.GRENADIER_SQUAD,
					abilityBlacklist = {ABILITY.GERMAN.GRENADIER_RIFLE_GRENADE_ABILITY},
				},
				{
					name = "Wave1_Left_B",
					sbp = SBP.GERMAN.GRENADIER_SQUAD,
				},
				{
					name = "Wave1_Left_B",
					sbp = SBP.GERMAN.GRENADIER_SQUAD,
					abilityBlacklist = {ABILITY.GERMAN.GRENADIER_RIFLE_GRENADE_ABILITY},
				},
			},
		}
		---- Difficulty Variation: HARD ----
		-- Add an extra squad to each attack
		if g_hardDiff then
			local unit = encData.units[1]
			table.insert(encData.units, unit)
		end
		encID_wave1Left = Encounter:Create(encData)
		
		local goalData = {
			name = "Attack",
			target = mkr_RDG_leftTarget,
			tacticControlsList = g_ampCoverTactic,
			useSkirmishAI = g_useSkirmishAI,
			movePathLengthFactor = 1.5,
			leashRange = 20,
			range = 45,
			attackMove = false,
			safeMoveWeight = 0,
			maxIdleTime = 15,
			onSuccess = EncUpdate_HTR_Capture,
		}
		encID_wave1Left:SetGoal(goalData)
		
		-- Spawn Any Delayed
		Rule_AddOneShot(OBJ_HTR_Wave1_Left_Delay, 13)
	end
	
	Timer_Start(tmr_RDG_wave2, g_RDG_wave2)
	-- Fire off any remaining functions (monitor)
	Rule_AddInterval(OBJ_HTR_Wave1_Finished, 1)
	
	Rule_AddDelayedInterval(__reduceGrenadierRange, 1, 10)
	
end

function HTR_Wave1_Speech()
	if Player_CanSeeSGroup(player1, SGroup_FromName("sg_e_RDG_wave1_left"), ANY) then
		Sound_PlayOnSquad("speech/sp/mission/m03/11035351", SGroup_FromName("sg_e_RDG_wave1_left"))
		if not g_easyDiff then
			Rule_AddOneShot(HTR_Speech_RifleGrenade, 6)
		end
		Rule_RemoveMe()
	end
end

function HTR_Speech_RifleGrenade()
	Util_StartIntel(EVENTS.RIFLE_GRENADE)
end

function HTR_FlamePio_Callout()
	if Player_CanSeeSGroup(player1, sg_pioneers_flame, ANY) then
		Util_StartIntel(EVENTS.FLAME_PIONEER_SPOTTED)
		Rule_RemoveMe()
	end
end

function OBJ_HTR_Wave1_Left_Delay()
	
	Rule_AddInterval(HTR_FlamePio_Callout, 1)

	-- First, determine which lanes are still open and fire off spawn functions
	if g_leftPointOwner == player1 then
		-- Setup Unit Table
		local t01 = {
			name = "Wave1_Left_A_Flankers",
			sbp = SBP.GERMAN.GRENADIER_SQUAD,
			dynamicSpawnTarget = mkr_e_RDG_leftDest,
			spawn = mkr_e_RDG_leftForestSpawn_01,
			sgroups = {SGroup_CreateIfNotFound("sg_e_RDG_wave1"), SGroup_CreateIfNotFound("sg_e_RDG_wave1_left")},
		}
		if encID_wave1Left:IsAlive() then
			encID_wave1Left:AddUnit(t01)
		end
		
		-- Clear Goal
		encID_wave1Left:ClearGoal()
		
		-- Set new Goal
		local attackData = {
			name = "Attack",
			leashRange = 23,
			range = 45,
			tacticControlsList = g_ampCoverTactic,
			target = mkr_RDG_leftTarget,
			maxIdleTime = 15,
			attackMove = false,
			safeMoveWeight = 0,

			fallback = true,
			fallbackParams = {
				thresholds = {0.6},
				thresholdType = Threshold_PercentageEntitiesRemaining,
				markers = {mkr_e_retreat_01},
				retreat = true,
				retreatDespawn = true,
			},
			onSuccess = EncUpdate_HTR_Capture,
		}
		encID_wave1Left:SetGoal(attackData)

	end

end

function OBJ_HTR_Wave1_Finished()

	if (Player_OwnsEGroup(player1, eg_POS_A_Points_01) == false) or ((SGroup_IsEmpty(SGroup_FromName("sg_e_RDG_wave1_left")) or SGroup_IsRetreating(SGroup_FromName("sg_e_RDG_wave1_left"), ALL)))
	  or Timer_GetRemaining(tmr_RDG_wave2) <= 0 then
		Rule_RemoveMe()

		Rule_AddOneShot(OBJ_HTR_Wave1A, 5)
		
		-- DEV
		g_dev_rdg_wave2 = Timer_GetRemaining(tmr_RDG_wave2)
	end

end

--**Wave1A**--
function OBJ_HTR_Wave1A()
	
	if g_rightPointOwner == player1 then
		-- Spawn Main force
		local encData = {
			name = "Wave2_Right",
			player = player2,
			dynamicSpawnTarget = mkr_e_RDG_rightDest,
			spawn = mkr_e_RDG_rightSpawn_01,
			sgroups = {SGroup_CreateIfNotFound("sg_e_RDG_wave1A"), SGroup_CreateIfNotFound("sg_e_RDG_wave1A_right")},
			units = {
				{
					name = "Wave1_Mid_A",
					sbp = SBP.GERMAN.GRENADIER_SQUAD,
				},
				{
					name = "Wave1_Mid_A",
					sbp = SBP.GERMAN.GRENADIER_SQUAD,
					abilityBlacklist = {ABILITY.GERMAN.GRENADIER_RIFLE_GRENADE_ABILITY},
				},
			},
		}
		---- Difficulty Variation: HARD ----
		if g_hardDiff then
			local unit = encData.units[1]
			table.insert(encData.units, unit)
		end
		encID_wave2Right = Encounter:Create(encData)
		
		local goalData = {
			name = "Attack",
			movePathLengthFactor = 1.5,
			coordinatedMoveRadius = -1,
			coordinatedSetup = false,
			leashRange = 20,
			range = 40,
			target = mkr_RDG_rightTarget,
			useSkirmishAI = g_useSkirmishAI,
			maxIdleTime = 15,
			attackMove = false,
			safeMoveWeight = 0,
			onSuccess = EncUpdate_HTR_Capture,
		}
		encID_wave2Right:SetGoal(goalData)

		-- Spawn Any Delayed
		Rule_AddOneShot(OBJ_HTR_Wave1A_Right_Delay, 6)
	end
	
	Timer_Start(tmr_RDG_wave2A, g_RDG_wave2A)

end

function OBJ_HTR_Wave1A_Right_Delay()
	
	Util_StartIntel(EVENTS.RDG_RIGHT_INCOMING_01)
	Ambient_Attacks_RestartLane("sg_e_leftAmb")
	
	-- First, determine which lanes are still open and fire off spawn functions
	if g_rightPointOwner == player1 then
		local t01 = {
			name = "RDG_W2_M1-1",
			sbp = SBP.GERMAN.GRENADIER_SQUAD,
			dynamicSpawnTarget = mkr_e_RDG_rightDest,
			spawn = mkr_e_RDG_rightForestSpawn_01,
			sgroups = {SGroup_CreateIfNotFound("sg_e_RDG_wave1A"), SGroup_CreateIfNotFound("sg_e_RDG_wave1A_right")},
		}
		if encID_wave2Right:IsAlive() then	
			encID_wave2Right:AddUnit(t01)
			gd1 = encID_wave2Right:GetGoalData()
		end
		
		local t01 = {
			name = "RDG_W2_M1-1",
			sbp = SBP.GERMAN.GRENADIER_SQUAD,
			abilityBlacklist = {ABILITY.GERMAN.GRENADIER_RIFLE_GRENADE_ABILITY},
			dynamicSpawnTarget = mkr_e_RDG_rightDest,
			spawn = mkr_e_RDG_rightForestSpawn_02,
			sgroups = {SGroup_CreateIfNotFound("sg_e_RDG_wave1A"), SGroup_CreateIfNotFound("sg_e_RDG_wave1A_right")},
		}
		---- Difficulty Variation: HARD ----
		-- Add an extra enemy squad
		if g_hardDiff then
			encID_wave2Right:AddUnit(t01)
		end	
		
		encID_wave2Right:ClearGoal()
		
		local attackData = {
			name = "Attack",
			coordinatedMoveRadius = -1,
			coordinatedSetup = false,
			leashRange = 20,
			range = 40,
			target = mkr_RDG_rightTarget,
			useSkirmishAI = g_useSkirmishAI,
			maxIdleTime = 15,
			attackMove = false,
			safeMoveWeight = 0,

			fallback = true,
			fallbackParams = {
				thresholds = {0.45},
				thresholdType = Threshold_PercentageEntitiesRemaining,
				markers = {mkr_e_retreat_03},
				retreat = true,
				retreatDespawn = true,
			},
			onSuccess = EncUpdate_HTR_Capture,
		}
		encID_wave2Right:SetGoal(attackData)

		Rule_AddOneShot(OBJ_HTR_Wave1A_KillMaxim, 14)
	end
	
	Rule_AddInterval(OBJ_HTR_Wave1A_Finished, 1)

end

function OBJ_HTR_Wave1A_Finished()
	
	if (Player_OwnsEGroup(player1, eg_POS_A_Points_03) == false) or ((SGroup_IsEmpty(SGroup_FromName("sg_e_RDG_wave1A_right")) or SGroup_IsRetreating(SGroup_FromName("sg_e_RDG_wave1A_right"), ALL)))
	  or Timer_GetRemaining(tmr_RDG_wave2A) <= 0 then
		Rule_RemoveMe()
		
		Rule_AddOneShot(OBJ_HTR_Wave2, 8)
		
		Ambient_Attacks_RestartLane("sg_e_rightAmb")
		
		-- DEV
		g_dev_rdg_wave3 = Timer_GetRemaining(tmr_RDG_wave3)
	end

end

-- Kill Maxim; kill the soldier manning the gun so the player has to re-crew it
function OBJ_HTR_Wave1A_KillMaxim()

	if not SGroup_IsEmpty(sg_a_hmg) then
		Entity_Kill(Squad_EntityAt(SGroup_GetSpawnedSquadAt(sg_a_hmg, 1), 1))
	end
	
	Rule_AddOneShot(OBJ_HTR_CollectMaxim, 1.5)
	
	Rule_AddOneShot(OBJ_HTR_RecrewMaxim, 3)

end

function OBJ_HTR_RecrewMaxim()

	Util_StartIntel(EVENTS.MAXIM_DOWN)
	
	Objective_Start(OBJ_SecondaryOBJ, false)
	
	hpid_maxim = Objective_AddUIElements(OBJ_SecondaryOBJ, eg_maxim, true, 11049996, true)
	Objective_SetAlwaysShowDetails(OBJ_SecondaryOBJ, true, true, true)
	
	Rule_AddInterval(OBJ_HTR_MaximRecrewed, 1)

	g_recrewMaximStarted = true
	
end

function OBJ_HTR_MaximRecrewed()

	if EGroup_IsEmpty(eg_maxim) or (Util_GetPlayerOwner(eg_maxim) == player1) then
		Rule_RemoveMe()
		
		Objective_RemoveUIElements(OBJ_SecondaryOBJ, hpid_maxim)
		Objective_Show(OBJ_SecondaryOBJ, false)
		sg_p_maxim = SGroup_CreateIfNotFound("sg_p_maxim")
		Player_GetAllSquadsNearMarker(player1, sg_p_maxim, mkr_a_RDG_HMG, 30)
		SGroup_Filter(sg_p_maxim, SBP.SOVIET.M1910_MAXIM_HEAVY_MACHINE_GUN_SQUAD, FILTER_KEEP)
		Rule_AddDelayedInterval(OBJ_HTR_MergeIntoMaxim, 5, 1)
	end

end

--- HINT: Merge conscripts into Maxim squad to reinforce
function OBJ_HTR_MergeIntoMaxim()
	if SGroup_IsEmpty(sg_p_maxim) then
		BeginnerHint_AddOpportunity(sg_mergehints, HINT_MERGE, true)		-- now special case is done, add in the generic merge hints
		Rule_RemoveMe()
		if hint_mergeIntoMaxim ~= nil then
			HintPoint_Remove(hint_mergeIntoMaxim)
		end
	elseif (SGroup_TotalMembersCount(sg_p_maxim) < 5) and (hint_mergeIntoMaxim == nil) then
		hint_mergeIntoMaxim = HintPoint_Add(sg_p_maxim, true, 11045296, 1.5, HPAT_Hint, "Icons_abilities_ability_soviet_merge")-- LOCDB [11045296] 'Merge in conscripts to reinforce the Maxim crew'
	elseif ((SGroup_TotalMembersCount(sg_p_maxim) > 6) or (SGroup_TotalMembersCount(sg_p_maxim) == 1)) and (hint_mergeIntoMaxim ~= nil) then
		HintPoint_Remove(hint_mergeIntoMaxim)
		BeginnerHint_AddOpportunity(sg_mergehints, HINT_MERGE, true)		-- now special case is done, add in the generic merge hints
		Rule_RemoveMe()
	elseif Timer_Exists(tmr_pg_suppress)  then
		HintPoint_Remove(hint_mergeIntoMaxim)
		Rule_RemoveMe()
	end
end
		

--**Wave2**--
function OBJ_HTR_Wave2()

	Ambient_Attacks_RetreatAndHold("sg_e_midAmb")
	Ambient_Attacks_RetreatAndHold("sg_e_rightAmb")
	
	-- Difficulty Variation -- Hard
	-- Bonus objective to kill enemy mortar teams
	if g_hardDiff then
		sg_e_ridgeMortar = SGroup_CreateIfNotFound("sg_e_ridgeMortar")
		Util_CreateSquads(player2, sg_e_ridgeMortar, SBP.GERMAN.MORTAR_TEAM_81MM, mkr_RDG_leftMortar)
		FOW_RevealSGroupOnly(sg_e_ridgeMortar, -1)
		Objective_Start(OBJ_RidgeMortars)
		Rule_AddSGroupEvent(__countMortarsKilled, sg_e_ridgeMortar, GE_SquadKilled)
	end	
	
	-- First, determine which lanes are still open and fire off spawn functions
	if g_midPointOwner == player1 then
	
		local event = Table_GetRandomItem(t_events.RDG_Mid_Incoming)
		
		Util_StartIntel(event)
		
		-- Spawn Main force
		local encData = {
			name = "Wave2_Mid",
			player = player2,
			dynamicSpawnTarget = mkr_e_RDG_midDest,
			spawn = mkr_e_RDG_midSpawn_01,
			sgroups = {SGroup_CreateIfNotFound("sg_e_RDG_wave2"), SGroup_CreateIfNotFound("sg_e_RDG_wave2_mid")},
			units = {
				{
					name = "Wave1_Mid_A",
					sbp = SBP.GERMAN.GRENADIER_SQUAD,
					abilityBlacklist = {ABILITY.GERMAN.GRENADIER_RIFLE_GRENADE_ABILITY},
				},
				{
					name = "Wave1_Mid_A",
					sbp = SBP.GERMAN.GRENADIER_SQUAD,
				},
			},
		}
		---- Difficulty Variation: HARD ----
		-- Add an extra enemy squad
		if g_hardDiff then
			local unit = encData.units[1]
			table.insert(encData.units, unit)
		end
		encID_wave2Mid = Encounter:Create(encData)
		
		local goalData = {
			name = "Attack",
			leashRange = 20,
			range = 40,
			movePathLengthFactor = 1.5,
			coordinatedMoveRadius = -1,
			coordinatedSetup = false,
			target = mkr_RDG_midTarget,
			useSkirmishAI = g_useSkirmishAI,
			maxIdleTime = 15,
			attackMove = false,
			safeMoveWeight = 0,
			onSuccess = EncUpdate_HTR_Capture,
		}
		encID_wave2Mid:SetGoal(goalData)
		
		-- Spawn Any Delayed
		Rule_AddOneShot(OBJ_HTR_Wave2_Mid_Delay, 3)
	end
	
	if g_rightPointOwner == player1 then
		-- Spawn Main force
		local encData = {
			name = "Wave2_Right",
			player = player2,
			dynamicSpawnTarget = mkr_e_RDG_rightDest,
			spawn = mkr_e_RDG_rightSpawn_01,
			sgroups = {SGroup_CreateIfNotFound("sg_e_RDG_wave2"), SGroup_CreateIfNotFound("sg_e_RDG_wave2_right")},
			units = {
				{
					name = "Wave1_Mid_A",
					sbp = SBP.GERMAN.GRENADIER_SQUAD,
				},
				{
					name = "Wave1_Mid_A",
					sbp = SBP.GERMAN.GRENADIER_SQUAD,
					abilityBlacklist = {ABILITY.GERMAN.GRENADIER_RIFLE_GRENADE_ABILITY},
				},
			},
		}
		---- Difficulty Variation: HARD ----
		-- Add an extra enemy squad
		if g_hardDiff then
			local unit = encData.units[1]
			table.insert(encData.units, unit)
		end
		encID_wave2Right = Encounter:Create(encData)
		
		local goalData = {
			name = "Attack",
			leashRange = 20,
			range = 40,
			movePathLengthFactor = 1.5,
			coordinatedMoveRadius = -1,
			coordinatedSetup = false,
			target = mkr_RDG_rightTarget,
			useSkirmishAI = g_useSkirmishAI,
			maxIdleTime = 15,
			attackMove = false,
			safeMoveWeight = 0,
			onSuccess = EncUpdate_HTR_Capture,
		}
		encID_wave2Right:SetGoal(goalData)
		
		-- Spawn Any Delayed
		Rule_AddOneShot(OBJ_HTR_Wave2_Right_Delay, 6)
	end
	
	Rule_AddOneShot(Ambient_Attacks_Init, 5)
	
	Timer_Start(tmr_RDG_wave3, g_RDG_wave3)
	
	-- Fire off any remaining functions (monitor)
	Rule_AddInterval(OBJ_HTR_Wave2_Finished, 1)
	
end

function OBJ_HTR_Wave2_Mid_Delay()

	-- First, determine which lanes are still open and fire off spawn functions
	if g_midPointOwner == player1 then
		local t01 = {
			name = "RDG_W2_M1-1",
			sbp = SBP.GERMAN.GRENADIER_SQUAD,
			dynamicSpawnTarget = mkr_e_RDG_midDest,
			spawn = mkr_e_RDG_leftForestSpawn_01,
			sgroups = {SGroup_CreateIfNotFound("sg_e_RDG_wave2"), SGroup_CreateIfNotFound("sg_e_RDG_wave2_mid")},
		}
		if encID_wave2Mid:IsAlive() then
			encID_wave2Mid:AddUnit(t01)
		end
		
		encID_wave2Mid:ClearGoal()
		
		local attackData = {
			name = "Attack",
			leashRange = 20,
			range = 40,
			coordinatedMoveRadius = -1,
			coordinatedSetup = false,
			target = mkr_e_RDG_midDest, 
			useSkirmishAI = g_useSkirmishAI,
			maxIdleTime = 15,
			attackMove = false,
			safeMoveWeight = 0,
			
			fallback = true,
			fallbackParams = {
				thresholds = {0.45},
				thresholdType = Threshold_PercentageEntitiesRemaining,
				markers = {mkr_e_retreat_02},
				retreat = true,
				retreatDespawn = true,
			},
			onSuccess = EncUpdate_HTR_Capture,
		}
		encID_wave2Mid:SetGoal(attackData)
		SGroup_AddSlotItemToDropOnDeath(encID_wave2Mid.sgroup, SLOT_ITEM.GRENADIER_MG42_LMG, 100, true)
	end

end

function OBJ_HTR_Wave2_Right_Delay()

	-- First, determine which lanes are still open and fire off spawn functions
	if g_rightPointOwner == player1 then
		local t01 = {
			name = "RDG_W2_M1-1",
			sbp = SBP.GERMAN.GRENADIER_SQUAD,
			dynamicSpawnTarget = mkr_e_RDG_rightDest,
			spawn = mkr_e_RDG_rightForestSpawn_01,
			sgroups = {SGroup_CreateIfNotFound("sg_e_RDG_wave2"), SGroup_CreateIfNotFound("sg_e_RDG_wave2_right")},
		}
		
		if encID_wave2Right:IsAlive() then
			encID_wave2Right:AddUnit(t01)
		end
		
		local t01 = {
			name = "RDG_W2_M1-1",
			sbp = SBP.GERMAN.GRENADIER_SQUAD,
			abilityBlacklist = {ABILITY.GERMAN.GRENADIER_RIFLE_GRENADE_ABILITY},
			dynamicSpawnTarget = mkr_e_RDG_rightDest,
			spawn = mkr_e_RDG_rightForestSpawn_02,
			sgroups = {SGroup_CreateIfNotFound("sg_e_RDG_wave2"), SGroup_CreateIfNotFound("sg_e_RDG_wave2_right")},
		}
		
		---- Difficulty Variation: HARD ----
		-- Add an extra enemy squad
		if g_hardDiff then
			encID_wave2Right:AddUnit(t01)
		end	
		
		encID_wave2Right:ClearGoal()
		
		local attackData = {
			name = "Attack",
			leashRange = 20,
			range = 40,
			coordinatedMoveRadius = -1,
			coordinatedSetup = false,
			target = mkr_RDG_rightTarget,
			useSkirmishAI = g_useSkirmishAI,
			maxIdleTime = 15,
			attackMove = false,
			safeMoveWeight = 0,

			fallback = true,
			fallbackParams = {
				thresholds = {0.45},
				thresholdType = Threshold_PercentageEntitiesRemaining,
				markers = {mkr_e_retreat_03},
				retreat = true,
				retreatDespawn = true,
			},
			onSuccess = EncUpdate_HTR_Capture,
		}
		encID_wave2Right:SetGoal(attackData)

		
	end

end

function OBJ_HTR_Wave2_Finished()
	
	if ((Player_OwnsEGroup(player1, eg_POS_A_Points_03) == false) or ((SGroup_IsEmpty(SGroup_FromName("sg_e_RDG_wave2_right")) or SGroup_IsRetreating(SGroup_FromName("sg_e_RDG_wave2_right"), ALL)))
	  and (Player_OwnsEGroup(player1, eg_POS_A_Points_02) == false) or ((SGroup_IsEmpty(SGroup_FromName("sg_e_RDG_wave2_mid")) or SGroup_IsRetreating(SGroup_FromName("sg_e_RDG_wave2_mid"), ALL))))
	  or Timer_GetRemaining(tmr_RDG_wave3) <= 0 then
		Rule_RemoveMe()
		
		Rule_AddOneShot(OBJ_HTR_Wave3, 8)
		
		Ambient_Attacks_RestartLane("sg_e_midAmb")
		Ambient_Attacks_RestartLane("sg_e_rightAmb")
		
		Rule_RemoveIfExist(Hint_trenchWalls)
		if hintID_trench ~= nil then
			HintPoint_Remove(hintID_trench)
		end
		
		-- DEV
		g_dev_rdg_wave3 = Timer_GetRemaining(tmr_RDG_wave3)
	end

end

--**Wave3**--
function OBJ_HTR_Wave3()

	Ambient_Attacks_RetreatAndHold("sg_e_rightAmb")
	
	--SachaHacks
	if g_leftPointOwner == player1 then
		-- Spawn Main force
		local encData = {
			name = "Wave3_Left",
			player = player2,
			dynamicSpawnTarget = mkr_e_RDG_leftDest,
			spawn = mkr_e_RDG_leftSpawn_01,
			sgroups = {SGroup_CreateIfNotFound("sg_e_RDG_wave3"), SGroup_CreateIfNotFound("sg_e_RDG_wave3_left")},
			units = {
				{
					name = "Wave1_Mid_A",
					sbp = SBP.GERMAN.GRENADIER_SQUAD,
				},
				{
					name = "Wave1_Mid_A",
					sbp = SBP.GERMAN.GRENADIER_SQUAD,
					abilityBlacklist = {ABILITY.GERMAN.GRENADIER_RIFLE_GRENADE_ABILITY},
				},
			},
		}
		---- Difficulty Variation: HARD ----
		-- Add an extra enemy squad
		if g_hardDiff then
			local unit = encData.units[1]
			table.insert(encData.units, unit)
		end
		encID_wave3Left = Encounter:Create(encData)
		
		local goalData = {
			name = "Attack",
			leashRange = 20,
			range = 45,
			movePathLengthFactor = 1.5,
			coordinatedMoveRadius = -1,
			coordinatedSetup = false,
			tacticControlsList = g_ampCoverTactic,
			target = mkr_e_RDG_leftDest,
			useSkirmishAI = g_useSkirmishAI,
			maxIdleTime = 15,
			attackMove = false,
			safeMoveWeight = 0,
			onSuccess = EncUpdate_HTR_Capture,
		}
		encID_wave3Left:SetGoal(goalData)
		
		-- Spawn Any Delayed
		Rule_AddOneShot(OBJ_HTR_Wave3_Right_Delay, 7)
	end
	
	if g_midPointOwner == player1 then
		-- Spawn Main force
		local encData = {
			name = "Wave3_Mid",
			player = player2,
			dynamicSpawnTarget = mkr_e_RDG_midDest,
			spawn = mkr_e_RDG_midSpawn_01,
			sgroups = {SGroup_CreateIfNotFound("sg_e_RDG_wave3"), SGroup_CreateIfNotFound("sg_e_RDG_wave3_mid")},
			units = {
				{
					name = "Wave1_Mid_A",
					sbp = SBP.GERMAN.GRENADIER_SQUAD,
					abilityBlacklist = {ABILITY.GERMAN.GRENADIER_RIFLE_GRENADE_ABILITY},
				},
				{
					name = "Wave1_Mid_A",
					sbp = SBP.GERMAN.GRENADIER_SQUAD,
				},
			},
		}
		---- Difficulty Variation: HARD ----
		-- Add an extra enemy squad
		if g_hardDiff then
			local unit = encData.units[1]
			table.insert(encData.units, unit)
		end
		encID_wave3Left = Encounter:Create(encData)
		
		local goalData = {
			name = "Attack",
			leashRange = 20,
			range = 40,
			movePathLengthFactor = 1.5,
			coordinatedMoveRadius = -1,
			coordinatedSetup = false,
			target = mkr_RDG_midTarget,
			useSkirmishAI = g_useSkirmishAI,
			maxIdleTime = 15,
			attackMove = false,
			safeMoveWeight = 0,
		}
		encID_wave3Left:SetGoal(goalData)

	end
	
	Timer_Start(tmr_RDG_wave4, g_RDG_wave4)
	
end

function OBJ_HTR_Wave3_Right_Delay()

	-- First, determine which lanes are still open and fire off spawn functions
	if g_rightPointOwner == player1 then
	
		local encData = {
			name = "Wave3_Right",
			player = player2,
			dynamicSpawnTarget = mkr_e_RDG_rightDest,
			spawn = mkr_e_RDG_rightForestSpawn_01,
			sgroups = {SGroup_CreateIfNotFound("sg_e_RDG_wave3"), SGroup_CreateIfNotFound("sg_e_RDG_wave3_right"), SGroup_CreateIfNotFound("sg_e_RDG_wave3_PG")},
			units = {
				{
					name = "Wave1_Mid_A",
					sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
				},
				
			},
		}
		encID_wave3RightPG = Encounter:Create(encData)
		Timer_Start(202, 60)
		Rule_AddDelayedInterval(OBJ_HTR_Wave3_SendInPG, 2, 1)
	end

end

function OBJ_HTR_Wave3_SendInPG()
	Player_GetAllSquadsNearMarker(player2, SGroup_CreateIfNotFound("sg_e_leftTarget"), mkr_RDG_leftTarget)
	Player_GetAllSquadsNearMarker(player2, SGroup_CreateIfNotFound("sg_e_midTarget"), mkr_RDG_midTarget)
	local noGrenadiers = (not SGroup_ContainsBlueprints(SGroup_FromName("sg_e_leftTarget"), SBP.GERMAN.GRENADIER_SQUAD, ALL) and not SGroup_ContainsBlueprints(SGroup_FromName("sg_e_midTarget"), SBP.GERMAN.GRENADIER_SQUAD, ALL))

	if noGrenadiers or Timer_GetElapsed(202) > 40 then

		encID_wave3RightPG:Disable()

		Cmd_AttackMove(SGroup_FromName("sg_e_RDG_wave3_PG"), mkr_e_RDG_rightDest)
		Cmd_AttackMove(SGroup_FromName("sg_e_RDG_wave3_PG"), mkr_e_RDG_rightDest, true)
		Cmd_AttackMove(SGroup_FromName("sg_e_RDG_wave3_PG"), mkr_e_RDG_rightDest, true)
		
		SGroup_SetInvulnerable(SGroup_FromName("sg_e_RDG_wave3_PG"), 0.75)
		Modify_ReceivedSuppression(SGroup_FromName("sg_e_RDG_wave3_PG"), 3)
		
		Rule_AddInterval(OBJ_HTR_Wave3_PG_Spotted, 1)
		Rule_RemoveMe()
	end
end

function OBJ_HTR_Wave3_PG_Spotted()

	if Player_CanSeeSGroup(player1, SGroup_FromName("sg_e_RDG_wave3_PG"), ANY) then
		Rule_RemoveMe()
		
		local goalData = {
			name = "Attack",
			leashRange = 20,
			tacticCoverPriority = -1,
			movePathLengthFactor = 1.5,
			target = mkr_e_RDG_rightDest,
			useSkirmishAI = true,
			attackMove = true,
			safeMoveWeight = 0,
			tacticCloseGround = true,
		}
		
		encID_wave3RightPG:SetGoal(goalData)
		
		ThreatArrow_CreateGroup(SGroup_FromName("sg_e_RDG_wave3_PG"))
		Rule_AddOneShot(OBJ_HTR_Wave3_PG_Warn, 2)
	end

end

--- Unlock enemy bundled grenades when player has more than X maxims
--- PGs will prefer to throw Bundled Grenades at Maxims
function PG_BundledGrenadeToggle()
	sg_playerHMGs = Player_GetSquads(player1)
	SGroup_Filter(sg_playerHMGs, SBP.SOVIET.M1910_MAXIM_HEAVY_MACHINE_GUN_SQUAD, FILTER_KEEP)
	if SGroup_Count(sg_playerHMGs) > t_difficulty.bundledGrenadeLimit and g_bundledGrenadesUnlocked ~= true then
		Player_SetAbilityAvailability(player2, BP_GetAbilityBlueprint("panzer_grenadier_bundled_campaign"), ITEM_UNLOCKED)
		g_bundledGrenadesUnlocked = true
	elseif SGroup_Count(sg_playerHMGs) <= t_difficulty.bundledGrenadeLimit and g_bundledGrenadesUnlocked == true then
		Player_SetAbilityAvailability(player2, BP_GetAbilityBlueprint("panzer_grenadier_bundled_campaign"), ITEM_LOCKED)
		g_bundledGrenadesUnlocked = false
	end
end	

function OBJ_HTR_Wave3_PG_Warn()
	
	-- Start the suppression Timer
	tmr_pg_suppress = "tmr_pg_suppress"
	tmr_pg_suppressTime = 30
	
	Timer_Start(tmr_pg_suppress, tmr_pg_suppressTime)
	
	Util_StartIntel(EVENTS.PANZER_GRENADER_SEEN)
	if EGroup_IsEmpty(eg_maxim) or (Util_GetPlayerOwner(eg_maxim) == player1)  then
		Objective_UpdateText(OBJ_SecondaryOBJ, 11008193, 11008193, false) -- LOCDB [11008193] 'Suppress the Panzer Grenadiers'
		hpid_pg = Objective_AddUIElements(OBJ_SecondaryOBJ, SGroup_FromName("sg_e_RDG_wave3_PG"), true, 11029988, true) -- LOCDB [11008194] 'Panzer Grenadiers'
	else
		hpid_pg = Objective_AddUIElements(OBJ_SecondaryOBJ, SGroup_FromName("sg_e_RDG_wave3_PG"), false, 11008193, true, nil, nil, HPAT_Hint) -- LOCDB [11008193] 'Suppress the Panzer Grenadiers'
	end
	
	Objective_Show(OBJ_SecondaryOBJ, true)
	
	Rule_AddDelayedInterval(OBJ_HTR_Wave3_UpdateGoal, 10, 1)
	
	Rule_AddDelayedInterval(OBJ_HTR_Wave3_PG_Remind, 12, 12)
	
	Rule_AddInterval(OBJ_HTR_Wave3_UnlockGrenades, 10)

end

function OBJ_HTR_Wave3_PG_Remind()
	
	if Rule_Exists(OBJ_HTR_Wave3_UpdateGoal) then
		Event_Skip()
		
		local event = Table_GetRandomItem(t_events.Suppress_PG)
		
		Util_StartIntel(event)
	else
		Rule_RemoveMe()
	end

end

function OBJ_HTR_Wave3_UnlockGrenades()
	local pinnedOrSuppressed = (SGroup_IsPinned(SGroup_FromName("sg_e_RDG_wave3_PG"), ANY) or SGroup_IsSuppressed(SGroup_FromName("sg_e_RDG_wave3_PG"), ANY))
	if pinnedOrSuppressed or (Timer_GetRemaining(tmr_pg_suppress) <= 0) then
		Rule_RemoveMe()
		
		if Event_IsAnyRunning() then
			Event_Skip()
		end
		
		SGroup_SetInvulnerable(SGroup_FromName("sg_e_RDG_wave3_PG"), false)
		
		if (hpid_pg ~= nil) and pinnedOrSuppressed then 
			Objective_RemoveUIElements(OBJ_SecondaryOBJ, hpid_pg) 
		end

		if Rule_Exists(OBJ_HTR_Wave3_PG_Remind) then Rule_Remove(OBJ_HTR_Wave3_PG_Remind) end
		
		encID_wave3RightPG:ClearGoal()
		
		local goalData = {
			name = "Attack",
			leashRange = 20,
			range = 40,
			target = mkr_RDG_rightTarget,
			useSkirmishAI = g_useSkirmishAI,
			attackMove = false,
			safeMoveWeight = 0,
			fallback = true,
			fallbackParams = {
				thresholds = {0.4},
				thresholdType = Threshold_PercentageEntitiesRemaining,
				markers = {mkr_e_retreat_03},
				retreat = true,
				retreatDespawn = true,
			},
		}
		if not SGroup_IsEmpty(encID_wave3RightPG.sgroup) then
			encID_wave3RightPG:SetGoal(goalData)
		end
		
		Rule_AddInterval(OBJ_HTR_Wave3_Finished, 1)
	elseif not pinnedOrSuppressed and (Timer_GetRemaining(tmr_pg_suppress) <= 15) then
		if not SGroup_IsEmpty(SGroup_FromName("sg_e_RDG_wave3_PG")) then
			Player_SetAbilityAvailability(player2, BP_GetAbilityBlueprint("panzer_grenadier_bundled_campaign"), ITEM_UNLOCKED)
			Cmd_Ability(SGroup_FromName("sg_e_RDG_wave3_PG"), BP_GetAbilityBlueprint("panzer_grenadier_bundled_campaign"), Marker_GetPosition(mkr_p_RDG_conscript_07), nil, true)
		end
	end

end

function OBJ_HTR_Wave3_UpdateGoal()
	local pinnedOrSuppressed = (SGroup_IsPinned(SGroup_FromName("sg_e_RDG_wave3_PG"), ANY) or SGroup_IsSuppressed(SGroup_FromName("sg_e_RDG_wave3_PG"), ANY))
	if pinnedOrSuppressed or SGroup_IsEmpty(SGroup_FromName("sg_e_RDG_wave3_PG")) or SGroup_IsRetreating(SGroup_FromName("sg_e_RDG_wave3_PG"), ALL) 
		or g_ridgePoint3Lost then
		Rule_RemoveMe()
		
		if EGroup_IsEmpty(eg_maxim) or (Util_GetPlayerOwner(eg_maxim) == player1) then
			Objective_RemoveUIElements(OBJ_SecondaryOBJ, hpid_pg)
			Objective_Show(OBJ_SecondaryOBJ, false)
		end
		
		encID_wave3Left:ClearGoal()
		
		local attackData = {
			name = "Attack",
			leashRange = 20,
			range = 45,
			tacticControlsList = g_ampCoverTactic,
			target = mkr_RDG_leftTarget,
			useSkirmishAI = g_useSkirmishAI,
			
			attackMove = false,
			safeMoveWeight = 0,
			tacticCloseGround = true,
			maxIdleTime = 15,
			fallback = true,
			fallbackParams = {
				thresholds = {0.35},
				thresholdType = Threshold_PercentageEntitiesRemaining,
				markers = {mkr_e_retreat_01},
				retreat = true,
				retreatDespawn = true,
			},
			onSuccess = EncUpdate_HTR_Capture,
		}
		if not SGroup_IsEmpty(encID_wave3Left.sgroup) then
			encID_wave3Left:SetGoal(attackData)
		end
		
		if SGroup_Exists("sg_e_RDG_pnzrIII") == false then
			Event_Skip()
			Util_StartIntel(EVENTS.MORE_MAXIMS_ENROUTE)
			Rule_AddOneShot(OBJ_HTR_Maxims_Arrive, 12)
		end
		
	-- Difficulty Variation" -- Hard
	-- Add another German Mortar Team
	if g_hardDiff then
			Util_CreateSquads(player2, sg_e_ridgeMortar, SBP.GERMAN.MORTAR_TEAM_81MM, mkr_RDG_midMortar)
			FOW_RevealSGroupOnly(sg_e_ridgeMortar, -1)
			Objective_AddUIElements(OBJ_RidgeMortars, SGroup_GetSpawnedSquadAt(sg_e_ridgeMortar, SGroup_Count(sg_e_ridgeMortar)), true)
			ThreatArrow_Add(threatArrowID_mortars, SGroup_GetSpawnedSquadAt(sg_e_ridgeMortar, SGroup_Count(sg_e_ridgeMortar)))
			Rule_RemoveSGroupEvent(__countMortarsKilled, sg_e_ridgeMortar)
			Rule_AddSGroupEvent(__countMortarsKilled, sg_e_ridgeMortar, GE_SquadKilled)
		end		
	
	end

end

function OBJ_HTR_Maxims_Arrive()

	-- Deploy Maxims
	sg_p_maxim01 = SGroup_CreateIfNotFound("sg_p_maxim01")
	sg_p_maxim02 = SGroup_CreateIfNotFound("sg_p_maxim02")
	
	Util_CreateSquads(player1, sg_p_maxim01, SBP.SOVIET.M1910_MAXIM_HEAVY_MACHINE_GUN_SQUAD, mkr_a_RDG_truck_spawn)
	Util_CreateSquads(player1, sg_p_maxim02, SBP.SOVIET.M1910_MAXIM_HEAVY_MACHINE_GUN_SQUAD, mkr_a_RDG_truck_spawn)

	Cmd_Move(sg_p_maxim01, mkr_midMaxim, nil, nil, Marker_GetPosition(mkr_RDG_midTarget))
	Cmd_Move(sg_p_maxim02, mkr_leftMaxim, nil, nil, Marker_GetPosition(mkr_RDG_leftTarget))
	
	Rule_AddOneShot(OBJ_HTR_MaximsArrived, 15)

end

function OBJ_HTR_Wave3_Finished()
	
	if Player_OwnsEGroup(player1, eg_POS_A_Points_03) == false or SGroup_IsEmpty(SGroup_FromName("sg_e_RDG_wave3_right") or SGroup_IsRetreating(SGroup_FromName("sg_e_RDG_wave3_right"), ALL))
	  or Timer_GetRemaining(tmr_RDG_wave4) <= 0 then
		Rule_RemoveMe()
		
		Rule_AddOneShot(OBJ_HTR_Wave4, 25)
		
		Ambient_Attacks_RestartLane("sg_e_rightAmb")
		
		-- DEV
		g_dev_rdg_wave4 = Timer_GetRemaining(tmr_RDG_wave4)
	end

end

function OBJ_HTR_MaximsArrived()

	if SGroup_Exists("sg_e_RDG_pnzrIII") == false then
		Util_StartIntel(EVENTS.MORE_MAXIMS_ARRIVE)
	end
		
	EventCue_Create(CUE.MAP, 11008195, 11008195, sg_p_maxim01)	-- LOCDB [11008195] 'HMGs Available'

end

--**Wave4**--
function OBJ_HTR_Wave4()
	Player_SetAbilityAvailability(player2, BP_GetAbilityBlueprint("panzer_grenadier_bundled_campaign"), ITEM_UNLOCKED)
	Ambient_Attacks_RetreatAndHold()
	
	-- Difficulty Variation" -- Hard
	-- Add another German Mortar Team
	if g_hardDiff then
		Util_CreateSquads(player2, sg_e_ridgeMortar, SBP.GERMAN.MORTAR_TEAM_81MM, mkr_RDG_rightMortar)
		FOW_RevealSGroupOnly(sg_e_ridgeMortar, -1)
		Objective_AddUIElements(OBJ_RidgeMortars, SGroup_GetSpawnedSquadAt(sg_e_ridgeMortar, SGroup_Count(sg_e_ridgeMortar)), true)
		ThreatArrow_Add(threatArrowID_mortars, SGroup_GetSpawnedSquadAt(sg_e_ridgeMortar, SGroup_Count(sg_e_ridgeMortar)))
		Rule_RemoveSGroupEvent(__countMortarsKilled, sg_e_ridgeMortar)
		Rule_AddSGroupEvent(__countMortarsKilled, sg_e_ridgeMortar, GE_SquadKilled)
	end
	
	-- First, determine which lanes are still open and fire off spawn functions
	if g_leftPointOwner == player1 then
		-- Spawn Main force
		local encData = {
			name = "Wave3_Left",
			player = player2,
			dynamicSpawnTarget = mkr_e_RDG_leftDest,
			spawn = mkr_e_RDG_leftSpawn_01,
			sgroups = {SGroup_CreateIfNotFound("sg_e_RDG_wave4"), SGroup_CreateIfNotFound("sg_e_RDG_wave4_left")},
			units = {
				{
					name = "Wave1_Mid_B",
					sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
					sgroups = {SGroup_CreateIfNotFound("sg_e_RDG_wave4_left_pg")},
				},
				{
					name = "Wave1_Mid_B",
					sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
					sgroups = {SGroup_CreateIfNotFound("sg_e_RDG_wave4_left_pg")},
				},
			},
		}
		---- Difficulty Variation: HARD ----
		-- Add an extra enemy squad
		if g_hardDiff then
			local unit = encData.units[1]
			table.insert(encData.units, unit)
		end
		encID_wave4Left = Encounter:Create(encData)
		
		local goalData = {
			name = "Attack",
			leashRange = 45,
			tacticCoverPriority = -1,
			target = mkr_e_RDG_leftDest,
			useSkirmishAI = g_useSkirmishAI,
			
			tacticTargetPreference = AITacticTargetPreference_Near,
			
			attackMove = false,
			safeMoveWeight = 0,
			tacticCloseGround = true,
			
			abilityControlsList = {
				{
					abilityPBG = ABILITY.GERMAN.PANZER_GRENADIER_BUNDLED_CAMPAIGN,
					maxCasters = 1,
					maxRange = 50,
					waitTimeSecs = 45,
				},
			},
			onSuccess = EncUpdate_HTR_Capture,
		}
		encID_wave4Left:SetGoal(goalData)
		
		ThreatArrow_CreateGroup(SGroup_FromName("sg_e_RDG_wave4_left_pg"))
	end
	
	if g_midPointOwner == player1 then
		-- Spawn Main force
		local encData = {
			name = "Wave3_Left",
			player = player2,
			dynamicSpawnTarget = mkr_e_RDG_midDest,
			spawn = mkr_e_RDG_midSpawn_01,
			sgroups = {SGroup_CreateIfNotFound("sg_e_RDG_wave4"), SGroup_CreateIfNotFound("sg_e_RDG_wave4_mid")},
			units = {
				{
					name = "Wave1_Mid_A",
					sbp = SBP.GERMAN.GRENADIER_SQUAD,
				},
				{
					name = "Wave1_Mid_B",
					sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
					sgroups = {SGroup_CreateIfNotFound("sg_e_RDG_wave4_mid_pg")},
				},
				{
					name = "Wave1_Mid_C",
					sbp = SBP.GERMAN.GRENADIER_SQUAD,
					spawn = mkr_e_RDG_leftForestSpawn_01,
				},
				{
					name = "Wave1_Mid_D",
					sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
					abilityBlacklist = {ABILITY.GERMAN.PANZER_GRENADIER_BUNDLED_CAMPAIGN},
				},
			},
		}
		encID_wave4Mid = Encounter:Create(encData)
		
		local goalData = {
			name = "Attack",
			leashRange = 40,
			tacticCoverPriority = -1,
			target = mkr_e_RDG_midDest,
			useSkirmishAI = g_useSkirmishAI,
			
			tacticTargetPreference = AITacticTargetPreference_Near,
			
			attackMove = false,
			safeMoveWeight = 0,
			tacticCloseGround = true,
			
			abilityControlsList = {
				{
					abilityPBG = ABILITY.GERMAN.PANZER_GRENADIER_BUNDLED_CAMPAIGN,
					maxCasters = 1,
					maxRange = 50,
					waitTimeSecs = 45,
				},
			},
		}
		encID_wave4Mid:SetGoal(goalData)
		
		ThreatArrow_CreateGroup(SGroup_FromName("sg_e_RDG_wave4_mid_pg"))
	end
	
	--SachaHacks
	if g_midPointOwner == player1 then
		-- Spawn Main force
		local encData = {
			name = "Wave3_Right",
			player = player2,
			dynamicSpawnTarget = mkr_e_RDG_rightDest,
			spawn = mkr_e_RDG_rightSpawn_01,
			sgroups = {SGroup_CreateIfNotFound("sg_e_RDG_wave4"), SGroup_CreateIfNotFound("sg_e_RDG_wave4_right")},
			units = {
				{
					name = "Wave1_Mid_B",
					sbp = SBP.GERMAN.GRENADIER_SQUAD,
				},
				{
					name = "Wave1_Mid_B",
					sbp = SBP.GERMAN.GRENADIER_SQUAD,
					abilityBlacklist = {ABILITY.GERMAN.GRENADIER_RIFLE_GRENADE_ABILITY},
				},
				{
					name = "Wave1_Mid_B",
					sbp = SBP.GERMAN.GRENADIER_SQUAD,
				},
			},
		}
		---- Difficulty Variation: HARD ----
		-- Add an extra enemy squad
		if g_hardDiff then
			local unit = encData.units[1]
			table.insert(encData.units, unit)
		end
		encID_wave4Right = Encounter:Create(encData)
		
		local goalData = {
			name = "Attack",
			leashRange = 40,
			tacticCoverPriority = -1,
			target = mkr_e_RDG_rightDest,
			useSkirmishAI = g_useSkirmishAI,
			
			attackMove = false,
			safeMoveWeight = 0,
			tacticCloseGround = true,
		}
		encID_wave4Right:SetGoal(goalData)
		
		-- Spawn Any Delayed
		Rule_AddOneShot(OBJ_HTR_Wave4_Right_Delay, 7)
	end
	
	Timer_Start(tmr_RDG_wave5, g_RDG_wave5)
	
	-- Fire off any remaining functions (monitor)
	Rule_AddInterval(OBJ_HTR_Wave4_Finished, 1)
	
end

function OBJ_HTR_Wave4_Right_Delay()

	-- First, determine which lanes are still open and fire off spawn functions
	if g_rightPointOwner == player1 then
		local t01 = {
			name = "RDG_W2_M1-1",
			sbp = SBP.GERMAN.GRENADIER_SQUAD,
			dynamicSpawnTarget = mkr_e_RDG_rightDest,
			spawn = mkr_e_RDG_rightForestSpawn_01,
			sgroups = {SGroup_CreateIfNotFound("sg_e_RDG_wave4"), SGroup_CreateIfNotFound("sg_e_RDG_wave3_right")},
		}
		local t02 = {
			name = "RDG_W2_M1-2",
			sbp = SBP.GERMAN.GRENADIER_SQUAD,
			dynamicSpawnTarget = mkr_e_RDG_rightDest,
			spawn = mkr_e_RDG_rightForestSpawn_01,
			sgroups = {SGroup_CreateIfNotFound("sg_e_RDG_wave4"), SGroup_CreateIfNotFound("sg_e_RDG_wave3_right")},
		}
		if encID_wave4Right:IsAlive() then
			encID_wave4Right:AddUnit(t01)
		end
		if encID_wave4Right:IsAlive() then
			encID_wave4Right:AddUnit(t02)
		end
	end

end

function OBJ_HTR_Wave4_Finished()
	
	if (SGroup_Exists("sg_e_RDG_wave4") and SGroup_TotalMembersCount(SGroup_FromName("sg_e_RDG_wave4")) <= 28) or Timer_GetRemaining(tmr_RDG_wave5) <= 0 then
		Rule_RemoveMe()
		
		Rule_AddOneShot(OBJ_HTR_Wave5, 15)
		
		Ambient_Attacks_RestartLane()
		
		-- DEV
		g_dev_rdg_wave5 = Timer_GetRemaining(tmr_RDG_wave5)
	end

end

--**Wave5**--
function OBJ_HTR_Wave5()

	-- First, determine which lanes are still open and fire off spawn functions
	if g_leftPointOwner == player1 then
		-- Spawn Main force
		local encData = {
			name = "Wave3_Left",
			player = player2,
			dynamicSpawnTarget = mkr_e_RDG_leftDest,
			spawn = mkr_e_RDG_leftSpawn_01,
			sgroups = {SGroup_CreateIfNotFound("sg_e_RDG_wave5"), SGroup_CreateIfNotFound("sg_e_RDG_wave5_left")},
			units = {
				{
					name = "Wave1_Mid_A",
					sbp = SBP.GERMAN.GRENADIER_SQUAD,
				},
				{
					name = "Wave1_Mid_B",
					sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
					spawn = mkr_e_RDG_leftForestSpawn_01,
					sgroups = {SGroup_CreateIfNotFound("sg_e_RDG_wave5_left_pg")},
				},
				{
					name = "Wave1_Mid_A",
					sbp = SBP.GERMAN.GRENADIER_SQUAD,
					abilityBlacklist = {ABILITY.GERMAN.GRENADIER_RIFLE_GRENADE_ABILITY},
				},
			},
		}
		encID_wave5Left = Encounter:Create(encData)
		
		local goalData = {
			name = "Attack",
			leashRange = 45,
			tacticCoverPriority = -1,
			target = mkr_e_RDG_leftDest,
			useSkirmishAI = g_useSkirmishAI,
			
			tacticTargetPreference = AITacticTargetPreference_Near,
			
			attackMove = false,
			safeMoveWeight = 0,
			tacticCloseGround = true,
			
			abilityControlsList = {
				{
					abilityPBG = ABILITY.GERMAN.PANZER_GRENADIER_BUNDLED_CAMPAIGN,
					maxCasters = 3,
					maxRange = 50,
					waitTimeSecs = 45,
				},
			},
		}
		encID_wave5Left:SetGoal(goalData)
		SGroup_AddSlotItemToDropOnDeath(encID_wave5Left.sgroup, SLOT_ITEM.GRENADIER_MG42_LMG, 100, true)
		ThreatArrow_CreateGroup(SGroup_FromName("sg_e_RDG_wave5_left_pg"))
	end
	
	if g_midPointOwner == player1 then
		-- Spawn Main force
		local encData = {
			name = "Wave3_Left",
			player = player2,
			dynamicSpawnTarget = mkr_e_RDG_midDest,
			spawn = mkr_e_RDG_midSpawn_01,
			sgroups = {SGroup_CreateIfNotFound("sg_e_RDG_wave5"), SGroup_CreateIfNotFound("sg_e_RDG_wave5_mid")},
			units = {
				{
					name = "Wave1_Mid_B",
					sbp = SBP.GERMAN.GRENADIER_SQUAD,
					sgroups = {SGroup_CreateIfNotFound("sg_e_RDG_safeCappers")},
				},
				{
					name = "Wave1_Mid_B",
					sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
					spawn = mkr_e_RDG_leftForestSpawn_01,
					sgroups = {SGroup_CreateIfNotFound("sg_e_RDG_wave5_mid_pg")},
				},
				{
					name = "Wave1_Mid_B",
					sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
					spawn = mkr_e_RDG_leftForestSpawn_01,
					sgroups = {SGroup_CreateIfNotFound("sg_e_RDG_wave5_mid_pg")},
				},
			},
		}
		encID_wave5Mid = Encounter:Create(encData)
		
		local goalData = {
			name = "Attack",
			leashRange = 40,
			tacticCoverPriority = -1,
			target = mkr_e_RDG_midDest,
			useSkirmishAI = g_useSkirmishAI,
			
			tacticTargetPreference = AITacticTargetPreference_Near,
			
			attackMove = false,
			safeMoveWeight = 0,
			tacticCloseGround = true,
			
			abilityControlsList = {
				{
					abilityPBG = ABILITY.GERMAN.PANZER_GRENADIER_BUNDLED_CAMPAIGN,
					maxCasters = 3,
					maxRange = 50,
					waitTimeSecs = 45,
				},
			},
		}
		encID_wave5Mid:SetGoal(goalData)
		
		ThreatArrow_CreateGroup(SGroup_FromName("sg_e_RDG_wave5_mid_pg"))
	end
	
	if g_rightPointOwner == player1 then
		-- Spawn Main force
		local encData = {
			name = "Wave3_Right",
			player = player2,
			dynamicSpawnTarget = mkr_e_RDG_rightDest,
			spawn = mkr_e_RDG_rightSpawn_01,
			sgroups = {SGroup_CreateIfNotFound("sg_e_RDG_wave5"), SGroup_CreateIfNotFound("sg_e_RDG_wave5_right")},
			units = {
				{
					name = "Wave1_Mid_B",
					sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
					sgroups = {SGroup_CreateIfNotFound("sg_e_RDG_wave5_right_pg")},
				},
				{
					name = "Wave1_Mid_B",
					sbp = SBP.GERMAN.GRENADIER_SQUAD,
					spawn = mkr_e_RDG_rightForestSpawn_02,
				},
				{
					name = "Wave1_Mid_B",
					sbp = SBP.GERMAN.GRENADIER_SQUAD,
					spawn = mkr_e_RDG_rightForestSpawn_02,
				},
			},
		}
		encID_wave5Right = Encounter:Create(encData)
		
		local goalData = {
			name = "Attack",
			leashRange = 40,
			tacticCoverPriority = -1,
			target = mkr_e_RDG_rightDest,
			useSkirmishAI = g_useSkirmishAI,
			
			tacticTargetPreference = AITacticTargetPreference_Near,
			
			attackMove = false,
			safeMoveWeight = 0,
			tacticCloseGround = true,
			
			abilityControlsList = {
				{
					abilityPBG = ABILITY.GERMAN.PANZER_GRENADIER_BUNDLED_CAMPAIGN,
					maxCasters = 3,
					maxRange = 50,
					waitTimeSecs = 45,
				},
			},
		}
		encID_wave5Right:SetGoal(goalData)
		
		ThreatArrow_CreateGroup(SGroup_FromName("sg_e_RDG_wave5_right_pg"))
	end
	
	-- Tanks spawn regardless
	local encData = {
		name = "Wave3_Left",
		player = player2,
		dynamicSpawnTarget = mkr_playZone,
		spawn = mkr_e_RDG_midSpawn_02,
		sgroups = {SGroup_CreateIfNotFound("sg_e_RDG_pnzrIII"), SGroup_CreateIfNotFound("sg_e_RDG_pnzrIII_02")},
		units = {
			{
				name = "Wave1_Mid_A",
				sbp = SBP.GERMAN.STUG_III_E_SQUAD,
			},
		},
	}
	encID_stug02 = Encounter:Create(encData)
	
	local goalData = {
		name = "Defend",
		target = mkr_e_RDG_pnzrIII_02_def,
		useSkirmishAI = g_useSkirmishAI,
		tacticControlsList = g_disableVehicleTactic,
		range = 70,
		leashRange = 35,
		attackMove = true,
		safeMoveWeight = 0,
	}
	encID_stug02:SetGoal(goalData)
	
	local encData = {
		name = "Wave3_Left",
		player = player2,
		dynamicSpawnTarget = mkr_e_RDG_rightDest,
		spawn = mkr_e_RDG_rightSpawn_01,
		sgroups = {SGroup_CreateIfNotFound("sg_e_RDG_pnzrIII"), SGroup_CreateIfNotFound("sg_e_RDG_pnzrIII_04")},
		units = {
			{
				name = "Wave1_Mid_A",
				sbp = SBP.GERMAN.STUG_III_E_SQUAD,
			},
		},
	}
	encID_stug04 = Encounter:Create(encData)
	
	local goalData = {
		name = "Defend",
		target = mkr_e_RDG_pnzrIII_04_def,
		useSkirmishAI = g_useSkirmishAI,
		tacticControlsList = g_disableVehicleTactic,
		range = 70,
		leashRange = 35,
		attackMove = true,
		safeMoveWeight = 0,
		tacticCloseGround = true,
	}
	encID_stug04:SetGoal(goalData)
	
	g_pnzrIII_range_mod = Modify_WeaponRange(SGroup_FromName("sg_e_RDG_pnzrIII"), "hardpoint_01", 0.75)
	
	-- Fire off any remaining functions (monitor)
	Rule_AddOneShot(OBJ_HTR_FinalWave, 20)
	Rule_RemoveIfExist(OBJ_HTR_Maxims_Arrive)
	Rule_AddInterval(HTR_Stug_Callout, 1)
	
end

function HTR_Stug_Callout()
	if Player_CanSeeSGroup(player1, SGroup_FromName("sg_e_RDG_pnzrIII"), ANY) then
		if hpid_pg ~= nil then
			Objective_RemoveUIElements(OBJ_SecondaryOBJ, hpid_pg)
		end
		if hpid_maxim ~= nil then
			Objective_RemoveUIElements(OBJ_SecondaryOBJ, hpid_maxim)
		end
		Util_StartIntel(EVENTS.TANK_SPOTTED)
		Rule_RemoveMe()
	end
end

function OBJ_HTR_FinalWave()
	
	-- First, determine which lanes are still open and fire off spawn functions
	if g_leftPointOwner == player1 then
		-- Spawn Main force
		local encData = {
			name = "Wave3_Left",
			player = player2,
			dynamicSpawnTarget = mkr_e_RDG_leftDest,
			spawn = mkr_e_RDG_leftSpawn_01,
			sgroups = {SGroup_CreateIfNotFound("sg_e_RDG_wave5"), SGroup_CreateIfNotFound("sg_e_RDG_wave5_left")},
			units = {
				{
					name = "Wave1_Mid_A",
					sbp = SBP.GERMAN.GRENADIER_SQUAD,
					sgroups = {SGroup_CreateIfNotFound("sg_e_RDG_safeCappers")},
				},
				{
					name = "Wave1_Mid_A",
					sbp = SBP.GERMAN.GRENADIER_SQUAD,
					sgroups = {SGroup_CreateIfNotFound("sg_e_RDG_safeCappers")},
				},
			},
		}
		---- Difficulty Variation: HARD ----
		-- Add an extra enemy squad
		if g_hardDiff then
			local unit = encData.units[1]
			table.insert(encData.units, unit)
		end
		encID_wave5Left = Encounter:Create(encData)
		
		local goalData = {
			name = "Attack",
			leashRange = 45,
			target = mkr_e_RDG_leftDest,
			useSkirmishAI = g_useSkirmishAI,
			
			attackMove = true,
			safeMoveWeight = 0,
			tacticCloseGround = true,
		}
		encID_wave5Left:SetGoal(goalData)
	end
	
	if g_midPointOwner == player1 then
		-- Spawn Main force
		local encData = {
			name = "Wave3_Left",
			player = player2,
			dynamicSpawnTarget = mkr_e_RDG_midDest,
			spawn = mkr_e_RDG_midSpawn_01,
			sgroups = {SGroup_CreateIfNotFound("sg_e_RDG_wave5"), SGroup_CreateIfNotFound("sg_e_RDG_wave5_mid")},
			units = {
				{
					name = "Wave1_Mid_B",
					sbp = SBP.GERMAN.GRENADIER_SQUAD,
					sgroups = {SGroup_CreateIfNotFound("sg_e_RDG_safeCappers")},
				},
				{
					name = "Wave1_Mid_B",
					sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
					spawn = mkr_e_RDG_leftForestSpawn_01,
					abilityBlacklist = {ABILITY.GERMAN.PANZER_GRENADIER_BUNDLED_CAMPAIGN},
				},
			},
		}
		encID_wave5Mid = Encounter:Create(encData)
		
		local goalData = {
			name = "Attack",
			leashRange = 40,
			target = mkr_e_RDG_midDest,
			useSkirmishAI = g_useSkirmishAI,
			
			tacticTargetPreference = AITacticTargetPreference_Near,
			
			attackMove = true,
			safeMoveWeight = 0,
			tacticCloseGround = true,
			
			abilityControlsList = {
				{
					abilityPBG = ABILITY.GERMAN.PANZER_GRENADIER_BUNDLED_CAMPAIGN,
					maxCasters = 1,
					maxRange = 50,
					waitTimeSecs = 45,
				},
			},
		}
		encID_wave5Mid:SetGoal(goalData)
	end
	
	if g_rightPointOwner == player1 then
		-- Spawn Main force
		local encData = {
			name = "Wave3_Right",
			player = player2,
			dynamicSpawnTarget = mkr_e_RDG_rightDest,
			spawn = mkr_e_RDG_rightSpawn_01,
			sgroups = {SGroup_CreateIfNotFound("sg_e_RDG_wave5"), SGroup_CreateIfNotFound("sg_e_RDG_wave5_right")},
			units = {
				{
					name = "Wave1_Mid_A",
					sbp = SBP.GERMAN.GRENADIER_SQUAD,
					sgroups = {SGroup_CreateIfNotFound("sg_e_RDG_safeCappers")},
				},
				{
					name = "Wave1_Mid_B",
					sbp = SBP.GERMAN.GRENADIER_SQUAD,
					spawn = mkr_e_RDG_rightForestSpawn_02,
					--SachaHacks, grant LMGs to some grenadiers
					upgrades = {UPG.GERMAN.GRENADIER_MG42_LMG}
				},
			},
		}
		encID_wave5Right = Encounter:Create(encData)
		SGroup_AddSlotItemToDropOnDeath(encID_wave5Right.sgroup, SLOT_ITEM.GRENADIER_MG42_LMG, 100, true)
		
		local goalData = {
			name = "Attack",
			leashRange = 40,
			target = mkr_e_RDG_rightDest,
			useSkirmishAI = g_useSkirmishAI,
			
			attackMove = true,
			safeMoveWeight = 0,
			tacticCloseGround = true,
		}
		encID_wave5Right:SetGoal(goalData)
		
	end
	
	-- Tanks spawn regardless
	local encData = {
		name = "Wave3_Left",
		player = player2,
		dynamicSpawnTarget = mkr_e_RDG_leftDest,
		spawn = mkr_e_RDG_leftSpawn_01,
		sgroups = {SGroup_CreateIfNotFound("sg_e_RDG_pnzrIII"), SGroup_CreateIfNotFound("sg_e_RDG_pnzrIII_01")},
		units = {
			{
				name = "Wave1_Mid_A",
				sbp = SBP.GERMAN.STUG_III_E_SQUAD,
			},
		},
	}
	encID_stug01 = Encounter:Create(encData)
	
	local goalData = {
		name = "Defend",
		target = mkr_e_RDG_pnzrIII_01_def,
		useSkirmishAI = g_useSkirmishAI,
		tacticControlsList = g_disableVehicleTactic,
		range = 70,
		leashRange = 35,
		attackMove = true,
		safeMoveWeight = 0,
		tacticCloseGround = true,
	}
	encID_stug01:SetGoal(goalData)
	
	local encData = {
		name = "Wave3_Left",
		player = player2,
		dynamicSpawnTarget = mkr_e_RDG_midDest,
		spawn = mkr_e_RDG_midSpawn_02,
		sgroups = {SGroup_CreateIfNotFound("sg_e_RDG_pnzrIII"), SGroup_CreateIfNotFound("sg_e_RDG_pnzrIII_03")},
		units = {
			{
				name = "Wave1_Mid_A",
				sbp = SBP.GERMAN.STUG_III_E_SQUAD,
			},
		},
	}
	encID_stug03 = Encounter:Create(encData)
	
	local goalData = {
		name = "Defend",
		target = mkr_e_RDG_pnzrIII_03_def,
		useSkirmishAI = g_useSkirmishAI,
		tacticControlsList = g_disableVehicleTactic,
		range = 70,
		leashRange = 35,
		attackMove = true,
		safeMoveWeight = 0,
		tacticCloseGround = true,
	}
	encID_stug03:SetGoal(goalData)
	
	local encData = {
		name = "Wave3_Left",
		player = player2,
		dynamicSpawnTarget = mkr_e_RDG_rightDest,
		spawn = mkr_e_RDG_rightSpawn_01,
		sgroups = {SGroup_CreateIfNotFound("sg_e_RDG_pnzrIII"), SGroup_CreateIfNotFound("sg_e_RDG_pnzrIII_05")},
		units = {
			{
				name = "Wave1_Mid_A",
				sbp = SBP.GERMAN.STUG_III_E_SQUAD,
			},
		},
	}
	encID_stug05 = Encounter:Create(encData)
	
	local goalData = {
		name = "Defend",
		target = mkr_e_RDG_pnzrIII_05_def,
		useSkirmishAI = g_useSkirmishAI,
		tacticControlsList = g_disableVehicleTactic,
		range = 70,
		leashRange = 35,
		
		attackMove = true,
		safeMoveWeight = 0,
		tacticCloseGround = true,
	}
	encID_stug05:SetGoal(goalData)
	
	Modifier_Remove(g_pnzrIII_range_mod)
	g_pnzrIII_range_mod = Modify_WeaponRange(SGroup_FromName("sg_e_RDG_pnzrIII"), "hardpoint_01", 0.75)
	
	Rule_AddOneShot(OBJ_HTR_Fallback, 5)

end

function OBJ_HTR_Fallback()
	Objective_Show(OBJ_SecondaryOBJ, false)
	Ambient_Attacks_RetreatAndHold()
	
	__t_ambient.tar = "VILLAGE"
	
	ThreatArrow_DestroyAllGroups()
	
	Rule_AddInterval(HTP_UpdateObj, 10)
		
	EGroup_DeSpawn(eg_p_MEP_01)
	EGroup_ReSpawn(eg_p_MEP_02)
	
	Camera_Unclamp()
	Misc_RemoveCommandRestriction()
	
	Rule_AddInterval(OBJ_HTR_Check_Point_01, 1)
	Rule_AddInterval(OBJ_HTR_Check_Point_02, 1)
	Rule_AddInterval(OBJ_HTR_Check_Point_03, 1)
	
	SGroup_SetInvulnerable(SGroup_FromName("sg_e_RDG_pnzrIII"), true)
	
	Cmd_Stop(SGroup_CreateIfNotFound("sg_e_RDG_pnzrIII"))
	
	Event_Remove(eventID_germanFlamer)
	if hint_pickupFlamerGerman ~= nil then
		HintPoint_Remove(hint_pickupFlamerGerman)
	end

end

function OBJ_HTR_Check_Point_01()
	
	local __despawnCheck = function(gid, idx, sid)
		if Player_CanSeeSquad(player1, sid, ALL) == false then
			Squad_Destroy(sid)
		end
	end
	
	--SachaHacks, ensure player can't see enemies spawn in around Ridge points
	if Player_OwnsEGroup(player2, eg_POS_A_Points_01, ALL) and not Player_CanSeePosition(player1, Marker_GetPosition(mkr_RDG_canSeeLeft)) and g_friendlyArtyComplete then
		sg_point_01_units = SGroup_CreateIfNotFound("sg_point_01_units")
		Player_GetAllSquadsNearMarker(player2, sg_point_01_units, Util_GetPosition(eg_POS_A_Points_01), 40)
		SGroup_Filter(sg_point_01_units, SBP.GERMAN.STUG_III_E_SQUAD, FILTER_REMOVE)
		
		if SGroup_IsEmpty(sg_point_01_units) == false then
			SGroup_ForEach(sg_point_01_units, __despawnCheck)
		else
			Rule_RemoveMe()
			
			if Rule_Exists(Enemy_Reinforce_Point01) == false then Rule_AddOneShot(Enemy_Reinforce_Point01, 5) end
		end
	elseif not Player_OwnsEGroup(player2, eg_POS_A_Points_01, ALL) and not Player_CanSeePosition(player1, Marker_GetPosition(mkr_RDG_canSeeLeft)) then
		EGroup_InstantCaptureStrategicPoint(eg_POS_A_Points_01, player2)
		FOW_RevealEGroupOnly(eg_POS_A_Points_01, 1)
	end

end

function Enemy_Reinforce_Point01()

	-- Spawn German howitzers on the Ridge

	sg_e_RDG_arty01 = SGroup_CreateIfNotFound("sg_e_RDG_arty01")
	sg_e_RDG_arty02 = SGroup_CreateIfNotFound("sg_e_RDG_arty02")

	Util_CreateSquads(player2, sg_e_RDG_arty01, SBP.GERMAN.HOWITZER_105MM_LE_FH18_ARTILLERY, mkr_e_RDG_artillery01)
	Util_CreateSquads(player2, sg_e_RDG_arty02, SBP.GERMAN.HOWITZER_105MM_LE_FH18_ARTILLERY, mkr_e_RDG_artillery02)
	
	-- Territory-point defenders
	local encData = {
		name = "wave4bCenter",
		player = player2,
		dynamicSpawnTarget = mkr_e_RDG_leftDest,
		spawn = mkr_e_RDG_leftSpawn_01,
		sgroups = {SGroup_CreateIfNotFound("sg_e_RDG_left_def")},
		units = {
			{
				name = "wave4bCenter-4",
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
			},
			{
				name = "wave4bCenter-4",
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
			},
			{
				name = "wave4bCenter-4",
				sbp = SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD,
			},
		},
	}
	encID_leftRDG_cp = Encounter:Create(encData)
	
	local defendData = {
		name = "Defend",
		target = mkr_e_RDG_leftDest,
		useSkirmishAI = g_useSkirmishAI,
		
		tacticTargetPreference = AITacticTargetPreference_Near,
		retaliateAttacks = true,
		
		range = 45,
		leashRange = 20,
		
		coordinatedSetup = true,
		coordinatedSetupFacingPositions = {mkr_friendly_artillery_B_01, mkr_friendly_artillery_B_02, mkr_friendly_artillery_B_03},
		
		fallback = true,
		fallbackParams = {
			thresholds = {0.55},
			thresholdType = Threshold_PercentageEntitiesRemaining,
			markers = {mkr_e_retreat_01},
			retreat = true,
			retreatDespawn = true,
			
			abilityControlsList = {
				{
					abilityPBG = ABILITY.GERMAN.PANZER_GRENADIER_BUNDLED_CAMPAIGN,
					maxCasters = 1,
					maxRange = 50,
					waitTimeSecs = 45,
				},
			},
		},
	}
	encID_leftRDG_cp:SetGoal(defendData)
	
end

function OBJ_HTR_Check_Point_02()
	
	local __despawnCheck = function(gid, idx, sid)
		if Player_CanSeeSquad(player1, sid, ALL) == false then
			Squad_Destroy(sid)
		end
	end
	
	--SachaHacks, ensure player can't see enemies spawn in around Ridge points
	if Player_OwnsEGroup(player2, eg_POS_A_Points_02, ALL) and not Player_CanSeePosition(player1, Marker_GetPosition(mkr_RDG_canSeeMid)) and g_friendlyArtyComplete then
		sg_point_02_units = SGroup_CreateIfNotFound("sg_point_02_units")
		Player_GetAllSquadsNearMarker(player2, sg_point_02_units, Util_GetPosition(eg_POS_A_Points_02), 40)
		SGroup_Filter(sg_point_02_units, SBP.GERMAN.STUG_III_E_SQUAD, FILTER_REMOVE)
		
		if SGroup_IsEmpty(sg_point_02_units) == false then
			SGroup_ForEach(sg_point_02_units, __despawnCheck)
		else
			Rule_RemoveMe()
			
			if Rule_Exists(Enemy_Reinforce_Point02) == false then Rule_AddOneShot(Enemy_Reinforce_Point02, 5) end
		end
	elseif not Player_OwnsEGroup(player2, eg_POS_A_Points_02, ALL) and not Player_CanSeePosition(player1, Marker_GetPosition(mkr_RDG_canSeeMid)) then
		EGroup_InstantCaptureStrategicPoint(eg_POS_A_Points_02, player2)
		FOW_RevealEGroupOnly(eg_POS_A_Points_02, 1)
	end

end

function Enemy_Reinforce_Point02()

	-- Spawn German howitzers on the Ridge
	sg_e_RDG_arty03 = SGroup_CreateIfNotFound("sg_e_RDG_arty03")
	sg_e_RDG_arty04 = SGroup_CreateIfNotFound("sg_e_RDG_arty04")
	
	Util_CreateSquads(player2, sg_e_RDG_arty03, SBP.GERMAN.HOWITZER_105MM_LE_FH18_ARTILLERY, mkr_e_RDG_artillery03)
	Util_CreateSquads(player2, sg_e_RDG_arty04, SBP.GERMAN.HOWITZER_105MM_LE_FH18_ARTILLERY, mkr_e_RDG_artillery04)
	
	-- Territory-point defenders
	local encData = {
		name = "wave4bCenter",
		player = player2,
		dynamicSpawnTarget = mkr_e_RDG_midDest,
		spawn = mkr_e_RDG_midSpawn_01,
		sgroups = {SGroup_CreateIfNotFound("sg_e_RDG_mid_def")},
		units = {
			{
				name = "wave4bCenter-4",
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
			},
			{
				name = "wave4bCenter-4",
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
			},
			{
				name = "wave4bCenter-4",
				sbp = SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD,
			},
		},
	}
	encID_midRDG_cp = Encounter:Create(encData)
	
	local defendData = {
		name = "Defend",
		target = mkr_e_RDG_midDest,
		useSkirmishAI = g_useSkirmishAI,
		
		tacticTargetPreference = AITacticTargetPreference_Near,
		retaliateAttacks = true,
		
		range = 45,
		leashRange = 20,
		
		coordinatedSetup = true,
		coordinatedSetupFacingPositions = {mkr_friendly_artillery_B_02, mkr_friendly_artillery_B_03, mkr_friendly_artillery_B_04},
		
		fallback = true,
		fallbackParams = {
			thresholds = {0.55},
			thresholdType = Threshold_PercentageEntitiesRemaining,
			markers = {mkr_e_retreat_02},
			retreat = true,
			retreatDespawn = true,
			
			abilityControlsList = {
				{
					abilityPBG = ABILITY.GERMAN.PANZER_GRENADIER_BUNDLED_CAMPAIGN,
					maxCasters = 1,
					maxRange = 50,
					waitTimeSecs = 45,
				},
			},
		},
	}
	encID_midRDG_cp:SetGoal(defendData)
	
end

function OBJ_HTR_Check_Point_03()
	
	local __despawnCheck = function(gid, idx, sid)
		if Player_CanSeeSquad(player1, sid, ALL) == false then
			Squad_Destroy(sid)
		end
	end
	
	--SachaHacks, ensure player can't see enemies spawn in around Ridge points
	if Player_OwnsEGroup(player2, eg_POS_A_Points_03, ALL) and not Player_CanSeePosition(player1, Marker_GetPosition(mkr_RDG_canSeeRight)) and g_friendlyArtyComplete then
		sg_point_03_units = SGroup_CreateIfNotFound("sg_point_03_units")
		Player_GetAllSquadsNearMarker(player2, sg_point_03_units, Util_GetPosition(eg_POS_A_Points_03), 5)
		SGroup_Filter(sg_point_03_units, SBP.GERMAN.STUG_III_E_SQUAD, FILTER_REMOVE)
		
		if SGroup_IsEmpty(sg_point_03_units) == false then
			SGroup_ForEach(sg_point_03_units, __despawnCheck)
		else
			Rule_RemoveMe()
			
			if Rule_Exists(Enemy_Reinforce_Point03) == false then Rule_AddOneShot(Enemy_Reinforce_Point03, 20) end
		end
	elseif not Player_OwnsEGroup(player2, eg_POS_A_Points_03, ALL) and not Player_CanSeePosition(player1, Marker_GetPosition(mkr_RDG_canSeeRight)) then
		EGroup_InstantCaptureStrategicPoint(eg_POS_A_Points_03, player2)
		FOW_RevealEGroupOnly(eg_POS_A_Points_03, 1)
	end

end

function Enemy_Reinforce_Point03()

	-- Spawn German howitzers on the Ridge
	sg_e_RDG_arty05 = SGroup_CreateIfNotFound("sg_e_RDG_arty05")
	sg_e_RDG_arty06 = SGroup_CreateIfNotFound("sg_e_RDG_arty06")
	
	Util_CreateSquads(player2, sg_e_RDG_arty05, SBP.GERMAN.HOWITZER_105MM_LE_FH18_ARTILLERY, mkr_e_RDG_artillery05)
	Util_CreateSquads(player2, sg_e_RDG_arty06, SBP.GERMAN.HOWITZER_105MM_LE_FH18_ARTILLERY, mkr_e_RDG_artillery06)
	
	-- Territory-point defenders
	local encData = {
		name = "wave4bCenter",
		player = player2,
		dynamicSpawnTarget = mkr_e_RDG_rightDest,
		spawn = mkr_e_RDG_rightSpawn_01,
		sgroups = {SGroup_CreateIfNotFound("sg_e_RDG_right_def")},
		units = {
			{
				name = "wave4bCenter-4",
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
			},
			{
				name = "wave4bCenter-4",
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
			},
			{
				name = "wave4bCenter-4",
				sbp = SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD,
			},
		},
	}
	encID_leftRDG_cp = Encounter:Create(encData)
	
	local defendData = {
		name = "Defend",
		target = mkr_e_RDG_rightDest,
		useSkirmishAI = g_useSkirmishAI,
		
		tacticTargetPreference = AITacticTargetPreference_Near,
		retaliateAttacks = true,
		
		range = 45,
		leashRange = 20,
		
		coordinatedSetup = true,
		coordinatedSetupFacingPositions = {mkr_friendly_artillery_B_03, mkr_friendly_artillery_B_04, mkr_friendly_artillery_B_05},
		
		fallback = true,
		fallbackParams = {
			thresholds = {0.55},
			thresholdType = Threshold_PercentageEntitiesRemaining,
			markers = {mkr_e_retreat_03},
			retreat = true,
			retreatDespawn = true,
			
			abilityControlsList = {
				{
					abilityPBG = ABILITY.GERMAN.PANZER_GRENADIER_BUNDLED_CAMPAIGN,
					maxCasters = 1,
					maxRange = 50,
					waitTimeSecs = 45,
				},
			},
		},
	}
	encID_leftRDG_cp:SetGoal(defendData)
	
end

function HTP_UpdateMusic_01()
	
	Player_GetAllSquadsNearMarker(player1, sg_temp, mkr_RDG_playzone)
	
	if SGroup_IsEmpty(sg_temp) then
		Player_GetAll(player1, sg_temp)
		Player_GetAll(player3, sg_blah)
		if SGroup_IsUnderAttack(sg_temp, ANY, 5) == false and SGroup_IsUnderAttack(sg_blah, ANY, 5) == false then
			Rule_RemoveMe()
		end
	end

end


function Friendly_Arty_Salvo_Delayed()
	
	sg_p_ridge = SGroup_CreateIfNotFound("sg_p_ridge")
	
	Player_GetAllSquadsNearMarker(player1, sg_p_ridge, mkr_RDG_check)
	
	if SGroup_Count(sg_p_ridge) < 3 then
		Rule_RemoveMe()
	elseif (SGroup_Count(sg_p_ridge) < 6) or SGroup_IsRetreating(sg_p_ridge, ANY) or Timer_GetRemaining(tmr_rdg_retreatOverride) <= 0 then
		Rule_RemoveMe()
		
		Friendly_Arty_Salvo_A()
	end

end


function Friendly_Arty_Salvo_A()
	
	local t = Marker_GetTable("mkr_friendly_artillery_A_%02d")
	
	for i = 1, table.getn(t) do
		Cmd_Ability(player3, ABILITY.GLOBAL.OFF_MAP_ARTILLERY, t[i], nil, true)
	end
	
	Rule_AddOneShot(Friendly_Arty_Salvo_B, 1)
	
	Rule_AddDelayedInterval(Friendly_Arty_CeaseFire_Delay, 3.5, 1)

end

function Friendly_Arty_CeaseFire_Delay()

	if Event_IsAnyRunning() == false then
		Rule_RemoveMe()
		
		Rule_AddOneShot(Friendly_Arty_CeaseFire, 2.5)
	end

end

function Friendly_Arty_CeaseFire()

	Util_StartIntel(EVENTS.HTP_Arty_CeaseFire)

end

function Friendly_Arty_Salvo_B()
	
	local t = Marker_GetTable("mkr_friendly_artillery_B_%02d")
	
	for i = 1, table.getn(t) do
		Cmd_Ability(player3, ABILITY.GLOBAL.OFF_MAP_ARTILLERY, t[i], nil, true)
	end
	
	Friendly_Arty_Salvo_C()

end

function Friendly_Arty_Salvo_C()
	
	local t = Marker_GetTable("mkr_friendly_artillery_C_%02d")
			
	for i = 1, table.getn(t) do
		Cmd_Ability(player3, ABILITY.GLOBAL.OFF_MAP_ARTILLERY, t[i], nil, true)
	end
	g_friendlyArtyComplete = true
end

--------------------
-- Objective 2: HOLD THE VILLAGE
--------------------
--------------------
function HTP_UpdateObj()

	if Event_IsAnyRunning() == false then
		Objective_Complete(OBJ_HoldTheRidge, false)
		if hint_retake ~= nil then
			HintPoint_Remove(hint_retake)
		end
		if g_hardDiff then
			Objective_Complete(OBJ_RidgeMortars, false)
		end
	
		Rule_RemoveMe()
		
		-- retreat and remove some low-health conscript squads, to make pop-cap room for Guard Troops
		sg_p_conscriptsToRemove = SGroup_CreateIfNotFound("sg_p_conscriptsToRemove")
		Player_GetAll(player1, sg_p_conscriptsToRemove)
		SGroup_Filter(sg_p_conscriptsToRemove, {SBP.SOVIET.BASE_CONSCRIPT_SQUAD,SBP.SOVIET.PENAL_BATTALION}, FILTER_KEEP)
		local sortGroup = function (gid, idx, sid)
			if Squad_Count(sid) > 1 then
				SGroup_Remove(gid, sid)
			end
		end
		SGroup_ForEach(sg_p_conscriptsToRemove, sortGroup)
		Cmd_Retreat(sg_p_conscriptsToRemove, mkr_a_t34_exit, true)
		g_retreatEntityCount = 2
		Rule_AddDelayedInterval(HTP_DeleteWeakConscripts, 30, 5)
		---
		local player1Squads = Player_GetSquads(player1)
		if SGroup_Count(player1Squads) <= 3 then
			Objective_Start(OBJ_HoldTheVillage, false)
		else	
			Objective_Start(OBJ_HoldTheVillage)
		end
		
		tmr_rdg_retreatOverride = "tmr_rdg_retreatOverride"
		Timer_Start(tmr_rdg_retreatOverride, 30)
		
		Rule_AddDelayedInterval(Friendly_Arty_Salvo_Delayed, 15, 1)
		-- LOCDB [11007300] 'Defend the Village Control Points'
		-- LOCDB [11007301] 'The Germans will attempt to push us back across the river, hold the village at all costs - ensure they do not take any more ground.'
		
		g_ridge_secure = false
		
		g_player_seen_hq = false
		
		-- Loss Rule
		g_positions_lost = 0
		g_pos_A_lost = false
		g_pos_B_lost = false
		g_pos_C_lost = false
	
	end

end

function HTP_DeleteWeakConscripts()
	sg_p_conscriptsToRemove = SGroup_CreateIfNotFound("sg_p_conscriptsToRemove")
	Player_GetAll(player1, sg_p_conscriptsToRemove)
	SGroup_Filter(sg_p_conscriptsToRemove, {SBP.SOVIET.BASE_CONSCRIPT_SQUAD, SBP.SOVIET.M1910_MAXIM_HEAVY_MACHINE_GUN_SQUAD, SBP.SOVIET.PENAL_BATTALION}, FILTER_KEEP)	
	
	local sortGroup = function (gid, idx, sid)
		if Squad_Count(sid) > g_retreatEntityCount then
			SGroup_Remove(gid, sid)
		end
	end
	SGroup_ForEach(sg_p_conscriptsToRemove, sortGroup)
	if not SGroup_IsEmpty(sg_p_conscriptsToRemove) then
		SGroup_DestroyAllInMarker(sg_p_conscriptsToRemove, mkr_a_t34_exit)

		Cmd_Retreat(sg_p_conscriptsToRemove, mkr_a_t34_exit, true)
	end
	g_retreatEntityCount = g_retreatEntityCount + 1
end

function HTP_DeleteRidgeSquads()
	Rule_RemoveIfExist(HTP_DeleteWeakConscripts)
	sg_p_conscriptsToRemove = SGroup_CreateIfNotFound("sg_p_conscriptsToRemove")
	Player_GetAll(player1, sg_p_conscriptsToRemove)

	-- Nuke remaining enemy squads on the ridge
	SGroup_DestroyAllSquads(SGroup_CreateIfNotFound("sg_e_RDG_wave1"))
	SGroup_DestroyAllSquads(SGroup_CreateIfNotFound("sg_e_RDG_wave2"))
	SGroup_DestroyAllSquads(SGroup_CreateIfNotFound("sg_e_RDG_wave3"))
	SGroup_DestroyAllSquads(SGroup_CreateIfNotFound("sg_e_RDG_wave4"))
	SGroup_DestroyAllSquads(SGroup_CreateIfNotFound("sg_e_RDG_wave5"))
	SGroup_DestroyAllSquads(sg_pioneers_flame)
	
	SGroup_DestroyAllSquads(sg_p_conscriptsToRemove)
	if g_hardDiff and SGroup_Exists("sg_e_ridgeMortar") then
		Rule_RemoveSGroupEvent(__countMortarsKilled, sg_e_ridgeMortar)
		SGroup_DestroyAllSquads(sg_e_ridgeMortar)
	end
end


--- Objective 2: Hold the Village

function Initialize_HoldTheVillage()

	OBJ_HoldTheVillage = {
		
		SetupUI = function() 
			hpid_pos_A = Objective_AddUIElements(OBJ_HoldTheVillage, mkr_villagePoint1, true, 11008183, true)
			hpid_pos_B = Objective_AddUIElements(OBJ_HoldTheVillage, mkr_villagePoint2, true, 11008183, true)
			hpid_pos_C = Objective_AddUIElements(OBJ_HoldTheVillage, mkr_villagePoint3, true, 11008183, true)
		end,
		
		OnStart = function()			
			Objective_UpdateText(OBJ_HoldTheVillage, 11035340, 11008197, false) -- LOCDB [11035340] 'Fall back to the village'
			
			World_SetIceHealingRate(t_difficulty.ice_heal_rate)
			
			-- give the player some munitions for demo packs and mines
			Player_SetResource(player1, RT_Munition, 300)
			
			CapturePoints_Set({eg_POS_B_Points_01, eg_POS_B_Points_02, eg_POS_B_Points_03}, OBJ_HoldTheVillage, OBJ_RetakeVillagePoint)
			
			g_fallbackArtyTimer = 0
			Rule_AddInterval(DCP_Timer_StartCheck, 1)
			
			-- Set variables
			g_leftPointOwner = player1
			g_midPointOwner = player1
			g_rightPointOwner = player1 
			
			g_VILpointsLost = 0
			
			g_VIL_RetakeTime = 1.2*60
			
			-- Wave Timers
			tmr_VIL_wave2 = "tmr_VIL_wave2"
			tmr_VIL_wave3 = "tmr_VIL_wave3"
			tmr_VIL_wave4 = "tmr_VIL_wave4"
			tmr_VIL_wave5 = "tmr_VIL_wave5"
			tmr_VIL_wave6 = "tmr_VIL_wave6"
			tmr_VIL_wave7 = "tmr_VIL_wave7"
			if g_easyDiff then
				g_VIL_wave2 = 1.75*60
				g_VIL_wave3 = 3*60
				g_VIL_wave4 = 3*60	
				g_VIL_wave5 = 2.5*60 
				g_VIL_wave6 = 2.5*60
				g_VIL_wave7 = 1.25*60 
			else
				g_VIL_wave2 = 1.25*60
				g_VIL_wave3 = 2.5*60
				g_VIL_wave4 = 2*60	
				g_VIL_wave5 = 2*60 
				g_VIL_wave6 = 1.5*60
				g_VIL_wave7 = 1.25*60 
			end
			World_IncreaseInteractionStage()
			EGroup_EnableMinimapIndicator(eg_mm_unlock1, true)
			Player_SetCommandAvailability(player1, SCMD_Retreat, ITEM_UNLOCKED)
			flashID_retreat = UI_FlashSquadCommandButton(SCMD_Retreat, true)
			
			-- Difficulty Variation: EASY
			-- Pause wave timers if player doesn't own all three territories in the village
			if g_easyDiff then
				g_HTV_timersPaused = false
				Rule_AddInterval(HTV_Easy_TerritoryCheck, 1)
			end
			
			-- Warning timers
			tmr_left_loss = "tmr_left_loss"
			tmr_mid_loss = "tmr_mid_loss"
			tmr_right_loss = "tmr_right_loss"
		end,
		
		OnComplete = function()
			
		end,
		
		OnFail = function()
			if g_missionFailed == false then
				g_missionFailed = true
				Rule_AddDelayedInterval(Mission_Fail, 1.5, 1)			
			end
		end,
		
		IsComplete = function()
			return false
		end, -- LOCDB [11008196] 'Defend the Village'
		
		Intel_Start = EVENTS.HTP_UpdateToVillage,				-- Event will play when obj starts but before any UI appears
		Intel_Complete = nil,			-- Event will play when obj completes but before UI is cleared
		Intel_Fail = EVENTS.MISSION_LOST_VILLAGE,				-- Event will play when obj fails but before UI is cleared
		Title = 11035337,-- LOCDB [11035337] 'Defend all three territories in the village'
		Description = 11008197,			-- LOCDB [11008197] 'The ridge has been lost.  Shore up defenses in the village and repel the next German wave - do not let them circle you!'
		TitleEnd = 11008198,				-- LOCDB [11008198] 'Village Held'
		TitleFail = 11008199,			-- LOCDB [11008199] 'Village Lost'
		Type = OT_Primary,				-- Objective Type (OT_Primary, OT_Secondary)
	}
	
	Objective_Register(OBJ_HoldTheVillage)
	
end

-- HOLD THE VILLAGE
----> Dummy OBJ: Retake Village Point
function Initialize_RetakeVillagePoint()

	OBJ_RetakeVillagePoint = {
		
		SetupUI = function() 
			
		end,
		
		OnStart = function()
			
		end,
		
		OnComplete = function()
			
		end,
		
		OnFail = function()
			Objective_Fail(OBJ_HoldTheVillage)	
		end,
		
		IsComplete = function()
			return false
		end,
		
		Intel_Start = nil,				-- Event will play when obj starts but before any UI appears
		Intel_Complete = nil,			-- Event will play when obj completes but before UI is cleared
		Intel_Fail = nil,				-- Event will play when obj fails but before UI is cleared
		Title = 11008188,				-- LOCDB [11008188] 'Move a squad to the lost strategic point'
		Description = 11008189,			-- LOCDB [11008189] 'Re-take the lost point before the Germans can encircle you!'
		TitleEnd = nil,				-- LOCDB [11007291] 'Village Held'
		TitleFail = nil,			-- LOCDB [11007292] 'Ridge Lost'
		Type = OT_Primary,				-- Objective Type (OT_Primary, OT_Secondary)
	}
	
	Objective_Register(OBJ_RetakeVillagePoint)
	
end
-- HOLD THE VILLAGE
----> Dummy OBJ: Timer
function Initialize_DefendCapturePointsTIMER()

	OBJ_DefendCapturePointsTIMER = {
		
		SetupUI = function() 
			
		end,
		
		OnStart = function()
			g_attackWarning = false
			
			Objective_SetAlwaysShowDetails(OBJ_DefendCapturePointsTIMER, true, true, true)
			
			Objective_StartTimer(OBJ_DefendCapturePointsTIMER, COUNT_DOWN, t_difficulty.vil_start_time, 30)
			Objective_Start(SOBJ_DCP_SquadsInCover, false)
			Objective_Start(SOBJ_DCP_MinesOrDemo, false)
			
			Rule_AddDelayedInterval(Hint_Flamethrowers, 15, 1)
			Rule_AddDelayedInterval(Hint_guardLMGs, 30, 1)
			
			Rule_Add(DCP_Timer_EndCheck)
			_flashProgressBar(10)
			Rule_AddInterval(Achievement_PlaceTenMines, 1)
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
		Title = 11008200,				-- LOCDB [11008200] 'Time to prepare defenses'
		Description = 11008201,			-- LOCDB [11008201] ''
		TitleEnd = nil,				-- LOCDB [11007291] 'Village Held'
		TitleFail = nil,			-- LOCDB [11007292] 'Ridge Lost'
		Type = OT_Secondary,				-- Objective Type (OT_Primary, OT_Secondary)
	}
	
	Objective_Register(OBJ_DefendCapturePointsTIMER)
	
end

-- SUB-OBJECTIVE: Move squads into cover near the river
function Initialize_DCP_SquadsInCover()

	SOBJ_DCP_SquadsInCover = {
		
		Parent = OBJ_DefendCapturePointsTIMER,
		
		SetupUI = function() 
			
		end,
		
		OnStart = function()

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
		Title = 11035833,				-- LOCDB [11035833] 'Move squads into cover near the river'
		Description = 11035833,				-- LOCDB [11035833] 'Move squads into cover near the river'
		TitleEnd = nil,				
		TitleFail = nil,			
		Type = OT_Secondary,				-- Objective Type (OT_Primary, OT_Secondary)
	}
	
	Objective_Register(SOBJ_DCP_SquadsInCover)
	
end

-- SUB-OBJECTIVE: Place mines or demolition charges 
function Initialize_DCP_MinesOrDemo()

	SOBJ_DCP_MinesOrDemo = {
		
		Parent = OBJ_DefendCapturePointsTIMER,
		
		SetupUI = function() 
			
		end,
		
		OnStart = function()

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
		Title = 11035339,				-- LOCDB [11035339] 'Place mines or demolition charges'
		Description = 11035339,			-- LOCDB [11035339] 'Place mines or demolition charges'
		TitleEnd = nil,				
		TitleFail = nil,			
		Type = OT_Secondary,				-- Objective Type (OT_Primary, OT_Secondary)
	}
	
	Objective_Register(SOBJ_DCP_MinesOrDemo)
	
end

-- Difficulty Variation: EASY
-- Pause wave timers if player doesn't own all three territories
function HTV_Easy_TerritoryCheck()
	if (EGroup_IsCapturedByPlayer(eg_POS_B_Points, player1, ALL) == false) and (g_HTV_timersPaused == false) then
		g_HTV_timersPaused = true
		if Timer_Exists(tmr_VIL_wave2) and Timer_GetElapsed(tmr_VIL_wave2) < g_VIL_wave2 then
			Timer_Pause(tmr_VIL_wave2)
		elseif Timer_Exists(tmr_VIL_wave3) and Timer_GetElapsed(tmr_VIL_wave3) < g_VIL_wave3 then
			Timer_Pause(tmr_VIL_wave3)
		elseif Timer_Exists(tmr_VIL_wave4) and Timer_GetElapsed(tmr_VIL_wave4) < g_VIL_wave4 then
			Timer_Pause(tmr_VIL_wave4)
		elseif Timer_Exists(tmr_VIL_wave5) and Timer_GetElapsed(tmr_VIL_wave5) < g_VIL_wave5 then
			Timer_Pause(tmr_VIL_wave5)
		elseif Timer_Exists(tmr_VIL_wave6) and Timer_GetElapsed(tmr_VIL_wave6) < g_VIL_wave6 then
			Timer_Pause(tmr_VIL_wave6)
		end
	elseif EGroup_IsCapturedByPlayer(eg_POS_B_Points, player1, ALL)  and g_HTV_timersPaused then
		g_HTV_timersPaused = false
		if Timer_Exists(tmr_VIL_wave2) and Timer_IsPaused(tmr_VIL_wave2) then
			Timer_Resume(tmr_VIL_wave2)
		elseif Timer_Exists(tmr_VIL_wave3) and Timer_IsPaused(tmr_VIL_wave3) then
			Timer_Resume(tmr_VIL_wave3)
		elseif Timer_Exists(tmr_VIL_wave4) and Timer_IsPaused(tmr_VIL_wave4) then
			Timer_Resume(tmr_VIL_wave4)
		elseif Timer_Exists(tmr_VIL_wave5) and Timer_IsPaused(tmr_VIL_wave5) then
			Timer_Resume(tmr_VIL_wave5)
		elseif Timer_Exists(tmr_VIL_wave6) and Timer_IsPaused(tmr_VIL_wave6) then
			Timer_Resume(tmr_VIL_wave6)
		end
	end
	if Timer_Exists(tmr_VIL_wave7) then
		Rule_RemoveMe()
	end
end


---- HINT: Engineers can be upgraded with flamethrowers ----
function Hint_Flamethrowers()
	local check = function(gid, idx, sid)
		if Misc_IsPosOnScreen(Squad_GetPosition(sid), 1.0) then
			if Squad_GetSlotItemCount(sid) == 0 then
				sg_p_engineerHint = SGroup_CreateIfNotFound("sg_p_engineerHint")
				SGroup_Add(sg_p_engineerHint, sid)
				g_flameEngineerHintSquad = sid
				g_hint_flameEngineer = true
				hint_flamethrower = HintPoint_Add(sg_p_engineerHint, true, 11035341, nil, HPAT_Hint, "Icons_upgrades_icon_upgrade_soviet_flamethrower") -- LOCDB [11035341] 'Engineers can be upgraded with ROKS-3 flamethrowers'
				return true
			end
		end
	end
	if g_hint_flameEngineer == nil then
		SGroup_ForEach(sg_p_engineer, check)
	end
	if SGroup_Exists("sg_p_engineerHint") then
		if SGroup_IsEmpty(sg_p_engineerHint) then
			Rule_RemoveMe()
			if g_hint_flameEngineer then
				HintPoint_Remove(hint_flamethrower)
			end
		elseif SGroup_HasTeamWeapon(sg_p_engineerHint, ANY) or (SGroup_ContainsBlueprints(sg_p_engineerHint, SBP.SOVIET.COMBAT_ENGINEER_SQUAD, ANY) == false)  then
			Rule_RemoveMe()
			if g_hint_flameEngineer then
				HintPoint_Remove(hint_flamethrower)
			end
		elseif (g_flameEngineerHintSquad ~= nil) and (scartype(g_flameEngineerHintSquad) == ST_SQUAD) and Squad_IsValid(Squad_GetGameID(g_flameEngineerHintSquad)) then
			if (Squad_GetSlotItemCount(g_flameEngineerHintSquad) ~= 0) or (Squad_GetBlueprint(g_flameEngineerHintSquad) ~= SBP.SOVIET.COMBAT_ENGINEER_SQUAD)  then
				Rule_RemoveMe()
				if g_hint_flameEngineer then
					HintPoint_Remove(hint_flamethrower)
				end
			end
		else
			if SGroup_IsUpgrading(sg_p_engineer, UPG.SOVIET.ENGINEER_FLAMETHROWER, ANY) or SGroup_IsEmpty(sg_p_engineerHint) then
				Rule_RemoveMe()
				
				if g_hint_flameEngineer then
					HintPoint_Remove(hint_flamethrower)
				end
				
				if not SGroup_IsEmpty(sg_p_engineer) then
					sg_engineer_flame = SGroup_CreateIfNotFound("sg_engineer_flame")
					local f = function (gid, idx, sid)
						if Squad_IsUpgrading(sid, UPG.SOVIET.ENGINEER_FLAMETHROWER) then
							SGroup_Add(sg_engineer_flame, sid)
							SGroup_AddSlotItemToDropOnDeath(sg_engineer_flame, SLOT_ITEM.FLAMETHROWER_ROKS3_ITEM, 100, true)
							return true
						end
					end
					SGroup_ForEach(sg_p_engineer, f)
					if not SGroup_CountSpawned(sg_engineer_flame) == 0 then
						Event_GroupIsDead(onDeath_flamer, {pos = SGroup_GetPosition(sg_engineer_flame)}, sg_engineer_flame)
					end
				end
			end
		end
	end
end

-- Put a hintpoint on the first dropped Soviet flamethrower
onDeath_flamer = function(data)
	eg_flamethrower = EGroup_CreateIfNotFound("eg_flamethrower")
	World_GetNeutralEntitiesNearPoint(eg_flamethrower, data.pos, 100) 
	EGroup_Filter(eg_flamethrower, BP_GetEntityBlueprint("flamethrower_roks3"), FILTER_KEEP)
	if not EGroup_IsEmpty(eg_flamethrower) and g_hint_pickupFlamethrower == nil then
		hint_pickupFlamer = HintPoint_Add(eg_flamethrower, true, 11034201, nil, HPAT_Hint, "Icons_upgrades_icon_upgrade_soviet_flamethrower") -- "Flamethrower"
		g_hint_pickupFlamethrower = true
	end
end

-- Put a hintpoint on the first dropped German flamethrower
onDeath_flamerGerman = function(data)
	eg_flamethrowerGerman = EGroup_CreateIfNotFound("eg_flamethrowerGerman")
	World_GetNeutralEntitiesNearPoint(eg_flamethrowerGerman, data.pos, 100) 
	EGroup_Filter(eg_flamethrowerGerman, BP_GetEntityBlueprint("axis_flamethrower_item"), FILTER_KEEP)
	if not EGroup_IsEmpty(eg_flamethrowerGerman) and g_hint_pickupGermanFlamethrower == nil then
		local entity = EGroup_GetSpawnedEntityAt(eg_flamethrowerGerman, 1)
		hint_pickupFlamerGerman = HintPoint_Add(entity, true, 11034201, nil, HPAT_Hint, "Icons_upgrades_icon_upgrade_german_flamethrower") -- "Flamethrower"
		g_hint_pickupGermanFlamethrower = true
	end
	Event_Remove(eventID_germanFlamer)
	if not Rule_Exists(germanFlamer_callout) and not g_germanFlamerCallout then
		Rule_AddInterval(germanFlamer_callout, 1)
	end
end

germanFlamer_callout = function ()
	if EGroup_IsEmpty(eg_flamethrowerGerman) then
		Rule_RemoveMe()
	elseif Misc_IsPosOnScreen(Entity_GetPosition(EGroup_GetSpawnedEntityAt(eg_flamethrowerGerman, 1)), 1.0) then
		g_germanFlamerCallout = true
		Util_StartIntel(EVENTS.GermanFlamer1)
		Rule_RemoveMe()
	end
end

---- HINT: Guards can be upgraded with Light Machine Guns ----
function Hint_guardLMGs()
	local check = function(gid, idx, sid)
		if Misc_IsPosOnScreen(Squad_GetPosition(sid), 1.0) then
			if Squad_GetSlotItemCount(sid) == 0 then
				sg_p_guardHint = SGroup_CreateIfNotFound("sg_p_guardHint")
				SGroup_Add(sg_p_guardHint, sid)
				g_guardLMGHintSquad = sid
				hint_guardLMG = HintPoint_Add(sid, true, 11046547, nil, HPAT_Hint, "Icons_upgrades_icon_upgrade_soviet_dp28_lmg") -- LOCDB [11046547] 'Guards infantry can be upgraded with light machine guns.'
				return true
			end
		end
	end
	if hint_guardLMG == nil then
		SGroup_ForEach(sg_p_guard, check)
	end
	if SGroup_Exists("sg_p_guardHint") then
		if SGroup_IsEmpty(sg_p_guardHint) or (SGroup_ContainsBlueprints(sg_p_guardHint, SBP.SOVIET.GUARDS_TROOPS, ANY) == false) then
			if hint_guardLMG ~= nil then
				HintPoint_Remove(hint_guardLMG)
			end
			Rule_RemoveMe()
		elseif SGroup_IsUpgrading(sg_p_guard, UPG.SOVIET.GUARD_DP_28_LMG_PACKAGE, ANY) or SGroup_HasTeamWeapon(sg_p_guardHint, ANY) then 
			Rule_RemoveMe()
			if hint_guardLMG ~= nil then
				HintPoint_Remove(hint_guardLMG)
			end
		elseif (g_guardLMGHintSquad ~= nil) and (scartype(g_guardLMGHintSquad) == ST_SQUAD) and Squad_IsValid(Squad_GetGameID(g_guardLMGHintSquad)) then
			if (Squad_GetSlotItemCount(g_guardLMGHintSquad) ~= 0) or (Squad_GetBlueprint(g_guardLMGHintSquad) ~= SBP.SOVIET.GUARDS_TROOPS) then
				Rule_RemoveMe()
				if hint_guardLMG ~= nil then
					HintPoint_Remove(hint_guardLMG)
				end
			end
		end
	end
end

-- BONUS OBJECTIVE: Crew all ZIS-3 Anti-Tank Guns
function Initialize_PingATGuns()

	OBJ_PingATGuns = {

		SetupUI = function() 
			
		end,
		
		OnStart = function()
			if Entity_IsValid(g_at_01_id) then 
				if Player_OwnsEntity(player1, Entity_FromWorldID(g_at_01_id)) == false and Player_OwnsEntity(player2, Entity_FromWorldID(g_at_01_id)) == false then
					hpid_pingAT_01 = Objective_AddUIElements(OBJ_PingATGuns, Entity_FromWorldID(g_at_01_id), true, 11006973, true)
				end
			end
			if Entity_IsValid(g_at_02_id) then
				if Player_OwnsEntity(player1, Entity_FromWorldID(g_at_02_id)) == false and Player_OwnsEntity(player2, Entity_FromWorldID(g_at_02_id)) == false then
					hpid_pingAT_02 = Objective_AddUIElements(OBJ_PingATGuns, Entity_FromWorldID(g_at_02_id), true, 11006973, true)
				end
			end
			if Entity_IsValid(g_at_03_id) then 
				if Player_OwnsEntity(player1, Entity_FromWorldID(g_at_03_id)) == false and Player_OwnsEntity(player2, Entity_FromWorldID(g_at_03_id)) == false then 
					hpid_pingAT_03 = Objective_AddUIElements(OBJ_PingATGuns, Entity_FromWorldID(g_at_03_id), true, 11006973, true)
				end
			end
			
			Rule_AddDelayedInterval(OBJ_HTV_ClearATGuns, 10, 1)
			Timer_Start(101, 60)
		end,
		
		OnComplete = function()
			
		end,
		
		OnFail = function()
						
		end,
		
		IsComplete = function()
			return false
		end,
		
		Intel_Start = EVENTS.STUG_SPOTTED,				-- Event will play when obj starts but before any UI appears
		Intel_Complete = EVENTS.ATvsInfantry,			-- Event will play when obj completes but before UI is cleared
		Intel_Fail = nil,				-- Event will play when obj fails but before UI is cleared
		Title = 11035342, -- LOCDB [11035342] 'Crew the ZiS-3 anti-tank guns'
		Description = 11008201,			-- LOCDB [11008201] ''
		TitleEnd = nil,				-- LOCDB [11007291] 'Village Held'
		TitleFail = nil,			-- LOCDB [11007292] 'Ridge Lost'
		Type = OT_Secondary,				-- Objective Type (OT_Primary, OT_Secondary)
	}
	
	Objective_Register(OBJ_PingATGuns)
	
end

function DCP_Timer_StartCheck()
	
	Player_GetAllSquadsNearMarker(player1, sg_temp, mkr_RDG_check)
	if SGroup_IsEmpty(sg_temp) or SGroup_IsRetreating(sg_temp, ALL) then
		Rule_RemoveMe()
		
		Rule_RemoveIfExist(OBJ_HTR_Wave3_UpdateGoal)
		Rule_RemoveIfExist(OBJ_HTR_Maxims_Arrive)
		Rule_RemoveIfExist(Friendly_Arty_Salvo_Delayed)
		Rule_RemoveIfExist(Friendly_Arty_CeaseFire)
		Rule_RemoveIfExist(Friendly_Arty_CeaseFire_Delay)
		
		SGroup_SetInvulnerable(SGroup_FromName("sg_e_RDG_pnzrIII"), false)
		Rule_AddOneShot(DCP_ShowHQ1, 3)
		Rule_AddOneShot(DCP_ShowHQ2, 6)
		Rule_AddOneShot(DCP_ShowHQ3, 10)
		
	elseif g_fallbackArtyTimer == 5 then
		g_fallbackArtyTimer = 0
	end
	
	g_fallbackArtyTimer = g_fallbackArtyTimer + 1

end

-- Show the player his new base
function DCP_ShowHQ1()
	Game_Letterbox(true, 2)
	Game_FadeToBlack(FADE_OUT, 2)
	Rule_AddOneShot(DCP_Autosave, 2)
end

function DCP_Autosave()
	HTP_DeleteRidgeSquads()
	--- CHECKPOINT AUTOSAVE #1 ---
	Subtitle_EndCurrentSpeech()
	Util_Autosave(11049961, nil, true)	-- LOCDB [11049961] 'Mission 3 - Autosave 1'
	World_ClearCasualties()
end

function DCP_ShowHQ2()
	Sound_StopMusic(1, 0)
	__respawnCapturedWeapons()
	Player_SetPopCapOverride(player1, 100)	
	EGroup_SetPlayerOwner(eg_p_baseBuildings, player1)
	EGroup_ReSpawn(eg_germanMines)
	UI_StopFlashing(flashID_retreat)
	Camera_ResetToDefault()
	Camera_MoveTo(mkr_lookAt_base, false)
	Game_FadeToBlack(FADE_IN, 2)
	sg_p_engineer = SGroup_CreateIfNotFound("sg_p_engineer")
	Util_CreateSquads(player3, sg_p_engineer, SBP.SOVIET.COMBAT_ENGINEER_SQUAD, mkr_p_engineer01_spawn, mkr_p_engineer01_dest)
	Util_CreateSquads(player3, sg_p_engineer, SBP.SOVIET.COMBAT_ENGINEER_SQUAD, mkr_p_engineer02_spawn, mkr_p_engineer02_dest)
	Util_CreateSquads(player3, sg_p_engineer, SBP.SOVIET.COMBAT_ENGINEER_SQUAD, mkr_p_engineer03_spawn)
	
	sg_p_hmg = SGroup_CreateIfNotFound("sg_p_hmg")
	Util_CreateSquads(player3, sg_p_hmg, SBP.SOVIET.M1910_MAXIM_HEAVY_MACHINE_GUN_SQUAD, mkr_p_VIL_hmg01)
	Util_CreateSquads(player3, sg_p_hmg, SBP.SOVIET.M1910_MAXIM_HEAVY_MACHINE_GUN_SQUAD, mkr_p_VIL_hmg02)
	Util_CreateSquads(player3, sg_p_hmg, SBP.SOVIET.M1910_MAXIM_HEAVY_MACHINE_GUN_SQUAD, mkr_p_VIL_hmg03)
	
	sg_p_guard = SGroup_CreateIfNotFound("sg_p_guard")
	Util_CreateSquads(player3, sg_p_guard, SBP.SOVIET.GUARDS_TROOPS, mkr_p_guardSpawn3, mkr_p_guardDest3)
	Util_CreateSquads(player3, sg_p_guard, SBP.SOVIET.GUARDS_TROOPS, mkr_p_guardSpawn2, mkr_p_guardDest2)
	Util_CreateSquads(player3, sg_p_guard, SBP.SOVIET.GUARDS_TROOPS, mkr_p_guardSpawn1, mkr_p_guardDest1)
	Player_SetUpgradeAvailability(player1, UPG.SOVIET.PTRS_41_AT_RIFLE_PACKAGE_GUARD_TROOP, ITEM_REMOVED)
	
	Rule_AddInterval(HTP_UpdateMusic_01, 1)
	
	hintID_base = HintPoint_Add(mkr_baseHint, true, 11046252) -- LOCDB [11046252] 'Select base buildings to produce new squads'
	
	Modifier_Remove(modID_manpowerCap)
	modID_manpowerCap = Modify_PlayerResourceCap(player1, RT_Manpower, 1001, MUT_Addition)
	Modifier_Remove(modID_manpowerRate)
	modID_manpowerRate = Modify_PlayerResourceRate(player1, RT_Manpower, t_difficulty.resourceRate_Manpower)
	Player_SetConstructionMenuAvailability(player1, "tp_construction_soviet_engineer", ITEM_REMOVED)
	Player_SetResource(player1, RT_Manpower, t_difficulty.startingRes_Manpower)
end

function DCP_ShowHQ3()
	Util_StartIntel(EVENTS.ENGINEERS)
	Sound_PlayMusic("streamed/music/missions/m03/m03_cue_setup_defenses", 5, 5)
	SGroup_SetPlayerOwner(sg_p_guard, player1)
	SGroup_SetPlayerOwner(sg_p_engineer, player1)
	SGroup_SetPlayerOwner(sg_p_hmg, player1)
	Misc_SelectSquad(SGroup_GetSpawnedSquadAt(sg_p_engineer, 1), true)
	
	EventCue_Create(CUE.MAP, 11008202, 11008202, sg_p_engineer)	-- LOCDB [11008202] 'Engineers available'
	Game_Letterbox(false, 3)
	Camera_SetInputEnabled(true)
	
	
	if Player_GetResource(player1, RT_Manpower) < 360 then
		Player_SetResource(player1, RT_Manpower, 360)
	end
	
	eg_guardProducer = EGroup_CreateIfNotFound("eg_guardProducer")
	EGroup_AddEGroup(eg_guardProducer, eg_p_baseBuildings)
	EGroup_Filter(eg_guardProducer, EBP.SOVIET.BARRACKS, FILTER_KEEP)
	Misc_SelectEntity(EGroup_GetRandomSpawnedEntity(eg_guardProducer))
	UI_FlashProductionButton(PITEM_Spawn, SBP.SOVIET.GUARDS_TROOPS, true)
	
	EGroup_DestroyAllEntities(eg_retreatPoint)
	EGroup_Destroy(eg_retreatPoint)

	Objective_UpdateText(OBJ_HoldTheVillage, 11035337, 11008197)
	
	HintMouseover_Add(11046584, mkr_e_detpack_hint01, 15, false) -- LOCDB [11035339] 'Place mines or demolition charges'
	HintMouseover_Add(11046584, mkr_e_detpack_hint02, 15, false) -- LOCDB [11046584] 'Use AT guns and grenades to break ice beneath enemies'
	HintMouseover_Add(11035339, mkr_e_detpack_hint03, 15, false)
	HintMouseover_Add(11035339, mkr_e_detpack_hint04, 15, false)
	HintMouseover_Add(11046584, mkr_e_detpack_hint05, 15, false)	
	
	--grant guard troops
	Player_CompleteUpgrade(player1, UPG.SOVIET.GUARD_TROOPS) 
	Player_SetAbilityAvailability(player1, BP_GetAbilityBlueprint("cmd_guard_troops"), ITEM_REMOVED)
	Player_SetSquadProductionAvailability(player1, SBP.SOVIET.GUARDS_TROOPS, ITEM_UNLOCKED)
		
	Rule_AddOneShot(_addBaseHints, 10)
	
	Modify_PlayerResourceCap(player1, RT_Manpower, 2001, MUT_Addition)
	
	-- Fail/Loss Condition: The player's HQ is destroyed
	Rule_AddInterval(Loss_NoHQ, 3)

end

-- HINTS: Use these base buildings
function _addBaseHints()
	hintID_hq = HintPoint_Add(EGroup_GetSpawnedEntityAt(eg_hq, 1), true, 11047654, nil, HPAT_Hint, "Icons_units_unit_soviet_engineer") -- LOCDB [11047654] 'Combat Engineers deployed here'
	hintID_shootingRange = HintPoint_Add(EGroup_GetSpawnedEntityAt(eg_p_baseBuildings, 2), true, 11047655, nil, HPAT_Hint, "Icons_units_unit_soviet_mg") -- LOCDB [11047655] 'Maxim HMGs deployed here'
	hintID_lightFactory = HintPoint_Add(EGroup_GetSpawnedEntityAt(eg_p_baseBuildings, 3), true, 11047656, nil, HPAT_Hint, "Icons_units_unit_soviet_guards") -- LOCDB [11047656] 'Guards Rifle Infantry deployed here'
	if EGroup_Count(eg_germanWeapons) > 1 then 
		hintID_germanWeapons = HintPoint_Add(eg_germanWeapons, true, 11045370, nil, HPAT_Hint) -- LOCDB [11045370] 'German weapons recovered from the ridge'
	end
	HintPoint_Remove(hintID_base)
	Rule_AddDelayedInterval(_removeBaseHints, 15, 1)
end

function _removeBaseHints()
	if Misc_IsEGroupSelected(eg_p_baseBuildings, ANY) then
		HintPoint_Remove(hintID_hq)
		HintPoint_Remove(hintID_shootingRange)
		HintPoint_Remove(hintID_lightFactory)
		HintPoint_Remove(hintID_germanWeapons)
		Rule_RemoveMe()
	end
end

-- Objective Timer: Set up defenses in the village
function DCP_Timer_EndCheck()
	
	local currentTime = Objective_GetTimerSeconds(OBJ_DefendCapturePointsTIMER)
	Obj_ShowProgress(11035343, (currentTime/t_difficulty.vil_start_time)) -- LOCDB [11035343] 'Time left...'
	if currentTime <= 105 and g_guardLMGReminder == nil then
		g_guardLMGReminder = true
		local player1Squads = Player_GetSquads(player1)
		SGroup_Filter(player1Squads, SBP.SOVIET.GUARDS_TROOPS, FILTER_KEEP)
		if not SGroup_IsEmpty(player1Squads) then
			if not SGroup_HasUpgrade(player1Squads, UPG.SOVIET.GUARD_DP_28_LMG_PACKAGE, ANY) and not SGroup_IsUpgrading(player1Squads, UPG.SOVIET.GUARD_DP_28_LMG_PACKAGE, ANY) then
				Util_StartIntel(EVENTS.GUARD_LMG)
			end
		end
	elseif currentTime <= 30 and g_attackWarning == false then
		g_attackWarning = true
		
		if hint_flamethrower ~= nil then
			HintPoint_Remove(hint_flamethrower)
		end
		
		if hint_guardLMG ~= nil then
			HintPoint_Remove(hint_guardLMG)
		end
		
		if hintID_germanWeapons ~= nil then
			HintPoint_Remove(hintID_germanWeapons)
		end
		_flashProgressBar(10)
		Util_StartIntel(EVENTS.GERMANS_ALMOST_HERE)
	elseif currentTime <= 0 then
		Rule_RemoveMe()
		Rule_RemoveIfExist(Achievement_PlaceTenMines)
		
		g_friendlyArtyComplete = true
		
		Obj_HideProgress()
		Sound_StopMusic(CAMPAIGN_MUSIC_FADEOUT, 5)
		Rule_AddOneShot(OBJ_HTV_Probe, 10)
		
		Objective_Complete(OBJ_DefendCapturePointsTIMER, false)
		Objective_Complete(SOBJ_DCP_SquadsInCover, false)
		Objective_Complete(SOBJ_DCP_MinesOrDemo, false)
	end

end

function __respawnCapturedWeapons()
	eg_germanWeapons = EGroup_CreateIfNotFound("eg_germanWeapons")
	if g_playerFlamerCount > 0 then
		for i = 1, math.min(g_playerFlamerCount, 3) do 
			local marker = Marker_FromName("mkr_flamerRespawn" .. i, "")
			Util_CreateEntities(nil, eg_germanWeapons, BP_GetEntityBlueprint("axis_flamethrower_item"), marker, 1)
		end
	end
	if g_playerLmgCount > 0 then
		for i = 1, math.min(g_playerLmgCount, 3) do 
			local marker = Marker_FromName("mkr_lmgRespawn" .. i, "")
			Util_CreateEntities(nil, eg_germanWeapons, BP_GetEntityBlueprint("axis_mg42"), marker, 1)
		end
	end
	if g_playerMortarCount > 0 then
		for i = 1, math.min(g_playerMortarCount, 3) do 
			local marker = Marker_FromName("mkr_mortarRespawn" .. i, "")
			Util_CreateEntities(nil, eg_germanWeapons, EBP.GERMAN.GRANATEWERFER_34_81MM_MORTAR, marker, 1)
		end
	end
	if EGroup_Count(eg_germanWeapons) >= 3 then
		Achievement_EnemyWeaponsCaptured()
	end
end
	
----------------
-- Hold the Village -- Enemy attack waves
-- Probe attack is first
----------------
function OBJ_HTV_Probe()
	Sound_PlayMusic("streamed/music/missions/m03/m03_cue_defend_village", 0, 0)
	EGroup_InstantCaptureStrategicPoint(eg_POS_A_Points_01, player2)
	EGroup_InstantCaptureStrategicPoint(eg_POS_A_Points_02, player2)
	EGroup_InstantCaptureStrategicPoint(eg_POS_A_Points_03, player2)
	
	local encData = {
		name = "wave4bCenter",
		player = player2,
		dynamicSpawnTarget = mkr_e_VIL_leftDynSpawn,
		spawn = mkr_e_RDG_leftSpawn_01,
		sgroups = {SGroup_CreateIfNotFound("sg_e_VIL_probe")},
		units = {
			{
				name = "wave4bCenter-4",
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = mkr_e_RDG_leftForestSpawn_01,
			},
			{
				name = "wave4bCenter-4",
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
			},
		},
		onDeath = nil,
	}
	encID_vil_probe01 = Encounter:Create(encData)
	
	local attackData = {
		name = "Attack",
		target = mkr_e_VIL_leftTar_01,
		useSkirmishAI = g_useSkirmishAI,
		
		attackMove = true,
		safeMoveWeight = 0,
	}
	encID_vil_probe01:SetGoal(attackData)
	
	local encData = {
		name = "wave4bCenter",
		player = player2,
		dynamicSpawnTarget = mkr_e_VIL_midDynSpawn,
		spawn = mkr_e_RDG_midSpawn_01,
		sgroups = {SGroup_CreateIfNotFound("sg_e_VIL_probe")},
		units = {
			{
				name = "wave4bCenter-4",
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = mkr_e_RDG_rightForestSpawn_01,
			},
			{
				name = "wave4bCenter-4",
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
			},
		},
		onDeath = nil,
	}
	encID_vil_probe02 = Encounter:Create(encData)
	
	local attackData = {
		name = "Attack",
		target = mkr_e_VIL_midTar_01,
		useSkirmishAI = g_useSkirmishAI,
		
		attackMove = true,
		safeMoveWeight = 0,
	}
	encID_vil_probe02:SetGoal(attackData)
	
	local encData = {
		name = "wave4bCenter",
		player = player2,
		dynamicSpawnTarget = mkr_e_VIL_rightDynSpawn,
		spawn = mkr_e_RDG_rightSpawn_01,
		sgroups = {SGroup_CreateIfNotFound("sg_e_VIL_probe")},
		units = {
			{
				name = "wave4bCenter-4",
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = mkr_e_RDG_leftForestSpawn_01,
			},
			{
				name = "wave4bCenter-4",
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
			},
		},
		onDeath = nil,
	}
	encID_vil_probe03 = Encounter:Create(encData)
	
	local attackData = {
		name = "Attack",
		target = mkr_e_VIL_rightTar_01,
		useSkirmishAI = g_useSkirmishAI,
		
		attackMove = true,
		safeMoveWeight = 0,
	}
	encID_vil_probe03:SetGoal(attackData)
	
	Rule_AddInterval(OBJ_HTV_Probe_Spotted, 1)
	
	Rule_AddInterval(OBJ_HTV_Probe_End_Check, 1)
	
end

function OBJ_HTV_Probe_Spotted()

	if Player_CanSeeSGroup(player1, SGroup_FromName("sg_e_VIL_probe"), ANY) then
		Rule_RemoveMe()
		
		Util_StartIntel(EVENTS.RECON_SPOTTED)
		
		-- Remove "suggested demolition" hints
		if _HintMouseOver ~= nil then
			for i = table.getn(_HintMouseOver), 1, -1 do
				local this = _HintMouseOver[i]
				if this.activehint ~= nil then
					HintPoint_Remove(this.activehint)
				end
				table.remove(_HintMouseOver, i)
			end
		end
	end

end

function OBJ_HTV_Probe_End_Check()

	if SGroup_TotalMembersCount(SGroup_FromName("sg_e_VIL_probe")) <= 16 then
		Rule_RemoveMe()
		
		local __probeFallback = function(gid, idx, sid)
			SGroup_Clear(sg_temp)
			SGroup_Add(sg_temp, sid)
			Cmd_Retreat(sg_temp, Util_GetClosestMarker(sg_temp, {mkr_e_retreat_01, mkr_e_retreat_02, mkr_e_retreat_03}), Util_GetClosestMarker(sg_temp, {mkr_e_retreat_01, mkr_e_retreat_02, mkr_e_retreat_03}))
		end
		
		SGroup_ForEach(SGroup_FromName("sg_e_VIL_probe"), __probeFallback)
		
		Rule_AddOneShot(OBJ_HTV_Prove_End_Speech, 1.5)
	end
	
end

function OBJ_HTV_Prove_End_Speech()

	Util_StartIntel(EVENTS.RECON_ATTACK)
	Rule_AddDelayedInterval(DCP_InitAttacks, 15, 1)

end

------------------------
-- Hold the Village
-- Start attacks on the village
------------------------
function DCP_InitAttacks()
	
	if Event_IsAnyRunning() == false then
		Rule_RemoveMe()
		
		__t_ambient.phase = 2
		
		__t_ambient.active = true
		
		Rule_AddOneShot(OBJ_HTV_Wave1, 10)
		
	end
	
end


----------------
-- Hold the Village
-- "Organized Defense"
----------------
--**Wave1**--
function OBJ_HTV_Wave1()
	Player_SetAbilityAvailability(player2, BP_GetAbilityBlueprint("panzer_grenadier_bundled_campaign"), ITEM_LOCKED)
	Rule_AddInterval(PG_BundledGrenadeToggle, 1)
	-- First, determine which lanes are still open and fire off spawn functions
	if g_midPointOwner == player1 then
		-- Spawn Main force
		local encData = {
			name = "Wave1_Left",
			player = player2,
			dynamicSpawnTarget = mkr_e_VIL_midTar_01,
			spawn = mkr_e_RDG_midSpawn_01,
			sgroups = {SGroup_CreateIfNotFound("sg_e_VIL_wave1"), SGroup_CreateIfNotFound("sg_e_VIL_wave1_mid")},
			units = {
				{
					name = "Wave1_Left_A",
					sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
				},
				{
					name = "Wave1_Left_B",
					sbp = SBP.GERMAN.GRENADIER_SQUAD,
				},
			},
		}
		encID_wave1Mid = Encounter:Create(encData)
		
		local goalData = {
			name = "Attack",
			target = mkr_e_VIL_midTar_01,
			useSkirmishAI = g_useSkirmishAI,
			
			attackMove = true,
			safeMoveWeight = 0.3,
			onSuccess = HTV_UpdateGoal_Defend,
			movePathLengthFactor = 1.5,
			
			abilityControlsList = {
				{
					abilityPBG = ABILITY.GERMAN.PANZER_GRENADIER_BUNDLED_CAMPAIGN,
					maxCasters = 1,
					maxRange = 50,
					waitTimeSecs = 30,
				},
			},
		}
		encID_wave1Mid:SetGoal(goalData)
		
		-- Spawn Any Delayed
		Rule_AddOneShot(OBJ_HTV_Wave1_Mid_Delay, 8)
		
		g_spawnMid = false
	end
	
	Timer_Start(tmr_VIL_wave2, g_VIL_wave2)
	
	-- Fire off any remaining functions (monitor)
	Rule_AddInterval(OBJ_HTV_Wave1_Finished, 1)
	
end

function OBJ_HTV_Wave1_Mid_Delay()
	-- First, determine which lanes are still open and fire off spawn functions
	if g_midPointOwner == player1 then
		-- Setup Unit Table
		local t01 = {
			name = "Wave1_Left_A_Flankers",
			sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
			dynamicSpawnTarget = mkr_e_VIL_midTar_01,
			spawn = mkr_e_RDG_leftSpawn_01,
			sgroups = {SGroup_CreateIfNotFound("sg_e_VIL_wave1"), SGroup_CreateIfNotFound("sg_e_VIL_wave1_mid"), SGroup_CreateIfNotFound("sg_e_VIL_wave1_mid_pg")},
		}
		if encID_wave1Mid:IsAlive() then
			encID_wave1Mid:AddUnit(t01)
		end
		
		local t01 = {
			name = "Wave1_Left_A_Flankers",
			sbp = SBP.GERMAN.GRENADIER_SQUAD,
			dynamicSpawnTarget = mkr_e_VIL_midTar_01,
			spawn = mkr_e_RDG_rightSpawn_01,
			sgroups = {SGroup_CreateIfNotFound("sg_e_VIL_wave1"), SGroup_CreateIfNotFound("sg_e_VIL_wave1_mid")},
		}
		if encID_wave1Mid:IsAlive() then
			encID_wave1Mid:AddUnit(t01)
		end
		
		-- Set new Goal
		local attackData = {
			name = "Attack",
			target = mkr_e_VIL_midTar_01,
			useSkirmishAI = g_useSkirmishAI,
			
			tacticTargetPreference = AITacticTargetPreference_Near,
			movePathLengthFactor = 1.5,
			
			attackMove = true,
			safeMoveWeight = 0.3,
			
			onSuccess = HTV_UpdateGoal_Defend,
			
			fallback = true,
			fallbackParams = {
				thresholds = {0.5},
				thresholdType = Threshold_PercentageEntitiesRemaining,
				markers = {mkr_e_retreat_02},
				retreat = true,
				retreatDespawn = true,
			},
		}
		encID_wave1Mid:SetGoal(attackData)
		
		Rule_AddInterval(OBJ_HTV_Wave1_Spotted, 1)
	end

end

function OBJ_HTV_Wave1_Spotted()
	
	if Player_CanSeeSGroup(player1, SGroup_FromName("sg_e_VIL_wave1_mid"), ANY) then
		Rule_RemoveMe()
		
		local event = Table_GetRandomItem(t_events.RDG_Mid_Incoming)
		
		Util_StartIntel(event)
	end

end

function OBJ_HTV_Wave1_Finished()

	if (Player_OwnsEGroup(player1, eg_POS_B_Points_02) == false or SGroup_Exists("sg_e_VIL_wave1_mid") == false) or ((SGroup_IsEmpty(SGroup_FromName("sg_e_VIL_wave1_mid")) or SGroup_IsRetreating(SGroup_FromName("sg_e_VIL_wave1_mid"), ALL)))
	  or Timer_GetRemaining(tmr_VIL_wave2) <= 0 then
		Rule_RemoveMe()

		Ambient_Attacks_RestartLane("sg_e_midAmb")
		
		Rule_AddOneShot(OBJ_HTV_Wave2, 5)
		
		-- DEV
		g_dev_vil_wave2 = Timer_GetRemaining(tmr_VIL_wave2)
	end

end
--**Wave2**--
function OBJ_HTV_Wave2()
	
	-- First, determine which lanes are still open and fire off spawn functions
	if g_leftPointOwner == player1 then
		-- Spawn Main force
		local encData = {
			name = "Wave1_Left",
			player = player2,
			dynamicSpawnTarget = mkr_e_VIL_leftTar_01,
			spawn = mkr_e_RDG_leftSpawn_01,
			sgroups = {SGroup_CreateIfNotFound("sg_e_VIL_wave2"), SGroup_CreateIfNotFound("sg_e_VIL_wave2_left")},
			units = {
				{
					name = "Wave1_Left_B",
					sbp = SBP.GERMAN.GRENADIER_SQUAD,
				},
				{
					name = "Wave1_Left_B",
					sbp = SBP.GERMAN.GRENADIER_SQUAD,
				},
			},
		}
		encID_wave2Left = Encounter:Create(encData)
		
		local goalData = {
			name = "Attack",
			target = mkr_e_VIL_leftTar_01,
			useSkirmishAI = g_useSkirmishAI,
			movePathLengthFactor = 1.5,
			
			attackMove = true,
			safeMoveWeight = 0,
			onSuccess = HTV_UpdateGoal_Defend,
		}
		encID_wave2Left:SetGoal(goalData)
		
		-- Spawn Any Delayed
		Rule_AddDelayedInterval(OBJ_HTV_Wave2_Left_Delay, 8, 1)
		
		-- Spotted
		Rule_AddInterval(OBJ_HTV_Wave2_Spotted, 1)
		
		g_spawnLeft = false
	end
	
	Timer_Start(tmr_VIL_wave3, g_VIL_wave3)
	
	-- Fire off any remaining functions (monitor)
	Rule_AddInterval(OBJ_HTV_Wave2_Finished, 1)
	
end

function OBJ_HTV_Wave2_Spotted()
	
	if Player_CanSeeSGroup(player1, SGroup_FromName("sg_e_VIL_wave2_left"), ANY) then
		Rule_RemoveMe()
		
		local event = Table_GetRandomItem(t_events.RDG_Left_Incoming)
		
		Util_StartIntel(event)
		
		
	end

end

function OBJ_HTV_Wave2_Left_Delay()
	
	if Event_IsAnyRunning() == false then
		Rule_RemoveMe()
			
		-- First, determine which lanes are still open and fire off spawn functions
		if g_midPointOwner == player1 then
			-- Setup Unit Table
			local t01 = {
				name = "Wave1_Left_A_Flankers",
				sbp = SBP.GERMAN.STUG_III_E_SQUAD,
				dynamicSpawnTarget = mkr_e_VIL_leftTar_01,
				spawn = mkr_e_RDG_leftSpawn_01,
				sgroups = {SGroup_CreateIfNotFound("sg_e_VIL_wave2"), SGroup_CreateIfNotFound("sg_e_VIL_wave2_left"), SGroup_CreateIfNotFound("sg_e_VIL_wave2_left_tank")},
			}
			if encID_wave2Left:IsAlive() then
				encID_wave2Left:AddUnit(t01)
			end
			
			local t01 = {
				name = "Wave1_Left_A_Flankers",
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				dynamicSpawnTarget = mkr_e_VIL_leftTar_01,
				spawn = mkr_e_RDG_leftSpawn_01,
				sgroups = {SGroup_CreateIfNotFound("sg_e_VIL_wave2"), SGroup_CreateIfNotFound("sg_e_VIL_wave2_left")},
			}
			if encID_wave2Left:IsAlive() then
				encID_wave2Left:AddUnit(t01)
			end
			
			-- Set new Goal
			local attackData = {
				name = "Attack",
				target = mkr_e_VIL_leftTar_01,
				useSkirmishAI = g_useSkirmishAI,
				attackMove = true,
				safeMoveWeight = 0,
				tacticControlsList = g_disableVehicleTactic,
				tacticTargetPreference = AITacticTargetPreference_Near,
				onSuccess = HTV_UpdateGoal_Defend,
				movePathLengthFactor = 1.5,
				fallback = true,
				fallbackParams = {
					thresholds = {0.05},
					thresholdType = Threshold_PercentageEntitiesRemaining,
					markers = {mkr_e_retreat_01},
					retreat = true,
					retreatDespawn = true,
				},
			}
			encID_wave2Left:SetGoal(attackData)
			
			Rule_AddInterval(OBJ_HTV_Wave2_Tank_Spotted, 1)
		end
	end

end

function OBJ_HTV_Wave2_Tank_Spotted()
	
	if Player_CanSeeSGroup(player1, SGroup_FromName("sg_e_VIL_wave2_left_tank"), ANY) then
		Rule_RemoveMe()
		
		if (Entity_IsValid(g_at_01_id) and Player_OwnsEntity(player1, Entity_FromWorldID(g_at_01_id)) == false) or 
		   (Entity_IsValid(g_at_02_id) and Player_OwnsEntity(player1, Entity_FromWorldID(g_at_02_id))== false) or 
		    (Entity_IsValid(g_at_03_id) and Player_OwnsEntity(player1, Entity_FromWorldID(g_at_03_id))== false) then
			Objective_Start(OBJ_PingATGuns)
			flashID_atGunObj = UI_FlashObjectiveIcon(OBJ_PingATGuns.ID, true)
		else
			Util_StartIntel(EVENTS.STUG_SPOTTED)
			Util_StartIntel(EVENTS.ICE_COMMENT_02)
		end
		Player_SetAbilityAvailability(player1, ABILITY.SOVIET.ML_20_152MM_BARRAGE_ABILITY, ITEM_UNLOCKED)
		if Player_GetResource(player1, RT_Munition) < 60 then
			Player_SetResource(player1, RT_Munition, 60)
		end
		flashID_zis = UI_FlashAbilityButton(ABILITY.SOVIET.AT_76MM_HE_BARRAGE_ABILITY, true)
		ThreatArrow_CreateGroup(SGroup_FromName("sg_e_VIL_wave2_left_tank"))
	end

end
function OBJ_HTV_ClearATGuns()

	--- Remove AT gun hints when weapons are crewed
	if Entity_IsValid(g_at_01_id) then
		if Player_OwnsEntity(player1, Entity_FromWorldID(g_at_01_id)) and (hpid_pingAT_01 ~= nil) then
			Objective_RemoveUIElements(OBJ_PingATGuns, hpid_pingAT_01)
			hpid_pingAT_01 = nil
		end
	end
	if Entity_IsValid(g_at_02_id) then
		if Player_OwnsEntity(player1, Entity_FromWorldID(g_at_02_id)) and (hpid_pingAT_02 ~= nil) then
			Objective_RemoveUIElements(OBJ_PingATGuns, hpid_pingAT_02)
			hpid_pingAT_02 = nil
		end
	end
	if Entity_IsValid(g_at_03_id) then
		if Player_OwnsEntity(player1, Entity_FromWorldID(g_at_03_id)) and (hpid_pingAT_03 ~= nil) then
			Objective_RemoveUIElements(OBJ_PingATGuns, hpid_pingAT_03)
			hpid_pingAT_03 = nil
		end
	end
	-- Complete AT-gun objective when all weapons are crewed
	if (hpid_pingAT_01 == nil) and (hpid_pingAT_02 == nil) and (hpid_pingAT_03 == nil) then
		Rule_RemoveMe()
		UI_StopFlashing(flashID_atGunObj)
		Objective_Complete(OBJ_PingATGuns, false)
	elseif not g_atgunRemind then 
		if Timer_Exists(101) and Timer_GetElapsed(101) > 45 then
			g_atgunRemind = true
			Util_StartIntel(EVENTS.ATGUN_REMINDER)
		end
		
	end
	
end

function OBJ_HTV_Wave2_Finished()

	if (Player_OwnsEGroup(player1, eg_POS_B_Points_01) == false or SGroup_Exists("sg_e_VIL_wave2_left") == false) or ((SGroup_IsEmpty(SGroup_FromName("sg_e_VIL_wave2_left")) or SGroup_IsRetreating(SGroup_FromName("sg_e_VIL_wave2_left"), ALL)))
	  or Timer_GetRemaining(tmr_VIL_wave3) <= 0 then
		Rule_RemoveMe()
		
		Ambient_Attacks_RestartLane("sg_e_leftAmb")
		
		Rule_AddOneShot(OBJ_HTV_Wave3, 5)
		
		-- DEV
		g_dev_vil_wave3 = Timer_GetRemaining(tmr_VIL_wave3)
	end

end
--**Wave3**--
function OBJ_HTV_Wave3()
	
	-- First, determine which lanes are still open and fire off spawn functions
	if g_midPointOwner == player1 then
		-- Spawn Main force
		local encData = {
			name = "Wave1_Left",
			player = player2,
			dynamicSpawnTarget = mkr_e_VIL_midTar_01,
			spawn = mkr_e_RDG_midSpawn_01,
			sgroups = {SGroup_CreateIfNotFound("sg_e_VIL_wave3"), SGroup_CreateIfNotFound("sg_e_VIL_wave3_mid")},
			units = {
				{
					name = "Wave1_Left_B",
					sbp = SBP.GERMAN.SCOUTCAR_SDKFZ222,
				},
				{
					name = "Wave1_Left_B",
					sbp = SBP.GERMAN.STUG_III_E_SQUAD,
					sgroups = {SGroup_CreateIfNotFound("sg_e_VIL_wave3_mid_tank")},
				},
				{
					name = "Wave1_Left_B",
					sbp = SBP.GERMAN.GRENADIER_SQUAD,
					spawn = mkr_e_RDG_leftSpawn_01,
				},
			},
		}
		encID_wave3Mid = Encounter:Create(encData)
		
		local goalData = {
			name = "Attack",
			target = mkr_e_VIL_midTar_01,
			tacticControlsList = g_disableVehicleTactic,
			movePathLengthFactor = 1.5,
			useSkirmishAI = g_useSkirmishAI,
			attackMove = true,
			safeMoveWeight = 0.2,
			onSuccess = HTV_UpdateGoal_Defend,
		}
		encID_wave3Mid:SetGoal(goalData)
		
		-- Spawn Any Delayed
		Rule_AddOneShot(OBJ_HTV_Wave3_Mid_Delay, 15)
		
		g_spawnMid = false
		
		-- Spotted
		Rule_AddInterval(OBJ_HTV_Wave3_Spotted, 1)
	end
	
end

function OBJ_HTV_Wave3_Spotted()
	
	if Player_CanSeeSGroup(player1, SGroup_FromName("sg_e_VIL_wave3_mid"), ANY) then
		Rule_RemoveMe()
		
		ThreatArrow_CreateGroup(SGroup_FromName("sg_e_VIL_wave3_mid_tank"))
		
		local event = Table_GetRandomItem(t_events.RDG_Mid_Incoming)
		
		Util_StartIntel(event)
	end

end


function OBJ_HTV_Wave3_Mid_Delay()
	
	-- First, determine which lanes are still open and fire off spawn functions
	if g_midPointOwner == player1 then
		local t01 = {
			name = "Wave1_Left_A_Flankers",
			sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
			dynamicSpawnTarget = mkr_e_VIL_leftTar_01,
			spawn = mkr_e_RDG_leftSpawn_01,
			sgroups = {SGroup_CreateIfNotFound("sg_e_VIL_wave2"), SGroup_CreateIfNotFound("sg_e_VIL_wave2_left")},
		}
		if encID_wave3Mid:IsAlive() then
			encID_wave3Mid:AddUnit(t01)
		end
		
		local goalData = {
			name = "Attack",
			target = mkr_e_VIL_midTar_01,
			useSkirmishAI = g_useSkirmishAI,
			movePathLengthFactor = 1.5,
			tacticControlsList = g_disableVehicleTactic,
			attackMove = true,
			safeMoveWeight = 0.3,
			
			onSuccess = HTV_UpdateGoal_Defend,
			
			fallback = true,
			fallbackParams = {
				thresholds = {0.05},
				thresholdType = Threshold_PercentageEntitiesRemaining,
				markers = {mkr_e_retreat_02},
				retreat = true,
				retreatDespawn = true,
			},
			
			abilityControlsList = {
				{
					abilityPBG = ABILITY.GERMAN.PANZER_GRENADIER_BUNDLED_CAMPAIGN,
					maxCasters = 1,
					maxRange = 50,
					waitTimeSecs = 30,
				},
			},
		}
		encID_wave3Mid:SetGoal(goalData)
	end
	
	Timer_Start(tmr_VIL_wave4, g_VIL_wave4)
	
	Rule_AddInterval(OBJ_HTV_Wave3_Finished, 1)

end

function OBJ_HTV_Wave3_Right_Spotted()
	
	if Player_CanSeeSGroup(player1, SGroup_FromName("sg_e_VIL_wave3_right"), ANY) then
		Rule_RemoveMe()
		
		local event = Table_GetRandomItem(t_events.RDG_Right_Incoming)
		
		Util_StartIntel(event)
	end

end

function OBJ_HTV_Wave3_Finished()
	
	if (Player_OwnsEGroup(player1, eg_POS_B_Points_02) == false or SGroup_Exists("sg_e_VIL_wave3_mid") == false) or ((SGroup_IsEmpty(SGroup_FromName("sg_e_VIL_wave3_mid")) or SGroup_IsRetreating(SGroup_FromName("sg_e_VIL_wave3_mid"), ALL)))
	  or Timer_GetRemaining(tmr_VIL_wave4) <= 0 then
		Rule_RemoveMe()
		
		Ambient_Attacks_RestartLane("sg_e_leftAmb")
		Ambient_Attacks_RetreatAndHold()
		
		__t_ambient.phase = 3
		
		if SGroup_IsEmpty(SGroup_FromName("sg_e_VIL_wave3_mid")) == false then Cmd_Retreat(SGroup_FromName("sg_e_VIL_wave3_mid"), mkr_e_retreat_02, mkr_e_retreat_02) end
		
		-- German Artillery Barrage #1
		-- Howitzers on the ridge launch a short barrage on the village
		t_artyHints = {}
		Rule_AddOneShot(OBJ_HTV_Artillery_A_01, 5)
		
		Util_StartIntel(EVENTS.ARTILLERY_01)
		
		if flashID_atGunObj ~= nil then
			UI_StopFlashing(flashID_atGunObj)
		end
		
		-- DEV
		g_dev_vil_wave4 = Timer_GetRemaining(tmr_VIL_wave4)
	end

end


-- German Artillery Interlude A
function OBJ_HTV_Artillery_A_01()
	if SGroup_Exists("sg_e_RDG_arty03") then
		if Util_GetPlayerOwner(sg_e_RDG_arty03) == player2 and SGroup_HasTeamWeapon(sg_e_RDG_arty03, ANY) then
			local fx_target = Marker_GetPosition(mkr_e_artillery03)
			fx_target.y = fx_target.y + 4.5
			Cmd_Ability(player2, g_bombardFX, fx_target)
			local hintID = HintPoint_Add(mkr_e_artillery03, true, 11046393, 6.5, HPAT_Critical) -- LOCDB [11046393] 'Howitzer Target'
			table.insert(t_artyHints, hintID)
			Cmd_Ability(sg_e_RDG_arty03, ABILITY.GLOBAL.HOWITZER_105MM_BARRAGE_SHORT, mkr_e_artillery03, nil, true)
		end
	end
	if SGroup_Exists("sg_e_RDG_arty04") then
		if Util_GetPlayerOwner(sg_e_RDG_arty04) == player2 and SGroup_HasTeamWeapon(sg_e_RDG_arty04, ANY) then
			local hintID = HintPoint_Add(mkr_e_artillery04, true, 11046393, 3, HPAT_Critical) -- LOCDB [11046393] 'Howitzer Target'
			table.insert(t_artyHints, hintID)
			Rule_AddOneShot(_delayedBombardWarningFX_01, 0.5)
			Cmd_Ability(sg_e_RDG_arty04, ABILITY.GLOBAL.HOWITZER_105MM_BARRAGE_SHORT, mkr_e_artillery04, nil, true)
			g_arty04Hint = true
		end
	end
	EventCue_Create(CUE.ATTACKED, 11050128, LOC(""), mkr_e_artillery03)
	Rule_AddOneShot(OBJ_HTV_Artillery_A_02, 1)
	
end

function _delayedBombardWarningFX_01()
	Cmd_Ability(player2, g_bombardFX, Marker_GetPosition(mkr_e_artillery04))
end

function OBJ_HTV_Artillery_A_02()
	if SGroup_Exists("sg_e_RDG_arty06") then 
		if Util_GetPlayerOwner(sg_e_RDG_arty06) == player2 and SGroup_HasTeamWeapon(sg_e_RDG_arty06, ANY) then
			local hintID = HintPoint_Add(mkr_e_artillery06, true, 11046393, 3, HPAT_Critical) -- LOCDB [11046393] 'Howitzer Target'
			table.insert(t_artyHints, hintID)
			Cmd_Ability(player2, g_bombardFX, Marker_GetPosition(mkr_e_artillery06))
			Cmd_Ability(sg_e_RDG_arty06, ABILITY.GLOBAL.HOWITZER_105MM_BARRAGE_SHORT, mkr_e_artillery06, nil, true)
		end
	end
	
	Rule_AddOneShot(OBJ_HTV_Artillery_A_03, 1)
	EventCue_Create(CUE.ATTACKED, 11050128, LOC(""), mkr_e_artillery06)

end

function OBJ_HTV_Artillery_A_03()

	if SGroup_Exists("sg_e_RDG_arty01") then
		if Util_GetPlayerOwner(sg_e_RDG_arty01) == player2 and SGroup_HasTeamWeapon(sg_e_RDG_arty01, ANY) then
			local hintID = HintPoint_Add(mkr_e_artillery01, true, 11046393, 3, HPAT_Critical) -- LOCDB [11046393] 'Howitzer Target'
			table.insert(t_artyHints, hintID)
			Cmd_Ability(player2, g_bombardFX, Marker_GetPosition(mkr_e_artillery01))
			Cmd_Ability(sg_e_RDG_arty01, ABILITY.GLOBAL.HOWITZER_105MM_BARRAGE_SHORT, mkr_e_artillery01, nil, true)
		end
	end
	if SGroup_Exists("sg_e_RDG_arty02") then
		if Util_GetPlayerOwner(sg_e_RDG_arty02) == player2 and SGroup_HasTeamWeapon(sg_e_RDG_arty02, ANY) then
			local hintID = HintPoint_Add(mkr_e_artillery02, true, 11046393, 3, HPAT_Critical) -- LOCDB [11046393] 'Howitzer Target'
			table.insert(t_artyHints, hintID)
			Rule_AddOneShot(_delayedBombardWarningFX_02, 0.5)
			Cmd_Ability(sg_e_RDG_arty02, ABILITY.GLOBAL.HOWITZER_105MM_BARRAGE_SHORT, mkr_e_artillery02, nil, true)
		end
	end
	if SGroup_Exists("sg_e_RDG_arty04") then
		if Util_GetPlayerOwner(sg_e_RDG_arty04) == player2 and SGroup_HasTeamWeapon(sg_e_RDG_arty04, ANY) then
			if not g_arty04Hint then
				local hintID = HintPoint_Add(mkr_e_artillery04, true, 11046393, 3, HPAT_Critical) -- LOCDB [11046393] 'Howitzer Target'
				table.insert(t_artyHints, hintID)
				Rule_AddOneShot(_delayedBombardWarningFX_03, 1)
			end
			Cmd_Ability(sg_e_RDG_arty04, ABILITY.GLOBAL.HOWITZER_105MM_BARRAGE_SHORT, mkr_e_artillery04, nil, true)
		end
	end
	Rule_AddOneShot(OBJ_HTV_RemoveArtyHints, 15)
	Rule_AddOneShot(OBJ_HTV_Wave4_delay, 20)
	EventCue_Create(CUE.ATTACKED, 11050128, LOC(""), mkr_e_artillery01)

end

function _delayedBombardWarningFX_02()
	Cmd_Ability(player2, g_bombardFX, Marker_GetPosition(mkr_e_artillery02))
end

function _delayedBombardWarningFX_03()
	Cmd_Ability(player2, g_bombardFX, Marker_GetPosition(mkr_e_artillery04))
end

function OBJ_HTV_RemoveArtyHints()
	for k,v in pairs(t_artyHints) do
		HintPoint_Remove(v)
		v = nil
	end
end

--**Wave4**--
function OBJ_HTV_Wave4_delay()

	Util_StartIntel(EVENTS.CRAZY_ATTACK_BEGIN)
	
	Rule_AddDelayedInterval(OBJ_HTV_Wave4_start, 1.5, 1)

end

function OBJ_HTV_Wave4_start()

	if Event_IsAnyRunning() == false then
		Rule_RemoveMe()
		if flashID_zis ~= nil then
			UI_StopFlashing(flashID_zis)
		end
		Ambient_Attacks_RestartLane()
		
		Rule_AddOneShot(OBJ_HTV_Wave4, 3)
	end

end
function OBJ_HTV_Wave4()

	-- First, determine which lanes are still open and fire off spawn functions
	if g_rightPointOwner == player1 then
		-- Spawn Main force
		local encData = {
			name = "Wave1_Left",
			player = player2,
			dynamicSpawnTarget = mkr_e_VIL_rightTar_01,
			spawn = mkr_e_RDG_rightSpawn_01,
			sgroups = {SGroup_CreateIfNotFound("sg_e_VIL_wave4"), SGroup_CreateIfNotFound("sg_e_VIL_wave4_right")},
			units = {
				{
					name = "Wave1_Left_B",
					sbp = SBP.GERMAN.GRENADIER_SQUAD,
				},
				{
					name = "Wave1_Left_B",
					sbp = SBP.GERMAN.SCOUTCAR_SDKFZ222,
				},
				{
					name = "Wave1_Left_B",
					sbp = SBP.GERMAN.STUG_III_E_SQUAD,
					spawn = mkr_e_RDG_leftForestSpawn_01,
					sgroups = {SGroup_CreateIfNotFound("sg_e_VIL_wave4_right_tank")},
				},
			},
		}
		encID_wave4Right = Encounter:Create(encData)
		
		local goalData = {
			name = "Attack",
			target = mkr_e_VIL_rightTar_01,
			useSkirmishAI = g_useSkirmishAI,
			tacticControlsList = g_disableVehicleTactic,
			attackMove = true,
			safeMoveWeight = 0.4,
			onSuccess = HTV_UpdateGoal_Defend,
			movePathLengthFactor = 1.5,
			fallback = true,
			fallbackParams = {
				thresholds = {0.05},
				thresholdType = Threshold_PercentageEntitiesRemaining,
				markers = {mkr_e_retreat_01},
				retreat = true,
				retreatDespawn = true,
			},
		}
		encID_wave4Right:SetGoal(goalData)
		
		ThreatArrow_CreateGroup(SGroup_FromName("sg_e_VIL_wave4_right_tank"))
		
		g_spawnLeft = false
	end
	
	-- Fire off any remaining functions (monitor)
	
	Rule_AddOneShot(OBJ_HTV_Wave4_Left_Delay, 35)
	
end

function OBJ_HTV_Wave4_Left_Delay()
	Player_SetAbilityAvailability(player2, BP_GetAbilityBlueprint("panzer_grenadier_bundled_campaign"), ITEM_UNLOCKED)

	if g_leftPointOwner == player1 then
		-- Spawn Main force
		local encData = {
			name = "Wave1_Left",
			player = player2,
			dynamicSpawnTarget = mkr_e_VIL_leftTar_01,
			spawn = mkr_e_RDG_leftSpawn_01,
			sgroups = {SGroup_CreateIfNotFound("sg_e_VIL_wave4"), SGroup_CreateIfNotFound("sg_e_VIL_wave4_left")},
			units = {
				{
					name = "Wave1_Left_B",
					sbp = SBP.GERMAN.STUG_III_E_SQUAD,
					spawn = mkr_e_RDG_leftForestSpawn_01,
					sgroups = {SGroup_CreateIfNotFound("sg_e_VIL_wave4_left_tank")},
				},
				{
					name = "Wave1_Left_B",
					sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
				},
				{
					name = "Wave1_Left_B",
					sbp = SBP.GERMAN.GRENADIER_SQUAD,
				},
			},
		}
		encID_wave4Left = Encounter:Create(encData)
		
		local goalData = {
			name = "Attack",
			target = mkr_e_VIL_leftTar_01,
			useSkirmishAI = g_useSkirmishAI,
			tacticControlsList = g_disableVehicleTactic,
			tacticTargetPreference = AITacticTargetPreference_Near,
			movePathLengthFactor = 1.5,
			attackMove = true,
			safeMoveWeight = 0.5,
			onSuccess = HTV_UpdateGoal_Defend,
			
			abilityControlsList = {
				{
					abilityPBG = ABILITY.GERMAN.PANZER_GRENADIER_BUNDLED_CAMPAIGN,
					maxCasters = 1,
					maxRange = 50,
					waitTimeSecs = 30,
				},
			},
		}
		encID_wave4Left:SetGoal(goalData)
		
		ThreatArrow_CreateGroup(SGroup_FromName("sg_e_VIL_wave4_left_tank"))
		
	end
	
	Timer_Start(tmr_VIL_wave5, g_VIL_wave5)
	Rule_AddInterval(OBJ_HTV_Wave4_Finished, 1)

end

function OBJ_HTV_Wave4_Finished()
	-- if player does not own the point OR the attacking wave does not exist
	-- OR
	-- The SGroup is dead
	-- OR
	-- The attackers are retreating
	if (Player_OwnsEGroup(player1, eg_POS_B_Points_01) == false
	  or SGroup_Exists("sg_e_VIL_wave4_left") == false
	  or (SGroup_Exists("sg_e_VIL_wave4_left") and (SGroup_IsEmpty(SGroup_FromName("sg_e_VIL_wave4_left")) or SGroup_IsRetreating(SGroup_FromName("sg_e_VIL_wave4_left"), ALL))))
	 and (Player_OwnsEGroup(player1, eg_POS_B_Points_03) == false
	  or SGroup_Exists("sg_e_VIL_wave4_right") == false
	  or (SGroup_Exists("sg_e_VIL_wave4_right") and (SGroup_IsEmpty(SGroup_FromName("sg_e_VIL_wave4_right")) or SGroup_IsRetreating(SGroup_FromName("sg_e_VIL_wave4_right"), ALL))))
	 or Timer_GetRemaining(tmr_VIL_wave5) <= 0 then
		Rule_RemoveMe()
		
		Ambient_Attacks_RestartLane("sg_e_rightAmb")
		
		Rule_AddOneShot(OBJ_HTV_Wave5, 8)
		
		-- DEV
		g_dev_vil_wave5 = Timer_GetRemaining(tmr_VIL_wave5)
	end

end

--**Wave5**--
function OBJ_HTV_Wave5()

	-- First, determine which lanes are still open and fire off spawn functions
	if g_leftPointOwner == player1 then
		-- Spawn Main force
		local encData = {
			name = "Wave1_Left",
			player = player2,
			dynamicSpawnTarget = mkr_e_VIL_leftTar_01,
			spawn = mkr_e_RDG_leftSpawn_01,
			sgroups = {SGroup_CreateIfNotFound("sg_e_VIL_wave5"), SGroup_CreateIfNotFound("sg_e_VIL_wave5_left")},
			units = {
				{
					name = "Wave1_Left_A",
					sbp = SBP.GERMAN.STUG_III_E_SQUAD,
					sgroups = {SGroup_CreateIfNotFound("sg_e_VIL_wave5_left_tank")},
				},
				{
					name = "Wave1_Left_B",
					sbp = SBP.GERMAN.GRENADIER_SQUAD,
					spawn = mkr_e_RDG_leftForestSpawn_01,
				},
				{
					name = "Wave1_Left_B",
					sbp = SBP.GERMAN.SCOUTCAR_SDKFZ222,
				},
			},
		}
		encID_wave5Left = Encounter:Create(encData)
		
		local goalData = {
			name = "Attack",
			target = mkr_e_VIL_leftTar_01,
			useSkirmishAI = g_useSkirmishAI,
			tacticControlsList = g_disableVehicleTactic,
			tacticTargetPreference = AITacticTargetPreference_HighDamage,
			movePathLengthFactor = 1.5,
			attackMove = true,
			safeMoveWeight = 0.6,
			
			onSuccess = HTV_UpdateGoal_Defend,
			
			fallback = true,
			fallbackParams = {
				thresholds = {0.05},
				thresholdType = Threshold_PercentageEntitiesRemaining,
				markers = {mkr_e_retreat_01},
				retreat = true,
				retreatDespawn = true,
			},
		}
		encID_wave5Left:SetGoal(goalData)
		
		ThreatArrow_CreateGroup(SGroup_FromName("sg_e_VIL_wave5_left_tank"))
		
	end
	
	if g_rightPointOwner == player1 then
		-- Spawn Main force
		local encData = {
			name = "Wave1_Left",
			player = player2,
			dynamicSpawnTarget = mkr_e_VIL_rightTar_01,
			spawn = mkr_e_RDG_rightSpawn_01,
			sgroups = {SGroup_CreateIfNotFound("sg_e_VIL_wave5"), SGroup_CreateIfNotFound("sg_e_VIL_wave5_right")},
			units = {
				{
					name = "Wave1_Left_A",
					sbp = SBP.GERMAN.STUG_III_E_SQUAD,
					spawn = mkr_e_RDG_rightForestSpawn_02,
					sgroups = {SGroup_CreateIfNotFound("sg_e_VIL_wave5_right_tank")},
				},
				{
					name = "Wave1_Left_B",
					sbp = SBP.GERMAN.GRENADIER_SQUAD,
					spawn = mkr_e_RDG_leftSpawn_01,
				},
				{
					name = "Wave1_Left_B",
					sbp = SBP.GERMAN.GRENADIER_SQUAD,
				},
			},
		}
		if g_easyDiff then
			encData.units[1].sbp = SBP.GERMAN.SCOUTCAR_SDKFZ222 
			encData.units[1].entityUpgrades = {UPG.GERMAN.SDKFZ_222_20MM_GUN} 
		end
				
		encID_wave5Right = Encounter:Create(encData)
		
		local goalData = {
			name = "Attack",
			target = mkr_e_VIL_rightTar_01,
			useSkirmishAI = g_useSkirmishAI,
			tacticControlsList = g_disableVehicleTactic,
			tacticTargetPreference = AITacticTargetPreference_Near,
			movePathLengthFactor = 1.5,
			attackMove = true,
			safeMoveWeight = 0.6,
			onSuccess = HTV_UpdateGoal_Defend,
			fallback = true,
			fallbackParams = {
				thresholds = {0.05},
				thresholdType = Threshold_PercentageEntitiesRemaining,
				markers = {mkr_e_retreat_03},
				retreat = true,
				retreatDespawn = true,
			},
		}
		encID_wave5Right:SetGoal(goalData)
		
		ThreatArrow_CreateGroup(SGroup_FromName("sg_e_VIL_wave5_right_tank"))
		
	end
	
	Rule_AddOneShot(OBJ_HTV_Wave5_Mid_Delay, 25)

end

function OBJ_HTV_Wave5_Mid_Delay()

	if g_midPointOwner == player1 then
		-- Spawn Main force
		local encData = {
			name = "Wave1_Left",
			player = player2,
			dynamicSpawnTarget = mkr_e_VIL_midTar_01,
			spawn = mkr_e_RDG_midSpawn_01,
			sgroups = {SGroup_CreateIfNotFound("sg_e_VIL_wave5"), SGroup_CreateIfNotFound("sg_e_VIL_wave5_mid")},
			units = {
				{
					name = "Wave1_Left_B",
					sbp = SBP.GERMAN.STUG_III_E_SQUAD,
					sgroups = {SGroup_CreateIfNotFound("sg_e_VIL_wave5_mid_tank")},
					spawn = mkr_e_RDG_leftSpawn_01,
				},
			},
		}
		encID_wave5Mid = Encounter:Create(encData)
		
		local goalData = {
			name = "Attack",
			target = mkr_e_VIL_midTar_01,
			useSkirmishAI = g_useSkirmishAI,
			tacticControlsList = g_disableVehicleTactic,
			tacticTargetPreference = AITacticTargetPreference_HighDamage,
			movePathLengthFactor = 1.5,
			attackMove = true,
			safeMoveWeight = 0.4,
			onSuccess = HTV_UpdateGoal_Defend,
		}
		encID_wave5Mid:SetGoal(goalData)
		
		ThreatArrow_CreateGroup(SGroup_FromName("sg_e_VIL_wave5_mid_tank"))
		
	end
	
	Timer_Start(tmr_VIL_wave6, g_VIL_wave6)
	
	Rule_AddInterval(OBJ_HTV_Wave5_Finished, 1)
	
end

function OBJ_HTV_Wave5_Finished()
	if ((Player_OwnsEGroup(player1, eg_POS_B_Points_01) == false or SGroup_Exists("sg_e_VIL_wave5_left") == false) or ((SGroup_IsEmpty(SGroup_FromName("sg_e_VIL_wave5_left")) or SGroup_IsRetreating(SGroup_FromName("sg_e_VIL_wave5_left"), ALL)))
	  and (Player_OwnsEGroup(player1, eg_POS_B_Points_02) == false or SGroup_Exists("sg_e_VIL_wave5_mid") == false) or ((SGroup_IsEmpty(SGroup_FromName("sg_e_VIL_wave5_mid")) or SGroup_IsRetreating(SGroup_FromName("sg_e_VIL_wave5_mid"), ALL)))
	  and (Player_OwnsEGroup(player1, eg_POS_B_Points_03) == false or SGroup_Exists("sg_e_VIL_wave5_right") == false) or ((SGroup_IsEmpty(SGroup_FromName("sg_e_VIL_wave5_right")) or SGroup_IsRetreating(SGroup_FromName("sg_e_VIL_wave5_right"), ALL))))
	  or Timer_GetRemaining(tmr_VIL_wave6) <= 0 then
		Rule_RemoveMe()
		
		Ambient_Attacks_RestartLane("sg_e_leftAmb")
		Ambient_Attacks_RestartLane("sg_e_rightAmb")
		
		Rule_AddOneShot(OBJ_HTV_Wave6, 7)
		
		-- DEV
		g_dev_vil_wave6 = Timer_GetRemaining(tmr_VIL_wave6)
	end
end

--**Wave6**--
function OBJ_HTV_Wave6()
	-- First, determine which lanes are still open and fire off spawn functions
	if g_leftPointOwner == player1 then
		-- Spawn Main force
		local encData = {
			name = "Wave1_Left",
			player = player2,
			dynamicSpawnTarget = mkr_e_VIL_leftTar_01,
			spawn = mkr_e_RDG_leftSpawn_01,
			sgroups = {SGroup_CreateIfNotFound("sg_e_VIL_wave6"), SGroup_CreateIfNotFound("sg_e_VIL_wave6_left")},
			units = {
				{
					name = "Wave1_Left_A",
					sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
					sgroups = {SGroup_CreateIfNotFound("sg_e_VIL_wave6_left_pg")},
				},
				{
					name = "Wave1_Left_B",
					sbp = SBP.GERMAN.SCOUTCAR_SDKFZ222,
					spawn = mkr_e_RDG_leftSpawn_01,
				},
			},
		}
		encID_wave6Left = Encounter:Create(encData)
		
		local goalData = {
			name = "Attack",
			target = mkr_e_VIL_leftTar_01,
			useSkirmishAI = g_useSkirmishAI,
			tacticControlsList = g_disableVehicleTactic,
			tacticTargetPreference = AITacticTargetPreference_Near,
			movePathLengthFactor = 1.5,
			attackMove = true,
			safeMoveWeight = 0.5,
			
			onSuccess = HTV_UpdateGoal_Defend,

			fallback = true,
			fallbackParams = {
				thresholds = {0.05},
				thresholdType = Threshold_PercentageEntitiesRemaining,
				markers = {mkr_e_retreat_01},
				retreat = true,
				retreatDespawn = true,
			},
			
			abilityControlsList = {
				{
					abilityPBG = ABILITY.GERMAN.PANZER_GRENADIER_BUNDLED_CAMPAIGN,
					maxCasters = 1,
					maxRange = 50,
					waitTimeSecs = 30,
				},
			},
		}
		encID_wave6Left:SetGoal(goalData)
		
	end
	
	if g_rightPointOwner == player1 then
		-- Spawn Main force
		local encData = {
			name = "Wave1_Left",
			player = player2,
			dynamicSpawnTarget = mkr_e_VIL_rightTar_01,
			spawn = mkr_e_RDG_rightSpawn_01,
			sgroups = {SGroup_CreateIfNotFound("sg_e_VIL_wave6"), SGroup_CreateIfNotFound("sg_e_VIL_wave6_right")},
			units = {
				{
					name = "Wave1_Left_A",
					sbp = SBP.GERMAN.STUG_III_E_SQUAD,
					spawn = mkr_e_RDG_rightForestSpawn_02,
					sgroups = {SGroup_CreateIfNotFound("sg_e_VIL_wave6_right_tank")},
				},
				{
					name = "Wave1_Left_B",
					sbp = SBP.GERMAN.GRENADIER_SQUAD,
				},
			},
		}
		encID_wave6Right = Encounter:Create(encData)
		
		local goalData = {
			name = "Attack",
			target = mkr_e_VIL_rightTar_01,
			useSkirmishAI = g_useSkirmishAI,
			tacticControlsList = g_disableVehicleTactic,
			attackMove = true,
			safeMoveWeight = 0.4,
			movePathLengthFactor = 1.5,
			onSuccess = HTV_UpdateGoal_Defend,
			
			fallback = true,
			fallbackParams = {
				thresholds = {0.05},
				thresholdType = Threshold_PercentageEntitiesRemaining,
				markers = {mkr_e_retreat_03},
				retreat = true,
				retreatDespawn = true,
			},
		}
		encID_wave6Right:SetGoal(goalData)
		
		ThreatArrow_CreateGroup(SGroup_FromName("sg_e_VIL_wave6_right_tank"))
		
	end
	--SachaHacks, add a new timer to end wave 6
	Timer_Start(tmr_VIL_wave7, g_VIL_wave7)
	
	Rule_AddOneShot(OBJ_HTV_Wave6_Mid_Delay, 12)

end

function OBJ_HTV_Wave6_Mid_Delay()

	if g_midPointOwner == player1 then
		-- Spawn Main force
		local encData = {
			name = "Wave1_Left",
			player = player2,
			dynamicSpawnTarget = mkr_e_VIL_midTar_01,
			spawn = mkr_e_RDG_midSpawn_01,
			sgroups = {SGroup_CreateIfNotFound("sg_e_VIL_wave6"), SGroup_CreateIfNotFound("sg_e_VIL_wave6_mid")},
			units = {
				{
					name = "Wave1_Left_B",
					sbp = SBP.GERMAN.STUG_III_E_SQUAD,
					sgroups = {SGroup_CreateIfNotFound("sg_e_VIL_wave6_mid_tank")},
				},
				{
					name = "Wave1_Left_B",
					sbp = SBP.GERMAN.GRENADIER_SQUAD,
				},
			},
		}
		if g_easyDiff then
			encData.units[1].sbp = SBP.GERMAN.SCOUTCAR_SDKFZ222 
			encData.units[1].entityUpgrades = {UPG.GERMAN.SDKFZ_222_20MM_GUN}
		end
		encID_wave6Mid = Encounter:Create(encData)
		
		local goalData = {
			name = "Attack",
			target = mkr_e_VIL_midTar_01,
			useSkirmishAI = g_useSkirmishAI,
			tacticControlsList = g_disableVehicleTactic,
			tacticTargetPreference = AITacticTargetPreference_HighDamage,
			tacticCloseGround = true,
			movePathLengthFactor = 1.5,
			attackMove = true,
			safeMoveWeight = 0,
			
			onSuccess = HTV_UpdateGoal_Defend,
			
			fallback = true,
			fallbackParams = {
				thresholds = {0.05},
				thresholdType = Threshold_PercentageEntitiesRemaining,
				markers = {mkr_e_retreat_02},
				retreat = true,
				retreatDespawn = true,
			},
		}
		encID_wave6Mid:SetGoal(goalData)
		
		ThreatArrow_CreateGroup(SGroup_FromName("sg_e_VIL_wave6_mid_tank"))
		
	end
	
	Rule_AddInterval(OBJ_HTV_Wave6_Finished, 1)

end

function OBJ_HTV_Wave6_Finished()

	local allEnemiesDead = (SGroup_IsEmpty(SGroup_FromName("sg_e_VIL_wave6_left")) and SGroup_IsEmpty(SGroup_FromName("sg_e_VIL_wave6_mid")) and SGroup_IsEmpty(SGroup_FromName("sg_e_VIL_wave6_right")))
	local allEnemiesRetreating = (SGroup_IsRetreating(SGroup_FromName("sg_e_VIL_wave6_left"), ALL) and SGroup_IsRetreating(SGroup_FromName("sg_e_VIL_wave6_mid"), ALL) and SGroup_IsRetreating(SGroup_FromName("sg_e_VIL_wave6_right"), ALL))
	local allVillagePointsLost = (Player_OwnsEGroup(player1, eg_POS_B_Points_01) == false and Player_OwnsEGroup(player1, eg_POS_B_Points_02) == false and Player_OwnsEGroup(player1, eg_POS_B_Points_03) == false)
	local timeIsUp = Timer_GetRemaining(tmr_VIL_wave7) <= 0
	
	if allEnemiesDead or allEnemiesRetreating or allVillagePointsLost or timeIsUp then
		Rule_RemoveMe()
		
		Ambient_Attacks_RetreatAndHold()
		
		-- German Artillery Barrage #2
		-- Howitzers on the ridge launch a longer, more accurate barrage on the village
		Rule_AddOneShot(OBJ_HTV_Artillery_B_01, 7)
		
		Util_StartIntel(EVENTS.ARTILLERY_02)
	end
end

-- Artillery Interlude B
function OBJ_HTV_Artillery_B_01()

	--check if AT gun entities exist, just in case they've fallen through the ice
	if Entity_IsValid(g_at_01_id) then
		Entity_SetInvulnerable(Entity_FromWorldID(g_at_01_id), false, -1)
	end
	if Entity_IsValid(g_at_02_id) then
		Entity_SetInvulnerable(Entity_FromWorldID(g_at_02_id), false, -1)
	end
	if Entity_IsValid(g_at_03_id) then
		Entity_SetInvulnerable(Entity_FromWorldID(g_at_03_id), false, -1)
	end
	--
	Player_GetAll(player1)
	SGroup_Filter(sg_allsquads, SBP.SOVIET.M1942_ZIS_3_76MM_AT_GUN_SQUAD, FILTER_REMOVE)
	SGroup_SetInvulnerable(sg_allsquads, true, 15)

	if SGroup_Exists("sg_e_RDG_arty02") then
		if Util_GetPlayerOwner(sg_e_RDG_arty02) == player2 then
			local target = Marker_GetPosition(mkr_e_precise_arty_02)
			if Entity_IsValid(g_at_01_id) then
				target = Prox_GetRandomPosition(Entity_FromWorldID(g_at_01_id), 10, 5)
			end
			if SGroup_HasTeamWeapon(sg_e_RDG_arty02, ANY) then
				local hintID = HintPoint_Add(target, true, 11046393, 3, HPAT_Critical) -- LOCDB [11046393] 'Howitzer Target'
				table.insert(t_artyHints, hintID)
				Cmd_Ability(player2, g_bombardFX, target)
				if Entity_IsValid(g_at_01_id) then
					g_artyOnZIS1 = true
				end
				Cmd_Ability(sg_e_RDG_arty02, ABILITY.GERMAN.HOWITZER_105MM_BARRAGE_ABILITY, target, nil, true)
				EventCue_Create(CUE.ATTACKED, 11050128, LOC(""), Util_GetPosition(target))
			end
		end
	end
	
	Rule_AddOneShot(OBJ_HTV_Artillery_B_02, 1)
	
end

function OBJ_HTV_Artillery_B_02()

	if SGroup_Exists("sg_e_RDG_arty01") then
		if Util_GetPlayerOwner(sg_e_RDG_arty01) == player2 then
			local target = Marker_GetPosition(mkr_e_precise_arty_01)
			if Entity_IsValid(g_at_02_id) then
				target = Prox_GetRandomPosition(Entity_FromWorldID(g_at_02_id), 10, 5)
			end
			if SGroup_HasTeamWeapon(sg_e_RDG_arty01, ANY) then
				local hintID = HintPoint_Add(target, true, 11046393, 3, HPAT_Critical) -- LOCDB [11046393] 'Howitzer Target'
				table.insert(t_artyHints, hintID)
				Cmd_Ability(player2, g_bombardFX, target)
				if Entity_IsValid(g_at_02_id) then
					g_artyOnZIS2 = true
				end
				Cmd_Ability(sg_e_RDG_arty01, ABILITY.GERMAN.HOWITZER_105MM_BARRAGE_ABILITY, target, nil, true)
				EventCue_Create(CUE.ATTACKED, 11050128, LOC(""), Util_GetPosition(target))
			end
		end
	end
	if SGroup_Exists("sg_e_RDG_arty04") then
		if Util_GetPlayerOwner(sg_e_RDG_arty04) == player2 then
			local target = Marker_GetPosition(mkr_e_precise_arty_04)
			if Entity_IsValid(g_at_03_id) then
				target = Prox_GetRandomPosition(Entity_FromWorldID(g_at_03_id), 10, 5)
			end
			if SGroup_HasTeamWeapon(sg_e_RDG_arty04, ANY) then
				local hintID = HintPoint_Add(target, true, 11046393, 3, HPAT_Critical) -- LOCDB [11046393] 'Howitzer Target'
				table.insert(t_artyHints, hintID)
				g_bombardFXTarget4 = target
				Rule_AddOneShot(_delayedBombardWarningFX_04, 0.5)
				if Entity_IsValid(g_at_03_id) then
					g_artyOnZIS3 = true
				end
				Cmd_Ability(sg_e_RDG_arty04, ABILITY.GERMAN.HOWITZER_105MM_BARRAGE_ABILITY, target, nil, true)
			end
		end
	end
	
	Player_GetAll(player1)
	
	SGroup_Filter(sg_allsquads, SBP.SOVIET.M1942_ZIS_3_76MM_AT_GUN_SQUAD, FILTER_KEEP)
	
	Rule_AddOneShot(OBJ_HTV_Artillery_B_03, 1)
	
	EGroup_SetInvulnerable(eg_hq, 0.5)
	
end

function _delayedBombardWarningFX_04()
	Cmd_Ability(player2, g_bombardFX, g_bombardFXTarget4)
end

function OBJ_HTV_Artillery_B_03()
	local target = Marker_GetPosition(mkr_e_precise_arty_03)
	if SGroup_Count(Player_GetSquads(player1)) > 0 then
		target = Squad_GetPosition(SGroup_GetRandomSpawnedSquad(Player_GetSquads(player1)))
	end
	if Entity_IsValid(g_at_01_id) then
		target = Prox_GetRandomPosition(Entity_FromWorldID(g_at_01_id), 10, 5)
	end

	if SGroup_Exists("sg_e_RDG_arty03") then
		if Util_GetPlayerOwner(sg_e_RDG_arty03) == player2 and SGroup_HasTeamWeapon(sg_e_RDG_arty03, ANY) then
			if not g_artyOnZIS1 then
				local hintID = HintPoint_Add(target, true, 11046393, 3, HPAT_Critical) -- LOCDB [11046393] 'Howitzer Target'
				table.insert(t_artyHints, hintID)
				Cmd_Ability(player2, g_bombardFX, target)
			end
			Cmd_Ability(sg_e_RDG_arty03, ABILITY.GERMAN.HOWITZER_105MM_BARRAGE_ABILITY, target, nil, true)
			EventCue_Create(CUE.ATTACKED, 11050128, LOC(""), Util_GetPosition(target))
		end
	end
	
	local target = Marker_GetPosition(mkr_e_precise_arty_02)
	if SGroup_Count(Player_GetSquads(player1)) > 0 then
		target = Squad_GetPosition(SGroup_GetRandomSpawnedSquad(Player_GetSquads(player1)))
	end
	if Entity_IsValid(g_at_02_id) then
		target = Prox_GetRandomPosition(Entity_FromWorldID(g_at_02_id), 10, 5)
	end
	
	if SGroup_Exists("sg_e_RDG_arty05") then
		if Util_GetPlayerOwner(sg_e_RDG_arty05) == player2 and SGroup_HasTeamWeapon(sg_e_RDG_arty05, ANY) then
			if not g_artyOnZIS2 then
				local hintID = HintPoint_Add(target, true, 11046393, 3, HPAT_Critical) -- LOCDB [11046393] 'Howitzer Target'
				table.insert(t_artyHints, hintID)
				g_bombardFXTarget5 = target
				Rule_AddOneShot(_delayedBombardWarningFX_05, 0.5)
			end
			Cmd_Ability(sg_e_RDG_arty05, ABILITY.GERMAN.HOWITZER_105MM_BARRAGE_ABILITY, target, nil, true)
		end
	end
	
	local target = Marker_GetPosition(mkr_e_precise_arty_01)
	if SGroup_Count(Player_GetSquads(player1)) > 0 then
		target = Squad_GetPosition(SGroup_GetRandomSpawnedSquad(Player_GetSquads(player1)))
	end
	if Entity_IsValid(g_at_03_id) then
		target = Prox_GetRandomPosition(Entity_FromWorldID(g_at_03_id), 10, 5)
	end
	
	if SGroup_Exists("sg_e_RDG_arty06") then
		if Util_GetPlayerOwner(sg_e_RDG_arty06) == player2 and SGroup_HasTeamWeapon(sg_e_RDG_arty06, ANY) then
			if not g_artyOnZIS3 then
				local hintID = HintPoint_Add(target, true, 11046393, 3, HPAT_Critical) -- LOCDB [11046393] 'Howitzer Target'
				table.insert(t_artyHints, hintID)
				g_bombardFXTarget6 = target
				Rule_AddOneShot(_delayedBombardWarningFX_06, 1)
			end
			Cmd_Ability(sg_e_RDG_arty06, ABILITY.GERMAN.HOWITZER_105MM_BARRAGE_ABILITY, target, nil, true)
		end
	end
	
	Rule_AddOneShot(OBJ_HTV_RemoveArtyHints, 15)
	Rule_AddOneShot(OBJ_HTV_Wave7, 20)
	
end

function _delayedBombardWarningFX_05()
	Cmd_Ability(player2, g_bombardFX, g_bombardFXTarget5)
end

function _delayedBombardWarningFX_06()
	Cmd_Ability(player2, g_bombardFX, g_bombardFXTarget6)
end

--**Wave7**--
function OBJ_HTV_Wave7()
	g_enc_villageWave7 = {}
	-- Spawn the hard enemy attacks against the player's base area
	__t_ambient.lanes[1].VILTar = eg_hq
	__t_ambient.lanes[2].VILTar = eg_hq
	__t_ambient.lanes[3].VILTar = eg_hq
	
	Ambient_Attacks_RestartLane()
	
	-- Actual Wave 7 - push back to HQ
	
	if g_leftPointOwner == player1 then
		-- Spawn Main force
		local encData = {
			name = "Wave1_Left",
			player = player2,
			dynamicSpawnTarget = mkr_e_VIL_leftTar_01,
			spawn = mkr_e_RDG_leftSpawn_01,
			sgroups = {SGroup_CreateIfNotFound("sg_e_VIL_wave7"), SGroup_CreateIfNotFound("sg_e_VIL_wave7_left")},
			units = {
				{
					name = "Wave1_Left_B",
					sbp = SBP.GERMAN.SCOUTCAR_SDKFZ222,
				},
				{
					name = "Wave1_Left_B",
					sbp = SBP.GERMAN.STUG_III_E_SQUAD,
					spawn = mkr_e_RDG_leftForestSpawn_01,
					sgroups = {SGroup_CreateIfNotFound("sg_e_VIL_wave7_left_tank")},
				},
				{
					name = "Wave1_Left_B",
					sbp = SBP.GERMAN.GRENADIER_SQUAD,
				},
			},
		}
		encID_wave7Left = Encounter:Create(encData)
		table.insert(g_enc_villageWave7, encID_wave7Left)
		
		local goalData = {
			name = "Attack",
			target = mkr_e_finalAttack_left, 
			useSkirmishAI = g_useSkirmishAI,
			tacticCloseGround = true,
			leashRange = 25,
			movePathLengthFactor = 1.5,
			attackMove = true,
			safeMoveWeight = 0.8,
			
			onSuccess = HTV_UpdateGoal_Defend,
		}
		encID_wave7Left:SetGoal(goalData)

	end
	
	if g_midPointOwner == player1 then
		-- Spawn Main force
		local encData = {
			name = "Wave1_Left",
			player = player2,
			dynamicSpawnTarget = mkr_e_VIL_midTar_01,
			spawn = mkr_e_RDG_midSpawn_01,
			sgroups = {SGroup_CreateIfNotFound("sg_e_VIL_wave7"), SGroup_CreateIfNotFound("sg_e_VIL_wave7_mid")},
			units = {
				{
					name = "Wave1_Left_B",
					sbp = SBP.GERMAN.GRENADIER_SQUAD,
				},
				{
					name = "Wave1_Left_B",
					sbp = SBP.GERMAN.STUG_III_E_SQUAD,
					sgroups = {SGroup_CreateIfNotFound("sg_e_VIL_wave7_mid_tank")},
				},
				{
					name = "Wave1_Left_B",
					sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
					sgroups = {SGroup_CreateIfNotFound("sg_e_VIL_wave7_mid_pg")},
				},
			},
		}
		encID_wave7Mid = Encounter:Create(encData)
		table.insert(g_enc_villageWave7, encID_wave7Mid)
		
		local goalData = {
			name = "Attack",
			target = mkr_e_finalAttack_mid,
			useSkirmishAI = g_useSkirmishAI,
			
			tacticTargetPreference = AITacticTargetPreference_Near,
			leashRange = 25,
			tacticCloseGround = true,
			movePathLengthFactor = 1.5,
			attackMove = true,
			safeMoveWeight = 0.8,
			
			abilityControlsList = {
				{
					abilityPBG = ABILITY.GERMAN.PANZER_GRENADIER_BUNDLED_CAMPAIGN,
					maxCasters = 1,
					maxRange = 50,
					waitTimeSecs = 30,
				},
			},
		}
		encID_wave7Mid:SetGoal(goalData)

	end
	
	if g_rightPointOwner == player1 then
		-- Spawn Main force
		local encData = {
			name = "Wave1_Left",
			player = player2,
			dynamicSpawnTarget = mkr_e_VIL_rightTar_01,
			spawn = mkr_e_RDG_rightSpawn_01,
			sgroups = {SGroup_CreateIfNotFound("sg_e_VIL_wave7"), SGroup_CreateIfNotFound("sg_e_VIL_wave7_right")},
			units = {
				{
					name = "Wave1_Left_B",
					sbp = SBP.GERMAN.SCOUTCAR_SDKFZ222,
				},
				{
					name = "Wave1_Left_B",
					sbp = SBP.GERMAN.GRENADIER_SQUAD,
				},
				{
					name = "Wave1_Left_B",
					sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
					sgroups = {SGroup_CreateIfNotFound("sg_e_VIL_wave7_right_pg")},
				},
			},
		}
		encID_wave7Right = Encounter:Create(encData)
		table.insert(g_enc_villageWave7, encID_wave7Right)
		
		local goalData = {
			name = "Attack",
			target = mkr_e_finalAttack_right,
			useSkirmishAI = g_useSkirmishAI,
			movePathLengthFactor = 1.5,
			tacticTargetPreference = AITacticTargetPreference_Near,
			leashRange = 25,
			attackMove = true,
			safeMoveWeight = 0,
			
			onSuccess = HTV_UpdateGoal_Defend,
			
			abilityControlsList = {
				{
					abilityPBG = ABILITY.GERMAN.PANZER_GRENADIER_BUNDLED_CAMPAIGN,
					maxCasters = 1,
					maxRange = 50,
					waitTimeSecs = 30,
				},
			},
		}
		encID_wave7Right:SetGoal(goalData)

	end
	
	Rule_AddOneShot(OBJ_HTV_Wave7_Delay, 5)
	
	Rule_AddOneShot(OBJ_HTV_FallBack_To_HQ, 12)

end

function OBJ_HTV_Wave7_Delay()

	-- Spawn an encounter to claim the territories in the village
	if g_leftPointOwner == player1 then
		-- Spawn Main force
		local encData = {
			name = "Wave1_Left",
			player = player2,
			dynamicSpawnTarget = mkr_e_VIL_leftTar_01,
			spawn = mkr_e_RDG_leftSpawn_01,
			sgroups = {SGroup_CreateIfNotFound("sg_e_VIL_wave7_cp"), SGroup_CreateIfNotFound("sg_e_VIL_wave7_left_cp")},
			units = {
				{
					name = "Wave1_Left_B",
					sbp = SBP.GERMAN.GRENADIER_SQUAD,
				},
				{
					name = "Wave1_Left_B",
					sbp = SBP.GERMAN.GRENADIER_SQUAD,
				},
			},
		}
		encID_wave7Left_CP = Encounter:Create(encData)
		table.insert(g_enc_villageWave7, encID_wave7Left_CP)
		
		local goalData = {
			name = "Attack",
			target = mkr_e_VIL_leftTar_01,
			useSkirmishAI = g_useSkirmishAI,
			movePathLengthFactor = 1.5,
			attackMove = true,
			safeMoveWeight = 0.8,

			onSuccess = HTV_UpdateGoal_Defend,
		}
		encID_wave7Left_CP:SetGoal(goalData)
		
	end
	
	if g_midPointOwner == player1 then
		-- Spawn Main force
		local encData = {
			name = "Wave1_Left",
			player = player2,
			dynamicSpawnTarget = mkr_e_VIL_midTar_01,
			spawn = mkr_e_RDG_midSpawn_01,
			sgroups = {SGroup_CreateIfNotFound("sg_e_VIL_wave7_cp"), SGroup_CreateIfNotFound("sg_e_VIL_wave7_mid_cp")},
			units = {
				{
					name = "Wave1_Left_B",
					sbp = SBP.GERMAN.GRENADIER_SQUAD,
				},
				{
					name = "Wave1_Left_B",
					sbp = SBP.GERMAN.SCOUTCAR_SDKFZ222,
				},
			},
		}
		encID_wave7Mid_CP = Encounter:Create(encData)
		table.insert(g_enc_villageWave7, encID_wave7Mid_CP)
		
		local goalData = {
			name = "Attack",
			target = mkr_e_VIL_midTar_01,
			useSkirmishAI = g_useSkirmishAI,
			movePathLengthFactor = 1.5,
			attackMove = true,
			safeMoveWeight = 0.8,

			onSuccess = HTV_UpdateGoal_Defend,
		}
		encID_wave7Mid_CP:SetGoal(goalData)
		
	end
	
	if g_rightPointOwner == player1 then
		local encData = {
			name = "Wave1_Left",
			player = player2,
			dynamicSpawnTarget = mkr_e_VIL_rightTar_01,
			spawn = mkr_e_RDG_rightSpawn_01,
			sgroups = {SGroup_CreateIfNotFound("sg_e_VIL_wave7_cp"), SGroup_CreateIfNotFound("sg_e_VIL_wave7_right_cp")},
			units = {
				{
					name = "Wave1_Left_B",
					sbp = SBP.GERMAN.GRENADIER_SQUAD,
				},
				{
					name = "Wave1_Left_B",
					sbp = SBP.GERMAN.GRENADIER_SQUAD,
				},
			},
		}
		encID_wave7Right_CP = Encounter:Create(encData)
		table.insert(g_enc_villageWave7, encID_wave7Right_CP)
		
		local goalData = {
			name = "Attack",
			target = mkr_e_VIL_rightTar_01,
			useSkirmishAI = g_useSkirmishAI,
			movePathLengthFactor = 1.5,
			attackMove = true,
			safeMoveWeight = 0.8,
			
			onSuccess = HTV_UpdateGoal_Defend,
		}
		encID_wave7Right_CP:SetGoal(goalData)
		
	end
	
	-- Base rush
	local encData = {
		name = "Wave1_Left",
		player = player2,
		dynamicSpawnTarget = mkr_e_VIL_leftTar_01,
		spawn = mkr_e_RDG_leftSpawn_01,
		sgroups = {SGroup_CreateIfNotFound("sg_e_VIL_wave7_rush")},
		units = {
			{
				name = "Wave1_Left_B",
				sbp = SBP.GERMAN.SCOUTCAR_SDKFZ222,
			},
			{
				name = "Wave1_Left_B",
				sbp = SBP.GERMAN.STUG_III_E_SQUAD,
			},
			{
				name = "Wave1_Left_B",
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
			},
		},
	}
	encID_wave7Rush = Encounter:Create(encData)
	table.insert(g_enc_villageWave7, encID_wave7Rush)
	
	local goalData = {
		name = "Attack",
		tacticCloseGround = true,
		movePathLengthFactor = 1.5,
		attackMove = false,
		safeMoveWeight = 0.4,
		target = mkr_playerHQ,
		range = 45,
		leashRange = 35,
		abilityControlsList = {
			{
				abilityPBG = ABILITY.GERMAN.PANZER_GRENADIER_BUNDLED_CAMPAIGN,
				maxCasters = 1,
				maxRange = 50,
				waitTimeSecs = 30,
			},
		},
	}
	encID_wave7Rush:SetGoal(goalData)

end
----------------
-- Hold the Village
-- Tell the player to fall back and defend the HQ
----------------
function OBJ_HTV_FallBack_To_HQ()
	g_fallbackToHQ = true
	Event_Skip()
	
	Util_StartIntel(EVENTS.OVERWHELM_ATTACK_BEGIN)
	
	if Rule_Exists(__capturePoints_Manager) then Rule_Remove(__capturePoints_Manager) end
	
	if Objective_IsStarted(OBJ_RetakeVillagePoint) then Objective_Complete(OBJ_RetakeVillagePoint, false) end
	Rule_AddInterval(OBJ_HTV_HideTimerObj, 1)
	
	if hint_retake ~= nil then
		HintPoint_Remove(hint_retake)
	end
	
	if hpid_pos_A ~= nil then
		Objective_RemoveUIElements(OBJ_HoldTheVillage, hpid_pos_A)
		hpid_pos_A = nil
	end
	
	if hpid_pos_B ~= nil then
		Objective_RemoveUIElements(OBJ_HoldTheVillage, hpid_pos_B)
		hpid_pos_B = nil
	end
	
	if hpid_pos_C ~= nil then
		Objective_RemoveUIElements(OBJ_HoldTheVillage, hpid_pos_C)
		hpid_pos_C = nil
	end
	
	hpid_hq = Objective_AddUIElements(OBJ_HoldTheVillage, eg_hq, true, 11008203, true)		-- LOCDB [11008203] 'Defend the HQ'
	
	Rule_AddDelayedInterval(OBJ_HTV_Update_To_HQ, 1.5, 1)
	
	Rule_AddDelayedInterval(OBJ_HTV_SpeechEvent_01, 10, 1)
	
	tmr_hq_override = "tmr_hq_override"
	Timer_Start(tmr_hq_override, 30)

end

function OBJ_HTV_Update_To_HQ()
	
	if Event_IsAnyRunning() == false then
		Rule_RemoveMe()
		Objective_Show(OBJ_PingATGuns, false)
		Objective_Show(OBJ_RetakeVillagePoint, false)
		if not g_villageFailed then
			Objective_UpdateText(OBJ_HoldTheVillage, 11008203, 11008203, true)
		end
	end

end

function OBJ_HTV_SpeechEvent_01()
	
	if Event_IsAnyRunning() == false and (Prox_ArePlayersNearMarker(player2, Util_GetPosition(eg_hq), ANY, 40) or Timer_GetRemaining(tmr_hq_override) <= 0 )then
		Rule_RemoveMe()
		
		Util_StartIntel(EVENTS.DESPERATION_02)
		
		Timer_Start(tmr_hq_override, 40)
		
		Rule_AddDelayedInterval(OBJ_HTV_SpeechEvent_02, 10, 1)
	end

end

function OBJ_HTV_SpeechEvent_02()
	
	if Event_IsAnyRunning() == false and (Prox_ArePlayersNearMarker(player2, Util_GetPosition(eg_hq), ANY, 40) or Timer_GetRemaining(tmr_hq_override) <= 0 )then
		Rule_RemoveMe()
		
		--temporarily set base buildings invulnerable
		EGroup_SetInvulnerable(eg_p_baseBuildings, 0.25, 180)
		sg_e_allNearPlayerHQ = SGroup_CreateIfNotFound("sg_e_allNearPlayerHQ")
		tmr_T34_arrival = 0034
		Timer_Start(tmr_T34_arrival, 120)
		Rule_AddDelayedInterval(OBJ_HTV_T34s_Arrive, 3, 1)
	end

end

function OBJ_HTV_HideTimerObj()
	if Objective_IsStarted(OBJ_RetakeVillagePoint) then 
		Objective_Complete(OBJ_RetakeVillagePoint, false) 
	end
	if Objective_IsVisible(OBJ_RetakeVillagePoint) then
		Objective_Show(OBJ_RetakeVillagePoint, false)
	end
end

function _flashProgressBar(duration)
	_enableProgressBarBlinking()
	Rule_AddOneShot(_disableProgressBarBlinking, duration)
end

function _enableProgressBarBlinking()
	Obj_SetProgressBlinking(true)
end

function _disableProgressBarBlinking()
	Obj_SetProgressBlinking(false)
end

-- NISlet: T34s Arrive to help the player re-take the ridge
function OBJ_HTV_T34s_Arrive()
	Player_GetAllSquadsNearMarker(player2, sg_e_allNearPlayerHQ, mkr_playerHQ, 45)
	local player1SquadCount = Player_GetSquadCount(player1)
	local player2SquadCount = SGroup_Count(sg_e_allNearPlayerHQ)
	
	if (player1SquadCount <= 4) or (player2SquadCount >= 4) or Timer_GetElapsed(tmr_T34_arrival) > 60 then
		g_spawnLeft = false
		g_spawnMid = false
		g_spawnRight = false

		sg_p_t34s = SGroup_CreateIfNotFound("sg_p_t34s")
		t_t34_targetMarkers = {mkr_e_VIL_leftDynSpawn, mkr_e_VIL_midDynSpawn, mkr_e_VIL_rightDynSpawn, mkr_e_VIL_leftTar_01, mkr_e_VIL_midTar_01, mkr_e_VIL_rightTar_01}
		Sound_StopMusic(CAMPAIGN_MUSIC_FADEOUT,0)
		Rule_AddDelayedInterval(OBJ_HTV_T34s_PostNIS2, 1, 4)
		
		ThreatArrow_DestroyAllGroups()
		Rule_RemoveMe()
	end
end

function OBJ_HTV_T34s_PostNIS2()
	if Event_IsAnyRunning() == false then
		local dest = Marker_GetPosition(t_t34_targetMarkers[SGroup_Count(sg_p_t34s) + 1])
		Util_CreateSquads(player3, sg_p_t34s, SBP.SOVIET.T_34_76_SQUAD, mkr_p_t34_spawn2, dest, 1, 1, true)
		local dest = Marker_GetPosition(t_t34_targetMarkers[SGroup_Count(sg_p_t34s) + 1])
		Util_CreateSquads(player3, sg_p_t34s, SBP.SOVIET.T_34_76_SQUAD, mkr_p_t34_spawn, dest, 1, 1, true)
		local dest = Marker_GetPosition(t_t34_targetMarkers[SGroup_Count(sg_p_t34s) + 1])
		Util_CreateSquads(player3, sg_p_t34s, SBP.SOVIET.T_34_76_SQUAD, mkr_p_t34_spawn3, dest, 1, 1, true)
		local t34_count = 6
		if g_hardDiff then
			t34_count = 3
		end
		if SGroup_Count(sg_p_t34s) == t34_count then
			Rule_RemoveMe()
			Rule_AddOneShot(OBJ_HTV_T34s_Delayed_Speech, 5)
			Rule_AddOneShot(RTR_ReinforceRidgeDefenders, 20)
			Rule_AddOneShot(T34_SetPlayerOwned, 20)
			sg_e_tanks = Player_GetSquads(player2)
			SGroup_Filter(sg_e_tanks, SBP.GERMAN.STUG_III_E_SQUAD, FILTER_KEEP)
			if (not SGroup_IsEmpty(sg_e_tanks)) and (not g_hardDiff) then
				Modify_Armor(sg_e_tanks, 0.666)
			end
			-- Fire German howitzers during final beat
			g_germanGunIndex = 1
			Rule_AddInterval(RTR_GermanArtillery, 30)
			sg_playerSquads = Player_GetSquads(player1)
			eg_playerEntities = Player_GetEntities(player1)
			SGroup_SetInvulnerable(sg_playerSquads, true)
			EGroup_SetInvulnerable(eg_playerEntities, true)
			Game_FadeToBlack(FADE_OUT, 1)
			Sound_PlayMusic("streamed/music/missions/m03/m03_cue_retake_ridge", 0, 0)
			Sound_SetMusicCombatValue(3, 20)
			Rule_AddOneShot(T34_StartArrivalNIS, 1.5)
			if not g_hardDiff then
				SGroup_IncreaseVeterancyExperience(sg_p_t34s, 1000, true, true)
			end
		end
	end
end

T34_Autosave = function ()
	--- CHECKPOINT AUTOSAVE #2 ---
	Subtitle_EndCurrentSpeech()
	Util_Autosave(11049962, nil, true)	-- LOCDB [11049962] 'Mission 3 - Autosave 2'
end

T34_ReturnToGameplay = function ()
	Game_FadeToBlack(FADE_IN, 1)
	SGroup_SetInvulnerable(sg_playerSquads, false)
	EGroup_SetInvulnerable(eg_playerEntities, false)
	EGroup_DeSpawn(eg_germanMines)
	FOW_PlayerRevealArea(player1, Marker_GetPosition(mkr_RDG_check), 90, -1)
	-- Update retreat/fallback threshold for enemies in the village
	for k,v in pairs(g_enc_villageWave7) do
		if v:IsAlive() and SGroup_Count(v.sgroup) > 0 then
			local goalData = v:GetGoalData()
			local player1Squads = Player_GetSquads(player1)
			goalData.coordinatedSetup = true
			goalData.coordinatedSetupFacingPositions = nil
			goalData.fallbackParams = {
				thresholds = {0.75},
				thresholdType = Threshold_PercentageEntitiesRemaining,
				markers = {Table_GetRandomItem({mkr_e_retreat_01, mkr_e_retreat_02, mkr_e_retreat_03})},
				retreat = true,
			}
			if SGroup_Count(player1Squads) > 2 then
				goalData.coordinatedSetup = true
				goalData.coordinatedSetupFacingPositions = {}
				for i = 1, SGroup_Count(player1Squads) do 
					table.insert(goalData.coordinatedSetupFacingPositions, SGroup_GetSpawnedSquadAt(player1Squads, i))
				end
			end
			v:UpdateGoal(goalData)
		end
	end
	
	Player_AddAbility(player1, BP_GetAbilityBlueprint("soviet_war_machine_sp"))
	if Player_GetResource(player1, RT_Munition) >= 200 then
		flash_warMachine = UI_FlashAbilityButton(BP_GetAbilityBlueprint("soviet_war_machine_sp"), true)
	end
end

T34_StartArrivalNIS = function ()
	local onComplete = function ()
		Camera_FollowSquad(SGroup_GetSpawnedSquadAt(sg_p_t34s, 2))
		Camera_SetInputEnabled(true)
		Camera_ResetToDefault()
		Rule_AddOneShot(T34_ReturnToGameplay, 1)
	end
	Sound_SetMusicCombatValue(3, 20)
	Util_StartNIS(NIS02, nil, nil, nil, onComplete)
end

function T34_RemoveHintpoints()
	if Misc_IsSGroupSelected(sg_p_t34s, ANY) then
		Rule_AddOneShot(T34_RemoveHintpoints_delayed, 20)
		Rule_RemoveMe()
	end
end

function T34_RemoveHintpoints_delayed()
	HintPoint_Remove(hint_t34_1)
	HintPoint_Remove(hint_t34_2)
	HintPoint_Remove(hint_t34_3)
	if flash_warMachine ~= nil then
		UI_StopFlashing(flash_warMachine)
	end
end

function T34_SetPlayerOwned()
	SGroup_SetPlayerOwner(sg_p_t34s, player1)
	Util_ReinforceEvent(sg_p_t34s)
	hint_t34_1 = HintPoint_Add(SGroup_GetSpawnedSquadAt(sg_p_t34s, 1), true, 11035344, 1, HPAT_Hint, "Icons_portraits_vehicle_soviet_t34_76_w_portrait") -- LOCDB [11035344] 'Use T-34s to help re-take the ridge'
	hint_t34_2 = HintPoint_Add(SGroup_GetSpawnedSquadAt(sg_p_t34s, 2), true, 11035344, 1, HPAT_Hint, "Icons_portraits_vehicle_soviet_t34_76_w_portrait")
	hint_t34_3 = HintPoint_Add(SGroup_GetSpawnedSquadAt(sg_p_t34s, 3), true, 11035344, 1, HPAT_Hint, "Icons_portraits_vehicle_soviet_t34_76_w_portrait")
	Rule_AddDelayedInterval(T34_RemoveHintpoints, 6, 1)
	Player_SetPopCapOverride(player1, 125)
	if not g_hardDiff then
		Modify_WeaponAccuracy(sg_p_t34s, "hardpoint_01", 10)
	end
end


--Tell village attackers to defend if they manage to clear their attack target marker 
--Otherwise they can get stuck out of combat 
function HTV_UpdateGoal_Defend(enc)
	local defendTargets = {mkr_e_VIL_rightTar_01, mkr_e_VIL_midTar_01, mkr_e_VIL_leftTar_01}
	sg_p_allPlayerSquads = Player_GetSquads(player1)
	local goalData = {
		name = "Defend",
		target = Table_GetRandomItem(defendTargets),
		onSuccess = HTV_UpdateGoal_Defend,
		attackMove = true,
	}
	if not SGroup_IsEmpty(sg_p_allPlayerSquads) then 
		goalData.coordinatedSetup = true
		goalData.coordinatedSetupFacingPositions = {}
		for i = 1, SGroup_CountSpawned(sg_p_allPlayerSquads) do 
			table.insert(goalData.coordinatedSetupFacingPositions, SGroup_GetSpawnedSquadAt(sg_p_allPlayerSquads, i))
		end
	end
	if not SGroup_IsEmpty(enc.sgroup) then
		enc:SetGoal(goalData)
	end
end
--
function Update_Attacker_Goals_VIL()

	local goalData = {
		name = "Defend",
		target = mkr_e_VIL_leftTar_01,
		useSkirmishAI = g_useSkirmishAI,
		
		fallback = true,
		fallbackParams = {
			thresholds = {0.05},
			thresholdType = Threshold_PercentageEntitiesRemaining,
			markers = {mkr_e_retreat_01},
			retreat = true,
			retreatDespawn = true,
		},
	}
	if not SGroup_IsEmpty(encID_wave7Left_CP.sgroup) then
		encID_wave7Left_CP:SetGoal(goalData)
	end
	
	local goalData = {
		name = "Defend",
		target = mkr_e_VIL_midTar_01,
		useSkirmishAI = g_useSkirmishAI,
		
		fallback = true,
		fallbackParams = {
			thresholds = {0.4},
			thresholdType = Threshold_PercentageEntitiesRemaining,
			markers = {mkr_e_retreat_02},
			retreat = true,
			retreatDespawn = true,
		},
	}
	if not SGroup_IsEmpty(encID_wave7Mid_CP.sgroup) then
		encID_wave7Mid_CP:SetGoal(goalData)
	end
	
	local goalData = {
		name = "Defend",
		target = mkr_e_VIL_rightTar_01,
		useSkirmishAI = g_useSkirmishAI,
		
		fallback = true,
		fallbackParams = {
			thresholds = {0.05}, 
			thresholdType = Threshold_PercentageEntitiesRemaining,
			markers = {mkr_e_retreat_03},
			retreat = true,
			retreatDespawn = true,
		},
	}
	if not SGroup_IsEmpty(encID_wave7Right_CP.sgroup) then
		encID_wave7Right_CP:SetGoal(goalData)
	end

end

function OBJ_HTV_T34s_Delayed_Speech()

	Util_StartIntel(EVENTS.T34s_ARRIVE)
	
	Rule_AddDelayedInterval(OBJ_HTV_Complete, 1.5, 1)

end

function OBJ_HTV_Complete()

	if Event_IsAnyRunning() == false then
		Rule_RemoveMe()
		
		Objective_Complete(OBJ_HoldTheVillage, false)
		T34_Autosave()
		Rule_AddDelayedInterval(OBJ_RTR_Delay_Start, 1.5, 1)
	end

end

-- FAIL CONDITION: The player has no HQ
function Loss_NoHQ()
	local playerEntities = Player_GetEntities(player1)
	local ebps = EBP.SOVIET.HQ
	EGroup_Filter(playerEntities, ebps, FILTER_KEEP)
	if EGroup_IsEmpty(playerEntities) then
		Util_MissionTitle(11048793, 1, 5, 1)
		Rule_AddOneShot(_delayedMissionFail, 8)
		Rule_RemoveMe()
	end
end

function _delayedMissionFail()
	Game_EndSP(false)
end

---- German artillery during final beat ----
function RTR_GermanArtillery()
	local guns = {sg_e_RDG_arty01, sg_e_RDG_arty02, sg_e_RDG_arty03, sg_e_RDG_arty04, sg_e_RDG_arty05, sg_e_RDG_arty06}
	local targets = {mkr_e_artillery01, mkr_e_artillery02, mkr_e_artillery03, mkr_e_artillery04, mkr_e_artillery05, mkr_e_artillery06}
	for i = g_germanGunIndex, 6 do
		if scartype(guns[i]) == ST_SGROUP then
			if not SGroup_IsEmpty(guns[i]) then
				if SGroup_HasTeamWeapon(guns[i], ANY) then
					Cmd_Ability(guns[i], ABILITY.GERMAN.HOWITZER_105MM_BARRAGE_ABILITY, targets[i], nil, true)
					break
				end
			end
		end
	end
	if g_germanArtyIntelPlayed == nil then
		Util_StartIntel(EVENTS.RTR_GermanArty)
		g_germanArtyIntelPlayed = true
	end
	if g_germanGunIndex == 6 then
		g_germanGunIndex = 1
	else
		g_germanGunIndex = g_germanGunIndex + 1
	end
end

----------------------
-- Objective 3 : Re-take the Ridge
-- PRIMARY
----------------------
function OBJ_RTR_Delay_Start()

	if Event_IsAnyRunning() == false then
		Rule_RemoveMe()
		Objective_Start(OBJ_RetakeTheRidge)
	end

end

function Initialize_RetakeTheRidge()

	OBJ_RetakeTheRidge = {
		
		SetupUI = function() 
			hpid_DTH_01 = Objective_AddUIElements(OBJ_RetakeTheRidge, eg_POS_A_Points_01, true, 11007307, nil, 3.8)	-- LOCDB [11007307] 'Clear the Point'
			hpid_DTH_02 = Objective_AddUIElements(OBJ_RetakeTheRidge, eg_POS_A_Points_02, true, 11007307, nil, 3.8)
			hpid_DTH_03 = Objective_AddUIElements(OBJ_RetakeTheRidge, eg_POS_A_Points_03, true, 11007307, nil, 3.8)
		end,
		
		OnStart = function()
		
			Objective_Start(SOBJ_RetakeTheRidge_Capture, false)
			Objective_Start(SOBJ_RetakeTheRidge_Kill, false)
			RTR_PullBackVillageAttackers()
			-- Speech Events, urging the player to move up and clear the ridge
			Rule_AddOneShot(OBJ_RTR_UrgeSpeech1, 60)
		end,
		
		OnComplete = function()
			Achievement_PreserveT34s()
			Game_FadeToBlack(FADE_OUT, 2)
			Rule_AddDelayedInterval(Mission_Complete, 2, 1)
			Outro_MovePlayerSquads()
		end,
		
		OnFail = function()
			-- Calls from Objective_Fail(OBJ_Objective1)
			-- Fires off before Intel_Fail (unless Intel_Fail is nil)			
		end,
		
		IsComplete = function()
			return false
		end,
		
		Intel_Start = EVENTS.RTR_Start,				-- Event will play when obj starts but before any UI appears
		Intel_Complete = EVENTS.RTR_Complete,			-- Event will play when obj completes but before UI is cleared
		Intel_Fail = nil,				-- Event will play when obj fails but before UI is cleared
		Title = 11008204,				-- LOCDB [11008204] 'Re-take the Ridge'
		Description = 11008205,			-- LOCDB [11008205] 'With the arrival of our T-34s, we now have the initiative - re-take the ridge for The Motherland!'
		TitleEnd = 11008206,				-- LOCDB [11008206] 'Ridge Taken'
		TitleFail = nil,			-- Failed Title
		Type = OT_Primary,				-- Objective Type (OT_Primary, OT_Secondary)
		SitRep = {},
	}
	
	Objective_Register(OBJ_RetakeTheRidge)

end

function Initialize_RetakeTheRidge_Capture()

	SOBJ_RetakeTheRidge_Capture = {
	
		Parent = OBJ_RetakeTheRidge,
		
		SetupUI = function() 

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
			return false
		end,
		
		Intel_Start = nil,				-- Event will play when obj starts but before any UI appears
		Intel_Complete = nil,			-- Event will play when obj completes but before UI is cleared
		Intel_Fail = nil,				-- Event will play when obj fails but before UI is cleared
		Title = 11035345, -- LOCDB [11035345] 'Capture all territory on the ridge, OR...'
		Description = 11035345,			-- LOCDB [11008205] 'With the arrival of our T-34s, we now have the initiative - re-take the ridge for The Motherland!'
		TitleEnd = nil,				-- LOCDB [11008206] 'Ridge Taken'
		TitleFail = nil,			-- Failed Title
		Type = OT_Primary,				-- Objective Type (OT_Primary, OT_Secondary)
		SitRep = {},
	}
	
	Objective_Register(SOBJ_RetakeTheRidge_Capture)

end

function Initialize_RetakeTheRidge_Kill()

	SOBJ_RetakeTheRidge_Kill = {
	
		Parent = OBJ_RetakeTheRidge,
		
		SetupUI = function() 

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
			return false
		end,
		
		Intel_Start = nil,				-- Event will play when obj starts but before any UI appears
		Intel_Complete = nil,			-- Event will play when obj completes but before UI is cleared
		Intel_Fail = nil,				-- Event will play when obj fails but before UI is cleared
		Title = 11035346, -- LOCDB [11035346] 'Destroy all enemy forces on the ridge'
		Description = 11035345,			-- LOCDB [11008205] 'With the arrival of our T-34s, we now have the initiative - re-take the ridge for The Motherland!'
		TitleEnd = nil,				-- LOCDB [11008206] 'Ridge Taken'
		TitleFail = nil,			-- Failed Title
		Type = OT_Primary,				-- Objective Type (OT_Primary, OT_Secondary)
		SitRep = {},
	}
	
	Objective_Register(SOBJ_RetakeTheRidge_Kill)

end

-- Speech Events, urging the player to move up and clear the ridge
function OBJ_RTR_UrgeSpeech1()
	if not g_missionIsComplete then
		Util_StartIntel(EVENTS.RTR_Urge_01)
		Rule_AddOneShot(OBJ_RTR_UrgeSpeech2, 60)
	end
end

function OBJ_RTR_UrgeSpeech2()
	if not g_missionIsComplete then
		Util_StartIntel(EVENTS.RTR_Urge_02)
		Rule_AddOneShot(OBJ_RTR_UrgeSpeech3, 60)
	end
end

function OBJ_RTR_UrgeSpeech3()
	if not g_missionIsComplete then
		Util_StartIntel(EVENTS.RTR_Urge_03)
	end
end

function OBJ_RTR_StartOutroNIS()
	sg_outroMove = SGroup_CreateIfNotFound("sg_outroMove")
	
	if not SGroup_IsEmpty(sg_p_t34s) then
		Cmd_Stop(sg_p_t34s)
	end
	
	Player_ClearArea(player1, mkr_outroTank1, false)
	Player_ClearArea(player1, mkr_outroTank2, false)
	Player_ClearArea(player1, mkr_outroTank3, false)
	Util_ClearWrecksFromMarker(mkr_outroTank1)
	Util_ClearWrecksFromMarker(mkr_outroTank2)
	Util_ClearWrecksFromMarker(mkr_outroTank3)
	
	if SGroup_Count(sg_p_t34s) >=1 then
		local squad = SGroup_GetSpawnedSquadAt(sg_p_t34s, 1)
		Squad_WarpToPos(squad, Marker_GetPosition(mkr_outroTank1))
	end
	if SGroup_Count(sg_p_t34s) >=2 then
		local squad = SGroup_GetSpawnedSquadAt(sg_p_t34s, 2)
		Squad_WarpToPos(squad, Marker_GetPosition(mkr_outroTank2))
	end
	if SGroup_Count(sg_p_t34s) >=3 then
		local squad = SGroup_GetSpawnedSquadAt(sg_p_t34s, 3)
		Squad_WarpToPos(squad, Marker_GetPosition(mkr_outroTank3))
	end
	_player2Squads = Player_GetSquads(player2)
	SGroup_DestroyAllSquads(_player2Squads)
	Game_FadeToBlack(FADE_IN, 0)
	Util_StartNIS(EVENTS.NIS03)
	EGroup_ReSpawn(eg_gravestones)
end

function Outro_MovePlayerSquads()
	Game_EnableInput(false)
	Player_GetAll(player1)
	SGroup_RemoveGroup(sg_allsquads, sg_p_t34s)
	if not SGroup_IsEmpty(sg_allsquads) then
		SGroup_SetSelectable(sg_allsquads, false)
		SGroup_EnableUIDecorator(sg_allsquads, false)
		SGroup_SetInvulnerable(sg_allsquads, true)
		SGroup_IsEmpty(sg_allsquads)
		g_playerSquadSpacing = math.max((160/SGroup_Count(sg_allsquads)), 12)
		Cmd_Stop(sg_allsquads)
		sg_outroMove = SGroup_CreateIfNotFound("sg_outroMove")
		local dest = World_Pos(26, 12.6, 104)
		local f = function (gid, idx, sid)
			SGroup_Clear(sg_outroMove)
			SGroup_Add(sg_outroMove, sid)
			Cmd_Move(sg_outroMove, dest)
			dest.x = dest.x - g_playerSquadSpacing
		end
		SGroup_ForEach(sg_allsquads, f)
	else
		g_playerSquadSpacing = 10
	end
		
end

function RTR_Ping_Cleanup()
	-- remove pings if points are captured OR areas are clear of enemies
	if (Player_OwnsEGroup(player1, eg_POS_A_Points_01, ANY) or not Player_CanSeePosition(player2, Marker_GetPosition(mkr_RDG_canSeeLeft))) and not g_point1Retaken then
		g_point1Retaken = true
		Objective_RemoveUIElements(OBJ_RetakeTheRidge, hpid_DTH_01)
	end
	
	if (Player_OwnsEGroup(player1, eg_POS_A_Points_02, ANY) or not Player_CanSeePosition(player2, Marker_GetPosition(mkr_RDG_canSeeMid))) and not g_point2Retaken then
		g_point2Retaken = true
		Objective_RemoveUIElements(OBJ_RetakeTheRidge, hpid_DTH_02)
	end
	
	if (Player_OwnsEGroup(player1, eg_POS_A_Points_03, ANY) or not Player_CanSeePosition(player2, Marker_GetPosition(mkr_RDG_canSeeRight))) and not g_point3Retaken then
		g_point3Retaken = true
		Objective_RemoveUIElements(OBJ_RetakeTheRidge, hpid_DTH_03)
	end

end

function RTR_ReinforceRidgeDefenders()
	sg_e_ridgeDefenders = SGroup_CreateIfNotFound("sg_e_ridgeDefenders")
	
	-- Territory-point defenders
	local encDataLeft = {
		name = "finalDefendersLeft",
		player = player2,
		dynamicSpawnTarget = mkr_e_RDG_leftDest,
		spawn = mkr_e_RDG_leftSpawn_01,
		sgroups = {sg_e_ridgeDefenders},
		units = {
			{
				sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
			},
			{ 
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
			},
			{
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
			},
			{
				sbp = SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD,
			},
		},
	}
	
	local encDataMid = {
		name = "finalDefendersMid",
		player = player2,
		dynamicSpawnTarget = mkr_e_RDG_midDest,
		spawn = mkr_e_RDG_midSpawn_01,
		sgroups = {sg_e_ridgeDefenders},
		units = {
			{
				sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
			},
			{ 
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
			},
			{
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
			},
			{
				sbp = SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD,
			},
		},
	}
	
	local encDataRight = {
		name = "finalDefendersRight",
		player = player2,
		dynamicSpawnTarget = mkr_e_RDG_rightDest,
		spawn = mkr_e_RDG_rightSpawn_01,
		sgroups = {sg_e_ridgeDefenders},
		units = {
			{
				sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
			},
			{ 
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
			},
			{
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
			},
			{
				sbp = SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD,
			},
		},
	}
	
	
	local defendData = {
		name = "Defend",
		target = mkr_e_RDG_leftDest,
		useSkirmishAI = g_useSkirmishAI,
		
		tacticTargetPreference = AITacticTargetPreference_Near,
		retaliateAttacks = true,
		
		range = 45,
		leashRange = 23,
		
		coordinatedSetup = true,
		coordinatedSetupFacingPositions = {mkr_friendly_artillery_B_01, mkr_friendly_artillery_B_02, mkr_friendly_artillery_B_03},
		
		fallback = true,
		fallbackParams = {
			thresholds = {0.55},
			thresholdType = Threshold_PercentageEntitiesRemaining,
			markers = {mkr_e_retreat_01},
			retreat = true,
			retreatDespawn = true,
			
			abilityControlsList = {
				{
					abilityPBG = ABILITY.GERMAN.PANZER_GRENADIER_BUNDLED_CAMPAIGN,
					maxCasters = 1,
					maxRange = 50,
					waitTimeSecs = 45,
				},
			},
		},
	}
	
	Player_GetAllSquadsNearMarker(player2, sg_e_ridgeDefenders, mkr_e_RDG_leftDest, 25)
	if SGroup_Count(sg_e_ridgeDefenders) < 2 then
		encID_finalDefLeft = Encounter:Create(encDataLeft)
		encID_finalDefLeft:SetGoal(defendData)
	end
	Player_GetAllSquadsNearMarker(player2, sg_e_ridgeDefenders, mkr_e_RDG_midDest, 25)
	if SGroup_Count(sg_e_ridgeDefenders) < 2 then

		defendData.target = mkr_e_RDG_midDest
		defendData.coordinatedSetupFacingPositions = {mkr_friendly_artillery_B_02, mkr_friendly_artillery_B_03, mkr_friendly_artillery_B_04}
		encID_finalDefMid = Encounter:Create(encDataMid)
		encID_finalDefMid:SetGoal(defendData)
	end
	Player_GetAllSquadsNearMarker(player2, sg_e_ridgeDefenders, mkr_e_RDG_rightDest, 25)
	if SGroup_Count(sg_e_ridgeDefenders) < 2 then
		defendData.target = mkr_e_RDG_rightDest
		defendData.coordinatedSetupFacingPositions = {mkr_friendly_artillery_B_03, mkr_friendly_artillery_B_04, mkr_friendly_artillery_B_05}
		encID_finalDefRight = Encounter:Create(encDataRight)
		encID_finalDefRight:SetGoal(defendData)
	end
	
	--- Attacking vehicles, assisting the Germans on the ridge
	local encData = {
		name = "RTR_LeftVehicle",
		player = player2,
		spawn = mkr_e_RDG_leftSpawn_01,
		sgroups = {SGroup_CreateIfNotFound("sg_e_RTR_leftVehicle")},
		units = {
			{
				name = "RTR_LeftVehicle",
				sbp = SBP.GERMAN.SCOUTCAR_SDKFZ222,
			},
		},
	}
	g_enc_RTR_leftVehicle = Encounter:Create(encData)
	
	local encData = {
		name = "RTR_MidVehicle",
		player = player2,
		spawn = mkr_e_RDG_midSpawn_01,
		sgroups = {SGroup_CreateIfNotFound("sg_e_RTR_midVehicle")},
		units = {
			{
				name = "RTR_MidVehicle",
				sbp = SBP.GERMAN.SDKFZ_251_HALFTRACK_SQUAD,
				entityUpgrades = {UPG.GERMAN.SDKFZ_251_HALFTRACK_FLAMMPANZERWAGEN_UPGRADE},
			},
		},
	}
	g_enc_RTR_midVehicle = Encounter:Create(encData)
	
	local encData = {
		name = "RTR_RightVehicle",
		player = player2,
		spawn = mkr_e_RDG_rightSpawn_01,
		sgroups = {SGroup_CreateIfNotFound("sg_e_RTR_rightVehicle")},
		units = {
			{
				name = "RTR_RightVehicle",
				sbp = SBP.GERMAN.SCOUTCAR_SDKFZ222,
			},
		},
	}
	g_enc_RTR_rightVehicle = Encounter:Create(encData)
	
	-- Light vehicle reinforcements on the ridge
	Rule_Remove(RTR_SendInLeftVehicle)
	Rule_Remove(RTR_SendInMidVehicle)
	Rule_Remove(RTR_SendInRightVehicle)
	Rule_AddDelayedInterval(RTR_SendInLeftVehicle, 5, 1)
	Rule_AddDelayedInterval(RTR_SendInMidVehicle, 5, 1)
	Rule_AddDelayedInterval(RTR_SendInRightVehicle, 5, 1)

	
	-- Mission Completion Check
	Rule_AddDelayedInterval(RTR_Complete_Check, 30, 1)
	Rule_AddDelayedInterval(RTR_Ping_Cleanup, 30, 1)	
	
	ThreatArrow_CreateGroup(sg_e_ridgeDefenders)
	
end

function RTR_SendInLeftVehicle()
	if SGroup_IsEmpty(sg_p_t34s) or SGroup_IsEmpty(g_enc_RTR_leftVehicle.sgroup) then
		Rule_RemoveMe()
	elseif Prox_AreSquadsNearMarker(sg_p_t34s, mkr_e_RDG_leftDest, ANY, 35) then
		local goalData = {
			name = "Attack",
			target = mkr_e_RDG_leftDest,
			tacticControlsList = g_disableVehicleTactic,
			range = 45,
			leashRange = 60,
			attackMove = true,
			safeMoveWeight = 0,
		}
		g_enc_RTR_leftVehicle:SetGoal(goalData)
		Rule_RemoveMe()
	end
end

function RTR_SendInMidVehicle()
	if SGroup_IsEmpty(sg_p_t34s) or SGroup_IsEmpty(g_enc_RTR_midVehicle.sgroup) then
		Rule_RemoveMe()
	elseif Prox_AreSquadsNearMarker(sg_p_t34s, mkr_e_RDG_midDest, ANY, 40) then
		local goalData = {
			name = "Attack",
			target = mkr_e_RDG_midDest,
			tacticControlsList = g_disableVehicleTactic,
			range = 45,
			leashRange = 60,
			attackMove = true,
			safeMoveWeight = 0,
		}
		g_enc_RTR_midVehicle:SetGoal(goalData)
		Rule_RemoveMe()
	end
end

function RTR_SendInRightVehicle()
	if SGroup_IsEmpty(sg_p_t34s) or SGroup_IsEmpty(g_enc_RTR_rightVehicle.sgroup) then
		Rule_RemoveMe()
	elseif Prox_AreSquadsNearMarker(sg_p_t34s, mkr_e_RDG_rightDest, ANY, 40) then
		local goalData = {
			name = "Attack",
			target = mkr_e_RDG_rightDest,
			tacticControlsList = g_disableVehicleTactic,
			range = 45,
			leashRange = 60,
			attackMove = true,
			safeMoveWeight = 0,
		}
		g_enc_RTR_rightVehicle:SetGoal(goalData)
		Rule_RemoveMe()
	end
end

function RTR_PullBackVillageAttackers()
-- Pull village attackers back across the river when T-34s arrive
-- encID_wave7Left encID_wave7Mid encID_wave7Right encID_wave7Left_CP encID_wave7Mid_CP encID_wave7Right_CP
	local defendData = {
		name = "Defend",
		target = mkr_friendly_artillery_B_01,
		range = 50,
		leashRange = 30,
		retaliateAttacks = true,
		coordinatedSetup = true,
		coordinatedSetupFacingPositions = {mkr_e_VIL_leftTar_01, mkr_e_VIL_midTar_01, mkr_e_VIL_rightTar_01},
		fallback = true,
		fallbackParams = {
			thresholds = {0.05},
			thresholdType = Threshold_PercentageEntitiesRemaining,
			markers = {mkr_e_retreat_01},
			retreat = true,
			retreatDespawn = true,
		},
	}
	encID_wave7Left:SetGoal(defendData)
	
	defendData.target = mkr_friendly_artillery_B_02
	encID_wave7Left_CP:SetGoal(defendData)
	
	defendData.target = mkr_friendly_artillery_B_03
	defendData.fallbackParams.markers = {mkr_e_retreat_02}
	encID_wave7Mid:SetGoal(defendData)
	
	defendData.target = mkr_friendly_artillery_C_01
	encID_wave7Mid_CP:SetGoal(defendData)	
	
	defendData.target = mkr_friendly_artillery_B_04
	defendData.fallbackParams.markers = {mkr_e_retreat_03}
	encID_wave7Right:SetGoal(defendData)	
	
	defendData.target = mkr_friendly_artillery_B_05
	encID_wave7Right_CP:SetGoal(defendData)	
	
end
-----

function RTR_Complete_Check()
	-- complete objective if points are captured OR areas are clear of enemies
	if Player_OwnsEGroup(player1, eg_POS_A_Points, ALL) or (g_point1Retaken and g_point2Retaken and g_point3Retaken) then
		Rule_RemoveMe()
		
		Objective_Complete(SOBJ_RetakeTheRidge_Capture, false)
		Objective_Complete(SOBJ_RetakeTheRidge_Kill, false)
		
		Objective_Complete(OBJ_RetakeTheRidge)
		RTR_RetreatRemainingEnemies()
		Rule_AddInterval(RTR_RetreatRemainingEnemies, 5)
	end

end

function RTR_RetreatRemainingEnemies()
	local player2Squads = Player_GetSquads(player2)
	if SGroup_Count(player2Squads) > 0 then
		Cmd_Retreat(player2Squads, Marker_GetPosition(mkr_trash), nil, nil, nil, nil, true)
	end
end

function Mission_Complete()

	if Event_IsAnyRunning() == false then
		Rule_RemoveMe()
		
		-- DEV
		-- Print out Timings
		print("********************************")
		print("********************************")
		print("WAVE TIMINGS")
		print("USED FOR TUNING")
		print("------------")
		print("RDG_Wave2: "..g_dev_rdg_wave2)
		print("RDG_Wave3: "..g_dev_rdg_wave3)
		print("RDG_Wave4: "..g_dev_rdg_wave4)
		print("RDG_Wave5: "..g_dev_rdg_wave5)
		
		print("VIL_Wave2: "..g_dev_vil_wave2)
		print("VIL_Wave3: "..g_dev_vil_wave3)
		print("VIL_Wave4: "..g_dev_vil_wave4)
		print("VIL_Wave5: "..g_dev_vil_wave5)
		print("VIL_Wave6: "..g_dev_vil_wave6)
		print("********************************")
		print("********************************")
		
		Game_EndSP(true)
	end

end

function Mission_Fail()
	
	Event_Skip()
	Rule_RemoveMe()
	
	UI_ScreenFade(118, 74, 29, 100, 7, false)
	
	Util_MuteAmbientSound(true, 4.5)
	
	Rule_AddOneShot(Mission_Fail_Complete, 6.8)

end

function Mission_Fail_Complete()

	Game_EndSP(false)

end



----- ACHIEVEMENTS -----

-- Capture at least 3 enemy weapons on the Ridge
function Achievement_EnemyWeaponsCaptured()
	Scar_CompleteIntelBulletinTask(player1, "camp03_support_borrow")
end

-- Place at least 10 mines before the Village defense
function Achievement_PlaceTenMines()
	local playerMines = Player_GetEntitiesFromType(player1, "mine")
	if EGroup_Count(playerMines) >= 10 then
		Scar_CompleteIntelBulletinTask(player1, "camp03_support_mines")
		Rule_RemoveMe()
	end
end

-- Re-take the Ridge without losing a vehicle on Hard difficulty
function Achievement_PreserveT34s()
	if g_hardDiff and SGroup_Count(sg_p_t34s) >= 3 then
		Scar_CompleteIntelBulletinTask(player1, "camp03_support_t34")
	end
end

--- DEBUG
--------------------
-- DEV: Skip to Village -- DEBUG FUNCTION
--------------------
function DEV_SkipToVillage()
	-- Note: This can only be fired off before the end of Wave1!!!
	-- Stop the Ambient Attacks
	Ambient_Attacks_Init()
	Ambient_Attacks_RetreatAndHold()
	
	__t_ambient.tar = "VILLAGE"
	
	-- Stop any current Waves
	if Rule_Exists(OBJ_HTR_Wave1) then Rule_Remove(OBJ_HTR_Wave1) end
	if Rule_Exists(OBJ_HTR_Wave1_Finished) then Rule_Remove(OBJ_HTR_Wave1_Finished) end
	
	if Rule_Exists(__capturePoints_Manager) then Rule_Remove(__capturePoints_Manager) end
	
	-- Complete the Ridge Objective
	Objective_Complete(OBJ_HoldTheRidge)
	
	-- Kill all squads
	Player_GetAll(player1)
	SGroup_DestroyAllSquads(sg_allsquads)
	
	-- Kill all allied quads
	Player_GetAll(player3)
	SGroup_DestroyAllSquads(sg_allsquads)
	
	EGroup_DeSpawn(eg_p_MEP_01)
	EGroup_ReSpawn(eg_p_MEP_02)
	
	-- Enemy cap all points
	EGroup_InstantCaptureStrategicPoint(eg_POS_A_Points, player2)
	
	-- Grant some resources 
	Player_SetResource(player1, RT_Manpower, 500)
	Player_SetResource(player1, RT_Munition, 105)
	Player_SetResource(player1, RT_Fuel, 10)
	
	EGroup_SetSelectable(eg_p_baseBuildings, true)
	Player_SetPopCapOverride(player1, 100)	
	
	-- Spawn enemy tanks
	-- Tanks spawn regardless
	local encData = {
		name = "Wave3_Left",
		player = player2,
		dynamicSpawnTarget = mkr_e_RDG_midDest,
		spawn = mkr_e_RDG_leftForestSpawn_01,
		sgroups = {SGroup_CreateIfNotFound("sg_e_RDG_pnzrIII"), SGroup_CreateIfNotFound("sg_e_RDG_pnzrIII_02")},
		units = {
			{
				name = "Wave1_Mid_A",
				sbp = SBP.GERMAN.STUG_III_E_SQUAD,
			},
		},
	}
	encID_stug02 = Encounter:Create(encData)
	
	local goalData = {
		name = "Attack",
		target = mkr_e_RDG_pnzrIII_02_def,
		useSkirmishAI = g_useSkirmishAI,
		tacticControlsList = g_disableVehicleTactic,
		range = 45,
		leashRange = 25,
		
		attackMove = true,
		safeMoveWeight = 0,
	}
	encID_stug02:SetGoal(goalData)
	
	local encData = {
		name = "Wave3_Left",
		player = player2,
		dynamicSpawnTarget = mkr_e_RDG_rightDest,
		spawn = mkr_e_RDG_rightForestSpawn_01,
		sgroups = {SGroup_CreateIfNotFound("sg_e_RDG_pnzrIII"), SGroup_CreateIfNotFound("sg_e_RDG_pnzrIII_04")},
		units = {
			{
				name = "Wave1_Mid_A",
				sbp = SBP.GERMAN.STUG_III_E_SQUAD,
			},
		},
	}
	encID_stug04 = Encounter:Create(encData)
	
	local goalData = {
		name = "Attack",
		target = mkr_e_RDG_pnzrIII_04_def,
		useSkirmishAI = g_useSkirmishAI,
		tacticControlsList = g_disableVehicleTactic,
		range = 0,
		leashRange = 0,
		
		attackMove = true,
		safeMoveWeight = 0,
	}
	encID_stug04:SetGoal(goalData)
	
	-- Tanks spawn regardless
	local encData = {
		name = "Wave3_Left",
		player = player2,
		dynamicSpawnTarget = mkr_e_RDG_leftDest,
		spawn = mkr_e_RDG_leftSpawn_01,
		sgroups = {SGroup_CreateIfNotFound("sg_e_RDG_pnzrIII"), SGroup_CreateIfNotFound("sg_e_RDG_pnzrIII_01")},
		units = {
			{
				name = "Wave1_Mid_A",
				sbp = SBP.GERMAN.STUG_III_E_SQUAD,
			},
		},
	}
	encID_stug01 = Encounter:Create(encData)
	
	local goalData = {
		name = "Attack",
		target = mkr_e_RDG_pnzrIII_01_def,
		useSkirmishAI = g_useSkirmishAI,
		tacticControlsList = g_disableVehicleTactic,
		range = 0,
		leashRange = 0,
		
		attackMove = true,
		safeMoveWeight = 0,
	}
	encID_stug01:SetGoal(goalData)
	
	local encData = {
		name = "Wave3_Left",
		player = player2,
		dynamicSpawnTarget = mkr_e_RDG_midDest,
		spawn = mkr_e_RDG_midSpawn_01,
		sgroups = {SGroup_CreateIfNotFound("sg_e_RDG_pnzrIII"), SGroup_CreateIfNotFound("sg_e_RDG_pnzrIII_03")},
		units = {
			{
				name = "Wave1_Mid_A",
				sbp = SBP.GERMAN.STUG_III_E_SQUAD,
			},
		},
	}
	encID_stug03 = Encounter:Create(encData)
	
	local goalData = {
		name = "Attack",
		target = mkr_e_RDG_pnzrIII_03_def,
		useSkirmishAI = g_useSkirmishAI,
		tacticControlsList = g_disableVehicleTactic,
		range = 0,
		leashRange = 0,
		
		attackMove = true,
		safeMoveWeight = 0,
	}
	encID_stug03:SetGoal(goalData)
	
	local encData = {
		name = "Wave3_Left",
		player = player2,
		dynamicSpawnTarget = mkr_e_RDG_rightDest,
		spawn = mkr_e_RDG_rightSpawn_01,
		sgroups = {SGroup_CreateIfNotFound("sg_e_RDG_pnzrIII"), SGroup_CreateIfNotFound("sg_e_RDG_pnzrIII_05")},
		units = {
			{
				name = "Wave1_Mid_A",
				sbp = SBP.GERMAN.STUG_III_E_SQUAD,
			},
		},
	}
	encID_stug05 = Encounter:Create(encData)
	
	local goalData = {
		name = "Attack",
		target = mkr_e_RDG_pnzrIII_05_def,
		useSkirmishAI = g_useSkirmishAI,
		tacticControlsList = g_disableVehicleTactic,
		range = 0,
		leashRange = 0,
		
		attackMove = true,
		safeMoveWeight = 0,
	}
	encID_stug05:SetGoal(goalData)
	
	Modifier_Remove(g_pnzrIII_range_mod)
	g_pnzrIII_range_mod = Modify_WeaponRange(SGroup_FromName("sg_e_RDG_pnzrIII"), "hardpoint_01", 0.75)
	
	SGroup_SetInvulnerable(SGroup_FromName("sg_e_RDG_pnzrIII"), true)
	
	-- Intiate defenders (delayed)
	Rule_AddOneShot(Enemy_Reinforce_Point01, 40)
	Rule_AddOneShot(Enemy_Reinforce_Point02, 40)
	Rule_AddOneShot(Enemy_Reinforce_Point03, 40)
	
	-- Spawn some additional units for the player
	sg_p_units = SGroup_CreateIfNotFound("sg_p_units")
	
	Util_CreateSquads(player1, sg_p_units, SBP.SOVIET.M1910_MAXIM_HEAVY_MACHINE_GUN_SQUAD, mkr_p_engineer02_spawn, nil, 1, 6)
	Util_CreateSquads(player1, sg_p_units, SBP.SOVIET.M1910_MAXIM_HEAVY_MACHINE_GUN_SQUAD, mkr_p_engineer02_spawn, nil, 1, 6)
	
	Util_CreateSquads(player1, sg_p_units, SBP.SOVIET.BASE_CONSCRIPT_SQUAD, mkr_p_engineer02_spawn, nil, 1, 6)
	Util_CreateSquads(player1, sg_p_units, SBP.SOVIET.BASE_CONSCRIPT_SQUAD, mkr_p_engineer02_spawn, nil, 1, 6)
	Util_CreateSquads(player1, sg_p_units, SBP.SOVIET.BASE_CONSCRIPT_SQUAD, mkr_p_engineer02_spawn, nil, 1, 6)
	Util_CreateSquads(player1, sg_p_units, SBP.SOVIET.BASE_CONSCRIPT_SQUAD, mkr_p_engineer01_spawn, nil, 1, 6)
	Util_CreateSquads(player1, sg_p_units, SBP.SOVIET.BASE_CONSCRIPT_SQUAD, mkr_p_engineer01_spawn, nil, 1, 6)
	Util_CreateSquads(player1, sg_p_units, SBP.SOVIET.BASE_CONSCRIPT_SQUAD, mkr_p_engineer01_spawn, nil, 1, 6)
	Util_CreateSquads(player1, sg_p_units, SBP.SOVIET.BASE_CONSCRIPT_SQUAD, mkr_p_engineer01_spawn, nil, 1, 6)
	Camera_Unclamp()
	Misc_RemoveCommandRestriction()
	
	-- Finally, fire off new OBJ
	HTP_UpdateObj()
	EGroup_SetPlayerOwner(eg_p_baseBuildings, player1)

end

