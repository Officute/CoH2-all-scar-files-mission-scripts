-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- Act 3 - Mission 13
-- Halbe
-- Designer: Andres Molina
-------------------------------------------------------------------------
-------------------------------------------------------------------------
import("ScarUtil.scar")
import("Systems/AiManager/ai.scar")
import("Prototype/DeploymentPoints.scar")
import("Halbe_Encounters.scar")
import("Beginner.scar")
import("Order227.scar")
import("Global_Values/CampaignGlobalConstants.scar")

-------------------------------------------------------------------------
-- [[ TUNABLE/Global VARIABLES ]]
-------------------------------------------------------------------------
function SetupData() 
	t_encounters = {} --Table of all encounters
	
	g_buildTimeFactor = 0.50 --Time factor for building light_factory and weapon_support
	
	g_gateCloseDelay = 25
	g_escapeLimit = Util_DifVar({30, 25, 20}, g_difficulty) --Max number of germans allowed to escape before Encircle failure
	g_countEscaped = 0.2 --Current number of germans that have escaped. Non-zero to avoid bug with progress bar
	g_opelSpeed = 0.8 --Speed modifier on Opel trucks
	
	g_maxAwareness = Util_DifVar({35*60, 27*60, 22*60}, g_difficulty) --Time taken for awareness to max-out.
	
	t_wreckEBPs = {
		BP_GetEntityBlueprint("wrecked_halftrack_sdkfz_251"), 
		BP_GetEntityBlueprint("wrecked_t_34_85_red_banner"),
		BP_GetEntityBlueprint("wrecked_su_76m"),
		BP_GetEntityBlueprint("wrecked_su_85"),
		BP_GetEntityBlueprint("wrecked_kv-1"),
	}
end

-------------------------------------------------------------------------
-- [[ SETUP ]]
-------------------------------------------------------------------------
function OnGameSetup()
	-- Required Players
	player1 = Setup_Player(1, 11038758, "soviet", 1)		-- player1 is always the human player
	player2 = Setup_Player(2, 11038759, "german", 2)		-- player2 is always the AI opponent
	player3 = Setup_Player(3, 11038758, "soviet", 1)		-- player3 is always the AI ally
	player4 = Setup_Player(4, 11038759, "german", TEAM_NEUTRAL)		-- player4 is neutral
	player227 = Setup_Player(5, 11038758, "soviet", 3)		-- Violent not-so-nice Commissar
end

function OnGameRestore()
	-- function takes care of restoring all global mission parameters after a save/load
	player1 = World_GetPlayerAt(1)
	player2 = World_GetPlayerAt(2)
	player3 = World_GetPlayerAt(3)
	player4 = World_GetPlayerAt(4)
	player227 = World_GetPlayerAt(5)
	
	Game_DefaultGameRestore()
end


-------------------------------------------------------------------------
-- [[ ONINIT ]]
-------------------------------------------------------------------------
function OnInit()
	--[[ SET DIFFICULTY ]]
	Mission_Difficulty()
	
	--[[Setup tunable data]]
	SetupData()
	
	--[[ PRESET DEBUG CONDITIONS ]]
	Mission_Debug()
	
	--[[ SET RESTRICTIONS ]]
	Mission_Restrictions()
	
	--[[ SET AI ]]
	Mission_CpuInit()
		
	--[[ MISSION PRESETS ]]
	Mission_MissionPreset()
	
	--[[ REGISTER OBJECTIVES ]]
	Initialize_ObjSecure()
	Initialize_ObjEncircle()
	Initialize_ObjBreakout()
	Initialize_Bonus()
	
	if(not g_debug) then
		--[[ PLAY INTRO NIS]]
		Util_StartNIS(EVENTS.NIS_Intro)
		
		--[[ GAME START CHECK ]]
		Rule_Add(Mission_MissionStart)
	else
		DEBUG_Beat_Selection_01()
	end
end
Scar_AddInit(OnInit)

function Mission_Debug()	
	g_debug = Misc_IsCommandLineOptionSet("debug")
	
	-- set up bindings for NISes
--~ 	Scar_DebugConsoleExecute("bind([[ALT+1]], [[Scar_DoString('Util_StartNIS(NIS_OPENING_BLEND)')]])")
end

function Mission_Restrictions()
	---------------------- [[PLAYER 1]] ----------------------------
	--[[Criticals]]
	
	--[[Upgrades]]
	Player_CompleteUpgrade(player1, UPG.SOVIET.SHOCK_TROOPS)
	Player_CompleteUpgrade(player1, UPG.SOVIET.ISU152_UNLOCK)
	Player_CompleteUpgrade(player1, UPG.SOVIET.IL_2_BOMB_STRIKE)
	Player_CompleteUpgrade(player1, UPG.SOVIET.IL_2_SUPPORT)
	Player_CompleteUpgrade(player1, UPG.SOVIET.T34_85_UNLOCK)
	Player_CompleteUpgrade(player1, UPG.GERMAN.BATTLE_PHASE_2)
	Player_CompleteUpgrade(player1, UPG.GERMAN.BATTLE_PHASE_3)
	
	--[[Abilities]]
	Player_AddAbility(player1, ABILITY.SOVIET.BASE_CONSCRIPT_DISPATCH)
	Player_AddAbility(player1, ABILITY.SOVIET.FRONTOVIKI_CONSCRIPT_DISPATCH)
	Player_AddAbility(player1, ABILITY.SOVIET.PENAL_TROOP_DISPATCH_SP)
	Player_AddAbility(player1, ABILITY.GLOBAL.TRANSFER_ORDERS)
	Player_SetAbilityAvailability(player1, ABILITY.SOVIET.CMD_SHOCK_TROOPS, ITEM_REMOVED) --Used to remove the [locked] passive ability icon.
	Player_SetAbilityAvailability(player1, ABILITY.SOVIET.CMD_ISU_152, ITEM_REMOVED)
	Player_SetAbilityAvailability(player1, ABILITY.SOVIET.CMD_CONSCRIPT_ASSAULT_PACKAGE, ITEM_REMOVED)
	Player_SetAbilityAvailability(player1, ABILITY.SOVIET.CMD_T34_85_MEDIUM_TANK, ITEM_REMOVED)
	
	--[[Construction]]
	Player_SetEntityProductionAvailability(player1, EBP.SOVIET.M1937_152MM_ML_20_ARTILLERY, ITEM_REMOVED)
	Player_SetSquadProductionAvailability(player1, SBP.SOVIET.IS_2, ITEM_REMOVED)
	Player_SetEntityProductionAvailability(player1, EBP.SOVIET.TANK_DEPOT, ITEM_UNLOCKED)
	Player_SetEntityProductionAvailability(player1, EBP.SOVIET.MOTORPOOL, ITEM_UNLOCKED)
	--Accelerate build Time
	Modify_EntityBuildTime(player1, EBP.SOVIET.MOTORPOOL, g_buildTimeFactor)
	Modify_EntityBuildTime(player1, EBP.SOVIET.WEAPON_SUPPORT_CENTER, g_buildTimeFactor)
	
	--[[Resources]]
	--Start
	Player_SetResource(player1, RT_Manpower, Util_DifVar({350, 250, 100}, g_difficulty))
	Player_SetResource(player1, RT_Munition, Util_DifVar({300, 200, 150}, g_difficulty))
	Player_SetResource(player1, RT_Fuel, Util_DifVar({150, 100, 50}, g_difficulty))
	Player_SetResource(player1, RT_Command, 12)
	Player_SetResource(player1, RT_SovietProgression, Util_DifVar({51, 51, 1}, g_difficulty))
	--Caps
	Player_SetPopCapOverride(player1, Util_DifVar({100, 80, 70}, g_difficulty))
	Modify_PlayerResourceCap(player1, RT_Manpower, Util_DifVar({2001, 1801, 1501}, g_difficulty), MUT_Addition)
	Modify_PlayerResourceCap(player1, RT_Munition, Util_DifVar({501, 351, 281}, g_difficulty), MUT_Addition)
	Modify_PlayerResourceCap(player1, RT_Fuel, Util_DifVar({501, 401, 301}, g_difficulty), MUT_Addition)
	--Rates
	Modify_PlayerResourceRate(player1, RT_Manpower, Util_DifVar({1.7, 1.5, 1.2}, g_difficulty), MUT_Multiplication)
	Modify_PlayerResourceRate(player1, RT_Munition, Util_DifVar({5.0, 4.0, 2.0}, g_difficulty), MUT_Multiplication)
	Modify_PlayerResourceRate(player1, RT_Fuel, Util_DifVar({3.8, 3.0, 2.0}, g_difficulty), MUT_Multiplication)
