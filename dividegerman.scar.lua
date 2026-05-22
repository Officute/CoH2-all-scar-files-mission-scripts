-------------------------------------------------------------------------
-------------------------------------------------------------------------

-- MISSION NAME
-- Designer: Shannon Gadbois

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

	-- groups
	sg_p_all = SGroup_CreateIfNotFound("sg_p_all")
	sg_p_tiger = SGroup_CreateIfNotFound("sg_p_tiger")
	sg_p1 = SGroup_CreateIfNotFound("sg_p1")
	sg_p2 = SGroup_CreateIfNotFound("sg_p2")
	sg_e_all = SGroup_CreateIfNotFound("sg_e_all")
	
	sg_e_is_01 = SGroup_CreateIfNotFound("sg_e_is_01")
	sg_e_is_02 = SGroup_CreateIfNotFound("sg_e_is_02")
	eg_e_base = EGroup_CreateIfNotFound("eg_e_base")

	-- variables
	TickerCount1 = Util_DifVar({World_GetRand(300,350),World_GetRand(350,400), World_GetRand(400,450)} )
	TickerCount2 = Util_DifVar({World_GetRand(75,125),World_GetRand(100,125), World_GetRand(125,150)} )
	
	Mission_Difficulty()	
t_soviets = {}
	
	for i=1,World_GetPlayerCount() do
	
		local player = World_GetPlayerAt(i)
		ToW_SetUpTechTreeByYear(player,1943)
		ToW_SetStandardResources (player)
		if Player_GetRaceName(player) == "german" then
			
			if Player_IsHuman(player) == false then
				Setup_SetPlayerName(player, 11038759)
			end	
			if AI_IsAIPlayer(player)  then
				
			end	
			-- Setup Player Resources
--~ 			Player_SetResource (player, RT_Command, 2 )
--~ 			Player_SetResource(player, RT_Munition, 100)
			Player_SetEntityProductionAvailability(player, EBP.GERMAN.SCHWERES_KRIEGSWERK_MP, ITEM_REMOVED)
			Player_SetEntityProductionAvailability(player, EBP.GERMAN.HINTERE_PANZERWERK_MP, ITEM_REMOVED)
			Player_SetUpgradeAvailability(player, UPG.GERMAN.BATTLE_PHASE_4_MP,ITEM_REMOVED)
			Player_SetUpgradeAvailability(player, UPG.GERMAN.BATTLE_PHASE_3_MP,ITEM_REMOVED)
	
		elseif Player_GetRaceName(player) == "soviet" then
			
			table.insert (t_soviets, player)
			
			-- Setup Player Resources
			Player_AddResource(player, RT_Manpower, t_difficulty.enemy_manpower)
			Player_AddResource(player, RT_Munition, t_difficulty.enemy_munition)
			Player_AddResource(player, RT_Fuel, t_difficulty.enemy_fuel)
			Modify_PlayerResourceRate(player, RT_Manpower, t_difficulty.enemy_manpower_rate)
			Modify_PlayerResourceRate(player, RT_Munition, t_difficulty.enemy_munition_rate)
			if Player_IsHuman(player) == false then
				Setup_SetPlayerName(player, 11038758)
			end	
			if AI_IsAIPlayer(player) then
				AI_SetPersonality( player, "tow_1943_ai_battle_divide")
			end
		end
	end
	
	ToW_SetUpBattleObjectives ()

	
	-- spawn initial player units
	Util_CreateSquads(World_GetPlayerAt(1), {sg_p_all, sg_p_tiger}, SBP.GERMAN.TIGER_SQUAD_MP, mkr_btl_player1_tiger, nil, 1)
	Util_CreateSquads(World_GetPlayerAt(1), {sg_p_all, sg_p_tiger}, SBP.GERMAN.GRENADIER_SQUAD_MP, mkr_btl_p1_sp_01, nil, 1)
	Util_CreateSquads(World_GetPlayerAt(1), {sg_p_all, sg_p_tiger}, SBP.GERMAN.GRENADIER_SQUAD_MP, mkr_btl_p1_sp_02, nil, 1)
	
	Util_CreateSquads(World_GetPlayerAt(2), {sg_p_all, sg_p_tiger}, SBP.GERMAN.TIGER_SQUAD_MP, mkr_btl_player2_tiger, nil, 1)
	Util_CreateSquads(World_GetPlayerAt(2), {sg_p_all, sg_p_tiger}, SBP.GERMAN.GRENADIER_SQUAD_MP, mkr_btl_p2_sp_01, nil, 1)
	Util_CreateSquads(World_GetPlayerAt(2), {sg_p_all, sg_p_tiger}, SBP.GERMAN.GRENADIER_SQUAD_MP, mkr_btl_p2_sp_02, nil, 1)
	
	SGroup_IncreaseVeterancyRank(sg_p_tiger, 0)
	-- setup preowned points
	EGroup_InstantCaptureStrategicPoint( eg_point1, t_soviets[1] ) 
