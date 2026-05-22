-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- Act 1 - Mission 5
-- Stalingrad
-- Designer: Andres Molina
-------------------------------------------------------------------------
-------------------------------------------------------------------------
import("ScarUtil.scar")
import("Systems/AiManager/ai.scar")
import("Prototype/DeploymentPoints.scar")
import("Stalingrad_Encounters.scar")
import("Beginner.scar")
import("Order227.scar")
import("Global_Values/CampaignGlobalConstants.scar")


-------------------------------------------------------------------------
-- [[ TUNABLE/Global VARIABLES ]]
-------------------------------------------------------------------------
function SetupData()
	g_thresholdHQ = 7			--Number of base Germans alive in base before triggering mission end.
	
	g_flavourAudioDelay = 150	--Time between playing flavour dialogue lines
	
	g_initialAttackDelay = 30
	g_howitzerFireInterval = Util_DifVar({190, 150, 120}, g_difficulty) 		--Amount of time between howitzer attacks
	g_counterAttackDelay = Util_DifVar({30, 20, 17}, g_difficulty)				--Time before Germans counterattack (Beat3)
	g_howitzerLockOnDistance = Util_DifVar({5, 9, 14}, g_difficulty)			--Min. distance to consider howitzer lock-on as same location
	
	g_katyushaRangeMod = Util_DifVar({0.7, 0.5, 0.5}, g_difficulty)
	
	g_reclaimTimer = 90			-- Countdown for loss if territories lost in Defend beat.
	
	g_tankReinforceLimit = Util_DifVar({3, 2, 1}, g_difficulty)		--Max number of tanks you get after the defend beat.
	
	g_wrecksList = {				--List of wrecks to prevent path blocking.
		EBP.WRECKED_VEHICLES.WRECKED_ARMORED_CAR_SDKFZ_222,
		EBP.WRECKED_VEHICLES.WRECKED_HALFTRACK_SDKFZ_251,
		EBP.WRECKED_VEHICLES.WRECKED_STUG_III_E_SDKFZ_141_1,
		EBP.WRECKED_VEHICLES.WRECKED_STUG_III_G_SDKFZ_141_1,
	}
	
	t_flavourLines = {
		11046769, -- LOCDB [11046769] 'Can you believe this used to be a real city?' - 'Soldier_01'
		11046770, -- LOCDB [11046770] 'I'm not sure I'll know what to do when I no longer have people shooting at me.' - 'Soldier_02'
		11049560, -- LOCDB [11049560] 'If we live, maybe we should look into construction work.' - 'Soviet_Soldier_02'
--~ 		11046771, -- LOCDB [11046771] 'These zhopas sure love their damned machine guns.' - 'Soldier_01'
	}
	
	g_achievementKatyushas = true
end

-------------------------------------------------------------------------
-- [[ SETUP ]]
-------------------------------------------------------------------------
function OnGameSetup()
	-- Required Players
	player1 = Setup_Player(1, 11038758, "soviet", 1)		-- player1 is always the human player
	player2 = Setup_Player(2, 11038759, "german", 2)		-- player2 is always the AI opponent
	player3 = Setup_Player(3, 11038758, "soviet", 1)		-- player3 is always the AI ally
	player227 = Setup_Player(4, 11038758, "soviet", 3)		-- Violent not-so-nice Commissar
end

function OnGameRestore()	
	-- function takes care of restoring all global mission parameters after a save/load
	player1 = World_GetPlayerAt(1)
	player2 = World_GetPlayerAt(2)
	player3 = World_GetPlayerAt(3)
	player227 = World_GetPlayerAt(4)
	
	Game_DefaultGameRestore()
end


-------------------------------------------------------------------------
-- [[ ONINIT ]]
-------------------------------------------------------------------------
function OnInit()
	--[[ PRESET DEBUG CONDITIONS ]]
	Mission_Debug()
	
	--[[ SET DIFFICULTY ]]
	Mission_Difficulty()
	
	--[[ SET RESTRICTIONS ]]
	Mission_Restrictions()
	
	--[[ SET AI ]]
	Mission_CpuInit()
	
	--[[Setup tunable data]]
	SetupData()
	
	--[[ MISSION PRESETS ]]
	Mission_MissionPreset()
	
	--[[ REGISTER OBJECTIVES ]]
	Initialize_ObjPerimeter()
	Initialize_ObjBridges()
	Initialize_ObjDefend()
	Initialize_ObjAttack()
	Initialize_BonusHowitzers()
	Initialize_BonusBridge()
	
	if(not g_debug) then
		--[[ PLAY INTRO NIS]]
		Game_FadeToBlack(FADE_OUT, 0)
		Util_StartNIS(EVENTS.NIS01)
		
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
	Player_CompleteUpgrade(player1, UPG.GERMAN.BATTLE_PHASE_2)
	Player_CompleteUpgrade(player1, UPG.GERMAN.BATTLE_PHASE_3)
	
	--[[Abilities]]
	Player_AddAbility(player1, ABILITY.SOVIET.BASE_CONSCRIPT_DISPATCH)
	Player_AddAbility(player1, ABILITY.SOVIET.FRONTOVIKI_CONSCRIPT_DISPATCH)
	Player_AddAbility(player1, ABILITY.SOVIET.PENAL_TROOP_DISPATCH_SP)
	Player_AddAbility(player1, ABILITY.GLOBAL.TRANSFER_ORDERS)
	Player_SetAbilityAvailability(player1, BP_GetAbilityBlueprint("cmd_shock_troops"), ITEM_REMOVED) --Used to remove the [locked] passive ability icon.
	Player_SetEntityProductionAvailability(player1, EBP.SOVIET.BARBED_WIRE_FENCE, ITEM_REMOVED)
	Player_SetEntityProductionAvailability(player1, EBP.SOVIET.TANK_DEPOT, ITEM_REMOVED)
	
	--[[Units]]
	Player_SetSquadProductionAvailability(player1, SBP.SOVIET.SHOCK_TROOPS, ITEM_UNLOCKED)
	Player_SetSquadProductionAvailability(player1, SBP.SOVIET.T_34_76_SQUAD, ITEM_LOCKED)
	Player_SetSquadProductionAvailability(player1, SBP.SOVIET.SU_85, ITEM_REMOVED)
	Player_SetSquadProductionAvailability(player1, SBP.SOVIET.KATYUSHA_BM_13N_SQUAD, ITEM_UNLOCKED)
	Player_SetSquadProductionAvailability(player1, SBP.SOVIET.T_70M, ITEM_REMOVED)
	Player_SetSquadProductionAvailability(player1, SBP.SOVIET.SU_76M, ITEM_REMOVED)
	Player_SetSquadProductionAvailability(player1, SBP.SOVIET.M5_HALFTRACK_SQUAD, ITEM_REMOVED)
	Player_SetSquadProductionAvailability(player1, SBP.SOVIET.IS_2, ITEM_REMOVED)
	
	--[[Commands]]

	--Enable Order 227
	Order227_Init()
	ConscriptProgression_AudioInit()
	
	--[[Resources]]
	--Start
	Player_SetResource(player1, RT_Manpower, Util_DifVar({400, 300, 150}, g_difficulty))
	Player_SetResource(player1, RT_Munition, Util_DifVar({250, 180, 50}, g_difficulty))
	Player_SetResource(player1, RT_Fuel, 10)
	Player_SetResource(player1, RT_Command, 1)
	Player_SetPopCapOverride(player1, Util_DifVar({80, 70, 60}, g_difficulty))
	--Rate
	Modify_PlayerResourceRate(player1, RT_Munition, 1.5, MUT_Multiplication)
	Modify_PlayerResourceRate(player1, RT_Fuel, 1.5, MUT_Multiplication)
	--Caps
	Modify_PlayerResourceCap(player1, RT_Manpower, Util_DifVar({1801, 1501, 1201}, g_difficulty), MUT_Addition)
	Modify_PlayerResourceCap(player1, RT_Munition, Util_DifVar({601, 501, 401}, g_difficulty), MUT_Addition)
	Modify_PlayerResourceCap(player1, RT_Fuel, Util_DifVar({301, 201, 151}, g_difficulty), MUT_Addition)
end

function Mission_CpuInit()
	---------------------- [[PLAYER 2]] ----------------------------
	--[[Criticals]]
	
	--[[Upgrades]]
	Player_CompleteUpgrade(player2, BP_GetUpgradeBlueprint("howitzer_barrage_short_upgrade"))
	Player_CompleteUpgrade(player2, BP_GetUpgradeBlueprint("panzerfaust_slow"))
	Player_CompleteUpgrade(player2, BP_GetUpgradeBlueprint("rifle_grenade_slow"))
	Player_CompleteUpgrade(player2, UPG.GERMAN.BATTLE_PHASE_2)
	
	--[[Abilities]]
	Player_SetAbilityAvailability(player2, ABILITY.GERMAN.PANZER_GRENADIER_BUNDLED_CAMPAIGN, ITEM_UNLOCKED)
	Player_SetAbilityAvailability(player2, ABILITY.GERMAN.PANZER_GRENADIER_BUNDLED_GRENADE, ITEM_UNLOCKED)
	Player_AddAbility(player2, ABILITY.GLOBAL.OFF_MAP_ARTY_SINGLE_SHOT_INSTANT)
	
	--[[Resources]]
	Player_SetResource(player2, RT_Munition, 2000)
	Player_SetResource(player2, RT_Fuel, 2000)
end

