-------------------------------------------------------------------------
-------------------------------------------------------------------------

-- MISSION NAME
-- Designers: NJR & Philippe Boulle

-------------------------------------------------------------------------
-------------------------------------------------------------------------

import("ScarUtil.scar")
import("TheatreOfWar.scar")
import("Systems/AiManager/ai.scar")

-------------------------------------------------------------------------
-- [[ SETUP ]]
-------------------------------------------------------------------------

function OnGameSetup()
	
	player1 = World_GetPlayerAt(1)
	player2 = World_GetPlayerAt(2)
	player3 = Setup_Player(3, 11042748, "german", 2)  -- LOCDB [11042748] '3rd Panzer Corps'
	player4 = Setup_Player(4, 11042749, "german", 2)  -- LOCDB [11042749] '48th Panzer Corps'
	
end



function OnGameRestore()
	
	-- function takes care of restoring all global mission parameters after a save/load
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
	
	
	--
	-- Get the player data
	--
	print("1: ".. Player_GetRaceName(player1) .. " ... Human:".. tostring(Player_IsHuman(player1)).. "  AIPlayer:".. tostring(AI_IsAIPlayer(player1)).."/Enabled:".. tostring(AI_IsEnabled(player1)))
	print("2: ".. Player_GetRaceName(player2) .. " ... Human:".. tostring(Player_IsHuman(player2)).. "  AIPlayer:".. tostring(AI_IsAIPlayer(player2)).."/Enabled:".. tostring(AI_IsEnabled(player2)))
	print("3: ".. Player_GetRaceName(player3) .. " ... Human:".. tostring(Player_IsHuman(player3)).. "  AIPlayer:".. tostring(AI_IsAIPlayer(player3)).."/Enabled:".. tostring(AI_IsEnabled(player3)))
	print("4: ".. Player_GetRaceName(player4) .. " ... Human:".. tostring(Player_IsHuman(player4)).. "  AIPlayer:".. tostring(AI_IsAIPlayer(player4)).."/Enabled:".. tostring(AI_IsEnabled(player4)))
	
	--
	-- Lock out AI control of certain units for P3 and P4
	--
	if AI_IsEnabled(player3) then
		AI_LockSquads(player3, sg_lockedout_ai)
	end
	if AI_IsEnabled(player4) then
		AI_LockSquads(player4, sg_lockedout_ai)
	end
	
	--[[ SET DIFFICULTY ]]
	Mission_Difficulty()
	
	--[[SET PRESETS]]
	Mission_MissionPresets()
	
	--[[ SET RESTRICTIONS ]]
	Mission_Restrictions()

	--[[ REGISTER OBJECTIVES ]]
	Brody_InitializeObjective()
	
	if AI_IsEnabled(player3) then
		AI_LockSquads(player3, sg_player3_starting)
	end
	if AI_IsEnabled(player4) then
		AI_LockSquads(player4, sg_player4_starting)
	end

	SetupGermanHQ()
	
	Camera_SetDefault(nil, nil, -45)
	Camera_ResetToDefault()

	
	Objective_Start(OBJ_Brody)
	Objective_Start(OBJ_Ticker, false)

	Rule_AddOneShot(StartTransitionToNight, (4 * 60) - 60)
	Rule_AddInterval(VP_Check, 1)	
	
	if g_debug then
		DEBUG_Beat_Selection_01()
	else
		local startfunc = phase_data[current_phase].startfunc				-- if there is a start function associated with this phase, call it now
		if scartype(startfunc) == ST_FUNCTION then
			startfunc()
		end
		local data = {}
		data.time = 240
		data.text = 11036693
		data.maxtime = 240
		
		Event_Timer(Countdown, data, 1)
	end
end

Scar_AddInit(OnInit)

function DEBUG_Beat_Selection_01()
	UI_MessageBoxSetText(LOC("Select Day"), LOC("Select the Mission beat to play"))
	UI_MessageBoxSetButton(DB_Button1, LOC("Day 1"), LOC("Part 1"), "", true)
	UI_MessageBoxSetButton(DB_Button2, LOC("Day 2"), LOC("Part 2"), "", true)
	UI_MessageBoxSetButton(DB_Button3, LOC("Day 3"), LOC("Part 3"), "", true)
	UI_MessageBoxShow(DC_Default, DEV_SelectPhase_Menu_01)
end

function DEV_SelectPhase_Menu_01(button)

	if button == DB_Button1 then
		current_phase = 1
	elseif button == DB_Button2 then
		current_phase = 3
		Player_AddResource(player1, RT_Command, 1)
		skippedPhases = 2
	elseif button == DB_Button3 then
		current_phase = 5
		Player_AddResource(player1, RT_Command, 1)
		skippedPhases = 4
	end

	local startfunc = phase_data[current_phase].startfunc				-- if there is a start function associated with this phase, call it now
	if scartype(startfunc) == ST_FUNCTION then
		startfunc()
	end
	
	local data = {}
	data.time = 240
	data.text = 11036693
	data.maxtime = 240
	
	Event_Timer(Countdown, data, 1)
end

function Mission_Debug()
	g_debug = Misc_IsCommandLineOptionSet("debug")
end

