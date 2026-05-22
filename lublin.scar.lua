-------------------------------------------------------------------------
-------------------------------------------------------------------------

-- Company of Heroes 2
-- Mission 10: Lublin
-- Designer: Sacha Narine

-------------------------------------------------------------------------
-------------------------------------------------------------------------

import("ScarUtil.scar")
import("Beginner.scar")
import("Systems/AiManager/ai.scar")
import("Prototype/DeploymentPoints.scar")
import("Order227.scar")
import("Global_Values/CampaignGlobalConstants.scar")

-------------------------------------------------------------------------
-- [[ SETUP ]]
-------------------------------------------------------------------------

g_useSkirmishAI = true

function OnGameSetup()
	
	-- Required Players
	player1 = Setup_Player(1, 11038758, "soviet", 1)		-- player1 is always the human player
	player2 = Setup_Player(2, 11038759, "german", 2)		-- player2 is always the AI opponent
	player3 = Setup_Player(3, 11038758, "soviet", 1)		-- player3 is always the AI ally
	player227 = Setup_Player(4, 11038758, "soviet", 3) -- Soviet Commissar for Order 227

end



function OnGameRestore()
	
	-- function takes care of restoring all global mission parameters after a save/load
	player1 = World_GetPlayerAt(1)
	player2 = World_GetPlayerAt(2)
	player3 = World_GetPlayerAt(3)
	player227 = World_GetPlayerAt(4)
	UI_SetCPMeterVisibility(true)
	Rule_AddOneShot(M10_OnGameRestore, 1)
	Game_DefaultGameRestore()
end

function M10_OnGameRestore()
	UI_SetCPMeterVisibility(false)
end

function NIS_Init()
	NIS01 = "SP/CoH2_Campaign/M10-Lublin/nis/m10_intro_nislet"
	nis_load(NIS01)
	
	NIS03 = "SP/CoH2_Campaign/M10-Lublin/nis/m10_castle"
	nis_load(NIS03)
	
	NIS04 = "SP/CoH2_Campaign/M10-Lublin/nis/m10_outro_nislet"
	nis_load(NIS04)
	
	nis_setintransitiontime(0)
	nis_setouttransitiontime(0.5)
end

Scar_AddInit(NIS_Init)

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
	
	--[[ REGISTER OBJECTIVES ]]
	Initialize_Objective1()
	Initialize_Objective2()
	Initialize_Objective3()
	Initialize_Objective4()
	
	--[[ GAME START CHECK ]]
	
	_endIntroNIS = function ()
		Game_SubTextFade(11048265, 11048266, 0, 0, 0)
		Game_FadeToBlack(FADE_OUT, 0)
		g_sitrepStarted = true
		Modifier_Remove(mod_ceasefire)
		SGroup_DestroyAllSquads(sg_allies)
		FOW_UnRevealMarker(mkr_initialReveal)
		
		Util_PlayMovie("m10_sitrep", 1, 1, _delayedRevertUIMode, nil, true)
		Rule_AddDelayedInterval(Mission_MissionStart, 2, 0.5)
		UI_SetCPMeterVisibility(false)
	end
	
	_delayedRevertUIMode = function ()
		Game_FadeToBlack(FADE_IN, 0)
		Game_SetMode(UI_Normal) 
	end
	_delayedStartSitrep = function ()
		Rule_AddOneShot(_endIntroNIS, 0.5)
	end
	
	-- Spawn squads for intro camera
	Lublin_SpawnAllies()
	Lublin_SpawnSouthwest()
	Lublin_SpawnWest()
	FOW_RevealMarker(mkr_initialReveal, -1)
	Sound_PlayMusic("streamed/music/missions/m10/m10_cue_start_capture_market", 0, 0) 
	Util_StartIntel(EVENTS.Intro)
end

Scar_AddInit(OnInit)

function Mission_Debug()	
	-- looks for the command line option [-debug]
	if Misc_IsCommandLineOptionSet("debug") then
		g_debug = true
	end
end



function Mission_Restrictions()

	-- Utilize for setting restrictions on Units, players, etc
	-- eg: Player_SetAbilityAvailability()
	
	Player_SetPopCapOverride(player1, 100)
	Modify_PlayerResourceCap(player1, RT_Manpower, 2001, MUT_Addition)
	Modify_PlayerResourceCap(player1, RT_Munition, 901, MUT_Addition)
	Modify_PlayerResourceCap(player1, RT_Fuel, 601, MUT_Addition)
	
	Player_SetSquadProductionAvailability(player1, SBP.SOVIET.IS_2, ITEM_REMOVED)
	
end



function Mission_CpuInit()

	-- Utilize for controlling AI functionality
	-- eg: Player_SetResource(player2, RT_Manpower, 1000)
	-- eg: AI_EnableComponent(player2, false, COMPONENT_Attacking)
	
	g_enc_counterAttacks = nil
	sg_counterAttackers = SGroup_CreateIfNotFound("sg_counterAttackers")
	sg_counterAttackers_armor = SGroup_CreateIfNotFound("sg_counterAttackers_armor")
	sg_counterAttackers_inf = SGroup_CreateIfNotFound("sg_counterAttackers_inf")
	g_armorTable = {SBP.GERMAN.OSTWIND_SQUAD, SBP.GERMAN.PANZER_IV_SQUAD, SBP.GERMAN.STUG_III_SQUAD}
	g_infantryTable = {SBP.GERMAN.OSTRUPPEN_SQUAD, SBP.GERMAN.GRENADIER_SQUAD, SBP.GERMAN.PANZER_GRENADIER_SQUAD}
	g_counterAttackCount = 1

	--Using AI Manager
	g_enc_counterAttack_inf = {}
	g_enc_counterAttack_arm = {}
	g_counterattackTarget = mkr_playerStart
	
	t_encsToReinforce = {}
	
	Player_AddResource(player2, RT_Munition, 1500)
	Player_CompleteUpgrade(player2, BP_GetUpgradeBlueprint("panzerfaust_slow"))
	Player_CompleteUpgrade(player2, BP_GetUpgradeBlueprint("pioneer_demolition"))
	Player_SetAbilityAvailability(player2, ABILITY.GERMAN.GRENADIER_PANZERFAUST, ITEM_REMOVED)
	Player_SetAbilityAvailability(player2, ABILITY.GERMAN.MG42_PHOSPHORUS_ROUNDS, ITEM_REMOVED)
	
	--- Tactic Controls
	g_tactics_disableVehicle = {
		{
			tacticType = TACTIC_Vehicle,
			priority = -1,
		},
	}
	
	g_tactics_disableAbility = {
		{
			tacticType = TACTIC_Vehicle,
			priority = -1,
		},
	}
			

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
		startingRes_Command					= Util_DifVar( {2, 2, 2, 2} ),				-- Starting Command Points
		startingRes_Manpower				= Util_DifVar( {480, 360, 240, 240} ),		-- Starting Manpower
		startingRes_Munitions				= Util_DifVar( {90, 60, 30, 30} ),		-- Starting Munition
		startingRes_Fuel					= Util_DifVar( {80, 60, 40, 40} ),		-- Starting Fuel
		resourceRate_Manpower				= Util_DifVar( {1.2, 1, 1, 1} ),		-- Resource rate modifier for manpower
		resourceRate_Munitions				= Util_DifVar( {1.5, 1, 1, 1} ),
		resourceRate_Fuel					= Util_DifVar( {1.2, 1, 1, 1} ),
		counterArty_interval				= Util_DifVar( {90, 60, 45, 45} ),
		counterArty_attemptMax				= Util_DifVar( {10, 15, 20, 20} ),
		counterArty_successMax				= Util_DifVar( {3, 5, 10, 10} ),
		demoPioneers_interval				= Util_DifVar( {600, 90, 45, 45} ),
		demoPioneers_timeLimit				= Util_DifVar( {200, 1500, 2700, 2700} ),
		maxConcurrentAttackers				= Util_DifVar( {4, 5, 6, 6} ),
		-- 
		defaultAttackGoalData 					= Util_DifVar( {t_defaultGoalData_attackEasy, {}, t_defaultGoalData_attackHard, {}}),
		defaultDefendGoalData 					= Util_DifVar( {t_defaultGoalData_defendEasy, {}, t_defaultGoalData_defendHard, {}}),
		modifyAttackGoalData					= Util_DifVar( {t_goalData_attackEasy, {}, t_goalData_attackHard, {}}),
		modifyDefendGoalData					= Util_DifVar( {t_goalData_defendEasy, {}, t_goalData_defendHard, {}}),
	}
	
	AIAttackGoal_AdjustDefaultGoalData(t_difficulty.defaultAttackGoalData)
	AIDefendGoal_AdjustDefaultGoalData(t_difficulty.defaultDefendGoalData)	
	
	AIAttackGoal_SetModifyGoalData(t_difficulty.modifyAttackGoalData)
	AIDefendGoal_SetModifyGoalData(t_difficulty.modifyDefendGoalData)
	
	Modify_ProjectileDelayTime(player2, BP_GetEntityBlueprint("bundled_stielgranate_campaign"), CAMPAIGN_PGREN_BUNDLED_TIMER)
	
	-- German mines in the southwest area
	if g_easyDiff then
		EGroup_DestroyAllEntities(eg_normalMines)
		EGroup_Destroy(eg_normalMines)
	end
	if not g_hardDiff then
		EGroup_DestroyAllEntities(eg_hardMines)
		EGroup_Destroy(eg_hardMines)
	end
	
	-- set grenade timers (per difficulty)
	Modify_ProjectileDelayTime(player2, BP_GetEntityBlueprint("bundled_stielgranate_campaign"), CAMPAIGN_PGREN_BUNDLED_TIMER)
	
end

-------------------------------------------------------------------------
-- MISSION Preset 
-------------------------------------------------------------------------

function Mission_MissionPreset()

	-- Kicks off after SCAR Inits, but before MissionStart is called.
	-- Use for spawning units on the map at the start
	
	Game_Letterbox(true, 0)
	
	sg_p_all = SGroup_CreateIfNotFound("sg_p_all")
	sg_e_all = SGroup_CreateIfNotFound("sg_e_all")
	sg_baseHarass = SGroup_CreateIfNotFound("sg_baseHarass")
	
	sg_mergehints = SGroup_CreateIfNotFound("sg_mergehints")
	sg_reinforcehints = SGroup_CreateIfNotFound("sg_reinforcehints")
	eg_reinforcehints = EGroup_CreateIfNotFound("eg_reinforcehints")
	
	-- Player Starting Squads
	Util_CreateSquads(player1, sg_p_all, SBP.SOVIET.COMBAT_ENGINEER_SQUAD, mkr_playerStart)
	Util_CreateSquads(player1, sg_p_all, SBP.SOVIET.SHOCK_TROOPS, mkr_startingSquad1)
	Util_CreateSquads(player1, sg_p_all, SBP.SOVIET.PM_82_41_MORTAR_SQUAD, mkr_startingSquad2)
	Util_CreateSquads(player1, sg_p_all, SBP.SOVIET.M5_HALFTRACK_SQUAD, mkr_startingSquad3)
	Util_CreateSquads(player1, sg_p_all, SBP.SOVIET.SU_76M, mkr_startingSquad4)
	Util_CreateSquads(player1, sg_p_all, SBP.SOVIET.T_70M, mkr_startingSquad5)
	
	g_startingSquadsCount = SGroup_TotalMembersCount(sg_p_all, true)
	
	Player_SetResource(player1, RT_Manpower, t_difficulty.startingRes_Manpower)
	Player_SetResource(player1, RT_Munition, t_difficulty.startingRes_Munitions)
	Player_SetResource(player1, RT_Fuel, t_difficulty.startingRes_Fuel)
	
	Modify_PlayerResourceRate(player1, RT_Manpower, t_difficulty.resourceRate_Manpower)
	Modify_PlayerResourceRate(player1, RT_Munition, t_difficulty.resourceRate_Munitions)
	Modify_PlayerResourceRate(player1, RT_Fuel, t_difficulty.resourceRate_Fuel)
	
	if g_easyDiff then 
		Modify_Upkeep(player1, 0.5)
	end	
	
	Player_AddUnspentCommandPoints(player1, 17)
	mod_ceasefire = Modify_WeaponEnabled(sg_p_all, "hardpoint_01", false)
	Camera_FocusOnPosition(Marker_GetPosition(mkr_playerStart), false)
	
	-- Default Player Upgrades
	Player_AddAbility(player1, ABILITY.SOVIET.BASE_CONSCRIPT_DISPATCH)
	Player_AddAbility(player1, BP_GetAbilityBlueprint("frontoviki_conscript_dispatch"))
	Player_AddAbility(player1, ABILITY.SOVIET.PENAL_TROOP_DISPATCH_SP)
	Player_AddAbility(player2, ABILITY.GERMAN.STUKA_CLOSE_AIR_SUPPORT)
	Player_AddAbility(player3, ABILITY.GLOBAL.OFF_MAP_ARTILLERY_PERCISE)
	Player_AddAbility(player2, ABILITY.GERMAN.STUKA_BOMBING_STRIKE)
	Player_AddAbility(player2, ABILITY.GERMAN.GERMAN_WARNING_SMOKE)
	Player_SetAbilityAvailability(player1, ABILITY.SOVIET.CONSCRIPT_OORAH, ITEM_UNLOCKED)
	Player_CompleteUpgrade(player1,UPG.SOVIET.T34_85_UNLOCK)
	Player_CompleteUpgrade(player1, BP_GetUpgradeBlueprint("upgrade\\commander\\soviet\\passive\\shock_troops"))
	Player_CompleteUpgrade(player1, BP_GetUpgradeBlueprint("upgrade\\campaign\\disable_vehicle_criticals"))
	Player_SetAbilityAvailability(player1, BP_GetAbilityBlueprint("cmd_shock_troops"), ITEM_REMOVED)
	Player_SetAbilityAvailability(player1, BP_GetAbilityBlueprint("cmd_t34_85_medium_tank"), ITEM_REMOVED)
	Player_SetAbilityAvailability(player1, ABILITY.SOVIET.ISU_152_PIERCING_SHOT_ABILITY, ITEM_REMOVED)
	
	-- Commander Abilities
	Player_CompleteUpgrade(player1, UPG.SOVIET.FIRE_ARTILLERY)
	Player_CompleteUpgrade(player1, UPG.SOVIET.IL_2_SUPPORT)
	Player_AddAbility(player1, ABILITY.GLOBAL.TRANSFER_ORDERS)
	
	Modify_AbilityRechargeTime(player2, ABILITY.GERMAN.PANZERWERFER_ROCKET_BARRAGE, 0.2)
	--
	EGroup_SetInvulnerable(eg_castleWall, true)
	EGroup_EnableMinimapIndicator(eg_castle_all, false)
	EGroup_SetSelectable(eg_castle_all, false)
	local setInv = function (gid, idx, entity)
		Entity_SetInvulnerableMinCap(entity, 0.75, 0)
	end
	EGroup_ForEach(eg_castle_most, setInv)
	Cmd_CriticalHit(player1, eg_allTeamWeapons, CRIT.VEHICLE_ABANDON, 0)
	EGroup_DeSpawn(eg_outroCorpses)
	EGroup_EnableMinimapIndicator(eg_mm_unlock1, false)
	
	Rule_AddDelayedInterval(Lublin_GarrisonOstruppen, 60, 1)
	
	sectorID_castle = World_GetTerritorySectorID(Marker_GetPosition(mkr_castle))
	sectorID_east = World_GetTerritorySectorID(Marker_GetPosition(mkr_strat_east))
	sectorID_west = World_GetTerritorySectorID(Marker_GetPosition(mkr_strat_west))
	sectorID_south = World_GetTerritorySectorID(Marker_GetPosition(mkr_strat_south))
	sectorID_northwest = World_GetTerritorySectorID(Marker_GetPosition(mkr_strat_northwest))
	sectorID_north = World_GetTerritorySectorID(Marker_GetPosition(mkr_strat_north))
	sectorID_northeast = World_GetTerritorySectorID(Marker_GetPosition(mkr_strat_northEast))
	sectorID_southeast = World_GetTerritorySectorID(Marker_GetPosition(mkr_southEast5))
	
	--227
	UI_SetSoviet227Visibility(true)
	Order227_Init()
	ConscriptProgression_AudioInit()
	
end

-------------------------------------------------------------------------
-- MISSION START 
-------------------------------------------------------------------------

function Mission_MissionStart()

	if Event_IsAnyRunning() == false then
		
		-- delay first objective
		Rule_AddOneShot(Mission_DelayObjTitle, 2)
		
		-- hints about merging into damaged squads and reinforcing from halftracks and HQs
		Lublin_UpdateHintGroups()
		BeginnerHint_AddOpportunity(sg_mergehints, HINT_MERGE, true, nil, nil, nil, GD_EASY)
		BeginnerHint_AddOpportunity(sg_reinforcehints, HINT_REINFORCE, true, nil, nil, nil, GD_EASY)
		Rule_AddInterval(Lublin_UpdateHintGroups, 30)
		
		Rule_RemoveMe()
	end
end


function Lublin_UpdateHintGroups()

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


function Mission_DelayObjTitle()

	Objective_Start(OBJ_Capture)
	
end

