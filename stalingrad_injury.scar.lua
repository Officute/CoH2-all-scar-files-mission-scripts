-------------------------------------------------------------------------
-------------------------------------------------------------------------

-- Company of Heroes 2
-- Mission 6: Stalingrad_Injury
-- Designer: Sacha Narine

-------------------------------------------------------------------------
-------------------------------------------------------------------------

import("ScarUtil.scar")
import("Systems/AiManager/ai.scar")
import("Prototype/DeploymentPoints.scar")
import("Beginner.scar")
import("Order227.scar")
import("Global_Values/CampaignGlobalConstants.scar")

g_useSkirmishAI = true

------------------------------------------------------------------------
-- [[ SETUP ]]
-------------------------------------------------------------------------

function OnGameSetup()
	
	-- Required Players
	player1 = Setup_Player(1, 11038758, "soviet", 1)		-- player1 is always the human player
	player2 = Setup_Player(2, 11038759, "german", 2)		-- player2 is always the AI opponent
	player3 = Setup_Player(3, 11038758, "soviet", 1)		-- player3 is always the AI ally
	
	player227 = Setup_Player(4, 11038758, "soviet", 3)
	
end



function OnGameRestore()
	
	-- function takes care of restoring all global mission parameters after a save/load
	player1 = World_GetPlayerAt(1)
	player2 = World_GetPlayerAt(2)
	player3 = World_GetPlayerAt(3)
	player227 = World_GetPlayerAt(4)
	UI_SetCPMeterVisibility(true)
	Rule_AddOneShot(M06_OnGameRestore, 1)
	Game_DefaultGameRestore()
end

function M06_OnGameRestore()
	if g_nearIke_startedDigging then
		g_diggerIndex = 1
		Rule_AddInterval(_startEngineerDigging, 0.4)	
	end
	EGroup_Hide(eg_a_barracks, true)
	UI_SetCPMeterVisibility(false)
end
		
function NIS_Init()
	NISlet_postInjury = "SP/CoH2_Campaign/M06-Stalingrad_Injury/nis/m06_postInjuryNislet"
	nis_load(NISlet_postInjury)
	NIS01 = "SP/CoH2_Campaign/M06-Stalingrad_Injury/nis/m06_intro_nislet" 
	nis_load(NIS01)
	NIS02 = "SP/CoH2_Campaign/M06-Stalingrad_Injury/nis/m06_cin00" 
	nis_load(NIS02)
	
	nis_setintransitiontime(0)
	nis_setouttransitiontime(0.5)
end


function NIS01_Complete()
	sg_nislet_yuri = SGroup_CreateIfNotFound("sg_nislet_yuri")
	sg_nislet_sergei = SGroup_CreateIfNotFound("sg_nislet_sergei")
	Util_CreateSquads(player3, sg_nislet_yuri, SBP.SOVIET.BASE_CONSCRIPT_SQUAD, mkr_yuri_spawn, nil, 1, 1)
	Util_CreateSquads(player3, sg_nislet_sergei, SBP.SOVIET.COMBAT_ENGINEER_SQUAD, mkr_yuri_dest3, nil, 1, 1)
	Util_StartNIS(NISlet_postInjury, nil, nil, nil, nislet_onComplete)
	Rule_AddOneShot(_yuri_retreat, 3.5)
	Rule_AddOneShot(_yuri_warp, 10)
	Util_ApplyModifier(sg_nislet_yuri, "posture_speed_modifier", 1.3, MUT_Multiplication)
	Modify_WeaponEnabled(sg_nislet_yuri, "hardpoint_01", false)
	SGroup_SetInvulnerable(sg_nislet_yuri, true)
	SGroup_SetInvulnerable(sg_nislet_sergei, true)
	EGroup_DestroyAllEntities(eg_wire)
end

_yuri_retreat = function ()
	SGroup_EnableAttention(sg_nislet_yuri, false)
	Cmd_Move(sg_nislet_yuri, mkr_yuri_dest1)

end

_yuri_proxCheck = function (data)
	SGroup_WarpToMarker(sg_nislet_yuri, mkr_yuri_dest2)
	Cmd_Retreat(sg_nislet_yuri, mkr_yuri_dest3)
	Rule_AddInterval(_yuri_retreatRepeat, 1)
end

_yuri_warp = function (data)
	SGroup_WarpToMarker(sg_nislet_yuri, mkr_yuri_warp)
	Cmd_Retreat(sg_nislet_yuri, mkr_yuri_dest3)
	Rule_AddInterval(_yuri_retreatRepeat, 1)
end

_yuri_retreatRepeat = function()
	if not SGroup_IsRetreating(sg_nislet_yuri, ALL) then
		Cmd_Retreat(sg_nislet_yuri, mkr_yuri_dest3)
	end
end

function nislet_onComplete()
	Util_Autosave(nil, nil, true)
	Game_SetMode(UI_Normal)
	FOW_UnRevealAll()
	EGroup_ReSpawn(eg_ikeBody)
	SGroup_SetInvulnerable(sg_p_all, false)
	
	-- Enemy spawns for Objective 2
	Rule_AddOneShot(A1M06_SpawnPatrols, 15)
	A1M06_SpawnBaseDefense()
	
	Rule_AddOneShot(_injury_delayStartSecondObjective, 2)
	if Event_Exists(eventID_yuri) then
		Event_Remove(eventID_yuri)
	end
	Rule_RemoveIfExist(_yuri_warp)
	Rule_RemoveIfExist(_yuri_retreat)
	Rule_RemoveIfExist(_yuri_retreatRepeat)
	if not SGroup_IsEmpty(sg_nislet_yuri) then
		SGroup_SetInvulnerable(sg_nislet_yuri, false)
		SGroup_SetPlayerOwner(sg_nislet_yuri, player1)
		Modifier_RemoveAllFromSGroup(sg_nislet_yuri)
		if not Prox_AreSquadsNearMarker(sg_nislet_yuri, mkr_yuri_dest3, ANY, 30) then
			SGroup_WarpToMarker(sg_nislet_yuri, mkr_yuri_dest3)
		end
	end
	if not SGroup_IsEmpty(sg_nislet_sergei) then
		SGroup_SetInvulnerable(sg_nislet_sergei, false)
		SGroup_SetPlayerOwner(sg_nislet_sergei, player1)
	end
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
	
	--[[ PLAY INTRO NIS]]
	Game_FadeToBlack(FADE_OUT, 0)
	Game_SetMode(UI_Cinematic)
	
	--[[ REGISTER OBJECTIVES ]]
	Initialize_Objective1()
	Initialize_Objective2()
	Initialize_Objective3()
	Initialize_Objective4()
	Initialize_Objective5()
	Initialize_Objective6()
	
	--[[ GAME START CHECK ]]
	_postIntro_cameraPan = function ()
		Game_FadeToBlack(FADE_IN, 1)
		Game_SetMode(UI_Cinematic)
		Cmd_Retreat(sg_p_intro)
		SGroup_EnableAttention(sg_p_intro, false)
		FOW_EnableTint(false)
		Util_StartNIS(EVENTS.Intro)
		Rule_AddOneShot(_postIntro_speech, 1.5)
	end
	_postIntro_speech = function ()
		Sound_PlayOnSquad("speech/sp/mission/m06/11049529", sg_p_intro) -- LOCDB [11043344] 'Damn those snipers! Get to the scout car.' - 'Russian_Soldier_01'
		Game_SubTextFade(11048262, 11046889, 0.5, 4, 0.5) -- LOCDB [11048262] 'October, 1942' 
	end
	_postIntro_fade = function ()
		Game_FadeToBlack(FADE_OUT, 1)
	end
	_postIntro_startMission = function ()
		Camera_ResetToDefault()
		SGroup_EnableAttention(sg_p_intro, true)
		Util_StartIntel(EVENTS.SitRep)
	end
	
	_postIntro_facing = function ()
		Cmd_Move(sg_p_shock, mkr_startSquad1_dest)
	end
	
	A1M06_SpawnSnipers()
	A1M06_SpawnSecondarySnipers()
--~ 	Util_PlayMovie("m06_cin00", 0, 0, _postIntro_cameraPan)
	SitRep_PlayMovie("m06_cin00")
	Rule_AddOneShot(_postIntro_cameraPan, 1)

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
	Player_SetEntityProductionAvailability(player1, EBP.SOVIET.TANK_DEPOT, ITEM_REMOVED)
	
	Player_SetSquadProductionAvailability(player1, SBP.SOVIET.M5_HALFTRACK_SQUAD, ITEM_REMOVED)
	Player_SetSquadProductionAvailability(player1, SBP.SOVIET.T_70M, ITEM_REMOVED)
	Player_SetSquadProductionAvailability(player1, SBP.SOVIET.SU_76M, ITEM_REMOVED)
	Player_SetSquadProductionAvailability(player1, SBP.SOVIET.T_34_76_SQUAD, ITEM_REMOVED)
	Player_SetSquadProductionAvailability(player1, SBP.SOVIET.IS_2, ITEM_REMOVED)
	
	Modify_PlayerResourceCap(player1, RT_Manpower, 1001, MUT_Addition)
	Modify_PlayerResourceCap(player1, RT_Munition, 601, MUT_Addition)
	Modify_PlayerResourceCap(player1, RT_Fuel, 401, MUT_Addition)
	
	Player_SetAbilityAvailability(player3, ABILITY.SOVIET.CONSCRIPT_MOLOTOV_COCKTAIL, ITEM_REMOVED)
	Player_SetAbilityAvailability(player1, BP_GetAbilityBlueprint("cmd_shock_troops"), ITEM_REMOVED)
	if not g_hardDiff then
		Player_SetAbilityAvailability(player2, ABILITY.SOVIET.SNIPER_DELAYED_COVER_AUTO_CAMOUFLAGE, ITEM_REMOVED)
		Player_SetAbilityAvailability(player2, ABILITY.SOVIET.SNIPER_IN_COVER_AUTO_CAMOUFLAGE, ITEM_REMOVED)
	end
	
end



function Mission_CpuInit()

	-- Utilize for controlling AI functionality
	-- eg: Player_SetResource(player2, RT_Manpower, 1000)
	-- eg: AI_EnableComponent(player2, false, COMPONENT_Attacking)
	Player_CompleteUpgrade(player2, BP_GetUpgradeBlueprint("panzerfaust_slow"))

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
		startingRes_Command					= Util_DifVar( {2, 2, 2, 2} ),				-- Starting Command Points
		startingRes_Manpower				= Util_DifVar( {480, 360, 240, 240} ),		-- Starting Manpower
		startingRes_Munition				= Util_DifVar( {90, 60, 30, 15} ),		-- Starting Munition
		startingRes_Fuel					= Util_DifVar( {50, 25, 0, 0} ),		-- Starting Fuel
		resourceRate_Manpower				= Util_DifVar( {1.2, 1, 1, 1} ),		-- Resource rate modifier for manpower
		resourceRate_Munition				= Util_DifVar( {1.5, 1, 1, 1} ),
		halftrackTimerThreshold				= Util_DifVar( {2, 3, 4, 4} ),
		hqHealthThreshold					= Util_DifVar( {0.75, 0.5, 0.33, 0.33} ),
		squadsNearbyThreshold				= Util_DifVar( {8, 6, 4, 4} ),
		-- 
		defaultAttackGoalData 					= Util_DifVar( {t_defaultGoalData_attackEasy, {}, t_defaultGoalData_attackHard, {}}),
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

function Mission_MissionPreset()

	-- Kicks off after SCAR Inits, but before MissionStart is called.
	-- Use for spawning units on the map at the start
	
 	sg_p_com = SGroup_CreateIfNotFound("sg_p_com")
	sg_p_all = SGroup_CreateIfNotFound("sg_p_all")
	sg_e_all = SGroup_CreateIfNotFound("sg_e_all")
	sg_p_intro = SGroup_CreateIfNotFound("sg_p_intro")
	sg_p_car = SGroup_CreateIfNotFound("sg_p_car")
	sg_p_shock = SGroup_CreateIfNotFound("sg_p_shock")

	sg_mergehints = SGroup_CreateIfNotFound("sg_mergehints")
	sg_reinforcehints = SGroup_CreateIfNotFound("sg_reinforcehints")
	
	sector_base = World_GetTerritorySectorID(World_Pos(-131, 10, -98))
	sector_defense = World_GetTerritorySectorID(World_Pos(141, 10, 0))
	
	Util_CreateSquads(player1, {sg_p_all, sg_p_car}, SBP.SOVIET.M3A1_SCOUT_CAR_SQUAD, mkr_startSquad1)
	Util_CreateSquads(player1, {sg_p_all, sg_p_shock}, SBP.SOVIET.SHOCK_TROOPS, mkr_startSquad2)
	Util_CreateSquads(player1, sg_p_all, SBP.SOVIET.SNIPER_TEAM, mkr_startSquad3)
	Util_CreateSquads(player1, sg_p_all, SBP.SOVIET.COMBAT_ENGINEER_SQUAD, mkr_startSquad4)
	Util_CreateSquads(player1, {sg_p_all, sg_p_intro}, SBP.SOVIET.CONSCRIPT_SQUAD, mkr_intro_spawn, nil, 1, 2)

	EGroup_DeSpawn(eg_ikeBody)
	EGroup_SetInvulnerable(eg_p_hq2, 0.1)
	EGroup_SetSelectable(eg_p_hq2, false)
	EGroup_Hide(eg_a_barracks, true)
	Modify_SightRadius(eg_a_barracks, 0)
	Player_SetPopCapOverride(player1, 60)
	Player_SetResource(player1, RT_Manpower, t_difficulty.startingRes_Manpower)
	Player_SetResource(player1, RT_Fuel, t_difficulty.startingRes_Fuel)
	Player_SetResource(player1, RT_Munition, t_difficulty.startingRes_Munition)
	
	modID_manpowerRate = Modify_PlayerResourceRate(player1, RT_Manpower, t_difficulty.resourceRate_Manpower)
	modID_munitionsRate = Modify_PlayerResourceRate(player1, RT_Munition, t_difficulty.resourceRate_Munition)
	
	Camera_SetZoomDist(23)
	Camera_SetOrbit(-0.1976)
	Camera_SetDeclination(0.6)

	Camera_FocusOnPosition(Marker_GetPosition(mkr_intro_cameraPan), false)
	
	-- Default Player Upgrades
	Player_AddAbility(player1, ABILITY.SOVIET.BASE_CONSCRIPT_DISPATCH)
	Player_AddAbility(player1, BP_GetAbilityBlueprint("frontoviki_conscript_dispatch"))
	Player_AddAbility(player1, ABILITY.SOVIET.PENAL_TROOP_DISPATCH_SP)
	Player_AddAbility(player2, ABILITY.GERMAN.GERMAN_WARNING_SMOKE)
	Player_AddAbility(player2, ABILITY.GERMAN.STUKA_BOMBING_STRIKE)
	Player_AddAbility(player2, ABILITY.GLOBAL.OFF_MAP_ARTY_SINGLE_SHOT_INSTANT)
	Player_AddAbility(player2, ABILITY.SOVIET.MORTAR_EXPLOSION_FX)
	Player_AddAbility(player1, ABILITY.GLOBAL.TRANSFER_ORDERS)
	Player_AddUnspentCommandPoints(player1, 17)
	
	-- Commander Abilities
	Player_CompleteUpgrade(player1, UPG.SOVIET.TANK_DETECTION)
	Player_CompleteUpgrade(player1, UPG.SOVIET.MARK_VEHICLE)
	Player_CompleteUpgrade(player1, BP_GetUpgradeBlueprint("upgrade\\commander\\soviet\\passive\\shock_troops"))
	
	Player_CompleteUpgrade(player1, BP_GetUpgradeBlueprint("disable_stuka_bomb_neutralize"))
	Player_CompleteUpgrade(player2, BP_GetUpgradeBlueprint("disable_stuka_bomb_neutralize"))
	
	Player_AddAbility(player2, ABILITY.GLOBAL.OFF_MAP_ARTY_SINGLE_SHOT_INSTANT)
	Player_SetAbilityAvailability(player1, ABILITY.SOVIET.IL_2_ATTACK_STRAFE, ITEM_REMOVED)
	
	Cmd_CriticalHit(player1, eg_allTeamWeapons, CRIT.VEHICLE_ABANDON, 0)
	
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
	
	--227
	Order227_Init()
	ConscriptProgression_AudioInit()

	local setInv = function(gid, idx, entity)
		Entity_SetInvulnerableMinCap(entity, 0.6, 0)
	end
	EGroup_ForEach(eg_ikeBuilding, setInv)
	EGroup_SetSelectable(eg_ikeBuilding, false)
	EGroup_EnableMinimapIndicator(eg_mm_unlock1, false)
	
end

-------------------------------------------------------------------------
-- MISSION START 
-------------------------------------------------------------------------

