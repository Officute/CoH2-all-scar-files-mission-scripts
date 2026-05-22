
------------------------------------------------------------------------
-------------------------------------------------------------------------

-- BLITZKRIEG CHALLENGE
-- Designer: Philippe Boulle

-------------------------------------------------------------------------
-------------------------------------------------------------------------

import("ScarUtil.scar")
import("Systems/AiManager/ai.scar")
import("Prototype/DeploymentPoints.scar")
import("TheatreOfWar.scar")
import("Global_Values/CampaignGlobalConstants.scar")

-------------------------------------------------------------------------
-- [[ SETUP ]]
-------------------------------------------------------------------------

function OnGameSetup()
	player1 = Setup_Player(1, 11038759, "german", 1)		-- player1 is always the human player
	player2 = Setup_Player(2, 11038758, "soviet", 2)		-- player2 is always the AI opponent
end

function OnGameRestore()
	player1 = World_GetPlayerAt(1)
	player2 = World_GetPlayerAt(2)
	Game_DefaultGameRestore()
end

function NIS_Init()
	NISOpening = "ToW/Challenges/Blitzkrieg/nis/blitzkrieg_intro" --"SP/CoH2_Campaign/Act_I/M06 - Stalingrad Aftermath/intro"
	nis_load(NISOpening)
	nis_setintransitiontime(0)
	nis_setouttransitiontime(1.5)
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
	
	--[[ SET DIFFICULTY ]]
	Mission_Difficulty()
	
	--[[ MISSION PRESETS ]]
	Mission_MissionPreset()
	
	--[[ REGISTER OBJECTIVES ]]
	Initialize_Objectives()
	
	--[[ GAME START CHECK ]]
	Rule_Add(Mission_MissionStart)
	
end

Scar_AddInit(OnInit)

function Mission_Debug()
	g_debug = Misc_IsCommandLineOptionSet("debug")
end

function Mission_Restrictions()
	
	ToW_SetUpTechTreeByYear(player1, 1941)
	
	-- Pioneer construction options
	Player_SetEntityProductionAvailability(player1, EBP.GERMAN.BEREICH_FESTUNG, ITEM_REMOVED)
	Player_SetEntityProductionAvailability(player1, EBP.GERMAN.DOLCH_AKTIONEN, ITEM_REMOVED)
	Player_SetEntityProductionAvailability(player1, EBP.GERMAN.GERMAN_HQ, ITEM_REMOVED)
	Player_SetEntityProductionAvailability(player1, EBP.GERMAN.BUNKER, ITEM_REMOVED)
	Player_SetEntityProductionAvailability(player1, EBP.GERMAN.HINTERE_PANZERWERK, ITEM_REMOVED)
	Player_SetEntityProductionAvailability(player1, EBP.GERMAN.SCHWERES_KRIEGSWERK, ITEM_REMOVED)
	Player_SetEntityProductionAvailability(player1, EBP.GERMAN.FUEL_POST_GERMAN, ITEM_REMOVED)
	Player_SetEntityProductionAvailability(player1, EBP.GERMAN.MUNITION_POST_GERMAN, ITEM_REMOVED)
	Player_SetEntityProductionAvailability(player1, EBP.GERMAN.HOWITZER_105MM_LE_FH18, ITEM_REMOVED)
	Player_SetEntityProductionAvailability(player1, EBP.GERMAN.PAK43_88MM_AT_GUN, ITEM_REMOVED)
	
	-- Enable longer Soviet grenade timers
	Player_CompleteUpgrade(player2, BP_GetUpgradeBlueprint("soviet_grenades_long_timer"))
	Modify_ProjectileDelayTime (player2, BP_GetEntityBlueprint("rg_42_longtimer"), CAMPAIGN_PGREN_BUNDLED_TIMER)
	
	-- Zero out resource rates
	Modify_PlayerResourceRate( player1, RT_Manpower, 0, MUT_Multiplication )
	Modify_PlayerResourceRate( player1, RT_Munition, 0, MUT_Multiplication )
	Modify_PlayerResourceRate( player1, RT_Fuel, 	 0, MUT_Multiplication )
	
	Modify_PlayerResourceRate(player2, RT_Munition, 7.5, MUT_Multiplication)
	
end

function Mission_Difficulty()
	-- get the difficulty
	g_difficulty = Game_GetSPDifficulty()  -- set a global difficulty variable 
	_ToWDebugDisplay("********* DIFFICULTY: "..g_difficulty)
	
	t_difficulty = {
		delayShort 			= Util_DifVar({	  8,   5,   3,	 0,}),
		delayMedium 		= Util_DifVar({  12,   8,   5,   3,}),
		delayLong 			= Util_DifVar({  15,  10,   8,   5,}),
		delayExtraLong		= Util_DifVar({  60,  30,  15,   5,}),
		startingManpower 	= Util_DifVar({ 150, 100,   0,   0,}),
		startingMunition 	= Util_DifVar({ 300, 150,  60,   0,}),
		startingAction	 	= Util_DifVar({1600, 800,   0,   0,}),
		rewardManpower 		= Util_DifVar({ 200, 150, 100,  50,}),
		rewardMunition		= Util_DifVar({ 450, 300, 150,  75,}),
		rewardAction		= Util_DifVar({ 800, 400, 100,   0,}),
		retaliationLight 	= Util_DifVar({   3,   2,   1,   0,}),
		retaliationMedium 	= Util_DifVar({   9,   5,   3,   2,}),
		retaliationHeavy 	= Util_DifVar({  13,   9,   7,   5,}),
		centralArmor 		= Util_DifVar({SBP.GERMAN.PANZER_IV_COMMAND_SQUAD, SBP.GERMAN.MORTAR_250_HALFTRACK_SQUAD, SBP.GERMAN.SCOUTCAR_SDKFZ222, SBP.GERMAN.SCOUTCAR_SDKFZ222}),
		popCap				= Util_DifVar({ 175, 150, 125, 100,}),
		repairMod			= Util_DifVar({   3,   2,   1,   1,}),
	}
end

-------------------------------------------------------------------------
-- MISSION Preset 
-------------------------------------------------------------------------

function Mission_MissionPreset()
	-- variables
	g_t34_1_boarded = false -- used for tank repairs in enc07
	g_t34_2_boarded = false -- used for tank repairs in enc07
	g_playerPoints = 0
	g_vehicleAchievement = false
	g_sovietVehicleCount = 0 
	
	-- capture targets
	g_bronze = 5
	g_silver = 10
	g_gold = 14
	
	g_strikeWarning = true
	
	-- player sgroups
	sg_pioneers = SGroup_CreateIfNotFound("sg_pioneers")
	sg_panzer_grenadiers = SGroup_CreateIfNotFound("sg_panzer_grenadiers")
	sg_player_infantry = SGroup_CreateIfNotFound("sg_player_infantry")
	sg_halftrack1 = SGroup_CreateIfNotFound("sg_halftrack1")
	sg_halftrack2 = SGroup_CreateIfNotFound("sg_halftrack2")
	sg_scout_car = SGroup_CreateIfNotFound("sg_scout_car")
	sg_panzer4s = SGroup_CreateIfNotFound("sg_panzer4s")
	sg_player_vehicles = SGroup_CreateIfNotFound("sg_player_vehicles")
	sg_player_all = SGroup_CreateIfNotFound("sg_player_all")
	
	-- tables for encounters
	t_encounters = {}
	t_encounters[1] = {}
	t_encounters[2] = {}
	t_encounters[3] = {}
	t_encounters[4] = {}
	t_encounters[5] = {}
	t_encounters[6] = {}
	t_encounters[7] = {}
	t_encounters[8] = {}
	t_encounters[9] = {}
	t_encounters[10] = {}
	t_encounters[11] = {}
	t_encounters.retaliation = {}
	
	t_special_hints = {}
	
	--table for strategic points
	t_points = {}
	
	-- big table of retaliation units (position on the table is the number of capped points at which
	-- that retaliation occurs)
	t_retal = {
		--1
		{
			abilities = {
			},
			units = nil,
		},
		--2
		{
			abilities = {},
			units = {
				SBP.SOVIET.CONSCRIPT_SQUAD,
				SBP.SOVIET.CONSCRIPT_SQUAD,
			},
		},
		--3
		{
			abilities = {
				ABILITY.SOVIET.IL_2_RECON_SINGLEPASS_SP,
			},
			units = nil,
		},
		--4
		{
			abilities = {},
			units = {
				{
					sbp = SBP.SOVIET.GUARDS_TROOPS,
					slotItems = {SLOT_ITEM.DP_28_LIGHT_MACHINE_GUN_PACKAGE},
					numSquads = 3, 
					veterancyRank = 2,
				},
				SBP.SOVIET.M3A1_SCOUT_CAR_SQUAD,
			},
		},
		--5
		{
			abilities = {
				ABILITY.SOVIET.IL_2_RECON,
			},
			units = {
				SBP.SOVIET.M3A1_SCOUT_CAR_SQUAD,
			},
		},
		--6
		{
			abilities = {},
			units = {
				{
					sbp = SBP.SOVIET.T_70M,
					numSquads = 3, 
					veterancyRank = 2,
				},
			},
		},
		--7
		{
			abilities = {
				ABILITY.SOVIET.IL_2_RECON,
			},
			units = {
				{
					sbp = SBP.SOVIET.SHOCK_TROOPS,
					numSquads = 3, 
					veterancyRank = 2,
				},
			},
		},
		--8
		{
			abilities = {
				ABILITY.SOVIET.IL_2_RECON,
			},
			units = {
				{
					sbp = SBP.SOVIET.SNIPER_TEAM,
					numSquads = 2, 
					veterancyRank = 3,
				},
			},
		},
		--9
		{
			abilities = {},
			units = {
				SBP.SOVIET.T_34_76_SQUAD,
				SBP.SOVIET.T_34_76_SQUAD,
				SBP.SOVIET.T_70M,
			},
		},
		--10
		{
			abilities = {
				ABILITY.SOVIET.IL_2_RECON,
			},
			units = {
				{
					sbp = SBP.SOVIET.GUARDS_TROOPS,
					slotItems = {SLOT_ITEM.PTRS_41_ANTI_TANK_RIFLE_GUARD_TROOP, SLOT_ITEM.PTRS_41_ANTI_TANK_RIFLE_GUARD_TROOP, },
					numSquads = 2, 
					veterancyRank = 3,
				},
				SBP.SOVIET.M3A1_SCOUT_CAR_SQUAD,
			},
		},
		--11
		{
			abilities = {
				ABILITY.SOVIET.IL_2_RECON,
			},
			units = {
				{
					sbp = SBP.SOVIET.SHOCK_TROOPS,
					numSquads = 3, 
					veterancyRank = 2,
				},
			},
		},
		--12
		{
			abilities = {},
			units = {
				{
					sbp = SBP.SOVIET.T_34_76_SQUAD,
					numSquads = 3, 
					veterancyRank = 2,
				},
			},
		},
		--13
		{
			abilities = {
				ABILITY.SOVIET.IL_2_RECON,
			},
			units = {
				{
					sbp = SBP.SOVIET.SHOCK_TROOPS,
					numSquads = 3, 
					veterancyRank = 2,
				},
			},
		},
		--14
		{
			abilities = {
				ABILITY.SOVIET.IL_2_RECON,
			},
			units = {
				{
					sbp = SBP.SOVIET.SHOCK_TROOPS,
					numSquads = 3, 
					veterancyRank = 2,
				},
			},
		},
	}
	
	t_retal.spawns = {
		{
			spawn = mkr_enemy_retreat_01,
			valid = true,
		},
		{
			spawn = mkr_enemy_retreat_02,
			valid = true,
		},
		{
			spawn = mkr_enemy_retreat_03,
			valid = true,
		},
	}
	
	-- Create Player Squads
	Util_CreateSquads (player1, sg_player_vehicles, SBP.GERMAN.SCOUTCAR_SDKFZ222, mkr_player_spawn_01, mkr_dest_01, 1)
	Util_CreateSquads (player1, sg_player_vehicles, t_difficulty.centralArmor, mkr_player_spawn_02, mkr_dest_02, 1)
	Util_CreateSquads (player1, sg_player_vehicles, SBP.GERMAN.PANZER_IV_STUBBY_SQUAD, mkr_player_spawn_03, mkr_dest_03, 1)
	Util_CreateSquads (player1, sg_player_vehicles, SBP.GERMAN.PANZER_IV_STUBBY_SQUAD, mkr_player_spawn_04, mkr_dest_04, 1)
	Util_CreateSquads (player1, sg_halftrack1, SBP.GERMAN.SDKFZ_251_HALFTRACK_SQUAD, mkr_player_spawn_05, mkr_dest_05)
	Util_CreateSquads (player1, sg_halftrack2, SBP.GERMAN.SDKFZ_251_HALFTRACK_SQUAD, mkr_player_spawn_06, mkr_dest_06)
	SGroup_AddGroups (sg_player_vehicles, {sg_halftrack1, sg_halftrack2, sg_scout_car, sg_panzer4s})
	Util_CreateSquads (player1, sg_panzer_grenadiers, SBP.GERMAN.PANZER_GRENADIER_SQUAD, sg_halftrack1) --, nil, nil, nil, BP_GetUpgradeBlueprint("panzerbusche_39"))
	Util_CreateSquads (player1, sg_pioneers, SBP.GERMAN.PIONEER_SQUAD, sg_halftrack1, nil, 1, nil, nil, nil, UPG.GERMAN.PIONEER_MINESWEEPER)
	Util_CreateSquads (player1, sg_panzer_grenadiers, SBP.GERMAN.PANZER_GRENADIER_SQUAD, sg_halftrack2) --, nil, nil, nil, BP_GetUpgradeBlueprint("panzerbusche_39"))
	Util_CreateSquads (player1, sg_pioneers, SBP.GERMAN.PIONEER_SQUAD, sg_halftrack2)
	SGroup_AddGroups (sg_player_infantry, {sg_pioneers, sg_panzer_grenadiers})
	SGroup_AddGroups (sg_player_all, {sg_player_infantry, sg_player_vehicles})
	
	-- Grant commander tree upgrades
	Player_CompleteUpgrade( player1, UPG.GERMAN.RECON_PLANE )		--  2 command points
	Player_CompleteUpgrade( player1, UPG.GERMAN.PANZER_TACTICIAN )		--  2 command points
	Player_CompleteUpgrade( player1, UPG.GERMAN.FAST_MARCH )					-- 3 command points
	Player_CompleteUpgrade( player1, UPG.GERMAN.STUKA_CLOSE_AIR_SUPPORT )		-- 6 command points
	
	-- adjust popcap
	Player_SetPopCapOverride(player1, t_difficulty.popCap)
	-- phase 2 upgrade to allow for various squad upgrades and abilities
	Player_CompleteUpgrade( player1, UPG.GERMAN.BATTLE_PHASE_2 ) 
	-- set resources
	Player_SetResource (player1, RT_Manpower, t_difficulty.startingManpower )
	Player_SetResource (player1, RT_Munition, t_difficulty.startingMunition )
	Player_SetResource (player1, RT_Action, t_difficulty.startingAction )
	-- improve the player's repair rate to help with recrewing
	Modify_VehicleRepairRate (player1, t_difficulty.repairMod, BP_GetName(EBP.GERMAN.PIONEER))

	Event_PlayerCanSeeElement(SpecialHints, {group = eg_enc02_military_hospital, locid = 11047917, icon = "Icons_upgrades_icon_upgrade_german_bunker_medic", index = 1}, player1, eg_enc02_military_hospital)
	Event_PlayerCanSeeElement(SpecialHints, {group = eg_enc11_support_bay, locid = 11047918, icon = "Icons_abilities_repair", index = 2}, player1, eg_enc11_support_bay)
	
