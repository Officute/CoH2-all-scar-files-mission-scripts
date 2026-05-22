-------------------------------------------------------------------------
-------------------------------------------------------------------------

-- MISSION NAME
-- Designer: Matt Philip

-------------------------------------------------------------------------
-------------------------------------------------------------------------

import("ScarUtil.scar")
import("TheatreOfWar.scar")
import("Systems/AiManager/ai.scar")
import("Prototype/DeploymentPoints.scar")

-------------------------------------------------------------------------
-- [[ SETUP ]]
-------------------------------------------------------------------------

function OnGameSetup()
	
end



function OnGameRestore()
	
	Game_DefaultGameRestore()
end


-------------------------------------------------------------------------
-- [[ ONINIT ]]
-------------------------------------------------------------------------

function OnInit()
	sg_e_all = SGroup_CreateIfNotFound("sg_e_all")
	sg_player_all = SGroup_CreateIfNotFound("sg_player_all")
	
	eg_e_base = EGroup_CreateIfNotFound("eg_e_base")

	TickerCount1 = Util_DifVar({World_GetRand(300,350),World_GetRand(350,400), World_GetRand(400,450)} )
	TickerCount2 = Util_DifVar({World_GetRand(50,100),World_GetRand(100,150), World_GetRand(100,200)} )
	
	EGroup_DeSpawn(eg_howitzers)
	
	g_TerritoryCheck =Util_DifVar({360,300,180} )

	t_difficulty = {
	
		enemy_manpower = Util_DifVar({100,200,1000} ),
		enemy_fuel = Util_DifVar({300,300,300} ),
	}
	
	t_germans = {}
	
	for i=1,World_GetPlayerCount() do
	
		local player = World_GetPlayerAt(i)
		ToW_SetUpTechTreeByYear(player,1942)
		ToW_SetStandardResources (player)
		if Player_GetRaceName(player) == "soviet" then
			Setup_SetPlayerName(player, 11038758)
			Player_CompleteUpgrade(player, UPG.SOVIET.HQ_ANTI_TANK_GRENADE_MP)
			Player_AddResource(player, RT_Manpower, 500)
			Player_AddResource(player, RT_Munition, 200)
			Util_CreateSquads(player,  sg_player_all, SBP.SOVIET.COMBAT_ENGINEER_SQUAD_MP, mkr_btl_sp_01 )
			Util_CreateSquads(player,  sg_player_all, SBP.SOVIET.CONSCRIPT_SQUAD_MP, mkr_btl_sp_02 )
			Player_SetEntityProductionAvailability(player, EBP.SOVIET.TANK_DEPOT_MP, ITEM_REMOVED)
		elseif Player_GetRaceName(player) == "german" and AI_IsAIPlayer(player) then
			Setup_SetPlayerName(player, 11038759)
			table.insert (t_germans, player)
			if AI_IsAIPlayer(player) then
				AI_SetPersonality( player, "tow_1942_ai_battles_terek")
			end
			Cmd_InstantUpgrade ( player, UPG.GERMAN.MORTAR_HALFTRACK)
			Cmd_InstantUpgrade ( player, UPG.GERMAN.PANZER_TACTICIAN)
			Player_SetResource ( player, RT_Command, 2 )
			Player_CompleteUpgrade(player, UPG.GERMAN.BATTLE_PHASE_2_MP)
			Player_CompleteUpgrade(player, UPG.GERMAN.BATTLE_PHASE_3_MP)
			Player_SetPopCapOverride(player, 150)
			Player_AddResource(player, RT_Fuel, t_difficulty.enemy_fuel)
			Player_AddResource(player, RT_Manpower, t_difficulty.enemy_fuel)
			Modify_PlayerResourceRate(player, RT_Fuel, 2)
		end
	end
	
	
	ToW_SetUpBattleObjectives ()
	AT_Gun_Setup()
	Rule_AddInterval(Tiger_Attack, 1)
	Rule_AddDelayedInterval(Check_Player_Territory, g_TerritoryCheck, 5)
	-- Atmosphere Setup
	Game_LoadAtmosphere("data:art/scenarios/presets/atmosphere/DLC/tow_terek_dusk.aps", 0)
	
