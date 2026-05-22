-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- m11_Behind_Enemy_Lines
-------------------------------------------------------------------------
-------------------------------------------------------------------------
import("ScarUtil.scar")
import("Prototype/DeploymentPoints.scar")
import("Systems/AiManager/ai.scar")
import("Events.scar")
import("Beginner.scar") 
import("Global_Values/CampaignGlobalConstants.scar")

-------------------------------------------------------------------------
-- [[ SETUP ]]
-------------------------------------------------------------------------
function OnGameSetup()
	-- Required Players
	player1 = Setup_Player(1, 11036895, "soviet", 1)		-- LOCDB [11036895] 'Armia Krajowa'
	player2 = Setup_Player(2, 11040339, "german", 2)		-- LOCDB [11040339] '35th Infantry Division'
	player3 = Setup_Player(3, 11037047, "soviet", 1)  -- LOCDB [11037047] 'Partisan allies'
	player4 = Setup_Player(4, 11041924, "soviet", TEAM_NEUTRAL) -- LOCDB [11041924] 'Informant Team'
	player5 = Setup_Player(5, 11037048, "soviet", TEAM_NEUTRAL) -- LOCDB [11037048] 'Partisans'
end

function OnGameRestore()	
	-- function takes care of restoring all global mission parameters after a save/load
	player1 = World_GetPlayerAt(1)
	player2 = World_GetPlayerAt(2)
    player3 = World_GetPlayerAt(3)
	player4 = World_GetPlayerAt(4)
	player5 = World_GetPlayerAt(5)
	
	Game_DefaultGameRestore()
end



-------------------------------------------------------------------------
-- [[ ONINIT ]]
-------------------------------------------------------------------------
function OnInit()
	--[[ PRESET DEBUG CONDITIONS ]]
	Init_Debug()
	
	--[[ SET RESTRICTIONS ]]
	Init_Restrictions()
	
	--[[ SET DIFFICULTY ]]
	Init_Difficulty()
	
	--[[ MISSION PRESETS ]]
	Init_MissionSetup() 
	
	--[[ PLAY INTRO NIS]]
	Game_StartMuted(true)
	Game_FadeToBlack(FADE_OUT, 0)
	
	Util_StartIntel(EVENTS.NIS_Intro)
	
	--[[ REGISTER OBJECTIVES ]]
	Initialize_ObjectiveKillOfficers()
	Initialize_ObjectiveAniaIsakovichMustSurvive()
	Initialize_ObjectiveCaptureInformant()
	Initialize_ObjectiveHelpPrisoners()
	Initialize_ObjectiveEscape()
	Initialize_ObjectiveCaptureInformantSubGetToCamp()
	Initialize_ObjectiveCaptureInformantSubSecureInformant()
	Initialize_ObjectiveCaptureInformantSubProtectAnia()
	Initialize_ObjectiveEscapeSquadCounter()
	Initialize_ObjectiveDestroyRadio()
	--[[ GAME START CHECK ]]
	
	Event_NarrativeEventsNotRunning(IntroNislet_Start)
end
Scar_AddInit(OnInit)

function Init_Debug()	 
	-- looks for the command line option [-debug]
	if Misc_IsCommandLineOptionSet("debug") then 
		g_debug = true
	end 
	if Misc_IsCommandLineOptionSet("dev") then
		Scar_DebugConsoleExecute("bind([[CONTROL+SPACE]], [[Scar_DoString('_skip()')]])")
	end
	

end

function Init_Restrictions()
	Player_SetAbilityAvailability(player1, ABILITY.SOVIET.SNIPER_SUPPRESSION_FIRE_ABILITY, ITEM_UNLOCKED)
	Player_SetAbilityAvailability(player1, ABILITY.SOVIET.SNIPER_FIRE_FLARES_ABILITY, ITEM_UNLOCKED)

	Player_SetAbilityAvailability(player1, ABILITY.SOVIET.SNIPER_IN_COVER_AUTO_CAMOUFLAGE, ITEM_UNLOCKED)
	Player_SetAbilityAvailability(player1, ABILITY.SOVIET.SNIPER_SUPPRESSION_FIRE_ABILITY, ITEM_UNLOCKED)
	Player_SetUpgradeAvailability(player1, UPG.SOVIET.ENGINEER_FLAMETHROWER, ITEM_UNLOCKED)

	
	Player_SetAbilityAvailability(player1, ABILITY.SOVIET.BASE_CONSCRIPT_DISPATCH, ITEM_REMOVED)
	Player_AddAbility(player2,ABILITY.GLOBAL.SP_SINGLE_SHOT_MORTAR)
	
	Player_CompleteUpgrade(player1,BP_GetUpgradeBlueprint("hq_anti_tank_grenade"))
end

function Init_Difficulty()
	-- Shorthand for Easy and Hard until UI settings and enums are working correctly
	g_easyDiff = Misc_IsCommandLineOptionSet("easy") or Game_GetSPDifficulty() == GD_EASY
	g_hardDiff = Misc_IsCommandLineOptionSet("hard") or Game_GetSPDifficulty() == GD_HARD
	
	campaignDifficulty = Game_GetSPDifficulty()
	
	Modify_ProjectileDelayTime(player2, BP_GetEntityBlueprint("bundled_stielgranate_campaign"), CAMPAIGN_PGREN_BUNDLED_TIMER)
	
	-- Default Attack goal data
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
				tacticType = TACTIC_RushAtTarget,
				priority = 10,
				retryTimeSecs = 8,
				waitTimeSecs = 20,
			},		
			{
				tacticType = TACTIC_Ability,
				priority = 400,
				maxUsers = 4,
				maxRange = 50,
				waitTimeSecs = 5,
				retryTimeSecs = 3,
			},
		},		
	}
	
	-- Default defend goal data
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
				tacticType = TACTIC_Ability,
				priority = 20,
				maxUsers = 4,
				maxRange = 40,
				waitTimeSecs = 5,
				retryTimeSecs = 3,
			},	
		},
	}

	-- Set modifiers/multipliers for local Attack goal data -- EASY
	t_modifyGoalData_attackEasy = { 
		range_Multiplier = 0.9,
		movePathLengthFactor_Multiplier = 0.8,
		safeMoveWeight_Multiplier = 0.75,
	}
	-- Set modifiers/multipliers for local Attack goal data -- HARD
	t_modifyGoalData_attackHard = { 		
		range_Multiplier = 1.2,
		movePathLengthFactor_Multiplier = 1.2,
		leashRange_Multiplier = 1.2,
		safeMoveWeight_Multiplier = 1.25,
		fallbackParams = 
		{
			thresholds_Multiplier = 0.5,
		},
	}
	-- Set modifiers/multipliers for local Defend goal data -- EASY
	t_modifyGoalData_defendEasy = { 
		range_Multiplier = 0.9,
		leashRange_Multiplier = 0.9,
		maxAttackers_Multiplier = -2,
		safeMoveWeight_Multiplier = 0.75,
	}
	-- Set modifiers/multipliers for local Defend goal data -- HARD
	t_modifyGoalData_defendHard = { 
		range_Multiplier = 1.2,
		movePathLengthFactor_Multiplier = 1.2,
		leashRange_Multiplier = 1.2,
		safeMoveWeight_Multiplier = 1.25,
	}

	
	-- Difficulty table; you can use this for non-AI stuff too, like timers and counters
	t_difficulty = { 
		defaultAttackGoalData 	= Util_DifVar( {t_defaultGoalData_attackEasy, {}, t_defaultGoalData_attackHard, {}}),
		defaultDefendGoalData 	= Util_DifVar( {t_defaultGoalData_defendEasy, {}, t_defaultGoalData_defendHard, {}}),
		modifyAttackGoalData	= Util_DifVar( {t_modifyGoalData_attackEasy, {}, t_modifyGoalData_attackHard, {}}),
		modifyDefendGoalData	= Util_DifVar( {t_modifyGoalData_defendEasy, t_modifyGoalData_defendNormal, t_modifyGoalData_defendHard, {}}),
	}
	
	-- Apply default goal data
	AIAttackGoal_AdjustDefaultGoalData(t_difficulty.defaultAttackGoalData)
	AIDefendGoal_AdjustDefaultGoalData(t_difficulty.defaultDefendGoalData)	
	
	-- Apply modifiers/multipliers to existing goal data
	AIAttackGoal_SetModifyGoalData(t_difficulty.modifyAttackGoalData)
	AIDefendGoal_SetModifyGoalData(t_difficulty.modifyDefendGoalData)
	
	-- Disable some of the nastier Grenadier abilities on EASY
	if g_easyDiff then
		Player_SetAbilityAvailability(player2, ABILITY.GERMAN.GRENADIER_PANZERFAUST, ITEM_REMOVED)
		Player_SetAbilityAvailability(player2, ABILITY.GERMAN.GRENADIER_RIFLE_GRENADE_ABILITY, ITEM_REMOVED)
	end
	
	t_Resource_difficulty = {		
		starting_manpower = Util_DifVar( {310,250,62.5,0 } ), 	-- Easy, Medium, Hard, Hardest
		starting_fuel = Util_DifVar( {300,200,100 ,50} ), 	-- Easy, Medium, Hard, Hardest
		starting_munition = Util_DifVar( {220,100 ,60,30} ), 	-- Easy, Medium, Hard, Hardest
	}
	
	----infirmary not available in hard mode
	if g_hardDiff then
		EGroup_DeSpawn(eg_hospital)
		EGroup_DeSpawn(eg_hospital_informant)
	end
	
	if g_easyDiff then
		Player_SetAbilityAvailability(player2, ABILITY.GERMAN.PANZER_GRENADIER_BUNDLED_CAMPAIGN, ITEM_REMOVED)
	else
		Player_SetAbilityAvailability(player2, ABILITY.GERMAN.PANZER_GRENADIER_BUNDLED_CAMPAIGN, ITEM_UNLOCKED)
	end
	
	----- health for squads
	if g_easyDiff then
		local health_modifier = Modifier_Create(MAT_EntityType, "modifiers\\health_maximum_modifier.lua", MUT_Multiplication, false, 1.5, BP_GetName(EBP.SOVIET.M11_ANIA_SNIPER))
		Modifier_ApplyToPlayer( health_modifier,player1 ) 
		local health_modifier02 = Modifier_Create(MAT_EntityType, "modifiers\\health_maximum_modifier.lua", MUT_Multiplication, false, 1.3, BP_GetName(EBP.SOVIET.M11_SNIPER))
		Modifier_ApplyToPlayer( health_modifier02,player1 ) 
		local health_modifier03 = Modifier_Create(MAT_EntityType, "modifiers\\health_maximum_modifier.lua", MUT_Multiplication, false, 1.3, BP_GetName(EBP.SOVIET.M11_SNIPER))
		Modifier_ApplyToPlayer( health_modifier03,player1 ) 
	elseif g_hardDiff then
		local health_modifier = Modifier_Create(MAT_EntityType, "modifiers\\health_maximum_modifier.lua", MUT_Multiplication, false, 1, BP_GetName(EBP.SOVIET.M11_ANIA_SNIPER))
		Modifier_ApplyToPlayer( health_modifier,player1 ) 
		local health_modifier02 = Modifier_Create(MAT_EntityType, "modifiers\\health_maximum_modifier.lua", MUT_Multiplication, false,0.8, BP_GetName(EBP.SOVIET.M11_SNIPER))
		Modifier_ApplyToPlayer( health_modifier02,player1 ) 
		local health_modifier03 = Modifier_Create(MAT_EntityType, "modifiers\\health_maximum_modifier.lua", MUT_Multiplication, false,0.8, BP_GetName(EBP.SOVIET.M11_SNIPER))
		Modifier_ApplyToPlayer( health_modifier03,player1 ) 
	else
		local health_modifier = Modifier_Create(MAT_EntityType, "modifiers\\health_maximum_modifier.lua", MUT_Multiplication, false, 1.2, BP_GetName(EBP.SOVIET.M11_ANIA_SNIPER))
		Modifier_ApplyToPlayer( health_modifier,player1 ) 
		local health_modifier02 = Modifier_Create(MAT_EntityType, "modifiers\\health_maximum_modifier.lua", MUT_Multiplication, false, 1, BP_GetName(EBP.SOVIET.M11_SNIPER))
		Modifier_ApplyToPlayer( health_modifier02,player1 ) 
		local health_modifier03 = Modifier_Create(MAT_EntityType, "modifiers\\health_maximum_modifier.lua", MUT_Multiplication, false, 1, BP_GetName(EBP.SOVIET.M11_SNIPER))
		Modifier_ApplyToPlayer( health_modifier03,player1 ) 
	end
end


function Init_MissionSetup()
	Player_SetResource(player1, RT_Command, 100)
	
	musicStart = "streamed/music/missions/m11/m11_cue_start_stealth.bsc"
	musicProtectAnia = "streamed/music/missions/m11/m11_cue_protect_ania.bsc"
	musicRescue = "streamed/music/missions/m11/m11_cue_rescue.bsc"
	musicEscape = "streamed/music/missions/m11/m11_cue_escape.bsc"
	
	-- enums for types of attack requested in function CreateVehiculeSquadWithLocationAndSquadIn
	OPEL_OFFICER_GRENADIERS = 1
	OPEL_GRENADIERS = 2
	HALFTRACK_PANZERGRENADIERS = 3
	OPEL_PIONEERS = 4
	OPEL_PANZERGRENADIERS_MORTAR = 5
	HALFTRACK_PIONEER_MORTAR = 6
	OPEL_PANZERGRENADIERS_SNIPER = 7
	HALFTRACK_PANZERGRENADIERS02 = 8
	OPEL_PIONEERS02 = 9
	OPEL_PANZERGRENADIERS = 10
	OPEL_PANZERGRENADIERS03 = 11
	
	b_achievement_armiakrajowaDone = false
	b_armiakrajowa_sniper = false
	b_armiakrajowa_kark = false
	b_armiakrajowa_nagant = false
	
	b_achievement_snipeDriver = false
	
	-- Use for spawning units on the map at the start
	Player_SetResource(player1, RT_Manpower, t_Resource_difficulty.starting_manpower)
	Player_SetResource(player1, RT_Fuel, t_Resource_difficulty.starting_fuel)
	Player_SetResource(player1, RT_Munition, t_Resource_difficulty.starting_munition)
	Modify_PlayerResourceCap(player1, RT_Munition, 500, MUT_Addition) 

	
	--Remove minimap icons for radio towers
	EGroup_EnableMinimapIndicator(eg_radio_antenna_camp01, false)
	EGroup_EnableMinimapIndicator(eg_radio_antenna_camp03, false)
	EGroup_EnableUIDecorator(eg_pickuphints, false, true)
	EGroup_EnableUIDecorator(eg_radio_antenna_camp01, false, true)
	EGroup_EnableUIDecorator(eg_radio_antenna_camp03, false, true)
	
	Camera_SetDefault(nil,nil, -90)
	Camera_ResetToDefault()
	Camera_FocusOnPosition(Marker_GetPosition(mkr_startCameraTarget), false)
	
	--sg_ivakovich = SGroup_CreateIfNotFound("sg_ivakovich")
	sg_ania = SGroup_CreateIfNotFound("sg_ania")
	sg_sniper_player = SGroup_CreateIfNotFound("sg_sniper_player")
	sg_sniper02_player = SGroup_CreateIfNotFound("sg_sniper02_player")
	sg_player_allSquads = SGroup_CreateIfNotFound("sg_player_allSquads")
	sg_player_allSnipers = SGroup_CreateIfNotFound("sg_player_allSnipers")
	sg_guardsAll_informant = SGroup_CreateIfNotFound("sg_guardsAll_informant")
	sg_sniper_safety = SGroup_CreateIfNotFound("sg_sniper_safety")
	
	-- Create player squad
	Util_CreateSquads(player1, sg_ania, BP_GetSquadBlueprint("m11_ania_sniper_squad"), mkr_mapEntry_ania, mkr_playerStart_ania)
	Util_CreateSquads(player1, sg_sniper_player, BP_GetSquadBlueprint("m11_sniper_team"), mkr_mapEntry_SniperTeam01) --, mkr_playerStart_sniperTeam01)
	Util_CreateSquads(player1, sg_sniper02_player, BP_GetSquadBlueprint("m11_sniper_team"), mkr_mapEntry_SniperTeam02) --, mkr_playerStart_sniperTeam02)
		
	SGroup_AddGroup(sg_player_allSquads,sg_ania)
	SGroup_AddGroup(sg_player_allSquads,sg_sniper_player)
	SGroup_AddGroup(sg_player_allSquads,sg_sniper02_player)
	SGroup_AddGroup(sg_player_allSnipers,sg_sniper_player)
	SGroup_AddGroup(sg_player_allSnipers,sg_sniper02_player)
	
	Player_SetAbilityAvailability(player1,BP_GetAbilityBlueprint("sniper_delayed_cover_auto_camouflage"),ITEM_LOCKED)
	
	sg_playerAll = SGroup_CreateIfNotFound("sg_playerAll")
	sg_playerAll = Player_GetSquads( player1 ) 
	
	sg_mergehints = SGroup_CreateIfNotFound("sg_mergehints")
	sg_reinforcehints = SGroup_CreateIfNotFound("sg_reinforcehints")
	eg_reinforcehints = EGroup_CreateIfNotFound("eg_reinforcehints")
	
	Cmd_Move(sg_ania,mkr_playerStart_ania_pos02,true)
	
	---- variables to know about fire camps
	g_NumberOfFireCaptured_target03 = 0
	g_fire01_target03 = false
	g_fire02_target03 = false
	g_fire03_target03 = false
	
	--- variables about antenna
	g_antenna_camp01_Destroyed = false
	g_antenna_camp03_Destroyed = false
	
	----- variables to know dialogues played once
	g_RadioBuildingIntelAttackDone = false 
	g_Camp02IntelAttackDone = false 
	g_Camp02IntelAttackDone02 = false 
	g_Camp03IntelAttackDone = false 
	g_Camp03IntelAttackDone02 = false
	g_Camp04IntelAttackDone = false 
	g_Camp02IntelFollowDone = false
	
	g_Camp03GrenGoneAtFire = false
	g_Camp03PioneerGoneAtFire = false
	
	g_leftFirstCamp = false

	b_StartedAlarm = false
	
	------- variables to check if Opel arrived at destination
	b_atDestOpel02 = {false}
	b_atDestOpel03 = false
	b_atDestOpel04 = false
	b_atDestOpel05 = false
	b_atDestOpel06 = false
	b_atDestOpel07 = false
	b_atDestOpel08 = false
	b_atDestOpenPrison01 = false
	b_atDestOpenPrison02 = false
	b_atDestOpelLowReinf = false
	b_atDestOpelReinfCamp01 = false
	b_atDestOpelReinfCamp03 = false
	
	---- number of available of partisan squads based on difficulty
	
	if g_easyDiff then
		g_numberOfSquadsAvailable = 7
		g_MaxNumberOfSquadsAvailable = 7
	elseif g_hardDiff then
		g_numberOfSquadsAvailable = 4
		g_MaxNumberOfSquadsAvailable = 4
	else
		g_numberOfSquadsAvailable = 5
		g_MaxNumberOfSquadsAvailable = 5
	end
	
	ProgressUnitsLeft = g_MaxNumberOfSquadsAvailable
	
	--- variable for squads to add or not
	g_checkMoreSquads = false
	
	bGarrisonOfficerTarget04 = false
	b_startedRadio = false		
	b_TeachFireCamp = false		
	b_attackedCamp02 = false
	
	----variable to see how many mortar hit the player
	g_NumberHitsByMortar = 0
	
	Modify_PlayerResourceRate(player1, RT_Manpower, 0, MUT_Multiplication)
	Modify_PlayerResourceRate(player1, RT_Fuel, 0, MUT_Multiplication)
	Modify_PlayerResourceRate(player1, RT_Munition, .6, MUT_Multiplication)
	
	Player_SetPopCapOverride(player1,5)
	
	Sound_PreCacheSound("campaign/alarm_klaxon")
	Sound_PreCacheSound("speech/sp/mission/m11/ambient/xb_hpg_pin_snigen_lt_s")
	Sound_PreCacheSound("speech/sp/mission/m11/ambient/xb_hpg_atk_gege00_nt_m")
	Sound_PreCacheSound("speech/sp/mission/m11/ambient/xb_hpg_atm_genge0_nt_m")
	Sound_PreCacheSound("speech/sp/mission/m11/ambient/xs_mrt_atk_gege00_nt_s")
	Sound_PreCacheSound("speech/sp/mission/m11/ambient/xb_xs1_bat_gege00_lt_s")
	Sound_PreCacheSound("speech/sp/mission/m11/ambient/xb_hpg_pin_snigen_lt_l")
	Sound_PreCacheSound("speech/sp/mission/m11/ambient/xb_xs1_buf_gesnge_lt_m")
	Sound_PreCacheSound("speech/sp/mission/m11/11036695")
	Sound_PreCacheSound("speech/sp/mission/m11/11036697")
end


-------------------------------------------------------------------------
-- MISSION END STUFF
-------------------------------------------------------------------------
function MissionFailed()		
	Game_EndSP(false)
end

function MissionComplete()	
	Util_StartNIS(EVENTS.NIS_End)
end

-- MISSION INTRO to show Ania as a sniper
function IntroNislet_Start()
	Cmd_Ability(sg_ania, ABILITY.SOVIET.SNIPER_HOLD_FIRE)
	Cmd_Ability(sg_sniper_player, ABILITY.SOVIET.SNIPER_HOLD_FIRE)
	Cmd_Ability(sg_sniper02_player, ABILITY.SOVIET.SNIPER_HOLD_FIRE)
	UI_SetCPMeterVisibility(false) 
	Util_PlayMusic(musicStart, 0, 0)
	Util_StartNislet(EVENTS.IntroNislet, IntroNislet_Skipped, true)
end

function IntroNislet_Skipped()
	SGroup_WarpToMarker(sg_ania, mkr_playerStart_ania_pos02)
	Cmd_Stop(sg_ania)
	SGroup_Kill(sg_officer_intro)
	StartSitRep()
end

function StartSitRep()
	Event_Timer(EventHandler_StartIntel, {intel = EVENTS.SIT_REP}, 1.5)	
	Event_NarrativeEventsNotRunning(MissionStart)
end

-------------------------------------------------------------------------
-- MISSION START 
-------------------------------------------------------------------------
function MissionStart()
	Player_SetAbilityAvailability(player1,BP_GetAbilityBlueprint("sniper_delayed_cover_auto_camouflage"),ITEM_UNLOCKED)
	EGroup_InstantCaptureStrategicPoint( eg_territoryInitial, player1 ) 
		
	-- hints about merging into damaged squads and reinforcing from halftracks and HQs
	Mission_UpdateHintGroups()
	BeginnerHint_AddOpportunity(sg_reinforcehints, HINT_REINFORCE, true, nil, nil, nil, GD_EASY)
	BeginnerHint_AddOpportunity(eg_pickuphints, HINT_PICKUP, true, nil, nil, nil, GD_EASY)
	Rule_AddInterval(Mission_UpdateHintGroups, 30)	

	FirstBeat_Start()
end

--------------------------------------------------------------------------
--- function to change the territory of the hospital to get benefit
--------------------------------------------------------------------------
function CheckIfPlayerOwnHospitalTerritory()	
	Util_SetPlayerOwner( eg_hospital, player1, true ) 
	BeginnerHint_AddOpportunity(eg_hospital, HINT_REINFORCE, true)
	
	Event_Timer(AddHospitalHintPoint2, nil, 3)
	
	UI_FlashSquadCommandButton(SCMD_ReinforceUnit, true)
	Util_SetPlayerOwner(eg_reinforcementPtCamp02,player1,true)
	Util_SetPlayerOwner(eg_retreatPtCamp02,player1,true)
	HintPoint_Remove(hpid_hospitalCamp02)	
end
function AddHospitalHintPoint2()
	if hp_hospital == nil then
		hp_hospital = HintPoint_Add(eg_hospital, true, 11050289, -2, nil, "Icons_odds_reinforce") -- LOCDB [11050289] 'Reinforce units here.'
	end
end


-----using this version of the previous function when trying to escape the map objective (if player gets the territory during last objective, grant him access to treatment but not retreat)
function CheckIfPlayerOwnHospitalTerritory02()	
	Util_SetPlayerOwner( eg_hospital, player1, true ) 
	Util_SetPlayerOwner(eg_reinforcementPtCamp02,player1,true)
	BeginnerHint_AddOpportunity(eg_hospital, HINT_REINFORCE, true)
	UI_FlashSquadCommandButton(SCMD_ReinforceUnit, true)
	UI_FlashSquadCommandButton(SCMD_InstantReinforceUnit, true)
	
	Rule_AddDelayedInterval(CheckEnemyGetsInfirmary,2,1)
end

function CheckEnemyGetsInfirmary()
	if World_IsTerritorySectorOwnedByPlayer( player2, World_GetTerritorySectorID( EGroup_GetPosition(eg_territory_hospital) )) then
		Util_SetPlayerOwner( eg_hospital, player2, true ) 
		Util_SetPlayerOwner(eg_reinforcementPtCamp02,player2,true)
		Event_PlayerOwnsTerritory(CheckIfPlayerOwnHospitalTerritory02, nil,player1,World_GetTerritorySectorID( EGroup_GetPosition(eg_territory_hospital) ))
		Rule_RemoveMe()
	end	
end

---- Checks number of sniper squads the player can use
function CheckSniperSquadsNumber()
	local sg_playerAll02 = Player_GetSquads( player1 ) 
	
	if SGroup_ContainsBlueprints(sg_playerAll02,BP_GetSquadBlueprint("m11_ania_sniper_squad"),ANY) then
		SGroup_Filter(sg_playerAll02,BP_GetSquadBlueprint("m11_ania_sniper_squad") , FILTER_REMOVE)
	end
end

function Mission_UpdateHintGroups()
	
	local infantry = {}
	local _add = function(k, v) table.insert(infantry, v) end
	table.foreach(LIST.INFANTRY, _add)
	table.foreach(LIST.ATGUNS, _add)
	table.foreach(LIST.HMGS, _add)
	
	Player_GetAll(player1, sg_reinforcehints)
	SGroup_Filter(sg_reinforcehints, infantry, FILTER_KEEP)

end

--- Checks if the player can see the sniper tower in camp 02 to reveal the sniper inside
function PlayerCanSeeSniperCamp02()
	
	if Player_CanSeeEGroup( player1, eg_sniperTower01_Target02, ANY) then		
		-- Adding a hint point over the tower so players know
		if g_hardDiff ~= true then
			hpid_sniper_camp02 = HintPoint_Add(eg_sniperTower01_Target02, true, 11036702,4,HPAT_Hint) -- LOCDB [11036702] 'German Sniper'
		end
		EventCue_Create(CUE.ATTACKED,11023513,11023513,eg_sniperTower01_Target02,nil,nil,10,true) -- LOCDB [11023513] 'Sniper!'
	
		-- Reveal the area of the tower otherwise player's wouldnt be able to shoot the sniper because of camouflaged sniper or hidden at other window
		FOW_RevealArea( EGroup_GetPosition(eg_sniperTower01_Target02), 5, -1 ) 
		
		-- check snipers death to remove hints
		Rule_AddSGroupEvent(CheckSniperCamp02Death,sg_guardTower_target02,GE_SquadKilled)		
		Rule_RemoveMe()
	end	
end

--- starts the objective for the radio building if player close to camp 03 or radio building
function ObjectiveStart_ObjDestroyRadio()	
	Objective_Start(OBJ_DestroyRadio)
	
	--checks if the squad at the radio station was attacked to give them behaviors
	if Rule_Exists(CheckSquadAttacked_RadioBuilding ) == false then
		Rule_AddInterval(CheckSquadAttacked_RadioBuilding ,1)
	end
end

--- starts the objective for the radio building if officer of camp01 runs to radio
function ObjectiveStart_ObjDestroyRadioRunning()
	Rule_RemoveMe()
	
	if Objective_IsStarted(OBJ_DestroyRadio) == false then
		Objective_Start(OBJ_DestroyRadio)
	end
	--checks if the squad at the radio station was attacked to give them behaviors
	FOW_RevealEGroup("eg_radio_antenna_camp01",10)
	if Rule_Exists(CheckSquadAttacked_RadioBuilding ) == false then
		Rule_AddInterval(CheckSquadAttacked_RadioBuilding ,1)
	end
	Event_Remove(eID_ObjDestroyRadio)
end

function BackToGameplay()
	Cmd_Move(sg_sniper_player,mkr_playerStart_ania)
	Rule_Add(ShowNewAbilitiesPre)
end

---- will show the player that the Sniper create cover ability is available to them
function ShowNewAbilitiesPre()
	if Event_IsAnyRunning() == false then
		Rule_RemoveMe()		
		Rule_AddInterval(CheckInCamo, 0.5)
		Rule_AddDelayedInterval(ShowNewAbilities, 6, 3)
	end
end

---- will show the player that the Sniper create cover ability is available to them
function ShowNewAbilities()
	if Event_IsAnyRunning() == false then
		Rule_RemoveMe()
		
--~ 		SelectAniaOrRegularSnipers()
		
		---- show feature
		Util_NewHUDFeatureEvent( HUDF_CommandCard, 11036896, "Icons_abilities_ability_german_build_camouflage", 5 )  -- LOCDB [11036896] 'Set up Sniper Cover: Use this ability to create your own camouflaged cover'
		
		iFlashSniper = -1
		iFlashSniper = UI_FlashAbilityButton(BP_GetAbilityBlueprint("camouflage_construction_ania"),true)
		
		---dont show hints if on hard mode
		if g_hardDiff ~= true then		
			hintID_SniperCover = BeginnerHint_AddOpportunity({mkr_SniperDigIn02,mkr_SniperDigIn03,mkr_SniperDigIn04,mkr_SniperDigIn05}, ABILITY.GLOBAL.CAMOUFLAGE_CONSTRUCTION)
		
			-- check if player selects the ability 
			UI_SetModalAbilityPhaseCallback(CheckUsedCoverSniper)
	
			--- check if player uses cover near camp01
			eID_cover = Event_Proximity(CheckGetInCover,nil,player1,mkr_CheckInCover,24,ANY)
		end		
		Rule_AddOneShot(ClearFlashSniper, 5)
	end
end

----- get rid of the flashing ability 
function ClearFlashSniper()
	if iFlashSniper ~= -1 then
		UI_StopFlashing(iFlashSniper)
	end
end

function SelectAniaOrRegularSnipers()

	if Misc_IsSGroupSelected(sg_sniper02_player, ANY) == false and Misc_IsSGroupSelected(sg_sniper_player, ANY) == false and Misc_IsSGroupSelected(sg_ania, ANY) == false then 
		
		if SGroup_IsEmpty(sg_ania) == false then
			Misc_SelectSquad( SGroup_GetSpawnedSquadAt( sg_ania, 1 ) , true ) 
		end
		
	elseif Misc_IsSGroupSelected(sg_ania, ANY) == true then
		
		-- if Ania is selected, make sure she's the only one
		
		if SGroup_IsEmpty(sg_ania) == false then
			Misc_SelectSquad( SGroup_GetSpawnedSquadAt( sg_ania, 1 ) , true ) 
		end
		if SGroup_IsEmpty(sg_sniper_player) == false then
			Misc_SelectSquad( SGroup_GetSpawnedSquadAt( sg_sniper_player, 1 ), false ) 
		end
		if SGroup_IsEmpty(sg_sniper02_player) == false then
			Misc_SelectSquad( SGroup_GetSpawnedSquadAt( sg_sniper02_player, 1 ), false ) 
		end
	end	
end

---- function checks if camouflage ability was used
function CheckUsedCoverSniper(abilityUsed, phaseDone)

	if abilityUsed == BP_GetAbilityBlueprint("camouflage_construction") then
		--- if player clicked on ground to bring troop
		
		if phaseDone == MAP_Confirmed then
			
			BeginnerHint_RemoveOpportunity(hintID_SniperCover)
			iFlashSniper = -1
			UI_ClearModalAbilityPhaseCallback()
		end
	end
end

----- function to check if squad camouflaged so remove hints
function CheckInCamo()
	if SGroup_IsCamouflaged( sg_playerAll, ANY ) then
		Rule_RemoveMe()
		Event_Remove(eID_timerCover)
		if hP_cover01 ~= nil then
			HintPoint_Remove(hP_cover01)
		end
	end
end

----- function to put up the cover hints
function CheckGetInCover()
	eID_timerCover = Event_Timer(Cover_GiveHint,nil,2)
end

----- function putting up the hints for cover
function Cover_GiveHint()	
	if Util_GetDistance(sg_ania,mkr_hintCover01) < Util_GetDistance(sg_ania, mkr_hintCover01b) then
		hP_cover01 = HintPoint_Add( mkr_hintCover01,true,11036897,0,HPAT_CoverYellow) -- LOCDB [11036897] 'Camouflage: Get near cover objects to go into camouflage mode'
	else
		hP_cover01 = HintPoint_Add( mkr_hintCover01b,true,11036897,0,HPAT_CoverYellow) -- LOCDB [11036897] 'Camouflage: Get near cover objects to go into camouflage mode'
	end	
	Event_Timer(EventHandler_RemoveHint, {hint = hP_cover01},10)
end