------------------- OBJECTIVE 1: Capture the market square, then capture two territories around the castle ----------------
function Initialize_Objective1()

	OBJ_Capture = {
		
		SetupUI = function() 
			-- Use for creating any hint points or UI Elements
			-- eg: Objective_AddUIElements()
			ping_southWest = Objective_AddUIElements(OBJ_Capture, eg_strat_southWest, true, 11045329, true, 2.8, nil, HPAT_Objective) -- LOCDB [11045329] 'Capture'
		end,
		
		OnStart = function()
			Game_Letterbox(false, 1)
			g_territoriesCaptured = 0
			Rule_AddDelayedInterval(Obj1_IsComplete_part1, 3, 1)
			Rule_AddInterval(Loss_NoHQ, 3)
			EGroup_DestroyAllEntities(eg_introBlockers)
			Modifier_Remove(modID_sniper1Camo)
			
			t_baseHarass = {mkr_baseHarass1, mkr_baseHarass2, mkr_baseHarass3, mkr_baseHarass4}
			g_HQWarningTimer = 60
			
			--- Stuka loiter near castle. This is to dissuade the player from attacking the castle before the ISU-152s arrive.
			Player_SetAbilityAvailability(player2, ABILITY.GERMAN.STUKA_CLOSE_AIR_SUPPORT, ITEM_UNLOCKED)
			Modify_AbilityMunitionsCost(player2, ABILITY.GERMAN.STUKA_CLOSE_AIR_SUPPORT, 0)
			Rule_AddDelayedInterval(Obj1_AirplaneCallout, 120, 5)
			
			--- Achievements
			--- Capture the market square without losing any troops
			Rule_AddInterval(Achievement_ZeroRiskMarket, 1)
			
			-- Counter player artillery/mortars
			-- Send enemies to attack player mortars, howitzers, and SU-76
			sg_e_counterArty = SGroup_CreateIfNotFound("sg_e_counterArty")
			g_counterArtyInterval = t_difficulty.counterArty_interval
			g_counterArtyCount = 0
			g_counterArtySuccessCount = 0
			Rule_AddDelayedInterval(_counterPlayerArtilllery, 60, g_counterArtyInterval)
			
			--- Set demo charges on player's HQ
			--- German Pioneers attempt to demolish the player's HQ
			if not g_easyDiff then
				Modify_ReceivedDamage(eg_p_hq, 1.1)
				Rule_AddDelayedInterval(Lublin_DemolitionPioneers, 120, t_difficulty.demoPioneers_interval)
				Rule_AddDelayedInterval(_demoPioneers_comment1, 130, 5)
			end
			
		end,
		
		OnComplete = function()
			-- Calls from OBJ_Capture(OBJ_Objective1)
			-- Fires off before Intel_Complete (unless Intel_Complete is nil)
			Obj1_removeHospitalHints()
			
			sg_152 = SGroup_CreateIfNotFound("sg_152")
			World_IncreaseInteractionStage()
			Game_Letterbox(true, 1)
			Player_GetAll(player1)
			SGroup_SetInvulnerable(sg_allsquads, true)
			EGroup_SetInvulnerable(eg_allentities, true)
			
			Rule_RemoveIfExist(Obj1_baseHarass)
			Rule_RemoveIfExist(Obj1_AirplaneLoiter)
			Rule_RemoveIfExist(Obj1_AirplaneCallout)
			Rule_RemoveIfExist(Lublin_DemolitionPioneers)
			HintPoint_Remove(hint_airplaneLoiter)
			Rule_AddOneShot(Obj2_cutToCastle, 5)
			Rule_AddOneShot(_fadeOutFor152, 3.5)
		end,
		
		OnFail = function()
			-- Calls from Objective_Fail(OBJ_Objective1)
			-- Fires off before Intel_Fail (unless Intel_Fail is nil)			
		end,
		
		IsComplete = function()
			return false
		end,
		
		Intel_Start = EVENTS.CaptureTerritories,				-- Event will play when obj starts but before any UI appears
		Intel_Complete = nil,			-- Event will play when obj completes but before UI is cleared
		Intel_Fail = nil,				-- Event will play when obj fails but before UI is cleared
		Title = 11045345, -- LOCDB [11045345] 'Capture the Lublin market square'
		Description = 11045345,			-- Objective Description
		TitleEnd = 11043164,
		TitleFail = nil,			
		Type = OT_Primary,				
	}
	Objective_Register(OBJ_Capture)

end

-- Objective completes if two marked territories are captured
-- No fail condition other than annihilation via base attackers

function Obj1_IsComplete_part1()

	if EGroup_IsCapturedByPlayer(eg_strat_southWest, player1, ALL) and not g_ping_southWest then
		g_ping_southWest = true
		Objective_RemoveUIElements(OBJ_Capture, ping_southWest)
		Objective_UpdateText(OBJ_Capture, 11045346) -- LOCDB [11045346] 'Capture two of three marked territories'
		Objective_SetCounter(OBJ_Capture, 0, 2)
		Obj1_PopCapIncrease()
		Obj1_removeHarassMarker(mkr_baseHarass1)
		Obj1_SpawnRetreatPoint(eg_hospital_southwest)
		hint_hospSW = HintPoint_Add(eg_hospital_southwest, true, 11037022, 3.5)
		Rule_AddOneShot(Obj1_removeHospitalHintSW, 60)
		Rule_RemoveMe()
		Rule_AddInterval(Obj1_IsComplete_part2, 1)
		Lublin_RevealStrats()
		ping_northWest = Objective_AddUIElements(OBJ_Capture, Util_GetPosition(eg_strat_northWest), true, 11045329, true, 3.8, nil, HPAT_Objective)
		ping_northEast = Objective_AddUIElements(OBJ_Capture, Util_GetPosition(eg_strat_northEast), true, 11045329, true, 3.8, nil, HPAT_Objective)
		ping_southEast = Objective_AddUIElements(OBJ_Capture, Util_GetPosition(eg_strat_southEast), true, 11045329, true, 3.8, nil, HPAT_Objective)
		World_IncreaseInteractionStage()
		EGroup_EnableMinimapIndicator(eg_mm_unlock1, true)
		Player_SetAbilityAvailability(player2, ABILITY.GERMAN.GRENADIER_PANZERFAUST, ITEM_UNLOCKED)
		Sound_StopMusic(CAMPAIGN_MUSIC_FADEOUT,0)
		Rule_AddOneShot(Music_StartSecondTrack, 5)
		--- Barrage Event ---
		--- A big German barrage hits a strategic points as the player approaches
		Rule_AddDelayedInterval(Lublin_BarrageEvent, 3, 10)
		
		--- CHECKPOINT AUTOSAVE THING #1 ---
		Util_Autosave(11049974, 7) -- LOCDB [11049974] 'Mission 10 - Autosave 1'
		
		--- Enemy Spawning ---
		--- Spawn enemies as the player moves around the map
		Rule_AddInterval(Lublin_SpawnSouth, 1)
		Rule_AddInterval(Lublin_SpawnEast, 1)
		Rule_AddInterval(Lublin_SpawnNorthwest, 1)
		Rule_AddInterval(Lublin_SpawnNorth, 1)
		Rule_AddInterval(Lublin_SpawnNortheast, 1)
		Rule_AddInterval(Lublin_SpawnSoutheast, 1)		
		Rule_AddInterval(Lublin_SpawnGateDefense, 1)

		--- Start bonus objective: intercept German reinforcements
		--- This only triggers if the player explores the southern part of the map
		Rule_AddDelayedInterval(Obj4_delayStartObjective, 150, 1)		
		
	end
end

function Obj1_IsComplete_part2()
	if g_territoriesCaptured == 2 then
		Rule_AddInterval(Obj1_delayedComplete, 1)
		Obj1_PopCapIncrease(150)
		Objective_SetCounter(OBJ_Capture, g_territoriesCaptured, 2)
		Rule_RemoveMe()
	elseif EGroup_IsCapturedByPlayer(eg_strat_northWest, player1, ALL) and not g_ping_northWest then
		g_ping_northWest = true
		g_territoriesCaptured = g_territoriesCaptured + 1
		Objective_RemoveUIElements(OBJ_Capture, ping_northWest)
		Objective_SetCounter(OBJ_Capture, g_territoriesCaptured, 2)
		Obj1_PopCapIncrease()
		Obj1_removeHarassMarker(mkr_baseHarass2)
		Obj1_SpawnRetreatPoint(eg_hospital_northwest)
		hint_hospNW = HintPoint_Add(eg_hospital_northwest, true, 11037022, 3.5)
		Rule_AddOneShot(Obj1_removeHospitalHintNW, 20)
		
	elseif EGroup_IsCapturedByPlayer(eg_strat_northEast, player1, ALL) and not g_ping_northEast then
		g_ping_northEast = true
		Objective_RemoveUIElements(OBJ_Capture, ping_northEast)
		g_territoriesCaptured = g_territoriesCaptured + 1
		Objective_SetCounter(OBJ_Capture, g_territoriesCaptured, 2)
		Obj1_PopCapIncrease()
		Obj1_removeHarassMarker(mkr_baseHarass3)
		Obj1_SpawnRetreatPoint(eg_hospital_northeast)
		hint_hospNE = HintPoint_Add(eg_hospital_northeast, true, 11037022, 3.5)
		Rule_AddOneShot(Obj1_removeHospitalHintNE, 20)
	elseif EGroup_IsCapturedByPlayer(eg_strat_southEast, player1, ALL) and not g_ping_southEast then
		g_ping_southEast = true
		Objective_RemoveUIElements(OBJ_Capture, ping_southEast)
		g_territoriesCaptured = g_territoriesCaptured + 1
		Objective_SetCounter(OBJ_Capture, g_territoriesCaptured, 2)
		Obj1_PopCapIncrease()
		Obj1_removeHarassMarker(mkr_baseHarass4)
		Obj1_SpawnRetreatPoint(eg_hospital_southeast)
		hint_hospSE = HintPoint_Add(eg_hospital_southeast, true, 11037022, 3.5)
		Rule_AddOneShot(Obj1_removeHospitalHintSE, 20)
	end
end

function Obj1_delayedComplete()
	local player1Squads = Player_GetSquads(player1)
	if (Event_IsAnyRunning() == false) and (SGroup_IsUnderAttack(player1Squads, ANY, 5) == false) then
		Objective_Complete(OBJ_Capture)
		Rule_RemoveMe()
	elseif (SGroup_IsUnderAttack(player1Squads, ANY, 5) and g_objTextUpdated == nil) then
		g_objTextUpdated = true
		Objective_UpdateText(OBJ_Capture, 11048798, 11048798)
		Objective_StopCounter(OBJ_Capture)
	end
end

function Music_StartSecondTrack()
	Sound_PlayMusic("streamed/music/missions/m10/m10_cue_mid_post_market", 4, 0) 
end

function Obj1_startSitrep()
	local _player1Squads = Player_GetSquads(player1)
	if not SGroup_IsUnderAttack(_player1Squads, ANY, 10) then
		Util_PlayMovie("m10_sitrep", 1, 1)
		Rule_RemoveMe()
	end
end

function Obj1_removeHarassMarker(marker)
	for i = 1, #t_baseHarass do 
		if t_baseHarass[i] == marker then
			table.remove(t_baseHarass, i)
		end
	end
end

function Obj1_SpawnRetreatPoint(point)
	eg_p_retreatPoints = EGroup_CreateIfNotFound("eg_p_retreatPoints")
	Util_CreateEntities(player1, eg_p_retreatPoints, BP_GetEntityBlueprint("sp_retreat_point"), Util_GetPosition(point), 1)
	if Rule_Exists(Order227_Update) and SGroup_Exists("sg_227_commissar") then
		local spawnpos = Util_GetOffsetPosition(point, OFFSET_BACK, 5)
		-- spawn commissars at HQs
		Util_CreateSquads(player227, sg_227_commissar, BP_GetSquadBlueprint("commissar_227"), spawnpos)
		if scartype(g_227_spawnPositions) == ST_TABLE then
			table.insert(g_227_spawnPositions, spawnpos)
		end
		SGroup_EnableUIDecorator(sg_227_commissar, false)
	end
end
	

function Obj1_PopCapIncrease(num)
	if num then 
		Player_SetPopCapOverride(player1, num)
	else
		Player_SetPopCapOverride(player1, Player_GetMaxPopulation(player1, CT_Personnel) + 15)
		eventCue_popCapIncrease = UI_CreateEventCue("Icons_events_event_cue_upgrade", "", 11045310, 11045310, 30, true) -- LOCDB [11045310] 'Population Cap Increased'
		if not Rule_Exists(_flashEventCue) then
			Rule_AddOneShot(_flashEventCue, 1)
		end
		if not Rule_Exists(_stopFlashingEventCue) then
			Rule_AddOneShot(_stopFlashingEventCue, 10)
		end
	end
end

---
function _flashEventCue() flashID_popCap = UI_FlashEventCue(eventCue_popCapIncrease, true) end
function _stopFlashingEventCue() UI_StopFlashing(flashID_popCap) end
--

function Obj1_AirplaneLoiter()
	Cmd_Ability(player2, ABILITY.GERMAN.STUKA_CLOSE_AIR_SUPPORT, Marker_GetPosition(mkr_airplaneLoiter), nil, true)
end

function Obj1_AirplaneCallout()
	if Player_CanSeePosition(player1, Marker_GetPosition(mkr_airplaneLoiter)) and Misc_IsPosOnScreen(Marker_GetPosition(mkr_airplaneLoiter), 1) then
		Util_StartIntel(EVENTS.StukaWarning)
		Cmd_Ability(player2, ABILITY.GERMAN.STUKA_CLOSE_AIR_SUPPORT, Marker_GetPosition(mkr_airplaneLoiter), nil, true)
		Rule_AddInterval(Obj1_AirplaneLoiter, 60)
		hint_airplaneLoiter = HintPoint_Add(mkr_airplaneLoiter, true, 11045347, 0, HPAT_Hint, "Icons_commander_cmdr_german_stuka_close_air_support") -- LOCDB [11045347] 'German bombers are covering this area'
		Rule_RemoveMe()
	end
end

-- Remove hospital hints
function Obj1_removeHospitalHintSW()
	HintPoint_Remove(hint_hospSW)
	hint_hospSW2 = HintPoint_Add(eg_hospital_southwest, true, 11049013, 3.5, nil, "Icons_commands_icon_command_retreat")
end

function Obj1_removeHospitalHintNW()
	HintPoint_Remove(hint_hospNW)
	hint_hospNW2 = HintPoint_Add(eg_hospital_northwest, true, 11049013, 3.5, nil, "Icons_commands_icon_command_retreat")
end

function Obj1_removeHospitalHintSE()
	HintPoint_Remove(hint_hospSE)
	hint_hospSE2 = HintPoint_Add(eg_hospital_southeast, true, 11049013, 3.5, nil, "Icons_commands_icon_command_retreat")
end

function Obj1_removeHospitalHintNE()
	HintPoint_Remove(hint_hospNE)
	hint_hospNE2 = HintPoint_Add(eg_hospital_northeast, true, 11049013, 3.5, nil, "Icons_commands_icon_command_retreat")
end

function Obj1_removeHospitalHints()
	HintPoint_Remove(hint_hospSW2)
	HintPoint_Remove(hint_hospNW2)
	HintPoint_Remove(hint_hospSE2)
	HintPoint_Remove(hint_hospNE2)
end

---- SPEECH EVENTS ----

function Speech_ElefantSpotted()
	if not SGroup_IsEmpty(g_enc_southEast[5].sgroup) then
		local squad = SGroup_GetRandomSpawnedSquad(g_enc_southEast[5].sgroup)
		if Squad_IsAttacking(squad, 5) then
			EventCue_Create(CUE.ATTACKED, 11007744, 11007744, g_enc_southEast[5].sgroup)
			FOW_RevealSGroup(g_enc_southEast[5].sgroup, 15)
			Util_StartIntel(EVENTS.ElefantWarning)
			Rule_RemoveMe()
			Rule_AddInterval(Lublin_RepairElefant, 1)
		end
	end
end

function Speech_TanksSpotted()
	if not Event_IsAnyRunning() then
		Util_StartIntel(EVENTS.TanksSpotted)
		Rule_RemoveMe()
	end
end

function Speech_FlaksSpotted()
	if not Event_IsAnyRunning() then
		Util_StartIntel(EVENTS.FlaksSpotted)
		Rule_RemoveMe()
	end
end

function Speech_PanzerwerfersSpotted()
	if not Event_IsAnyRunning() then
		Util_StartIntel(EVENTS.PanzerwerfersSpotted)
		Rule_RemoveMe()
	end
end

------------------- OBJECTIVE 2: Use ISU-152s to breach the castle wall ----------------
function Initialize_Objective2()

	OBJ_Breach = {
		
		SetupUI = function() 
			-- Use for creating any hint points or UI Elements
			-- eg: Objective_AddUIElements()
			ping_wall = Objective_AddUIElements(OBJ_Breach, mkr_castleGate, true, 11045348, true) -- LOCDB [11045348] 'Target castle gate with ISU-152s'
			hint_fire1 = HintPoint_Add(mkr_firingPosition1, true, 11045349, nil, HPAT_Movement, "Icons_portraits_vehicle_soviet_isu_152_s_portrait") -- LOCDB [11045349] 'Bring an ISU-152 to either position'
			hint_fire2 = HintPoint_Add(mkr_firingPosition2, true, 11045349, nil, HPAT_Movement, "Icons_portraits_vehicle_soviet_isu_152_s_portrait") -- LOCDB [11045349] 'Bring an ISU-152 to either position'
			blip_fire1 = UI_CreateMinimapBlip(mkr_firingPosition1, -1, BT_General)
			blip_fire2 = UI_CreateMinimapBlip(mkr_firingPosition2, -1, BT_General)
			Rule_AddDelayedInterval(Obj2_check152Location, 5, 1)
		end,
		
		OnStart = function()
			Sound_PlayMusic("streamed/music/missions/m10/m10_cue_destroy_castle_gate", 4, 4) 
			Rule_AddDelayedInterval(Obj2_IsComplete, 22, 2)
			g_wallHealth = math.floor((EGroup_GetAvgHealth(eg_castleWall) * 100))
			EGroup_SetInvulnerable(eg_castleWall, 0.01)
			modID_gate = Modify_ReceivedDamage(eg_castleWall, 0.3334)
			EGroup_SetSelectable(eg_castleWall, true)
			EGroup_SetPlayerOwner(eg_castleWall, player2)
			
			--Attackers
			g_counterattack2Count = 1
			g_counterattackTarget = Obj2_GetTarget()
			g_armorTable = {SBP.GERMAN.OSTWIND_SQUAD, SBP.GERMAN.PANZER_IV_SQUAD, SBP.GERMAN.STUG_III_SQUAD}
			
			Player_AddResource(player2, RT_Munition, 300)
			Player_CompleteUpgrade(player1, BP_GetUpgradeBlueprint("demolitions_disable"))
			Cmd_Ability(player2, ABILITY.GERMAN.STUKA_BOMBING_STRIKE, Marker_GetPosition(mkr_artyOnWall), nil, true)

		end,
		
		OnComplete = function()
			-- Calls from Objective_Complete(OBJ_Objective1)
			-- Fires off before Intel_Complete (unless Intel_Complete is nil)			
			Mission_MissionComplete()

		end,
		
		OnFail = function()
			-- Calls from Objective_Fail(OBJ_Objective1)
			-- Fires off before Intel_Fail (unless Intel_Fail is nil)
			Game_EndSP(false)
		end,
		
		IsComplete = function()
			return false
		end,
		
		Intel_Start = EVENTS.AssaultTheCastle,				-- Event will play when obj starts but before any UI appears
		Intel_Complete = EVENTS.CastleTaken,			-- Event will play when obj completes but before UI is cleared
		Intel_Fail = EVENTS.ISUdestroyed2,				-- Event will play when obj fails but before UI is cleared
		Title = 11045350,	-- LOCDB [11045350] 'Breach the castle gate with ISU-152s'
		Description = 11045350,			-- Objective Description
		TitleEnd = 11045351, -- LOCDB [11045351] 'Castle gate breached'
		TitleFail = 11045352, -- LOCDB [11045352] 'ISU-152s destroyed'
		Type = OT_Primary,				-- Objective Type (OT_Primary, OT_Secondary)
	}
	
	Objective_Register(OBJ_Breach)
