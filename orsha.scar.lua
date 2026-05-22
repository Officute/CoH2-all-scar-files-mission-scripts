-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- Act 2 - Mission 3
-- Operation Bagration
-- Designer: Mitch Lagran
-------------------------------------------------------------------------
-------------------------------------------------------------------------
import("ScarUtil.scar")
import("Systems/AiManager/ai.scar")
import("Prototype/DeploymentPoints.scar")
import("CampaignSetup.scar")
import("Beginner.scar")
import("Order227.scar")
import("Global_Values/CampaignGlobalConstants.scar")

-------------------------------------------------------------------------
-- [[ Mission Setup ]]
-------------------------------------------------------------------------

function OnGameSetup()	
	-- Required Players
	player1 = Setup_Player(1, 11039130, "soviet", 1) -- LOCDB [11039130] '11th Guards Army'
	player2 = Setup_Player(2,  11039131, "german", 2) -- LOCDB [11039131] 'XXVII Corps'
	
	-- Optional Players
	player3 = Setup_Player(3, 11039130, "soviet", 1)		-- player3 is always the AI ally
	player4 = Setup_Player(4, 11039130, "soviet", TEAM_NEUTRAL)	
	
	-- 227 Commissar
	player227 = Setup_Player(5, 11038758, "soviet", 3)
end

function OnGameRestore()	
	-- function takes care of restoring all global mission parameters after a save/load
	player1 = World_GetPlayerAt(1)
	player2 = World_GetPlayerAt(2)
    player3 = World_GetPlayerAt(3)
	player4 = World_GetPlayerAt(4)
	player227 = Setup_Player(5, 11038758, "soviet", 3)
	
	Game_DefaultGameRestore()
end

function Mission_Setup()
	musicStart = "streamed/music/missions/m09/m09_cue_start.bsc"
	musicRadioSilence = "streamed/music/missions/m09/m09_cue_radio_silence.bsc"
	musicBreakthrough = "streamed/music/missions/m09/m09_cue_breakthrough.bsc"
	Util_PlayMusic(musicStart, 0, 0)

	Sound_PreCacheSound("streamed/music/missions/m09/m05_full")
	Sound_PreCacheSinglePlayerSpeech("mission/m09") 
	g_MissionSpeechPath = "mission/m09"		
	
	NIS01 = "SP/CoH2_Campaign/M09-Bagration/nis/m09_intro"
	nis_load(NIS01)	
	nis_setintransitiontime(0)
	nis_setouttransitiontime(1)
	
	Camera_SetDefault(35, 45, 280)
	Camera_ResetToDefault()
	
	-- Territories
	territory_fwdRight = World_GetTerritorySectorID(Util_GetPosition(eg_forwardRightTerritory))
	territory_fwdLeft = World_GetTerritorySectorID(Util_GetPosition(eg_forwardLeftTerritory))
	territory_midRight = World_GetTerritorySectorID(Util_GetPosition(eg_midRightTerritory))
	territory_midLeft = World_GetTerritorySectorID(Util_GetPosition(eg_midLeftTerritory))
	territory_player = World_GetTerritorySectorID(Util_GetPosition(eg_playerTerritory))
	territory_communications = World_GetTerritorySectorID(Util_GetPosition(eg_commTerritory))
	territory_vehicleBase = World_GetTerritorySectorID(Util_GetPosition(eg_vehicleTerritory))
	territory_hqBase = World_GetTerritorySectorID(Util_GetPosition(eg_hqTerritory))
	territory_bankRight = World_GetTerritorySectorID(Util_GetPosition(eg_bankRightTerritory))
	territory_bankLeft = World_GetTerritorySectorID(Util_GetPosition(eg_bankLeftTerritory))

	sg_mergehints = SGroup_CreateIfNotFound("sg_mergehints")
	sg_reinforcehints = SGroup_CreateIfNotFound("sg_reinforcehints")
	eg_reinforcehints = EGroup_CreateIfNotFound("eg_reinforcehints")
	
	Player_SetAbilityAvailability(player2, ABILITY.GERMAN.PANZER_GRENADIER_BUNDLED_CAMPAIGN, ITEM_UNLOCKED)
	Player_CompleteUpgrade(player2, BP_GetUpgradeBlueprint("panzerfaust_slow"))
	Player_AddAbility(player2, BP_GetAbilityBlueprint("stuka_strafe_m09"))
	Player_AddAbility(player1, ABILITY.SOVIET.IL_2_RECON)
	Player_AddAbility(player1, ABILITY.SOVIET.BASE_CONSCRIPT_DISPATCH)
	Player_AddAbility(player1, BP_GetAbilityBlueprint("frontoviki_conscript_dispatch"))
	Player_AddAbility(player1, ABILITY.SOVIET.PENAL_TROOP_DISPATCH_SP)
	Player_SetAbilityAvailability(player1, ABILITY.SOVIET.BASE_CONSCRIPT_DISPATCH, ITEM_DEFAULT)
	Player_SetAbilityAvailability(player1, ABILITY.SOVIET.IL_2_RECON, ITEM_DEFAULT)
	Player_CompleteUpgrade(player1, UPG.SOVIET.IL_2_RECON)
	Player_CompleteUpgrade(player1, UPG.SOVIET.SHOCK_TROOPS)
	
	Player_SetResource(player1, RT_Command, 100)
	Modify_VehicleRepairRate(player1, 3, EBP.SOVIET.COMBAT_ENGINEER)

	Order227_Init(90, 9)
	ConscriptProgression_AudioInit()
	UI_SetSoviet227Visibility(true)

	Cmd_Upgrade(sg_hulledDownTanks, BP_GetUpgradeBlueprint("instant_german_hulldown"), nil, true)
	
	Player_SetSquadProductionAvailability(player1, SBP.SOVIET.IS_2, ITEM_REMOVED)
	Modify_Upkeep(player1, 0.75)
	sg_p_units = SGroup_CreateIfNotFound("sg_p_units")
	sg_playerEngies = SGroup_CreateIfNotFound("sg_playerEngies")
	sg_playerSnipers = SGroup_CreateIfNotFound("sg_playerSnipers")
	
	Player_SetResource(player1, RT_Manpower, 650)
	Modify_PlayerResourceCap(player1, RT_Manpower, 1501, MUT_Addition)
	Modify_PlayerResourceRate(player1, RT_Manpower, 1.1, MUT_Multiplication)
	
	Player_SetResource(player1, RT_Fuel, 90)
	Modify_PlayerResourceRate(player1, RT_Fuel, 1.25, MUT_Multiplication)
	Modify_PlayerResourceCap(player1, RT_Fuel, 301, MUT_Addition)
	
	Player_SetResource(player1, RT_Munition, 100)
	Modify_PlayerResourceCap(player1, RT_Munition, 401, MUT_Addition)
	Player_SetPopCapOverride(player1, 120)
	
	
	EGroup_SetInvulnerable(eg_bridge, true)
	
	retreatAmount_FrontLines = 12
	retreatAmount_BackLineLeft = 10
	retreatAmount_BackLineRight = 12
	retreatAmount_BackLineMid = 4
	retreatAmount_CityDefense = 5
	
	SetupMainObjective()
	
	FrontLine_Setup()	
	BreakLine_Setup()
	CaptureTown_Setup()	
	
	EGroup_EnableUIDecorator(eg_radioStation, false)
	EGroup_EnableMinimapIndicator(eg_radioStation, false)
  	EGroup_SetSelectable( eg_radioStation, false ) 
	
	EGroup_SetInvulnerable(eg_mapEntryBridge, true)
	
	Rule_Add(TankHuskHandler)
end

function SetupMainObjective()
	obj_main = {
		OnStart = FrontLine_Start,
		Intel_Start = nil,
		Intel_Complete = nil,
		Intel_Fail = nil,
		Title = 11039132, -- LOCDB [11039132] 'Liberate the town of Orscha from the Germans'
		Description = 1459051,		
		TitleEnd = 11039132,			
		TitleFail = 1459052,		
		Type = OT_Primary,	
	}
	Objective_Register(obj_main)
end

-------------------------------------------------------------------------
-- Mission Start 
-------------------------------------------------------------------------

function Mission_Start()
	playerRadioEnabled = true
	FrontLine_Enemies()
	
	if campaignDifficulty == GD_NORMAL or campaignDifficulty == GD_HARD then
		SGroup_IncreaseVeterancyRank(sg_tanksV1, 1, true)
		SGroup_IncreaseVeterancyRank(sg_tanksV2, 2, true)
	end
	if campaignDifficulty == GD_HARD then
		SGroup_IncreaseVeterancyRank(sg_tanksV3, 3, true)
	end
	
	-- hints about merging into damaged squads and reinforcing from halftracks and HQs
	Mission_UpdateHintGroups()
	BeginnerHint_AddOpportunity(sg_mergehints, HINT_MERGE, true, nil, nil, nil, GD_EASY)
	BeginnerHint_AddOpportunity(sg_reinforcehints, HINT_REINFORCE, true, nil, nil, nil, GD_EASY)
	Rule_AddInterval(Mission_UpdateHintGroups, 30)
	
	Event_OnHealth(Mission_Fail, nil, eg_playerHQ, 0)


	Util_StartNislet(EVENTS.NIS_Intro, IntroNisletSkipped)	
	Event_Timer(CheckPlayerTankAchievement, nil, 5)	
	
	EGroup_SetRallyPoint(eg_playerWeaponSupport, mkr_defaultRallyRight)
	EGroup_SetRallyPoint(eg_playerHQ, mkr_defaultRallyMiddle)
end

function IntroNisletSkipped()
	introNisletSkipped = true
	Event_Remove(evt_introSendAir)
	Event_Remove(evt_introCreateBarracks)
	
	SGroup_WarpToMarker(sg_playerEngies, mkr_engyBuildPosition)
	SGroup_WarpToMarker(sg_playerSnipers, mkr_sniperMoveto)
	
	if introHasCreatedBarracks ~= true then		
		Event_Remove(evt_introCreateBarracks)
		Intro_CreateBarracks()
	end
	
	if introHasSentAirRecon ~= true then	
		Player_AddAbility(player1, ABILITY.SOVIET.IL_2_RECON_SINGLEPASS_SP)
		Cmd_Ability(player1, ABILITY.SOVIET.IL_2_RECON_SINGLEPASS_SP, mkr_planeRecon, Marker_GetDirection(mkr_planeRecon), true)	
		Player_SetAbilityAvailability(player1, ABILITY.SOVIET.IL_2_RECON_SINGLEPASS_SP, ITEM_REMOVED)
	end
end

function Mission_UpdateHintGroups()

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