end

function Mission_CpuInit()
	---------------------- [[PLAYER 2]] ----------------------------
	--[[Criticas]]
	
	--[[Upgrades]]
	Player_CompleteUpgrade(player2, UPG.GERMAN.BATTLE_PHASE_2)
	Player_CompleteUpgrade(player2, BP_GetUpgradeBlueprint("panzerfaust_slow"))
	Player_CompleteUpgrade(player2, BP_GetUpgradeBlueprint("rifle_grenade_slow"))
	Player_SetAbilityAvailability(player2, ABILITY.GERMAN.PANZER_GRENADIER_BUNDLED_CAMPAIGN, ITEM_UNLOCKED)
	
	--[[Abilities]]
	Player_AddAbility(player2, ABILITY.GLOBAL.DROP_WEAPONS)
	
	--[[Resources]]
	Player_SetResource(player2, RT_Munition, 1000)
	Player_SetResource(player2, RT_Fuel, 1000)
	
	
	
	---------------------- [[PLAYER 3]] ----------------------------
	--[[Criticas]]
	
	--[[Upgrades]]
	
	--[[Resources]]
	Player_SetResource(player3, RT_Manpower, 1000)
	Player_SetResource(player3, RT_Munition, 1000)
	Player_SetResource(player3, RT_Fuel, 1000)
end

function Mission_Difficulty(diff)
	g_difficulty = diff or Game_GetSPDifficulty()  -- set a global difficulty variable 
	AI_OverrideDifficulty(diff)
	Campaign_InitializeConstants(diff)
	print("********* DIFFICULTY: " .. g_difficulty)
	
	g_diffVariableSBP = Util_DifVar({SBP.GERMAN.OSTRUPPEN_SQUAD, SBP.GERMAN.GRENADIER_SQUAD, SBP.GERMAN.PANZER_GRENADIER_SQUAD}, g_difficulty)
	
	--Modifiers
	t_modifiers = {
		pgren_bundled_timer = Modify_ProjectileDelayTime(player2, BP_GetEntityBlueprint("bundled_stielgranate_campaign"), CAMPAIGN_PGREN_BUNDLED_TIMER),
		dispatchLvl1 = Modify_AbilityRechargeTime(player1, ABILITY.SOVIET.BASE_CONSCRIPT_DISPATCH, CAMPAIGN_DISPATCH_COOLDOWN),
		dispatchLvl2 = Modify_AbilityRechargeTime(player1, ABILITY.SOVIET.FRONTOVIKI_CONSCRIPT_DISPATCH, CAMPAIGN_DISPATCH_COOLDOWN),
		dispatchLvl3 = Modify_AbilityRechargeTime(player1, ABILITY.SOVIET.PENAL_TROOP_DISPATCH_SP, CAMPAIGN_DISPATCH_COOLDOWN),
	}
	
	Modify_ProjectileDelayTime(player2, BP_GetEntityBlueprint("bundled_stielgranate_campaign"), Util_DifVar({1.25, 1, 0.625}, g_difficulty))
end

--[[ DEBUG ]]--
function DEBUG_Beat_Selection_01()
	UI_MessageBoxSetText(LOC("SELECT START"), LOC("Select the Mission beat to play"))
	UI_MessageBoxSetButton(DB_Button1, LOC("WITH INTRO"), LOC("Play intro"), "", true)
	UI_MessageBoxSetButton(DB_Button2, LOC("NO INTRO"), LOC("Don't play intro NIS"), "", true)
	UI_MessageBoxSetButton(DB_Button3, LOC("NO MISSION"), LOC("No mission logic"), "", true)
	UI_MessageBoxShow(DC_Default, DEV_SelectPhase_Menu_01)
end

function DEV_SelectPhase_Menu_01(button)
	if button == DB_Button1 then
		--Intro
		Util_StartNIS(EVENTS.NIS_Intro)
		Rule_Add(Mission_MissionStart)
	elseif button == DB_Button2 then
		--No Intro
		SpawnIntroUnits()
		TriggerReconPlane()
		Rule_AddOneShot(Secure_DelayedStart, 1)
	elseif button == DB_Button3 then
		--No logic
		SGroup_Kill(sg_runners0)
		Camera_ResetToDefault()
		print("No mission!")
	end
end



-------------------------------------------------------------------------
-- MISSION Preset 
-------------------------------------------------------------------------
function Mission_MissionPreset()
	UI_SetSoviet227Visibility(true)
	EGroup_SetRallyPoint(eg_hq, mkr_htDest1)
	
	--Hide non-interactable territory points.
	EGroup_EnableMinimapIndicator(vp_encircleNorth, false)
	EGroup_EnableMinimapIndicator(vp_encircleSouth, false)
	EGroup_EnableMinimapIndicator(vp_exitRoad, false)
	EGroup_EnableMinimapIndicator(vp_railway, false)
	
	sg_mergehints = SGroup_CreateIfNotFound("sg_mergehints")
	sg_reinforcehints = SGroup_CreateIfNotFound("sg_reinforcehints")
	eg_reinforcehints = EGroup_CreateIfNotFound("eg_reinforcehints")
	
	--Set starting territory as visible
	FOW_RevealTerritory(player1, World_GetTerritorySectorID(EGroup_GetPosition(vp_start)), -1, false)
	
	--Initial retreat point
	eg_retreatPoint = EGroup_CreateIfNotFound("eg_retreatPoint")
	Util_CreateEntities(player1, eg_retreatPoint, BP_GetEntityBlueprint("sp_retreat_point"), mkr_camStart, 1)
	
	--Mines
	SetupMineFields()
	
	--Special entry point on the right-hand side of the map
	EGroup_DeSpawn(eg_entryNorth1)
	
	
	--[[ INTRO ]]
	--Runners
	sg_runners0 = Util_CreateSquads(player2, "sg_runners0", SBP.GERMAN.OSTRUPPEN_SQUAD, mkr_camStart, nil, nil, 3)
	--Enemy units
	EncRoadblock() -- Encounters file
	RoadAT()
	
	--Camera setup
--~ 	Camera_SetDeclination(0.3558)
--~ 	Camera_SetOrbit(-0.318918)
	Camera_SetOrbit(0)
	Camera_SetZoomDist(20.0)
	Camera_FocusOnPosition(World_Pos(67.059, 9.013, -200.329), false)
end

