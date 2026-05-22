--=====================================================================================================--
--=====================================================================================================--
--==============			       CHALLENGE German Defence Challenge			  =====================--
--============== 				Designer: Eric Foster & Philippe Boulle			  =====================--
--=====================================================================================================--
--=====================================================================================================--

isCampaign = true
import("ScarUtil.scar")
import("TheatreOfWar.scar")
import("Systems/AiManager/ai.scar")
import("Global_Values/CampaignGlobalConstants.scar")

--=====================================================================================================--
--========================== Encounters & Addition Scripts Found Here   ===============================--
--=====================================================================================================--

import("TurtleWaves.scar") -- <-- <-- <-- <-- <-- <-- <-- <-- <-- <--

--=====================================================================================================--
--======================================= MISSION SETUP   ============================================--
--=====================================================================================================--

function OnGameSetup()
	player1 = Setup_Player(1, 11038759, "german", 1)		-- player1 is always the human player
	player2 = Setup_Player(2, 11038758, "soviet", 2)		-- player2 is always the AI opponent
end

function OnGameRestore()
	player1 = World_GetPlayerAt(1)
	player2 = World_GetPlayerAt(2)
	Game_DefaultGameRestore()
end

--=====================================================================================================--
--======================================= MISSION ONINIT   ============================================--
--=====================================================================================================--

function OnInit()
		
	--[[ PRESET DEBUG CONDITIONS ]]
	Mission_Debug()
	
	--[[ SET DIFFICULTY ]]
	Mission_Difficulty()
	
	--[[ SET RESTRICTIONS ]]
	Mission_Restrictions()
	
	--[[ REGISTER OBJECTIVES ]]
	Initialize_Objectives()
	
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
	Player_SetEntityProductionAvailability(player1, EBP.GERMAN.FUEL_POST_GERMAN, ITEM_REMOVED)
	Player_SetEntityProductionAvailability(player1, EBP.GERMAN.MUNITION_POST_GERMAN, ITEM_REMOVED)
	Player_SetSquadProductionAvailability(player1, SBP.GERMAN.MORTAR_250_HALFTRACK_SQUAD, ITEM_REMOVED)
	-- Enable longer Soviet grenade timers
	Player_CompleteUpgrade(player2, BP_GetUpgradeBlueprint("soviet_grenades_long_timer"))
	Modify_ProjectileDelayTime (player2, BP_GetEntityBlueprint("rg_42_longtimer"), CAMPAIGN_PGREN_BUNDLED_TIMER)

end


function Mission_Difficulty()
	g_difficulty = Game_GetSPDifficulty()   
	_ToWDebugDisplay("********* DIFFICULTY: "..g_difficulty)
	
	t_difficulty = {
		startingManpower 			= Util_DifVar( {1000,  500, 250,  250} ), 	-- Easy, Medium, Hard, Hardest
		startingManpowerRate		= Util_DifVar( {   1,  0.8, 0.5, 0.25} ), 
		startingMunition			= Util_DifVar( { 300,  200,  90,    0} ), 
		startingMunitionRate		= Util_DifVar( {  10,    6,   3,    2} ), 
		startingFuel				= Util_DifVar( { 180,  100,  40,    0} ), 
		startingFuelRate			= Util_DifVar( {   3,    2,   1,    1} ), 
		awardMunition				= Util_DifVar( { 300,  150, 100,   60} ), 
		awardFuel					= Util_DifVar( { 100,   50,  25,   10} ), 
		awardAction					= Util_DifVar( { 500,  250, 125,   50} ), 
		squadsVeryMany				= Util_DifVar( {   4,    5,   6,    7} ), 
		squadsMany					= Util_DifVar( {   2,    3,   4,    5} ), 
		squadsSome					= Util_DifVar( {   1,    2,   3,    4} ), 
		squadsFew					= Util_DifVar( {   1,    1,   2,    3} ), 
		squadsVeryFew				= Util_DifVar( {   1,    1,   1,    2} ), 
		baseWaveDelay				= Util_DifVar( {  30,   20,  20,   15} ), 
		waveDelayReduction			= Util_DifVar( {   3,    2,   3,    3} ), 
		playerSetupTime				= Util_DifVar( { 120,   90,  60,   30} ),  	
	}
end

--=====================================================================================================--
--======================================= MISSION Preset   ============================================--
--=====================================================================================================--

