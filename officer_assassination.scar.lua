-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- OFFICER ASSASSINATION
-- Designers: LANCE MUELLER & PHILIPPE BOULLE
-------------------------------------------------------------------------
-------------------------------------------------------------------------
--~ isCampaign = true
import("ScarUtil.scar")
import("Beginner.scar")
import("Systems/AiManager/ai.scar")
import("TheatreOfWar.scar")
import("Global_Values/CampaignGlobalConstants.scar")

g_isWinterMap = true

-------------------------------------------------------------------------
-- [[ SETUP ]]
-------------------------------------------------------------------------

function OnGameSetup()
	-- Required Playersgerman
	player1 = Setup_Player(1, 11038759, "german", 1)		-- player1 is always the human player
	player2 = Setup_Player(2, 11038758, "soviet", 2)		-- player2 is always the AI opponent
end

function OnGameRestore()
	-- function takes care of restoring all global mission parameters after a save/load
	player1 = World_GetPlayerAt(1)
	player2 = World_GetPlayerAt(2)
	Game_DefaultGameRestore()
end

function NIS_Init()
	NISOpening = "ToW\\Challenges\\Officer_Assassination\\nis\\intro" 
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
	
end

Scar_AddInit(OnInit)

function Mission_Debug()
	g_debug = Misc_IsCommandLineOptionSet("debug")
end

function Mission_Restrictions()
	ToW_SetUpTechTreeByYear (player1, 1941)
	ToW_SetUpTechTreeByYear (player2, 1941)

	-- Enable longer Soviet grenade timers
	Player_CompleteUpgrade(player2, BP_GetUpgradeBlueprint("soviet_grenades_long_timer"))
	Modify_ProjectileDelayTime (player2, BP_GetEntityBlueprint("rg_42_longtimer"), CAMPAIGN_PGREN_BUNDLED_TIMER)
	-- No flammpanzers for the halftracks
	Player_SetUpgradeAvailability(player1,UPG.GERMAN.SDKFZ_251_HALFTRACK_FLAMMPANZERWAGEN_UPGRADE,ITEM_REMOVED)
	-- Battle Phase 2 to allow PG upgrades
	Player_CompleteUpgrade(player1, BP_GetUpgradeBlueprint("battle_phase_2"))
	-- No resource trickle for the German player
	Modify_PlayerResourceRate(player1, RT_Manpower, 0, MUT_Multiplication)
	Modify_PlayerResourceRate(player1, RT_Munition, 0, MUT_Multiplication)
	Modify_PlayerResourceRate(player1, RT_Fuel, 	0, MUT_Multiplication)
	-- Increased Munitions for the Soviet player
	Modify_PlayerResourceRate(player2, RT_Munition, 7.5, MUT_Multiplication)

end

function Mission_Difficulty()
	
	-- get the difficulty
	g_difficulty = Game_GetSPDifficulty()  -- set a global difficulty variable 
	_ToWDebugDisplay("********* DIFFICULTY: "..g_difficulty, "white")
	
	local reinforcementsByDiff = {
		{
			SBP.GERMAN.SNIPER_SQUAD,
			SBP.GERMAN.PANZER_GRENADIER_SQUAD,
			SBP.GERMAN.PANZER_GRENADIER_SQUAD,
			SBP.GERMAN.SDKFZ_251_HALFTRACK_SQUAD,
		},
		{
			SBP.GERMAN.PANZER_GRENADIER_SQUAD,
			SBP.GERMAN.PANZER_GRENADIER_SQUAD,
			SBP.GERMAN.SDKFZ_251_HALFTRACK_SQUAD,
		},
		{
			SBP.GERMAN.PANZER_GRENADIER_SQUAD,
			SBP.GERMAN.SDKFZ_251_HALFTRACK_SQUAD,
		},
		{
			SBP.GERMAN.PANZER_GRENADIER_SQUAD,
		},
	}
	
	local escalationByDiff1 = {
		{
			SBP.SOVIET.GUARDS_TROOPS,
		},
		{
			SBP.SOVIET.M3A1_SCOUT_CAR_SQUAD,
		},
		{
			SBP.SOVIET.M3A1_SCOUT_CAR_SQUAD,
		},
		{
			SBP.SOVIET.T_70M,
		},
	}
	
	local escalationByDiff2 = {
		{
			SBP.SOVIET.GUARDS_TROOPS,
		},
		{
			SBP.SOVIET.M3A1_SCOUT_CAR_SQUAD,
		},
		{
			SBP.SOVIET.T_70M,
		},
		{
			SBP.SOVIET.T_70M,
		},
	}
	
	local escalationByDiff3 = {
		{
		},
		{
			SBP.SOVIET.SNIPER_TEAM,
		},
		{
			SBP.SOVIET.SNIPER_TEAM,
			SBP.SOVIET.SNIPER_TEAM,
		},
		{
			SBP.SOVIET.SNIPER_TEAM,
			SBP.SOVIET.SNIPER_TEAM,
		},
	}
	
	local escalationByDiff4 = {
		{
			SBP.SOVIET.T_70M,
		},
		{
			SBP.SOVIET.T_70M,
		},
		{
			SBP.SOVIET.T_34_76_SQUAD,
		},
		{
			SBP.SOVIET.KV_1,
		},
	}
	
	local enc7supportByDiff = {
		SBP.SOVIET.M1910_MAXIM_HEAVY_MACHINE_GUN_SQUAD,
		BP_GetSquadBlueprint("dshk_38_hmg_squad"),
		SBP.SOVIET.HM_120_38_MORTAR_SQUAD,
		SBP.SOVIET.HM_120_38_MORTAR_SQUAD,
	}
	
	t_difficulty = {
		reinforcements					= Util_DifVar(reinforcementsByDiff,	g_difficulty),
		escalationUnits1				= Util_DifVar(escalationByDiff1, 	g_difficulty),
		escalationUnits2				= Util_DifVar(escalationByDiff2, 	g_difficulty),
		escalationUnits3				= Util_DifVar(escalationByDiff3, 	g_difficulty),
		escalationUnits4				= Util_DifVar(escalationByDiff4, 	g_difficulty),
		enc7support						= Util_DifVar(enc7supportByDiff, 	g_difficulty),
		mortarReactionChance			= Util_DifVar({20, 60, 100, 100}),
	}

end

-------------------------------------------------------------------------
-- MISSION Preset 
-------------------------------------------------------------------------

function Mission_MissionPreset()
	local data = 	{	
		retaliateAttacks = false,
		pickupWeapons = false,
	}
	AIDefendGoal_SetOverrideGoalData(data)  

	-- MISC VARIABLES
	g_bronze = 2 -- this is used as the first threshold for reinforcments
	g_silver = 4
	g_gold = 6
	
	g_officersKilled = 0
	-- for use in bombing run in encounter 9
	g_enc09BombTime = 0

	-- constant to easily update the sbp for the target officers
	g_SovietOfficerSquad = SBP.SOVIET.SOVIET_OFFICER_SQUAD

	-- master table to store encounter data, so we can easily access it later
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

	t_guards = {}

	-- PLAYER STARTING UNITS AND GROUPS (most are pre-placed on the map)
	eg_bunker = EGroup_CreateIfNotFound("eg_bunker")
	sg_player_mortar = SGroup_CreateIfNotFound("sg_player_mortar")

	if g_difficulty == GD_EASY then
		Util_CreateEntities(player1, eg_bunker, EBP.GERMAN.BUNKER, mkr_player_bunker, 1)
		Cmd_InstantUpgrade(eg_bunker, UPG.GERMAN.BUNKER_MEDIC_STATION)
	end
	
	-- ENEMY STARTING UNITS AND GROUPS
	sg_allOfficers = SGroup_CreateIfNotFound("sg_allOfficers")
	sg_enemy_scout_car_1 = SGroup_CreateIfNotFound("sg_enemy_scout_car_1")
	sg_enemy_scout_car_2 = SGroup_CreateIfNotFound("sg_enemy_scout_car_2")
	sg_enemy_sniper_team = SGroup_CreateIfNotFound("sg_enemy_sniper_team")
	sg_enemy_t70 = SGroup_CreateIfNotFound("sg_enemy_t70")
	

	-- SET UP FOR AT GUARDS TROOPS

	SetupGuards()	
	SetupEncounters()
	
	Event_Timer (SetupAchievements, nil, 1)

	-- Beginner Hints
	BeginnerHint_AddOpportunity (eg_supply_drops, HINT_PICKUP, true, 11046241)
	
	-- START INTRO
	if g_debug == true then
		DEBUG_Beat_Selection_01()
	else
		startIntro()
	end
	
end

-------------------------------------------------------------------------
-- MISSION START 
-------------------------------------------------------------------------

function Mission_MissionStart()

	UI_SetCPMeterVisibility(false)
	Cmd_Ability(sg_player_snipers, BP_GetAbilityBlueprint("sniper_hold_fire"))
	
	if not Objective_IsStarted(OBJ_Main) then
		Objective_Start(OBJ_Main)
	
		local goalData = {
			name = "Defend",
			target = mkr_O1_space,
			range = 45,
			leashRange = mkr_O1_space,
			useSkirmishAI = true,
			coordinatedSetupFacingPositions	= { mkr_O1_facing },
		}
		
		t_encounters[1].guards:SetGoal (goalData)
		Event_Timer (StartSilver, nil, 5)
	
	end