function SetupMineFields()
	local mines = Marker_GetSequence("mkr_mines")
	eg_mines = EGroup_CreateIfNotFound("mines")
	for i=1, #mines do
		Util_CreateEntities(player2, eg_mines, EBP.GERMAN.MINE_FIELD_BORDER, mines[i], 1)
		
		Util_CreateEntities(player2, eg_mines, EBP.GERMAN.RIEGEL_43_MINE, Util_GetRandomPosition(mines[i], 20), 1)
		Util_CreateEntities(player2, eg_mines, EBP.GERMAN.RIEGEL_43_MINE, Util_GetRandomPosition(mines[i], 20), 1)
		Util_CreateEntities(player2, eg_mines, EBP.GERMAN.RIEGEL_43_MINE, Util_GetRandomPosition(mines[i], 20), 1)
		Util_CreateEntities(player2, eg_mines, EBP.GERMAN.RIEGEL_43_MINE, Util_GetRandomPosition(mines[i], 20), 1)
		Util_CreateEntities(player2, eg_mines, EBP.GERMAN.RIEGEL_43_MINE, Util_GetRandomPosition(mines[i], 20), 1)
		
		Util_CreateEntities(player2, eg_mines, EBP.GERMAN.MINE_FIELD_MINE, Util_GetRandomPosition(mines[i], 20), 1)
		Util_CreateEntities(player2, eg_mines, EBP.GERMAN.MINE_FIELD_MINE, Util_GetRandomPosition(mines[i], 20), 1)
		Util_CreateEntities(player2, eg_mines, EBP.GERMAN.MINE_FIELD_MINE, Util_GetRandomPosition(mines[i], 20), 1)
		Util_CreateEntities(player2, eg_mines, EBP.GERMAN.MINE_FIELD_MINE, Util_GetRandomPosition(mines[i], 20), 1)
		Util_CreateEntities(player2, eg_mines, EBP.GERMAN.MINE_FIELD_MINE, Util_GetRandomPosition(mines[i], 20), 1)
		Util_CreateEntities(player2, eg_mines, EBP.GERMAN.MINE_FIELD_MINE, Util_GetRandomPosition(mines[i], 20), 1)
	end
end




-------------------------------------------------------------------------
-- MISSION START/END
-------------------------------------------------------------------------
function Mission_MissionStart()
	if Event_IsAnyRunning() == false then
		Rule_RemoveMe()
		Cmd_Retreat(sg_runners0, mkr_eTankDest, mkr_eTankDest)
		
		UI_SetCPMeterVisibility(false)
		
		if(Misc_IsCommandLineOptionSet("nomovies")) then
			ResetCamera()
		else
			Util_SetPlayerCanSkipSequence(IntroSkipped, true)
			Util_StartNIS(EVENTS.Intro_Opening)
		end
		Rule_AddInterval(Mission_PlaySitRep, 1)
		
		-- hints about merging into damaged squads and reinforcing from halftracks and HQs
		Halbe_UpdateHintGroups()
		BeginnerHint_AddOpportunity(sg_mergehints, HINT_MERGE, true, nil, nil, nil, GD_EASY)
		BeginnerHint_AddOpportunity(sg_reinforcehints, HINT_REINFORCE, true, nil, nil, nil, GD_EASY)
		Rule_AddInterval(Halbe_UpdateHintGroups, 30)
	end
end

function IntroSkipped()
	print("Skipped!")
	SpawnIntroUnits()
	TriggerReconPlane()
	Game_FadeToBlack(FADE_OUT, 0)
end

function Halbe_UpdateHintGroups()

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



function Mission_MissionComplete()
 	if(not Rule_Exists(Mission_MissionEnd)) then
		--Only trigger if not in the process of ending
		Util_StartNIS(EVENTS.NIS_Outro)
		g_win = true
		Rule_AddDelayedInterval(Mission_MissionEnd, 1.5, 1)
	end
end

function Mission_MissionFailed()
	if(not Rule_Exists(Mission_MissionEnd)) then
		g_win = false
		Rule_AddDelayedInterval(Mission_MissionEnd, 1.5, 1)
	end
end

function Mission_MissionEnd()
	if Event_IsAnyRunning() == false then
		Rule_RemoveMe()
		Game_EndSP(g_win)
	end
end

function Mission_PlaySitRep()
	if(not Event_IsAnyRunning()) then
		Rule_RemoveMe()
		
		Util_PlayMovie("m13_sitrep", nil, 2, ResetCamera, 0, true)
		Util_SetPlayerUnableToSkipSequence()
		Rule_AddDelayedInterval(Secure_DelayedStart, 3, 1)
	end
end


-------------------------------------------------------------------------
-- Intro sequence
-------------------------------------------------------------------------
function ResetCamera()
	Camera_MoveTo(mkr_camStart, false)
	Camera_ResetToDefault()
end

function SpawnIntroUnits()
	if hasSpawnedIntroUnits then return end
	hasSpawnedIntroUnits = true

	--Starting player conscripts
	sg_startingConscripts = SGroup_CreateIfNotFound("startingConscripts")
	Util_CreateSquads(player1, sg_startingConscripts, SBP.SOVIET.CONSCRIPT_SQUAD, mkr_playerSpawn4, mkr_playerDest, nil, 4, false)
	Util_CreateSquads(player1, sg_startingConscripts, SBP.SOVIET.CONSCRIPT_SQUAD, mkr_playerSpawn3, mkr_playerDest2, nil, 5, false)
	Cmd_InstantUpgrade(sg_startingConscripts, UPG.SOVIET.CONSCRIPT_ASSAULT_PACKAGE)
	
	SGroup_Destroy(sg_startingConscripts)
end

function TriggerReconPlane()
	if hasTriggeredReconPlane then return end
	hasTriggeredReconPlane = true
	
	Cmd_Ability(player3, ABILITY.SOVIET.IL_2_RECON, mkr_tankDest2, nil, true)
end







 -- LOCDB CREATE  MISSION "M13" SCENE "TEXT"