function Mission_MissionPresets()
	sg_temp = SGroup_CreateIfNotFound("sg_temp")
	eg_temp = EGroup_CreateIfNotFound("eg_temp")
	sg_blah = SGroup_CreateIfNotFound("sg_blah")
	eg_blah = EGroup_CreateIfNotFound("eg_blah")
	
	eg_victorypoints = EGroup_CreateIfNotFound("eg_victorypoints")
	EGroup_AddEGroup(eg_victorypoints, eg_vp1)
	EGroup_AddEGroup(eg_victorypoints, eg_vp2)
	EGroup_AddEGroup(eg_victorypoints, eg_vp3)
	
	--[[ VARIABLES ]]
	ticker_count = t_difficulty.startingTickers		
	current_phase = 1
	
	g_p3_flankers_unloaded = false
	g_p4_flankers_unloaded = false
	
	phase_data = {
		{startfunc = Phase1_Start, cycle = "day"},
		{startfunc = Phase2_Start, cycle = "night"},
		{startfunc = Phase3_Start, cycle = "day"},
		{startfunc = Phase4_Start, cycle = "night"},
		{startfunc = Phase5_Start, cycle = "day"},
		{startfunc = Phase6_Start, cycle = "night"},
		{startfunc = Phase7_Start, cycle = "day"},
		{startfunc = Phase8_Start, cycle = "night"},
		{startfunc = EndMission, cycle = "day"},
	}
	
	bonus_data = {																
		{
			player = player1,
			level1Used = false,
			level2Used = false,
			level3Used = false,
			levelsUsed = 0,
			commanderAbilities = {},
			pointsavailable = 4, 
			currentselection = 0,
			tankKills = 0,
		},
		{
			player = player2, 
			level1Used = false,
			level2Used = false,
			level3Used = false,
			levelsUsed = 0,
			commanderAbilities = {},
			pointsavailable = 4, 
			currentselection = 0,
			tankKills = 0,			
		},
	}
	
	for k, bonus in pairs(bonus_data) do										-- set up the reinforcement selection UI (a bunch of abilities that appear on the command bar when it's time to choose)
		Player_AddAbility(bonus.player, ABILITY.GLOBAL.BONUS_1)
		Player_AddAbility(bonus.player, ABILITY.GLOBAL.BONUS_2)
		Player_AddAbility(bonus.player, ABILITY.GLOBAL.BONUS_3)
		Player_AddAbility(bonus.player, BP_GetAbilityBlueprint("bonus_2b"))
		Player_AddAbility(bonus.player, BP_GetAbilityBlueprint("bonus_3b"))
		Player_AddAbility(bonus.player, BP_GetAbilityBlueprint("bonus_3c"))
		Player_SetAbilityAvailability(bonus.player, ABILITY.GLOBAL.BONUS_1, ITEM_REMOVED)
		Player_SetAbilityAvailability(bonus.player, ABILITY.GLOBAL.BONUS_2, ITEM_REMOVED)
		Player_SetAbilityAvailability(bonus.player, ABILITY.GLOBAL.BONUS_3, ITEM_REMOVED)
		Player_SetAbilityAvailability(bonus.player, BP_GetAbilityBlueprint("bonus_2b"), ITEM_REMOVED)
		Player_SetAbilityAvailability(bonus.player, BP_GetAbilityBlueprint("bonus_3b"), ITEM_REMOVED)
		Player_SetAbilityAvailability(bonus.player, BP_GetAbilityBlueprint("bonus_3c"), ITEM_REMOVED)
		Rule_AddPlayerEvent(BonusSelect_Selected, bonus.player, GE_AbilityExecuted)
	end
	
	spawnlocations_p1 = {														-- sets of spawn locations for each player. Helps spread out reinforcements, rather than them all arriving at the same spot.
		{spawn = mkr_spawn_p1a, dest = mkr_rally_p1a},
		{spawn = mkr_spawn_p1b, dest = mkr_rally_p1b},
	}
	spawnlocations_p2 = {
		{spawn = mkr_spawn_p2a, dest = mkr_rally_p2a},
		{spawn = mkr_spawn_p2b, dest = mkr_rally_p2b},
	}
	spawnlocations_p3 = {
		{spawn = mkr_spawn_p3a, dest = mkr_rally_p3a},
		{spawn = mkr_spawn_p3b, dest = mkr_rally_p3b},
	}
	flank_p3 = {
		{spawn = mkr_spawn_p3a, dest = mkr_rally_p3a},
		{spawn = mkr_northFlank_spawn, dest = mkr_northFlank_rally},
	}
	spawnlocations_p4 = {
		{spawn = mkr_spawn_p4a, dest = mkr_rally_p4a},
		{spawn = mkr_spawn_p4b, dest = mkr_rally_p4b},
	}
	flank_p4 = {
		{spawn = mkr_spawn_p4a, dest = mkr_rally_p4a},
		{spawn = mkr_eastFlank_spawn, dest = mkr_eastFlank_rally},
	}
	northFlank = {
		{spawn = mkr_northFlank_spawn, dest = mkr_northFlank_rally},
	}
	eastFlank = {
		{spawn = mkr_eastFlank_spawn, dest = mkr_eastFlank_rally},
	}
	
	LossCues = {
		{tickerValue = 750, loseWarning = 39367, played=false,},
		{tickerValue = 500, loseWarning = 39366, played=false,},
		{tickerValue = 400, loseWarning = 39360, played=false,},
		{tickerValue = 300, loseWarning = 39361, speech = "speech/mp/soviet/INT/intel/FriendlyTicker/SB_INT_FTS_300Gen_NT_L", played=false,},
		{tickerValue = 200, loseWarning = 39362, speech = "speech/mp/soviet/INT/intel/FriendlyTicker/SB_INT_FTS_200Gen_NT_L", played=false,},
		{tickerValue = 100, loseWarning = 39363, speech = "speech/mp/soviet/INT/intel/FriendlyTicker/SB_INT_FTS_100Gen_NT_L", played=false, },
		{tickerValue = 75,  loseWarning = 11046928, speech = "speech/mp/soviet/INT/intel/FriendlyTicker/SB_INT_FTS_075Gen_NT_L", played=false,},
		{tickerValue = 50,  loseWarning = 39364, speech = "speech/mp/soviet/INT/intel/FriendlyTicker/SB_INT_FTS_050Gen_NT_L", played=false,},
		{tickerValue = 25,  loseWarning = 39365, speech = "speech/mp/soviet/INT/intel/FriendlyTicker/SB_INT_FTS_025Gen_NT_L", played=false,},
		{tickerValue = 10, loseWarning = 11046929, speech = "speech/mp/soviet/INT/intel/FriendlyTicker/SB_INT_FTS_010Gen_NT_L", played=false,},
	}
	
	
	-- [[player squads]]
	sg_player1_starting = SGroup_CreateIfNotFound("sg_player1_starting")
	sg_player2_starting = SGroup_CreateIfNotFound("sg_player2_starting")
	
	Player_SetPopCapOverride(player1, 200)
	Player_SetPopCapOverride(player2, 200)
	
	
	-- [[ tell the AI enemies to prioritize the victory points ]]
	if AI_IsEnabled(player3) then
		local _SetImport = function(gid, idx, eid)
			if Entity_IsVictoryPoint(eid) then
				AI_SetCaptureImportanceBonus(player3, eid, 10)
			end
		end
		EGroup_ForEach(eg_victorypoints, _SetImport)
	end
	
	if AI_IsEnabled(player4) then
		local _SetImport = function(gid, idx, eid)
			if Entity_IsVictoryPoint(eid) then
				AI_SetCaptureImportanceBonus(player4, eid, 10)
			end
		end
		EGroup_ForEach(eg_victorypoints, _SetImport)
	end
	
	if AI_IsAIPlayer(player2) == true then
		Setup_SetPlayerName(player2, 11042750) -- LOCDB [11042750] '22nd Mechanized Corps'
	elseif AI_IsAIPlayer(player1) == true then
		Setup_SetPlayerName(player1, 11042751) -- LOCDB [11042751] '22nd Mechanized Corps'
	end
	
	Rule_AddSGroupEvent(CountTankKills, sg_blah, GE_SquadKilled)
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
end

function Mission_Difficulty()

	-- get the difficulty
	g_difficulty = Game_GetSPDifficulty()   
	
	_ToWDebugDisplay("********* DIFFICULTY: "..g_difficulty)
	
	t_difficulty = {
		startingTickers = 	Util_DifVar({1200, 1000,  800, 800}, g_difficulty),
		friendlyRate = 		Util_DifVar({ 0.5,  0.4,   0.4,  0.25}, g_difficulty),
		neutralRate  =		Util_DifVar({0.25,  0.5,  0.5,     1}, g_difficulty),
		enemyRate  =		Util_DifVar({ 1.0,  1.5,   1.5,   2.0}, g_difficulty),
	}
end

function SetupGermanHQ()

	enc_p3base = Encounter:ConvertSgroup(sg_player3_starting)
	enc_p4base = Encounter:ConvertSgroup(sg_player4_starting)
	
	local goalData = {
		name = "Defend",
		target = mkr_germanBase,
		useSkirmishAI = true,
		leashRange = mkr_germanBase,
	}

	enc_p3base:SetGoal(goalData)
	enc_p4base:SetGoal(goalData)

end

-------------------------------------------
-------------------------------------------
--
--  Set up Mission Objective
--
-------------------------------------------
-------------------------------------------

function Brody_InitializeObjective()

	OBJ_Brody = {
		SetupUI = function() 
		end,
		OnStart = function()
		end,
		OnComplete = function()
			Rule_AddInterval (EndSpeech, 1)
			for k,bonus in pairs (bonus_data) do
			
				local player = bonus.player
				
				if (not bonus.level1Used) and (not bonus.level2Used) and (not bonus.level3Used) then
					_ToWDebugDisplay("ACHIEVEMENT: tow_brody_tank_war_i_need_no_help for player " .. k, "gold")
					Scar_CompleteIntelBulletinTask(player, "tow_brody_tank_war_i_need_no_help")
				end
			
			end
		end,
		Intel_Fail = EVENTS.Defeat, 
		OnFail = function()
			if Rule_Exists(StartTransitionToNight) then Rule_Remove(StartTransitionToNight) end
			if Rule_Exists(StartTransitionToDay) then Rule_Remove(StartTransitionToDay) end
			if Rule_Exists(MidTransitionPoint) then Rule_Remove(MidTransitionPoint) end
			World_SetTeamWin(Team_GetEnemyTeam(Player_GetTeam(World_GetPlayerAt(1))))
		end,
		Title = Loc_FormatText(11036694, Loc_ConvertNumber(1)) , -- LOCDB [11036694] 'Keep your VP tickers from reaching 0. (Day %1DAY% of 4)'
		Description = 0,
		Type = OT_Primary,				-- Objective Type (OT_Primary, OT_Secondary)
	}
	
	OBJ_Ticker = {
		Parent = OBJ_Brody,
		SetupUI = function()
		end,
		OnStart = function()
		end,
		OnComplete = function()
		end,
		OnFail = function()
		end,
		Title = 11042752, -- LOCDB [11042752] 'Status: Tickers holding even.'
		Description = 0,
		Type = OT_Secondary,
	}
	
	Objective_Register(OBJ_Brody)
	Objective_Register(OBJ_Ticker)
end

function Countdown(data)
	if data.time > 0 then
		data.time = data.time - 1
		local prog = data.time / data.maxtime
		Obj_ShowProgress(data.text, prog)
		Event_Timer(Countdown, data, 1)
	elseif data.time == 0 then
		MidTransitionPoint(data)
	end
end



-- PHASE 1 (DAY 1)
-- Initial attacks with some Scout Cars
-- Followed up by some heavier armour (but still easily dealt with)
function Phase1_Start()
	_ToWDebugDisplay ("Phase1_Start", "white")
	Rule_AddOneShot(Phase1_GermanScoutCars, 5)
	Rule_AddOneShot(Phase1_GermanTanks, 110)
	Util_StartIntel ( EVENTS.Intro )
	Rule_AddInterval(Phase1_Intro2, 0.5)
	FOW_RevealEGroupOnly(eg_victorypoints, -1)
end

function Phase1_Intro2()
	if not Event_IsAnyRunning() then
		Rule_RemoveMe()
		Util_StartIntel ( EVENTS.Points )
		t_pings = {}
		local function AddPing(egroup, index, entity) 
			local ping = Objective_AddPing(OBJ_Brody, entity)
			table.insert(t_pings, ping)
		end
		EGroup_ForEach(eg_victorypoints, AddPing)
		Rule_AddInterval(Phase1_Intro3, 0.5)
	end
end

function Phase1_Intro3()
	if not Event_IsAnyRunning() then
		Rule_RemoveMe()
		for k,ping in pairs (t_pings) do
			Objective_RemovePing(OBJ_Brody, ping)
		end
		Util_StartIntel ( EVENTS.Reinforcements )
	end
end

function Phase1_GermanScoutCars()
	_ToWDebugDisplay ("Phase1_GermanScoutCars", "white")
	local list = {
		SBP.GERMAN.SDKFZ_251_HALFTRACK_SQUAD,
		SBP.GERMAN.SCOUTCAR_SDKFZ222,
		SBP.GERMAN.GRENADIER_SQUAD,
	}
	SpawnList(player3, list, spawnlocations_p3)
	
	local list = {
		SBP.GERMAN.SDKFZ_251_HALFTRACK_SQUAD,
		SBP.GERMAN.SCOUTCAR_SDKFZ222,
		SBP.GERMAN.GRENADIER_SQUAD,
	}
	SpawnList(player4, list, spawnlocations_p4)
	
	if g_difficulty > GD_EASY then
	
		local encData = {
			name = "Raiders1",
			player = player3,
			sgroups = {SGroup_CreateIfNotFound("sg_raiders1")},
				units = {
					{
						sbp = SBP.GERMAN.GRENADIER_SQUAD,
						numSquads = 2,
						spawn = mkr_rally_p3a,
					},
				},
			onDeath = nil,
		}
		
		local goalData = {
			name = "Attack",
			target = eg_vp1,
		}
		raiders1 = Encounter:Create(encData)
		if AI_IsEnabled(player3) then
			raiders1:SetGoal(goalData)
		end
	end
	
	if g_difficulty > GD_NORMAL then
	
		local encData = {
			name = "Raiders2",
			player = player3,
			sgroups = {SGroup_CreateIfNotFound("sg_raiders2")},
				units = {
					{
						sbp = SBP.GERMAN.GRENADIER_SQUAD,
						numSquads = 2,
						spawn = mkr_northFlank_spawn,
					},
				},
			onDeath = nil,
		}
		
		local goalData = {
			name = "Attack",
			target = eg_vp2,
		}
		
		raiders2 = Encounter:Create(encData)
		if AI_IsEnabled(player3) then
			raiders2:SetGoal(goalData)
		end
		
		local encData = {
			name = "Raiders3",
			player = player4,
			sgroups = {SGroup_CreateIfNotFound("sg_raiders3")},
				units = {
					{
						sbp = SBP.GERMAN.GRENADIER_SQUAD,
						numSquads = 2,
						spawn = mkr_eastFlank_spawn,
					},
				},
			onDeath = nil,
		}
		
		local goalData = {
			name = "Attack",
			target = eg_vp3,
		}
		
		raiders3 = Encounter:Create(encData)
		if AI_IsEnabled(player4) then
			raiders3:SetGoal(goalData)
		end
	end
	
	
end
function Phase1_GermanTanks()
	_ToWDebugDisplay ("Phase1_GermanTanks", "white")
	local list = {
		SBP.GERMAN.STUG_III_E_SQUAD,
		SBP.GERMAN.STUG_III_E_SQUAD,
		{sbp = SBP.GERMAN.SCOUTCAR_SDKFZ222, upg = UPG.GERMAN.SDKFZ_222_20MM_GUN},
	}
	SpawnList(player3, list, spawnlocations_p3)
	
	local list = {
		SBP.GERMAN.STUG_III_E_SQUAD,
		SBP.GERMAN.STUG_III_E_SQUAD,
		{sbp = SBP.GERMAN.SCOUTCAR_SDKFZ222, upg = UPG.GERMAN.SDKFZ_222_20MM_GUN},
	}
	SpawnList(player4, list, spawnlocations_p4)
end

-- PHASE 2 (DAY 1 NIGHT)
-- German counter-attack
-- Some flame units to light up the dark
function Phase2_Start()
	_ToWDebugDisplay ("Phase2_Start", "white")
	Rule_AddOneShot(Phase2_GermanCounterAttack, 15)
	Rule_AddOneShot(Phase2_GermanCounterAttackB, 30)
	Rule_AddOneShot(Phase2_GermanCounterAttackC, 120)
end

function Phase2_GermanCounterAttack()
	_ToWDebugDisplay ("Phase2_GermanCounterAttack", "white")
	local list = {
		SBP.GERMAN.PANZER_IV_STUBBY_SQUAD,
		SBP.GERMAN.PANZER_IV_STUBBY_SQUAD,
	}
	SpawnList(player3, list, flank_p3)
	SpawnList(player4, list, flank_p4)
	
end
function Phase2_GermanCounterAttackB()
	_ToWDebugDisplay ("Phase2_GermanCounterAttackB", "white")
	local list = {
		SBP.GERMAN.GRENADIER_SQUAD,
		{sbp = SBP.GERMAN.PIONEER_SQUAD, upg = UPG.GERMAN.PIONEER_FLAMETHROWER},
	}
	SpawnList(player3, list, spawnlocations_p3)
	SpawnList(player4, list, spawnlocations_p4)
	
end
function Phase2_GermanCounterAttackC()
	_ToWDebugDisplay ("Phase2_GermanCounterAttackC", "white")

	sg_phase2Flankers_p3 = SGroup_CreateIfNotFound("sg_phase2Flankers_p3")
	sg_phase2Flankers_p4 = SGroup_CreateIfNotFound("sg_phase2Flankers_p4")

	local encData = {
		name = "Night 1 Flankers",
		spawn = mkr_northFlank_spawn,
		player = player3,
		sgroups = {sg_phase2Flankers_p3},
		units = {
			{
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
			},
			{
				sbp = SBP.GERMAN.SDKFZ_251_HALFTRACK_SQUAD,
				upgrades = {UPG.GERMAN.SDKFZ_251_HALFTRACK_FLAMMPANZERWAGEN_UPGRADE},
			},
		},
		onDeath = nil,
	}
	phase2Flankers_p3 = Encounter:Create(encData)

	encData.spawn = mkr_eastFlank_spawn
	encData.player = player4
	encData.sgroups = { sg_phase2Flankers_p4}

	phase2Flankers_p4 = Encounter:Create(encData)
	
	local goalData = {
		name = "Attack",
		target = eg_vp2,
		attackMove = true,
		onSuccess = function ()
			Util_ReAllowAI(sg_phase2Flankers_p3)
		end,
		onFailure = function ()
			Util_ReAllowAI(sg_phase2Flankers_p3)
		end,
	}
	phase2Flankers_p3:SetGoal(goalData)
	
	local goalData = {
		name = "Attack",
		target = eg_vp3,
		attackMove = true,
		onSuccess = function ()
			Util_ReAllowAI(sg_phase2Flankers_p4)
		end,
		onFailure = function ()
			Util_ReAllowAI(sg_phase2Flankers_p4)
		end,
	}
	
	phase2Flankers_p4:SetGoal(goalData)
end

-- PHASE 3 (DAY 2)
-- Player reinforcements
function Phase3_Start()
	_ToWDebugDisplay ("Phase3_Start", "white")
	Objective_UpdateText(OBJ_Brody, Loc_FormatText(11036694, Loc_ConvertNumber(2)), 0, false)
	Util_MissionTitle(11038547)  -- LOCDB [11038547] 'Day 2 - Reinforcements approaching'
	Util_StartIntel ( EVENTS.DayTwo )
	BonusSelect_ShowButtons()
	Rule_AddOneShot(Phase3_GermanReinforcements_Early, 115)
	Rule_AddOneShot(Phase3_GermanReinforcements_Late, 175)
end


function Phase3_Reinforcements(player, level)
	local spawnlocations = spawnlocations_p1
	if player == player2 then
		spawnlocations = spawnlocations_p2
	end
	local list = {
		{	-- reinforcement level 1
			SBP.SOVIET.T_70M,
			SBP.SOVIET.T_70M,
		},
		{	-- reinforcement level 2
			SBP.SOVIET.T_34_76_SQUAD,
			SBP.SOVIET.T_34_76_SQUAD,
		},
		{	-- reinforcement level 3
			SBP.SOVIET.KV_1,
			SBP.SOVIET.KV_1,
		},
	}
	if level >= 1 then
		SpawnList(player, list[level], spawnlocations)
	end
end

function Phase3_GermanReinforcements_Early()
	_ToWDebugDisplay ("Phase3_GermanReinforcements_Early", "white")
	local list = {
		SBP.GERMAN.STUG_III_E_SQUAD,
		{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD, upg = BP_GetUpgradeBlueprint("panzerbusche_39")},
	}
	SpawnList(player3, list, spawnlocations_p3)
	SpawnList(player4, list, spawnlocations_p4)
end

function Phase3_GermanReinforcements_Late()
	_ToWDebugDisplay ("Phase3_GermanReinforcements_Late", "white")
	local list = {
		{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD, upg = BP_GetUpgradeBlueprint("panzerbusche_39")},
		{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD, upg = BP_GetUpgradeBlueprint("panzerbusche_39")},
	}
	SpawnList(player3, list, flank_p3)
	SpawnList(player4, list, flank_p4)
	
end

-- PHASE 4 (DAY 2 NIGHT)
-- Bombing runs
-- German reinforcements
function Phase4_Start()
	_ToWDebugDisplay ("Phase4_Start", "white")
	if not Player_HasAbility(player3, ABILITY.GERMAN.STUKA_STRAFING_RUN) then
		Player_AddAbility(player3, ABILITY.GERMAN.STUKA_STRAFING_RUN)
	end
	if not Player_HasAbility(player3, ABILITY.GERMAN.STUKA_CLOSE_AIR_SUPPORT) then
		Player_AddAbility(player3, ABILITY.GERMAN.STUKA_CLOSE_AIR_SUPPORT)
	end
	if not Player_HasAbility(player3, ABILITY.GERMAN.STUKA_BOMBING_STRIKE) then
		Player_AddAbility(player3, ABILITY.GERMAN.STUKA_BOMBING_STRIKE)
	end
	if not Player_HasAbility(player4, ABILITY.GERMAN.STUKA_STRAFING_RUN) then
		Player_AddAbility(player3, ABILITY.GERMAN.STUKA_STRAFING_RUN)
	end
	if not Player_HasAbility(player4, ABILITY.GERMAN.STUKA_CLOSE_AIR_SUPPORT) then
		Player_AddAbility(player3, ABILITY.GERMAN.STUKA_CLOSE_AIR_SUPPORT)
	end
	if not Player_HasAbility(player4, ABILITY.GERMAN.STUKA_BOMBING_STRIKE) then
		Player_AddAbility(player4, ABILITY.GERMAN.STUKA_BOMBING_STRIKE)
	end

	Rule_AddOneShot(Phase4_Airstrike1, 30)
	Rule_AddOneShot(Phase4_Airstrike2, 45)
	Rule_AddOneShot(Phase4_Airstrike3, 75)
	Rule_AddOneShot(Phase4_Airstrike4, 90)
	Rule_AddOneShot(Phase4_Airstrike5, 105)
	Rule_AddOneShot(Phase4_GermanReinforcements, 150)
	
	
end

function Phase4_Airstrike1()
	_ToWDebugDisplay ("Phase4_Airstrike1", "white")
	local target_airstrike1 = Player_GetSquadConcentration(player1)
	if (target_airstrike1) then
		Cmd_Ability (player3, ABILITY.GERMAN.STUKA_CLOSE_AIR_SUPPORT, target_airstrike1, nil, true)
	end
end
function Phase4_Airstrike2()
	_ToWDebugDisplay ("Phase4_Airstrike2", "white")
	local target_airstrike2 = Player_GetSquadConcentration(player2)
	if (target_airstrike2) then
		Cmd_Ability (player4, ABILITY.GERMAN.STUKA_CLOSE_AIR_SUPPORT, target_airstrike2, nil, true)
	end
end
function Phase4_Airstrike3()
	_ToWDebugDisplay ("Phase4_Airstrike3", "white")
	if not Entity_IsStrategicPointCapturedBy(EGroup_GetSpawnedEntityAt(eg_vp1, 1), player3) then
		Cmd_Ability(player3, ABILITY.GERMAN.STUKA_BOMBING_STRIKE, eg_vp1, nil, true)
	end
	
end
function Phase4_Airstrike4()
	_ToWDebugDisplay ("Phase4_Airstrike4", "white")
	if Entity_IsStrategicPointCapturedBy(EGroup_GetSpawnedEntityAt(eg_vp2, 1), player1) then
		Cmd_Ability(player3, ABILITY.GERMAN.STUKA_BOMBING_STRIKE, eg_vp2, nil, true)
	end
	
	sg_phase4Flankers_p3_transport = SGroup_CreateIfNotFound("sg_phase4Flankers_p3_transport")
	sg_phase4Flankers_p3_troops = SGroup_CreateIfNotFound("sg_phase4Flankers_p3_troops")
	local encData = {
		name = "Night 2 Halftrack P3",
		spawn = mkr_northFlank_spawn,
		player = player3,
		sgroups = {sg_phase4Flankers_p3_transport},
		units = {
			{
				sbp = SBP.GERMAN.SDKFZ_251_HALFTRACK_SQUAD,
			},
		},
		onDeath = nil,
	}
	phase4Flankers_p3_transport = Encounter:Create(encData)

	local goalData = {
		name = "Attack",
		target = eg_vp2,
		attackMove = true,
		maxTime = 120,
		maxIdleTime = 30,
		onSuccess = function ()
			Util_ReAllowAI(sg_phase4Flankers_p3_transport)
		end,
		onFailure = function ()
			Util_ReAllowAI(sg_phase4Flankers_p3_transport)
		end,
	}
	phase4Flankers_p3_transport:SetGoal(goalData)
	
	Event_Timer(FlankersInTransport, nil, 1)
end

function FlankersInTransport (data)
	local encData = {
		name = "Night 2 Flankers P3",
		player = player3,
		sgroups = {sg_phase4Flankers_p3_troops},
		units = {
			{
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
				upgrades = {BP_GetUpgradeBlueprint("panzerbusche_39")},
				numSquads = 2,
				spawn = sg_phase4Flankers_p3_transport,
			},
		},
		onDeath = nil,
	}
	phase4Flankers_p3_troops = Encounter:Create(encData)
	local data = {enc = phase4Flankers_p3_troops, target = eg_vp2, group = sg_phase4Flankers_p3_troops}
	Event_Proximity(UnloadAndAttack, data, sg_phase4Flankers_p3_transport, eg_vp2, 40, ANY, 1)
	Event_GroupIsDead(UnloadAndAttack, data, sg_phase4Flankers_p3_transport)
end

function UnloadAndAttack (data)
	_ToWDebugDisplay ("UnloadAndAttack for " .. SGroup_GetName(data.group), "white")
	
	local goalData = {
		name = "Attack",
		target = data.target,
		attackMove = true,
		maxTime = 120,
		maxIdleTime = 30,
		onSuccess = function ()
			Util_ReAllowAI(data.group)
		end,
		onFailure = function ()
			Util_ReAllowAI(data.group)
		end,
	}
	
	if data.group == sg_phase4Flankers_p3_troops then
		if not g_p3_flankers_unloaded then
			data.enc:SetGoal(goalData)
			g_p3_flankers_unloaded = true
		end
	elseif data.group == sg_phase4Flankers_p4_troops then
		if not g_p4_flankers_unloaded then
			data.enc:SetGoal(goalData)
			g_p4_flankers_unloaded = true
		end
	end

end


function Phase4_Airstrike5()
	_ToWDebugDisplay ("Phase4_Airstrike5", "white")
	if Entity_IsStrategicPointCapturedBy(EGroup_GetSpawnedEntityAt(eg_vp3, 1), player1) then
		Cmd_Ability(player3, ABILITY.GERMAN.STUKA_BOMBING_STRIKE, eg_vp3, nil, true)
	end
	sg_phase4Flankers_p4_transport = SGroup_CreateIfNotFound("sg_phase4Flankers_p4_transport")
	sg_phase4Flankers_p4_troops = SGroup_CreateIfNotFound("sg_phase4Flankers_p4_troops")
	local encData = {
		name = "Night 2 Flankers",
		spawn = mkr_eastFlank_spawn,
		player = player4,
		sgroups = {sg_phase4Flankers_p4_transport},
		units = {
			{
				sbp = SBP.GERMAN.SDKFZ_251_HALFTRACK_SQUAD,
			},
		},
		onDeath = nil,
	}
	phase4Flankers_p4 = Encounter:Create(encData)

	local goalData = {
		name = "Attack",
		target = eg_vp3,
		attackMove = true,
		onSuccess = function ()
			Util_ReAllowAI(sg_phase4Flankers_p4_transport)
		end,
		onFailure = function ()
			Util_ReAllowAI(sg_phase4Flankers_p4_transport)
		end,
	}
	phase4Flankers_p4:SetGoal(goalData)
	Event_Timer(FlankersInTransportB, nil, 1)
end

function FlankersInTransportB (data)
	local encData = {
		name = "Night 2 Flankers P4",
		player = player4,
		sgroups = {sg_phase4Flankers_p4_troops},
		units = {
			{
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
				upgrades = {BP_GetUpgradeBlueprint("panzerbusche_39")},
				numSquads = 2,
				spawn = sg_phase4Flankers_p4_transport,
			},
		},
		onDeath = nil,
	}
	phase4Flankers_p4_troops = Encounter:Create(encData)
	local data = {enc = phase4Flankers_p4_troops, target = eg_vp3, group = sg_phase4Flankers_p4_troops}
	Event_Proximity(UnloadAndAttack, data, sg_phase4Flankers_p4_transport, eg_vp3, 40, ANY, 1)
	Event_GroupIsDead(UnloadAndAttack, data, sg_phase4Flankers_p4_transport)
end


function Phase4_GermanReinforcements()
	_ToWDebugDisplay ("Phase4_GermanReinforcements", "white")
	local list = {
		SBP.GERMAN.PANZER_IV_STUBBY_SQUAD,
		SBP.GERMAN.PANZER_IV_STUBBY_SQUAD,
		SBP.GERMAN.PANZER_IV_STUBBY_SQUAD,
	}
	SpawnList(player3, list, flank_p3)
	SpawnList(player4, list, flank_p4)
end

-- PHASE 5 (DAY 3)
function Phase5_Start()
	_ToWDebugDisplay ("Phase5_Start", "white")
	if not Player_HasAbility(player3, ABILITY.GERMAN.RAILWAY_GUN_ARTILLERY) then
		Player_AddAbility(player3, ABILITY.GERMAN.RAILWAY_GUN_ARTILLERY)
	end
	if not Player_HasAbility(player4, ABILITY.GERMAN.RAILWAY_GUN_ARTILLERY) then
		Player_AddAbility(player4, ABILITY.GERMAN.RAILWAY_GUN_ARTILLERY)
	end
	
	Objective_UpdateText(OBJ_Brody, Loc_FormatText(11036694, Loc_ConvertNumber(3)), 0, false)
	Util_MissionTitle(11038548) -- LOCDB [11038548] 'Day 3 - Reinforcements approaching'
	Util_StartIntel ( EVENTS.DayThree )
	BonusSelect_ShowButtons()
	
	Rule_AddOneShot(Phase5_ArtilleryA, 190)
	Rule_AddOneShot(Phase5_ArtilleryB, 205)
	Rule_AddOneShot(Phase5_ArtilleryC, 220)
	
end


function Phase5_Reinforcements(player, level)
	local spawnlocations = spawnlocations_p1
	if player == player2 then
		spawnlocations = spawnlocations_p2
	end
	local list = {
		{	-- reinforcement level 1
			SBP.SOVIET.T_70M,
			SBP.SOVIET.T_70M,
		},
		{	-- reinforcement level 2
			SBP.SOVIET.T_70M,
			SBP.SOVIET.T_34_76_SQUAD,
			SBP.SOVIET.T_34_76_SQUAD,
		},
		{	-- reinforcement level 3
			SBP.SOVIET.KV_1,
			SBP.SOVIET.KV_1,
			SBP.SOVIET.T_34_76_SQUAD,
			SBP.SOVIET.T_34_76_SQUAD,
		},
	}
	if level >= 1 then
		SpawnList(player, list[level], spawnlocations)
	end
end

function Phase5_ArtilleryA ()
	_ToWDebugDisplay ("Phase5_ArtilleryA", "white")

	if Entity_IsStrategicPointCapturedBy(EGroup_GetSpawnedEntityAt(eg_vp1, 1), player1) then
		EventCue_Create(CUE.ATTACKED, 11038432,  nil, eg_vp1) -- LOCDB [11038432] 'Artillery Incoming'
		local hint = HintPoint_Add(eg_vp1, true, 11038432, 3, HPAT_Hint)
		Event_Timer(RemoveHint, {id=hint}, 15)
		Cmd_Ability (player3, ABILITY.GERMAN.RAILWAY_GUN_ARTILLERY, eg_vp1, nil, true)
	end
	
end

function Phase5_ArtilleryB ()
	_ToWDebugDisplay ("Phase5_ArtilleryB", "white")

	if Entity_IsStrategicPointCapturedBy(EGroup_GetSpawnedEntityAt(eg_vp2, 1), player1) then
		EventCue_Create(CUE.ATTACKED, 11038432,  nil, eg_vp2) -- LOCDB [11038432] 'Artillery Incoming'
		local hint = HintPoint_Add(eg_vp2, true, 11038432, 3, HPAT_Hint)
		Event_Timer(RemoveHint, {id=hint}, 15)
		Cmd_Ability (player3, ABILITY.GERMAN.RAILWAY_GUN_ARTILLERY, eg_vp2, nil, true)
	end
	
end

function Phase5_ArtilleryC ()
	_ToWDebugDisplay ("Phase5_ArtilleryC", "white")

	if Entity_IsStrategicPointCapturedBy(EGroup_GetSpawnedEntityAt(eg_vp3, 1), player1) then
		EventCue_Create(CUE.ATTACKED, 11038432,  nil, eg_vp3) -- LOCDB [11038432] 'Artillery Incoming'
		local hint = HintPoint_Add(eg_vp3, true, 11038432, 3, HPAT_Hint)
		Event_Timer(RemoveHint, {id=hint}, 15)
		Cmd_Ability (player3, ABILITY.GERMAN.RAILWAY_GUN_ARTILLERY, eg_vp3, nil, true)
	end
	
end

function RemoveHint (data)
	HintPoint_Remove(data.id)
end


-- PHASE 6 (DAY 3 NIGHT)
-- German anti-tank units
function Phase6_Start()
	_ToWDebugDisplay ("Phase6_Start", "white")
	Rule_AddOneShot(Phase6_GermanReinforcements, 15)
	Rule_AddOneShot(Phase6_GermanReinforcementsB, 130)
end

function Phase6_GermanReinforcements()
	_ToWDebugDisplay ("Phase6_GermanReinforcements", "white")
	local list = {
		SBP.GERMAN.STUG_III_E_SQUAD,
		SBP.GERMAN.STUG_III_E_SQUAD,
		SBP.GERMAN.PANZER_IV_STUBBY_SQUAD,
		SBP.GERMAN.PANZER_IV_STUBBY_SQUAD,
		SBP.GERMAN.PANZER_IV_STUBBY_SQUAD,
		{sbp = SBP.GERMAN.SCOUTCAR_SDKFZ222, upg = UPG.GERMAN.SDKFZ_222_20MM_GUN},
		{sbp = SBP.GERMAN.SCOUTCAR_SDKFZ222, upg = UPG.GERMAN.SDKFZ_222_20MM_GUN},
		SBP.GERMAN.MORTAR_250_HALFTRACK_SQUAD,
	}
	SpawnList(player3, list, spawnlocations_p3)
	SpawnList(player4, list, spawnlocations_p4)

end


function Phase6_GermanReinforcementsB()
	_ToWDebugDisplay ("Phase6_GermanReinforcementsB", "white")
	local list = {
		SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD,
		{sbp = SBP.GERMAN.SCOUTCAR_SDKFZ222, upg = UPG.GERMAN.SDKFZ_222_20MM_GUN},
		{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD, upg = BP_GetUpgradeBlueprint("panzerbusche_39")},
		{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD, upg = BP_GetUpgradeBlueprint("panzerbusche_39")},
		{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD, upg = BP_GetUpgradeBlueprint("panzerbusche_39")},
		{sbp = SBP.GERMAN.SDKFZ_251_HALFTRACK_SQUAD, upg = UPG.GERMAN.SDKFZ_251_HALFTRACK_FLAMMPANZERWAGEN_UPGRADE},
	}
	SpawnList(player3, list, northFlank)
	SpawnList(player4, list, eastFlank)

end

-- PHASE 7 (DAY 4)
-- Final day
function Phase7_Start()
	_ToWDebugDisplay ("Phase7_Start", "white")
	if not Player_HasAbility(player3, ABILITY.GERMAN.RAILWAY_GUN_ARTILLERY) then
		Player_AddAbility(player3, ABILITY.GERMAN.RAILWAY_GUN_ARTILLERY)
	end
	if not Player_HasAbility(player3, ABILITY.GERMAN.LIGHT_SUPPORT_ARTILLERY) then
		Player_AddAbility(player3, ABILITY.GERMAN.LIGHT_SUPPORT_ARTILLERY)
	end
	Objective_UpdateText(OBJ_Brody, Loc_FormatText(11036694, Loc_ConvertNumber(4)), 0, false)
	Util_MissionTitle(11038549) -- LOCDB [11038549] 'Day 4 - Reinforcements approaching'
	Util_StartIntel ( EVENTS.DayFour )
	BonusSelect_ShowButtons()
	
	Rule_AddOneShot(Phase7_CreepingBarrage, 180)
end

function Phase7_Reinforcements(player, level)
	local spawnlocations = spawnlocations_p1
	if player == player2 then
		spawnlocations = spawnlocations_p2
	end
	local list = {
		{	-- reinforcement level 1
			SBP.SOVIET.T_70M,
			SBP.SOVIET.T_70M,
		},
		{	-- reinforcement level 2
			SBP.SOVIET.T_70M,
			SBP.SOVIET.T_34_76_SQUAD,
			SBP.SOVIET.T_34_76_SQUAD,
		},
		{	-- reinforcement level 3
			SBP.SOVIET.KV_1,
			SBP.SOVIET.KV_1,
			SBP.SOVIET.KV_1,
			SBP.SOVIET.T_34_76_SQUAD,
			SBP.SOVIET.T_34_76_SQUAD,
			SBP.SOVIET.T_34_76_SQUAD,
		},
	}
	if level >= 1 then
		SpawnList(player, list[level], spawnlocations)
	end
end


function Phase7_CreepingBarrage()
	_ToWDebugDisplay ("Phase7_CreepingBarrage", "white")
	ArtyStrike ({marker=mkr_creeping_barrage_01M, ability=ABILITY.GERMAN.LIGHT_SUPPORT_ARTILLERY})
	Event_Timer(ArtyStrike, {marker=mkr_creeping_barrage_01W, ability=ABILITY.GERMAN.LIGHT_SUPPORT_ARTILLERY}, 1)
	Event_Timer(ArtyStrike, {marker=mkr_creeping_barrage_01E, ability=ABILITY.GERMAN.LIGHT_SUPPORT_ARTILLERY}, 2)
	if g_difficulty >= GD_HARD then
		Event_Timer(ArtyStrike, {marker=mkr_creeping_barrage_01M, ability=ABILITY.GERMAN.LIGHT_SUPPORT_ARTILLERY}, 10)
		Event_Timer(ArtyStrike, {marker=mkr_creeping_barrage_01W, ability=ABILITY.GERMAN.LIGHT_SUPPORT_ARTILLERY}, 11)
		Event_Timer(ArtyStrike, {marker=mkr_creeping_barrage_01E, ability=ABILITY.GERMAN.LIGHT_SUPPORT_ARTILLERY}, 12)
	end
	if g_difficulty >= GD_NORMAL then
		Event_Timer(ArtyStrike, {marker=mkr_creeping_barrage_01M, ability=ABILITY.GERMAN.RAILWAY_GUN_ARTILLERY}, 20)
		Event_Timer(ArtyStrike, {marker=mkr_creeping_barrage_01W, ability=ABILITY.GERMAN.RAILWAY_GUN_ARTILLERY}, 21)
		Event_Timer(ArtyStrike, {marker=mkr_creeping_barrage_01E, ability=ABILITY.GERMAN.RAILWAY_GUN_ARTILLERY}, 22)
	end
	
	Event_Timer(ArtyStrike, {marker=mkr_creeping_barrage_02M, ability=ABILITY.GERMAN.LIGHT_SUPPORT_ARTILLERY}, 30)
	Event_Timer(ArtyStrike, {marker=mkr_creeping_barrage_02W, ability=ABILITY.GERMAN.LIGHT_SUPPORT_ARTILLERY}, 31)
	Event_Timer(ArtyStrike, {marker=mkr_creeping_barrage_02E, ability=ABILITY.GERMAN.LIGHT_SUPPORT_ARTILLERY}, 32)
	if g_difficulty >= GD_HARD then
		Event_Timer(ArtyStrike, {marker=mkr_creeping_barrage_02M, ability=ABILITY.GERMAN.LIGHT_SUPPORT_ARTILLERY}, 40)
		Event_Timer(ArtyStrike, {marker=mkr_creeping_barrage_02W, ability=ABILITY.GERMAN.LIGHT_SUPPORT_ARTILLERY}, 41)
		Event_Timer(ArtyStrike, {marker=mkr_creeping_barrage_02E, ability=ABILITY.GERMAN.LIGHT_SUPPORT_ARTILLERY}, 42)
	end
	if g_difficulty >= GD_NORMAL then
		Event_Timer(ArtyStrike, {marker=mkr_creeping_barrage_02M, ability=ABILITY.GERMAN.RAILWAY_GUN_ARTILLERY}, 50)
		Event_Timer(ArtyStrike, {marker=mkr_creeping_barrage_02W, ability=ABILITY.GERMAN.RAILWAY_GUN_ARTILLERY}, 51)
		Event_Timer(ArtyStrike, {marker=mkr_creeping_barrage_02E, ability=ABILITY.GERMAN.RAILWAY_GUN_ARTILLERY}, 52)
	end
	Event_Timer(ArtyStrike, {marker=mkr_creeping_barrage_03M, ability=ABILITY.GERMAN.LIGHT_SUPPORT_ARTILLERY}, 60)
	Event_Timer(ArtyStrike, {marker=mkr_creeping_barrage_03W, ability=ABILITY.GERMAN.LIGHT_SUPPORT_ARTILLERY}, 61)
	Event_Timer(ArtyStrike, {marker=mkr_creeping_barrage_03E, ability=ABILITY.GERMAN.LIGHT_SUPPORT_ARTILLERY}, 62)
	if g_difficulty >= GD_HARD then
		Event_Timer(ArtyStrike, {marker=mkr_creeping_barrage_03M, ability=ABILITY.GERMAN.LIGHT_SUPPORT_ARTILLERY}, 70)
		Event_Timer(ArtyStrike, {marker=mkr_creeping_barrage_03W, ability=ABILITY.GERMAN.LIGHT_SUPPORT_ARTILLERY}, 71)
		Event_Timer(ArtyStrike, {marker=mkr_creeping_barrage_03E, ability=ABILITY.GERMAN.LIGHT_SUPPORT_ARTILLERY}, 72)
	end
	if g_difficulty >= GD_NORMAL then
		Event_Timer(ArtyStrike, {marker=mkr_creeping_barrage_03M, ability=ABILITY.GERMAN.RAILWAY_GUN_ARTILLERY}, 80)
		Event_Timer(ArtyStrike, {marker=mkr_creeping_barrage_03W, ability=ABILITY.GERMAN.RAILWAY_GUN_ARTILLERY}, 81)
		Event_Timer(ArtyStrike, {marker=mkr_creeping_barrage_03E, ability=ABILITY.GERMAN.RAILWAY_GUN_ARTILLERY}, 82)
	end

end


function ArtyStrike (data)
	local ability = data.ability or ABILITY.GERMAN.LIGHT_SUPPORT_ARTILLERY
	local marker = data.marker or mkr_creeping_barrage_01M
	local player = data.player or player3
	
	_ToWDebugDisplay("ArtyStrike: " .. BP_GetName(ability) .. " " .. Marker_GetName(marker), "gold")
	
	if not Player_HasAbility(player, ability) then
		Player_AddAbility(player,ability)
	end
	
	local pos = Util_GetRandomPosition(marker)
	if ability == ABILITY.GERMAN.RAILWAY_GUN_ARTILLERY then
		EventCue_Create(CUE.ATTACKED, 11038432,  nil, eg_vp1) -- LOCDB [11038432] 'Artillery Incoming'
		local hint = HintPoint_Add(pos, true, 11038432, 3, HPAT_Hint)
		Event_Timer(RemoveHint, {id=hint}, 15)
	end
	Cmd_Ability (player, ability, pos, nil, true)
end

-- PHASE 8 (NIGHT 4)
-- Final night
-- Huge all-out tank fight


function Phase8_Start()
	_ToWDebugDisplay ("Phase8_Start", "white")
	Rule_AddOneShot(Phase8_GermanReinforcements, 25)
	Rule_AddOneShot(Phase8_GermanReinforcementsB, 30)
end

function Phase8_GermanReinforcements()
	_ToWDebugDisplay ("Phase8_GermanReinforcements", "white")
	
	local list = {
		SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD,
		SBP.GERMAN.PANZER_GRENADIER_SQUAD,
		{sbp = SBP.GERMAN.GRENADIER_SQUAD, upg = UPG.GERMAN.GRENADIER_MG42_LMG},
		{sbp = SBP.GERMAN.GRENADIER_SQUAD, upg = UPG.GERMAN.GRENADIER_MG42_LMG},
		SBP.GERMAN.MORTAR_250_HALFTRACK_SQUAD,
	}
	SpawnList(player3, list, northFlank)
	SpawnList(player4, list, eastFlank)
	
end

function Phase8_GermanReinforcementsB()
	_ToWDebugDisplay ("Phase8_GermanReinforcementsB", "white")
	
	local list = {
		
		SBP.GERMAN.PANZER_IV_STUBBY_SQUAD,
		SBP.GERMAN.STUG_III_E_SQUAD,
		SBP.GERMAN.STUG_III_E_SQUAD,
		SBP.GERMAN.PANZER_IV_STUBBY_SQUAD,
		
		SBP.GERMAN.PANZER_IV_STUBBY_SQUAD,
		SBP.GERMAN.PANZER_IV_STUBBY_SQUAD,
		SBP.GERMAN.PANZER_IV_STUBBY_SQUAD,
		SBP.GERMAN.PANZER_IV_STUBBY_SQUAD,
	}
	SpawnList(player3, list, flank_p3)
	SpawnList(player4, list, flank_p4)
	
end

function SpawnList(player, list, locations, count)
	sg_temp = SGroup_CreateIfNotFound("sg_temp")
	count = count or #list
	for n = 1, count do 
		local what = list[n]
		local where = locations[math.mod(n, #locations) + 1]
		local upgrade = nil 
		local entityUpgrade = nil
		if scartype(what) == ST_TABLE then
			if (what.upg) then
				if (what.upg == UPG.GERMAN.SDKFZ_222_20MM_GUN) or (what.upg == UPG.GERMAN.SDKFZ_251_HALFTRACK_FLAMMPANZERWAGEN_UPGRADE) then
					entityUpgrade = what.upg
				else
					upgrade = what.upg
				end
			end
			what = what.sbp
		end
		if (entityUpgrade) then
			SGroup_Clear(sg_temp)
			Util_CreateSquads(player, sg_temp, what, where.spawn, where.dest, 1)
			SGroup_CompleteEntityUpgrade(sg_temp, entityUpgrade)
			SGroup_AddGroup(sg_blah, sg_temp)
			SGroup_Clear(sg_temp)
		else
			Util_CreateSquads(player, sg_blah, what, where.spawn, where.dest, 1, nil, nil, nil, upgrade)
		end
	end
	
	Rule_RemoveSGroupEvent(CountTankKills, sg_blah)
	Rule_AddSGroupEvent(CountTankKills, sg_blah, GE_SquadKilled)
end



---------------------------------
--                             --
-- Day / Night cycle functions --
--                             --
---------------------------------


function StartTransitionToNight()
	Game_LoadAtmosphere("data:art/scenarios/presets/atmosphere/_tow_brody_night.aps", 120)
	Rule_AddOneShot(StartTransitionToDay, (4 * 60))
end


function StartTransitionToDay()
	Game_LoadAtmosphere("data:art/scenarios/presets/atmosphere/_tow_brody_day.aps", 120)
	Rule_AddOneShot(StartTransitionToNight, (4 * 60))
end


-- this is called in the middle of the day/night transition
function MidTransitionPoint(data)
	current_phase = current_phase + 1									-- increment the phase count
	local startfunc = phase_data[current_phase].startfunc				-- if there is a start function associated with this phase, call it now
	if scartype(startfunc) == ST_FUNCTION then
		startfunc()
	end
	if IsDay() == true then
		data.text = 11036693
	else
		data.text = 11036698
	end
	data.time = 240
	if current_phase > 8 then
		Obj_HideProgress()
	else
		Obj_ShowProgress(data.text, 1)
		Event_Timer(Countdown, data, 1)
	end
end


function IsDay()
	if phase_data[current_phase].cycle == "day" then
		return true
	else
		return false
	end
end

function IsNight()
	if phase_data[current_phase].cycle == "night" then
		return true
	else
		return false
	end
end




----------------------------
--                        --
-- Select bonus functions --
--                        --
----------------------------
function BonusSelect_ShowButtons()
--~ 	Util_NewHUDFeatureEvent(HUDF_AbilityCard, 11038542, "Icons_faction_soviets_enemy", 10) -- LOCDB [11038542] 'Select Reinforcement Level. Choosing heavier reinforcements now will mean fewer reinforcements on later days.'
	for k,bonus in pairs (bonus_data) do
		if AI_IsEnabled (bonus.player) then
			BonusSelect_SelectDefault(bonus.player, current_phase)
		else
			if not bonus.level1Used then 
				Player_SetAbilityAvailability(bonus.player, ABILITY.GLOBAL.BONUS_1, ITEM_UNLOCKED) 
				ping1 = UI_FlashAbilityButton(ABILITY.GLOBAL.BONUS_1 , true) 
			end
			if not bonus.level2Used then 
				if current_phase >= 5 then
					Player_SetAbilityAvailability(bonus.player, ABILITY.GLOBAL.BONUS_2, ITEM_REMOVED) 
					Player_SetAbilityAvailability(bonus.player, BP_GetAbilityBlueprint("bonus_2b"), ITEM_UNLOCKED) 
					ping2 = UI_FlashAbilityButton(BP_GetAbilityBlueprint("bonus_2b") , true) 
				else
					Player_SetAbilityAvailability(bonus.player, ABILITY.GLOBAL.BONUS_2, ITEM_UNLOCKED) 
					ping2 = UI_FlashAbilityButton(ABILITY.GLOBAL.BONUS_2 , true) 
				end
			end
			if not bonus.level3Used then 
				if current_phase >= 7 then
					Player_SetAbilityAvailability(bonus.player, BP_GetAbilityBlueprint("bonus_3b"), ITEM_REMOVED) 
					Player_SetAbilityAvailability(bonus.player, ABILITY.GLOBAL.BONUS_3, ITEM_REMOVED) 
					Player_SetAbilityAvailability(bonus.player, BP_GetAbilityBlueprint("bonus_3c"), ITEM_UNLOCKED) 
					ping3 = UI_FlashAbilityButton(BP_GetAbilityBlueprint("bonus_3c") , true) 
				elseif current_phase >= 5 then
					Player_SetAbilityAvailability(bonus.player, ABILITY.GLOBAL.BONUS_3, ITEM_REMOVED) 
					Player_SetAbilityAvailability(bonus.player, BP_GetAbilityBlueprint("bonus_3b"), ITEM_UNLOCKED) 
					ping3 = UI_FlashAbilityButton(BP_GetAbilityBlueprint("bonus_3b") , true) 
				else
					Player_SetAbilityAvailability(bonus.player, ABILITY.GLOBAL.BONUS_3, ITEM_UNLOCKED) 
					ping3 = UI_FlashAbilityButton(ABILITY.GLOBAL.BONUS_3, true) 
				end
			end
		Event_Timer (RemoveAbilityPings, nil, 5)
		end
	end
end


function RemoveAbilityPings ()

	if (ping1) then
		UI_StopFlashing( ping1)
	end
	if (ping2) then
		UI_StopFlashing( ping2)
	end
	if (ping3) then
		UI_StopFlashing( ping3)
	end

end

function BonusSelect_SelectDefault(player, phase)
	if phase     >= 7 then
		Phase7_Reinforcements(player, 3)
	elseif phase     >= 5 then
		Phase7_Reinforcements(player, 2)
	elseif phase     >= 3 then
		Phase7_Reinforcements(player, 1)
	end
end

function BonusSelect_Selected (player, ability)
	if ability == ABILITY.GLOBAL.BONUS_1 
		or ability == ABILITY.GLOBAL.BONUS_2 
		or ability == BP_GetAbilityBlueprint("bonus_2b") 
		or ability == BP_GetAbilityBlueprint("bonus_3b") 
		or ability == BP_GetAbilityBlueprint("bonus_3c") 
		or ability == ABILITY.GLOBAL.BONUS_3 then
		
		for k, bonus in pairs(bonus_data) do
			if player == bonus.player then
				bonus.levelsUsed = bonus.levelsUsed + 1
				if ability == ABILITY.GLOBAL.BONUS_1 then
					bonus.currentselection = 1
					bonus.level1Used = true
					Player_SetAbilityAvailability(bonus.player, ABILITY.GLOBAL.BONUS_1, ITEM_REMOVED)
				elseif ability == ABILITY.GLOBAL.BONUS_2 then
					bonus.currentselection = 2
					bonus.level2Used = true
					Player_SetAbilityAvailability(bonus.player, ABILITY.GLOBAL.BONUS_2, ITEM_REMOVED)
				elseif ability == ABILITY.GLOBAL.BONUS_3 then
					bonus.currentselection = 3
					bonus.level3Used = true
					Player_SetAbilityAvailability(bonus.player, ABILITY.GLOBAL.BONUS_3, ITEM_REMOVED)
				elseif ability == BP_GetAbilityBlueprint("bonus_2b") then
					bonus.currentselection = 2
					bonus.level2Used = true
					Player_SetAbilityAvailability(bonus.player, BP_GetAbilityBlueprint("bonus_2b"), ITEM_REMOVED)
				elseif ability == BP_GetAbilityBlueprint("bonus_3b") then
					bonus.currentselection = 3
					bonus.level3Used = true
					Player_SetAbilityAvailability(bonus.player, BP_GetAbilityBlueprint("bonus_3b"), ITEM_REMOVED)
				elseif ability == BP_GetAbilityBlueprint("bonus_3c") then
					bonus.currentselection = 3
					bonus.level3Used = true
					Player_SetAbilityAvailability(bonus.player, BP_GetAbilityBlueprint("bonus_3c"), ITEM_REMOVED)
				end
				
				if current_phase     >= 7 then
					Phase7_Reinforcements(bonus.player, bonus.currentselection)
					if bonus.levelsUsed >= 3 then
						RemoveSubMenu (player)
					end
				elseif current_phase >= 5 then
					Phase5_Reinforcements(bonus.player, bonus.currentselection)
					if bonus.levelsUsed >= 2 then
						RemoveSubMenu (player)
					end
				elseif current_phase >= 3 then
					Phase3_Reinforcements(bonus.player, bonus.currentselection)
					RemoveSubMenu (player)
				end
			end
		end
	end
end

function RemoveSubMenu (player)
	Player_SetAbilityAvailability(player, ABILITY.GLOBAL.BONUS_1, ITEM_REMOVED)
	Player_SetAbilityAvailability(player, ABILITY.GLOBAL.BONUS_2, ITEM_REMOVED)
	Player_SetAbilityAvailability(player, ABILITY.GLOBAL.BONUS_3, ITEM_REMOVED)
	Player_SetAbilityAvailability(player, BP_GetAbilityBlueprint("bonus_2b"), ITEM_REMOVED)
	Player_SetAbilityAvailability(player, BP_GetAbilityBlueprint("bonus_3b"), ITEM_REMOVED)
	Player_SetAbilityAvailability(player, BP_GetAbilityBlueprint("bonus_3c"), ITEM_REMOVED)
	Player_SetAbilityAvailability(player, BP_GetAbilityBlueprint("bonus_back"), ITEM_REMOVED)
end



-----------------------------
--                         --
-- Victory point functions --
--                         --
-----------------------------

function VP_Check()

	local lossPoints = 0
	
	local _CheckEntity = function(gid, idx, eid)
		if Entity_IsStrategicPointCapturedBy(eid, player3) then
			lossPoints = lossPoints + t_difficulty.enemyRate
		elseif World_OwnsEntity(eid) then
			lossPoints = lossPoints + t_difficulty.neutralRate
		else
			lossPoints = lossPoints - t_difficulty.friendlyRate
		end
	end
	EGroup_ForEach(eg_victorypoints, _CheckEntity)
	
	
	if lossPoints < 0 then
		if ticker_count >= t_difficulty.startingTickers then
			lossPoints = 0
		elseif g_difficulty > GD_EASY then
			lossPoints = 0
		end
	end
	
	ticker_count = math.max((ticker_count - lossPoints), 0)
	ticker_count = math.min((ticker_count), t_difficulty.startingTickers)
	
	if not (skippedPhases) then 
		skippedPhases = 0
	end
	
	if ( lossPoints > 0 ) and ( current_phase > 2 ) then
		local timeToLoss = ticker_count/lossPoints 
		local timeLeft = (240 * (8 - skippedPhases)) - World_GetGameTime()
		
		if timeToLoss < timeLeft then
			if not Rule_Exists(LossWarning) then
				_ToWDebugDisplay ("Current loss rate means a defeat", "gold")
				Rule_AddInterval(LossWarning, 30)
			end
		else
			if Rule_Exists(LossWarning) then
				_ToWDebugDisplay ("Current loss rate means a victory.", "gold")
				Rule_Remove (LossWarning)
			end
		end
	else
		if Rule_Exists(LossWarning) then
			_ToWDebugDisplay ("No current loss rate.", "gold")
			Rule_Remove (LossWarning)
		end
	end
	
	LossCueCheck(ticker_count)
	
	if not (g_currentLossRate) then
		g_currentLossRate = 0
	end
	
	if not (g_rateText) then
		g_rateText = 11048672
	end
	
	if lossPoints ~= g_currentLossRate then
		if lossPoints == 0 then
			_ToWDebugDisplay ("VP Tickers stable.", "cyan")
			Objective_UpdateText(OBJ_Ticker, 11042752, 0 , false)
			g_rateText = 11048672
		elseif lossPoints < 0 then
			local minRate = math.floor(lossPoints * 60)
			_ToWDebugDisplay ("Gaining " .. tostring(0 - lossPoints) .. " VP Tickers per second.", "cyan")
			Objective_UpdateText(OBJ_Ticker, Loc_FormatText(11042753, Loc_ConvertNumber(0 - minRate)), 0 , false) -- LOCDB [11042753] 'Gaining %1NUMBER% VP Tickers per second.'
			g_rateText = Loc_FormatText(11048673, Loc_ConvertNumber(0 - minRate))
		elseif lossPoints > 0 then
			local minRate = math.floor(lossPoints * 60)
			_ToWDebugDisplay ("Losing " .. tostring(lossPoints) .. " VP Tickers per second.", "cyan")
			Objective_UpdateText(OBJ_Ticker, Loc_FormatText(11042754, Loc_ConvertNumber(minRate)), 0 , false) -- LOCDB [11042754] 'Losing %1NUMBER% VP Tickers per second.'
			g_rateText = Loc_FormatText(11048674, Loc_ConvertNumber(minRate))
		end
		g_currentLossRate = lossPoints
	end
	
	local ticker_display = math.floor(ticker_count)
	
	local barText = Loc_FormatText(11048675, Loc_ConvertNumber(ticker_display), Loc_ConvertNumber(t_difficulty.startingTickers), g_rateText)
	
	Obj_ShowProgress2(barText, ticker_count/t_difficulty.startingTickers)
	
	if ticker_count <= 0 then
		Rule_RemoveMe()
		Objective_Fail(OBJ_Brody)
	end
end


function LossCueCheck(tickers)
	for k,v in pairs (LossCues) do
		if ( tickers <= v.tickerValue ) and (v.played == false) then
			WinWarning_ShowLoseWarning(v.loseWarning, 0.125, 2.25, 0.125)
			if (v.speech) then
				Sound_PlayStreamed(v.speech)
			end
			v.played = true
		end
	end
end


function LossWarning()
	local warnings = {
		EVENTS.Warning1,
		EVENTS.Warning2,
		EVENTS.Warning3,
	}
	if not (g_warningIndex) then
		g_warningIndex = 1
	elseif g_warningIndex > #warnings then
		g_warningIndex = 1
	end
	
	if ticker_count > 100 then
		Util_StartIntel(warnings[g_warningIndex])
		g_warningIndex = g_warningIndex + 1
	end
	
	EGroup_Clear(eg_temp)
	
	local function _CheckVPs(egroup, index, entity)
		if Entity_IsStrategicPointCapturedBy(entity, player3) then
			EGroup_Add(eg_temp, entity)
		elseif World_OwnsEntity(entity) then
			EGroup_Add(eg_temp, entity)
		end
	end
	
	EGroup_ForEach(eg_victorypoints, _CheckVPs)
	
	if EGroup_Count(eg_temp) > 0 then
	
		local pings = {}
		local function AddPing(egroup, index, entity) 
			local ping = Objective_AddPing(OBJ_Brody, entity)
			table.insert(pings, ping)
		end
		
		EGroup_ForEach(eg_temp, AddPing)
		
		Event_Timer (RemovePings, pings, 10)
	
	end
	
end

function RemovePings (pings)
	for k,ping in pairs (pings) do
		Objective_RemovePing(OBJ_Brody, ping)
	end
end

---------------------------
--                       --
-- End mission functions --
--                       --
---------------------------

function EndMission()
	if Rule_Exists(StartTransitionToNight) then Rule_Remove(StartTransitionToNight) end
	if Rule_Exists(StartTransitionToDay) then Rule_Remove(StartTransitionToDay) end
	if Rule_Exists(MidTransitionPoint) then Rule_Remove(MidTransitionPoint) end
	if Rule_Exists(VP_Check) then Rule_Remove(VP_Check) end
	Obj_HideProgress()
	Objective_Complete(OBJ_Brody)
	Rule_AddOneShot(Mission_MissionComplete, 1)
end

function EndSpeech()
	if not Event_IsAnyRunning() then
		Rule_RemoveMe()
		Util_StartIntel(EVENTS.VPVictoryMessage)
	end
end


function Mission_MissionComplete()
	
	if not Player_HasAbility(player1, ABILITY.SOVIET.IL_2_SUPPORT_PRECISION_SP) then
		Player_AddAbility(player1, ABILITY.SOVIET.IL_2_SUPPORT_PRECISION_SP)
		Player_SetAbilityAvailability(player1, ABILITY.SOVIET.IL_2_SUPPORT_PRECISION_SP , ITEM_REMOVED)
	end
	
	local target1 = Player_GetSquadConcentration(player3, nil, {SBP.GERMAN.PANZER_IV_STUBBY_SQUAD, SBP.GERMAN.STUG_III_E_SQUAD})
	
	if (target1) then
		Cmd_Ability(player1, ABILITY.SOVIET.IL_2_SUPPORT_PRECISION_SP, target1, nil, true, false)
	end
	
	local target2 = Player_GetSquadConcentration(player4, nil, {SBP.GERMAN.PANZER_IV_STUBBY_SQUAD, SBP.GERMAN.STUG_III_E_SQUAD})
	
	if (target2) then
		Cmd_Ability(player1, ABILITY.SOVIET.IL_2_SUPPORT_PRECISION_SP, target2, nil, true, false)
	end
	-- wee camera pan if we have only one human player
	if not (Player_IsHuman(player1) and Player_IsHuman(player2)) then
		Game_SetMode(UI_Cinematic)
		if (target1) then
			Camera_MoveTo(target1, true, 0.05)
		elseif (target2) then
			Camera_MoveTo(target2, true, 0.05)
		end
	end

	Rule_AddDelayedInterval(Mission_MissionEnd, 14, 1)
end

function Mission_MissionEnd()
	if not Event_IsAnyRunning() then
		Rule_RemoveMe()
		Game_SetMode(UI_Normal)
		Camera_SetInputEnabled(true)
		World_SetTeamWin(Player_GetTeam(World_GetPlayerAt(1)))
	end
end

---------------------------------
---

function Util_ReAllowAI(sgroup)
	_ToWDebugDisplay("Util_ReAllowAI " .. SGroup_GetName(sgroup), "gold")
	if AI_IsEnabled(player3) then
		AI_UnlockSquads(player3, sgroup)
	end
	if AI_IsEnabled(player4) then
		AI_UnlockSquads(player4, sgroup)
	end
end

function CountTankKills(squad)
	if Squad_GetPlayerOwner(squad) == player3 or Squad_GetPlayerOwner(squad) == player4 then
		if Squad_GetBlueprint(squad) == SBP.GERMAN.PANZER_IV_SQUAD or
			Squad_GetBlueprint(squad) == SBP.GERMAN.PANZER_IV_STUBBY_SQUAD or
			Squad_GetBlueprint(squad) == SBP.GERMAN.PANZER_IV_COMMAND_SQUAD or
			Squad_GetBlueprint(squad) == SBP.GERMAN.STUG_III_E_SQUAD then
				sg_attacker = SGroup_CreateIfNotFound("sg_attacker")
				SGroup_Clear(sg_attacker)
				Squad_GetLastAttacker(squad, sg_attacker)
				if SGroup_Count(sg_attacker) > 0 then
					for k,bonus in pairs (bonus_data) do
						if bonus.player == Squad_GetPlayerOwner(SGroup_GetSpawnedSquadAt(sg_attacker, 1)) then
							bonus.tankKills = bonus.tankKills + 1
							if bonus.tankKills >= 20 then
								_ToWDebugDisplay("ACHIEVEMENT: tow_brody_tank_war_panzer_graveyard for player " .. k, "gold")
								Scar_CompleteIntelBulletinTask(bonus.player, "tow_brody_tank_war_panzer_graveyard")
							end
						end
					end
				end
		end
	end
end
