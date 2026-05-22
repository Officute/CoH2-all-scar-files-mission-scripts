-------------------------------------------------------------------------
-------------------------------------------------------------------------

-- MISSION: Tiger Ace
-- Designer: Shannon Gadbois

-------------------------------------------------------------------------
-------------------------------------------------------------------------

import("ScarUtil.scar")
import("Systems/AiManager/ai.scar")
import("Prototype/DeploymentPoints.scar")
import("TheatreOfWar.scar")
-- [[ IMPORT MISSION SCRIPTS ]]
import("Tiger_Ace_Obj.scar")
import("Tiger_Ace_Encounters.scar")

-------------------------------------------------------------------------
-- [[ SETUP ]]
-------------------------------------------------------------------------

function OnGameSetup()
	-- Required Players
	player1 = Setup_Player(1, 11038759, "german", 1) -- player1 is always the human player
	player2 = Setup_Player(2, 11038758, "soviet", 2) -- player2 is always the AI opponent

	-- Optional Players
	player3 = Setup_Player(3, 0, "soviet", 1)		-- player3 is always the AI ally

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
	
	--[[ MISSION PRESETS ]]
	Mission_MissionPreset()
	
	--[[ PLAY INTRO NIS]]
	Game_StartMuted(true)
	
	--[[ GAME START CHECK ]]
	Rule_Add(Mission_MissionStart)
	
	
end

function OnGameRestore()
	player1 = World_GetPlayerAt(1)
	player2 = World_GetPlayerAt(2)
	player3 = World_GetPlayerAt(3)
	UI_SetCPMeterVisibility(true)
	UI_SetAbilityCardVisibility(true)
	Rule_AddOneShot(Tiger_OnGameRestore, 1)
	Game_DefaultGameRestore()
end

function Tiger_OnGameRestore()
	UI_SetCPMeterVisibility(false)
	UI_SetAbilityCardVisibility(false)
end

Scar_AddInit(OnInit)

function Mission_Debug()

	-- looks for the command line option [-debug]
	if Misc_IsCommandLineOptionSet("debug") then
		g_debug = true
	end
	
	-- set up bindings for NISes
--~ 	Scar_DebugConsoleExecute("bind([[ALT+1]], [[Scar_DoString('Util_StartNIS(NIS_OPENING_BLEND)')]])")
--~ 	Scar_DebugConsoleExecute("bind([[ALT+2]], [[Scar_DoString('Util_StartNIS(NIS_CLOSING)')]])")