-------------------------------------------------------------------------
-- OBJECTIVE ANIA MUST SURVIVE 
-------------------------------------------------------------------------
function Initialize_ObjectiveAniaIsakovichMustSurvive()
	OBJ_AniaIsakovichMustSurvive = {		
		OnStart = function()		
			Event_GroupIsDead(_Ania_DeadCheck, nil, sg_ania,0,false)
		end,		
		OnFail = function()
			MissionFailed()
		end,		
		Intel_Start = nil, --EVENTS.Obj3_Intro,				-- Event will play when obj starts but before any UI appears
		Intel_Complete = nil, --EVENTS.Obj3_Complete,			-- Event will play when obj completes but before UI is cleared
		Intel_Fail = EVENTS.Obj3_Fail,				-- Event will play when obj fails but before UI is cleared
		Title = 11034446,	-- LOCDB [11034446] 'Ania must survive'
		Description = 11034447,	-- LOCDB [11034447] 'Ania must survive'
		TitleEnd = 11034446,	-- LOCDB [11034448] 'Ania survived'
		TitleFail = 11034449,		-- LOCDB [11034449] 'You lost one of your squads'
		Type = OT_Primary,				-- Objective Type (OT_Primary, OT_Secondary)		
	}
	Objective_Register(OBJ_AniaIsakovichMustSurvive)
end

function _Ania_DeadCheck()
	Event_Skip()
	Objective_Fail(OBJ_AniaIsakovichMustSurvive,true)
end

--not used for now but was checking the death of Isakovich
function _Isakovich_DeadCheck()
	Objective_Fail(OBJ_AniaIsakovichMustSurvive,true)
end

-------------------------------------------------------------------------
-- OBJECTIVE KILL GERMAN OFFICERS
-------------------------------------------------------------------------
function Initialize_ObjectiveKillOfficers()
	OBJ_KillOfficers = {
		
		SetupUI = function() 
			hpid_Officer04 = Objective_AddUIElements(OBJ_KillOfficers, sg_officer_target04, true, 11034470, true, 3) -- LOCDB [11034470] 'Eliminate the Officers'
			hpid_Officer02 = Objective_AddUIElements(OBJ_KillOfficers, sg_officer_target02, true, 11034470, true, 3) -- LOCDB [11034470] 'Eliminate the Officers'
			hpid_Officer01 = Objective_AddUIElements(OBJ_KillOfficers, sg_officer_target01, true, 11034470, true, 3) -- LOCDB [11034470] 'Eliminate the Officers'
		end,
		
		OnStart = function()		
			g_numberOfficersKilled_count = 0
			g_numberOfMaximumOfficers = 3
			
			Event_Timer(EventHandler_ObjectiveStart, {objective = OBJ_AniaIsakovichMustSurvive}, 13)	
			Rule_AddOneShot(BackToGameplay, 1)
			
			Rule_AddSGroupEvent(_Officers01_DeadCheck,sg_officer_target01,GE_SquadKilled)
			Rule_AddSGroupEvent(_Officers02_DeadCheck,sg_officer_target02,GE_SquadKilled)

			Rule_AddSGroupEvent(_Officers04_DeadCheck,sg_officer_target04,GE_SquadKilled)
			
			--function that checks if all dead
			Rule_AddInterval(OBJ_ObjectiveKillOfficers_Complete, 1)
			
			--function that will show on hud how many officers have been killed
			Objective_SetCounter(OBJ_KillOfficers , g_numberOfficersKilled_count, g_numberOfMaximumOfficers) 
			
			Misc_SelectSquad(SGroup_GetRandomSpawnedSquad(sg_ania), true)
			Util_StartIntel(EVENTS.Obj1_Intro)
		end,
		
		OnComplete = function()
			World_IncreaseInteractionStage()
			Event_Proximity(Informant_ApproachingCamp,nil,player1,mkr_TowardsInformant,45,ANY)
			
			Rule_Add(StartObjective_CaptureTargetPre)			
		end,
		
		OnFail = function()			
			MissionFailed()
		end,
		
		Title = 11034451,		-- LOCDB [11034451] 'Eliminate the German Officers'
		Description = 11034452,	-- LOCDB [11034452] 'Eliminate the German Officers as quickly as possible.'
		TitleEnd = 11034451,		-- LOCDB [11034453] 'German Officers eliminated,'
		TitleFail = 11034454,	-- LOCDB [11034454] 'German Officers survived, you should be ashamed'
		Type = OT_Primary,				-- Objective Type (OT_Primary, OT_Secondary)
	}
	Objective_Register(OBJ_KillOfficers)
end

--function that will check if the officer 1 is killed
function _Officers01_DeadCheck(squad, killer)
	
	g_numberOfficersKilled_count = g_numberOfficersKilled_count + 1
	
	Objective_SetCounter(OBJ_KillOfficers , g_numberOfficersKilled_count, g_numberOfMaximumOfficers) 	
	
	--remove the obj icon over the officer 
	Objective_RemoveUIElements(OBJ_KillOfficers, hpid_Officer01)
	
	--get the squad who killed the officer to send enemies after them
	sg_killer_camp01 = SGroup_CreateIfNotFound("sg_killer_camp01")
	Squad_GetLastAttacker( squad, sg_killer_camp01 )	
	
	--retaliation using the killer squad from player to be attacked by the officer guards
	RetaliateOfficerDead( squad, sg_killer_camp01, sg_guards_target01,encID_guardsOfficer01 )
	
	------remove hint for Radio in camp
	if hintAntennaCamp01 ~= nil then
		HintPoint_Remove(hintAntennaCamp01)
	end
	
	Rule_AddInterval(CheckProxOutCamp01,1)
	Rule_RemoveIfExist(StartAttackAllHiddenCamp01)
end


function CheckProxOutCamp01()
	if Prox_ArePlayersNearMarker(player1, mkr_EscapingCamp01, ANY) == false then 
		g_leftFirstCamp = true
		Rule_RemoveMe()
		
		Rule_AddOneShot(SendInPassbyTruck,3)
	end
end

function SendInPassbyTruck()
	sg_opelDriveBy = SGroup_CreateIfNotFound("sg_opelDriveBy")

	Util_CreateSquads(player2, sg_opelDriveBy, SBP.GERMAN.OPEL_BLITZ_SQUAD, mkr_truckExitTarget04)

	Cmd_SquadPath(sg_opelDriveBy,"patrol_truckDriveBy",true,LOOP_NONE,false,0,mkr_GermReinf_LowSec,false,true)
	
	MakeVehicleSnipable(sg_opelDriveBy)
end

----function will check when is the best time to activate the radio objective
function CheckTimeToActivateRadioObj()
	if g_leftFirstCamp or SGroup_IsEmpty(sg_allUnits_target01) then
		if Objective_IsStarted(OBJ_DestroyRadio) == false then
			if b_startedRadio == false then
				Event_Timer(ObjectiveStart_ObjDestroyRadioRunning,nil,1)
				b_startedRadio = true
				Rule_RemoveMe()
			end
		end
	end
end

--function that will check if the officer 2 is killed
function _Officers02_DeadCheck(squad,killer)

	g_numberOfficersKilled_count = g_numberOfficersKilled_count + 1
	Objective_SetCounter(OBJ_KillOfficers , g_numberOfficersKilled_count, g_numberOfMaximumOfficers) 
	
	--remove the obj icon over the officer 
	Objective_RemoveUIElements(OBJ_KillOfficers, hpid_Officer02)
	
	--get the squad who killed the officer to send enemies after them
	sg_killer_camp02 = SGroup_CreateIfNotFound("sg_killer_camp02")
	Squad_GetLastAttacker( squad, sg_killer_camp02 )
	
	--retaliation using the killer squad from player to be attacked by the officer guards
	RetaliateOfficerDead( squad, sg_killer_camp02, sg_guards_pgren_target02, eID_pgren_target02 )
	
	Event_Remove(eID_teachCampFire)
		
	--- make the capture time shorter
	Modify_CaptureTime(eg_territory_hospital,3)

	Rule_AddOneShot(GiveHintInfirmary,5)
	
	if b_attackedCamp02 == false then
		b_attackedCamp02 = true
		CancelHintsCamp02Fire()
	end
end

function GiveHintInfirmary()
	if g_hardDiff ~= true then
		--Add hint over the infirmary so players know they found something to use
		hpid_hospitalCamp02 = HintPoint_Add(eg_hospital, true, 11036734,1,HPAT_Hint) -- LOCDB [11036734] 'Infirmary: Heal your squads by moving them close to the building'
		Util_StartIntel(EVENTS.CaptureInfirmary)
		FOW_RevealEGroup(eg_hospital,30)		
	end
end


--function that will check if the officer camp 4 is killed
function _Officers04_DeadCheck(squad, killer)
	
	g_numberOfficersKilled_count = g_numberOfficersKilled_count + 1
	Objective_SetCounter(OBJ_KillOfficers , g_numberOfficersKilled_count, g_numberOfMaximumOfficers) 
	
	--remove the obj icon over the officer 
	Objective_RemoveUIElements(OBJ_KillOfficers, hpid_Officer04)
	
	--get the squad who killed the officer to send enemies after them
	sg_killer_camp04 = SGroup_CreateIfNotFound("sg_killer_camp04")
	Squad_GetLastAttacker( squad, sg_killer_camp04 )
	
	--retaliation using the killer squad from player to be attacked by the officer guards
	RetaliateOfficerDead( squad, sg_killer_camp04, sg_guards_pgren_target04,eID_pgren_target04 )
	
	if hID_transportOfficer ~= nil then
		HintPoint_Remove(hID_transportOfficer)
	end
	
	if SGroup_Exists(SGroup_GetName(sg_truck_target04)) then
		SGroup_SetWorldOwned(sg_truck_target04 ) 
	end
	
--	Rule_RemoveIfExist(StartAttackAllHiddenCamp04)
end


--------------------------------------------
--- retaliate function
---       will have the other guards go to the position of the dead officer and attack from there
--   param: squad killed (officer), the killer sgroup, the sgroup who need to attack, encounterid of the sgroup to cancel their goal
--------------------------------------------
function RetaliateOfficerDead( squadKilled, sgID_killer, sg_squadAround, EncounterID )	
	--if guards around the officer are still alive
	if SGroup_IsEmpty(sg_squadAround) == false then 	
		EncounterID:ClearGoal()		
		--check if the killer squad has still some entities alive
		if SGroup_Count( sgID_killer ) > 0 then 			
			local lastPosition = SGroup_GetPosition(sgID_killer)
			
			-- Set attack encounter goal to attack the killer
			local goalData = {
				name = "Attack",
				range = 45,
				leashRange = 40,
				attackMove = true,
				target = lastPosition,
				useSkirmishAI = g_useSkirmishAI,
			}
			
			EncounterID:SetGoal(goalData)		
		
			if SGroup_IsEmpty(sg_squadAround) == false then
				Sound_PlayOnSquad( "speech/sp/mission/m11/ambient/xb_xs1_bat_gege00_lt_s", sg_squadAround ) 
			end
		end
	end
end

-- function checks if all officers have been killed to complete the objective
function OBJ_ObjectiveKillOfficers_Complete()
	-- checking if all officers killed
	if g_numberOfficersKilled_count == g_numberOfMaximumOfficers then
		Rule_RemoveMe()
		Objective_Complete(OBJ_KillOfficers)		
		Event_Timer(RemoveProgressBar,nil,2)
	end		
end

function RemoveProgressBar()
	Obj_HideProgress()
end

-------------------------------------------------------------------------
-- OBJECTIVE CAPTURE INFORMANT
-------------------------------------------------------------------------
function Initialize_ObjectiveCaptureInformant()	
	OBJ_CaptureInformant = {		
		OnStart = function()		
			Util_Autosave()
			EGroup_SetSelectable( eg_captureBuilding, false ) 
			Util_StartIntel(EVENTS.Obj2_Intro)
		--Checking proximity of players squad to the informant
			Rule_AddInterval(OBJ_CaptureInformant_CheckProx, 1)
			
			--Time that the player will have to protect Ania and the informant 
			if g_easyDiff then
				g_CaptureInformationTime = 120			
			elseif g_hardDiff then
				g_CaptureInformationTime = 120			
			else
				g_CaptureInformationTime = 120
			end
			
			g_InformantBuildingLocation = mkr_defendAniaEncTarget			
		end,		
		OnComplete = function()			
			Rule_AddOneShot(ObjectiveStart_HelpPrisoners,1)
			Util_SetPlayerOwner(eg_reinforcementPtCamp02,player2,true)
			Util_SetPlayerOwner(eg_retreatPtCamp02,player2,true)
			EGroup_SetSelectable( eg_captureBuilding, true ) 
		end,		
		OnFail = function()		
			MissionFailed()
		end,		
		Intel_Complete = EVENTS.Obj2_Complete,			-- Event will play when obj completes but before UI is cleared
		Intel_Fail = EVENTS.Obj2_Fail,				-- Event will play when obj fails but before UI is cleared
		Title = 11034455,	-- LOCDB [11034455] 'Capture the informant'
		Description = 11034456,	-- LOCDB [11034456] 'Capture the informant and get information from them. Protect Ania while she gets the information'
		TitleEnd = 11034455, -- LOCDB [11034457] 'We captured the informant.'
		TitleFail = 11034458, -- LOCDB [11034458] 'You could not get the information from the informant'
		Type = OT_Primary,				-- Objective Type (OT_Primary, OT_Secondary)		
	}
	Objective_Register(OBJ_CaptureInformant)	
end

-------------------------------------------------------------------------
-- OBJECTIVE CAPTURE INFORMANT Sub Get to the camp
-------------------------------------------------------------------------
function Initialize_ObjectiveCaptureInformantSubGetToCamp()
	
	OBJ_CaptureInformantSubGetToCamp = {		
		Parent = OBJ_CaptureInformant,
		
		Intel_Start = nil,				-- Event will play when obj starts but before any UI appears
		Intel_Complete = nil,			-- Event will play when obj completes but before UI is cleared
		Intel_Fail = nil,				-- Event will play when obj fails but before UI is cleared
		Title = 11037033,	-- LOCDB [11037033] 'Get to the Informant's camp'
		Description = 11037034,	-- LOCDB [11037034] 'The informant is located in the northern camp in the area'
		TitleEnd = 11037033, -- 
		Type = OT_Primary,				-- Objective Type (OT_Primary, OT_Secondary)		
	}
	Objective_Register(OBJ_CaptureInformantSubGetToCamp)	
end

-------------------------------------------------------------------------
-- OBJECTIVE CAPTURE INFORMANT Sub Secure the informant
-------------------------------------------------------------------------
function Initialize_ObjectiveCaptureInformantSubSecureInformant()	
	OBJ_CaptureInformantSubSecureInformant = {
		
		OnFail = function()		
			MissionFailed()
		end,
		
		Parent = OBJ_CaptureInformant,
		
		Intel_Start = nil,				-- Event will play when obj starts but before any UI appears
		Intel_Complete = nil,			-- Event will play when obj completes but before UI is cleared
		Intel_Fail = nil,				-- Event will play when obj fails but before UI is cleared		
		Title = 11037035,	-- LOCDB [11037035] 'Get Ania to the informant's hideout'
		Description = 11037036,	-- LOCDB [11037036] 'The informant is in the building. Eliminate threats around the camp and get Ania close to the building'
		TitleEnd = 11037035, -- 	
		Type = OT_Primary,				-- Objective Type (OT_Primary, OT_Secondary)
		
	}
	Objective_Register(OBJ_CaptureInformantSubSecureInformant)	
end

-------------------------------------------------------------------------
-- OBJECTIVE CAPTURE INFORMANT Sub Secure the informant
-------------------------------------------------------------------------
function Initialize_ObjectiveCaptureInformantSubProtectAnia()
	
	OBJ_CaptureInformantSubProtectAnia = {
		
		OnStart = function()			
		end,
		
		Parent = OBJ_CaptureInformant,		
		Intel_Start = nil,				-- Event will play when obj starts but before any UI appears
		Intel_Complete = nil,			-- Event will play when obj completes but before UI is cleared
		Intel_Fail = nil,				-- Event will play when obj fails but before UI is cleared		
		Title = 11037037,	-- LOCDB [11037037] 'Protect Ania until she gets out'
		Description = 11037038,	-- LOCDB [11037038] 'You need to protect Ania from reinforcements coming towards the camp while she retrieves the informant.'
		TitleEnd = 11037037, 
		TitleFail = nil, 
		Type = OT_Primary,				-- Objective Type (OT_Primary, OT_Secondary)		
	}
	Objective_Register(OBJ_CaptureInformantSubProtectAnia)	
end

----- making sure the previous objective is done
function StartObjective_CaptureTargetPre()
	if Event_IsAnyRunning() == false then	
		Rule_RemoveMe()
		Rule_AddOneShot(StartObjective_CaptureTarget,1)
	end
end

-- Start objective to get the informant
function StartObjective_CaptureTarget()	
	Objective_Start(OBJ_CaptureInformant)
	
	Event_Timer(EventHandler_ObjectiveStart,{ objective = OBJ_CaptureInformantSubGetToCamp, showTitle = false},3)

	Event_Proximity(ActivateCampFire, nil, sg_ania, eg_fire01_farm_turnOn, 40, ANY, 2)
	
	Event_Proximity(ActivateInformantArea, nil, player1, mkr_nearCampInformant,70,ANY)
	
	--- Prepare the units around the informant
	SecondBeat_Init()
end

---------------------------------------
---- Function to check if Ania is close to the informant 
---------------------------------------
function OBJ_CaptureInformant_CheckProx()

-- check if the informant is in the group and alive
	if SGroup_IsEmpty(sg_informant) == false then
	
	-- if Ania is 15 meters from informant
		if Prox_AreSquadsNearMarker( sg_ania, SGroup_GetPosition(sg_informant), ANY,15 ) == true then
		
			Rule_RemoveMe()
			
			-- tell players Ania is going inside 
			Objective_Complete(OBJ_CaptureInformantSubSecureInformant)
			Util_StartIntel(EVENTS.Obj2_GoingInProtect)
			Event_Timer(StartNextObjective_ProtectAnia,nil,2)
					
			EventCue_Create(CUE.POP_INC,11045310,11045310,nil,nil,nil,10,true) -- LOCDB [11045310] 'Population Cap Increased'
				
			Player_SetPopCapOverride(player1,7)		
			
			----add ability to call in more sniper squads
			Rule_AddOneShot(AddingNewSnipersAbility,6)
			
			-- check if sniper is alive...if so kill him to avoid unfortunate death from player
			if SGroup_IsEmpty( sg_guards_sniper_informant) == false then
				SGroup_Kill(sg_guards_sniper_informant)
				HintPoint_Remove(hpid_sniper_informant)
			end
			
			---- reveal the area to show all of the informant territory
			FOW_UnRevealMarker( mkr_informant) 
			FOW_RevealArea( Marker_GetPosition(mkr_InsideLastArea), 40, -1 )
			
			--- change owner of ania squad so players cant use her anymore
			SGroup_SetPlayerOwner( sg_ania, player4 ) 
			SGroup_SetPlayerOwner( sg_informant, player4 )
			
			Event_Timer(SetAniaAndInformantTeam, nil, 2)
			
			--- Garrison the building while ania and informant "talk"
			Cmd_Garrison(sg_ania,eg_captureBuilding,true,false,true)
			Cmd_Garrison(sg_informant,eg_captureBuilding,true,false,true)
						
			-- if any guards left attack the building
			Cmd_Attack(sg_guardsAll_informant,eg_captureBuilding)
			
			-- make sure the territory is now player owned so access to health
			EGroup_InstantCaptureStrategicPoint( eg_territoryPt_informant, player1 ) 
			
			if g_hardDiff ~= true then
				-- Making the hospital in the informant area is on player side
				Util_SetPlayerOwner( eg_hospital_informant, player1, true ) 
				BeginnerHint_AddOpportunity(eg_hospital_informant, HINT_REINFORCE, true)
				Util_SetPlayerOwner(eg_reinforcementPtInformant,player1,true)				
								
				Event_Timer(AddHospitalHintPoint, nil, 3)				
			end
			
			Util_SetPlayerOwner(eg_retreatPtInformant,player1,true)
			Modify_CaptureTime(eg_territoryPt_informant,0.0000001)
			
		end
	end
end

function AddHospitalHintPoint()
	if hp_hospital2 == nil then
		hp_hospital2 = HintPoint_Add(eg_hospital_informant, true, 11050289, -2, nil, "Icons_odds_reinforce") -- LOCDB [11050289] 'Reinforce units here.'
	end
end

function SetAniaAndInformantTeam()
	SGroup_SetPlayerOwner( sg_ania, player3 ) 
	SGroup_SetPlayerOwner( sg_informant, player3 )
end

function StartNextObjective_ProtectAnia()
	if Event_IsAnyRunning() == false then
	
		Player_SetAbilityAvailability(player2, ABILITY.GERMAN.PANZER_GRENADIER_BUNDLED_CAMPAIGN, ITEM_LOCKED)
		
		sg_informantScounts = SGroup_CreateIfNotFound("sg_informantScounts")
	
		Objective_Start(OBJ_CaptureInformantSubProtectAnia,false)
		
		timeLeft = 1
		
		Objective_StartTimer( OBJ_CaptureInformantSubProtectAnia, COUNT_DOWN, g_CaptureInformationTime, 20 ) 
		
		Obj_ShowProgress( 11035343, timeLeft ) -- LOCDB [11035343] 'Time left...'
		
		--- update timer
		Rule_AddInterval(OBJ_ProtectAnia_UpdateTimer,1)
		
		Event_Timer(BringScoutsInformant,{side = mkr_hint_charges01, canSeeCheck = true}, 0.1)

		--callback when time is up
		Rule_AddOneShot(CheckTimeRemaining,g_CaptureInformationTime + 1)
			
	else
		Event_Timer(StartNextObjective_ProtectAnia,nil,2)
	end
end

-----function spawns soldiers to scout and show player direction enemies will come from
------ data: pass in the side of the attack, sgroup
function BringScoutsInformant(data)
	local sg_informantScounts = SGroup_Create("")
	local scoutMoveTo = mkr_scoutMoveTo_01
	local spawnlocationScout = mkr_reinfInformant_destination01_c
	
	if Marker_GetName(data.side) == "mkr_hint_charges02" then
		spawnlocationScout = mkr_reinfInformant_destination02_b
		scoutMoveTo = mkr_scoutMoveTo_01
	end
	
	local load = 2
	if data.canSeeCheck == true then --hack - only used on the first two scouts
		load = 3
	else
		if campaignDifficulty == GD_NORMAL then
			load = 3
		elseif campaignDifficulty == GD_HARD then
			load = 4
		end
	end	
	
	local encData = {
		player = player2,
		spawn = spawnlocationScout,
		sgroups = {sg_informantScounts},
		units = {
			{sbp = SBP.GERMAN.GRENADIER_SQUAD,	spawn = spawnlocationScout, load = load},
		},
	}
	local encid_encountername = Encounter:Create(encData)
	
	if spawnlocationScout == mkr_reinfInformant_destination01_c then
		Cmd_AttackMove(sg_informantScounts, mkr_reinfInformant_destination01)
		Cmd_AttackMove(sg_informantScounts, mkr_reinfInformant_destination04, true)
		Cmd_AttackMove(sg_informantScounts, mkr_scoutMoveTo_01, true)
	else
		Cmd_AttackMove(sg_informantScounts, mkr_reinfInformant_destination02)
		Cmd_AttackMove(sg_informantScounts, mkr_reinfInformant_destination03, true)
		Cmd_AttackMove(sg_informantScounts, mkr_scoutMoveTo_01, true)	
	end
	
	--check status of attack
	if data.canSeeCheck == true then
		Event_PlayerCanSeeElement(CanSeeScout,{side = data.side}, player1, sg_informantScounts, ANY)
	end
	Event_IsDoingAttack(SetupScoutEncounter,{encounter = encid_encountername, sgroup = sg_informantScounts}, sg_informantScounts, ANY, 1)	
end

function SetupScoutEncounter(data)
	Cmd_Stop(data.sgroup)
	local goalData = {
		name = "Defend",
		range = mkr_scoutMoveTo_01,
		leashRange = mkr_scoutMoveTo_01,
		target = mkr_scoutMoveTo_01,
		useSkirmishAI = g_useSkirmishAI,		
		movePathLengthFactor = 1.1,
	}		
			
	data.encounter:SetGoal(goalData)
end

----function checks if the squad can see the scouts coming their way
function CanSeeScout(data)
	
	if Marker_GetName(data.side) == "mkr_hint_charges01" then
	
		Sound_StopMusic(CAMPAIGN_MUSIC_FADEOUT, 0)
		Util_PlayMusic(musicProtectAnia, 0, 3)
	
		--- Hints for demo charges to place
		g_mineHints = {}
		
		-- Reinforcement coming announcement
		Util_StartIntel(EVENTS.Obj2_Reinforcements)
		
		Event_Timer(EventHandler_StartIntel,{intel = EVENTS.Obj2_Reinforcements03_trucks},6)
				
		g_mineHints[1] = HintPoint_Add(mkr_hint_charges01, true, 11035167,1,HPAT_Detonation) -- LOCDB [11035167] 'Place demo charge here'
		
		UI_CreateMinimapBlip( mkr_hint_charges01, 10, BT_CaptureHere ) 
		
		--Bring German trucks in
		
		Event_Timer( BringScoutsInformant,{side = mkr_hint_charges02, canSeeCheck = true},0.1)

	elseif Marker_GetName(data.side) == "mkr_hint_charges02" then
		
		-- Reinforcement coming announcement
		Util_StartIntel(EVENTS.Obj2_Reinforcements02)
		
		g_mineHints[2] = HintPoint_Add(mkr_hint_charges02, true, 11035167,1,HPAT_Detonation) -- LOCDB [11035167] 'Place demo charge here'
		UI_CreateMinimapBlip( mkr_hint_charges02, 10, BT_CaptureHere ) 
		
		--Bring German trucks in
		if g_easyDiff then
			Rule_AddOneShot(BringSecondVehicule,5)
			Rule_AddOneShot(BringThirdVehicule,17)
		else
			Rule_AddOneShot(BringSecondVehicule,3)
			Rule_AddOneShot(BringThirdVehicule,13)
		end
		
	end

end

function OBJ_ProtectAnia_UpdateTimer()
	timeLeft = timeLeft - ( 1 / g_CaptureInformationTime)
	Obj_ShowProgress( 11035343, timeLeft ) -- LOCDB [11035343] 'Time left...'
end

---- function used to add the sniper ability after the Intel played
function AddingNewSnipersAbility()

	-- add ability icon on to get more sniper squads
	M11_SNIPER_DISPATCH02 = BP_GetAbilityBlueprint("M11_SNIPER_DISPATCH02")
	Player_AddAbility(player1, M11_SNIPER_DISPATCH02)
	
	Rule_AddOneShot(StartSniperFlash,2)
	
	Rule_AddDelayedInterval(CheckPlayerSquadsNumber_Informant,1,1)
	
	---get rid of flashing after a while
	Rule_AddOneShot(StopSniperFlash,20)
	
	-- Adding this rule so that the player will get reinforcement from partisans to fill his lost squads

	Rule_AddDelayedInterval(CheckSniperSquadsNumber,2,1)	
end

function StartSniperFlash()
	IdUI_sniper = UI_FlashAbilityButton(ABILITY.SOVIET.M11_SNIPER_DISPATCH02,true)
end

function StopSniperFlash()
	UI_StopFlashing(IdUI_sniper)
end


----- function will check if player can add some partisans
function CheckPlayerSquadsNumber_Informant()
	if Player_GetUnitCount( player1 )  < Player_GetMaxPopulation( player1, CT_Personnel )  then
			UI_SetModalAbilityPhaseCallback( PlayerCallsReinforcementInformant ) 
	else
		UI_ClearModalAbilityPhaseCallback()
	end
end

--- This function checks if players has pressed on the icon ability to bring more snipers in
function PlayerCallsReinforcementInformant(abilityUsed, phaseDone)
	if abilityUsed == ABILITY.SOVIET.M11_SNIPER_DISPATCH02 then
		--- if player clicked on ground to bring troop
		if phaseDone == MAP_Confirmed then
	
			-- check for achievement unlock
			if b_armiakrajowa_sniper == false then
				b_armiakrajowa_sniper = true
			end
			Rule_RemoveIfExist(CheckPlayerSquadsNumber_Informant)
		end
	end
end



-- check time remaining for obj protect Informant and Ania
function CheckTimeRemaining()
	if Objective_GetTimerSeconds( OBJ_CaptureInformantSubProtectAnia ) == 0 then
		Event_Remove(evID_InformantDeath)
		Obj_HideProgress()
		Rule_Remove(OBJ_ProtectAnia_UpdateTimer)
		
		Util_StartIntel(EVENTS.Obj2_CoverUs)
		
		SGroup_SetPlayerOwner( sg_ania, player3 ) 
		SGroup_SetPlayerOwner( sg_informant, player3 )
		
		-- completed objective, call function
		Objective_Complete(OBJ_CaptureInformantSubProtectAnia)
		
		Event_Timer(EventHandler_ObjectiveComplete , {objective = OBJ_CaptureInformant},1)
		
		if g_mineHints ~= nil then
			if g_mineHints[1] ~= nil then
				HintPoint_Remove(g_mineHints[1])
			end
			if g_mineHints[2] ~= nil then
				HintPoint_Remove(g_mineHints[2])
			end
		end

		Rule_RemoveMe()
	end
end

-- function to check if player leaves area around the informant but not needed for now
function CheckPlayerGetOutOfInformantRange()
	if Prox_AreSquadsNearMarker( sg_ania, mkr_informant, ANY ) == false then
		Rule_RemoveMe()
		Objective_StopTimer( OBJ_CaptureInformantSubProtectAnia ) 
		Rule_RemoveIfExist(CheckTimeRemaining)
		Rule_AddInterval(OBJ_CaptureInformant_CheckProx,1)
	end
end


-------------------------------------------------------------------------
-- OBJECTIVE DESTROY RADIO BUILDING - Secondary objective
-------------------------------------------------------------------------
function Initialize_ObjectiveDestroyRadio()
	OBJ_DestroyRadio = {		
		SetupUI = function() 
			hpid_RadioBuilding = Objective_AddUIElements(OBJ_DestroyRadio, eg_radio_building, true, 11034459, true, 3) -- LOCDB [11034459] 'Destroy the Radio Tower'
		end,		
		OnStart = function()
			g_RadioBuildingDestroyed = false			
			eID_DeathRadioBuilding = Event_GroupIsDead( EventHandler_ObjectiveComplete,{objective = OBJ_DestroyRadio}, eg_radio_building, 1 ) 
		end,		
		OnComplete = function()
			g_RadioBuildingDestroyed = true
		end,
		Intel_Start = EVENTS.RadioBuilding_Intro,
		Title = 11034460, -- LOCDB [11034460] 'Destroy the Radio Tower'
		Description = 11034461,	-- LOCDB [11034461] 'Destroy the Radio Tower to stop local reinforcements from coming'
		TitleEnd = 11034460, -- LOCDB [11034462] 'Local reinforcements won't be called in'
		TitleFail = 11034463,	-- LOCDB [11034463] 'You did not stop reinforcement'
		Type = OT_Secondary,				-- Objective Type (OT_Primary, OT_Secondary)
	}
	Objective_Register(OBJ_DestroyRadio)
end

-------------------------------------------------------------------------
-- OBJECTIVE LIBERATE PRISONERS - Primary objective
-------------------------------------------------------------------------
function Initialize_ObjectiveHelpPrisoners()
	OBJ_HelpPrisoners = {		
		SetupUI = function() 
			hpid_prison = Objective_AddUIElements(OBJ_HelpPrisoners, eg_prisongate, true, 11037049, true, 3,nil,HPAT_Detonation) -- LOCDB [11037049] 'Prison: Destroy the gate to liberate the Polish partisan squads'
		end,
		
		OnStart = function()
			Event_GroupIsDead(CapturePrison,nil,eg_prisongate,2)			
			Sound_StopMusic(CAMPAIGN_MUSIC_FADEOUT, 0)
			Util_PlayMusic(musicRescue, 0, 3)
			if campaignDifficulty ~= GD_EASY then
				Player_SetAbilityAvailability(player2, ABILITY.GERMAN.PANZER_GRENADIER_BUNDLED_CAMPAIGN, ITEM_UNLOCKED)
			end
		end,
		
		OnComplete = function()
			Rule_AddOneShot(ThirdBeat_Init,5)
			Util_SetPlayerOwner(eg_reinforcementPtInformant,player2,true)
			Util_SetPlayerOwner(eg_retreatPtInformant,player2,true)			
		end,
		
		Intel_Start = EVENTS.ObjHelpPrisoners_Intro, 
		Intel_Complete = EVENTS.ObjHelpPrisoners_Complete,	
		Title = 11034465,	-- LOCDB [11034465] 'Liberate the prisoners'
		Description = 11034466,	-- LOCDB [11034466] 'Liberate the prisoners by capturing the territory and killing the German in the camp'
		TitleEnd = 11034465,	-- LOCDB [11043329] 'Partisans rescued!'
		TitleFail = 11034468,	-- LOCDB [11034468] 'Partisans not saved'
		Type = OT_Primary,				-- Objective Type (OT_Primary, OT_Secondary)
	}
	Objective_Register(OBJ_HelpPrisoners)
end