end

function StartSilver(data)
	Objective_Start(OBJ_Silver)
end




function Initialize_Objectives()

	OBJ_Main = {
		
		SetupUI = function() 
		end,
		
		OnStart = function()
			Rule_AddInterval(checkFail, 1)
			for k,v in pairs (t_encounters.subset) do
				t_encounters[v].uiCheck = uiChecker(v)
			end
			objUI_0 = Objective_AddPing(OBJ_Main, mkr_O1_0)
			SupplyHint()
		end,
		
		OnComplete = function()
		end,
		
		OnFail = function()
		end,
		
		Intel_Start = nil,				-- Event will play when obj starts but before any UI appears
		Intel_Complete = nil,			-- Event will play when obj completes but before UI is cleared
		Intel_Fail = nil,				-- Event will play when obj fails but before UI is cleared
		Title = 11038802,  -- LOCDB [11038802] 'Assassinate the Soviet Officers.'
		Description = 0,				-- Objective Description
		Type = OT_Primary,				-- Objective Type (OT_Primary, OT_Secondary, OT_Medal)

	}
	
	
	OBJ_Silver = {
		Parent = OBJ_Main,
		SetupUI = function() 
			Objective_SetCounter(OBJ_Silver, 0, g_silver)
		end,
		
		OnStart = function()
		end,
		
		OnComplete = function()
			Rule_AddInterval(StartGold,1)
		end,
		
		OnFail = function()
			Mission_MissionComplete()
		end,
		
		Intel_Start = nil,				-- Event will play when obj starts but before any UI appears
		Intel_Complete = nil,			-- Event will play when obj completes but before UI is cleared
		Intel_Fail = nil,				-- Event will play when obj fails but before UI is cleared
		Title = Loc_FormatText(11047612,Loc_ConvertNumber(g_silver)),				-- LOCDB [11038801] '%1LEVEL%: Assassinate %2NUMBER% Soviet officers.'
		Description = 0,			-- Objective Description
		Type = OT_Secondary,				-- Objective Type (OT_Primary, OT_Secondary)
	}
	
	OBJ_Gold = {
		SetupUI = function() 
			Objective_SetCounter(OBJ_Gold, g_officersKilled - g_silver, g_gold - g_silver)
		end,
		
		OnStart = function()
			if g_officersKilled >= g_gold then
				Objective_Complete(OBJ_Gold)
			end
		end,
		
		OnComplete = function()
			Achieve ("tow_officer_assassination_gold_assassin")
			Mission_MissionComplete()
		end,
		
		OnFail = function()
			Mission_MissionComplete()
		end,
		
		Intel_Start = EVENTS.Bonus,				-- Event will play when obj starts but before any UI appears
		Intel_Complete = nil,			-- Event will play when obj completes but before UI is cleared
		Intel_Fail = nil,				-- Event will play when obj fails but before UI is cleared
		Title = Loc_FormatText(11038801,11047614,Loc_ConvertNumber(g_gold - g_silver)),				-- LOCDB [11038801] '%1LEVEL%: Assassinate %2NUMBER% Soviet officers.'
		Description = 0,			-- Objective Description
		Type = OT_Secondary,				-- Objective Type (OT_Primary, OT_Secondary)
	}
	
	Objective_Register(OBJ_Main)
	Objective_Register(OBJ_Silver)
	Objective_Register(OBJ_Gold)

end
function StartGold()
	if not Event_IsAnyRunning() then
		Rule_RemoveMe()
		Objective_Start(OBJ_Gold)
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
	
		startIntro()

	elseif button == DB_Button2 then
	Cmd_Move(sg_player_sniper_01, mkr_player_spawn_4)
	Cmd_Move(sg_player_sniper_02, mkr_player_spawn_1)
	Cmd_Move(sg_player_panzergrenadiers_01, mkr_player_spawn_0)
	Cmd_Move(sg_player_panzergrenadiers_02, mkr_player_spawn_2)
	
		Initialize_Objectives()
		Mission_MissionStart()

	elseif button == DB_Button3 then
	
		_ToWDebugDisplay("No mission!", "gold")
		
	end

		
end

function startIntro()

	Camera_SetInputEnabled(false)
	Game_Letterbox(true, 2)
	UI_SetForceShowSubtitles(true)
	FOW_RevealArea(Marker_GetPosition(mkr_O1_space), 35, -1)
	FOW_RevealArea(Marker_GetPosition(mkr_player_spawn_waypoint_2), 30, -1)
	SGroup_SetAnimatorState(sg_enemy_officer_1, "m01_commissarspeech", "speech")
	
	Cmd_Move(sg_player_sniper_01, mkr_player_spawn_4)
	Cmd_Move(sg_player_sniper_02, mkr_player_spawn_1)
	Cmd_Move(sg_player_panzergrenadiers_01, mkr_player_spawn_0)
	Cmd_Move(sg_player_panzergrenadiers_02, mkr_player_spawn_2)
	
	
	Util_StartIntel(EVENTS.Intro)
	
end



function introReturn()
	Game_Letterbox(false, 2)
	FOW_UnRevealArea(Marker_GetPosition(mkr_O1_space), 35)
	Camera_SetInputEnabled(true)
	SGroup_SetAnimatorState(sg_enemy_officer_1, "m01_commissarspeech", "not_speech")
	Initialize_Objectives()
	Mission_MissionStart()
end

--=====================================================================================================--
--======================================== Mission Complete ===========================================--
--=====================================================================================================--

function Mission_MissionComplete()
	Game_SetMode(UI_Cinematic)
	Camera_MoveTo(mkr_O1_space, true, 0.05)
	if Objective_IsComplete(OBJ_Silver) then
		Util_StartIntel(EVENTS.VPVictoryMessage)
	end
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


--------------------------------------------------------------------------------------------
--------------------------------- ENCOUNTER SETUP FUNCTIONS
--------------------------------------------------------------------------------------------

function SetupGuards()

	sg_enemy_at_1 = SGroup_CreateIfNotFound("sg_enemy_at_1")
	sg_enemy_at_2 = SGroup_CreateIfNotFound("sg_enemy_at_2")
	sg_enemy_at_3 = SGroup_CreateIfNotFound("sg_enemy_at_3")
	sg_enemy_at_4 = SGroup_CreateIfNotFound("sg_enemy_at_4")
	sg_enemy_at_5 = SGroup_CreateIfNotFound("sg_enemy_at_5")
	sg_enemy_at_6 = SGroup_CreateIfNotFound("sg_enemy_at_6")
	sg_enemy_at_7 = SGroup_CreateIfNotFound("sg_enemy_at_7")
	sg_enemy_at_8 = SGroup_CreateIfNotFound("sg_enemy_at_8")
	sg_enemy_at_9 = SGroup_CreateIfNotFound("sg_enemy_at_9")
	sg_enemy_at_10 = SGroup_CreateIfNotFound("sg_enemy_at_10")
	
	sg_enemy_cache_1 = SGroup_CreateIfNotFound("sg_enemy_cache_1")
	sg_enemy_cache_2 = SGroup_CreateIfNotFound("sg_enemy_cache_2")

	-- ROTATING GUARDS (1 THRU 9)
	for i=1,9 do
	
		table.insert(t_guards, i, {})
		
		local encData = {
			player = player2,
			sgroups = {SGroup_CreateIfNotFound("sg_enemy_at_" .. i)},
			units = {
				{
					name = "AT",
					sbp = SBP.SOVIET.GUARDS_TROOPS,
					spawn = Marker_FromName(("mkr_AT" .. i),""),
					dropItems = {
						{
							slotItem = SLOT_ITEM.PTRS_41_ANTI_TANK_RIFLE_GUARD_TROOP,
							dropChance = 1,
							exclusive = true,
						},
					},
				},
			},
		}
		
		if (i == 2) or (i == 4) or (i == 6) or (i == 8) or g_difficulty >= GD_HARD then
			encData.units[1].slotItems = { SLOT_ITEM.PTRS_41_ANTI_TANK_RIFLE_GUARD_TROOP, }
		end
		
		if g_difficulty < GD_HARD then
			encData.units[1].load = 4
		end
		
		t_guards[i] = Encounter:Create(encData)
		
		local goalData = {
			name = "Defend",
			target = Marker_FromName(("mkr_AT" .. i),""),
			useSkirmishAI = true,
			tacticControlsList = {
				{
				tacticType = TACTIC_Pickup,
				priority = -1,
				},
			},
		}
		t_guards[i]:SetGoal(goalData)
	
		Event_IsUnderAttack(SniperMortarReaction, {react = {"relocate","relocate","frag"},enc=t_guards[i],}, SGroup_FromName("sg_enemy_at_" .. i), ANY, 1)
		
		Event_Timer(RotateGuard, {enc=t_guards[i], index = i}, World_GetRand(120,180))
		
	end

	-- FIXED MORTAR POSITION AT_10
	local encData = {
		name = "Mortar",
		player = player2,
		sgroups = {sg_enemy_at_10},
		units = {
			{
				sbp = SBP.SOVIET.HM_120_38_MORTAR_SQUAD,
				spawn = mkr_AT10,
			},
		},
		onDeath = nil,
	}
	
	local goalData = {
		name = "Defend",
		target = mkr_AT10,
		useSkirmishAI = true,
	}
	
	t_guards.mortar = Encounter:Create(encData)
	t_guards.mortar:SetGoal(goalData)
	
	Event_IsDoingAttack(AddThreat, nil, sg_enemy_at_10, ANY, 1)
	Event_IsUnderAttack (SniperMortarReaction, {react={"barrage","relocate"},enc=t_guards.mortar}, sg_enemy_at_10, ANY, 1)
	
	
	-- GUARDS NEAR THE SUPPLY CACHES
	local encData = {
		name = "Cache1",
		player = player2,
		sgroups = {sg_enemy_cache_1},
		units = {
			{
				sbp = SBP.SOVIET.GUARDS_TROOPS,
				upgrades = {BP_GetUpgradeBlueprint("guard_dp-28_lmg_package")},
				spawn = eg_supplyCacheHouse01,
			},
		},
		onDeath = nil,
	}
	t_guards.cache1 = Encounter:Create(encData)
	
	local goalData = {
		name = "Defend",
		target = eg_supplyCacheHouse01,
		garrison = true,
		garrisonIdle = true,
		useSkirmishAI = true,
	}
	t_guards.cache1:SetGoal(goalData)
	
	local encData = {
		name = "Cache2",
		player = player2,
		sgroups = {sg_enemy_cache_2},
		units = {
			{
				sbp = SBP.SOVIET.GUARDS_TROOPS,
				upgrades = {BP_GetUpgradeBlueprint("guard_dp-28_lmg_package")},
				spawn = eg_supplyCacheHouse02,
			},
		},
		onDeath = nil,
	}
	t_guards.cache2 = Encounter:Create(encData)
	
	local goalData = {
		name = "Defend",
		target = eg_supplyCacheHouse02,
		garrison = true,
		garrisonIdle = true,
		useSkirmishAI = true,
	}
	t_guards.cache2:SetGoal(goalData)