function Mission_MissionStart()

	if Event_IsAnyRunning() == false then
		
		-- hints about merging into damaged squads and reinforcing from halftracks and HQs
		Stalingrad_UpdateHintGroups()
		BeginnerHint_AddOpportunity(sg_mergehints, HINT_MERGE, true)
		BeginnerHint_AddOpportunity(sg_reinforcehints, HINT_REINFORCE, true)
		Rule_AddInterval(Stalingrad_UpdateHintGroups, 30)
		
		-- delay first objective
		Rule_AddOneShot(Mission_DelayObjTitle, 1)
		
		Rule_RemoveMe()
	end
end

function Stalingrad_UpdateHintGroups()

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

	Objective_Start(OBJ_FindSnipers, true)
	A1M06_SpawnDefenders()
	A1M06_alliesForShow()
	
end

function Initialize_Objective1()

	OBJ_FindSnipers = {
		
		SetupUI = function() 
			hint_sniper1 = Objective_AddUIElements(OBJ_FindSnipers, Marker_GetPosition(mkr_sniper1), true, 11045297, true)-- LOCDB [11045297] 'Two snipers nearby'
			hint_sniper2 = Objective_AddUIElements(OBJ_FindSnipers, Marker_GetPosition(mkr_sniper2), true, 11045297, true)-- LOCDB [11045297] 'Two snipers nearby'
			hint_sniper3 = Objective_AddUIElements(OBJ_FindSnipers, Marker_GetPosition(mkr_sniper3), true, 11045297, true)-- LOCDB [11045297] 'Two snipers nearby'
		end,
		
		OnStart = function()
			Sound_PlayMusic("streamed/music/missions/m06/m06_cue_start_hunt_snipers", 0, 0)
			Rule_AddDelayedInterval(Obj1_IsComplete, 3, 3)
			Rule_AddDelayedInterval(Obj1_PingManager, 5, 2)
			Objective_SetCounter(OBJ_FindSnipers, 0, 6)
			World_SetDesignerSupply(Marker_GetPosition(mkr_playerStart), true)
			A1M06_AddAmbientEvents()
			Achievement_startM3A1KillCount()
		end,
		
		OnComplete = function()
			Rule_RemoveIfExist(Ambient_FlavorSpeech1)
			Rule_RemoveIfExist(Ambient_FlavorSpeech2)
			-- Retreat and remove enemy squads that are in combat, before the NIS
			sg_e_temp = SGroup_CreateIfNotFound("sg_e_temp")
			local retreat = function (gid, idx, sid)
				if Squad_IsAttacking(sid, 30) or Squad_IsUnderAttack(sid, 30) then
					SGroup_Add(sg_e_temp, sid)
				end
			end
			SGroup_ForEach(sg_e_all, retreat)
			if not SGroup_IsEmpty(sg_e_temp) then
				Cmd_Stop(sg_e_temp)
				Cmd_Retreat(sg_e_temp, Marker_GetPosition(mkr_attackerSpawn1), nil, nil, true)
			end
			
			if not g_isSkipping then
				Rule_AddOneShot(Obj1_FadeOutOnComplete, 5)
				Rule_AddOneShot(Obj1_StartInjuryNIS, 7)
				Sound_StopMusic(CAMPAIGN_MUSIC_FADEOUT, 0)
			end
		end,
		
		OnFail = function()
	
		end,
		
		IsComplete = function()
			return false
		end,
		
		Intel_Start = nil,				
		Intel_Complete = EVENTS.IkeUpdate_03,			-- Event will play when obj completes but before UI is cleared
		Intel_Fail = nil,				-- Event will play when obj fails but before UI is cleared
		Title = 11045298,	-- LOCDB [11045298] 'Clear enemy snipers from marked sectors'
		Description = 1459051,			-- Objective Description
		TitleEnd = 11045299, -- LOCDB [11045299] 'Snipers eliminated'
		TitleFail = 1459052,			-- Failed Title
		Type = OT_Primary,				-- Objective Type (OT_Primary, OT_Secondary)
	}
	
	Objective_Register(OBJ_FindSnipers)

end

function Obj1_IsComplete()
	if SGroup_IsEmpty(sg_e_snipers) and SGroup_IsEmpty(sg_e_secSnipers) then
		if Event_IsAnyRunning() == false and Rule_Exists(__dropStukaBomb) == false then
			Objective_Complete(OBJ_FindSnipers)
			Rule_RemoveIfExist(Ambient_StukaInTownSquare)
			Rule_RemoveIfExist(Obj1_PingManager)
			Rule_RemoveMe()
		end
	elseif EGroup_IsEmpty(eg_p_hq) then
		Rule_RemoveMe()
		Util_MissionTitle(11048793, 1, 5, 1)
		Rule_AddOneShot(_delayedMissionFail, 8)
	else
		Objective_SetCounter(OBJ_FindSnipers, 6 - (SGroup_Count(sg_e_snipers) + SGroup_Count(sg_e_secSnipers)), 6)
		if Objective_GetCounter(OBJ_FindSnipers) >= 1 and not g_startResourceObjective then
			if not EGroup_IsEmpty(eg_fuelCan) and not EGroup_IsEmpty(eg_ammoBox) then
				-- Start OBJ_Resources: Collect fuel and ammo
				Rule_AddInterval(Obj1_delayStartSecondaryObjective, 5)
				g_startResourceObjective = true
			end
		end
	end
end

function _delayedMissionFail()
	Game_EndSP(false)
end

function Obj1_PingManager()
	---- Remove mini-map pings and tell the player when sectors are cleared of snipers
	if (SGroup_IsEmpty(sg_e_sniper1) and SGroup_IsEmpty(sg_e_secSniper1))  and not g_sector1Cleared then
		Objective_RemoveUIElements(OBJ_FindSnipers, hint_sniper1_2)
		Obj1_SniperUpdateSpeech()
		g_sector1Cleared = true
	end
	if (SGroup_IsEmpty(sg_e_sniper2) and SGroup_IsEmpty(sg_e_secSniper2)) and not g_sector2Cleared then
		Objective_RemoveUIElements(OBJ_FindSnipers, hint_sniper2_2)
		Obj1_SniperUpdateSpeech()
		g_sector2Cleared = true
	end
	if (SGroup_IsEmpty(sg_e_sniper3) and SGroup_IsEmpty(sg_e_secSniper3)) and not g_sector3Cleared then
		Objective_RemoveUIElements(OBJ_FindSnipers, hint_sniper3_2)
		Obj1_SniperUpdateSpeech()
		g_sector3Cleared = true
	end
	--- 
	if (SGroup_IsEmpty(sg_e_sniper1) or SGroup_IsEmpty(sg_e_secSniper1))  and hint_sniper1_2 == nil then
		Objective_RemoveUIElements(OBJ_FindSnipers, hint_sniper1)
		hint_sniper1_2 = Objective_AddUIElements(OBJ_FindSnipers, Marker_GetPosition(mkr_sniper1), true, 11045300, true)-- LOCDB [11045300] 'One sniper nearby'
	end
	if (SGroup_IsEmpty(sg_e_sniper2) or SGroup_IsEmpty(sg_e_secSniper2)) and hint_sniper2_2 == nil then
		Objective_RemoveUIElements(OBJ_FindSnipers, hint_sniper2)
		hint_sniper2_2 = Objective_AddUIElements(OBJ_FindSnipers, Marker_GetPosition(mkr_sniper2), true, 11045300, true)-- LOCDB [11045300] 'One sniper nearby'
	end
	if (SGroup_IsEmpty(sg_e_sniper3) or SGroup_IsEmpty(sg_e_secSniper3)) and hint_sniper3_2 == nil then
		Objective_RemoveUIElements(OBJ_FindSnipers, hint_sniper3)
		hint_sniper3_2 = Objective_AddUIElements(OBJ_FindSnipers, Marker_GetPosition(mkr_sniper3), true, 11045300, true)-- LOCDB [11045300] 'One sniper nearby'
	end
end

function Obj1_FadeOutOnComplete()
	Game_Letterbox(true, 2)
	Game_FadeToBlack(FADE_OUT, 2)
end

function Obj1_StartInjuryNIS()
	if Timer_Exists(g_227_timer) and Rule_Exists(Order227_Update) then
		Rule_Remove(Order227_Update)
		SGroup_DestroyAllSquads(sg_227_commissar)
		g_227_currentPistolShots = 0
		SGroup_Clear(sg_227_usedTargets)
		Player_SetResource(World_GetPlayerAt(1), RT_SovietOrder227, 0)
	end
	Util_StartNIS(EVENTS.NIS01)
end

function Obj1_delayStartSecondaryObjective()
	local player1Squads = Player_GetSquads(player1)
	if not SGroup_IsDoingAttack(player1Squads, ANY, 5) and not SGroup_IsUnderAttack(player1Squads, ANY, 5) then
		if not EGroup_IsEmpty(eg_fuelCan) and not EGroup_IsEmpty(eg_ammoBox) and not Event_IsAnyRunning() then
			Objective_Start(OBJ_Resources)
		end
		Rule_RemoveMe()
	end
end

function Obj1_SniperUpdateSpeech()
	if not g_sniperUpdate1 then
		Util_StartIntel(EVENTS.SniperUpdate1)
		Util_StartIntel(EVENTS.IkeUpdate_01)
		g_sniperUpdate1 = true
	elseif not g_sniperUpdate2 then
		Util_StartIntel(EVENTS.SniperUpdate2)
		Util_StartIntel(EVENTS.IkeUpdate_02)
		g_sniperUpdate2 = true
	end
end

------ Objective 2: Bring an engineer to Isakovich -----
function Initialize_Objective2()

	OBJ_MoveEngineer = {
		
		SetupUI = function() 
			hpid_escort = Objective_AddUIElements(OBJ_MoveEngineer, Marker_GetPosition(mkr_isakovich_nis), true, 11045301, true) -- LOCDB [11045301] 'Escort an engineer to Isakovich'
		end,
		
		OnStart = function()
			Sound_PlayMusic("streamed/music/missions/m06/m06_cue_save_isakovich", 0, 0)
			Rule_AddDelayedInterval(Obj2_IsComplete, 5, 3)
			g_escortTimer = 375
			if g_hardDiff then
				g_escortTimer = 250
			end
			g_timer_moveEngineer = 777
			g_moveEngineer_timerPaused = false
			Timer_Start(g_timer_moveEngineer, 360)
			Rule_AddInterval(Obj2_startTimer, 1)
			
			flashID_moveObj = UI_FlashObjectiveIcon(OBJ_MoveEngineer.ID, true)
			Rule_AddOneShot(_removeObj2Flash, 15)

			SGroup_DestroyAllSquads(sg_a_all)
			if not Objective_IsComplete(OBJ_Resources) then
				Objective_Fail(OBJ_Resources, false, true)
				Rule_RemoveIfExist(Obj5_IsComplete)
			end
			Rule_AddInterval(Obj2_delayStartSecondaryObjective, 3) 
			Obj2_GrantEngineer()
			eg_woundedIke = EGroup_CreateIfNotFound("eg_woundedIke")
			Util_CreateEntities(player1, eg_woundedIke, BP_GetEntityBlueprint("isakovich_m06"), mkr_isakovich_nis, 1)
			EGroup_SetWorldOwned(eg_woundedIke) 
			EGroup_SetSelectable(eg_woundedIke, false)
			EGroup_EnableUIDecorator(eg_woundedIke, false)
			FOW_RevealEGroupOnly(eg_woundedIke, -1)
			EGroup_EnableMinimapIndicator(eg_mm_unlock1, true)
			World_IncreaseInteractionStage()			
		end,
		
		OnComplete = function()
			sg_p_startObj3 = SGroup_CreateIfNotFound("sg_p_startObj3")
			Rule_AddDelayedInterval(Obj2_delayStartThirdObjective, 1, 1)
			Sound_StopMusic(CAMPAIGN_MUSIC_FADEOUT,0)
			Achievement_DestroyHalftracks()
		end,
		
		OnFail = function()
			Game_EndSP(false)
		end,
		
		IsComplete = function()
			return false
		end,
		
		Intel_Start = EVENTS.Injury_Short,				-- Event will play when obj starts but before any UI appears
		Intel_Complete = nil,			-- Event will play when obj completes but before UI is cleared
		Intel_Fail = EVENTS.ReachFail,				-- Event will play when obj fails but before UI is cleared
		Title = 11045301, -- LOCDB [11045301] 'Escort an engineer to Isakovich'
		Description = 1459051,			-- Objective Description
		TitleEnd = 11045302, -- LOCDB [11045302] 'Extraction in progress'
		TitleFail = 11045303, -- LOCDB [11045303] 'Isakovich was killed'
		Type = OT_Primary,				-- Objective Type (OT_Primary, OT_Secondary)
	}
	
	Objective_Register(OBJ_MoveEngineer)

end

function Obj2_startTimer()
	-- Start an objective timer to reach Isakovich after enough halftracks are destroyed or enough time has passed
	-- Pause the "pre-timer" timer if the player has a small army
	if SGroup_Exists("sg_e_halftracks") then
		if (Timer_GetElapsed(g_timer_moveEngineer) >= 300) or (SGroup_Count(sg_e_halftracks) < t_difficulty.halftrackTimerThreshold) then
			Util_StartIntel(EVENTS.TimerStart_Obj2)
			Objective_StartTimer(OBJ_MoveEngineer, COUNT_DOWN, g_escortTimer, 60)
			Obj_ShowProgress(11035343, 1) -- LOCDB [11035343] 'Time left...'
			_flashProgressBar(10)
			flashID_moveObj = UI_FlashObjectiveIcon(OBJ_MoveEngineer.ID, true)
			Rule_RemoveIfExist(_removeObj2Flash)
			Rule_AddOneShot(_removeObj2Flash, 15)
			Rule_AddInterval(Obj2_UpdateProgress, 1)
			Rule_RemoveMe()
		elseif Player_GetPopulationPercentage(player1, CT_Personnel) < 0.5 and Timer_IsPaused(g_timer_moveEngineer) == false then
			Timer_Pause(g_timer_moveEngineer)
		elseif Player_GetPopulationPercentage(player1, CT_Personnel) >= 0.5 and Timer_IsPaused(g_timer_moveEngineer) then
			Timer_Resume(g_timer_moveEngineer)
		end
	end
end
	
function Obj2_IsComplete()
	if Objective_IsTimerSet(OBJ_MoveEngineer) and (Objective_GetTimerSeconds(OBJ_MoveEngineer) <= 0) then
		Objective_Fail(OBJ_MoveEngineer)
		Obj_HideProgress()
		Rule_RemoveMe()
	elseif EGroup_IsEmpty(eg_p_hq) then
		Rule_RemoveMe()
		Obj_HideProgress()
		Util_MissionTitle(11048793, 1, 5, 1)
		Rule_AddOneShot(_delayedMissionFail, 8)
	else
		sg_nearIke = SGroup_CreateIfNotFound("sg_nearIke")
		Player_GetAllSquadsNearMarker(player1, sg_nearIke, mkr_isakovich, 25)
		
		local checkEngineer = function ()
			if SGroup_ContainsBlueprints(sg_nearIke, SBP.SOVIET.COMBAT_ENGINEER_SQUAD, ANY) then
				if hint_wire ~= nil then 
					HintPoint_Remove(hint_wire)
				end
				EGroup_DestroyAllEntities(eg_wire)
				SGroup_Filter(sg_nearIke, SBP.SOVIET.COMBAT_ENGINEER_SQUAD, FILTER_KEEP)
				SGroup_Single(sg_nearIke, SGroup_GetRandomSpawnedSquad(sg_nearIke))
				if SGroup_IsInHoldSquad(sg_nearIke, ANY) then
					Cmd_UngarrisonSquad(sg_nearIke)
					return
				end
				if Squad_Count(SGroup_GetRandomSpawnedSquad(sg_nearIke)) > 1 then
					newSquad = Squad_Split(SGroup_GetRandomSpawnedSquad(sg_nearIke), 1)
					SGroup_Clear(sg_nearIke)
					SGroup_Add(sg_nearIke, newSquad)
				end
				Obj_HideProgress()
				Rule_RemoveIfExist(Obj2_UpdateProgress)
				if not SGroup_IsEmpty(sg_e_baseDefense) then
					hint_baseDefense = HintPoint_Add(sg_e_baseDefense, true, 11047031)
					ThreatArrow_CreateGroup(sg_e_baseDefense)
					Objective_StopTimer(OBJ_MoveEngineer)
					Rule_RemoveIfExist(Obj2_startTimer)
					Objective_UpdateText(OBJ_MoveEngineer, 11046433, 11046433) -- LOCDB [11046433] 'Eliminate enemy squads near Isakovich'
					Objective_RemoveUIElements(OBJ_MoveEngineer, hpid_escort)
					hpid_escort = Objective_AddUIElements(OBJ_MoveEngineer, Marker_GetPosition(mkr_isakovich_nis), true, 11046433, true)
					Actor_PlaySpeech(ACTOR.Russian_Engineer, 11047032)
					A1M06_UpdateBaseDefense()
					Rule_AddInterval(Obj2_delayCompleteObjective, 1)
				else
					Objective_Complete(OBJ_MoveEngineer)
				end
				if SGroup_IsInHoldSquad(sg_nearIke, ANY) then
					Cmd_UngarrisonSquad(sg_nearIke, Util_GetPosition(mkr_woundedIke2))
				else
					Cmd_Move(sg_nearIke, mkr_woundedIke2)
				end
				SGroup_SetWorldOwned(sg_nearIke) 
				SGroup_SetSelectable(sg_nearIke, false)
				SGroup_EnableUIDecorator(sg_nearIke, false)
				SGroup_SetMoodMode(sg_nearIke, MM_ForceTense)
				g_foundEngineer = true
				Rule_RemoveIfExist(Obj2_startTimer)
				Rule_RemoveMe()
			end	
		end
		
		-- Check if the player has brought an engineer squad to the target location
		if not SGroup_IsEmpty(sg_nearIke) then
			checkEngineer()
		end
		
		if not g_foundEngineer then
			Player_GetAllSquadsNearMarker(player1, sg_nearIke, mkr_woundedIke2, 25)
			if not SGroup_IsEmpty(sg_nearIke) then
				checkEngineer()
			end
		end
	end