-------------------------------------------------------------------------
-- OBJECTIVE LIBERATE PRISONERS - Primary objective - Squad Counter
-------------------------------------------------------------------------
function Initialize_ObjectiveEscapeSquadCounter()
	OBJ_EscapeSquadCounter = {			
		OnStart = function()
			Objective_SetCounter(OBJ_EscapeSquadCounter, g_numberOfSquadsAvailable, g_MaxNumberOfSquadsAvailable)
			World_IncreaseInteractionStage()
			Sound_StopMusic(CAMPAIGN_MUSIC_FADEOUT, 0)
			Util_PlayMusic(musicEscape, 0, 3)
		end,		
		
		Intel_Start = nil,  -- Event will play when obj starts but before any UI appears
		Intel_Complete = nil,			-- Event will play when obj completes but before UI is cleared
		Intel_Fail = nil,				-- Event will play when obj f but before UI is cleared
		Title = 11038389,	-- LOCDB [11038389] 'Partisans Squads Available:'
		Description = 11038403,	-- LOCDB [11038403] 'Total number of Partisans Squads Available:'
		TitleEnd = nil,	-- LOCDB [11034467] 'Partisans available to help if needs be'
		TitleFail = nil,	-- LOCDB [11034468] 'Partisans not saved'
		Type = OT_Secondary,				-- Objective Type (OT_Primary, OT_Secondary)		
	}
	Objective_Register(OBJ_EscapeSquadCounter)
end

-------------------------------------------------------------------------
-- OBJECTIVE ESCAPE - Primary objective
-------------------------------------------------------------------------
function Initialize_ObjectiveEscape()
	OBJ_Escape = {		
		SetupUI = function() 
			hpid_escape = Objective_AddUIElements(OBJ_Escape, mkr_escapePoint, true, 11039029, true, 3)  -- LOCDB [11039029] 'Escape to the extraction point'
		end,
		
		OnComplete = function()
			SGroup_SetInvulnerable(sg_ania,true)
			Event_Timer(MissionComplete, nil, 2)
		end,
		
		Intel_Start = EVENTS.EscapeIntelStart,  -- Event will play when obj starts but before any UI appears
		Intel_Complete = EVENTS.EscapeIntelComplete,			-- Event will play when obj completes but before UI is cleared
		Intel_Fail = nil,				-- Event will play when obj f but before UI is cleared
		Title = 11035273,	 -- LOCDB [11035273] 'Bring Ania to the extraction point'
		Description = 11035274, -- LOCDB [11035274] 'Get Ania to the extraction point to get back to Pozharski. The informant will be waiting for us there'
		TitleEnd =  11035273, -- LOCDB [11035275] 'Reached extraction point'
		TitleFail = nil,		
		Type = OT_Primary,				-- Objective Type (OT_Primary, OT_Secondary)
	}
	Objective_Register(OBJ_Escape)
end

-------------------------------------------------------------------------
--                     FIRST BEAT INIT!!!!!!!!
-------------------------------------------------------------------------
function FirstBeat_Start()
	if g_hardDiff ~= true then
		Event_PlayerOwnsTerritory(CheckIfPlayerOwnHospitalTerritory, nil, player1, eg_territory_hospital) 
	end
		
	eID_ObjDestroyRadio = Event_Proximity(ObjectiveStart_ObjDestroyRadio, nil, player1, {mkr_aroundRadiobuilding, mkr_camp03_radioObjStart}, 38.22, ANY)

	Event_Timer(EventHandler_ObjectiveStart, {objective = OBJ_KillOfficers}, 1)

	FirstBeat_FirstCampEnemies()
	FirstBeat_SecondCampEnemies()
	FirstBeat_ThirdCampEnemies()
	FirstBeat_RadioCampEnemies()
	
	-- Calls to check fire camp in the woods between camp 01 and 02 (forest center low area in map). is it captured yet?
	Event_PlayerOwnsElement(CheckCabinFire, nil, player1, eg_fire01_cabin_turnOn)
	Rule_AddDelayedInterval(CheckFireCamp02,.5,1)
	
	---check death condition of enemies in forest
	Event_GroupIsDead(CheckDeathForestCabinEnemies,nil,sg_forestguards_01)
	
	-----  Ania will let player know about this new technique when she sees it
	eID_teachCampFire = Event_Proximity(ActivateCampFireForest, nil, sg_ania, mkr_approachFireCamp, 30, ANY)
	
	if g_hardDiff ~= true then
		eID_MunitionPost = Event_Proximity(FirstBeat_CheckMunitionPost,nil,player1,mkr_camp01_center,19.31,ANY,10)
	end
	 
	Event_GroupIsDead(FirstBeat_CheckDeathMunitionPost,nil,eg_munitionPt_Target01)
	
	if g_easyDiff ~= true then
		Event_PlayerCanSeeElement(FirstBeat_PlayerCanSeeTruckCamp04,nil,player1,sg_truck_target04,ANY,1)
	end
	
	Event_Proximity(FirstBeat_ChatterBetweenCamps, nil, player1, {mkr_chatterBeforeCamp04, mkr_chatterBeforeCamp04_02}, 40, ANY)
	Event_PlayerCanSeeElement(FirstBeat_GiveHintIfLowMunitions,nil,player1,{eg_territory_camp01,eg_territory_hospital,eg_territoryPt_Radio,eg_territory_camp04,eg_territory_betwInfPrison},ANY,4)	
	
	_skip = function()
		SGroup_Kill(sg_officer_target01)
		SGroup_Kill(sg_officer_target02)
		SGroup_Kill(sg_officer_target04)
		
		_skip = function()
			SGroup_Kill(sg_guardsAll_informant)
		end
	end
end

----	First camp	----
function FirstBeat_FirstCampEnemies()
	sg_guards_target01 = SGroup_CreateIfNotFound("sg_guards_target01")
	sg_officer_target01 = SGroup_CreateIfNotFound("sg_officer_target01")
	
	local encData = {		
		player = player2,
		spawn = mkr_officer_target01,
		sgroups = {sg_officer_target01, sg_allUnits_target01},
		units = {
			{difficulty = GD_EASY, 		sbp = SBP.GERMAN.OFFICER_SQUAD,	spawn = mkr_officer_target01,	},
			{difficulty = GD_NORMAL, 	sbp = SBP.GERMAN.OFFICER_SQUAD,	spawn = mkr_officer_target01,	},
			{difficulty = GD_HARD,		sbp = SBP.GERMAN.OFFICER_SQUAD,	spawn = mkr_officer_target01,	veterancyRank = 1},
		},
	}
	encID_Officer01 = Encounter:Create(encData)		
	modID_OfficerTarget01 = Util_ApplyModifier(sg_officer_target01, "posture_speed_modifier", -1, MUT_Addition)
	
	local encData = {
		player = player2,
		spawn = mkr_camp01_defendPt,
		sgroups = {sg_guards_target01, sg_allUnits_target01},
		units = {
			{difficulty = GD_EASY, 		sbp = SBP.GERMAN.GRENADIER_SQUAD,		},
			{difficulty = GD_NORMAL, 	sbp = SBP.GERMAN.GRENADIER_SQUAD,	veterancyRank = 2},
			{difficulty = GD_HARD,		sbp = SBP.GERMAN.GRENADIER_SQUAD,	veterancyRank = 3},
			
			{sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,	numSquads = 1,	spawn = mkr_middleCamp01},
		},
	}
	encID_guardsOfficer01 = Encounter:Create(encData)
	
	local goalData = {
		name = "Defend",
		range = 60,
		leashRange = 50,
		target = mkr_camp01_defendPt,
	}				
	encID_guardsOfficer01:SetGoal(goalData)
	
	Event_IsUnderAttack(FirstCamp_AttackedReaction, nil, sg_allUnits_target01, ANY, 1)
	
	Event_GroupIsDead(CheckAntennaCampDestroyed, nil,eg_radio_antenna_camp01,2)
	
	-- Check if the player is camouflaged and around the different camps and gives command to attack
	Rule_AddInterval(StartAttackAllHiddenCamp01,2)	
	Rule_AddDelayedInterval(CheckTimeToActivateRadioObj,2,1)
end

function FirstCamp_AttackedReaction()

	sg_tempCamp01 = SGroup_CreateIfNotFound("sg_tempCamp01")
	
	SGroup_GetLastAttacker(sg_allUnits_target01, sg_tempCamp01)		
	
	if SGroup_IsEmpty(sg_tempCamp01) == false and SGroup_IsEmpty(sg_officer_target01) == false then			
		Modifier_Remove(modID_OfficerTarget01 ) 
		
		if g_antenna_camp01_Destroyed == false then
			if evID_ProxRadio == nil then
				Util_StartIntel(EVENTS.RadioCamp_RunningTowards)
				Cmd_Move( sg_officer_target01, mkr_radioAntenna_target01)	
				
				hintAntennaCamp01 = HintPoint_Add(eg_radio_antenna_camp01,true,11038361,2,HPAT_Critical) -- LOCDB [11038361] 'Eliminate the officer before he calls in reinforcement'
				
				radioActivationTime = 10
				if campaignDifficulty == GD_NORMAL then
					radioActivationTime = 7
				elseif campaignDifficulty == GD_HARD then
					radioActivationTime = 5
				end
				
				evID_ProxRadio = Event_Proximity(FirstCamp_RadioActivated, {sg_attackers = sg_tempCamp01}, sg_officer_target01, mkr_radioAntenna_target01,1,ANY,5)					
			end
			
		else	
			Cmd_AttackMove(sg_officer_target01,mkr_officer_target01)
			Ai:RemoveFromAllEncounters(sg_officer_target01)		
			encID_guardsOfficer01:AddSgroup(sg_officer_target01)
		end
	end
end

function FirstCamp_RadioActivated()	
	
	if Objective_IsComplete(OBJ_DestroyRadio) == false then	
		if SGroup_IsEmpty(sg_officer_target01) == false then	
			if g_antenna_camp01_Destroyed == false then			
				sg_vehiclesReinforceCamp01 = SGroup_CreateIfNotFound("sg_vehiclesReinforceCamp01")
				sg_guardsReinforceCamp01 = SGroup_CreateIfNotFound("sg_guardsReinforceCamp01")
	
				local reinforceSpawn = mkr_reinforceFirstCamp01
				
				if Player_CanSeePosition(player1, Util_GetPosition(mkr_reinforceFirstCamp01)) then
					reinforceSpawn = mkr_reinforceFirstCamp02					
					
					if Player_CanSeePosition(player1, Util_GetPosition(mkr_reinforceFirstCamp02)) then
						reinforceSpawn = mkr_reinforceFirstCamp03						
						
						if Player_CanSeePosition(player1, Util_GetPosition(mkr_reinforceFirstCamp02)) then
							reinforceSpawn = mkr_reinforceCamp01
						end
					end
				end
				
				CreateHalftrackSquadWithLocation(sg_vehiclesReinforceCamp01,reinforceSpawn,mkr_reinforcementCamp01,sg_guardsReinforceCamp01,encID_guardsOfficer01)
			
				Rule_AddOneShot(AnnounceReinforcementComing,2)
			end
			
			if SGroup_IsEmpty(sg_officer_target01) == false then
				Cmd_AttackMove(sg_officer_target01, mkr_officer_target01)
				Ai:RemoveFromAllEncounters(sg_officer_target01)		
				encID_guardsOfficer01:AddSgroup(sg_officer_target01)
			end			
		end
		
	elseif SGroup_IsEmpty(sg_officer_target01) == false then
		Cmd_AttackMove(sg_officer_target01, mkr_officer_target01)
		Ai:RemoveFromAllEncounters(sg_officer_target01)		
		encID_guardsOfficer01:AddSgroup(sg_officer_target01)
	end
end

--	Second camp --
function FirstBeat_SecondCampEnemies()
	sg_officer_target02 = SGroup_CreateIfNotFound("sg_officer_target02")
	sg_guardTower_target02 = SGroup_CreateIfNotFound("sg_guardTower_target02")
	sg_guardsAll_target02 = SGroup_CreateIfNotFound("sg_guardsAll_target02")
	sg_guardsPioneer_target02 = SGroup_CreateIfNotFound("sg_guardsPioneer_target02")
	
	--- OFFICER
	local encData = {		
		player = player2,
		spawn = mkr_officer_target02,
		sgroups = {sg_officer_target02},
		units = {
			{difficulty = GD_EASY, 		sbp = SBP.GERMAN.OFFICER_SQUAD,	spawn = mkr_officer_target02,	},
			{difficulty = GD_NORMAL, 	sbp = SBP.GERMAN.OFFICER_SQUAD,	spawn = mkr_officer_target02,	veterancyRank = 1},
			{difficulty = GD_HARD,		sbp = SBP.GERMAN.OFFICER_SQUAD,	spawn = mkr_officer_target02,	veterancyRank = 2},
		},
	}
	encID_Officer02 = Encounter:Create(encData)
	
	--- SNIPER: adding the sniper to the tower
	local encData = {		
		player = player2,
		spawn = mkr_sniper_target02,
		sgroups = {sg_guardTower_target02,sg_guardsAll_target02},
		units = {
			{sbp = SBP.GERMAN.SNIPER_SQUAD,		spawn = eg_sniperTower01_Target02,	numSquads = 1,},
		},
	}
	encID_sniper = Encounter:Create(encData)
	
	local encData = {		
		player = player2,
		spawn = mkr_pioneers_camp02,
		sgroups = {sg_guardsPioneer_target02,sg_guardsAll_target02},
		units = {
			{difficulty = GD_EASY,		sbp = SBP.GERMAN.PIONEER_SQUAD,	spawn = mkr_pioneers_camp02,	load = 2,	numSquads = 1,},
			{difficulty = GD_NORMAL,	sbp = SBP.GERMAN.PIONEER_SQUAD,	spawn = mkr_pioneers_camp02,	load = 3,	numSquads = 1,	upgrades = UPG.GERMAN.PIONEER_FLAMETHROWER},
			{difficulty = GD_HARD,		sbp = SBP.GERMAN.PIONEER_SQUAD,	spawn = mkr_pioneers_camp02,	load = 4,	numSquads = 1,	upgrades = UPG.GERMAN.PIONEER_FLAMETHROWER},
			
			{difficulty = GD_EASY,		sbp = SBP.GERMAN.PIONEER_SQUAD,	spawn = mkr_pioneers_camp02,	},
			{difficulty = GD_NORMAL,	sbp = SBP.GERMAN.PIONEER_SQUAD,	spawn = mkr_pioneers_camp02,	veterancyRank = 2},
			{difficulty = GD_HARD,		sbp = SBP.GERMAN.PIONEER_SQUAD,	spawn = mkr_pioneers_camp02,	veterancyRank = 3},
		},
	}	
	eID_PioneerTarget02 = Encounter:Create(encData)
		
	---- GRENADIERS
	sg_guards_gren_target02 = SGroup_Create("sg_guards_gren_target02")
	local encData = {		
		player = player2,
		spawn = mkr_sniper_target02,
		sgroups = {sg_guards_gren_target02,sg_guardsAll_target02},
		units = {
			{difficulty = GD_EASY,		sbp = SBP.GERMAN.GRENADIER_SQUAD,	spawn = mkr_frontDefense_target02,	},
			{difficulty = GD_NORMAL,	sbp = SBP.GERMAN.GRENADIER_SQUAD,	spawn = mkr_frontDefense_target02,	},
			{difficulty = GD_HARD,		sbp = SBP.GERMAN.GRENADIER_SQUAD,	spawn = mkr_frontDefense_target02,	upgrades = UPG.GERMAN.GRENADIER_MG42_LMG},
		},
	}
	eID_gren_target02 = Encounter:Create(encData)	
	
	---- PANZER GRENADIERS
	sg_guards_gren_target02 = SGroup_Create("sg_guards_gren_target02")
	local encData = {		
		player = player2,
		spawn = mkr_sniper_target02,
		sgroups = {sg_guards_pgren_target02,sg_guardsAll_target02},
		units = {
			{difficulty = GD_EASY,		sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,	spawn = mkr_leftDefense_target02,	},
			{difficulty = GD_NORMAL,	sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,	spawn = mkr_leftDefense_target02,	veterancyRank = 2},
			{difficulty = GD_HARD,		sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,	spawn = mkr_leftDefense_target02,	veterancyRank = 3},
		},
	}
	eID_pgren_target02 = Encounter:Create(encData)	
	
	--- check if the guards in camp 02 are attacked by the player 
	Rule_AddDelayedInterval(CheckSquadAttacked_Camp02,2,1)
	
	---- function checks if all guards in camp02 have been killed except 1 and makes the officer attack
	eid_GroupAllKilledTarget02 = Event_GroupLeftAlive(GroupAllKilled, nil, sg_guardsAll_target02, 1, 1)
		
	--- function that send the guards after the player if they have seen him
	Rule_AddDelayedInterval(followThePlayer,2,3)
	
		-----PIONEERS Around camp fire
	local encData = {		
		player = player2,
		spawn = mkr_cabin,
		sgroups = {sg_forestguards_01},
		units = {
			{difficulty = GD_EASY,		sbp = SBP.GERMAN.PIONEER_SQUAD,	},
			{difficulty = GD_NORMAL,	sbp = SBP.GERMAN.PIONEER_SQUAD,	veterancyRank = 2},
			{difficulty = GD_HARD,		sbp = SBP.GERMAN.PIONEER_SQUAD,	veterancyRank = 3},
		},
	}	
	eID_forestGuards = Encounter:Create(encData)
	
	local goalData = {
			name = "Defend",
			useSkirmishAI = true,
			target = mkr_cabin,
			range = 20,
			leashRange = 20,
		}	
	eID_forestGuards:SetGoal(goalData)
	
	
	--- Function checks if sniper in camp 02 saw the player squads so let players know about it
	eID_sniperProxAnia = Event_Proximity(TellPlayerIfSniperSeesSquad,{sniper = sg_guardTower_target02, shotPosition = mkr_sniperShootsHere },sg_ania,mkr_proxSniperCamp01,33,ANY)
	eID_sniperProxSniperSquad01 = Event_Proximity(TellPlayerIfSniperSeesSquad,{sniper = sg_guardTower_target02, shotPosition = mkr_sniperShootsHere },sg_sniper_player,mkr_proxSniperCamp01,33,ANY)
	eID_sniperProxSniperSquad02 = Event_Proximity(TellPlayerIfSniperSeesSquad,{sniper = sg_guardTower_target02, shotPosition = mkr_sniperShootsHere },sg_sniper02_player,mkr_proxSniperCamp01,33,ANY)
	eID_sniperProxAnia02 = Event_Proximity(TellPlayerIfSniperSeesSquad,{sniper = sg_guardTower_target02, shotPosition = mkr_sniperShootsHere },sg_ania,mkr_proxSniperCamp02,33,ANY)
	eID_sniperProxSniperSquad01_01 = Event_Proximity(TellPlayerIfSniperSeesSquad,{sniper = sg_guardTower_target02, shotPosition = mkr_sniperShootsHere },sg_sniper_player,mkr_proxSniperCamp02,33,ANY)
	eID_sniperProxSniperSquad02_02 = Event_Proximity(TellPlayerIfSniperSeesSquad,{sniper = sg_guardTower_target02, shotPosition = mkr_sniperShootsHere },sg_sniper02_player,mkr_proxSniperCamp02,33,ANY)
end

function FirstBeat_ThirdCampEnemies()
	-------------------------------------------------
	-----  Target 04 Camp - Setting up defenses
	-------------------------------------------------	
	sg_guards_mortar01_target04 = SGroup_CreateIfNotFound("sg_guards_mortar01_target04")
	sg_guards_mortar02_target04 = SGroup_CreateIfNotFound("sg_guards_mortar02_target04")
	sg_guards_mortalAll_target04 = SGroup_CreateIfNotFound("sg_guards_mortalAll_target04")
	sg_guardsAll_target04 = SGroup_CreateIfNotFound("sg_guardsAll_target04")	
	sg_guard_sniper01_target04 = SGroup_CreateIfNotFound("sg_guard_sniper01_target04")
	sg_officer_target04 = SGroup_CreateIfNotFound("sg_officer_target04")
	sg_guards_radioBuilding = SGroup_CreateIfNotFound("sg_guards_radioBuilding")
	
	local encData = {	
		player = player2,
		spawn = mkr_guards_mortar01_target04,
		sgroups = {sg_guards_mortar01_target04,sg_guards_mortalAll_target04, sg_guardsAll_target04},
		units = {			
			{difficulty = {GD_EASY, GD_NORMAL},	sbp = SBP.GERMAN.MORTAR_TEAM_81MM,		spawn = mkr_guards_mortar01_target04,},
			{difficulty = GD_HARD,				sbp = SBP.GERMAN.MORTAR_TEAM_81MM,		spawn = mkr_guards_mortar01_target04,},
		},
	}
	eID_mortar01_target04 = Encounter:Create(encData)
			
	local encData = {	
		player = player2,
		spawn = mkr_guards_mortar02_target04,
		sgroups = {sg_guards_mortar02_target04,sg_guards_mortalAll_target04, sg_guardsAll_target04},
		units = {
			{difficulty = GD_NORMAL,	sbp = SBP.GERMAN.MORTAR_TEAM_81MM,		spawn = mkr_guards_mortar02_target04,	load = 3,},
			{difficulty = GD_HARD,		sbp = SBP.GERMAN.MORTAR_TEAM_81MM,		spawn = mkr_guards_mortar02_target04,	}
		},
	}	
	eID_mortar02_target04 = Encounter:Create(encData)	
	
	local encData = {		
		player = player2,
		spawn = mkr_sniper01_target04,
		sgroups = {sg_guard_sniper01_target04,sg_guardsAll_target04},
		units = {
			{sbp = SBP.GERMAN.SNIPER_SQUAD,		spawn = eg_sniperTower01_Target04,},
		},
	}
	encID_guardTower01_Target04 = Encounter:Create(encData)
		
	local encData = {		
		player = player2,
		spawn = mkr_officer_target04,
		sgroups = {sg_officer_target04, sg_guardsAll_target04},
		units = {
			{difficulty = GD_EASY, 		sbp = SBP.GERMAN.OFFICER_SQUAD,	spawn = mkr_officer_target04,	},
			{difficulty = GD_NORMAL, 	sbp = SBP.GERMAN.OFFICER_SQUAD,	spawn = mkr_officer_target04,	veterancyRank = 2},
			{difficulty = GD_HARD,		sbp = SBP.GERMAN.OFFICER_SQUAD,	spawn = mkr_officer_target04,	veterancyRank = 3},
		},
	}
	encID_Officer04 = Encounter:Create(encData)
	
	local encData = {		
		player = player2,
		spawn = mkr_behindSandbag02_Target04,
		sgroups = {sg_guards_pgren_target04, sg_guardsAll_target04},
		units = {
			{difficulty = GD_EASY, 		sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,	spawn = mkr_behindSandbag02_Target04,	},
			{difficulty = GD_NORMAL, 	sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,	spawn = mkr_behindSandbag02_Target04,	veterancyRank = 1},
			{difficulty = GD_HARD,		sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,	spawn = mkr_behindSandbag02_Target04,	veterancyRank = 2},
			
			{sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,	spawn = mkr_behindSandbag02_Target04,},
			
		},
	}
	eID_pgren_target04 = Encounter:Create(encData)

	--- Check if the squad at camp 04 is attacked
	Rule_AddDelayedInterval(CheckSquadAttacked_Camp04,2,1)
	
	-- function used to tell the officer to escape with truck when squads around him is lower than 2
	eid_GroupAllKilledTarget04 = Event_GroupLeftAlive(GroupAllKilled, nil, sg_guardsAll_target04, 2,1)
	
	Rule_AddDelayedInterval(CheckPlayerSeeMortar,15,2)	
	Rule_AddDelayedInterval(CheckPlayerSeeRadioBuilding,10,2)
	Rule_AddDelayedInterval(PlayerCanSeeSniperCamp02,1,1)
	Rule_AddDelayedInterval(PlayerCanSeeSniperCamp04,1,1)
	
end

function FirstBeat_RadioCampEnemies()
	sg_guard_sniper01_radioB = SGroup_CreateIfNotFound("sg_guard_sniper01_radioB")
	
	local encData = {		
			player = player2,
			spawn = mkr_radio_sniperTower,
			sgroups = {sg_guard_sniper01_radioB,sg_guardsAll_radioB},
			units = {
				{sbp = SBP.GERMAN.SNIPER_SQUAD,		spawn = eg_radio_sniperTower,},
			},
		}
	encID_sniperTower_radioB = Encounter:Create(encData)
	
	---- check when sniper is dead
	Rule_AddSGroupEvent(CheckSniperRadioBDeath,sg_guard_sniper01_radioB,GE_SquadKilled)
	
	local encData = {		
		player = player2,
		spawn = mkr_radioBuilding,
		sgroups = {sg_guards_radioBuilding},
		units = {
			{difficulty = GD_EASY, 		sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,	spawn = mkr_radioBuilding,	load = 3,	},
			{difficulty = GD_NORMAL, 	sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,	spawn = mkr_radioBuilding,	load = 4,	veterancyRank = 1},
			{difficulty = GD_HARD,		sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,	spawn = mkr_radioBuilding,	load = 4,	veterancyRank = 2},
			
			{difficulty = GD_EASY, 		sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,	spawn = mkr_radioBuilding,	load = 2,	},
			{difficulty = GD_NORMAL, 	sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,	spawn = mkr_radioBuilding,	load = 3,	veterancyRank = 2},
			{difficulty = GD_HARD,		sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,	spawn = mkr_radioBuilding,	load = 3,	veterancyRank = 3},
		},
	}
	encID_radioBuilding = Encounter:Create(encData)
		
	-- checks if the player can see the sniper near the radio building
	Rule_AddDelayedInterval(PlayerCanSeeSniperRadioB,1,1)		
end

function FirstBeat_ChatterBetweenCamps()
	
	---- if hard mode there is no infirmary so only chatter possible
	if g_hardDiff ~= true then
	
		--- make sure more than just Ania left
		if SGroup_Count(sg_playerAll) > 1 then
		
		----- if all squads still have units in them
			if SGroup_IsEmpty(sg_sniper02_player) == false and SGroup_IsEmpty(sg_sniper_player) == false then
				
				---- players injured and camp 02 officer is dead
				if ((Squad_Count( SGroup_GetSpawnedSquadAt(sg_sniper02_player,1) )  > 1 and SGroup_GetAvgHealth(sg_sniper02_player) < .99) or (Squad_Count( SGroup_GetSpawnedSquadAt(sg_sniper02_player,1) ) == 1 and SGroup_GetAvgHealth(sg_sniper02_player) < .49)
					or (Squad_Count( SGroup_GetSpawnedSquadAt(sg_sniper_player,1) ) > 1 and SGroup_GetAvgHealth(sg_sniper_player) < .99) or (Squad_Count( SGroup_GetSpawnedSquadAt(sg_sniper_player,1) ) == 1 and SGroup_GetAvgHealth(sg_sniper_player) < .49)
					or  SGroup_GetAvgHealth(sg_ania) < .99)     and  SGroup_IsEmpty(sg_officer_target02) == true then
					Util_StartIntel(EVENTS.VisitInfirmary)
					
				---- players injured and camp 02 officer is NOT dead
				elseif ((Squad_Count( SGroup_GetSpawnedSquadAt(sg_sniper02_player,1) ) > 1 and SGroup_GetAvgHealth(sg_sniper02_player) < .99) or (Squad_Count( SGroup_GetSpawnedSquadAt(sg_sniper02_player,1) ) == 1 and SGroup_GetAvgHealth(sg_sniper02_player) < .49) 
					or (Squad_Count( SGroup_GetSpawnedSquadAt(sg_sniper_player,1) ) > 1 and SGroup_GetAvgHealth(sg_sniper_player) < .99) or (Squad_Count( SGroup_GetSpawnedSquadAt(sg_sniper_player,1) ) == 1 and SGroup_GetAvgHealth(sg_sniper_player) < .49)
					or  SGroup_GetAvgHealth(sg_ania) < .99) and SGroup_IsEmpty(sg_officer_target02) == false then
					Util_StartIntel(EVENTS.ThinkInfirmary)
				
				---- all is fine
				else
					Util_StartIntel(EVENTS.ChatterFiller)
				end
					
		--- if only the 2nd squad has some unit in
			elseif SGroup_IsEmpty(sg_sniper02_player) == false then
			
			---- players injured and camp 02 officer is dead
				if ((Squad_Count( SGroup_GetSpawnedSquadAt(sg_sniper02_player,1) )  > 1 and SGroup_GetAvgHealth(sg_sniper02_player) < .99) or (Squad_Count( SGroup_GetSpawnedSquadAt(sg_sniper02_player,1) ) == 1 and SGroup_GetAvgHealth(sg_sniper02_player) < .49)
					or  SGroup_GetAvgHealth(sg_ania) < .99) and  SGroup_IsEmpty(sg_officer_target02) == true then
						
						Util_StartIntel(EVENTS.VisitInfirmary)
				
				---- players injured and camp 02 officer is NOT dead
				elseif ((Squad_Count( SGroup_GetSpawnedSquadAt(sg_sniper02_player,1) ) > 1 and SGroup_GetAvgHealth(sg_sniper02_player) < .99) or (Squad_Count( SGroup_GetSpawnedSquadAt(sg_sniper02_player,1) ) == 1 and SGroup_GetAvgHealth(sg_sniper02_player) < .49) 
					or  SGroup_GetAvgHealth(sg_ania) < .99) and SGroup_IsEmpty(sg_officer_target02) == false then
						
						Util_StartIntel(EVENTS.ThinkInfirmary)
				
					---- all is fine
				else
					Util_StartIntel(EVENTS.ChatterFiller)
				end
				
		--- if only the 1st squad has some unit in		
			elseif SGroup_IsEmpty(sg_sniper_player) == false then
			
			---- players injured and camp 02 officer is dead
				if ((Squad_Count( SGroup_GetSpawnedSquadAt(sg_sniper_player,1) ) > 1 and SGroup_GetAvgHealth(sg_sniper_player) < .99) or (Squad_Count( SGroup_GetSpawnedSquadAt(sg_sniper_player,1) ) == 1 and SGroup_GetAvgHealth(sg_sniper_player) < .49)
					or  SGroup_GetAvgHealth(sg_ania) < .99)     and  SGroup_IsEmpty(sg_officer_target02) == true then
					Util_StartIntel(EVENTS.VisitInfirmary)
					
				---- players injured and camp 02 officer is NOT dead
				elseif ((Squad_Count( SGroup_GetSpawnedSquadAt(sg_sniper_player,1) ) > 1 and SGroup_GetAvgHealth(sg_sniper_player) < .99) or (Squad_Count( SGroup_GetSpawnedSquadAt(sg_sniper_player,1) ) == 1 and SGroup_GetAvgHealth(sg_sniper_player) < .49)
					or  SGroup_GetAvgHealth(sg_ania) < .99) and SGroup_IsEmpty(sg_officer_target02) == false then
					Util_StartIntel(EVENTS.ThinkInfirmary)
				
					---- all is fine
				else
					Util_StartIntel(EVENTS.ChatterFiller)
				end
		
			end
			
		---if only ania left
		elseif SGroup_GetAvgHealth( sg_ania ) < .99 then
			Util_StartIntel(EVENTS.AloneInfirmary)
		end
	else
		Util_StartIntel(EVENTS.ChatterFiller)
	end
	
	if g_easyDiff then
		SGroup_DeSpawn(sg_truckIntro_target04)
	else	
		MoveFakeTruck()
		MakeVehicleSnipable(sg_truckIntro_target04)		
	end
	
	if g_hardDiff ~= true then
		Rule_AddInterval(CheckPlayerAttackedByMortar,1)
	end
end


function CheckPlayerAttackedByMortar()
	
	sg_mortarsAttacked = SGroup_CreateIfNotFound("sg_mortarsAttacked")
	
	SGroup_GetLastAttacker( sg_player_allSquads, sg_mortarsAttacked) 
	
	if SGroup_IsEmpty(sg_mortarsAttacked) == false then
	
		if SGroup_ContainsBlueprints( sg_mortarsAttacked, BP_GetSquadBlueprint("mortar_team_81mm"), ANY )  then
		
			g_NumberHitsByMortar = g_NumberHitsByMortar + 1
			
			--- if player injured twice by mortars
			if g_NumberHitsByMortar == 2 then
			
				Event_Timer(TellPlayerMortarAttacking,nil,2)
				Rule_RemoveMe()
			end
		end
	end	
	
end

--------------------
---- function will show up a warning if no events running
----------------------------------------------------------------
function TellPlayerMortarAttacking()
	EventCue_Create(CUE.ATTACKED,11045855,11045855,sg_player_allSquads,nil,nil,10,true) -- LOCDB [11045855] 'Mortars! Move your squads'
		--- LOCDB [11026218] 'Mortars!'
end

--------------------------------------------------
--- Checks if the antenna in the camps have been destroyed
--------------------------------------------------
function CheckAntennaCampDestroyed(data)
	antenna = data._group
	--camp 01 antenna
	if EGroup_GetName(antenna) == "eg_radio_antenna_camp01" then
		g_antenna_camp01_Destroyed = true
	
	-- camp 03 antenna
	elseif EGroup_GetName(antenna) == "eg_radio_antenna_camp03" then
		g_antenna_camp03_Destroyed = true		
	end	
end

--------------------------------------------
----              CAMP 01  functions    -----
---------------------------------------------
---- function will add an hint after player has seen it after x seconds
 function FirstBeat_CheckMunitionPost()
	if EGroup_IsEmpty(eg_munitionPt_Target01) == false then
		hintID_muniPt_Target01 = HintPoint_Add(eg_munitionPt_Target01,true,11039030,1.5,HPAT_Hint)  -- LOCDB [11039030] 'Destroy the munition cache with demo charges to gain access to territory'
	end
 end
 
 --- function will remove the hint point on the munition pt of target 01
 function FirstBeat_CheckDeathMunitionPost()
 
	Event_Remove(eID_MunitionPost)
	if hintID_muniPt_Target01 ~= nil then
		HintPoint_Remove(hintID_muniPt_Target01)
	end
 end
 