end

function Obj2_cutToCastle()
	Sound_SetMusicCombatValue(2, 20)
	Util_StartNIS(NIS03, nil, nil, nil, Obj2_EndLetterbox)
	Rule_AddOneShot(Obj2_cutTo152s, 14)

	sg_p_moveFor152Arrival = SGroup_CreateIfNotFound("sg_p_moveFor152Arrival")
	eg_p_moveFor152Arrival = EGroup_CreateIfNotFound("eg_p_moveFor152Arrival")
	Player_GetAllSquadsNearMarker(player1, sg_p_moveFor152Arrival, mkr_isu_rect)
	Player_GetAllEntitiesNearMarker(player1, eg_p_moveFor152Arrival, mkr_isu_rect)
	if not SGroup_IsEmpty(sg_p_moveFor152Arrival) then
		local f = function(gid, idx, sid)
			Squad_WarpToPos(sid, Util_GetRandomPosition(mkr_playerStart))
		end
		SGroup_ForEach(sg_p_moveFor152Arrival, f)
	end
	if not EGroup_IsEmpty(eg_p_moveFor152Arrival) then
		EGroup_DeSpawn(eg_p_moveFor152Arrival)
	end
	if not EGroup_IsEmpty(eg_barrier1) then
		EGroup_DeSpawn(eg_barrier1)
	end
end


function Obj2_cutTo152s()
	Modify_AbilityRechargeTime(player1, ABILITY.SOVIET.ISU_152_PIERCING_SHOT_ABILITY, 0.666)
	Modify_AbilityMaxCastRange(player1, ABILITY.SOVIET.ISU_152_PIERCING_SHOT_ABILITY, 0.8)
	Util_CreateSquads(player1, sg_152, SBP.SOVIET.ISU_152, mkr_ISU1, Marker_GetPosition(mkr_ISU1_dest))
	Util_CreateSquads(player1, sg_152, SBP.SOVIET.ISU_152, mkr_ISU2, Marker_GetPosition(mkr_ISU2_dest))
	Objective_Start(OBJ_Protect, false)
	Rule_AddInterval(Obj2_checkIsuUnderAttack, 5)
	Sound_StopMusic(CAMPAIGN_MUSIC_FADEOUT,0)
	-- Castle Gate modifiers
	Modify_Armor(eg_castleWall, 3)
	
end

_fadeOutFor152 = function ()
	Game_FadeToBlack(FADE_OUT, 1.5)
end

_fadeInOn152 = function ()
	Game_FadeToBlack(FADE_IN, 1.5)
end

function Obj2_checkIsuUnderAttack()
	if SGroup_IsEmpty(sg_152) then
		Rule_RemoveMe()
	else
		if SGroup_IsUnderAttack(sg_152, ANY, 5) and not g_protectObjectiveFlashing then
			flashID_protectObj = UI_FlashObjectiveIcon(OBJ_Protect.ID, true)
			g_protectObjectiveFlashing = true
		elseif g_protectObjectiveFlashing and not SGroup_IsUnderAttack(sg_152, ANY, 5) then
			g_protectObjectiveFlashing = false
			UI_StopFlashing(flashID_protectObj)
		end
	end
end
		

-- Objective completes when the castle gate is destroyed.
-- Objective is failed if both ISUs are destroyed.
function Obj2_IsComplete()
	g_wallHealth = math.floor((EGroup_GetAvgHealth(eg_castleWall) * 100))
	Obj_ShowProgress(11045353, (g_wallHealth/100)) -- LOCDB [11045353] 'Lublin Castle Gate'
	Objective_SetCounter(OBJ_Protect, SGroup_Count(sg_152), 2)
	
	if EGroup_GetAvgHealth(eg_castleWall) <= 0.05 then
		Achievement_GateCrusher()
		Game_FadeToBlack(FADE_OUT, 1.5)
		Game_SetMode(UI_Cinematic)
		
		Obj_HideProgress()
		Rule_RemoveMe()
		
		Rule_AddOneShot(outro_completeObjective, 1.6)
		Rule_AddOneShot(outro_destroyGateObjects, 2)
		Rule_AddOneShot(outro_destroyGate, 2.5)
		Rule_AddOneShot(outro_retreatEnemies, 4)
		
	elseif SGroup_Count(sg_152) == 1 and not g_oneISUdestroyed then
		g_oneISUdestroyed = true
		Util_StartIntel(EVENTS.ISUdestroyed1)
	elseif SGroup_IsEmpty(sg_152) then
		Objective_Fail(OBJ_Breach)
		Obj_HideProgress()
		Rule_RemoveMe()
	end
end

outro_completeObjective = function()
	if scartype(g_enc_castlePrisoners.sgroup) == ST_SGROUP then
		SGroup_Kill(g_enc_castlePrisoners.sgroup)
	end
	
	EGroup_DestroyAllEntities(eg_gate_moveBlock)
	local gatePos = EGroup_GetPosition(eg_castleWall)
	gatePos.x = gatePos.x + 1.75
	eg_gateDest = EGroup_CreateIfNotFound("eg_gateDest")
	Util_CreateEntities(player2, eg_gateDest, BP_GetEntityBlueprint("beams_m_02"), gatePos, 1)
	Util_CreateEntities(player2, eg_gateDest, BP_GetEntityBlueprint("old_world_low_horizontal_fence_01"), gatePos, 1)
	gatePos.y = gatePos.y + 1.5
	Util_CreateEntities(player2, eg_gateDest, BP_GetEntityBlueprint("beams_m_01"), gatePos, 1)
	gatePos.y = gatePos.y + 1.5
	Util_CreateEntities(player2, eg_gateDest, BP_GetEntityBlueprint("beams_m_02"), gatePos, 1)
	EGroup_ReSpawn(eg_outroCorpses)
	Objective_Complete(OBJ_Breach, false)
end

outro_destroyGateObjects = function()
	EGroup_Kill(eg_gateDest)
end

outro_destroyGate = function()
	Sound_Play3D("campaign\\m10_castle_door_break", EGroup_GetSpawnedEntityAt(eg_castleWall, 1))
	EGroup_Kill(eg_castleWall)
end

outro_retreatEnemies = function()
	if not SGroup_IsEmpty(g_enc_castleInterior.sgroup) then
		Cmd_Retreat(g_enc_castleInterior.sgroup, mkr_retreat_castleInterior, nil, nil, true, nil, true)
		Sound_PlayOnSquad("campaign\m10_russians_freed_cheer", g_enc_castleInterior.sgroup)
	end
	if not SGroup_IsEmpty(sg_counterAttackers) then
		Cmd_Retreat(sg_counterAttackers, mkr_engineer_spawn, nil, nil, true, nil, true)
	end
	if not SGroup_IsEmpty(g_enc_gateDefense.sgroup) then
		Cmd_Retreat(g_enc_gateDefense.sgroup, mkr_engineer_spawn, nil, nil, true, nil, true)
	end
end

function Obj2_WaveManager()
	if SGroup_Count(sg_counterAttackers) < t_difficulty.maxConcurrentAttackers then
		ThreatArrow_CreateGroup(sg_counterAttackers)
		g_counterattackTarget = Obj2_GetTarget()
		if(g_counterattack2Count == 1) then
			g_counterattack2Count = g_counterattack2Count + 1
			Obj2_SpawnInfantry(1)
			Obj2_SpawnArmor(1)
		elseif(g_counterattack2Count == 2 and SGroup_Count(sg_counterAttackers) < 5) then
			g_counterattack2Count = 3
			Obj2_SpawnInfantry(2)
			Obj2_SpawnArmor(2)
			Modifier_Remove(modID_gate)
			modID_gate = Modify_ReceivedDamage(eg_castleWall, 0.6666)
		elseif(g_counterattack2Count == 3 and SGroup_Count(sg_counterAttackers) < 7) then
			g_counterattack2Count = 4
			Obj2_SpawnInfantry(3)
			Obj2_SpawnArmor(3)
			Modifier_Remove(modID_gate)
		elseif(g_counterattack2Count == 4 and SGroup_Count(sg_counterAttackers) < 9) then
			g_counterattack2Count = 5
			Obj2_SpawnInfantry(4)
			Obj2_SpawnArmor(4)
		elseif(g_counterattack2Count == 5 and SGroup_Count(sg_counterAttackers) < 7) then
			g_counterattack2Count = 6
			Obj2_SpawnInfantry(4)
			Obj2_SpawnArmor(4)
		elseif (g_counterattack2Count >= 6 and SGroup_IsEmpty(sg_counterAttackers)) then
			Rule_RemoveMe()
		end
		ThreatArrow_CreateGroup(sg_counterAttackers)
	end
end

function Obj2_GetTarget()
	if not SGroup_IsEmpty(sg_152) then
		return SGroup_GetRandomSpawnedSquad(sg_152)
	else
		return mkr_defend_wall
	end
end

function Obj2_EndLetterbox()
	if EGroup_CountDeSpawned(eg_p_moveFor152Arrival) > 0 then
		EGroup_ReSpawn(eg_p_moveFor152Arrival)
	end
	SGroup_SetInvulnerable(sg_allsquads, false)
	EGroup_SetInvulnerable(eg_allentities, false)
	FOW_UnRevealAll()
	FOW_RevealMarker(mkr_castle, -1)
	FOW_RevealMarker(mkr_castle_center, -1)
	
	if Rule_Exists(Obj2_cutTo152s) then
		Rule_Remove(Obj2_cutTo152s)
		Obj2_cutTo152s()
	end
	Objective_Start(OBJ_Breach)
	Util_ReinforceEvent(sg_152)
end

_endLetterbox_delayed = function ()
	Game_Letterbox(false, 1)
end

-- Start enemy attacker spawns for final objective
function Obj2_check152Location()
	if Prox_AreSquadMembersNearMarker(sg_152, mkr_defend_wall, ANY, 50) or (EGroup_GetAvgHealth(eg_castleWall) < 0.95) then
		Objective_UpdateText(OBJ_Breach, 11045350)
		-- Modify 152 weapon penetration 
		Modify_WeaponPenetration(sg_152, "hardpoint_01", 2.75)
		HintPoint_Remove(hint_fire1)
		UI_DeleteMinimapBlip(blip_fire1)
		HintPoint_Remove(hint_fire2)
		UI_DeleteMinimapBlip(blip_fire2)
		if SGroup_CountSpawned(sg_152) >= 1 then
			ping_isu1 = Objective_AddUIElements(OBJ_Breach, SGroup_GetSpawnedSquadAt(sg_152, 1), false, 11045348, true, 1.5) -- LOCDB [11045348] 'Target castle gate with ISU-152s'
		end
		if SGroup_CountSpawned(sg_152) == 2 then
			ping_isu2 = Objective_AddUIElements(OBJ_Breach, SGroup_GetSpawnedSquadAt(sg_152, 2), true, 11045348, true, 1.5) -- LOCDB [11045348] 'Target castle gate with ISU-152s'
		end
		if g_easyDiff then
			Rule_AddDelayedInterval(Obj2_WaveManager, 60, 3) -- More time to prepare on Easy
		else
			Rule_AddDelayedInterval(Obj2_WaveManager, 5, 3)
		end
		Rule_AddInterval(Obj2_RemoveGateHint, 1)
		
		g_castleBurnIndex  = 1
		Rule_AddInterval(Obj2_burnCastleEntity, 5)
		
		-- Hide secondary objective if it is not complete
		if Objective_IsStarted(OBJ_Intercept) and not Objective_IsComplete(OBJ_Intercept) then
			if ping_bonus ~= nil then
				Objective_RemoveUIElements(OBJ_Intercept, ping_bonus)
			end
			if hint_reinforcements ~= nil then
				Objective_RemoveUIElements(OBJ_Intercept, hint_reinforcements)
			end
			Objective_Show(OBJ_Intercept, false)
			Rule_RemoveIfExist(Obj4_IsComplete)
			Rule_RemoveIfExist(Obj4_spawnToCastleSquads)
		end
		
		Rule_RemoveIfExist(Lublin_BarrageEvent)
		
		Rule_RemoveMe()
	end
end

function Obj2_RemoveGateHint()
	if EGroup_GetAvgHealth(eg_castleWall) < 0.95 then
		Objective_RemoveUIElements(OBJ_Breach, ping_wall)
		Objective_RemoveUIElements(OBJ_Breach, ping_isu1)
		Objective_RemoveUIElements(OBJ_Breach, ping_isu2)
		Rule_RemoveMe()
	end
end


function Obj2_burnCastleEntity()
	local castleHealth = EGroup_GetAvgHealth(eg_castleWall)
	if castleHealth < 0.6 and g_castleBurnIndex == 1 then
		if EGroup_Count(eg_castle_frontLeft) > 0 then
			Entity_SetInvulnerableMinCap(EGroup_GetRandomSpawnedEntity(eg_castle_frontLeft), 0, 0)
			Entity_SetOnFire(EGroup_GetRandomSpawnedEntity(eg_castle_frontLeft))
			Entity_SetInvulnerableMinCap(EGroup_GetRandomSpawnedEntity(eg_castle_frontLeft), 0.75, 0)
		end
		g_castleBurnIndex  = 2
	elseif castleHealth  < 0.4 and g_castleBurnIndex == 2 then
		if EGroup_Count(eg_castle_frontRight) > 0 then
			Entity_SetInvulnerableMinCap(EGroup_GetRandomSpawnedEntity(eg_castle_frontRight), 0, 0)
			Entity_SetOnFire(EGroup_GetRandomSpawnedEntity(eg_castle_frontRight))
			Entity_SetInvulnerableMinCap(EGroup_GetRandomSpawnedEntity(eg_castle_frontRight), 0.75, 0)
		end
		g_castleBurnIndex  = 3
	elseif castleHealth  < 0.1 and g_castleBurnIndex == 3 then
		if EGroup_Count(eg_castle_sideRight) > 0 then
			Entity_SetInvulnerableMinCap(EGroup_GetRandomSpawnedEntity(eg_castle_sideRight), 0, 0)
			Entity_SetOnFire(EGroup_GetRandomSpawnedEntity(eg_castle_sideRight))
			Entity_SetInvulnerableMinCap(EGroup_GetRandomSpawnedEntity(eg_castle_sideRight), 0.75, 0)
		end
		g_castleBurnIndex  = 4
	elseif castleHealth  < 0.01 and g_castleBurnIndex == 4 then
		if EGroup_Count(eg_castle_chapel) > 0 then
			Entity_SetInvulnerableMinCap(EGroup_GetRandomSpawnedEntity(eg_castle_chapel), 0, 0)
			Entity_SetOnFire(EGroup_GetRandomSpawnedEntity(eg_castle_chapel))
			Entity_SetInvulnerableMinCap(EGroup_GetRandomSpawnedEntity(eg_castle_chapel), 0.75, 0)
		end
		if EGroup_Count(eg_castle_sideLeft) > 0 then
			local f = function (gid, idx, entity)
				Entity_SetInvulnerableMinCap(entity, 0, 0)
				Entity_SetOnFire(entity)
				Entity_SetInvulnerableMinCap(entity, 0.75, 0)
			end
			EGroup_ForEach(eg_castle_sideLeft, f)
		end
		Rule_RemoveMe()
	end
end

--- ENEMY SPAWNING ---
--- For final objective at castle gate ---