-------------------------------------------------------------------------
-- Objective1: Front Line
-------------------------------------------------------------------------
function FrontLine_Setup()
	sg_fwdPoints = SGroup_CreateIfNotFound("sg_fwdPoints")	
	sg_fwdPointsLeft = SGroup_CreateIfNotFound("sg_fwdPointsLeft")	
	sg_fwdPointsRight = SGroup_CreateIfNotFound("sg_fwdPointsRight")
	
	obj_FrontLine = {
		OnStart = function()
			hp_id_1 = Objective_AddUIElements(obj_FrontLine, eg_fwdLeft, true, LOC("Enemy Position"))
			hp_id_2 = Objective_AddUIElements(obj_FrontLine, eg_fwdRight, true, LOC("Enemy Position"))
		end,	
		
		Parent = obj_main,
		Intel_Start = EVENTS.Foothold,				
		Intel_Complete = nil,		
		Intel_Fail = nil,			
		Title = 11039133, -- LOCDB [11039133] 'Secure the nearby territories'
		Description = 1459051,		
		TitleEnd = 11039133,			
		TitleFail = 1459052,		
		Type = OT_Primary,			
	}
	Objective_Register(obj_FrontLine)		
end

function FrontLine_Enemies()
	-- Right side encounter
	local encData = {
		player = player2,
		spawn = mkr_fwdRightBase_Spawn_04,
		sgroups = {sg_fwdPoints, sg_fwdPointsRight},
		units = {
			{sbp = SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD,	spawn = mkr_fwdRightBase_Spawn_04,	numSquads = 1,	},			
			
			{difficulty = GD_EASY,		sbp = SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD,	spawn = mkr_fwdRightBase_Spawn_01,	numSquads = 1,	veterancyRank = 0},
			{difficulty = GD_NORMAL,	sbp = SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD,	spawn = mkr_fwdRightBase_Spawn_01,	numSquads = 1,	veterancyRank = 1},
			{difficulty = GD_HARD,		sbp = SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD,	spawn = mkr_fwdRightBase_Spawn_01,	numSquads = 1,	veterancyRank = 2},
		},
	}
	enc_fwdRight = Encounter:Create(encData)
	defenseGoal = {
		name = "Defend",
		target = mkr_fwdRightBase,
		range = mkr_fwdRightBase,
		leashRange = mkr_fwdRightBaseLeash,
		garrisonIdle = false,
		garrison = false,
		pickupWeapons = false,	
	}
	enc_fwdRight:SetGoal(defenseGoal)
		
	local encData = {
		player = player2,
		spawn = mkr_fwdRightSpawn,
		sgroups = {sg_fwdPoints, sg_fwdPointsRight},
		units = {
			{sbp = SBP.GERMAN.SNIPER_SQUAD,		spawn = mkr_fwdRightBase_Spawn_05,	numSquads = 1,	},
			{sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,	spawn = mkr_fwdRightBase_Spawn_05,	numSquads = 1,	},
			{sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,	spawn = mkr_fwdRightBase_Spawn_01,	numSquads = 1,	},
			
			{difficulty = {GD_EASY, GD_NORMAL},	sbp = SBP.GERMAN.SNIPER_SQUAD,	spawn = mkr_fwdRightBase_Spawn_05,	numSquads = 1,	},
			{difficulty = GD_HARD,				sbp = SBP.GERMAN.SNIPER_SQUAD,	spawn = mkr_fwdRightBase_Spawn_05,	numSquads = 1,	veterancyRank = 3},
						
			{difficulty = GD_EASY,		sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,			spawn = mkr_fwdRightBase_Spawn_01,	numSquads = 1,	veterancyRank = 0},
			{difficulty = GD_NORMAL,	sbp = SBP.GERMAN.GRENADIER_SQUAD,			spawn = mkr_fwdRightBase_Spawn_01,	numSquads = 1,	veterancyRank = 0},
			{difficulty = GD_HARD,		sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,	spawn = mkr_fwdRightBase_Spawn_01,	numSquads = 1,	veterancyRank = 0},
						
			{difficulty = GD_EASY,		sbp = SBP.GERMAN.GRENADIER_SQUAD,	spawn = mkr_fwdRightBase_Spawn_04,	numSquads = 1,	veterancyRank = 0},
			{difficulty = GD_NORMAL,	sbp = SBP.GERMAN.GRENADIER_SQUAD,	spawn = mkr_fwdRightBase_Spawn_04,	numSquads = 1,	veterancyRank = 1},
			{difficulty = GD_HARD,		sbp = SBP.GERMAN.GRENADIER_SQUAD,	spawn = mkr_fwdRightBase_Spawn_04,	numSquads = 1,	veterancyRank = 2},
		},
	}
	enc_fwdRight2 = Encounter:Create(encData)	
	defenseGoal = {
		name = "Defend",
		target = mkr_fwdRightBase,
		range = mkr_fwdRightBase,
		leashRange = mkr_fwdRightBaseLeash,
		garrisonIdle = true,
		garrison = true,
		pickupWeapons = true,		
		
		tacticControlsList = {
			{
				tacticType = TACTIC_Hold,
				priority = 100,
				maxUsers = 2,
			},
		},
	}	
	enc_fwdRight2:SetGoal(defenseGoal)
	SetupATGunEncounter(sg_fwdPointsRightATGun)
	
	--Left Side Encounter
	local encData = {
		player = player2,
		spawn = mkr_fwdLeftBase,
		sgroups = {sg_fwdPoints, sg_fwdPointsLeft},
		units = {
			{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,	spawn = mkr_fwdLeftBase_spawn_04,	numSquads = 1,	},
			{sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,			spawn = mkr_fwdLeftBase_spawn_04,	numSquads = 1,	},
			{sbp = SBP.GERMAN.GRENADIER_SQUAD,			spawn = mkr_fwdLeftBase_spawn_05,	numSquads = 1,	},
			
			{difficulty = {GD_EASY, GD_NORMAL},	sbp = SBP.GERMAN.GRENADIER_SQUAD,	spawn = mkr_fwdLeftBase_spawn_03,	numSquads = 1,	},
			{difficulty = GD_HARD,				sbp = SBP.GERMAN.GRENADIER_SQUAD,	spawn = mkr_fwdLeftBase_spawn_03,	numSquads = 1,	upgrades = UPG.GERMAN.GRENADIER_MG42_LMG},
			
			{difficulty = GD_EASY,		sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,	spawn = mkr_fwdLeftBase_spawn_02,	numSquads = 1,	veterancyRank = 0},
			{difficulty = GD_NORMAL,	sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,	spawn = mkr_fwdLeftBase_spawn_02,	numSquads = 1,	veterancyRank = 2},
			{difficulty = GD_HARD,		sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,	spawn = mkr_fwdLeftBase_spawn_02,	numSquads = 1,	veterancyRank = 3},
			
			{difficulty = {GD_EASY, GD_NORMAL},	sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,			spawn = mkr_fwdLeftBase_spawn_02,	numSquads = 1,	veterancyRank = 0},
			{difficulty = GD_HARD,				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,	spawn = mkr_fwdLeftBase_spawn_02,	numSquads = 1,	veterancyRank = 1},
		},
	}
	enc_fwdLeft = Encounter:Create(encData)	
	defenseGoal = {
		name = "Defend",
		target = mkr_fwdLeftBase,
		range = mkr_fwdLeftBase,
		leashRange = mkr_fwdLeftBaseLeash,
		garrisonIdle = true,
		garrison = true,
		pickupWeapons = true,		
		
		tacticControlsList = {
			{
				tacticType = TACTIC_Hold,
				priority = 100,
				maxUsers = 2,
			},
		},
	}	
	enc_fwdLeft:SetGoal(defenseGoal)
	
	SetupATGunEncounter(sg_fwdPointsLeftATGun)
	
	local encData = {
		player = player2,
		spawn = mkr_fwdLeftBase_spawn_06,
		sgroups = {sg_fwdPoints, sg_fwdPointsLeft},
		units = {
			{sbp = SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD,	spawn = mkr_fwdLeftBase_spawn_03,	numSquads = 1,	},
			
			{difficulty = {GD_EASY, GD_NORMAL},	sbp = SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD,	spawn = mkr_fwdLeftBase_spawn_06,	numSquads = 1,	veterancyRank = 0},
			{difficulty = GD_HARD,				sbp = SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD,	spawn = mkr_fwdLeftBase_spawn_06,	numSquads = 1,	veterancyRank = 1},
		},
	}
	enc_fwdLeft2 = Encounter:Create(encData)
	defenseGoal = {
		name = "Defend",
		target = mkr_fwdLeftBase,
		range = mkr_fwdLeftBase,
		leashRange = mkr_fwdLeftBaseLeash,
		garrisonIdle = false,
		garrison = false,
		pickupWeapons = false,	
	}
	enc_fwdLeft2:SetGoal(defenseGoal)
	
	Event_GroupLeftAlive(EventHandler_StaggeredRetreat, {group = sg_fwdPointsLeft, location = mkr_retreat}, sg_fwdPointsLeft, retreatAmount_FrontLines)
	Event_GroupLeftAlive(EventHandler_StaggeredRetreat, {group = sg_fwdPointsRight, location = mkr_retreat}, sg_fwdPointsRight, retreatAmount_FrontLines)
end

function SetupATGunEncounter(sgroup)
	local enc = Encounter:ConvertSgroup(sgroup)
	
	defenseGoal = {
		name = "Defend",
		target = SGroup_GetPosition(sgroup),
		range = 50,
		leashRange = 10,	
		garrisonIdle = false,
		garrison = false,
		pickupWeapons = false,	
	}
	enc:SetGoal(defenseGoal)
end

function FrontLine_Start()
	UI_SetCPMeterVisibility(false) 
	Event_Timer(EventHandler_ObjectiveStart, {objective = obj_FrontLine}, 3)
	
	Event_PlayerResourceLevel(FrontLine_CanBuildArmour, nil, player1, RT_Fuel, 110, 15)
	
	evt_frontLineComplete = Event_PlayerOwnsTerritory(FrontLine_Complete, nil, player1, {territory_fwdRight, territory_fwdLeft})

	evt_firstTerritory_01 = Event_PlayerOwnsTerritory(FrontLine_FirstTerritory, nil, player1, territory_fwdRight)
	evt_firstTerritory_02 = Event_PlayerOwnsTerritory(FrontLine_FirstTerritory, nil, player1, territory_fwdLeft)

	Event_IsUnderAttack(FrontLine_PlayerHasAttacked, nil, sg_fwdPoints, ANY, 1)
	
	evt_counterAttackTimer = Event_Timer(German_SpawnerStart, nil, 400)

	function _skip()
		EGroup_InstantCaptureStrategicPoint(eg_forwardRightTerritory, player1)
		EGroup_InstantCaptureStrategicPoint(eg_forwardLeftTerritory, player1)		
		SGroup_DeSpawn(sg_fwdPoints)
	end
end

function FrontLine_PlayerHasAttacked()
	playerHasStartedAttack = true
end

function FrontLine_CanBuildArmour()
	if Player_GetResource(player1, RT_Fuel) > 110 then
		Util_StartIntel(EVENTS.BuildArmour)
	end
end

function FrontLine_FirstTerritory(data)
	
	if data._territory == territory_fwdLeft then
		Objective_RemoveUIElements(obj_FrontLine, hp_id_1)
	else
		Objective_RemoveUIElements(obj_FrontLine, hp_id_2)
	end
	
	event_GermanStrafe = Event_NarrativeEventsNotRunning(BreakLine_StartGermanStrafe, nil, 10)
	Event_Remove(evt_firstTerritory_01)
	Event_Remove(evt_firstTerritory_02)
	
	Util_StartIntel(EVENTS.RushPlayer)
