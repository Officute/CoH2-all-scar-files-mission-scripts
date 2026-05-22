-------------------------------------------------------------------------
-------------------------------------------------------------------------

-- Mud Road Soviet
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


	-- human players
	player1 = World_GetPlayerAt(1)
	player2 = World_GetPlayerAt(2)
	player3 = World_GetPlayerAt(3)
	
	-- ai Defenders
	player5 = World_GetPlayerAt(5)
	player6 = World_GetPlayerAt(6)
	player7 = World_GetPlayerAt(7)
	
end


function OnGameRestore()
	
	Game_DefaultGameRestore()
	
	-- Attackers
	player1 = World_GetPlayerAt(1)
	player2 = World_GetPlayerAt(2)
	player3 = World_GetPlayerAt(3)
	
	-- Defenders
	player5 = World_GetPlayerAt(4)
	player6 = World_GetPlayerAt(5)
	player7 = World_GetPlayerAt(6)
	
end

-------------------------------------------------------------------------
-- [[ ONINIT ]]
-------------------------------------------------------------------------

function OnInit()
	
	t_germans = {}
	g_difficulty = Game_GetSPDifficulty()
	sg_p_all1 = SGroup_CreateIfNotFound("sg_p_all1")
	sg_p_all2 = SGroup_CreateIfNotFound("sg_p_all2")
	sg_p_all3= SGroup_CreateIfNotFound("sg_p_all3")
	sg_p_all= SGroup_CreateIfNotFound("sg_p_all")
	
	
	for i=1,World_GetPlayerCount() do
	
		local player = World_GetPlayerAt(i)
		ToW_SetUpTechTreeByYear(player,1943)
		ToW_SetStandardResources (player)
		
		if Player_GetRaceName(player) == "soviet" then
			if Player_IsHuman(player) == false then
				Setup_SetPlayerName(player, 11038758)	-- "soviet"
			end
			
			Cmd_Upgrade(player, BP_GetUpgradeBlueprint("order227"), 1, true)
			Cmd_Upgrade(player, BP_GetUpgradeBlueprint("1943_mud_road"), 1, true)
			
		elseif Player_GetRaceName(player) == "german" then
			Setup_SetPlayerName(player, 11038759)
			table.insert (t_germans, player)
			
			Modify_PlayerResourceRate(player, RT_Fuel, 1.5, MUT_Multiplication)
			Modify_PlayerResourceRate(player, RT_Munition, 1.5, MUT_Multiplication)
			
			Player_SetResource(player, RT_Manpower, 600)
			
			
			if AI_IsAIPlayer(player) then -- This will return false if the AI isn't running on this computer.
				AI_SetPersonality( player, "tow_1942_ai_battle_mudroad_soviet")
			end
		end
	end
	

	Util_CreateSquads(player1, sg_p_all1, SBP.SOVIET.COMMISSAR_SQUAD_BATTLE, mkr_1)
	Util_CreateSquads(player2, sg_p_all2, SBP.SOVIET.COMMISSAR_SQUAD_BATTLE, mkr_3)
	Util_CreateSquads(player3, sg_p_all3, SBP.SOVIET.COMMISSAR_SQUAD_BATTLE, mkr_5)

	
	if Game_GetLocalPlayer() == player1 then
	
		hint_officer1 = HintPoint_Add(sg_p_all1, true, 11051610) -- "Use officer to call in air support"
		Event_Timer(EventHandler_RemoveHint, {hint = hint_officer1}, 10)
	
	end
	
	if Game_GetLocalPlayer() == player2 then
	
		hint_officer1 = HintPoint_Add(sg_p_all2, true, 11051610) -- "Use officer to call in air support"
		Event_Timer(EventHandler_RemoveHint, {hint = hint_officer1}, 10)
	
	end
	
	if Game_GetLocalPlayer() == player3 then
	
		hint_officer1 = HintPoint_Add(sg_p_all3, true, 11051610) -- "Use officer to call in air support"
		Event_Timer(EventHandler_RemoveHint, {hint = hint_officer1}, 10)
	
	end
	
	ToW_SetUpBattleObjectives()
	
	Rule_AddInterval(SpawnPantherGroup, 1)
	Rule_AddInterval(SpawnPantherGroup1, 1)
	Rule_AddInterval(SpawnPantherGroup2, 1)
	Rule_AddOneShot(manpowerpush, 600)
	
	Rule_AddOneShot(Start_Transition_Phase, World_GetRand(240, 300)) -- Start Storm Transitions
	
end

	

Scar_AddInit(OnInit)


---------------------------------
-- Atmosphere Transitions
---------------------------------