end

-------------------------------------------------------------------------
-- MISSION START & OBJECTIVES
-------------------------------------------------------------------------

function Mission_MissionStart()
	if Event_IsAnyRunning() == false then
		Rule_RemoveMe()
		-- in debug mode we display a menu with some options for how to start
		if g_debug == true then
			DEBUG_Beat_Selection_01()
		else
			-- setup enemy encounters
			SetupEncounters()
			StartIntro()
		end
	end
end

function DEBUG_Beat_Selection_01()

	UI_MessageBoxSetText(LOC("SELECT START"), LOC("Select the Mission beat to play"))
	UI_MessageBoxSetButton(DB_Button1, LOC("WITH INTRO"), LOC("Part 1"), "", true)
	UI_MessageBoxSetButton(DB_Button2, LOC("NO INTRO"), LOC("Part 2"), "", true)
	UI_MessageBoxSetButton(DB_Button3, LOC("NO MISSION"), LOC("Part 3"), "", true)
	UI_MessageBoxShow(DC_Default, DEV_SelectPhase_Menu_01)

end

function DEV_SelectPhase_Menu_01(button)
	if button == DB_Button1 then
			SetupEncounters()
			StartIntro()
	elseif button == DB_Button2 then
			SetupEncounters()
			Mission_DelayObjTitle()
	elseif button == DB_Button3 then
		_ToWDebugDisplay("No mission!", "gold")
	end
end


function StartIntro()
	Camera_SetInputEnabled(false)
	Game_Letterbox(true, 2)
	UI_SetForceShowSubtitles(true)
	FOW_RevealMarker(mkr_enc03_space, -1)
--~ 	Cmd_Upgrade(sg_panzer_grenadiers, BP_GetUpgradeBlueprint("panzerbusche_39"), 2, true)
	Util_StartIntel(EVENTS.Intro)
end

function Return2()
	FOW_UnRevealMarker(mkr_enc03_space)
--~ 	Camera_MoveTo (mkr_dest_02, true, 1.5)
	Camera_ResetToDefault()
	Camera_SetInputEnabled(true)
	Game_Letterbox(false, 2)
	Mission_DelayObjTitle()
end

function Mission_DelayObjTitle()
	Objective_Start(OBJ_Main)
	Event_Timer (StartLossCondition, nil, 5)
end

function StartLossCondition(data)
	Objective_Start(OBJ_LossCondition)
	Event_Timer (StartSilver, nil, 5)
end

function StartSilver(data)
	Objective_Start(OBJ_Silver)
end

function StartGold()
	if not Event_IsAnyRunning() then
		Rule_RemoveMe()
		Objective_Start(OBJ_Gold)
	end
end

function Initialize_Objectives()

	OBJ_Main = {
		
		SetupUI = function() 
		end,
		
		OnStart = function()
			-- setup capture point tracking
			SetupPoints()
			CompleteArea03()
		end,
		
		OnComplete = function()
			Mission_MissionComplete()
		end,
		
		OnFail = function()
		end,
		
		IsComplete = function()
			return false
		end,
		
		Intel_Start = nil,				-- Event will play when obj starts but before any UI appears
		Intel_Complete = nil,			-- Event will play when obj completes but before UI is cleared
		Intel_Fail = nil,				-- Event will play when obj fails but before UI is cleared
		Title = 11035460,				-- LOCDB [11035460] 'Capture Soviet-held points.'
		Description = 0,			-- Objective Description
		TitleEnd = 0,				-- Completed Title
		TitleFail = 0,			-- Failed Title
		Type = OT_Primary,				-- Objective Type (OT_Primary, OT_Secondary)
	}
	
	OBJ_LossCondition = {
		SetupUI = function() 
		end,
		
		OnStart = function()
			-- here we add a rule to check if you lose all your infantry
			Rule_AddInterval(LossCheck, 1)
		end,
		
		OnComplete = function()
		end,
		
		OnFail = function()
			Mission_MissionComplete()
		end,
		Title = 11043314,				-- LOCDB [11043314] 'Loss Condition: Do not lose all your infantry.'
		Description = 0,			-- Objective Description
		TitleEnd = 0,				
		TitleFail = 11043315,			-- LOCDB [11043315] 'All Infantry Lost.'
		Type = OT_Primary,				-- Objective Type (OT_Primary, OT_Secondary)
		
	}
	
	OBJ_Silver = {
		Parent = OBJ_Main,
		
		SetupUI = function() 
		end,
		
		OnStart = function()
			Objective_SetCounter(OBJ_Silver, 0, g_silver)
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
		Title = Loc_FormatText(11047608,Loc_ConvertNumber(g_silver)),				-- LOCDB [11035461] '%1LEVEL%: Capture %2NUMBER% Soviet Positions'
		Description = 0,			-- Objective Description
		TitleFail = 0,			-- Failed Title
		Type = OT_Secondary,				-- Objective Type (OT_Primary, OT_Secondary)
	}
	
	OBJ_Gold = {
		SetupUI = function() 
		end,
		
		OnStart = function()
			Objective_SetCounter(OBJ_Gold, 0, g_gold - g_silver)
		end,
		
		OnComplete = function()
			Achieve({id="tow_blitzkrieg_goldkrieg"})
			Rule_Remove(PointCheck)
			Objective_Complete(OBJ_Main, false)
		end,
		
		OnFail = function()
		end,
		
		IsComplete = function()
			return false
		end,
		
		Intel_Start = EVENTS.Bonus,				-- Event will play when obj starts but before any UI appears
		Intel_Complete = nil,			-- Event will play when obj completes but before UI is cleared
		Intel_Fail = nil,				-- Event will play when obj fails but before UI is cleared
		Title = Loc_FormatText(11035461,11047614,Loc_ConvertNumber(g_gold - g_silver)),				-- LOCDB [11035461] '%1LEVEL%: Capture %2NUMBER% Soviet Positions'
		Description = 0,			-- Objective Description
		TitleEnd = Loc_FormatText(11035467,11035470),				-- LOCDB [11035467] '%1LEVEL% Awarded.'
		TitleFail = 0,			-- Failed Title
		Type = OT_Secondary,				-- Objective Type (OT_Primary, OT_Secondary)
	}
	
	Objective_Register(OBJ_Main)
	Objective_Register(OBJ_LossCondition)
	Objective_Register(OBJ_Silver)
	Objective_Register(OBJ_Gold)

end

-------------------------------------------------------
-- MISSION END FUNCTIONS
-------------------------------------------------------

function Mission_MissionComplete()
	Game_SetMode(UI_Cinematic)
	FOW_RevealAll()
	Camera_MoveTo(eg_enc11_support_bay, true, 0.05)
	if Objective_IsComplete(OBJ_Silver) then
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

---------------------------------------
-- ENCOUNTERS 
---------------------------------------