end

function FrontLine_Complete()
	Objective_Complete(obj_FrontLine)
	BreakLine_Start()
end

-------------------------------------------------------------------------
-- Objective 2: Break Line
-------------------------------------------------------------------------
function BreakLine_Setup()
	sg_backLine = SGroup_CreateIfNotFound("sg_backLine")
	sg_backLineRight = SGroup_CreateIfNotFound("sg_backLineRight")
	sg_backLineLeft = SGroup_CreateIfNotFound("sg_backLineLeft")
	sg_backLineMid = SGroup_CreateIfNotFound("sg_backLineMid")
	sg_bankLine = SGroup_CreateIfNotFound("sg_bankLine")
	sg_cityDefenseLeft = SGroup_CreateIfNotFound("sg_cityDefenseLeft")
	sg_cityDefenseRight = SGroup_CreateIfNotFound("sg_cityDefenseRight")
	sg_cityDefenseLeft = SGroup_CreateIfNotFound("sg_cityDefenseLeft")
	
	obj_BreakLine = {		
		OnStart = function()
			objMkr_breakLine01 = Objective_AddUIElements(obj_BreakLine, eg_bankRightTerritory, true, LOC("Capture territory"))
			objMkr_breakLine02 = Objective_AddUIElements(obj_BreakLine, eg_bankLeftTerritory, true, LOC("Capture territory"))
			
			BreakLine_CanHitRadio()
		end,
		
		Parent = obj_main,
		Intel_Start = EVENTS.BreakLine,		
		Intel_Complete = EVENTS.BrokeLine,	
		Intel_Fail = nil,	
		Title = 11039137, -- LOCDB [11039137] 'Break through the German defensive lines'
		Description = 11039138,		
		TitleEnd = 11039137,			
		TitleFail = 1459052,	
		Type = OT_Primary,	
	}	
	Objective_Register(obj_BreakLine)
	
	obj_Communications = {		
		OnStart = function()
--~ 			hp_id_1 = Objective_AddUIElements(obj_Communications, Util_GetPosition(mkr_commStation), false, nil)	-- LOCDB [11039135] 'Restablish communication lines'
			Sound_StopMusic(CAMPAIGN_MUSIC_FADEOUT, 0)
			Util_PlayMusic(musicRadioSilence, 0, 3)
		end,
		
		OnComplete = function()
			Sound_StopMusic(CAMPAIGN_MUSIC_FADEOUT, 0)
			Util_PlayMusic(musicStart, 0, 3)
		end,
		
		Intel_Start = nil,			
		Intel_Complete = EVENTS.CommsReestablished,
		Intel_Fail = nil,			
		Title = 11039136, -- LOCDB [11039136] 'Restablish communication with the main Soviet Forces'
		Description = 1459051,		
		TitleEnd = 11039136,			
		TitleFail = 1459052,		
		Type = OT_Secondary,	
	}
	Objective_Register(obj_Communications)
end

function BreakLine_Enemies()	
	--back left, near the infantry entrance
	local encData = {
		player = player2,
		spawn = mkr_backLeftBase,
		sgroups = {sg_backLine, sg_backLineLeft},
		units = {
			{sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,			spawn = mkr_backLeftSpawn_01,	numSquads = 1,	},
			{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,	spawn = mkr_backLeftSpawn_05,	numSquads = 1,	},
			{sbp = SBP.GERMAN.SNIPER_SQUAD,				spawn = mkr_backLeftSpawn_05,	numSquads = 1,	},
			{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,	spawn = mkr_backLeftSpawn_06,	numSquads = 1,	},
			
			{difficulty = {GD_EASY, GD_NORMAL},	sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,		spawn = mkr_backLeftSpawn_03,	numSquads = 1,	},
			{difficulty = GD_HARD,				sbp = SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD,	spawn = mkr_backLeftSpawn_03,	numSquads = 1,	upgrades = UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM},
			
			
			{difficulty = GD_EASY,		sbp = SBP.GERMAN.GRENADIER_SQUAD,	spawn = mkr_backLeftSpawn_03,	numSquads = 1,	upgrades = UPG.GERMAN.GRENADIER_MG42_LMG,	veterancyRank = 0},		
			{difficulty = GD_NORMAL,	sbp = SBP.GERMAN.GRENADIER_SQUAD,	spawn = mkr_backLeftSpawn_03,	numSquads = 1,	upgrades = UPG.GERMAN.GRENADIER_MG42_LMG,	veterancyRank = 2},		
			{difficulty = GD_HARD,		sbp = SBP.GERMAN.GRENADIER_SQUAD,	spawn = mkr_backLeftSpawn_03,	numSquads = 1,	upgrades = UPG.GERMAN.GRENADIER_MG42_LMG,	veterancyRank = 3},	
			
			{difficulty = GD_EASY,		sbp = SBP.GERMAN.SNIPER_SQUAD,	spawn = mkr_backLeftSpawn_06,	numSquads = 1,	veterancyRank = 0},		
			{difficulty = GD_NORMAL,	sbp = SBP.GERMAN.SNIPER_SQUAD,	spawn = mkr_backLeftSpawn_06,	numSquads = 1,	veterancyRank = 1},		
			{difficulty = GD_HARD,		sbp = SBP.GERMAN.SNIPER_SQUAD,	spawn = mkr_backLeftSpawn_06,	numSquads = 1,	veterancyRank = 2},		
			
			
			{difficulty = GD_EASY,				sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,	spawn = mkr_backLeftSpawn_01,	numSquads = 1,	veterancyRank = 0},
			{difficulty = {GD_NORMAL, GD_HARD},	sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,	spawn = mkr_backLeftSpawn_01,	numSquads = 1,	veterancyRank = 1},
			
			{difficulty = {GD_EASY, GD_NORMAL},	sbp = SBP.GERMAN.GRENADIER_SQUAD,	spawn = mkr_backLeftSpawn_03,	numSquads = 1,	veterancyRank = 0},
			{difficulty = GD_HARD,				sbp = SBP.GERMAN.GRENADIER_SQUAD,	spawn = mkr_backLeftSpawn_03,	numSquads = 1,	veterancyRank = 1},
		},
	}
	enc_backLeft = Encounter:Create(encData)
	defenseGoal = {
		name = "Defend",
		target = mkr_backLeftBase,
		garrisonIdle = true,
		pickupWeapons = true,		
	}
	enc_backLeft:SetGoal(defenseGoal)	
	
	--Back middle, guarding small path up
	local encData = {
		player = player2,
		spawn = mkr_backMidBase,
		sgroups = {sg_backLine, sg_backLineMid},
		units = {
			{sbp = SBP.GERMAN.MORTAR_TEAM_81MM,	spawn = mkr_backMidSpawn_05,	numSquads = 1,	},
			
			{difficulty = GD_EASY,		sbp = SBP.GERMAN.SNIPER_SQUAD,	spawn = mkr_backMidSpawn_02,	numSquads = 1,	veterancyRank = 0},		
			{difficulty = GD_NORMAL,	sbp = SBP.GERMAN.SNIPER_SQUAD,	spawn = mkr_backMidSpawn_02,	numSquads = 1,	veterancyRank = 2},		
			{difficulty = GD_HARD,		sbp = SBP.GERMAN.SNIPER_SQUAD,	spawn = mkr_backMidSpawn_02,	numSquads = 1,	veterancyRank = 3},	
			
			{difficulty = {GD_EASY, GD_NORMAL},	sbp = SBP.GERMAN.SNIPER_SQUAD,	spawn = mkr_backMidSpawn_04,	numSquads = 1,	veterancyRank = 0},		
			{difficulty = GD_HARD,				sbp = SBP.GERMAN.SNIPER_SQUAD,	spawn = mkr_backMidSpawn_04,	numSquads = 1,	veterancyRank = 1},		
		},
	}
	enc_backMid = Encounter:Create(encData)	
	defenseGoal = {
		name = "Defend",
		target = mkr_backMidBase,
		garrisonIdle = false,
		pickupWeapons = true,		
	}
	enc_backMid:SetGoal(defenseGoal)	
	SetupATGunEncounter(sg_backLineMidATGuns)
	
	
	--back left, near the vehicle entrance
	local encData = {
		player = player2,
		spawn = mkr_backRightBase,
		sgroups = {sg_backLine, sg_backLineRight},
		units = {
			{sbp = SBP.GERMAN.PIONEER_SQUAD,			spawn = mkr_backRightSpawn_04,	numSquads = 1,	upgrades = UPG.GERMAN.PIONEER_FLAMETHROWER},
			{sbp = SBP.GERMAN.GRENADIER_SQUAD,			spawn = mkr_backRightSpawn_03,	numSquads = 1,	upgrades = UPG.GERMAN.GRENADIER_MG42_LMG},
			{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,	spawn = mkr_backRightSpawn_04,	numSquads = 1,	upgrades = UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM,},
			
			{difficulty = {GD_EASY, GD_NORMAL},	sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,	spawn = mkr_backRightSpawn_03,	numSquads = 1,	veterancyRank = 0},		
			{difficulty = GD_HARD,				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,	spawn = mkr_backRightSpawn_03,	numSquads = 1,	veterancyRank = 1},		
						
			{difficulty = GD_EASY,		sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,	spawn = mkr_backRightSpawn_03,	numSquads = 1,	veterancyRank = 0},		
			{difficulty = GD_NORMAL,	sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,	spawn = mkr_backRightSpawn_03,	numSquads = 1,	veterancyRank = 2},		
			{difficulty = GD_HARD,		sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,	spawn = mkr_backRightSpawn_03,	numSquads = 1,	veterancyRank = 3},	
								
			{difficulty = GD_HARD,		sbp = SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD,	spawn = mkr_backRightSpawn_03,	numSquads = 1	},	
			
			{difficulty = GD_EASY,		sbp = SBP.GERMAN.GRENADIER_SQUAD,	spawn = mkr_backRightSpawn_04,	numSquads = 1,	veterancyRank = 0},		
			{difficulty = GD_NORMAL,	sbp = SBP.GERMAN.GRENADIER_SQUAD,	spawn = mkr_backRightSpawn_04,	numSquads = 1,	veterancyRank = 1},		
			{difficulty = GD_HARD,		sbp = SBP.GERMAN.GRENADIER_SQUAD,	spawn = mkr_backRightSpawn_04,	numSquads = 1,	veterancyRank = 2},	
		},
	}
	enc_backRight = Encounter:Create(encData)	
	defenseGoal = {
		name = "Defend",
		target = mkr_backRightBase,
		garrisonIdle = true,
		pickupWeapons = true,		
	}
	enc_backRight:SetGoal(defenseGoal)
	
	--left city entrance, guarded by infantry
	local encData = {
		player = player2,
		spawn = mkr_cityDefenseLeft,
		sgroups = {sg_cityDefenseLeft},
		units = {
			{sbp = SBP.GERMAN.GRENADIER_SQUAD,	spawn = mkr_cityDefenseLeft_08,	numSquads = 1,	upgrades = UPG.GERMAN.GRENADIER_MG42_LMG,},			
			
			{difficulty = GD_EASY,		sbp = SBP.GERMAN.GRENADIER_SQUAD,			spawn = mkr_cityDefenseLeft_01,	numSquads = 1,	},		
			{difficulty = GD_NORMAL,	sbp = SBP.GERMAN.GRENADIER_SQUAD,			spawn = mkr_cityDefenseLeft_01,	numSquads = 1,	veterancyRank = 2},		
			{difficulty = GD_HARD,		sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,	spawn = mkr_cityDefenseLeft_01,	numSquads = 1,	veterancyRank = 2},	
			
			{difficulty = GD_EASY,		sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,	spawn = mkr_cityDefenseLeft_02,	numSquads = 1,	},		
			{difficulty = GD_NORMAL,	sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,	spawn = mkr_cityDefenseLeft_02,	numSquads = 1,	},		
			{difficulty = GD_HARD,		sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,	spawn = mkr_cityDefenseLeft_02,	numSquads = 1,	upgrades = UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM},	
			
			{difficulty = GD_EASY,		sbp = SBP.GERMAN.SNIPER_SQUAD,	spawn = mkr_cityDefenseLeft_03,	numSquads = 1,	veterancyRank = 0},		
			{difficulty = GD_NORMAL,	sbp = SBP.GERMAN.SNIPER_SQUAD,	spawn = mkr_cityDefenseLeft_03,	numSquads = 1,	veterancyRank = 2},		
			{difficulty = GD_HARD,		sbp = SBP.GERMAN.SNIPER_SQUAD,	spawn = mkr_cityDefenseLeft_03,	numSquads = 1,	veterancyRank = 3},	
			
			{difficulty = {GD_EASY, GD_NORMAL},		sbp = SBP.GERMAN.SNIPER_SQUAD,	spawn = mkr_cityDefenseLeft_06,	numSquads = 1,	veterancyRank = 0},		
			{difficulty = GD_HARD,					sbp = SBP.GERMAN.SNIPER_SQUAD,	spawn = mkr_cityDefenseLeft_06,	numSquads = 1,	veterancyRank = 1},	
			
			{difficulty = GD_EASY,		sbp = SBP.GERMAN.GRENADIER_SQUAD,	spawn = mkr_cityDefenseLeft_07,	numSquads = 1,	veterancyRank = 0, upgrades = UPG.GERMAN.GRENADIER_MG42_LMG},		
			{difficulty = GD_NORMAL,	sbp = SBP.GERMAN.GRENADIER_SQUAD,	spawn = mkr_cityDefenseLeft_07,	numSquads = 1,	veterancyRank = 1, upgrades = UPG.GERMAN.GRENADIER_MG42_LMG},		
			{difficulty = GD_HARD,		sbp = SBP.GERMAN.GRENADIER_SQUAD,	spawn = mkr_cityDefenseLeft_07,	numSquads = 1,	veterancyRank = 2, upgrades = UPG.GERMAN.GRENADIER_MG42_LMG},	
		},
	}
	enc_cityLeft = Encounter:Create(encData)	
	defenseGoal = {
		name = "Defend",
		target = mkr_cityDefenseLeft,
		garrisonIdle = false,
		pickupWeapons = true,		
	}
	enc_cityLeft:SetGoal(defenseGoal)	

	--right city entrance, guarded by vehicles
	encData = {
		player = player2,
		spawn = mkr_cityDefenseRight,
		sgroups = {sg_cityDefenseRight},
		units = {			
			{difficulty = GD_EASY,		sbp = SBP.GERMAN.GRENADIER_SQUAD,			spawn = mkr_cityDefenseRight_02,	numSquads = 1,	},		
			{difficulty = GD_NORMAL,	sbp = SBP.GERMAN.GRENADIER_SQUAD,			spawn = mkr_cityDefenseRight_02,	numSquads = 1,	veterancyRank = 2},		
			{difficulty = GD_HARD,		sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,	spawn = mkr_cityDefenseRight_02,	numSquads = 1,	veterancyRank = 2},	
			
			{difficulty = {GD_EASY, GD_NORMAL},	sbp = SBP.GERMAN.GRENADIER_SQUAD,	spawn = mkr_cityDefenseRight_01,	numSquads = 1,	},			
			{difficulty = GD_HARD,				sbp = SBP.GERMAN.GRENADIER_SQUAD,	spawn = mkr_cityDefenseRight_01,	numSquads = 1,	veterancyRank = 1},	
			
			{difficulty = GD_EASY,		sbp = SBP.GERMAN.PIONEER_SQUAD,		spawn = mkr_cityDefenseRight_02,	numSquads = 1,	},		
			{difficulty = GD_NORMAL,	sbp = SBP.GERMAN.PIONEER_SQUAD,		spawn = mkr_cityDefenseRight_02,	numSquads = 1,	},		
			{difficulty = GD_HARD,		sbp = SBP.GERMAN.PIONEER_SQUAD,		spawn = mkr_cityDefenseRight_02,	numSquads = 1, upgrades = UPG.GERMAN.PIONEER_FLAMETHROWER},	
			
			{difficulty = GD_EASY,		sbp = SBP.GERMAN.PIONEER_SQUAD,		spawn = mkr_cityDefenseRight_01,	numSquads = 1,	},		
			{difficulty = GD_NORMAL,	sbp = SBP.GERMAN.PIONEER_SQUAD,		spawn = mkr_cityDefenseRight_01,	numSquads = 1,	veterancyRank = 2},		
			{difficulty = GD_HARD,		sbp = SBP.GERMAN.PIONEER_SQUAD,		spawn = mkr_cityDefenseRight_01,	numSquads = 1,	veterancyRank = 3},	
		},
	}
	enc_cityRight = Encounter:Create(encData)	
	defenseGoal = {
		name = "Defend",
		target = mkr_cityDefenseRight,
		garrisonIdle = false,
		pickupWeapons = true,		
	}
	enc_cityRight:SetGoal(defenseGoal)	
	
	Event_GroupLeftAlive(EventHandler_StaggeredRetreat, {group = sg_backLineMid, location = mkr_retreat}, sg_backLineMid, retreatAmount_BackLineMid)
	Event_GroupLeftAlive(EventHandler_StaggeredRetreat, {group = sg_backLineRight, location = mkr_retreat}, sg_backLineRight, retreatAmount_BackLineRight)
	Event_GroupLeftAlive(EventHandler_StaggeredRetreat, {group = sg_backLineLeft, location = mkr_retreat}, sg_backLineLeft, retreatAmount_BackLineLeft)
	
	Event_GroupLeftAlive(EventHandler_StaggeredRetreat, {group = sg_cityDefenseLeft, location = mkr_retreat}, sg_cityDefenseLeft, retreatAmount_CityDefense)
	Event_GroupLeftAlive(EventHandler_StaggeredRetreat, {group = sg_cityDefenseRight, location = mkr_retreat}, sg_cityDefenseRight, retreatAmount_CityDefense)