----- function to check if the officer is next to a radio
function SquadGotNextToRadio(data)	
	sg_closeTo = data._target
	mkr_radio = data._location
	
	-- check if the radio building is still alive
	if Objective_IsComplete(OBJ_DestroyRadio) == false then
		if SGroup_IsEmpty(sg_officer_target03) == false then		
			-- check if the antenna has not been destroyed
			if g_antenna_camp03_Destroyed == false then
			
				sg_vehiclesReinforceCamp03 = SGroup_CreateIfNotFound("sg_vehiclesReinforceCamp03")
				sg_guardsReinforceCamp03 = SGroup_CreateIfNotFound("sg_guardsReinforceCamp03")
			
				if b_StartedAlarm == false then
					StartAlarm()
				end
				-- send a haltrack to the camp
				CreateHalftrackSquadWithLocation(sg_vehiclesReinforceCamp03,mkr_reinforceCamp03,mkr_camp_target03,sg_guardsReinforceCamp03,encID_ReinforceCamp03)
				Rule_AddOneShot(AnnounceReinforcementComing,2)
				HintPoint_Remove(hintAntennaCamp03)
				-- send officer back to defensive position
				if SGroup_IsEmpty(sg_closeTo) == false then
					Cmd_AttackMove(sg_closeTo,mkr_officer_target03)
				end
			end
		end
		
	-- check if the radio building was destroyed 	
	else	
		if SGroup_IsEmpty(sg_closeTo) == false then
			Cmd_AttackMove(sg_closeTo,mkr_officer_target03)
		end
	end
end


function StartAlarm()
	Sound_Play3D("campaign/alarm_klaxon", EGroup_GetSpawnedEntityAt( eg_PrisonSpeaker01, 1) )
	Game_SetGameRestoreCallback(Sound_Play3D, "campaign/alarm_klaxon", EGroup_GetSpawnedEntityAt( eg_PrisonSpeaker01, 1))
	b_StartedAlarm = true
end

----- tell player that reinforcements are coming
function AnnounceReinforcementComing()
	Util_StartIntel(EVENTS.Obj1_RemindReinforce)
end

----- When in camo and around camp 01 then Ania tells to attack
function StartAttackAllHiddenCamp01()
	if SGroup_IsCamouflaged( sg_playerAll, ANY ) and Player_CanSeeSGroup(player1, sg_officer_target01 ,ANY) then
		Rule_RemoveMe()
		Event_Remove(eID_timerCover)
		if hP_cover01 ~= nil then
			HintPoint_Remove(hP_cover01)
		end
	end
end

-------------------------------------------------------------
-----					CAMP 02 functions
-------------------------------------------------------------
--when in camo and around camp 02 then Ania tells to attack
function StartAttackAllHiddenCamp02()
	if SGroup_IsCamouflaged( sg_playerAll, ALL ) and Player_CanSeeSGroup(player1,sg_officer_target02 ,ANY) then
		Util_StartIntel(EVENTS.NearCamp)
		Rule_RemoveMe()
	end
end
																	
---- Function checks if the player has been seen by grenadiers at camp 02, they will follow him if it is the case
function followThePlayer()
	if SGroup_IsEmpty(sg_guards_gren_target02) == false then
		if SGroup_CanSeeSGroup( sg_guards_gren_target02, sg_playerAll, ANY ) then
		
		-- attack the closest player squad 	
			if SGroup_IsEmpty( sg_sniper_player ) and SGroup_CanSeeSGroup( sg_guards_gren_target02, sg_sniper_player, ANY ) then
				lastPosition = World_GetClosest( sg_guards_gren_target02, sg_sniper_player ) 
				
			elseif SGroup_IsEmpty( sg_sniper02_player ) and SGroup_CanSeeSGroup( sg_guards_gren_target02, sg_sniper02_player, ANY ) then
				lastPosition = World_GetClosest( sg_guards_gren_target02, sg_sniper02_player ) 
				
			else 
				lastPosition = World_GetClosest( sg_guards_gren_target02, sg_ania ) 
			end
			
			-- if health is still high, go after player
			if  SGroup_GetAvgHealth(sg_guards_gren_target02) >= .75 then
		
				local goalData = {
					name = "Attack",
					attackMove = true,
					target = lastPosition,
					useSkirmishAI = true,
					maxTime = 15,
					maxIdleTime = 10,
					range = 15,
					leashRange = 20,
					tacticControlsList = {
						{
							tacticType = TACTIC_RushAtTarget,
							priority = 6,
							maxUsers = 4,
							maxRange = 5,
							waitTimeSecs = 12,
						},
						
						{
							tacticType = TACTIC_Cover,
							priority = 5,
							retryTimeSecs = 2,
							waitTimeSecs = 6,
						},
						{
							tacticType = TACTIC_Retaliate,
							priority = 1,
							retryTimeSecs = 5,
							waitTimeSecs = 10,
						},
					},
					
					onSuccess = InformSuccessPioneerCamp02,
					onFailure = InformSuccessPioneerCamp02,
				}
				eID_gren_target02:SetGoal(goalData)
			elseif  SGroup_GetAvgHealth(sg_guards_gren_target02) > 0 then
			
				--call only once
				if g_Camp02IntelFollowDone == false then
					if SGroup_IsEmpty(sg_guards_gren_target02) == false then
						Sound_PlayOnSquad( "speech/sp/mission/m11/ambient/xb_hpg_atk_gege00_nt_m", sg_guards_gren_target02 ) 
					end
					--Util_StartIntel(EVENTS.RunAfterGerman)
					g_Camp02IntelFollowDone = true
				end
			end
		end
	end
end

---- function that lets player know if the sniper saw one of the player squads
function TellPlayerIfSniperSeesSquad(data)
	if SGroup_IsEmpty(data.sniper) == false then
--~ 		local sg_entered = SGroup_CreateIfNotFound("sg_entered")
--~ 		local sg_sniperThatSees = SGroup_CreateIfNotFound("sg_sniperThatSees")
		
		local sg_allsquadsPlayer1 = SGroup_CreateIfNotFound("sg_allsquadsPlayer1")
	
		Player_GetAll(player1,sg_allsquadsPlayer1)
		
		--- to know which one entered the trigger
		sg_entered = data._target
		
		sg_sniperThatSees = data.sniper
		shotPosition = data.shotPosition
		
		---check which camp involved to remove the proper events  ---- CAMP02
		if Marker_GetName( shotPosition ) == "mkr_sniperShootsHere" then
			Event_Remove(eID_sniperProxSniperSquad01)
			Event_Remove(eID_sniperProxSniperSquad02)
			Event_Remove(eID_sniperProxAnia)
			Event_Remove(eID_sniperProxSniperSquad01_01)
			Event_Remove(eID_sniperProxSniperSquad02_02)
			Event_Remove(eID_sniperProxAnia02)
			
			Cmd_Stop(sg_allsquadsPlayer1)
			FOW_PlayerRevealArea( player1, EGroup_GetPosition(eg_sniperTower01_Target02), 3, 10 ) 
--~ 			Camera_MoveTo( eg_sniperTower01_Target02, true) 
--~ 		    Event_Timer(SniperMoveBackCamera,{sg_enteredArea = sg_entered},4)
			
			
			---- INFORMANT CAMP AREA
		elseif Marker_GetName( shotPosition ) == "mkr_ShootHereInformant" then
			Event_Remove(eID_sniperProxAniaInformant)
			Event_Remove(eID_sniperProxSniperSquad01Informant)
			Event_Remove(eID_sniperProxSniperSquad02Informant)
			FOW_PlayerRevealArea( player1, EGroup_GetPosition(eg_sniperTower_informant), 3, 10 ) 
		end
		
		eg_tempShotAt = EGroup_CreateIfNotFound("eg_tempShotAt")

		FOW_PlayerRevealArea( player2, SGroup_GetPosition(sg_entered), 2, 3 ) 
		
		Squad_GiveSlotItem(SGroup_GetSpawnedSquadAt(sg_sniperThatSees, 1), BP_GetSlotItemBlueprint("ground_attack_sniper_rifle_item"))
		
		----- if the sniper cannot see the target, then attack a target set by us	
		Util_CreateEntities(player1, eg_tempShotAt, BP_GetEntityBlueprint("sniper_atk_target"), shotPosition, 1) 
		
		Event_Timer(DelaySniperShot,{shotLocation = shotPosition, sniper = sg_sniperThatSees },1)
		
		

	end
end

function DelaySniperShot(data)
	
		shotPosition = data.shotLocation
		sniper = data.sniper
	
		FOW_PlayerRevealArea( player2, Marker_GetPosition(shotPosition), 2, 3 ) 
		
		------ reveal the area so the sniper will be able to shoot 
		FOW_PlayerRevealArea( player2, EGroup_GetPosition(eg_tempShotAt), 2, 3 ) 
		Cmd_Attack(sniper, eg_tempShotAt)
		
		if SGroup_IsEmpty(sniper) == false then
			Event_Timer(DelayedSniperCall,{sniper = data.sniper, location = shotPosition},4)

		end
		Event_Timer(StopSniperShooting,{sniper = sg_sniperThatSees, tempShotPos = eg_tempShotAt},5)
end
 

-----function will bring the camera back to troop who entered the trigger
function SniperMoveBackCamera(data)
	 
	sg_sendCameraTo = SGroup_CreateIfNotFound("sg_sendCameraTo")
	
	sg_sendCameraTo = data.sg_enteredArea
	
	if SGroup_IsEmpty(sg_sendCameraTo) == false then
		Camera_FocusOnPosition(SGroup_GetPosition(sg_sendCameraTo), false)
	end
	
end

function DelayedSniperCall(data)
	if Event_IsAnyRunning() == false then
		if SGroup_IsEmpty(data.sniper) == false then
			Util_StartIntel(EVENTS.SniperSeesYou)
			
		end
	else
		Event_Timer(DelayedSniperCall,{sniper = data.sniper, location = data.location},1)
	end
end

	
function StopSniperShooting(data)
	Cmd_Upgrade(data.sniper, BP_GetUpgradeBlueprint("sniper_ground_attack_remove"), 1, true)
	EGroup_DeSpawn(data.tempShotPos)
	Cmd_Stop(data.sniper)
end
	
-- check snipers death to remove hints and makes sure the player will be attacked 
function CheckSniperCamp02Death(squad, killer)
	
	--get the squad who killed the officer to send enemies after them
	sg_killer_sniperCamp02 = SGroup_CreateIfNotFound("sg_killer_sniperCamp02")
	Squad_GetLastAttacker( squad, sg_killer_sniperCamp02 )	
	
	--retaliation using the killer squad from player to be attacked by the officer guards
	RetaliateCamp02Attacked( sg_killer_sniperCamp02 )
	
	if g_hardDiff ~= true then
		HintPoint_Remove(hpid_sniper_camp02)
	end
	
	if b_attackedCamp02 == false then
		b_attackedCamp02 = true
		CancelHintsCamp02Fire()
	end
	
end	
	
-- retaliate camp3 when officer dead
function _Officers03_DeadCheck(squad, killer)
	
	sg_killer_camp03 = SGroup_CreateIfNotFound("sg_killer_camp03")
	Squad_GetLastAttacker( squad, sg_killer_camp03 )
	
	RetaliateCamp03Attacked(sg_killer_camp03)
	
	Rule_RemoveIfExist(Officer03_PatrolChange)
end	

-----  function checks if the camp03 has been attacked
function CheckSquadAttacked_Camp03()
	if SGroup_IsEmpty(sg_guardsAll_target03) == false and SGroup_IsUnderAttack(sg_guardsAll_target03, ANY, 1) then
		
		sg_tempCamp03 = SGroup_CreateIfNotFound("sg_tempCamp03")
		
		SGroup_GetLastAttacker(sg_guardsAll_target03, sg_tempCamp03)
		
		RetaliateCamp03Attacked(sg_tempCamp03)
	end
end
	
-----  function checks if the camp02 has been attacked
function CheckSquadAttacked_Camp02()
	
	if SGroup_IsEmpty(sg_guardsAll_target02) == false and SGroup_IsUnderAttack(sg_guardsAll_target02, ANY, 1) then
		
		sg_tempCamp02 = SGroup_CreateIfNotFound("sg_tempCamp02")
		
		SGroup_GetLastAttacker(sg_guardsAll_target02, sg_tempCamp02)
		
		RetaliateCamp02Attacked(sg_tempCamp02)
		if b_attackedCamp02 == false then
			b_attackedCamp02 = true
			CancelHintsCamp02Fire()
		end
	end
end

function RetaliateCamp02Attacked(sgID_killer)

	-- IF we KNOW WHO ATTACKED
	if SGroup_IsEmpty(sgID_killer) == false then
		
		Rule_RemoveIfExist(CheckFireCamp02)
		
		-------- PANZER GRENADIERS ---------
		if SGroup_IsEmpty(sg_guards_pgren_target02) == false then
			
			eID_pgren_target02:ClearGoal()
			--get the last position of the last attacker
			local lastPosition = SGroup_GetPosition(sgID_killer)
			
			-- Tell Panzer Grenadiers to use Bundled Grenades on the player's last location
			local goalData = {
				name = "Ability",
				target = lastPosition,
				attackMove = true,
				useSkirmishAI = true,
				abilityParams = {
					abilityPBG = ABILITY.GERMAN.PANZER_GRENADIER_BUNDLED_CAMPAIGN,
					maxCasters = 1,
					maxRange = 50,
					waitTimeSecs = 5,
					retryTimeSecs = 2,
				},
			
				tacticControlsList = {
						{
							tacticType = TACTIC_RushAtTarget,
							maxUsers = 4,
							maxRange = 40,
							waitTimeSecs = 7,
						},
						{
							tacticType = TACTIC_Ability,
							priority = 1000,
							maxUsers = 4,
							maxRange = 50,
							waitTimeSecs = 8,
							retryTimeSecs = 3,
						},
					},
		--		onFailure = InformSuccessPioneerCamp02_Attack,
				onSuccess = InformSuccessPioneerCamp02_Attack,
			}
			
			local goalData02 = {
				name = "Attack",
				target = lastPosition,
				attackMove = true,
				useSkirmishAI = true,
				maxTime = 30,
				maxIdleTime = 10,
				range = 15,
				leashRange = 20,
				
				onSuccess = InformSuccessPioneerCamp02,
			}
			
			if g_easyDiff then
				eID_pgren_target02:SetGoal(goalData02)
			else
				eID_pgren_target02:SetGoal(goalData)
			end
		
		-- do this only once
			if g_Camp02IntelAttackDone == false then
				if SGroup_IsEmpty(sg_guards_pgren_target02) == false then
					Sound_PlayOnSquad( "speech/sp/mission/m11/ambient/xb_hpg_pin_snigen_lt_s", sg_guards_pgren_target02 ) 
				end
			--	Util_StartIntel(EVENTS.SniperStayGerman)
				g_Camp02IntelAttackDone = true
			end

		end
		
		------- GRENADIERS
		
		--- if grenadiers alive then defend the front area of the camp
		if SGroup_IsEmpty(sg_guards_gren_target02) == false then
		
			eID_gren_target02:ClearGoal()
			local goalData = {
					name = "Defend",
					range = 30,
					leashRange = 20,
					target = mkr_frontDefense_target02,
					useSkirmishAI = g_useSkirmishAI,
					tacticControlsList = {
						{
							tacticType = TACTIC_Help,
							maxUsers = 4,
							maxRange = 5,
							waitTimeSecs = 15,
						},						
					},
				}
				
			eID_gren_target02:SetGoal(goalData)
			Squad_SuggestPosture( SGroup_GetSpawnedSquadAt( sg_guards_gren_target02, 1 ),0, 15)
	
			-- do this only once
			if g_Camp02IntelAttackDone02 == false then
				if SGroup_IsEmpty(sg_guards_gren_target02) == false then
					Sound_PlayOnSquad( "speech/sp/mission/m11/ambient/xb_hpg_pin_snigen_lt_l", sg_guards_gren_target02 ) 
				end
				--Util_StartIntel(EVENTS.SniperPinnedGerman)
				g_Camp02IntelAttackDone02 = true
			
			end
		end
		
		------------- PIONEER with Flamethrower (not for easy mode)
			
			eID_PioneerTarget02:ClearGoal()
			--get the last position of the last attacker
			local lastPosition = SGroup_GetPosition(sgID_killer)

			local goalData = {
				name = "Attack",
				target = lastPosition,
				attackMove = true,
				useSkirmishAI = true,
				maxTime = 30,
				maxIdleTime = 10,
				range = 20,
				leashRange = 30,
				tacticControlsList = {
					{
						tacticType = TACTIC_RushAtTarget,
						priority = 4,
						maxUsers = 4,
						maxRange = 10,
						waitTimeSecs = 10,
					},
				},
			}
			eID_PioneerTarget02:SetGoal(goalData)

		---- OFFICER
		
		-- the officer will go inside the building to protect himself during the attack
		if SGroup_IsEmpty(sg_officer_target02) == false then
			encID_Officer02:ClearGoal()
			
			Cmd_Garrison( sg_officer_target02,eg_cabin_target02 ) 
			

		end
	
	-- IF DONT KNOW WHO ATTACKED
	else
	
		--officer goes inside the building
		if SGroup_IsEmpty(sg_officer_target02) == false then
			encID_Officer02:ClearGoal()
			
			Cmd_Garrison( sg_officer_target02,eg_cabin_target02 ) 
			
		end
			
		-------- PANZER GRENADIERS ---------
		
		--- if panzer are alive they will defend the left side of camp
		if SGroup_IsEmpty(sg_guards_pgren_target02) == false then
			
			eID_pgren_target02:ClearGoal()
			
		
			local goalData = {
				name = "Defend",
				target = mkr_leftDefense_target02,
				useSkirmishAI = true,
				range = 25,
				leashRange = 10,				
				tacticControlsList = {
					{
						tacticType = TACTIC_Help,
						maxUsers = 4,
						maxRange = 5,
						waitTimeSecs = 15,
					},
							
					{
						tacticType = TACTIC_Ability,
						priority = 5,
						maxUsers = 4,
						maxRange = 40,
						waitTimeSecs = 10,
						retryTimeSecs = 5,
					},
				},
			}
			
			eID_pgren_target02:SetGoal(goalData)
			
			-- do this only once
			if g_Camp02IntelAttackDone == false then
				--Util_StartIntel(EVENTS.SniperStayGerman)
				if SGroup_IsEmpty(sg_guards_pgren_target02) == false then
					Sound_PlayOnSquad( "speech/sp/mission/m11/ambient/xb_xs1_buf_gesnge_lt_m", sg_guards_pgren_target02 ) 
				end
				g_Camp02IntelAttackDone = true
			end
		end
		
		------- GRENADIERS
		
		---defend front area of camp 02
		if SGroup_IsEmpty(sg_guards_gren_target02) == false then
		
			eID_gren_target02:ClearGoal()
			local goalData = {
					name = "Defend",
					range = 25,
					leashRange = 10,
					target = mkr_frontDefense_target02,
					useSkirmishAI = g_useSkirmishAI,
					tacticControlsList = {
						{
							tacticType = TACTIC_Cover,
							maxUsers = 4,
							maxRange = 5,
							waitTimeSecs = 15,
						},

					}
					
				}
				eID_gren_target02:SetGoal()
			Squad_SuggestPosture( SGroup_GetSpawnedSquadAt( sg_guards_gren_target02, 1 ),0, 15)
				
			-- do this only once
			if g_Camp02IntelAttackDone02 == false then
				if SGroup_IsEmpty(sg_guards_gren_target02) == false then
					Sound_PlayOnSquad( "speech/sp/mission/m11/ambient/xb_hpg_pin_snigen_lt_s", sg_guards_gren_target02 ) 
				end
				--Util_StartIntel(EVENTS.StayAwayGerman)
				g_Camp02IntelAttackDone02 = true
			end
		end
	end
	
	
end


function InformSuccessPioneerCamp02_Attack(enc)

	local goalData = enc:GetGoalData()

	-- Tell Panzer Grenadiers to use Bundled Grenades on the player's last location
	local goalData = {
		name = "Attack",
		target = goalData.target,
		attackMove = true,
		useSkirmishAI = true,
		abilityParams = {
			abilityPBG = ABILITY.GERMAN.PANZER_GRENADIER_BUNDLED_CAMPAIGN,
			maxCasters = 1,
			maxRange = 60,
			waitTimeSecs = 10,
			retryTimeSecs = 5,
		},
	
		tacticControlsList = {
			{
				tacticType = TACTIC_RushAtTarget,
				priority = 5,
				maxUsers = 4,
				maxRange = 50,
				waitTimeSecs = 7,
			},
			{
				tacticType = TACTIC_Ability,
				priority = 5,
				maxUsers = 4,
				maxRange = 60,
				waitTimeSecs = 10,
				retryTimeSecs = 5,
			},
		},		
	}
	
	enc:SetGoal(goalData)
end

----- function that sends the guards back to camp if no target anymore
function InformSuccessPioneerCamp02(enc)
	local goalData = {
		name = "Defend",
		range = 30,
		leashRange = 20,
		target = mkr_leftDefense_target02,
		useSkirmishAI = g_useSkirmishAI,
		coordinatedSetup = true,
		
		tacticControlsList = {
			{
				tacticType = TACTIC_Help,
				maxUsers = 4,
				maxRange = 5,
				waitTimeSecs = 15,
			},
					
			{
				tacticType = TACTIC_Ability,
				priority = 5,
				maxUsers = 4,
				maxRange = 40,
				waitTimeSecs = 10,
				retryTimeSecs = 5,
			},
		},
	}
	
	enc:SetGoal(goalData)
end

----fucntion that removes the hints if the enemies in the forest are dead
function CheckDeathForestCabinEnemies()
	
	Rule_RemoveIfExist(GetToCamouflageAroundCabinFireCamp)
	HintPoint_Remove(hintCabinFireCover01)
	HintPoint_Remove(hintCabinFireCover02)
	HintPoint_Remove(hintCabinFireCover03)
	HintPoint_Remove(hintCabinFireCover04)
	HintPoint_Remove(hintCabinFire)
	
end

----fucntion that removes the hints if the enemies in the forest are dead
function CancelHintsCamp02Fire()
	
	Rule_RemoveIfExist(GetToCamouflageAroundFireCamp02)
	HintPoint_Remove(hintCamp02FireCover01)
	HintPoint_Remove(hintCamp02FireCover02)
	HintPoint_Remove(hintCamp02FireCover03)
	HintPoint_Remove(hintCamp02Fire)
end

----Fire Camp : teaching for forest area
function ActivateCampFireForest()

	if SGroup_IsEmpty(sg_forestguards_01) == false and b_TeachFireCamp == false then
		--Tell player about the fire camp 
		Util_StartIntel(EVENTS.FireCamp_Intro)
	
---removed because the mechanic is introduced for sure in the first segment of the map	
	--	Event_Remove(eID_teachCampFire02)
		
		hintCabinFire = HintPoint_Add(mkr_fire_cabin,true,11036966,2,HPAT_Critical) -- LOCDB [11036966] 'Campfire: Interact with fire to attract enemies'
		
		
		local nearestMarker = Util_GetClosestMarker( sg_ania, {mkr_fire_cabin_Cover01, mkr_fire_cabin_Cover02, mkr_fire_cabin_Cover03, mkr_fire_cabin_Cover04}) 
		hintCabinFireCover01 = HintPoint_Add(nearestMarker,true,11036965,2,HPAT_CoverGreen) -- LOCDB [11036965] 'Cover: Use this object to hide from the enemy'
		UI_CreateMinimapBlip( mkr_fire_cabin, 10, BT_CaptureHere ) 
		
		b_TeachFireCamp = true
		
		Rule_AddInterval(GetToCamouflageAroundCabinFireCamp,1)
	end
end

----Fire Camp: teach if missed first one
function ActivateCampFireForest02()

	if b_attackedCamp02 == false and b_TeachFireCamp == false then
		--Tell player about the fire camp 
		Util_StartIntel(EVENTS.FireCamp_Intro)
		
		Event_Remove(eID_teachCampFire)
		
		hintCamp02Fire = HintPoint_Add(mkr_fire_camp02,true,11036966,2,HPAT_Critical) -- LOCDB [11036966] 'Campfire: Interact with fire to attract enemies'
		hintCamp02FireCover01 = HintPoint_Add(mkr_fire_camp02_Cover01,true,11036965,2,HPAT_CoverGreen) -- LOCDB [11036965] 'Cover: Use this object to hide from the enemy'
		hintCamp02FireCover02 = HintPoint_Add(mkr_fire_camp02_Cover02,true,11036965,2,HPAT_CoverGreen) -- LOCDB [11036965] 'Cover: Use this object to hide from the enemy'
		hintCamp02FireCover03 = HintPoint_Add(mkr_fire_camp02_Cover03,true,11036965,2,HPAT_CoverGreen) -- LOCDB [11036965] 'Cover: Use this object to hide from the enemy'
		b_TeachFireCamp = true
		UI_CreateMinimapBlip( mkr_fire_camp02, 10, BT_CaptureHere ) 
		Rule_AddInterval(GetToCamouflageAroundFireCamp02,1)
	end
end

function GetToCamouflageAroundCabinFireCamp()

	if SGroup_IsEmpty(sg_sniper_player) == false and SGroup_IsEmpty(sg_sniper02_player) == false then
		if SGroup_IsCamouflaged( sg_sniper_player, ANY ) and SGroup_IsCamouflaged( sg_sniper02_player, ANY )  then
		
			--add an hint to ignite the fire camp
		--	hintCabinFire = HintPoint_Add(mkr_fire_cabin,true,11036966,2,HPAT_Critical) -- LOCDB [11036966] 'Campfire: Interact with fire to attract enemies'
			Event_Timer(EventHandler_RemoveHint,{hint = hintCabinFireCover01},2)
			Event_Timer(EventHandler_RemoveHint,{hint = hintCabinFireCover02},2)
			Event_Timer(EventHandler_RemoveHint,{hint = hintCabinFireCover03},2)
			Event_Timer(EventHandler_RemoveHint,{hint = hintCabinFireCover04},2)
			
			Rule_RemoveMe()
			--add an hint to ignite the fire camp
		--	hint_FireCampCabin = HintPoint_Add(eg_fire01_cabin_turnOn,true,11035063,4) -- LOCDB [11035063] 'Campfire to ignite'
		end
	elseif SGroup_IsEmpty(sg_sniper_player) == false then 
		if SGroup_IsCamouflaged( sg_sniper_player, ANY )  then
		
			--add an hint to ignite the fire camp
		--	hintCabinFire = HintPoint_Add(mkr_fire_cabin,true,11036966,2,HPAT_Critical) -- LOCDB [11036966] 'Campfire: Interact with fire to attract enemies'
			Event_Timer(EventHandler_RemoveHint,{hint = hintCabinFireCover01},2)
			Event_Timer(EventHandler_RemoveHint,{hint = hintCabinFireCover02},2)
			Event_Timer(EventHandler_RemoveHint,{hint = hintCabinFireCover03},2)
			Event_Timer(EventHandler_RemoveHint,{hint = hintCabinFireCover04},2)
			Rule_RemoveMe()
			--add an hint to ignite the fire camp
		--	hint_FireCampCabin = HintPoint_Add(eg_fire01_cabin_turnOn,true,11035063,4) -- LOCDB [11035063] 'Campfire to ignite'
		end
	elseif SGroup_IsEmpty(sg_sniper02_player) == false then
		if SGroup_IsCamouflaged( sg_sniper02_player, ANY )  then
		
			--add an hint to ignite the fire camp
		--	hintCabinFire = HintPoint_Add(mkr_fire_cabin,true,11036966,2,HPAT_Critical) -- LOCDB [11036966] 'Campfire: Interact with fire to attract enemies'
			Event_Timer(EventHandler_RemoveHint,{hint = hintCabinFireCover01},2)
			Event_Timer(EventHandler_RemoveHint,{hint = hintCabinFireCover02},2)
			Event_Timer(EventHandler_RemoveHint,{hint = hintCabinFireCover03},2)
			Event_Timer(EventHandler_RemoveHint,{hint = hintCabinFireCover04},2)
			Rule_RemoveMe()
			--add an hint to ignite the fire camp
		--	hint_FireCampCabin = HintPoint_Add(eg_fire01_cabin_turnOn,true,11035063,4) -- LOCDB [11035063] 'Campfire to ignite'
		end
	else
		--add an hint to ignite the fire camp
		--	hintCabinFire = HintPoint_Add(mkr_fire_cabin,true,11036966,2,HPAT_Critical) -- LOCDB [11036966] 'Campfire: Interact with fire to attract enemies'
			Event_Timer(EventHandler_RemoveHint,{hint = hintCabinFireCover01},2)
			Event_Timer(EventHandler_RemoveHint,{hint = hintCabinFireCover02},2)
			Event_Timer(EventHandler_RemoveHint,{hint = hintCabinFireCover03},2)
			Event_Timer(EventHandler_RemoveHint,{hint = hintCabinFireCover04},2)
			Rule_RemoveMe()
	end

end

----if didnt teach at first fire camp then do it for camp 02
function GetToCamouflageAroundFireCamp02()

	if SGroup_IsEmpty(sg_sniper_player) == false and SGroup_IsEmpty(sg_sniper02_player) == false then
		if SGroup_IsCamouflaged( sg_sniper_player, ANY ) and SGroup_IsCamouflaged( sg_sniper02_player, ANY )  then
		
			--add an hint to ignite the fire camp
			hintCamp02Fire = HintPoint_Add(mkr_fire_camp02,true,11036966,2,HPAT_Critical) -- LOCDB [11036966] 'Campfire: Interact with fire to attract enemies'
			Event_Timer(EventHandler_RemoveHint,{hint = hintCamp02FireCover01},2)
			Event_Timer(EventHandler_RemoveHint,{hint = hintCamp02FireCover02},2)
			Event_Timer(EventHandler_RemoveHint,{hint = hintCamp02FireCover03},2)
			Rule_RemoveMe()
			--add an hint to ignite the fire camp
		--	hint_FireCampCabin = HintPoint_Add(eg_fire01_cabin_turnOn,true,11035063,4) -- LOCDB [11035063] 'Campfire to ignite'
		end
	elseif SGroup_IsEmpty(sg_sniper_player) == false then 
		if SGroup_IsCamouflaged( sg_sniper_player, ANY )  then
		
			--add an hint to ignite the fire camp
			hintCamp02Fire = HintPoint_Add(mkr_fire_camp02,true,11036966,2,HPAT_Critical) -- LOCDB [11036966] 'Campfire: Interact with fire to attract enemies'
			Event_Timer(EventHandler_RemoveHint,{hint = hintCamp02FireCover01},2)
			Event_Timer(EventHandler_RemoveHint,{hint = hintCamp02FireCover02},2)
			Event_Timer(EventHandler_RemoveHint,{hint = hintCamp02FireCover03},2)
			Rule_RemoveMe()
			--add an hint to ignite the fire camp
		--	hint_FireCampCabin = HintPoint_Add(eg_fire01_cabin_turnOn,true,11035063,4) -- LOCDB [11035063] 'Campfire to ignite'
		end
	elseif SGroup_IsEmpty(sg_sniper02_player) == false then
		if SGroup_IsCamouflaged( sg_sniper02_player, ANY )  then
		
			--add an hint to ignite the fire camp
			hintCamp02Fire = HintPoint_Add(mkr_fire_camp02,true,11036966,2,HPAT_Critical) -- LOCDB [11036966] 'Campfire: Interact with fire to attract enemies'
			Event_Timer(EventHandler_RemoveHint,{hint = hintCamp02FireCover01},2)
			Event_Timer(EventHandler_RemoveHint,{hint = hintCamp02FireCover02},2)
			Event_Timer(EventHandler_RemoveHint,{hint = hintCamp02FireCover03},2)
			Rule_RemoveMe()
			--add an hint to ignite the fire camp
		--	hint_FireCampCabin = HintPoint_Add(eg_fire01_cabin_turnOn,true,11035063,4) -- LOCDB [11035063] 'Campfire to ignite'
		end
	else
		--add an hint to ignite the fire camp
			hintCamp02Fire = HintPoint_Add(mkr_fire_camp02,true,11036966,2,HPAT_Critical) -- LOCDB [11036966] 'Campfire: Interact with fire to attract enemies'
			Event_Timer(EventHandler_RemoveHint,{hint = hintCamp02FireCover01},2)
			Event_Timer(EventHandler_RemoveHint,{hint = hintCamp02FireCover02},2)
			Event_Timer(EventHandler_RemoveHint,{hint = hintCamp02FireCover03},2)
			Rule_RemoveMe()
	end
end

function CheckCabinFire()
	HintPoint_Remove(hintCabinFire)
	HintPoint_Remove(hintCabinFireCover01)
	HintPoint_Remove(hintCabinFireCover02)
	HintPoint_Remove(hintCabinFireCover03)
	HintPoint_Remove(hintCabinFireCover04)
	
	if Rule_Exists(GetToCamouflageAroundCabinFireCamp) then
		Rule_Remove(GetToCamouflageAroundCabinFireCamp)
	end
	Rule_AddOneShot(SendSquadToInvestigateCabinFire,3)
		
end

function SendSquadToInvestigateCabinFire()
	--- check if any forest guards are left if so give them a goal to get near fire camp
	if SGroup_TotalMembersCount( sg_forestguards_01 ) > 0 then
		
		local goalData = {
			name = "Attack",
			useSkirmishAI = true,
			target = mkr_fire_cabin,
			maxTime = 60,
			maxIdleTime = 10,
			range = 8,
			leashRange = 15,
			onSuccess = FireCabinUnitGetBackToPatrol,
			onFailure = FireCabinUnitGetBackToPatrol,
		}

		eID_forestGuards:SetGoal(goalData)
		
		-- forest guards go to investigate and tells about it 
		Util_StartIntel(EVENTS.InvestigatingFire02German)
	end