end
-- Difficulty Tables and Setup
function Mission_Difficulty()
	
	g_difficulty = Game_GetSPDifficulty() 
	
	t_defaultGoalData_attackEasy = {
	  abilityControlsList = {
		{
			abilityPBG = ABILITY.SOVIET.ANTI_TANK_GRENADE,
			maxCasters = 1,
			retryTimeSecs = 6,
			waitTimeSecs = 15,
			useInitialWaitTime = false,
		},
		{
			abilityPBG = ABILITY.SOVIET.BUTTON_VEHICLE_TOW,
			maxCasters = 1,
			retryTimeSecs = 25,
			waitTimeSecs = 30,
			useInitialWaitTime = false,
		},
	  }
	}
	
	t_defaultGoalData_attackNormal = {
	  abilityControlsList = {
		{
			abilityPBG = ABILITY.SOVIET.ANTI_TANK_GRENADE,
			maxCasters = 2,
			retryTimeSecs = 3,
			waitTimeSecs = 8,
			useInitialWaitTime = false,
		},
		{
			abilityPBG = ABILITY.SOVIET.BUTTON_VEHICLE_TOW,
			maxCasters = 1,
			retryTimeSecs = 20,
			waitTimeSecs = 25,
			useInitialWaitTime = false,
		},
	  }
	}
	
	t_defaultGoalData_attackHard = {
	  abilityControlsList = {
		{
			abilityPBG = ABILITY.SOVIET.ANTI_TANK_GRENADE,
			maxCasters = 4,
			retryTimeSecs = 3,
			waitTimeSecs = 6,
			useInitialWaitTime = false,
		},
		{
			abilityPBG = ABILITY.SOVIET.BUTTON_VEHICLE_TOW,
			maxCasters = 1,
			retryTimeSecs = 15,
			waitTimeSecs = 20,
			useInitialWaitTime = false,
		},
	  }
	}
	
	t_enemy_type_easy = {
		
		unit = SBP.SOVIET.BASE_CONSCRIPT_SQUAD,
		unit_at = SBP.SOVIET.M1937_53_K_45MM_AT_GUN_SQUAD,
		unit_tank = SBP.SOVIET.T_34_76_SQUAD,
		upgrade = UPG.SOVIET.PTRS_41_AT_RIFLE_PACKAGE_GUARD_TROOP,
	
	}
	
	t_enemy_type_normal = {
		
		unit = SBP.SOVIET.BASE_CONSCRIPT_SQUAD,
		unit_at = SBP.SOVIET.M1937_53_K_45MM_AT_GUN_SQUAD,
		unit_tank = SBP.SOVIET.T_34_76_SQUAD,
		upgrade = UPG.SOVIET.PTRS_41_AT_RIFLE_PACKAGE_GUARD_TROOP,
	}
	t_enemy_type_hard = {
		
		unit = SBP.SOVIET.M1937_53_K_45MM_AT_GUN_SQUAD,
		unit_at = SBP.SOVIET.M1942_ZIS_3_76MM_AT_GUN_SQUAD,
		unit_tank = SBP.SOVIET.KV_1,
		upgrade = UPG.SOVIET.GUARD_DP_28_LMG_PACKAGE,
	}

	t_difficulty = {
		defaultAttackGoalData 		= Util_DifVar( {t_defaultGoalData_attackEasy, t_defaultGoalData_attackNormal, t_defaultGoalData_attackHard, {}}),
		startingMunition 			= Util_DifVar( { 50, 50, 100, 100, } ),
		point_reward 			= Util_DifVar( { 175, 150, 100, 100, } ),
		rewardMunitions 			= Util_DifVar( { 11051792, 11051791, 11051790, 11051790, } ),
		enemy_difficulty_type = Util_DifVar( { t_enemy_type_easy,  t_enemy_type_normal,    t_enemy_type_hard,    t_enemy_type_hard, } ),
		enemy_tank_health = Util_DifVar( { 0.5,  0.75, 1, 1, } ),
		downed_tank_health = Util_DifVar( { 0.10,  0.15, 0.25, 0.25, } ),
	}
	
	AIAttackGoal_AdjustDefaultGoalData(t_difficulty.defaultAttackGoalData)
end