end

function Obj2_delayCompleteObjective()
	if SGroup_IsEmpty(sg_e_baseDefense) or SGroup_IsRetreating(sg_e_baseDefense, ALL) then
		Objective_Complete(OBJ_MoveEngineer)
		HintPoint_Remove(hint_baseDefense)
		ThreatArrow_DestroyAllGroups()
		local f = function (gid, idx, sid)
			if Squad_IsRetreating(sid) then
				SGroup_Remove(sg_e_baseDefense, sid)
			end
		end
		SGroup_ForEach(sg_e_baseDefense, f)
		Rule_RemoveMe()
	end
end

function Obj2_delayStartThirdObjective()
	local sector = World_GetTerritorySectorID(Marker_GetPosition(mkr_isakovich))
	SGroup_Clear(sg_p_startObj3)
	World_GetSquadsWithinTerritorySector(player1, sg_p_startObj3, sector, OT_Player)
	if not SGroup_IsUnderAttack(sg_p_startObj3, ANY, 5) then
		Objective_Start(OBJ_HoldGround, true)
		if hint_baseDefense ~= nil then
			HintPoint_Remove(hint_baseDefense)
		end
		Rule_RemoveMe()
	end
end

function Obj2_delayStartSecondaryObjective()
	if ((EGroup_Count(eg_HMGs) < 2) or (EGroup_Count(eg_mortars) < 2)) or Objective_IsComplete(OBJ_MoveEngineer) then
		Rule_RemoveMe()
	elseif Player_CanSeeEGroup(player1, eg_HMGs, ANY) or Player_CanSeeEGroup(player1, eg_mortars, ANY) then
		if not Event_IsAnyRunning() then
			Objective_Start(OBJ_Weapons)
			Rule_RemoveMe()
		end
	end
end

function _removeObj2Flash()
	UI_StopFlashing(flashID_moveObj)
end

-- If the player hasn't got an engineer squad, give him a free squad at the start of Objective 2
function Obj2_GrantEngineer()
	_player1Squads = Player_GetSquads(player1)
	SGroup_Filter(_player1Squads, SBP.SOVIET.COMBAT_ENGINEER_SQUAD, FILTER_KEEP)
	if SGroup_IsEmpty(_player1Squads) then
		sg_p_newEngineer = SGroup_CreateIfNotFound("sg_p_newEngineer")
		Util_CreateSquads(player1, sg_p_newEngineer, SBP.SOVIET.COMBAT_ENGINEER_SQUAD, World_Pos(-156.5, 25.5, -173.1), Marker_GetPosition(mkr_startSquad2))
		Util_ReinforceEvent(sg_p_newEngineer)
		UI_CreateEventCue("Icons_events_event_cue", "", 11045304, 11045304, 30, true) -- LOCDB [11045304] 'Engineers arriving at HQ'
	end
end

function Obj2_UpdateProgress()
	local currentTime = Objective_GetTimerSeconds(OBJ_MoveEngineer)
	if currentTime <= 1 then
		Rule_RemoveMe()
	else
		Obj_ShowProgress(11035343, (currentTime/g_escortTimer)) -- LOCDB [11035343] 'Time left...'
	end
end

------ Objective 3: Defend Isakovich until timer expires. Player must keep squads nearby and protect the HQ. -----
function Initialize_Objective3()

	OBJ_HoldGround = {
		
		SetupUI = function() 
			Objective_AddUIElements(OBJ_HoldGround, Marker_GetPosition(mkr_isakovich), true, nil, false)
		end,
		
		OnStart = function()
			Sound_PlayMusic("streamed/music/missions/m06/m06_cue_hold_out", 0, 0)
			EGroup_InstantCaptureStrategicPoint(eg_strat_ike, player1)
			
			Player_ClearArea(player1, mkr_forwardHQ, false)
			Player_ClearArea(player1, mkr_base1, false)
			Player_ClearArea(player1, mkr_base2, false)
			Player_ClearArea(player1, mkr_base3, false)
			
			Rule_AddOneShot(Obj3_buildForwardBase, 0.5)
			EGroup_DeSpawn(eg_p_mapentry)
			sg_e_attackers = SGroup_CreateIfNotFound("sg_e_attackers")
			sg_p_allNearIke =  SGroup_CreateIfNotFound("sg_p_allNearIke")
			sg_a_ambulance = SGroup_CreateIfNotFound("sg_a_ambulance")
			sg_e_pg = SGroup_CreateIfNotFound("sg_e_pg")
			g_attackWaveCount = 0
			g_attackerCountThreshold = 4
			if g_easyDiff then
				g_attackerCountThreshold = 3
			end
			if g_hardDiff then
				g_attackerCountThreshold = 5
			end
			g_enc_counterAttack = {}
			g_enc_armor = {}
			
			-- Enemy squads to deploy during the final objective
			t_attackSquads1 = {SBP.GERMAN.GRENADIER_SQUAD, SBP.GERMAN.PANZER_GRENADIER_SQUAD, SBP.GERMAN.SCOUTCAR_SDKFZ222}
			t_attackSquads2 = {SBP.GERMAN.PANZER_GRENADIER_SQUAD, SBP.GERMAN.STUG_III_E_SQUAD, SBP.GERMAN.PANZER_GRENADIER_SQUAD, SBP.GERMAN.PANZER_IV_SQUAD} --
			t_attackTanks = {SBP.GERMAN.STUG_III_E_SQUAD, SBP.GERMAN.STUG_III_SQUAD, SBP.GERMAN.PANZER_IV_SQUAD}
			--
			Game_Letterbox(true, 0.5)
			Camera_ResetToDefault()
			Camera_MoveTo(mkr_base2, true, 0.5)
			_spawnForwardBase()
			
			g_tankIndex = 1
			
			Player_CompleteUpgrade(player3, BP_GetUpgradeBlueprint("allow_building_hq"))
			sg_a_tempEngineers = SGroup_CreateIfNotFound("sg_a_tempEngineers")
			Util_CreateSquads(player3, sg_a_tempEngineers, SBP.SOVIET.COMBAT_ENGINEER_SQUAD, mkr_tempEngineers, nil, 1, 4)
			SGroup_SetInvulnerable(sg_a_tempEngineers, true)
			SGroup_SetSelectable(sg_a_tempEngineers, false)
			SGroup_EnableUIDecorator(sg_a_tempEngineers, false)
			eg_p_obstructions = EGroup_CreateIfNotFound("eg_p_obstructions")
			Player_GetAllEntitiesNearMarker(player1, eg_p_obstructions, mkr_forwardHQ)
			EGroup_DestroyAllEntities(eg_p_obstructions)
			Cmd_Construct(sg_a_tempEngineers, EBP.SOVIET.HQ, mkr_forwardHQ)
			Rule_AddDelayedInterval(Obj3_removeTempHQEngineers, 5, 1)	
			Rule_AddDelayedInterval(Obj3_retryBuildHQ, 3, 2)
			
			--Bring in HMG truck for the player
			if Player_GetCurrentPopulation(player1, CT_Personnel) < 35 then
				Rule_AddOneShot(A1M06_SetupTruck, 15)
			end
			
			g_useSkirmishAI = true
			g_closeAirAbility = BP_GetAbilityBlueprint("stuka_close_air_m06")
			Player_AddAbility(player2, g_closeAirAbility)
			Player_SetAbilityAvailability(player2, g_closeAirAbility, ITEM_UNLOCKED)
			Player_SetAbilityAvailability(player2, ABILITY.GERMAN.PANZER_GRENADIER_BUNDLED_CAMPAIGN, ITEM_UNLOCKED)
			Player_SetResource(player2, RT_Munition, 500)
			Player_GetAll(player1, sg_p_all)
			SGroup_SetInvulnerable(sg_p_all, true)
			
			--- Garrisoned HMGs
			if not EGroup_IsEmpty(eg_HMG1) then
				Util_CreateSquads(player2, sg_e_all, SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD, eg_HMG1)
			end
			if not EGroup_IsEmpty(eg_HMG2) then
				Util_CreateSquads(player2, sg_e_all, SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD, eg_HMG2)
			end
			
			--Stuka Air Support; enemy planes fly by and destroy world objects during final objective
			g_airSupportIndex = 1
			Rule_AddDelayedInterval(Obj3_StukaSupport, 90, 90)
			
		end,
		
		OnComplete = function()
			-- Fade out and start outro cinematic
			Rule_RemoveIfExist(Obj3_AttackWaves)
			EGroup_DeSpawn(eg_ikeBody)
			Rule_AddOneShot(Obj3_FadeOutOnComplete, 5)
			Rule_AddOneShot(Obj3_StartOutroNIS, 7)
			Rule_RemoveIfExist(Obj3_UpdateProgress)
		end,
		
		OnFail = function()
			Rule_RemoveIfExist(Obj3_UpdateProgress)
			Game_EndSP(false)
		end,
		
		IsComplete = function()
			return false
		end,
		
		Intel_Start = EVENTS.ReachSuccess,				-- Event will play when obj starts but before any UI appears
		Intel_Complete = EVENTS.DefendSuccess,			-- Event will play when obj completes but before UI is cleared
		Intel_Fail = EVENTS.DefendFail,				-- Event will play when obj fails but before UI is cleared
		Title = 11045305, -- LOCDB [11045305] 'Hold out until Isakovich is freed'
		Description = 1459051,			-- Objective Description
		TitleEnd = 11045306, -- LOCDB [11045306] 'Isakovich extracted'
		TitleFail = 11045303, -- LOCDB [11045303] 'Isakovich was killed'
		Type = OT_Primary,				-- Objective Type (OT_Primary, OT_Secondary)
	}
	
	Objective_Register(OBJ_HoldGround)

end

function Obj3_retryBuildHQ()
	if not EGroup_IsEmpty(eg_wreckedHQ) then
		EGroup_DestroyAllEntities(eg_wreckedHQ)
	end
	if not SGroup_IsConstructingBuilding(sg_a_tempEngineers, ANY) then
		if not SGroup_IsEmpty(sg_a_tempEngineers) then
			Player_ClearArea(player1, mkr_forwardHQ, false)
			Cmd_Construct(sg_a_tempEngineers, EBP.SOVIET.HQ, Util_GetRandomPosition(mkr_forwardHQ, 2))
		end
	else
		Rule_RemoveMe()
	end
end

function Obj3_FadeOutOnComplete()
	Game_Letterbox(true, 2)
	Game_FadeToBlack(FADE_OUT, 2)
end

function Obj3_StartOutroNIS()
	Game_FadeToBlack(FADE_IN, 1)
	Util_StartNIS(EVENTS.NIS02)
end


function Initialize_Objective4()

	OBJ_Health = {
		
		SetupUI = function() 

		end,
		
		OnStart = function()
			Objective_SetAlwaysShowDetails(OBJ_Health, true, false, false)
			hint_forwardBase = HintPoint_Add(eg_p_hq2, true, 11045307, nil, HPAT_Hint, "Icons_buildings_building_soviet_headquarters") -- LOCDB [11045307] 'Defend the field headquarters'
			EGroup_SetInvulnerable(eg_p_hq2, false)
			EGroup_SetSelectable(eg_p_hq2, true)
			if g_easyDiff then
				Modify_ReceivedDamage(eg_p_hq2, 1.5)
			elseif g_hardDiff then
				Modify_ReceivedDamage(eg_p_hq2, 2)
			else
				Modify_ReceivedDamage(eg_p_hq2, 2.5)
			end
			Modify_Armor(eg_p_hq2, 0.5, true)
			Rule_AddInterval(updateHQHealth, 1)
			Rule_AddOneShot(Obj3_RemoveFBhint, 15)
			
			if g_easyDiff then
				Rule_AddDelayedInterval(Obj3_AttackWaves, 35, 5)
				g_holdGroundTimer = 410
			else
				Rule_AddDelayedInterval(Obj3_AttackWaves, 5, 5)
				g_holdGroundTimer = 380
			end
			Rule_AddDelayedInterval(A1M06_ClearWrecks, 120, 1)
			
			g_warningTimer = 30
			Objective_StartTimer(OBJ_HoldGround, COUNT_DOWN, g_holdGroundTimer, 30)
			
			Timer_Start(202, 60)
			Rule_AddDelayedInterval(Obj3_IsComplete, 3, 3)
			Rule_AddInterval(Obj3_UpdateProgress, 1)
			_flashProgressBar(10)
			sg_e_nearSmokeStacks = SGroup_CreateIfNotFound("sg_e_nearSmokeStacks")
			Rule_AddDelayedInterval(_destroySmokeStack1, 120, 1)
			Rule_AddDelayedInterval(_destroySmokeStack2, 240, 1)
			
			local message = Loc_FormatText(11045651, Loc_ConvertNumber(100)) -- LOCDB [11045651] 'HQ integrity: %1HEALTH%%%'
			Objective_UpdateText(OBJ_Health, message, nil, false)
			
		end,
		
		OnComplete = function()
			Mission_MissionComplete()
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
		Title = 11045651,				-- Objective Title
		Description = 1459051,			-- Objective Description
		TitleEnd = 11045306, -- LOCDB [11045306] 'Isakovich extracted'
		TitleFail = 11045303, -- LOCDB [11045303] 'Isakovich was killed'
		Type = OT_Secondary,				-- Objective Type (OT_Primary, OT_Secondary)
	}
	
	Objective_Register(OBJ_Health)

end

function _destroySmokeStack1()
	if EGroup_IsEmpty(eg_smokestack1) then
		Rule_RemoveMe()
	elseif Misc_IsPosOnScreen(EGroup_GetPosition(eg_smokestack1), 0.8) then
		Player_GetAllSquadsNearMarker(player2, sg_e_nearSmokeStacks, EGroup_GetPosition(eg_smokestack1), 25)
		if not SGroup_IsEmpty(sg_e_nearSmokeStacks) then
			EGroup_Kill(eg_smokestack1)
			Rule_RemoveMe()
		end
	end
end

function _destroySmokeStack2()
	if EGroup_IsEmpty(eg_smokestack2) then
		Rule_RemoveMe()
	elseif Misc_IsPosOnScreen(EGroup_GetPosition(eg_smokestack2), 0.8) then
		Player_GetAllSquadsNearMarker(player2, sg_e_nearSmokeStacks, EGroup_GetPosition(eg_smokestack2), 25)
		if not SGroup_IsEmpty(sg_e_nearSmokeStacks) then
			EGroup_Kill(eg_smokestack2)
			Rule_RemoveMe()
		end
	end
end

function updateHQHealth()
	-- Display the player's HQ health; losing the HQ is a fail condition during objective 3
	if not EGroup_IsEmpty(eg_p_hq2) then
		if g_hqHealth ~= math.floor(EGroup_GetAvgHealth(eg_p_hq2) * 100) then 
			g_hqHealth = math.floor(EGroup_GetAvgHealth(eg_p_hq2) * 100)
			local message = Loc_FormatText(11045651, Loc_ConvertNumber(g_hqHealth)) -- LOCDB [11045651] 'HQ integrity: %1HEALTH%%%'
			Objective_UpdateText(OBJ_Health, message, nil, false)
		elseif (Objective_GetTimerSeconds(OBJ_HoldGround) < 75) and (EGroup_GetAvgHealth(eg_p_hq2) > 0.80) then
			if not g_mortarStart then
			end
		end
	end
end