function SetupEncounters ()
	if g_debug == true then

		SetupArea01 ()
		SetupArea02 ()
		SetupArea03 ()
		SetupArea04 ()
		SetupArea05 ()
		SetupArea06 ()
		SetupArea07 ()
		SetupArea08 ()
		SetupArea09 ()
		SetupArea10 ()
		SetupArea11 ()
	else
		SetupArea01 ()
		SetupArea02 ()
		SetupArea03 ()
		SetupArea04 ()
		SetupArea05 ()
		SetupArea06 ()
		SetupArea07 ()
		SetupArea08 ()
		SetupArea09 ()
		SetupArea10 ()
		SetupArea11 ()
    
	end
end

function SetupArea01 ()
	--- encounter area 1: infantry lines ---
	sg_enc01 = SGroup_CreateIfNotFound("sg_enc01")
	sg_enc01_hmg1 = SGroup_CreateIfNotFound("sg_enc01_hmg1")
	sg_enc01_hmg2 = SGroup_CreateIfNotFound("sg_enc01_hmg2")
	sg_enc01_mortar = SGroup_CreateIfNotFound("sg_enc01_mortar")
	sg_enc01_conscripts1 = SGroup_CreateIfNotFound("sg_enc01_conscripts1")
	sg_enc01_conscripts2 = SGroup_CreateIfNotFound("sg_enc01_conscripts2")
	sg_enc01_conscripts4 = SGroup_CreateIfNotFound("sg_enc01_conscripts4")
	sg_enc01_conscripts6 = SGroup_CreateIfNotFound("sg_enc01_conscripts6")
	
	-- 1a - hmg with crew in place
	local encData = {
		name = "Enc01 HMG 1",
		player = player2,
		sgroups = {sg_enc01_hmg1, sg_enc01},
		units = {
			{
				sbp = SBP.SOVIET.M1910_MAXIM_HEAVY_MACHINE_GUN_SQUAD,
				spawn = mkr_enc01_hmg_1,
			},
		},
		onDeath = nil,
	}
	local goalData = {
		name = "Defend",
		target = mkr_enc01_space2,
		range = mkr_enc01_space2,
		leashRange = mkr_enc01_space2,
		coordinatedSetupFacingPositions = {
			Util_GetOffsetPosition(mkr_enc01_hmg_1, OFFSET_FRONT, 100),
			},
		}

	t_encounters[1].hmg1 = Encounter:Create(encData)
	t_encounters[1].hmg1:SetGoal(goalData)
	
	-- 1b: hmg with crew out of place
	encData = {
		name = "Enc01 HMG 2",
		player = player2,
		sgroups = {SGroup_CreateIfNotFound("sg_enc01_hmg2"), sg_enc01},
		units = {
			{
				sbp = SBP.SOVIET.BASE_CONSCRIPT_SQUAD,
				spawn = mkr_enc01_conscripts_3,
			},
		},
		onDeath = nil,
	}
	t_encounters[1].hmg2 = Encounter:Create(encData)
	
	t_encounters[1].hmg2.reactData = {
		target = mkr_enc01_space2,
		range = mkr_enc01_space2,
		leashRange = 25,
		fallback = false,
		onFailure = doNothing,
		coordinatedSetupFacingPositions = {
			mkr_enc01_conscripts_5,
			},
		tacticControlsList = {
				{
				tacticType = TACTIC_CaptureTeamWeapon,
				priority = 1000,
				},
			},
		}
	local data = 
	{
		sgroup = sg_enc01_hmg2,
		delay = t_difficulty.delayMedium,
	}
	Event_PlayerCanSeeElement(ReactionCheck, data, player1, sg_enc01_hmg2, ANY )
	
	-- 1c mortar with crew out of place
	encData = {
		name = "Enc01 mortar",
		player = player2,
		sgroups = {SGroup_CreateIfNotFound("sg_enc01_mortar"), sg_enc01},
		units = {
			{
				sbp = SBP.SOVIET.BASE_CONSCRIPT_SQUAD,
				spawn = mkr_enc01_conscripts_5,
				
			},
		},
		onDeath = nil,
	}
	t_encounters[1].mortar = Encounter:Create(encData)
	t_encounters[1].mortar.reactData = {
			target = mkr_enc01_space2,
			range = mkr_enc01_space2,
			fallback = false,
			onFailure = doNothing,
			tacticControlsList = {
				{
				tacticType = TACTIC_CaptureTeamWeapon,
				priority = 1000,
				maxRange = 30,
				},
			},
		}
	
	Event_PlayerCanSeeElement(ReactionCheck, {sgroup=sg_enc01_mortar, delay=t_difficulty.delayMedium}, player1, sg_enc01_mortar, ANY)
	
	-- 1d conscripts with their pants down
	encData = {
		name = "Enc01 conscripts 6",
		player = player2,
		sgroups = {SGroup_CreateIfNotFound("sg_enc01_conscripts6"), sg_enc01},
		units = {
			{
				sbp = SBP.SOVIET.CONSCRIPT_SQUAD,
				spawn = mkr_enc01_conscripts_6,
			},
		},
		onDeath = nil,
	}
	t_encounters[1].conscripts6 = Encounter:Create(encData)
	t_encounters[1].conscripts6.reactData = {
			target = mkr_enc01_space2,
			range = mkr_enc01_space2,
			tacticControlsList = {
				{
				tacticType = TACTIC_CaptureTeamWeapon,
				priority = -1,
				},
			},
			}
	
	Event_PlayerCanSeeElement(ReactionCheck, {sgroup=sg_enc01_conscripts6, delay=t_difficulty.delayMedium,}, player1, sg_enc01_conscripts6, ANY )
	
	-- 1e conscripts with their pants down
	encData = {
		name = "Enc01 conscripts 4",
		player = player2,
		sgroups = {SGroup_CreateIfNotFound("sg_enc01_conscripts4"), sg_enc01},
		units = {
			{
				sbp = SBP.SOVIET.CONSCRIPT_SQUAD,
				spawn = mkr_enc01_conscripts_4,
			},
		},
		onDeath = nil,
	}
	t_encounters[1].conscripts4 = Encounter:Create(encData)
	t_encounters[1].conscripts4.reactData = {
		target = mkr_enc01_space2,
		range = mkr_enc01_space2,
			tacticControlsList = {
				{
				tacticType = TACTIC_CaptureTeamWeapon,
				priority = -1,
				},
			},
	}
	
	Event_PlayerCanSeeElement(ReactionCheck, {sgroup=sg_enc01_conscripts4, delay=t_difficulty.delayMedium}, player1, sg_enc01_conscripts4, ANY)
	
	-- 1f conscripts with their pants down
	encData = {
		name = "Enc01 conscripts 1",
		player = player2,
		sgroups = {SGroup_CreateIfNotFound("sg_enc01_conscripts1"), sg_enc01},
		units = {
			{
				sbp = SBP.SOVIET.CONSCRIPT_SQUAD,
				spawn = mkr_enc01_conscripts_1,
			},
		},
		onDeath = nil,
	}
	t_encounters[1].conscripts1 = Encounter:Create(encData)
	t_encounters[1].conscripts1.reactData = {
		target = mkr_enc01_space3, 
		range = mkr_enc01_space3,
			tacticControlsList = {
				{
				tacticType = TACTIC_CaptureTeamWeapon,
				priority = -1,
				},
			},
	}
	Event_PlayerCanSeeElement(ReactionCheck, {sgroup=sg_enc01_conscripts1, delay=t_difficulty.delayMedium},player1, sg_enc01_conscripts1, ANY )
	
	-- 1f conscripts who hide in buildings
	encData = {
		name = "Enc01 conscripts 2",
		player = player2,
		sgroups = {SGroup_CreateIfNotFound("sg_enc01_conscripts2"), sg_enc01},
		units = {
			{
				sbp = SBP.SOVIET.CONSCRIPT_SQUAD,
				spawn = mkr_enc01_conscripts_2,
			},
		},
		onDeath = nil,
	}
	t_encounters[1].conscripts2 = Encounter:Create(encData)
	t_encounters[1].conscripts2.reactData = {
			target = eg_enc01_conscript_dest_01,
			range = mkr_enc01_space3,
			garrison = true,
				tacticControlsList = {
				{
				tacticType = TACTIC_CaptureTeamWeapon,
				priority = -1,
				},
			},
	}	
	Event_PlayerCanSeeElement(ReactionCheck, {sgroup=sg_enc01_conscripts2, delay=t_difficulty.delayMedium}, player1, sg_enc01_conscripts2, ANY )
end

	--- ENCOUNTER AREA 2 - TRIAGE / MED STATION --
function SetupArea02 ()
	
	sg_enc02_atCrew = SGroup_CreateIfNotFound("sg_enc02_atCrew")
	sg_enc02_conscripts = SGroup_CreateIfNotFound("sg_enc02_conscripts")
	sg_enc02_partisans = SGroup_CreateIfNotFound("sg_enc02_partisans")
	
	--2a idling transport trucks
	
	t_encounters[2].trucks = Encounter:ConvertSgroup(sg_enc02_trucks)
 	t_encounters[2].trucks.reactData = {
		name = "Move",
		target = mkr_enemy_retreat_02,
		range = mkr_enemy_retreat_02,
		fallback = false,
		onSuccess = DespawnMe,
		}
	Event_PlayerCanSeeElement(ReactionCheck, {sgroup=sg_enc02_trucks, delay=t_difficulty.delayShort}, player1, sg_enc02_trucks, ANY )
	SGroup_SetAnimatorState(sg_enc02_trucks, "supplies_loaded", "partial")
	
	--2b AT gun crew
	
	local encData = {
		name = "Enc02 AT",
		player = player2,
		sgroups = {SGroup_CreateIfNotFound("sg_enc02_atCrew")},
		units = {
			{
				sbp = SBP.SOVIET.BASE_CONSCRIPT_SQUAD,
				spawn = mkr_enc02_conscripts1,
			},
		},
		onDeath = nil, 
	}
	t_encounters[2].atCrew = Encounter:Create(encData)
	t_encounters[2].atCrew.reactData = {
		target = eg_enc02_military_hospital,
		range = 40,
			onFailure = doNothing,
			tacticControlsList = {
			{
				tacticType = TACTIC_CaptureTeamWeapon,
				priority = 1000,
			},
		},
	}
	
	Event_PlayerCanSeeElement(ReactionCheck, {sgroup=sg_enc02_atCrew}, player1, sg_enc02_atCrew, ANY)
	
	--2c Conscripts who go to trenches
	encData = {
		name = "Enc02 conscripts",
		player = player2,
		sgroups = {SGroup_CreateIfNotFound("sg_enc02_conscripts")},
		units = {
			{
				sbp = SBP.SOVIET.CONSCRIPT_SQUAD,
				spawn = mkr_enc02_conscripts2,
				upgrades = {UPG.SOVIET.CONSCRIPT_DP_28_LMG_PACKAGE},
			},
			{
				sbp = SBP.SOVIET.CONSCRIPT_SQUAD,
				spawn = mkr_enc02_conscripts3,
			},
		},
		onDeath = nil,
	}
	t_encounters[2].conscripts = Encounter:Create(encData)
	t_encounters[2].conscripts.reactData = {
		target = eg_enc02_military_hospital,
		range = 25,
		tacticControlsList = {
			{
				tacticType = TACTIC_Cover,
				priority = 1000,
			},
		},
	}
	
	Event_PlayerCanSeeElement(ReactionCheck, {sgroup=sg_enc02_conscripts}, player1, sg_enc02_conscripts, ANY)
		
	