function Obj2_SpawnInfantry(num)
	local sbp1 = g_infantryTable[1]
	local sbp2 = g_infantryTable[2]
	t_counterAttack_infSpawnMarkers = Marker_GetTable("mkr_counterAttack_s_%d")
	if num == 2 then
		sbp1 = g_infantryTable[2]
		sbp2 = g_infantryTable[1]
		t_counterAttack_infSpawnMarkers = Marker_GetTable("mkr_counterAttack_e_%d")
	elseif num == 3 then
		sbp1 = g_infantryTable[2]
		sbp2 = g_infantryTable[3]
		t_counterAttack_infSpawnMarkers = Marker_GetTable("mkr_counterAttack_ne_%d")		
	elseif num == 4 then
		sbp1 = g_infantryTable[3]
		sbp2 = g_infantryTable[2]
		t_counterAttack_infSpawnMarkers = Marker_GetTable("mkr_counterAttack_n_%d")
	end
	
	
	local encData = {
		name = "counterAttackWave_inf_" .. num,
		player = player2,
		sgroups = {sg_counterAttackers, sg_counterAttackers_inf},
		units = {
			{
				name = "counter_inf_" .. num,
				sbp = sbp1,
				spawn = counterAttack_findSpawn_infantry(),
				veterancyRank = World_GetRand(0,2),
			},
			{
				name = "counter_inf2_" .. num,
				sbp = sbp1,
				spawn = counterAttack_findSpawn_infantry(),
				veterancyRank = World_GetRand(0,2),
			},
			{
				name = "counter_inf3_" .. num,
				sbp = sbp2,
				spawn = counterAttack_findSpawn_infantry(),
				veterancyRank = World_GetRand(0,2),
			}
		},

	}
	
	if num == 2 then
		encData.units[1].upgrades = {UPG.GERMAN.GRENADIER_MG42_LMG}
	elseif num == 3 then
		encData.units[2].upgrades = {UPG.GERMAN.GRENADIER_MG42_LMG}
	elseif num >= 4 then
		encData.units[2].upgrades = {UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM}
	end
	
	if Player_GetCurrentPopulation(player1, CT_Personnel) > 50 and not g_easyDiff then
		table.insert(encData.units, encData.units[table.getn(encData.units)])
	elseif Player_GetCurrentPopulation(player1, CT_Personnel) < 25 then
		if table.getn(encData.units) > 1 then
			table.remove(encData.units)
		end
	end
	
	g_enc_counterAttack_inf[num] = Encounter:Create(encData)
	
	local goalData = {
		name = "Attack",
		target = g_counterattackTarget,
		range = 50,
		leashRange = 40,
		coordinatedSetup = false,
	}
	
	if Objective_IsStarted(OBJ_Breach) then
		goalData = {
			name = "Defend",
			target = mkr_defend_wall,
			safeMoveWeight = (World_GetRand(25,50) / 100),
			useSkirmishAI = g_useSkirmishAI,
			range = 50,
			leashRange = 40,
			tacticTargetPreference = AITacticTargetPreference_LowHealth,
			abilityControlsList = {
				{
					abilityPBG = ABILITY.GERMAN.PANZER_GRENADIER_BUNDLED_CAMPAIGN,
					maxCasters = 2,
					maxRange = 50,
					waitTimeSecs = 30,
				},
			},
			tacticControlsList = {
				{
					tacticType = TACTIC_Ability,
					priority = 100,
					retryTimeSecs = 8,
					waitTimeSecs = 15,
				},
				{
					tacticType = TACTIC_Recrew,
					priority = 50,
				},
				{
					tacticType = TACTIC_Cover,
					priority = 25,
				},
			},
			
		}
	end
	
	-- Secondary Objective result
	if not Objective_IsFailed(OBJ_Intercept) then
		goalData.tacticControlsList = g_tactics_disableAbility
	end
	
	g_enc_counterAttack_inf[num]:SetGoal(goalData)
	
end

counterAttack_findSpawn_infantry = function ()
	local t = Clone(t_counterAttack_infSpawnMarkers)
	for k,v in pairs(t) do
		if Player_CanSeePosition(player1, Marker_GetPosition(v)) then
			table.remove(t, k)
			v = nil 
		end
	end
	if #t > 0 then
		return Table_GetRandomItem(t)
	else
		return Util_FindHiddenSpawn(Marker_GetPosition(mkr_counterAttack2_far), Marker_GetPosition(mkr_counterAttack_e_1))
	end
		
end

function Obj2_SpawnArmor(num)

	t_counterAttack_armorSpawns = Marker_GetTable("mkr_counterAttack_n_%d")
	
	if num == 2 then
		t_counterAttack_armorSpawns = Marker_GetTable("mkr_counterAttack_ne_%d")
	elseif num == 3 then
		t_counterAttack_armorSpawns = Marker_GetTable("mkr_counterAttack_e_%d")		
	elseif num == 4 then
		t_counterAttack_armorSpawns = Marker_GetTable("mkr_counterAttack_s_%d")
	end
	
	local encData = {
		name = "counterAttackWave_arm_" .. num,
		player = player2,
		sgroups = {sg_counterAttackers},
		units = {
			{
				name = "counter_arm_" .. num .. "-1",
				sbp = Table_GetRandomItem(g_armorTable),
				spawn =  counterAttack_findSpawn_armor(),
				veterancyRank = World_GetRand(1,2),
			},
			{
				name = "counter_arm_" .. num .. "-2",
				sbp = Table_GetRandomItem(g_armorTable),
				spawn = counterAttack_findSpawn_armor(),
				veterancyRank = World_GetRand(1,2),
			}
		},
	}
	
	if num == 1 then
		encData.units = {
			{
				name = "counter_arm_" .. num,
				sbp = SBP.GERMAN.STUG_III_E_SQUAD,
				spawn = counterAttack_findSpawn_armor(),
			}
		}
	elseif num == 2 then
		encData.units = {
			{
				name = "counter_arm_" .. num,
				sbp = SBP.GERMAN.OSTWIND_SQUAD,
				spawn = counterAttack_findSpawn_armor(),
			},
			{
				name = "counter_arm_" .. num,
				sbp = SBP.GERMAN.SCOUTCAR_SDKFZ222,
				entityUpgrades = {UPG.GERMAN.SDKFZ_222_20MM_GUN_MP},
				spawn = counterAttack_findSpawn_armor(),
			},
		}
	end
	if Player_GetCurrentPopulation(player1, CT_Personnel) > 90 and not g_easyDiff then
		table.insert(encData.units, encData.units[table.getn(encData.units)])
	elseif Player_GetCurrentPopulation(player1, CT_Personnel) < 45 then
		if table.getn(encData.units) > 1 then
			table.remove(encData.units)
		end
	end
	
	g_enc_counterAttack_arm[num]  = Encounter:Create(encData)

	local goalData = {
		name = "Attack",
		target = g_counterattackTarget,
		safeMoveWeight = 0, 
		range = 45,
		leashRange = 35,
		coordinatedSetup = false,
		onSuccess = UpdateAttackTarget,
		tacticTargetPreference = AITacticTargetPreference_HighDamage,
	}
	
	if not Objective_IsFailed(OBJ_Intercept) then
		goalData.tacticControlsList = g_tactics_disableVehicle
	end

	g_enc_counterAttack_arm[num]:SetGoal(goalData)

end

counterAttack_findSpawn_armor = function ()
	local t = Clone(t_counterAttack_armorSpawns)
	for k,v in pairs(t) do
		if Player_CanSeePosition(player1, Marker_GetPosition(v)) then
			table.remove(t, k)
			v = nil 
		end
	end
	if #t > 0 then
		return Table_GetRandomItem(t)
	else
		return Util_FindHiddenSpawn(Marker_GetPosition(mkr_counterAttack1_far), Marker_GetPosition(mkr_counterAttack1))
	end
end	


------------------- OBJECTIVE 3: Protect ISU-152s ----------------
function Initialize_Objective3()

	OBJ_Protect = {
	
		Parent = OBJ_Breach,
		
		SetupUI = function() 
			-- Use for creating any hint points or UI Elements
			-- eg: Objective_AddUIElements()
		end,
		
		OnStart = function()
			-- Calls from Objective_Start(OBJ_Objective1)
			
			Objective_SetCounter(OBJ_Protect, 2, 2)

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
			return false
		end,
		
		Intel_Start = nil,				-- Event will play when obj starts but before any UI appears
		Intel_Complete = nil,			-- Event will play when obj completes but before UI is cleared
		Intel_Fail = nil,				-- Event will play when obj fails but before UI is cleared
		Title = 11045354,	-- LOCDB [11045354] 'Protect ISU-152s from enemy tanks'
		Description = 11045354,			-- Objective Description
		TitleEnd = nil,				-- Completed Title
		TitleFail = 11045352, -- LOCDB [11045352] 'ISU-152s destroyed'
		Type = OT_Secondary,				-- Objective Type (OT_Primary, OT_Secondary)
	}
	
	Objective_Register(OBJ_Protect)

end

------------------- BONUS OBJECTIVE: Intercept German squads approaching from the south ----------------
function Initialize_Objective4()

	OBJ_Intercept = {
		
		SetupUI = function() 
			-- Use for creating any hint points or UI Elements
			-- eg: Objective_AddUIElements()
			ping_bonus = Objective_AddUIElements(OBJ_Intercept, Marker_GetPosition(mkr_intercept), true, 11045358, true) -- LOCDB [11045358] 'Intercept squads approaching from the south'
		end,
		
		OnStart = function()
			-- Calls from Objective_Start(OBJ_Objective1)
			g_squadsReachedCastle = 0
			g_Obj4_squadLimit = 10
			g_Obj4_squadsKilled = 0
			g_toCastleSquadsSpawned = 0
			sg_toCastle = SGroup_CreateIfNotFound("sg_toCastle")
			sg_toCastle1 = SGroup_CreateIfNotFound("sg_toCastle1")
			sg_toCastle2 = SGroup_CreateIfNotFound("sg_toCastle2")
			sg_atCastle = SGroup_CreateIfNotFound("sg_atCastle")
			Objective_SetCounter(OBJ_Intercept, 0, g_Obj4_squadLimit)
			Rule_AddDelayedInterval(Obj4_IsComplete, 5, 3)
			g_toCastleConcurrentSquads = 1
			Rule_AddDelayedInterval(Obj4_spawnToCastleSquads, 60, 20)
		end,
		
		OnComplete = function()
			-- Calls from Objective_Complete(OBJ_Objective1)
			-- Fires off before Intel_Complete (unless Intel_Complete is nil)		
			Rule_RemoveIfExist(Obj4_revealToCastleSquads)
		end,
		
		OnFail = function()
			-- Calls from Objective_Fail(OBJ_Objective1)
			-- Fires off before Intel_Fail (unless Intel_Fail is nil)
			Rule_RemoveIfExist(Obj4_revealToCastleSquads)
		end,
		
		IsComplete = function()
			return false
		end,
		
		Intel_Start = EVENTS.SecondaryObj,				-- Event will play when obj starts but before any UI appears
		Intel_Complete = EVENTS.SecondaryObj_Won,			-- Event will play when obj completes but before UI is cleared
		Intel_Fail = EVENTS.SecondaryObj_Lost,				-- Event will play when obj fails but before UI is cleared
		Title = 11045355,	-- LOCDB [11045355] 'Eliminate German reinforcements'
		Description = 11045355,	-- LOCDB [11045355] 'Eliminate German reinforcements'
		TitleEnd = 11045356,	-- LOCDB [11045356] 'Reinforcements eliminated'
		TitleFail = 11045357, -- LOCDB [11045357] 'Enemy reinforcements reached the castle'
		Type = OT_Secondary,				-- Objective Type (OT_Primary, OT_Secondary)
	}
	
	Objective_Register(OBJ_Intercept)

end

function Obj4_IsComplete()
	Player_GetAllSquadsNearMarker(player2, sg_atCastle, mkr_interceptDest, 10)
	local f = function (gid, idx, sid)
		if not SGroup_ContainsSquad(sg_toCastle, Squad_GetGameID(sid)) then
			SGroup_Remove(sg_atCastle, sid)
		end
	end
	SGroup_ForEach(sg_atCastle, f)
	if not SGroup_IsEmpty(sg_atCastle) and not SGroup_IsOnScreen(player1, sg_atCastle, ANY) then
		Rule_RemoveSGroupEvent(Obj4_incKillCount, sg_atCastle)
		g_squadsReachedCastle = g_squadsReachedCastle + SGroup_Count(sg_atCastle)
		SGroup_DestroyAllSquads(sg_atCastle)
	end
	if g_squadsReachedCastle >= (2 * g_Obj4_squadLimit) then
		Rule_RemoveMe()
		Objective_Fail(OBJ_Intercept)
		Obj4_setCompleteGoal()
		if hint_reinforcements ~= nil then
			HintPoint_Remove(hint_reinforcements)
		end
		Rule_RemoveIfExist(Obj4_spawnToCastleSquads)
	elseif (g_Obj4_squadsKilled >= g_Obj4_squadLimit) then 
		Rule_RemoveMe()
		if not SGroup_IsEmpty(sg_toCastle1) then
			Rule_RemoveSGroupEvent(Obj4_incKillCount, sg_toCastle1)
		end
		if not SGroup_IsEmpty(sg_toCastle2) then
			Rule_RemoveSGroupEvent(Obj4_incKillCount, sg_toCastle2)
		end
		Objective_Complete(OBJ_Intercept)
		Obj4_setCompleteGoal()
		if hint_reinforcements ~= nil then
			HintPoint_Remove(hint_reinforcements)
		end
		Rule_RemoveIfExist(Obj4_spawnToCastleSquads)
	end
	if not g_bonusHintRemoved then
		Obj4_hintManager()
	end
end

-- Spawn enemies that move toward the castle from the bottom of the map 
-- The player should try to prevent these squads from reaching the castle		
function Obj4_spawnToCastleSquads()
	if (SGroup_Count(sg_toCastle) < g_toCastleConcurrentSquads) and (g_Obj4_squadsKilled < g_Obj4_squadLimit) then
		SGroup_Clear(sg_toCastle1)
		SGroup_Clear(sg_toCastle2)
		local squad1 = g_infantryTable[1]
		local squad2 = g_infantryTable[1]
		if g_toCastleSquadsSpawned >= 8 then
			squad1 = g_infantryTable[3]
			squad2 = g_infantryTable[3]
		elseif g_toCastleSquadsSpawned >= 6 then
			squad1 = g_infantryTable[3]
			squad2 = g_infantryTable[2]
		elseif g_toCastleSquadsSpawned >= 4 then
			squad1 = g_infantryTable[2]
			squad2 = g_infantryTable[2]
		elseif g_toCastleSquadsSpawned >= 2 then
			squad1 = g_infantryTable[2]
		end
		local spawnPos = Util_FindHiddenSpawn(Marker_GetPosition(mkr_intercept_spawn_far), Marker_GetPosition(mkr_intercept_spawn))
		Util_CreateSquads(player2, {sg_toCastle, sg_toCastle1}, squad1, spawnPos) 
		Rule_AddSGroupEvent(Obj4_incKillCount, sg_toCastle1, GE_SquadKilled)
		Util_CreateSquads(player2, {sg_toCastle, sg_toCastle2}, squad2, spawnPos)
		Rule_AddSGroupEvent(Obj4_incKillCount, sg_toCastle2, GE_SquadKilled)
		if g_toCastleSquadsSpawned >= 8 then
			Cmd_InstantUpgrade(sg_toCastle1, UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM)
		end
		g_toCastleSquadsSpawned = g_toCastleSquadsSpawned + 2
		Cmd_SquadPath(sg_toCastle1, "intercept", false, LOOP_NONE, false, 0)
		Cmd_SquadPath(sg_toCastle2, "intercept", false, LOOP_NONE, false, 0)
		Rule_RemoveIfExist(Obj4_revealToCastleSquads)
		Rule_AddDelayedInterval(Obj4_revealToCastleSquads, 1, 5)
		if hint_reinforcements ~= nil then
			Objective_RemoveUIElements(OBJ_Intercept, hint_reinforcements)
		end
		local hintSquad = SGroup_GetSpawnedSquadAt(sg_toCastle, SGroup_Count(sg_toCastle))
		hint_reinforcements = Objective_AddUIElements(OBJ_Intercept, hintSquad, true, 11045359, true) -- LOCDB [11045359] 'German Reinforcements'
		g_toCastleConcurrentSquads = g_toCastleConcurrentSquads + 0.5
	end
end

function Obj4_incKillCount(squad)
	g_Obj4_squadsKilled = g_Obj4_squadsKilled + 1
	Objective_SetCounter(OBJ_Intercept, g_Obj4_squadsKilled, g_Obj4_squadLimit)
end

function Obj4_delayStartObjective()
	local player1Squads = Player_GetSquads(player1)
	if Objective_IsComplete(OBJ_Capture) then
		Rule_RemoveMe()
	elseif Player_CanSeePosition(player1, Marker_GetPosition(mkr_intercept)) and (not Event_IsAnyRunning()) and (not SGroup_IsUnderAttack(player1Squads, ANY, 10)) then
		Objective_Start(OBJ_Intercept)
		Rule_RemoveMe()
	end
end

function Obj4_revealToCastleSquads()
	FOW_RevealSGroupOnly(sg_toCastle, 6)
end

function Obj4_hintManager()
	if Prox_ArePlayersNearMarker(player1, mkr_intercept, ANY, 10) then
		Objective_RemoveUIElements(OBJ_Intercept, ping_bonus)
		g_bonusHintRemoved = true
	end	
end

function Obj4_setCompleteGoal()
	local player1Squads = Player_GetSquads(player1)
	local goalData = {
		name = "Attack",
		target = player1Squads,
		safeMoveWeight = 0, 
		range = 20,
		coordinatedMoveRadius = 100,
	}
	if not SGroup_IsEmpty(sg_toCastle) then
		g_enc_remainder1 = Encounter:ConvertSgroup(sg_toCastle)
		g_enc_remainder1:SetGoal(goalData)
	end
	if not SGroup_IsEmpty(sg_atCastle) then
		g_enc_remainder2 = Encounter:ConvertSgroup(sg_atCastle)
		g_enc_remainder2:SetGoal(goalData)
	end
end

-----------------------------
------ ENEMY SPAWNING -------

-- Despawn some retreating squads and reinforce others
function DespawnOrReinforce(enc)
	local rand = World_GetRand(1,10)
	if rand == 10 then
		table.insert(t_encsToReinforce, enc)
		if not Rule_Exists(_delayedReinforceCommand) then
			Rule_Add(_delayedReinforceCommand)
		end
	else
		SGroup_DeSpawn(enc.sgroup)
	end
end

_delayedReinforceCommand = function()
	for k,v in pairs(t_encsToReinforce) do
		if not SGroup_IsRetreating(v.sgroup, ANY) then
			local count = math.floor(SGroup_TotalMembersCount(v.sgroup))
			Cmd_InstantReinforceUnitPos(v.sgroup, count, mkr_castle_front)
			v:RestartGoal()
			table.remove(t_encsToReinforce, k)
		end
	end
end
---