function Obj3_IsComplete()
	-- Objective Complete if timer reaches zero before player HQ is destroyed 
	-- Objective Fail if HQ is destroyed or no player squads left in the defense sector
	Player_GetAllSquadsNearMarker(player1, sg_p_allNearIke, sector_defense)
	if (SGroup_IsEmpty(sg_p_allNearIke) and Prox_ArePlayersNearMarker(player2, sector_defense, ANY) and g_warningTimer <= 0) or EGroup_IsEmpty(eg_p_hq2) or SGroup_IsEmpty(sg_nearIke) then
		Objective_Fail(OBJ_HoldGround)
		Rule_RemoveMe()
		Obj_HideProgress()
	elseif Objective_GetTimerSeconds(OBJ_HoldGround) == 0 then
		Achievement_DefendForwardHQ()
		Rule_AddOneShot(Obj3_delayCompleteMission, 1)
		Objective_Show(OBJ_Health, false)
		Rule_RemoveIfExist(updateHQHealth)
		Rule_RemoveMe()
		Obj_HideProgress()
	end
	
	if (SGroup_Count(sg_p_allNearIke) == 1) and (g_warningTimer == 30) then
		g_warningTimer = 27
		Util_MissionTitle(11045308) -- LOCDB [11045308] 'Stay close to Isakovich'
	elseif g_warningTimer <= 27 then
		g_warningTimer = g_warningTimer - 3
	end
	
end

function Obj3_retreatRemainingEnemies()
	sg_e_outroRetreat = SGroup_CreateIfNotFound("sg_e_outroRetreat")
	local f = function (gid, idx, sid)
		SGroup_Add(sg_e_outroRetreat, sid)
		local retreatTarget = mkr_attackerSpawn1
		if Prox_MarkerSGroup(mkr_attackerSpawn1, sg_e_outroRetreat, PROX_CENTER) > Prox_MarkerSGroup(mkr_attackerSpawn2, sg_e_outroRetreat, PROX_CENTER) then
			retreatTarget = mkr_attackerSpawn2
		end
		Cmd_Retreat(sg_e_outroRetreat, Marker_GetPosition(retreatTarget), nil, nil, nil, nil, true)
		SGroup_Clear(sg_e_outroRetreat)
	end
	ThreatArrow_DestroyAllGroups()
	SGroup_ForEach(sg_e_attackers, f)
	Rule_RemoveIfExist(Obj3_retreatRemainingEnemies)
	Rule_AddOneShot(Obj3_retreatRemainingEnemies, 15)
end

function Obj3_UpdateProgress()
	local currentTime = Objective_GetTimerSeconds(OBJ_HoldGround)
	if currentTime <= 1 then
		Rule_RemoveMe()
	else
		Obj_ShowProgress(11045309, (currentTime/g_holdGroundTimer)) -- LOCDB [11045309] 'Time to Extraction'
	end
end

function Obj3_delayCompleteMission()
	Objective_Complete(OBJ_HoldGround)
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

---- #attackWaves
---- Enemy squads that attack the defense sector during Objective 3
function Obj3_AttackWaves()
	if (SGroup_Count(sg_e_attackers) < g_attackerCountThreshold) or (Timer_GetElapsed(202) > 40 and Objective_IsTimerSet(OBJ_HoldGround) and SGroup_Count(sg_e_attackers) < 10) then
		Timer_End(202)
		Timer_Start(202, 60)
		g_pgUpgrade = 0
		if (g_attackWaveCount >= 7) or (Objective_GetTimerSeconds(OBJ_HoldGround) < 75) then
			g_pgUpgrade = World_GetRand(1,2)
			A1M06_SpawnAttackers(t_attackSquads1[World_GetRand(1,3)],t_attackTanks[g_tankIndex])
		elseif (g_attackWaveCount >= 6) or (Objective_GetTimerSeconds(OBJ_HoldGround) < 125) then
			A1M06_SpawnAttackers(t_attackSquads1[3],t_attackSquads2[4])
			
		elseif (g_attackWaveCount >= 4) or (Objective_GetTimerSeconds(OBJ_HoldGround) < 175) then
			g_pgUpgrade = 2
			A1M06_SpawnAttackers(t_attackSquads1[3],t_attackSquads2[3])
			g_attackerCountThreshold = g_attackerCountThreshold + 1
		elseif (g_attackWaveCount >= 2) or (Objective_GetTimerSeconds(OBJ_HoldGround) < 225) then
			g_pgUpgrade = 1
			A1M06_SpawnAttackers(t_attackSquads1[2],t_attackSquads2[2])
		elseif (g_attackWaveCount >= 0) or (Objective_GetTimerSeconds(OBJ_HoldGround) < 285) then
			A1M06_SpawnAttackers(t_attackSquads1[1],t_attackSquads2[1])
		end
		g_attackWaveCount = g_attackWaveCount + 1
		if g_tankIndex == table.getn(t_attackTanks) then
			g_tankIndex = 1
		else
			g_tankIndex = g_tankIndex + 1
		end
	end
	if Objective_GetTimerSeconds(OBJ_HoldGround) <= 60 then
		Rule_AddOneShot(Obj3_retreatRemainingEnemies, 40)
		Rule_RemoveMe()
	end
end

function Obj3_RemoveFBhint()
	UI_StopFlashing(flashID_holdObj)
	HintPoint_Remove(hint_forwardBase)
	Player_SetPopCapOverride(player1, 90)
	eventCue_popCapIncrease = UI_CreateEventCue("Icons_events_event_cue_upgrade", "", 11045310, 11045310, 30, true) -- LOCDB [11045310] 'Population Cap Increased'
	function _flashEventCue() flashID_popCap = UI_FlashEventCue(eventCue_popCapIncrease, true) end
	function _stopFlashingEventCue() UI_StopFlashing(flashID_popCap) end
	Rule_AddOneShot(_flashEventCue, 1)
	Rule_AddOneShot(_stopFlashingEventCue, 10)
end

-- Construct forward base buildings in the defense sector
function _spawnForwardBase()
	eg_p_hq2 = EGroup_CreateIfNotFound("eg_p_hq2")
	eg_p_forwardBase = EGroup_CreateIfNotFound("eg_p_forwardBase")
	
	World_SetDesignerSupply(Marker_GetPosition(mkr_forwardBase), true)

	FOW_PlayerRevealArea(player1, Marker_GetPosition(mkr_reveal1), 120, -1)
	Rule_AddOneShot(_showForwardBase, 3.5)
	Rule_AddOneShot(_endForwardBase, 8)
end

function _showForwardBase()
	Camera_MoveTo(Marker_GetPosition(mkr_forwardHQ), true, 0.5)
	-- Set Rally Points
	if not EGroup_IsEmpty(eg_startingBase) then
		Command_EntityPos(player1, eg_startingBase, CMD_RallyPoint, Marker_GetPosition(mkr_rally2))
	end
end

function _endForwardBase()
	Game_Letterbox(false, 3)
	Camera_MoveTo(mkr_attackTarget, true, 0.5)
	flashID_holdObj = UI_FlashObjectiveIcon(OBJ_HoldGround.ID, true)
	Rule_AddOneShot(__Autosave2, 2)

	Util_CreateSquads(player3, sg_nearIke, SBP.SOVIET.COMBAT_ENGINEER_SQUAD, mkr_woundedIke1, nil, 1, 1)
	Util_CreateSquads(player3, sg_nearIke, SBP.SOVIET.COMBAT_ENGINEER_SQUAD, mkr_woundedIke3, nil, 1, 1)
	SGroup_SetSelectable(sg_nearIke, false)
	SGroup_EnableUIDecorator(sg_nearIke, false)
	SGroup_EnableMinimapIndicator(sg_nearIke, false)
	SGroup_SetWorldOwned(sg_nearIke)
	Util_ApplyModifier(sg_nearIke, "posture_speed_modifier", 0.01, MUT_Multiplication)
	mod_ceasefire = Modify_WeaponEnabled(sg_nearIke, "hardpoint_01", false)
	g_diggerIndex = 1
	g_nearIke_startedDigging = true
	Rule_AddInterval(_startEngineerDigging, 0.4)
	SGroup_SetInvulnerable(sg_p_all, false)
end	

function _startEngineerDigging()
	local squad = nil
	if SGroup_Count(sg_nearIke) >= g_diggerIndex then
		squad = SGroup_GetSpawnedSquadAt(sg_nearIke, g_diggerIndex)
		Squad_SetAnimatorState(squad, "shovel_digin_state", "active")
		g_diggerIndex = g_diggerIndex + 1
	else
		Rule_RemoveMe()
	end
end

function Obj3_removeTempHQEngineers()
	eg_p_hq2 = EGroup_CreateIfNotFound("eg_p_hq2")
	Player_GetAllEntitiesNearMarker(player3, eg_p_hq2, mkr_forwardHQ, 6)
	if not EGroup_IsEmpty(eg_p_hq2) then
		EGroup_Filter(eg_p_hq2, EBP.SOVIET.HQ, FILTER_KEEP)
		EGroup_FilterUnderConstruction(eg_p_hq2, FILTER_REMOVE)
		if not EGroup_IsEmpty(eg_p_hq2) and not SGroup_IsEmpty(sg_a_tempEngineers) then
			Rule_RemoveIfExist(Obj3_retryBuildHQ)
			SGroup_DestroyAllSquads(sg_a_tempEngineers)
			Loc_FormatText(11045651, Loc_ConvertNumber(100))
			Objective_Start(OBJ_Health, false)
            if Player_HasUpgrade(player1, UPG.SOVIET.HQ_HEALING_AURA) then
                 Cmd_Upgrade(eg_p_hq2, UPG.SOVIET.HQ_HEALING_AURA, 1, true)
            end
			EGroup_SetPlayerOwner(eg_p_hq2, player1)
			EGroup_SetRallyPoint(eg_p_hq2, Marker_GetPosition(mkr_rally2))
			EGroup_SetPlayerOwner(eg_startingBase, player3)
			Rule_RemoveMe()
		end
	end
end

function __Autosave2 ()
	Util_Autosave()
end

function Obj3_StukaSupport()
	-- Enemy planes fly around defense sector and destroy world objects. They should not directly attack player buildings or squads.
	local targets = {mkr_stuka_target1, mkr_stuka_target2, mkr_stuka_target3, mkr_stuka_target4, mkr_stuka_target5}
	Cmd_Ability(player2, g_closeAirAbility, Marker_GetPosition(targets[g_airSupportIndex]), nil, true)
	g_airSupportIndex = g_airSupportIndex + 1
	if g_airSupportIndex > 5 then
		g_airSupportIndex  = 1
	end
end
---------

function Mission_MissionComplete()
	Game_Letterbox(true, 0)
	Rule_AddDelayedInterval(Mission_MissionEnd, 1.5, 1)
end

function Mission_MissionEnd()

	if Event_IsAnyRunning() == false then
		Game_EndSP(true)
	end

end

function Mission_MissionEndInstant()

	Game_EndSP(true)

end


------- Enemy Spawns -------

function A1M06_SpawnSnipers()
	-- Patrolling snipers that the player has to kill in Objective 1
	g_enc_patrols = {}
	sg_e_snipers = SGroup_CreateIfNotFound("sg_e_snipers")
	sg_e_sniper1 = SGroup_CreateIfNotFound("sg_e_sniper1")
	sg_e_sniper2 = SGroup_CreateIfNotFound("sg_e_sniper2")
	sg_e_sniper3 = SGroup_CreateIfNotFound("sg_e_sniper3")
	sg_e_sniperSingle = SGroup_CreateIfNotFound("sg_e_sniperSingle")
	sg_p_sniperTarget = SGroup_CreateIfNotFound("sg_e_sniperTarget")
	sg_p_squadsInBase = SGroup_CreateIfNotFound("sg_p_squadsInBase")
	
	local data = {
		name = "patrol1",
		player = player2,
		sgroups = {sg_e_all, sg_e_snipers, sg_e_sniper1},
		units = {
			{
				sbp = SBP.GERMAN.SNIPER_SQUAD,
				spawn = mkr_sniper1_spawn,
			}
		}
	}
	table.insert(g_enc_patrols, Encounter:Create(data))
	
	local goalData = {
		name = "Defend",
		tacticControlsList = {
			{
				tacticType = TACTIC_Cover,
				priority = 100,
			},
			{
				tacticType = TACTIC_Retaliate,
				priority = -1,
			},
			{
				tacticType = TACTIC_ForceAttack,
				priority = -1,
			},
		},
		patrolParams = {
			path = "sniper1Patrol",
			wait = 5,
		},
		fallbackParams = {
			thresholds = {0.75, 0.25},
			markers = {mkr_sniper1retreat, mkr_sniper1retreat},
			retreat = false,
			fallbackDist = 30,
			minDist = 25,
			maxDist = 35,
		}
	}
	g_enc_patrols[1]:SetGoal(goalData)
	
	data.name = "patrol2"
	data.sgroups = {sg_e_all, sg_e_snipers, sg_e_sniper2}
	data.units = {
		{
				sbp = SBP.GERMAN.SNIPER_SQUAD,
				spawn = mkr_sniper2,
		}
	}
	table.insert(g_enc_patrols, Encounter:Create(data))
	goalData.patrolParams.path = "sniper2Patrol"
	goalData.fallbackParams.markers = {mkr_sniper2retreat, mkr_sniper2retreat}

	g_enc_patrols[2]:SetGoal(goalData)
	
	data.name = "patrol3"
	data.sgroups = {sg_e_all, sg_e_snipers, sg_e_sniper3}
	data.units = {
		{
				sbp = SBP.GERMAN.SNIPER_SQUAD,
				spawn = mkr_sniper3,
		}
	}
	table.insert(g_enc_patrols, Encounter:Create(data))
	goalData.patrolParams.path = "sniper3Patrol"
	goalData.fallbackParams.markers = {mkr_sniper3retreat, mkr_sniper3retreat}

	g_enc_patrols[3]:SetGoal(goalData)

	
	--- Difficulty Variation 1
	--- Buff sniper sight radius on Normal and Hard
	if not g_easyDiff then
		Modify_SightRadius(sg_e_snipers, 1.5)
	end
	SGroup_SetInvulnerable(sg_e_snipers, true, 20)
	-- Disable sniper camo-in-cover on Easy and Normal
	if not g_hardDiff then
		Util_ApplyModifier(sg_e_snipers, "camouflage_enable", -1, MUT_Enable)
	end

end

function A1M06_SpawnSecondarySnipers()
	-- Garrisoned snipers that the player has to kill in Objective 1
	g_enc_secSnipers = {}
	sg_e_secSnipers = SGroup_CreateIfNotFound("sg_e_secSnipers")
	sg_e_secSniper1 = SGroup_CreateIfNotFound("sg_e_secSniper1")
	sg_e_secSniper2 = SGroup_CreateIfNotFound("sg_e_secSniper2")
	sg_e_secSniper3 = SGroup_CreateIfNotFound("sg_e_secSniper3")
	local data = {
		name = "secSniper1",
		player = player2,
		sgroups = {sg_e_all, sg_e_secSnipers, sg_e_secSniper1},
		units = {
			{
				sbp = SBP.GERMAN.SNIPER_SQUAD,
				spawn = mkr_secSniper1,
			}
		}
	}
	table.insert(g_enc_secSnipers, Encounter:Create(data))
	
	local goalData = {
		name = "Defend",
		useSkirmishAI = true,
		garrison = false,
		garrisonIdle = false,
	}
	g_enc_secSnipers[1]:SetGoal(goalData)
	
	local goalData = {
		name = "Defend",
		garrison = true,
		garrisonIdle = true
	}
	
	data.name = "secSniper2"
	data.sgroups = {sg_e_all, sg_e_secSnipers, sg_e_secSniper2}
	data.units = {
		{
				sbp = SBP.GERMAN.SNIPER_SQUAD,
				spawn = mkr_secSniper2,
		}
	}
	table.insert(g_enc_secSnipers, Encounter:Create(data))
	
	g_enc_secSnipers[2]:SetGoal(goalData)
	
	data.name = "secSniper3"
	data.sgroups = {sg_e_all, sg_e_secSnipers, sg_e_secSniper3}
	data.units = {
		{
				sbp = SBP.GERMAN.SNIPER_SQUAD,
				spawn = mkr_secSniper3,
		}
	}
	table.insert(g_enc_secSnipers, Encounter:Create(data))
	
	g_enc_secSnipers[3]:SetGoal(goalData)
	
	if not g_hardDiff then
		Util_ApplyModifier(sg_e_secSnipers, "camouflage_enable", -1, MUT_Enable)
	end
	
	-- Sniper nest, temporary buff to one enemy sniper
	modID_sniperNest1 = Modify_SightRadius(sg_e_secSniper1, 1.5)
	modID_sniperNest2 = Modify_WeaponRange(sg_e_secSniper1, "hardpoint_01", 1.5)
	Rule_AddInterval(SniperNest_RemoveBuffs, 1)
	
end

function SniperNest_RemoveBuffs()
	if SGroup_IsEmpty(sg_e_secSniper1) then
		Rule_RemoveMe()
	elseif SGroup_GetVeterancyExperience(sg_e_secSniper1) > 200 then
		Modifier_Remove(modID_sniperNest1)
		Modifier_Remove(modID_sniperNest2)
		Rule_RemoveMe()
	end