end

function BreakLine_Start()
	Objective_Start(obj_BreakLine)
	if evt_counterAttackTimer ~= nil then
		Event_Remove(evt_counterAttackTimer)
		Event_Timer(German_SpawnerStart, nil, 10)
	end
	World_IncreaseInteractionStage() --1
	World_IncreaseInteractionStage() --2
	World_IncreaseInteractionStage() --3
	BreakLine_Enemies()	
	BreakLine_CommStationEnemies()
	Event_PlayerCanSeeElement(EventHandler_StartIntel, {intel = EVENTS.buildTanks}, player1, sg_defenseTanksRight, ANY, 1.5)	
		
	event_BreakLineCompleteRight = Event_PlayerOwnsTerritory(BreakLine_Complete, nil, player1, territory_bankRight, 1)
	event_BreakLineCompleteLeft = Event_PlayerOwnsTerritory(BreakLine_Complete, nil, player1, territory_bankLeft, 1) 
	
	event_BreakLineReinforcement1 = Event_PlayerOwnsTerritory(Breakline_SetReinforcementsMedium, nil, player1, territory_midLeft)
	event_BreakLineReinforcement2 = Event_PlayerOwnsTerritory(Breakline_SetReinforcementsMedium, nil, player1, territory_midRight)
	event_BreakLineReinforcement3 = Event_PlayerOwnsTerritory(Breakline_SetReinforcementsMedium, nil, player1, territory_communications)
	
--~ 	Event_PlayerOwnsTerritory(BreakLine_CanHitRadio, nil, player1, {territory_midLeft, territory_midRight, territory_bankLeft, territory_bankRight}, ANY)
	
	function _skip()				
		SGroup_DeSpawn(sg_backLine)

		EGroup_InstantCaptureStrategicPoint(eg_midLeftTerritory, player1)
		EGroup_InstantCaptureStrategicPoint(eg_midRightTerritory, player1)	
		
		function _skip()				
			SGroup_DeSpawn(sg_cityDefenseLeft)
			SGroup_DeSpawn(sg_cityDefenseRight)
					
			EGroup_InstantCaptureStrategicPoint(eg_bankRightTerritory, player1)
			EGroup_InstantCaptureStrategicPoint(eg_bankLeftTerritory, player1)
		end
	end
end 

function Breakline_SetReinforcementsMedium(data)	
	Event_Remove(event_BreakLineReinforcement1)
	Event_Remove(event_BreakLineReinforcement2)
	Event_Remove(event_BreakLineReinforcement3)
	
	if data._territory == territory_communications then
		event_BreakLineReinforcement1 = Event_PlayerOwnsTerritory(Breakline_SetReinforcementsHard, nil, player1, territory_midLeft)
		event_BreakLineReinforcement2 = Event_PlayerOwnsTerritory(Breakline_SetReinforcementsHard, nil, player1, territory_midRight)	
	else		
		event_BreakLineReinforcement1 = Event_IsUnderAttack(Breakline_SetReinforcementsHard, nil, mkr_cityDefenseRight, ANY, 1)	
		event_BreakLineReinforcement2 = Event_IsUnderAttack(Breakline_SetReinforcementsHard, nil, mkr_cityDefenseLeft, ANY, 1)	
		event_BreakLineReinforcement3 = Event_PlayerOwnsTerritory(Breakline_SetReinforcementsHard, nil, player1, territory_communications)
	end
	
	German_SetReinforcementsDifficulty(MEDIUM)
end

function Breakline_SetReinforcementsHard()
	Event_Remove(event_BreakLineReinforcement1)
	Event_Remove(event_BreakLineReinforcement2)
	
	German_SetReinforcementsDifficulty(HARD)
end

function BreakLine_Complete()	
	if breaklineComplete ~= true then
		Event_Timer(Breakline_AutosaveFinished, nil, 2)
		Event_Remove(event_BreakLineCompleteLeft)
		Event_Remove(event_BreakLineCompleteRight)
		Util_Autosave()
	end
end

function Breakline_AutosaveFinished()
	Objective_Complete(obj_BreakLine)
	breaklineComplete = true
	CaptureTown_Start()
end

-------------------------------------------------------------------------
-- Secondary Objective: Communications Loss and Airstrikes
-------------------------------------------------------------------------
function BreakLine_StartGermanStrafe()	
	BreakLine_GermanAirStrafe(true)
end