--------------------------------------------------------------------------------------------------------------------------------------------------
--************************************************************************************************************************************************
-- 													OBJECTIVE 1 - Secure the road to Halbe
--************************************************************************************************************************************************
--------------------------------------------------------------------------------------------------------------------------------------------------
function Initialize_ObjSecure()
	OBJ_SecureRoad = {
		SetupUI = function() 
		end,
		
		OnStart = function()
			g_currentObjective = OBJ_SecureRoad
			
			--Infantry Reenforcements
			t_startPos = {mkr_playerDest, mkr_playerDest2, mkr_playerDest4, mkr_playerDest5, mkr_playerDest6}
			
			--Prevent HQ from being destroyed by player
			EGroup_SetInvulnerable(eg_hq, 0.1)
			
			--Check when the player reaches the VP
			proxPanther = Event_Proximity(StartTankBattle, {filterlist = LIST.AIRCRAFT, filtertype = FILTER_REMOVE}, player1, trg_tankBattle, nil, ANY, 2)
			
			--If perimeter is broken, engage the AI
			proxRoadBlock = Event_Proximity(RoadblockBreached, {filterlist = LIST.AIRCRAFT, filtertype = FILTER_REMOVE}, player1, mkr_roadblock, nil, ANY)
			
			Event_PlayerCanSeeElement(StartAttackRoad, nil, player1, enc_roadblock.sgroup, ANY, 2)
			
			Rule_AddDelayedInterval(Secure_InformAT, 2, 1)
			
			
			for k, sobj in pairs(OBJ_SecureRoad.subObjectives) do
				if(sobj.onParentStart) then
					Objective_Start(sobj, false)
				end
			end
			
			Rule_AddInterval(Secure_CheckSuccess, 2)			
			
			--List of enemies. Used for SKIP.
			t_enemies = {sg_roadAT, enc_roadblock.sgroup, eg_bunkerHMG}
		end,
		
		OnComplete = function()
			-- Calls from Objective_Complete(OBJ_Objective1)
			Objective_RemoveUIElements(OBJ_SecureRoad, hpid_Secure)
			
			EGroup_SetInvulnerable(eg_hq, false)
			Order227_Init(120, nil, true)
			ConscriptProgression_AudioInit(true, true)
			
			Rule_Remove(Secure_CheckSuccess)		
			
			--Setup the capped territory so that the player can build on it.
			if(Util_GetPlayerOwner(vp_road) ~= player1) then EGroup_InstantCaptureStrategicPoint(vp_road, player1) end
			World_SetDesignerSupply(Util_GetPosition(vp_road), true)
			
			EGroup_DeSpawn(eg_retreatPoint)
			
			--Make any left over units retreat
			RetreatRoadblock()
			
			World_IncreaseInteractionStage()
			--Setup Town defenses
			EncTown()
			
			Rule_Add(Encircle_DelayedStart)
		end,
		
		OnFail = function()
			-- Calls from Objective_Fail(OBJ_Objective1)
			Rule_Remove(Secure_CheckSuccess)
			
			Event_Remove(proxPanther)
			Event_Remove(proxRoadBlock)
			
			Mission_MissionFailed()
		end,
		
		IsComplete = function()
			return Objective_IsComplete(SOBJ_CapRoad) and Objective_IsComplete(SOBJ_DestroyAT)
		end,
		
		IsFailed = function()
			return (Player_GetSquadCount(player1) == 0)
		end,
		
		Skip = function()
			for k,v in pairs(t_enemies) do
				Util_Kill(v)
			end
			Event_Remove(proxPanther)
			Event_Remove(proxRoadBlock)
			InformPanther()
			EGroup_InstantCaptureStrategicPoint(vp_road, player1)
			
			Objective_Complete(OBJ_SecureRoad)
		end,
		
		subObjectives = {},
		
		Intel_Start = EVENTS.Secure_Intro,		
		Intel_Complete = EVENTS.Secure_Complete,
		Intel_Fail = nil,
		Title = 11045384, -- LOCDB [11045384] 'Secure the Road to Halbe'
		Description = 11045384, -- LOCDB [11045384] 'Secure the Road to Halbe'
		TitleEnd = 11045385, -- LOCDB [11045385] 'Road secured'
		TitleFail = 11045386, -- LOCDB [11045386] 'Soviet forces have been defeated'
		Type = OT_Primary,
	}
	
	
	--[[ Sub-Objectives ]]
	SOBJ_CapRoad = { --Capture the road territory
		SetupUI = function() 
			hpid_Secure = Objective_AddUIElements(OBJ_SecureRoad, vp_road, true, 11045387, true, 3) -- LOCDB [11045387] 'Secure the territory'
		end,
		
		OnStart = function()
			
		end,
		
		OnComplete = function()
		end,
		
		OnFail = function()
			
		end,
		
		IsComplete = function()
			return (enc_tankBattle ~= nil and not enc_tankBattle:IsAlive() and Util_GetPlayerOwner(vp_road) == player1)
		end,
		
		Skip = function()
			
		end,
		
		Intel_Start = nil,
		Intel_Complete = nil,
		Intel_Fail = nil,
		Title = 11045387,
		Description = 11045387,
		TitleEnd = 11045388, -- LOCDB [11045388] 'Territory secured'
		TitleFail = 11045386,
		Type = OT_Primary,
		onParentStart = true,
		showTitle = false,
		Parent = OBJ_SecureRoad,
	}
	
	
	SOBJ_DestroyAT = { --Eliminate German AT support
		SetupUI = function() 
			
		end,
		
		OnStart = function()
			Event_GroupIsDead(DestroyAT_Complete, nil, sg_roadAT, 3, true)
		end,
		
		OnComplete = function()
			--Increase Resources
			Player_AddResource(player1, RT_Command, 6)
			Player_AddResource(player1, RT_Munition, 160)
			
			--Give Tanks
			sg_startTanks = Util_CreateSquads(player1, "sg_startTanks", SBP.SOVIET.T_34_85_SQUAD, mkr_playerSpawn2, mkr_htDest2, nil, nil, true)
			
			EventCue_Create(CUE.VEHICLE_BUILT, 11045389, nil, sg_startTanks) -- LOCDB [11045389] 'Incoming tank support'
		end,
		
		OnFail = function()
			
		end,
		
		IsComplete = function()
			return false
		end,
		
		Skip = function()
			SGroup_Kill(sg_roadAT)
		end,
		
		Intel_Start = EVENTS.Secure_IntroAT,
		Intel_Complete = EVENTS.Secure_ATDestroyed,
		Intel_Fail = nil,
		Title = 11045390, -- LOCDB [11045390] 'Eliminate German Anti-tank support'
		Description = 11045390,
		TitleEnd = 11045391, -- LOCDB [11045391] 'Anti-tank support eliminated'
		TitleFail = 11045386,
		Type = OT_Primary,
		onParentStart = false,
		showTitle = true,
		Parent = OBJ_SecureRoad,
	}
	
	
	table.insert(OBJ_SecureRoad.subObjectives, SOBJ_CapRoad)
	table.insert(OBJ_SecureRoad.subObjectives, SOBJ_DestroyAT)
	
	
	Objective_Register(OBJ_SecureRoad)
	for k, sobj in pairs(OBJ_SecureRoad.subObjectives) do
		Objective_Register(sobj)
	end
end

function Secure_DelayedStart()
	if Event_IsAnyRunning() == false then
		Rule_RemoveMe()
		Game_SetMode(UI_Normal)
		Camera_SetInputEnabled(true)
		SpawnStartingUnits()
		EncAttackRoad()
		
		--Music
		Sound_PlayMusic("streamed/music/missions/m13/m13_cue_start_secure_road", 0, 0)
		
		Objective_Start(OBJ_SecureRoad)
	end
end

function Secure_CheckSuccess() -- Road is secure and enemy tanks are destroyed
	if(not Event_IsAnyRunning()) then
		--SubObjectives
		for k, subObj in pairs(OBJ_SecureRoad.subObjectives) do
			if(Objective_IsStarted(subObj) and not Objective_IsComplete(subObj) and not Objective_IsFailed(subObj)) then
				if(subObj.IsComplete()) then
					Objective_Complete(subObj, subObj.showTitle)
				elseif(subObj.IsFailed ~= nil and subObj.IsFailed()) then
					Objective_Fail(subObj)
				end
			end
		end
		
		
		--Main objective
		if(OBJ_SecureRoad.IsComplete()) then
			Rule_RemoveMe()
			
			--Music
			Sound_StopMusic(CAMPAIGN_MUSIC_FADEOUT,0)
			
			Objective_Complete(OBJ_SecureRoad)
		elseif(OBJ_SecureRoad.IsFailed()) then
			Rule_RemoveMe()
			Objective_Fail(OBJ_SecureRoad)
		end
	end
end

function DestroyAT_Complete()
	Objective_Complete(SOBJ_DestroyAT)
end

function Secure_InformAT()
	if(not Event_IsAnyRunning()) then
		Rule_RemoveMe()
		Objective_Start(SOBJ_DestroyAT)
	end
end