end

-- fire cabin squad will go back to the cabin after attack
function FireCabinUnitGetBackToPatrol(eID_forestGuards)
	
	local goalData = {
			name = "Defend",
			useSkirmishAI = true,
			target = mkr_cabin,
			maxTime = 10,
			range = 8,
		}
	
	eID_forestGuards:SetGoal(goalData)
end

-- check if fire near camp 02 was lighted and will attract enemies around
function CheckFireCamp02()

--check if captured by player
	if Player_OwnsEGroup(player1, eg_fire01_target02_turnOn, ANY ) then
		Rule_RemoveMe()
		
		--remove hint
		HintPoint_Remove(hintCamp02Fire)
		HintPoint_Remove(hintCamp02FireCover01)
		HintPoint_Remove(hintCamp02FireCover02)
		HintPoint_Remove(hintCamp02FireCover03)
		
		--- check if any forest guards are left if so give them a goal to get near fire camp
		if SGroup_TotalMembersCount( sg_guards_pgren_target02 ) > 0 then
			
			local goalData = {
				name = "Attack",
				useSkirmishAI = true,
				target = mkr_fire_camp02,
				maxTime = 60,
				maxIdleTime = 10,
				range = 8,
				leashRange = 15,
				onSuccess = FireCamp02UnitGetBackToPatrol,
				onFailure = FireCamp02UnitGetBackToPatrol,
			}
			
			eID_pgren_target02:SetGoal(goalData)
			
			-- panzer gren go to investigate and tells about it 
			if SGroup_IsEmpty(sg_guards_pgren_target02) == false then
				Sound_PlayOnSquad( "speech/sp/mission/m11/ambient/xb_hpg_atm_genge0_nt_m", sg_guards_pgren_target02 ) 
			end
		end
	end
end

-- fire cabin camp 02 will go back to the main camp after attack
function FireCamp02UnitGetBackToPatrol(eID_pgren_target02)
	
	local goalData = {
		name = "Defend",
		useSkirmishAI = true,
		target = mkr_leftDefense_target02,
		range = 8,		
		tacticControlsList = {				
			{
				tacticType = TACTIC_Ability,
				priority = 5,
				maxUsers = 4,
				maxRange = 40,
				waitTimeSecs = 10,
				retryTimeSecs = 5,
			},
		},
	}
	
	eID_forestGuards:SetGoal(goalData)
end


-------------------------------------------------------------
-----					CAMP 03 functions
-------------------------------------------------------------
--- Changes the patrol randomly of the officer in the camp 03
function Officer03_PatrolChange()
	
	patrolToSet = Table_GetRandomItem( g_Officer03_patrols ) 
	encID_Officer03:SetGoal(patrolToSet)
	
end

----- Check if the player can see the prison
function CheckWhenAroundCamp03Prison()
	if Player_CanSeePosition( player1, Marker_GetPosition(mkr_camp_target03_prison) ) or Player_CanSeePosition( player1, Marker_GetPosition(mkr_camp_target03_prison02) )  then
		--Ania sees the prisoners
		Util_StartIntel(EVENTS.HelpPrisoners)
		Rule_RemoveMe()
		
	end
end

---- start objective when close to prisons
function ObjectiveStart_HelpPrisoners()
	
	---- create unarmed partisan in the prison camp
	sg_partisan_noweapon01 = SGroup_CreateIfNotFound("sg_partisan_noweapon01")
	sg_partisan_noweapon02 = SGroup_CreateIfNotFound("sg_partisan_noweapon02")
	Util_CreateSquads(player5, sg_partisan_noweapon01, BP_GetSquadBlueprint("m11_partisan_squad_noweapon"), mkr_partisanPrison01) 
	Util_CreateSquads(player5, sg_partisan_noweapon02, BP_GetSquadBlueprint("m11_partisan_squad_noweapon"), mkr_partisanPrison02) 
	
	SGroup_SetPlayerOwner( sg_ania, player1 ) 
	SGroup_SetInvulnerable( sg_ania, true ) 
	
	---ungarrison Squads ania and informant 
	Cmd_UngarrisonSquad(sg_ania,mkr_surrender_informant,false)
	Cmd_UngarrisonSquad(sg_informant,mkr_surrender_informant,false)
	
	--- change owner of ania squad so players cant use her anymore
	Rule_AddDelayedInterval(waitAniaOut,2,1)
end

function waitAniaOut()

----check if ania is out of the building before doing anything else
	if SGroup_IsInHoldEntity( sg_ania,ANY ) == false then
		Rule_RemoveMe()
--~ 		--- change owner of ania squad so players cant use her anymore
--~ 		SGroup_SetPlayerOwner( sg_ania, player1 ) 
		
		SGroup_SetPlayerOwner( sg_informant, player4 )
		SGroup_SetInvulnerable( sg_informant, 0.1 ) 
		SGroup_SetInvulnerableToCritical(sg_informant, true)
		
		Event_Timer(ChangeInvulnerabilitySetting,nil,3)
		
		Rule_RemoveSGroupEvent( CheckInformantDeath, sg_informant )
		
		---- creating a squad to bring informant to safety so players dont need to care
		Util_CreateSquads(player4, sg_sniper_safety, BP_GetSquadBlueprint("m11_sniper_team"), mkr_extraSquad_StartingPt)
		SGroup_SetInvulnerable( sg_sniper_safety, 0.1 ) 
		SGroup_SetInvulnerableToCritical(sg_sniper_safety, true)
		
		Rule_Add(GetPrisonObjectiveStartedPre)
	end
end

function GetPrisonObjectiveStartedPre()
	if Event_IsAnyRunning() == false then
		Event_Timer(GetPrisonObjectiveStarted,nil,2)
		Rule_RemoveMe()
	end
end

function GetPrisonObjectiveStarted()
	
----- Starting objective to liberate the prisoners
	Objective_Start(OBJ_HelpPrisoners)
	
	Rule_AddSGroupEvent(_Officers03_DeadCheck,sg_officer_target03,GE_SquadKilled)
	
	Event_Proximity(StayOffRoad,nil,player1,mkr_OffRoad,40,ANY)
	--- help player for direction
	Event_Proximity(ProvideDirectionToPrison,nil,player1,mkr_GoThisWayPrison,35.00,ANY)
	
	Rule_Add(SetBeat03)
end


-----provide a direction for players to get to the prison
function ProvideDirectionToPrison()
	Rule_Add(ProvideDirectionToPrisonSpeech)
end

function ProvideDirectionToPrisonSpeech()
	if Event_IsAnyRunning() == false then
		Rule_RemoveMe()
		Event_Timer(EventHandler_StartIntel,{intel = EVENTS.ObjHelpPrisoners_Direction},2)
	end
end

function SetBeat03()
	if Event_IsAnyRunning() == false then
		Rule_RemoveMe()
		
		World_IncreaseInteractionStage()
		--- ania telling new squad to help the informant while they go to the prison camp
		Util_StartIntel(EVENTS.GetInformantToSafety)
		
		-- informant moves to safety
		Cmd_MoveToAndDespawn(sg_informant,mkr_informant_safety)
		Cmd_MoveToAndDespawn(sg_sniper_safety,mkr_informant_safety)
		
		--sets up the guards in the prison area
		Beat03_Setup()
	end
end

----- function that will set the Camp 03 guards to do stuff
function Beat03_Setup()		
	-----  Target 03 CAMP 03 - Setting up defenses 
	g_Officer03_patrols = {}
	
	local goalData = {
		name = "Defend",
		useSkirmishAI = true,
		pickupWeapons = -1,
		patrolParams = {
			path = "patrol_officer03_fuel",
			wait = 2,
		},
	}	
	local goalData02 = {
		name = "Defend",
		useSkirmishAI = true,
		pickupWeapons = -1,
		patrolParams = {
			path = "patrol_officer03_firecamp",
			wait = 5,
		},
	}
	
	g_Officer03_patrols[1]= goalData
	g_Officer03_patrols[2]= goalData02
		
	local encData = {		
		player = player2,
		spawn = mkr_officerSpawn_target03,
		sgroups = {sg_officer_target03},
		units = {
			{difficulty = GD_EASY, 		sbp = SBP.GERMAN.OFFICER_SQUAD,	spawn = mkr_officerSpawn_target03,	},
			{difficulty = GD_NORMAL, 	sbp = SBP.GERMAN.OFFICER_SQUAD,	spawn = mkr_officerSpawn_target03,	veterancyRank = 2},
			{difficulty = GD_HARD,		sbp = SBP.GERMAN.OFFICER_SQUAD,	spawn = mkr_officerSpawn_target03,	veterancyRank = 3},
		},
	}
	encID_Officer03 = Encounter:Create(encData)
	
	modID_OfficerTarget03 = Util_ApplyModifier(sg_officer_target03, "posture_speed_modifier", -1, MUT_Addition)
	encID_Officer03:SetGoal(goalData)
	
	--change the patrol every 60 seconds
	Rule_AddInterval(Officer03_PatrolChange,60)
	
	--- Setting up guards from camp 03			
	sg_guards01_target03 = SGroup_CreateIfNotFound("sg_guards01_target03")
	sg_guards02_target03 = SGroup_CreateIfNotFound("sg_guards02_target03")
	sg_guards03_target03 = SGroup_CreateIfNotFound("sg_guards03_target03")
	
	local encData = {		
		player = player2,
		spawn = mkr_mg42_defend_camp03,
		sgroups = {sg_guardsAll_target03},
		units = {
			{difficulty = GD_EASY,		sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,	sgroups = {sg_guards01_target03},	spawn = mkr_camp_target03_prison,},
			{difficulty = GD_NORMAL,	sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,	sgroups = {sg_guards01_target03},	spawn = mkr_camp_target03_prison, 	veterancyRank = 2},
			{difficulty = GD_HARD,		sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,	sgroups = {sg_guards01_target03}, spawn = mkr_camp_target03_prison, 	veterancyRank = 3},
		},
	}	
	g_encID_guards01_T3 = Encounter:Create(encData)
	
	local encData = {		
		player = player2,
		spawn = mkr_mg42_defend_camp03,
		sgroups = {sg_guardsAll_target03},
		units = {			
			{difficulty = GD_EASY,				sbp = SBP.GERMAN.PIONEER_SQUAD,	sgroups = {sg_guards02_target03},	spawn = mkr_grenadiers_defend_camp03,},
			{difficulty = {GD_NORMAL, GD_HARD},	sbp = SBP.GERMAN.PIONEER_SQUAD,	sgroups = {sg_guards02_target03},	spawn = mkr_grenadiers_defend_camp03, upgrades = UPG.GERMAN.PIONEER_FLAMETHROWER,},
		},
	}	
	g_encID_guards02_T3 = Encounter:Create(encData)
	
	local encData = {		
		player = player2,
		spawn = mkr_mg42_defend_camp03,
		sgroups = {sg_guardsAll_target03},
		units = {
			{difficulty = GD_EASY,		sbp = SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD,	sgroups = {sg_guards03_target03}, spawn = mkr_mg42_defend_camp03,		load = 3,},
			{difficulty = GD_NORMAL,	sbp = SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD,	sgroups = {sg_guards03_target03},	spawn = mkr_mg42_defend_camp03, 	veterancyRank = 1},
			{difficulty = GD_HARD,		sbp = SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD,	sgroups = {sg_guards03_target03}, spawn = mkr_mg42_defend_camp03, 	veterancyRank = 2},
		},
	}	
	g_encID_guards03_T3 = Encounter:Create(encData)
		
	local goalData = {
		name = "Defend",
		range = 25,
		leashRange = 5,
		target = mkr_grenadiers_defend_camp03,
		useSkirmishAI = g_useSkirmishAI,		
		tacticControlsList = {								
			{
				tacticType = TACTIC_Ability,
				priority = 5,
				maxUsers = 4,
				maxRange = 40,
				waitTimeSecs = 10,
				retryTimeSecs = 5,
			},			
			{
				tacticType = TACTIC_Cover,
				priority = 15,
				retryTimeSecs = 3,
				waitTimeSecs = 6,
			},
			{
				tacticType = TACTIC_Retaliate,
				priority = 8,
				retryTimeSecs = 5,
				waitTimeSecs = 10,
			},
		},
	}				
	g_encID_guards01_T3:SetGoal(goalData)
	
	local goalData = {
		name = "Defend",
		range = 5,
		leashRange = 15,
		target = mkr_pioneer_defend_camp03,
		useSkirmishAI = g_useSkirmishAI,
	}
	g_encID_guards02_T3:SetGoal(goalData)
				
	local goalData = {
		name = "Defend",
		range = 15,
		leashRange = 2,
		target =  mkr_mg42_defend_camp03,
		useSkirmishAI = g_useSkirmishAI,
		coordinatedSetup = true,
		coordinatedSetupFacingPositions = {mkr_camp03_facing02},
	}				
	g_encID_guards03_T3:SetGoal(goalData)	
	
	--- function will check if squads at camp 03 are attacked
	Rule_AddDelayedInterval(CheckSquadAttacked_Camp03,2,1)
	
	--- Will check if camp 03 antenna is destroyed
	Event_GroupIsDead(CheckAntennaCampDestroyed,nil,eg_radio_antenna_camp03,2)	
	
	----- to start the check for camp fires around the camp 03
	evId_CheckPlayerAroundTarget03 = Event_Proximity(CheckIfPlayerAroundCampTarget03, nil,player1,mkr_camp03,60.78,ANY)
	evId_CheckPlayerAroundTarget03 = Event_Proximity(CheckIfPlayerAroundCampTarget03Fire, nil,sg_ania,mkr_camp03,60.78,ANY)
end

----- Check if partisans were saved need to capture territory with prison. releasing the prisoners will provide you with more squads and snipers if yours die
function CapturePrison()		
	--- Objective completed 
	Objective_Complete(OBJ_HelpPrisoners)
	if b_StartedAlarm == false then
		StartAlarm()
	end
	BeginnerHint_RemoveOpportunity(hintID_SniperCover)
	
	EGroup_InstantCaptureStrategicPoint( eg_territory_prison, player1 ) 
	
	-- check if rule to add snipers exists then remove it to add new rule for general partisans
	Rule_Remove(CheckSniperSquadsNumber)

	SGroup_SetPlayerOwner( sg_partisan_noweapon01, player3 ) 
	SGroup_SetPlayerOwner( sg_partisan_noweapon02, player3 ) 
	
	---- move the partisans out of the prison
	Cmd_Move(sg_partisan_noweapon01,mkr_partisanPrison01_exit)
	Cmd_Move(sg_partisan_noweapon02,mkr_partisanPrison02_exit)
	
	Rule_AddDelayedInterval(CheckPlayerSquadsNumber,2,1)
	
	--- set new point for retreat
	Util_SetPlayerOwner(eg_retreatPtPrison,player1,true)
	Util_SetPlayerOwner(eg_retreatPt_beforeInformant,player2,true)
end

---------- Proximity check on Ania near prison
function AniaToCapturePrison()
	EGroup_DeSpawn(eg_munitionPostPrison)
end

-----  Check if the camp 03 people are under attacked
function RetaliateCamp03Attacked(sgID_killer)
	
	--remove the possibility to use the camp fires
	Rule_RemoveIfExist(CheckFires_Target03)
	
	--if attacker is still alive
	if SGroup_IsEmpty(sgID_killer) == false then
		
		------ PIONEERS attack the player squad who attacked
		if SGroup_IsEmpty(sg_guards02_target03) == false then
			
			lastLocation = SGroup_GetPosition(sgID_killer)
			g_encID_guards02_T3:ClearGoal()
			
			local goalData = {
				name = "Attack",
				target = lastLocation,
				attackMove = true,
				useSkirmishAI = true,
				maxTime = 30,
			--	maxIdleTime = 10,
				range = 15,
				leashRange = 20,
				onSuccess = InformSuccessPioneerCamp03,
		--		onFailure = InformSuccessPioneerCamp03,
			}
			
			if g_Camp03IntelAttackDone02 == false then
				if SGroup_IsEmpty(sg_guards02_target03) == false then
					Sound_PlayOnSquad( "speech/sp/mission/m11/ambient/xb_hpg_atk_gege00_nt_m", sg_guards02_target03 ) 
				end
				--Util_StartIntel(EVENTS.RunAfterGerman)
				g_Camp03IntelAttackDone02 = true
			end
			g_encID_guards02_T3:SetGoal(goalData)
		end
	
		--- PANZER GRENADIERS defend the camp 
		if SGroup_IsEmpty(sg_guards01_target03) == false then
	
			local goalData = {
					name = "Defend",
					range = 60,
					leashRange = 70,
					target = mkr_grenadiers_defend_camp03,   --mkr_mg42_defend02_camp03,
					useSkirmishAI = g_useSkirmishAI,
				}
				
			g_encID_guards01_T3:SetGoal(goalData)
		end
		
		----- MG42 SQUAD defend your position
		if SGroup_IsEmpty(sg_guards03_target03) == false then
	
			local goalData = {
				name = "Defend",
				range = 15,
				leashRange = 15,
				target = mkr_mg42_defend_camp03,
				useSkirmishAI = g_useSkirmishAI,
				coordinatedSetup = true,
				coordinatedSetupFacingPositions = {mkr_camp03_facing02},
				tacticControlsList = {
					{
						tacticType = TACTIC_Help,
						maxUsers = 4,
						maxRange = 50,
						waitTimeSecs = 30,
					},
					{
						tacticType = TACTIC_TeamWeapon,
						maxUsers = 4,
						maxRange = 50,
						waitTimeSecs = 5,
					},						
				}
			}
				
			g_encID_guards03_T3:SetGoal(goalData)
			
		end
		
		-- if officer is still alive
		if SGroup_IsEmpty(sg_officer_target03) == false then
			
			-- stop patrol
			Rule_RemoveIfExist(Officer03_PatrolChange)
			encID_Officer03:ClearGoal()
			Modifier_Remove(modID_OfficerTarget03 ) 
			--- if antenna in camp 03 still intact then go call help
			if g_antenna_camp03_Destroyed == false then
			
				-- only call reinforcement once
				if evID_ProxRadio03 == nil then
					
					--move to radio and once beside it call reinforcement
--~ 					Util_StartIntel(EVENTS.CallReinforcementGerman)
					
					Sound_Play3D("speech/sp/mission/m11/11034487", Squad_EntityAt(SGroup_GetSpawnedSquadAt(sg_officer_target03, 1),0))
					Cmd_Move( sg_officer_target03, mkr_radioAntenna_target03)
					evID_ProxRadio03 = Event_Proximity(SquadGotNextToRadio, {sg_attackers = sgID_killer} , sg_officer_target03,mkr_radioAntenna_target03,1,ANY,10)
					
					hintAntennaCamp03 = HintPoint_Add(eg_radio_antenna_camp03,true,11038361,2,HPAT_Critical) -- LOCDB [11038361] 'Eliminate the officer before he calls in reinforcement'
					
					Event_GroupIsDead(EventHandler_RemoveHint, {hint = hintAntennaCamp03},sg_officer_target03, 2)
				end
			
			-- if antenna was destroyed
			else	
				Cmd_AttackMove(sg_officer_target03,mkr_officer_target03,2)
			end
		end
	end
end

------ function called when done with attack
function InformSuccessPioneerCamp03(enc)
	
	local goalData = {
		name = "Defend",
		range = 40,
		leashRange = 2,
		target = mkr_mg42_defend02_camp03,
		useSkirmishAI = g_useSkirmishAI,
		coordinatedSetup = true,
		
		tacticControlsList = {
						
			{
				tacticType = TACTIC_Ability,
				priority = 5,
				maxUsers = 4,
				maxRange = 40,
				waitTimeSecs = 10,
				retryTimeSecs = 5,
			},
			
			{
				tacticType = TACTIC_Cover,
				priority = 5,
				retryTimeSecs = 3,
				waitTimeSecs = 5,
			},
			{
				tacticType = TACTIC_Retaliate,
				priority = 3,
				retryTimeSecs = 5,
				waitTimeSecs = 10,
			},
		},
	}
	enc:SetGoal(goalData)
end

--- function called when player is close to camp 03
function CheckIfPlayerAroundCampTarget03Fire()
	if SGroup_TotalMembersCount( sg_guards01_target03 ) > 0 then
		Util_StartIntel(EVENTS.FireCamp_Camp03)	
		Rule_AddInterval(CheckFires_Target03,3)		
	end
end
--- function called when player is close to camp 03
function CheckIfPlayerAroundCampTarget03()
	
	-- function to check if player sees the prisoners
	Rule_AddInterval(CheckWhenAroundCamp03Prison,1)
	
	Event_Proximity(CheckIfCloseToPartisan,nil,player1,mkr_camp_prisonersHelp,20.45,ANY)
		
end

----- this function will make the partisan shout for help
function CheckIfCloseToPartisan()

	Util_StartIntel(EVENTS.LiberateUs01)
	Event_Timer(EventHandler_StartIntel,{intel = EVENTS.LiberateUs02 },3)
	
	Event_Timer(EventHandler_StartIntel,{intel = EVENTS.LiberateUs03 },8)
end

-- check if fire camps near the PRISON CAMP have been captured and will attract enemies around
function CheckFires_Target03() 

----for fire camp 01 near prison camp
	if Player_OwnsEGroup(player1,eg_fire01_turnOn,ANY) and g_fire01_target03 == false then 
	
	---so we know if we used this camp to attract before and how many we used so far
		g_fire01_target03 = true
		g_NumberOfFireCaptured_target03 = g_NumberOfFireCaptured_target03 + 1
		
		----goal to investigate
		local goalData = {
				name = "Attack",
				attackMove = false,
				attackEngagementMove = false,
				useSkirmishAI = true,
				target = mkr_fire01_target03,
				maxTime = 10,
				maxIdleTime = 10,
				range = 1,
				leashRange = 15,
				onSuccess = FireUnitTarget03GetBackToPatrol,
				onFailure = FireUnitTarget03GetBackToPatrol,
				
				tacticControlsList = {
						
					{
						tacticType = TACTIC_Ability,
						priority = 5,
						maxUsers = 4,
						maxRange = 40,
						waitTimeSecs = 10,
						retryTimeSecs = 5,
					},
					
				},
			}
		--- ----send Grenadiers to investigate -- check if some still alive
		if SGroup_TotalMembersCount( sg_guards01_target03 ) > 0 then
			g_encID_guards01_T3:ClearGoal()
			g_encID_guards01_T3:SetGoal(goalData)
			g_Camp03GrenGoneAtFire = true
	
			---grenadiers tell they are coming
--~ 			Util_StartIntel(EVENTS.InvestigatingFireGerman)
			if SGroup_IsEmpty(sg_guards01_target03) == false then
				Sound_PlayOnSquad( "speech/sp/mission/m11/ambient/xb_hpg_atm_genge0_nt_m", sg_guards01_target03 ) 
				
			end
			
		---- send the Pioneers to go investigate if alive
		elseif SGroup_TotalMembersCount( sg_guards02_target03 ) > 0 then
			g_encID_guards02_T3:ClearGoal()
			g_encID_guards02_T3:SetGoal(goalData)
			g_Camp03PioneerGoneAtFire = true
			
				---grenadiers tell they are coming
			Util_StartIntel(EVENTS.InvestigatingFire02German)
			
		end
		
	----for fire camp 02 near prison camp	
	elseif Player_OwnsEGroup(player1,eg_fire02_turnOn,ANY) and g_fire02_target03 == false then 
	
	---so we know if we used this camp to attract before and how many we used so far
		g_fire02_target03 = true
		g_NumberOfFireCaptured_target03 = g_NumberOfFireCaptured_target03 + 1
		
		
		----goal to investigate
		local goalData = {
				name = "Attack",
				attackMove = false,
				attackEngagementMove = false,
				useSkirmishAI = true,
				target = mkr_fire02_target03,
				maxTime = 10,
				maxIdleTime = 10,
				range = 1,
				leashRange = 15,
				onSuccess = FireUnitTarget03GetBackToPatrol,
				onFailure = FireUnitTarget03GetBackToPatrol,
				tacticControlsList = {
						
					{
						tacticType = TACTIC_Ability,
						priority = 5,
						maxUsers = 4,
						maxRange = 40,
						waitTimeSecs = 10,
						retryTimeSecs = 5,
					},
				},
			}
		
		--- ----send Grenadiers to investigate -- check if some still alive
		if SGroup_TotalMembersCount( sg_guards01_target03 ) > 0 then
			g_encID_guards01_T3:ClearGoal()
			g_encID_guards01_T3:SetGoal(goalData)
			g_Camp03GrenGoneAtFire = true
			
			---grenadiers tell they are coming
			if SGroup_IsEmpty(sg_guards01_target03) == false then
				Sound_PlayOnSquad( "speech/sp/mission/m11/ambient/xb_hpg_atm_genge0_nt_m", sg_guards01_target03 ) 
			end
		--	Util_StartIntel(EVENTS.InvestigatingFireGerman)
		
			---- send the Pioneers to go investigate if alive
		elseif SGroup_TotalMembersCount( sg_guards02_target03 ) > 0 then
			g_encID_guards02_T3:ClearGoal()
			g_encID_guards02_T3:SetGoal(goalData)
			g_Camp03PioneerGoneAtFire = true
			
			---pioneers tell they are coming
			Util_StartIntel(EVENTS.InvestigatingFire02German)
		end
		
	----for fire camp 03 near prison camp	
	elseif Player_OwnsEGroup(player1,eg_fire03_turnOn,ANY) and g_fire03_target03 == false then 
	
		---so we know if we used this camp to attract before and how many we used so far
		g_fire03_target03 = true
		g_NumberOfFireCaptured_target03 = g_NumberOfFireCaptured_target03 + 1
		
		----goal to investigate
		local goalData = {
				name = "Attack",
				attackMove = false,
				attackEngagementMove = false,
				useSkirmishAI = true,
				target = mkr_fire03_target03,
				maxTime = 10,
				maxIdleTime = 10,
				range = 1,
				leashRange = 15,
				onSuccess = FireUnitTarget03GetBackToPatrol,
				onFailure = FireUnitTarget03GetBackToPatrol,
				tacticControlsList = {
				
					{
						tacticType = TACTIC_Ability,
						priority = 5,
						maxUsers = 4,
						maxRange = 40,
						waitTimeSecs = 10,
						retryTimeSecs = 5,
					},
				},
			}
		
		--- ----send Grenadiers to investigate -- check if some still alive
		if SGroup_TotalMembersCount( sg_guards01_target03 ) > 0 then
			g_encID_guards01_T3:ClearGoal()
			g_encID_guards01_T3:SetGoal(goalData)
			g_Camp03GrenGoneAtFire = true
			
			---grenadiers tell they are coming
			if SGroup_IsEmpty(sg_guards01_target03) == false then

				Sound_PlayOnSquad( "speech/sp/mission/m11/ambient/xb_hpg_atm_genge0_nt_m", sg_guards01_target03 ) 
			end
		--	Util_StartIntel(EVENTS.InvestigatingFireGerman)
			
		---- send the Pioneers to go investigate if alive
		elseif SGroup_TotalMembersCount( sg_guards02_target03 ) > 0 then
			g_encID_guards02_T3:ClearGoal()
			g_encID_guards02_T3:SetGoal(goalData)
			g_Camp03PioneerGoneAtFire = true
			
			---pioneers tell they are coming
			Util_StartIntel(EVENTS.InvestigatingFire02German)
		end
	end
	
	--- check if all the fire camps have been used, then remove the rule to check them
	if g_NumberOfFireCaptured_target03 == 3 then
		Rule_RemoveMe()
	end
end

-- fire investigation team squad will go back to the camp
function FireUnitTarget03GetBackToPatrol(enc)

	local goalData = {
			name = "Defend",
			useSkirmishAI = true,
			target = mkr_camp_target03,
			maxTime = -1,
			range = 3,
			--onFailure = InformFailure
			tacticControlsList = {

				{
					tacticType = TACTIC_Ability,
					priority = 5,
					maxUsers = 4,
					maxRange = 40,
					waitTimeSecs = 10,
					retryTimeSecs = 5,
				},
			},
		}
	enc:ClearGoal()
	enc:SetGoal(goalData)
end


-------------------------------------------------------------
-----					CAMP 04 functions
------------------------------------------------------------
----- function checks if player in camp and around camp 04	
function StartAttackAllHiddenCamp04()
	if SGroup_IsCamouflaged( sg_playerAll, ALL ) and Player_CanSeeSGroup(player1,sg_officer_target04 ,ANY) then
		Util_StartIntel(EVENTS.NearCamp)
		Rule_RemoveMe()
	end
end

--- if player can see the mortar squads then tell to shoot them first
function CheckPlayerSeeMortar()

	if Player_CanSeeSGroup( player1, sg_guards_mortalAll_target04, ANY )  then
		Rule_Add(DelayedMortarCalled)
		Rule_RemoveMe()
	end
	
end
	
function DelayedMortarCalled()
	if Event_IsAnyRunning() == false then
		Rule_RemoveMe()
		
		Event_Timer(EventHandler_StartIntel,{intel = EVENTS.TakeMortarTeam},1)
		
		---- add a game event when see mortars
		EventCue_Create(CUE.ATTACKED,11026218,11026218,sg_guards_mortalAll_target04,nil,nil,10,true) --- LOCDB [11026218] 'Mortars!'
		
		if g_hardDiff ~= true then
			Cmd_Ability(player2, ABILITY.GLOBAL.SP_SINGLE_SHOT_MORTAR, Util_GetPositionAwayFromPlayer( mkr_mortarStrikeAway, player1, 36.00, 5 ) )
		end
	
	end
end	
	
---- check if the player can see the truck ready to leave	
function FirstBeat_PlayerCanSeeTruckCamp04()
	if Event_IsAnyRunning() == false then
		Util_StartIntel(EVENTS.Obj1_Target04TruckIntro)
		Rule_AddOneShot(ShowTruckTarget04,3)
	else
		Event_Timer(FirstBeat_PlayerCanSeeTruckCamp04,nil,1)
	end
end	

function ShowTruckTarget04()
	hID_transportOfficer = HintPoint_Add(sg_truck_target04,true,11041913,2,HPAT_Critical) -- LOCDB [11041913] 'Officer Transport Truck'
	
	----add a game even to look at transport truck
	EventCue_Create(CUE.VEHICLE,11041913,11041913,sg_truck_target04,nil,nil,10,false)
end

---- checks if the player can see the sniper tower in camp 04
function PlayerCanSeeSniperCamp04()
	---if can see tower
	if Player_CanSeeEGroup( player1, eg_sniperTower01_Target04, ANY) then
		
		if g_hardDiff ~= true then	
			---- add hint over the sniper tower
			hpid_sniper_camp04 = HintPoint_Add(eg_sniperTower01_Target04, true, 11036702,4,HPAT_Hint) -- LOCDB [11036702] 'German Sniper'
		end
		EventCue_Create(CUE.ATTACKED,11023513,11023513,eg_sniperTower01_Target04,nil,nil,10,true) -- LOCDB [11023513] 'Sniper!'
		
		---- reveal area over tower so player can shoot the sniper who might be at other window hidden to player 
		FOW_RevealArea( EGroup_GetPosition(eg_sniperTower01_Target04), 5, -1 ) 
		
		---- check when sniper is dead
--~ 		Event_GroupIsDead(CheckSniperCamp04Death,nil,sg_guard_sniper01_target04)
		Rule_AddSGroupEvent(CheckSniperCamp04Death,sg_guard_sniper01_target04,GE_SquadKilled)
		
		Rule_RemoveMe()
	end
end

-- check snipers death to remove hints
function CheckSniperCamp04Death(squad, killer)
	
	--get the squad who killed the officer to send enemies after them
	sg_killer_sniperCamp04 = SGroup_CreateIfNotFound("sg_killer_sniperCamp04")
	
	Squad_GetLastAttacker( squad, sg_killer_sniperCamp04 )	
	
	--retaliation using the killer squad from player to be attacked by the officer guards
	RetaliateCamp04Attacked( sg_killer_sniperCamp04 )
	HintPoint_Remove(hpid_sniper_camp04)
end


---- function checks if the guards in camp04 have been attacked
function CheckSquadAttacked_Camp04()
	
	if SGroup_IsEmpty(sg_guardsAll_target04) == false and SGroup_IsUnderAttack(sg_guardsAll_target04, ANY, 1) then
		
		--- get the last attacker from player squad 
		sg_tempCamp04 = SGroup_CreateIfNotFound("sg_tempCamp04")
		SGroup_GetLastAttacker(sg_guardsAll_target04, sg_tempCamp04)
		
		RetaliateCamp04Attacked( sg_tempCamp04 )
	end
end

