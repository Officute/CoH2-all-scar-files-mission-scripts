-------------------------------------------------------------------------
-------------------------------------------------------------------------

-- MISSION NAME: Compound - Soviet
-- Designer: Sacha Narine
-- Description: Use a captured Pak43 to defend the map center, and break the German defenses (compound) around the east VP

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
	--
end


function OnGameRestore()
	Game_DefaultGameRestore()
end


-------------------------------------------------------------------------
-- [[ ONINIT ]]
-------------------------------------------------------------------------

function OnInit()
	
	t_germans = {}
	
	sg_p_all = SGroup_CreateIfNotFound("sg_p_all")
	sg_p1 = SGroup_CreateIfNotFound("sg_p1")
	sg_p2 = SGroup_CreateIfNotFound("sg_p2")
	sg_e_all = SGroup_CreateIfNotFound("sg_e_all")
	sg_e1 = SGroup_CreateIfNotFound("sg_e1")
	sg_e2 = SGroup_CreateIfNotFound("sg_e2")
	sg_e_brummbar = SGroup_CreateIfNotFound("sg_e_brummbar")
	eg_e_base = EGroup_CreateIfNotFound("eg_e_base")
	-- variables
	TickerCount1 = Util_DifVar({World_GetRand(300,350),World_GetRand(350,400), World_GetRand(400,450)} )
	TickerCount2 = Util_DifVar({World_GetRand(125,150),World_GetRand(175,200), World_GetRand(250,275)} )
	
	g_difficulty = Game_GetSPDifficulty()

	for i=1,World_GetPlayerCount() do
	
		local player = World_GetPlayerAt(i)
		ToW_SetStandardResources (player)
		Player_SetResource (player, RT_Command, 1 )
		Player_SetResource(player, RT_Munition, 100)
		Player_SetResource(player, RT_Manpower, 500)
		Modify_PlayerResourceRate(player, RT_Manpower, 1.1)
		ToW_SetUpTechTreeByYear(player,1943)
		
		if Player_GetRaceName(player) == "soviet" then
			
			if Player_IsHuman(player) == false then
				Setup_SetPlayerName(player, 11038758)
			end
			if AI_IsAIPlayer(player) then
				
			end
			
		elseif Player_GetRaceName(player) == "german" then
			
			table.insert (t_germans, player)
			if Player_IsHuman(player) == false then
				Setup_SetPlayerName(player, 11038759)
			end
			if AI_IsAIPlayer(player)  then
				
			end
			
		end
	end

	Mission_Difficulty()
	
	-- Player Spawns
	-- Grant the Soviet team a captured Pak 43 AT gun
	pakOwner = World_GetPlayerAt(1)
	pakOwner_02 = World_GetPlayerAt(2)

	eg_pak43 = EGroup_CreateIfNotFound("eg_pak43")
	Util_CreateEntities(nil, eg_pak43, EBP.GERMAN.PAK43_88MM_AT_GUN_MP, mkr_pak43, 1) -- World_Pos(-75, 10, -22)
	Util_CreateSquads(pakOwner, sg_p1, SBP.SOVIET.CONSCRIPT_SQUAD_MP, mkr_pak43, nil, nil, 3) -- World_Pos(-74, 10, -21)
	Cmd_CaptureTeamWeapon(sg_p1, eg_pak43)
	
	eg_pak43_02 = EGroup_CreateIfNotFound("eg_pak43_02")
	Util_CreateEntities(nil, eg_pak43_02, EBP.GERMAN.PAK43_88MM_AT_GUN_MP, mkr_pak43_02, 1) -- World_Pos(-75, 10, -22)
	Util_CreateSquads(pakOwner_02, sg_p2, SBP.SOVIET.CONSCRIPT_SQUAD_MP, mkr_pak43_02, nil, nil, 3) -- World_Pos(-74, 10, -21)
	Cmd_CaptureTeamWeapon(sg_p2, eg_pak43_02)
	
	-- Starting Mortar Squads
	Util_CreateSquads(World_GetPlayerAt(1), sg_p1, SBP.SOVIET.HM_120_38_MORTAR_SQUAD_MP, mkr_p1_mortar, nil, 1)
	Util_CreateSquads(World_GetPlayerAt(2), sg_p2, SBP.SOVIET.HM_120_38_MORTAR_SQUAD_MP, mkr_p2_mortar, nil, 1)
	
	ToW_SetUpBattleObjectives ()
	
	-- Flare Mines
	-- Grant the Soviet player some pre-placed flare (tripwire) mines
	eg_flareMines = EGroup_CreateIfNotFound("eg_flareMines")
	Util_CreateEntities(World_GetPlayerAt(1), eg_flareMines, EBP.SOVIET.FLARE_MINE_MP, mkr_flareMine1, 1)
	Util_CreateEntities(World_GetPlayerAt(2), eg_flareMines, EBP.SOVIET.FLARE_MINE_MP, mkr_flareMine2, 1)
	Util_CreateEntities(World_GetPlayerAt(1), eg_flareMines, EBP.SOVIET.FLARE_MINE_MP, mkr_flareMine3, 1)
	Util_CreateEntities(World_GetPlayerAt(1), eg_flareMines, EBP.SOVIET.FLARE_MINE_MP, mkr_flareMine5, 1)
	Util_CreateEntities(World_GetPlayerAt(2), eg_flareMines, EBP.SOVIET.FLARE_MINE_MP, mkr_flareMine6, 1)

	-- Enemy Spawns
	-- German squads pre-garrisoned in the Compound area
