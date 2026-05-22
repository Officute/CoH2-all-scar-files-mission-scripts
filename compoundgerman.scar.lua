-------------------------------------------------------------------------
-------------------------------------------------------------------------

-- MISSION NAME: Compound - German
-- Designer: Sacha Narine
-- Description: Use a fortified compound area to defend the east VP, but watch out for the enemy's captured Pak43 and patrollers

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
	-- Atmosphere Setup
	Game_LoadAtmosphere("data:art/scenarios/presets/atmosphere/DLC/tow_heavy_rain_battle.aps", 0)
	Camera_SetDefault(nil, nil, 145)
	Camera_ResetToDefault()
	t_germans = {}
	
	sg_p_all = SGroup_CreateIfNotFound("sg_p_all")
	sg_p1 = SGroup_CreateIfNotFound("sg_p1")
	sg_p2 = SGroup_CreateIfNotFound("sg_p2")
	sg_p1_sniper = SGroup_CreateIfNotFound("sg_p1_sniper")
	sg_p2_sniper = SGroup_CreateIfNotFound("sg_p2_sniper")
	sg_e_all = SGroup_CreateIfNotFound("sg_e_all")
	sg_e1 = SGroup_CreateIfNotFound("sg_e1")
	sg_e2 = SGroup_CreateIfNotFound("sg_e2")
	sg_e_is2 = SGroup_CreateIfNotFound("sg_e_is2")
	
	-- variables
	TickerCount1 = Util_DifVar({World_GetRand(300,350),World_GetRand(375,425), World_GetRand(400,450)} )
	TickerCount2 = Util_DifVar({World_GetRand(125,150),World_GetRand(200,225), World_GetRand(250,275)} )
	
	g_difficulty = Game_GetSPDifficulty()
	
	for i=1,World_GetPlayerCount() do
	
		local player = World_GetPlayerAt(i)
		ToW_SetStandardResources (player)
		Player_SetResource (player, RT_Command, 1 )
		Player_SetResource(player, RT_Munition, 100)
		Player_SetResource(player, RT_Manpower, 500)
		ToW_SetUpTechTreeByYear(player,1943)
		
		if Player_GetRaceName(player) == "soviet" then
		
			if Player_IsHuman(player) == false then
				Setup_SetPlayerName(player, 11038758)
			end
			if AI_IsAIPlayer(player) then
				
			end
			
		elseif Player_GetRaceName(player) == "german" then
			
			table.insert (t_germans, player)
			
			if Player_IsHuman(player) == false  then
				Setup_SetPlayerName(player, 11038759)
			end
			if AI_IsAIPlayer(player)  then
				
			end
			
		end
	end

	Mission_Difficulty()
	
	-- Soviet Spawns
	-- Grant the Soviet team a captured Pak 43 AT gun
	pakOwner_02 = World_GetPlayerAt(1)
	pakOwner_02 = World_GetPlayerAt(2)

	eg_pak43 = EGroup_CreateIfNotFound("eg_pak43")
	Util_CreateEntities(nil, eg_pak43, EBP.GERMAN.PAK43_88MM_AT_GUN_MP, mkr_pak43, 1) -- World_Pos(-75, 10, -22)
	Util_CreateSquads(pakOwner_02, sg_p1, SBP.SOVIET.CONSCRIPT_SQUAD_MP, mkr_pak43, nil, nil, 3) -- World_Pos(-74, 10, -21)
	Cmd_CaptureTeamWeapon(sg_p1, eg_pak43)
	
	eg_pak43_02 = EGroup_CreateIfNotFound("eg_pak43_02")
	Util_CreateEntities(nil, eg_pak43_02, EBP.GERMAN.PAK43_88MM_AT_GUN_MP, mkr_pak43_02, 1) -- World_Pos(-75, 10, -22)
	Util_CreateSquads(pakOwner_02, sg_p2, SBP.SOVIET.CONSCRIPT_SQUAD_MP, mkr_pak43_02, nil, nil, 3) -- World_Pos(-74, 10, -21)
	Cmd_CaptureTeamWeapon(sg_p2, eg_pak43_02)
	
	-- Player Starting Units
		-- Starting Mortar Squads
	Util_CreateSquads(World_GetPlayerAt(3), sg_p1, SBP.GERMAN.PANZERWERFER_SQUAD_MP, mkr_p1_panzer, nil, 1)
	Util_CreateSquads(World_GetPlayerAt(4), sg_p2, SBP.GERMAN.PANZERWERFER_SQUAD_MP, mkr_p2_panzer, nil, 1)
	
	Util_CreateSquads(World_GetPlayerAt(3), sg_p1_sniper, SBP.GERMAN.SNIPER_SQUAD_MP, mkr_p1_sniper_01, nil, 2)
	Util_CreateSquads(World_GetPlayerAt(4), sg_p2_sniper, SBP.GERMAN.SNIPER_SQUAD_MP, mkr_p2_sniper_01, nil, 2)
	
	SGroup_IncreaseVeterancyRank(sg_p1_sniper, Util_DifVar({2, 1, 0}) )
	SGroup_IncreaseVeterancyRank(sg_p2_sniper, Util_DifVar({2, 1, 0}) )

	ToW_SetUpAnnihilationObjectives() -- Setup game Objective
	-- Flare Mines
	-- Grant the Soviet player some pre-placed flare (tripwire) mines
	eg_flareMines = EGroup_CreateIfNotFound("eg_flareMines")
	Util_CreateEntities(World_GetPlayerAt(1), eg_flareMines, EBP.SOVIET.FLARE_MINE_MP, mkr_flareMine1, 1)
	Util_CreateEntities(World_GetPlayerAt(2), eg_flareMines, EBP.SOVIET.FLARE_MINE_MP, mkr_flareMine2, 1)
	Util_CreateEntities(World_GetPlayerAt(1), eg_flareMines, EBP.SOVIET.FLARE_MINE_MP, mkr_flareMine3, 1)
	Util_CreateEntities(World_GetPlayerAt(1), eg_flareMines, EBP.SOVIET.FLARE_MINE_MP, mkr_flareMine5, 1)
	Util_CreateEntities(World_GetPlayerAt(2), eg_flareMines, EBP.SOVIET.FLARE_MINE_MP, mkr_flareMine6, 1)

	
	-- Mines


	-- Soviet patrollers
	-- These squads spawn into scripted patrol routes
	Rule_AddOneShot(PatrollerSpawn1, 1)
	Rule_AddOneShot(PatrollerSpawn2, 1)
	
	-- Intro Speech 
	Util_StartIntel(EVENTS.Intro)
	