end

-- Function called at mission start to set up the the officer encounters
function SetupEncounters()
	local encData = {}
	local goalData = {}
	local maxEntries = 6 -- this is the number of encounters that will populate
	local str = "" -- string used in debug display of encounters

	-- this is the table of the encounters that will spawn (selected from the nine possibles)
	-- we always want encounter 1 to be part of the subset, so we prepopulate it
	t_encounters.subset = {1,}

	-- area to add any debug behavior, such as force populating certain encounters for testing
	if g_debug == true then
	end
	
	-- we now populate the subset with a random selection of encounters
	while #t_encounters.subset < maxEntries do
		-- get a random number
		local n = World_GetRand(1,9)
		local isDupe = false
		-- run a check to see if we've already selected this number before
		for k,v in pairs (t_encounters.subset) do
			if v == n then
				isDupe = true
			end
		end
		-- if we haven't, then add the number to the subset
		if isDupe == false then
			table.insert(t_encounters.subset, n)
		end
	end
	
	-- now we iterate through the subset, populating the corresponding encounters
	for k,v in pairs (t_encounters.subset) do
		if v == 1 then
			SetupEncounter1()
		elseif v == 2 then
			SetupEncounter2()
		elseif v == 3 then
			SetupEncounter3()
		elseif v == 4 then
			SetupEncounter4()
		elseif v == 5 then
			SetupEncounter5()
		elseif v == 6 then
			SetupEncounter6()
		elseif v == 7 then
			SetupEncounter7()
		elseif v == 8 then
			SetupEncounter8()
		elseif v == 9 then
			SetupEncounter9()
		end
		-- in debug we expose which encounters have been selected, starting with a title and then the debug string
		str = str .. " " .. v -- add the encounter number to the debug string
		_ToWDebugDisplay("MISSION SPAWNING OFFICERS: " .. str, "cyan", 2) 
	end
end


--------------------------- ENCOUNTER 1 -------------------------------------
----- Dshk HMG as guard
----- Road guards Conscripts may retreat here 
----- At first, this encounter's squads have very tight leashes and ranges to keep them in position for the tutorial
function SetupEncounter1()
	sg_enemy_officer_1 = SGroup_CreateIfNotFound("sg_enemy_officer_1")	
	sg_enemy_atk1 = SGroup_CreateIfNotFound("sg_enemy_atk1")
	sg_roadGuard = SGroup_CreateIfNotFound("sg_roadGuard")

	local encData = {
		name = "Encounter1Officer",
		player = player2,
		sgroups = {sg_enemy_officer_1,sg_allOfficers},
		units = {
			{
				spawn = mkr_O1_0,
				sbp = g_SovietOfficerSquad,
				dropItems = {
					{
						slotItem = SLOT_ITEM.PTRS_41_ANTI_TANK_RIFLE_GUARD_TROOP,
						dropChance = 1,
						exclusive = true,
					},
				}
			},
		},
		onDeath = NextOfficer,
	}
	
	local goalData = {
		name = "Defend",
		target = mkr_O1_space,
		range = 45,
		leashRange = mkr_O1_space,
		useSkirmishAI = true,
		coordinatedSetupFacingPositions	= { mkr_O1_facing },
		tacticControlsList = {
			{
			tacticType = TACTIC_Cover,
			priority = 1000,
			},
		},
	}
	t_encounters[1].officer = Encounter:Create(encData)
	t_encounters[1].officer:SetGoal (goalData)
	
	encData = {
		name = "Encounter1Guards",
		player = player2,
		sgroups = {sg_enemy_atk1},
		units = {
			{
				sbp = BP_GetSquadBlueprint("dshk_38_hmg_squad"),
				spawn = mkr_O1_1,
			},
		},
		onDeath = nil,
	}
	t_encounters[1].guards = Encounter:Create(encData)
	t_encounters[1].retreatMarker = mkr_escalation_02
	
	Event_IsUnderAttack(SniperMortarReaction, {react = "relocate",enc=t_encounters[1].guards,}, sg_enemy_atk1, ANY, 1)
	
	-- guards along the approach road who retreat to officer position 1
	local encData = {
		name = "Road Guard",
		player = player2,
		spawn = mkr_roadGuard,
		sgroups = {sg_roadGuard},
		units = {
			{
				sbp = SBP.SOVIET.CONSCRIPT_SQUAD,
				dropItems = {
					{
						slotItem = SLOT_ITEM.PTRS_41_ANTI_TANK_RIFLE_GUARD_TROOP,
						dropChance = 1,
						exclusive = true,
					},
				},
			},
		},
		onDeath = nil,
	}
	t_encounters[1].roadGuard = Encounter:Create(encData)
	
	local goalData = {
		name = "Defend",
		target = mkr_roadGuard,
		useSkirmishAI = true,
		fallback = true,
		fallbackParams = {
			thresholds = {0.75},
			thresholdType = Threshold_PercentageEntitiesRemaining,
			markers = {mkr_O1_2},
			retreat = true,
			retreatDespawn = false,
		},
		
	}
	
	t_encounters[1].roadGuard:SetGoal(goalData)
	Event_IsUnderAttack(SniperMortarReaction, {react = "relocate",enc=t_encounters[1].roadGuard,}, sg_roadGuard, ANY, 1)
end

--------------------------- ENCOUNTER 2 -------------------------------------
--- 1 squad of conscripts and 1 garrisoned sniper team as guards; officer in scout car

function SetupEncounter2()

	sg_enemy_officer_2 = SGroup_CreateIfNotFound("sg_enemy_officer_2")	
	sg_enemy_atk2 = SGroup_CreateIfNotFound("sg_enemy_atk2")
	sg_enemy_sniper2 = SGroup_CreateIfNotFound("sg_enemy_sniper2")
	sg_O2_m3a1 = SGroup_CreateIfNotFound("sg_O2_m3a1")

	local encData = {
		name = "Encounter2Car",
		player = player2,
		sgroups = {sg_O2_m3a1,},
		units = {
			{
			spawn = mkr_O2_2,
			sbp = SBP.SOVIET.M3A1_SCOUT_CAR_SQUAD,
			sgroups = {},
			},
		},
		onDeath = nil,
	}
	local goalData = {
		name = "Defend",
		target = mkr_O2_space,
		range = mkr_O2_space,
		tacticTargetPreference = AITacticTargetPreference_Near,
		useSkirmishAI = true,
		garrison = true,
		tacticControlsList = {
			{
			tacticType = TACTIC_Hold,
			priority = 1000,
			},
		},
	}
	t_encounters[2].officerCar = Encounter:Create(encData)
	t_encounters[2].officerCar:SetGoal (goalData)
	
	Event_Timer(SpawnOfficerInCar, {index = 2, car = sg_O2_m3a1, goal = goalData}, 0.25)
	
	encData = {
		name = "Encounter2Guards",
		player = player2,
		sgroups = {sg_enemy_atk2},
		units = {
			{
			sbp = SBP.SOVIET.CONSCRIPT_SQUAD,
			spawn = mkr_O2_1,
			},
		},
		onDeath = nil,
	}
	
	goalData = {
		name = "Defend",
		target = mkr_O2_space,
		range = mkr_O2_space,
		useSkirmishAI = true,
	}
	
	t_encounters[2].guards = Encounter:Create(encData)
	t_encounters[2].guards:SetGoal (goalData)
            
	Event_IsUnderAttack(SniperMortarReaction, {react = "relocate",enc=t_encounters[2].guards,}, sg_enemy_atk2, ANY, 1)
	
	encData = {
		name = "Encounter2Snipers",
		player = player2,
		sgroups = {sg_enemy_sniper2},
		units = {
			{
			sbp = SBP.SOVIET.SNIPER_TEAM,
			spawn = mkr_O2_2,
			},
		},
		onDeath = nil,
	}
	
	goalData = {
		name = "Defend",
		target = mkr_O2_space,
		range = mkr_O2_space,
		tacticTargetPreference = AITacticTargetPreference_HighDamage,
		useSkirmishAI = true,
		garrisonIdle = true,
		garrison = true,
	}
	
	t_encounters[2].snipers = Encounter:Create(encData)
	t_encounters[2].snipers:SetGoal (goalData)
            
	t_encounters[2].retreatMarker = mkr_escalation_03