function Mission_Restrictions()

	-- Utilize for setting restrictions on Units, teams, etc
	ToW_SetUpTechTreeByYear(player1, 1942) 
	ToW_SetUpTechTreeByYear(player2, 1942)
	ToW_SetUpTechTreeByYear(player3, 1942)
	
	-- Player 1 Setup
	player_rank = 0
	Player_AddResource(player1, RT_Munition, t_difficulty.startingMunition)
	Rule_AddInterval(Player_AbilityHints, 1, 1000) -- UI Hints for abilities as they unlock

	Modify_PlayerResourceRate( player1, RT_Manpower, 0, MUT_Multiplication )
	Modify_PlayerResourceRate( player1, RT_Munition, 0, MUT_Multiplication )
	Modify_PlayerResourceRate( player1, RT_Fuel, 	 0, MUT_Multiplication )
	
	
	Modify_AbilityMunitionsCost(player1, ABILITY.GERMAN.PANZER_PANTHER_TIGER_OSTWIND_REPAIR_TOW, Util_DifVar({1, 1, 1.5, 1.5}) )
	
	-- Player 2 Setup (AI)
	Player_SetAbilityAvailability(player2, ABILITY.SOVIET.T_34_RAMMING_ABILITY, ITEM_LOCKED)
	Player_SetAbilityAvailability(player2, ABILITY.SOVIET.T70_CREW_REPAIR_ABILITY, ITEM_LOCKED)
	Player_SetAbilityAvailability(player2, ABILITY.SOVIET.ANTI_TANK_GRENADE, ITEM_UNLOCKED)
	Player_SetAbilityAvailability(player2, ABILITY.SOVIET.BUTTON_VEHICLE_TOW, ITEM_UNLOCKED)
	Player_SetAbilityAvailability(player2, ABILITY.SOVIET.BUTTON_VEHICLE, ITEM_REMOVED)
	Player_AddAbility(player2, ABILITY.SOVIET.IL_2_RECON_SINGLEPASS_SP)
	
	Player_AddUnspentCommandPoints(player2, 6)
	Player_AddResource(player2, RT_Munition, 9999)
	-- Player 3 Setup
	Player_AddAbility(player3, ABILITY.GERMAN.AMBUSH_CAMO_HOLD_FIRE_MP) 
	Player_AddUnspentCommandPoints(player3, 6)
	Player_AddResource(player3, RT_Munition, 9999)
	Player_SetAbilityAvailability(player3, ABILITY.GERMAN.AMBUSH_CAMOUFLAGE, ITEM_UNLOCKED)
	Player_SetAbilityAvailability(player3, ABILITY.GERMAN.GRENADIER_PANZERFAUST, ITEM_LOCKED)
	Cmd_InstantUpgrade(player3, UPG.GERMAN.CAN_CAMOUFLAGE)
	Player_AddAbility(player3, ABILITY.GERMAN.AMBUSH_CAMOUFLAGE_UPGRADE) 

end

-------------------------------------------------------------------------
-- MISSION Preset 
-------------------------------------------------------------------------

function Mission_MissionPreset()

	-- Kicks off after SCAR Inits, but before MissionStart is called.
	-- Use for spawning units on the map at the start
	
	-- variables
	Game_FadeToBlack(FADE_OUT, 0) -- initial fade out for intro movie to hide game interface popping in
	marker = 1 -- variable used in wreck clean up function
	
	-- tables

	-- Player Unit Setup
	sg_Tiger = SGroup_CreateIfNotFound("sg_Tiger")
	eg_temp = EGroup_CreateIfNotFound("eg_temp")
	Util_CreateSquads (player1, sg_Tiger, BP_GetSquadBlueprint("tiger_squad_tow"), mkr_player_start, mkr_player_start2, 1)
	
	SGroup_EnableAttention(sg_Tiger, false)
	Misc_SelectSquad(SGroup_GetSpawnedSquadAt(sg_Tiger, 1), true)
	Misc_SetSquadControlGroup(SGroup_GetSpawnedSquadAt(sg_Tiger, 1), 1)
	Misc_SetSelectionInputEnabled(false)
	Rule_AddInterval(Tiger_MaintainSelection, 1)
	
	Modify_TargetPriority(sg_Tiger, 1000)
	
	-- Enemy units
	Event_Timer (SetupEncounters, nil, 0.25)
	
	-- Camera Setup
	Camera_SetDefault(nil, nil, -135)
	Camera_ResetToDefault()
	Camera_Follow(sg_Tiger)
	
	Rule_AddInterval(Wreck_CleanUp, 2)
	-- World Setup
	EGroup_SetInvulnerable(eg_bridge, true) -- make the east bridge entrance invulnerable so the entry point isn't blocked.
	EGroup_SetSelectable(eg_bridge, false)
	EGroup_SetInvulnerable(eg_train, true) 
	EGroup_SetSelectable(eg_train, false)
	FOW_RevealArea(Util_GetPosition(mkr_enc1_ui), 2, 0.25)
	FOW_RevealArea(Util_GetPosition(mkr_enc2_ui), 2, 0.25)
	FOW_RevealArea(Util_GetPosition(mkr_enc3_ui), 2, 0.25)
	FOW_RevealArea(Util_GetPosition(mkr_enc4_ui), 2, 0.25)
	FOW_RevealArea(Util_GetPosition(mkr_enc5_ui), 2, 0.25)
	FOW_RevealArea(Util_GetPosition(mkr_enc6_ui), 2, 0.25)
	FOW_RevealArea(Util_GetPosition(mkr_enc7_ui), 2, 0.25)
	
	
	