end

Scar_AddInit(OnInit)

function AT_Gun_Setup() 
	Util_CreateEntities(nil, eg_AT_Gun, EBP.SOVIET.M1937_53_K_45MM_AT_GUN_MP, mkr_btl_AT_Gun_01, 1 )
	Util_CreateEntities(nil, eg_AT_Gun, EBP.SOVIET.M1942_76MM_DIVISIONAL_GUN_ZIS_3_MP, mkr_btl_AT_Gun_02, 1 )
	Util_CreateEntities(nil, eg_AT_Gun, EBP.SOVIET.M1942_76MM_DIVISIONAL_GUN_ZIS_3_MP, mkr_btl_AT_Gun_03, 1 )
	Util_CreateEntities(nil, eg_AT_Gun, EBP.SOVIET.M1937_53_K_45MM_AT_GUN_MP, mkr_btl_AT_Gun_04, 1 )
end


------------------------------------
-- Special Events
------------------------------------

-- check to see if players do not own the any VP or the player owns most of the territories without capturing any VP's
function Check_Player_Territory()
	if VPTicker_GetTeamTickers(1) >= 500 and Player_GetNumVictoryPoints(t_germans[1]) == 0 then
		Territory_Retaliation()
		Rule_RemoveMe()
	elseif Player_GetNumVictoryPoints(t_germans[1]) ~= 0 then
		print("Removing Territory Check!!!!!!!!!!!!!!!")
		Rule_RemoveMe()
	end
end

function Territory_Check_Delay()
	Rule_AddInterval(Check_Player_Territory, 5)
	Rule_RemoveMe()
end

function Territory_Retaliation()
	local ter_choice = Util_DifVar( { Ter_Retal_Easy, Ter_Retal_Normal, Ter_Retal_Hard} )
	ter_choice()
	Rule_AddInterval(Territory_Check_Delay, 120)
end

function Ter_Retal_Easy()
	if VPTicker_GetTeamTickers(1) ~= 0 then
		Squad_CreateAndSpawnToward( SBP.GERMAN.PANZER_IV_SQUAD_MP, t_germans[1], 1, Util_GetPosition(mkr_btl_enemy_spawn_01),  Util_GetPosition(mkr_btl_enemy_spawn_01) ) 
		Squad_CreateAndSpawnToward( SBP.GERMAN.OSTRUPPEN_SQUAD_MP, t_germans[1], 4, Util_GetPosition(mkr_btl_enemy_spawn_01),  Util_GetPosition(mkr_btl_enemy_spawn_01) ) 
		Squad_CreateAndSpawnToward( SBP.GERMAN.OSTRUPPEN_SQUAD_MP, t_germans[1], 4, Util_GetPosition(mkr_btl_enemy_spawn_01),  Util_GetPosition(mkr_btl_enemy_spawn_01) ) 
	end
end

function Ter_Retal_Normal()
	if VPTicker_GetTeamTickers(1) ~= 0 then
		Squad_CreateAndSpawnToward( SBP.GERMAN.MORTAR_250_HALFTRACK_SQUAD_MP, t_germans[1], 1, Util_GetPosition(mkr_btl_enemy_spawn_01),  Util_GetPosition(mkr_btl_enemy_spawn_01) ) 
		Squad_CreateAndSpawnToward( SBP.GERMAN.PANZER_IV_SQUAD_MP, t_germans[1], 1, Util_GetPosition(mkr_btl_enemy_spawn_02),  Util_GetPosition(mkr_btl_enemy_spawn_01) ) 
		Squad_CreateAndSpawnToward( SBP.GERMAN.OSTRUPPEN_SQUAD_MP, t_germans[1], 4, Util_GetPosition(mkr_btl_enemy_spawn_01),  Util_GetPosition(mkr_btl_enemy_spawn_01) ) 
		Squad_CreateAndSpawnToward( SBP.GERMAN.OSTRUPPEN_SQUAD_MP, t_germans[1], 4, Util_GetPosition(mkr_btl_enemy_spawn_02),  Util_GetPosition(mkr_btl_enemy_spawn_01) ) 
	end