function UpdateAttackTarget(enc)
	g_counterattackTarget = Obj2_GetTarget()
	local goalData = {
		name = "Attack",
		target = g_counterattackTarget,
		useSkirmishAI = g_useSkirmishAI,
		safeMoveWeight = 0, 
		range = 20,
		coordinatedMoveRadius = 15,
		onSuccess = UpdateAttackTarget,
	}
	enc:SetGoal(goalData)
end

--- #TRAPS and AMBUSHES 1
function Lublin_SpawnSouthwest()
	g_enc_southWest = {}
	local data = {
		name = "southWest",
		player = player2,
		sgroups = {sg_e_all},
		units = {
			{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = mkr_southWest1
			},
		}
	}
	local goalData = {
		name = "Defend",
		useSkirmishAI = g_useSkirmishAI,
		target = mkr_southWest1,
		garrisonIdle = false,
		garrison = false,
		range = 30,
		leashRange = 22,
		coordinatedSetup = true,
		coordinatedSetupFacingPositions = {mkr_face_sw},
		fallbackParams = {
			retreat = true,
			markers = {mkr_castle_front},
			thresholds = {0.6},
			thresholdType = Threshold_PercentageEntitiesRemaining,
		},
		onFailure = DespawnOrReinforce,
	}
	
	for i = 1, 21 do 
		data.units[1].sbp = SBP.GERMAN.GRENADIER_SQUAD
		data.name = "southWest" .. i
		goalData.leashRange = 22
		for k,v in pairs(data.units) do
			v.spawn = Marker_FromName("mkr_southWest" .. i, "")
			if i == 2 or i == 4 or i == 9 then 
				goalData.coordinatedSetupFacingPositions = nil
				v.sbp = SBP.GERMAN.SNIPER_SQUAD
			elseif i == 3 or i == 6 then
				v.sbp = SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD
				goalData.leashRange = 18
			elseif i == 7 then
				v.sbp = SBP.GERMAN.OSTRUPPEN_SQUAD 
			elseif i == 8 then
			
			elseif i > 9 then
				v.sbp = Table_GetRandomItem({SBP.GERMAN.GRENADIER_SQUAD,SBP.GERMAN.SNIPER_SQUAD, SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD})
			end
			if v.sbp == SBP.GERMAN.GRENADIER_SQUAD then
				goalData.abilityControlsList = {
						{
							abilityPBG = ABILITY.GERMAN.GRENADIER_PANZERFAUST,
							maxCasters = 1,
							maxRange = 25,
							waitTimeSecs = 45,
						}
				}
			end
		end
		goalData.target = Marker_FromName("mkr_southWest" .. i, "")
		g_enc_southWest[i] = Encounter:Create(data)
		g_enc_southWest[i]:SetGoal(goalData)
		goalData.abilityControlsList = nil
		goalData.coordinatedSetupFacingPositions = {mkr_face_sw}
	end
	
	local data = {
		name = "strat_southWest",
		player = player2,
		sgroups = {sg_e_all},
		units = {
			{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = mkr_strat_southwest_spawn1
			},
			{
				sbp = SBP.GERMAN.PIONEER_SQUAD, 
				upgrades = {UPG.GERMAN.PIONEER_FLAMETHROWER},
				spawn = mkr_strat_southwest_spawn2
			},
			{
				sbp = SBP.GERMAN.SNIPER_SQUAD,
				spawn = mkr_strat_southwest_spawn3
			},
		}
	}
	g_enc_stratSouthwest = Encounter:Create(data)
	
	local goalData = {
		name = "Defend",
		target = mkr_strat_southwest,
		garrisonIdle = false,
		range = 30,
		leashRange = 25,
		coordinatedSetup = true,
		coordinatedSetupFacingPositions = {mkr_stratSW_face1, mkr_stratSW_face2},
		fallbackParams = {
			retreat = true,
			markers = {mkr_castle_front},
			thresholds = {0.34},
			thresholdType = Threshold_PercentageEntitiesRemaining,
		},
		onFailure = DespawnOrReinforce,
	}
	g_enc_stratSouthwest:SetGoal(goalData)
	
	sg_e_p4driveby1 = SGroup_CreateIfNotFound("sg_e_p4driveby1")
	sg_e_p4driveby2 = SGroup_CreateIfNotFound("sg_e_p4driveby2")
	
	Util_CreateSquads(player2, sg_e_p4driveby1, SBP.GERMAN.PANZER_IV_SQUAD, mkr_p4driveby1)
	Util_CreateSquads(player2, sg_e_p4driveby2, SBP.GERMAN.OSTWIND_SQUAD, mkr_p4driveby2)
	modID_sniper1Camo = Util_ApplyModifier(g_enc_southWest[4].sgroup, "camouflage_enable", -1, MUT_Enable)
	
	Rule_AddDelayedInterval(Lublin_TankResponse, 30, 1)
	
	-- Squads without AI (until they are spotted)
	sg_e_noAI = SGroup_CreateIfNotFound("sg_e_noAI")
	sg_e_noAI_single = SGroup_CreateIfNotFound("sg_e_noAI_single")
	Util_CreateSquads(player2, {sg_e_all, sg_e_noAI}, SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD, mkr_southWestPak1)
	Util_CreateSquads(player2, {sg_e_all, sg_e_noAI}, SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD, mkr_southWestPak2)
	Util_CreateSquads(player2, {sg_e_all, sg_e_noAI}, SBP.GERMAN.SNIPER_SQUAD, mkr_southWestSniper1)
	Util_CreateSquads(player2, {sg_e_all, sg_e_noAI}, SBP.GERMAN.SNIPER_SQUAD, mkr_southWestSniper2)
	Util_CreateSquads(player2, {sg_e_all, sg_e_noAI}, SBP.GERMAN.PIONEER_SQUAD, mkr_southWestSquad1, nil, 1, nil, nil, nil, UPG.GERMAN.PIONEER_FLAMETHROWER)
	Util_CreateSquads(player2, {sg_e_all, sg_e_noAI}, SBP.GERMAN.PIONEER_SQUAD, mkr_southWestSquad2, nil, 1, nil, nil, nil, UPG.GERMAN.PIONEER_FLAMETHROWER)
	Util_CreateSquads(player2, {sg_e_all, sg_e_noAI}, SBP.GERMAN.PIONEER_SQUAD, mkr_southWestSquad3, nil, 1, nil, nil, nil, UPG.GERMAN.PIONEER_FLAMETHROWER)
	Util_CreateSquads(player2, {sg_e_all, sg_e_noAI}, SBP.GERMAN.PIONEER_SQUAD, mkr_southWestSquad4, nil, 1, nil, nil, nil, UPG.GERMAN.PIONEER_FLAMETHROWER)
	
end

--- #TRAPS and AMBUSHES 2
function Lublin_SpawnWest()
		g_enc_west = {}
		local data = {
			name = "west",
			player = player2,
			sgroups = {sg_e_all},
			units = {
				{
					sbp = SBP.GERMAN.GRENADIER_SQUAD,
					spawn = mkr_west1
				},
			}
		}
		local goalData = {
			name = "Defend",
			useSkirmishAI = g_useSkirmishAI,
			target = mkr_west1,
			garrisonIdle = false,
			garrison = false,
			range = 30,
			leashRange = 22,
			coordinatedSetup = true,
			coordinatedSetupFacingPositions = {mkr_face_w1},
			fallbackParams = {
				retreat = true,
				markers = {mkr_castle_front},
				thresholds = {0.6},
				thresholdType = Threshold_PercentageEntitiesRemaining,
			},
			onFailure = DespawnOrReinforce,
		}
		
		for i = 1, 16 do 
			data.units[1].sbp = SBP.GERMAN.GRENADIER_SQUAD
			data.name = "west" .. i
			goalData.garrison = false
			for k,v in pairs(data.units) do
				v.upgrades = nil
				v.spawn = Marker_FromName("mkr_west" .. i, "")
				if i == 2 or i == 4 or i == 9 then 
					v.sbp = SBP.GERMAN.SNIPER_SQUAD
					goalData.garrison = true
					goalData.coordinatedSetupFacingPositions = nil
				elseif i == 3 then
					v.sbp = SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD
				elseif i == 7 then
					v.sbp = SBP.GERMAN.OSTRUPPEN_SQUAD
				elseif i == 8 then

				elseif i == 6 or i == 10 or i == 11 then
					v.upgrades = {UPG.GERMAN.GRENADIER_MG42_LMG}
				end
				if (i >= 9 and i <= 8) or i  == 10 then
					goalData.coordinatedSetupFacingPositions = {mkr_face_w2}
				elseif i == 9 then
					goalData.coordinatedSetupFacingPositions = {mkr_face_w3}
				elseif i > 11 then
					v.sbp = Table_GetRandomItem({SBP.GERMAN.GRENADIER_SQUAD,SBP.GERMAN.PANZER_GRENADIER_SQUAD,SBP.GERMAN.SNIPER_SQUAD, SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD})
				end
				if v.sbp == SBP.GERMAN.GRENADIER_SQUAD then
					goalData.abilityControlsList = {
						{
							abilityPBG = ABILITY.GERMAN.GRENADIER_PANZERFAUST,
							maxCasters = 1,
							maxRange = 25,
							waitTimeSecs = 45,
						}
					}
				end
				
			end
			goalData.target = Marker_FromName("mkr_west" .. i, "")
			g_enc_west[i] = Encounter:Create(data)
			g_enc_west[i]:SetGoal(goalData)
			goalData.abilityControlsList = nil
			goalData.coordinatedSetupFacingPositions = {mkr_face_w1}
		end
		
		local data = {
			name = "strat_west",
			player = player2,
			sgroups = {sg_e_all},
			units = {
				{
					sbp = SBP.GERMAN.GRENADIER_SQUAD,
					spawn = mkr_strat_west_spawn
				},
				{
					sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
					spawn = mkr_strat_west_spawn
				},
				{
					sbp = SBP.GERMAN.SNIPER_SQUAD,
					spawn = mkr_strat_west_spawn
				},
			}
		}
		g_enc_stratwest = Encounter:Create(data)
		
		local goalData = {
			name = "Defend",
			target = mkr_strat_west,
			garrisonIdle = false,
			range = 30,
			leashRange = 25,
			coordinatedSetup = true,
			coordinatedSetupFacingPositions = {mkr_bomb_trigger1, mkr_bomb_trigger2, mkr_lightArtyTarget},
			fallbackParams = {
				retreat = true,
				markers = {mkr_castle_front},
				thresholds = {0.34},
				thresholdType = Threshold_PercentageEntitiesRemaining,
			},
			onFailure = DespawnOrReinforce,
		}
		g_enc_stratwest:SetGoal(goalData)

	-- Squads without AI (until they are spotted)
	Util_CreateSquads(player2, {sg_e_all, sg_e_noAI}, SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD, mkr_westPak1)
	Util_CreateSquads(player2, {sg_e_all, sg_e_noAI}, SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD, mkr_westPak2)
	Util_CreateSquads(player2, {sg_e_all, sg_e_noAI}, SBP.GERMAN.SNIPER_SQUAD, mkr_westSniper1)
	Util_CreateSquads(player2, {sg_e_all, sg_e_noAI}, SBP.GERMAN.SNIPER_SQUAD, mkr_westSniper2)
	Util_CreateSquads(player2, {sg_e_all, sg_e_noAI}, SBP.GERMAN.SNIPER_SQUAD, mkr_westSniper3)
	
	g_enc_noAI = {}
	Rule_AddDelayedInterval(Southwest_West_EnableAI, 30, 1)

end