--~ 	Util_CreateSquads(World_GetPlayerAt(3), sg_e1, SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD_MP, eg_northeast)
--~ 	if AI_IsEnabled(World_GetPlayerAt(3)) then
--~ 		AI_LockSquads(World_GetPlayerAt(3), sg_e1)
--~ 	end
--~ 	Util_CreateSquads(World_GetPlayerAt(4), sg_e2, SBP.GERMAN.SNIPER_SQUAD_MP, eg_center)
--~ 	if AI_IsEnabled(World_GetPlayerAt(4)) then
--~ 		AI_LockSquads(World_GetPlayerAt(4), sg_e2)
--~ 	end
	
	-- Bunkers
	-- German bunkers in the compound area
--~ 	eg_germanBunker1 = EGroup_CreateIfNotFound("eg_germanBunker1")
--~ 	eg_germanBunker2 = EGroup_CreateIfNotFound("eg_germanBunker2")
--~ 	Util_CreateEntities(World_GetPlayerAt(3), eg_germanBunker1, EBP.GERMAN.BUNKER_MP, mkr_germanBunker1, 1)
--~ 	Cmd_Upgrade(eg_germanBunker1, UPG.GERMAN.BUNKER_COMMAND_MP, 1, true)
--~ 	Util_CreateEntities(World_GetPlayerAt(4), eg_germanBunker2, EBP.GERMAN.BUNKER_MP, mkr_germanBunker2, 1)
--~ 	Cmd_Upgrade(eg_germanBunker2, UPG.GERMAN.BUNKER_MEDIC_STATION_MP, 1, true)
	
	-- Mines
	eg_germanMines = EGroup_CreateIfNotFound("eg_germanMines")
	
	--Check for switching personality to armor based units 
	Rule_AddInterval(Tank_Personality_Check, 2)
	
	-- German patrollers
	-- These squads spawn into scripted patrol routes
--~ 	Rule_AddOneShot(PatrollerSpawn1, t_difficulty.spawn1Delay)
--~ 	Rule_AddOneShot(PatrollerSpawn2, t_difficulty.spawn2Delay)
--~ 	Rule_AddOneShot(PatrollerSpawn3, t_difficulty.spawn3Delay)
--~ 	Rule_AddOneShot(PatrollerSpawn4, t_difficulty.spawn4Delay)
	
	-- Intro Speech 
	Util_StartIntel(EVENTS.Intro)
	
end



function Mission_Difficulty()	
	g_difficulty = Game_GetSPDifficulty() 
	
	t_difficulty = {
 	-- Easy, Medium, Hard
		spawn1Delay = Util_DifVar({60,30,15,15}),
		spawn2Delay = Util_DifVar({150,75,30,30}),
		spawn3Delay = Util_DifVar({300,150,75,75}),
		spawn4Delay = Util_DifVar({800,400,200,200}),
		
	}
	
end

function Tank_Personality_Check()
	local base_isUnderAttack = false
	-- get everything the player owns
	for index, player in pairs(t_germans) do
		
		Player_GetAll(player, sg_e_all, eg_e_base)
		EGroup_Filter(eg_e_base, {EBP.GERMAN.GERMAN_HQ_MP, EBP.GERMAN.HINTERE_PANZERWERK_MP, EBP.GERMAN.BEREICH_FESTUNG_MP, EBP.GERMAN.DOLCH_AKTIONEN_MP, EBP.GERMAN.HINTERE_PANZERWERK_MP}, FILTER_KEEP)
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
		Activate_Tank_Personality_Phase1()
		Rule_RemoveMe()
	end