--~ 	EGroup_InstantCaptureStrategicPoint( eg_point2, t_soviets[1] ) 
	EGroup_InstantCaptureStrategicPoint( eg_point3, t_soviets[1] ) 
	
	-- spawn initial enemy player units
	Util_CreateSquads( World_GetPlayerAt(3), sg_e_all, SBP.SOVIET.M1942_ZIS_3_76MM_AT_GUN_SQUAD_MP, mkr_btl_player2_sp_01)
	Util_CreateSquads( World_GetPlayerAt(3), sg_e_all, SBP.SOVIET.CONSCRIPT_SQUAD_MP, mkr_btl_player2_sp_01)
	Util_CreateSquads( World_GetPlayerAt(3), sg_e_all, SBP.SOVIET.CONSCRIPT_SQUAD_MP, mkr_btl_player2_sp_01)
	
	-- spawn initial enemy player units
	Util_CreateSquads( World_GetPlayerAt(4), sg_e_all, SBP.SOVIET.M1942_ZIS_3_76MM_AT_GUN_SQUAD_MP, mkr_btl_player2_sp_02)
	Util_CreateSquads( World_GetPlayerAt(4), sg_e_all, SBP.SOVIET.CONSCRIPT_SQUAD_MP, mkr_btl_player2_sp_02)
	Util_CreateSquads( World_GetPlayerAt(4), sg_e_all, SBP.SOVIET.CONSCRIPT_SQUAD_MP, mkr_btl_player2_sp_02)
	
	
	Point1_Defense_Enc()
--~ 	Point2_Defense_Enc()
	Point3_Defense_Enc()
	Base_Defense_Enc_01()
	Base_Defense_Enc_02()
	Rule_AddInterval(Heavy_Tank_Retaliation_01, 1)
end

function Mission_Difficulty()	
	g_difficulty = Game_GetSPDifficulty() 
	
	t_difficulty = {
 	-- Easy, Medium, Hard
		enemy_manpower = Util_DifVar({200,500,1000} ),
		enemy_munition = Util_DifVar({100,200,300} ),
		enemy_fuel = Util_DifVar({50,100,200} ),
		
		bonus_enemy_manpower = Util_DifVar({200,500,1000} ),
		bonus_enemy_munition = Util_DifVar({100,200,300} ),
		bonus_enemy_fuel = Util_DifVar({100,200,300} ),
		
		enemy_manpower_rate = Util_DifVar({1,1.15,1.2} ),
		enemy_munition_rate = Util_DifVar({1,1.5,1.5} ),
	}
	
end

Scar_AddInit(OnInit)


-- Pre Placed AI Setup

function Point1_Defense_Enc()
	local Point1_Defense_EncounterData = {
		name = "Point 1 AT",
		player = World_GetPlayerAt(3),
		sgroups = {sg_e_all},
		veterancyRank = Util_DifVar({0, 1, 2}),
		units = {
			{
				sbp = Util_DifVar( { SBP.SOVIET.PENAL_BATTALION_MP, SBP.SOVIET.PENAL_BATTALION_MP, SBP.SOVIET.PENAL_BATTALION_MP} ),
				spawn = mkr_btl_pt1_sp_01,
			},
			{
				sbp = Util_DifVar( { SBP.SOVIET.PENAL_BATTALION_MP, SBP.SOVIET.PENAL_BATTALION_MP, SBP.SOVIET.PENAL_BATTALION_MP} ),
				spawn = mkr_btl_pt1_sp_02,
			},
			{
				sbp = Util_DifVar( { SBP.SOVIET.M1937_53_K_45MM_AT_GUN_SQUAD_MP, SBP.SOVIET.M1942_ZIS_3_76MM_AT_GUN_SQUAD_MP, SBP.SOVIET.M1942_ZIS_3_76MM_AT_GUN_SQUAD_MP} ),
				spawn = mkr_btl_pt1_at_01,
			},
			{
				sbp = Util_DifVar( { SBP.SOVIET.M1937_53_K_45MM_AT_GUN_SQUAD_MP, SBP.SOVIET.M1942_ZIS_3_76MM_AT_GUN_SQUAD_MP, SBP.SOVIET.M1942_ZIS_3_76MM_AT_GUN_SQUAD_MP} ),
				spawn = mkr_btl_pt1_at_02,
			},
		},
		onDeath = nil,
	}
	local Point1_Defense_AttackData = {
		name = "Defend",
		target = mkr_pt1_defend,
		leashRange = 25,
		range = 45,
		attackMove = true,
		useSkirmishAI = false,
--~ 		tacticControlsList = {

--~ 		},
	}
	encID_Point1_Defense = Encounter:Create(Point1_Defense_EncounterData)
	encID_Point1_Defense:SetGoal(Point1_Defense_AttackData)