function RetaliateCamp04Attacked( sgID_killer )	

	-- IF KNOW WHO ATTACKED
	if SGroup_IsEmpty(sgID_killer) == false then
		
		
		-------- PANZER GRENADIERS go attack the player squad
		if SGroup_IsEmpty(sg_guards_pgren_target04) == false then
			
			eID_pgren_target04:ClearGoal()
			
			local lastPosition = SGroup_GetPosition(sgID_killer)
			
			local goalData = {
				name = "Ability",
				attackMove = true,
				target = lastPosition,
				useSkirmishAI = true,
				abilityParams = {
					abilityPBG = ABILITY.GERMAN.PANZER_GRENADIER_BUNDLED_CAMPAIGN,
					maxCasters = 1,
					maxRange = 50,
					waitTimeSecs = 5,
					retryTimeSecs = 2,
				},
						onSuccess = InformSuccessPioneerCamp04,
				}
				
			local goalDataEasy = {
				name = "Attack",
				target = lastPosition,
				useSkirmishAI = true,
				range = 20,
				leashRange = 40,
			
			}
			
			if g_easyDiff then
				eID_pgren_target04:SetGoal(goalDataEasy)
			else 
				eID_pgren_target04:SetGoal(goalData)
			end
		end
		
		------- Mortar 01

		---- mortar attack player from distance
		if SGroup_IsEmpty(sg_guards_mortar01_target04) == false then
			eID_mortar01_target04:ClearGoal()
			local goalData = {
					name = "Defend",
					range = 40,
					leashRange = 30,
					target = mkr_behindSandbag01_Target04,
					useSkirmishAI = g_useSkirmishAI,
					tacticControlsList = {
						{
							tacticType = TACTIC_TeamWeapon,
							maxUsers = 4,
							maxRange = 50,
							waitTimeSecs = 20,
						},
					}
				}
				
			eID_mortar01_target04:SetGoal(goalData)
			
			---- team will say they are attacking once
			if g_Camp04IntelAttackDone == false then
				if SGroup_IsEmpty(sg_guards_mortar01_target04) == false then
					Sound_PlayOnSquad( "speech/sp/mission/m11/ambient/xs_mrt_atk_gege00_nt_s", sg_guards_mortar01_target04 ) 
				end
			--	Util_StartIntel(EVENTS.MortarGerman)
				g_Camp04IntelAttackDone = true
			end
		end
		
		------- Mortar 02
		--make sure re-adding auto target

		----- mortar team 02 attacking from distance
		if SGroup_IsEmpty(sg_guards_mortar02_target04) == false then
			eID_mortar02_target04:ClearGoal()
			local goalData = {
					name = "Attack",
					range = 30,
					leashRange =30,
					target = mkr_guards_mortar02_target04,
					useSkirmishAI = g_useSkirmishAI,
					tacticControlsList = {
						{
							tacticType = TACTIC_TeamWeapon,
							maxUsers = 4,
							maxRange = 50,
							waitTimeSecs = 20,
						},
					}
				}
			
			eID_mortar02_target04:SetGoal(goalData)
					end

		---- OFFICER will go hide inside building
		if SGroup_IsEmpty(sg_officer_target04) == false then
			encID_Officer04:ClearGoal()
			
			if bGarrisonOfficerTarget04 == false then
				Cmd_Garrison( sg_officer_target04,eg_hideout_target4 ) 
				bGarrisonOfficerTarget04 = true
			end 
		end
	
	-- IF DONT KNOW WHO ATTACKED
	else
		---- OFFICER will go hide inside building
		if SGroup_IsEmpty(sg_officer_target04) == false then
			encID_Officer04:ClearGoal()
			
			Cmd_Garrison( sg_officer_target04,eg_hideout_target4 ) 
		end
		-------- PANZER GRENADIERS will defend the area---------
		if SGroup_IsEmpty(sg_guards_pgren_target04) == false then
			
			eID_pgren_target04:ClearGoal()
			
			local goalData = {
				name = "Defend",
				target = mkr_behindSandbag03_Target04,
				useSkirmishAI = true,
				range = 25,
				leashRange = 10,
				abilityParams = {
					abilityPBG = ABILITY.GERMAN.PANZER_GRENADIER_BUNDLED_CAMPAIGN,
				},
				tacticControlsList = {
							{
								tacticType = TACTIC_Ability,
								priority = 5,
								maxUsers = 4,
								maxRange = 5,
								waitTimeSecs = 10,
							},
							
						},
			}
			
			eID_pgren_target04:SetGoal(goalData)
		end
		
		------- MORTARS 01 will stay in cover
		
		if SGroup_IsEmpty(sg_guards_mortar01_target04) == false then
			eID_mortar01_target04:ClearGoal()
			local goalData = {
					name = "Defend",
					range = 25,
					leashRange = 30,
					target = mkr_behindSandbag01_Target04,
					useSkirmishAI = g_useSkirmishAI,
					tacticControlsList = {
						{
							tacticType = TACTIC_Cover,
							maxUsers = 4,
							maxRange = 10,
							waitTimeSecs = 5,
						},
					}
					
				}
				
			eID_mortar01_target04:SetGoal(goalData)
			
		end
		
		------- MORTARS 02 will stay in cover
		
		if SGroup_IsEmpty(sg_guards_mortar02_target04) == false then
			eID_mortar02_target04:ClearGoal()
			local goalData = {
					name = "Defend",
					range = 25,
					leashRange = 30,
					target = mkr_behindSandbag04_Target04,
					useSkirmishAI = g_useSkirmishAI,
					tacticControlsList = {
						{
							tacticType = TACTIC_Cover,
							maxUsers = 4,
							maxRange = 10,
							waitTimeSecs = 5,
						},
					}
					
				}
				
			eID_mortar02_target04:SetGoal(goalData)
			
		end
	end
end

-----function used when attack was done and go back to camp to defend
function InformSuccessPioneerCamp04(enc)
		
		local goalData = enc:GetGoalData()
		
		-- Tell Panzer Grenadiers to use Bundled Grenades on the player's last location
				local goalData = {
					name = "Attack",
					target = goalData.target,
					attackMove = true,
					useSkirmishAI = true,
					abilityParams = {
						abilityPBG = ABILITY.GERMAN.PANZER_GRENADIER_BUNDLED_CAMPAIGN,
						maxCasters = 1,
						maxRange = 30,
						waitTimeSecs = 5,
						retryTimeSecs = 4,
					},
				
					tacticControlsList = {
							{
								tacticType = TACTIC_RushAtTarget,
								priority = 5,
								maxUsers = 4,
								maxRange = 30,
								waitTimeSecs = 7,
							},
							{
								tacticType = TACTIC_Ability,
								priority = 5,
								maxUsers = 4,
								maxRange = 40,
								waitTimeSecs = 5,
								retryTimeSecs = 4,
							},
						},
				
				}
				
		enc:SetGoal(goalData)
end


----------------------------------------------------------------------------
------------                    RADIO BUILDING functions
--------------------------------------------------------------------------------													
--function to check if squad at radio building has been destroyed
function CheckSquadAttacked_RadioBuilding()

	if SGroup_IsEmpty(sg_guardsAll_radioB) == false and SGroup_IsUnderAttack(sg_guardsAll_radioB, ANY, 1) then
	
		---- get the last attacker squad
		sg_tempRadio = SGroup_CreateIfNotFound("sg_tempRadio")
		SGroup_GetLastAttacker(sg_guardsAll_radioB, sg_tempRadio)
		
		RetaliateRadioBAttacked(sg_tempRadio)
	end
end

----- function checks who killed the sniper and returns that unit
function CheckSniperRadioBDeath(squad,killer)

	
	HintPoint_Remove(hpid_sniper_RadioB)
	
	--get the squad who killed the officer to send enemies after them
	sg_killer_sniperRadioB = SGroup_CreateIfNotFound("sg_killer_sniperRadioB")
	Squad_GetLastAttacker( squad, sg_killer_sniperRadioB )	
	
	--retaliation using the killer squad from player to be attacked by the officer guards
	RetaliateRadioBAttacked( sg_killer_sniperRadioB )
end

---- function used to send units after the killer
function RetaliateRadioBAttacked(sgID_killer)
		---- if the attacker has been found	
		
		if SGroup_IsEmpty(sgID_killer) == false then
		
			encID_radioBuilding:ClearGoal()
	
					-- Tell Panzer Grenadiers to use Bundled Grenades on the player's last location
			local lastPosition = SGroup_GetPosition(sgID_killer)		
					
			local goalData = {
				name = "Ability",
				attackMove = true,
				target = lastPosition,
				useSkirmishAI = true,
				range = 20,
			--	leashRange = 40,
				abilityParams = {
					abilityPBG = ABILITY.GERMAN.PANZER_GRENADIER_BUNDLED_CAMPAIGN,
					maxCasters = 1,
					maxRange = 50,
					waitTimeSecs = 5,
					retryTimeSecs = 4,
				},

						onSuccess = InformSuccessPioneerRadio,
			}
				
 			----attack the player 
			local goalData02 = {
					name = "Attack",
					range = 20,
					leashRange = 40,
					target = lastPosition,
					useSkirmishAI = g_useSkirmishAI,
				}
				
			if g_easyDiff then
				encID_radioBuilding:SetGoal(goalData02)
			else
				encID_radioBuilding:SetGoal(goalData)
			end
			
		---- German squad say they are going to investigate once	
			if g_RadioBuildingIntelAttackDone == false then
					if SGroup_IsEmpty(sg_guards_radioBuilding) == false then
						Sound_PlayOnSquad( "speech/sp/mission/m11/ambient/xb_hpg_atk_gege00_nt_m", sg_guards_radioBuilding ) 
					end
					--Util_StartIntel(EVENTS.RunAfterGerman)
					g_RadioBuildingIntelAttackDone = true
			end

		end
end

-----function used when attack was done and go back to camp to defend
function InformSuccessPioneerRadio(enc)
		
		local goalData = enc:GetGoalData()
		
		-- Tell Panzer Grenadiers to use Bundled Grenades on the player's last location
				local goalData = {
					name = "Attack",
					target = goalData.target,
					attackMove = true,
					useSkirmishAI = true,
					abilityParams = {
						abilityPBG = ABILITY.GERMAN.PANZER_GRENADIER_BUNDLED_CAMPAIGN,
						maxCasters = 1,
						maxRange = 60,
						waitTimeSecs = 10,
						retryTimeSecs = 5,
					},
				
					tacticControlsList = {
							{
								tacticType = TACTIC_RushAtTarget,
								priority = 5,
								maxUsers = 4,
								maxRange = 50,
								waitTimeSecs = 7,
							},
							{
								tacticType = TACTIC_Ability,
								priority = 4,
								maxUsers = 2,
								maxRange = 60,
								waitTimeSecs = 10,
								retryTimeSecs = 5,
							},
						},
				
				}
				
		enc:SetGoal(goalData)
end

---- Function will check if the player can see the radio building
function CheckPlayerSeeRadioBuilding()
	if Player_CanSeeEGroup(player1, eg_radio_building,ANY) then
	
		----Ania will talk about the reinforcement possible from this radio building
		Util_StartIntel(EVENTS.RadioBuilding_ToDestroy)
		Rule_RemoveMe()
	end
end

---- checks if the player can see the sniper tower in camp 04
function PlayerCanSeeSniperRadioB()
	---if can see tower
	if Player_CanSeeEGroup( player1, eg_radio_sniperTower, ANY) then
		
		if g_hardDiff ~= true then
			---- add hint over the sniper tower
			hpid_sniper_RadioB = HintPoint_Add(eg_radio_sniperTower, true, 11036702,4,HPAT_Hint) -- LOCDB [11036702] 'German Sniper'
		end	
		EventCue_Create(CUE.ATTACKED,11023513,11023513,eg_radio_sniperTower,nil,nil,10,true) -- LOCDB [11023513] 'Sniper!'
		---- reveal area over tower so player can shoot the sniper who might be at other window hidden to player 
		FOW_RevealArea( EGroup_GetPosition(eg_radio_sniperTower), 5, -1 ) 
		
--~ 		---- check when sniper is dead
--~ 		Rule_AddSGroupEvent(CheckSniperRadioBDeath,sg_guard_sniper01_radioB,GE_SquadKilled)
		
		Rule_RemoveMe()
	end
end

----------------------------------------------------------------------------
------------                    GENERAL FUNCTIONS BELOW
--------------------------------------------------------------------------------
----function that will check if the player as taken over territories to get munitions
function FirstBeat_GiveHintIfLowMunitions(data)
	
	eg_element = SGroup_CreateIfNotFound("eg_element")
	
	eg_element = data.seenElements[1]
	t_territoryToCheck = data._elements
	
	if World_IsTerritorySectorOwnedByPlayer( player1, World_GetTerritorySectorID( EGroup_GetPosition(eg_element) )) == false then		

		if Player_GetResource(player1,RT_Munition) < 59 then
			
			hID_LowMun = HintPoint_Add(eg_element,true,11040530,2,HPAT_Hint) --- LOCDB [11040530] 'Capture a territory to increase your amount of munition available'
			Event_Timer(EventHandler_RemoveHint,{hint = hID_LowMun},10)
		
		else
			
			Event_PlayerCanSeeElement(FirstBeat_GiveHintIfLowMunitions,nil,player1,t_territoryToCheck,ANY,4)
		end
		
	else
		if table.getn(t_territoryToCheck) > 1 then
			
			for k,element in pairs(t_territoryToCheck) do
				if element == eg_element then
					table.remove(t_territoryToCheck, k)
				end
			end
			
			Event_PlayerCanSeeElement(FirstBeat_GiveHintIfLowMunitions,nil,player1,t_territoryToCheck,ANY,4)
		end
		
	end
end
																	
-- Called when inumberleftAlive left in a sgroup															
function GroupAllKilled(data)

	sg_check = data._group
	---number still alive
	inumberleftAlive = data._amount
	
	
	----if for camp 02
	if SGroup_GetName(sg_check) == "sg_guardsAll_target02" then
	
		---if officer camp 02 not dead
		if SGroup_IsEmpty(sg_officer_target02) == false then
		
			--- make officer get out of building and defend the area
			
			local goalData = {
						name = "Defend",
						range = 30,
						leashRange = 20,
						target = mkr_frontDefense_target02,
						useSkirmishAI = g_useSkirmishAI,
						}
		--	encID_Officer02:SetGoal(goalData)
		end
		
	---if for camp 04
	elseif SGroup_GetName(sg_check) == "sg_guardsAll_target04" then
	
		---if officer in camp 04 is still alive
		if SGroup_IsEmpty(sg_officer_target04) == false then
		
			if g_easyDiff ~= true then
				Util_StartIntel(EVENTS.Obj1_Target04TruckLeaving)
			end
			
			-- make officer get out of building
			Cmd_UngarrisonSquad( sg_officer_target04, Marker_GetPosition(mkr_truck_camp04) )
			
			Cmd_Move(sg_officer_target04,mkr_truck_camp04,true)
			--Rule_AddOneShot(MakeSureTarget04OutBunker,2)
			
			if g_easyDiff ~= true then
				---- check if the officer is near the truck and make him flee
				Rule_AddInterval(GetInTruck,1)
				
				local eg_mortarToDelete = EGroup_CreateIfNotFound("eg_mortarToDelete")
	
				t_mortars = {
						BP_GetEntityBlueprint("granatewerfer_34_81mm_mortar")
					}
				World_GetEntitiesNearMarker(player2, eg_mortarToDelete, mkr_GetRidOfAllMortars, OT_Neutral)
				EGroup_Filter(eg_mortarToDelete, t_mortars, FILTER_KEEP)
			--	EGroup_Kill(eg_mortarToDelete)
				EGroup_DeSpawn(eg_mortarToDelete)
			end
		end
	end
end


---function checks if the officer is next to the truck and leaves with him
function GetInTruck()

	if Prox_AreSquadsNearMarker(sg_officer_target04,mkr_truck_camp04,ANY,10) then
	
	--check if officer still alive
		if SGroup_IsEmpty(sg_officer_target04) == false then
			Rule_RemoveMe()
			
			HintPoint_Remove(hID_transportOfficer)
			---get in truck
			Cmd_Garrison(sg_officer_target04,sg_truck_target04,false,false,false)
			
			----once inside move out
			Event_IsInHold(StartTruck, nil, sg_officer_target04, true, ANY, 1)
			
			--check if truck shot at then kill driver
			Rule_AddInterval(CheckDriverShot,1)
		end
	end
end

--check if truck shot at then kill driver
function CheckDriverShot()
	if SGroup_IsUnderAttackByPlayer( sg_truck_target04, player1, 1 ) then
		
		Rule_AddOneShot(KillDriver,1)
		Rule_RemoveMe()
	end
end

function KillDriver()

	if SGroup_CountSpawned(sg_truck_target04) > 0  then
		local entity = Squad_EntityAt(SGroup_GetSpawnedSquadAt(sg_truck_target04, 1), 0)
		if Prox_MarkerSGroup( mkr_truck_camp04, sg_truck_target04, PROX_SHORTEST) >= 15 then
			Entity_ApplyCritical(entity, CRIT.VEHICLE_OUT_OF_CONTROL_SLOW, 1.1)
			UI_CreateSGroupKickerMessage(player1,sg_truck_target04,11039031)   -- LOCDB [11039031] 'Driver Killed'
		else
			Entity_ApplyCritical(entity, CRIT.VEHICLE_DRIVER_INJURED, 1.1)
		end
		
		if b_achievement_snipeDriver == false then
			b_achievement_snipeDriver = true
			Scar_CompleteIntelBulletinTask(player1, "camp11_EnemyLines_SnipeDriver")
		end
		Cmd_Stop(sg_truck_target04)
		Rule_AddOneShot(OfficerEscape,3)
	end
end

-------------- Officer will try to escape on foot
function OfficerEscape()
	if SGroup_CountSpawned(sg_officer_target04) > 0  then
		Cmd_UngarrisonSquad(sg_officer_target04, mkr_truckExitTarget04 ) 		
		---- make the officer go prone
		Squad_SuggestPosture( SGroup_GetSpawnedSquadAt( sg_officer_target04, 1 ),0, 8)
		
		----make officer go up and run towards the exit
		if g_hardDiff then
			Rule_AddOneShot(OfficerCanRunAgain,5)
		else
			Rule_AddOneShot(OfficerCanRunAgain,10)
		end
		
		Event_Proximity(CheckTruckExitOfficer,nil,sg_officer_target04,mkr_truckExitTarget04,5,ANY,1)
	end
end

--- delayed function for officer to move out to exit pt
function moveoutOfficer()
	Cmd_Move(sg_officer_target04,mkr_truckExitTarget04)
	
	if g_hardDiff then
		Rule_AddOneShot(OfficerCanRunAgain,5)
	else
		Rule_AddOneShot(OfficerCanRunAgain,10)
	end
end

function OfficerCanRunAgain()
	Cmd_Move(sg_officer_target04,mkr_truckExitTarget04)
end

-----function makes the truck go to extraction point
function StartTruck()
	Cmd_Move(sg_truck_target04, mkr_truckmove01Target04)
	Cmd_Move(sg_truck_target04, mkr_truckmove01aTarget04,true)
	Cmd_Move(sg_truck_target04, mkr_truckmove01bTarget04,true)
	Cmd_Move(sg_truck_target04, mkr_truckmove01cTarget04,true)
	Cmd_Move(sg_truck_target04, mkr_truckmove01dTarget04,true)
	Cmd_Move(sg_truck_target04, mkr_truckmove02Target04,true)
	Cmd_Move(sg_truck_target04, mkr_truckmove02bTarget04,true)
	Cmd_Move(sg_truck_target04, mkr_truckmove02cTarget04,true)
	Cmd_Move(sg_truck_target04, mkr_truckExitTarget04,true)
	
	---when truck is next to extraction then remove it
	Event_Proximity(CheckTruckExit,nil,sg_truck_target04,mkr_truckExitTarget04,5,ANY,1)
end

-----function makes the truck go to extraction point
function MoveFakeTruck()
	Cmd_Move(sg_truckIntro_target04, mkr_truckmove01Target04)
	Cmd_Move(sg_truckIntro_target04, mkr_truckmove01aTarget04,true)
	Cmd_Move(sg_truckIntro_target04, mkr_truckmove01bTarget04,true)
	Cmd_Move(sg_truckIntro_target04, mkr_truckmove01cTarget04,true)
	Cmd_Move(sg_truckIntro_target04, mkr_truckmove01dTarget04,true)
	Cmd_Move(sg_truckIntro_target04, mkr_truckmove02Target04,true)
	Cmd_Move(sg_truckIntro_target04, mkr_truckmove02bTarget04,true)
	Cmd_Move(sg_truckIntro_target04, mkr_truckmove02cTarget04,true)
	Cmd_Move(sg_truckIntro_target04, mkr_truckExitTarget04,true, mkr_truckExitTarget04)
	
end

---- Truck arrived at target then despawn
function CheckTruckExit()
	if SGroup_IsEmpty(sg_truck_target04) == false then
	
	----if officer camp 04 is still alive 
		if SGroup_IsEmpty(sg_officer_target04) == false then
		
		----despawn the truck
			SGroup_DeSpawn(sg_truck_target04)
			
			----objective failed since officer left the map
			Objective_Fail(OBJ_KillOfficers,true)
		end
	end
end

---- officer 04 arrived at target then despawn
function CheckTruckExitOfficer()	
	if SGroup_IsEmpty(sg_officer_target04) == false then
		SGroup_DeSpawn(sg_officer_target04)
		Objective_Fail(OBJ_KillOfficers,true)
	end
	
end

-------- Function will create a halftrack and go to a location used for reinforcement 
-------- parameters: sgroup, location to enter map, location to go to, sgroup squads inside, encounterID used
function CreateHalftrackSquadWithLocation(sg_vehicule,locationToSpawnVehicule,locationToAttack,sg_squadToUse,encToJoin)
	
	local sg_deleteme = SGroup_CreateIfNotFound("")
	
	Util_CreateSquads(player2, sg_vehicule, SBP.GERMAN.OPEL_BLITZ_SQUAD, locationToSpawnVehicule)
		
	---which camp?
	if sg_vehicule == sg_vehiclesReinforceCamp01 then
		MakeVehicleSnipable(sg_vehiclesReinforceCamp01)
	elseif sg_vehicule == sg_vehiclesReinforceCamp03 then
		MakeVehicleSnipable(sg_vehiclesReinforceCamp03)
	end
	
	--move truck to location to attack
	Cmd_Move(sg_vehicule, locationToAttack)
	
	----- creating the unit inside the truck
	local encData = {		
		player = player2,
		spawn = locationToSpawnVehicule,				
		units = {
			{sbp = SBP.GERMAN.GRENADIER_SQUAD,	sgroups = {sg_deleteme},	spawn = mkr_offMap,	},
		},
	}
	
	unitData = {
		{difficulty = GD_EASY,		sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,	sgroups = {sg_squadToUse},	spawn = sg_vehicule,},
		{difficulty = GD_NORMAL,	sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,	sgroups = {sg_squadToUse},	spawn = sg_vehicule,	veterancyRank = 2},
		{difficulty = GD_HARD,		sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,	sgroups = {sg_squadToUse},	spawn = sg_vehicule, 	veterancyRank = 3},
	}
	
	encID = Encounter:Create(encData)
	
	Event_Timer(DelayedSpawn, {encID = encID, unitData = unitData, sgroup = sg_deleteme}, 1)
	
---- event to check when the vehicule has reached destination
	eventID_ProxVehicule = Event_Proximity(VehiculeIsAtDest, {encToJoin = encToJoin},sg_vehicule,locationToAttack,15,ANY,2)
end

----- function called when vehicule at destination
----- parameters: sgroup of vehicule, location to attack
function VehiculeIsAtDest(data)
	--print(data.name .. tostring(data.range))
	local sg_vehiculeAtDest = data._target
	local locationToAttackFrom = data._location

----- Case for Informant vehicule
	if sg_vehiculeAtDest == sg_vehicleInformant then
	
		---- get informant out of truck 
		Cmd_UngarrisonSquad( sg_informant,mkr_informant ) 
		---- get guards outside truck
		Cmd_UngarrisonSquad( sg_guards01_informant,mkr_grenadiers_informant ) 
		
		encID_informant:RemoveUnitsBySgroup(sg_informant) 
		
		---- add UI so players know where the informant is
		hpid_informant = Objective_AddUIElements(OBJ_CaptureInformant, Marker_GetPosition(mkr_grenadiers_informant), true, 11034469, true, 2)  -- LOCDB [11034469] 'Interrogate the Informant'
		
		---reveal the area where informant is
		FOW_RevealMarker( mkr_informant, -1 ) 
		
		Rule_AddOneShot(ChangeTeamInformant,2)
		
		---- makes the truck move back out of map 
		if SGroup_IsEmpty(sg_vehiculeAtDest) == false then
			Cmd_MoveToAndDespawn(sg_vehiculeAtDest,mkr_truckInformantStart,false)
		end
		
	----- Reinforcement for informant vehicule 01
	elseif sg_vehiculeAtDest == sg_vehicleguards02_Informant then
	 ----get squad out of truck
		Cmd_UngarrisonSquad( sg_guards02_informant, mkr_grenadiers_informant ) 
		
		b_atDestOpel02[1] = true 
		
		---- send truck out of map 
		if SGroup_IsEmpty(sg_vehiculeAtDest) == false then
			Cmd_MoveToAndDespawn(sg_vehiculeAtDest,mkr_truckInformantStart,false)
		end
		
		SetAttackInformantIncoming(sg_guards02_informant, encId_guards02_informant)
		
	----- Reinforcement for informant vehicule 02
	elseif sg_vehiculeAtDest == sg_vehicleguards03_Informant then

		----get squad out of truck (halftrack)
			Cmd_UngarrisonSquad( sg_guards03_informant, mkr_reinfInformant_destination04 ) 
			b_atDestOpel03 = true
			----set encounter for squads
		SetAttackInformantIncoming(sg_guards03_informant, encId_guards03_informant)
			
	----- Reinforcement for informant vehicule 03
	elseif sg_vehiculeAtDest == sg_vehicleguards04_Informant then	
		----get squad out of truck
		Cmd_UngarrisonSquad( sg_guards04_informant,mkr_reinfInformant_destination04 ) 
		b_atDestOpel04 = true
		---send to out of map
		if SGroup_IsEmpty(sg_vehiculeAtDest) == false then
			Cmd_MoveToAndDespawn(sg_vehiculeAtDest,mkr_truckInformantStart,false)
		end
		----set encounter for squad 
		SetAttackInformantIncoming(sg_guards04_informant, encId_guards04_informant)		
		
	----- Reinforcement for informant vehicule 04
	elseif sg_vehiculeAtDest == sg_vehicleguards05_Informant then	
		Cmd_UngarrisonSquad( sg_guards05_informant,mkr_reinfDest05 ) 
		b_atDestOpel05 = true
		if SGroup_IsEmpty(sg_vehiculeAtDest) == false then
			Cmd_MoveToAndDespawn(sg_vehiculeAtDest,mkr_truckInformantStart,false)
		end
		
		SetAttackInformantIncoming(sg_guards05_informant, encId_guards05_informant)
	
	----- Reinforcement for informant vehicule 05
	elseif sg_vehiculeAtDest == sg_vehicleguards06_Informant then
	
		Cmd_UngarrisonSquad( sg_guards06_informant,mkr_reinfInformant_destination04 ) 
		b_atDestOpel06 = true
		if SGroup_IsEmpty(sg_vehiculeAtDest) == false then
			Cmd_MoveToAndDespawn(sg_vehiculeAtDest,mkr_truckInformantStart,false)
	
		end
		---set encounter 
		SetAttackInformantIncoming(sg_guards06_informant, encId_guards06_informant)
		
	----- Reinforcement for informant vehicule 06
	elseif sg_vehiculeAtDest == sg_vehicleguards07_Informant then
	
		----get squad out of truck
		Cmd_UngarrisonSquad( sg_guards07_informant,mkr_reinfInformant_destination04 ) 
		b_atDestOpel07 = true
		---go despawn outside map
		if SGroup_IsEmpty(sg_vehiculeAtDest) == false then
			Cmd_MoveToAndDespawn(sg_vehiculeAtDest,mkr_truckInformantStart,false)
		end
		
		--set encounter
		SetAttackInformantIncoming(sg_guards07_informant, encId_guards07_informant)
	
----- Reinforcement for informant vehicule 07	
	elseif sg_vehiculeAtDest == sg_vehicleguards08_Informant then
	
		----get squad out of truck
		Cmd_UngarrisonSquad( sg_guards08_informant,mkr_informant ) 
		b_atDestOpel08 = true
		----send out of map 
		if SGroup_IsEmpty(sg_vehiculeAtDest) == false then
			Cmd_MoveToAndDespawn(sg_vehiculeAtDest,mkr_truckInformantStart,false)
		end
		
		---set encounter 
		SetAttackInformantIncoming(sg_guards08_informant, encId_guards08_informant)
		
	---- Used for normal reinforcement for camps other than informant
	elseif sg_vehiculeAtDest == sg_vehiclesReinforceCamp01 then
		b_atDestOpelReinfCamp01 = true
		Cmd_UngarrisonSquad(sg_guardsReinforceCamp01,mkr_camp01_defendPt)
		
		Ai:RemoveFromAllEncounters(sg_guardsReinforceCamp01)
		
		data.encToJoin:AddSgroup(sg_guardsReinforceCamp01)

		Rule_AddOneShot(SetTruckMoveOut,2)
		
	elseif sg_vehiculeAtDest == sg_vehiclesReinforceCamp03 then
		b_atDestOpelReinfCamp03 = true 
		Cmd_UngarrisonSquad(sg_guardsReinforceCamp03,Prox_GetRandomPosition( locationToAttackFrom, 5,5 ))
	--	if SGroup_CanSeeSGroup(sg_vehiculeAtDest,sg_player_allSquads,ANY) == false then	
			Rule_AddOneShot(SetTruckMoveOutCamp03,2)
	--	end
	elseif sg_vehiculeAtDest == sg_vehicleguards_reinfLowSec01 then
	
		local goalData = {
		name = "Defend",
		useSkirmishAI = true,
		pickupWeapons = -1,
		patrolParams = {
			path = "patrol_ReinfLow_truck",
		--	wait = 3,
			},
		}
	
		encID_reinfLowPatrol_truck = Encounter:ConvertSgroup( sg_vehicleguards_reinfLowSec01 ) 
		encID_reinfLowPatrol_truck:SetGoal(goalData)
		
	
	elseif sg_vehiculeAtDest == sg_vehicleguards_reinfLowSec02 then
	
		--- truck gets to location and unloads troops
		Cmd_UngarrisonSquad( sg_guards_reinfLowSec02,mkr_spawnGoToPrison02 ) 
		Cmd_MoveToAndDespawn(sg_vehiculeAtDest,mkr_escapePoint)
		
		b_atDestOpelLowReinf = true
		
		---- troops will protect this area now
		local goalData = {
			name = "Defend",
			range = 5,
			leashRange = 20,
			target = mkr_spawnGoToPrison02,
			useSkirmishAI = g_useSkirmishAI,
		}
		
		--- give a goal if encounter exists
		if encId_guards_reinfLowSec02:IsAlive() then
			encId_guards_reinfLowSec02:SetGoal(goalData)
			
			--- put sandbags down around location
			eg_sandbagsDefendExit = EGroup_CreateIfNotFound("eg_sandbagsDefendExit")
			Util_CreateEntities( nil, eg_sandbagsDefendExit, BP_GetEntityBlueprint("ebps\\environment\\art_ambient\\objects\\defenses\\sandbags\\sandbag_wall_01"), mkr_reinfCamp01_sandbag01, 1 ) 
			Util_CreateEntities( nil, eg_sandbagsDefendExit, BP_GetEntityBlueprint("ebps\\environment\\art_ambient\\objects\\defenses\\sandbags\\sandbag_wall_01"), mkr_reinfCamp01_sandbag02, 1 ) 
			Util_CreateEntities( nil, eg_sandbagsDefendExit, BP_GetEntityBlueprint("ebps\\environment\\art_ambient\\objects\\defenses\\sandbags\\sandbag_wall_01"), mkr_reinfCamp01_sandbag03, 1 ) 
			Util_CreateEntities( nil, eg_sandbagsDefendExit, BP_GetEntityBlueprint("ebps\\environment\\art_ambient\\objects\\defenses\\sandbags\\sandbag_wall_01"), mkr_reinfCamp01_sandbag04, 1 ) 
		end
		
--~ 		Event_Proximity(SquadScorchArea,nil,player1,sg_guards_reinfLowSec02,70,ANY)
		
	---- park the truck there
	elseif sg_vehiculeAtDest == sg_vehicleguards_reinfLowSecRadio then
	
		--- truck gets to location and unloads troops
		Cmd_UngarrisonSquad( sg_guards_reinfLowSecRadio,mkr_aroundRadiobuilding_BlockPath ) 
		Cmd_Move(sg_guards_reinfLowSecRadio,mkr_aroundRadiobuilding_BlockPath,true)
		
		---- troops will protect this area now
		local goalData = {
			name = "Defend",
			range = 10,
			leashRange = 40,
			target = mkr_aroundRadiobuilding_BlockPath,
			useSkirmishAI = g_useSkirmishAI,
		}
		
		--- give a goal if encounter exists
		if encId_guards_reinfLowSecRadio:IsAlive() then
			encId_guards_reinfLowSecRadio:SetGoal(goalData)
		end
	
	elseif sg_vehiculeAtDest == sg_vehicleguards_PrisReinf01 then
		
		--- truck gets to location and unloads troops
		Cmd_UngarrisonSquad( sg_guards_PrisReinf01,mkr_camp_target03 ) 
		
		b_atDestOpenPrison01 = true
		
		if SGroup_IsEmpty(sg_vehiculeAtDest) == false then
			Cmd_MoveToAndDespawn(sg_vehiculeAtDest,mkr_GermReinf_LowSec)
		end
	
	elseif sg_vehiculeAtDest == sg_vehicleguards_PrisReinf02 then
		
		--- truck gets to location and unloads troops
		Cmd_UngarrisonSquad( sg_guards_PrisReinf02,mkr_halfwayRoutePrison ) 
		
		b_atDestOpenPrison02 = true
		
		if SGroup_IsEmpty(sg_vehiculeAtDest) == false then
			Cmd_MoveToAndDespawn(sg_vehiculeAtDest,mkr_GermReinf_LowSec)
		end

	else
		Cmd_EjectOccupants( sg_vehiculeAtDest, Prox_GetRandomPosition( locationToAttackFrom, 5,5 )  )
	end
end