end

function Activate_Tank_Personality_Phase1()
	if Player_GetRaceName(World_GetPlayerAt(3)) == "german" and AI_IsAIPlayer(World_GetPlayerAt(3)) then
		print("SWITCHING PERSONALITY 1")
		AI_SetPersonality(World_GetPlayerAt(3), "tow_1943_ai_battle_compound")
	end	
	Player_AddResource(World_GetPlayerAt(3), RT_Manpower, 1000)
	Player_AddResource(World_GetPlayerAt(3), RT_Fuel, 500)
	Modify_PlayerResourceRate(World_GetPlayerAt(3), RT_Fuel, 2)
	Player_CompleteUpgrade(World_GetPlayerAt(3), UPG.GERMAN.BATTLE_PHASE_2)

	if Player_GetRaceName(World_GetPlayerAt(4)) == "german" and AI_IsAIPlayer(World_GetPlayerAt(4)) then
		print("SWITCHING PERSONALITY 2")
		AI_SetPersonality(World_GetPlayerAt(4), "tow_1943_ai_battle_compound")
	end	
	Player_AddResource(World_GetPlayerAt(4), RT_Manpower, 1000)
	Player_AddResource(World_GetPlayerAt(4), RT_Fuel, 500)
	Modify_PlayerResourceRate(World_GetPlayerAt(4), RT_Fuel, 2)
	Player_CompleteUpgrade(World_GetPlayerAt(4), UPG.GERMAN.BATTLE_PHASE_2)

	Rule_AddInterval(Tank_Personality_Check_Phase2, 2)
end

function Tank_Personality_Check_Phase2()
	local base_isUnderAttack = false
	-- get everything the player owns
	for index, player in pairs(t_germans) do
		
		Player_GetAll(player, sg_e_all, eg_e_base)
		EGroup_Filter(eg_e_base, {EBP.GERMAN.GERMAN_HQ_MP, EBP.GERMAN.HINTERE_PANZERWERK_MP, EBP.GERMAN.BEREICH_FESTUNG_MP, EBP.GERMAN.DOLCH_AKTIONEN_MP, EBP.GERMAN.HINTERE_PANZERWERK_MP}, FILTER_KEEP)
		EGroup_FilterUnderConstruction(eg_e_base, FILTER_REMOVE)
		
		local _basecheck = function(gid, idx, eid)
			if Entity_GetHealthPercentage(eid) <= 0.35 then
				return true
			end
		end
		
		if EGroup_Count(eg_e_base) <= 2 and EGroup_ForEachAllOrAny(eg_e_base, ANY, _basecheck) then
			base_isUnderAttack = true
		end
		
	end

	if VPTicker_GetTeamTickers(1) <= TickerCount2 or base_isUnderAttack == true then
		Activate_Tank_Personality_Phase2()
		Rule_RemoveMe()
	end
end

function Activate_Tank_Personality_Phase2()
	if Player_GetRaceName(World_GetPlayerAt(3)) == "german" and AI_IsAIPlayer(World_GetPlayerAt(3)) then
		print("SWITCHING PERSONALITY Phase 2 - 1")
	end	
	Player_AddResource(World_GetPlayerAt(3), RT_Manpower, 1000)
	Player_AddResource(World_GetPlayerAt(3), RT_Fuel, 500)
	Player_SetPopCapOverride(World_GetPlayerAt(3), 130)

	if Player_GetRaceName(World_GetPlayerAt(4)) == "german" and AI_IsAIPlayer(World_GetPlayerAt(4)) then
		print("SWITCHING PERSONALITY  Phase 2 - 2")
		AI_SetPersonality(World_GetPlayerAt(4), "tow_1943_ai_battle_compound_pt2")
	end	
	Player_AddResource(World_GetPlayerAt(4), RT_Manpower, 1000)
	Player_AddResource(World_GetPlayerAt(4), RT_Fuel, 500)
	Player_SetPopCapOverride(World_GetPlayerAt(4), 130)
	Modify_PlayerResourceRate(World_GetPlayerAt(4), RT_Manpower, 2)
	Player_CompleteUpgrade(World_GetPlayerAt(4), UPG.GERMAN.BATTLE_PHASE_3)