end

--- Engineer, for the player. Required for objective 2.
function A1M06_SetupEngineer()
	sg_p_Engineer = SGroup_CreateIfNotFound("sg_p_Engineer")
	Util_CreateSquads(player1, sg_p_Engineer, SBP.SOVIET.COMBAT_ENGINEER_SQUAD, mkr_playerStart)
	hint_Engineer = HintPoint_Add(sg_p_Engineer, true, 11024598, nil, HPAT_Hint, "Icons_portraits_unit_soviet_combat_engineer_s_portrait")
	Rule_AddInterval(_isEngineerSelected, 3)
	Rule_AddInterval(_spawnNewEngineer, 5)
	Player_GetAll(player1)
	sg_p_engineers = SGroup_CreateIfNotFound("sg_p_engineers")
	SGroup_Clear(sg_p_engineers)
	SGroup_AddGroup(sg_p_engineers, sg_allsquads)
	SGroup_Filter(sg_p_engineers, SBP.SOVIET.COMBAT_ENGINEER_SQUAD, FILTER_KEEP)
end

function _isEngineerSelected()
	if SGroup_IsEmpty(sg_p_Engineer) then
		Rule_RemoveMe()
	elseif Misc_IsSquadSelected(SGroup_GetRandomSpawnedSquad(sg_p_Engineer)) then
		HintPoint_Remove(hint_Engineer)
		Rule_RemoveMe()
	end
end

function _spawnNewEngineer()
	if Objective_IsComplete(OBJ_MoveEngineer) then
		Rule_RemoveMe()
	elseif SGroup_IsEmpty(sg_p_Engineer) then
		Rule_RemoveIfExist(_isEngineerSelected)
		Rule_RemoveMe()
		Camera_FocusOnPosition(Marker_GetPosition(mkr_playerStart), false)
		Util_MissionTitle(11045301)-- LOCDB [11045301] 'Escort an engineer to Isakovich'
		A1M06_SetupEngineer()
	end
end

--- FREE HALFTRACK. The player gets a free halftrack with Guard Troops if their pop-cap is low at the start of Objective 3.
function A1M06_SetupTruck()
	Util_StartIntel(EVENTS.TruckArrival)
	sg_p_truck = SGroup_CreateIfNotFound("sg_p_truck")
	sg_p_guardsInTruck = SGroup_CreateIfNotFound("sg_p_guardsInTruck")
	Util_CreateSquads(player3, sg_p_truck, SBP.SOVIET.M5_HALFTRACK_SQUAD, mkr_ambSpawn)
	hint_truck = HintPoint_Add(sg_p_truck, true, 11038345, nil, HPAT_Hint, "Icons_portraits_vehicle_soviet_m5_halftrack_s_portrait")
	SGroup_SetInvulnerable(sg_p_truck, true)
	Cmd_SquadPath(sg_p_truck, "mgtruck", false, LOOP_NONE, false, 0)
	Player_SetResource(player3, RT_Munition, 200)
	_loadMGtruck = function ()
		Util_CreateSquads(player3, {sg_p_all, sg_p_guardsInTruck}, SBP.SOVIET.GUARDS_TROOPS, sg_p_truck, nil, 2, nil, nil, nil, UPG.SOVIET.PTRS_41_AT_RIFLE_PACKAGE_GUARD_TROOP)
	end
	Rule_AddOneShot(_loadMGtruck, 2)
	Rule_AddInterval(_hasTruckArrived, 1)
end

--- Check if the player has received the halftrack
function _hasTruckArrived()
	if SGroup_IsEmpty(sg_p_truck) then
		Rule_RemoveMe()
	elseif Misc_IsSGroupSelected(sg_p_truck, ANY) then
		Rule_RemoveMe()
		HintPoint_Remove(hint_truck)
		SGroup_SetPlayerOwner(sg_p_truck, player1)
		SGroup_SetPlayerOwner(sg_p_guardsInTruck, player1)
		SGroup_SetInvulnerable(sg_p_truck, false)
		Cmd_Move(sg_p_truck, mkr_truckDest, nil, false, Marker_GetPosition(mkr_wire))
		Util_ReinforceEvent(sg_p_truck)
	elseif Prox_AreSquadsNearMarker(sg_p_truck, mkr_truckDest, ANY, 15) then
		SGroup_SetInvulnerable(sg_p_truck, false)
	end
end

--- DEFENDERS; pre-spawned on the map for Objective 1
function A1M06_SpawnDefenders()
	g_enc_defenders = {}
	g_enc_reinforcements = {}
	
	local data = {
		name = "defender1",
		player = player2,
		sgroups = {sg_e_all},
		units = {
			{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = mkr_defend1,
			}
		}
	}
	if g_hardDiff then
		local unit = {
			sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
			spawn = mkr_defend1,
		}
		table.insert(data.units, unit)
	end
	table.insert(g_enc_defenders, Encounter:Create(data))
	
	local goalData = {
		name = "Defend",
		useSkirmishAI = g_useSkirmishAI,
		garrisonIdle = false,
		range = 35,
		leashRange = 25,
		pickupWeapons = -1,
		onFailure = A1M06_ReinforceDefenders
	}
	goalData.target = mkr_defend1
	goalData.leashRange = 22
	g_enc_defenders[1]:SetGoal(goalData)
	goalData.onFailure = nil
	-----
	data.name = "defender2"
	data.units = {
		{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = mkr_defend2,
		}
	}
	if g_hardDiff then
		local unit = {
			sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
			spawn = mkr_defend2,
		}
		table.insert(data.units, unit)
	end
	table.insert(g_enc_defenders, Encounter:Create(data))
	goalData.garrisonIdle = true
	goalData.target = mkr_defend2
	g_enc_defenders[2]:SetGoal(goalData)
	-----
	data.name = "defender3"
	data.units = {
		{
				sbp = SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD,
				spawn = mkr_defend3,
		}
	}
	table.insert(g_enc_defenders, Encounter:Create(data))
	goalData.garrisonIdle = false
	goalData.target = mkr_defend3
	goalData.onFailure = A1M06_ReinforceDefenders
	goalData.leashRange = 22
	g_enc_defenders[3]:SetGoal(goalData)
	goalData.onFailure = nil
	-----
	data.name = "defender4"
	data.units = {
		{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = mkr_defend4,
		}
	}
	if g_hardDiff then
		local unit = {
			sbp = SBP.GERMAN.GRENADIER_SQUAD,
			upgrades = {UPG.GERMAN.GRENADIER_MG42_LMG},
			spawn = mkr_defend4,
		}
		table.insert(data.units, unit)
	end
	table.insert(g_enc_defenders, Encounter:Create(data))
	goalData.garrisonIdle = true
	goalData.target = mkr_defend4
	goalData.leashRange = 25
	g_enc_defenders[4]:SetGoal(goalData)
	-----
	data.name = "defender5"
	data.units = {
		{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = mkr_defend5,
		}
	}
	table.insert(g_enc_defenders, Encounter:Create(data))
	goalData.garrisonIdle = false
	goalData.target = mkr_defend5
	g_enc_defenders[5]:SetGoal(goalData)	
	-----
	data.name = "defender6"
	data.units = {
		{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = mkr_defend6,
		}
	}
	table.insert(g_enc_defenders, Encounter:Create(data))
	goalData.garrisonIdle = false
	goalData.target = mkr_defend6
	g_enc_defenders[6]:SetGoal(goalData)	
	-----
	data.name = "defender7"
	data.units = {
		{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = mkr_defend7,
		}
	}
	table.insert(g_enc_defenders, Encounter:Create(data))
	goalData.garrisonIdle = false
	goalData.target = mkr_defend7
	g_enc_defenders[7]:SetGoal(goalData)	
	-----
	data.name = "defender8"
	data.units = {
		{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = mkr_defend8,
		}
	}
	table.insert(g_enc_defenders, Encounter:Create(data))
	goalData.garrisonIdle = true
	goalData.garrison = true
	goalData.target = mkr_defend8
	g_enc_defenders[8]:SetGoal(goalData)	
	-----
	data.name = "defender9"
	data.units = {
		{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = mkr_defend9,
		}
	}
	table.insert(g_enc_defenders, Encounter:Create(data))
	goalData.garrisonIdle = false
	goalData.garrison = false
	goalData.range = 25
	goalData.target = mkr_defend9
	goalData.retaliateAttacks = true
	g_enc_defenders[9]:SetGoal(goalData)	
	-----
	data.name = "defender10"
	data.units = {
		{
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
				spawn = mkr_defend10,
				dropItems = {{slotItem = SLOT_ITEM.PANZERSHRECK, dropChance = 0, exclusive = true}}
		}
	}
	table.insert(g_enc_defenders, Encounter:Create(data))
	goalData.garrisonIdle = false
	goalData.target = mkr_defend10
	goalData.range = 35
	g_enc_defenders[10]:SetGoal(goalData)	
	-----
	data.name = "defender11"
	data.units = {
		{
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
				spawn = mkr_defend11,
		}
	}
	table.insert(g_enc_defenders, Encounter:Create(data))
	goalData.garrisonIdle = false
	goalData.target = mkr_defend11
	g_enc_defenders[11]:SetGoal(goalData)	
	-----
	data.name = "defender12"
	data.units = {
		{
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
				upgrades = {UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM},
				spawn = mkr_defend12,
		}
	}
	table.insert(g_enc_defenders, Encounter:Create(data))
	goalData.garrisonIdle = false
	goalData.target = mkr_defend12
	g_enc_defenders[12]:SetGoal(goalData)	
	-----
	data.name = "defender13"
	data.units = {
		{
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
				upgrades = {UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM},
				dropItems = {{slotItem = SLOT_ITEM.PANZERSHRECK, dropChance = 1, exclusive = true}},
				spawn = mkr_defend13,
		}
	}
	if g_hardDiff then
		local unit = {
			sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
			spawn = mkr_defend13,
		}
		table.insert(data.units, unit)
	end
	table.insert(g_enc_defenders, Encounter:Create(data))
	goalData.garrisonIdle = false
	goalData.target = mkr_defend13
	g_enc_defenders[13]:SetGoal(goalData)	
	
	-----
	data.name = "defender14"
	data.units = {
		{
			sbp = SBP.GERMAN.SCOUTCAR_SDKFZ222,
			spawn = mkr_defend14,
		}
	}
	if g_hardDiff then
		data.units[1] = {
			sbp = SBP.GERMAN.SDKFZ_251_HALFTRACK_SQUAD,
			entityUpgrades = {UPG.GERMAN.SDKFZ_251_HALFTRACK_FLAMMPANZERWAGEN_UPGRADE},
			spawn = mkr_defend14,
		}
	end
	table.insert(g_enc_defenders, Encounter:Create(data))
	local goalData = {
		name = "Defend",
		useSkirmishAI = g_useSkirmishAI,
		retaliateAttacks = true,
		patrolParams = {
			path = "armoredCar",
			wait = 6,
		},
	}
	g_enc_defenders[14]:SetGoal(goalData)
	goalData.patrolParams = nil
	goalData.range = 65
	----- AT Guns
	-----
	goalData.leashRange = 22
	data.name = "defender15"
	data.units = {
		{
			sbp = SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD,
			spawn = mkr_atGun1,
		}
	}
	table.insert(g_enc_defenders, Encounter:Create(data))
	goalData.target = mkr_atGun1
	goalData.garrisonIdle = false
	goalData.retaliateAttacks = false
	g_enc_defenders[15]:SetGoal(goalData)	
	----
	data.name = "defender16"
	data.units = {
		{
				sbp = SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD,
				spawn = mkr_atGun2,
		}
	}
	table.insert(g_enc_defenders, Encounter:Create(data))
	goalData.target = mkr_atGun2
	goalData.garrisonIdle = false
	g_enc_defenders[16]:SetGoal(goalData)	
	----
	data.name = "defender17"
	data.units = {
		{
				sbp = SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD,
				spawn = mkr_atGun3,
		}
	}
	table.insert(g_enc_defenders, Encounter:Create(data))
	goalData.target = mkr_atGun3
	goalData.garrisonIdle = false
	goalData.onFailure = A1M06_ReinforceDefenders
	g_enc_defenders[17]:SetGoal(goalData)	
end

-- Reinforce Defenders: when certain defenders are killed, spawn reinforcements to replace them
function A1M06_ReinforceDefenders(enc)

	g_enc_toBeReinforced = enc

	if not Rule_Exists(A1M06_Rule_ReinforceDefenders) then
		Rule_AddInterval(A1M06_Rule_ReinforceDefenders, 1)
	end
	
end

function A1M06_Rule_ReinforceDefenders()
	if g_enc_toBeReinforced == g_enc_defenders[1] and Player_CanSeePosition(player1, Marker_GetPosition(mkr_atgun_reinforce)) or
	   g_enc_toBeReinforced == g_enc_defenders[17] and Player_CanSeePosition(player1, Marker_GetPosition(mkr_hmg_reinforce))
	   or g_enc_toBeReinforced == g_enc_defenders[3] then
		local count = table.getn(g_enc_reinforcements) + 1
		local squad = SBP.GERMAN.OSTRUPPEN_SQUAD
		local attackTarget = mkr_mortar2
		local spawnMarker = Util_FindHiddenSpawn(Marker_GetPosition(mkr_reinforce1Spawn_far), Marker_GetPosition(mkr_reinforce1Spawn))
		if g_enc_toBeReinforced == g_enc_defenders[3] then
			-- Scout car reinforcement defends central territory
			squad = SBP.GERMAN.SCOUTCAR_SDKFZ222
			attackTarget = mkr_mortar3
			spawnMarker = mkr_attackerSpawn1
		elseif g_enc_toBeReinforced == g_enc_defenders[17] then
			-- Ostruppen reinforcements capture available HMGs
			squad = SBP.GERMAN.OSTRUPPEN_SQUAD
			attackTarget = Marker_GetPosition(mkr_hmg_reinforce)
			spawnMarker = Util_FindHiddenSpawn(Marker_GetPosition(mkr_reinforce2Spawn_far), Marker_GetPosition(mkr_reinforce2Spawn))
		end
		
		local data = {
			name = "reinforce" .. count,
			player = player2,
			sgroups = {sg_e_all},
			units = {
				{
					sbp = squad,
					spawn = spawnMarker,
				}
			}
		}
		
		local goalData = {
			name = "Defend",
			target = attackTarget,
			safeMoveWeight = 0,
			useSkirmishAI = true,
		}
		if not Event_IsAnyRunning() and not (SGroup_IsEmpty(sg_e_snipers) and SGroup_IsEmpty(sg_e_secSnipers)) then
			table.insert(g_enc_reinforcements, Encounter:Create(data))
			if g_enc_toBeReinforced == g_enc_defenders[1] then
				if not EGroup_IsEmpty(eg_atgun_reinforce) then
					g_HMG1_captureSgroup = g_enc_reinforcements[table.getn(g_enc_reinforcements)].sgroup
					Cmd_Move(g_HMG1_captureSgroup, eg_atgun_reinforce)
					Rule_AddInterval(A1M06_HMG1_Capture, 1)
				else
					goalData.pickupWeapons = 1000
					g_enc_reinforcements[table.getn(g_enc_reinforcements)]:SetGoal(goalData)
				end
			elseif g_enc_toBeReinforced == g_enc_defenders[17] then
				if not EGroup_IsEmpty(eg_hmg_reinforce) then
					g_HMG2_captureSgroup = g_enc_reinforcements[table.getn(g_enc_reinforcements)].sgroup
					Cmd_Move(g_HMG2_captureSgroup, eg_hmg_reinforce)
					Rule_AddInterval(A1M06_HMG2_Capture, 1)
				else
					goalData.pickupWeapons = 1000
					g_enc_reinforcements[table.getn(g_enc_reinforcements)]:SetGoal(goalData)
				end
			else
				g_enc_reinforcements[table.getn(g_enc_reinforcements)]:SetGoal(goalData)
			end
			
			Rule_RemoveMe()
			
		end
		
		
	end
end

A1M06_HMG1_Capture = function ()
	if EGroup_IsEmpty(eg_atgun_reinforce) then
		Rule_RemoveMe()
	elseif Player_CanSeePosition(player1, Marker_GetPosition(mkr_atgun_reinforce)) and Misc_IsPosOnScreen(Marker_GetPosition(mkr_atgun_reinforce), 1.0) then
		Util_StartIntel(EVENTS.GermanMaxim_01)
		FOW_RevealMarker(mkr_atgun_reinforce, 10)
		hint_hmgCapture1 = HintPoint_Add(eg_atgun_reinforce, true, 11007106)
		Rule_AddOneShot(A1M06_removeHmgHint1, 15)
		Rule_AddOneShot(A1M06_HMG1_Capture_delayed, 1)
		Rule_RemoveMe()
	end
end