end

--------------------------- ENCOUNTER 3 -------------------------------------
--- one conscript squad and one Guards squad (with LMG)
----

function SetupEncounter3()

	sg_enemy_officer_3 = SGroup_CreateIfNotFound("sg_enemy_officer_3")	
	sg_enemy_atk3 = SGroup_CreateIfNotFound("sg_enemy_atk3")

	local encData = {
		name = "Encounter3Officer",
		player = player2,
		spawn = mkr_O3_0,
		sgroups = {sg_enemy_officer_3,sg_allOfficers},
		units = {
			{
			spawn = mkr_O3_0,
			sbp = g_SovietOfficerSquad,
			},
		},
		onDeath = NextOfficer,
	}
	
	local goalData = {
		name = "Defend",
		target = mkr_O3_space,
		range = mkr_O3_space,
		useSkirmishAI = true,
		leashRange = 15,
		tacticControlsList = {
			{
			tacticType = TACTIC_Cover,
			priority = 1000,
			},
		},
	}
		
t_encounters[3].officer = Encounter:Create(encData)
t_encounters[3].officer:SetGoal (goalData)
	         
	encData = {
		name = "Encounter3Guards",
		player = player2,
		sgroups = {sg_enemy_atk3},
		units = {
			{
			sbp = SBP.SOVIET.CONSCRIPT_SQUAD,
			spawn = mkr_O3_1,
			},
			{
			sbp = SBP.SOVIET.GUARDS_TROOPS,
			upgrades = {BP_GetUpgradeBlueprint("guard_dp-28_lmg_package")},
			spawn = mkr_O3_2,
			},
		},
		onDeath = nil,
	}
	
	goalData = {
		name = "Defend",
		target = mkr_O3_space,
		range = mkr_O3_space,
		tacticTargetPreference = AITacticTargetPreference_Near,
		useSkirmishAI = true,
		leashRange = 15,
	}

	t_encounters[3].guards = Encounter:Create(encData)
	t_encounters[3].guards:SetGoal (goalData)

	t_encounters[3].retreatMarker = mkr_escalation_02
	Event_IsUnderAttack(SniperMortarReaction, {react = "relocate",enc=t_encounters[3].guards,}, sg_enemy_atk3, ANY, 1)
end

--------------------------- ENCOUNTER 4 -------------------------------------
--- one conscript squad and one Dushka HMG (set up facing the main entry)
--- officer in scout car

function SetupEncounter4()

	sg_enemy_officer_4 = SGroup_CreateIfNotFound("sg_enemy_officer_4")	
	sg_enemy_atk4 = SGroup_CreateIfNotFound("sg_enemy_atk4")
	sg_O4_m3a1 = SGroup_CreateIfNotFound("sg_O4_m3a1")
	
	local encData = {
		name = "Encounter4OfficerCar",
		player = player2,
		spawn = mkr_O4_0,
		sgroups = {sg_O4_m3a1,},
		units = {
			{
			spawn = mkr_O4_2,
			sbp = SBP.SOVIET.M3A1_SCOUT_CAR_SQUAD,
			},
		},
		onDeath = nil,
	}

	local goalData = {
		name = "Defend",
		target = mkr_O4_space,
		range = mkr_O4_space,
			useSkirmishAI = true,
	}
		
	t_encounters[4].officerCar = Encounter:Create(encData)
	t_encounters[4].officerCar:SetGoal (goalData)
	
	Event_Timer(SpawnOfficerInCar, {index = 4, car = sg_O4_m3a1, goal = goalData}, 0.25)
				
	encData = {
		name = "Encounter4Guards",
		player = player2,
		sgroups = {sg_enemy_atk4,},
		units = {
			{
				sbp = BP_GetSquadBlueprint("dshk_38_hmg_squad"),
				spawn = mkr_O4_0,
			},
			{
				sbp = SBP.SOVIET.CONSCRIPT_SQUAD,
				spawn = mkr_O4_1,
			},
		},
		onDeath = nil,
	}
	
	goalData = {
		name = "Defend",
		target = mkr_O4_space,
		range = mkr_O4_space,
		tacticTargetPreference = AITacticTargetPreference_Near,
		useSkirmishAI = true,
		coordinatedSetupFacingPositions = { mkr_O4_1, mkr_O4_1},
		tacticControlsList = {
			{
				tacticType = TACTIC_CaptureTeamWeapon,
				priority = 200,
			},
		},
		leashRange = mkr_O4_space,
	}

	t_encounters[4].guards = Encounter:Create(encData)
	t_encounters[4].guards:SetGoal (goalData)
	t_encounters[4].retreatMarker = mkr_escalation_04
	Event_IsUnderAttack(SniperMortarReaction, {react = "relocate",enc=t_encounters[4].guards,}, sg_enemy_atk4, ANY, 1)
end

--------------------------- ENCOUNTER 5 -------------------------------------
--- Two conscript squads (one with an LMG) who garrison a buildings. The officer will garrison once combat starts.
---

function SetupEncounter5()

	sg_enemy_officer_5 = SGroup_CreateIfNotFound("sg_enemy_officer_5")	
	sg_enemy_atk5 = SGroup_CreateIfNotFound("sg_enemy_atk5")

	local encData = {
		name = "Encounter5Officer",
		player = player2,
		sgroups = {sg_enemy_officer_5,sg_allOfficers},
		units = {
			{
			spawn = mkr_O5_0,
			sbp = g_SovietOfficerSquad,
			},
		},
		onDeath = NextOfficer,
	}

	local goalData = {
		name = "Defend",
		target = mkr_O5_space,
		range = mkr_O5_space,
		useSkirmishAI = true,
		garrison = true,
		leashRange = 15,
		tacticControlsList = {
			{
			tacticType = TACTIC_Hold,
			priority = 1000,
			},
		},
	}
		
	t_encounters[5].officer = Encounter:Create(encData)
	t_encounters[5].officer:SetGoal (goalData)
	
	encData = {
		name = "Encounter5Guards",
		player = player2,
		sgroups = {sg_enemy_atk5},
		units = {
			{
			sbp = SBP.SOVIET.CONSCRIPT_SQUAD,
			spawn = mkr_O5_1,
			},
			{
			sbp = SBP.SOVIET.CONSCRIPT_SQUAD,
			spawn = mkr_O5_2,
			slotItems = {BP_GetSlotItemBlueprint("dp-28_light_machine_gun_package")},
			},
		},
		onDeath = nil,
	}
	
	goalData = {
		name = "Defend",
		target = mkr_O5_space,
		range = mkr_O5_space,
		tacticTargetPreference = AITacticTargetPreference_Near,
		useSkirmishAI = true,
		garrison = true,
		garrisonIdle = true,
	}
	
	t_encounters[5].guards = Encounter:Create(encData)
	t_encounters[5].guards:SetGoal (goalData)

	t_encounters[5].retreatMarker = mkr_escalation_04
	Event_IsUnderAttack(SniperMortarReaction, {react = "relocate",enc=t_encounters[5].guards,}, sg_enemy_atk5, ANY, 1)
end

--------------------------- ENCOUNTER 6 -------------------------------------
-- Three squads of shock troopers will counter attack once combat starts.
-- Officer in car
function SetupEncounter6()

	sg_enemy_officer_6 = SGroup_CreateIfNotFound("sg_enemy_officer_6")	
	sg_enemy_atk6 = SGroup_CreateIfNotFound("sg_enemy_atk6")
	sg_O6_m3a1 = SGroup_CreateIfNotFound("sg_O6_m3a1")
	sg_enc06_all = SGroup_CreateIfNotFound("sg_enc06_all")
	sg_counter_attack6 = SGroup_CreateIfNotFound("sg_counter_attack6")

	local encData = {
		name = "Encounter6OfficerCar",
		player = player2,
		spawn = mkr_O6_0,
		sgroups = {sg_O6_m3a1,sg_enc06_all},
		units = {
			{
			spawn = mkr_O6_0,
			sbp = SBP.SOVIET.M3A1_SCOUT_CAR_SQUAD,
			},
		},
		onDeath = nil,
	}

	local goalData = {
		name = "Defend",
		target = mkr_O6_space,
		range = mkr_O6_space,
		useSkirmishAI = true,
	}
	
	t_encounters[6].officerCar = Encounter:Create(encData)
	t_encounters[6].officerCar:SetGoal (goalData)
	
	Event_Timer(SpawnOfficerInCar, {index = 6, car = sg_O6_m3a1, goal = goalData}, 0.25)
	
	encData = {
		name = "Encounter6Guards",
		player = player2,
		sgroups = {sg_enemy_atk6, sg_enc06_all},
		units = {
			{
			sbp = SBP.SOVIET.CONSCRIPT_SQUAD,
			spawn = mkr_O6_1,
			slotItems = {BP_GetSlotItemBlueprint("dp-28_light_machine_gun_package")},
			},
			{
			sbp = SBP.SOVIET.CONSCRIPT_SQUAD,
			spawn = mkr_O6_2,
			},
		},
		onDeath = nil,
	}
	
	goalData = {
		name = "Defend",
		target = mkr_O6_space,
		range = mkr_O6_space,
		tacticTargetPreference = AITacticTargetPreference_Near,
		tacticCoverPriority = 2,
		useSkirmishAI = true,
		leashRange = 15,
	}
	
	t_encounters[6].guards = Encounter:Create(encData)
	t_encounters[6].guards:SetGoal (goalData)

	t_encounters[6].retreatMarker = mkr_escalation_03
	Event_IsUnderAttack(SniperMortarReaction, {react = "relocate",enc=t_encounters[6].guards,}, sg_enemy_atk6, ANY, 1)
	Event_IsUnderAttack(Enc6CounterAttack, nil, sg_enc06_all, ANY, 1)
