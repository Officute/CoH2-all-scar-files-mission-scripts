--=====================================================================================================--
--=====================================================================================================--
--==============			        CHALLENGE Ice Challenge	            		  =====================--
--============== 					Designer: Lance Mueller & Philippe Boulle	  =====================--
--=====================================================================================================--
--=====================================================================================================--
isCampaign = true
import("ScarUtil.scar")
import("Systems/AiManager/ai.scar")
import("TheatreOfWar.scar")
import("Beginner.scar")
import("Global_Values/CampaignGlobalConstants.scar")

g_isWinterMap = true

--=====================================================================================================--
--========================== Encounters & Addition Scripts Found Here   ===============================--
--=====================================================================================================--

import("IceChallengeWaves.scar") 


--=====================================================================================================--
--======================================= MISSION SETUP   ============================================--
--=====================================================================================================--

function OnGameSetup()
	player1 = Setup_Player(1, 11038758, "soviet", 1)		-- player1 is always the human player
	player2 = Setup_Player(2, 11038759, "german", 2)		-- player2 is always the AI opponent
end

function OnGameRestore()
	player1 = World_GetPlayerAt(1)
	player2 = World_GetPlayerAt(2)
	Game_DefaultGameRestore()
end

function NIS_Init()
	NISOpening = "ToW\\Challenges\\Ice_Challenge\\nis\\ice_challenge_intro_v2" 
	nis_load(NISOpening)
	nis_setintransitiontime(0)
	nis_setouttransitiontime(1.5)
end

Scar_AddInit(NIS_Init)

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
	
	SetUpAchievements()
	
	--[[ MISSION PRESETS ]]
	Mission_MissionPreset()
	
end

Scar_AddInit(OnInit)

function Mission_Debug()
	g_debug = Misc_IsCommandLineOptionSet("debug") 
end

function Mission_Restrictions()
	ToW_SetUpTechTreeByYear(player1, 1941)
	
	-- Remove Ablilties
	Player_SetEntityProductionAvailability(player1, EBP.SOVIET.WEAPON_SUPPORT_CENTER, ITEM_REMOVED)
	Player_SetEntityProductionAvailability(player1, EBP.SOVIET.TANK_DEPOT, ITEM_REMOVED)
	Player_SetEntityProductionAvailability(player1, EBP.SOVIET.MOTORPOOL, ITEM_REMOVED)
	Player_SetEntityProductionAvailability(player1, EBP.SOVIET.BARRACKS, ITEM_REMOVED)
	Player_SetEntityProductionAvailability(player1, EBP.SOVIET.OBSERVATION_POST_FUEL, ITEM_REMOVED)
	Player_SetEntityProductionAvailability(player1, EBP.SOVIET.OBSERVATION_POST_MUNITION, ITEM_REMOVED)
	Player_SetEntityProductionAvailability(player1, EBP.SOVIET.M1937_152MM_ML_20_ARTILLERY, ITEM_REMOVED)
	
	-- Gives engineers bigger Detination packs for breaking ice
	Player_CompleteUpgrade(player1,BP_GetUpgradeBlueprint("tow_upgrade")) 
	Player_AddAbility(player1, BP_GetAbilityBlueprint("frontoviki_conscript_dispatch"))
	
	Player_CompleteUpgrade(player1, UPG.SOVIET.IL_2_RECON)
	Player_CompleteUpgrade(player1, UPG.SOVIET.IL_2_SUPPORT)
	-- Resource Mods
	Modify_PlayerResourceRate(player1, RT_Manpower, t_difficulty.startingManpowerRate, MUT_Multiplication)
	Modify_PlayerResourceRate(player1, RT_Munition, t_difficulty.startingMunitionRate, MUT_Multiplication)
	Modify_PlayerResourceRate(player1, RT_Fuel, 	0, MUT_Multiplication)

	Player_SetResource(player1, RT_Manpower,  t_difficulty.startingManpower)
	Player_SetResource(player1, RT_Munition,  t_difficulty.startingMunition)
	Player_SetResource(player1, RT_Fuel,      0)
	Player_SetResource(player1, RT_SovietProgression, 75)
	Rule_AddInterval(CapSovietProgression, 3)

end