end


-- Pre Placed AI Setup

function Point2_Defense_Enc()
	local Point2_Defense_EncounterData = {
		name = "Point 2 AT",
		player = World_GetPlayerAt(3),
		sgroups = {sg_e_all},
		veterancyRank = Util_DifVar({0, 1, 2}),
		units = {
			{
				sbp = Util_DifVar( { SBP.SOVIET.PENAL_BATTALION_MP, SBP.SOVIET.PENAL_BATTALION_MP, SBP.SOVIET.PENAL_BATTALION_MP} ),
				spawn = mkr_btl_pt2_sp_01,
			},
			{
				sbp = Util_DifVar( { SBP.SOVIET.PENAL_BATTALION_MP, SBP.SOVIET.PENAL_BATTALION_MP, SBP.SOVIET.PENAL_BATTALION_MP} ),
				spawn = mkr_btl_pt2_sp_02,
			},
			{
				sbp = Util_DifVar( { SBP.SOVIET.M1937_53_K_45MM_AT_GUN_SQUAD_MP, SBP.SOVIET.M1942_ZIS_3_76MM_AT_GUN_SQUAD_MP, SBP.SOVIET.M1942_ZIS_3_76MM_AT_GUN_SQUAD_MP} ),
				spawn = mkr_btl_pt2_at_01,
			},
			{
				sbp = Util_DifVar( { SBP.SOVIET.M1937_53_K_45MM_AT_GUN_SQUAD_MP, SBP.SOVIET.M1942_ZIS_3_76MM_AT_GUN_SQUAD_MP, SBP.SOVIET.M1942_ZIS_3_76MM_AT_GUN_SQUAD_MP} ),
				spawn = mkr_btl_pt2_at_02,
			},
		},
		onDeath = nil,
	}
	local Point2_Defense_AttackData = {
		name = "Defend",
		target = mkr_pt2_defend,
		leashRange = 35,
		range = 45,
		attackMove = true,
		useSkirmishAI = false,
--~ 		tacticControlsList = {

--~ 		},
	}
	encID_Point2_Defense = Encounter:Create(Point2_Defense_EncounterData)
	encID_Point2_Defense:SetGoal(Point2_Defense_AttackData)
end

-- Pre Placed AI Setup

function Point3_Defense_Enc()
	local Point3_Defense_EncounterData = {
		name = "Point 3 AT",
		player = World_GetPlayerAt(4),
		sgroups = {sg_e_all},
		veterancyRank = Util_DifVar({0, 1, 2}),
		units = {
			{
				sbp = Util_DifVar( { SBP.SOVIET.PENAL_BATTALION_MP, SBP.SOVIET.PENAL_BATTALION_MP, SBP.SOVIET.PENAL_BATTALION_MP} ),
				spawn = mkr_btl_pt3_sp_01,
			},
			{
				sbp = Util_DifVar( { SBP.SOVIET.PENAL_BATTALION_MP, SBP.SOVIET.PENAL_BATTALION_MP, SBP.SOVIET.PENAL_BATTALION_MP} ),
				spawn = mkr_btl_pt3_sp_02,
			},
			{
				sbp = Util_DifVar( { SBP.SOVIET.M1937_53_K_45MM_AT_GUN_SQUAD_MP, SBP.SOVIET.M1942_ZIS_3_76MM_AT_GUN_SQUAD_MP, SBP.SOVIET.M1942_ZIS_3_76MM_AT_GUN_SQUAD_MP} ),
				spawn = mkr_btl_pt3_at_01,
			},
			{
				sbp = Util_DifVar( { SBP.SOVIET.M1937_53_K_45MM_AT_GUN_SQUAD_MP, SBP.SOVIET.M1942_ZIS_3_76MM_AT_GUN_SQUAD_MP, SBP.SOVIET.M1942_ZIS_3_76MM_AT_GUN_SQUAD_MP} ),
				spawn = mkr_btl_pt3_at_02,
			},
		},
		onDeath = nil,
	}
	local Point3_Defense_AttackData = {
		name = "Defend",
		target = mkr_pt3_defend,
		leashRange = 25,
		range = 45,
		attackMove = true,
		useSkirmishAI = true,
		tacticControlsList = {

		},
	}
	encID_Point3_Defense = Encounter:Create(Point3_Defense_EncounterData)
	encID_Point3_Defense:SetGoal(Point3_Defense_AttackData)