function Mission_Difficulty(diff)
	g_difficulty = diff or Game_GetSPDifficulty()  -- Set a global difficulty variable. Param used for debugging.
	AI_OverrideDifficulty(diff)
	Campaign_InitializeConstants(diff)
	print("********* DIFFICULTY: " .. g_difficulty)
	
	--Modifiers
	t_modifiers = {
		pgren_bundled_timer = Modify_ProjectileDelayTime(player2, BP_GetEntityBlueprint("bundled_stielgranate_campaign"), CAMPAIGN_PGREN_BUNDLED_TIMER),
		dispatchLvl1 = Modify_AbilityRechargeTime(player1, ABILITY.SOVIET.BASE_CONSCRIPT_DISPATCH, CAMPAIGN_DISPATCH_COOLDOWN),
		dispatchLvl2 = Modify_AbilityRechargeTime(player1, ABILITY.SOVIET.FRONTOVIKI_CONSCRIPT_DISPATCH, CAMPAIGN_DISPATCH_COOLDOWN),
		dispatchLvl3 = Modify_AbilityRechargeTime(player1, ABILITY.SOVIET.PENAL_TROOP_DISPATCH_SP, CAMPAIGN_DISPATCH_COOLDOWN),
	}
	
	g_diffVariableSBP = Util_DifVar({SBP.GERMAN.OSTRUPPEN_SQUAD, SBP.GERMAN.GRENADIER_SQUAD, SBP.GERMAN.PANZER_GRENADIER_SQUAD}, g_difficulty)
	
	
	local t_defaultGoalData_attackEasy = {
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
			{
				tacticType = TACTIC_Pickup,
				priority = -1,
			},
			{
				tacticType = TACTIC_CaptureTeamWeapon,
				priority = -1,
			},
		},
		abilityControlsList = {
			{
				abilityPBG = ABILITY.GERMAN.GRENADIER_RIFLE_GRENADE_ABILITY,
				maxCasters = 1,
				waitTimeSecs = 20,
				useInitialWaitTime = 8,
			},
			{
				abilityPBG = ABILITY.GERMAN.GRENADIER_PANZERFAUST,
				maxCasters = 1,
				waitTimeSecs = 20,
				useInitialWaitTime = 10,
			},
			{
				abilityPBG = ABILITY.GERMAN.PANZER_GRENADIER_BUNDLED_CAMPAIGN,
				maxCasters = 1,
			},
--~ 			{
--~ 				abilityPBG = ,
--~ 				maxCasters = ,
--~ 				waitTimeSecs = ,
--~ 				useInitialWaitTime = ,
--~ 			},
		}
	}
	
	local t_defaultGoalData_attackHard = {
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
	
	
	local t_defaultGoalData_defendEasy = {
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
		},
		abilityControlsList = {
			{
				abilityPBG = ABILITY.GERMAN.GRENADIER_RIFLE_GRENADE_ABILITY,
				maxCasters = 1,
				waitTimeSecs = 20,
				useInitialWaitTime = 8,
			},
			{
				abilityPBG = ABILITY.GERMAN.GRENADIER_PANZERFAUST,
				maxCasters = 1,
				waitTimeSecs = 20,
				useInitialWaitTime = 10,
			},
			{
				abilityPBG = ABILITY.GERMAN.PANZER_GRENADIER_BUNDLED_CAMPAIGN,
				maxCasters = 1,
			},
--~ 			{
--~ 				abilityPBG = ,
--~ 				maxCasters = ,
--~ 				waitTimeSecs = ,
--~ 				useInitialWaitTime = ,
--~ 			},
		},
	}
	
	local t_defaultGoalData_defendHard = {
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
		},
	}
	
	AIAttackGoal_AdjustDefaultGoalData(Util_DifVar({t_defaultGoalData_attackEasy, {}, t_defaultGoalData_attackHard}, g_difficulty))
	AIDefendGoal_AdjustDefaultGoalData(Util_DifVar({t_defaultGoalData_defendEasy, {}, t_defaultGoalData_defendHard}, g_difficulty))
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
		Game_FadeToBlack(FADE_OUT, 0)
		Util_StartNIS(EVENTS.NIS01)
		Rule_Add(Mission_MissionStart)
	elseif button == DB_Button2 then
		--No Intro
		ClearAll()
		ResetCam()
		SGroup_DeSpawn(sg_commissar)
		Rule_AddOneShot(Obj1_DelayedStart, 1)
	elseif button == DB_Button3 then
		--No logic
		ClearAll()
		print("No mission!")
	end
end


-------------------------------------------------------------------------
-- MISSION Preset 
-------------------------------------------------------------------------
function Mission_MissionPreset()
	UI_SetSoviet227Visibility(true)

	--Setup world
	EGroup_InstantCaptureStrategicPoint(eg_pointB, player2)
	EGroup_SetRallyPoint(eg_allyBldgs, mkr_rallyPoint)
	EGroup_SetInvulnerable(eg_bridges, true)
	Player_SetDefaultSquadMoodMode(player1, MM_ForceTense)
	--These entry points are despawned on start, and are progressively unlocked as the player advances.
	EGroup_DeSpawn(eg_entryPt0)
	EGroup_DeSpawn(eg_entryPt1)
	EGroup_DeSpawn(eg_entryPt2)
	EGroup_DeSpawn(eg_entryPt3)
	EGroup_DeSpawn(eg_entryPt4)
	
	FOW_RevealTerritory(player1, World_GetTerritorySectorID(Marker_GetPosition(mkr_startHT)), 1, true)
	
	--Hide CapturePoints in Non-Interactable area
	EGroup_EnableMinimapIndicator(eg_pointE, false)
	EGroup_EnableMinimapIndicator(eg_pointF, false)
	EGroup_EnableMinimapIndicator(eg_pointC, false)
	
	--Enemy base
	EGroup_EnableMinimapIndicator(eg_enemyBaseBldgs, false)
	EGroup_EnableMinimapIndicator(eg_enemyHQ, true)
	
	--Starting units
	sg_startingHMG = Util_CreateSquads(player1, "sg_startingHMG", SBP.SOVIET.M1910_MAXIM_HEAVY_MACHINE_GUN_SQUAD, mkr_alliedHMG, nil, nil, 5)
	SGroup_IncreaseVeterancyRank(sg_startingHMG, 1, true)
	
	sg_startingShock = Util_CreateSquads(player1, "sg_startingShock", SBP.SOVIET.SHOCK_TROOPS, mkr_start2, nil, nil, 4)
	SGroup_IncreaseVeterancyRank(sg_startingShock, 2, true)
	
	sg_startingEngineers = Util_CreateSquads(player1, "sg_startingEngineers", SBP.SOVIET.COMBAT_ENGINEER_SQUAD, mkr_start4, nil, nil, nil, nil, nil, UPG.SOVIET.ENGINEER_FLAMETHROWER)
	SGroup_IncreaseVeterancyRank(sg_startingEngineers, 1, true)
	
	sg_startingConscript = Util_CreateSquads(player1, "sg_startingConscript", SBP.SOVIET.CONSCRIPT_SQUAD, mkr_factory)
	
	sg_startingGuards = Util_CreateSquads(player1, "sg_startingGuards", SBP.SOVIET.GUARDS_TROOPS, mkr_rallyPoint, nil, nil, nil, nil, nil, UPG.SOVIET.GUARD_DP_28_LMG_PACKAGE)
	
	sg_startingHT = Util_CreateSquads(player1, "sg_startingHT", SBP.SOVIET.M5_HALFTRACK_SQUAD, mkr_startHT)
	
	
	--Commissar
	sg_commissar = Util_CreateSquads(player1, "sg_commissar", SBP.SOVIET.COMMISSAR_227, mkr_commissar)
	
	--Supply trucks
	EGroup_SetAnimatorState(eg_truck1, "supplies_loaded", "half") -- empty/partial/half/majority/full
	EGroup_SetAnimatorState(eg_truck2, "supplies_loaded", "majority")
	EGroup_SetSelectable(eg_truck1, false)
	EGroup_SetSelectable(eg_truck2, false)
	
	SetupIntroNIS()
end

function SetupIntroNIS()
	sg_introHMG = Util_CreateSquads(player3, "introHMG", SBP.SOVIET.CONSCRIPT_SQUAD, mkr_ptA_mg, nil, nil, 3)
	Modify_ReceivedDamage(sg_introHMG, 2)
	Modify_SquadCaptureRate(sg_introHMG, 0)
	SGroup_SetInvulnerable(sg_introHMG, true)
	
	sg_introShocks = Util_CreateSquads(player3, "introShock", SBP.SOVIET.SHOCK_TROOPS, mkr_ptA_2, nil, nil, 3)
	Modify_ReceivedDamage(sg_introShocks, 2)
	SGroup_SetInvulnerable(sg_introShocks, true)
	
	sg_introPG = Util_CreateSquads(player2, "introPG", SBP.GERMAN.PANZER_GRENADIER_SQUAD, mkr_enc5_1, mkr_ptA_2, nil, nil, true)
	SGroup_SetInvulnerable(sg_introPG, true)
	
	sg_introOst = Util_CreateSquads(player2, "introOst", SBP.GERMAN.OSTRUPPEN_SQUAD, Util_FindHiddenSpawn(trg_stopHarass3, trg_stopHarass2), trg_stopHarass2, nil, 2, true)
	Modify_ReceivedDamage(sg_introOst, 1.5)
end




-------------------------------------------------------------------------
-- MISSION START/END
-------------------------------------------------------------------------
function Mission_MissionStart()
	if(not Event_IsAnyRunning()) then
		Rule_RemoveMe()
		
		Rule_AddInterval(_CheckHQ, 3)
		Rule_AddDelayedInterval(_PlayFlavourAudio, g_flavourAudioDelay, 2) --Flavour audio that plays when screen units not in combat.
		
		--Music
		Sound_PlayMusic("streamed/music/missions/m05/m05_cue_start_secure_perimeter", 0, 0)
		
		print("##Starting Intro...")
		UI_SetCPMeterVisibility(false)
		Util_StartNislet(EVENTS.NIS_IntroCam, IntroNisletSkipped, true) --Intro cam movement
		Rule_AddDelayedInterval(Mission_StartSitRep, 2, 0.3)		
	end
end

function Mission_MissionComplete()
	if(g_achievementKatyushas) then
		--[[ACHIEVEMENT: Kept shock troops alive]]
		print("Achievement unlocked: No katyushas fired")
		Scar_CompleteIntelBulletinTask(player1, "camp05_stalingrad_no_katyushas")
	end
	
	if(not Misc_IsCommandLineOptionSet("-nomovies")) then
		Util_StartNIS(EVENTS.NIS02)
	end
	g_win = true
	Rule_AddDelayedInterval(Mission_MissionEnd, 1.5, 1)
end

function Mission_MissionFailed()
	g_win = false
	Rule_AddDelayedInterval(Mission_MissionEnd, 1.5, 1)
end

function Mission_MissionEnd()
	if Event_IsAnyRunning() == false then
		Rule_RemoveMe()
		Game_EndSP(g_win)
	end
end


function IntroNisletSkipped()
	print("##Skipped Intro")
	--Kill intro NIS units
	SGroup_Kill(sg_introHMG)
	SGroup_Kill(sg_introShocks)
	SGroup_DestroyAllSquads(sg_introPG)
	if(sg_introHT ~= nil) then SGroup_DestroyAllSquads(sg_introHT) end
	if(event_introGrenade ~= nil) then Event_Remove(event_introGrenade) end
	
	--Move starting units
	SGroup_WarpToMarker(sg_startingEngineers, mkr_katyusha1)
	SGroup_WarpToMarker(sg_startingConscript, mkr_camStart)
	SGroup_WarpToMarker(sg_startingGuards, mkr_start3)
	SGroup_WarpToMarker(sg_startingHT, mkr_start1)
	Camera_ResetToDefault()
	Camera_SetSlideTargetRate(9999)
end

function Mission_StartSitRep()
	if(not Event_IsAnyRunning()) then
		Rule_RemoveMe()
		
		FOW_EnableTint(true)
		FOW_UnRevealAll()
		Camera_MoveTo(mkr_camStart)
		Camera_ResetToDefault()
		Camera_SetSlideTargetRate(9999)
		
		print("##Starting Sitrep...")
		Util_StartNIS(EVENTS.Sitrep)
		
		--Clear intro NIS units
		Player_SetAbilityAvailability(player2, ABILITY.GERMAN.PANZER_GRENADIER_BUNDLED_GRENADE, ITEM_LOCKED)
		if(sg_introHT ~= nil) then SGroup_DestroyAllSquads(sg_introHT) end
		SGroup_DestroyAllSquads(sg_introPG)
		SGroup_Kill(sg_introHMG)
		SGroup_DestroyAllSquads(sg_commissar)
		SGroup_Destroy(sg_commissar)
		sg_commissar = nil
		
		Rule_AddDelayedInterval(Obj1_DelayedStart, 2, 0.3)
	end
end