function SpawnStartingUnits()
	sg_startShock1 = Util_CreateSquads(player1, "sg_startShock1", SBP.SOVIET.SHOCK_TROOPS, mkr_playerSpawn, mkr_playerDest4, nil, nil, true)
	sg_startShock2 = Util_CreateSquads(player1, "sg_startShock2", SBP.SOVIET.SHOCK_TROOPS, mkr_playerSpawn, mkr_playerDest3, nil, nil, true)
	
	sg_startShock = SGroup_CreateIfNotFound("sg_startShock")
	SGroup_AddGroups(sg_startShock, {sg_startShock1, sg_startShock2})
	
	sg_startMortar = Util_CreateSquads(player1, "sg_startMortar", SBP.SOVIET.PM_82_41_MORTAR_SQUAD, mkr_playerSpawn0, mkr_playerDest6, nil, nil, false)
	
	sg_startHT = Util_CreateSquads(player1, "sg_startHT", SBP.SOVIET.M5_HALFTRACK_SQUAD, mkr_playerSpawn2, mkr_playerDest5)
	
	sg_engineers1 = Util_CreateSquads(player1, "sg_engineers1", SBP.SOVIET.COMBAT_ENGINEER_SQUAD, mkr_playerSpawn0, mkr_camStart)
end

function RetreatRoadblock()

	enc_roadblock:ClearGoal()

	for k,v in pairs(t_enemies) do
		if(scartype(v) == ST_SGROUP and SGroup_IsAlive(v)) then
			Cmd_Retreat(v, mkr_tankSpawn, mkr_tankSpawn)
		end
	end
end

function RoadblockBreached()
	enc_roadblock:Enable()

	--Bring in additional reinforcements
	EncReinforceRoadblock()
end


--[[TANK BATTLE]]
function StartTankBattle()
	--Enemy tanks (encounters file)
	PantherAttack()
	
	Event_PlayerCanSeeElement(InformPanther, nil, player1, sg_panther, ANY)
end

function InformPanther()
	Util_StartIntel(EVENTS.Tanks_Intro)
	UI_CreateMinimapBlip(Marker_GetPosition(mkr_eTankDest), 8, BT_Combat)
	ThreatArrow_CreateGroup(sg_panther)
	
	--Player heavy tanks
	sg_tankReinforcements = SGroup_CreateIfNotFound("sg_tankReinforcements")
	Util_CreateSquads(player1, sg_tankReinforcements, SBP.SOVIET.KV_1, mkr_playerSpawn0, mkr_tankDest1)
	Util_CreateSquads(player1, sg_tankReinforcements, SBP.SOVIET.SU_85, mkr_playerSpawn2, mkr_tankDest2)
	Player_SetPopCapOverride(player1, 130)
	
	EventCue_Create(CUE.VEHICLE_BUILT, 11045393, nil, sg_tankReinforcements) -- LOCDB [11045393] 'Armor Support'
	
	if(not Objective_IsComplete(SOBJ_DestroyAT)) then
		Util_StartIntel(EVENTS.Tanks_RemindAT)
	end
end







--------------------------------------------------------------------------------------------------------------------------------------------------
--************************************************************************************************************************************************
-- 													OBJECTIVE 2 - Encircle Halbe
--************************************************************************************************************************************************
--------------------------------------------------------------------------------------------------------------------------------------------------
function Initialize_ObjEncircle()
	OBJ_Encircle = {
		SetupUI = function() 
		end,
		
		OnStart = function()
			g_currentObjective = OBJ_Encircle
			
			--Music
			Sound_PlayMusic("streamed/music/missions/m13/m13_cue_encircle_town", 0, 0)
			
			--Unhide capture points
			EGroup_EnableMinimapIndicator(vp_encircleNorth, true)
			EGroup_EnableMinimapIndicator(vp_encircleSouth, true)
			EGroup_EnableMinimapIndicator(vp_exitRoad, true)
			EGroup_EnableMinimapIndicator(vp_railway, true)
			
			Rule_AddInterval(_CheckHQ, 3)
			
			--Give engineer and advise base
			sg_engineersBase = Util_CreateSquads(player1, "sg_engineersBase", SBP.SOVIET.COMBAT_ENGINEER_SQUAD, EGroup_GetPosition(eg_hq), mkr_htDest1)
			local hint_base = HintPoint_Add(sg_engineersBase, true, 11049970, 0) -- LOCDB [11049970] 'Engineers can build base buildings'
			Event_IsSelected(EventHandler_RemoveHint, {hint = hint_base}, sg_engineersBase, ANY, 1.0)
			
			--Used for checking if the player builds more units (achievement)
			g_startingUnits = SGroup_CreateIfNotFound("startingUnits")
			Player_GetAll(player1, g_startingUnits)
			SGroup_Filter(g_startingUnits, {SBP.SOVIET.BASE_CONSCRIPT_SQUAD, SBP.SOVIET.PENAL_BATTALION}, FILTER_REMOVE)
			
			--Warn about avoiding the town
			event_avoidTown = Event_PlayerCanSeeElement(EventHandler_StartIntel, {intel_callback = EVENTS.Encircle_AvoidTown}, player1, sg_townDefenses, ANY, 1.0)
			
			Rule_AddInterval(Encircle_CheckSuccess, 2)
			Rule_AddDelayedInterval(Encircle_CheckIntentionalDelay, 120, 2)
			
			Rule_AddDelayedInterval(Encircle_WarnManeuver, 30, 1)
			Rule_AddDelayedInterval(Awareness_DelayedStart, 5, 1)
			
			for k, sObj in pairs(OBJ_Encircle.subObjectives) do
				if(sObj.onParentStart) then
					Objective_Start(sObj, false)
				end
			end
		end,
		
		OnComplete = function()
			--Achievement check
			_CheckConstruction()
		
			-- Calls from Objective_Complete(OBJ_Objective1)
			Rule_Remove(Encircle_CheckSuccess)
			Rule_Remove(Encircle_CheckIntentionalDelay)
			Rule_Remove(Encircle_PreventIntentionalDelay)
			
			if(not Objective_IsFailed(OBJ_Awareness)) then
				Objective_Complete(OBJ_Awareness, false)
			end
			
			Event_Remove(event_avoidTown)
			
			Util_Autosave()
			
			if(enc_attemptNorth) then enc_attemptNorth:RemoveOnDeath(true) end
			if(enc_attemptSouth) then enc_attemptSouth:RemoveOnDeath(true) end
			--Remove encircle hintpoints in case they still linger.
			Objective_RemoveUIElements(SOBJ_BlockRoad, hpid_road)
			Objective_RemoveUIElements(SOBJ_BlockRailway, hpid_rail)
			
			Rule_AddDelayedInterval(Breakout_DelayedStart, 3, 0.5)
		end,
		
		OnFail = function()
			-- Calls from Objective_Fail(OBJ_Objective1)
			Rule_Remove(Encircle_CheckSuccess)
		end,
		
		IsComplete = function()
			return false
		end,
		
		Skip = function()
			for i=1, #t_encounters do
				SGroup_Kill(t_encounters[i].sgroup)
			end
			EGroup_InstantCaptureStrategicPoint(vp_encircleNorth, player1)
			EGroup_InstantCaptureStrategicPoint(vp_encircleSouth, player1)
			
			Objective_Complete(OBJ_Encircle)
		end,
		
		subObjectives = {},
		
		Intel_Start = EVENTS.Encircle_Intro,
		Intel_Complete = EVENTS.Encircle_Complete,
		Intel_Fail = nil,
		Title = 11045394, -- LOCDB [11045394] 'Encircle the town'
		TitleEnd = 11045395, -- LOCDB [11045395] 'Perimeter secured'
		TitleFail = 11045396, -- LOCDB [11045396] 'German Forces have escaped'
		Type = OT_Primary,
	}
	
	
	--[[ Sub-Objectives ]]
	SOBJ_BlockRailway = { --Block the railway
		SetupUI = function() 
			hpid_rail = Objective_AddUIElements(SOBJ_BlockRailway, mkr_escapeNorth, true, 11045397, true) -- LOCDB [11045397] 'Secure and hold the railway'
		end,
		
		OnStart = function()
			SetupNorthEncounters()
		end,
		
		OnComplete = function()
			Objective_RemoveUIElements(SOBJ_BlockRailway, hpid_rail)
			
			Encircle_InformSecuredExit()
			Rule_AddOneShot(EscapeAttemptNorth, 15)
		end,
		
		OnFail = function()
			
		end,
		
		IsComplete = function()
			return false
		end,
		
		Intel_Start = nil,
		Intel_Complete = nil,
		Intel_Fail = nil,
		Title = 11045397, -- LOCDB [11045397] 'Secure and hold the railway'
		TitleEnd = 11045398, -- LOCDB [11045398] 'Railway secured'
		TitleFail = 11045396,
		Type = OT_Primary,
		onParentStart = true,
		Parent = OBJ_Encircle,
	}	
	
	
	--Block the road
	SOBJ_BlockRoad = { 
		SetupUI = function() 
			hpid_road = Objective_AddUIElements(SOBJ_BlockRoad, mkr_road2, true, 11045399, true) -- LOCDB [11045399] 'Secure and hold the road'
		end,
		
		OnStart = function()
			SetupSouthEncounters()
		end,
		
		OnComplete = function()
			Objective_RemoveUIElements(SOBJ_BlockRoad, hpid_road)
			
			Encircle_InformSecuredExit()
			Rule_AddOneShot(EscapeAttemptSouth, 15)
		end,
		
		OnFail = function()
		end,
		
		IsComplete = function()
			return false
		end,
		
		Intel_Start = nil,
		Intel_Complete = nil,
		Intel_Fail = nil,
		Title = 11045400, -- LOCDB [11045400] 'Secure and hold the Western road'
		TitleEnd = 11045401, -- LOCDB [11045401] 'Road secured'
		TitleFail = 11045396,
		Type = OT_Primary,
		onParentStart = true,
		Parent = OBJ_Encircle,
	}
	
	
	table.insert(OBJ_Encircle.subObjectives, SOBJ_BlockRailway)
	table.insert(OBJ_Encircle.subObjectives, SOBJ_BlockRoad)
	
	
	Objective_Register(OBJ_Encircle)
	for k, sobj in pairs(OBJ_Encircle.subObjectives) do
		Objective_Register(sobj)
	end