end	
	-------
	-- ENC AREA 3 - SUPPLY DEPOT / SCORCHED EARTH
	-------
function SetupArea03 ()
	
	sg_enc03_engineers = SGroup_CreateIfNotFound("sg_enc03_engineers")
	
	-- 3a supply truck #1 being "loaded"
	t_encounters[3].truck1 = Encounter:ConvertSgroup(sg_enc03_truck1)
	t_encounters[3].truck1.reactData = {
		name = "Move",
		target = mkr_enemy_retreat_02,
		fallback = false,
		onSuccess = DespawnMe,
		}

	-- 3b supply truck #2 being "loaded"
	t_encounters[3].truck2 = Encounter:ConvertSgroup(sg_enc03_truck2)
	t_encounters[3].truck2.reactData = {
		name = "Move",
		target = mkr_enemy_retreat_02,
		fallback = false,
		onSuccess = DespawnMe,
		}
		
	-- The observation post on this point is loaded to explode! This triggers a warning and then the explosion
	Event_Proximity(BoobyTrap, nil, player1, eg_enc03_depot, 10, ANY, t_difficulty.delayExtraLong) 
	Event_Proximity(BoobyTrapUI, nil, player1, eg_enc03_depot, 10, ANY, 0) 
	
	SGroup_SetAnimatorState(sg_enc03_truck1, "supplies_loaded", "majority")
	SGroup_SetAnimatorState(sg_enc03_truck2, "supplies_loaded", "full")
	
	Util_CreateSquads(player2, sg_enc03_engineers, SBP.SOVIET.COMBAT_ENGINEER_SQUAD, mkr_enc03_engineers, nil, nil, nil, nil, nil, UPG.SOVIET.ENGINEER_FLAMETHROWER)
	
	Cmd_Attack(sg_enc03_engineers, eg_enc03_scorchTarget)
end

-- ENCOUNTER 3 SUPPORT FUNCTIONS
function CompleteArea03()
	t_encounters[3].engineers = Encounter:ConvertSgroup(sg_enc03_engineers)
	t_encounters[3].engineers.reactData = {
		target = mkr_enc03_space,
		range = mkr_enc03_space,
		fallbackParams = {
			target = mkr_enemy_retreat_02,
			},
		}
	
	Event_PlayerCanSeeElement(ReactionCheck, {sgroup=sg_enc03_truck1, delay=t_difficulty.delayMedium}, player1, sg_enc03_truck1, ANY )
	Event_PlayerCanSeeElement(ReactionCheck, {sgroup=sg_enc03_truck2, delay=t_difficulty.delayLong}, player1, sg_enc03_truck2, ANY )
	Event_PlayerCanSeeElement(ReactionCheck, {sgroup=sg_enc03_engineers, delay=t_difficulty.delayLong}, player1, sg_enc03_engineers, ANY )
end

-- explosion of booby trapped munitions depot in encounter 3
function BoobyTrap (data)
	local egroup = data._result_location
		if EGroup_Count(egroup) < 1 then 
		return
	end
	
	local pos1 = Util_GetOffsetPosition(egroup, OFFSET_FRONT, 7)
	local pos2 = Util_GetOffsetPosition(egroup, OFFSET_RIGHT, 7)
	local pos3 = Util_GetOffsetPosition(egroup, OFFSET_BACK, 7)
	local pos4 = Util_GetOffsetPosition(egroup, OFFSET_LEFT, 7)
	local eg_temp = EGroup_CreateIfNotFound("eg_temp")
	
	EGroup_Kill(egroup)
	Util_CreateEntities(player2, eg_temp, EBP.SOVIET.SOVIET_MINE, pos1, 2)
	Util_CreateEntities(player2, eg_temp, EBP.SOVIET.SOVIET_MINE, pos2, 2)
	Util_CreateEntities(player2, eg_temp, EBP.SOVIET.SOVIET_MINE, pos3, 2)
	Util_CreateEntities(player2, eg_temp, EBP.SOVIET.SOVIET_MINE, pos4, 2)
	EGroup_Kill(eg_temp)
end

	---- ENCOUNTER 4 ROAD MINES AND DEFENSES

function SetupArea04 ()
	
	sg_enc04_atCrew1 = SGroup_CreateIfNotFound("sg_enc04_atCrew1")
	sg_enc04_at2 = SGroup_CreateIfNotFound("sg_enc04_at2")
	sg_enc04_tank = SGroup_CreateIfNotFound("sg_enc04_tank")
	sg_enc04_scoutCar = SGroup_CreateIfNotFound("sg_enc04_scoutCar")
	sg_enc04 = SGroup_CreateIfNotFound("sg_enc04")
	
	local num = EGroup_CountAlive(eg_enc04_minefield) - 1
	Event_GroupLeftAlive(MineWarning, nil, eg_enc04_minefield, num)
	
	Event_GroupIsDead(Achieve, {id="tow_blitzkrieg_clean_sweep"}, eg_enc04_minefield)

	-- 4a AT gun crew overlooking minefield
	local encData = {
		name = "Enc04 AT1",
		player = player2,
		sgroups = {SGroup_CreateIfNotFound("sg_enc04_atCrew1")},
		units = {
			{
				sbp = SBP.SOVIET.CONSCRIPT_SQUAD,
				spawn = mkr_enc04_conscripts1,
			},
		},
		onDeath = nil,
	}
	t_encounters[4].atCrew1 = Encounter:Create(encData)
	t_encounters[4].atCrew1.reactData = {
		target = mkr_enc04_space,
		range = mkr_enc04_space,
			onFailure = doNothing,
			tacticControlsList = {
			{
				tacticType = TACTIC_CaptureTeamWeapon,
				priority = 1000,
			},
		},
	}
	Event_PlayerCanSeeElement(ReactionCheck, {sgroup=sg_enc04_atCrew1, delay=t_difficulty.delayShort}, player1, sg_enc04_atCrew1, ANY )
	
	--4b manned AT gun covering the first position
	t_encounters[4].at2 = Encounter:ConvertSgroup(sg_enc04_at2)
	
	local goalData = {
		name = "Defend",
		target = mkr_enc04_space,
		range = mkr_enc04_space,
		leashRange = 10,
	}
	t_encounters[4].at2:SetGoal(goalData)
	
	--4c medium armor
	t_encounters[4].tank = Encounter:ConvertSgroup(sg_enc04_tank)
	Event_PlayerCanSeeElement(ReactionCheck, {sgroup=sg_enc04_tank}, player1, sg_enc04_tank, ANY)
	
	SGroup_AddGroups(sg_enc04, {sg_enc04_at2, sg_enc04_atCrew1, sg_enc04_tank})
	
	-- 4d scout car that drives into the mine field to help sell it to the player
	t_encounters[4].scoutCar = Encounter:ConvertSgroup(sg_enc04_scoutCar)
	t_encounters[4].scoutCar.reactData = {
		name = "Move",
		target = mkr_enc04_scoutCar_dest,
		range = mkr_enc04_scoutCar_dest,
		fallback = false,
		}
	
	-- trigger the reaction when the player sees the car
	-- kill the car when it hits a "mine" (a marker)
	Event_PlayerCanSeeElement(ReactionCheck, {sgroup=sg_enc04_scoutCar, delay=t_difficulty.delayShort}, player1, sg_enc04_scoutCar, ANY)
	Event_Proximity(FakeMine, {sgroup=sg_enc04_scoutCar}, sg_enc04_scoutCar, mkr_minefield, Marker_GetProximityRadius(mkr_minefield))
end

-- ENCOUNTER 4 SUPPORT FUNCTIONS
function MineField()
	local t_mines = Marker_GetSequence("mkr_enc04_mine", "")
	for k,v in pairs (t_mines) do
		Util_CreateEntities(player2, eg_enc04_minefield, EBP.GERMAN.GERMAN_MINE,v,1)
	end
end

function FakeMine (data)
	SGroup_Kill(data.sgroup)
end

	
	-- ENCOUNTER AREA 5 - Artillery batteries covering areas 1, 4 and 11
function SetupArea05 ()
	
	sg_enc05_guard1 = SGroup_CreateIfNotFound("sg_enc05_guard1")
	sg_enc05_guard2 = SGroup_CreateIfNotFound("sg_enc05_guard2")
	
	
	
	-- 5a/b/c batteries proper
	-- each battery turns on when the encounter area it is covering comes under attack
	t_encounters[5].artillery1 = Encounter:ConvertSgroup(sg_enc05_artillery1)
	local data = {
		marker = mkr_enc04_space,
		sgroup = sg_enc05_artillery1,
	}
	Event_IsUnderAttack(FireHowitzer, data, sg_enc04, ANY, 5, nil, t_difficulty.delayLong)
	Util_LogSyncWpn(sg_enc05_artillery1)
	SGroup_SetVeterancyDisplayVisibility(sg_enc05_artillery1, false) 
	
	t_encounters[5].artillery2 = Encounter:ConvertSgroup(sg_enc05_artillery2)
	Event_IsUnderAttack(FireHowitzer, {marker = mkr_enc01_space2, sgroup = sg_enc05_artillery2}, sg_enc01, ANY, 5, nil, t_difficulty.delayLong)
	Util_LogSyncWpn(sg_enc05_artillery2)
	SGroup_SetVeterancyDisplayVisibility(sg_enc05_artillery2, false) 
	
	t_encounters[5].artillery3 = Encounter:ConvertSgroup(sg_enc05_artillery3)
	Event_IsUnderAttack(FireHowitzer, {marker = mkr_enc11_space, sgroup = sg_enc05_artillery3}, sg_enc11, ANY, 5, nil, t_difficulty.delayLong)
	Util_LogSyncWpn(sg_enc05_artillery3)
	SGroup_SetVeterancyDisplayVisibility(sg_enc05_artillery3, false) 
	
	
	-- 5 d/e Guards troops who fall back to the artillery postiions to defend them
	local encData = {
		name = "Enc05 guard1",
		player = player2,
		sgroups = {SGroup_CreateIfNotFound("sg_enc05_guard1")},
		units = {
			{
				sbp = SBP.SOVIET.GUARDS_TROOPS,
				slotItems = {SLOT_ITEM.PTRS_41_ANTI_TANK_RIFLE_GUARD_TROOP, },
				spawn = mkr_enc05_guard1,
				veterancyRank = 1,
			},
		},
		onDeath = nil,
	}
	t_encounters[5].guard1 = Encounter:Create(encData)
	Event_PlayerCanSeeElement(ReactionCheck, {sgroup=sg_enc05_guard1}, player1, sg_enc05_guard1, ANY)
	
	encData = {
		name = "Enc05 guard2",
		player = player2,
		sgroups = {SGroup_CreateIfNotFound("sg_enc05_guard2")},
		units = {
			{
				sbp = SBP.SOVIET.GUARDS_TROOPS,
				slotItems = {SLOT_ITEM.PTRS_41_ANTI_TANK_RIFLE_GUARD_TROOP, },
				spawn = mkr_enc05_guard2,
				veterancyRank = 1,
			},
		},
		onDeath = nil,
	}
	t_encounters[5].guard2 = Encounter:Create(encData)
	Event_PlayerCanSeeElement(ReactionCheck, {sgroup=sg_enc05_guard2}, player1, sg_enc05_guard2, ANY)