function BreakLine_CanHitRadio()
	Event_Remove(event_GermanStrafe)	
	evt_radioTireHit = Event_IsUnderAttack(BreakLine_RadioStationHit, nil, eg_radioStation, ANY, 5)
	event_GermanStrafe = Event_NarrativeEventsNotRunning(BreakLine_GermanAirStrafe, nil, 20)
end

function BreakLine_CommStationEnemies()
	sg_commStation = SGroup_CreateIfNotFound("sg_commStation")
	local encData = {
		player = player2,
		spawn = mkr_commStation,
		sgroups = {sg_commStation},
		units = {
			{sbp = SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD,	spawn = mkr_commStationSpawn_02,	numSquads = 1,	},
			{sbp = SBP.GERMAN.SNIPER_SQUAD,					spawn = mkr_commStationSpawn_02,	numSquads = 1,	},
			
			{difficulty = {GD_HARD, GD_NORMAL},	sbp = SBP.GERMAN.MORTAR_TEAM_81MM,	spawn = mkr_commStation,	numSquads = 1,	},
			
			{difficulty = {GD_EASY, GD_NORMAL},		sbp = SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD,		spawn = mkr_commStationSpawn_01,	numSquads = 1,	},			
			{difficulty = GD_HARD,					sbp = SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD,		spawn = mkr_commStationSpawn_01,	numSquads = 1,	veterancyRank = 1},
			
			{difficulty = GD_EASY,		sbp = SBP.GERMAN.SNIPER_SQUAD,		spawn = mkr_commStationSpawn_01,	numSquads = 1,	},		
			{difficulty = GD_NORMAL,	sbp = SBP.GERMAN.SNIPER_SQUAD,		spawn = mkr_commStationSpawn_01,	numSquads = 1,	veterancyRank = 1},		
			{difficulty = GD_HARD,		sbp = SBP.GERMAN.SNIPER_SQUAD,		spawn = mkr_commStationSpawn_01,	numSquads = 1,	veterancyRank = 2},
			
			{difficulty = GD_EASY,		sbp = SBP.GERMAN.MORTAR_TEAM_81MM,		spawn = mkr_commStationSpawn_03,	numSquads = 1,	},		
			{difficulty = GD_NORMAL,	sbp = SBP.GERMAN.MORTAR_TEAM_81MM,		spawn = mkr_commStationSpawn_03,	numSquads = 1,	veterancyRank = 2},		
			{difficulty = GD_HARD,		sbp = SBP.GERMAN.MORTAR_TEAM_81MM,		spawn = mkr_commStationSpawn_03,	numSquads = 1,	veterancyRank = 3},	
		}			
	}
	local enc = Encounter:Create(encData)	
	defenseGoal = {
		name = "Defend",
		target = mkr_commStation,
		range = mkr_commStation,
		leashRange = mkr_commStation,
		garrisonIdle = false,
		pickupWeapons = true,		
	}
	enc:SetGoal(defenseGoal)
	enc:AddSgroup(sg_commStation)
end

function BreakLine_RadioStationHit()
	playerRadioEnabled = false	
	Objective_RemoveUIElements(obj_BreakLine, objMkr_breakLine01)
	Objective_RemoveUIElements(obj_BreakLine, objMkr_breakLine02)
	Objective_RemoveUIElements(obj_capTown, hp_id_1)
	Objective_RemoveUIElements(obj_capTown, hp_id_2)
	
	Event_Timer(BreakLine_StartRadioDownChatter, nil, 10)
		
	EGroup_Kill(eg_radioStation)
	
	Player_SetAbilityAvailability(player1, ABILITY.SOVIET.IL_2_RECON, ITEM_LOCKED)
	Event_PlayerOwnsTerritory(BreakLine_RegainCommunications, nil, player1, territory_communications, 1)
end

function BreakLine_StartRadioDownChatter()
	radioDownChatterStarted = true
	if not SGroup_IsEmpty(sg_backLine) then
		evt_radioDownChatter = Event_IsUnderAttack(BreakLine_RadioDownAttackChatter, nil, sg_backLine, ANY, 1)
	end
	Event_Timer(BreakLine_RadioDownWaitChatter, nil, {50, 80})
end

function BreakLine_RadioDownAttackChatter()
	if playerRadioEnabled == false then
		Util_StartIntel(EVENTS.CommsOutNeedAir)
	end
end
function BreakLine_RadioDownWaitChatter()
	if playerRadioEnabled == false then
		if  SGroup_IsDoingAttack(Player_GetSquads(player1), ANY, 5) == false then
			Util_StartIntel(EVENTS.CommsOutBlind)
		else			
			Event_Timer(BreakLine_RadioDownWaitChatter, nil, 25)
		end
	end
end

function BreakLine_RegainCommunications()
	failedCommsAchievement = true
	Objective_Complete(obj_Communications) 
	playerRadioEnabled = true
		
	if Objective_IsComplete(obj_BreakLine) == false then
		if World_IsTerritorySectorOwnedByPlayer(player1, territory_bankRight) == false  then
			objMkr_breakLine01 = Objective_AddUIElements(obj_BreakLine, eg_bankRightTerritory, true, LOC("Capture territory"))
		end
		if World_IsTerritorySectorOwnedByPlayer(player1, territory_bankLeft) == false then
			objMkr_breakLine02 = Objective_AddUIElements(obj_BreakLine, eg_bankLeftTerritory, true, LOC("Capture territory"))
		end
	else 
		if World_IsTerritorySectorOwnedByPlayer(player1, territory_hqBase) == false then
			hp_id_1 = Objective_AddUIElements(obj_capTown, eg_hqTerritory, true, LOC("Capture territory"))
			Event_PlayerOwnsTerritory(EventHandler_RemoveObjectiveUI, {objective = obj_capTown, element = hp_id_1}, player1, territory_hqBase, 1)
		end
		if World_IsTerritorySectorOwnedByPlayer(player1, territory_vehicleBase) == false then
			hp_id_2 = Objective_AddUIElements(obj_capTown, eg_vehicleTerritory, true, LOC("Capture territory"))
			Event_PlayerOwnsTerritory(EventHandler_RemoveObjectiveUI, {objective = obj_capTown, element = hp_id_2}, player1, territory_vehicleBase, 1)
		end
	end
	
	Player_SetAbilityAvailability(player1, ABILITY.SOVIET.IL_2_RECON, ITEM_DEFAULT)
	
	Event_Remove(event_GermanStrafe)	 
	
	Event_Timer(BreakLine_KatyushaArrival, nil, 45)
end

function BreakLine_KatyushaArrival()
	if playerRadioEnabled then		
		sg_playerKatyusha = SGroup_CreateIfNotFound("sg_playerKatyusha")
		Util_StartIntel(EVENTS.ArtilleryAvailable)
		Util_CreateSquads(player1, sg_playerKatyusha, SBP.SOVIET.KATYUSHA_BM_13N_SQUAD, mkr_artySpawn, mkr_allyFallback, 1)
		
		UI_CreateMinimapBlip(mkr_allyFallback, 5, BT_General)
		Player_CompleteUpgrade(player1, UPG.SOVIET.KATYUSHA_UNLOCK)
	end
end		

function BreakLine_GermanAirStrafe(forceAttack)	
	print("BreakLine_GermanAirStrafe")
	
	local target = nil
		
	local playerUnits = SGroup_CreateIfNotFound("playerUnits")
	Player_GetAll(player1, playerUnits)	
	
	sg_strafeTarget = SGroup_CreateIfNotFound("sg_strafeTarget")
	SGroup_Clear(sg_strafeTarget)
	sg_strafeTargetSecondary = SGroup_CreateIfNotFound("sg_strafeTargetSecondary")
	SGroup_Clear(sg_strafeTargetSecondary)
	
	local _checkVisibleSquad = function(sgid, indx, sid)
		if Player_CanSeeSquad(player2, sid, ALL) then
			SGroup_Add(sg_strafeTarget, sid)
		end
	end
	
	local minTime = 170
	local maxTime = 200
	if campaignDifficulty == GD_HARD then			
		minTime = 140
		maxTime = 170
	end
		
	if Event_Exists(evt_radioTireHit) then
		print("evt_radioTireHit")
		target = eg_radioStation
		Event_Timer(CaptureTown_ShowRadioExplosion, nil, 8)
		minTime = 90
		maxTime = 120
	else
		if playerRadioEnabled and forceAttack ~= true then
			print("playerRadioEnabled")
			SGroup_ForEach(playerUnits, _checkVisibleSquad)
		else
			print("sg_strafeTarget")
			sg_strafeTarget = playerUnits
		end
		
		SGroup_Filter(sg_strafeTarget, LIST.INFANTRY, FILTER_KEEP, sg_strafeTargetSecondary)
		
		if SGroup_Count(sg_strafeTarget) > 0 then
			target = SGroup_GetRandomSpawnedSquad(sg_strafeTarget)
		elseif SGroup_Count(sg_strafeTargetSecondary) > 0 then
			target = SGroup_GetRandomSpawnedSquad(sg_strafeTargetSecondary)
		
		end
	end
		
	if target ~= nil then
		Cmd_Ability(player2, BP_GetAbilityBlueprint("stuka_strafe_m09"), Util_GetPosition(target), nil, true)
		if playerRadioEnabled == true then	
			if target ~= eg_radioStation then			
				Util_StartIntel(EVENTS.IncomingStrafe)
			end
			UI_CreateMinimapBlip(target, 32, BT_Combat)
		elseif radioDownChatterStarted == true then
			Event_Timer(EventHandler_StartIntel, {intel = EVENTS.CommsOutStuka}, 17)
		end
		
		event_GermanStrafe = Event_Timer(BreakLine_GermanAirStrafe, nil, {minTime, maxTime})
	else
		event_GermanStrafe = Event_Timer(BreakLine_GermanAirStrafe, nil, 20)
	end
	
end

function CaptureTown_ShowRadioExplosion()
	Util_StartIntel(EVENTS.IncomingStrafe)
	Event_Timer(ShowRadioExplosion, nil, 1)
end

function ShowRadioExplosion()
	local allPlayerSquads = SGroup_Create("allPlayerSquads")
	Player_GetAll(player1, allPlayerSquads)
	SGroup_SetInvulnerable(allPlayerSquads, true)
	
	local allGermanSquads = SGroup_Create("allGermanSquads")
	Player_GetAll(player2, allGermanSquads)
	SGroup_SetInvulnerable(allGermanSquads, true)

	Game_SetMode(UI_Cinematic)	
	sitrepCamStartPosition = Camera_GetCurrentTargetPos()
	Camera_MoveTo(mkr_sniperMoveto, true, 0.2)
	Event_Timer(EventHandler_StartIntel, {intel = EVENTS.CommsOut}, 4.5)
end

function _commsOutResetCamera(data)
	Game_SetMode(UI_Normal)
	Camera_MoveTo(data.endLoc, false)	
end