end

-- rule that runs to trigger a counter attack on the encounter 6 area
function Enc6CounterAttack()
	-- remove the rule if the guards and officer are all already dead
	if SGroup_IsAlive(sg_enc06_all) == false then
		return
	end
	
	local encData = {
		name = "Counter Attack",
		player = player2,
		sgroups = {sg_counter_attack6},
		units = {
			{
				sbp = SBP.SOVIET.SHOCK_TROOPS,
				spawn = mkr_escalation_03,
			},
			{
				sbp = SBP.SOVIET.SHOCK_TROOPS,
				spawn = mkr_escalation_03,
			},
			{
				sbp = SBP.SOVIET.SHOCK_TROOPS,
				spawn = mkr_escalation_03,
			},
		},
		onDeath = nil,
	}
	t_encounters[6].counterAttack = Encounter:Create(encData)
	local goalData = {
		name = "Attack",
		target = mkr_O6_space,
		range = mkr_O6_space,
		useSkirmishAI = true,
		attackMove = true,
		fallback = true,
		fallbackParams = {
			thresholds = {0.4},
			thresholdType = Threshold_PercentageEntitiesRemaining,
			markers = {mkr_escalation_03},
			retreat = true,
			retreatDespawn = true,
		},
	}
	t_encounters[6].counterAttack:SetGoal(goalData)
	Util_StartIntel(EVENTS.enc6CounterAttack)
	
end

--------------------------- ENCOUNTER 7 -------------------------------------
-- Heavily defended position with shock troops, a mortar team, and engineers who lay mines.
function SetupEncounter7()

	sg_enemy_officer_7 = SGroup_CreateIfNotFound("sg_enemy_officer_7")	
	sg_enemy_atk7 = SGroup_CreateIfNotFound("sg_enemy_atk7")
	sg_enemy_eng7 = SGroup_CreateIfNotFound("sg_enemy_eng7")
	sg_enemy_support7 = SGroup_CreateIfNotFound("sg_enemy_support7")
	sg_enc07_shock1 = SGroup_CreateIfNotFound("sg_enc07_shock1")
	sg_enc07_shock2 = SGroup_CreateIfNotFound("sg_enc07_shock2")

	local encData = {
		name = "Encounter7Officer",
		player = player2,
		spawn = mkr_O7_0,
		sgroups = {sg_enemy_officer_7,sg_allOfficers},
		units = {
			{
			spawn = mkr_O7_0,
			sbp = g_SovietOfficerSquad,
			},
		},
		onDeath = NextOfficer,
	}

	local goalData = {
		name = "Defend",
		target = mkr_O7_space,
		range = mkr_O7_space,
		useSkirmishAI = true,
		leashRange = 15,
		tacticControlsList = {
			{
			tacticType = TACTIC_Cover,
			priority = 1000,
			},
		},
	}
		
	t_encounters[7].officer = Encounter:Create(encData)
	t_encounters[7].officer:SetGoal (goalData)

	encData = {
		name = "Encounter7Guards",
		player = player2,
		sgroups = {sg_enemy_atk7},
		units = {
			{
			sbp = SBP.SOVIET.SHOCK_TROOPS,
			spawn = mkr_O7_1,
			sgroups = {sg_enc07_shock1},
			},
			{
			sbp = SBP.SOVIET.SHOCK_TROOPS,
			spawn = mkr_O7_2,
			sgroups = {sg_enc07_shock2},
			},
		},
		onDeath = nil,
	}
	
	goalData = {
		name = "Defend",
		target = mkr_O7_space,
		range = mkr_O7_space,
		tacticTargetPreference = AITacticTargetPreference_Near,
		useSkirmishAI = true,
		tacticControlsList = {
			{
			tacticType = TACTIC_RushAtTarget,
			priority = 500,
			},
			{
			tacticType = TACTIC_CaptureTeamWeapon,
			priority = 300,
			},
		},
	}

	t_encounters[7].guards = Encounter:Create(encData)
	t_encounters[7].guards:SetGoal (goalData)
	
	encData = {
		name = "Encounter7support",
		player = player2,
		sgroups = {sg_enemy_support7},
		units = {
			{
			sbp = t_difficulty.enc7support,
			spawn = mkr_O7_3,
			},
		},
		onDeath = nil,
	}
	
	t_encounters[7].support = Encounter:Create(encData)
	t_encounters[7].support:SetGoal (goalData)
	
	if (g_difficulty == GD_HARD) or (g_difficulty == GD_EXPERT) then
		Event_IsDoingAttack(AddThreat, nil, sg_enemy_support7, ANY, 1)
	end
	
	Event_IsUnderAttack (SniperMortarReaction, {react={"barrage","relocate"},enc=t_encounters[7].support}, sg_enemy_support7, ANY, 1)

	local data = {
		react = {"smoke","smoke","frag",},
		marker = mkr_O7_1,
		enc=t_encounters[7].guards,
		sgroup = sg_enc07_shock1,
	}
	
	local data2 = {
		react = {"smoke","smoke","frag",},
		marker = mkr_O7_2,
		enc=t_encounters[7].guards,
	}
	
	
	Event_IsUnderAttack(SniperMortarReaction, data,  sg_enc07_shock1, ANY, 1)
	Event_IsUnderAttack(SniperMortarReaction, data2, sg_enc07_shock2, ANY, 1)

	encData = {
		name = "Encounter7Engineers",
		player = player2,
		sgroups = {sg_enemy_eng7},
		units = {
			{
			sbp = SBP.SOVIET.COMBAT_ENGINEER_SQUAD,
			spawn = mkr_O7_0,
			},
		},
		onDeath = nil,
	}
	
	t_encounters[7].engineers = Encounter:Create(encData)
	t_encounters[7].engineers:SetGoal (goalData)
	
	-- This logic issues the orders to the engineers to lay mines
	local t_mines = Marker_GetSequence("mkr_O7_mines", "Camera")

	for k,v in pairs (t_mines) do
		Cmd_Construct(sg_enemy_eng7, EBP.SOVIET.SOVIET_MINE, v, nil, true)
	end
	
	t_encounters[7].retreatMarker = mkr_escalation_02
	Event_IsUnderAttack(SniperMortarReaction, {react = "relocate",enc=t_encounters[7].engineers,}, sg_enemy_eng7, ANY, 1)
	
end
--------------------------- ENCOUNTER 8 -------------------------------------
-- shock troops as guards
-- a t70 light tank will counter attack once combat starts with this encounter
-- officer in scout car
function SetupEncounter8()

	sg_enemy_officer_8 = SGroup_CreateIfNotFound("sg_enemy_officer_8")	
	sg_enemy_atk8 = SGroup_CreateIfNotFound("sg_enemy_atk8")
	sg_O8_m3a1 = SGroup_CreateIfNotFound("sg_O8_m3a1")
	sg_enc08_shock1 = SGroup_CreateIfNotFound("sg_enc08_shock1")
	sg_enc08_shock2 = SGroup_CreateIfNotFound("sg_enc08_shock2")
	sg_enc08_shock3 = SGroup_CreateIfNotFound("sg_enc08_shock3")
	sg_counter_attack8 = SGroup_CreateIfNotFound("sg_counter_attack8")
	sg_enc08_all = SGroup_CreateIfNotFound("sg_enc08_all")

	local encData = {
		name = "Encounter8OfficerCar",
		player = player2,
		sgroups = {sg_O8_m3a1,sg_enc08_all},
		units = {
			{
			spawn = mkr_O8_0,
			sbp = SBP.SOVIET.M3A1_SCOUT_CAR_SQUAD,
			},
		},
		onDeath = nil,
	}

	local goalData = {
		name = "Defend",
		target = mkr_O8_space,
		range = mkr_O8_space,
		useSkirmishAI = true,
	}
	
	t_encounters[8].officerCar = Encounter:Create(encData)
	t_encounters[8].officerCar:SetGoal (goalData)
		
	Event_Timer(SpawnOfficerInCar, {index = 8, car = sg_O8_m3a1, goal = goalData}, 0.25)
	
	encData = {
		name = "Encounter8Guards",
		player = player2,
		sgroups = {sg_enemy_atk8, sg_enc08_all},
		units = {
			{
			sbp = SBP.SOVIET.SHOCK_TROOPS,
			spawn = mkr_O8_0,
			sgroups = {sg_enc08_shock1},
			},
			{
			sbp = SBP.SOVIET.SHOCK_TROOPS,
			spawn = mkr_O8_1,
			sgroups = {sg_enc08_shock2},
			},
			{
			sbp = SBP.SOVIET.SHOCK_TROOPS,
			spawn = mkr_O8_2,
			sgroups = {sg_enc08_shock3},
			},
		},
		onDeath = nil,
	}
	
	goalData = {
		name = "Defend",
		target = mkr_O8_space,
		range = mkr_O8_space,
		useSkirmishAI = true,
		tacticControlsList = {
			{
			tacticType = TACTIC_RushAtTarget,
			priority = 1000,
			},
			{
			tacticType = TACTIC_Pickup,
			priority = -1,
			},
		},
	}

	t_encounters[8].guards = Encounter:Create(encData)
	t_encounters[8].guards:SetGoal (goalData)

	t_encounters[8].retreatMarker = mkr_escalation_01

	Event_IsUnderAttack(SniperMortarReaction, {react = {"smoke","smoke","frag",},enc=t_encounters[8].guards,}, sg_enc08_shock1, ANY, 1)
	Event_IsUnderAttack(SniperMortarReaction, {react = {"smoke","smoke","frag",},enc=t_encounters[8].guards,}, sg_enc08_shock2, ANY, 1)
	Event_IsUnderAttack(SniperMortarReaction, {react = {"smoke","smoke","frag",},enc=t_encounters[8].guards,}, sg_enc08_shock3, ANY, 1)
	Event_IsUnderAttack(Enc8CounterAttack, nil, sg_enc08_all, ANY, 1)