end

function Encircle_DelayedStart()
	if Event_IsAnyRunning() == false then
		Rule_RemoveMe()
		Objective_Start(OBJ_Encircle)
	end
end

function Encircle_CheckSuccess() -- VPs by the roads are captured.
	if(Util_GetPlayerOwner(vp_exitRoad) == player1 and not Objective_IsComplete(SOBJ_BlockRoad)) then
		Objective_Complete(SOBJ_BlockRoad, not g_informedSecuredExit, g_informedSecuredExit)
	end
	
	if(Util_GetPlayerOwner(vp_railway) == player1 and not Objective_IsComplete(SOBJ_BlockRailway)) then
		Objective_Complete(SOBJ_BlockRailway, not g_informedSecuredExit, g_informedSecuredExit)
	end

	if(Objective_IsComplete(SOBJ_BlockRoad) and Objective_IsComplete(SOBJ_BlockRailway)) then
		Rule_RemoveMe()
		Rule_Remove(Encircle_CheckIntentionalDelay)
		Rule_Remove(Encircle_PreventIntentionalDelay)
		
		--Music
		Sound_StopMusic(CAMPAIGN_MUSIC_FADEOUT,0)
		
		Objective_Complete(OBJ_Encircle)
	end
end

function Encircle_CheckIntentionalDelay() --Check to see if the player is building up forces before capping the last territory
	local searchGroup = SGroup_CreateIfNotFound("searchGroup")
	SGroup_Clear(searchGroup)
	
	local countNorth = World_GetSquadsWithinTerritorySector(player2, searchGroup, World_GetTerritorySectorID(Marker_GetPosition(mkr_escapeNorth)), OT_Player)
	SGroup_Clear(searchGroup)
	local countSouth = World_GetSquadsWithinTerritorySector(player2, searchGroup, World_GetTerritorySectorID(Marker_GetPosition(mkr_escapeSouth)), OT_Player)
	
	if(enc_railAttack ~= nil and countNorth == 0
		and sg_partisans2 ~= nil and countSouth == 0
		and Player_GetCurrentPopulation(player1, CT_Personnel) >= 0.5*Player_GetMaxPopulation(player1, CT_Personnel)) then
			Rule_RemoveMe()
--~ 			print("adding rule...") --Debug
			Rule_AddOneShot(Encircle_PreventIntentionalDelay, 60)
	end
end

function Encircle_PreventIntentionalDelay()
	Rule_Remove(Encircle_CheckSuccess)
	Objective_Complete(OBJ_Encircle)
end

function Encircle_InformSecuredExit()
	if(g_informedSecuredExit) then return end
	
	g_informedSecuredExit = true
	Util_StartIntel(EVENTS.Encircle_SecuredExit)
end

function Encircle_WarnManeuver()
	if(not Event_IsAnyRunning()) then
		Rule_RemoveMe()
		
		local playerUnits = Player_GetSquads(player1)
		SGroup_Filter(playerUnits, {SBP.SOVIET.T_34_85_SQUAD, SBP.SOVIET.SU_85, SBP.SOVIET.KV_1}, FILTER_KEEP)
		if(SGroup_CountSpawned(playerUnits) > 0) then
			Util_StartIntel(EVENTS.Encircle_WarnManeuver)
		end
	end
end


--[[ NORTHERN ENCOUNTERS (right) ]]
function SetupNorthEncounters()
	--Defined in Halbe_Encounters.scar
	EncN1()
	Event_Proximity(BreachN1, nil, player1, mkr_encN1, nil, ANY)
	Event_Proximity(ActivateEntryPoint, {group = eg_entryNorth1}, player1, mkr_encN1, nil, ANY)
	EncN2()
	Event_Proximity(RidgeN, nil, player1, mkr_encN2, nil, ANY)
	Event_Proximity(EncN7, nil, player1, trg_encN3, nil, ANY)
	Event_PlayerDoesntOwnTerritory(ReinforceNorth, nil, player2, vp_encircleNorth, 2)
	Event_Proximity(EncN10, nil, player1, trg_reinforceNorth, nil, ANY)
	Event_Proximity(EncRail, nil, player1, mkr_encN10, nil, ANY)
end

function ActivateEntryPoint(data)
	EGroup_ReSpawn(data.group)
end


--[[ SOUTHERN ENCOUNTERS (left) ]]
function SetupSouthEncounters()
	Event_Proximity(Treeline, nil, player1, trg_treeline, nil, ANY)
	Event_Proximity(South2, nil, player1, trg_south2, nil, ANY)
	Event_Proximity(SouthHill, nil, player1, trg_south2, nil, ANY, 3)
	Event_Proximity(South6, nil, player1, trg_truckS4, nil, ANY, 10)
	Event_Proximity(South7, {filterlist = LIST.AIRCRAFT, filtertype = FILTER_REMOVE}, player1, trg_tankS8, nil, ANY)
	Event_Proximity(SouthEsc, nil, player1, trg_tankS8, nil, ANY)