-------------------------------------------------------------------------
-- Objective 3: Capture Town
-------------------------------------------------------------------------
function CaptureTown_Setup()
	sg_cityDefenses = SGroup_CreateIfNotFound("sg_cityDefenses")
	sg_cityDefensesEast = SGroup_CreateIfNotFound("sg_cityDefensesEast")
	sg_cityDefensesWest = SGroup_CreateIfNotFound("sg_cityDefensesWest")
	sg_island = SGroup_CreateIfNotFound("sg_island")
	
	obj_capTown = {				
		OnStart = function()
			hp_id_1 = Objective_AddUIElements(obj_capTown, eg_hqTerritory, true, LOC("Enemy Position"))
			hp_id_2 = Objective_AddUIElements(obj_capTown, eg_vehicleTerritory, true, LOC("Enemy Position"))
			Sound_StopMusic(CAMPAIGN_MUSIC_FADEOUT, 0)
			Util_PlayMusic(musicBreakthrough, 0, 3)			
		end,	

		Parent = obj_main,
		Intel_Start = nil,
		Intel_Complete = nil,		
		Intel_Fail = nil,
		Title = 11039139, -- LOCDB [11039139] 'Clear the Germans from their HQ and Vehicle Depot'
		Description = 1459051,
		TitleEnd = 11039139,
		TitleFail = 1459052,
		Type = OT_Primary,
	}	
	Objective_Register(obj_capTown)	
end

function CaptureTown_Enemies()
	
	-- HQ encounters
	encData = {
		player = player2,
		spawn = mkr_germanHQ_01,
		sgroups = {sg_cityDefenses},
		units = {
			{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,	spawn = mkr_germanHQ_01,	numSquads = 1,	upgrades = UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM,},			
			
			{difficulty = GD_EASY,		sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,	spawn = mkr_germanHQ_01,	numSquads = 1,	upgrades = UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM},
			{difficulty = GD_NORMAL,	sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,	spawn = mkr_germanHQ_01,	numSquads = 1,	upgrades = UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM,	veterancyRank = 2,},
			{difficulty = GD_HARD,		sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,	spawn = mkr_germanHQ_01,	numSquads = 1,	upgrades = UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM,	veterancyRank = 3,},
			
			{difficulty = GD_EASY,		sbp = SBP.GERMAN.GRENADIER_SQUAD,	spawn = mkr_hqHMG02,	numSquads = 1,	upgrades = UPG.GERMAN.GRENADIER_MG42_LMG},
			{difficulty = GD_NORMAL,	sbp = SBP.GERMAN.GRENADIER_SQUAD,	spawn = mkr_hqHMG02,	numSquads = 1,	upgrades = UPG.GERMAN.GRENADIER_MG42_LMG,	veterancyRank = 1,},
			{difficulty = GD_HARD,		sbp = SBP.GERMAN.GRENADIER_SQUAD,	spawn = mkr_hqHMG02,	numSquads = 1,	upgrades = UPG.GERMAN.GRENADIER_MG42_LMG,	veterancyRank = 2,},
			
			{difficulty = {GD_EASY, GD_NORMAL},	sbp = SBP.GERMAN.SNIPER_SQUAD,	spawn = mkr_hqGrens02,	numSquads = 1,},
			{difficulty = GD_HARD,				sbp = SBP.GERMAN.SNIPER_SQUAD,	spawn = mkr_hqGrens02,	numSquads = 1,	veterancyRank = 1,},
		},
	}
	defenseGoal = {
		name = "Defend",
		target = mkr_germanHQ_01,
		range = mkr_germanHQ_01,
		leashRange = mkr_germanHQLeash_01,
		garrisonIdle = true,
		garrison = true,
		pickupWeapons = false,		
		tacticControlsList = {
			{
				tacticType = TACTIC_Hold,
				priority = 500,
				maxUsers = 6,
				maxRange = 10,
			},
		}		
	}	
	enc = Encounter:Create(encData)	
	enc:SetGoal(defenseGoal)	
	
	encData = {
		player = player2,
		spawn = mkr_germanHQ_01,
		sgroups = {sg_cityDefenses},
		units = {
			{sbp = SBP.GERMAN.GRENADIER_SQUAD,	spawn = mkr_hqGrens02,	numSquads = 1,},
			
			{difficulty = GD_EASY,		sbp = SBP.GERMAN.MORTAR_TEAM_81MM,	spawn = mkr_hqMortar02,	numSquads = 1,	},
			{difficulty = GD_NORMAL,	sbp = SBP.GERMAN.MORTAR_TEAM_81MM,	spawn = mkr_hqMortar02,	numSquads = 1,	veterancyRank = 2,},
			{difficulty = GD_HARD,		sbp = SBP.GERMAN.MORTAR_TEAM_81MM,	spawn = mkr_hqMortar02,	numSquads = 1,	veterancyRank = 3,},
			
			{difficulty = GD_EASY,		sbp = SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD,	spawn = mkr_hqHMG02,	numSquads = 1,	},
			{difficulty = GD_NORMAL,	sbp = SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD,	spawn = mkr_hqHMG02,	numSquads = 1,	veterancyRank = 1,},
			{difficulty = GD_HARD,		sbp = SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD,	spawn = mkr_hqHMG02,	numSquads = 1,	veterancyRank = 2,},
		},
	}
	defenseGoal = {
		name = "Defend",
		target = mkr_hqMortar02,
		range = 65,
		leashRange = mkr_hqMortar02,
		garrisonIdle = false,
		garrison = false,
		pickupWeapons = false,				
	}
	enc = Encounter:Create(encData)	
	enc:SetGoal(defenseGoal)		
	enc:AddSgroup(sg_hqATGun_02)
	
	encData = {
		player = player2,
		spawn = mkr_germanHQ_01,
		sgroups = {sg_cityDefenses},
		units = {
			{sbp = SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD,	spawn = mkr_hqHMG01,	numSquads = 1,},
			
			{difficulty = GD_EASY,		sbp = SBP.GERMAN.MORTAR_TEAM_81MM,	spawn = mkr_hqMortar01,	numSquads = 1,	},
			{difficulty = GD_NORMAL,	sbp = SBP.GERMAN.MORTAR_TEAM_81MM,	spawn = mkr_hqMortar01,	numSquads = 1,	veterancyRank = 1,},
			{difficulty = GD_HARD,		sbp = SBP.GERMAN.MORTAR_TEAM_81MM,	spawn = mkr_hqMortar01,	numSquads = 1,	veterancyRank = 1,},
		},
	}
	defenseGoal = {
		name = "Defend",
		target = mkr_hqMortar01,
		range = 65,
		leashRange = mkr_hqMortar01,
		garrisonIdle = false,
		garrison = false,
		pickupWeapons = false,				
	}
	enc = Encounter:Create(encData)	
	enc:SetGoal(defenseGoal)	
	enc:AddSgroup(sg_hqATGun_01)
	
	-- Vehicle depot encounters
	encData = {
		player = player2,
		spawn = mkr_vehicleLot_02,
		sgroups = {sg_cityDefenses},
		units = {			
			{difficulty = GD_EASY,		sbp = SBP.GERMAN.PIONEER_SQUAD,	numSquads = 2,	upgrades = UPG.GERMAN.PIONEER_FLAMETHROWER,	veterancyRank = 0,},
			{difficulty = GD_NORMAL,	sbp = SBP.GERMAN.PIONEER_SQUAD,	numSquads = 1,	upgrades = UPG.GERMAN.PIONEER_FLAMETHROWER,	veterancyRank = 1,},
			{difficulty = GD_HARD,		sbp = SBP.GERMAN.PIONEER_SQUAD,	numSquads = 1,	upgrades = UPG.GERMAN.PIONEER_FLAMETHROWER,	veterancyRank = 2,},			
			 
			{difficulty = GD_NORMAL,	sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,	numSquads = 1,	upgrades = UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM,	veterancyRank = 1,},
			{difficulty = GD_HARD,		sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,	numSquads = 1,	upgrades = UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM,	veterancyRank = 2,},
		},
	}
	defenseGoal = {
		name = "Defend",
		target = mkr_vehicleLotTarget,
		range = mkr_vehicleLotTarget,
		leashRange = mkr_vehicleLotTarget,
		garrisonIdle = true,
		garrison = false,
		pickupWeapons = true,		
	}	
	encVehicles = Encounter:Create(encData)	
	encVehicles:SetGoal(defenseGoal)	
	encVehicles:AddSgroup(sg_vehicleTerritoryTanksAll)
	
	sg_elephant = SGroup_CreateIfNotFound("sg_elephant")
	
	local finalTankSBP = SBP.GERMAN.ELEFANT_TANK_DESTROYER_SQUAD
	
	Util_CreateSquads(player2, sg_elephant, finalTankSBP, mkr_vehicleLot_02)
	
	if campaignDifficulty == GD_HARD then
		SGroup_IncreaseVeterancyRank(sg_elephant, 3, true)
	elseif campaignDifficulty == GD_NORMAL then	
		SGroup_IncreaseVeterancyRank(sg_elephant, 2, true)	
	end
	
	Event_IsUnderAttack(CaptureTown_MoveElephantIn, nil, sg_vehicleTerritoryTanksAll, ANY, 5)
	

end

function CaptureTown_MoveElephantIn(data)
	Cmd_Move(sg_elephant, mkr_tankMoveto_02)
	Cmd_Move(sg_elephant, data.attacker, true)
	Event_Proximity(CaptureTown_AddElephantToEncounter, nil, sg_elephant, mkr_tankMoveto_02, 5)
end
function CaptureTown_AddElephantToEncounter()
	encVehicles:AddSgroup(sg_elephant)
end
function CaptureTown_Start()
	Objective_Start(obj_capTown)
	
	World_IncreaseInteractionStage() --4(blank)
	World_IncreaseInteractionStage() --5
	CaptureTown_Enemies()
	event_BreakLineComplete = Event_PlayerOwnsTerritory(CaptureTown_Complete, nil, player1, {territory_hqBase, territory_vehicleBase})
	event_captureHQIntel = Event_PlayerOwnsTerritory(CaptureTown_HQCaptured, nil, player1, territory_hqBase)
	event_captureVehicleIntel = Event_PlayerOwnsTerritory(CaptureTown_DepotCaptured, nil, player1, territory_vehicleBase)

	Event_PlayerOwnsTerritory(EventHandler_RemoveObjectiveUI, {objective = obj_capTown, element = hp_id_1}, player1, territory_hqBase, 1)
	Event_PlayerOwnsTerritory(EventHandler_RemoveObjectiveUI, {objective = obj_capTown, element = hp_id_2}, player1, territory_vehicleBase, 1)
	
	Event_NarrativeEventsNotRunning(CaptureTown_GivePlayerBomber, nil, 30)
	Event_NarrativeEventsNotRunning(CaptureTown_StartStukaBomb, nil, 60)
	
	function _skip()
		EGroup_InstantCaptureStrategicPoint(eg_hqTerritory, player1)
		EGroup_InstantCaptureStrategicPoint(eg_vehicleTerritory, player1)
		
		SGroup_Kill(sg_cityDefenses)
	end
end
function CaptureTown_DepotCaptured(data)
	Event_Remove(event_captureVehicleIntel)
	Util_StartIntel(EVENTS.CapturedVehicle)
end

function CaptureTown_HQCaptured(data)
	Event_Remove(event_captureHQIntel)
	Util_StartIntel(EVENTS.CapturedHQ)		