end

function Enc8CounterAttack()
	-- remove the rule if the guards and officer are all already dead
	if SGroup_IsAlive(sg_enc08_all) == false then
		return
	end
	
	local encData = {
		name = "Counter Attack",
		player = player2,
		sgroups = {SGroup_CreateIfNotFound("sg_counter_attack8")},
		units = {
			{
			sbp = SBP.SOVIET.T_70M,
			spawn = mkr_escalation_01,
			},
		},
		onDeath = nil,
	}
	t_encounters[8].counterAttack = Encounter:Create(encData)

	local goalData = {
		name = "Attack",
		target = mkr_O8_space,
		range = mkr_O8_space,
		useSkirmishAI = true,
		attackMove = true,
	}
	t_encounters[8].counterAttack:SetGoal(goalData)
	Util_StartIntel(EVENTS.enc8CounterAttack)
end


	--------------------------- ENCOUNTER 9 -------------------------------------
	--- penal battalion guards; 
	--- officer will call in an IL-2 bombing run on attackers once every two minutes
function SetupEncounter9()	

	sg_enemy_officer_9 = SGroup_CreateIfNotFound("sg_enemy_officer_9")
	sg_enemy_atk9 = SGroup_CreateIfNotFound("sg_enemy_atk9")

	local encData = {
		name = "Encounter9Officer",
		player = player2,
		sgroups = {sg_enemy_officer_9,sg_allOfficers},
		units = {
			{
			spawn = mkr_O9_0,
			sbp = g_SovietOfficerSquad,
			},
		},
		onDeath = NextOfficer,
	}

	local goalData = {
		name = "Defend",
		target = mkr_O9_space,
		range = mkr_O9_space,
		useSkirmishAI = true,
		leashRange = 15,
		tacticControlsList = {
			{
			tacticType = TACTIC_Cover,
			priority = 1000,
			},
		},
	}
		
	t_encounters[9].officer = Encounter:Create(encData)
	t_encounters[9].officer:SetGoal (goalData)
		
	encData = {
		name = "Encounter9Guards",
		player = player2,
		sgroups = {sg_enemy_atk9},
		units = {
			{
			sbp = SBP.SOVIET.PENAL_BATTALION,
			spawn = mkr_O9_0,
			},
			{
			sbp = SBP.SOVIET.PENAL_BATTALION,
			spawn = mkr_O9_1,
			},
			{
			sbp = SBP.SOVIET.PENAL_BATTALION,
			spawn = mkr_O9_2,
			},
		},
		tacticControlsList = {
			{
			tacticType = TACTIC_RushAtTarget,
			priority = 1000,
			},
		},
		onDeath = nil,
	}
	
	goalData = {
		name = "Defend",
		target = mkr_O9_space,
		range = mkr_O9_space,
		tacticTargetPreference = AITacticTargetPreference_Near,
		useSkirmishAI = true,
		leashRange = 15,
	}
	
	t_encounters[9].guards = Encounter:Create(encData)
	t_encounters[9].guards:SetGoal (goalData)
	
	t_encounters[9].retreatMarker = mkr_escalation_03

	Event_IsUnderAttack(SniperMortarReaction, {react = "relocate",enc=t_encounters[9].guards,}, sg_enemy_atk9, ANY, 1)
	Rule_AddInterval( Enc9BombingRun, 3) -- rule that runs for the bombing run

end


-- rule for calling in the bombing run for encounter 9
function Enc9BombingRun()
	-- remove the rule if the officer is dead
	if SGroup_IsAlive(sg_enemy_officer_9) == false then
		Rule_RemoveMe()
		return
	end
	
	-- if we've used the bombing run before, check to see if 120 seconds have elapsed; if not return
	if g_enc09BombTime > 0 then
		if World_GetGameTime() < g_enc09BombTime + 120 then
			return
		end
	end
	
	-- if timer test passes then use the ability if either guards or officer are under attack
	if SGroup_IsUnderAttack(sg_enemy_atk9, ANY, 3) or SGroup_IsUnderAttack(sg_enemy_officer_9, ANY, 3) then
		sg_temp = SGroup_CreateIfNotFound("sg_temp")
		SGroup_Clear(sg_temp)
		SGroup_AddGroup(sg_temp, sg_enemy_atk9)
		SGroup_AddGroup(sg_temp, sg_enemy_officer_9)
		sg_temp2 = SGroup_CreateIfNotFound("sg_temp2")
		SGroup_Clear(sg_temp2)
		SGroup_GetLastAttacker(sg_temp, sg_temp2)
		if SGroup_CountSpawned(sg_temp) == 0 then
			return
		end
		local pos = SGroup_GetPosition(sg_temp2)
		
		if not Player_HasAbility(player2, ABILITY.SOVIET.IL_2_BOMBING_RUN_SP) then
			Player_AddAbility(player2, ABILITY.SOVIET.IL_2_BOMBING_RUN_SP )
		end
		
		local hint = HintPoint_Add(pos, true, 11046747, 3, HPAT_Hint)
		Event_Timer(RemoveHint, {id=hint}, 10)
		Cmd_Ability(player2, ABILITY.SOVIET.IL_2_BOMBING_RUN_SP, pos, nil, true, false)
		Player_SetAbilityAvailability(player2, ABILITY.SOVIET.IL_2_BOMBING_RUN_SP, ITEM_LOCKED)
		
		Util_StartIntel(EVENTS.enc9BombingRun)
		
		SGroup_Clear(sg_temp)
		SGroup_Clear(sg_temp2)
		
		g_enc09BombTime = World_GetGameTime()
	end
end

--=====================================================================================================--
--======================================= Mission Functions  ==========================================--
--=====================================================================================================--

-- Reinforcements Given
function reinforce()
	local function CallReinforcements()
		for k,unit in pairs (t_difficulty.reinforcements) do
			if unit == SBP.GERMAN.SDKFZ_251_HALFTRACK_SQUAD then
				Util_CreateSquads (player1, sg_player_truck, unit, mkr_player_spawn_3, mkr_player_spawn_waypoint_1)
			else
				Util_CreateSquads (player1, sg_player_infantry, unit, mkr_player_spawn_3, mkr_player_spawn_waypoint_1)
			end
		end
	end

	if g_officersKilled == g_bronze then
		Util_MissionTitle(11038803)  -- LOCDB [11038803] 'Reinforcements have arrived'
		CallReinforcements()
	elseif g_officersKilled == g_silver then
		Util_MissionTitle(11038803)  -- LOCDB [11038803] 'Reinforcements have arrived'
		CallReinforcements()
	end
end

function checkFail()
	if Player_GetSquadCount(player1) <= 0 then
		if Objective_IsStarted(OBJ_Silver) then
			if Objective_IsComplete(OBJ_Silver) == false then
				Objective_Fail(OBJ_Silver)
			end
		end
		if Objective_IsStarted(OBJ_Gold) then
			if Objective_IsComplete(OBJ_Gold) == false then
				Objective_Fail(OBJ_Gold)
			end
		end
		Rule_RemoveMe()
	end
end

-- Guards start rotating from position to position after the first officer is killed
function RotateGuard (data)
	local enc = data.enc
	if not enc:IsAlive() then
		return
	end
	
	local index = data.index
	local groupName = SGroup_GetName(enc.data.sgroups[1])
	
	if g_officersKilled > 0 then
		index = index + 1
		if index == 10 then
			index = 1
		end
		_ToWDebugDisplay("RotateGuard is moving " .. groupName .. " from pos " .. data.index .. " to " .. index)
		
		local targetMarker = Marker_FromName("mkr_AT" .. index, "")
		local goalData = {
			name = "Defend",
			target = targetMarker,
			attackMove = true,
			leashRange = 20,
			range = 45,
		}
		enc:SetGoal(goalData)
		data.index = index
	end
	Event_Timer(RotateGuard, data, World_GetRand(120,180))