-- LOCDB CREATE  MISSION "M05" SCENE "TEXT"
--------------------------------------------------------------------------------------------------------------------------------------------------
--************************************************************************************************************************************************
-- 												OBJECTIVE 1 - Establish a Perimeter.
--************************************************************************************************************************************************
--------------------------------------------------------------------------------------------------------------------------------------------------
function Initialize_ObjPerimeter()
	OBJ_Perimeter = {
		SetupUI = function()
			hpid_pointA = Objective_AddUIElements(OBJ_Perimeter, eg_pointA, true, 11043161, true, 3) -- LOCDB [11043161] 'Secure territory'
			hpid_pointB = Objective_AddUIElements(OBJ_Perimeter, eg_pointB, true, 11043161, true, 3)
			hpid_pointD = Objective_AddUIElements(OBJ_Perimeter, eg_pointD, true, 11043161, true, 3)
			
		end,
		
		OnStart = function()
			-- Fires off after Intel_Start (unless Intel_Start is nil)
			g_currentObjective = OBJ_Perimeter
			Rule_AddInterval(Obj1_CheckSuccess, 2)
			Rule_AddInterval(Obj1_CheckFailure, 2)
			
			--Territory points
			SetupPointA()
			Rule_AddOneShot(SetupPointB, 3)
			Rule_AddOneShot(SetupPointD, 3)
			
			Rule_AddDelayedInterval(CheckPointB, 5, 2)
			Rule_AddDelayedInterval(CheckPointD, 5, 2)

			--Encounters in other areas
			SetupArea2()
			SetupArea5()
			
			--Demo pack hints. Barricade on main road and wall into point D
			-- LOCDB [11043162] 'Clear path using Demo Charges'
			hint_demo1 = BeginnerHint_AddOpportunity(eg_hintDemo1, HINT_DEMOCHARGE, false, 11048322, "Icons_abilities_ability_soviet_demo_charge") -- LOCDB [11048322] 'Demo Charges can clear obstacles'
			hint_demo2 = BeginnerHint_AddOpportunity(eg_hintDemo2, HINT_DEMOCHARGE, false, 11048322, "Icons_abilities_ability_soviet_demo_charge")
			
			--Reinforce hints
			sg_playerMergeHints = SGroup_CreateIfNotFound("sg_playerMergeHints")
			sg_playerReinforceHints = SGroup_CreateIfNotFound("sg_playerReinforceHints")
			_ReinforceHints()
			BeginnerHint_AddOpportunity(sg_playerMergeHints, HINT_MERGE, true)
			BeginnerHint_AddOpportunity(sg_playerReinforceHints, HINT_REINFORCE, true)
			Rule_AddDelayedInterval(_ReinforceHints, 10, 20)
			
			
			--Delay for first push - encounters file
			Rule_AddOneShot(Push0, g_initialAttackDelay)
			Rule_AddInterval(HarassBase, 90)
			
			proxStopHarass1 = Event_Proximity(StopHarassBase, nil, player1, trg_stopHarass1, nil, ANY)
			proxStopHarass2 = Event_Proximity(StopHarassBase, nil, player1, trg_stopHarass2, nil, ANY)
			
			--Order 227 check.
			Rule_AddInterval(WarnOrder227, 1.5)
			Rule_AddInterval(HintCommissar227, 1.5)
			
			--Teach the player about the M5 quad upgrade (EASY/NORMAL)
			if(g_difficulty < GD_HARD) then
				Rule_AddOneShot(CheckM5Upgrade, 240)
			end
			
			Event_Proximity(ObjArty_Start, nil, player1, {trg_stopHarass1, trg_stopHarass2, trg_stopHarass3}, nil, ANY)
		end,
		
		OnComplete = function()
			Rule_Remove(Obj1_CheckSuccess)		
			Rule_Remove(Obj1_CheckFailure)
			
			_StopStukas()
			
			EGroup_SetPlayerOwner(eg_entryPt1, player1)
			EGroup_SetPlayerOwner(eg_entryPt2, Util_GetPlayerOwner(eg_pointD) or player1)
			EGroup_ReSpawn(eg_entryPt1)
			EGroup_ReSpawn(eg_entryPt2)
			
			BeginnerHint_RemoveOpportunity(hint_demo2)
			
			Rule_AddDelayedInterval(Obj2_DelayedStart, 8, 0.5)
		end,
		
		OnFail = function()
			Rule_Remove(Obj1_CheckSuccess)		
			Rule_Remove(Obj1_CheckFailure)
			
			Rule_AddOneShot(Mission_MissionFailed, 3.5)
		end,
		
		IsComplete = function()
			return false
		end,
		
		Skip = function()
			--Remove checks
			Rule_Remove(CheckPushA)
			Rule_Remove(CheckPointB)
			
			--Removes triggers
			Event_Remove(proxStopHarass1)
			Event_Remove(proxStopHarass2)
			
			--Remove enemies
			g_enc_pointA:RemoveOnDeath(true)
			g_enc_area2:RemoveOnDeath(true)
			g_enc_pointB:RemoveOnDeath(true)
			g_enc_pointD:RemoveOnDeath(true)
			
			SGroup_Kill(g_enc_pointA.sgroup)
			SGroup_Kill(g_enc_area2.sgroup)
			SGroup_Kill(g_enc_pointB.sgroup)
			SGroup_Kill(g_enc_pointD.sgroup)
			SGroup_Kill(sg_garrisonD)
			SGroup_Kill(sg_garrisonPtB)
			SGroup_Kill(sg_flammer1)
			if(sg_mortarB) then SGroup_Kill(sg_mortarB) end
			
			--Territories
			EGroup_InstantCaptureStrategicPoint(eg_pointA, player1)
			EGroup_InstantCaptureStrategicPoint(eg_pointD, player1)
			EGroup_InstantCaptureStrategicPoint(eg_pointB, player1)
			
			_StopStukas()
			
			Objective_Complete(OBJ_Perimeter)
		end,
		
		Intel_Start = EVENTS.Obj1_Intro,
		Intel_Complete = nil,
		Intel_Fail = nil,
		Title = 11043163,  -- LOCDB [11043163] 'Secure the perimeter'
		TitleEnd = 11043164, -- LOCDB [11043164] 'Territories secured'
		TitleFail = 11043165, -- LOCDB [11043165] 'All Soviet forces have been killed'
		Type = OT_Primary,
	}
	
	Objective_Register(OBJ_Perimeter)
end

function Obj1_DelayedStart()
	if Event_IsAnyRunning() == false then
		Rule_RemoveMe()
		
		Game_SetMode(UI_Normal)
		Game_FadeToBlack(FADE_IN, 0.5)
		Camera_SetInputEnabled(true)
		
		print("##Starting Objective...")
		Objective_Start(OBJ_Perimeter)
	end
end

function Obj1_CheckSuccess() --All territories cleared and survived attacks
	
	if(Util_GetPlayerOwner(eg_pointA) == player1
		and Util_GetPlayerOwner(eg_pointB) == player1 and g_defeatedB
		and Util_GetPlayerOwner(eg_pointD) == player1
	) then
		Rule_RemoveMe()
		
		--Music
		Sound_StopMusic(CAMPAIGN_MUSIC_FADEOUT, 0)
		
		Objective_Complete(OBJ_Perimeter)
	end
end

function Obj1_CheckFailure() --All player units killed
	if(Player_GetSquadCount(player1) < 1) then
		Objective_Fail(OBJ_Perimeter)
	end
end

function CheckPointB()
	sg_nearPtB = SGroup_CreateIfNotFound("sg_nearPtB")
	Player_GetAllSquadsNearMarker(player2, sg_nearPtB, mkr_pointB, 22)
	
	if(Util_GetPlayerOwner(eg_pointB) == player1 and SGroup_CountSpawned(sg_nearPtB) == 0) then
		Rule_RemoveMe()
		g_defeatedB = true
		EGroup_SetPlayerOwner(eg_entryPt1, player1)
		EGroup_ReSpawn(eg_entryPt0)	
		Objective_RemoveUIElements(OBJ_Perimeter, hpid_pointB)
		
		GiveKatyushas({pos = mkr_d3})
	end
end

function CheckPointD()
	if(Util_GetPlayerOwner(eg_pointD) == player1) then
		Rule_RemoveMe()
		Objective_RemoveUIElements(OBJ_Perimeter, hpid_pointD)
		
		GiveKatyushas({pos = mkr_b1})
	end
end


function WarnOrder227()
	if(SGroup_IsRetreating(Player_GetSquads(player1), ANY) and Rule_Exists(Order227_Update)) then
		Rule_RemoveMe()
		Util_StartIntel(EVENTS.Order227_Retreat)
	end
end

function HintCommissar227()
	if(sg_227_commissar ~= nil) then
		Rule_RemoveMe()
		hpid_commissar = HintPoint_Add(sg_227_commissar, true, 11049795, 0)-- LOCDB [11049795] 'Retreating units will be shot'
		Event_ElementOnScreen(EventHandler_RemoveHint, {hint = hpid_commissar}, player1, sg_227_commissar, ANY, 0.85, 15)
	end
end

function StopHarassBase()
	--Stop harassing base
	Rule_Remove(HarassBase)
	Event_Remove(proxStopHarass1)
	Event_Remove(proxStopHarass2)
end


--[[ Katyushas ]]
--Called when PointB (waterplant) or PointD (center) is captured.
function GiveKatyushas(data)
	if(sg_hasKatyushas) then return end --Only give once
	sg_hasKatyushas = true
	
	Util_StartIntel(EVENTS.Obj1_Katyushas)
	
	sg_katyusha1 = Util_CreateSquads(player1, "sg_katyusha1", SBP.SOVIET.KATYUSHA_BM_13N_SQUAD, mkr_baseEntry1, mkr_katyusha2)
	sg_katyusha2 = Util_CreateSquads(player1, "sg_katyusha2", SBP.SOVIET.KATYUSHA_BM_13N_SQUAD, mkr_baseEntry2, mkr_start1)
	
	Modify_AbilityMaxCastRange(player1, ABILITY.SOVIET.KAYTUSHA_ROCKET_TRUCK_BARRAGE, g_katyushaRangeMod)
	
	local hpid_katyushas1 = HintPoint_Add(sg_katyusha1, true, 11043166) -- LOCDB [11043166] 'Katyusha Rocket Launchers'
	Event_IsSelected(_RemoveHint, {hint = hpid_katyushas1}, sg_katyusha1, ANY)
	Event_IsSelected(_RemoveHint, {hint = hpid_katyushas1}, sg_katyusha2, ANY)
	
	UI_CreateMinimapBlip(mkr_katyusha1, 10, BT_General)
	EventCue_Create(CUE.NORMAL, 11043167, nil, sg_katyusha1) -- LOCDB [11043167] 'Katyusha support'
	
	local hpid_katyushaTarget = HintPoint_Add(data.pos, true, 11043168, 2) -- LOCDB [11043168] 'Spot area for Katyushas Barrage'
	Event_ElementOnScreen(_RemoveHint, {hint = hpid_katyushaTarget}, player1, data.pos, nil, 0.8, 8)
	
	sg_katyushas = SGroup_CreateIfNotFound("sg_katyushas")
	SGroup_AddGroups(sg_katyushas, {sg_katyusha1, sg_katyusha2})
	Rule_AddSGroupEvent(KatyushaFired, sg_katyushas, GE_AbilityExecuted)
end

function KatyushaFired()
	print("Fired katyushas")
	Rule_RemoveSGroupEvent(KatyushaFired, sg_katyushas)
	g_achievementKatyushas = false
end