function A1M06_HMG1_Capture_delayed()
	Cmd_CaptureTeamWeapon(g_HMG1_captureSgroup, eg_atgun_reinforce)
	if not Rule_Exists(A1M06_EnableAIforHMGs) then
		Rule_AddInterval(A1M06_EnableAIforHMGs, 1)
	end
end

A1M06_HMG2_Capture = function ()
	if EGroup_IsEmpty(eg_hmg_reinforce) then
		Rule_RemoveMe()
	elseif Player_CanSeePosition(player1, Marker_GetPosition(mkr_hmg_reinforce)) and Misc_IsPosOnScreen(Marker_GetPosition(mkr_hmg_reinforce), 1.0) then
		Util_StartIntel(EVENTS.GermanMaxim_02)
		FOW_RevealMarker(mkr_hmg_reinforce, 10)
		hint_hmgCapture2 = HintPoint_Add(eg_hmg_reinforce, true, 11007106)
		Rule_AddOneShot(A1M06_removeHmgHint2, 15)
		Rule_AddOneShot(A1M06_HMG2_Capture_delayed, 1)
		Rule_RemoveMe()
	end
end

function A1M06_HMG2_Capture_delayed()
	Cmd_CaptureTeamWeapon(g_HMG2_captureSgroup, eg_hmg_reinforce)
	if not Rule_Exists(A1M06_EnableAIforHMGs) then
		Rule_AddInterval(A1M06_EnableAIforHMGs, 1)
	end
end

function A1M06_removeHmgHint1()
	if hint_hmgCapture1 ~= nil then
		HintPoint_Remove(hint_hmgCapture1)
	end
end

function A1M06_removeHmgHint2()
	if hint_hmgCapture2 ~= nil then
		HintPoint_Remove(hint_hmgCapture2)
	end
end
		
-- Ostruppen capture HMGs, then their AI enables
function A1M06_EnableAIforHMGs()
	if g_enc_atgunReinforce ~= nil and g_enc_hmgReinforce ~= nil then
		Rule_RemoveMe()
	else
		if g_enc_hmgReinforce == nil then
			sg_e_hmgReinforce = SGroup_CreateIfNotFound("sg_e_hmgReinforce")
			Player_GetAllSquadsNearMarker(player2, sg_e_hmgReinforce, mkr_hmg_reinforce, 5)
			SGroup_Filter(sg_e_hmgReinforce, SBP.SOVIET.M1910_MAXIM_HEAVY_MACHINE_GUN_SQUAD, FILTER_KEEP)
			if not SGroup_IsEmpty(sg_e_hmgReinforce) then
				g_enc_hmgReinforce = Encounter:ConvertSgroup(sg_e_hmgReinforce)
				local goalData = {
					name = "Defend",
					range = 40,
					leashRange = 22,
					target = mkr_hmg_reinforce,
					useSkirmishAI = g_useSkirmishAI,
				}
				g_enc_hmgReinforce:SetGoal(goalData)
			end
		end
		if g_enc_atgunReinforce == nil then
			sg_e_atgunReinforce = SGroup_CreateIfNotFound("sg_e_atgunReinforce")
			Player_GetAllSquadsNearMarker(player2, sg_e_atgunReinforce, mkr_atgun_reinforce, 5)
			SGroup_Filter(sg_e_atgunReinforce, SBP.SOVIET.M1910_MAXIM_HEAVY_MACHINE_GUN_SQUAD, FILTER_KEEP)
			if not SGroup_IsEmpty(sg_e_atgunReinforce) then
				g_enc_atgunReinforce = Encounter:ConvertSgroup(sg_e_atgunReinforce)
				local goalData = {
					name = "Defend",
					range = 40,
					leashRange = 22,
					target = mkr_atgun_reinforce,
				}
				g_enc_atgunReinforce:SetGoal(goalData)
			end
		end
	end
end
	
function A1M06_SpawnAttackers(sbp1,sbp2)
--- #ATTACKERS, enemy squads attacking the player during Objective 3
	if g_attackerSpawn1 == nil or g_attackerSpawn1 == mkr_attackerSpawn2 then
		g_attackerSpawn1 = mkr_attackerSpawn1
		g_attackerSpawn2 = mkr_attackerSpawn2
		g_mortarLeash = mkr_mortarLeash2
	elseif g_attackerSpawn1 == mkr_attackerSpawn1 then
		g_attackerSpawn1 = mkr_attackerSpawn2 
		g_attackerSpawn2 = mkr_attackerSpawn1 
		g_mortarLeash = mkr_mortarLeash1
	end

	local data = {
		name = "attacker1",
		player = player2,
		sgroups = {sg_e_all, sg_e_attackers},
		units = {
			{
				sbp = sbp1,
				spawn = g_attackerSpawn1,
			}
		}
	}

	if g_pgUpgrade == 1 and sbp1 == SBP.GERMAN.PANZER_GRENADIER_SQUAD then

	elseif g_pgUpgrade == 2 and sbp1 == SBP.GERMAN.PANZER_GRENADIER_SQUAD then
		data.units[1].upgrades = {UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM}
	end
	table.insert(g_enc_counterAttack, Encounter:Create(data))
	
	local goalData = {
		name = "Attack",
		target = mkr_attackTarget,
		useSkirmishAI = g_useSkirmishAI,
		coordinatedSetup = false,
	}
	if sbp1 == SBP.GERMAN.PANZER_GRENADIER_SQUAD and EGroup_Count(eg_p_hq2) >= 1 then
		-- Tell Panzer Grenadiers to use Bundled Grenades on the player's HQ
		goalData = {
			name = "Ability",
			target = eg_p_hq2,
			range = 50,
			leashRange = 50,
			useSkirmishAI = true,
			abilityParams = {
				abilityPBG = ABILITY.GERMAN.PANZER_GRENADIER_BUNDLED_CAMPAIGN,
			},
			onFailure = A1M06_AddToMainGoal,
			onSuccess = A1M06_AddToMainGoal,
		}
	elseif sbp1 == SBP.GERMAN.GRENADIER_SQUAD then
		goalData.safeMoveWeight = 0.35
		goalData.range = 35
		goalData.tacticCloseGround = 1
	elseif sbp1 == SBP.GERMAN.SCOUTCAR_SDKFZ222 then
		goalData.safeMoveWeight = 0.75
		goalData.range = 45
		goalData.leashRange = 22
		if g_attackerSpawn1 == mkr_attackerSpawn1 then
			goalData.target = mkr_attackTarget_vehicle1
		elseif g_attackerSpawn1 == mkr_attackerSpawn2 then
			goalData.target = mkr_attackTarget_vehicle2
		end
		goalData.tacticControlsList = g_disableVehicleTactic
	end
	
	-- Difficulty Variation: EASY, NORMAL and HARD
	-- Make attackers more "tactical" if player is doing well
	Player_GetAllSquadsNearMarker(player1, sg_p_allNearIke, sector_defense)
	if EGroup_GetAvgHealth(eg_p_hq2) > t_difficulty.hqHealthThreshold and SGroup_Count(sg_p_allNearIke) > t_difficulty.squadsNearbyThreshold then
		goalData.tacticControlsList = {
			{
				tacticType = TACTIC_Recrew,
				priority = 100,
				retryTimeSecs = 4,
				waitTimeSecs = 8,
			},
			{
				tacticType = TACTIC_Pickup,
				priority = 88,
				retryTimeSecs = 4,
				waitTimeSecs = 8,
			},
			{
				tacticType = TACTIC_CaptureTeamWeapon,
				priority = 75,
				retryTimeSecs = 5,
				waitTimeSecs = 10,
			},
			{
				tacticType = TACTIC_Vehicle,
				priority = 50,
				retryTimeSecs = 5,
				waitTimeSecs = 10,
			},
		}
	end
	
	g_enc_counterAttack[table.getn(g_enc_counterAttack)]:SetGoal(goalData)
	
	-----
	data.name = "attacker2"
	data.units = {
		{
				name = "sbp2",
				sbp = sbp2,
				spawn = g_attackerSpawn2,
		}
	}
	if g_hardDiff then
		data.units[1].veterancyRank = World_GetRand(0,2)
	end
	if g_attackWaveCount > 7 then
		data.name = "armor"
		table.insert(g_enc_armor, Encounter:Create(data))
	else
		table.insert(g_enc_counterAttack, Encounter:Create(data))
	end
	
	local goalData = {
		name = "Attack",
		target = mkr_attackTarget, 
		safeMoveWeight = 0, 
		range = 55,
		leashRange = 32,
		coordinatedMoveRadius = 25,
		coordinatedSetup = true,
	}

	if sbp2 == SBP.GERMAN.PANZER_GRENADIER_SQUAD and EGroup_Count(eg_p_hq2) >= 1 then
		-- Tell Panzer Grenadiers to use Bundled Grenades on the player's HQ
		goalData = {
			name = "Ability",
			target = eg_p_hq2,
			range = 50,
			leashRange = 50,
			useSkirmishAI = true,
			abilityParams = {
				abilityPBG = ABILITY.GERMAN.PANZER_GRENADIER_BUNDLED_CAMPAIGN,
			},
			onFailure = A1M06_AddToMainGoal,
			onSuccess = A1M06_AddToMainGoal,
		}
	elseif sbp2 == SBP.GERMAN.SNIPER_SQUAD then
		goalData = {
			name = "Move",
			target = mkr_sniperLeash,
			useSkirmishAI = true,
			range = 10,
		}
	elseif sbp2 == SBP.GERMAN.PANZER_IV_SQUAD or sbp2 == SBP.GERMAN.STUG_III_E_SQUAD or sbp2 == SBP.GERMAN.STUG_III_SQUAD then
		goalData.safeMoveWeight = 0
		goalData.attackMove = false
		goalData.range = 55
		goalData.leashRange = 22
		goalData.tacticControlsList = g_disableVehicleTactic
		if g_attackerSpawn2 == mkr_attackerSpawn1 then
			goalData.target = mkr_attackTarget_vehicle1
		elseif g_attackerSpawn2 == mkr_attackerSpawn2 then
			goalData.target = mkr_attackTarget_vehicle2
		end

		-- Difficulty Variation: EASY, NORMAL and HARD
		-- Make attackers more "tactical" if player is doing well
		Player_GetAllSquadsNearMarker(player1, sg_p_allNearIke, sector_defense)
		if EGroup_GetAvgHealth(eg_p_hq2) > t_difficulty.hqHealthThreshold and SGroup_Count(sg_p_allNearIke) > t_difficulty.squadsNearbyThreshold then
			goalData.tacticControlsList = {
				{
					tacticType = TACTIC_Vehicle,
					maxUsers = 1,
					maxRange = 10,
					retryTimeSecs = 15,
					waitTimeSecs = 30,
					useInitialWaitTime = true,
					priority = 1,
				},
			}
		end
		
		if g_attackWaveCount == 7 or g_attackWaveCount == 9 or g_attackWaveCount == 11 then 
			if not EGroup_IsEmpty(eg_p_hq2) then
				goalData.target = eg_p_hq2
				goalData.leashRange = 50
				goalData.tacticControlsList = g_disableVehicleTactic
			end
		end
	elseif sbp2 == SBP.GERMAN.MORTAR_TEAM_81MM then

		if g_attackWaveCount > 5 then 
			if not EGroup_IsEmpty(eg_p_hq2) then
				goalData.target = eg_p_hq2
				goalData.attackMove = false
				goalData.range = 80
			end
		else
			goalData = {
				name = "Move",
				target = g_mortarLeash,
				useSkirmishAI = true,
				range = 7.5,
			}
		end
		
	end
	if g_attackWaveCount > 7 then
		g_enc_armor[table.getn(g_enc_armor)]:SetGoal(goalData)
	else
		g_enc_counterAttack[table.getn(g_enc_counterAttack)]:SetGoal(goalData)
	end
	ThreatArrow_CreateGroup(sg_e_attackers)
	SGroup_Filter(sg_e_attackers, {SBP.GERMAN.SNIPER_SQUAD, SBP.GERMAN.MORTAR_TEAM_81MM}, FILTER_REMOVE)
	Util_ClearWrecksFromMarker(mkr_clearWrecks1)
	Util_ClearWrecksFromMarker(mkr_clearWrecks2)
end

function A1M06_ClearWrecks()

	Util_ClearWrecksFromMarker(mkr_p4dest_north, 15)

end

function A1M06_AddToMainGoal(enc)
	-- Give "Ability" squads a new goal once they succeed
	if enc:IsAlive() and not SGroup_IsEmpty(enc.sgroup) then
		local goalData = {
			name = "Defend",
			range = 40,
			leashRange = 20,
			target = Util_GetRandomPosition(Util_GetPosition(enc.sgroup),20),
			useSkirmishAI = g_useSkirmishAI,
		}
		enc:SetGoal(goalData)
	end
end
	
_injury_cutToEngineer = function ()
	A1M06_SetupEngineer()
	nis_stop()
	Camera_FocusOnPosition(Marker_GetPosition(mkr_playerStart), false)
end
	
_injury_delayStartSecondObjective = function()
	Objective_Start(OBJ_MoveEngineer)
end	
	
----- PATROLS - halftracks with Panzer Grenadiers spawn in and patrol during objective 2 
function A1M06_SpawnPatrols()
	sg_e_halftracks = SGroup_CreateIfNotFound("sg_e_halftracks")
	
	local data = {
		name = "halftrack1",
		player = player2,
		sgroups = {sg_e_all, sg_e_halftracks},
		units = {
			{
				sbp = SBP.GERMAN.SDKFZ_251_HALFTRACK_SQUAD,
				spawn = mkr_patrol1Spawn,
			}
		}
	}
	g_enc_halftrack1 = Encounter:Create(data)
	
	local goalData = {
		name = "Defend",
		useSkirmishAI = g_useSkirmishAI,
		patrolParams = {
			path = "stormPatrol1",
			wait = 5,
		},

	}
	g_enc_halftrack1:SetGoal(goalData)
	

	-----
	local data = {
		name = "halftrack2",
		player = player2,
		sgroups = {sg_e_all, sg_e_halftracks},
		units = {
			{
				sbp = SBP.GERMAN.SDKFZ_251_HALFTRACK_SQUAD,
				spawn = mkr_patrol2Spawn,
			}
		}
	}
	g_enc_halftrack2 = Encounter:Create(data)
	
	local goalData = {
		name = "Defend",
		useSkirmishAI = g_useSkirmishAI,
		patrolParams = {
			path = "stormPatrol2",
			wait = 5,
		},
	}
	g_enc_halftrack2:SetGoal(goalData)
	
	-----
	local data = {
		name = "halftrack3",
		player = player2,
		sgroups = {sg_e_all, sg_e_halftracks},
		units = {
			{
				sbp = SBP.GERMAN.SDKFZ_251_HALFTRACK_SQUAD,
				spawn = mkr_attackerSpawn1,
			}
		}
	}
	g_enc_halftrack3 = Encounter:Create(data)
	
	local goalData = {
		name = "Defend",
		useSkirmishAI = g_useSkirmishAI,
		patrolParams = {
			path = "stormPatrol3",
			wait = 5,
		},
	}
	g_enc_halftrack3:SetGoal(goalData)
	
	-----
	local data = {
		name = "halftrack4",
		player = player2,
		sgroups = {sg_e_all, sg_e_halftracks},
		units = {
			{
				sbp = SBP.GERMAN.SDKFZ_251_HALFTRACK_SQUAD,
				spawn = mkr_attackerSpawn2
			}
		}
	}
	g_enc_halftrack4 = Encounter:Create(data)
	
	local goalData = {
		name = "Defend",
		useSkirmishAI = g_useSkirmishAI,
		patrolParams = {
			path = "stormPatrol4",
			wait = 5,
		},
	}
	g_enc_halftrack4:SetGoal(goalData)

	Rule_AddOneShot(Obj2_spawnInHalftracks, 1)
	
end

function Obj2_spawnInHalftracks()
	local data = {
		name = "inHalftrack1",
		player = player2,
		sgroups = {sg_e_all},
		units = {
			{
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
				upgrades = {UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM},
				spawn = g_enc_halftrack1.sgroup,
			}
		}
	}
	if g_hardDiff then
		local unit = {
			sbp = SBP.GERMAN.GRENADIER_SQUAD,
			upgrades = {UPG.GERMAN.GRENADIER_MG42_LMG},
			spawn = g_enc_halftrack1.sgroup,
		}
		table.insert(data.units, unit)
	end
	g_enc_inHalftrack1 = Encounter:Create(data)
	
	local data = {
		name = "inHalftrack2",
		player = player2,
		sgroups = {sg_e_all},
		units = {
			{
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
				spawn = g_enc_halftrack2.sgroup,
			}
		}
	}
	if g_hardDiff then
		local unit = {
			sbp = SBP.GERMAN.PIONEER_SQUAD,
			upgrades = {UPG.GERMAN.PIONEER_FLAMETHROWER},
			spawn = g_enc_halftrack2.sgroup,
		}
	end
	g_enc_inHalftrack2 = Encounter:Create(data)
	
	local data = {
		name = "inHalftrack3",
		player = player2,
		sgroups = {sg_e_all},
		units = {
			{
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
				upgrades = {UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM},
				spawn = g_enc_halftrack3.sgroup,
			}
		}
	}
	if g_hardDiff then
		local unit = {
			sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
			upgrades = {UPG.GERMAN.GRENADIER_MG42_LMG},
			spawn = g_enc_halftrack3.sgroup,
		}
		table.insert(data.units, unit)
	end
	g_enc_inHalftrack3 = Encounter:Create(data)
	
	local data = {
		name = "inHalftrack4",
		player = player2,
		sgroups = {sg_e_all},
		units = {
			{
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
				spawn = g_enc_halftrack4.sgroup,
			}
		}
	}
	g_enc_inHalftrack4 = Encounter:Create(data)
	
	g_t_halftracks = {g_enc_halftrack1, g_enc_halftrack2, g_enc_halftrack3, g_enc_halftrack4}
	g_t_storms = {g_enc_inHalftrack1, g_enc_inHalftrack2, g_enc_inHalftrack3, g_enc_inHalftrack4}	

	Rule_AddDelayedInterval(Obj2_HalftrackUnload, 5, 2)	
	