end

function Ter_Retal_Hard()
	if VPTicker_GetTeamTickers(1) ~= 0 then
		Squad_CreateAndSpawnToward( SBP.GERMAN.MORTAR_250_HALFTRACK_SQUAD_MP, t_germans[1], 1, Util_GetPosition(mkr_btl_enemy_spawn_01),  Util_GetPosition(mkr_btl_enemy_spawn_01) ) 
		Squad_CreateAndSpawnToward( SBP.GERMAN.PANZER_IV_SQUAD_MP, t_germans[1], 1, Util_GetPosition(mkr_btl_enemy_spawn_01),  Util_GetPosition(mkr_btl_enemy_spawn_01) ) 
		Squad_CreateAndSpawnToward( SBP.GERMAN.PANZER_IV_SQUAD_MP, t_germans[1], 4, Util_GetPosition(mkr_btl_enemy_spawn_02),  Util_GetPosition(mkr_btl_enemy_spawn_01) ) 
		Squad_CreateAndSpawnToward( SBP.GERMAN.GRENADIER_SQUAD_MP, t_germans[1], 4, Util_GetPosition(mkr_btl_enemy_spawn_01),  Util_GetPosition(mkr_btl_enemy_spawn_01) ) 
		Squad_CreateAndSpawnToward( SBP.GERMAN.GRENADIER_SQUAD_MP, t_germans[1], 4, Util_GetPosition(mkr_btl_enemy_spawn_02),  Util_GetPosition(mkr_btl_enemy_spawn_01) ) 
	end
end

-- Enemy Retaliation Wave that is called in between Tiger Attacks
function Enemy_Retaliation()
	local enemy_choice = Util_DifVar( { Enemy_Retal_Easy, Enemy_Retal_Normal, Enemy_Retal_Hard} )
	enemy_choice()
end

function Enemy_Retal_Easy()
	if VPTicker_GetTeamTickers(1) ~= 0 then
		Squad_CreateAndSpawnToward( SBP.GERMAN.MORTAR_250_HALFTRACK_SQUAD_MP, t_germans[1], 1, Util_GetPosition(mkr_btl_enemy_spawn_01),  Util_GetPosition(mkr_btl_enemy_spawn_01) ) 
	end
end

function Enemy_Retal_Normal()
	if VPTicker_GetTeamTickers(1) ~= 0 then
		Squad_CreateAndSpawnToward( SBP.GERMAN.MORTAR_250_HALFTRACK_SQUAD_MP, t_germans[1], 1, Util_GetPosition(mkr_btl_enemy_spawn_01),  Util_GetPosition(mkr_btl_enemy_spawn_01) ) 
		Squad_CreateAndSpawnToward( SBP.GERMAN.OSTRUPPEN_SQUAD_MP, t_germans[1], 4, Util_GetPosition(mkr_btl_enemy_spawn_01),  Util_GetPosition(mkr_btl_enemy_spawn_01) ) 
	end
end

function Enemy_Retal_Hard()
	if VPTicker_GetTeamTickers(1) ~= 0 then
		Squad_CreateAndSpawnToward( SBP.GERMAN.MORTAR_250_HALFTRACK_SQUAD_MP, t_germans[1], 1, Util_GetPosition(mkr_btl_enemy_spawn_01),  Util_GetPosition(mkr_btl_enemy_spawn_01) ) 
		Squad_CreateAndSpawnToward( SBP.GERMAN.MORTAR_250_HALFTRACK_SQUAD_MP, t_germans[1], 1, Util_GetPosition(mkr_btl_enemy_spawn_01),  Util_GetPosition(mkr_btl_enemy_spawn_01) ) 
		Squad_CreateAndSpawnToward( SBP.GERMAN.OSTRUPPEN_SQUAD_MP, t_germans[1], 4, Util_GetPosition(mkr_btl_enemy_spawn_01),  Util_GetPosition(mkr_btl_enemy_spawn_01) ) 
		Squad_CreateAndSpawnToward( SBP.GERMAN.OSTRUPPEN_SQUAD_MP, t_germans[1], 4, Util_GetPosition(mkr_btl_enemy_spawn_01),  Util_GetPosition(mkr_btl_enemy_spawn_01) ) 
	end