end
	
	-- ENCOUNTER 5 SUPPORT FUNCTIONS
function FireHowitzer(data)
	_ToWDebugDisplay ("FireHowitzer for " .. SGroup_GetName(data.sgroup), "gold")
	
	if SGroup_Count(data.sgroup) < 1 then
		_ToWDebugDisplay ("FireHowitzer found empty group " .. SGroup_GetName(data.sgroup))
		return
	end
	
	if not (data.timeout) then
		data.timeout = 10
	end
	
	local sg_concentration_p1 = Player_GetSquadConcentration(player1, nil, nil, nil, nil, data.marker)
	
	if sg_concentration_p1 == nil then
		data.timeout = data.timeout - 1
		_ToWDebugDisplay ("FireHowitzer found no targets. ".. data.timeout .. " remaining tries.")
	elseif SGroup_IsRetreating(data.sgroup, ANY) == false and SGroup_HasTeamWeapon(data.sgroup, ALL) then
		if g_strikeWarning then
			Sound_Play3D ("speech/sp/theater_of_war/c04/ambient/panzer_grenadier_artillery" , Squad_EntityAt( SGroup_GetRandomSpawnedSquad(sg_concentration_p1), 0))
			g_strikeWarning = false
		else
			g_strikeWarning = true
		end
		
		-- get the position to shoot at
		data.pos = Util_GetPositionAwayFromPlayer(sg_concentration_p1, player1, 18, 5) or SGroup_GetPosition(sg_concentration_p1)
		
		-- create event cue, hintpoint and threat arrow
		EventCue_Create(CUE.ATTACKED, 11038432,  nil, data.pos) -- LOCDB [11038432] 'Artillery Incoming'
		local hint = HintPoint_Add(data.pos, true, 11038432, 3, HPAT_Hint)
		Event_Timer(RemoveHint, {id=hint}, 15)
		if not (g_artyThreat) then
			g_artyThreat = ThreatArrow_CreateGroup(data.sgroup)
		else
			ThreatArrow_Add(g_artyThreat, data.sgroup)
		end
		
		-- fire the artillery
		Command_SquadPosAbility(player2, data.sgroup, data.pos, ABILITY.SOVIET.B4_203MM_BARRAGE, true, false)
		
		-- reveal the artillery position for a bit
		FOW_RevealSGroup (data.sgroup, 30 )
	end
	
	-- if we haven't timed out, then we recreate the event to check again
	if data.timeout > 0 then
		Event_Timer(FireHowitzer, data, t_difficulty.delayExtraLong)
	end
end

	-- AREA 6 : ENTRENCHED AT GUNS
function SetupArea06 ()
	
	sg_enc06_conscripts = SGroup_CreateIfNotFound("sg_enc06_conscripts")
	sg_enc06_guards = SGroup_CreateIfNotFound("sg_enc06_guards")
	sg_enc06_hvyAT1 = SGroup_CreateIfNotFound("sg_enc06_hvyAT1")
	sg_enc06_hvyAT2 = SGroup_CreateIfNotFound("sg_enc06_hvyAT2")
	sg_enc06_partisans = SGroup_CreateIfNotFound("sg_enc06_partisans")
	
	--6a conscripts in the front edge
	local encData = {
		name = "Enc06 conscripts",
		player = player2,
		sgroups = {sg_enc06_conscripts},
		units = {
			{
				sbp = SBP.SOVIET.CONSCRIPT_SQUAD,
				spawn = mkr_enc06_conscripts1,
			},
		},
		onDeath = nil,
	}
	t_encounters[6].conscripts = Encounter:Create(encData)
	t_encounters[6].conscripts.reactData = {
		tacticControlsList = {
			{
			tacticType = TACTIC_CaptureTeamWeapon,
			priority = -1,
			},
		},
		fallbackParams = {
			thresholds = {0.6},
			markers = {mkr_enemy_retreat_03},
		},
	}	
	
	Event_PlayerCanSeeElement(ReactionCheck, {sgroup=sg_enc06_conscripts}, player1, sg_enc06_conscripts, ANY)
	
	--6b veteran guards with PTRS
	encData = {
		name = "Enc06 guards",
		player = player2,
		sgroups = {sg_enc06_guards},
		units = {
			{
				sbp = SBP.SOVIET.GUARDS_TROOPS,
				slotItems = {SLOT_ITEM.PTRS_41_ANTI_TANK_RIFLE_GUARD_TROOP, SLOT_ITEM.PTRS_41_ANTI_TANK_RIFLE_GUARD_TROOP, },
				spawn = mkr_enc06_guards,
				veterancyRank = 2,
			},
		},
		onDeath = nil,
	}
	t_encounters[6].guards = Encounter:Create(encData)
	t_encounters[6].guards.reactData = {
		tacticControlsList = {
			{
			tacticType = TACTIC_CaptureTeamWeapon,
			priority = -1,
			},
		},
		fallbackParams = {
			thresholds = {0.3},
			markers = {mkr_enemy_retreat_03},
		},
	}	
	Event_PlayerCanSeeElement(ReactionCheck, {sgroup=sg_enc06_guards}, player1, sg_enc06_guards, ANY)
	
	--6c Heavy AT crew out of position
	encData = {
		name = "Enc06 hvyAT1 crew",
		player = player2,
		sgroups = {sg_enc06_hvyAT1},
		units = {
			{
				sbp = SBP.SOVIET.GUARDS_TROOPS,
				spawn = mkr_enc06_hvyAT1_crew,
			},
		},
		onDeath = nil,
	}
	t_encounters[6].hvyAT1 = Encounter:Create(encData)
	t_encounters[6].hvyAT1.reactData = {
		target = mkr_enc06_space,
		range = mkr_enc06_space,
			onFailure = doNothing,
			tacticControlsList = {
			{
			tacticType = TACTIC_CaptureTeamWeapon,
			priority = 1000,
			},
		},
	}	
	Event_PlayerCanSeeElement(ReactionCheck, {sgroup=sg_enc06_hvyAT1, delay=t_difficulty.delayLong}, player1, sg_enc06_hvyAT1, ANY )
	
	
	--6d Heavy AT crew in position
	t_encounters[6].hvyAT2 = Encounter:ConvertSgroup(sg_enc06_hvyAT2)
	Event_PlayerCanSeeElement(ReactionCheck, {sgroup=sg_enc06_hvyAT2, delay=t_difficulty.delayShort}, player1, sg_enc06_hvyAT2, ANY )

	
	
	--6e Partisans / Civilians who retreat
	encData = {
		name = "Enc06 partisans",
		player = player2,
		sgroups = {sg_enc06_partisans},
		units = {
			{
				sbp = SBP.SOVIET.PARTISAN_SQUAD_KAR98K_RIFLE,
				spawn = mkr_enc06_partisans,
			},
		},
		onDeath = nil,
	}
	t_encounters[6].partisans = Encounter:Create(encData)
	t_encounters[6].partisans.reactData = {
		target = mkr_enc06_space,
		range = mkr_enc06_space,
		fallbackParams = {
			thresholds = {0.75},
			markers = {mkr_enemy_retreat_03},
		},
		tacticControlsList = {
			{
			tacticType = TACTIC_CaptureTeamWeapon,
			priority = -1,
			},
		},
	}
	Event_PlayerCanSeeElement(ReactionCheck, {sgroup=sg_enc06_partisans, delay=t_difficulty.delayShort}, player1, sg_enc06_partisans, ANY )
end
	
	-- AREA 7 Light/Med Armor
function SetupArea07 ()
	
	sg_enc07_engineers1 = SGroup_CreateIfNotFound("sg_enc07_engineers1")
	sg_enc07_engineers2 = SGroup_CreateIfNotFound("sg_enc07_engineers2")
	sg_enc07_engineers = SGroup_CreateIfNotFound("sg_enc07_engineers")
	
	
	-- 7a T70 tank  1
	t_encounters[7].t70_1 = Encounter:ConvertSgroup(sg_enc07_t70_1)
	t_encounters[7].t70_1.reactData = {
		target = mkr_enc07_space,
		range = mkr_enc07_space,
		leashRange = mkr_enc07_space,
		}

	
	-- 7b T70 tank  2
	t_encounters[7].t70_2 = Encounter:ConvertSgroup(sg_enc07_t70_2)
	t_encounters[7].t70_2.reactData = {
		target = mkr_enc07_space,
		range = mkr_enc07_space,
		leashRange = mkr_enc07_space,
		}
		
	Event_PlayerCanSeeElement(ReactionCheck, {sgroup=sg_enc07_t70_1, delay=t_difficulty.delayMedium}, player1, sg_enc07_t70_1, ANY)
	Event_PlayerCanSeeElement(ReactionCheck, {sgroup=sg_enc07_t70_2, delay=t_difficulty.delayMedium}, player1, sg_enc07_t70_2, ANY)
	
	--7c engineers 1 -- They are repairing a T34 and will recrew it if given enough time
	local encData = {
		name = "Enc07 engineers1",
		player = player2,
		sgroups = {sg_enc07_engineers1},
		units = {
			{
				sbp = SBP.SOVIET.COMBAT_ENGINEER_SQUAD,
				spawn = mkr_enc07_engineers1,
			},
		},
		onDeath = nil,
	}
	t_encounters[7].engineers1 = Encounter:Create(encData)
	
	--7d engineers 2 -- They are repairing another T34 and will recrew it if given enough time
	encData = {
		name = "Enc07 engineers1",
		player = player2,
		sgroups = {sg_enc07_engineers2},
		units = {
			{
				sbp = SBP.SOVIET.COMBAT_ENGINEER_SQUAD,
				spawn = mkr_enc07_engineers2,
			},
		},
		onDeath = nil,
	}
	t_encounters[7].engineers2 = Encounter:Create(encData)
	
	Rule_AddOneShot(SetupTankRepairs, 2)
	
end	

	-- ENCOUNTER 7 SUPPORT FUNCTIONS
function SetupTankRepairs()
	SGroup_SetAvgHealth(sg_enc07_t34_1, 0.25)
	SGroup_SetAvgHealth(sg_enc07_t34_2, 0.25)

	Cmd_CriticalHit(player2, sg_enc07_t34_1, CRIT.VEHICLE_LOSE_TREADS_OR_WHEELS, 1)
	Cmd_CriticalHit(player2, sg_enc07_t34_1, CRIT.VEHICLE_ABANDON, 1)
	Cmd_CriticalHit(player2, sg_enc07_t34_2, CRIT.VEHICLE_LOSE_TREADS_OR_WHEELS, 1)
	Cmd_CriticalHit(player2, sg_enc07_t34_2, CRIT.VEHICLE_ABANDON, 1)
	
	eg_enc07_tank1 = EGroup_CreateIfNotFound("eg_enc07_tank1")
	eg_enc07_tank2 = EGroup_CreateIfNotFound("eg_enc07_tank2")
	
	World_GetEntitiesNearMarker(player2, eg_enc07_tank1, mkr_enc07_engineers1, OT_Neutral)
	EGroup_Filter(eg_enc07_tank1, EBP.SOVIET.T_34_76, FILTER_KEEP)
	
	World_GetEntitiesNearMarker(player2, eg_enc07_tank2, mkr_enc07_engineers2, OT_Neutral)
	EGroup_Filter(eg_enc07_tank2, EBP.SOVIET.T_34_76, FILTER_KEEP)
	
	_ToWDebugDisplay ("SetupTankRepairs egroup populations: grp1: " .. EGroup_Count(eg_enc07_tank1) .. " grp2: " .. EGroup_Count(eg_enc07_tank2))
	
	Event_PlayerCanSeeElement(ReactionCheck, {egroup=eg_enc07_tank1, sgroup=sg_enc07_engineers1, delay=t_difficulty.delayMedium, func=ManAndRepair}, player1, sg_enc07_engineers1, ANY)
	Event_PlayerCanSeeElement(ReactionCheck, {egroup=eg_enc07_tank2, sgroup=sg_enc07_engineers2, delay=t_difficulty.delayMedium, func=ManAndRepair}, player1, sg_enc07_engineers2, ANY)