function Mission_MissionPreset()

	-- variables
	g_pos = EGroup_GetPosition(eg_player_hq)
	
	-- Resource Mods
	Modify_PlayerResourceRate(player1, RT_Manpower, t_difficulty.startingManpowerRate, MUT_Multiplication)
	Modify_PlayerResourceRate(player1, RT_Munition, t_difficulty.startingMunitionRate, MUT_Multiplication)
	Modify_PlayerResourceRate(player1, RT_Fuel, 	t_difficulty.startingFuelRate, MUT_Multiplication)
	Player_SetResource(player1, RT_Manpower,  t_difficulty.startingManpower)
	Player_SetResource(player1, RT_Munition,  t_difficulty.startingMunition)
	Player_SetResource(player1, RT_Fuel,      t_difficulty.startingFuel)
	Player_SetResource(player2, RT_Munition, 250)
	
	-- Commander abilities
	Player_CompleteUpgrade(player1, UPG.GERMAN.PANZER_TACTICIAN) -- 1 CP
	Player_CompleteUpgrade(player1, UPG.GERMAN.MORTAR_HALFTRACK)  -- 3 CP
	Player_CompleteUpgrade(player1, UPG.GERMAN.STUKA_CLOSE_AIR_SUPPORT)  -- 5 CP
	Player_CompleteUpgrade(player1, UPG.GERMAN.RAILWAY_ARTILLERY_SUPPORT) -- 7 CP
	
	-- Player Units and Groups
	sg_player_starting_units = SGroup_CreateIfNotFound("sg_player_starting_units")
	Util_CreateSquads(player1, sg_player_starting_units, SBP.GERMAN.PIONEER_SQUAD, mkr_player_pioneer_01)
	
	-- camera / FoW
	Camera_SetDefault(nil, nil, 45)
	Camera_ResetToDefault()
	FOW_RevealMarker(mkr_leash, -1)
	
	SetUpWaveData()
	SetupAchievements()

	if (g_debug) then
		DEBUG_Beat_Selection_01()
	else
		startIntro()
	end
end

--=====================================================================================================--
--======================================== INTRO & MISSION START   ====================================--
--=====================================================================================================--
function DEBUG_Beat_Selection_01()
	UI_MessageBoxSetText(LOC("SELECT START"), LOC("Select the Mission beat to play"))
	UI_MessageBoxSetButton(DB_Button1, LOC("WITH INTRO"), LOC("Part 1"), "", true)
	UI_MessageBoxSetButton(DB_Button2, LOC("NO INTRO"), LOC("Part 2"), "", true)
	UI_MessageBoxSetButton(DB_Button3, LOC("NO SETUP TIME"), LOC("Part 3"), "", true)
	UI_MessageBoxShow(DC_Default, DEV_SelectPhase_Menu_01)
end

function DEV_SelectPhase_Menu_01(button)
	if button == DB_Button1 then
		startIntro()
	elseif button == DB_Button2 then
		Mission_MissionStart()
	elseif button == DB_Button3 then
		t_difficulty.playerSetupTime = 15
		Mission_MissionStart()
	end
end

function startIntro()
	Camera_SetInputEnabled(false)
	Game_Letterbox(true, 2)
	UI_SetForceShowSubtitles(true)
	Util_StartIntel(EVENTS.IntroNISLET)
end

function introReturn()
	Game_SetMode(UI_Normal)
	Camera_SetInputEnabled(true)
	Game_Letterbox(false, 2)
	Camera_ResetToDefault()
	Camera_SetSlideTargetRate(0.333)
	Mission_MissionStart()
end

function Mission_MissionStart()
	Rule_AddOneShot(Mission_DelayObjTitle, 4)
end

function Mission_DelayObjTitle()
	Objective_Start(OBJ_Main)
	Event_Timer (StartSetup, nil, 5)
end

function StartSetup(data)
	Objective_Start(OBJ_Setup)
end

--=====================================================================================================--
--========================================== Objectives  ==============================================--
--=====================================================================================================--