end

-- This function runs after an officer is killed, updating several things.
function NextOfficer(enc)
	-- tell the player he's assassinated an officer
	Util_MissionTitle(11038795) -- LOCDB [11038795] 'Officer Assassinated'
	
	if Rule_Exists(checkFail) then
		Rule_Remove(checkFail)
	end
	
	-- iterate to find the current encounter
	for i = 1,9 do
		if enc.data.name == "Encounter" .. i .. "Officer" then
			-- create an attack goal
			local goalData = {
				name = "Attack",
				attackMove = true,
				target = Marker_FromName("mkr_O" .. i .. "_space",""),
				leashRange = 15,
				tacticCloseGround = true,
				useSkirmishAI = true,
				fallback = true,
				fallbackParams = {
					thresholds = {0.33},
					thresholdType = Threshold_PercentageEntitiesRemaining,
					markers = {t_encounters[i].retreatMarker},
					retreat = true,
					retreatDespawn = true,
				},
			}
			-- now find all the non-officer encounters associated with this encounter space
			for k,v in pairs (t_encounters[i]) do
				if scartype(v) == ST_TABLE then
					if k ~= "officer" then
						print("NextOfficer" .. i .. " found:", k)
						if (v.SetGoal) then
						print("NextOfficer" .. i .. " setting goal for:", k)
							v:SetGoal(goalData)
						end
					end
				end
			end
			
			-- if the uiCheck rule is up we remove that rule
			if (t_encounters[i].uiCheck) then
				Event_Remove(t_encounters[i].uiCheck) 
				-- if the hint arrow is still active, we remove it too
				if (t_encounters[i].uiArrow) then
					HintPoint_Remove(t_encounters[i].uiArrow)
				end
			end
		end
	end
	
	-- remove the UI ping used in the first encounter
	if enc.data.name == "Encounter1Officer" then
		Objective_RemovePing(OBJ_Main,objUI_0)
	end
		
	-- if we haven't killed anyone else before getting here, we play some objective update text
	if g_officersKilled == 0 then
		Util_StartIntel(EVENTS.Search)
		for k,v in pairs (t_encounters.subset) do
			local group = SGroup_FromName("sg_enemy_officer_"..v)
			if SGroup_IsAlive(group) then
				local arrow = ThreatArrow_CreateGroup(group)
				ThreatArrow_Add ( arrow, group, "Icons_symbols_unit_soviet_officer_symbol")
			end
		end
	end
	
	-- Add one to the officers killed
	g_officersKilled = g_officersKilled + 1
	
	-- Increment objectives
	local obj = nil
	local goal = 0
	local count = g_officersKilled
	if Objective_IsStarted(OBJ_Gold) then
		obj = OBJ_Gold
		goal = g_gold - g_silver
		count = g_officersKilled - g_silver
	elseif Objective_IsStarted(OBJ_Silver) then
		obj = OBJ_Silver
		goal = g_silver
	end
	
	if (obj) then
		Objective_SetCounter(obj, count, goal)
		if count >= goal then
			Objective_Complete(obj)
		end
	end
	
	-- run a check for escalation
	reinforce()
	Escalate()
	
	if not Rule_Exists(checkFail) then
		Rule_AddInterval(checkFail, 1)
	end
end

function SpawnOfficerInCar(data)
	local encData = {
		name = "Encounter" .. data.index .. "Officer",
		player = player2,
		sgroups = {SGroup_FromName("sg_enemy_officer_"..data.index),sg_allOfficers},
		units = {
			{
			spawn = data.car,
			sbp = g_SovietOfficerSquad,
			},
		},
		onDeath = NextOfficer,
	}
	t_encounters[data.index].officer = Encounter:Create(encData)
	
	SGroup_SetInvulnerable(SGroup_FromName("sg_enemy_officer_"..data.index),0.25)
	Event_GroupIsDead(OfficerReset, data, data.car)
	SGroup_AddGroup(sg_allOfficers, SGroup_FromName("sg_enemy_officer_"..data.index))
end

function OfficerReset (data)
	SGroup_SetInvulnerable(SGroup_FromName("sg_enemy_officer_"..data.index),false)
	t_encounters[data.index].officer:SetGoal(data.goal)
end

function Escalate()
	local encData = {}
	local goalData = {}
	
	local function AddEscalationUnits(t_units, marker)
		for k,unit in pairs (t_units) do
			local unitTable = {
				sbp = unit,
				spawn = marker,
			}
			table.insert (encData.units, unitTable)
		end
	end
	
	Player_GetAll(player1, sg_player_mortar)
	SGroup_Filter(sg_player_mortar, SBP.SOVIET.HM_120_38_MORTAR_SQUAD, FILTER_KEEP)
	
	-- if we have now killed 2 officers, we add a scout car that patrols the road
	if g_officersKilled == 2 then
		if table.getn(t_difficulty.escalationUnits1) > 0 then
			encData = {
				name = "ScoutCar1",
				player = player2,
				sgroups = {sg_enemy_scout_car_1},
				units = { },
				onDeath = nil,
			}
			goalData = {
				name = "Move",
				target = mkr_patrol_01,
				useSkirmishAI = true,
				attackMove = true,
				onSuccess = PatrolUpdate,
			}
			AddEscalationUnits(t_difficulty.escalationUnits1, mkr_escalation_01)
			t_encounters.escalation01 = Encounter:Create(encData)
			t_encounters.escalation01:SetGoal(goalData)
			Util_StartIntel(EVENTS.ScoutCar1)
		end
	
	-- after third officer is killed, a second scout car patrols as well
	elseif g_officersKilled == 3 then
		if table.getn(t_difficulty.escalationUnits2) > 0 then
			encData = {
				name = "ScoutCar2",
				player = player2,
				sgroups = {sg_enemy_scout_car_2},
				units = {},
				onDeath = nil,
			}
			goalData = {
				name = "Move",
				target = mkr_patrol_04,
				useSkirmishAI = true,
				attackMove = true,
				onSuccess = PatrolUpdate,
			}
			AddEscalationUnits(t_difficulty.escalationUnits2, mkr_escalation_02)
			t_encounters.escalation02 = Encounter:Create(encData)
			t_encounters.escalation02:SetGoal(goalData)
			Util_StartIntel(EVENTS.ScoutCar2)
		end
		
	-- after the fourth officer is killed, a sniper team spawns and goes after the player's infantry
	elseif g_officersKilled == 4 then
		if table.getn(t_difficulty.escalationUnits3) > 0 then
			encData = {
				name = "Sniper",
				player = player2,
				sgroups = {sg_enemy_sniper_team},
				units = {},
				onDeath = nil,
			}
			goalData = {
				name = "Attack",
				target = sg_player_infantry,
				useSkirmishAI = true,
				attackMove = true,
			}
			AddEscalationUnits(t_difficulty.escalationUnits3, mkr_escalation_03)
			if SGroup_Count (sg_player_mortar) > 0 then
				goalData.target = sg_player_mortar
			elseif SGroup_Count(sg_player_infantry) < 1 then
				goalData.target = sg_player_truck
			end
			t_encounters.escalation03 = Encounter:Create(encData)
			t_encounters.escalation03:SetGoal(goalData)
			Util_StartIntel(EVENTS.SniperTeam)
		end
		
	-- after the fifth officer is killed, a t70 light tank spawns and goes after the half-tracks
	elseif g_officersKilled == 5 then
		if table.getn(t_difficulty.escalationUnits3) > 0 then
			encData = {
				name = "T70",
				player = player2,
				sgroups = {sg_enemy_t70},
				units = {},
				onDeath = nil,
			}
			goalData = {
				name = "Attack",
				target = sg_player_truck,
				useSkirmishAI = true,
				attackMove = true,
			}
		
			AddEscalationUnits(t_difficulty.escalationUnits4, mkr_escalation_01)
			if SGroup_Count (sg_player_mortar) > 0 then
				goalData.target = sg_player_mortar
			elseif SGroup_Count(sg_player_truck) < 1 then
				goalData.target = sg_player_infantry
			end
			t_encounters.escalation03 = Encounter:Create(encData)
			t_encounters.escalation03:SetGoal(goalData)
			Util_StartIntel(EVENTS.T70)
		end
	end
end


-- helper function for the patrolling scout cars; updates their goals after they reach a way point
function PatrolUpdate (enc)
	local goalData = {
		name = "Move",
		useSkirmishAI = true,
		attackMove = true,
		onSuccess = PatrolUpdate,
	}
	
	if enc.goal.data.target == mkr_patrol_01 then
		goalData.target = mkr_patrol_02
	elseif enc.goal.data.target == mkr_patrol_02 then
		goalData.target = mkr_patrol_03
	elseif enc.goal.data.target == mkr_patrol_03 then
		goalData.target = mkr_patrol_04
	elseif enc.goal.data.target == mkr_patrol_04 then
		goalData.target = mkr_patrol_05
	elseif enc.goal.data.target == mkr_patrol_05 then
		goalData.target = mkr_patrol_06
	elseif enc.goal.data.target == mkr_patrol_06 then
		goalData.target = mkr_patrol_07
	elseif enc.goal.data.target == mkr_patrol_07 then
		goalData.target = mkr_patrol_01
	end
	
	enc:SetGoal(goalData)