end

-- Check for Ticker Count to call in First Tank Attack
function Tiger_Attack()
	local base_isUnderAttack = false
	-- get everything the player owns
	Player_GetAll(t_germans[1], sg_e_all, eg_e_base)
	-- filter out things that aren't HQ buildings, and buildings currently under construction
	EGroup_Filter(eg_e_base, {EBP.GERMAN.GERMAN_HQ_MP, EBP.GERMAN.HINTERE_PANZERWERK_MP, EBP.GERMAN.BEREICH_FESTUNG_MP, EBP.GERMAN.DOLCH_AKTIONEN_MP, EBP.GERMAN.HINTERE_PANZERWERK_MP}, FILTER_KEEP)
	EGroup_FilterUnderConstruction(eg_e_base, FILTER_REMOVE)
	-- check each entity remaining in the group. As soon as one is less than half health, set the flag
	if EGroup_GetAvgHealth(eg_e_base) <= 0.70  then
		base_isUnderAttack = true
	end

	if VPTicker_GetTeamTickers(1) <= TickerCount1 or base_isUnderAttack == true then
		Tiger_Spawn_Enc()
		Rule_RemoveMe()
	end
end

function Tiger_Spawn_Enc()
	local TigerAttack_EncounterData = {
		name = "Tiger_Attack",
		player = t_germans[1],
		spawn = mkr_btl_enemy_spawn_01,
		sgroups = {sg_e_all},
		veterancyRank = Util_DifVar({0, 0, 1}),
		units = {
			{
				sbp = Util_DifVar( { SBP.GERMAN.PANZER_IV_SQUAD_MP, SBP.GERMAN.TIGER_SQUAD_MP, SBP.GERMAN.TIGER_SQUAD_MP} ),
			},
			{
				sbp = Util_DifVar( { SBP.GERMAN.OSTRUPPEN_SQUAD_MP, SBP.GERMAN.OSTRUPPEN_SQUAD_MP, SBP.GERMAN.GRENADIER_SQUAD_MP} ),
			},
			{
				sbp = Util_DifVar( { SBP.GERMAN.OSTRUPPEN_SQUAD_MP, SBP.GERMAN.OSTRUPPEN_SQUAD_MP, SBP.GERMAN.GRENADIER_SQUAD_MP} ),
			},
		},
		onDeath = nil,
	}
	local Tiger_AttackData = {
		name = "Attack",
		target = mkr_btl_enemy_dest_01,
		leashRange = 45,
		range = 70,
		attackMove = true,
		useSkirmishAI = true,
		tacticControlsList = {
			{
				tacticType = TACTIC_Vehicle,
				priority = 100,
			},
		},
	}
	encID_TigerAttack = Encounter:Create(TigerAttack_EncounterData)
	encID_TigerAttack:SetGoal(Tiger_AttackData)
	Rule_AddInterval(Tiger_Attack2, 1)
	Event_Timer(Enemy_Retaliation, nil, World_GetRand(120, 240))
end