function Initialize_Objectives()
	
	g_bronze = 5
	g_silver = 7
	g_gold = 10
	OBJ_Main = {
		
		SetupUI = function() 
		end,
		
		OnStart = function()
			Event_GroupIsDead(HQLost, nil, eg_player_hq)
		end,
		
		OnComplete = function()
			Rule_AddOneShot(Mission_MissionComplete, 1)
		end,
		
		OnFail = function()
			Rule_AddOneShot(Mission_MissionComplete, 1)
		end,
		
		IsComplete = function()
			return false
		end,
		
		Intel_Start = 	 nil,						-- Event will play when obj starts but before any UI appears
		Intel_Complete = nil,						-- Event will play when obj completes but before UI is cleared
		Intel_Fail = 	 nil,						-- Event will play when obj fails but before UI is cleared
		Title = 		 11038808, -- LOCDB [11038808] 'Defend your Headquarters.'
		Description =  	 0,	-- Objective Description
		TitleFail = 	 11038809, -- LOCDB [11038809] 'Headquarters destroyed!'
		Type = 			 OT_Primary,				-- Objective Type (OT_Primary, OT_Secondary)
	}
	
	OBJ_Setup = {
		Parent = OBJ_Main,
		
		SetupUI = function() 
			HintPoint_Add(mkr_point_01, true, 11040300, 3, HPAT_Hint) -- LOCDB [11040300] 'Possible Approach'
			HintPoint_Add(mkr_point_02, true, 11040300, 3, HPAT_Hint) -- LOCDB [11040300] 'Possible Approach'
			HintPoint_Add(mkr_point_03, true, 11040300, 3, HPAT_Hint) -- LOCDB [11040300] 'Possible Approach'
			HintPoint_Add(mkr_point_04, true, 11040300, 3, HPAT_Hint) -- LOCDB [11040300] 'Possible Approach'
			HintPoint_Add(mkr_point_05, true, 11040300, 3, HPAT_Hint) -- LOCDB [11040300] 'Possible Approach'		
			ThreatArrow_CreateGroup(mkr_point_01)
			ThreatArrow_CreateGroup(mkr_point_02)
			ThreatArrow_CreateGroup(mkr_point_03)
			ThreatArrow_CreateGroup(mkr_point_04)
			ThreatArrow_CreateGroup(mkr_point_05)
		end,
		
		OnStart = function()
			Objective_StartTimer(OBJ_Setup, COUNT_DOWN, t_difficulty.playerSetupTime, 30)
			Event_Timer(CompleteSetup, nil, t_difficulty.playerSetupTime)
		end,
		
		OnComplete = function()
			HintPoint_RemoveAll()
			ThreatArrow_DestroyAllGroups()
			Objective_Start (OBJ_Silver)
			ToW_DefenseCreateWave (1)
			Rule_AddInterval(KillAllCowards, 2)
		end,
		
		OnFail = function()
		end,
		
		IsComplete = function()
			return false
		end,
		
		Intel_Start = 	 nil,						-- Event will play when obj starts but before any UI appears
		Intel_Complete = nil,						-- Event will play when obj completes but before UI is cleared
		Intel_Fail = 	 nil,						-- Event will play when obj fails but before UI is cleared
		Title = 		 Loc_FormatText(11038806, Loc_ConvertNumber(t_difficulty.playerSetupTime)), -- LOCDB [11038806] 'You have %1TIME% seconds to set up.'
		Description =  	 0,	-- Objective Description
		Type = 			 OT_Secondary,				-- Objective Type (OT_Primary, OT_Secondary)
	}
	

	OBJ_Silver = {
		Parent = OBJ_Main,
		Goal = g_silver,
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
		Title = 		Loc_FormatText(11047609, Loc_ConvertNumber(g_silver)), -- LOCDB [11035532] '%1LEVEL%: Defeat %2NUMBER% waves.'
		Description = 	0,			-- Objective Description
		Type = OT_Secondary,				-- Objective Type (OT_Primary, OT_Secondary)
	}
	
	OBJ_Gold = {
		Goal = g_gold,
		SetupUI = function() 
		end,
		
		OnStart = function()
			Objective_SetCounter(OBJ_Gold, g_silver, g_gold)
		end,
		
		OnComplete = function()
			Achieve ("tow_schildkroteberg_turtle_gold")
			Objective_Complete (OBJ_Main)
		end,
		
		OnFail = function()
		end,
		
		IsComplete = function()
			return false
		end,
		
		Intel_Start = EVENTS.Bonus,				-- Event will play when obj starts but before any UI appears
		Intel_Complete = nil,			-- Event will play when obj completes but before UI is cleared
		Intel_Fail = nil,				-- Event will play when obj fails but before UI is cleared
		Title = 		Loc_FormatText(11035532, 11047614, Loc_ConvertNumber(g_gold)), -- LOCDB [11035532] '%1LEVEL%: Defeat %2NUMBER% waves.'
		Description = 	0,			-- Objective Description
		Type = OT_Secondary,				-- Objective Type (OT_Primary, OT_Secondary)
	}
	
	Objective_Register(OBJ_Main)
	Objective_Register(OBJ_Setup)
	Objective_Register(OBJ_Silver)
	Objective_Register(OBJ_Gold)