end

function CaptureTown_GivePlayerBomber()
	if playerRadioEnabled then
		Util_StartIntel(EVENTS.BombersAvailable)
		Event_NarrativeEventsNotRunning(CaptureTown_GivePlayerBomber2)		
	else		
		Event_Timer(CaptureTown_GivePlayerBomber, nil, 10)
	end
end

function CaptureTown_GivePlayerBomber2()
	Player_AddAbility(player1, ABILITY.SOVIET.IL_2_BOMBING_RUN_SP)
	Player_SetAbilityAvailability(player1, ABILITY.SOVIET.IL_2_BOMBING_RUN_SP, ITEM_DEFAULT)
	bombingFlash = UI_FlashAbilityButton(ABILITY.SOVIET.IL_2_BOMBING_RUN_SP, true)
	
	Event_Timer(CaptureTown_GivePlayerBomber3, nil, 5)
end

function CaptureTown_GivePlayerBomber3()
	UI_StopFlashing(bombingFlash)
end

function CaptureTown_Complete()
	Event_Remove(event_captureHQIntel)
	Event_Remove(event_captureVehicleIntel)
	Objective_Complete(obj_capTown)
	Mission_Complete()
end

bombAbility = BP_GetAbilityBlueprint("stuka_bombing_strike_w_smoke")
function CaptureTown_StartStukaBomb()
	Player_AddAbility(player2, bombAbility)
	Player_SetAbilityAvailability(player2, bombAbility, ITEM_UNLOCKED)
	
	CaptureTown_StukaBomb()
end

function CaptureTown_StukaBomb()
	print("CaptureTown_StukaBomb")
	local sg_bombTarget = Player_GetSquads(player1)
	local forceAttack = false
	local squadsNearMarker = {}
	SGroup_Filter(sg_bombTarget, SBP.SOVIET.KATYUSHA_BM_13N_SQUAD, FILTER_KEEP)
		
	if SGroup_IsDoingAttack(sg_bombTarget, ANY, 60) == false then
		sg_bombTarget = Player_GetSquads(player1)
		
		
		local CheckNearMarker = function (groupid, itemindex, itemid)
			if Marker_InProximity(mkr_bombingZone, Squad_GetPosition(itemid)) then
				table.insert( squadsNearMarker, itemid )
			end
		end
		
		SGroup_ForEach(sg_bombTarget, CheckNearMarker)	
	else
		forceAttack = true
	end
	
	if forceAttack then
		print("++++++++++++++ BOMING KATY +++++++++++++++++")
		local target = Util_GetPosition(SGroup_GetRandomSpawnedSquad(sg_bombTarget))
		target.x = target.x + World_GetRand(-10, 10)
		target.z = target.z + World_GetRand(-10, 10)
		Cmd_Ability(player2, bombAbility, target, nil, true) 
		
		UI_CreateMinimapBlip(target, 10, BT_Combat)
		Event_Timer(CaptureTown_StukaBomb, nil, {160, 190}) 
		
	elseif table.getn(squadsNearMarker) > 0 then
		local target = Util_GetPosition(Table_GetRandomItem(squadsNearMarker))
		target.x = target.x + World_GetRand(-15, 15)
		target.z = target.z + World_GetRand(-15, 15)
		Cmd_Ability(player2, bombAbility, target, nil, true)
		
		UI_CreateMinimapBlip(target, 10, BT_Combat)
		Event_Timer(CaptureTown_StukaBomb, nil, {160, 190})
	else
		Event_Timer(CaptureTown_StukaBomb, nil, 30)
	end
end

-------------------------------------------------------------------------
--Mission End
-------------------------------------------------------------------------
function Mission_Complete()
	local allPlayer2Squads = Player_GetSquads(player2)
	if (SGroup_IsAlive(allPlayer2Squads)) then
		Util_ForceRetreatAll(allPlayer2Squads, mkr_retreat, mkr_retreat, true)	
	end
	Event_Timer(Mission_Complete2, nil, 5)
end

function Mission_Complete2()
	Event_Timer(Mission_Complete3, nil, 5)	
	Util_StartIntel(EVENTS.MissionComplete)
end

function Mission_Complete3()	

	if failedCommsAchievement ~= true then
		Scar_CompleteIntelBulletinTask(player1, "camp09_orsha_no_radio")
	end
	Mission_EndMission()
end

function Mission_Fail()	
	Util_MissionTitle(11048793, 1, 5, 1) -- LOCDB [11048793] 'Mission Failed: Headquarters Destroyed'
	Event_Timer(_delayedMissionFail, nil, 8)

end

function _delayedMissionFail()
	Mission_EndMission(false)
end

-----------------------------------
-- German "AI"
-----------------------------------
EASY = 1
MEDIUM = 2
HARD = 3
function German_SetReinforcementsDifficulty(difficultyLevel)
	reinforcementDifficulty = difficultyLevel
	if difficultyLevel == EASY then
		if campaignDifficulty == GD_HARD then
			maxReinforcements = 3
			germanMinSpawnTime = 240
			germanMaxSpawnTime = 270	
		else
			maxReinforcements = 3
			germanMinSpawnTime = 270
			germanMaxSpawnTime = 300	
		end
	elseif difficultyLevel == MEDIUM then		
		if campaignDifficulty == GD_HARD then
			maxReinforcements = 3
			germanMinSpawnTime = 210
			germanMaxSpawnTime = 240
		else
			maxReinforcements = 3
			germanMinSpawnTime = 240
			germanMaxSpawnTime = 270
		end
	else
		if campaignDifficulty == GD_HARD then
			maxReinforcements = 4
			germanMinSpawnTime = 210
			germanMaxSpawnTime = 240	
		else
			maxReinforcements = 3		
			germanMinSpawnTime = 210
			germanMaxSpawnTime = 240			
		end
	end
end

function German_SpawnerStart()
	sg_germanReinforcments = SGroup_CreateIfNotFound("sg_germanReinforcments")
	German_SetReinforcementsDifficulty(EASY)
	numInfantry = 0
	Event_Remove(evt_counterAttackTimer)
	evt_counterAttackTimer = nil
	
	event_GermanSpawner = Event_Timer(German_Spawner, nil, 10)
end

function German_Spawner()	
	
	if World_IsTerritorySectorOwnedByPlayer(player2, territory_bankLeft) and World_IsTerritorySectorOwnedByPlayer(player2, territory_bankRight) then	
		local spawnMkr = World_GetRand(1, 2)		
		local numReinforcements = 0
		
		local maxDifficultySpawned = 10
		local minDifficultySpawned = 1
		
		if campaignDifficulty == GD_EASY then
			if reinforcementDifficulty ~= HARD then 				
				maxDifficultySpawned = 8
			else
				maxDifficultySpawned = 9
			end
		else 
			if reinforcementDifficulty ~= HARD then
				maxDifficultySpawned = 9
			end
		end
		
		if spawnMkr == 1 and numInfantry < 2 or numInfantry == 0 then
			spawnMkr = mkr_reinforcement_01 -- infantry
			numReinforcements = maxReinforcements -- infantry
			numInfantry = numInfantry + 1
		else
			spawnMkr = mkr_reinforcement_02 -- vehicles
			numReinforcements = maxReinforcements - 1
			
			if campaignDifficulty == GD_HARD then	 
				numInfantry = 1
			else
				numInfantry = 0
			end
			if firstVehicleCounter == nil then
				maxDifficultySpawned = 8
				firstVehicleCounter = true
			end
		end
		
		local sovietVehicles = {
			SBP.SOVIET.M1937_53_K_45MM_AT_GUN_SQUAD,
			SBP.SOVIET.M1942_ZIS_3_76MM_AT_GUN_SQUAD,
			SBP.SOVIET.ISU_152,
			SBP.SOVIET.IS_2,
			SBP.SOVIET.KV_1,
			SBP.SOVIET.M3A1_SCOUT_CAR_SQUAD,
			SBP.SOVIET.KATYUSHA_BM_13N_SQUAD,
			SBP.SOVIET.SU_76M,
			SBP.SOVIET.SU_85,
			SBP.SOVIET.T_34_76_SQUAD,
			SBP.SOVIET.T_34_85_SQUAD,
			SBP.SOVIET.T_70M
		}
		
		local playerVehicles = Player_GetSquads(player1)
		local playerInfantryCount = SGroup_Count(playerVehicles)
		
		SGroup_Filter(playerVehicles, sovietVehicles, FILTER_KEEP)
			
		local playerVehicleHeavy = false
		
		if (playerInfantryCount - SGroup_Count(playerVehicles)) < SGroup_Count(playerVehicles) then
			playerVehicleHeavy = true
		end
		
		if playerVehicleHeavy then 
			printout = "true" 
		else 
			printout = "false"
		end
		print("::: Spawning German Reinforcements ::: "..numReinforcements.." being spawned at"..Marker_GetName(spawnMkr)..". Vehicle heavy: "..printout)
				
		local sg_counterAttack = SGroup_Create("")
		
		for i=numReinforcements,1,-1 do 
			upgrades = nil
			if i == 1 and maxDifficultySpawned > 7 and not firstVehicleCounter then
				if spawnMkr == mkr_reinforcement_02 then
					minDifficultySpawned = 8
				else
					minDifficultySpawned = maxDifficultySpawned
				end
			end
			
			local rand = World_GetRand(minDifficultySpawned, maxDifficultySpawned)
			local sbp = nil
			local spawnMarker = spawnMkr
			local entityUpgrades = nil
			if spawnMkr == mkr_reinforcement_01 then -- coming from the german HQ, primarily infantry units
				if rand <= 4 then -- base units
					sbp = SBP.GERMAN.OSTRUPPEN_SQUAD
					minDifficultySpawned = 5
				elseif rand <= 7 then -- mid-level units
					sbp = SBP.GERMAN.GRENADIER_SQUAD			
					if playerVehicleHeavy == false then
						upgrades = UPG.GERMAN.GRENADIER_MG42_LMG
					end
				elseif rand <= 9 then -- hard hitting units
					if playerVehicleHeavy then
						sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD	
						upgrades = UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM
					else
						sbp = SBP.GERMAN.SNIPER_SQUAD
					end
					print("a")
					maxDifficultySpawned = 8
				else -- units to specifically target player's strongest point
					if playerVehicleHeavy then
						sbp = SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD
					else
						sbp = SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD
					end
					maxDifficultySpawned = 8
				end		
			else -- coming from the german vehicle depot, primarily infantry units
				if rand <= 3 then -- base units
					sbp = SBP.GERMAN.OSTRUPPEN_SQUAD 	
					minDifficultySpawned = 4
				elseif rand <= 6 then -- base units
					sbp = SBP.GERMAN.PIONEER_SQUAD
					if playerVehicleHeavy == false then
						upgrades = UPG.GERMAN.PIONEER_FLAMETHROWER
					end
				elseif rand <= 8 then -- mid-level units
					sbp = SBP.GERMAN.SCOUTCAR_SDKFZ222	
					spawnMarker = mkr_reinforcement_02_vehicle2
					maxDifficultySpawned = 8
				elseif rand <= 9 then -- hard hitting units
					if playerVehicleHeavy then
						sbp = SBP.GERMAN.STUG_III_SQUAD
					else
						sbp = SBP.GERMAN.SDKFZ_251_HALFTRACK_SQUAD
						entityUpgrades = UPG.GERMAN.SDKFZ_251_HALFTRACK_FLAMMPANZERWAGEN_UPGRADE
					end
					maxDifficultySpawned = 8
					spawnMarker = mkr_reinforcement_02_vehicle1
				else -- units to specifically target player's strongest point
					if playerVehicleHeavy then
						sbp = SBP.GERMAN.ELEFANT_TANK_DESTROYER_SQUAD
					else
						sbp = SBP.GERMAN.OSTWIND_SQUAD
					end
					maxDifficultySpawned = 8
					spawnMarker = mkr_reinforcement_02_vehicle1
				end		
			end
			
			if upgrades ~= nil then
				printout = BP_GetName(upgrades)
			else 
				printout = "none"
			end
			print("spawning: "..BP_GetName(sbp).." upgrade: "..printout)
			
			Util_CreateSquads(player2, sg_counterAttack, sbp, spawnMarker, nil, nil, nil, nil, nil, upgrades)
			if entityUpgrades ~= nil then
				SGroup_CompleteEntityUpgrade(sg_counterAttack, entityUpgrades)
				entityUpgrades = nil
			end
			
		end
		
		if playerRadioEnabled == true then
			Event_Proximity(German_AttackWarning, {group = sg_counterAttack}, sg_counterAttack, {mkr_reinforcementTrigger_East, mkr_reinforcementTrigger_West})	
		else
			Event_IsDoingAttack(German_AttackedWithoutRadio, nil, sg_counterAttack, ANY, 1)
		end
		if spawnMkr == mkr_reinforcement_02 then			
			if World_GetRand(1, 2) == 1 then
				AttackRoute({sgroup = sg_counterAttack, markers = {mkr_vehicleRouteA_01, mkr_vehicleRouteA_02, mkr_vehicleRouteA_03, mkr_vehicleRouteA_04, mkr_vehicleRouteA_05}})
			else
				AttackRoute({sgroup = sg_counterAttack, markers = {mkr_vehicleRouteA_01, mkr_vehicleRouteA_02, mkr_vehicleRouteA_03, mkr_vehicleRouteB_01, mkr_vehicleRouteB_02}})
			end
		else
			if World_GetRand(1, 2) == 1 then
				AttackRoute({sgroup = sg_counterAttack, markers = {mkr_infantryRouteA_01, mkr_infantryRouteA_02, mkr_infantryRouteA_03, mkr_infantryRouteA_04}})
			else
				AttackRoute({sgroup = sg_counterAttack, markers = {mkr_infantryRouteA_01, mkr_infantryRouteA_02, mkr_infantryRouteB_01, mkr_infantryRouteB_02, mkr_infantryRouteB_03}})
			end
		end
		if firstVehicleCounter == true then
			firstVehicleCounter = false
		end
		event_GermanSpawner = Event_Timer(German_Spawner, nil, {germanMinSpawnTime, germanMaxSpawnTime})
	end