end

-- tank repairs for enc07
function ManAndRepair (data)
	if (SGroup_Count(data.sgroup) > 0) and (EGroup_Count(data.egroup) > 0) then
		Command_SquadEntity(player2, data.sgroup, SCMD_Recrew, data.egroup, true)
		Event_Timer(RepairT34, data, 2)
	else
		_ToWDebugDisplay("ManAndRepair failed:")
		_ToWDebugDisplay("Sgroup: " .. SGroup_GetName(data.sgroup) .. ": " .. SGroup_Count(data.sgroup) .. " members.")
		_ToWDebugDisplay("Egroup: " .. EGroup_GetName(data.egroup) .. ": " .. EGroup_Count(data.egroup) .. " members.")
	end	
end

function RepairT34 (data)
	if data.egroup == eg_enc07_tank1 then
		SGroup_Filter(data.sgroup, SBP.SOVIET.T_34_76_SQUAD, FILTER_REMOVE, sg_enc07_t34_1)
		if SGroup_Count(data.sgroup) > 0 then
			Cmd_Ability(data.sgroup, ABILITY.SOVIET.SOVIET_REPAIR_ABILITY, sg_enc07_t34_1)
		end
	elseif data.egroup == eg_enc07_tank2 then
		SGroup_Filter(data.sgroup, SBP.SOVIET.T_34_76_SQUAD, FILTER_REMOVE, sg_enc07_t34_2)
		if SGroup_Count(data.sgroup) > 0 then
			Cmd_Ability(data.sgroup, ABILITY.SOVIET.SOVIET_REPAIR_ABILITY, sg_enc07_t34_2)
		end
	end
end
	
	
	-- AREA 8 : ENTRENCHED HEAVY ARMOR

function SetupArea08 ()
	
	sg_enc08 = SGroup_CreateIfNotFound("sg_enc08")
	
	-- 8a t34s
	-- These tanks are disabled until the player sees them
	t_encounters[8].t34s = Encounter:ConvertSgroup(sg_enc08_t34s)
	t_encounters[8].t34s.reactData = {
		target = mkr_enc08_space,
		range = mkr_enc08_space,
		tacticTargetPreference = AITacticTargetPreference_Near,
	}
	
	Event_PlayerCanSeeElement(ReactionCheck, {sgroup=sg_enc08_t34s, delay=t_difficulty.delayMedium}, player1, sg_enc08_t34s, ANY)
	SGroup_SetAutoTargetting (sg_enc08_t34s, "hardpoint_01", false)
	Event_PlayerCanSeeElement(ReactionCheck, {sgroup=sg_enc08_t34s, delay=t_difficulty.delayShort, func = RestoreGun,}, player1, sg_enc08_t34s, ANY)
	
	
	-- 8a kv1 
	-- This tank is disabled until any unit in this encounter is actually under attack
	t_encounters[8].hvyArmor = Encounter:ConvertSgroup(sg_enc08_hvyArmor)
	
	SGroup_SetAutoTargetting (sg_enc08_hvyArmor, "hardpoint_01", false)
	
	SGroup_AddGroups(sg_enc08, {sg_enc08_t34s, sg_enc08_hvyArmor})
	
	Event_IsUnderAttack(HvyArmorReaction, nil, sg_enc08, ANY, 5, nil, t_difficulty.delayLong)
end
	
	-- ENCOUNTER 8 SUPPORT FUNCTIONS
function HvyArmorReaction()
	local goalData = {
		name = "Defend",
		target = mkr_enc08_space,
		range = mkr_enc08_space,
		useSkirmishAI = true,
		tacticTargetPreference = AITacticTargetPreference_Near,
	}
	SGroup_SetAutoTargetting (sg_enc08_hvyArmor, "hardpoint_01", true)
	t_encounters[8].hvyArmor:SetGoal(goalData)
end
	
	-- AREA 9 HEAVILY DEFENDED ROAD

function SetupArea09 ()

	local goalData = {
		name = "Defend",
		target = mkr_enc09_space,
		range = mkr_enc09_space,
		leashRange = mkr_enc09_space,
		useSkirmishAI = true,
		coordinatedSetupFacingPositions = {
			mkr_patrol_01,
			},
		}
	t_encounters[9].main = Encounter:ConvertSgroup(sg_enc09)
	t_encounters[9].main:SetGoal(goalData)
	
	--9c KV1 in reserve
	t_encounters[9].kv1 = Encounter:ConvertSgroup(sg_enc09_hvyTank)
	Event_IsUnderAttack(kv1Support, nil, sg_enc09, ANY, 5, nil, t_difficulty.delayLong)
end
	-- ENCOUNTER 9 SUPPORT FUNCTIONS
function kv1Support()
	local goalData = {
		name = "Attack",
		target = mkr_enc09_space,
		range = mkr_enc09_space,
		useSkirmishAI = true,
		tacticTargetPreference = AITacticTargetPreference_Near,
	}
	t_encounters[9].kv1:SetGoal(goalData)
end
	
	-- 	AREA 10 AMBUSH

function SetupArea10 ()
	
	sg_enc10_strike1 = SGroup_CreateIfNotFound("sg_enc10_strike1")
	sg_enc10_strike2 = SGroup_CreateIfNotFound("sg_enc10_strike2")
	sg_enc10_bait = SGroup_CreateIfNotFound("sg_enc10_bait")
	
	-- 10a strike force 1
	local encData = {
		name = "Enc10 strike1",
		player = player2,
		sgroups = {sg_enc10_strike1},
		units = {
			{
				sbp = SBP.SOVIET.SHOCK_TROOPS,
				spawn = eg_enc10_strike1House1,
			},
			{
				sbp = SBP.SOVIET.SHOCK_TROOPS,
				spawn = eg_enc10_strike1House1,
			},
			{
				sbp = SBP.SOVIET.SHOCK_TROOPS,
				spawn = eg_enc10_strike1House1,
			},
			{
				sbp = SBP.SOVIET.SHOCK_TROOPS,
				spawn = eg_enc10_strike1House2,
			},
			{
				sbp = SBP.SOVIET.SHOCK_TROOPS,
				spawn = eg_enc10_strike1House2,
			},
		},
		onDeath = nil,
	}
	local goalData = {
		name = "Defend",
		target = mkr_enc10_strike1_staging,
		range = mkr_enc10_strike1_staging,
		useSkirmishAI = true,
		leashRange = 20,
		garrison = true,
		garrisonIdle = true,
	}
	t_encounters[10].strike1 = Encounter:Create(encData)
	t_encounters[10].strike1:AddSgroup (sg_enc10_t70s)
	t_encounters[10].strike1:SetGoal(goalData)
	
	--10b strike force 2
	encData = {
		name = "Enc10 strike2",
		player = player2,
		sgroups = {sg_enc10_strike2},
		units = {
			{
				sbp = SBP.SOVIET.PENAL_BATTALION,
				spawn = eg_enc10_strike2House1,
			},
			{
				sbp = SBP.SOVIET.PENAL_BATTALION,
				spawn = eg_enc10_strike2House1,
			},
			{
				sbp = SBP.SOVIET.PENAL_BATTALION,
				spawn = eg_enc10_strike2House1,
			},
			{
				sbp = SBP.SOVIET.PENAL_BATTALION,
				spawn = eg_enc10_strike2House2,
			},
			{
				sbp = SBP.SOVIET.PENAL_BATTALION,
				spawn = eg_enc10_strike2House2,
			},
			{
				sbp = SBP.SOVIET.PENAL_BATTALION,
				spawn = eg_enc10_strike2House2,
			},
		},
		onDeath = nil,
	}
	goalData = {
		name = "Defend",
		target = mkr_enc10_strike2_staging,
		range = mkr_enc10_strike2_staging,
		useSkirmishAI = true,
		leashRange = 20,
		garrison = true,
		garrisonIdle = true,
	}
	t_encounters[10].strike2 = Encounter:Create(encData)
	t_encounters[10].strike2:AddSgroup (sg_enc10_m3a1)
	t_encounters[10].strike2:SetGoal(goalData)
	
	--10c bait
	encData = {
		name = "Enc10 bait",
		player = player2,
		sgroups = {sg_enc10_bait},
		units = {
			{
				sbp = SBP.SOVIET.CONSCRIPT_SQUAD,
				spawn = mkr_enc10_conscripts,
			},
			{
				sbp = SBP.SOVIET.CONSCRIPT_SQUAD,
				spawn = mkr_enc10_conscripts,
			},
			{
				sbp = SBP.SOVIET.COMBAT_ENGINEER_SQUAD,
				spawn = mkr_enc10_engineers,
			},
		},
		onDeath = nil,
	}
	t_encounters[10].bait = Encounter:Create(encData)
	
	Event_IsUnderAttack(Ambush, nil, sg_enc10_bait, ANY, 5, nil, t_difficulty.delayLong)
end	
	-- ENCOUNTER 10 SUPPORT FUNCTIONS
function Ambush()
	Cmd_EjectOccupants(eg_enc10_strike1House1)
	Cmd_EjectOccupants(eg_enc10_strike1House2)
	Cmd_EjectOccupants(eg_enc10_strike2House1)
	Cmd_EjectOccupants(eg_enc10_strike2House2)
	local goalData = {
		name = "Attack",
		target = mkr_enc10_space,
		range = mkr_enc10_space,
		useSkirmishAI = true,
		fallback = false,
		attackMove = true,
	}
	t_encounters[10].strike1:SetGoal(goalData)
	t_encounters[10].strike2:SetGoal(goalData)
	Cmd_Ability(player2, ABILITY.SOVIET.IL_2_PRECISION_BOMB_STRIKE, mkr_enc10_space)
end
	
		-- AREA 11 MOTOR POOL

function SetupArea11 ()
	sg_enc11 = SGroup_CreateIfNotFound("sg_enc11")
	sg_enc11_HMG = SGroup_CreateIfNotFound("sg_enc11_HMG")
	sg_enc11_LMG = SGroup_CreateIfNotFound("sg_enc11_LMG")
	
	-- guards at the motor pool
	local goalData = {
		name = "Defend",
		player = player2,
		target = mkr_enc11_space,
		range = mkr_enc11_space,
		leashRange = 15,
	}
	t_encounters[11].at = Encounter:ConvertSgroup(sg_enc11_at)
	t_encounters[11].at:SetGoal(goalData)
	
	t_encounters[11].HMG = Encounter:ConvertSgroup(sg_enc11_HMG)
	t_encounters[11].HMG:SetGoal(goalData)
	
	-- this function sets up crew and vehicles to be recrewed
	SetUpMotorPool()