--[[ Teach M5 Upgrade ]]
function CheckM5Upgrade()
	local halftracks = SGroup_CreateIfNotFound("halftracks")
	Player_GetAll(player1, halftracks)
	SGroup_Filter(halftracks, SBP.SOVIET.M5_HALFTRACK_SQUAD, FILTER_KEEP)
	
	if(SGroup_CountSpawned(halftracks) > 0 
		and not SGroup_HasUpgrade(halftracks, UPG.SOVIET.M5_HALFTRACK_72K_AA_GUN_PACKAGE, ANY) 
		and not SGroup_IsUpgrading(halftracks, UPG.SOVIET.M5_HALFTRACK_72K_AA_GUN_PACKAGE, ANY)) then
			local hpid_M5Upgrade = HintPoint_Add(halftracks, true, 11048323, 0) -- LOCDB [11048323] 'Upgrade to improve anti-infantry capabilities'
			Event_IsSelected(TeachM5Upgrade, {hint = hpid_M5Upgrade}, halftracks, ANY)
	end
end

function TeachM5Upgrade(data)
	_RemoveHint(data)
	local flash_M5Upgrade = UI_FlashProductionButton(PITEM_Upgrade, UPG.SOVIET.M5_HALFTRACK_72K_AA_GUN_PACKAGE, true)
	Event_Timer(_StopFlashing, {id = flash_M5Upgrade}, 4.5)
end




--[[ POINT A  - In front of HQ]]
function SetupPointA()
	PointA()
	Rule_AddInterval(CheckPushA, 2)
end

function CheckPushA() --Pioneer attack
	if(Util_GetPlayerOwner(eg_pointA) == player1) then
		Rule_RemoveMe()
		
		Objective_RemoveUIElements(OBJ_Perimeter, hpid_pointA)
		
		--Stuka Strike #1
		event_stuka = Event_Timer(_StukaBomb, {pos = mkr_bomb2}, World_GetRand(15, 20))
		Rule_AddPlayerEvent(_ResetStukaTimer, player1, GE_PlayerBeingAttacked)
		
		
		--Place demo pack and set timer
		eg_demopack1 = EGroup_CreateIfNotFound("eg_demopack1")
		Util_CreateEntities(player2, eg_demopack1, BP_GetEntityBlueprint("demo_charge"), mkr_demopack0, 1)
		eg_demopack2 = EGroup_CreateIfNotFound("eg_demopack2")
		Util_CreateEntities(player2, eg_demopack2, BP_GetEntityBlueprint("demo_charge"), mkr_demopack1, 1)
		Rule_AddOneShot(DetonateDemo, 2)
		
		Rule_AddOneShot(PushA, 3.0)
	end
end

function DetonateDemo()
	Command_PlayerEntity(player2, player2, PCMD_DetonateCharges, eg_demopack1)
	Rule_AddOneShot(DetonateDemo2, 1)
end

function DetonateDemo2()
	Command_PlayerEntity(player2, player2, PCMD_DetonateCharges, eg_demopack2)
end

function InformPioneers()
	Util_StartIntel(EVENTS.Obj1_Pioneers)
	UI_CreateMinimapBlip(Util_GetPosition(mkr_demopack0), 6, BT_Combat)
	threatID_pioneers1 = ThreatArrow_CreateGroup(g_enc_pushA.sgroup)
	EventCue_Create(CUE.ATTACKED, 11047721, nil, mkr_ptA_mg) -- LOCDB [11047721] 'Pioneer Attack'
end




--[[ AREA 5 - Above point-A ]]
function SetupArea5()
	Area5()
end



--[[ AREA 2 - In between point-A and point-B ]]
function SetupArea2()
	Area2()
	
	proxHmg1Pos1 = Event_Proximity(HMG1Pos1, nil, player1, trg_mgPos1, nil, ANY)
	proxHmg1Pos2 = Event_Proximity(HMG1Pos2, nil, player1, trg_mgPos2, nil, ANY)
	proxHmg1Pos3 = Event_Proximity(HMG1Pos3, nil, player1, trg_mgPos3, nil, ANY)
end




--[[ POINT B  - Waterplant ]]
function SetupPointB()
	PointB()
	
	Event_PlayerCanSeeElement(AlertPointB, nil, player1, sg_garrisonPtB, ANY, 1.0)
	Event_PlayerDoesntOwnTerritory(ReinforceB, nil, player2, eg_pointB)
end

function AlertPointB()
	Cmd_Garrison(sg_garrisonPtB, eg_garrisonB)
	Rule_AddInterval(InformGarrisonB, 2)
	
	EngagePointB()
end

function InformGarrisonB()
	if(SGroup_IsAlive(sg_garrisonPtB) and SGroup_IsInHoldEntity(sg_garrisonPtB, ALL) and Player_CanSeeSGroup(player1, sg_garrisonPtB, ANY)) then
		Rule_RemoveMe()
		Util_StartIntel(EVENTS.Obj1_Garrisons)
	end
end






--[[ POINT D - Center territory]]
function SetupPointD()
	PointD()
	
	--Garrison squads
	Util_CreateSquads(player2, nil, SBP.GERMAN.OSTRUPPEN_SQUAD, eg_towerCenter1)
	if(g_difficulty >= GD_HARD) then
		Util_CreateSquads(player2, nil, SBP.GERMAN.SNIPER_SQUAD, eg_towerCenter1)
	end
	sg_garrisonD = Util_CreateSquads(player2, "sg_garrisonD", SBP.GERMAN.GRENADIER_SQUAD, mkr_d3)
	
	
	if(g_difficulty <= GD_NORMAL) then
		--EASY/NORMAL
		sg_hmg2 = Util_CreateSquads(player2, "sg_hmg2", SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD, mkr_pointD)
	
		proxHMG2Pos1 = Event_Proximity(AlertHMGPointD, {pos = mkr_mg2Pos2}, player1, trg_mg2Pos2, nil, ANY)
		proxHMG2Pos2 = Event_Proximity(AlertHMGPointD, {pos = mkr_mg2Pos3}, player1, trg_mg2Pos3, nil, ANY)
	else
		--HARD
		sg_hmg2 = Util_CreateSquads(player2, "sg_hmg2", SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD, mkr_mg2Pos2)
		Util_CreateSquads(player2, sg_hmg2, SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD, mkr_mg2Pos3)
	end
	Event_IsEngaged(AlertPointD, nil, sg_hmg2, ANY, 5.0)
	
	--Send units from north to attack when point is breached
	Event_Proximity(PushD, nil, player1, mkr_pointD, 16, ANY, 2)
end

function AlertHMGPointD(data)
	if(SGroup_IsAlive(sg_hmg2)) then
		Cmd_Move(sg_hmg2, data.pos)
	end
	Event_Remove(proxHMG2Pos1)
	Event_Remove(proxHMG2Pos2)
end

function AlertPointD()
	--Move grens into cover
	if(SGroup_IsAlive(sg_garrisonD) and g_difficulty >= GD_NORMAL) then
		Cmd_Garrison(sg_garrisonD, eg_towerCenter2)
	end
	
	--Engage defend AI
	if(g_enc_pointD:IsAlive()) then
		g_enc_pointD:Enable()
	end
end








--------------------------------------------------------------------------------------------------------------------------------------------------
--************************************************************************************************************************************************
-- 														OBJECTIVE 2 - Secure the bridges
--************************************************************************************************************************************************
--------------------------------------------------------------------------------------------------------------------------------------------------
function Initialize_ObjBridges()
	OBJ_Secure = {
		SetupUI = function() 
			hpid_bridge1 = Objective_AddUIElements(OBJ_Secure, mkr_pointE, true, 11043169, true) --point-E  -- LOCDB [11043169] 'Secure and hold the territory'
			hpid_bridge2 = Objective_AddUIElements(OBJ_Secure, mkr_bridge2, true, 11043169, true) --point-F
		end,
		
		OnStart = function()
			g_currentObjective = OBJ_Secure
			
			--Increase interaction and reveal capture points
			World_IncreaseInteractionStage()
			EGroup_EnableMinimapIndicator(eg_pointE, true)
			EGroup_EnableMinimapIndicator(eg_pointF, true)
			EGroup_EnableMinimapIndicator(eg_pointC, true)
			
			
			--Music
			Sound_PlayMusic("streamed/music/missions/m05/m05_cue_secure_bridges", 0, 0)
			
			SetupBridgeLeft()
			SetupBridgeRight()
			SetupArea3()
			SetupNorthBridge() --Bonus objective. Spawned here to prevent spawning in player sight.
			
			--If there are any stragglers, move them to a better position
			if(_IsEncounterActive(g_enc_area5)) then
				AttackMiddleRoad(g_enc_area5)
			end
			if(_IsEncounterActive(g_enc_attack5)) then
				AttackMiddleRoad(g_enc_attack5)
			end
			if(_IsEncounterActive(g_enc_HTArea5)) then
				AttackMiddleRoad(g_enc_HTArea5)
			end
			
			hint_demo3 = BeginnerHint_AddOpportunity(eg_hintDemo3, HINT_DEMOCHARGE, false, 11043170, "Icons_abilities_ability_soviet_demo_charge") -- LOCDB [11043170] 'Clear path using Demo Charges'
			
			--Stuka Strike #2
			event_stuka = Event_Timer(_StukaBomb, {pos = mkr_demopack3}, World_GetRand(15, 20))
			Rule_AddPlayerEvent(_ResetStukaTimer, player1, GE_PlayerBeingAttacked)
			
			--Setup howitzer #2
			SetupHowitzer2()
			SetupHowitzerEncounter2()
			StopArtillery()
			StartArtillery()
			Rule_AddInterval(ObjArty_CheckComplete, 2) --Rule started here. Otherwise OBJ completes on Howitzer1 death.
			
			Rule_AddDelayedInterval(ObjBridge_DelayedStart, 4, 1)
			Rule_AddInterval(TeachTranferOrders, 3)
			Rule_AddInterval(CheckBridgeLeft, 2)
			Rule_AddInterval(CheckBridgeRight, 2)
			Rule_AddInterval(Obj2_CheckComplete, 2)
		end,
		
		OnComplete = function()
			BeginnerHint_RemoveOpportunity(hint_demo3)
			
			_StopStukas()
			
			if Util_GetPlayerOwner(eg_pointE) ~= nil then
				EGroup_SetPlayerOwner(eg_entryPt3, Util_GetPlayerOwner(eg_pointE))
			end
			if Util_GetPlayerOwner(eg_pointF) ~= nil then
				EGroup_SetPlayerOwner(eg_entryPt4, Util_GetPlayerOwner(eg_pointF))
			end
			EGroup_ReSpawn(eg_entryPt3)
			EGroup_ReSpawn(eg_entryPt4)
			
			Util_Autosave()
			
			Rule_AddDelayedInterval(ObjDefend_DelayedStart, 8, 1)
		end,
		
		OnFail = function()
		end,
		
		IsComplete = function()
			return false
		end,
		
		Skip = function()
			g_enc_pointE:RemoveOnDeath(true)
			g_enc_pointF:RemoveOnDeath(true)
			
			for k,v in pairs(t_enemiesE) do
				SGroup_Kill(v)
			end
			
			for k,v in pairs(t_enemiesF) do
				SGroup_Kill(v)
			end
			
			for k,v in pairs(t_enemiesArea3) do
				SGroup_Kill(v)
			end
			
			SGroup_Kill(sg_scout2)
			
			_StopStukas()
			
			Objective_Complete(OBJ_Secure)
		end,
		
		Intel_Start = EVENTS.Obj2_Intro,
		Intel_Complete = nil,
		Intel_Fail = nil,
		Title = 11043171, -- LOCDB [11043171] 'Capture and hold the bridge territories'
		TitleEnd = 11043172, -- LOCDB [11043172] 'Bridge territories secured'
		TitleFail = 11043165,
		Type = OT_Primary,
	}
	
	Objective_Register(OBJ_Secure)