end


function German_AttackedWithoutRadio()
	if playerRadioEnabled == false and radioDownChatterStarted == true then
		Util_StartIntel(EVENTS.CommsOutCounterAtk)
	end
end

function German_AttackWarning(data)
	if playerRadioEnabled == true then
		if data._result_location == mkr_reinforcementTrigger_West then		
			UI_CreateMinimapBlip(data.group, 15, BT_General)
			Util_StartIntel(EVENTS.GermanAttackWest)
		else
			UI_CreateMinimapBlip(data.group, 15, BT_General)
			Util_StartIntel(EVENTS.GermanAttackEast)				
		end
	end
end

function AttackRoute(data)	
	print("-- AttackRoute -- START")
	local markerToUse = data.markers[1]
	table.remove(data.markers, 1)
	print("move marker: "..Marker_GetName(markerToUse))
	_AttackPlayerBase({sgroup = data.sgroup, target = markerToUse})
	if table.getn(data.markers) > 1 then
		local eventTag = Event_Proximity(AttackRoute, {sgroup = data.sgroup,markers = data.markers}, data.sgroup, markerToUse, nil, ALL)
		
		print("setting next event: "..eventTag)
	else
		Event_Proximity(_AttackPlayerBase, {sgroup = data.sgroup, target = mkr_playerBase}, data.sgroup, markerToUse, nil, ALL)
	end
	print("-- AttackRoute -- END")
end

function _AttackPlayerBase(data)
	print(":: _AttackPlayerBase :: START")
	if attackEncounterTable == nil then
		attackEncounterTable = {}
		print("created table")
	end	
	for k=table.getn(attackEncounterTable), 1, -1 do 
		if attackEncounterTable[k].sgroup == data.sgroup then
			attackEncounterTable[k].encounter:Disable()
			table.remove(attackEncounterTable, k)
			print("Removed old encounter")
		elseif SGroup_Count(data.sgroup) < 1 then			
			table.remove(attackEncounterTable, k)
			print("Removed dead encounter")
		end
	end
	enc = Encounter:ConvertSgroup(data.sgroup)
	
	print("marker: "..Marker_GetName(data.target).." SGroup Name: "..SGroup_GetName(data.sgroup).." SGroup Count: "..SGroup_TotalMembersCount(data.sgroup))
	
	local goal_germanAttack = {
		name = "Attack",
		garrison = false,
		garrisonIdle = false,
		target = data.target,
		leashRange = 10,
		useSkirmishAI = true,
		pickupWeapons = false,			
		tacticCloseGround = true,
		attackMove = true,
		movePathLengthFactor = 1.25,
			tacticControlsList = {
				{
					tacticType = TACTIC_RushAtTarget,
					priority = 100,
				},
		},
	}
	enc:SetGoal(goal_germanAttack)	
	
	table.insert(attackEncounterTable, {encounter = enc, sgroup = data.sgroup})
	print(":: _AttackPlayerBase :: END")
end

--Destroys any destroyed vehicles that could block the choke points leading into the city
function TankHuskHandler()
	_eg_husks = EGroup_CreateIfNotFound("_eg_husks")
	EGroup_Clear(_eg_husks)	
	
	if World_GetEntitiesNearMarker(player1, _eg_husks, mkr_chokepointLeft, OT_Neutral) > 0 then	
		EGroup_Filter(_eg_husks, huskEbps, FILTER_KEEP)		
		EGroup_Kill(_eg_husks)
	end	
	
	EGroup_Clear(_eg_husks)
	if World_GetEntitiesNearMarker(player1, _eg_husks, mkr_chokepointRight, OT_Neutral) > 0 then	
		EGroup_Filter(_eg_husks, huskEbps, FILTER_KEEP)		
		EGroup_Kill(_eg_husks)
	end	
end

huskEbps = {
	EBP.SOVIET.KATYUSHA_BM_13N,
	EBP.SOVIET.M5_HALFTRACK,
	EBP.SOVIET.SU_85,
	EBP.SOVIET.T_34_76,
	EBP.SOVIET.ATGUN53K_CREW,
	EBP.SOVIET.ATGUNZIS_CREW,
	EBP.SOVIET.SU_76M,
	EBP.SOVIET.M3A1_SCOUT_CAR,
	EBP.SOVIET.M1942_76MM_DIVISIONAL_GUN_ZIS_3,
	EBP.SOVIET.M1937_53_K_45MM_AT_GUN,
	EBP.GERMAN.ARMORED_CAR_SDKFZ_222,
	EBP.GERMAN.ELEFANT_SDKFZ_184,
	EBP.GERMAN.HALFTRACK_SDKFZ_251,
	EBP.GERMAN.OSTWIND_FLAK_PANZER,
	EBP.GERMAN.MG42_HMG,
	EBP.GERMAN.PAK40_75MM_AT_GUN,
	EBP.WRECKED_VEHICLES.WRECKED_T70,
	EBP.WRECKED_VEHICLES.WRECKED_ARMORED_CAR_SDKFZ_222,
	EBP.WRECKED_VEHICLES.WRECKED_HALFTRACK_SDKFZ_251,
	EBP.WRECKED_VEHICLES.WRECKED_ELEFANT_SDKFZ_184,
	EBP.WRECKED_VEHICLES.WRECKED_OSTWIND_FLAK_PANZER,
	EBP.WRECKED_VEHICLES.WRECKED_SU_76M,
	EBP.WRECKED_VEHICLES.WRECKED_ATGUN_ZIS3,
	EBP.WRECKED_VEHICLES.WRECKED_M5_HALFTRACK,
	EBP.WRECKED_VEHICLES.WRECKED_ATGUN_45MM,
	EBP.WRECKED_VEHICLES.WRECKED_SU_85,
	EBP.WRECKED_VEHICLES.WRECKED_T_34_76,
	EBP.WRECKED_VEHICLES.WRECKED_KATYUSHA_BM_13N,
	EBP.WRECKED_VEHICLES.WRECKED_STUG_III_E_SDKFZ_141_1,
	EBP.WRECKED_VEHICLES.WRECKED_STUG_III_G_SDKFZ_141_1,
}

function CheckPlayerTankAchievement()

	local _check = function(a, b, squad)
		if hasBuildT34 ~= true then
			if Squad_GetBlueprint(squad) == SBP.SOVIET.T_34_76_SQUAD then
				hasBuildT34 = true
			end
		end
		if hasBuildSU85 ~= true then
			if Squad_GetBlueprint(squad) == SBP.SOVIET.SU_85 then
				hasBuildSU85 = true
			end
		end
		if hasBuildSU76 ~= true then
			if Squad_GetBlueprint(squad) == SBP.SOVIET.SU_76M then
				hasBuildSU76 = true
			end
		end
		if hasBuildT70 ~= true then
			if Squad_GetBlueprint(squad) == SBP.SOVIET.T_70M then
				hasBuildT70 = true
			end
		end
	end
	
	local sg_allPlayerSquads = SGroup_CreateIfNotFound("sg_allPlayerSquads")
	Player_GetAll(player1, sg_allPlayerSquads)
	
	SGroup_ForEach(sg_allPlayerSquads, _check)
		
	if hasBuildSU85 == true and hasBuildT34 == true and hasBuildSU76 == true and hasBuildT70 == true then	
		Scar_CompleteIntelBulletinTask(player1, "camp09_orsha_tanks")
	else	
		Event_Timer(CheckPlayerTankAchievement, nil, 5)
	end
end

--[TO REMOVE] this function is to aid with reproducing a bug related to bombing
function Debug_OrshaBombing()
	World_IncreaseInteractionStage()
	World_IncreaseInteractionStage()
	World_IncreaseInteractionStage()
	World_IncreaseInteractionStage()
	World_IncreaseInteractionStage()
	
	FOW_PlayerRevealAll(player1)
	
	Player_SetResource(player1, RT_Munition, 2000)
	
	Player_AddAbility(player1, ABILITY.SOVIET.IL_2_BOMBING_RUN_SP)
	Player_SetAbilityAvailability(player1, ABILITY.SOVIET.IL_2_BOMBING_RUN_SP, ITEM_UNLOCKED)
end