end

-- ENCOUNTER 11 SUPPORT FUNCTIONS

function SetUpMotorPool()
	eg_enc11_vehicle01 = EGroup_CreateIfNotFound("eg_enc11_vehicle01")
	eg_enc11_vehicle02 = EGroup_CreateIfNotFound("eg_enc11_vehicle02")
	eg_enc11_vehicle03 = EGroup_CreateIfNotFound("eg_enc11_vehicle03")
	eg_enc11_vehicle04 = EGroup_CreateIfNotFound("eg_enc11_vehicle04")
	eg_enc11_vehicle05 = EGroup_CreateIfNotFound("eg_enc11_vehicle05")
	eg_enc11_vehicle06 = EGroup_CreateIfNotFound("eg_enc11_vehicle06")
	eg_enc11_vehicle07 = EGroup_CreateIfNotFound("eg_enc11_vehicle07")
	eg_enc11_vehicle08 = EGroup_CreateIfNotFound("eg_enc11_vehicle08")
	sg_enc11_crew1 = SGroup_CreateIfNotFound("sg_enc11_crew1")
	sg_enc11_crew2 = SGroup_CreateIfNotFound("sg_enc11_crew2")
	sg_enc11_crew3 = SGroup_CreateIfNotFound("sg_enc11_crew3")
	sg_enc11_crew4 = SGroup_CreateIfNotFound("sg_enc11_crew4")
	sg_enc11_crew5 = SGroup_CreateIfNotFound("sg_enc11_crew5")
	sg_enc11_crew6 = SGroup_CreateIfNotFound("sg_enc11_crew6")
	sg_enc11_crew7 = SGroup_CreateIfNotFound("sg_enc11_crew7")
	sg_enc11_crew8 = SGroup_CreateIfNotFound("sg_enc11_crew8")

	-- set up the vehicles to be recrewed

	SGroup_SetAvgHealth(sg_enc11_abandonedTanks, 0.75)
	Cmd_CriticalHit(player2, sg_enc11_abandonedTanks, 	CRIT.VEHICLE_ABANDON, 1)

	for i=1,8 do
		local group = EGroup_FromName("eg_enc11_vehicle0" .. i)
		local marker = Marker_FromName("mkr_enc11_vehicle0" .. i, "")
		local ebps = {EBP.SOVIET.T_70M, EBP.SOVIET.KV_1, EBP.SOVIET.T_34_76}
		World_GetEntitiesNearMarker(player2, group, marker, OT_Neutral)
		EGroup_Filter(group, ebps, FILTER_KEEP)
	end

	-- set up the crew
	Util_CreateSquads(player2, sg_enc11_crew1, SBP.SOVIET.CONSCRIPT_SQUAD, mkr_enc11_crewSpawn1, nil, 1, 2)
	Util_CreateSquads(player2, sg_enc11_crew2, SBP.SOVIET.CONSCRIPT_SQUAD, mkr_enc11_crewSpawn1, nil, 1, 2)
	Util_CreateSquads(player2, sg_enc11_crew3, SBP.SOVIET.CONSCRIPT_SQUAD, mkr_enc11_crewSpawn2, nil, 1, 2)
	
	Util_CreateSquads(player2, sg_enc11_crew4, SBP.SOVIET.CONSCRIPT_SQUAD, mkr_enc11_crewSpawn3, nil, 1, 3)
	Util_CreateSquads(player2, sg_enc11_crew5, SBP.SOVIET.CONSCRIPT_SQUAD, mkr_enc11_crewSpawn4, nil, 1, 3)
	
	Util_CreateSquads(player2, sg_enc11_crew6, SBP.SOVIET.CONSCRIPT_SQUAD, mkr_enc11_crewSpawn5, nil, 1, 3)
	Util_CreateSquads(player2, sg_enc11_crew7, SBP.SOVIET.CONSCRIPT_SQUAD, mkr_enc11_crewSpawn5, nil, 1, 3)
	Util_CreateSquads(player2, sg_enc11_crew8, SBP.SOVIET.CONSCRIPT_SQUAD, mkr_enc11_crewSpawn6, nil, 1, 3)
	
	SGroup_AddGroups( sg_enc11, {sg_enc11_crew1, sg_enc11_crew2, sg_enc11_crew3, sg_enc11_crew4, sg_enc11_crew5, sg_enc11_crew6, sg_enc11_crew7, sg_enc11_crew8})

	-- create reaction events for all the crew to run to their tanks
	Event_PlayerCanSeeElement(ReactionCheck, {index=1,sgroup=sg_enc11_crew1,delay=t_difficulty.delayMedium,func=RunForVehicles}, player1, sg_enc11_crew1, ANY)
	Event_PlayerCanSeeElement(ReactionCheck, {index=2,sgroup=sg_enc11_crew2,delay=t_difficulty.delayMedium,func=RunForVehicles}, player1, sg_enc11_crew2, ANY)
	Event_PlayerCanSeeElement(ReactionCheck, {index=3,sgroup=sg_enc11_crew3,delay=t_difficulty.delayMedium,func=RunForVehicles}, player1, sg_enc11_crew3, ANY)
	Event_PlayerCanSeeElement(ReactionCheck, {index=4,sgroup=sg_enc11_crew4,delay=t_difficulty.delayMedium,func=RunForVehicles}, player1, sg_enc11_crew4, ANY)
	Event_PlayerCanSeeElement(ReactionCheck, {index=5,sgroup=sg_enc11_crew5,delay=t_difficulty.delayMedium,func=RunForVehicles}, player1, sg_enc11_crew5, ANY)
	Event_PlayerCanSeeElement(ReactionCheck, {index=6,sgroup=sg_enc11_crew6,delay=t_difficulty.delayMedium,func=RunForVehicles}, player1, sg_enc11_crew6, ANY)
	Event_PlayerCanSeeElement(ReactionCheck, {index=7,sgroup=sg_enc11_crew7,delay=t_difficulty.delayMedium,func=RunForVehicles}, player1, sg_enc11_crew7, ANY)
	Event_PlayerCanSeeElement(ReactionCheck, {index=8,sgroup=sg_enc11_crew8,delay=t_difficulty.delayMedium,func=RunForVehicles}, player1, sg_enc11_crew8, ANY)
	
end

function RunForVehicles(data)
	local sgroup = SGroup_FromName("sg_enc11_crew" .. data.index)
	local egroup = EGroup_FromName("eg_enc11_vehicle0" .. data.index)
	if (SGroup_Count(sgroup) > 0) and (EGroup_Count(egroup) > 0) then
		Command_SquadEntity(player2, sgroup, SCMD_Recrew, egroup, false)
		Event_GroupIsDead(VehicleGoalUpdate, {index = data.index, sgroup = data.sgroup }, egroup, t_difficulty.delayShort)
	else
		_ToWDebugDisplay("RunForVehicles failed:")
		_ToWDebugDisplay("Sgroup: " .. SGroup_GetName(sgroup) .. ": " .. SGroup_Count(sgroup) .. " members.")
		_ToWDebugDisplay("Egroup: " .. EGroup_GetName(egroup) .. ": " .. EGroup_Count(egroup) .. " members.")
	end	
end


function VehicleGoalUpdate(data)
	local name = "enc11_vehicle0" .. data.index
	if (SGroup_Count(data.sgroup) > 0)  then
		t_encounters[11][name] = Encounter:ConvertSgroup(data.sgroup)
		local goalData = {
			name = "Defend",
			target = mkr_enc11_space,
			range = mkr_enc11_space,
			useSkirmishAI = true,	
		}
		t_encounters[11][name]:SetGoal(goalData)
	end
end

--------------------------------------------------------
-- MISSION FUNCTIONS
--------------------------------------------------------

-- this function checks to see if the player still has any infantry (squads that can cap points)
-- it is also used to check for an achievement for recrewing 10 Soviet vehicles
function LossCheck()

	sg_soviet_vehicles 		= SGroup_CreateIfNotFound("sg_soviet_vehicles")
	sg_soviet_vehicles_temp = SGroup_CreateIfNotFound("sg_soviet_vehicles_temp")

	local germanVehicles = {
		SBP.GERMAN.PANZERWERFER_SQUAD,
		SBP.GERMAN.MORTAR_250_HALFTRACK_SQUAD,
		SBP.GERMAN.PANZER_IV_STUBBY_SQUAD,
		SBP.GERMAN.PANZER_IV_COMMAND_SQUAD,
		SBP.GERMAN.SCOUTCAR_SDKFZ222,
		SBP.GERMAN.SDKFZ_251_HALFTRACK_SQUAD,
		SBP.GERMAN.TIGER_SQUAD,
		SBP.GERMAN.STUKA_AIR_CAP_SQUAD,
		SBP.GERMAN.STUKA_GROUND_ANTI_TANK_SQUAD,
		SBP.GERMAN.STUKA_GROUND_ATTACK_SQUAD,
		SBP.GERMAN.STUKA_GROUND_FRAGMENTATION_SQUAD,
		SBP.GERMAN.STUKA_SMOKE_SQUAD,
		}
	
	local sovietVehicles = {
		SBP.SOVIET.KV_1,
		SBP.SOVIET.M3A1_SCOUT_CAR_SQUAD,
		SBP.SOVIET.T_34_76_SQUAD,
		SBP.SOVIET.T_70M,
		}

	Player_GetAll(player1)
	SGroup_Clear(sg_soviet_vehicles_temp)
	SGroup_Filter(sg_allsquads, sovietVehicles, FILTER_REMOVE, sg_soviet_vehicles_temp)
	SGroup_Filter(sg_allsquads, germanVehicles, FILTER_REMOVE)
	
	if SGroup_Count(sg_allsquads) < 1 then
		Objective_Fail(OBJ_LossCondition)
		Rule_RemoveMe()
	elseif not g_vehicleAchievement then
		SGroup_ForEach(sg_soviet_vehicles_temp, CountSovietVehicles)
		if g_sovietVehicleCount >= 10 then
			Achieve({id="tow_blitzkrieg_armored_and_dangerous"})
			g_vehicleAchievement = true
		end
	end
end

function CountSovietVehicles(sgroup, index, squad)	
	if not SGroup_ContainsSquad(sg_soviet_vehicles, Squad_GetGameID(squad)) then
		g_sovietVehicleCount = g_sovietVehicleCount + 1
		SGroup_Add(sg_soviet_vehicles, squad)
	end
end


-- create a table of points and associated data we use to track ownership
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

-- This check detects when a player captures a point he hasn't previously owned
-- It then gives resources and triggers a reaction from the enemy
function PointCheck()
	for k, point in pairs (t_points) do
		if point.owner ~= player1 then
			local currentOwner = -1
			if not World_OwnsEntity(point.id) then
				currentOwner = Entity_GetPlayerOwner(point.id)
			end
			if currentOwner == player1 then
				CaptureGrant(point.id)
				Event_Timer(Retaliation, {target=point.id}, t_difficulty.delayShort)
				point.owner = player1
			end
		end
	end
end