end

function StartGold()
	if not Event_IsAnyRunning() then
		Rule_RemoveMe()
		Objective_Start(OBJ_Gold)
	end
end

function CompleteSetup(data)
	Objective_Complete(OBJ_Setup)
end

function HQLost(data)
	Objective_Fail(OBJ_Main)
end

--=====================================================================================================--
--======================================= Mission Complete Functions  =================================--
--=====================================================================================================--

function Mission_MissionComplete()
	if Rule_Exists(KillAllCowards) then
		Rule_Remove(KillAllCowards)
	end
	Game_SetMode(UI_Cinematic)
	Camera_MoveTo(g_pos, true, 0.05)
	if Objective_IsComplete(OBJ_Silver) then
		Util_StartIntel(EVENTS.VPVictoryMessage)
	end
	Event_RemoveAll()
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

--=====================================================================================================--
--======================================== MISC Functions  ===========================================--
--=====================================================================================================--


function ClearPing(data)
	HintPoint_Remove(data.id)
end


function KillAllCowards()
	sg_temp = SGroup_CreateIfNotFound("sg_temp")
	SGroup_Clear(sg_temp)
	World_GetSquadsNearMarker(player2, sg_temp, mkr_enemy_spawn_01, OT_Player)
	World_GetSquadsNearMarker(player2, sg_temp, mkr_enemy_spawn_02, OT_Player)
	World_GetSquadsNearMarker(player2, sg_temp, mkr_enemy_spawn_03, OT_Player)
	World_GetSquadsNearMarker(player2, sg_temp, mkr_enemy_spawn_04, OT_Player)
	World_GetSquadsNearMarker(player2, sg_temp, mkr_enemy_spawn_05, OT_Player)
	if SGroup_Count(sg_temp) > 0 then
		local function CowardKill(sgroup, index, squad)
			if Squad_IsRetreating(squad) then
				Squad_Destroy(squad)
			end
		end
		SGroup_ForEach(sg_temp, CowardKill)
	end
end

function VehicleWarning (data)
	Util_StartIntel(EVENTS.VehicleWarning)
end


-------------------------- ACHIEVEMENT FUNCTIONS ------------------------------------------

function Achieve(data)
	if scartype (data) == ST_STRING then
		data = { id = data }
	end
	_ToWDebugDisplay("ACHIEVEMENT: " .. data.id, "gold")
	Scar_CompleteIntelBulletinTask(player1, data.id)
end

function SetupAchievements()
	sg_panzers = SGroup_CreateIfNotFound("sg_panzers")
	sg_tripleVets = SGroup_CreateIfNotFound("sg_tripleVets")
	g_panzerCount = 0
	g_tripleVetCount = 0
	Rule_AddInterval(AchievementCheck, 1)
end

function AchievementCheck()
	Player_GetAll(player1)
	if g_tripleVetCount < 3 then
		SGroup_ForEach(sg_allsquads, CountVets)
		if g_tripleVetCount >= 3 then
			Achieve ("tow_schildkroteberg_tripple_tripple")
		end
	end
	if g_panzerCount < 3 then
		SGroup_Filter(sg_allsquads, {SBP.GERMAN.PANZER_IV_SQUAD, SBP.GERMAN.PANZER_IV_STUBBY_SQUAD}, FILTER_KEEP)
		SGroup_ForEach(sg_allsquads, CountPanzers)
		if g_panzerCount >= 3 then 
			Achieve ("tow_schildkroteberg_hard_shell")
		end
	end	
	if (g_tripleVetCount >= 3) and (g_panzerCount >= 3) then
		Rule_RemoveMe()
	end
end

function CountVets(sgroup, index, squad)
	if Squad_GetVeterancyRank(squad) >= 3 then
		if not SGroup_ContainsSquad(sg_tripleVets, Squad_GetGameID(squad)) then
			g_tripleVetCount = g_tripleVetCount + 1
			SGroup_Add(sg_tripleVets, squad)
		end
	end
end

function CountPanzers(sgroup, index, squad)
	if not SGroup_ContainsSquad(sg_panzers, Squad_GetGameID(squad)) then
		g_panzerCount = g_panzerCount + 1
		SGroup_Add(sg_panzers, squad)
	end
end