end

function Obj2_DelayedStart()
	if Event_IsAnyRunning() == false then
		Rule_RemoveMe()
		Objective_Start(OBJ_Secure)
	end
end

function Obj2_CheckComplete()
	if(g_bridge1Secure and g_bridge2Secure) then
		Rule_RemoveMe()
		
		--Music
		Sound_StopMusic(CAMPAIGN_MUSIC_FADEOUT, 0)
		
		Objective_Complete(OBJ_Secure)
	end
end

function TeachTranferOrders()
	if(Player_GetCurrentPopulation(player1, CT_Personnel) >= Player_GetMaxPopulation(player1, CT_Personnel)) then
		Rule_RemoveMe()
		Util_NewHUDFeatureEvent(HUDF_AbilityCard, 11047720, "Icons_abilities_ability_soviet_transfer_orders", 5) -- LOCDB [11047720] 'Use 'Transfer Orders' to withdraw specific units.'
		local flashID = UI_FlashAbilityButton(ABILITY.GLOBAL.TRANSFER_ORDERS, true)
		Event_Timer(_StopFlashing, {id = flashID}, 5)
	end
end

function CheckBridgeLeft()
	if(Util_GetPlayerOwner(eg_pointE) == player1) then
		Rule_RemoveMe()
		
		g_bridge1Secure = true
		Rule_AddOneShot(AbandonAT1, 2)
		
		Objective_RemovePing(OBJ_Secure, hpid_bridge1)
		if(not g_bridge2Secure) then
			Util_StartIntel(EVENTS.Obj2_BridgeSecured)
		end
	end
end

function CheckBridgeRight()
	if(Util_GetPlayerOwner(eg_pointF) == player1) then
		Rule_RemoveMe()
		
		g_bridge2Secure = true
		Rule_AddOneShot(AbandonAT2, 2)
		
		Objective_RemovePing(OBJ_Secure, hpid_bridge2)
		if(not g_bridge1Secure) then
			Util_StartIntel(EVENTS.Obj2_BridgeSecured)
		end
	end
end



--[[ AREA 3 - Below left bridge ]]
function SetupArea3()
	
	Area3()
	
	proxArea3Start = Event_Proximity(StartArea3, nil, player1, trg_enc3, nil, ANY)
	
	t_enemiesArea3 = {sg_hmgArea3, sg_garrisonArea3}
end





--[[ POINT E -  Left bridge (1) ]]
function SetupBridgeLeft()

	PointE()
	
	Event_PlayerDoesntOwnTerritory(PushPointE, nil, player2, eg_pointE)
	
	t_enemiesE = {g_enc_pointE.sgroup, sg_roadAT1, sg_hmgBunker1}
end

function AbandonAT1()
	Cmd_AbandonTeamWeapon(sg_roadAT1, true)
	Rule_AddOneShot(RetreatAT1, 1)
end

function RetreatAT1()
	Cmd_Retreat(sg_roadAT1)
end







--[[ POINT F - Right bridge (2) ]]
function SetupBridgeRight()
	
	PointF()
	Area6()
	Area4()
	proxStart4 = Event_Proximity(StartArea4, nil, player1, mkr_enc4, nil, ANY, 2)
	
	t_enemiesF = {sg_garrisonF1, sg_pointF, sg_roadAT3, sg_roadPG, g_enc_HMGRoad2.sgroup, g_enc_pointF.sgroup}
end

function AbandonAT2()
	Cmd_AbandonTeamWeapon(sg_roadAT3, true)
	Rule_AddOneShot(RetreatAT2, 1)
end

function RetreatAT2()
	Cmd_Retreat(sg_roadAT3)
end

function RestartPointF() --Debug. Remove.
	if Misc_IsCommandLineOptionSet("dev") then
		for k,v in pairs(t_enemiesF) do
			SGroup_Kill(v)
		end
		
		Rule_Remove(CheckBridgeRight)
		Event_Remove(proxStart4)
		
		SetupBridgeRight()
	end
end









--------------------------------------------------------------------------------------------------------------------------------------------------
--************************************************************************************************************************************************
-- 													OBJECTIVE 3 - Stop counterattack
--************************************************************************************************************************************************
--------------------------------------------------------------------------------------------------------------------------------------------------
function Initialize_ObjDefend()
	OBJ_Defend = {
		SetupUI = function() 
		end,
		
		OnStart = function()
			for k, sObj in pairs(OBJ_Defend.subObjectives) do
				if(sObj.onParentStart) then
					Objective_Start(sObj, false)
				end
			end
		
			--Music
			Sound_PlayMusic("streamed/music/missions/m05/m05_cue_counterattack", 0, 0)
			--Don't have artillery hitting player during this beat.
			StopArtillery()
			
			EGroup_InstantCaptureStrategicPoint(eg_pointE, player1)
			EGroup_InstantCaptureStrategicPoint(eg_pointF, player1)
			
			g_loseTerritoryCounter = 0 --Counter for loss timer if both territories are lost
		
			--Counter-attack wave data
			sg_currentAttackers = SGroup_CreateIfNotFound("sg_currentAttackers")
			t_encs_counterAttack = {}
			g_currentWave = 0
			
			t_counterAttackList = {
				{
					wave = CounterAttack1,
					timeout = Util_DifVar({75, 90, 120}, g_difficulty),
--~ 					actions = {},
					delay = 2,
				},
				{
					wave = CounterAttack2,
					timeout = Util_DifVar({75, 90, 120}, g_difficulty),
					delay = 2,
				},
				{
					wave = CounterAttack3,
					timeout = Util_DifVar({60, 90, 90}, g_difficulty),
					delay = 2,
				},
				{
					wave = CounterAttack4,
					timeout = Util_DifVar({75, 90, 120}, g_difficulty),
				},
			}
			
			Rule_AddOneShot(SpawnNextWave, g_counterAttackDelay)
			
			Rule_AddInterval(PreventWrecks, 1)
			Rule_AddOneShot(ObjDefend_SpawnAlliedTanks, 1.5)
			
			Rule_AddDelayedInterval(ObjDefend_WarnLoss, 10, 2)
			Rule_AddDelayedInterval(ObjDefend_CheckComplete, 5, 2)
			Rule_AddDelayedInterval(ObjDefend_CheckFailure, 5, 5)
		end,
		
		OnComplete = function()
			StartArtillery()
			
			--Music
			Sound_StopMusic(CAMPAIGN_MUSIC_FADEOUT, 0)
		
			Rule_Remove(PreventWrecks)
			Rule_Remove(ObjDefend_WarnLoss)
			World_IncreaseInteractionStage()
			EGroup_DestroyAllEntities(eg_leftPathBlockers)
			
			Rule_AddDelayedInterval(ObjAttack_DelayedStart, 5, 1)
		end,
		
		OnFail = function()
			Rule_RemoveAll()
			Rule_AddOneShot(Mission_MissionFailed, 4)
		end,
		
		IsComplete = function()
			--Attackwaves ended and have been killed. Player2 does not own bridge territories
			return g_ObjDefendComplete and SGroup_CountSpawned(sg_currentAttackers) == 0
					and Util_GetPlayerOwner(eg_pointE) ~= player2 and Util_GetPlayerOwner(eg_pointF) ~= player2
		end,
		
		IsFailed = function()
			return false
		end,
		
		Skip = function()
			Rule_Remove(ObjDefend_CheckComplete)
			Rule_Remove(SpawnNextWave)
			SGroup_Kill(sg_currentAttackers)
			Objective_Complete(OBJ_Defend)
		end,
		
		subObjectives = {},
		
		Intel_Start = EVENTS.ObjDefend_Intro,
		Intel_Complete = EVENTS.ObjDefend_Complete,
		Intel_Fail = nil,
		Title = 11043173,  -- LOCDB [11043173] 'Stop the German Counter-Attack'
		TitleEnd = 11043174, -- LOCDB [11043174] 'German counter-attack defeated'
		TitleFail = 11043175, -- LOCDB [11043175] 'German forces have regained control of the bridges'
		Type = OT_Primary,
	}
	
	
	-- Prevent Germans from capping bridge territories
	SOBJ_PreventCapture = {
		Intel_Start = nil,
		Intel_Complete = nil,
		Intel_Fail = nil,
		Title = 11049796, -- LOCDB [11049796] 'Maintain control of the bridge territories'
		TitleEnd = nil,
		TitleFail = nil,
		Type = OT_Primary,
		Parent = OBJ_Defend,
		onParentStart = true,
		
		SetupUI = function() 
			hpid_bridge1 = Objective_AddUIElements(OBJ_Defend, eg_pointE, true, 11049796, true, 2.8) -- LOCDB [11049796] 'Maintain control of the bridge territories'
			hpid_bridge2 = Objective_AddUIElements(OBJ_Defend, eg_pointF, true, 11049796, true, 2.8) -- LOCDB [11049796] 'Maintain control of the bridge territories'
		end,
		OnStart = function() end,
		OnComplete = function() end,
		OnFail = function() end,
	}
	
	
	table.insert(OBJ_Defend.subObjectives, SOBJ_PreventCapture)
	
	Objective_Register(OBJ_Defend)
	for k, sObj in pairs(OBJ_Defend.subObjectives) do 
		Objective_Register(sObj)
	end
end

function ObjDefend_DelayedStart()
	if Event_IsAnyRunning() == false then
		Rule_RemoveMe()
		Objective_Start(OBJ_Defend)
	end
end

function ObjDefend_CheckComplete()
	if(OBJ_Defend.IsComplete()) then
		Rule_RemoveMe()
		Objective_Complete(OBJ_Defend)
	end
end