end


-- BASE DEFENSE - Enemies defending the area where Ike is trapped in Objective 2
function A1M06_SpawnBaseDefense()
	sg_e_baseDefense = SGroup_CreateIfNotFound("sg_e_baseDefense")
	local data = {
		name = "baseDefense1",
		player = player2,
		sgroups = {sg_e_all, sg_e_baseDefense},
		units = {
			{
				sbp = SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD,
				spawn = mkr_p_mapentry,
			}
		}
	}
	g_enc_baseDefense1 = Encounter:Create(data)
	
	local goalData = {
		name = "Defend",
		useSkirmishAI = g_useSkirmishAI,
		target = mkr_wire,
		range = 50,
		leashRange = 20,
	}
	g_enc_baseDefense1:SetGoal(goalData)
	
	local data = {
		name = "baseDefense2",
		player = player2,
		sgroups = {sg_e_all, sg_e_baseDefense},
		units = {
			{
				sbp = SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD,
				spawn = mkr_p_mapentry,
			}
		}
	}
	g_enc_baseDefense2 = Encounter:Create(data)
	
	local goalData = {
		name = "Defend",
		useSkirmishAI = g_useSkirmishAI,
		target = mkr_attackTarget,
		range = 60,
		leashRange = 20,
	}
	g_enc_baseDefense2:SetGoal(goalData)
	
	local data = {
		name = "baseDefense3",
		player = player2,
		sgroups = {sg_e_all, sg_e_baseDefense},
		units = {
			{
				sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
				spawn = mkr_p_mapentry,
			}
		}
	}
	g_enc_baseDefense3 = Encounter:Create(data)
	
	local goalData = {
		name = "Defend",
		useSkirmishAI = g_useSkirmishAI,
		target = mkr_p4dest_south,
		range = 35,
		leashRange = 20,
	}
	g_enc_baseDefense3:SetGoal(goalData)
	
	local data = {
		name = "baseDefense4",
		player = player2,
		sgroups = {sg_e_all, sg_e_baseDefense},
		units = {
			{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				upgrades = {UPG.GERMAN.GRENADIER_MG42_LMG},
				spawn = mkr_p_mapentry,
			}
		}
	}
	g_enc_baseDefense4 = Encounter:Create(data)
	
	local goalData = {
		name = "Defend",
		useSkirmishAI = g_useSkirmishAI,
		target = mkr_sniperLeash,
		range = 40,
		leashRange = 20,
	}
	g_enc_baseDefense4:SetGoal(goalData)
	
end

function A1M06_UpdateBaseDefense()
	local goalData = {
		name = "Attack",
		attackMove = true,
		target = mkr_forwardHQ,
		range = 35,
		leashRange = 45,
	}
	if g_enc_baseDefense1 then
		g_enc_baseDefense1:SetGoal(goalData)
	end
	if g_enc_baseDefense2 then
		g_enc_baseDefense2:SetGoal(goalData)
	end
	if g_enc_baseDefense3 then
		g_enc_baseDefense3:SetGoal(goalData)
	end
	if g_enc_baseDefense4 then
		g_enc_baseDefense4:SetGoal(goalData)
	end
end

function Obj2_HalftrackUnload()
	if table.getn(g_t_halftracks) == 0 then
		Rule_RemoveMe()
	else
		for k,v in pairs(g_t_halftracks) do
			if v ~= nil and g_t_storms[k] ~= nil then
				if not SGroup_IsEmpty(v.sgroup) then
					if SGroup_IsUnderAttack(v.sgroup, ANY, 2) then
						Cmd_EjectOccupants(v.sgroup)
						--- Difficulty Variation 2
						--- Give enemy halftracks a healing aura on Normal and Hard
						if not g_easyDiff then
							Cmd_InstantUpgrade(v.sgroup, UPG.GERMAN.SDKFZ_251_HALFTRACK_MOBILE_MEDIC_STATION_UPGRADE)
						end
						local goalData = {
							name = "Defend",
							range = 60,
							target = Util_GetPosition(v.sgroup),
							garrisonIdle = false,
						    tacticControlsList = {
								{
									tacticType = TACTIC_Retaliate,
									priority = 75,
								},
							}
						}
						g_t_storms[k]:SetGoal(goalData)
						table.remove(g_t_halftracks, k)
						table.remove(g_t_storms, k)
						v:SetGoal(goalData)
					end
				elseif SGroup_IsEmpty(v.sgroup) and not SGroup_IsEmpty(g_t_storms[k].sgroup) then
					local goalData = {
						name = "Defend",
						range = 60,
						target = Util_GetPosition(g_t_storms[k].sgroup),
						garrisonIdle = false,
					}
					g_t_storms[k]:SetGoal(goalData)
					table.remove(g_t_halftracks, k)
					table.remove(g_t_storms, k)
				end	
			end
		end
	end
end

----- BONUS OBJECTIVES ------

function Initialize_Objective5()
	-- Retrieve munitions and fuel caches; starts shortly after objective 1
	OBJ_Resources = {
		
		SetupUI = function() 

		end,
		
		OnStart = function()
			Objective_SetAlwaysShowDetails(OBJ_Resources, true, false, false)
			if EGroup_Count(eg_fuelCan) >= 1 then
				ping_fuelCan = Objective_AddUIElements(OBJ_Resources, EGroup_GetPosition(eg_fuelCan), true, 11007729, true, 2)
			end
			if EGroup_Count(eg_ammoBox) >= 1 then
				ping_ammoBox = Objective_AddUIElements(OBJ_Resources, EGroup_GetPosition(eg_ammoBox), true, 11007759, true, 2)
			end
			Rule_AddDelayedInterval(Obj5_IsComplete, 5, 1)
		end,
		
		OnComplete = function()
			if not Player_HasUpgrade(player1, BP_GetUpgradeBlueprint("hq_anti_tank_grenade")) then
				Player_CompleteUpgrade(player1, BP_GetUpgradeBlueprint("hq_anti_tank_grenade"))
			end
			Modify_AbilityMunitionsCost(player1, ABILITY.SOVIET.ANTI_TANK_GRENADE, -5, MUT_Addition)
			Modify_AbilityRechargeTime(player1, ABILITY.SOVIET.ANTI_TANK_GRENADE, 0.75)
			Rule_AddInterval(Obj5_flashATGrenade, 1)
			EventCue_Create(CUE.ATTACKED, 11048220, 11048220, mkr_playerStart, nil, nil, 30)
		end,
		
		OnFail = function()

		end,
		
		IsComplete = function()
			return false
		end,
		
		Intel_Start = EVENTS.StartSecondary,				-- Event will play when obj starts but before any UI appears
		Intel_Complete = EVENTS.ResourcesRetrieved,			-- Event will play when obj completes but before UI is cleared
		Intel_Fail = nil,				-- Event will play when obj fails but before UI is cleared
		Title = 11045311, -- LOCDB [11045311] 'Retrieve munitions and fuel caches'
		Description = 1459051,			-- Objective Description
		TitleEnd = 11045312, -- LOCDB [11045312] 'Resource caches recovered'
		TitleFail = nil,			-- Failed Title
		Type = OT_Secondary,				-- Objective Type (OT_Primary, OT_Secondary)

	}
	
	Objective_Register(OBJ_Resources)

end

function Obj5_flashATGrenade()
	local player1Squads = Player_GetSquads(player1)
	SGroup_Filter(player1Squads, {SBP.SOVIET.CONSCRIPT_SQUAD, SBP.SOVIET.BASE_CONSCRIPT_SQUAD, SBP.SOVIET.PENAL_BATTALION}, FILTER_KEEP)
	if Misc_IsSGroupSelected(player1Squads, ANY) then
		flashID_atGrenade = UI_FlashAbilityButton(ABILITY.SOVIET.ANTI_TANK_GRENADE, true)
		Rule_AddOneShot(_removeATGrenadeFlash, 10)
		Rule_RemoveMe()
	end
end

_removeATGrenadeFlash = function ()
	UI_StopFlashing(flashID_atGrenade)
end

function Obj5_IsComplete()
	-- Complete objective if munitions and fuel pickups are collected
	if EGroup_IsEmpty(eg_fuelCan) and EGroup_IsEmpty(eg_ammoBox) then
		Objective_Complete(OBJ_Resources)
		Rule_RemoveMe()
	else
		if EGroup_IsEmpty(eg_fuelCan)and ping_fuelCan ~= nil then
			Objective_RemoveUIElements(OBJ_Resources, ping_fuelCan)
		end
		if EGroup_IsEmpty(eg_ammoBox) and ping_ammoBox ~= nil then
			Objective_RemoveUIElements(OBJ_Resources, ping_ammoBox)
		end
	end
end
	
---

function Initialize_Objective6()

	OBJ_Weapons = {
		-- Retrieve mortar and MG42 team weapons; starts after objective, when weapons are spotted. May not start at all depending on player movement.
		SetupUI = function() 

		end,
		
		OnStart = function()
			Objective_SetAlwaysShowDetails(OBJ_Weapons, true, false, false)
			ping_HMGs = Objective_AddUIElements(OBJ_Weapons, EGroup_GetPosition(eg_HMGs), true)
			ping_mortars = Objective_AddUIElements(OBJ_Weapons, EGroup_GetPosition(eg_mortars), true)
			Rule_AddDelayedInterval(Obj6_IsComplete, 5, 1)
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
		Title = 11045313,	-- LOCDB [11045313] 'Retrieve mortar and MG42 team weapons'
		Description = 1459051,			-- Objective Description
		TitleEnd = 11045314, -- LOCDB [11045314] 'Team weapons recovered'
		TitleFail = nil,			-- Failed Title
		Type = OT_Secondary,				-- Objective Type (OT_Primary, OT_Secondary)
	}
	
	Objective_Register(OBJ_Weapons)

end

function Obj6_IsComplete()
	if (EGroup_Count(eg_HMGs) < 2) and (EGroup_Count(eg_mortars) < 2) then
		Objective_Complete(OBJ_Weapons)
		Rule_RemoveMe()
	else
		if (EGroup_Count(eg_HMGs) < 2) and ping_HMGs ~= nil then
			Objective_RemoveUIElements(OBJ_Weapons, ping_HMGs)
		end
		if (EGroup_Count(eg_mortars) < 2) and ping_mortars ~= nil then
			Objective_RemoveUIElements(OBJ_Weapons, ping_mortars)
		end
	end
end	

-- Force-construct a forward base when the player completes objective 2 (reaches Wounded Isakovich)
function Obj3_buildForwardBase()
	sg_p_tempEngineers1 = SGroup_CreateIfNotFound("sg_p_tempEngineers1")
	sg_p_tempEngineers2 = SGroup_CreateIfNotFound("sg_p_tempEngineers2")
	sg_p_tempEngineers3 = SGroup_CreateIfNotFound("sg_p_tempEngineers3")
	Util_CreateSquads(player3, sg_p_tempEngineers1, SBP.SOVIET.COMBAT_ENGINEER_SQUAD, mkr_base1, nil, 1, 2)
	Util_CreateSquads(player3, sg_p_tempEngineers2, SBP.SOVIET.COMBAT_ENGINEER_SQUAD, mkr_base2, nil, 1, 2)
	Util_CreateSquads(player3, sg_p_tempEngineers3, SBP.SOVIET.COMBAT_ENGINEER_SQUAD, mkr_base3, nil, 1, 2)
	SGroup_SetInvulnerable(sg_p_tempEngineers1, true)
	SGroup_SetInvulnerable(sg_p_tempEngineers2, true)
	SGroup_SetInvulnerable(sg_p_tempEngineers3, true)
	SGroup_SetSelectable(sg_p_tempEngineers1, false)
	SGroup_SetSelectable(sg_p_tempEngineers2, false)
	SGroup_SetSelectable(sg_p_tempEngineers3, false)
	SGroup_EnableUIDecorator(sg_p_tempEngineers1, false)
	SGroup_EnableUIDecorator(sg_p_tempEngineers2, false)
	SGroup_EnableUIDecorator(sg_p_tempEngineers3, false)
	Modify_EntityBuildTime(player3, EBP.SOVIET.BARRACKS, 0.5)
	Modify_EntityBuildTime(player3, EBP.SOVIET.WEAPON_SUPPORT_CENTER, 0.5)
	Modify_EntityBuildTime(player3, EBP.SOVIET.MOTORPOOL, 0.5)
	eg_p_obstructions = EGroup_CreateIfNotFound("eg_p_obstructions")
	Player_GetAllEntitiesNearMarker(player1, eg_p_obstructions, mkr_base1)
	EGroup_DestroyAllEntities(eg_p_obstructions)
	Player_GetAllEntitiesNearMarker(player1, eg_p_obstructions, mkr_base2)
	EGroup_DestroyAllEntities(eg_p_obstructions)
	Player_GetAllEntitiesNearMarker(player1, eg_p_obstructions, mkr_base3)
	EGroup_DestroyAllEntities(eg_p_obstructions)
	Cmd_Construct(sg_p_tempEngineers1, EBP.SOVIET.MOTORPOOL, mkr_base1)
	Cmd_Construct(sg_p_tempEngineers2, EBP.SOVIET.WEAPON_SUPPORT_CENTER, mkr_base2)
	Cmd_Construct(sg_p_tempEngineers3, EBP.SOVIET.BARRACKS, mkr_base3)
	eg_p_forwardBase = EGroup_CreateIfNotFound("eg_p_forwardBase")
	Rule_AddDelayedInterval(Obj3_retryBuildForwardBase, 4, 1)
end

function Obj3_retryBuildForwardBase()
	if not SGroup_IsConstructingBuilding(sg_p_tempEngineers1, ANY) then
		if not SGroup_IsEmpty(sg_p_tempEngineers1) then
			Player_ClearArea(player1, mkr_base1, false)
			Cmd_Construct(sg_p_tempEngineers1, EBP.SOVIET.MOTORPOOL, mkr_base1)
		end
	end
	if not SGroup_IsConstructingBuilding(sg_p_tempEngineers2, ANY) then
		if not SGroup_IsEmpty(sg_p_tempEngineers2) then
			Player_ClearArea(player1, mkr_base2, false)
			Cmd_Construct(sg_p_tempEngineers2, EBP.SOVIET.WEAPON_SUPPORT_CENTER, mkr_base2)
		end
	end
	if not SGroup_IsConstructingBuilding(sg_p_tempEngineers3, ANY) then
		if not SGroup_IsEmpty(sg_p_tempEngineers3) then
			Player_ClearArea(player1, mkr_base3, false)
			Cmd_Construct(sg_p_tempEngineers3, EBP.SOVIET.BARRACKS, mkr_base3)
		end
	end

	Player_GetAllEntitiesNearMarker(player3, eg_p_forwardBase, mkr_base1, 6)
	if not EGroup_IsEmpty(eg_p_forwardBase) then
		EGroup_Filter(eg_p_forwardBase, EBP.SOVIET.MOTORPOOL, FILTER_KEEP)
		EGroup_FilterUnderConstruction(eg_p_forwardBase, FILTER_REMOVE)
		if not EGroup_IsEmpty(eg_p_forwardBase) and not SGroup_IsEmpty(sg_p_tempEngineers1) then
			EGroup_SetPlayerOwner(eg_p_forwardBase, player1)
			SGroup_DestroyAllSquads(sg_p_tempEngineers1)
			EGroup_SetRallyPoint(eg_p_forwardBase, Marker_GetPosition(mkr_rally2))
		end
	end
	Player_GetAllEntitiesNearMarker(player3, eg_p_forwardBase, mkr_base2, 6)
	if not EGroup_IsEmpty(eg_p_forwardBase) then
		EGroup_Filter(eg_p_forwardBase, EBP.SOVIET.WEAPON_SUPPORT_CENTER, FILTER_KEEP)
		EGroup_FilterUnderConstruction(eg_p_forwardBase, FILTER_REMOVE)
		if not EGroup_IsEmpty(eg_p_forwardBase) and not SGroup_IsEmpty(sg_p_tempEngineers2) then
			EGroup_SetPlayerOwner(eg_p_forwardBase, player1)
			SGroup_DestroyAllSquads(sg_p_tempEngineers2)
			EGroup_SetRallyPoint(eg_p_forwardBase, Marker_GetPosition(mkr_rally2))
		end
	end
	Player_GetAllEntitiesNearMarker(player3, eg_p_forwardBase, mkr_base3, 6)
	if not EGroup_IsEmpty(eg_p_forwardBase) then
		EGroup_Filter(eg_p_forwardBase, EBP.SOVIET.BARRACKS, FILTER_KEEP)
		EGroup_FilterUnderConstruction(eg_p_forwardBase, FILTER_REMOVE)
		if not EGroup_IsEmpty(eg_p_forwardBase) and not SGroup_IsEmpty(sg_p_tempEngineers3) then
			EGroup_SetPlayerOwner(eg_p_forwardBase, player1)
			SGroup_DestroyAllSquads(sg_p_tempEngineers3)
			EGroup_SetRallyPoint(eg_p_forwardBase, Marker_GetPosition(mkr_rally2))
		end
	end
	if SGroup_IsEmpty(sg_p_tempEngineers1) and SGroup_IsEmpty(sg_p_tempEngineers2) and SGroup_IsEmpty(sg_p_tempEngineers3) then
		Rule_RemoveMe()
	end