function Mission_Difficulty()

	g_difficulty = Game_GetSPDifficulty()   
	_ToWDebugDisplay ("********* DIFFICULTY: "..g_difficulty)
	
	t_difficulty = {
		startingManpower 		= Util_DifVar( { 50,    0,   0,  0}, g_difficulty  ), 	-- Easy, Medium, Hard, Hardest
		startingManpowerRate	= Util_DifVar( {0.5, 0.25, 0.1,  0}, g_difficulty  ), 	-- Easy, Medium, Hard, Hardest
		startingMunition		= Util_DifVar( {180,   90,  45,  0}, g_difficulty  ), 	-- Easy, Medium, Hard, Hardest
		startingMunitionRate	= Util_DifVar( { 10,    6,   3,  2}, g_difficulty  ), 
		awardMunition			= Util_DifVar( {300,  150, 100, 60}, g_difficulty  ), 	-- Easy, Medium, Hard, Hardest
		awardAction				= Util_DifVar( {500,  250, 125, 50}, g_difficulty  ), 	-- Easy, Medium, Hard, Hardest
		squadsMany				= Util_DifVar( {  3,    4,   4,  5}, g_difficulty  ), 	-- Easy, Medium, Hard, Hardest
		squadsSome				= Util_DifVar( {  2,    2,   3,  4}, g_difficulty  ), 	-- Easy, Medium, Hard, Hardest
		squadsFew				= Util_DifVar( {  1,    1,   2,  3}, g_difficulty  ), 	-- Easy, Medium, Hard, Hardest
		squadsVeryFew			= Util_DifVar( {  1,    1,   1,  2}, g_difficulty  ), 	-- Easy, Medium, Hard, Hardest
		atGun 					= Util_DifVar({ SBP.SOVIET.M1942_ZIS_3_76MM_AT_GUN_SQUAD, 
											SBP.SOVIET.M1942_ZIS_3_76MM_AT_GUN_SQUAD,
											SBP.SOVIET.M1937_53_K_45MM_AT_GUN_SQUAD,
											SBP.SOVIET.M1937_53_K_45MM_AT_GUN_SQUAD,}, g_difficulty ),
	}  
	--adjust timer for panzergrenadier grenades
	Modify_ProjectileDelayTime (player2, BP_GetEntityBlueprint("bundled_stielgranate_campaign"), CAMPAIGN_PGREN_BUNDLED_TIMER)
end

function Mission_MissionPreset()
	
	-- Player Units and Groups
	
	sg_player_starting_units = SGroup_CreateIfNotFound("sg_player_starting_units")
	sg_mergehints = SGroup_CreateIfNotFound("sg_mergehints")
	Util_CreateSquads(player1, sg_player_starting_units, SBP.SOVIET.GUARDS_TROOPS, mkr_player_starting_units0)
	Util_CreateSquads(player1, sg_player_starting_units, SBP.SOVIET.COMBAT_ENGINEER_SQUAD, mkr_player_starting_units2)
	Util_CreateSquads(player1, {sg_player_starting_units,sg_mergehints}, SBP.SOVIET.BASE_CONSCRIPT_SQUAD, mkr_player_starting_units1)
	
	-- FOW
	FOW_RevealMarker(mkr_fow_reveal_1, -1)
	
	-- Ice Heal Rate
	World_SetIceHealingRate(0.0025)

	SetUpWaveData()
	Camera_FocusOnPosition(Marker_GetPosition(mkr_start), false)
	
	startIntro()
	BeginnerHint_AddOpportunity(sg_mergehints, HINT_MERGE, true)
	Rule_AddInterval(UpdateHintGroups, 30)
	
end

function UpdateHintGroups()

	local conscripts = {
		SBP.SOVIET.BASE_CONSCRIPT_SQUAD,
		SBP.SOVIET.CONSCRIPT_SQUAD,
		SBP.SOVIET.PENAL_BATTALION,
	}
	Player_GetAll(player1, sg_mergehints)
	SGroup_Filter(sg_mergehints, conscripts, FILTER_KEEP)
end


function SetUpAchievements()
	g_mobilizeCount = 0
	UI_SetModalAbilityPhaseCallback(CountMobilize)
	Rule_AddInterval (CheckForPanzerIV, 1)