-- Check ownership of territories. If lost, inform player and start countdown to loss.
-- If the player reclaims one of the territories, revert.
function ObjDefend_CheckFailure()	
	if(Util_GetPlayerOwner(eg_pointE) == player2 and Util_GetPlayerOwner(eg_pointF) == player2 and g_loseTerritoryCounter == 0) then
		print("Territories lost!!!!")
		--Both territories were just lost
		if(not Event_IsRunning(EVENTS.ObjDefend_WarnLoss) and not Event_IsQueued(EVENTS.ObjDefend_WarnLoss)) then
			Util_StartIntel(EVENTS.ObjDefend_WarnLoss)
		end
		Objective_StartTimer(SOBJ_PreventCapture, COUNT_DOWN, g_reclaimTimer, 45)
		Objective_UpdateText(SOBJ_PreventCapture, 11050199, nil, true) -- LOCDB [11050199] 'Reclaim the bridge territories'
		local flashID_reclaim = UI_FlashObjectiveIcon(OBJ_Defend.ID, true)
		Event_Timer(EventHandler_StopFlashing, {flashID = flashID_reclaim}, 4)
		if(not Rule_Exists(ObjDefend_WarnLoss)) then
			Rule_AddOneShot(ObjDefend_WarnLoss, 45)
		end
		
		g_loseTerritoryCounter = g_loseTerritoryCounter + 5
	elseif(Util_GetPlayerOwner(eg_pointE) == player2 and Util_GetPlayerOwner(eg_pointF) == player2 and g_loseTerritoryCounter > 0) then
		print("Counting down!!!")
		--Territories lost. Counting down
		g_loseTerritoryCounter = g_loseTerritoryCounter + 5
		
		--Show ticker
		if g_loseTerritoryCounter <= g_reclaimTimer then
			local timerSeconds = Objective_GetTimerSeconds(SOBJ_PreventCapture)
			local message = Loc_FormatText(11045653, Loc_ConvertNumber(timerSeconds)) -- LOCDB [11045653] 'Sector lost in %1SECONDS% seconds'
			UI_CreateEntityKickerMessage(player1, EGroup_GetRandomSpawnedEntity(eg_pointE), message)
			UI_CreateEntityKickerMessage(player1, EGroup_GetRandomSpawnedEntity(eg_pointF), message)
		end
		
		--Uh oh.. time's up
		if g_loseTerritoryCounter > g_reclaimTimer then
			Rule_RemoveMe()
			Objective_Fail(OBJ_Defend)
		end
	elseif( (Util_GetPlayerOwner(eg_pointE) ~= player2 or Util_GetPlayerOwner(eg_pointF) ~= player2) and g_loseTerritoryCounter > 0) then
		print("Reclaimed!!!")
		g_loseTerritoryCounter = 0
		Objective_UpdateText(SOBJ_PreventCapture, 11049796, nil, false) -- LOCDB [11049796] 'Maintain control of the bridge territories'
		Objective_StopTimer(SOBJ_PreventCapture)
		Rule_Remove(ObjDefend_WarnLoss)
	end
end

function ObjDefend_WarnLoss()
	if(Util_GetPlayerOwner(eg_pointE) ~= player1 or Util_GetPlayerOwner(eg_pointF) ~= player1) then
		Rule_RemoveMe()
		Util_StartIntel(EVENTS.ObjDefend_WarnLoss)
		
		if(Util_GetPlayerOwner(eg_pointE) ~= player1) then
			UI_CreateMinimapBlip(eg_pointE, 10, BT_DefendHere)
		end
		
		if(Util_GetPlayerOwner(eg_pointF) ~= player1) then
			UI_CreateMinimapBlip(eg_pointF, 10, BT_DefendHere)
		end
		
		local flash_warnDefend = UI_FlashObjectiveIcon(OBJ_Defend.ID, true)
		Event_Timer(EventHandler_StopFlashing, {flashID = flash_warnDefend}, 4)
	end
end

function PreventWrecks()
	Util_ClearWrecksFromMarker(trg_wrecks1, nil, g_wrecksList)
	Util_ClearWrecksFromMarker(trg_wrecks2, nil, g_wrecksList)
end

--Tanks
function ObjDefend_SpawnAlliedTanks()
	Util_StartIntel(EVENTS.ObjDefend_Tanks)
	
	sg_tank1 = Util_CreateSquads(player3, "sg_tank1", SBP.SOVIET.T_34_76_SQUAD, mkr_tankSpawn1)
	Cmd_SquadPath(sg_tank1, "pth_tank1", false, LOOP_NONE, false, 0, true)
	Event_Proximity(GivePlayerTank, {sgroup = sg_tank1}, sg_tank1, mkr_tankDest1, 10, ANY)
	
	sg_tank2 = Util_CreateSquads(player3, "sg_tank2", SBP.SOVIET.T_34_76_SQUAD, mkr_tankSpawn3)
	Cmd_SquadPath(sg_tank2, "pth_tank2", false, LOOP_NONE, false, 0, true)
	Event_Proximity(GivePlayerTank, {sgroup = sg_tank2}, sg_tank2, mkr_tankDest2, 10, ANY)
	
	EventCue_Create(CUE.VEHICLE, 11043176, nil, sg_tank1) -- LOCDB [11043176] 'Armor Reinforcements'
	UI_CreateMinimapBlip(Util_GetPosition(sg_tank1), 6, BT_General)
	
	--Hints
	local hint_tank1 = HintPoint_Add(sg_tank1, true, 11043177) -- LOCDB [11043177] 'T-34 Support'
	local hint_tank2 = HintPoint_Add(sg_tank2, true, 11043177)
	Event_IsSelected(_RemoveHint, {hint = hint_tank1}, sg_tank1, ANY)
	Event_IsSelected(_RemoveHint, {hint = hint_tank2}, sg_tank2, ANY)
	
	
	
	Rule_AddOneShot(TimeoutAlliedTanks, 45)
	Rule_AddInterval(NotifyTankAvailability, 2)
end

function NotifyTankAvailability()
	if(not Event_IsAnyRunning()) then
		Rule_RemoveMe()
		Util_NewHUDFeatureEvent(HUDF_None, 11048324, "Icons_vehicles_vehicle_soviet_t34_76_heavy_tank", 5.0) -- LOCDB [11048324] 'T-34 Tank construction unlocked'
		
		--Give access to heavy factory/T-34
		Player_SetSquadProductionAvailability(player1, SBP.SOVIET.T_34_76_SQUAD, ITEM_UNLOCKED)
		Player_SetResource(player1, RT_Fuel, math.max(90, Player_GetResource(player1, RT_Fuel)))
		EGroup_SetRallyPoint(eg_motorpool, mkr_stugDest) --TODO: Where to place this? Near base or near combat?
		EventCue_Create(CUE.MAP, 11043179, nil, eg_motorpool) -- LOCDB [11043179] 'Heavy Factory unlocked'
		local hint_tankDepot = HintPoint_Add(eg_motorpool, true, 11043178) -- LOCDB [11043178] 'Heavy Factory'
		Event_IsSelected(EventHandler_RemoveHint, {hint = hint_tankDepot}, eg_motorpool, ANY, 1.0)
	end
end

function GivePlayerTank(data)
	if(Util_GetPlayerOwner(data.sgroup) ~= player1) then
		SGroup_SetPlayerOwner(data.sgroup, player1)
		Player_SetPopCapOverride(player1, math.max(Player_GetMaxPopulation(player1, CT_Personnel), Player_GetCurrentPopulation(player1, CT_Personnel)))
	end
end

function TimeoutAlliedTanks()
	if(SGroup_CountSpawned(sg_tank1) > 0) then
		GivePlayerTank({sgroup = sg_tank1})
	end
	
	if(SGroup_CountSpawned(sg_tank2) > 0) then
		GivePlayerTank({sgroup = sg_tank2})
	end
end