end

------- EVENTS and adventures -------
--- Ambient and flavor events -------

function A1M06_AddAmbientEvents()
	Rule_AddDelayedInterval(Ambient_StukaInTownSquare, 5, 3)
	Rule_AddDelayedInterval(Ambient_arty1, 5, 3)
	Rule_AddDelayedInterval(Ambient_arty2, 5, 3)
	Rule_AddDelayedInterval(Ambient_arty3, 5, 3)
	Rule_AddDelayedInterval(Ambient_FlavorSpeech1, 30, 10)
	Rule_AddOneShot(A1M06_mortarsForShow, 25)
	g_drivebyCount = 0
	Rule_AddOneShot(Ambient_DrivebyTanks, 10)
	Rule_AddDelayedInterval(_driveby_spottedSpeech, 20, 2)
	sg_p_ambientArty = SGroup_CreateIfNotFound("sg_p_ambientArty")
	sg_e_introSniper = SGroup_CreateIfNotFound("sg_e_introSniper")
	Util_CreateSquads(player2, sg_e_introSniper, SBP.GERMAN.SNIPER_SQUAD, mkr_introSniper)
	SGroup_SetInvulnerable(sg_e_introSniper, 0.1)
	Entity_SetInvulnerableToCritical(Squad_EntityAt(SGroup_GetRandomSpawnedSquad(sg_e_introSniper), 0), true)
	Rule_AddInterval(A1M06_RemoveIntroSniper, 1)
end

function A1M06_RemoveIntroSniper()
	if SGroup_IsEmpty(sg_e_introSniper) then
		Rule_RemoveMe()
	elseif SGroup_IsUnderAttackByPlayer(sg_e_introSniper, player1, 1) or Prox_ArePlayersNearMarker(player1, mkr_introSniper, ANY, 25) then
		Util_ApplyModifier(sg_e_introSniper, "camouflage_enable", -1, MUT_Enable)
		Util_ApplyModifier(sg_e_introSniper, "posture_speed_modifier", 1, MUT_Addition)
		Modify_ReceivedAccuracy(sg_e_introSniper, 0.0001, true)
		Cmd_MoveToAndDespawn(sg_e_introSniper, mkr_sniperDespawn, false)
		Rule_RemoveMe()
	elseif Player_CanSeePosition(player1, Marker_GetPosition(mkr_mortar1)) or Player_CanSeePosition(player1, Marker_GetPosition(mkr_reinforce1Spawn)) then
		Util_ApplyModifier(sg_e_introSniper, "camouflage_enable", -1, MUT_Enable)
		Util_ApplyModifier(sg_e_introSniper, "posture_speed_modifier", 1, MUT_Addition)
		Modify_ReceivedAccuracy(sg_e_introSniper, 0.0001, true)
		Cmd_MoveToAndDespawn(sg_e_introSniper, mkr_sniperDespawn, false)
		Rule_RemoveMe()
	end
end

--- #1. Damaged German tanks driving down the main road
--- These tanks have the "destroyed main gun" critical, and only Stug_iii_e can become abandoned.
function Ambient_DrivebyTanks()
	sg_driveby = SGroup_CreateIfNotFound("sg_driveby")
	local spawnMarker = mkr_attackerSpawn1
	local path = "driveby1"
	local deleteMarker = mkr_attackerSpawn2
	local t_tanks = {SBP.GERMAN.STUG_III_E_SQUAD, SBP.GERMAN.STUG_III_SQUAD, SBP.GERMAN.STUG_III_SQUAD, SBP.GERMAN.PANZER_IV_SQUAD}
	if g_drivebyIndex == nil or g_drivebyIndex == 2 then
		g_drivebyIndex = 1
	else
		g_drivebyIndex = 2
		spawnMarker = mkr_attackerSpawn2
		path = "driveby2"
		deleteMarker = mkr_attackerSpawn1
	end
	if SGroup_IsEmpty(sg_driveby) and not Objective_IsComplete(OBJ_FindSnipers) then
		local sbp = Table_GetRandomItem(t_tanks)
		Util_CreateSquads(player2, sg_driveby, sbp, spawnMarker)
		g_drivebyCount = g_drivebyCount + 1
		local entity = Squad_EntityAt(SGroup_GetRandomSpawnedSquad(sg_driveby), 0)
		Entity_ApplyCritical(entity, CRIT.VEHICLE_DESTROY_MAINGUN, 0)
		SGroup_SetAvgHealth(sg_driveby, World_GetRand(25, 75)/100)
		Cmd_SquadPath(sg_driveby, path, false, LOOP_NONE, false, 10)
		g_drivebyDeleteMarker = deleteMarker
		if sbp ~= SBP.GERMAN.STUG_III_E_SQUAD then
			Cmd_InstantUpgrade(sg_driveby, BP_GetUpgradeBlueprint("upgrade/campaign/disable_abandon_critical_squad"))
		end
		Rule_AddInterval(_driveby_deleteSquad, 1)
	end
end

_driveby_deleteSquad = function ()
	if Prox_AreSquadsNearMarker(sg_driveby, g_drivebyDeleteMarker, ANY) or SGroup_IsEmpty(sg_driveby) then
		SGroup_DestroyAllSquads(sg_driveby)
		Rule_RemoveMe()
		Rule_RemoveIfExist(Ambient_DrivebyTanks)
		local player1Squads = Player_GetSquads(player1)
		if (not Objective_IsComplete(OBJ_FindSnipers)) and (not SGroup_ContainsBlueprints(player1Squads, SBP.GERMAN.STUG_III_E_SQUAD, ANY)) then
			if g_drivebyCount <= 16 then
				if g_hardDiff then
					Rule_AddOneShot(Ambient_DrivebyTanks, World_GetRand(30, 60))
				else
					Rule_AddOneShot(Ambient_DrivebyTanks, World_GetRand(10, 20))
				end
			end
		end
	end
end

_driveby_spottedSpeech = function ()
	if Player_CanSeeSGroup(player1, sg_driveby, ANY) and SGroup_IsOnScreen(player1, sg_driveby, ANY, 0.8) then
		Util_StartIntel(EVENTS.GermanTanks)
		Rule_RemoveMe()
	end
end

--- #2. Stuka bomb falls in the town square
--- If Player1 is close to the statue and Player2 is not, drop a Stuka bomb.
function Ambient_StukaInTownSquare()
	if not Event_IsAnyRunning() then
		if Player_CanSeePosition(player1, Marker_GetPosition(mkr_mortar3)) and not Player_CanSeePosition(player2, Marker_GetPosition(mkr_mortar3)) then
			EventCue_Create(CUE.ATTACKED, 11036242, 11036242, mkr_mortar3, nil, nil, 30)
			Util_StartIntel(EVENTS.StukaBomber)
			Rule_RemoveMe()
			Rule_AddInterval(__dropWarningSmoke, 1)
		end
	end
end

__dropWarningSmoke = function ()
	if Misc_IsPosOnScreen(Marker_GetPosition(mkr_mortar3), 0.8) then
		Cmd_Ability(player2, ABILITY.GERMAN.GERMAN_WARNING_SMOKE, Marker_GetPosition(mkr_mortar3), nil, true)
		Rule_AddOneShot(__dropStukaBomb, 4)
		Rule_RemoveMe()
	end
end

__dropStukaBomb = function()
	FOW_RevealMarker(mkr_mortar3, 15)
	Cmd_Ability(player2, ABILITY.GERMAN.STUKA_BOMBING_STRIKE, Marker_GetPosition(mkr_mortar3), nil, true)
	eg_stukaStrat = EGroup_CreateIfNotFound("eg_stukaStrat")
	World_GetNeutralEntitiesNearMarker(eg_stukaStrat, mkr_mortar3)
	EGroup_Filter(eg_stukaStrat, BP_GetEntityBlueprint("territory_point"), FILTER_KEEP)
	EGroup_InstantCaptureStrategicPoint(eg_stukaStrat, player2)
end

--- #3 Arty on world objects
--- Single artillery hits on a few world objects when the player is near
function Ambient_arty1()
	if Prox_ArePlayersNearMarker(player1, mkr_ambientArty1, ANY, 20) then
		Player_GetAllSquadsNearMarker(player1, sg_p_ambientArty, mkr_ambientArty1, 30)
		if Misc_IsPosOnScreen(Marker_GetPosition(mkr_ambientArty1), 0.8) and SGroup_IsDoingAttack(sg_p_ambientArty, ANY, 3) then
			Cmd_Ability(player2, ABILITY.GLOBAL.OFF_MAP_ARTY_SINGLE_SHOT_INSTANT, Marker_GetPosition(mkr_ambientArty1), nil, true)
			Rule_RemoveMe()
		end
	end
end

function Ambient_arty2()
	if Prox_ArePlayersNearMarker(player1, mkr_ambientArty2, ANY, 20) then
		Player_GetAllSquadsNearMarker(player1, sg_p_ambientArty, mkr_ambientArty2, 30)
		if Misc_IsPosOnScreen(Marker_GetPosition(mkr_ambientArty2), 0.8) and SGroup_IsDoingAttack(sg_p_ambientArty, ANY, 3) then
			Cmd_Ability(player2, ABILITY.GLOBAL.OFF_MAP_ARTY_SINGLE_SHOT_INSTANT, Marker_GetPosition(mkr_ambientArty2), nil, true)
			Rule_RemoveMe()
		end
	end
end

function Ambient_arty3()
	if Prox_ArePlayersNearMarker(player1, mkr_ambientArty3, ANY, 30) then
		Player_GetAllSquadsNearMarker(player1, sg_p_ambientArty, mkr_ambientArty3, 35)
		if Misc_IsPosOnScreen(Marker_GetPosition(mkr_ambientArty3), 0.8) and SGroup_IsDoingAttack(sg_p_ambientArty, ANY, 3) then
			Cmd_Ability(player2, ABILITY.GLOBAL.OFF_MAP_ARTY_SINGLE_SHOT_INSTANT, Marker_GetPosition(mkr_ambientArty3), nil, true)
			Rule_RemoveMe()
		end
	end
end

-- Silly ambient speech events from JT
-- These are just for flavor. 
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
			Sound_PlayOnSquad("speech/sp/mission/m06/11046839", player1Squads)
			Rule_RemoveMe()
			Rule_AddDelayedInterval(Ambient_FlavorSpeech2, 45, 10)
		end
	end
end

function Ambient_FlavorSpeech2()
	local player1Squads = Player_GetSquads(player1)
	if SGroup_IsUnderAttack(player1Squads, ANY, 10) == false and SGroup_IsDoingAttack(player1Squads, ANY, 10) == false then
		local f = function (gid, idx, sid) 
			if not Misc_IsSquadOnScreen(sid, 0.75) then
				SGroup_Remove(player1Squads, sid)
			end
		end
		SGroup_ForEach(player1Squads, f)
		if not SGroup_IsEmpty(player1Squads) and not Event_IsAnyRunning() then
			Sound_PlayOnSquad("speech/sp/mission/m06/11046840", player1Squads)
			Rule_RemoveMe()
		end
	end
end

-- Suppressing mortars fall around the map, at a safe distance from player squads
function A1M06_mortarsForShow()
	t_mortarTargets = {mkr_mortar1, mkr_mortar2, mkr_mortar3, mkr_mortar4, mkr_mortar5, mkr_mortar6, mkr_mortar7}
	local target = t_mortarTargets[World_GetRand(1,7)]
	if not Prox_AreSquadsNearMarker(SGroup_FromName("__Player1000Squads"), target, ANY, 25) then
		Cmd_Ability(player2, ABILITY.SOVIET.MORTAR_EXPLOSION_FX, Util_GetRandomPosition(target), nil, true)
	end
	Rule_RemoveIfExist(A1M06_mortarsForShow)
	Rule_AddOneShot(A1M06_mortarsForShow, World_GetRand(10, 30))
end

-- Ally conscripts on the map and in combat at mission start; they die pretty quickly
function A1M06_alliesForShow()
	g_enc_allies = {}
	sg_a_all = SGroup_CreateIfNotFound("sg_a_all")
	local data = {
		name = "ally1",
		player = player3,
		sgroups = {sg_a_all},
		units = {
			{
				sbp = SBP.SOVIET.CONSCRIPT_SQUAD,
				spawn = mkr_allySpawn3,
				load = 6,
			}
		}
	}
	table.insert(g_enc_allies, Encounter:Create(data))
	
	local goalData = {
		name = "Defend",
		useSkirmishAI = g_useSkirmishAI,
		pickupWeapons = -1,
		garrisonIdle = false,
	}
	g_enc_allies[1]:SetGoal(goalData)
	
	Modify_WeaponDamage(sg_a_all, "hardpoint_01", 0.001)
	Modify_ReceivedDamage(g_enc_allies[1].sgroup, 0.2)

end	

------- TEST / CHEATS --------

function SkipObjective(num)
	Player_GetAll(player1)
	if num >= 1 then
		SGroup_Kill(sg_e_snipers)
		SGroup_Kill(sg_e_secSnipers)
	end
	if num >= 2 then
		function _skipObjective_num2()
			Rule_RemoveIfExist(Obj2_IsComplete)
			Objective_Complete(OBJ_MoveEngineer)
			SGroup_WarpToPos(sg_allsquads, World_Pos(93.6,11.6,-16.7))
			Camera_FocusOnPosition(Marker_GetPosition(mkr_isakovich), false)
			EGroup_Kill(eg_wire)
			SGroup_DestroyAllSquads(sg_e_all)
		end
		Rule_AddOneShot(_skipObjective_num2, 5)
	end
end

----- ACHIEVEMENTS -----

-- Kill at least 3 snipers with an M3A1 Scout Car
function Achievement_ScoutVsSniper(sid)
	Squad_GetLastAttacker(sid, sg_p_m3a1)
	SGroup_Filter(sg_p_m3a1, SBP.SOVIET.M3A1_SCOUT_CAR_SQUAD, FILTER_KEEP)
	if SGroup_IsEmpty(sg_p_m3a1) == false then
		g_m3a1_snipersKilled = g_m3a1_snipersKilled + 1
	end
	if g_m3a1_snipersKilled == 3 then
		Scar_CompleteIntelBulletinTask(player1, "camp06_aftermath_scoutcar")
		Rule_RemoveSGroupEvent(Achievement_ScoutVsSniper, sg_e_snipers)
		Rule_RemoveSGroupEvent(Achievement_ScoutVsSniper, sg_e_secSnipers)
	end
end

function Achievement_startM3A1KillCount()
	sg_p_m3a1 = SGroup_CreateIfNotFound("sg_p_m3a1")
	g_m3a1_snipersKilled = 0
	Rule_AddSGroupEvent(Achievement_ScoutVsSniper, sg_e_snipers, GE_SquadKilled)
	Rule_AddSGroupEvent(Achievement_ScoutVsSniper, sg_e_secSnipers, GE_SquadKilled)
end

-- Destroy all the German halftracks that spawn after Objective 1
function Achievement_DestroyHalftracks()
	if SGroup_IsEmpty(sg_e_halftracks) then
		Scar_CompleteIntelBulletinTask(player1, "camp06_aftermath_halftrack")
	end
end

-- Complete the mission with at least 50 percent HQ integrity on Hard difficulty 
function Achievement_DefendForwardHQ()
	if g_hardDiff and (g_hqHealth >= 50) then
		Scar_CompleteIntelBulletinTask(player1, "camp06_aftermath_defense")
	end
end