end

--=====================================================================================================--
--======================================== MISSION START & OBJECTIVES   ===============================--
--=====================================================================================================--

function Mission_MissionStart()
	Rule_AddOneShot(Mission_DelayObjTitle, 2.5)
	Rule_AddOneShot(WaveOne, 15)
end

function WaveOne()
	ToW_DefenseCreateWave(1)
	Rule_AddDelayedInterval( CaptureTroops, 60, 30 )
end


function Mission_DelayObjTitle()
	Objective_Start(OBJ_Main)
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
	g_bronze = 5
	g_silver = 7
	g_gold = 10
	

	OBJ_Main = {
		
		SetupUI = function() 
			-- Use for creating any hint points or UI Elements
			-- eg: Objective_AddUIElements()
			
		end,
		
		OnStart = function()
			local sector = World_GetTerritorySectorID( EGroup_GetPosition(eg_player_point))
			Event_PlayerOwnsTerritory(MissionLose, nil, player2, sector)
		end,
		
		
		OnComplete = function()
			if Rule_Exists(CaptureTroops) then
				Rule_Remove(CaptureTroops)
			end
			
			Rule_AddOneShot(Mission_MissionComplete, 1)
		end,
		
		OnFail = function()
		
			if Rule_Exists(CaptureTroops) then
				Rule_Remove(CaptureTroops)
			end
			Rule_AddOneShot(Mission_MissionComplete, 1)
		end,
		
		IsComplete = function()
			return false
		end,
		
		Intel_Start = nil,				-- Event will play when obj starts but before any UI appears
		Intel_Complete = nil,			-- Event will play when obj completes but before UI is cleared
		Intel_Fail = nil,				-- Event will play when obj fails but before UI is cleared
		Title = 		11035531, -- LOCDB [11035531] 'Hold the point.'
		Description = 	0,
		Type = OT_Primary,				-- Objective Type (OT_Primary, OT_Secondary)
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
			Achieve ("tow_winter_defense_gold_defense")
			Objective_Complete(OBJ_Main)
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
	Objective_Register(OBJ_Silver)
	Objective_Register(OBJ_Gold)

end

--=====================================================================================================--
--======================================= MISSION END FUNCTIONS  ==========================================--
--=====================================================================================================--


function MissionLose(data)

	Objective_Fail(OBJ_Main)
	
end


function Mission_MissionComplete()

	Game_SetMode(UI_Cinematic)
	Camera_MoveTo(eg_player_point, true, 0.05)
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


--=====================================================================================================--
--======================================== INTRO FUNCTIONS  ===========================================--
--=====================================================================================================--

function startIntro()
	Camera_SetDefault(nil, nil, 45)
	Camera_ResetToDefault()
	Camera_SetInputEnabled(false)
	Game_Letterbox(true, 2)
	UI_SetForceShowSubtitles(true)

	if g_debug then
		DEBUG_Beat_Selection_01()
	else
		Util_StartIntel(EVENTS.Intro)
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
		Util_StartIntel(EVENTS.Intro)
	elseif button == DB_Button2 then
		introReturn()
	elseif button == DB_Button3 then
		_ToWDebugDisplay("No mission!", "gold")
		Game_Letterbox(false, 2)
		Camera_SetInputEnabled(true)
	end
end

function introReturn()
	Game_Letterbox(false, 2)
	Camera_SetInputEnabled(true)
	
	--[[ GAME START CHECK ]]
	Mission_MissionStart()
	
	local t_hints = {
		HintPoint_Add(mkr_point_02, true, 11040300, 3, HPAT_Hint), -- LOCDB [11040300] 'Possible Approach'
		HintPoint_Add(mkr_point_03, true, 11040300, 3, HPAT_Hint), -- LOCDB [11040300] 'Possible Approach'
		HintPoint_Add(mkr_point_04, true, 11040300, 3, HPAT_Hint), -- LOCDB [11040300] 'Possible Approach'
		HintPoint_Add(mkr_point_05, true, 11040300, 3, HPAT_Hint), -- LOCDB [11040300] 'Possible Approach'
	}
	
	local t_threats = {
		ThreatArrow_CreateGroup(mkr_point_02),
		ThreatArrow_CreateGroup(mkr_point_03),
		ThreatArrow_CreateGroup(mkr_point_04),
		ThreatArrow_CreateGroup(mkr_point_05),
	}
	
	Event_Proximity(ClearPing, {hint=t_hints[1], threat=t_threats[1],}, player1, mkr_point_02, 15, ANY)
	Event_Proximity(ClearPing, {hint=t_hints[2], threat=t_threats[2],}, player1, mkr_point_03, 15, ANY)
	Event_Proximity(ClearPing, {hint=t_hints[3], threat=t_threats[3],}, player1, mkr_point_04, 15, ANY)
	Event_Proximity(ClearPing, {hint=t_hints[4], threat=t_threats[4],}, player1, mkr_point_05, 15, ANY)
end


--=====================================================================================================--
--======================================== Other Functions  ===========================================--
--=====================================================================================================--

function CapSovietProgression()
	Player_SetResource(player1, RT_SovietProgression, 75)
end

function ClearPing(data)
	if (data.hint) then
		HintPoint_Remove(data.hint)
	end
	if (data.threat) then
		ThreatArrow_DestroyGroup(data.threat)
	end
end


function CaptureTroops()
	sg_temp = SGroup_CreateIfNotFound("sg_temp")
	SGroup_Clear(sg_temp)

	if Player_GetSquadCount(player1) < 1 then
		World_GetSquadsNearPoint (player2, sg_temp, EGroup_GetPosition(eg_player_point), 15, OT_Player)
		local cappers = 0
		for i=1,SGroup_Count(sg_temp) do
			local squad = SGroup_GetSpawnedSquadAt(sg_temp, i)
			if Squad_CanCaptureStrategicPoint(squad, EGroup_GetSpawnedEntityAt(eg_player_point, 1)) == true then
				cappers = cappers + 1
			end
		end
		
		if cappers == 0 then
			local encData = {
			name = "REPLACE_NAME",
			player = player2,
			sgroups = {SGroup_CreateIfNotFound("sg_cappers_wave" .. tostring(t_defData.currentWave))},
			units = {
						{
						sbp = SBP.GERMAN.GRENADIER_SQUAD,
						spawn = mkr_enemy_spawn1,
						},
						{
						sbp = SBP.GERMAN.GRENADIER_SQUAD,
						spawn = mkr_enemy_spawn1,
						},
				},
				onDeath = nil,
			}
			t_waves[t_defData.currentWave].cappers = Encounter:Create(encData)
			local goalData = {
				name = "Attack",
				target = mkr_fow_reveal_1,
				useSkirmishAI = true,
			}
			t_waves[t_defData.currentWave].cappers:SetGoal(goalData)
		end
	end
end

--------------------------------------------------------
-------------- ACHIEVEMENT FUNCTIONS -------------------
--------------------------------------------------------


function Achieve(data)
	if scartype (data) == ST_STRING then
		data = { id = data }
	end
	_ToWDebugDisplay("ACHIEVEMENT: " .. data.id, "gold")
	Scar_CompleteIntelBulletinTask(player1, data.id)
end

function CountMobilize (ability, phase)
	if (ability == BP_GetAbilityBlueprint("frontoviki_conscript_dispatch")) and (phase == MAP_Confirmed) then
		g_mobilizeCount = g_mobilizeCount + 1
		_ToWDebugDisplay("Mobilize Count: " .. g_mobilizeCount, "gold")
		if g_mobilizeCount >= 20 then
			Achieve ("tow_winter_defense_to_the_front")
			UI_ClearModalAbilityPhaseCallback()
		end
	end
end

function CheckForPanzerIV()
	Player_GetAll(player1)
	SGroup_Filter(sg_allsquads, {SBP.GERMAN.PANZER_IV_SQUAD, SBP.GERMAN.PANZER_IV_STUBBY_SQUAD, SBP.GERMAN.PANZER_IV_COMMAND_SQUAD}, FILTER_KEEP)
	if SGroup_Count(sg_allsquads) > 0 then
		if SGroup_GetAvgHealth(sg_allsquads) > 0.2 then
			Achieve("tow_winter_defense_panzer_theft")
			Rule_RemoveMe()
		end
	end
end