function Southwest_West_EnableAI()
	if SGroup_IsEmpty(sg_e_noAI) then
		Rule_RemoveMe()
	else
		local targetPos = mkr_strat_southwest
		local goalData = {
			name = "Defend",
			target = targetPos,
			range = 35,
			leashRange = 25,
		}
		local f = function (gid, idx, sid)
			targetPos = Squad_GetPosition(sid)
			if Player_CanSeePosition(player1, targetPos) then
				SGroup_Clear(sg_e_noAI_single)
				SGroup_Add(sg_e_noAI_single, sid)
				SGroup_Remove(sg_e_noAI, sid)
				table.insert(g_enc_noAI, Encounter:ConvertSgroup(sg_e_noAI_single))
				goalData.target = targetPos
				g_enc_noAI[#g_enc_noAI]:SetGoal(goalData)
			end
		end
		SGroup_ForEach(sg_e_noAI, f)
	end
end

--- #EMPLACEMENTS -- Pak 43s
function Lublin_SpawnNorthwest()
	sg_p_northwest = SGroup_CreateIfNotFound("sg_p_northwest")
	sg_p_north = SGroup_CreateIfNotFound("sg_p_north")
	SGroup_Clear(sg_p_north)
	World_GetSquadsWithinTerritorySector(player1, sg_p_north, sectorID_north, OT_Player)
	SGroup_Clear(sg_p_northwest)
	World_GetSquadsWithinTerritorySector(player1, sg_p_northwest, sectorID_northwest, OT_Player)
	if not SGroup_IsEmpty(sg_p_northwest) or (g_northSpawned and not SGroup_IsEmpty(sg_p_north)) then
		g_enc_northWest = {}
		g_northwestSpawned = true
		sg_e_pak43s = SGroup_CreateIfNotFound("sg_e_pak43s")
		local data = {
			name = "northWest",
			player = player2,
			sgroups = {sg_e_all},
			units = {
				{
					sbp = SBP.GERMAN.GRENADIER_SQUAD,
					spawn = mkr_northWest1
				},
			}
		}
		local goalData = {
			name = "Defend",
			useSkirmishAI = g_useSkirmishAI,
			target = mkr_northWest1,
			garrisonIdle = false,
			garrison = false,
			range = 30,
			leashRange = 20,
			fallbackParams = {
				retreat = true,
				markers = {Marker_FromName("mkr_fallback_nw", "")},
				thresholds = {0.6},
				thresholdType = Threshold_PercentageEntitiesRemaining,
			},
			onFailure = DespawnOrReinforce,
			coordinatedSetup = true,
			coordinatedSetupFacingPositions = {mkr_face_nw1},
		}
		
		for i = 1, 9 do 
			data.units[1].sbp = SBP.GERMAN.GRENADIER_SQUAD
			data.units[1].upgrades = nil
			data.units[1].veterancyRank = nil
			goalData.tacticControlsList = nil
			goalData.fallbackParams = {
				retreat = true,
				markers = {Marker_FromName("mkr_fallback_nw", "")},
				thresholds = {0.6},
				thresholdType = Threshold_PercentageEntitiesRemaining,
			}
			data.name = "northWest" .. i
			for k,v in pairs(data.units) do
				v.spawn = Marker_FromName("mkr_northWest" .. i, "")
				if i == 1 or i == 2 then 
					v.upgrades = {UPG.GERMAN.GRENADIER_MG42_LMG}
					goalData.range = 30
				elseif i == 3 then
					goalData.range = 35
					goalData.tacticControlsList = {
						{
							tacticType = TACTIC_Avoid,
							priority = 100,
						},
					}
					goalData.fallbackParams = nil
				elseif i == 5 then
					v.sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD
					goalData.range = 35
				elseif i == 4 or i == 6 or i == 9 then
					v.sbp = SBP.GERMAN.PAK43_88MM_AT_GUN_SQUAD
					v.sgroups = {sg_e_pak43s}
					if g_hardDiff then
						v.veterancyRank = 2
					end
					goalData.range = 80
					goalData.leashRange = 80
				elseif i == 7 or i == 8 then
					v.sbp = SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD
					goalData.range = 45
				end
			end
			goalData.target = Marker_FromName("mkr_northWest" .. i, "")
			goalData.coordinatedSetupFacingPositions = {Marker_FromName("mkr_face_nw" .. i, "")}
			
			g_enc_northWest[i] = Encounter:Create(data)
			g_enc_northWest[i]:SetGoal(goalData)
		end
		
		local data = {
			name = "northWestPatrol",
			player = player2,
			sgroups = {sg_e_all},
			units = {
				{
					sbp = SBP.GERMAN.SCOUTCAR_SDKFZ222,
					spawn = mkr_northWest10
				},
			}
		}
		g_enc_northWest[10] = Encounter:Create(data)
		
		-- Patroller
		local goalData = {
			name = "Defend",
			garrisonIdle = false,
			garrison = false,
			patrolParams = {
				path = "northWest1",
				wait = 5,
			}
		}
		
		g_enc_northWest[10]:SetGoal(goalData)
		
		local data = {
			name = "strat_northWest",
			player = player2,
			sgroups = {sg_e_all},
			units = {
				{
					sbp = SBP.GERMAN.GRENADIER_SQUAD,
					spawn = mkr_strat_northwest_spawn1
				},
				{
					sbp = SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD,
					spawn = mkr_strat_northwest_spawn2
				},
				{
					sbp = SBP.GERMAN.GRENADIER_SQUAD,
					spawn = mkr_strat_northwest_spawn3
				},
			}
		}
		g_enc_stratNorthwest = Encounter:Create(data)
		
		local goalData = {
			name = "Defend",
			target = mkr_strat_northwest,
			garrisonIdle = false,
			range = 30,
			leashRange = 50,
			coordinatedSetup = true,
			coordinatedSetupFacingPositions = {mkr_face_strat_nw1, mkr_face_strat_nw2, mkr_face_strat_nw3},
			tacticControlsList = {
				{
					tacticType = TACTIC_Retaliate,
					priority = 100,
					retryTimeSecs = 8,
					waitTimeSecs = 15,
				},
			},
			fallbackParams = {
				retreat = true,
				markers = {mkr_castle_front},
				thresholds = {0.34},
				thresholdType = Threshold_PercentageEntitiesRemaining,
			},
			onFailure = DespawnOrReinforce,
		}
		g_enc_stratNorthwest:SetGoal(goalData)	
		SGroup_Destroy(sg_p_northwest)
		
		if g_hardDiff then
			Modify_WeaponRange(sg_e_pak43s, "hardpoint_01", 1.666)
			Modify_SightRadius(sg_e_pak43s, 2)
		else
			Modify_WeaponRange(sg_e_pak43s, "hardpoint_01", 1.333)
			Modify_SightRadius(sg_e_pak43s, 1.5)
		end
		SGroup_SetRecrewable(g_enc_northWest[4].sgroup, false)
		SGroup_SetRecrewable(g_enc_northWest[6].sgroup, false)
		SGroup_SetRecrewable(g_enc_northWest[9].sgroup, false)
		Event_GroupIsDead(Achievement_GlassCannons_Pak43s, {}, sg_e_pak43s)
		
		-- Squads without AI
		Util_CreateSquads(player2, sg_e_all, SBP.GERMAN.GRENADIER_SQUAD, mkr_northwestFountain, nil, 1, nil, nil, nil, UPG.GERMAN.GRENADIER_MG42_LMG)
		Util_CreateSquads(player2, sg_e_all, SBP.GERMAN.GRENADIER_SQUAD, mkr_northwestFountain2, nil, 1, nil, nil, nil, UPG.GERMAN.GRENADIER_MG42_LMG)
		
		Speech_FlaksSpotted()
		Rule_RemoveMe()
		
		
	end
end
--- #MISC NORTH -- Mostly Panzer Grenadiers
function Lublin_SpawnNorth()
	sg_p_north = SGroup_CreateIfNotFound("sg_p_north")
	sg_p_northeast = SGroup_CreateIfNotFound("sg_p_northeast")
	SGroup_Clear(sg_p_northeast)
	World_GetSquadsWithinTerritorySector(player1, sg_p_northeast, sectorID_northeast, OT_Player)
	SGroup_Clear(sg_p_north)
	World_GetSquadsWithinTerritorySector(player1, sg_p_north, sectorID_north, OT_Player)
	if not SGroup_IsEmpty(sg_p_north) or (g_northeastSpawned  and not SGroup_IsEmpty(sg_p_northeast))  then
		g_enc_north = {}
		g_northSpawned = true
		local data = {
			name = "north",
			player = player2,
			sgroups = {sg_e_all},
			units = {
				{
					sbp = SBP.GERMAN.GRENADIER_SQUAD,
					spawn = mkr_north1
				},
			}
		}
		local goalData = {
			name = "Defend",
			useSkirmishAI = g_useSkirmishAI,
			target = mkr_north1,
			garrisonIdle = false,
			garrison = false,
			fallbackParams = {
				retreat = true,
				markers = {Marker_FromName("mkr_fallback_n", "")},
				thresholds = {0.6},
				thresholdType = Threshold_PercentageEntitiesRemaining,
			},
			onFailure = DespawnOrReinforce,
		}
		
		for i = 1, 6 do 
			data.units[1].sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD
			data.units[1].upgrades = {UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM}
			data.name = "north" .. i
			for k,v in pairs(data.units) do
				v.spawn = Marker_FromName("mkr_north" .. i, "")
				if i == 1 or i == 3 or i == 5 then 
					data.units[1].upgrades = nil
				end
			end
			goalData.target = Marker_FromName("mkr_north" .. i, "")
			g_enc_north[i] = Encounter:Create(data)
			g_enc_north[i]:SetGoal(goalData)
		end
		
		local data = {
			name = "strat_north",
			player = player2,
			sgroups = {sg_e_all},
			units = {
				{
					sbp = SBP.GERMAN.GRENADIER_SQUAD,
					upgrades = {UPG.GERMAN.GRENADIER_MG42_LMG},
					spawn = mkr_strat_north_spawn
				},
				{
					sbp = SBP.GERMAN.GRENADIER_SQUAD,
					upgrades = {UPG.GERMAN.GRENADIER_MG42_LMG},
					spawn = mkr_strat_north_spawn
				},
			}
		}
		g_enc_stratNorth = Encounter:Create(data)
		
		local goalData = {
			name = "Defend",
			target = mkr_strat_north,
			garrisonIdle = false,
			range = 30,
			leashRange = 25,
			coordinatedSetup = true,
			coordinatedSetupFacingPositions = {mkr_face_n1, mkr_face_n2},
			fallbackParams = {
				retreat = true,
				markers = {mkr_castle_front},
				thresholds = {0.34},
				thresholdType = Threshold_PercentageEntitiesRemaining,
			},
			onFailure = DespawnOrReinforce,
		}
		g_enc_stratNorth:SetGoal(goalData)	
		SGroup_Destroy(sg_p_north)
		Rule_RemoveMe()
	end
end

--- #MORTARS/PANZERWERFERS
function Lublin_SpawnNortheast()
	sg_p_northeast = SGroup_CreateIfNotFound("sg_p_northeast")
	sg_p_east = SGroup_CreateIfNotFound("sg_p_east")
	SGroup_Clear(sg_p_northeast)
	World_GetSquadsWithinTerritorySector(player1, sg_p_northeast, sectorID_northeast, OT_Player)
	SGroup_Clear(sg_p_east)
	World_GetSquadsWithinTerritorySector(player1, sg_p_east, sectorID_east, OT_Player)
	if not SGroup_IsEmpty(sg_p_northeast) or (g_eastSpawned and not SGroup_IsEmpty(sg_p_east)) then
		sg_werfers = SGroup_CreateIfNotFound("sg_e_werfers")
		sg_werfer_single = SGroup_CreateIfNotFound("sg_werfer_single")
		sg_werferTarget = SGroup_CreateIfNotFound("sg_werferTarget")
		g_northeastSpawned = true
		g_enc_northEast = {}
		local data = {
			name = "northEast",
			player = player2,
			sgroups = {sg_e_all},
			units = {
				{
					sbp = SBP.GERMAN.GRENADIER_SQUAD,
					spawn = mkr_northEast1
				},
			}
		}
		local goalData = {
			name = "Defend",
			useSkirmishAI = g_useSkirmishAI,
			target = mkr_northEast1,
			garrisonIdle = false,
			garrison = false,
			range = 30,
			leashRange = 22,
		}
		
		for i = 1, 9 do 
			data.units[1].sbp = SBP.GERMAN.MORTAR_TEAM_81MM
			data.units[1].upgrades = nil
			data.units[1].veterancyRank = nil
			data.name = "northEast" .. i
			data.sgroups = {sg_e_all}
			for k,v in pairs(data.units) do
				v.spawn = Marker_FromName("mkr_northEast" .. i, "")
				if i == 1 or i == 3 or i == 5 then
					data.sgroups = {sg_e_all, sg_werfers}
					v.sbp = SBP.GERMAN.PANZERWERFER_SQUAD
					if g_hardDiff then
						v.veterancyRank = 2
					end
				elseif i == 7 then
					v.sbp = SBP.GERMAN.OSTWIND_SQUAD
					goalData.patrolParams = {
						path = "northEast7",
						wait = 5,
					}
				elseif i == 8 then
					v.sbp = SBP.GERMAN.PANZER_IV_SQUAD
					goalData.patrolParams = {
						path = "northEast8",
						wait = 5,
					}
				elseif i == 9 then
					v.sbp = SBP.GERMAN.OSTWIND_SQUAD
					goalData.patrolParams = {
						path = "northEast9",
						wait = 5,
					}
				end
			end
			goalData.target = Marker_FromName("mkr_northEast" .. i, "")
			g_enc_northEast[i] = Encounter:Create(data)
			if i ~= 1 and i ~= 3 and i ~= 5 then
				g_enc_northEast[i]:SetGoal(goalData)
			end
		end
		
		local data = {
			name = "strat_northEast",
			player = player2,
			sgroups = {sg_e_all},
			units = {
				{
					sbp = SBP.GERMAN.GRENADIER_SQUAD,
					upgrades = {UPG.GERMAN.GRENADIER_MG42_LMG},
					spawn = mkr_strat_northEast_spawn1
				},
				{
					sbp = SBP.GERMAN.GRENADIER_SQUAD,
					upgrades = {UPG.GERMAN.GRENADIER_MG42_LMG},
					spawn = mkr_strat_northEast_spawn2
				},
				{
					sbp = SBP.GERMAN.SDKFZ_251_HALFTRACK_SQUAD,
					upgrades = {UPG.GERMAN.SDKFZ_251_HALFTRACK_MOBILE_MEDIC_STATION_UPGRADE},
					spawn = mkr_strat_northEast_spawn3
				},
			}
		}
		g_enc_stratNortheast = Encounter:Create(data)
		
		local goalData = {
			name = "Defend",
			target = mkr_strat_northEast,
			garrisonIdle = false,
			range = 30,
			leashRange = 25,
			coordinatedSetup = true,
			coordinatedSetupFacingPositions = {mkr_stratNE_face1, mkr_stratNE_face2, mkr_stratNE_face3},
			fallbackParams = {
				retreat = true,
				markers = {Marker_FromName("mkr_fallback_ne", "")},
				thresholds = {0.34},
				thresholdType = Threshold_PercentageEntitiesRemaining,
			},
			onFailure = DespawnOrReinforce,
		}
		g_enc_stratNortheast:SetGoal(goalData)	
		
		--- Panzerwerfer Firing ---
		g_werferWarningIndex = 1
		if g_easyDiff then
			Rule_AddDelayedInterval(Obj1_rocketBarrage, 5, 60)
		else
			Rule_AddDelayedInterval(Obj1_rocketBarrage, 5, 30)
		end
		Speech_PanzerwerfersSpotted()
		Rule_RemoveMe()
	end
end

--- #INTERSTITIAL -- Infantry and Light Vehicles
function Lublin_SpawnEast()
	sg_p_east = SGroup_CreateIfNotFound("sg_p_east")
	SGroup_Clear(sg_p_east)
	World_GetSquadsWithinTerritorySector(player1, sg_p_east, sectorID_east, OT_Player)
	if not SGroup_IsEmpty(sg_p_east) or g_southeastSpawned or g_northeastSpawned then
		g_eastSpawned = true
		local data = {
			name = "strat_east1",
			player = player2,
			sgroups = {sg_e_all},
			units = {
				{
					sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
					spawn = mkr_strat_east_spawn1
				},
				{
					sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
					spawn = mkr_strat_east_spawn2
				},
				{
					sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
					spawn = mkr_strat_east_spawn3
				},
				{
					sbp = SBP.GERMAN.GRENADIER_SQUAD,
					spawn = mkr_strat_east_spawn4
				},
				{
					sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
					spawn = mkr_strat_east_spawn5
				},
			}
		}
		g_enc_stratEast1 = Encounter:Create(data)
		
		local data = {
			name = "strat_east2",
			player = player2,
			sgroups = {sg_e_all},
			units = {
				{
					sbp = SBP.GERMAN.SCOUTCAR_SDKFZ222,
					spawn = mkr_strat_east_spawn6
				},
				{
					sbp = SBP.GERMAN.SDKFZ_251_HALFTRACK_SQUAD,
					entityUpgrades = {UPG.GERMAN.SDKFZ_251_HALFTRACK_FLAMMPANZERWAGEN_UPGRADE},
					spawn = mkr_strat_east_spawn7
				},
			}
		}
		g_enc_stratEast2 = Encounter:Create(data)
		
		local goalData = {
			name = "Defend",
			target = mkr_strat_east,
			garrisonIdle = false,
			range = 50,
			leashRange = 30,
			pickupWeapons = -1,
			coordinatedSetup = true,
			coordinatedSetupFacingPositions = {mkr_face_strat_e1, mkr_face_strat_e2, mkr_face_strat_e3},
		}
		g_enc_stratEast1:SetGoal(goalData)

		local goalData = {
			name = "Defend",
			target = mkr_strat_east,
			garrisonIdle = false,
			range = 50,
			leashRange = 40,
		}
		g_enc_stratEast2:SetGoal(goalData)				
		
		EGroup_SetCrushable(eg_nocrush1, false)
		Rule_AddOneShot(SpawnEast_EnableCoverCrush, 20)
		Rule_RemoveMe()
	end
end

function SpawnEast_EnableCoverCrush()
	EGroup_SetCrushable(eg_nocrush1, true)
end

--- #TANKS -- Elefant in the center
function Lublin_SpawnSoutheast()
	sg_p_southeast = SGroup_CreateIfNotFound("sg_p_southeast")
	SGroup_Clear(sg_p_southeast)
	World_GetSquadsWithinTerritorySector(player1, sg_p_southeast, sectorID_southeast, OT_Player) 
	if not SGroup_IsEmpty(sg_p_southeast) or g_southSpawned or (g_eastSpawned and Player_CanSeeSGroup(player1, g_enc_stratEast1.sgroup, ANY)) then
		g_southeastSpawned = true
		g_enc_southEast = {}
		sg_e_tanks_se = SGroup_CreateIfNotFound("sg_e_tanks_se")
		sg_e_elefant = SGroup_CreateIfNotFound("sg_e_elefant")
		local data = {
			name = "southEast",
			player = player2,
			sgroups = {sg_e_all, sg_e_tanks_se},
			units = {
				{
					sbp = SBP.GERMAN.GRENADIER_SQUAD,
					spawn = mkr_southEast1
				},
			}
		}
		local goalData = {
			name = "Defend",
			useSkirmishAI = g_useSkirmishAI,
			target = mkr_southEast1,
			range = 35,
			leashRange = 25,
			tacticControlsList = {
				{
					tacticType = TACTIC_Retaliate,
					priority = 500,
					retryTimeSecs = 8,
					waitTimeSecs = 15,
				},
			}
		}
		if g_easyDiff then
			goalData.tacticControlsList = g_tactics_disableVehicle
		end
			
		
		for i = 1, 9 do 
			data.name = "southEast" .. i
			data.units[1].veterancyRank = nil
			for k,v in pairs(data.units) do
				v.spawn = Marker_FromName("mkr_southEast" .. i, "")
				if i == 1 then 
					v.sbp = SBP.GERMAN.STUG_III_SQUAD
				elseif i == 2 then
					v.sbp = SBP.GERMAN.STUG_III_E_SQUAD
				elseif i == 3 then
					v.sbp = SBP.GERMAN.OSTWIND_SQUAD
					goalData.range = 60
				elseif i == 4 then
					v.sbp = SBP.GERMAN.PANZER_IV_SQUAD
					goalData.range = 60
				elseif i == 5 then
					v.sbp = SBP.GERMAN.ELEFANT_TANK_DESTROYER_SQUAD
					if g_hardDiff then
						v.veterancyRank = 2
					end
					v.sgroups = {sg_e_elefant}
					goalData.leashRange = 20
				elseif i == 6 then
					v.sbp = SBP.GERMAN.OSTWIND_SQUAD
				elseif i == 7 then
					v.sbp = SBP.GERMAN.STUG_III_SQUAD
				elseif i == 8 then
					v.sbp = SBP.GERMAN.PANZER_IV_SQUAD
				elseif i == 9 then
					v.sbp = SBP.GERMAN.OSTWIND_SQUAD
				end
			end
			goalData.target = Marker_FromName("mkr_southEast" .. i, "")
			g_enc_southEast[i] = Encounter:Create(data)
			g_enc_southEast[i]:SetGoal(goalData)
			goalData.leashRange = 25
			goalData.patrolParams = nil
		end
		SGroup_Destroy(sg_p_southeast)
		Rule_AddDelayedInterval(Speech_ElefantSpotted, 30, 1)
		Event_GroupIsDead(Achievement_GlassCannons_Elefant, {}, sg_e_elefant)
		Speech_TanksSpotted()
		Rule_RemoveMe()
	end
end

--- #MISC SOUTH -- Mixed infantry and tanks
function Lublin_SpawnSouth()
	sg_p_south = SGroup_CreateIfNotFound("sg_p_south")
	SGroup_Clear(sg_p_south)
	World_GetSquadsWithinTerritorySector(player1, sg_p_south, sectorID_south, OT_Player)
	if not SGroup_IsEmpty(sg_p_south) or (g_southeastSpawned and Player_CanSeeSGroup(player1, sg_e_tanks_se, ANY)) or Player_CanSeePosition(player1, Marker_GetPosition(mkr_canSee_SE)) then
		g_southSpawned = true
		g_enc_south = {}
		local data = {
			name = "south",
			player = player2,
			sgroups = {sg_e_all},
			units = {
				{
					sbp = SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD,
					spawn = mkr_south1
				},
			}
		}
		local goalData = {
			name = "Defend",
			useSkirmishAI = g_useSkirmishAI,
			target = mkr_south1,
			garrisonIdle = false,
			garrison = false,
		}
		
		for i = 1, 9 do 
			data.name = "south" .. i
			for k,v in pairs(data.units) do
				if i == 1 or i == 2 or i == 3 then
					v.spawn = Marker_FromName("mkr_south" .. i, "")	
					goalData.target = Marker_FromName("mkr_south" .. i, "")
				elseif i == 4 then
					v.sbp = SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD
					v.spawn = EGroup_FromName("eg_south_bunker1")
					goalData.target = EGroup_FromName("eg_south_bunker1")
					goalData.garrison = true
					goalData.garrisonIdle = true
				elseif i == 5 or i == 6 then
					v.sbp = SBP.GERMAN.OSTRUPPEN_SQUAD
					v.spawn = Marker_FromName("mkr_south" .. i, "")	
					goalData.target = Marker_FromName("mkr_south" .. i, "")
					goalData.range = 40
					goalData.leashRange = 25
					goalData.garrison = true
					goalData.garrisonIdle = false
				else
					goalData.range = nil
					goalData.leashRange = nil
					v.sbp = SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD
					v.spawn = EGroup_FromName("eg_south_bunker" .. (i - 5))
					goalData.target = EGroup_FromName("eg_south_bunker" .. (i - 5))
					goalData.garrison = true
					goalData.garrisonIdle = true
				end
			end
			
			g_enc_south[i] = Encounter:Create(data)
			g_enc_south[i]:SetGoal(goalData)
		end
		
		data.name = "south8"
		data.units[1].sbp = SBP.GERMAN.SDKFZ_251_HALFTRACK_SQUAD
		data.units[1].spawn = mkr_south4
		goalData.target = nil 
		goalData.patrolParams = {
			path = "south4",
			wait = 5,
		}
		
		g_enc_south[8] = Encounter:Create(data)
		g_enc_south[8]:SetGoal(goalData)
		
		Rule_AddOneShot(Lublin_spawnSouthInHalftrack, 1)
		
		local data = {
			name = "strat_south",
			player = player2,
			sgroups = {sg_e_all},
			units = {
				{
					sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
					spawn = mkr_strat_south_spawn
				},
				{
					sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
					upgrades = {UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM},
					spawn = mkr_strat_south_spawn
				},
			}
		}
		g_enc_stratSouth = Encounter:Create(data)
		
		local goalData = {
			name = "Defend",
			target = mkr_strat_south,
			garrisonIdle = false,
			range = 30,
			leashRange = 25,
			coordinatedSetup = true,
			coordinatedSetupFacingPositions = {mkr_stratS_face1, mkr_stratS_face2},
			fallbackParams = {
				retreat = true,
				markers = {Marker_FromName("mkr_fallback_s", "")},
				thresholds = {0.34},
				thresholdType = Threshold_PercentageEntitiesRemaining,
			},
			onFailure = DespawnOrReinforce,
		}
		g_enc_stratSouth:SetGoal(goalData)	
		
		SGroup_Destroy(sg_p_south)
		Rule_RemoveMe()
	end
end

function Lublin_spawnSouthInHalftrack()
		local data = {
			name = "south9",
			player = player2,
			sgroups = {sg_e_all},
			spawn = g_enc_south[8].sgroup,
			units = {
				{
					sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
					upgrades = {UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM},
				},
				{
					sbp = SBP.GERMAN.GRENADIER_SQUAD,
					upgrades = {UPG.GERMAN.GRENADIER_MG42_LMG},
				},
			}
		}
	g_enc_south[9] = Encounter:Create(data)
	Rule_AddDelayedInterval(Lublin_HalftrackUnload, 10, 2)
end

function Lublin_HalftrackUnload()

	local halftrack = g_enc_south[8].sgroup

	if SGroup_IsUnderAttack(halftrack, ANY, 2) then
		Cmd_EjectOccupants(halftrack)
		Cmd_InstantUpgrade(halftrack, UPG.GERMAN.SDKFZ_251_HALFTRACK_MOBILE_MEDIC_STATION_UPGRADE)
		local goalData = {
			name = "Defend",
			range = 40,
			leashRange = 30,
			target = Util_GetPosition(halftrack),
			useSkirmishAI = g_useSkirmishAI,
			garrisonIdle = false,
		}
		g_enc_south[9]:SetGoal(goalData)
	end
end

function Lublin_SpawnGateDefense()
	sg_p_nearCastle = SGroup_CreateIfNotFound("sg_p_nearCastle")
	SGroup_Clear(sg_p_nearCastle)
	World_GetSquadsWithinTerritorySector(player1, sg_p_nearCastle, sectorID_castle, OT_Player)
	if not SGroup_IsEmpty(sg_p_nearCastle) or SGroup_Exists("sg_152") then
		local data = {
			name = "gateDefense",
			player = player2,
			sgroups = {sg_e_all},
			units = {
				{
					sbp = SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD,
					spawn = mkr_gate_pak1
				},
				{
					sbp = SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD,
					spawn = mkr_gate_pak2
				},
				{
					sbp = SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD,
					spawn = mkr_gate_HMG1,
				},
				{
					sbp = SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD,
					spawn = mkr_gate_HMG2,
				},
				{
					sbp = SBP.GERMAN.PANZER_IV_SQUAD,
					spawn = mkr_gate_tank1,
				},
				{
					sbp = SBP.GERMAN.PANZER_IV_SQUAD,
					spawn = mkr_gate_tank2,
				},
			}
		}
		
		if g_hardDiff then
			data.units[5].veterancyRank = 3
			data.units[6].veterancyRank = 3
		end
		
		g_enc_gateDefense = Encounter:Create(data, true)
		
		local data = {
			name = "castleInterior",
			player = player2,
			sgroups = {sg_e_all},
			units = {
				{
					sbp = SBP.GERMAN.MORTAR_TEAM_81MM,
					spawn = mkr_castle_mortar1
				},
				{
					sbp = SBP.GERMAN.MORTAR_TEAM_81MM,
					spawn = mkr_castle_mortar2
				},
				{
					sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
					spawn = mkr_castle_inf1,
				},
				{
					sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
					spawn = mkr_castle_inf2
				},
				{
					sbp = SBP.GERMAN.GRENADIER_SQUAD,
					spawn = mkr_castle_inf3
				},
				{
					sbp = SBP.GERMAN.GRENADIER_SQUAD,
					spawn = mkr_castle_inf4
				},
				{
					sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
					spawn = mkr_castle_inf5
				},
				{
					sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
					spawn = mkr_castle_inf6
				},
				{
					sbp = SBP.GERMAN.SCOUTCAR_SDKFZ222,
					spawn = mkr_castle_inf7
				},
				{
					sbp = SBP.GERMAN.SDKFZ_251_HALFTRACK_SQUAD,
					spawn = mkr_castle_inf8
				},
			}
		}
		
		g_enc_castleInterior = Encounter:Create(data, true)
		
		SGroup_SetMoodMode(g_enc_castleInterior.sgroup, MM_ForceTense)
		Modify_ReceivedDamage(g_enc_castleInterior.sgroup, 2)
		
		SGroup_EnableUIDecorator(g_enc_castleInterior.sgroup, false)
		SGroup_SetSelectable(g_enc_castleInterior.sgroup, false)
		
		sg_prisoners1 = SGroup_CreateIfNotFound("sg_prisoners1")
		sg_prisoners2 = SGroup_CreateIfNotFound("sg_prisoners2")
		
		local data = {
			name = "castlePrisoners",
			player = player2,
			sgroups = {sg_e_all},
			units = {
				{
					sbp = SBP.SOVIET.BASE_CONSCRIPT_SQUAD,
					sgroups = {sg_prisoners1},
					spawn = mkr_prisoners1
				},
				{
					sbp = SBP.SOVIET.SHOCK_TROOPS,
					sgroups = {sg_prisoners2},
					spawn = mkr_prisoners2
				},
				{
					sbp = SBP.SOVIET.BASE_CONSCRIPT_SQUAD,
					spawn = mkr_prisoners3
				},
			}
		}
		
		g_enc_castlePrisoners = Encounter:Create(data, true)
		
		Util_ApplyModifier(g_enc_castlePrisoners.sgroup, "posture_speed_modifier", -3, MUT_Addition)
		Modify_WeaponEnabled(g_enc_castlePrisoners.sgroup, "hardpoint_01", false)
		Cmd_SquadPath(sg_prisoners1, "prison1", true, LOOP_NORMAL, false, 8)
		Cmd_SquadPath(sg_prisoners2, "prison2", true, LOOP_NORMAL, false, 12)
		SGroup_EnableUIDecorator(g_enc_castlePrisoners.sgroup, false)
		SGroup_EnableMinimapIndicator(g_enc_castleInterior.sgroup, false)
		SGroup_EnableMinimapIndicator(g_enc_castlePrisoners.sgroup, false)	
		SGroup_SetSelectable(g_enc_castlePrisoners.sgroup, false)		
		
		EGroup_SetSelectable(eg_e_germanBase, false)
		EGroup_EnableMinimapIndicator(eg_e_germanBase, false)
		
		Cmd_InstantSetupTeamWeapon(g_enc_gateDefense.sgroup)
		
		Rule_AddInterval(GateDefense_EnableAI, 5)
		Rule_AddInterval(CastleInterior_EnableAI, 3)
		
		Rule_RemoveMe()
	end
	
end

function GateDefense_EnableAI()
	if SGroup_IsEmpty(g_enc_gateDefense.sgroup) then
		Rule_RemoveMe()
	elseif SGroup_IsUnderAttack(g_enc_gateDefense.sgroup, ANY, 5) then
		local goalData = {
			name = "Defend",
			target = mkr_airplaneLoiter,
			leashRange = 60,
			range = 75,
			maxAttackers = 3,
			tacticControlsList = {
				{
					tacticType = TACTIC_Retaliate,
					priority = 500,
					retryTimeSecs = 8,
					waitTimeSecs = 15,
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
		g_enc_gateDefense:SetGoal(goalData)
		Rule_RemoveMe()
	end
end

function CastleInterior_EnableAI()	
	if SGroup_IsEmpty(g_enc_castleInterior.sgroup) then
		Rule_RemoveMe()
	elseif SGroup_IsUnderAttack(g_enc_castleInterior.sgroup, ANY, 3) then
		local goalData = {
			name = "Defend",
			target = mkr_castle_center,
			leashRange = 25,
			range = 25,
			tacticControlsList = {
				{
					tacticType = TACTIC_Retaliate,
					priority = -1,
				},
				{
					tacticType = TACTIC_Cover,
					priority = -1,
				},
				{
					tacticType = TACTIC_Avoid,
					priority = 500,
				},
			},
		}	
		g_enc_castleInterior:SetGoal(goalData)
		Rule_RemoveMe()
	end
end

function _counterPlayerArtilllery()
	-- Find player howitzers, mortars and SU-76
	-- Send enemy squads to attack them if they stay still for too long
	local player1Squads = Player_GetSquads(player1)
	local blueprintsMortar = {SBP.SOVIET.PM_82_41_MORTAR_SQUAD, SBP.GERMAN.MORTAR_TEAM_81MM, SBP.SOVIET.HM_120_38_MORTAR_SQUAD}
	local blueprintsArty = {SBP.SOVIET.SU_76M, SBP.SOVIET.M1931_203MM_B_4_HOWITZER_ARTILLERY}
	local blueprints = {SBP.SOVIET.PM_82_41_MORTAR_SQUAD, SBP.GERMAN.MORTAR_TEAM_81MM, SBP.SOVIET.HM_120_38_MORTAR_SQUAD,SBP.SOVIET.SU_76M, SBP.SOVIET.M1931_203MM_B_4_HOWITZER_ARTILLERY}
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
			local targetSquad = SGroup_GetSpawnedSquadAt(player1Squads, 1)
			local attackSquad = SBP.GERMAN.PANZER_GRENADIER_SQUAD
			local weaponUpgrade = nil
			local dropSlotItem = nil
			if Table_Contains(blueprintsMortar, Squad_GetBlueprint(targetSquad)) then
				attackSquad = SBP.GERMAN.GRENADIER_SQUAD
			elseif Squad_GetBlueprint(targetSquad) == SBP.SOVIET.SU_76M then
				weaponUpgrade = UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM
				dropSlotItem = {{slotItem = SLOT_ITEM.PANZERSHRECK, dropChance = 0.05, exclusive = true}}
			end
			
			local t_spawnMarkers = {mkr_fallback_nw, mkr_engineer_spawn, mkr_fallback_n, mkr_fallback_s, mkr_pioSpawn_far}
			if (#t_spawnMarkers == 0) or (t_spawnMarkers == nil) then
				return
			end
			local encData = {
				name = "counterArty",
				player = player2,
				spawn = Util_GetClosestMarker(player1Squads, t_spawnMarkers), 
				sgroups = {sg_e_counterArty},
				units = {
					{
						sbp = attackSquad,
						upgrades = {weaponUpgrade},
						dropItems = dropSlotItem
					},
				},
			}
			if scartype(encData.spawn) == ST_MARKER then
				if not (Player_CanSeePosition(player1, Marker_GetPosition(encData.spawn)) and Misc_IsPosOnScreen(Marker_GetPosition(encData.spawn), 1)) then
					g_enc_counterArty = Encounter:Create(encData)

					local goalData = {
						name = "Attack",
						attackMove = false,
						target = player1Squads,
						safeMoveWeight = 0.75,
						coordinatedMoveRadius = 15,
						pickupWeapons = -1,
						onSuccess = _counterPA_onSuccess,
					}
					g_enc_counterArty:SetGoal(goalData)		
					g_counterArtyCount = g_counterArtyCount + 1
				end
			end
			if g_counterArtyCount > t_difficulty.counterArty_attemptMax or g_counterArtySuccessCount >= t_difficulty.counterArty_successMax or Objective_IsComplete(OBJ_Capture) then
				Rule_RemoveMe()
			else
				if g_easyDiff then
					g_counterArtyInterval = g_counterArtyInterval + 30
				else
					g_counterArtyInterval = g_counterArtyInterval + 15
				end
				Rule_ChangeInterval(_counterPlayerArtilllery, g_counterArtyInterval)
			end
		end
	end
end

function _counterPA_onSuccess(enc)
	if enc:IsAlive() and not SGroup_IsEmpty(enc.sgroup) then
		g_counterArtySuccessCount = g_counterArtySuccessCount + 1
		if g_counterArtySuccessCount == 1 then
			Util_StartIntel(EVENTS.ArtyHuntWarning)
		end
		local player1Squads = Player_GetSquads(player1)
		local attackTarget = mkr_playerStart
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
			onSuccess = _counterPA_onSuccess,
		}
		enc:SetGoal(goalData)		
	end
end

--- Demolition Pioneers ---
--- Attempt to set demolition charges on the player's HQ, on Normal and Hard difficulty
function Lublin_DemolitionPioneers()
	if EGroup_IsEmpty(eg_p_hq) or World_GetGameTime() >= t_difficulty.demoPioneers_timeLimit then
		Rule_RemoveMe()
	elseif Player_CanSeePosition(player1, Marker_GetPosition(mkr_sw_canSee)) == false then
		if SGroup_IsEmpty(sg_baseHarass) then
			local encData = {
				name = "demoPioneers",
				player = player2,
				spawn = Util_FindHiddenSpawn(mkr_pioSpawn_far, mkr_pioSpawn_near), 
				sgroups = {sg_e_all, sg_baseHarass},
				units = {
					{
						sbp = SBP.GERMAN.PIONEER_SQUAD,
					},
				},
			}
			g_enc_demoPioneers = Encounter:Create(encData)
			EGroup_RemoveDemolitions(eg_p_hq)
			Cmd_SetDemolitions(sg_baseHarass, eg_p_hq, true)
			Rule_RemoveIfExist(Lublin_DetonateDemolitions)
			Rule_AddDelayedInterval(Lublin_DetonateDemolitions, 15, 5)
		elseif Rule_Exists(Lublin_DetonateDemolitions) == false and Timer_GetElapsed(0010) > 45 then
			EGroup_RemoveDemolitions(eg_p_hq)
			Cmd_SetDemolitions(sg_baseHarass, eg_p_hq, true)
			Rule_AddDelayedInterval(Lublin_DetonateDemolitions, 15, 5)
		end
	end
end

function Lublin_DetonateDemolitions()
	if EGroup_IsEmpty(eg_p_hq) then
		Rule_RemoveMe()
	elseif Entity_IsDemolitionReady(EGroup_GetSpawnedEntityAt(eg_p_hq, 1)) and not Prox_AreSquadMembersNearMarker(sg_baseHarass, EGroup_GetPosition(eg_p_hq), ANY, 5) then 
		Cmd_DetonateDemolitions(player2, eg_p_hq)
		Timer_Start(0010, 180)
		Rule_RemoveMe()
	elseif Entity_IsDemolitionReady(EGroup_GetSpawnedEntityAt(eg_p_hq, 1)) == false and SGroup_IsEmpty(sg_baseHarass) then
		Rule_RemoveMe()
	elseif SGroup_Count(sg_baseHarass) > 0 and Entity_IsDemolitionReady(EGroup_GetSpawnedEntityAt(eg_p_hq, 1)) then
		_demoPioneers_comment2()
		if Prox_AreSquadMembersNearMarker(sg_baseHarass, EGroup_GetPosition(eg_p_hq), ANY, 5) then
			Cmd_MoveAwayFromPos(sg_baseHarass, EGroup_GetPosition(eg_p_hq), 18) 
		end
		if SGroup_Exists("sg_227_commissar") and not SGroup_IsEmpty(sg_227_commissar) then
			Cmd_MoveAwayFromPos(sg_227_commissar, EGroup_GetPosition(eg_p_hq), 10) 
		end
	elseif SGroup_Count(sg_baseHarass) > 0 and Entity_IsDemolitionReady(EGroup_GetSpawnedEntityAt(eg_p_hq, 1)) == false then
		EGroup_RemoveDemolitions(eg_p_hq)
		Cmd_SetDemolitions(sg_baseHarass, eg_p_hq, true)
	end
end

function _demoPioneers_comment1()
	if Player_CanSeeSGroup(player1, sg_baseHarass, ANY) then
		Util_StartIntel(EVENTS.DemolitionsWarning_01)
		Rule_RemoveMe()
	end
end
function _demoPioneers_comment2()
	if g_demoPioneersCommentDone == nil then
		g_demoPioneersCommentDone = true
		Util_StartIntel(EVENTS.DemolitionsWarning_02)
	end
end

--- Garrisoned Ostruppen spawn in as the player gets close ---
function Lublin_GarrisonOstruppen()
	local f = function (gid, idx, eid)
		if Player_CanSeeEntity(player1, eid) then
			eg_ostGarrison_single = EGroup_CreateIfNotFound("eg_ostGarrison_single")
			EGroup_Add(eg_ostGarrison_single, eid)
			Util_CreateSquads(player2, sg_e_all, SBP.GERMAN.OSTRUPPEN_SQUAD, eg_ostGarrison_single, nil, 1, World_GetRand(2,6))
			Util_CreateSquads(player2, sg_e_all, SBP.GERMAN.OSTRUPPEN_SQUAD, eg_ostGarrison_single, nil, 1, World_GetRand(2,6))
			EGroup_Clear(eg_ostGarrison_single)
			EGroup_Remove(eg_ostGarrison, eid)
		end
	end
	if EGroup_IsEmpty(eg_ostGarrison) then
		Rule_RemoveMe()
	else
		EGroup_ForEach(eg_ostGarrison, f)
	end
end

function Lublin_RevealStrats()
	FOW_RevealEGroupOnly(eg_south_bunker1, 1)
	FOW_RevealEGroupOnly(eg_south_bunker2, 1)
	FOW_RevealEGroupOnly(eg_south_bunker3, 1)
	FOW_RevealEGroupOnly(eg_south_bunker4, 1)
end

-- Spawn allies for intro camera
function Lublin_SpawnAllies()
	sg_allies = SGroup_CreateIfNotFound("sg_allies")
	sg_allies_truck = SGroup_CreateIfNotFound("sg_allies_truck")
	Util_SetPlayerOwner(eg_introMine, player1)
	Util_CreateSquads(player3, sg_allies, SBP.SOVIET.CONSCRIPT_SQUAD, mkr_ally_sw)
	Util_CreateSquads(player3, sg_allies_truck, SBP.SOVIET.M5_HALFTRACK_SQUAD, mkr_introTruck)
	g_truckEntity = Squad_EntityAt(SGroup_GetSpawnedSquadAt(sg_allies_truck, 1), 0)
	Entity_SetInvulnerableToCritical(g_truckEntity, true)
	Cmd_SquadPath(sg_allies_truck, "introTruck", true, LOOP_NONE, false, 0)
	Rule_AddOneShot(Lublin_ShowTimeCard, 1)
	Rule_AddOneShot(Lublin_DestroyIntroTruck, 4.5)
	Rule_AddOneShot(Lublin_RetreatInitialAllies, 5.5)
	Modify_ReceivedAccuracy(sg_allies, 2)
	if not Rule_Exists(Lublin_DespawnAllies) then
		Rule_AddOneShot(Lublin_DespawnAllies, 30)
	else 
		Rule_ChangeInterval(Lublin_DespawnAllies, 30)
	end
	Modify_WeaponDamage(sg_allies, "hardpoint_01", 0.1)
end

function Lublin_DespawnAllies()
	SGroup_DestroyAllSquads(sg_allies)
end

function Lublin_RetreatInitialAllies()
	SGroup_EnableAttention(sg_allies, false)
	Cmd_Retreat(sg_allies)
end

-- Blow up halftrack in intro camera
function Lublin_DestroyIntroTruck()
	if not SGroup_IsEmpty(sg_allies_truck) then
		if g_truckEntity ~= nil and scartype(g_truckEntity) == ST_ENTITY then
			Entity_SetInvulnerableToCritical(g_truckEntity, false)
		end
		Cmd_CriticalHit(player2, sg_allies_truck, CRIT.VEHICLE_OUT_OF_CONTROL_FAST, 0)
		if not EGroup_IsEmpty(eg_introMine) then
			Util_SetPlayerOwner(eg_introMine, player2)
		end
	end
end

function Lublin_ShowTimeCard()
	if g_sitrepStarted ~= true then
		Game_SubTextFade(11048265, 11048266, 0.5, 4, 0.5)-- LOCDB [11048265] 'July 1944' -- LOCDB [11048266] 'Lublin, Poland'
	end
end

-- Send in some Pioneers to repair the Elefant if it takes damage
function Lublin_RepairElefant()
	if SGroup_IsEmpty(g_enc_southEast[5].sgroup) then 
		Rule_RemoveMe()
	else
		local squad = SGroup_GetRandomSpawnedSquad(g_enc_southEast[5].sgroup)
		if Squad_GetHealthPercentage(squad) < 0.9 then
			local spawnLoc = Util_FindHiddenSpawn(Marker_GetPosition(mkr_engineer_spawn),Squad_GetPosition(squad))
			Util_CreateSquads(player2, "sg_e_hulldownPioneers", SBP.GERMAN.PIONEER_SQUAD, spawnLoc)
			Cmd_Ability(SGroup_FromName("sg_e_hulldownPioneers"), ABILITY.SOVIET.SOVIET_REPAIR_ABILITY, g_enc_southEast[5].sgroup)
			Modify_SquadCaptureRate(SGroup_FromName("sg_e_hulldownPioneers"), 0)
			if g_hardDiff then
				Rule_AddInterval(Lublin_HardElefant, 1)
			end
			Rule_RemoveMe()
		end
	end
end

function Lublin_HardElefant()
	local player1Squads = Player_GetSquads(player1)
	if Prox_AreSquadsNearMarker(player1Squads, mkr_southEast7, ANY, 15) then
		local spawnLoc = Util_FindHiddenSpawn(Marker_GetPosition(mkr_hardElefant_spawn), Marker_GetPosition(mkr_hardElefant_spawnDest))
		local data = {
			name = "hardElefant",
			player = player2,
			sgroups = {sg_e_all},
			units = {
				{
					sbp = SBP.GERMAN.ELEFANT_TANK_DESTROYER_SQUAD,
					spawn = spawnLoc
				},
			}				
		}
		g_enc_hardElefant = Encounter:Create(data)
		local goalData = {
			name = "Attack",
			target = mkr_hardElefant_target,
			range = 60,
			leashRange = 45
		}
		g_enc_hardElefant:SetGoal(goalData)
		Rule_RemoveMe()
	end
end

function Lublin_TankResponse()
	if not SGroup_IsEmpty(sg_e_p4driveby1) then
		if (Player_CanSeePosition(player1, Marker_GetPosition(mkr_p4driveby1)) or SGroup_IsUnderAttack(sg_e_p4driveby1, ANY, 3)) and not g_driveby1Complete then
			if Misc_IsPosOnScreen(Marker_GetPosition(mkr_p4driveby1), 1) then
				FOW_RevealSGroupOnly(sg_e_p4driveby1, 10)
				g_enc_driveby1 = Encounter:ConvertSgroup(sg_e_p4driveby1)
				local goalData = {
					name = "Attack",
					attackMove = true,
					target = mkr_playerStart,
					safeMoveWeight = (World_GetRand(50,100) / 100),
					range = 60,
					leashRange = 60,
					tacticTargetPreference = AITacticTargetPreference_LowHealth
				}
				g_enc_driveby1:SetGoal(goalData)
				g_driveby1Complete = true
			end
		end
	end
	if not SGroup_IsEmpty(sg_e_p4driveby2) then
		if (Player_CanSeePosition(player1, Marker_GetPosition(mkr_p4driveby2)) or SGroup_IsUnderAttack(sg_e_p4driveby2, ANY, 3)) and not g_driveby2Complete then
			if Misc_IsPosOnScreen(Marker_GetPosition(mkr_p4driveby2), 1)  then
				FOW_RevealSGroupOnly(sg_e_p4driveby2, 10)
				g_enc_driveby2 = Encounter:ConvertSgroup(sg_e_p4driveby2)
				local goalData = {
					name = "Attack",
					attackMove = true,
					target = mkr_playerStart,
					safeMoveWeight = (World_GetRand(0,50) / 100),
					range = 45,
					leashRange = 45,
					tacticTargetPreference = AITacticTargetPreference_Near,
				}
				g_enc_driveby2:SetGoal(goalData)
				g_driveby2Complete = true
			end
		end
	end
	if g_driveby1Complete and g_driveby2Complete then
		Rule_RemoveMe()
	end
end

function Lublin_BarrageEvent()
	if Player_CanSeePosition(player1, Marker_GetPosition(mkr_bomb_trigger1)) or Player_CanSeePosition(player1, Marker_GetPosition(mkr_bomb_trigger2)) then
		if Misc_IsPosOnScreen(Marker_GetPosition(mkr_strat_west), 1) then
			local ability = BP_GetAbilityBlueprint("light_artillery_m10")
			Player_AddAbility(player2, ability)
			Player_SetAbilityAvailability(player2, ability, ITEM_UNLOCKED)
			FOW_RevealMarker(mkr_strat_west, 30)
			Sound_Play3D("speech/sp/mission/m10/11036733", EGroup_GetSpawnedEntityAt(eg_strat_barrage, 1))
			Cmd_Ability(player2, ability, Marker_GetPosition(mkr_lightArtyTarget), nil, true)
			Cmd_Ability(player2, ability, Marker_GetPosition(mkr_strat_west_arty1), nil, true)
			Cmd_Ability(player2, ability, Marker_GetPosition(mkr_strat_west_arty2), nil, true)
			EventCue_Create(CUE.MAP, 11045360, nil, mkr_strat_west) -- LOCDB [11045360] 'Incoming Light Artillery Barrage'
			if not SGroup_IsEmpty(g_enc_stratwest.sgroup) then
				local goalData = g_enc_stratwest:GetGoalData()
				goalData.target = mkr_strat_west_spawn
				g_enc_stratwest:SetGoal(goalData)
			end
			
			if not SGroup_IsEmpty(g_enc_west[12].sgroup) then
				local goalData = g_enc_west[12]:GetGoalData()
				goalData.target = mkr_strat_west_spawn
				g_enc_west[12]:SetGoal(goalData)
			end
			
			Rule_AddOneShot(Lublin_bomb_prone, 20)
			Rule_AddOneShot(Lublin_bomb_reverseGoal, 25)
			Rule_RemoveMe()
		end
	end
end

function Lublin_bomb_prone()
	if not SGroup_IsEmpty(g_enc_stratwest.sgroup) then
		SGroup_SetSuppression(g_enc_stratwest.sgroup, 500)
		SGroup_SuggestPosture(g_enc_stratwest.sgroup, 1, 30)
	end
	
	if not SGroup_IsEmpty(g_enc_west[12].sgroup) then
		SGroup_SetSuppression(g_enc_west[12].sgroup, 500)
		SGroup_SuggestPosture(g_enc_west[12].sgroup, 1, 20)
	end
end

function Lublin_bomb_reverseGoal()
	if not SGroup_IsEmpty(g_enc_stratwest.sgroup) then
		local goalData = g_enc_stratwest:GetGoalData()
		goalData.target = mkr_strat_west
		g_enc_stratwest:SetGoal(goalData)
	end
	
	if not SGroup_IsEmpty(g_enc_west[12].sgroup) then
		local goalData = g_enc_west[12]:GetGoalData()
		goalData.target = mkr_west12
		g_enc_west[12]:SetGoal(goalData)
	end
end

------ UNUSED ------
------ BASE HARASS: Spawn squads to bother the player's base ------
------ UNUSED ------
function Obj1_baseHarass()
	if SGroup_IsEmpty(sg_baseHarass) then
		t_baseHarass_temp = Clone(t_baseHarass)
		for k,v in pairs(t_baseHarass_temp) do 
			if Player_CanSeePosition(player1,Marker_GetPosition(v)) then
				table.remove(t_baseHarass_temp, k)
			end
		end
		
		g_harassSpawnPos = Table_GetRandomItem(t_baseHarass_temp) or mkr_baseHarass4
		
		local data = {
			name = "south",
			player = player2,
			sgroups = {sg_e_all, sg_baseHarass},
			units = {
				{
					sbp = SBP.GERMAN.GRENADIER_SQUAD,
					spawn = g_harassSpawnPos
				},
				{
					sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
					spawn = g_harassSpawnPos
				},
			}
		}
		if g_harassSpawnPos == mkr_baseHarass2 then
			data.units[2].sbp = SBP.GERMAN.OSTRUPPEN_SQUAD
		elseif g_harassSpawnPos == mkr_baseHarass3 then 
			data.units[1].sbp = SBP.GERMAN.GRENADIER_SQUAD
			data.units[2].sbp = SBP.GERMAN.SDKFZ_251_HALFTRACK_SQUAD
			data.units[2].upgrades = {UPG.GERMAN.SDKFZ_251_HALFTRACK_MOBILE_MEDIC_STATION_UPGRADE}
		elseif g_harassSpawnPos == mkr_baseHarass4 then
			table.insert(data.units, {})
			data.units[2].sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD
			data.units[2].upgrades = {UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM}
			data.units[3].sbp = SBP.GERMAN.SCOUTCAR_SDKFZ222
			data.units[3].spawn = g_harassSpawnPos
		end

		local goalData = {
			name = "Attack",
			target = mkr_playerStart,
			safeMoveWeight = (World_GetRand(50,100) / 100),
			useSkirmishAI = g_useSkirmishAI,
			range = mkr_playerStart,
			coordinatedMoveRadius = 15,
		}
		g_enc_baseHarass = Encounter:Create(data)
		g_enc_baseHarass:SetGoal(goalData)
		SGroup_AddSlotItemToDropOnDeath(sg_baseHarass, SLOT_ITEM.PANZERSHRECK, 0, true)
	end
end

function Obj1_eventCue_base()
	if EGroup_IsUnderAttack(eg_baseBuildings, ANY, 10) and not EGroup_IsOnScreen(player1, eg_baseBuildings, ANY) then
		eventCue_baseUnderAttack = UI_CreateEventCueClickable("Icons_events_event_cue_upgrade", "", LOC("Your base is under attack"), LOC(""), Obj1_eventCue_base_cam, 9, true)
		if g_HQWarningTimer == 0 then	
			Util_StartIntel(EVENTS.HQWarning)
			g_HQWarningTimer = 60
		end
		g_HQWarningTimer = g_HQWarningTimer - 10
	end
end

function Obj1_eventCue_base_cam()
	if SGroup_Exists("sg_baseHarass") and not SGroup_IsEmpty(sg_baseHarass) then
		local f = function (gid, idx, sid)
			if World_DistancePointToPoint(Squad_GetPosition(sid), Marker_GetPosition(mkr_playerStart)) < 40 then
				Camera_FocusOnPosition(Squad_GetPosition(SGroup_GetRandomSpawnedSquad(sg_baseHarass)), false)
				return true
			end
		end
		SGroup_ForEach(sg_baseHarass, f)
	end
end
		

------------- PANZERWERFERS: Tell them to use their rocket barrage --------------
function Obj1_rocketBarrage()
	if SGroup_IsEmpty(sg_werfers) then
		SGroup_Destroy(sg_werfers)
		SGroup_Destroy(sg_werfer_single)
		SGroup_Destroy(sg_werferTarget)
		Rule_RemoveMe()
	else
		local fire = function (gid, idx, sid)
			Player_GetAllSquadsNearMarker(player1, sg_werferTarget, Squad_GetPosition(sid), 75)
			if not SGroup_IsEmpty(sg_werferTarget) then
				SGroup_Clear(sg_werfer_single)
				SGroup_Add(sg_werfer_single, sid)
				if World_DistancePointToPoint(SGroup_GetPosition(sg_werfer_single), SGroup_GetPosition(sg_werferTarget)) > 20 then
					if Misc_IsPosOnScreen(SGroup_GetPosition(sg_werferTarget), 1) and not Event_IsAnyRunning() then
						if g_werferWarningIndex == 1 then
							Util_StartIntel(EVENTS.PanzerwerferWarning)
							g_werferWarningIndex = 2
						else
							Util_StartIntel(EVENTS.PanzerwerferWarning2)
							g_werferWarningIndex = 1
						end	
						EventCue_Create(CUE.ATTACKED, 11045361, nil, sg_werferTarget) -- LOCDB [11045361] 'Panzerwerfer targeting your squads'
						Cmd_Ability(player2, ABILITY.GERMAN.GERMAN_WARNING_SMOKE, SGroup_GetPosition(sg_werferTarget), nil, true)
						Cmd_Ability(sg_werfer_single, ABILITY.GERMAN.PANZERWERFER_ROCKET_BARRAGE, SGroup_GetPosition(sg_werferTarget), nil, true)
						return true
					end
				end
			end
		end
		SGroup_ForEach(sg_werfers, fire)
	end
end
		
function Obj1_rocketBarrage_cam()
	if SGroup_Exists("sg_werferTarget") and not SGroup_IsEmpty(sg_werferTarget) then
		Camera_FocusOnPosition(SGroup_GetPosition(sg_werferTarget), false)
	end
end
		
-----------------------------

function Mission_MissionComplete()

	Game_Letterbox(true, 1)
	Game_FadeToBlack(FADE_OUT, 5)

end

Lublin_startOutro = function ()
	Util_StartNIS(EVENTS.NIS02)
end

function Mission_MissionEnd()

	if Event_IsAnyRunning() == false then
		Game_EndSP(true)
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

------------------------- TEST FUNCTIONS --------------------------

--Skips an objective
function SkipObjective(num)
	if num == 0 then
		EGroup_InstantCaptureStrategicPoint(eg_strat_southWest, player1)
	elseif(num == 1) then
		Objective_Complete(OBJ_Capture)
		SGroup_DestroyAllSquads(sg_e_all)
		Rule_RemoveIfExist(Obj1_IsComplete_part1)
		Rule_RemoveIfExist(Obj1_IsComplete_part2)
		Rule_RemoveIfExist(Speech_ElefantSpotted)
		EGroup_InstantCaptureStrategicPoint(eg_strats, player1)
		Player_SetPopCapOverride(player1, 150)
	elseif(num == 2) then
		Objective_Complete(OBJ_Defend)
		Rule_RemoveIfExist(Obj2_IsComplete)
		Rule_RemoveIfExist(Obj2_WaveManager)
	elseif(num == 3) then
		EGroup_SetAvgHealth(eg_castleWall, 0.01)
	end
end


----- ACHIEVEMENTS -----

-- Complete the first objective without losing any units
function Achievement_ZeroRiskMarket()
	if SGroup_TotalMembersCount(sg_p_all, true) < g_startingSquadsCount then
		Rule_RemoveMe()
	elseif g_ping_southWest then
		Scar_CompleteIntelBulletinTask(player1, "camp10_lublin_market")
		Rule_RemoveMe()
	end
end

-- Destroy an Elefant or all Pak-43s before they destroy a vehicle
function Achievement_GlassCannons_Elefant()
	if Stats_UnitVehicleKills(player2, SBP.GERMAN.ELEFANT_TANK_DESTROYER_SQUAD) == 0 then
		Scar_CompleteIntelBulletinTask(player1, "camp10_lublin_vehicles")
	end
end

function Achievement_GlassCannons_Pak43s()
	if Stats_UnitVehicleKills(player2, SBP.GERMAN.PAK43_88MM_AT_GUN_SQUAD) == 0 then
		Scar_CompleteIntelBulletinTask(player1, "camp10_lublin_vehicles")
	end
end

-- Breach the gate without losing an ISU-152 on Hard difficulty
function Achievement_GateCrusher()
	if g_hardDiff and SGroup_Count(sg_152) == 2 then
		Scar_CompleteIntelBulletinTask(player1, "camp10_lublin_gate")
	end
end
