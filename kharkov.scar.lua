-------------------------------------------------------------------------
-------------------------------------------------------------------------

-- Kharkov Pursuit
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
	
	t_germans = {}
	player1 = Game_GetLocalPlayer()
	sg_blah = SGroup_CreateIfNotFound("sg_blah")
	sg_p_all = SGroup_CreateIfNotFound("sg_p_all")
	g_difficulty = Game_GetSPDifficulty()
	
	for i=1,World_GetPlayerCount() do
	
		local player = World_GetPlayerAt(i)
		ToW_SetUpTechTreeByYear(player,1942)
		ToW_SetStandardResources (player)
		if Player_GetRaceName(player) == "german" and AI_IsAIPlayer(player) then
			Setup_SetPlayerName(player, 11038759)
		elseif Player_GetRaceName(player) == "soviet" and AI_IsAIPlayer(player) then
			Setup_SetPlayerName(player, 11038758)
			table.insert (t_germans, player)
			if AI_IsAIPlayer(player) then
				AI_SetPersonality( player, "tow_1942_ai_battle_kharkov")
			end
			Player_SetResource( player, RT_Munition, 50)
		
		end
	end
	
	ToW_SetUpBattleObjectives ()
	
	Player_SetEntityProductionAvailability(player1, EBP.GERMAN.SCHWERES_KRIEGSWERK_MP, ITEM_REMOVED)
	Player_SetUpgradeAvailability(player1, UPG.GERMAN.BATTLE_PHASE_4_MP,ITEM_REMOVED)
	Player_AddAbility(t_germans[1], ABILITY.SOVIET.PARTISAN_DISPATCH_TOW)
	Player_AddAbility(t_germans[1], ABILITY.GERMAN.STUKA_SMOKE_BOMB)
	Event_Timer(CallInPartisanSquads, nil, World_GetRand(100, 140))
	Event_Timer(CallInSniperSquads, nil, World_GetRand(300, 440))
	Rule_AddInterval (RES_Airstrike, 240)
	Rule_AddOneShot(spawnAT, 420)
	Rule_AddOneShot(spawnT70, 560)
	Rule_AddOneShot(spawnT34, 720)

 	
end

Scar_AddInit(OnInit)




function CallInPartisanSquads()
	
	if Player_IsAlive(t_germans[1]) then
		
		-- list of potential spawn locations; egroups and markers
		local potential_targets = {
--~ 			mkr_partisanspawn,
			eg_partisan1,
			eg_partisan2,
			eg_partisan3,
			eg_partisan4,
			eg_partisan5,
			eg_partisan6,
			eg_partisan7,

		}
		
		-- filter out any egroups that are empty (because the building was destroyed)
		for index = #potential_targets, 1, -1 do 
			if scartype(potential_targets[index]) == ST_EGROUP and (EGroup_Count(potential_targets[index]) == 0 or World_OwnsEGroup(potential_targets[index], ALL) == false) then	
				table.remove(potential_targets, index)
			end
		end
		
		-- pick a random item 
		local rand = Table_GetRandomItem(potential_targets)
		
		if scartype(rand) == ST_MARKER then
			
			-- cast the ability
			Cmd_Ability(t_germans[1], ABILITY.SOVIET.PARTISAN_DISPATCH_TOW, Table_GetRandomItem(potential_targets), nil, true)
			
		elseif scartype(rand) == ST_EGROUP then
			
			-- spawn the guys straight into the building
			
			local blueprints = {
				SBP.SOVIET.PARTISAN_SQUAD_KAR98K_RIFLE_MP,
				SBP.SOVIET.PARTISAN_SQUAD_MAXIM_HMG_MP,
				SBP.SOVIET.PARTISAN_SQUAD_NAGANT_RIFLE_MP,
--~ 				SBP.SOVIET.SNIPER_TEAM_MP,
--~ 				sbp.tow_bridge_partisan_squad_at,
			}
			Util_CreateSquads(t_germans[1], sg_blah, Table_GetRandomItem(blueprints), rand)
			
		end
		
	end

	Event_Timer(CallInPartisanSquads, nil, World_GetRand(200, 260))
	
	

end



-------------------------SNIPER CALL IN---------------------------------

function CallInSniperSquads()
	
	if Player_IsAlive(t_germans[1]) then
		
		-- list of potential spawn locations; egroups and markers
		local potential_targets = {
--~ 			mkr_partisanspawn,
			eg_partisan1,
			eg_partisan2,
			eg_partisan3,
			eg_partisan4,
			eg_partisan5,
			eg_partisan6,
			eg_partisan7,

		}
		
		-- filter out any egroups that are empty (because the building was destroyed)
		for index = #potential_targets, 1, -1 do 
			if scartype(potential_targets[index]) == ST_EGROUP and (EGroup_Count(potential_targets[index]) == 0 or World_OwnsEGroup(potential_targets[index], ALL) == false) then	
				table.remove(potential_targets, index)
			end
		end
		
		-- pick a random item 
		local rand = Table_GetRandomItem(potential_targets)
		
		if scartype(rand) == ST_MARKER then
			
			-- cast the ability
			Cmd_Ability(t_germans[1], ABILITY.SOVIET.PARTISAN_DISPATCH_TOW, Table_GetRandomItem(potential_targets), nil, true)
			
		elseif scartype(rand) == ST_EGROUP then
			
			-- spawn the guys straight into the building
			
			local blueprints = {
--~ 				SBP.SOVIET.PARTISAN_SQUAD_KAR98K_RIFLE_MP,
--~ 				SBP.SOVIET.PARTISAN_SQUAD_MAXIM_HMG_MP,
--~ 				SBP.SOVIET.PARTISAN_SQUAD_NAGANT_RIFLE_MP,
				SBP.SOVIET.SNIPER_TEAM_MP,
--~ 				sbp.tow_bridge_partisan_squad_at,
			}
			Util_CreateSquads(t_germans[1], sg_blah, Table_GetRandomItem(blueprints), rand)
			
		end
		
	end

	Event_Timer(CallInPartisanSquads, nil, World_GetRand(300, 360))
	
	

end



--Stuka Strike-----------------------------------

function RES_Airstrike ()



local markers =
	{
	mkr_1,
	mkr_2,
	mkr_3,
	mkr_4,
	mkr_5,
	mkr_6,
	mkr_7,
	mkr_8,
	mkr_9,
	mkr_10,
}

local target = Table_GetRandomItem(markers)

Cmd_Ability(t_germans[1], ABILITY.GERMAN.STUKA_SMOKE_BOMB,target, nil, true)
Rule_ChangeInterval(RES_Airstrike, World_GetRand(240, 300))


end


--------------------------AT gun call in------------------------


function spawnAT()

	if g_difficulty == GD_NORMAL or g_difficulty == GD_HARD then
		
		Util_CreateSquads(t_germans[1], sg_p_all, SBP.SOVIET.M5_HALFTRACK_SQUAD_MP, mkr_11)
		Util_CreateSquads(t_germans[1], sg_p_all, SBP.SOVIET.M1942_ZIS_3_76MM_AT_GUN_SQUAD_MP, mkr_11)
		
	end
	
end


function spawnT70()

	if g_difficulty == GD_NORMAL or g_difficulty == GD_HARD then

		Util_CreateSquads(t_germans[1], sg_p_all, SBP.SOVIET.T_70M_MP, mkr_11)

	end

end

function spawnT34()

	if g_difficulty == GD_NORMAL or g_difficulty == GD_HARD then

		Util_CreateSquads(t_germans[1], sg_p_all, SBP.SOVIET.T_34_76_SQUAD_MP, mkr_11)

	end
	
end