function Start_Transition_Phase()
	if VPTicker_GetTeamTickers(0) ~= 0 and VPTicker_GetTeamTickers(1) ~= 0 then
		print("Start Transition Phase")
		Game_LoadAtmosphere("data:art/scenarios/presets/atmosphere/DLC/tow_MudRoad311_transition.aps", 30)
		Rule_AddOneShot(Start_Storm_Phase, 30)
	end
end
function Start_Storm_Phase()
	if VPTicker_GetTeamTickers(0) ~= 0 and VPTicker_GetTeamTickers(1) ~= 0 then
		print("Start Storm Phase")
		Game_LoadAtmosphere("data:art/scenarios/presets/atmosphere/DLC/tow_MudRoad311_lightning.aps", 0)
		Rule_AddOneShot(Start_Transition_Phase_02, World_GetRand(180, 240))
	end
end
function Start_Transition_Phase_02()
	if VPTicker_GetTeamTickers(0) ~= 0 and VPTicker_GetTeamTickers(1) ~= 0 then
		print("Start Transition Phase")
		Game_LoadAtmosphere("data:art/scenarios/presets/atmosphere/DLC/tow_MudRoad311_transition.aps", 0)
		Rule_AddOneShot(Start_Default_Phase, 30)
	end
end
function Start_Default_Phase()
	if VPTicker_GetTeamTickers(0) ~= 0 and VPTicker_GetTeamTickers(1) ~= 0 then
		print("Start Default Phase")
		Game_LoadAtmosphere("data:art/scenarios/presets/atmosphere/DLC/tow_MudRoad311_default.aps", 15)
		Rule_AddOneShot(Start_Transition_Phase, World_GetRand(210, 260))
	end
end

---------------------------------
-- Mission Functions
---------------------------------


function manpowerpush()

	Player_AddResource(player5, RT_Manpower, 1000)
	Player_AddResource(player6, RT_Manpower, 1000)
	Player_AddResource(player7, RT_Manpower, 1000)

end

function SpawnPantherGroup1()

	if VPTicker_GetTeamTickers(1) <= 350 then

		if g_difficulty == GD_NORMAL or g_difficulty == GD_HARD then

			Util_CreateSquads(t_germans[1], sg_p_all, SBP.GERMAN.ASSAULT_GRENADIER_SQUAD_MP, mkr_tankspawn)
			Util_CreateSquads(t_germans[1], sg_p_all, SBP.GERMAN.ASSAULT_GRENADIER_SQUAD_MP, mkr_tankspawn)
			Util_CreateSquads(t_germans[1], sg_p_all, SBP.GERMAN.ASSAULT_GRENADIER_SQUAD_MP, mkr_tankspawn)
			Util_CreateSquads(t_germans[1], sg_p_all, SBP.GERMAN.OSTWIND_SQUAD_MP, mkr_tankspawn)
			Util_CreateSquads(t_germans[1], sg_p_all, SBP.GERMAN.STUG_III_SQUAD, mkr_tankspawn)
			
		end
	
		Rule_RemoveMe()	
	
	end
	
end



function SpawnPantherGroup()

	if VPTicker_GetTeamTickers(1) <= 200 then

		if g_difficulty == GD_NORMAL or g_difficulty == GD_HARD then

			Util_CreateSquads(t_germans[1], sg_p_all, SBP.WEST_GERMAN.PANTHER_COMMANDER_SQUAD_MP, mkr_tankspawn)
			Util_CreateSquads(t_germans[1], sg_p_all, SBP.GERMAN.PANTHER_SQUAD_MP, mkr_tankspawn)
			Util_CreateSquads(t_germans[1], sg_p_all, SBP.GERMAN.PANTHER_SQUAD_MP, mkr_tankspawn)
			Util_CreateSquads(t_germans[1], sg_p_all, SBP.GERMAN.ELEFANT_TANK_DESTROYER_SQUAD_MP, mkr_tankspawn)
			
		end
	
		Rule_RemoveMe()	
	
	end
	
end


function SpawnPantherGroup2()

	if VPTicker_GetTeamTickers(1) <= 100 then

		if g_difficulty == GD_NORMAL or g_difficulty == GD_HARD then

			Util_CreateSquads(t_germans[1], sg_p_all, SBP.GERMAN.PANTHER_SQUAD_MP, mkr_tankspawn)
			Util_CreateSquads(t_germans[1], sg_p_all, SBP.GERMAN.TIGER_ACE_SQUAD_MP, mkr_tankspawn)
			Util_CreateSquads(t_germans[1], sg_p_all, SBP.GERMAN.PANTHER_SQUAD_MP, mkr_tankspawn)
			
		end
	
		Rule_RemoveMe()	
	
	end
	
end