----- squad attacks ground to create fear in player.
function SquadScorchArea()	
	sg_allPlayersCloseToEnd = SGroup_CreateIfNotFound("sg_allPlayersCloseToEnd")

	if SGroup_IsEmpty(sg_guards_reinfLowSec02) == false then
	
		Player_GetAll(player1,sg_allPlayersCloseToEnd)
		
		if World_DistanceSGroupToPoint(sg_allPlayersCloseToEnd,Marker_GetPosition(mkr_ClosestPathNearEnd),true) < World_DistanceSGroupToPoint(sg_allPlayersCloseToEnd,Marker_GetPosition(mkr_truckmove02bTarget04),true) then
			Cmd_Move(sg_guards_reinfLowSec02,mkr_reinfSquad_Cover01)
			SGroup_FacePosition( sg_guards_reinfLowSec02, Marker_GetPosition(mkr_ClosestPathNearEnd) ) 
			Command_SquadPos(player2,sg_guards_reinfLowSec02,SCMD_Attack,Marker_GetPosition(mkr_ClosestPathNearEnd_Attack01),false)		
		else	
			Cmd_Move(sg_guards_reinfLowSec02,mkr_reinforceCamp01)
			SGroup_FacePosition( sg_guards_reinfLowSec02, Marker_GetPosition(mkr_truckmove02bTarget04 )) 
			Command_SquadPos(player2,sg_guards_reinfLowSec02,SCMD_Attack,Marker_GetPosition(mkr_truckmove02cTarget04),false)
		end	
	end
end


function ChangeTeamInformant()
	---- putting informant in group World so no one attacks him
		SGroup_SetPlayerOwner( sg_informant, player4 ) 
		Cmd_Garrison(sg_informant,eg_captureBuilding,true,false,true)
		
		--checks death of informant 
		Rule_AddSGroupEvent(CheckInformantDeath,sg_informant,GE_SquadKilled)
end

-----Lightning strikes 
function LightningStrikes()
	Game_TriggerLightning() 
end

---- tell truck to move away and despawn
function SetTruckMoveOut()
	if SGroup_IsEmpty(sg_vehiclesReinforceCamp01) == false then
		Cmd_MoveToAndDespawn(sg_vehiclesReinforceCamp01,mkr_GermReinf_LowSec)
	end
end

function SetTruckMoveOutCamp03()
	if SGroup_IsEmpty(sg_vehiclesReinforceCamp03) == false then
		Cmd_MoveToAndDespawn(sg_vehiclesReinforceCamp03,mkr_GermReinf_LowSec)
	end
end

------------------------------------------------------------------------------------------------------------------------------------------------------
--	SECOND BEAT
------------------------------------------------------------------------------------------------------------------------------------------------------
function SecondBeat_Init()	
	Rule_RemoveIfExist(StartAttackAllHiddenCamp01)

	sg_vehicleInformant = SGroup_CreateIfNotFound("sg_vehicleInformant")
	sg_informant = SGroup_CreateIfNotFound("sg_informant")
	sg_guards01_informant = SGroup_CreateIfNotFound("sg_guards01_informant")
	sg_reinforcements_informant = SGroup_CreateIfNotFound("sg_reinforcements_informant")

	encID_informant = CreateVehiculeSquadWithLocationAndSquadIn(sg_vehicleInformant,mkr_hint_charges01,mkr_truckInformantDest,sg_informant,encID_informant,OPEL_OFFICER_GRENADIERS)
	
	----check if the player is around the camp
	Rule_AddInterval(CheckSeeInformantCamp, 1)

	Rule_AddOneShot(DelayProximityCheckInformant, 3)
end

function DelayProximityCheckInformant()
	Event_Proximity( CheckInformantArrival,nil,sg_informant, mkr_informant,10,ANY)
end

----- function will get some German units in the lower section of the map once player moves towards the informant
function Informant_ApproachingCamp()
	sg_vehicleguards_reinfLowSec01 = SGroup_CreateIfNotFound("sg_vehicleguards_reinfLowSec01")
	sg_guards_reinfLowSec01 = SGroup_CreateIfNotFound("sg_guards_reinfLowSec01")
	
	sg_vehicleguards_reinfLowSec02 = SGroup_CreateIfNotFound("sg_vehicleguards_reinfLowSec02")
	sg_guards_reinfLowSec02 = SGroup_CreateIfNotFound("sg_guards_reinfLowSec02")
	
	-----create the reinforcement from the lower section to add to map and create future ambush for player
	if g_easyDiff then
		encId_guards_reinfLowSec01 = CreateVehiculeSquadWithLocationAndSquadIn(sg_vehicleguards_reinfLowSec01,mkr_GermReinf_LowSec,mkr_GermReinf_LowSec_moveUnit01,sg_guards_reinfLowSec01,encId_guards_reinfLowSec01,OPEL_PANZERGRENADIERS)
		MakeVehicleSnipable(sg_vehicleguards_reinfLowSec01)
	else
		encId_guards_reinfLowSec01 = CreateVehiculeSquadWithLocationAndSquadIn(sg_vehicleguards_reinfLowSec01,mkr_GermReinf_LowSec,mkr_GermReinf_LowSec_moveUnit01,sg_guards_reinfLowSec01,encId_guards_reinfLowSec01,HALFTRACK_PANZERGRENADIERS02)
	end
	encId_guards_reinfLowSec02 = CreateVehiculeSquadWithLocationAndSquadIn(sg_vehicleguards_reinfLowSec02,mkr_GermReinf_LowSec03,mkr_reinforceCamp01,sg_guards_reinfLowSec02,encId_guards_reinfLowSec02,OPEL_PIONEERS02)
	MakeVehicleSnipable(sg_vehicleguards_reinfLowSec02)
	
	CheckReinfor_SpawnCamp02()
	
	Rule_AddOneShot(CheckReinfor_SpawnLastTruck,2)
	
	Rule_AddOneShot(CheckReinfor_SetCam,1)
	
	---- set territories back to enemies
	EGroup_InstantCaptureStrategicPoint( eg_territory_hospital, player2 ) 
	EGroup_InstantCaptureStrategicPoint( eg_territory_camp01, player2 ) 
	EGroup_InstantCaptureStrategicPoint( eg_territoryInitial, player2 ) 
	EGroup_InstantCaptureStrategicPoint( eg_territoryPt_Radio, player2 ) 
	Util_SetPlayerOwner( eg_hospital, player2, true ) 
	BeginnerHint_RemoveOpportunity(eg_hospital)
	
	if g_hardDiff ~= true then
		Event_PlayerOwnsTerritory(CheckIfPlayerOwnHospitalTerritory02, nil,player1,World_GetTerritorySectorID( EGroup_GetPosition(eg_territory_hospital) ))
	end
end

-- function that will send in trucks towards the informant to show direction to player
function SendTrucksForDirection()
	
	sg_truckTowardsInformant = SGroup_CreateIfNotFound("sg_truckTowardsInformant")

	local vehiculeType = SBP.GERMAN.OPEL_BLITZ_SQUAD
			
	Util_CreateSquads(player2, sg_truckTowardsInformant, vehiculeType, mkr_Reinforcement02_informant,mkr_reinfInformant_destination02)

	Cmd_Move(sg_truckTowardsInformant,mkr_reinfInformant_destination02)
	Cmd_Move(sg_truckTowardsInformant,mkr_pak40_defenseArea,true)
	Cmd_Move(sg_truckTowardsInformant,mkr_truckForDirectionDest,true)
	
	Event_Timer(EventHandler_StartIntel,{intel = EVENTS.Obj2_TrucksTowardsInformant },2)
	
	evt_informantTruckSniped = MakeVehicleSnipable(sg_truckTowardsInformant)
	Event_Proximity(ArrivedAtDest_TruckDirection,nil,sg_truckTowardsInformant,mkr_truckForDirectionDest,2,ANY)
end

function ArrivedAtDest_TruckDirection()
	Event_Remove(evt_informantTruckSniped )
	SGroup_SetWorldOwned(sg_truckTowardsInformant ) 
end

---- will spawn a truck with squads to block road
function CheckReinfor_SpawnLastTruck()

	------- spawn enemies in the bottom left corner of map 
	sg_vehicleguards_reinfLowSecRadio = SGroup_CreateIfNotFound("sg_vehicleguards_reinfLowSecRadio")
	sg_guards_reinfLowSecRadio = SGroup_CreateIfNotFound("sg_guards_reinfLowSecRadio")
	encId_guards_reinfLowSecRadio = CreateVehiculeSquadWithLocationAndSquadIn(sg_vehicleguards_reinfLowSecRadio,mkr_GermReinf_LowSec03,mkr_aroundRadiobuilding_parkTruck,sg_guards_reinfLowSecRadio,encId_guards_reinfLowSecRadio,OPEL_PANZERGRENADIERS, true)
end

function CheckReinfor_SpawnCamp02()
	sg_reinforInfLowCamp02_pangren = SGroup_CreateIfNotFound("sg_reinforInfLowCamp02_pangren")
	sg_reinforInfLowCamp02_mortar = SGroup_CreateIfNotFound("sg_reinforInfLowCamp02_mortar")
	
	---- panzer grenadier to patrol forest
	local encData = {			
		player = player2,
		spawn = mkr_GermReinf_LowSec02,
		sgroups = {sg_reinforInfLowCamp02_pangren},		
		units = {
			{difficulty = GD_EASY,		sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,	spawn = mkr_GermReinf_LowSec02,		load = 2,},
			{difficulty = GD_NORMAL,	sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,	spawn = mkr_GermReinf_LowSec02,		load = 3,},
			{difficulty = GD_HARD,		sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,	spawn = mkr_GermReinf_LowSec02,		load = 3,},
			
		},
	}	
	encID_reinfLowCamp02_pangren = Encounter:Create(encData)
	
	-- patrol around forest
	local goalData = {
		name = "Defend",
		useSkirmishAI = true,
		pickupWeapons = -1,
		patrolParams = {
			path = "patrol_forestguards02_showway",
			wait = 1,
		},
	}
	modifier = Util_ApplyModifier(sg_reinforInfLowCamp02_pangren, "posture_speed_modifier", -1, MUT_Addition)
	encID_reinfLowCamp02_pangren:SetGoal(goalData)
	
	----- spawn mortar team to defend area camp 02
	local encData = {			
		player = player2,
		spawn = mkr_GermReinf_LowSec02,
		sgroups = {sg_reinforInfLowCamp02_mortar},
		units = {
			{difficulty = GD_NORMAL,	sbp = SBP.GERMAN.MORTAR_TEAM_81MM,		spawn = mkr_GermReinf_LowSec02,		moveTo = mkr_frontDefense_target02,	load = 3,},	
			{difficulty = GD_HARD,		sbp = SBP.GERMAN.MORTAR_TEAM_81MM,		spawn = mkr_GermReinf_LowSec02,		moveTo = mkr_frontDefense_target02,	},			
		},
	}
	encID_reinfLowCamp02_mortar = Encounter:Create(encData)
end

----- using cameras to show the german squads arrival
function CheckReinfor_SetCam()
		
	-- talk about the reinforcement squads
	Util_StartIntel(EVENTS.ReinforcementComingFromBelow)
	
	--camera change
	Camera_SetInputEnabled(false)
	Rule_AddOneShot(CheckReinfor_ChangeCam,1)
end

---function will change the camera to show enemies coming in lower part of map
function CheckReinfor_ChangeCam()
	sg_allsquadsPlayer1 = SGroup_CreateIfNotFound("sg_allsquadsPlayer1")
	
	Player_GetAll(player1,sg_allsquadsPlayer1)
	Cmd_Stop(sg_allsquadsPlayer1)
	
	FOW_RevealMarker(mkr_revealGermanArrival,20)
	Camera_SetDefault(nil,nil,-90)
	Camera_ResetToDefault()
	Camera_SetInputEnabled(false)
	
	Game_SetMode(UI_Cinematic)
 --	Camera_FocusOnPosition(Marker_GetPosition(mkr_cam_showGermReinf), true)
 
	Camera_MoveTo( Marker_GetPosition(mkr_cam_showGermReinf), true, .5)
	
	checkReinforStartCamPos = Camera_GetTargetPos()
	
	SGroup_SetInvulnerable(sg_ania,true)
	
	Rule_AddOneShot(CheckReinfor_CameraBack,12)
	
end
 
----- function used to come back to camera gameplay
function CheckReinfor_CameraBack()
	Camera_FocusOnPosition(checkReinforStartCamPos, true)
	Camera_SetInputEnabled(true)
	Game_SetMode(UI_Normal)
	Util_SetPlayerOwner(eg_retreatPt_beforeInformant,player1,true)
	Util_SetPlayerOwner(eg_retreatPtCamp01,player2,true)
	
	Event_Timer(ChangeInvulnerabilitySetting,nil,4)
	
	Event_Proximity(SendTrucksForDirection,nil,player1,mkr_TowardsInformant_Trucks,25,ANY)
	Camera_SetInputEnabled(true)
end

function ChangeInvulnerabilitySetting()
	
	SGroup_SetInvulnerable(sg_ania,false)
	
	if SGroup_IsAlive(sg_sniper_player) then
		SGroup_SetInvulnerable(sg_sniper_player,false)
	end
	
	if SGroup_IsAlive(sg_sniper02_player) then
		SGroup_SetInvulnerable(sg_sniper02_player,false)
	end
end

-----   Activating informant Area
function ActivateInformantArea(data)

----makes sure that we add all the groups in the main guards group around the informant
	local encData = {		
		player = player2,
		spawn = mkr_truckInformantDest05,
		sgroups = {sg_guardsAll_informant, sg_guards_pgren_informant},		
		units = {
			{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,	spawn = mkr_truckInformantDest05,},				
		},
	}	
	encID_pgrenInformant = Encounter:Create(encData)
	
	if SGroup_IsEmpty(sg_guards_pak40_informant) == false then
		SGroup_AddGroup( sg_guardsAll_informant,sg_guards_pak40_informant )
		encID_pak40Informant = Encounter:ConvertSgroup(sg_guards_pak40_informant)
		
		----defend the area
			local goalData = {
				name = "Defend",
				target = mkr_pak40_defenseArea,
				attackMove = true,
				useSkirmishAI = true,
				maxTime = 30,
				maxIdleTime = 10,
				range = 10,
				leashRange = 30,
				tacticControlsList = {
						{
							tacticType = TACTIC_Retaliate,
							maxUsers = 4,
							maxRange = 30,
							waitTimeSecs = 30,
						},
						{
							tacticType =   TACTIC_Help,
							maxUsers = 4,
							maxRange = 50,
							waitTimeSecs = 10,
						},
					},
			}
			encID_pak40Informant:SetGoal(goalData)
	end
end

----function is activated when the informant is in his camp
function CheckInformantArrival( data )

	--- check squads attacked by player 
	Rule_AddInterval( CheckSquadAttacked_GuardsInformant, 1)
	
	---check if all guards are dead in informant camp
	Event_GroupIsDead(CheckGuardsInformantAllDead,nil,sg_guards01_informant,2)
end

----- function to look at the informant at destination
function LookAtInformant()
	if SGroup_IsEmpty(sg_vehicleInformant) == false then
		
		Camera_Follow( sg_vehicleInformant )
		Game_SetMode(UI_Cinematic)
		FOW_RevealSGroupOnly( sg_vehicleInformant, 5 ) 
	end
end


---- check if special guards around informant are dead then informant will surrender and stop shooting
function CheckGuardsInformantAllDead()
	
	if SGroup_IsEmpty(sg_guards_pak40_informant) == false then
		Event_GroupIsDead(ChangeInformantStatus,nil,sg_guards_pak40_informant)
	else
	---- makes the informant move next to building to defend from after player captured him
		ChangeInformantStatus()
	end
end

----- function to do things when informant is alone in the camp
function ChangeInformantStatus()

---stop him from shooting
	SGroup_SetAutoTargetting(sg_informant,"hardpoint_01",false)
	Cmd_Stop(sg_informant)
	---move near building
	Cmd_Move(sg_informant,mkr_surrender_informant)
	
	----set informant to World (was already probably)
	SGroup_SetPlayerOwner( sg_informant, player4 )
	
	---have him on one knee and calm
	SGroup_SuggestPosture( sg_informant, 1, -1 ) 
	SGroup_SetMoodMode( sg_informant,MM_ForceCalm) 
end

----- function that checks if squads near informant are attacked
function CheckSquadAttacked_GuardsInformant()

	if SGroup_IsEmpty(sg_guardsAll_informant) == false and SGroup_IsUnderAttack(sg_guardsAll_informant, ANY, 1) then

		sg_tempInformant = SGroup_CreateIfNotFound("sg_tempInformant")
		SGroup_GetLastAttacker(sg_guardsAll_informant, sg_tempInformant)
		
		RetaliateInformantAttacked(sg_tempInformant)
	end
end

function RetaliateInformantAttacked(sgID_killer)

	----if we know the attacker and still alive
	if SGroup_IsEmpty(sgID_killer) == false then
		
		----- informant guards  are alive
		if SGroup_IsEmpty(sg_guards01_informant) == false then

		--- defend informant
			local goalData = {
					name = "Defend",
					range = 10,
					leashRange = 60,
					target = mkr_guardsProtect_informant,
					useSkirmishAI = g_useSkirmishAI,
				}
			
			if encID_informant:IsAlive() then
				encID_informant:SetGoal(goalData)
			end
		end
		
		---- PANZER GRENADIERS are alive
		if SGroup_IsEmpty(sg_guards_pgren_informant) == false then
		
		----get position of attacker
			local lastPosition = SGroup_GetPosition(sgID_killer)
			
				-- Tell Panzer Grenadiers to use Bundled Grenades on the player's last location
			local goalData = {
				name = "Ability",
				attackMove = true,
				target = lastPosition,
				useSkirmishAI = true,
				range = 50,
			--	leashRange = 40,
				abilityParams = {
					abilityPBG = ABILITY.GERMAN.PANZER_GRENADIER_BUNDLED_CAMPAIGN,
					maxCasters = 1,
					maxRange = 60,
					waitTimeSecs = 5,
					retryTimeSecs = 3,
				},
				tacticControlsList = {
						{
							tacticType = TACTIC_RushAtTarget,
							maxUsers = 4,
							maxRange = 40,
							waitTimeSecs = 6,
						},
						{
							tacticType = TACTIC_Ability,
							maxUsers = 2,
							maxRange = 60,
							waitTimeSecs = 10,
						},
					},
		--		onFailure = InformSuccessInformantArea,
				onSuccess = InformSuccessInformantArea,
			}
				
			encID_pgrenInformant:SetGoal(goalData)
		end
		
		-------  PAK 40 is alive 
		if SGroup_IsEmpty(sg_guards_pak40_informant) == false and encID_pak40Informant ~= nil then
		
		----defend the area
			local goalData = {
				name = "Defend",
				target = mkr_pak40_defenseArea,
				attackMove = true,
				useSkirmishAI = true,
				maxTime = 30,
				maxIdleTime = 10,
				range = 10,
				leashRange = 30,
				tacticControlsList = {
						{
							tacticType = TACTIC_Retaliate,
							maxUsers = 4,
							maxRange = 30,
							waitTimeSecs = 30,
						},
						{
							tacticType =   TACTIC_Help,
							maxUsers = 4,
							maxRange = 50,
							waitTimeSecs = 10,
						},
					},
			}
			encID_pak40Informant:SetGoal(goalData)
		end
		
		-------  Mortar is alive
		if SGroup_IsEmpty(sg_guards_mortar_informant) == false then
		
		-----attack from distance	
			local goalData = {
					name = "Defend",
					range = 30,
					leashRange = 50,
					target = mkr_guards_mortar_informant,
					useSkirmishAI = g_useSkirmishAI,
					tacticControlsList = {
						{
							tacticType = TACTIC_Cover,
							maxUsers = 4,
							maxRange = 10,
							waitTimeSecs = 15,
						},
						{
							tacticType = TACTIC_TeamWeapon,
							maxUsers = 4,
							maxRange = 40,
							waitTimeSecs = 10,
						},
					}
				}
			encID_mortarInformant:SetGoal(goalData)
		end
	end
end

-----fucntion called when attack from German is done in informant camp --- go back to defend
function InformSuccessInformantArea(enc)
	local goalData = enc:GetGoalData()
		
		-- Tell Panzer Grenadiers to use Bundled Grenades on the player's last location
				local goalData = {
					name = "Attack",
					target = goalData.target,
					attackMove = true,
					useSkirmishAI = true,
					abilityParams = {
						abilityPBG = ABILITY.GERMAN.PANZER_GRENADIER_BUNDLED_CAMPAIGN,
						maxCasters = 1,
						maxRange = 60,
						waitTimeSecs = 10,
						retryTimeSecs = 5,
					},
				
					tacticControlsList = {
							{
								tacticType = TACTIC_RushAtTarget,
								priority = 5,
								maxUsers = 4,
								maxRange = 30,
								waitTimeSecs = 7,
							},
							{
								tacticType = TACTIC_Ability,
								priority = 4,
								maxUsers = 4,
								maxRange = 60,
								waitTimeSecs = 10,
								retryTimeSecs = 5,
							},
						},
				
				}
	
	enc:SetGoal(goalData)
end

---- Check activation of camp fire near Informant
function ActivateCampFire()
	if SGroup_TotalMembersCount( sg_guards_pgren_informant ) > 0 or (SGroup_Exists(SGroup_GetName(sg_guards01_informant)) == true and SGroup_TotalMembersCount( sg_guards01_informant ) > 0) then

		--- Tell player about the fire camp
		Util_StartIntel(EVENTS.FireCamp_Farm)
		
		---- check if player captured the fire camp near informant area
		Rule_AddInterval(CheckCapturedFarmFire,1)
	end
end

-----function to spawn the sniper in his tower and MORTAR
function SpawnSniperNearInformant()

	sg_guards_sniper_informant = SGroup_CreateIfNotFound("sg_guards_sniper_informant")
	sg_guards_mortar_informant = SGroup_CreateIfNotFound("sg_guards_mortar_informant")
	
	-- MORTAR -- setup guys around the farm area for informant fight
	local encData = {
			
				player = player2,
				spawn = mkr_guards_mortar_informant,
				units = {
					{
						
						sbp = SBP.GERMAN.MORTAR_TEAM_81MM,
						sgroups = {sg_guards_mortar_informant,sg_guardsAll_informant},
						spawn = mkr_guards_mortar_informant,
						load = 3,
					},
					
				},
		}
		
		if g_easyDiff then
			encData.units[1].load = 3
		elseif g_hardDiff then
			encData.units[1].load = 3
			encData.units[1].numSquads = 2
		end
		
	encID_mortarInformant = Encounter:Create(encData)

	-- SNIPER setup in his tower
	local encData = {
			
				player = player2,
				spawn = mkr_sniperInformant,
				units = {
					{
						
						sbp = SBP.GERMAN.SNIPER_SQUAD,
						sgroups = {sg_guards_sniper_informant,sg_guardsAll_informant},
						spawn = eg_sniperTower_informant,
					},
					
				},
		}
		
	---- no sniper for easy mode	
	if g_easyDiff ~= true then	
		encID_sniper_informant = Encounter:Create(encData)
	
		--- Function checks if sniper in camp 04 saw the player squads so let players know about it
		eID_sniperProxAniaInformant = Event_Proximity(TellPlayerIfSniperSeesSquad,{sniper = sg_guards_sniper_informant, shotPosition = mkr_ShootHereInformant },sg_ania,mkr_ShootHereInformant,30,ANY)
		eID_sniperProxSniperSquad01Informant = Event_Proximity(TellPlayerIfSniperSeesSquad,{sniper = sg_guards_sniper_informant, shotPosition = mkr_ShootHereInformant },sg_sniper_player,mkr_ShootHereInformant,30,ANY)
		eID_sniperProxSniperSquad02Informant = Event_Proximity(TellPlayerIfSniperSeesSquad,{sniper = sg_guards_sniper_informant, shotPosition = mkr_ShootHereInformant },sg_sniper02_player,mkr_ShootHereInformant,30,ANY)
		
		----- can player see the sniper ?
		Rule_AddInterval(PlayerCanSeeSniperInformant,2)
	end
end


------ Function checks if the player can see the sniper in his tower
function PlayerCanSeeSniperInformant()
	
	if Player_CanSeeEGroup( player1, eg_sniperTower_informant, ANY) and SGroup_IsEmpty(sg_guards_sniper_informant) == false then
	
		if g_hardDiff ~= true then
			----add hint over the sniper tower
			hpid_sniper_informant = HintPoint_Add(eg_sniperTower_informant, true, 11036702,4,HPAT_Hint) -- LOCDB [11036702] 'German Sniper'
		end
		EventCue_Create(CUE.ATTACKED,11023513,11023513,eg_sniperTower_informant,nil,nil,10,true) -- LOCDB [11023513] 'Sniper!'
	
	----reveal the tower so we can see the sniper cuz can be in other window and player cant shoot him
		FOW_RevealArea( EGroup_GetPosition(eg_sniperTower_informant), 5, -1 ) 
		
		--check death of sniper 
	--	Event_GroupIsDead(CheckSniperInformantDeath,nil,sg_guards_sniper_informant)
		Rule_AddSGroupEvent(CheckSniperInformantDeath,sg_guards_sniper_informant,GE_SquadKilled)
		Rule_RemoveMe()
	end
end


-----remove the hint when sniper dead  -- informant area
function CheckSniperInformantDeath(squad, killer)
	
	--get the squad who killed the officer to send enemies after them
	sg_killer_sniperInformant = SGroup_CreateIfNotFound("sg_killer_sniperInformant")
	Squad_GetLastAttacker( squad, sg_killer_sniperInformant )	
	
	--retaliation using the killer squad from player to be attacked by the officer guards
	RetaliateInformantAttacked( sg_killer_sniperInformant )
	HintPoint_Remove(hpid_sniper_informant)
end

------ Function activated when player is near the informant camp
function CheckSeeInformantCamp()
	if Prox_ArePlayerMembersNearMarker(player1, mkr_nearCampInformant,ANY,70) then
		
		----Ania speaks about the tactics
		Util_StartIntel(EVENTS.Obj2_SeeCampNear)
		
		Objective_Complete(OBJ_CaptureInformantSubGetToCamp)
		Objective_Start(OBJ_CaptureInformantSubSecureInformant,false)
		
		----spawn sniper 
		SpawnSniperNearInformant()
		Rule_RemoveMe()
	end
end

-------check if camp NEXT to INFORMANT has been captured!!
function CheckCapturedFarmFire()
	
	if Player_OwnsEGroup(player1, eg_fire01_farm_turnOn, ANY ) then
		Rule_RemoveMe()
		
		----goal to investigate fire
		local goalData = {
				name = "Attack",
				useSkirmishAI = true,
				target = eg_fire01_farm_turnOn,
				maxTime = 60,
				maxIdleTime = 10,
				range = 8,
				leashRange = 15,
				onSuccess = FarmCabinUnitGetBack,
				onFailure = FarmCabinUnitGetBack,
			}
		--- send Panzer Grenadiers to fire camp is alive
		if SGroup_TotalMembersCount( sg_guards_pgren_informant ) > 0 then
				
			if SGroup_IsEmpty(sg_guards_pgren_informant) == false then
--~ 				Sound_Play3D( "speech/sp/mission/m11/ambient/xb_hpg_atm_genge0_nt_m", Squad_EntityAt(SGroup_GetSpawnedSquadAt( sg_guards_pgren_informant, 1 ),0 )) 
				Sound_PlayOnSquad( "speech/sp/mission/m11/ambient/xb_xs1_bat_gege00_lt_s", sg_guards_pgren_informant ) 
			end
			
			--set goal to investigate
			encID_pgrenInformant:SetGoal(goalData)
			
	---- if all panzer dead then guards near informant will investigate
		elseif SGroup_Exists(SGroup_GetName(sg_guards01_informant)) == true then
		
			if SGroup_TotalMembersCount( sg_guards01_informant ) > 0 then
			
				encID_informant:SetGoal(goalData)
				
				----informant guards talk about investigating
				Util_StartIntel(EVENTS.InvestigatingFire02German)
			end
		end
	end
end

------- function called when informant attack was done go back to defend
function FarmCabinUnitGetBack(enc)
		
	local goalData = {
		name = "Defend",
		useSkirmishAI = true,
		target = mkr_InsideLastArea,
		range = 5,
		leashRange = 25,
	}
			
	enc:SetGoal(goalData)
end

--Check if the informant has been killed --- objective failed
function CheckInformantDeath(squad, killer)	
	if Objective_IsComplete(OBJ_CaptureInformant) == false then
		Objective_Fail(OBJ_CaptureInformant,true)
	else
		Rule_AddOneShot(MissionFailed,5)
	end
end

--check if truck shot (Second Vehicule) at then kill driver

-------------- troops will try to escape on foot
function TroopEscapeVehicule(data)
	Cmd_Stop(data.sg_truck)
	Cmd_UngarrisonSquad(data.sg_troops) 	
end

-- Function to bring reinforcement vehicule 01 for informant
function BringSecondVehicule()

	sg_vehicleguards02_Informant = SGroup_CreateIfNotFound("sg_vehicleguards02_Informant")
	sg_guards02_informant = SGroup_CreateIfNotFound("sg_guards02_informant")
	
	-----create the reinforcement to attack the informant and ania
	encId_guards02_informant = CreateVehiculeSquadWithLocationAndSquadIn(sg_vehicleguards02_Informant,mkr_Reinforcement01_informant,mkr_reinfInformant_destination04,sg_guards02_informant,encId_guards02_informant,OPEL_GRENADIERS)
end


-- Function to bring reinforcement vehicule 02 for informant
function BringThirdVehicule()

	sg_vehicleguards03_Informant = SGroup_CreateIfNotFound("sg_vehicleguards03_Informant")
	sg_guards03_informant = SGroup_CreateIfNotFound("sg_guards03_informant")
	
	-----create the reinforcement to attack the informant and ania
	if g_easyDiff then
		encId_guards03_informant = CreateVehiculeSquadWithLocationAndSquadIn(sg_vehicleguards03_Informant,mkr_Reinforcement02_informant,mkr_reinfDest05,sg_guards03_informant,encId_guards03_informant,OPEL_PANZERGRENADIERS03)
		---- bring next vehicule
		Rule_AddOneShot(BringFourthVehicule,18)
	elseif g_hardDiff then
		encId_guards03_informant = CreateVehiculeSquadWithLocationAndSquadIn(sg_vehicleguards03_Informant,mkr_Reinforcement02_informant,mkr_reinfDest05,sg_guards03_informant,encId_guards03_informant,HALFTRACK_PANZERGRENADIERS)
		---- bring next vehicule
		Rule_AddOneShot(BringFourthVehicule,9)
	else
		encId_guards03_informant = CreateVehiculeSquadWithLocationAndSquadIn(sg_vehicleguards03_Informant,mkr_Reinforcement02_informant,mkr_reinfDest05,sg_guards03_informant,encId_guards03_informant,OPEL_PANZERGRENADIERS03)
		Rule_AddOneShot(BringFourthVehicule,15)
	end
	
	local sg_germansNearPlayer = SGroup_CreateIfNotFound("sg_germansNearPlayer")
	Player_GetAllSquadsNearMarker(player2, sg_germansNearPlayer, mkr_nearCampInformant)
	if SGroup_CountSpawned(sg_germansNearPlayer) < 4 then
		Event_Timer( BringScoutsInformant,{side = mkr_hint_charges02},0.1)
	end
end

-- Function to bring reinforcement vehicule 03 for informant
function BringFourthVehicule()

	sg_vehicleguards04_Informant = SGroup_CreateIfNotFound("sg_vehicleguards04_Informant")
	sg_guards04_informant = SGroup_CreateIfNotFound("sg_guards04_informant")
	
	-----create the reinforcement to attack the informant and ania
	encId_guards04_informant = CreateVehiculeSquadWithLocationAndSquadIn(sg_vehicleguards04_Informant,mkr_Reinforcement01_informant,mkr_reinfInformant_destination04,sg_guards04_informant,encId_guards04_informant,OPEL_PIONEERS)
	---- bring next vehicule
	if g_easyDiff ~= true then
		Rule_AddOneShot(BringFifthVehicule,17)
	end
	local sg_germansNearPlayer = SGroup_CreateIfNotFound("sg_germansNearPlayer")
	Player_GetAllSquadsNearMarker(player2, sg_germansNearPlayer, mkr_nearCampInformant)
	if SGroup_CountSpawned(sg_germansNearPlayer) < 4 then
		Event_Timer( BringScoutsInformant,{side = mkr_hint_charges01},0.1)
	end
end

-- Function to bring reinforcement vehicule 04 for informant
function BringFifthVehicule()

	sg_vehicleguards05_Informant = SGroup_CreateIfNotFound("sg_vehicleguards05_Informant")
	sg_guards05_informant = SGroup_CreateIfNotFound("sg_guards05_informant")
	
	-----create the reinforcement to attack the informant and ania
	encId_guards05_informant = CreateVehiculeSquadWithLocationAndSquadIn(sg_vehicleguards05_Informant,mkr_Reinforcement01_informant,mkr_reinfDest05,sg_guards05_informant,encId_guards05_informant,OPEL_PANZERGRENADIERS_MORTAR)	
	
	
	local sg_germansNearPlayer = SGroup_CreateIfNotFound("sg_germansNearPlayer")
	Player_GetAllSquadsNearMarker(player2, sg_germansNearPlayer, mkr_nearCampInformant)
	if SGroup_CountSpawned(sg_germansNearPlayer) < 4 then
		Event_Timer( BringScoutsInformant,{side = mkr_hint_charges01},0.1)
	end
end