end

function SniperMortarReaction (data)
	sg_temp = SGroup_CreateIfNotFound("sg_temp")
	sg_snipers = SGroup_CreateIfNotFound("sg_snipers")
	sg_mortars = SGroup_CreateIfNotFound("sg_mortars")
	SGroup_Clear(sg_temp)
	SGroup_Clear(sg_snipers)
	SGroup_Clear(sg_mortars)
	SGroup_GetLastAttacker(data._group, sg_temp)
	SGroup_Filter(sg_temp, SBP.GERMAN.SNIPER_SQUAD, FILTER_REMOVE, sg_snipers)
	SGroup_Filter(sg_temp, SBP.SOVIET.HM_120_38_MORTAR_SQUAD, FILTER_REMOVE, sg_mortars)
	
	data.enc.data.oldGoal = data.enc.data.oldGoal or data.enc:GetGoalData()	
		
	if (SGroup_Count(sg_snipers) > 0) and (SGroup_Count(data._group) > 0) then
		_ToWDebugDisplay("SNIPE!")
		local reaction = ""
		if scartype(data.react) == ST_STRING then
			reaction = data.react
		elseif scartype (data.react) == ST_TABLE then
			reaction = data.react[World_GetRand(1,#data.react)]
		end
		
		if reaction == "relocate" then
			local posA = SGroup_GetPosition(sg_snipers)
			local posB = SGroup_GetPosition(data._group)
			local dist = Util_GetDistance(posA, posB)
			local posC = Util_GetPositionFromAtoB(posA, posB, dist + 20 )
			local goalData = {
				name = "Move",
				target = posC,
				range = 5,
				leashRange = 5,
				onSuccess = RestoreGoal,
				onFailure = RestoreGoal,
			}
			data.enc:SetGoal(goalData)
			
		elseif reaction == "smoke" then
			local posA = SGroup_GetPosition(sg_snipers)
			local posB = SGroup_GetPosition(data._group)
			local posC = Util_GetPositionFromAtoB(posA, posB, 8)
			Squad_AddAbility(SGroup_GetSpawnedSquadAt(data._group, 1), ABILITY.SOVIET.RGD_1_SMOKE_GRENADE)
			local goalData = {
				name = "Ability",
				target = posC,
				abilityParams = {
					abilityPBG = ABILITY.SOVIET.RGD_1_SMOKE_GRENADE,
				},
				onSuccess = RestoreGoal,
				onFailure = RestoreGoal,
			}
			data.enc:SetGoal(goalData)
			
		elseif reaction == "frag" then
			local posA = SGroup_GetPosition(sg_snipers)
			local posB = SGroup_GetPosition(data._group)
			local posC = Util_GetPositionFromAtoB(posA, posB, 8)
			Squad_AddAbility(SGroup_GetSpawnedSquadAt(data._group, 1), ABILITY.SOVIET.RG_42_ANTI_PERSONNEL_GRENADE)
			local goalData = {
				name = "Ability",
				target = posC,
				abilityParams = {
					abilityPBG = ABILITY.SOVIET.RG_42_ANTI_PERSONNEL_GRENADE,
				},
				onSuccess = RestoreGoal,
				onFailure = RestoreGoal,
			}
			data.enc:SetGoal(goalData)
			
		elseif reaction == "barrage" then
			if SGroup_ContainsBlueprints(data._group, SBP.SOVIET.HM_120_38_MORTAR_SQUAD, ANY) then
				local posA = SGroup_GetPosition(sg_snipers)
				local posB = SGroup_GetPosition(data._group)
				local posC = Util_GetPositionAwayFromPlayer(sg_snipers, player1, 25, 15)
				local goalData = {
				name = "Ability",
				target = posC,
				abilityParams = {
					abilityPBG = ABILITY.SOVIET.SYNC_MORTAR_BARRAGE_120MM,
				},
				onSuccess = RestoreGoal,
				onFailure = RestoreGoal,
				}
				data.enc:SetGoal(goalData)
			else
				local posA = SGroup_GetPosition(sg_snipers)
				local posB = SGroup_GetPosition(data._group)
				local dist = Util_GetDistance(posA, posB)
				local posC = Util_GetPositionFromAtoB(posA, posB, dist + 20 )
				local goalData = {
				name = "Move",
				target = posC,
				range = 5,
				leashRange = 5,
				onSuccess = RestoreGoal,
				onFailure = RestoreGoal,
				}
				data.enc:SetGoal(goalData)
			end
		end
		Event_Timer(RestoreSniperMortarReaction, data, 2)
		
	elseif (SGroup_Count(sg_mortars) > 0) and (SGroup_Count(data._group) > 0) then
		_ToWDebugDisplay("MORTARED!")
		local rand = World_GetRand(1,100)
		rand = rand - t_difficulty.mortarReactionChance
		if rand > 0 then 
			local posA = SGroup_GetPosition(sg_mortars)
			local posB = SGroup_GetPosition(data._group)
			local goalData = {
				name = "Attack",
				target = posA,
				range = 10,
				leashRange = 25,
				attackMove = true,
				maxIdleTime = 5,
				onSuccess = RestoreGoal,
				onFailure = RestoreGoal,
			}
			data.enc:SetGoal(goalData)
		end
		Event_Timer(RestoreSniperMortarReaction, data, 10)
	end
end

function RestoreSniperMortarReaction(data)
	if (SGroup_Count(data._group)>0) and (data.enc:IsAlive()) then
		Event_IsUnderAttack(SniperMortarReaction, data, data._group, ANY, 1)
	end
end
	
function RestoreGoal(enc)
	if (enc.data.oldGoal) then
		enc:SetGoal(enc.data.oldGoal)
		enc.data.oldGoal = nil
	end
end

--------------------------------------------------------------------------------------------
--------------------------------- ACHIEVEMENT FUNCTIONS
--------------------------------------------------------------------------------------------

function Achieve(data)
	if scartype (data) == ST_STRING then
		data = { id = data }
	end
	_ToWDebugDisplay("ACHIEVEMENT: " .. data.id, "gold")
	Scar_CompleteIntelBulletinTask(player1, data.id)
end

function SetupAchievements()
	g_snipeKills = 0
	local num = math.floor(EGroup_Count(eg_supply_drops) * 0.2)
	Event_GroupLeftAlive (Achieve, {id="tow_officer_assassination_scrounger"}, eg_supply_drops, num)
	Rule_AddSGroupEvent(CountSniperKills, sg_allOfficers, GE_SquadKilled)
end


function CountSniperKills (squad)
	sg_temp = SGroup_CreateIfNotFound("sg_temp")
	SGroup_Clear(sg_temp)
	Squad_GetLastAttacker(squad, sg_temp)
	SGroup_Filter(sg_temp, SBP.GERMAN.SNIPER_SQUAD, FILTER_KEEP)
	if SGroup_Count(sg_temp)>0 then
		g_snipeKills = g_snipeKills + 1
		if g_snipeKills == 5 then
			Achieve("tow_officer_assassination_sharpshooter")
		end
	end
	_ToWDebugDisplay("g_snipeKills is now " .. tostring(g_snipeKills), "gold")
end


--------------------------------------------------------------------------------------------
--------------------------------- UI / HINT FUNCTIONS
--------------------------------------------------------------------------------------------
-- functions that create arrows over officers when they are visible to the player

function uiChecker (i)
	local data = 
	{
		i = i,
		officer = SGroup_FromName("sg_enemy_officer_" .. i),
	}
	local id = 	Event_PlayerCanSeeElement(uiChecker_AddArrow, data, player1, data.officer)
	return id
end

function uiChecker_AddArrow(data)
	t_encounters[data.i].uiArrow = HintPoint_Add(data.officer, true, 11038796, 3, HPAT_Objective, "Icons_commands_icon_command_attackmove")	-- LOCDB [11038796] 'Target Officer'
	Event_Timer(uiClearCheck, data, 0.5)
end


function uiClearCheck(data)
	local clear = true
	local endCheck = true

	if SGroup_IsAlive (data.officer) then
		endCheck = false
		if Player_CanSeeSGroup(player1, data.officer, ANY) then
			clear = false
		end
	end
	
	if clear == true then
		HintPoint_Remove(t_encounters[data.i].uiArrow)
		if endCheck == false then
			Event_PlayerCanSeeElement(uiChecker_AddArrow, data, player1, data.officer)
		end
	else
		if endCheck == false then
			Event_Timer(uiClearCheck, data, 0.5)
		end
	end
end


function SupplyHint()
	g_supplies = HintPoint_Add(eg_supply_drop01, true, 11046241, nil, nil, "Icons_tooltips_pick_up_item") -- LOCDB [11046241] 'Supply Caches Provide Resources'
	Event_GroupIsDead(ClearSupplyHint, nil, eg_supply_drop01)
end
function ClearSupplyHint(data)
	HintPoint_Remove(g_supplies)
end

function AddThreat(data)
	ThreatArrow_CreateGroup(data._group)
end

function ClearUIElement(data)
	Objective_RemoveUIElements(data.obj, data.id)
end

function RemoveHint (data)
	HintPoint_Remove(data.id)
end
