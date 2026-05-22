-------------------------------------------------------------------------
-------------------------------------------------------------------------

-- ENCIRCLEMENT AT SMOLENSK
-- Smolensk, USSR; July, 1941
-- Designer: Neil Jones-Rodway & Philippe Boulle

-------------------------------------------------------------------------
-------------------------------------------------------------------------

import("ScarUtil.scar")
import("Systems/AiManager/ai.scar")
import("TheatreOfWar.scar")

-------------------------------------------------------------------------
-- [[ SETUP ]]
-------------------------------------------------------------------------

function OnGameSetup()
	player1 = World_GetPlayerAt(1)
	player2 = World_GetPlayerAt(2)
	player3 = Setup_Player(3, 11035397, "soviet", 2) -- LOCDB [11035397] 'Soviet 20th Army'
	player4 = Setup_Player(4, 11035398, "soviet", 2) -- LOCDB [11035398] 'Soviet 16th Army'
end

function OnGameRestore()
	player1 = World_GetPlayerAt(1)
	player2 = World_GetPlayerAt(2)
	player3 = World_GetPlayerAt(3)
	player4 = World_GetPlayerAt(4)
	Game_DefaultGameRestore()
end

-------------------------------------------------------------------------
-- [[ ONINIT ]]
-------------------------------------------------------------------------

function OnInit()

	--[[ PRESET DEBUG CONDITIONS ]]
	Mission_Debug()
	
	print("1: ".. Player_GetRaceName(player1) .. " ... Human:".. tostring(Player_IsHuman(player1)).. "  AIPlayer:".. tostring(AI_IsAIPlayer(player1)).."/Enabled:".. tostring(AI_IsEnabled(player1)))
	print("2: ".. Player_GetRaceName(player2) .. " ... Human:".. tostring(Player_IsHuman(player2)).. "  AIPlayer:".. tostring(AI_IsAIPlayer(player2)).."/Enabled:".. tostring(AI_IsEnabled(player2)))
	print("3: ".. Player_GetRaceName(player3) .. " ... Human:".. tostring(Player_IsHuman(player3)).. "  AIPlayer:".. tostring(AI_IsAIPlayer(player3)).."/Enabled:".. tostring(AI_IsEnabled(player3)))
	print("4: ".. Player_GetRaceName(player4) .. " ... Human:".. tostring(Player_IsHuman(player4)).. "  AIPlayer:".. tostring(AI_IsAIPlayer(player4)).."/Enabled:".. tostring(AI_IsEnabled(player4)))
	
	--
	--[[ MISSION PRESETS ]]
	Mission_MissionPreset()

	--[[ SET RESTRICTIONS ]]
	Mission_Restrictions()

	--[[ SET DIFFICULTY ]]
	Mission_Difficulty()

	-- camera
	Camera_SetDefault(nil, nil, 180)
	Camera_ResetToDefault()

	--[[ REGISTER OBJECTIVES ]]
	Part1_InitializeObjective()
	Part2_InitializeObjective()
	Part3_InitializeObjective()
	
	SetupHints()
	SetupAchievements()
	
	if g_debug then
		DEBUG_Beat_Selection_01()
	else
		Part1_Start()
	end
end

Scar_AddInit(OnInit)

function Mission_Debug()
	g_debug = Misc_IsCommandLineOptionSet("debug")
end

function DEBUG_Beat_Selection_01()
	UI_MessageBoxSetText(LOC("Select Beat"), LOC("Select the Mission beat to play"))
	UI_MessageBoxSetButton(DB_Button1, LOC("Part 1"), LOC("Part 1"), "", true)
	UI_MessageBoxSetButton(DB_Button2, LOC("Part 2"), LOC("Part 2"), "", true)
	UI_MessageBoxSetButton(DB_Button3, LOC("Part 3"), LOC("Part 3"), "", true)
	UI_MessageBoxShow(DC_Default, DEV_SelectPhase_Menu_01)
end

function DEV_SelectPhase_Menu_01(button)
	local function EntityCap (egroup, index, entity)
		Entity_InstantCaptureStrategicPoint(entity, player1)
		local disableCapture = Modifier_Create(MAT_Entity, "modifiers\\enable_capture_entity_modifier.lua", MUT_Enable, false, -1, "")
		Modifier_ApplyToEntity(disableCapture, entity)
	end

	if button == DB_Button1 then
		_ToWDebugDisplay("Part 1", "gold")
		Part1_Start()
	elseif button == DB_Button2 then
		_ToWDebugDisplay("Part 2", "gold")
		SetupHowitzersVPs()
		SetupLaterVPs()
		SetupVP3()
		SetupHints()
		EGroup_ForEach(eg_part1_points, EntityCap)
		Part2_Start()
	elseif button == DB_Button3 then
		_ToWDebugDisplay("Part 3", "gold")
		t_difficulty.part3Countdown = 20
		SGroup_Kill(sg_player1_starting)
		SGroup_Kill(sg_tankguns_p1)
		SGroup_Kill(sg_player2_starting)
		SGroup_Kill(sg_tankguns_p2)
		SGroup_Kill(sg_watchtower_t70_1)
		SGroup_Kill(sg_watchtower_t70_2)
		SGroup_Kill(sg_overlook_howitzer1)
		SGroup_Kill(sg_overlook_howitzer2)
		SGroup_Kill(sg_overlook_hvyAT1)
		EGroup_ForEach(eg_part1_points, EntityCap)
		EGroup_ForEach(eg_vp2a, EntityCap)
		EGroup_ForEach(eg_vp2b, EntityCap)
		SetupVP3()
		EGroup_DestroyAllEntities(eg_vp2_motorpool)
		EGroup_DestroyAllEntities(eg_vp2a_barracks)
		EGroup_DestroyAllEntities(eg_vp2a_weapon_support_center)
		EGroup_DestroyAllEntities(eg_vp2b_tank_depot)
		Part3_Start()
	end
end