end

function Tiger_MaintainSelection()
	if SGroup_IsEmpty(sg_Tiger) == false then
		if not Misc_IsSGroupSelected(sg_Tiger, ANY) then
			Misc_SelectSquad(SGroup_GetSpawnedSquadAt(sg_Tiger, 1), true)
		end
	end
end
-------------------------------------------------------------------------
-- MISSION START 
-------------------------------------------------------------------------

function Mission_MissionStart()
	Rule_RemoveMe()
	Util_StartIntel(EVENTS.Intro)
	
	Event_Timer(Hide_UI, nil, 1)

	-- Minefield Warning Events
	Event_Proximity(Minefield01_Warning, nil, sg_Tiger, mkr_minefield_01, 40, ANY)
	Event_Proximity(Minefield01_Warning, nil, sg_Tiger, mkr_minefield_02, 40, ANY)
end

function Hide_UI()
	UI_SetAbilityCardVisibility(false)
	UI_SetCPMeterVisibility(false)
end	
function Minefield01_Warning()
	Util_StartIntel(EVENTS.Minefield)
end

-- clean up function to prevent wrecks from blocking entry points
function Wreck_CleanUp()

	if marker == 1 then
		World_GetNeutralEntitiesNearMarker(eg_temp, mkr_cleanup_01)
		EGroup_Filter(eg_temp, EBP.WRECKED_VEHICLES, FILTER_KEEP )
		EGroup_Kill(eg_temp)
		marker = 2
	elseif marker == 2 then
		World_GetNeutralEntitiesNearMarker(eg_temp, mkr_cleanup_02)
		EGroup_Filter(eg_temp, EBP.WRECKED_VEHICLES, FILTER_KEEP )
		EGroup_Kill(eg_temp)
		marker = 3
	elseif marker == 3 then
		World_GetNeutralEntitiesNearMarker(eg_temp, mkr_cleanup_03)
		EGroup_Filter(eg_temp, EBP.WRECKED_VEHICLES, FILTER_KEEP )
		EGroup_Kill(eg_temp)
		marker = 4
	elseif marker == 4 then
		World_GetNeutralEntitiesNearMarker(eg_temp, mkr_cleanup_04)
		EGroup_Filter(eg_temp, EBP.WRECKED_VEHICLES, FILTER_KEEP )
		EGroup_Kill(eg_temp)
		marker = 5
	elseif marker == 5 then
		World_GetNeutralEntitiesNearMarker(eg_temp, mkr_cleanup_05)
		EGroup_Filter(eg_temp, EBP.WRECKED_VEHICLES, FILTER_KEEP )
		EGroup_Kill(eg_temp)
		marker = 1
	end
end

function Player_AbilityHints()
	if SGroup_GetVeterancyRank(sg_Tiger) == 1 and player_rank == 0 then
		UI_AddHintAndFlashAbility(player1, ABILITY.GERMAN.PANZER_PANTHER_TIGER_DEFENSIVE_SMOKE_TOW, 11051342, 5)
		player_rank = player_rank + 1
	elseif SGroup_GetVeterancyRank(sg_Tiger) == 2 and player_rank == 1 then
		UI_AddHintAndFlashAbility(player1, ABILITY.GERMAN.PANZER_PANTHER_TIGER_OSTWIND_REPAIR_TOW, 11051343, 5)
		player_rank = player_rank + 1
	elseif SGroup_GetVeterancyRank(sg_Tiger) == 3 and player_rank == 2 then
		UI_AddHintAndFlashAbility(player1, ABILITY.GERMAN.PANZER_PANTHER_TIGER_OSTWIND_BLITZKRIEG_TOW, 11051344, 5)
		player_rank = player_rank + 1
	elseif player_rank == 3 then
		Rule_RemoveMe()
	end
end