-- Check for Ticker Count to call in Second Tank Attack
function Tiger_Attack2()

	local base_isUnderAttack = false
	Player_GetAll(t_germans[1], sg_e_all, eg_e_base)
	EGroup_Filter(eg_e_base, {EBP.GERMAN.GERMAN_HQ_MP, EBP.GERMAN.HINTERE_PANZERWERK_MP, EBP.GERMAN.BEREICH_FESTUNG_MP, EBP.GERMAN.DOLCH_AKTIONEN_MP, EBP.GERMAN.HINTERE_PANZERWERK_MP}, FILTER_KEEP)
	EGroup_FilterUnderConstruction(eg_e_base, FILTER_REMOVE)
	
	if EGroup_GetAvgHealth(eg_e_base) <= 0.25 then
		base_isUnderAttack = true
	end

	if VPTicker_GetTeamTickers(1) <= TickerCount2 or base_isUnderAttack == true then
		Tiger_Spawn_Enc2()
		Tiger_Spawn_Enc2b()
		Rule_RemoveMe()
	end
end

function Tiger_Spawn_Enc2()
	local TigerAttack_EncounterData2 = {
		name = "Tiger_Attack",
		player = t_germans[1],
		spawn = mkr_btl_enemy_spawn_01,
		sgroups = {sg_e_all},
		veterancyRank = Util_DifVar({1, 2, 3}),
		units = {
			{
				sbp = Util_DifVar( { SBP.GERMAN.PANZER_IV_SQUAD_MP, SBP.GERMAN.TIGER_SQUAD_MP, SBP.GERMAN.TIGER_SQUAD_MP} ),
			},
			{
				sbp = Util_DifVar( { SBP.GERMAN.OSTRUPPEN_SQUAD_MP, SBP.GERMAN.OSTRUPPEN_SQUAD_MP, SBP.GERMAN.GRENADIER_SQUAD_MP} ),
			},
			{
				sbp = Util_DifVar( { SBP.GERMAN.OSTRUPPEN_SQUAD_MP, SBP.GERMAN.OSTRUPPEN_SQUAD_MP, SBP.GERMAN.GRENADIER_SQUAD_MP} ),
			},
		},
		onDeath = nil,
	}
	local Tiger_AttackData2 = {
		name = "Attack",
		target = mkr_btl_enemy_dest_02,
		leashRange = 45,
		range = 90,
		attackMove = true,
		useSkirmishAI = true,
		tacticControlsList = {
			{
				tacticType = TACTIC_Vehicle,
				priority = 100,
			},
		},
	}
	encID_TigerAttack2 = Encounter:Create(TigerAttack_EncounterData2)
	encID_TigerAttack2:SetGoal(Tiger_AttackData2)
end
function Tiger_Spawn_Enc2b()
	local TigerAttack_EncounterData2b = {
		name = "Tiger_Attack",
		player = t_germans[1],
		spawn = mkr_btl_enemy_spawn_02,
		sgroups = {sg_e_all},
		veterancyRank = Util_DifVar({1, 2, 3}),
		units = {
			{
				sbp = Util_DifVar( { SBP.GERMAN.PANZER_IV_SQUAD_MP, SBP.GERMAN.TIGER_SQUAD_MP, SBP.GERMAN.TIGER_SQUAD_MP} ),
			},
			{
				sbp = Util_DifVar( { SBP.GERMAN.OSTRUPPEN_SQUAD_MP, SBP.GERMAN.OSTRUPPEN_SQUAD_MP, SBP.GERMAN.GRENADIER_SQUAD_MP} ),
			},
			{
				sbp = Util_DifVar( { SBP.GERMAN.OSTRUPPEN_SQUAD_MP, SBP.GERMAN.OSTRUPPEN_SQUAD_MP, SBP.GERMAN.GRENADIER_SQUAD_MP} ),
			},
		},
		onDeath = nil,
	}
	local Tiger_AttackData2b = {
		name = "Attack",
		target = mkr_btl_enemy_dest_03,
		leashRange = 45,
		range = 90,
		attackMove = true,
		useSkirmishAI = true,
		tacticControlsList = {
			{
				tacticType = TACTIC_Vehicle,
				priority = 100,
			},
		},
	}
	encID_TigerAttack2b = Encounter:Create(TigerAttack_EncounterData2b)
	encID_TigerAttack2b:SetGoal(Tiger_AttackData2b)
	Event_Timer(Enemy_Retaliation, nil, World_GetRand(120, 240))
end