function Mission_MissionPreset()
	g_achievementComplete = false
	t_encounters = {}

	sg_temp = SGroup_CreateIfNotFound("sg_temp")
	eg_temp = EGroup_CreateIfNotFound("eg_temp")
	sg_blah = SGroup_CreateIfNotFound("sg_blah")
	eg_blah = EGroup_CreateIfNotFound("eg_blah")
	sg_part4_retreaters = SGroup_CreateIfNotFound("sg_part4_retreaters")
	
	-- Lock out AI control of pre-placed units for P3 and P4
	if AI_IsEnabled(player3) then
		AI_LockSquads(player3, sg_overlook_hvyAT1)
		AI_LockSquads(player3, sg_watchtower_t70_1)
		AI_LockSquads(player3, sg_watchtower_t70_2)
	end
	
	-- Remove the map entry point in the center of the map (that's only there to get the map past the validation in the editor)
	EGroup_DestroyAllEntities(eg_delete_me_on_start)
	
	-- Set up importance of territory flags
	if AI_IsEnabled(player2) then
		AI_SetCaptureImportanceBonus(player2, EGroup_GetSpawnedEntityAt(eg_vp1, 1), 10)
		AI_SetCaptureImportanceBonus(player2, EGroup_GetSpawnedEntityAt(eg_vp1a, 1), 10)
		AI_SetCaptureImportanceBonus(player2, EGroup_GetSpawnedEntityAt(eg_vp2a, 1), -100)
		AI_SetCaptureImportanceBonus(player2, EGroup_GetSpawnedEntityAt(eg_vp2b, 1), -100)
		AI_SetCaptureImportanceBonus(player2, EGroup_GetSpawnedEntityAt(eg_phase2_point2c, 1), -100)
		AI_SetCaptureImportanceBonus(player2, EGroup_GetSpawnedEntityAt(eg_phase3_point1a, 1), -100)
		AI_SetCaptureImportanceBonus(player2, EGroup_GetSpawnedEntityAt(eg_phase3_point1b, 1), -100)
		AI_SetCaptureImportanceBonus(player2, EGroup_GetSpawnedEntityAt(eg_phase3_point2a, 1), -100)
		AI_SetCaptureImportanceBonus(player2, EGroup_GetSpawnedEntityAt(eg_phase3_point2b, 1), -100)
		AI_SetCaptureImportanceBonus(player2, EGroup_GetSpawnedEntityAt(eg_phase4_point1, 1), -100)
		AI_SetCaptureImportanceBonus(player2, EGroup_GetSpawnedEntityAt(eg_phase4_point2, 1), -100)
		AI_SetCaptureImportanceBonus(player2, EGroup_GetSpawnedEntityAt(eg_phase4_pointenemy, 1), -100)
	end

	if AI_IsEnabled(player3) then
		AI_SetCaptureImportanceBonus(player3, EGroup_GetSpawnedEntityAt(eg_vp1, 1), 10)
		AI_SetCaptureImportanceBonus(player3, EGroup_GetSpawnedEntityAt(eg_vp1a, 1), 10)
		AI_SetCaptureImportanceBonus(player3, EGroup_GetSpawnedEntityAt(eg_vp2a, 1), 10)
		AI_SetCaptureImportanceBonus(player3, EGroup_GetSpawnedEntityAt(eg_vp2b, 1), 10)
	end
	
	if AI_IsEnabled(player4) then
		AI_SetCaptureImportanceBonus(player4, EGroup_GetSpawnedEntityAt(eg_vp1, 1), 10)
		AI_SetCaptureImportanceBonus(player4, EGroup_GetSpawnedEntityAt(eg_vp1a, 1), 10)
		AI_SetCaptureImportanceBonus(player4, EGroup_GetSpawnedEntityAt(eg_vp2a, 1), 10)
		AI_SetCaptureImportanceBonus(player4, EGroup_GetSpawnedEntityAt(eg_vp2b, 1), 10)
	end

	--player squads
	sg_player1_starting = SGroup_CreateIfNotFound ("sg_player1_starting")
	sg_player2_starting = SGroup_CreateIfNotFound ("sg_player2_starting")
	sg_tankguns_p1 = SGroup_CreateIfNotFound ("sg_tankguns_p1")
	sg_tankguns_p2 = SGroup_CreateIfNotFound ("sg_tankguns_p2")
	
	Util_CreateSquads( player1, sg_player1_starting, SBP.GERMAN.GRENADIER_SQUAD, mkr_player1_infantry1)
	Util_CreateSquads( player1, sg_player1_starting, SBP.GERMAN.GRENADIER_SQUAD, mkr_player1_infantry2)
	Util_CreateSquads( player1, sg_player1_starting, SBP.GERMAN.GRENADIER_SQUAD, mkr_player1_infantry3)
	Util_CreateSquads( player1, sg_player1_starting, SBP.GERMAN.STUG_III_E_SQUAD, mkr_player1_vehicle1)
	Util_CreateSquads( player1, sg_player1_starting, SBP.GERMAN.STUG_III_E_SQUAD, mkr_player1_vehicle2)
	Util_CreateSquads( player1, sg_player1_starting, SBP.GERMAN.SCOUTCAR_SDKFZ222, mkr_player1_vehicle3)
	Util_CreateSquads( player1, sg_tankguns_p1, SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD, mkr_player1_atGun)
	
	Util_CreateSquads( player2, sg_player2_starting, SBP.GERMAN.GRENADIER_SQUAD, mkr_player2_infantry1)
	Util_CreateSquads( player2, sg_player2_starting, SBP.GERMAN.GRENADIER_SQUAD, mkr_player2_infantry2)
	Util_CreateSquads( player2, sg_player2_starting, SBP.GERMAN.GRENADIER_SQUAD, mkr_player2_infantry3)
	Util_CreateSquads( player2, sg_player2_starting, SBP.GERMAN.STUG_III_E_SQUAD, mkr_player2_vehicle1)
	Util_CreateSquads( player2, sg_player2_starting, SBP.GERMAN.STUG_III_E_SQUAD, mkr_player2_vehicle2)
	Util_CreateSquads( player2, sg_player2_starting, SBP.GERMAN.SCOUTCAR_SDKFZ222, mkr_player2_vehicle3)
	Util_CreateSquads( player2, sg_tankguns_p2, SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD, mkr_player2_atGun)
	
	if AI_IsAIPlayer(player2) == true then
		Setup_SetPlayerName(player2, 11035400) -- LOCDB [11035400] '20th Mechanized Division'
	elseif AI_IsAIPlayer(player1) == true then
		Setup_SetPlayerName(player1, 11035400) -- LOCDB [11035400] '20th Mechanized Division'
	end
	
	SGroup_SetAvgHealth(sg_abandontanks1, 0.13)
	Cmd_CriticalHit(player3, sg_abandontanks1, CRIT.VEHICLE_ABANDON, 1)
	
	eg_vp2a_structures = EGroup_CreateIfNotFound("eg_vp2a_structures")
	EGroup_AddEGroup( eg_vp2a_structures, eg_vp2a_barracks)
	EGroup_AddEGroup( eg_vp2a_structures, eg_vp2a_weapon_support_center)

	eg_vp2b_structures = EGroup_CreateIfNotFound("eg_vp2b_structures")
	EGroup_AddEGroup( eg_vp2b_structures, eg_vp2b_tank_depot)
	EGroup_AddEGroup( eg_vp2b_structures, eg_vp2_motorpool)
	
	-- hide and make invulnerable the player 4 HQ to prevent anihilation from short circuting the script
	eg_player4_hq = EGroup_CreateIfNotFound("eg_player4_hq")
	sg_player4_engineers = SGroup_CreateIfNotFound("sg_player4_engineers")
	Player_GetAll(player4, sg_player4_engineers, eg_player4_hq)
	EGroup_Filter(eg_player4_hq, EBP.SOVIET.HQ, FILTER_KEEP)
	EGroup_SetInvulnerable(eg_player4_hq, true)
	EGroup_Hide(eg_player4_hq, true)
	SGroup_Filter(sg_player4_engineers, SBP.SOVIET.COMBAT_ENGINEER_SQUAD, FILTER_KEEP)
	SGroup_DestroyAllSquads(sg_player4_engineers)
end

function Mission_Restrictions()
	ToW_SetUpTechTreeByYear(player1, 1941)
	ToW_SetUpTechTreeByYear(player2, 1941)
	ToW_SetUpTechTreeByYear(player3, 1941)
	ToW_SetUpTechTreeByYear(player4, 1941)
	
	ToW_SetStandardResources (player1)
	ToW_SetStandardResources (player2)
	ToW_SetStandardResources (player3)
	ToW_SetStandardResources (player4)

	Player_SetEntityProductionAvailability ( player3, EBP.SOVIET.BARRACKS, ITEM_LOCKED )
	Player_SetEntityProductionAvailability ( player3, EBP.SOVIET.WEAPON_SUPPORT_CENTER, ITEM_LOCKED )
	Player_SetEntityProductionAvailability ( player3, EBP.SOVIET.MOTORPOOL, ITEM_LOCKED )
	Player_SetEntityProductionAvailability ( player3, EBP.SOVIET.TANK_DEPOT, ITEM_LOCKED )

	Player_SetEntityProductionAvailability ( player4, EBP.SOVIET.BARRACKS, ITEM_LOCKED )
	Player_SetEntityProductionAvailability ( player4, EBP.SOVIET.WEAPON_SUPPORT_CENTER, ITEM_LOCKED )
	Player_SetEntityProductionAvailability ( player4, EBP.SOVIET.MOTORPOOL, ITEM_LOCKED )
	Player_SetEntityProductionAvailability ( player4, EBP.SOVIET.TANK_DEPOT, ITEM_LOCKED )
end

function Mission_Difficulty()
	g_difficulty = Game_GetSPDifficulty()   
	_ToWDebugDisplay("********* DIFFICULTY: "..g_difficulty)
	
	sg_breakout_trucks = SGroup_CreateIfNotFound("sg_breakout_trucks")
	sg_breakout_t34s = SGroup_CreateIfNotFound("sg_breakout_t34s")
	sg_breakout_t70s = SGroup_CreateIfNotFound("sg_breakout_t70s")
	sg_breakout_katyushas = SGroup_CreateIfNotFound("sg_breakout_katyushas")
	
	sg_breakout01 = SGroup_CreateIfNotFound("sg_breakout01")
	sg_breakout02 = SGroup_CreateIfNotFound("sg_breakout02")
	sg_breakout03 = SGroup_CreateIfNotFound("sg_breakout03")
	sg_breakout04 = SGroup_CreateIfNotFound("sg_breakout04")
	sg_breakout05 = SGroup_CreateIfNotFound("sg_breakout05")
	sg_breakout06 = SGroup_CreateIfNotFound("sg_breakout06")
	sg_breakout07 = SGroup_CreateIfNotFound("sg_breakout07")
	sg_breakout08 = SGroup_CreateIfNotFound("sg_breakout08")
	
	sg_escape_headoffmap = SGroup_CreateIfNotFound("sg_escape_headoffmap")
	
	local 	breakoutEasyUnits = {
		{
			sbp = SBP.SOVIET.M3A1_SCOUT_CAR_SQUAD ,
			sgroups = { sg_breakout_trucks },
		},
		{
			sbp = SBP.SOVIET.T_70M ,
			sgroups = { sg_breakout_t70s},
		},
		{
			sbp = SBP.SOVIET.T_70M ,
			sgroups = { sg_breakout_t70s },
		},
		{
			sbp = SBP.SOVIET.US6_TRUCK_SQUAD ,
			sgroups = { sg_breakout_katyushas },
		},
		{
			sbp = SBP.SOVIET.US6_TRUCK_SQUAD ,
			sgroups = { sg_breakout_katyushas },
		},
		{
			sbp = SBP.SOVIET.T_34_76_SQUAD ,
			sgroups = { sg_breakout_t34s },
		},
		{
			sbp = SBP.SOVIET.M3A1_SCOUT_CAR_SQUAD ,
			sgroups = { sg_breakout_trucks },
		},
		{
			sbp = SBP.SOVIET.M3A1_SCOUT_CAR_SQUAD ,
			sgroups = { sg_breakout_trucks },
		},
	}

	local 	breakoutNormalUnits = {
		{
			sbp = SBP.SOVIET.M3A1_SCOUT_CAR_SQUAD ,
			sgroups = { sg_breakout_trucks },
		},
		{
			sbp = SBP.SOVIET.T_70M ,
			sgroups = { sg_breakout_t70s },
		},
		{
			sbp = SBP.SOVIET.T_34_76_SQUAD ,
			sgroups = { sg_breakout_t34s },
		},
		{
			sbp = SBP.SOVIET.US6_TRUCK_SQUAD ,
			sgroups = { sg_breakout_katyushas },
		},
		{
			sbp = SBP.SOVIET.US6_TRUCK_SQUAD ,
			sgroups = { sg_breakout_katyushas },
		},
		{
			sbp = SBP.SOVIET.T_34_76_SQUAD ,
			sgroups = { sg_breakout_t34s },
		},
		{
			sbp = SBP.SOVIET.T_70M ,
			sgroups = { sg_breakout_t70s },
		},
		{
			sbp = SBP.SOVIET.M3A1_SCOUT_CAR_SQUAD ,
			sgroups = { sg_breakout_trucks },
		},
	}

	local 	breakoutHardUnits = {
		{
			sbp = SBP.SOVIET.M3A1_SCOUT_CAR_SQUAD ,
			sgroups = { sg_breakout_trucks },
		},
		{
			sbp = SBP.SOVIET.T_34_76_SQUAD ,
			sgroups = { sg_breakout_t34s },
		},
		{
			sbp = SBP.SOVIET.T_34_76_SQUAD ,
			sgroups = { sg_breakout_t34s },
		},
		{
			sbp = SBP.SOVIET.US6_TRUCK_SQUAD ,
			sgroups = { sg_breakout_katyushas },
		},
		{
			sbp = SBP.SOVIET.US6_TRUCK_SQUAD ,
			sgroups = { sg_breakout_katyushas },
		},
		{
			sbp = SBP.SOVIET.T_34_76_SQUAD ,
			sgroups = { sg_breakout_t34s },
		},
		{
			sbp = SBP.SOVIET.T_34_76_SQUAD ,
			sgroups = { sg_breakout_t34s },
		},
		{
			sbp = SBP.SOVIET.T_70M ,
			sgroups = { sg_breakout_t70s },
		},
	}
	
	t_difficulty = {
		artilleryDelay = Util_DifVar ( { 75, 60, 45, 30 }, g_difficulty),
		part3Countdown = Util_DifVar ( { 240, 180, 120, 90 }, g_difficulty),
		numFew  = Util_DifVar( { 1, 1, 1, 2}, g_difficulty),
		numSome = Util_DifVar( { 1, 1, 2, 2}, g_difficulty),
		numMany = Util_DifVar( { 1, 2, 2, 2}, g_difficulty),
		breakoutUnits = Util_DifVar ( { breakoutEasyUnits, breakoutNormalUnits, breakoutHardUnits, breakoutHardUnits}, g_difficulty ),
	}
end


function Part1_InitializeObjective()

	OBJ_Part1 = {
		
		SetupUI = function() 
			vp1Ping  = Objective_AddUIElements(OBJ_Part1, eg_vp1,  true, 11049986, true, nil, nil, HPAT_Objective)			-- LOCDB [11049986] 'Secure this Watchtower'
			vp1aPing = Objective_AddUIElements(OBJ_Part1, eg_vp1a, true, 11049986, true, nil, nil, HPAT_Objective)
		end,

		OnStart = function()
			Util_StartIntel(EVENTS.Part1Start)
			Objective_SetCounter (OBJ_Part1, 0, 2)
			local sect1 = World_GetTerritorySectorID( EGroup_GetPosition(eg_vp1))
			local sect1a = World_GetTerritorySectorID( EGroup_GetPosition(eg_vp1a))
			Event_PlayerOwnsTerritory(SecureVP, {obj = OBJ_Part1, id = vp1Ping , group = eg_vp1,  max = 2}, player1, sect1)
			Event_PlayerOwnsTerritory(SecureVP, {obj = OBJ_Part1, id = vp1aPing, group = eg_vp1a, max = 2}, player1, sect1a)
			
			ToW_SetUpTechTreeByYear(player3, 1000)
			ToW_SetUpTechTreeByYear(player4, 1000)
		end,
		
		OnComplete = function()
			Rule_AddOneShot(Part2_Start, 2)
			ToW_SetUpTechTreeByYear(player3, 1941)
			ToW_SetUpTechTreeByYear(player4, 1941)
		end,
		
		OnFail = function()
		end,
		
		Title = 11038425, -- LOCDB [11038425] 'Secure the two Watchtowers to link up with your ally.'
		Description = 0,				-- Objective Description
		Type = OT_Primary,				-- Objective Type (OT_Primary, OT_Secondary)
		
	}
	
	Objective_Register(OBJ_Part1)

end

function Part1_Start()
	SetupEarlyVPs()
	SetupHowitzersVPs()
	SetupLaterVPs()
	SetupVP3()
	SetupHints()
	Objective_Start(OBJ_Part1)
end

function SetupEarlyVPs()
	local encData = {
		name = "VP1 defense",
		player = player3,
		units = {
			{
				sbp = SBP.SOVIET.GUARDS_TROOPS,
				spawn = mkr_vp1_infantry1,
				numSquads = t_difficulty.numMany,
			},
			{
				sbp = SBP.SOVIET.CONSCRIPT_SQUAD,
				spawn = mkr_vp1_infantry2,
				numSquads = t_difficulty.numFew,
			},
			{
				sbp = SBP.SOVIET.CONSCRIPT_SQUAD,
				spawn = mkr_vp1_infantry3,
				numSquads = t_difficulty.numFew,
			},
			{
				sbp = SBP.SOVIET.M1937_53_K_45MM_AT_GUN_SQUAD,
				spawn = mkr_vp1_atGun1,
			},
		},
		onDeath = nil,
	}
	local goalData = {
		name = "Defend",
		target = mkr_vp1_space,
		range = mkr_vp1_space,
	}
	t_encounters.vp1 = Encounter:Create(encData)
	t_encounters.vp1:SetGoal(goalData)
	
	encData = {
		name = "VP1a defense",
		player = player3,
		units = {
			{
				sbp = SBP.SOVIET.GUARDS_TROOPS,
				spawn = mkr_vp1a_infantry1,
				numSquads = t_difficulty.numSome,
			},
			{
				sbp = SBP.SOVIET.GUARDS_TROOPS,
				spawn = mkr_vp1a_infantry2,
				numSquads = t_difficulty.numSome,
			},
			{
				sbp = SBP.SOVIET.M1937_53_K_45MM_AT_GUN_SQUAD,
				spawn = mkr_vp1a_atGun1,
			},
		},
		onDeath = nil,
	}
	local goalData = {
		name = "Defend",
		target = mkr_vp1a_space,
		range = mkr_vp1a_space,
	}
	t_encounters.vp1a = Encounter:Create(encData)
	t_encounters.vp1a:SetGoal(goalData)
	
	local goalData = {
		name = "Defend",
		target = mkr_watchtower_t70s_staging,
		range = mkr_watchtower_t70s_staging,
		leashRange = mkr_watchtower_t70s_staging,
	}
	t_encounters.watchtowerT701 = Encounter:ConvertSgroup(sg_watchtower_t70_1)
	t_encounters.watchtowerT701:SetGoal(goalData)
	t_encounters.watchtowerT702 = Encounter:ConvertSgroup(sg_watchtower_t70_2)
	t_encounters.watchtowerT702:SetGoal(goalData)
end

function Part1_T70Counter()
	if t_encounters.watchtowerT701:IsAlive() then
		local goalData = {
			name = "Defend",
			target = mkr_vp1_space,
			range = mkr_vp1_space,
		}
		t_encounters.watchtowerT701:UpdateGoal(goalData)
	end
	if t_encounters.watchtowerT702:IsAlive() then
		local goalData = {
			name = "Defend",
			target = mkr_vp1a_space,
			range = mkr_vp1a_space,
		}
		t_encounters.watchtowerT702:UpdateGoal(goalData)
	end
end

function SetupHowitzersVPs()
	local data  = { sgroup = sg_overlook_howitzer1, marker = mkr_howitzer_target1, delay = t_difficulty.artilleryDelay}
	local data2 = { sgroup = sg_overlook_howitzer2, marker = mkr_howitzer_target2, delay = t_difficulty.artilleryDelay }
	Event_Timer ( FireHowitzer, data , 60 )
	Event_Timer ( FireHowitzer, data2, 45 )
	Util_LogSyncWpn(sg_overlook_howitzer1)
	Util_LogSyncWpn(sg_overlook_howitzer2)
end

function SetupLaterVPs()
	sg_vp2a_defenders = SGroup_CreateIfNotFound("sg_vp2a_defenders")
	sg_vp2b_defenders = SGroup_CreateIfNotFound("sg_vp2b_defenders")
	local encData = {
		player = player3, 
		sgroups = {sg_vp2a_defenders},
		units = {
			{
				sbp = SBP.SOVIET.M1942_ZIS_3_76MM_AT_GUN_SQUAD,
				spawn = mkr_vp2a_atgun1,
			},
			{
				sbp = SBP.SOVIET.M1942_ZIS_3_76MM_AT_GUN_SQUAD,
				spawn = mkr_vp2a_atgun2,
			},
			{
				sbp = SBP.SOVIET.M1942_ZIS_3_76MM_AT_GUN_SQUAD,
				spawn = mkr_vp2a_atgun3,
			},
			{
				sbp = SBP.SOVIET.T_34_76_SQUAD,
				spawn = mkr_vp2a_tank1,
			},
			{
				sbp = SBP.SOVIET.SHOCK_TROOPS,
				spawn = mkr_vp2a_infantry3,
				numSquads = t_difficulty.numSome,
			},
			{
				sbp = SBP.SOVIET.SHOCK_TROOPS,
				spawn = mkr_vp2a_infantry2,
				numSquads = t_difficulty.numSome,
			},
			{
				sbp = SBP.SOVIET.GUARDS_TROOPS,
				spawn = mkr_vp2a_infantry1,
				numSquads = t_difficulty.numSome,
			},
		},
		onDeath = nil,
	}
	local goalData = {
		name = "Defend",
		target = mkr_vp2a_space,
		leashRange = mkr_vp2a_space,
		range = mkr_vp2a_space,
	}
	t_encounters.vp2a = Encounter:Create(encData)
	t_encounters.vp2a:SetGoal(goalData)

	local encData = {
		player = player4, 
		sgroups = {sg_vp2b_defenders},
		units = {
			{
				sbp = SBP.SOVIET.M1942_ZIS_3_76MM_AT_GUN_SQUAD,
				spawn = mkr_vp2b_atgun1,
			},
			{
				sbp = SBP.SOVIET.M1942_ZIS_3_76MM_AT_GUN_SQUAD,
				spawn = mkr_vp2b_atgun2,
			},
			{
				sbp = SBP.SOVIET.T_34_76_SQUAD,
				spawn = mkr_vp2b_tank1,
			},
			{
				sbp = SBP.SOVIET.T_34_76_SQUAD,
				spawn = mkr_vp2b_tank2,
			},
			{
				sbp = SBP.SOVIET.T_34_76_SQUAD,
				spawn = mkr_vp2b_tank3,
			},
			{
				sbp = SBP.SOVIET.GUARDS_TROOPS,
				spawn = mkr_vp2b_infantry1,
				numSquads = t_difficulty.numSome,
			},
			{
				sbp = SBP.SOVIET.GUARDS_TROOPS,
				spawn = mkr_vp2b_infantry2,
				numSquads = t_difficulty.numSome,
			},
			{
				sbp = SBP.SOVIET.GUARDS_TROOPS,
				spawn = mkr_vp2b_infantry3,
				numSquads = t_difficulty.numSome,
			},
		},
		onDeath = nil,
	}
	local goalData = {
		name = "Defend",
		target = mkr_vp2b_space,
		leashRange = mkr_vp2b_space,
		range = mkr_vp2b_space,
	}
	t_encounters.vp2b = Encounter:Create(encData)
	t_encounters.vp2b:SetGoal(goalData)
end

function SetupVP3()
	sg_vp3_defenders = SGroup_CreateIfNotFound("sg_vp3_defenders")
	sg_hq2_defenders = SGroup_CreateIfNotFound("sg_hq2_defenders")
	local encData = {
		player = player3, 
		sgroups = {sg_vp3_defenders},
		units = {
			{
				sbp = SBP.SOVIET.M1942_ZIS_3_76MM_AT_GUN_SQUAD,
				spawn = mkr_vp3_atgun1,
			},
			{
				sbp = SBP.SOVIET.M1942_ZIS_3_76MM_AT_GUN_SQUAD,
				spawn = mkr_vp3_atgun2,
			},
			{
				sbp = SBP.SOVIET.KV_1,
				spawn = mkr_vp3_kv1_01,
			},
			{
				sbp = SBP.SOVIET.KV_1,
				spawn = mkr_vp3_kv1_02,
			},
			{
				sbp = SBP.SOVIET.T_34_76_SQUAD,
				spawn = mkr_vp3_t34_01,
			},
			{
				sbp = SBP.SOVIET.T_34_76_SQUAD,
				spawn = mkr_vp3_t34_02,
			},
		},
		onDeath = nil,
	}
	local goalData = {
		name = "Defend",
		target = mkr_vp3_space,
		leashRange = mkr_vp3_space,
		range = mkr_vp3_space,
	}
	t_encounters.vp3 = Encounter:Create(encData)
	t_encounters.vp3:SetGoal(goalData)
	
	encData = {
		player = player3,
		sgroups = {sg_vp3_defenders},
		units = {
			{
				sbp = SBP.SOVIET.SNIPER_TEAM,
				spawn = eg_vp3_church,
			},
			
			{
				sbp = SBP.SOVIET.M1910_MAXIM_HEAVY_MACHINE_GUN_SQUAD,
				spawn = eg_vp3_church,
			},
		},
		onDeath = nil,
	}
	goalData = {
		name = "Defend",
		target = mkr_vp3_space,
		leashRange = mkr_vp3_space,
		range = mkr_vp3_space,
		garrison = true,
		garrisonIdle = true,
	}
	t_encounters.vp3snipers = Encounter:Create(encData)
	t_encounters.vp3snipers:SetGoal(goalData)
	
	encData = {
		player = player4,
		sgroups = {sg_hq2_defenders},
		units = {
			{
				sbp = SBP.SOVIET.M1942_ZIS_3_76MM_AT_GUN_SQUAD,
				spawn = mkr_hq2_atgun1,
			},
			{
				sbp = SBP.SOVIET.M1942_ZIS_3_76MM_AT_GUN_SQUAD,
				spawn = mkr_hq2_atgun2,
			},
			{
				sbp = SBP.SOVIET.M1942_ZIS_3_76MM_AT_GUN_SQUAD,
				spawn = mkr_hq2_atgun3,
			},
			{
				sbp = SBP.SOVIET.T_34_76_SQUAD,
				spawn = mkr_hq2_t34_01,
			},
			{
				sbp = SBP.SOVIET.T_34_76_SQUAD,
				spawn = mkr_hq2_t34_02,
			},
		},
		onDeath = nil,
	}
	goalData = {
		name = "Defend",
		target = mkr_hq2_space,
		range = mkr_hq2_space,
		leashRange = mkr_hq2_space,
	}
	t_encounters.hq2 = Encounter:Create(encData)
	t_encounters.hq2:SetGoal(goalData)
end

-------------------------------------------
-------------------------------------------
--
--  PART 2: Tighten the Noose
--
-------------------------------------------
-------------------------------------------


function Part2_InitializeObjective()

	OBJ_Part2 = {
		
		SetupUI = function() 
			vp2aPing = Objective_AddUIElements(OBJ_Part2, eg_vp2a, true, 11047917, true, 3, nil, HPAT_Hint, "Icons_upgrades_icon_upgrade_german_bunker_medic")
			vp2bPing = Objective_AddUIElements(OBJ_Part2, eg_vp2b, true, 11047918, true, 3, nil, HPAT_Hint, "Icons_abilities_repair")
		end,

		OnStart = function()
			Util_StartIntel(EVENTS.Part2Start)
			Objective_SetCounter (OBJ_Part2, 0, 2)
			local sect2a = World_GetTerritorySectorID( EGroup_GetPosition(eg_vp2a))
			local sect2b = World_GetTerritorySectorID( EGroup_GetPosition(eg_vp2b))
			Event_PlayerOwnsTerritory(SecureVP, {obj = OBJ_Part2, id = vp2aPing, group = eg_vp2a, 
			groupToDestroy = eg_vp2a_structures, max = 2}, player1, sect2a)
			Event_PlayerOwnsTerritory(SecureVP, {obj = OBJ_Part2, id = vp2bPing, group = eg_vp2b, 
			groupToDestroy = eg_vp2b_structures, max = 2}, player1, sect2b)
		end,
		
		OnComplete = function()
			Part2_EvacFieldHQs(player3)
			Part2_EvacFieldHQs(player4)
			Part3_Start()
		end,
		
		OnFail = function()
		end,
		
		Title = 11038426, -- LOCDB [11038426] 'Secure the Soviet field HQs.'
		Description = 0,			-- Objective Description
		Type = OT_Primary,				-- Objective Type (OT_Primary, OT_Secondary)
		
	}
	Objective_Register(OBJ_Part2)
end


function Part2_Start()
	Objective_Start(OBJ_Part2)
	if g_difficulty ~= GD_EASY then
		Rule_AddInterval ( Part2_CounterAttackFromHospital , 300)
		Rule_AddDelayedInterval ( Part2_CounterAttackFromSupportBay, 120 , 300)
	end
	
	-- 
	-- Set up importance of territory flags
	--
	if AI_IsEnabled(player2) then
		AI_SetCaptureImportanceBonus(player2, EGroup_GetSpawnedEntityAt(eg_vp2a, 1), 1)
		AI_SetCaptureImportanceBonus(player2, EGroup_GetSpawnedEntityAt(eg_vp2b, 1), 100)
		AI_SetCaptureImportanceBonus(player2, EGroup_GetSpawnedEntityAt(eg_phase3_point1a, 1), 3)
		AI_SetCaptureImportanceBonus(player2, EGroup_GetSpawnedEntityAt(eg_phase3_point1b, 1), 3)
		AI_SetCaptureImportanceBonus(player2, EGroup_GetSpawnedEntityAt(eg_phase3_point2a, 1), 7)
		AI_SetCaptureImportanceBonus(player2, EGroup_GetSpawnedEntityAt(eg_phase3_point2b, 1), 7)
	end
	
	if AI_IsEnabled(player3) then
		AI_SetCaptureImportanceBonus(player3, EGroup_GetSpawnedEntityAt(eg_vp2a, 1), 10)
		AI_SetCaptureImportanceBonus(player3, EGroup_GetSpawnedEntityAt(eg_vp2b, 1), 7)
	end
	
	if AI_IsEnabled(player4) then
		AI_SetCaptureImportanceBonus(player4, EGroup_GetSpawnedEntityAt(eg_vp2a, 1), 7)
		AI_SetCaptureImportanceBonus(player4, EGroup_GetSpawnedEntityAt(eg_vp2b, 1), 10)
	end
	
	-- forget flags from previous phases
	if AI_IsEnabled(player2) then
		AI_SetCaptureImportanceBonus(player2, EGroup_GetSpawnedEntityAt(eg_vp1, 1), 5)
	end
	
	if AI_IsEnabled(player3) then
		AI_SetCaptureImportanceBonus(player3, EGroup_GetSpawnedEntityAt(eg_vp1, 1), -100)
		AI_SetCaptureImportanceBonus(player3, EGroup_GetSpawnedEntityAt(eg_phase2_point2c, 1), -100)
	end
	
	if AI_IsEnabled(player4) then
		AI_SetCaptureImportanceBonus(player4, EGroup_GetSpawnedEntityAt(eg_vp1, 1), -100)
		AI_SetCaptureImportanceBonus(player4, EGroup_GetSpawnedEntityAt(eg_phase2_point2c, 1), -100)
	end
end



function Part2_EvacFieldHQs(player)
	sg_temp = SGroup_CreateIfNotFound("sg_temp")
	SGroup_Clear(sg_temp)
	Player_GetAllSquadsNearMarker(player, sg_temp, mkr_vp2a_space)
	Cmd_Retreat(sg_temp)
	SGroup_Clear(sg_temp)
	Player_GetAllSquadsNearMarker(player, sg_temp, mkr_vp2b_space)
	Cmd_Retreat(sg_temp)
end

function Part2_CounterAttackFromHospital ()
	if EGroup_IsCapturedByPlayer(eg_vp2a, player1, ALL) or EGroup_IsCapturedByPlayer(eg_vp2a, player2, ALL) then
		Rule_RemoveMe()
		return
	elseif (t_encounters.hospitalRaid ~= nil) and (t_encounters.hospitalRaid:IsAlive()) then
		return
	end
	
	local encData = GetRaiderEncData(mkr_escape_north)
	t_encounters.hospitalRaid = Encounter:Create(encData)
	local goalData = {
		name = "Attack",
		target = mkr_player1_base,
		range = mkr_player1_base,
	}
	t_encounters.hospitalRaid:SetGoal(goalData)
	
	_ToWDebugDisplay ("Part2_CounterAttackFromHospital launching", "gold")
	_ToWDebugDisplay ("sbp1: " .. BP_GetName(encData.units[1].sbp), "cyan")
	_ToWDebugDisplay ("sbp2: " .. BP_GetName(encData.units[2].sbp), "cyan")
	_ToWDebugDisplay ("sbp3: " .. BP_GetName(encData.units[3].sbp), "cyan")
end
	
function Part2_CounterAttackFromSupportBay ()
	if EGroup_IsCapturedByPlayer(eg_vp2b, player1, ALL) or EGroup_IsCapturedByPlayer(eg_vp2b, player2, ALL) then
		Rule_RemoveMe()
		return
	elseif (t_encounters.supportBayRaid ~= nil) and (t_encounters.supportBayRaid:IsAlive()) then
		return
	end
	
	local encData = GetRaiderEncData(mkr_escape_south)
	t_encounters.supportBayRaid = Encounter:Create(encData)
	local goalData = {
		name = "Attack",
		target = mkr_player2_base,
		range = mkr_player2_base,
	}
	t_encounters.supportBayRaid:SetGoal(goalData)
	
	_ToWDebugDisplay ("Part2_CounterAttackFromSupportBay launching", "gold")
	_ToWDebugDisplay ("sbp1: " .. BP_GetName(encData.units[1].sbp), "cyan")
	_ToWDebugDisplay ("sbp2: " .. BP_GetName(encData.units[2].sbp), "cyan")
	_ToWDebugDisplay ("sbp3: " .. BP_GetName(encData.units[3].sbp), "cyan")

end

function GetRaiderEncData(marker)
	local infantry1 = {
		SBP.SOVIET.CONSCRIPT_SQUAD,
		SBP.SOVIET.GUARDS_TROOPS,
		SBP.SOVIET.SHOCK_TROOPS,
		SBP.SOVIET.PENAL_BATTALION,
	}
	local infantry2 = {
		SBP.SOVIET.CONSCRIPT_SQUAD,
		SBP.SOVIET.GUARDS_TROOPS,
		SBP.SOVIET.SHOCK_TROOPS,
		SBP.SOVIET.PENAL_BATTALION,
	}
	local vehicles = {
		SBP.SOVIET.M3A1_SCOUT_CAR_SQUAD,
		SBP.SOVIET.T_70M,
		SBP.SOVIET.KATYUSHA_BM_13N_SQUAD,
		SBP.SOVIET.T_34_76_SQUAD,
	}
	
	local encData = {
		player = player3,
		name = "Raid",
		spawn = marker,
		sgroups = {},
		units = {
			{
				sbp = infantry1[World_GetRand(1,#infantry1)],
				numSquads = t_difficulty.numMany,
			},
			{
				sbp = infantry2[World_GetRand(1,#infantry2)],
				numSquads = t_difficulty.numMany,
			},
			{
				sbp = vehicles[World_GetRand(1,#vehicles)],
				numSquads = t_difficulty.numSome,
			},
		},
		onDeath = nil,
	}
	return encData
end

-------------------------------------------
-------------------------------------------
--
--  PART 3: Breakout attempt
--
-------------------------------------------
-------------------------------------------

function Part3_InitializeObjective()
	g_breakout = 7

	OBJ_Prepare = {
		
		SetupUI = function() 
			Objective_AddUIElements(OBJ_Prepare, mkr_prepareHint1, true, 11040300, true, 3, nil, HPAT_Hint)
			Objective_AddUIElements(OBJ_Prepare, mkr_prepareHint2, true, 11040300, true, 3, nil, HPAT_Hint)
		end,
		
		
		OnStart = function()			-- Calls from Objective_Start(OBJ_Objective1)
			Util_StartIntel(EVENTS.Part3Start)
			Rule_AddOneShot(StartCountdown, 19)
		end,
		
		OnComplete = function()			-- Calls from Objective_Complete(OBJ_Objective1)
			Objective_Start(OBJ_Breakout)
		end,
		
		OnFail = function()				-- Calls from Objective_Fail(OBJ_Objective1)
		end,
		
		Title = 11038427, -- LOCDB [11038427] 'Prepare to stop a Russian breakout attempt.'
		Description = 0,									-- Objective Description
		Type = OT_Secondary,
		
	}
	
	OBJ_Breakout = {
		
		SetupUI = function() 
		end,
		
		OnStart = function()			-- Calls from Objective_Start(OBJ_Objective1)
			Objective_Start(OBJ_BreakoutSub, false)
			Event_Timer(Breakout, nil, 2)
			Util_StartIntel(EVENTS.Part3Breakout)
		end,
		
		OnComplete = function()			-- Calls from Objective_Complete(OBJ_Objective1)
			Rule_AddOneShot (EndSpeech, 3)
			Mission_MissionComplete()
		end,
		
		Intel_Fail = EVENTS.MissionFail, 
		OnFail = function()				-- Calls from Objective_Fail(OBJ_Objective1)
			World_SetTeamWin(Team_GetEnemyTeam(Player_GetTeam(World_GetPlayerAt(1))))
		end,
		
		Title = 11038428, -- LOCDB [11038428] 'Destroy the Russian vehicle convoy.'
		Description = 0,									-- Objective Description
		Type = OT_Primary,
		
	}
	
	OBJ_BreakoutSub = {
		Parent = OBJ_Breakout,
		SetupUI = function() 
			Objective_SetCounter(OBJ_BreakoutSub, 0, g_breakout)
		end,
		
		OnStart = function()			-- Calls from Objective_Start(OBJ_Objective1)
		end,
		
		OnComplete = function()			-- Calls from Objective_Complete(OBJ_Objective1)
		end,
		
		OnFail = function()				-- Calls from Objective_Fail(OBJ_Objective1)
		end,
		
		Title = Loc_FormatText(11048259, Loc_ConvertNumber(g_breakout)), -- LOCDB [11048259] 'Destroy at least %1NUMBER% vehicles'
		Description = 0,									-- Objective Description
		Type = OT_Secondary,
		
	}
	
	Objective_Register(OBJ_Prepare)
	Objective_Register(OBJ_Breakout)
	Objective_Register(OBJ_BreakoutSub)
end

function StartCountdown()
	Objective_StartTimer(OBJ_Prepare, COUNT_DOWN, t_difficulty.part3Countdown, 30)
	Event_Timer(CompleteCountdown, nil, t_difficulty.part3Countdown)
end

function Part3_Start()
	Objective_Start(OBJ_Prepare)
end

function CompleteCountdown(data)
	Objective_Complete(OBJ_Prepare)
end

function Breakout (data)
	sg_breakout = SGroup_CreateIfNotFound("sg_breakout")
	sg_breakout_infantry = SGroup_CreateIfNotFound("sg_breakout_infantry")
	local breakout_spawn = { mkr_escape_north, mkr_escape_south}
	local index = World_GetRand(1,2)
	local indexB = index - 1
	if indexB == 0 then
		indexB = 2
	end

	local encData = {
		spawn = breakout_spawn[index],
		sgroups = {sg_breakout},
		player = player4,
		units = t_difficulty.breakoutUnits,
		onDeath = nil,
	}
	t_encounters.breakout = Encounter:Create(encData, nil, true)
	
	local goalData = {
		name = "Move",
		target = mkr_escape_dest,
		attackMove = true,
		leashRange = 20, 
		coordinatedSetup = false,
	}
	t_encounters.breakout:SetGoal(goalData)
	
	Rule_AddDelayedInterval(ConvoySetup, 5, 1)
	
	local encData = {
		spawn = breakout_spawn[indexB],
		sgroups = {sg_breakout_infantry},
		player = player4,
		units = {
			{
				sbp = SBP.SOVIET.PENAL_BATTALION ,
				numSquads = 2,
			},
			{
				sbp = SBP.SOVIET.PENAL_BATTALION ,
				numSquads = 2,
			},
			{
				sbp = SBP.SOVIET.PENAL_BATTALION ,
				numSquads = 2,
			},
		},
		onDeath = nil,
	}
	t_encounters.breakoutInfantry = Encounter:Create(encData, nil, true)
	
	local goalData = {
		name = "Attack",
		target = mkr_escape_dest,
		range = mkr_escape_dest,
		leashRange = mkr_escape_dest,
		attackMove = true,
	}
	t_encounters.breakoutInfantry:SetGoal(goalData)
end


function ConvoySetup()
	if SGroup_Count(sg_breakout) > 7 then
		Modify_UnitSpeed ( sg_breakout_trucks, 		(4.0/6.0) )
		Modify_UnitSpeed ( sg_breakout_katyushas, 	(4.0/5.5) )
		Modify_UnitSpeed ( sg_breakout_t70s, 		(4.5/5.5) )
		SGroup_SetAnimatorState( sg_breakout_katyushas, "supplies_loaded", "full")
		FOW_RevealSGroupOnly ( sg_breakout, -1 )
		Objective_AddUIElements(OBJ_Breakout, sg_breakout, true, 11038428, true, 3)
		Rule_AddInterval(IncrementCounter, 1)
		Rule_RemoveMe()
	end
end

function IncrementCounter()
	if Objective_IsComplete(OBJ_Breakout) then
		Rule_RemoveMe()
		return
	elseif Objective_IsFailed(OBJ_Breakout) then
		Rule_RemoveMe()
		return
	end

	local killed = 8 - SGroup_Count(sg_breakout)
	Objective_SetCounter(OBJ_BreakoutSub, killed, g_breakout)
	
	local squadsNearFirstMarker = {}
	local CheckNearFirstMarker = function ( groupid, itemindex, itemid )
		if ( Marker_InProximity(mkr_escape_dest, Squad_GetPosition(itemid)) ) then
			table.insert( squadsNearFirstMarker, itemid )
		end
	end
	
	SGroup_ForEach( sg_breakout, CheckNearFirstMarker )
	SGroup_ForEach( sg_breakout_infantry, CheckNearFirstMarker )
	
	for i = 1, table.getn( squadsNearFirstMarker ) do
		if AI_IsEnabled(player4) then
			AI_LockSquad(player4, squadsNearFirstMarker[i])
		end
		SGroup_Clear(sg_escape_headoffmap)
		SGroup_Add(sg_escape_headoffmap, squadsNearFirstMarker[i] )
		if SGroup_ContainsSGroup(sg_breakout,  sg_escape_headoffmap, ANY) then
			t_encounters.breakout:RemoveUnitsBySgroup(sg_escape_headoffmap)
			t_encounters.breakout:RestartGoal()
		else
			t_encounters.breakoutInfantry:RemoveUnitsBySgroup(sg_escape_headoffmap)
			t_encounters.breakoutInfantry:RestartGoal()
		end
		Cmd_Move(sg_escape_headoffmap, mkr_truck_spawn)
	end
	
	
	local squadsNearSecondMarker = {}
	local CheckNearSecondMarker = function ( groupid, itemindex, itemid )
		if ( Marker_InProximity(mkr_truck_spawn, Squad_GetPosition(itemid)) ) then
			table.insert( squadsNearSecondMarker, itemid )
		end
	end
	
	SGroup_ForEach( sg_breakout, CheckNearSecondMarker )
	SGroup_ForEach( sg_breakout_infantry, CheckNearSecondMarker )
	
	for i = 1, table.getn( squadsNearSecondMarker ) do
		Squad_DeSpawn(squadsNearSecondMarker[i] )
	end
	

	
	if g_missionFinished ~= true then
		
		if not g_achievementComplete then
			if SGroup_Count(sg_breakout_infantry) < 1 then
				Achieve ("tow_encirclement_at_smolensk_in_the_noose")
				g_achievementComplete = true
			end
		end
		
		if (SGroup_CountSpawned(sg_breakout) < 1) or (killed >= g_breakout) then
			
			if Objective_IsCounterSet(OBJ_BreakoutSub) and ( Objective_GetCounter(OBJ_BreakoutSub) < g_breakout ) then
				Objective_Fail (OBJ_Breakout)
				g_missionFinished = true
--~ 				Rule_RemoveMe()
			elseif not Objective_IsComplete(OBJ_Breakout) then
				Objective_Complete (OBJ_Breakout)
				g_missionFinished = true
--~ 				Rule_RemoveMe()
			end
			
		elseif SGroup_CountDeSpawned(sg_breakout) > 8 - g_breakout then
			Objective_Fail (OBJ_Breakout)
			g_missionFinished = true
--~ 			Rule_RemoveMe()
		end
		
	end
	
end



function EndSpeech()
	Util_StartIntel(EVENTS.VPVictoryMessage)
end


function Mission_MissionComplete()
	
	if not Player_HasAbility(player1, ABILITY.GERMAN.STUKA_CLOSE_AIR_SUPPORT) then
		Player_AddAbility(player1, ABILITY.GERMAN.STUKA_CLOSE_AIR_SUPPORT)
		Player_SetAbilityAvailability(player1, ABILITY.GERMAN.STUKA_CLOSE_AIR_SUPPORT , ITEM_REMOVED)
	end
	
	if not Player_HasAbility(player1, ABILITY.GERMAN.STUKA_STRAFING_RUN) then
		Player_AddAbility(player1, ABILITY.GERMAN.STUKA_STRAFING_RUN)
		Player_SetAbilityAvailability(player1, ABILITY.GERMAN.STUKA_STRAFING_RUN , ITEM_REMOVED)
	end
	
	Cmd_Ability(player1, ABILITY.GERMAN.STUKA_CLOSE_AIR_SUPPORT, mkr_vp3_space, nil, true, false)
	Cmd_Ability(player1, ABILITY.GERMAN.STUKA_STRAFING_RUN, mkr_vp3_space, nil, true, false)

	-- wee camera pan if we have only one human player
	if not (Player_IsHuman(player1) and Player_IsHuman(player2))then
		Game_SetMode(UI_Cinematic)
		FOW_RevealAll()
		Camera_MoveTo(mkr_vp3_space, true, 0.05, nil, true)
	end

	Rule_AddOneShot(Mission_MissionEnd, 26)
end

function Mission_MissionEnd()
	Camera_SetInputEnabled(true)
	World_SetTeamWin(Player_GetTeam(World_GetPlayerAt(1)))
end

function ClearPing(data)
	_ToWDebugDisplay ("ClearPing for " .. EGroup_GetName(data.group), "gold")
	Objective_RemovePing(data.obj, data.id)
end 

function CompleteObjective(data)
	Objective_Complete(data.obj)
end 

function SecureVP(data)
	_ToWDebugDisplay ("SecureVP for " .. EGroup_GetName(data.group), "gold")
	
	if data.group == eg_vp1 then
		Objective_RemoveUIElements(OBJ_Part1, vp1Ping)
	elseif data.group == eg_vp1a then
		Objective_RemoveUIElements(OBJ_Part1, vp1aPing)
	elseif data.group == eg_vp2a then
		Objective_RemoveUIElements(OBJ_Part2, vp2aPing)
	elseif data.group == eg_vp2b then
		Objective_RemoveUIElements(OBJ_Part2, vp2bPing)
	end
	
	local entity = EGroup_GetSpawnedEntityAt(data.group, 1)
	local disableCapture = Modifier_Create(MAT_Entity, "modifiers\\enable_capture_entity_modifier.lua", MUT_Enable, false, -1, "")
	Modifier_ApplyToEntity(disableCapture, entity)
	
	if AI_IsEnabled(player3) then
		AI_SetCaptureImportanceBonus(player3, EGroup_GetSpawnedEntityAt(data.group, 1), -100)
	end
	
	if AI_IsEnabled(player4) then
		AI_SetCaptureImportanceBonus(player4, EGroup_GetSpawnedEntityAt(data.group, 1), -100)
	end
	
	if (data.max) then
		local function Increment()
			local count = Objective_GetCounter(data.obj) + 1
			Objective_SetCounter(data.obj, count, data.max)
			if count == data.max then
				Objective_Complete(data.obj)
			end
		end
		if (data.groupToDestroy) then
			if EGroup_Count(data.groupToDestroy) > 0 then
				Event_GroupIsDead (SecureVP, data, data.groupToDestroy)
			else
				Increment()
			end
		else
			Increment()
		end
	end
	
	if (data.obj == OBJ_Part1) and (Objective_IsComplete(data.obj) == false) then
		Part1_T70Counter()
	end
end

function FireHowitzer(data)
	_ToWDebugDisplay ("FireHowitzer for " .. SGroup_GetName(data.sgroup), "gold")
	
	if SGroup_Count(data.sgroup) < 1 then
		_ToWDebugDisplay ("FireHowitzer found empty group " .. SGroup_GetName(data.sgroup))
		return
	end
	
	local sg_concentration_p1 = Player_GetSquadConcentration(player1, nil, nil, nil, nil, data.marker)
	local sg_concentration_p2 = Player_GetSquadConcentration(player2, nil, nil, nil, nil, data.marker)
	local target = nil
	local targetPlayer = player1
	
	if (sg_concentration_p1 == nil) and (sg_concentration_p2 == nil) then
		_ToWDebugDisplay ("FireHowitzer found no targets")
	elseif (sg_concentration_p1 == nil) then
		target = sg_concentration_p2
		targetPlayer = player2
		_ToWDebugDisplay ("FireHowitzer target: player 2")
	elseif (sg_concentration_p2 == nil) then
		target = sg_concentration_p1
		targetPlayer = player1
		_ToWDebugDisplay ("FireHowitzer target: player 1")
	elseif SGroup_Count(sg_concentration_p1) > SGroup_Count(sg_concentration_p2) then
		target = sg_concentration_p1
		targetPlayer = player1
		_ToWDebugDisplay ("FireHowitzer target: player 1")
	elseif SGroup_Count(sg_concentration_p1) < SGroup_Count(sg_concentration_p2) then
		target = sg_concentration_p2
		targetPlayer = player2
		_ToWDebugDisplay ("FireHowitzer target: player 2")
	elseif World_GetRand(1,2) == 2 then
		target = sg_concentration_p1
		targetPlayer = player1
		_ToWDebugDisplay ("FireHowitzer target: player 1")
	else
		target = sg_concentration_p2
		targetPlayer = player2
		_ToWDebugDisplay ("FireHowitzer target: player 2")
	end
	
	if(target ~= nil) and (SGroup_IsRetreating(data.sgroup, ANY) == false) and SGroup_HasTeamWeapon(data.sgroup, ALL) then
		local pos = Util_GetPositionAwayFromPlayer(target, targetPlayer, 18, 5) or SGroup_GetPosition(target)
		EventCue_Create(CUE.ATTACKED, 11038432,  nil, pos) -- LOCDB [11038432] 'Artillery Incoming'
		local hint = HintPoint_Add(pos, true, 11038432, 3, HPAT_Hint)
		Command_SquadPosAbility(player3, data.sgroup, pos, BP_GetAbilityBlueprint("b4_203mm_barrage_mp"), true, false)
		Event_Timer(FireHowitzer2, {id=hint}, 15)
		FOW_RevealSGroup (data.sgroup, 30 )
		
		if not (g_artyThreat) then
			g_artyThreat = ThreatArrow_CreateGroup(data.sgroup)
		else
			ThreatArrow_Add(g_artyThreat, data.sgroup)
		end
	end
	Event_Timer(FireHowitzer, data, data.delay)
end

function FireHowitzer2 (data)
	HintPoint_Remove(data.id)
end

---------------------------- HINTS FOR BUILDINGS IN PART 2 ----------------

function SetupHints()
	Event_PlayerCanSeeElement (CreateHint, {group = eg_vp2a_barracks, locid = 11038433, icon = "Icons_commands_icon_command_attackmove"}, player1, eg_vp2a_barracks) -- LOCDB [11038433] 'Destroy to cripple soviet production.'
	Event_PlayerCanSeeElement (CreateHint, {group = eg_vp2a_weapon_support_center, locid = 11038433, icon = "Icons_commands_icon_command_attackmove"}, player1, eg_vp2a_weapon_support_center)
	Event_PlayerCanSeeElement (CreateHint, {group = eg_vp2b_tank_depot, locid = 11038433, icon = "Icons_commands_icon_command_attackmove"}, player1, eg_vp2b_tank_depot)
	Event_PlayerCanSeeElement (CreateHint, {group = eg_vp2_motorpool, locid = 11038433, icon = "Icons_commands_icon_command_attackmove"}, player1, eg_vp2_motorpool)
end

function CreateHint(data)
	data.hint = HintPoint_Add( data.group, true, data.locid, 3, HPAT_Hint, data.icon) 
	Event_GroupIsDead (RemoveUI, data, data.group)
end

function RemoveUI (data)
	HintPoint_Remove(data.hint)
end

function Achieve(data)
	if scartype (data) == ST_STRING then
		data = { id = data }
	end
	_ToWDebugDisplay("ACHIEVEMENT: " .. data.id, "gold")
	Scar_CompleteIntelBulletinTask(player1, data.id)
	if not AI_IsEnabled(player2) then
		Scar_CompleteIntelBulletinTask(player2, data.id)
	end
end

function SetupAchievements()
	sg_artillery = SGroup_CreateIfNotFound("sg_artillery")
	SGroup_AddGroups(sg_artillery, {sg_overlook_howitzer1, sg_overlook_howitzer2})
	Event_GroupIsDead(Achieve, {id="tow_encirclement_at_smolensk_silence_the_guns"}, sg_artillery)
end