end



function Mission_Difficulty()	
	g_difficulty = Game_GetSPDifficulty() 
	
	t_difficulty = {
 	-- Easy, Medium, Hard
		
	}
	
end


function ToW_SetUpAnnihilationObjectives ()

	OBJ_Main = {
		SetupUI = function() 
		end,
		OnStart = function()
		end,
		OnComplete = function()
			VPVictoryMessage()
		end,
		OnFail = function()
		end,
		IsComplete = function()
			return false
		end,
		Intel_Start = nil,				-- Event will play when obj starts but before any UI appears
		Intel_Complete = nil,			-- Event will play when obj completes but before UI is cleared
		Intel_Fail = nil,				-- Event will play when obj fails but before UI is cleared
		Title = 11055956,				-- LOCDB [11046899] 'Destroy the Enemy Base to win the match.'
		Description = 0,			-- Objective Description
		Type = OT_Primary,				-- Objective Type (OT_Primary, OT_Secondary)
	}
	Objective_Register(OBJ_Main)
	Event_Timer (_StartAnnihilationObjective, {anh_obj=OBJ_Main}, 1)
end

function _StartAnnihilationObjective (data)
	Objective_Start(data.anh_obj)
end


-- Additional Enemy Spawns


function PatrollerSpawn1()
	local patroller1Data = { 
		name = "Patroller1",
		player = World_GetPlayerAt(1),
		spawn = mkr_southSpawn,
		sgroups = {sg_e1, sg_e_is2},
		veterancyRank = Util_DifVar({0, 0, 1}),
		units = {
			{
				sbp = Util_DifVar( { SBP.SOVIET.T_34_76_SQUAD_MP, SBP.SOVIET.IS_2_MP, SBP.SOVIET.IS_2_MP} ),
			},
		},
	}
	local Patroller1GoalData= {
		name = "Defend",
		target = mkr_southeast,
		patrolParams = {
			path = "westVP",
			wait = 5,
			attackMove = true,
		}
	}
	encID_patroller1 = Encounter:Create(patroller1Data )
	encID_patroller1:SetGoal(Patroller1GoalData)
end

function PatrollerSpawn2()
	local patroller2Data = { 
		name = "Patroller2",
		player = World_GetPlayerAt(2),
		spawn = mkr_southSpawn,
		sgroups = {sg_e2, sg_e_is2},
		veterancyRank = Util_DifVar({0, 0, 1}),
		units = {
			{
				sbp = Util_DifVar( { SBP.SOVIET.T_34_76_SQUAD_MP, SBP.SOVIET.IS_2_MP, SBP.SOVIET.IS_2_MP} ),
			},
		},
	}
	local Patroller2GoalData= {
		name = "Defend",
		target = mkr_southeast,
		patrolParams = {
			path = "farSouthRoad",
			wait = 5,
			attackMove = true,
		}
	}
	encID_patroller2 = Encounter:Create(patroller2Data )
	encID_patroller2:SetGoal(Patroller2GoalData)
	
--~ 	Rule_AddDelayedInterval(_unlockIS2, 450, 10)
end

-- IS-2
-- If it's still alive after X minutes, take the IS-2 out of its patrol and release it to skirmish AI
function _unlockIS2()
	if not SGroup_IsEmpty(sg_e_is2) then
		if not SGroup_IsUnderAttack(sg_e_is2, ANY, 10) then
			if AI_IsEnabled(World_GetPlayerAt(3)) then
				AI_UnlockSquads(World_GetPlayerAt(3), sg_e_is2)
				Rule_RemoveMe()
			end
		end
	end
end


Scar_AddInit(OnInit)