end

function Heavy_Tank_Retaliation_01()
	local base_isUnderAttack = false
	-- get everything the player owns
	for index, player in pairs(t_soviets) do
		
		Player_GetAll(player, sg_e_all, eg_e_base)
		EGroup_Filter(eg_e_base, {EBP.SOVIET.HQ_MP, EBP.SOVIET.BARRACKS_MP, EBP.SOVIET.MOTORPOOL_MP, EBP.SOVIET.TANK_DEPOT_MP, EBP.SOVIET.WEAPON_SUPPORT_CENTER_MP}, FILTER_KEEP)
		EGroup_FilterUnderConstruction(eg_e_base, FILTER_REMOVE)
		
		local _basecheck = function(gid, idx, eid)
			if Entity_GetHealthPercentage(eid) <= 0.75 then
				return true
			end
		end
		
		if EGroup_Count(eg_e_base) <= 2 and EGroup_ForEachAllOrAny(eg_e_base, ANY, _basecheck) then
			base_isUnderAttack = true
		end
		
	end

	if VPTicker_GetTeamTickers(1) <= TickerCount1 or base_isUnderAttack == true then
		Spawn_IS2_01()
		Rule_AddInterval(Heavy_Tank_Retaliation_02, 1)
		Rule_RemoveMe()
	end
end

function Heavy_Tank_Retaliation_02()

	local base_isUnderAttack = false
	
	for index, player in pairs(t_soviets) do
		
		Player_GetAll(player, sg_e_all, eg_e_base)
		EGroup_Filter(eg_e_base, {EBP.SOVIET.HQ_MP, EBP.SOVIET.BARRACKS_MP, EBP.SOVIET.MOTORPOOL_MP, EBP.SOVIET.TANK_DEPOT_MP, EBP.SOVIET.WEAPON_SUPPORT_CENTER_MP}, FILTER_KEEP)
		EGroup_FilterUnderConstruction(eg_e_base, FILTER_REMOVE)
		
		local _basecheck = function(gid, idx, eid)
			if Entity_GetHealthPercentage(eid) <= 0.25 then
				return true
			end
		end
		
		if EGroup_Count(eg_e_base) == 1 or (EGroup_Count(eg_e_base) <= 2 and EGroup_ForEachAllOrAny(eg_e_base, ANY, _basecheck)) then
			base_isUnderAttack = true
		end
		
	end

	if VPTicker_GetTeamTickers(1) <= TickerCount2 or base_isUnderAttack == true then
		Spawn_IS2_02()
		Rule_RemoveMe()
	end
end
-- Spawn in Heavy Soviet Tank
function Spawn_IS2_01()
	Util_CreateSquads( World_GetPlayerAt(3), { sg_e_all, sg_e_is_01}, SBP.SOVIET.IS_2_MP, mkr_btl_p2_tank_sp_01)
	SGroup_IncreaseVeterancyRank(sg_e_is_01, Util_DifVar({0, 1, 2}) )
	
end

function Spawn_IS2_02()
	Util_CreateSquads( World_GetPlayerAt(3), { sg_e_all, sg_e_is_02}, SBP.SOVIET.IS_2_MP, mkr_btl_p2_tank_sp_01)
	Util_CreateSquads( World_GetPlayerAt(4), { sg_e_all, sg_e_is_02}, SBP.SOVIET.IS_2_MP, mkr_btl_p2_tank_sp_02)
	SGroup_IncreaseVeterancyRank(sg_e_is_02, Util_DifVar({1, 2, 3}) )
	
	Player_AddResource(World_GetPlayerAt(3), RT_Fuel, t_difficulty.bonus_enemy_fuel)
	Player_AddResource(World_GetPlayerAt(4), RT_Fuel, t_difficulty.bonus_enemy_fuel)
	
	Player_AddResource(World_GetPlayerAt(3), RT_Manpower, t_difficulty.bonus_enemy_manpower)
	Player_AddResource(World_GetPlayerAt(4), RT_Manpower, t_difficulty.bonus_enemy_manpower)