end

-- Achievement: Checks to see if the player builds any units throughout the second beat.
function _CheckConstruction()
	local unitsEnd = Player_GetSquads(player1)
	SGroup_Filter(unitsEnd, {SBP.SOVIET.BASE_CONSCRIPT_SQUAD, SBP.SOVIET.PENAL_BATTALION}, FILTER_REMOVE)
	
	if(SGroup_Count(unitsEnd) <= SGroup_Count(g_startingUnits)) then
		--[[ACHIEVEMENT: Didn't construct any units]]
		print("Achievement unlocked: Didn't construct units")
		Scar_CompleteIntelBulletinTask(player1, "camp13_halbe_no_construction")
	end
end







--------------------------------------------------------------------------------------------------------------------------------------------------
--************************************************************************************************************************************************
-- 													OBJECTIVE 3 - Prevent breakout
--************************************************************************************************************************************************
--------------------------------------------------------------------------------------------------------------------------------------------------
function Initialize_ObjBreakout()
	OBJ_Breakout = {
		SetupUI = function() 
			hpid_BreakoutRoad = Objective_AddUIElements(OBJ_Breakout, mkr_144, true, 11045403, true) -- LOCDB [11045403] 'Prevent Escape'
			hpid_BreakoutRail = Objective_AddUIElements(OBJ_Breakout, mkr_145, true, 11045403, true)
		end,
		
		OnStart = function()
			g_currentObjective = OBJ_Breakout
			
			--Music
			Sound_PlayMusic("streamed/music/missions/m13/m13_cue_prevent_escape", 0, 0)
			
			if(enc_attemptNorth) then enc_attemptNorth:RemoveOnDeath(true) end
			if(enc_attemptSouth) then enc_attemptSouth:RemoveOnDeath(true) end
			
			sg_currentEscapers = SGroup_CreateIfNotFound("sg_currentEscapers")
			t_escapeList = {
				SpawnEscape1a, 
				SpawnCivilianEscape, 
				SpawnEscape2,
				SpawnEscape3
			}
			
			UI_CreateMinimapBlip(Util_GetPosition(mkr_road1), 10, BT_DefendHere)
			UI_CreateMinimapBlip(Util_GetPosition(mkr_road2), 10, BT_DefendHere)
			
			--Do reveal for player to see alternate paths.
			FOW_RevealArea(Marker_GetPosition(mkr_road1), 45, -1)
			FOW_RevealArea(Marker_GetPosition(mkr_escapeSouth), 45, -1)
			Rule_AddOneShot(Breakout_UnrevealExits, 0.2)
			
			AI_SetStaggeredSpawnDelay(3.0)
			
			Rule_AddInterval(Breakout_NotifyAwareness, 1)
			
			Rule_AddDelayedInterval(Breakout_CheckRetreats, 5, 3)
			Rule_AddInterval(Breakout_WaveManager, 1)
			Rule_AddInterval(Breakout_CheckFailure, 2)
			Rule_AddInterval(Breakout_CheckHalf, 2)
			Rule_AddDelayedInterval(Breakout_CheckExits, 2, 0.5)
		end,
		
		OnComplete = function()
			if(g_countEscaped < 1) then
				--[[ACHIEVEMENT: Kept shock troops alive]]
				print("Achievement unlocked: No Germans escaped")
				Scar_CompleteIntelBulletinTask(player1, "camp13_halbe_no_escape")
			end
		
			Rule_RemoveIfExist(Breakout_CheckFailure)
			Rule_RemoveIfExist(Breakout_CheckExits)
			Rule_RemoveIfExist(Breakout_WaveManager)
			Rule_RemoveIfExist(Breakout_CheckRetreats)
			
			Rule_AddOneShot(Mission_MissionComplete, 6)
		end,
		
		OnFail = function()
			-- Calls from Objective_Fail(OBJ_Objective1)
			Rule_RemoveIfExist(Breakout_CheckFailure)
			Rule_RemoveIfExist(Breakout_CheckExits)
			Rule_RemoveIfExist(Breakout_WaveManager)
			
			Rule_AddOneShot(Mission_MissionFailed, 4)
		end,
		
		IsComplete = function() return false end,
		
		Skip = function()
			Rule_RemoveAll()
			Objective_Complete(OBJ_Breakout)
		end,
		
		Intel_Start = EVENTS.Breakout_Intro,				
		Intel_Complete = EVENTS.Breakout_Complete,			
		Intel_Fail = EVENTS.Breakout_Fail,
		Title = 11045404, -- LOCDB [11045404] 'Prevent German forces from escaping'
		TitleEnd = 11045405, -- LOCDB [11045405] 'Enemy forces destroyed'
		TitleFail = 11045396,
		Type = OT_Primary,
	}
	
	Objective_Register(OBJ_Breakout)
end

function Breakout_DelayedStart()
	if(not Event_IsAnyRunning()) then
		Rule_RemoveMe()
		Objective_Start(OBJ_Breakout)
	end
end

function Breakout_UnrevealExits()
	FOW_UnRevealArea(Marker_GetPosition(mkr_road1), 45)
	FOW_UnRevealArea(Marker_GetPosition(mkr_escapeSouth), 45)
end

function Breakout_NotifyAwareness()
	if(not Event_IsAnyRunning()) then
		Rule_RemoveMe()
		if(g_failedAwareness) then
			Util_StartIntel(EVENTS.Breakout_Awareness)
		else
			Util_StartIntel(EVENTS.Breakout_NoAwareness)
		end
	end
end

function Breakout_CheckFailure()
	if(g_countEscaped >= g_escapeLimit) then
		Rule_RemoveMe()
		Rule_RemoveIfExist(Breakout_WaveManager)
		Rule_RemoveIfExist(Breakout_CheckExits)
		Event_RemoveAll()
		
		Objective_Fail(OBJ_Breakout)
	end
end

function Breakout_CheckHalf()
	if(g_countEscaped >= (g_escapeLimit/2)) then
		Rule_RemoveMe()
		Util_StartIntel(EVENTS.Breakout_Halfway)
	end
end


function Breakout_WaveManager()
	if(SGroup_CountSpawned(sg_currentEscapers) == 0) then
		Breakout_LaunchNextEscape()
	end
end

function Breakout_LaunchNextEscape()
	if(#t_escapeList > 0) then
		print("Spawning new wave...") --Debug.
		
		local func = t_escapeList[1]
		func()
		table.remove(t_escapeList, 1)
	else
		Rule_RemoveIfExist(Breakout_WaveManager)
		Rule_RemoveIfExist(Breakout_CheckExits)
		Rule_RemoveIfExist(Breakout_CheckFailure)
		Event_RemoveAll()
		
		Objective_Complete(OBJ_Breakout)
	end
end

function Breakout_CheckExits() --Checks to see if any german units reach the escape points. Increases obj_counter and despawns escapers
	sg_search = SGroup_CreateIfNotFound("sg_search")
	SGroup_Clear(sg_search)
	Player_GetAllSquadsNearMarker(player2, sg_search, mkr_exitNorth, 6)
	if(SGroup_CountSpawned(sg_search) > 0 ) then
		print("###Found " .. SGroup_TotalMembersCount(sg_search) .. " at exitNorth")
		g_countEscaped = g_countEscaped + SGroup_TotalMembersCount(sg_search)
		SGroup_DestroyAllSquads(sg_search)
	end
	
	SGroup_Clear(sg_search)
	Player_GetAllSquadsNearMarker(player2, sg_search, mkr_exitSouth, 6)
	if(SGroup_CountSpawned(sg_search) > 0 ) then
		print("###Found " .. SGroup_TotalMembersCount(sg_search) .. " at exitSouth")
		g_countEscaped = g_countEscaped + SGroup_TotalMembersCount(sg_search)
		SGroup_DestroyAllSquads(sg_search)
	end
	
	local message = Loc_FormatText(11045406, Loc_ConvertNumber(math.floor(g_countEscaped)), Loc_ConvertNumber(g_escapeLimit)) -- LOCDB [11045406] 'Germans Escaped: %1ESCAPED% of %2TOTAL%'
	Obj_ShowProgress(message, g_countEscaped/g_escapeLimit)
end

function Breakout_CheckRetreats()
	for k=SGroup_CountSpawned(sg_currentEscapers), 1, -1  do
		local squad = SGroup_GetSpawnedSquadAt(sg_currentEscapers, k)
		if(Squad_IsRetreating(squad)) then
			SGroup_Remove(sg_currentEscapers, squad)
		end
	end
end


--Util functions to send breakout attempts to exits if route is clear
function EvacuateNorth(enc)
	enc:Disable()
	SGroup_RemoveGroup(sg_currentEscapers, enc.sgroup)
	Cmd_Move(enc.sgroup, mkr_exitNorth)
end

function EvacuateSouth(enc)
	enc:Disable()
	SGroup_RemoveGroup(sg_currentEscapers, enc.sgroup)
	Cmd_Move(enc.sgroup, mkr_exitSouth)
end






--------------------------------------------------------------------------------------------------------------------------------------------------
--************************************************************************************************************************************************
-- 													BONUS OBJECTIVE - Encircle before awareness
--************************************************************************************************************************************************
--------------------------------------------------------------------------------------------------------------------------------------------------
function Initialize_Bonus()
	OBJ_Awareness = {
		SetupUI = function() 
		end,
		
		OnStart = function()
			g_currentAwareness = (0.01 * g_maxAwareness)-1
			g_failedAwareness = false
			
			Rule_AddDelayedInterval(UpdateCounter, 2, 1)
		end,
		
		OnComplete = function()
			Rule_Remove(UpdateCounter)
			Obj_HideProgress()
		end,
		
		OnFail = function()
			Obj_HideProgress()
			g_failedAwareness = true
		end,
		
		IsComplete = function()
			return false
		end,
		
		Skip = function()
			Rule_Remove(UpdateCounter)
			Obj_HideProgress()
		end,
		
		Intel_Start = EVENTS.Encircle_WarnAwareness,				
		Intel_Complete = nil,
		Intel_Fail = EVENTS.Encircle_GermansAware,
		Title = 11049975, -- LOCDB [11049975] 'Complete encirclement before the Germans are aware'
		TitleEnd = nil,
		TitleFail = 11049976, -- LOCDB [11049976] 'The Germans are aware of the encirclement'
		Type = OT_Secondary,
	}
	
	Objective_Register(OBJ_Awareness)
end

function Awareness_DelayedStart()
	if Event_IsAnyRunning() == false then
		Rule_RemoveMe()
		Objective_Start(OBJ_Awareness, false)
	end
end

function UpdateCounter()
	local perc = g_currentAwareness/g_maxAwareness
	
	if(perc >= 1.0) then
		Rule_RemoveMe()
		Objective_Fail(OBJ_Awareness, false)
	else
		g_currentAwareness = g_currentAwareness + 1
	end
	
--~ 		Objective_UpdateText(OBJ_Encircle, LOC("Encircle the town - Awareness: " .. math.floor(perc*100) .. "%"), nil, false) --Debug.
	local message = Loc_FormatText(11045402, Loc_ConvertNumber(math.floor(perc*100))) -- LOCDB [11045402] 'German Awareness of encirclement: %1PERC%%%'
	Obj_ShowProgress(message, perc)
end








-------------------------------------------------------------------------
-- Util functions
-------------------------------------------------------------------------
function _CheckHQ()
	if(EGroup_GetAvgHealth(eg_hq) <= 0) then
		Rule_RemoveMe()
		Util_MissionTitle(11048793, 1, 5, 1) -- LOCDB [11048793] 'Mission Failed: Headquarters Destroyed'
		Rule_AddOneShot(Mission_MissionFailed, 5)
	end
end



-------------------------------------------------------------------------
-- Debug functions
-------------------------------------------------------------------------
function SkipObjective() --Skips the current objective
	if(g_currentObjective ~= nil and Misc_IsCommandLineOptionSet("dev")) then
		g_currentObjective.Skip()
		Objective_Complete(g_currentObjective)
	end
end

function SkipBonus() --Skips the current BONUS objective
	if(g_currentBonus ~= nil and Misc_IsCommandLineOptionSet("dev")) then
		g_currentBonus.Skip() 
		Objective_Complete(g_currentBonus)
	end
end

function Grab() --Grabs units currently selected and places them in sg_selected
	sg_selected = SGroup_CreateIfNotFound("sg_selected")
	Misc_GetSelectedSquads(sg_selected, false)
	
	eg_selected = EGroup_CreateIfNotFound("eg_selected")
	Misc_GetSelectedEntities(eg_selected, false)
end

function Troops()
	if(Misc_IsCommandLineOptionSet("dev")) then
		Util_CreateSquads(player1, nil, SBP.SOVIET.T_34_85_SQUAD, Misc_GetMouseOnTerrain())
		Util_CreateSquads(player1, nil, SBP.SOVIET.CONSCRIPT_SQUAD, Misc_GetMouseOnTerrain())
		Util_CreateSquads(player1, nil, SBP.SOVIET.SHOCK_TROOPS, Misc_GetMouseOnTerrain())
	end
end

function KillTown()
	if(Misc_IsCommandLineOptionSet("dev")) then
		SGroup_Kill(sg_townDefenses)
	end
end

function KillRoad()
	if(Misc_IsCommandLineOptionSet("dev")) then
		SGroup_Kill(enc_roadblock.sgroup)
		SGroup_Kill(sg_roadAT)
		EGroup_Kill(eg_bunkerHMG)
	end
end

function ClearAll()
	if(Misc_IsCommandLineOptionSet("dev")) then
		SGroup_DestroyAllSquads(Player_GetSquads(player2))
	end
end

function PrepEscape()
	if(Misc_IsCommandLineOptionSet("dev")) then
		KillRoad()
		World_IncreaseInteractionStage()
	
		EGroup_InstantCaptureStrategicPoint(vp_road, player1)
		EGroup_InstantCaptureStrategicPoint(vp_encircleNorth, player1)
		EGroup_InstantCaptureStrategicPoint(vp_encircleSouth, player1)
		EGroup_InstantCaptureStrategicPoint(vp_exitRoad, player1)
		EGroup_InstantCaptureStrategicPoint(vp_railway, player1)
	end
end

function setDiff(val)
	if(Misc_IsCommandLineOptionSet("dev")) then
		g_difficulty = val
		AI_OverrideDifficulty(val)
		g_diffVariableSBP = Util_DifVar({SBP.GERMAN.OSTRUPPEN_SQUAD, SBP.GERMAN.GRENADIER_SQUAD, SBP.GERMAN.PANZER_GRENADIER_SQUAD}, g_difficulty)
	end
end
