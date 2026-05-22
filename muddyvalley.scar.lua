-------------------------------------------------------------------------
-------------------------------------------------------------------------

-- Muddy Valley (a.k.a. Breaking Lines)
-- Designer: NJR

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
	
	player1 = World_GetPlayerAt(1)		-- Soviets (players)
	player2 = World_GetPlayerAt(2)
	player3 = World_GetPlayerAt(3)
	
	player4 = World_GetPlayerAt(5)		-- Germans (enemies)
	player5 = World_GetPlayerAt(6)
	player6 = World_GetPlayerAt(7)
	
end


function OnGameRestore()
	
	player1 = World_GetPlayerAt(1)
	player2 = World_GetPlayerAt(2)
	player3 = World_GetPlayerAt(3)
	
	player4 = World_GetPlayerAt(4)
	player5 = World_GetPlayerAt(5)
	player6 = World_GetPlayerAt(6)
	
	Game_DefaultGameRestore()
	
end


-------------------------------------------------------------------------
-- [[ ONINIT ]]
-------------------------------------------------------------------------

function OnInit()
	
	sg_temp = SGroup_CreateIfNotFound("sg_temp")
	sg_blah = SGroup_CreateIfNotFound("sg_blah")
	eg_temp = EGroup_CreateIfNotFound("eg_temp")
	eg_blah = EGroup_CreateIfNotFound("eg_blah")
	
	sg_p1_units = SGroup_CreateIfNotFound("sg_p1_units")
	sg_p2_units = SGroup_CreateIfNotFound("sg_p2_units")
	sg_p3_units = SGroup_CreateIfNotFound("sg_p3_units")
	
	t_germans = {}
	t_soviets = {}
	g_difficulty = Game_GetSPDifficulty()
	
	-- set the initial ownership of all the points
	EGroup_Clear(eg_temp)
	World_GetStrategyPoints(eg_temp, false)
	EGroup_InstantCaptureStrategicPoint(eg_temp, player1)
	
	EGroup_InstantCaptureStrategicPoint(eg_vp1, player4)
	EGroup_InstantCaptureStrategicPoint(eg_vp2, player5)
	EGroup_InstantCaptureStrategicPoint(eg_vp3, player6)
	
	for i=1,World_GetPlayerCount() do
		
		local player = World_GetPlayerAt(i)
		
		ToW_SetUpTechTreeByYear(player, 1943)
		ToW_SetStandardResources (player)
		
		if Player_GetRaceName(player) == "german" then
			
			table.insert (t_germans, player)
			if AI_IsAIPlayer(player) then
				
			end
			if Player_IsHuman(player) == false then
				Setup_SetPlayerName(player, 11038759)
			end
			
		elseif Player_GetRaceName(player) == "soviet" then
			
			table.insert (t_soviets, player)			
			if Player_IsHuman(player) == false then
				Setup_SetPlayerName(player, 11038758)
			end
			
		end
		
	end
	
	-- set up the objective
	ToW_SetUpBattleObjectives()
	
	Create_Start_Units()		-- create the extra units the players start with
	Create_VP_Defenders()		-- create the enemy units defending each VP
 	
end

Scar_AddInit(OnInit)







-- create some extra units for the players to start with
function Create_Start_Units()

	local details = {
		{player = player1, group = sg_p1_units, target_area = mkr_vp1_area},
		{player = player2, group = sg_p2_units, target_area = mkr_vp2_area},
		{player = player3, group = sg_p3_units, target_area = mkr_vp3_area},
	}
	
	for index, this in pairs(details) do 
		
		Player_GetAll(this.player)
		EGroup_Filter(eg_allentities, EBP.SOVIET.HQ_MP, FILTER_KEEP)
		
		Util_CreateSquads(this.player, this.group, SBP.SOVIET.CONSCRIPT_SQUAD_MP, EGroup_GetPosition(eg_allentities), nil, 2)
		
		if Player_IsHuman(this.player) == false then
			
			local goal = {
				name = "Attack",
				target = this.target_area,
				range = Marker_GetProximityRadius(this.target_area),
				leashRange = Marker_GetProximityRadius(this.target_area) + 30,
			}
			local this_encounter = Encounter:ConvertSgroup(this.group)
			this_encounter:SetGoal(goal)
			
		end
		
	end

end





-- create all of the enemy units that are set to guard the VPs on the map
function Create_VP_Defenders()
	
	--
	-- vp 1 (village corner)
	--
	EGroup_Clear(eg_temp)
	Util_CreateEntities(player4, eg_temp, EBP.GERMAN.SLIT_TRENCH_GERMAN_MP, mkr_vp1_spawn2, 1)
	
	local encData_VP1 = {
		name = "VP1 Defence",
		player = player4,
		spawn = mkr_vp1_area,
		units = {
			{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD_MP},
			{sbp = SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD_MP, spawn = mkr_vp1_spawn1},
			{sbp = SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD_MP, spawn = eg_temp},
		},
		goal = {
			name = "Defend",
			target = mkr_vp1_area,
			garrison = true,
			garrisonIdle = true,
			range = Marker_GetProximityRadius(mkr_vp1_area) + 30,
			leashRange = Marker_GetProximityRadius(mkr_vp1_area),
		},
		triggerGoalOnEngage = true,
	}
	enc_VP1_Defence = Encounter:Create(encData_VP1)
	
	--
	-- vp 2 (middle)
	--
	local encData_VP2 = {
		name = "VP2 Defence",
		player = player5,
		spawn = mkr_vp2_area,
		units = {
			{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD_MP},
			{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD_MP, upgrades = UPG.GERMAN.PANZERBUSCHE_39_MP},
			{sbp = SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD_MP, spawn = mkr_vp2_spawn1},
			{sbp = SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD_MP, spawn = mkr_vp2_spawn2},
		},
		goal = {
			name = "Defend",
			target = mkr_vp2_area,
			range = Marker_GetProximityRadius(mkr_vp2_area) + 45,
			leashRange = Marker_GetProximityRadius(mkr_vp2_area),
		},
		triggerGoalOnEngage = true,
	}
	enc_VP2_Defence = Encounter:Create(encData_VP2)
	
	--
	-- vp 3 (industrial corner)
	--
	EGroup_Clear(eg_temp)
	Util_CreateEntities(player6, eg_temp, EBP.GERMAN.SLIT_TRENCH_GERMAN_MP, mkr_vp3_spawn2, 1)
	
	local encData_VP3 = {
		name = "VP3 Defence",
		player = player6,
		spawn = mkr_vp3_area,
		units = {
			{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD_MP},
			{sbp = SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD_MP, spawn = mkr_vp3_spawn1},
			{sbp = SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD_MP, spawn = eg_temp},
		},
		goal = {
			name = "Defend",
			target = mkr_vp3_area,
			garrison = true,
			garrisonIdle = true,
			range = Marker_GetProximityRadius(mkr_vp3_area) + 30,
			leashRange = Marker_GetProximityRadius(mkr_vp3_area),
		},
		triggerGoalOnEngage = true,
	}
	enc_VP3_Defence = Encounter:Create(encData_VP3)
	
	
end