-- Function to bring reinforcement vehicule 05 for informant
function BringSixthVehicule()

	sg_vehicleguards06_Informant = SGroup_CreateIfNotFound("sg_vehicleguards06_Informant")
	sg_guards06_informant = SGroup_CreateIfNotFound("sg_guards06_informant")
	
	encId_guards06_informant = CreateVehiculeSquadWithLocationAndSquadIn(sg_vehicleguards06_Informant,mkr_Reinforcement01_informant,mkr_reinfInformant_destination04,sg_guards06_informant,encId_guards06_informant,OPEL_PANZERGRENADIERS)
	
	---- bring next vehicule
	Rule_AddOneShot(BringSeventhVehicule,10)
end


-- Function to bring reinforcement vehicule 06 for informant
function BringSeventhVehicule()

	sg_vehicleguards07_Informant = SGroup_CreateIfNotFound("sg_vehicleguards07_Informant")
	sg_guards07_informant = SGroup_CreateIfNotFound("sg_guards07_informant")
	
	-----create the reinforcement to attack the informant and ania
	encId_guards07_informant = CreateVehiculeSquadWithLocationAndSquadIn(sg_vehicleguards07_Informant,mkr_Reinforcement01_informant,mkr_reinfInformant_destination04,sg_guards07_informant,encId_guards07_informant,OPEL_GRENADIERS)
	
	---- bring next vehicule

	Rule_AddOneShot(BringEightVehicule,10)
end


-- Function to bring reinforcement vehicule 07 for informant
function BringEightVehicule()

	sg_vehicleguards08_Informant = SGroup_CreateIfNotFound("sg_vehicleguards08_Informant")
	sg_guards08_informant = SGroup_CreateIfNotFound("sg_guards08_informant")
	
	-----create the reinforcement to attack the informant and ania
	encId_guards08_informant = CreateVehiculeSquadWithLocationAndSquadIn(sg_vehicleguards08_Informant,mkr_Reinforcement01_informant,mkr_reinfInformant_destination04,sg_guards08_informant,encId_guards08_informant,OPEL_PIONEERS)
end

--------- function checks if we still have time to send more troops
function CheckReinforcementInformantDeath()

----check timer 
	if Objective_IsTimerSet(OBJ_CaptureInformant) then
	
	-----if no reinforcement squads alive and time remaining is more than 20 seconds
		if SGroup_IsEmpty(sg_reinforcements_informant) and Objective_GetTimerSeconds( OBJ_CaptureInformant )  >= 20  then
			BringEightVehicule()
			Rule_RemoveMe()
		
		-----if some reinforcement squads alive and time remaining is more than 20 seconds
		elseif SGroup_Count(sg_reinforcements_informant) <= 1 and Objective_GetTimerSeconds( OBJ_CaptureInformant )  >= 20 then
			BringEightVehicule()
			Rule_RemoveMe()
		end
	else
		Rule_RemoveMe()
	end
end								

function DelayedSpawn(data)
	for k, unit in ipairs(data.unitData) do 
		data.encID:AddUnit(unit)
	end
	
	data.encID:RemoveUnitsBySgroup(data.sgroup) 

	SGroup_DeSpawn(data.sgroup)

	SGroup_Destroy(data.sgroup)
end

---- make the truck stop if under attack by players
function CheckSeeAttackers(data)
--	data.location
	sg_UnderAttack = SGroup_CreateIfNotFound("sg_UnderAttack")

	SGroup_Clear( sg_UnderAttack ) 
	sg_UnderAttack = data._group
	Cmd_Stop(sg_UnderAttack)
	Rule_AddOneShot(UnloadSquad,1)
end

function UnloadSquad()
	Cmd_EjectOccupants( sg_UnderAttack, Prox_GetRandomPosition( sg_UnderAttack, 5,5 )  )
end

function SetAttackInformantIncoming(sgroup, encounter)
	Event_Timer(__SetAttackInformantIncoming, {sgroup = sgroup, encounter = encounter}, 2)	
end

function __SetAttackInformantIncoming(data)
	if SGroup_CountSpawned(data.sgroup) > 0 then
		local goalData = {
						name = "Attack",
						range = 25,
						leashRange = 20,
						target = g_InformantBuildingLocation,
						useSkirmishAI = g_useSkirmishAI,
						tacticTargetPreference = AITacticTargetPreference_Near,
					}
		
		data.encounter:SetGoal(goalData)
	end	
end

------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------- ENCOUNTERS STUFF                       THIRD BEAT INIT!!!!!!!!
------------------------------------------------------------------------------------------------------------------------------------------------------
function ThirdBeat_Init()
	sg_partisans_player = SGroup_CreateIfNotFound("sg_partisans_player")
	
	Objective_Start(OBJ_EscapeSquadCounter,false)
	
	EGroup_InstantCaptureStrategicPoint( eg_territoryPt_informant, player2 ) 
	Modify_CaptureTime(eg_territoryPt_informant,1)
	
	Rule_Add(showUINewAbilities)
	
	Rule_AddOneShot(SendTroopsPrison,5)
	
	---- start last objective to escape map
	Objective_Start(OBJ_Escape,true)
	
	EGroup_DestroyAllEntities( eg_startPos_EscapePt )
	EGroup_DestroyAllEntities( eg_mapentry_escapept )
	
	---check proximity to extraction point
	eID_Escape = Event_Proximity(CheckEscape,nil,sg_ania,mkr_escapePoint,20,ANY)
end

function showUINewAbilities()
	if Event_IsAnyRunning() == false then
		
		Rule_RemoveMe()
		
		M11_PARTISANS_DISPATCH_KARK98K = BP_GetAbilityBlueprint("M11_PARTISANS_DISPATCH_KARK98K")
		Player_AddAbility(player1, M11_PARTISANS_DISPATCH_KARK98K)
		
		M11_PARTISANS_DISPATCH_NAGANT = BP_GetAbilityBlueprint("M11_PARTISANS_DISPATCH_NAGANT")
		Player_AddAbility(player1, M11_PARTISANS_DISPATCH_NAGANT)
	
		Rule_AddOneShot(StartPartisanFlash,2)
	
		if g_easyDiff then
			Player_SetPopCapOverride(player1,19)
		elseif g_hardDiff then
			Player_SetPopCapOverride(player1,11)
		else
			Player_SetPopCapOverride(player1,15)
		end
		EventCue_Create(CUE.POP_INC,11045310,11045310,nil,nil,nil,10,true) -- LOCDB [11045310] 'Population Cap Increased'
		
		---- show feature
		Util_NewHUDFeatureEvent( HUDF_AbilityCard, 11038405, "Icons_units_unit_soviet_partisan", 5 )  -- LOCDB [11038405] 'Dispatch Partisan Squads: Use this ability to call in some specialized partisan squads.'
		
		Rule_AddOneShot(PartisanFlash,10)
	end
end

function StartPartisanFlash()
	IdUI_Kar98k =  UI_FlashAbilityButton(ABILITY.SOVIET.M11_PARTISANS_DISPATCH_KARK98K,true)
	IdUI_nagant = UI_FlashAbilityButton(ABILITY.SOVIET.M11_PARTISANS_DISPATCH_NAGANT,true)
end

--- stop flashing from partisan flash mobilize
function PartisanFlash()
	UI_StopFlashing(IdUI_Kar98k)
	UI_StopFlashing(IdUI_nagant)
end

----- complete objective after getting to extraction pt
function CheckEscape()
	SGroup_Kill(sg_reinforInfLowCamp02_mortar)
	SGroup_Kill(sg_guards_reinfLowSec02)
	
	Objective_Complete(OBJ_Escape)
end


function SendTroopsPrison()

	sg_vehicleguards_PrisReinf01 = SGroup_CreateIfNotFound("sg_vehicleguards_PrisReinf01")
	sg_guards_PrisReinf01 = SGroup_CreateIfNotFound("sg_guards_PrisReinf01")

	sg_vehicleguards_PrisReinf02 = SGroup_CreateIfNotFound("sg_vehicleguards_PrisReinf02")
	sg_guards_PrisReinf02 = SGroup_CreateIfNotFound("sg_guards_PrisReinf02")
	
	encId_guards_prisPanGren = CreateVehiculeSquadWithLocationAndSquadIn(sg_vehicleguards_PrisReinf01,mkr_spawnGoToPrison,mkr_camp_target03,sg_guards_PrisReinf01,encId_guards_prisPanGren,OPEL_PANZERGRENADIERS)
	encId_guards_prisPion = CreateVehiculeSquadWithLocationAndSquadIn(sg_vehicleguards_PrisReinf02,mkr_spawnGoToPrison02,mkr_halfwayRoutePrison,sg_guards_PrisReinf02,encId_guards_prisPion,OPEL_PIONEERS02)
	
	MakeVehicleSnipable(sg_vehicleguards_PrisReinf01)
	MakeVehicleSnipable(sg_vehicleguards_PrisReinf02)
	
	sg_reinforPrison_pangren = SGroup_CreateIfNotFound("sg_reinforPrison_pangren")
	sg_reinforPrison_gren = SGroup_CreateIfNotFound("sg_reinforPrison_gren")
	
	sg_reinforPathEscape_camp04 = SGroup_CreateIfNotFound("sg_reinforPathEscape_camp04")
	sg_reinforPathEscape_camp04_02 = SGroup_CreateIfNotFound("sg_reinforPathEscape_camp04_02")
	
	
	sg_reinforPathEscape_informant = SGroup_CreateIfNotFound("sg_reinforPathEscape_informant")
	
	---- units around informant area
	local encDataInformant = {
			
				player = player2,
				spawn = mkr_Reinforcement02_informant,
				units = {
					
					{
						
						sbp = SBP.GERMAN.PIONEER_SQUAD,
						sgroups = {sg_reinforPathEscape_camp04_02},
						spawn = mkr_Reinforcement02_informant,
						upgrades = {UPG.GERMAN.PIONEER_FLAMETHROWER},
						moveTo = mkr_reinfInformant_destination02_b,
					},
					
				},
		}
		
	encID_reinforPathEscape_informant = Encounter:Create(encDataInformant)
	
	local goalDataInformant = {
		name = "Defend",
		useSkirmishAI = true,
		pickupWeapons = -1,
		target = mkr_reinfInformant_destination02_b,
		leash = 30,
		range = 20,
	}

	encID_reinforPathEscape_informant:SetGoal(goalDataInformant)
	
--- put sandbags down around location
	eg_sandbagsDefendExit02 = EGroup_CreateIfNotFound("eg_sandbagsDefendExit02")
	Util_CreateEntities( nil, eg_sandbagsDefendExit02, BP_GetEntityBlueprint("ebps\\environment\\art_ambient\\objects\\defenses\\sandbags\\sandbag_wall_01"), mkr_reinfInformant_sandbag01, 1 ) 
	Util_CreateEntities( nil, eg_sandbagsDefendExit02, BP_GetEntityBlueprint("ebps\\environment\\art_ambient\\objects\\defenses\\sandbags\\sandbag_wall_01"), mkr_reinfInformant_sandbag02, 1 ) 
	Util_CreateEntities( nil, eg_sandbagsDefendExit02, BP_GetEntityBlueprint("ebps\\environment\\art_ambient\\objects\\defenses\\sandbags\\sandbag_wall_01"), mkr_reinfInformant_sandbag03, 1 ) 
	Util_CreateEntities( nil, eg_sandbagsDefendExit02, BP_GetEntityBlueprint("ebps\\environment\\art_ambient\\objects\\defenses\\sandbags\\sandbag_wall_01"), mkr_reinfInformant_sandbag04, 1 ) 
	
	---- units around camp04
	
	local encDataCamp04_02 = {
			
				player = player2,
				spawn = mkr_truckExitTarget04,
				units = {
					
					{
						
						sbp = SBP.GERMAN.PIONEER_SQUAD,
						sgroups = {sg_reinforPathEscape_camp04_02},
						spawn = mkr_truckExitTarget04,
						upgrades = {UPG.GERMAN.PIONEER_FLAMETHROWER},
						moveTo = mkr_behindSandbag02_Target04,
					},
					
				},
		}
		
		if g_easyDiff then
			encDataCamp04_02.units[1].load = 2
		elseif g_hardDiff then
			encDataCamp04_02.units[1].load = 3
		else
			encDataCamp04_02.units[1].load = 2
		end
	
	encID_reinforPathEscape_camp04_02 = Encounter:Create(encDataCamp04_02)
	
	local goalDataCamp04_02 = {
		name = "Defend",
		useSkirmishAI = true,
		pickupWeapons = -1,
		target = mkr_behindSandbag02_Target04,
		leash = 30,
		range = 20,
	}

	encID_reinforPathEscape_camp04_02:SetGoal(goalDataCamp04_02)
	
	local encDataCamp04 = {
			
				player = player2,
				spawn = mkr_truckExitTarget04,
				units = {
					{
						
						sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
						sgroups = {sg_reinforPathEscape_camp04},
						spawn = mkr_truckExitTarget04,
						moveTo = mkr_truckmove01dTarget04,
					},
					
					{
						
						sbp = SBP.GERMAN.PIONEER_SQUAD,
						sgroups = {sg_reinforPathEscape_camp04},
						spawn = mkr_truckExitTarget04,
						upgrades = {UPG.GERMAN.PIONEER_FLAMETHROWER},
						moveTo = mkr_truckmove01dTarget04,
					},
					
				},
		}
		
		if g_easyDiff then
			encDataCamp04.units[1].load = 2
			encDataCamp04.units[2].load = 2
		elseif g_hardDiff then
			encDataCamp04.units[1].load = 3
		else
			encDataCamp04.units[1].load = 2
		end
	
	encID_reinforPathEscape_camp04 = Encounter:Create(encDataCamp04)
	
	local goalDataCamp04 = {
		name = "Defend",
		useSkirmishAI = true,
		pickupWeapons = -1,
		target = mkr_truckmove01dTarget04,
		leash = 30,
		range = 20,
	}

	encID_reinforPathEscape_camp04:SetGoal(goalDataCamp04)
	
	---- panzer grenadier to patrol forest
	local encData = {			
		player = player2,
		spawn = mkr_escapePoint,
		units = {
			{						
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
				sgroups = {sg_reinforPrison_pangren},
				spawn = mkr_escapePoint,
				load = 2,
				moveTo = mkr_leftDefense02_target02,
			},			
		},
	}
		
	if g_easyDiff then
		encData.units[1].load = 2
	elseif g_hardDiff then
		encData.units[1].load = 3
	else
		encData.units[1].load = 2
	end
		
	encID_reinfPrison_pangren = Encounter:Create(encData)
	
		-- patrol around forest
	local goalData = {
		name = "Defend",
		useSkirmishAI = true,
		pickupWeapons = -1,
		target = mkr_leftDefense02_target02,
		leash = 15,
		range = 20,
	}

	encID_reinfPrison_pangren:SetGoal(goalData)
	
	----- spawn grenadier team to defend area camp 02
	local encData = {
			
				player = player2,
				spawn = mkr_escapePoint,
				units = {
					{
						
						sbp = SBP.GERMAN.GRENADIER_SQUAD,
						sgroups = {sg_reinforPrison_gren},
						spawn = mkr_escapePoint,
						moveTo = mkr_camp03,
					},
					
				},
		}
		
		if g_easyDiff then
			encData.units[1].load = 2
		elseif g_hardDiff then
			encData.units[1].load = 4
		else
			encData.units[1].load = 3
		end
	encID_reinfPrison_gren = Encounter:Create(encData)
	
	Cmd_AttackMove(sg_reinforPrison_gren,mkr_camp03)
end

------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------- ENCOUNTERS STUFF                       THIRD BEAT FUNCTIONS
------------------------------------------------------------------------------------------------------------------------------------------------------

------- function will start trucks coming in and let players know to stay off the road
function StayOffRoad()
	Rule_Add(StayOffRoadSpeech)
end

------ function for speech delayed until no more speech going on.
function StayOffRoadSpeech()
	if Event_IsAnyRunning() == false then
		Rule_AddOneShot(BringSixthVehicule,5)
		Event_Timer(EventHandler_StartIntel,{intel = EVENTS.KeepOffRoads},2)
		Rule_RemoveMe()
	end
end

----- function will check if player can add some partisans
function CheckPlayerSquadsNumber()
	if Player_GetUnitCount( player1 )  < Player_GetMaxPopulation( player1, CT_Personnel )  then
			UI_SetModalAbilityPhaseCallback( PlayerCallsReinforcement ) 
	else
		UI_ClearModalAbilityPhaseCallback()
	end
	
	Rule_RemoveIfExist(CheckPlayerSquadsNumber_Informant)
end

--- This function checks if players has pressed on the icon ability to bring more snipers in
function PlayerCallsReinforcement(abilityUsed, phaseDone)
	if abilityUsed == ABILITY.SOVIET.M11_SNIPER_DISPATCH02 or abilityUsed == ABILITY.SOVIET.M11_PARTISANS_DISPATCH_KARK98K or abilityUsed == ABILITY.SOVIET.M11_PARTISANS_DISPATCH_NAGANT then
		--- if player clicked on ground to bring troop
		if phaseDone == MAP_Confirmed then
	
			-- check for achievement unlock
			if b_achievement_armiakrajowaDone == false then
				if abilityUsed == ABILITY.SOVIET.M11_SNIPER_DISPATCH02 then
					b_armiakrajowa_sniper = true
				elseif abilityUsed == ABILITY.SOVIET.M11_PARTISANS_DISPATCH_KARK98K then
					b_armiakrajowa_kark = true
				elseif abilityUsed == ABILITY.SOVIET.M11_PARTISANS_DISPATCH_NAGANT then
					b_armiakrajowa_nagant = true
				end
				
				if b_armiakrajowa_sniper == true and b_armiakrajowa_kark == true and b_armiakrajowa_nagant == true then
					Scar_CompleteIntelBulletinTask(player1, "camp11_EnemyLines_ArmiaKrajowa")
					b_achievement_armiakrajowaDone = true
				end
			end
			
			local sg_playerAll03 = Player_GetSquads( player1 ) 
			
			if SGroup_ContainsBlueprints(sg_playerAll03,BP_GetSquadBlueprint("m11_ania_sniper_squad"),ANY) then
				SGroup_Filter(sg_playerAll03,BP_GetSquadBlueprint("m11_ania_sniper_squad") , FILTER_REMOVE)
			end
			
			-- check number of times the player has used his abilities to call in some partisan squads
			g_numberOfSquadsAvailable = g_numberOfSquadsAvailable - 1
			
			if	g_numberOfSquadsAvailable > 0 then			
				Objective_SetCounter(OBJ_EscapeSquadCounter, g_numberOfSquadsAvailable, g_MaxNumberOfSquadsAvailable)
				ProgressUnitsLeft = ProgressUnitsLeft - ( 1 / g_MaxNumberOfSquadsAvailable )
			
			elseif g_numberOfSquadsAvailable == 0 then			
				Objective_SetCounter(OBJ_EscapeSquadCounter, g_numberOfSquadsAvailable, g_MaxNumberOfSquadsAvailable)
				Rule_RemoveIfExist(CheckPlayerSquadsNumber)
				Rule_AddOneShot(removeAbilityDispatch,1)
			end
		end
	end
end

function removeAbilityDispatch()
	Player_SetAbilityAvailability(player1, ABILITY.SOVIET.M11_SNIPER_DISPATCH02, ITEM_LOCKED)
	Player_SetAbilityAvailability(player1, ABILITY.SOVIET.M11_PARTISANS_DISPATCH_NAGANT, ITEM_LOCKED)
	Player_SetAbilityAvailability(player1, ABILITY.SOVIET.M11_PARTISANS_DISPATCH_KARK98K, ITEM_LOCKED)
end


----------------------------------------------
--------	CreateVehiculeSquadWithLocationAndSquadIn
--------    param: vehicule sgroup, locationToSpawnVehicule, locationToAttack, sgroup of squad, encID of squads, int type of attack: 
---------    1 = OPEL + german officer + grenadiers, 2 = OPEL + grenadiers, 3 = halftrack + panzer grenadiers, 4 = OPEL + pioneers
-----------------------------------------------------
function CreateVehiculeSquadWithLocationAndSquadIn(sg_vehicule,locationToSpawnVehicule,locationToAttack,sg_squadToUse,encID,TypeOfAttack, notGuardUnit)
	local encData = nil
	local unitData =nil
	local sg_deleteme = SGroup_CreateIfNotFound("")
	
	local sgroupList = {sg_squadToUse}
	
	if notGuardUnit ~= true then
		table.insert(sgroupList, sg_guardsAll_informant)
	end

	--officer + squads of guards to send to camp
	if TypeOfAttack == OPEL_OFFICER_GRENADIERS then
		vehiculeType = SBP.GERMAN.OPEL_BLITZ_SQUAD
		
		Util_CreateSquads(player2, sg_vehicule, vehiculeType, locationToSpawnVehicule)

			Cmd_Move(sg_vehicule, locationToAttack)
	--	Rule_AddOneShot(LookAtInformant,5)
		encData = {
		
			player = player2,
			spawn = locationToSpawnVehicule,
		--	sgroups = {sg_squadToUse},
			units = {
				{
					
					sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
					sgroups = {sg_deleteme},
					spawn = mkr_offMap,
				},
			},
		}
		unitData = {
			{
				
				sbp = SBP.GERMAN.OFFICER_SQUAD,
				sgroups = {sg_squadToUse},
				spawn = sg_vehicule,
			},
			
			{
					
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				sgroups = {sg_guards01_informant,sg_guardsAll_informant},
				spawn = sg_vehicule,
			},
		}
		
---- REINFORCEMENTS BELOW FOR INFORMANT
	---opel + grenadiers
	elseif TypeOfAttack == OPEL_GRENADIERS then
	
		vehiculeType = SBP.GERMAN.OPEL_BLITZ_SQUAD
		
		Util_CreateSquads(player2, sg_vehicule, vehiculeType, locationToSpawnVehicule)
		Cmd_Move(sg_vehicule, mkr_reinfInformant_destination01_b)
		Cmd_Move(sg_vehicule, mkr_reinfInformant_destination01_c,true)
		Cmd_Move(sg_vehicule,mkr_reinfInformant_destination01,true)
		Cmd_Move(sg_vehicule,locationToAttack,true)
		
		encData = {
		
			player = player2,
			spawn = locationToSpawnVehicule,
		--	sgroups = sgroupList,
			units = {
				{
					
					sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
					sgroups = {sg_deleteme},
					spawn = mkr_offMap,
				},
			},
		}
		unitData = {
			{
				
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				sgroups = sgroupList,
				spawn = sg_vehicule,
			},
		}
	-- halftrack + panzer grenadiers
	elseif TypeOfAttack == HALFTRACK_PANZERGRENADIERS then
		vehiculeType = SBP.GERMAN.SDKFZ_251_HALFTRACK_SQUAD
		
		Util_CreateSquads(player2, sg_vehicule, vehiculeType, locationToSpawnVehicule)
		
		Cmd_Move(sg_vehicule, mkr_reinfInformant_destination02_b)
		Cmd_Move(sg_vehicule, mkr_reinfInformant_destination02,true)
		Cmd_Move(sg_vehicule, mkr_reinfInformant_destination03,true)
		Cmd_Move(sg_vehicule, locationToAttack,true)
		
		encData = {
		
			player = player2,
			spawn = locationToSpawnVehicule,
			units = {
				{
					
					sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
					sgroups = {sg_deleteme},
					spawn = mkr_offMap,
				},
			},
		}
		unitData = {
			{
				
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
				sgroups = sgroupList,
				spawn = sg_vehicule,
			},
		}
		
	-- OPEL + Pioneers
	elseif TypeOfAttack == OPEL_PIONEERS then
	
		vehiculeType = SBP.GERMAN.OPEL_BLITZ_SQUAD
		
		Util_CreateSquads(player2, sg_vehicule, vehiculeType, locationToSpawnVehicule)
		
		Cmd_Move(sg_vehicule, mkr_reinfInformant_destination01_b)
		Cmd_Move(sg_vehicule, mkr_reinfInformant_destination01_c,true)
		Cmd_Move(sg_vehicule, mkr_reinfInformant_destination01,true)
		Cmd_Move(sg_vehicule, locationToAttack,true)
		
		encData = {
		
			player = player2,
			spawn = locationToSpawnVehicule,
	
			units = {
				{
					
					sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
					sgroups = {sg_deleteme},
					spawn = mkr_offMap,
					
				},
			},
		}
		unitData = {
			{
				
				sbp = SBP.GERMAN.PIONEER_SQUAD,
				sgroups = sgroupList,
				spawn = sg_vehicule,
			},
		}
		if g_hardDiff or g_easyDiff ~= true then
			unitData[1].upgrades = {UPG.GERMAN.PIONEER_FLAMETHROWER}
		end
		
	-- OPEL + panzer grenadiers + 
	elseif TypeOfAttack == OPEL_PANZERGRENADIERS_MORTAR then
		vehiculeType = SBP.GERMAN.OPEL_BLITZ_SQUAD
		
		Util_CreateSquads(player2, sg_vehicule, vehiculeType, locationToSpawnVehicule)
		Cmd_Move(sg_vehicule, mkr_reinfInformant_destination02)
		Cmd_Move(sg_vehicule, mkr_reinfInformant_destination03,true)
		Cmd_Move(sg_vehicule, locationToAttack,true)
		
		encData = {
		
			player = player2,
			spawn = locationToSpawnVehicule,
			units = {
				{
					
					sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
					sgroups = {sg_deleteme},
					spawn = mkr_offMap,
				},

			},
		}
		unitData = {
			{
				
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
				sgroups = sgroupList,
				spawn = sg_vehicule,
			},
		}

		-- halftrack + pionners flamethrowers + Mortar
	elseif TypeOfAttack == HALFTRACK_PIONEER_MORTAR then
		vehiculeType = SBP.GERMAN.SDKFZ_251_HALFTRACK_SQUAD
		
		Util_CreateSquads(player2, sg_vehicule, vehiculeType, locationToSpawnVehicule)
		Cmd_Move(sg_vehicule, mkr_reinfInformant_destination01_b)
		Cmd_Move(sg_vehicule, mkr_reinfInformant_destination01_c,true)
		Cmd_Move(sg_vehicule, mkr_reinfInformant_destination01,true)
		Cmd_Move(sg_vehicule, mkr_reinfInformant_destination04,true)
		
		Cmd_Move(sg_vehicule, locationToAttack,true)
		
		encData = {
		
			player = player2,
			spawn = locationToSpawnVehicule,
			units = {
				{
					sgroups = {sg_deleteme},
					spawn = mkr_offMap,
					sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
				},
			},
		}
		unitData = {
			{
					
				sbp = SBP.GERMAN.PIONEER_SQUAD,
				sgroups = sgroupList,
				spawn = sg_vehicule,
				upgrades = {UPG.GERMAN.PIONEER_FLAMETHROWER},
			},
			{
				
				sbp = SBP.GERMAN.MORTAR_TEAM_81MM,
				sgroups = sgroupList,
				spawn = sg_vehicule,
				load = 2,
			},
		}
		-- OPEL + sniper + panzer grenadiers
	elseif TypeOfAttack == OPEL_PANZERGRENADIERS_SNIPER then
		vehiculeType = SBP.GERMAN.OPEL_BLITZ_SQUAD
		
		Util_CreateSquads(player2, sg_vehicule, vehiculeType, locationToSpawnVehicule)
		Cmd_Move(sg_vehicule, mkr_reinfInformant_destination02_b)
		Cmd_Move(sg_vehicule, mkr_reinfInformant_destination02,true)
		Cmd_Move(sg_vehicule, mkr_reinfInformant_destination03,true)
		Cmd_Move(sg_vehicule, locationToAttack,true)
		
		encData = {
		
			player = player2,
			spawn = locationToSpawnVehicule,
			units = {
				{
					sgroups = {sg_deleteme},
					spawn = mkr_offMap,
					sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
				},
			},
		}
		unitData = {
			{
				
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
				sgroups = sgroupList,
				spawn = sg_vehicule,
			},
			{
				
				sbp = SBP.GERMAN.SNIPER_SQUAD,
				sgroups = {sg_squadToUse},
				spawn = sg_vehicule,
			},
		}
		
		-- halftrack + panzer grenadiers
	elseif TypeOfAttack == HALFTRACK_PANZERGRENADIERS02 then
		vehiculeType = SBP.GERMAN.SDKFZ_251_HALFTRACK_SQUAD
		
		Util_CreateSquads(player2, sg_vehicule, vehiculeType, locationToSpawnVehicule)
		
		Cmd_Move(sg_vehicule, locationToAttack)
		
		encData = {
		
			player = player2,
			spawn = locationToSpawnVehicule,
		--	sgroups = sgroupList,
			units = {
				{
					sgroups = {sg_deleteme},
					spawn = mkr_offMap,
					sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
				},
			},
		}
		unitData = {
			{
				
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
				sgroups = {sg_squadToUse},
				spawn = sg_vehicule,
			},
		}
	
	-- OPEL + Pioneers
	elseif TypeOfAttack == OPEL_PIONEERS02 then
	
		vehiculeType = SBP.GERMAN.OPEL_BLITZ_SQUAD
		
		Util_CreateSquads(player2, sg_vehicule, vehiculeType, locationToSpawnVehicule)
		

		Cmd_Move(sg_vehicule, locationToAttack)
		
		encData = {
		
			player = player2,
			spawn = locationToSpawnVehicule,
		--	sgroups = sgroupList,
			units = {
				{
					sgroups = {sg_deleteme},
					spawn = mkr_offMap,
					sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
				},
			},
		}
		unitData = {
			{
				
				sbp = SBP.GERMAN.PIONEER_SQUAD,
				sgroups = {sg_squadToUse},
				spawn = sg_vehicule,
			},
		}
		
		if g_easyDiff ~= true then
			unitData[1].upgrades = {UPG.GERMAN.PIONEER_FLAMETHROWER}
		end
		
	elseif TypeOfAttack == OPEL_PANZERGRENADIERS then
		vehiculeType = SBP.GERMAN.OPEL_BLITZ_SQUAD
		
		Util_CreateSquads(player2, sg_vehicule, vehiculeType, locationToSpawnVehicule)
		
		Cmd_Move(sg_vehicule, locationToAttack)
		
		encData = {
		
			player = player2,
			spawn = locationToSpawnVehicule,
	--		sgroups = sgroupList,
			units = {
				{
					sgroups = {sg_deleteme},
					spawn = mkr_offMap,
					sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
				},
			},
		}
		unitData = {
			{
				
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
				sgroups = sgroupList,
				spawn = sg_vehicule,
				load = 3,
			},
		}
		
	elseif TypeOfAttack == OPEL_PANZERGRENADIERS03 then
		vehiculeType = SBP.GERMAN.OPEL_BLITZ_SQUAD
		
		Util_CreateSquads(player2, sg_vehicule, vehiculeType, locationToSpawnVehicule)
		
		Cmd_Move(sg_vehicule, mkr_reinfInformant_destination02_b)
		Cmd_Move(sg_vehicule, mkr_reinfInformant_destination02,true)
		Cmd_Move(sg_vehicule, mkr_reinfInformant_destination03,true)
		Cmd_Move(sg_vehicule, locationToAttack,true)

		encData = {
		
			player = player2,
			spawn = locationToSpawnVehicule,
			units = {
				{
					sgroups = {sg_deleteme},
					spawn = mkr_offMap,
					sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
				},
			},
		}
		
		unitData = {
			{
				
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
				sgroups = sgroupList,
				spawn = sg_vehicule,
				load = 3,
			},
		}
	end
	
	encID = Encounter:Create(encData)
	
	Event_Timer(DelayedSpawn, {encID = encID, unitData = unitData, sgroup = sg_deleteme}, 0.1)
	----- will check the proximity of vehicule to the location to attack
	eventID_ProxVehicule = Event_Proximity(VehiculeIsAtDest,nil,sg_vehicule,locationToAttack,15,ANY,2)
	MakeVehicleSnipable(sg_vehicule)
	return encID
end

function MakeVehicleSnipable(sgroup)
	return Event_IsUnderAttack(ApplyDriverKilledCritical, nil, sgroup, ANY, 0.15, player1)
end

function ApplyDriverKilledCritical(data)
	local critOdds = 3
	
	if campaignDifficulty == GD_EASY then
		critOdds = 2
	end

	critOdds = World_GetRand(1, critOdds)
	local sg_attacker = SGroup_CreateIfNotFound("sg_attacker")		
	SGroup_GetLastAttacker( data._group, sg_attacker, 0.15) 
		
	if 	critOdds == 1 and 
	SGroup_IsEmpty(sg_attacker) == false and 
	SGroup_ContainsBlueprints( sg_attacker, {BP_GetSquadBlueprint("m11_ania_sniper_squad"), BP_GetSquadBlueprint("m11_sniper_team")}, ANY ) then	
		local entity = Squad_EntityAt(SGroup_GetSpawnedSquadAt(data._group, 1), 0)
		local squadsHeld = SGroup_CreateIfNotFound("__squadsHeldOn")
		SGroup_Clear(squadsHeld)
		SGroup_GetSquadsHeld(data._group, squadsHeld)
		
		if SGroup_CountSpawned(squadsHeld) > 0 then
			SGroup_Kill(squadsHeld)
		end
		
		Entity_ApplyCritical(entity, CRIT.VEHICLE_OUT_OF_CONTROL_SLOW, 1.1)
		UI_CreateSGroupKickerMessage(player1, data._group, 11039031)  -- driver killed
		
		--achievement
		if b_achievement_snipeDriver == false then
			b_achievement_snipeDriver = true
			Scar_CompleteIntelBulletinTask(player1, "camp11_EnemyLines_SnipeDriver")
		end
	else
		MakeVehicleSnipable(data._group)
	end
end