function CaptureGrant(entity)
	-- increment our counter
	g_playerPoints = g_playerPoints + 1
	
	-- award resources
	Player_AddResource(player1, RT_Manpower, t_difficulty.rewardManpower)
	Player_AddResource(player1, RT_Munition, t_difficulty.rewardMunition)
	Player_AddResource(player1, RT_Action,   t_difficulty.rewardAction)
	
	-- trigger a kicker to tell the player about the resources
	UI_CreateEntityKickerMessage (player1, entity, Loc_FormatText(11043316, Loc_ConvertNumber(t_difficulty.rewardManpower), Loc_ConvertNumber(t_difficulty.rewardMunition))) -- LOCDB [11043316] '+%1MANPOWER% Manpower +%2MUNITIONS% Munitions'
	
	-- disable the point to prevent recapture
	local disableCapture = Modifier_Create(MAT_Entity, "modifiers\\enable_capture_entity_modifier.lua", MUT_Enable, false, -1, "")
	Modifier_ApplyToEntity(disableCapture, entity)
	
	-- turn off hintpoints or disable nearby enemy counter attack spawn points
	if EGroup_ContainsEntity(eg_enc02_military_hospital, entity) then
		HintPoint_Remove(t_special_hints[1])
	elseif EGroup_ContainsEntity(eg_enc11_support_bay, entity) then
		HintPoint_Remove(t_special_hints[2])
	elseif EGroup_ContainsEntity(eg_point_swamp_1, entity) then
		t_retal.spawns[2].valid = false
	elseif EGroup_ContainsEntity(eg_point_swamp_2, entity) then
		t_retal.spawns[2].valid = false
	elseif EGroup_ContainsEntity(eg_point_arty, entity) then
		t_retal.spawns[1].valid = false
	elseif EGroup_ContainsEntity(eg_point_near_arty, entity) then
		t_retal.spawns[1].valid = false
	end
	
	-- now check to see if we've hit a threshold for bronze/silver/gold and update the objectives and counters
	if Objective_IsStarted(OBJ_Gold) then
		Objective_SetCounter(OBJ_Gold, g_playerPoints - g_silver, g_gold - g_silver)
		if g_playerPoints >= g_gold then
			Objective_Complete(OBJ_Gold)
		end
	elseif Objective_IsStarted (OBJ_Silver) then
		Objective_SetCounter (OBJ_Silver, g_playerPoints, g_silver)
		if g_playerPoints >= g_silver then
			Objective_Complete(OBJ_Silver)
		end
	end
end

-- This function triggers when an sgroup is seen but effectively disregards being seen by a recon plane
-- This is used by almost every encounter on the map
function ReactionCheck (data)
	local player = data._player
	local sgroup = data.sgroup
	local delay = data.delay or t_difficulty.delayMedium
	local func = data.func or ReactWhenSeen -- ReactWhenSeen is the default reaction function
	_ToWDebugDisplay("ReactionCheck triggered for " .. SGroup_GetName(sgroup), "white")
	
	-- first we check to see if the seeing player has a recon plane alive 
	-- (in which case that is likely what spotted the encounter)
	sg_temp = SGroup_CreateIfNotFound("sg_temp")
	SGroup_Clear(sg_temp)
	Player_GetAll(player)
	SGroup_AddGroup(sg_temp, sg_allsquads)
	SGroup_Filter(sg_temp, SBP.GERMAN.STUKA_AIR_CAP_SQUAD, FILTER_KEEP)
	
	if SGroup_CountSpawned(sg_temp) > 0 then
	-- if the recon plane is the spotter, we restore the event on a timer
		Event_Timer(RestoreReaction, data, 2)
	else
		Event_Timer(func, data, delay)
	end
	
	SGroup_Clear(sg_temp)
end

-- This just resets the reaction check
function RestoreReaction (data)
	Event_PlayerCanSeeElement (ReactionCheck, data, data._player, data.sgroup, ANY)
end


-- helper function for having groups react (gain a goal) only when spotted and only after a delay 
-- delay is set in the data.delay when the function is set up

function ReactWhenSeen(data)
	local player = data._player
	local sgroup = data.sgroup
	_ToWDebugDisplay("ReactWhenSeen triggered for " .. SGroup_GetName(sgroup), "gold")
	
	local groupName = SGroup_GetName(sgroup)
	local encArea = string.sub(groupName,4,8)
	local index = tonumber(string.sub(encArea,5,5))
	local encName = string.sub(groupName,10,-1)
	local enc = t_encounters[index][encName]

	local mkr_name = "mkr_" .. encArea .. "_space"
	
	local reaction = Clone(enc.reactData) or {}
	reaction.name = reaction.name or "Defend"
	reaction.target = (Util_HasPosition(reaction.target) and reaction.target) or 
						(Marker_Exists(mkr_name, "") and Marker_FromName(mkr_name, ""))
						
	reaction.range = reaction.range or Marker_FromName("mkr_" .. encArea .. "_space", "")
	reaction.fallback = reaction.fallback or true
	if (reaction.fallback) then
		reaction.fallbackParams = reaction.fallbackParams or {}
		reaction.fallbackParams.thresholds = reaction.fallbackParams.thresholds or {0.25}
		reaction.fallbackParams.thresholdType = reaction.fallbackParams.thresholdType or Threshold_PercentageEntitiesRemaining
		reaction.fallbackParams.markers = reaction.fallbackParams.markers or {mkr_enemy_retreat_01}
		reaction.fallbackParams.retreat = reaction.fallbackParams.retreat or true
		reaction.onFailure = reaction.onFailure or DespawnMe
	end
	Cmd_Stop(sgroup)

	if not Util_HasPosition(reaction.target) and Util_HasPosition(sgroup) then
		reaction.target = Util_GetPosition(sgroup)
	end

	if Util_HasPosition(reaction.target) then
		enc:SetGoal(reaction)
	end
end

-- Reaction to restore a disabled gun (to simulate a tank "turning on")
function RestoreGun (data)
	SGroup_SetAutoTargetting (data.sgroup, "hardpoint_01", true)	
end

-------------------------------
--- RETALIATION MECHANICS
-------------------------------

function Retaliation (data)
	local retal = t_retal[g_playerPoints]
	if not (retal) then
		return
	end
	
	if (retal.abilities) then
		for k,ability in pairs (retal.abilities) do
			if not Player_HasAbility(player2, ability) then
				Player_AddAbility(player2, ability)
			end
			local point = data.target
			local pos = Util_GetPositionAwayFromPlayer(point, player1, 25, 10)
			Cmd_Ability(player2, ability, pos, nil, true)
	    end
	end
	
	if (retal.units) then
		data.units = retal.units
		data.spawnMarker = GetEnemySpawnMarker()
		data.range = 30
		RetaliatoryAttack(data)
	end
end

function GetEnemySpawnMarker()
	local marker = nil
	while marker == nil do
		local index = World_GetRand(1,3)
		if t_retal.spawns[index].valid == true then
			marker = t_retal.spawns[index].spawn
		end
	end
	return marker
end

function AddEscalationUnits(t_units, marker, encData)
	for k,unit in pairs (t_units) do
		local unitTable = {}
		if scartype(unit) == ST_PBG then
			unitTable = {
				sbp = unit,
				spawn = marker,
			}
		elseif scartype(unit) == ST_TABLE then
			unitTable = unit
			unitTable.spawn = unit.spawn or marker
		end
		
		table.insert (encData.units, unitTable)
	end
	
	return encData
end

function RetaliatoryAttack(data)
	local encData = {
		sgroups = {},
		units = {},
		onDeath = nil,
	}
	
	encData = AddEscalationUnits(data.units, data.spawnMarker, encData)
	t_retal[g_playerPoints].enc = Encounter:Create(encData)
	
	local goalData = {
		name = "Attack",
		target = data.target,
		range = data.range,
		attackMove = true,
		onSuccess = WaitThenMoveOn,
	}
	
	if EGroup_ContainsEntity(eg_enc02_military_hospital, data.target) or EGroup_ContainsEntity(eg_enc11_support_bay, data.target) then
		if SGroup_Count(sg_player_all) > 1 then
			goalData.target = sg_player_all
		end
	end
	
	t_retal[g_playerPoints].enc:SetGoal(goalData)
	
	_ToWDebugDisplay ("RetaliatoryAttack from spawn point " .. Marker_GetName(data.spawnMarker), "cyan")
end

function WaitThenMoveOn (enc)
	Event_Timer (WithdrawOrSearch, enc, t_difficulty.delayExtraLong)
end


function WithdrawOrSearch(enc)
	local goalData = {
		name = "Move",
		target = mkr_enemy_retreat_03,
		attackMove = true,
		onSuccess = DespawnMe,
	}
	
	if(SGroup_Count(sg_player_all) > 1 and g_difficulty ~= GD_EASY) then
		goalData = {
			name = "Attack",
			target = sg_player_all,
			attackMove = true,
		}
	end
	
	enc:SetGoal(goalData)
end


----------------------------------------------
-- UI and HintPoint Functions
----------------------------------------------

function SpecialHints (data)
	t_special_hints[data.index] = HintPoint_Add (data.group, true, data.locid, 3, HPAT_Hint, data.icon)
end

function RemoveHint (data)
	HintPoint_Remove(data.id)
end

function BoobyTrapUI (data)

	t_encounters[3].trapTime = t_difficulty.delayExtraLong
	t_encounters[3].trapGroup = data._result_location
	
	local message = Loc_FormatText(11035471, Loc_ConvertNumber(t_difficulty.delayExtraLong)) -- LOCDB [11035471] 'Trap! Detonates in %1TIME% seconds.'
	
	t_encounters[3].trapTimer = HintPoint_Add ( t_encounters[3].trapGroup, true, message, 3, HPAT_Critical, "Icons_abilities_ability_soviet_demo_charge")
	
	Rule_AddIntervalEx(CounterDecrement, 1, t_difficulty.delayExtraLong)
	
	Util_StartIntel(EVENTS.Trap)
	
end

function CounterDecrement()

	local timer = t_encounters[3].trapTime
	timer = timer - 1
	local message = Loc_FormatText(11035471, Loc_ConvertNumber(timer)) -- LOCDB [11035471] 'Trap! Detonates in %1TIME% seconds.'
	
	if timer < 1 then
		Rule_RemoveMe()
		HintPoint_Remove(t_encounters[3].trapTimer)
	else
		HintPoint_Remove(t_encounters[3].trapTimer)
		t_encounters[3].trapTimer = HintPoint_Add ( t_encounters[3].trapGroup, true, message, 3, HPAT_Critical, "Icons_abilities_ability_soviet_demo_charge")
		t_encounters[3].trapTime = timer
	end
end

function MineWarning (data)
	local data = {}
	data.id = HintPoint_Add(mkr_minefield, true, 11046247, 2, HPAT_Critical, "Icons_buildings_building_mines" ) -- LOCDB [11046247] 'Minefield'
	EventCue_Create(CUE.ATTACKED, 11046247,  nil, mkr_minefield) 
	Event_GroupIsDead (RemoveHint, data, eg_enc04_minefield)
	Util_StartIntel(EVENTS.Minefield)
end

------------------------------------------------
-- MISC UTILITIES
------------------------------------------------

function DespawnMe(enc)
	_ToWDebugDisplay("DespawnMe!", "gold")
	SGroup_DestroyAllSquads(enc.sgroup)
	
end

function doNothing(enc)
end

function Achieve(data)
	_ToWDebugDisplay("ACHIEVEMENT: " .. data.id, "gold")
	Scar_CompleteIntelBulletinTask(player1, data.id)
end