end

function Base_Defense_Enc_01()
	local Base_Defense_EncounterData = {
		name = "Base Defense Encounter 01",
		player = World_GetPlayerAt(3),
		sgroups = {sg_e_all},
		veterancyRank = Util_DifVar({1, 2, 3}),
		units = {
			{
				sbp = Util_DifVar( { SBP.SOVIET.PENAL_BATTALION_MP, SBP.SOVIET.PENAL_BATTALION_MP, SBP.SOVIET.PENAL_BATTALION_MP} ),
				spawn = mkr_btl_base_enc_01,
			},
			{
				sbp = Util_DifVar( { SBP.SOVIET.PENAL_BATTALION_MP, SBP.SOVIET.PENAL_BATTALION_MP, SBP.SOVIET.PENAL_BATTALION_MP} ),
				spawn = mkr_btl_base_enc_02,
			},
			{
				sbp = Util_DifVar( { SBP.SOVIET.M1937_53_K_45MM_AT_GUN_SQUAD_MP, SBP.SOVIET.M1942_ZIS_3_76MM_AT_GUN_SQUAD_MP, SBP.SOVIET.M1942_ZIS_3_76MM_AT_GUN_SQUAD_MP} ),
				spawn = mkr_btl_base_enc_01,
			},
			{
				sbp = Util_DifVar( { SBP.SOVIET.M1937_53_K_45MM_AT_GUN_SQUAD_MP, SBP.SOVIET.M1942_ZIS_3_76MM_AT_GUN_SQUAD_MP, SBP.SOVIET.M1942_ZIS_3_76MM_AT_GUN_SQUAD_MP} ),
				spawn = mkr_btl_base_enc_02,
			},
		},
		onDeath = nil,
	}
	local Base_Defense_AttackData = {
		name = "Defend",
		target = mkr_btl_base_area_01,
		leashRange = 25,
		range = 45,
		attackMove = true,
		useSkirmishAI = true,
		tacticControlsList = {

		},
	}
	encID_Base_Defense = Encounter:Create(Base_Defense_EncounterData)
	encID_Base_Defense:SetGoal(Base_Defense_AttackData)
end

function Base_Defense_Enc_02()
	local Base_Defense_02_EncounterData = {
		name = "Base Defense Encounter 02",
		player = World_GetPlayerAt(4),
		sgroups = {sg_e_all},
		veterancyRank = Util_DifVar({1, 2, 3}),
		units = {
			{
				sbp = Util_DifVar( { SBP.SOVIET.PENAL_BATTALION_MP, SBP.SOVIET.PENAL_BATTALION_MP, SBP.SOVIET.PENAL_BATTALION_MP} ),
				spawn = mkr_btl_base_enc_03,
			},
			{
				sbp = Util_DifVar( { SBP.SOVIET.PENAL_BATTALION_MP, SBP.SOVIET.PENAL_BATTALION_MP, SBP.SOVIET.PENAL_BATTALION_MP} ),
				spawn = mkr_btl_base_enc_04,
			},
			{
				sbp = Util_DifVar( { SBP.SOVIET.M1937_53_K_45MM_AT_GUN_SQUAD_MP, SBP.SOVIET.M1942_ZIS_3_76MM_AT_GUN_SQUAD_MP, SBP.SOVIET.M1942_ZIS_3_76MM_AT_GUN_SQUAD_MP} ),
				spawn = mkr_btl_base_enc_03,
			},
			{
				sbp = Util_DifVar( { SBP.SOVIET.M1937_53_K_45MM_AT_GUN_SQUAD_MP, SBP.SOVIET.M1942_ZIS_3_76MM_AT_GUN_SQUAD_MP, SBP.SOVIET.M1942_ZIS_3_76MM_AT_GUN_SQUAD_MP} ),
				spawn = mkr_btl_base_enc_04,
			},
		},
		onDeath = nil,
	}
	local Base_Defense_02_AttackData = {
		name = "Defend",
		target = mkr_btl_base_area_02,
		leashRange = 25,
		range = 45,
		attackMove = true,
		useSkirmishAI = true,
		tacticControlsList = {

		},
	}
	encID_Base_Defense_02 = Encounter:Create(Base_Defense_02_EncounterData)
	encID_Base_Defense_02:SetGoal(Base_Defense_02_AttackData)
end