--Wave Management
function SpawnNextWave()
	--Increase counter
	g_currentWave = g_currentWave + 1
	
	if(g_currentWave <= #t_counterAttackList) then
		print("#####Spawning wave " .. g_currentWave .. "...") --Debug
		
		local currentEnemyCount = SGroup_TotalMembersCount(sg_currentAttackers)
		t_counterAttackList[g_currentWave].wave()
		t_counterAttackList[g_currentWave].numEntities = SGroup_TotalMembersCount(sg_currentAttackers) - currentEnemyCount
	
		if(t_counterAttackList[g_currentWave].timeout) then
			print("Set to time-out in " .. t_counterAttackList[g_currentWave].timeout .. " seconds.") --Debug
			Rule_AddOneShot(TimeoutWave, t_counterAttackList[g_currentWave].timeout)
		elseif(t_counterAttackList[g_currentWave].threshold ~= nil) then
			print("Threshold set to " .. t_counterAttackList[g_currentWave].threshold .. " seconds.") --Debug
			Rule_AddDelayedInterval(CheckWaveStrength, 2, 2)
		else
			fatal("Wave does not have timeout or threshold.")
		end
		
		if(t_counterAttackList[g_currentWave].actions ~= nil) then
			for k,action in pairs(t_counterAttackList[g_currentWave].actions) do
				action()
			end
		end
	else
		Rule_Remove(TimeoutWave)
		Rule_Remove(CheckWaveStrength)
		
		g_ObjDefendComplete = true
		--CheckComplete() takes care of Completing the objective.
		print("#####Attack complete") --Debug
--~ 		Util_MissionTitle(LOC("DONE!"))	
	end
end	

function TimeoutWave()
	print("#####Wave timeout!") --Debug
	for k,enc in pairs(t_encs_counterAttack) do
		enc:RemoveOnDeath(true)
	end
	t_encs_counterAttack = {}
	
	Rule_AddOneShot(SpawnNextWave, t_counterAttackList[g_currentWave].delay or 0)
end

function CheckWaveStrength()
	if(SGroup_TotalMembersCount(sg_currentAttackers)/ t_counterAttackList[g_currentWave].numEntities <= t_counterAttackList[g_currentWave].threshold) then
		Rule_RemoveMe()
		
		print("#####Wave threshold reached!") --Debug
		
		Rule_AddOneShot(SpawnNextWave, t_counterAttackList[g_currentWave].delay or 0)
	end
end







--------------------------------------------------------------------------------------------------------------------------------------------------
--************************************************************************************************************************************************
-- 													OBJECTIVE 4 - Capture the Enemy base
--************************************************************************************************************************************************
--------------------------------------------------------------------------------------------------------------------------------------------------
function Initialize_ObjAttack()
	OBJ_AttackBase = {
		SetupUI = function() 
			hpid_enemyBase = Objective_AddUIElements(OBJ_AttackBase, eg_enemyHQ, true, 11043180, true) -- LOCDB [11043180] 'Capture the enemy base'
			
			--Reveal base
			FOW_RevealEGroup(eg_enemyHQ, 2)
		end,
		
		OnStart = function()
			g_currentObjective = OBJ_AttackBase
			
			--Music
			Sound_PlayMusic("streamed/music/missions/m05/m05_cue_destroy_g_hq", 0, 0)
			
			--Give the player IL-2 Strafe
			Player_CompleteUpgrade(player1, UPG.SOVIET.IL_2_SUPPORT)
			Player_SetResource(player1, RT_Command, 6)
			flash_IL2 = UI_FlashAbilityButton(ABILITY.SOVIET.IL_2_SUPPORT, true)
			Event_Timer(_StopFlashing, {id = flash_IL2}, 4)
			
			SetupBridge2() --Right
			SetupBridge1() --Left
			SetupDepot()
			SetupBasePerimeter()
			Rule_AddOneShot(SetupEnemyBase, 3)
			
			--Stuka Strike #3
			event_stuka = Event_Timer(_StukaBomb, {pos = mkr_bomb5}, World_GetRand(15, 20))
			Rule_AddPlayerEvent(_ResetStukaTimer, player1, GE_PlayerBeingAttacked)
			
			--Give additional tanks if lost (normal/easy)
			if(g_difficulty <= GD_NORMAL) then
				Rule_AddOneShot(ObjAttack_TankReinforcements, 4)
			end
			
			Rule_AddDelayedInterval(ObjAttack_CheckComplete, 4, 2)
		end,
		
		OnComplete = function()
			_StopStukas()
			EGroup_SetWorldOwned(eg_enemyBaseBldgs)
			Rule_AddOneShot(Mission_MissionComplete, 5)
		end,
		
		OnFail = function()
		end,
		
		IsComplete = function()
			return false
		end,
		
		Skip = function()
			_StopStukas()
			Objective_Complete(OBJ_AttackBase)
		end,
		
		Intel_Start = EVENTS.ObjAttack_Intro,
		Intel_Complete = EVENTS.ObjAttack_Complete,
		Intel_Fail = nil,
		Title = 11043180, -- LOCDB [11043180] 'Capture the enemy base'
		TitleEnd = 11043181, -- LOCDB [11043181] 'Enemy base secured'
		TitleFail = nil,
		Type = OT_Primary,
	}
	
	Objective_Register(OBJ_AttackBase)
end

function ObjAttack_DelayedStart()
	if Event_IsAnyRunning() == false then
		Rule_RemoveMe()
		Objective_Start(OBJ_AttackBase)
	end
end

function ObjAttack_CheckComplete() --Enemy HQ is destroyed or most of the base infantry is killed AND the player can see into the base
	if((EGroup_CountSpawned(eg_enemyHQ) == 0 or SGroup_TotalMembersCount(enc_infBase.sgroup) <= g_thresholdHQ) and Player_CanSeePosition(player1, Marker_GetPosition(mkr_base1))) then
		Rule_RemoveMe()
		Cmd_Retreat(enc_infBase.sgroup, mkr_baseExit2, mkr_baseExit2, nil, true)
--~ 		Command_SquadMovePos(player2, sg_baseStug, Marker_GetPosition(mkr_baseExit), false, true)
		Rule_AddOneShot(ObjAttack_DelayedComplete, 5)
	end
end

function ObjAttack_DelayedComplete()
	Objective_Complete(OBJ_AttackBase)
--~ 	Util_MissionTitle(LOC("Mission complete"))
end

function ObjAttack_TankReinforcements()
	local tanks = Player_GetSquads(player1)
	SGroup_Filter(tanks, LIST.TANKS, FILTER_KEEP)
	
	if(SGroup_CountSpawned(tanks) < g_tankReinforceLimit) then
		local sg_tankReinforcements = Util_CreateSquads(player1, "sg_tankReinforcements", SBP.SOVIET.T_34_76_SQUAD, mkr_tankSpawn3, mkr_stugDest, nil, nil, nil, mkr_middleRoad)
		local hint_tankReinforcements = HintPoint_Add(sg_tankReinforcements, true, 11050177) -- LOCDB [11050177] 'T-34 Reinforcements'
		Event_IsSelected(EventHandler_RemoveHint, {hint = hint_tankReinforcements}, sg_tankReinforcements, ANY, 1.0)
		
		Util_StartIntel(EVENTS.ObjAttack_MoreTanks)
		EventCue_Create(CUE.VEHICLE, 11043176, nil, sg_tankReinforcements) -- LOCDB [11043176] 'Armor Reinforcements'
		UI_CreateMinimapBlip(Util_GetPosition(sg_tankReinforcements), 6, BT_General)
	end
end









--------------------------------------------------------------------------------------------------------------------------------------------------
--************************************************************************************************************************************************
-- 													BONUS 1 - Locate and destroy enemy howitzers
--************************************************************************************************************************************************
--------------------------------------------------------------------------------------------------------------------------------------------------
function Initialize_BonusHowitzers()
	OBJ_DestroyArtillery = {
		SetupUI = function() 
			
		end,
		
		OnStart = function()
			g_currentBonus = OBJ_DestroyArtillery
			
			Objective_SetCounter(OBJ_DestroyArtillery, 0, 2)
			
			sg_howitzers = SGroup_CreateIfNotFound("sg_howitzers")
			SetupHowitzer1()
			SetupHowitzerEncounter1()
			
			StartArtillery()
			
			t_howitzerArrows = {-1, -1} --Holds hintPoint ID's for howitzers
		end,
		
		OnComplete = function()
			--[[ACHIEVEMENT: Destroyed enemy howitzers]]
			print("Achievement unlocked: Destroyed enemy howitzers")
			Scar_CompleteIntelBulletinTask(player1, "camp05_stalingrad_bonus_howitzers")
			
			Player_SetSquadProductionAvailability(player1, SBP.SOVIET.M5_HALFTRACK_SQUAD, ITEM_DEFAULT)
			Util_NewHUDFeatureEvent(HUDF_None, 11048325, "Icons_vehicles_vehicle_soviet_m5_halftrack", 5) -- LOCDB [11048325] 'M5 Half-track construction now available'
			local hpid_halftracks = HintPoint_Add(eg_motorpool, true, 11048326) -- LOCDB [11048326] 'M5 Half-track available'
			Event_IsSelected(_RemoveHint, {hint = hpid_halftracks}, eg_motorpool, ANY)
		end,
		
		OnFail = function()
			
		end,
		
		IsComplete = function()
			return false
		end,
		
		Skip = function()
			SGroup_Kill(sg_howitzer1)
			SGroup_Kill(enc_outpostA.sgroup)
			SGroup_Kill(sg_howitzer2)
			SGroup_Kill(enc_outpostB.sgroup)
		end,
		
		Intel_Start = EVENTS.ObjArty_Intro,
		Intel_Complete = EVENTS.ObjArty_Outro,
		Intel_Fail = nil,
		Title = 11043182, -- LOCDB [11043182] 'Locate and destroy German artillery'
		TitleEnd = 11043183, -- LOCDB [11043183] 'German artillery destroyed'
		TitleFail = nil,
		Type = OT_Secondary,
	}
	
	Objective_Register(OBJ_DestroyArtillery)
end

--[[Intro]]
function ObjArty_Start()
	if(not Event_IsAnyRunning() and t_artyPos == nil) then
		Rule_RemoveMe()
		
		t_artyPos = {mkr_arty1, mkr_arty2, mkr_arty3, mkr_arty4}
		Rule_AddInterval(DropArtyIntro, 1.8)
	end
end

function DropArtyIntro()
	if(#t_artyPos > 0) then
		local pos = t_artyPos[1]
		Cmd_Ability(player2, ABILITY.GLOBAL.OFF_MAP_ARTY_SINGLE_SHOT_INSTANT, pos, nil, true)
		table.remove(t_artyPos, 1)
	else
		Rule_RemoveMe()
		Objective_Start(OBJ_DestroyArtillery)
	end
end

function AddArtilleryArrow(data)
	t_howitzerArrows = t_howitzerArrows or {-1, -1} --In case the objective was never started.
	t_howitzerArrows[data.index] = Objective_AddUIElements(OBJ_DestroyArtillery, SGroup_GetPosition(data.group), true, 11043184, true, 1, nil, HPAT_Bonus) -- LOCDB [11043184] 'German Artillery'
end

--[[Actions]]
function ObjArty_CheckComplete()
	if(SGroup_CountSpawned(sg_howitzers) == 0) then
		Rule_RemoveMe()
		Objective_Complete(OBJ_DestroyArtillery)
	end
end


function SetupHowitzer1()
	sg_howitzers = SGroup_CreateIfNotFound("sg_howitzers")
	--Howitzer1
	sg_howitzer1 = Util_CreateSquads(player2, "sg_howitzer1", SBP.GERMAN.HOWITZER_105MM_LE_FH18_ARTILLERY, mkr_howitzer1)
	SGroup_AddGroup(sg_howitzers, sg_howitzer1)
	
	Event_PlayerCanSeeElement(AddArtilleryArrow, {group = sg_howitzer1, index = 1}, player1, sg_howitzer1, ANY, 1)
	
	SGroup_SetRecrewable(sg_howitzer1, false)
	Event_OnHealth(DestroyHowitzer, {howitzerIndex = 1}, sg_howitzer1, 0.34, false)
	Util_LogSyncWpn(sg_howitzer1, true)
	
	g_howitzer1TargettingData = { --This data is used to make the howitzer home in on the player
		prevTarget = SGroup_GetPosition(sg_howitzer1),
		currentCount = 0,
		maxCount = 3,
		maxTargetDistance = 15,
		minTargetDistance = 5,
		lockOnDistance = g_howitzerLockOnDistance,
		warningTargetted = EVENTS.ObjArty_Incoming,
		abilityTargetted = BP_GetAbilityBlueprint("howitzer_105mm_barrage_short_precise"),
		warningLocked = EVENTS.ObjArty_Locked,
		abilityLocked = ABILITY.GLOBAL.HOWITZER_105MM_BARRAGE_SHORT,
		hintTargetted = {
			text = 11043185, -- LOCDB [11043185] 'Incoming Artillery'
			offset = 1.5,
			actionType = HPAT_Hint,
			icon = nil,
			timeout = 17,
		},
		hintLocked = {
			text = 11048327, -- LOCDB [11048327] 'Incoming Heavy Artillery'
			offset = 1.5,
			actionType = HPAT_Hint,
			icon = nil,
			timeout = 30,
		},
		eventCue = {
			cueStyle = CUE.ATTACKED,
			text = 11043186, -- LOCDB [11043186] 'Artillery fire'
			description = nil,
		}
	}
end

function SetupHowitzer2()
	sg_howitzers = SGroup_CreateIfNotFound("sg_howitzers")
	--Howitzer2
	sg_howitzer2 = Util_CreateSquads(player2, "sg_howitzer2", SBP.GERMAN.HOWITZER_105MM_LE_FH18_ARTILLERY, mkr_howitzer2)
	SGroup_AddGroup(sg_howitzers, sg_howitzer2)
	
	Event_PlayerCanSeeElement(AddArtilleryArrow, {group = sg_howitzer2, index = 2}, player1, sg_howitzer2, ANY, 1)
	
	SGroup_SetRecrewable(sg_howitzer2, false)
	Event_OnHealth(DestroyHowitzer, {howitzerIndex = 2}, sg_howitzer2, 0.34, false)
	Util_LogSyncWpn(sg_howitzer2, true)
	
	g_howitzer2TargettingData = { --This data is used to make the howitzer home in on the player
		prevTarget = SGroup_GetPosition(sg_howitzer2),
		currentCount = 0,
		maxCount = 3,
		lockOnDistance = g_howitzerLockOnDistance,
		maxTargetDistance = 15,
		minTargetDistance = 5,
		warningTargetted = EVENTS.ObjArty_Incoming,
		abilityTargetted = BP_GetAbilityBlueprint("howitzer_105mm_barrage_short_precise"),
		warningLocked = EVENTS.ObjArty_Locked,
		abilityLocked = ABILITY.GLOBAL.HOWITZER_105MM_BARRAGE_SHORT,
		hintTargetted = {
			text = 11043185, -- LOCDB [11043185] 'Incoming Artillery'
			offset = 1.5,
			actionType = HPAT_Hint,
			icon = nil,
			timeout = 17,
		},
		hintLocked = {
			text = 11043185, -- LOCDB [11043185] 'Incoming Artillery'
			offset = 1.5,
			actionType = HPAT_Hint,
			icon = nil,
			timeout = 30,
		},
		eventCue = {
			cueStyle = CUE.ATTACKED,
			text = 11043186,
			description = nil,
		}
	}
end

function StartArtillery()
	if(sg_howitzer1 and SGroup_CountSpawned(sg_howitzer1) > 0) then
		Rule_AddDelayedInterval(FireHowitzer1, 40, g_howitzerFireInterval)
	end
	
	if(sg_howitzer2 and SGroup_CountSpawned(sg_howitzer2) > 0) then
		Rule_AddDelayedInterval(FireHowitzer2, 40+(g_howitzerFireInterval/2), g_howitzerFireInterval)
	end
end

function StopArtillery()
	Rule_Remove(FireHowitzer1)
	Rule_Remove(FireHowitzer2)
end

function FireHowitzer1()
	local sg_target = Player_GetSquadConcentration(player1, nil, nil, {SBP.SOVIET.KATYUSHA_BM_13N_SQUAD, SBP.SOVIET.M5_HALFTRACK_SQUAD}, nil, {mkr_howitzerRange1, mkr_howitzerRange3})
--~ 	view(sg_target) --Debug.
	if(SGroup_IsAlive(sg_howitzer1)) then
		FireTargettingArtillery(sg_howitzer1, sg_target, g_howitzer1TargettingData)
	else
		Rule_RemoveMe()
	end
end

function FireHowitzer2()
	local sg_target = Player_GetSquadConcentration(player1, nil, nil, {SBP.SOVIET.KATYUSHA_BM_13N_SQUAD, SBP.SOVIET.M5_HALFTRACK_SQUAD}, nil, {mkr_howitzerRange2, mkr_howitzerRange3})
	
	if(SGroup_IsAlive(sg_howitzer2)) then
		FireTargettingArtillery(sg_howitzer2, sg_target, g_howitzer2TargettingData)
	else
		Rule_RemoveMe()
	end
end

function DestroyHowitzer(data)
	if(data.howitzerIndex == 1) then
		Rule_Remove(FireHowitzer1)
	elseif(data.howitzerIndex == 2) then
		Rule_Remove(FireHowitzer2)
	end
	
	if(Objective_IsCounterSet(OBJ_DestroyArtillery)) then
		Objective_SetCounter(OBJ_DestroyArtillery, Objective_GetCounter(OBJ_DestroyArtillery) + 1, 2)
		if(Objective_GetCounter(OBJ_DestroyArtillery) == 1) then
			Util_StartIntel(EVENTS.ObjArty_Howitzer1)
		end
	end
	if(t_howitzerArrows and t_howitzerArrows[data.howitzerIndex]) then
		Objective_RemoveUIElements(OBJ_DestroyArtillery, t_howitzerArrows[data.howitzerIndex])
	end
	
	SGroup_RemoveGroup(sg_howitzers, SGroup_FromName("sg_howitzer" .. data.howitzerIndex))
end






--------------------------------------------------------------------------------------------------------------------------------------------------
--************************************************************************************************************************************************
-- 													BONUS 2 - Secure northern bridge
--************************************************************************************************************************************************
--------------------------------------------------------------------------------------------------------------------------------------------------
function Initialize_BonusBridge()
	OBJ_SecureBridge = {
		SetupUI = function() 
			hpid_bridgeNorth = Objective_AddUIElements(OBJ_SecureBridge, eg_pointC, true, 11043188, true, 3, nil, HPAT_Bonus) -- LOCDB [11043188] 'Secure the Northern bridge'
		end,
		
		OnStart = function()
			-- Fires off after Intel_Start (unless Intel_Start is nil)
			g_currentBonus = OBJ_SecureBridge
			
			AlliesBridgeNorth()
			Rule_AddDelayedInterval(ObjBridge_CheckComplete, 1, 2)
		end,
		
		OnComplete = function()
			--[[ACHIEVEMENT: Secured northern bridge]]
			print("Achievement unlocked: Secured northern bridge")
			Scar_CompleteIntelBulletinTask(player1, "camp05_stalingrad_bonus_bridge")
		
			ReinforcePlayer()
			
			--Retreat the bridge guards, if alive.
			if(SGroup_CountSpawned(sg_northBridge) > 0) then
				Cmd_AbandonTeamWeapon(sg_northBridge, true)
				Cmd_Retreat(sg_northBridge, mkr_AT1, mkr_AT1)
			end
		end,
		
		OnFail = function()
		end,
		
		IsComplete = function()
			return false
		end,
		
		Skip = function()
		end,
		
		Intel_Start = EVENTS.ObjBridge_Intro,
		Intel_Complete = EVENTS.ObjBridge_Complete,
		Intel_Fail = nil,
		Title = 11043188, -- LOCDB [11043188] 'Secure the Northern bridge'
		TitleEnd = 11043189, -- LOCDB [11043189] 'Bridge secured'
		TitleFail = nil,
		Type = OT_Secondary,
	}
	
	Objective_Register(OBJ_SecureBridge)
end

function ObjBridge_DelayedStart()
	if(not Event_IsAnyRunning()) then
		Rule_RemoveMe()
		Objective_Start(OBJ_SecureBridge)
	end
end

function ObjBridge_CheckComplete()
	if(Util_GetPlayerOwner(eg_pointC) == player1 or Util_GetPlayerOwner(eg_pointC) == player3) then
		Rule_RemoveMe()
		Objective_Complete(OBJ_SecureBridge)
	end
end

function ReinforcePlayer()
	Util_CreateSquads(player1, nil, SBP.SOVIET.GUARDS_TROOPS, mkr_reinforcements, mkr_c1)
	Util_CreateSquads(player1, nil, (g_difficulty <= GD_NORMAL and SBP.SOVIET.GUARDS_TROOPS or SBP.SOVIET.CONSCRIPT_SQUAD), mkr_reinforcements, mkr_hmg2)
	sg_reinforceHT = Util_CreateSquads(player1, "sg_reinforceHT", SBP.SOVIET.M5_HALFTRACK_SQUAD, mkr_reinforcements, mkr_c7, nil, nil, nil, mkr_hmg2)
	
	if(g_difficulty <= GD_NORMAL) then
		SGroup_CompleteEntityUpgrade(sg_reinforceHT, UPG.SOVIET.M5_HALFTRACK_72K_AA_GUN_PACKAGE)
		SGroup_Destroy(sg_reinforceHT)
		sg_reinforceHT = nil
	end
	
	--Increase popcap if over limit
	Player_SetPopCapOverride(player1, math.max(Player_GetCurrentPopulation(player1, CT_Personnel), Player_GetMaxPopulation(player1, CT_Personnel)))
	
	--Alerts
	EventCue_Create(CUE.VEHICLE, 11043190, nil, mkr_c7) -- LOCDB [11043190] 'Soviet Reinforcements'
	UI_CreateMinimapBlip(mkr_c7, 10, BT_General)
end







-------------------------------------------------------------------------
-- Util functions
-------------------------------------------------------------------------
function _ReinforceHints()
	
	local conscripts = {
		SBP.SOVIET.BASE_CONSCRIPT_SQUAD,
		SBP.SOVIET.CONSCRIPT_SQUAD,
		SBP.SOVIET.PENAL_BATTALION,
	}
	Player_GetAll(player1, sg_playerMergeHints)
	SGroup_Filter(sg_playerMergeHints, conscripts, FILTER_KEEP)
	
	
	local infantry = {}
	local _add = function(k, v) table.insert(infantry, v) end
	table.foreach(LIST.INFANTRY, _add)
	table.foreach(LIST.ATGUNS, _add)
	table.foreach(LIST.HMGS, _add)
	
	Player_GetAll(player1, sg_playerReinforceHints)
	SGroup_Filter(sg_playerReinforceHints, infantry, FILTER_KEEP)
	
end

function _StopFlashing(data)
	UI_StopFlashing(data.id)
end

function _RemoveHint(data)
	HintPoint_Remove(data.hint)
end

function _StukaBomb(data)
--~ 	view(data.pos) --Debug
	Cmd_Ability(player2, ABILITY.GERMAN.STUKA_BOMBING_STRIKE, data.pos, nil, true)
	event_stuka = nil
	Rule_RemovePlayerEvent(_ResetStukaTimer, player1)
end

function _ResetStukaTimer()
	if(event_stuka ~= nil) then
--~ 		print("Resetting Stuka timer...") --Debug
		local event = Event_GetEvent(event_stuka)
		--Remove the existing event. Create a new one.
		Event_Remove(event_stuka)
		if(event ~= nil) then
			event_stuka = Event_Timer(_StukaBomb, {pos = event.data.pos}, World_GetRand(15, 20))
		end
	end
end

function _StopStukas()
	Event_Remove(event_stuka)
	event_stuka = nil
	Rule_RemovePlayerEvent(_ResetStukaTimer, player1)
end

function _ResetUnderAttackTimer()
	Rule_Remove(_PlayFlavourAudio)
	if(#t_flavourLines > 0) then
		Rule_AddDelayedInterval(_PlayFlavourAudio, g_flavourAudioDelay, 2)
	end
end

--Plays a line of Flavour audio on an on-screen unit if player is not in combat for 'g_flavourAudioDelay' seconds
function _PlayFlavourAudio()
	local playerSquads = Player_GetSquads(player1)
	
	if(#t_flavourLines == 0) then
		Rule_RemoveMe()
	elseif(not SGroup_IsUnderAttack(playerSquads, ALL, 4)) then
		--Find an on-screen unit to play the audio line on.
		for i=1, SGroup_CountSpawned(playerSquads) do
			local squad = SGroup_GetSpawnedSquadAt(playerSquads, i)
			
			if(Misc_IsSquadOnScreen(squad, 0.9) and not Squad_IsUnderAttack(squad, 4) and not Squad_IsAttacking(squad, 4)) then
--~		 			view(squad) --Debug.
				local locNum = World_GetRand(1, #t_flavourLines)
				Sound_PlayOnSquad("speech/sp/mission/m05/" .. t_flavourLines[locNum], squad)
				table.remove(t_flavourLines, locNum)
				Rule_AddOneShot(_ResetUnderAttackTimer, 0.5)
				break
			end
		end
	end
end

function _CheckHQ()
	if(EGroup_GetAvgHealth(eg_playerHQ) <= 0) then
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

function Troops() --Spawn a reasonable player force
	if Misc_IsCommandLineOptionSet("dev") then
		local pos = Misc_GetMouseOnTerrain()
		Util_CreateSquads(player1, nil, SBP.SOVIET.SHOCK_TROOPS, pos)
		Util_CreateSquads(player1, nil, SBP.SOVIET.CONSCRIPT_SQUAD, pos)
		Util_CreateSquads(player1, nil, SBP.SOVIET.T_34_76_SQUAD, pos)
		Util_CreateSquads(player1, nil, SBP.SOVIET.M1937_53_K_45MM_AT_GUN_SQUAD, pos)
	end
end

function PrepDefend()
	if Misc_IsCommandLineOptionSet("dev") then
		EGroup_InstantCaptureStrategicPoint(eg_pointA, player1)
		EGroup_InstantCaptureStrategicPoint(eg_pointB, player1)
		EGroup_InstantCaptureStrategicPoint(eg_pointD, player1)
		EGroup_InstantCaptureStrategicPoint(eg_pointE, player1)
		EGroup_InstantCaptureStrategicPoint(eg_pointF, player1)
		
		EGroup_EnableMinimapIndicator(eg_pointE, true)
		EGroup_EnableMinimapIndicator(eg_pointF, true)
		
		World_IncreaseInteractionStage()
	end
end

function ResetCam()
	if Misc_IsCommandLineOptionSet("dev") then
		Game_SetMode(UI_Normal)
		Game_FadeToBlack(FADE_IN, 0)
		Camera_ResetToDefault()
		Camera_SetInputEnabled(true)
	end
end

function ClearAll()
	if Misc_IsCommandLineOptionSet("dev") then
		AI_RemoveAllEncounters()
		SGroup_DestroyAllSquads(Player_GetSquads(player2))
		SGroup_DestroyAllSquads(Player_GetSquads(player3))
	end
end