end
-- Additional Enemy Spawns
function PatrollerSpawn1()
	local patroller1Data = { 
		name = "Patroller1",
		player = World_GetPlayerAt(3),
		spawn = mkr_northSpawn,
		sgroups = {sg_e1},
		units = {
			{
				sbp = SBP.GERMAN.GRENADIER_SQUAD_MP,
			},
		},
	}
	local Patroller1GoalData= {
		name = "Defend",
		target = mkr_eastVP,
		patrolParams = {
			path = "southRoad",
			wait = 5,
			attackMove = true,
		}
	}
	encID_patroller1 = Encounter:Create(patroller1Data)
	encID_patroller1:SetGoal(Patroller1GoalData)
--~ 	if g_difficulty ~= GD_EASY then
--~ 		Player_SetPopCapOverride(World_GetPlayerAt(3), 106)
--~ 	end
	
	Util_CreateEntities(World_GetPlayerAt(3), eg_germanMines, EBP.GERMAN.MINE_FIELD_MINE_MP, mkr_mine1, 1)
	
end

function PatrollerSpawn2()
	local patroller2Data = { 
		name = "Patroller2",
		player = World_GetPlayerAt(4),
		spawn = mkr_northSpawn,
		sgroups = {sg_e2},
		units = {
			{
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD_MP,
			},
		},
	}
	local Patroller2GoalData= {
		name = "Defend",
		target = mkr_eastVP,
		patrolParams = {
			path = "center",
			wait = 5,
			attackMove = true,
		}
	}
	encID_patroller2 = Encounter:Create(patroller2Data)
	encID_patroller2:SetGoal(Patroller2GoalData)
--~ 	if g_difficulty ~= GD_EASY then
--~ 		Player_SetPopCapOverride(World_GetPlayerAt(4), 106)
--~ 	end
end

function PatrollerSpawn3()
	local patroller3Data = { 
		name = "Patroller3",
		player = World_GetPlayerAt(3),
		spawn = mkr_northSpawn,
		sgroups = {sg_e1},
		units = {
			{
				sbp = SBP.GERMAN.SDKFZ_251_HALFTRACK_SQUAD_MP,
			},
		},
	}
	local Patroller3GoalData= {
		name = "Defend",
		target = mkr_eastVP,
		patrolParams = {
			path = "eastRoad",
			wait = 5,
			attackMove = true,
		}
	}
	encID_patroller3 = Encounter:Create(patroller3Data )
	encID_patroller3:SetGoal(Patroller3GoalData)
--~ 	if g_difficulty ~= GD_EASY then
--~ 		Player_SetPopCapOverride(World_GetPlayerAt(3), 115)
--~ 	end
end

function PatrollerSpawn4()
	local patroller4Data = { 
		name = "Patroller4",
		player = World_GetPlayerAt(4),
		spawn = mkr_northSpawn,
		sgroups = {sg_e1, sg_e_brummbar},
		units = {
			{
				sbp = SBP.GERMAN.BRUMMBAR_SQUAD_MP,
			},
		},
	}
	local Patroller4GoalData= {
		name = "Defend",
		target = mkr_eastVP,
		patrolParams = {
			path = "farNorthRoad",
			wait = 5,
			attackMove = true,
		}
	}
	encID_patroller4 = Encounter:Create(patroller4Data )
	encID_patroller4:SetGoal(Patroller4GoalData)
--~ 	if g_difficulty ~= GD_EASY then
--~ 		Player_SetPopCapOverride(World_GetPlayerAt(4), 115)
--~ 	end
	
	Util_CreateEntities(World_GetPlayerAt(2), eg_flareMines, EBP.SOVIET.FLARE_MINE_MP, mkr_flareMine4, 1)
	Rule_AddDelayedInterval(_unlockBrummbar, 450, 10)
end

-- Brummbar
-- If it's still alive after X minutes, take the Brummbar out of its patrol and release it to skirmish AI
function _unlockBrummbar()
	if not SGroup_IsEmpty(sg_e_brummbar) then
		if not SGroup_IsUnderAttack(sg_e_brummbar, ANY, 10) then
			if AI_IsEnabled(World_GetPlayerAt(4)) then
				AI_UnlockSquads(World_GetPlayerAt(4), sg_e_brummbar)
				Rule_RemoveMe()
			end
		end
	end
end

Scar_AddInit(OnInit)


