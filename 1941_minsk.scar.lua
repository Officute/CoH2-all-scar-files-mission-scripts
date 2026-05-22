-------------------------------------------------------------------------
-------------------------------------------------------------------------

-- MISSION NAME
-- Designer: Joe Smith

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
	
	for i=1,World_GetPlayerCount() do
	
		local player = World_GetPlayerAt(i)
		ToW_SetUpTechTreeByYear(player,1941)
		ToW_SetStandardResources (player)
		if Player_GetRaceName(player) == "soviet" and not Player_IsHuman(player) then
			Setup_SetPlayerName(player, 11038758)
		elseif Player_GetRaceName(player) == "german" and not Player_IsHuman(player) then
			Setup_SetPlayerName(player, 11038759)
			table.insert (t_germans, player)
			if AI_IsAIPlayer(player) then
				AI_SetPersonality( player, "tow_testbed")
			end
			Cmd_InstantUpgrade ( player, UPG.GERMAN.MORTAR_HALFTRACK)
			Cmd_InstantUpgrade ( player, UPG.GERMAN.PANZER_TACTICIAN)
			Player_SetResource ( player, RT_Command, 2 )
		end
	end
	
	
	Rule_AddInterval(VetUp, 5)
	ToW_SetUpBattleObjectives ()
	
	
end

Scar_AddInit(OnInit)


function VetUp ()

	for k,player in pairs (t_germans) do
	
		if Player_IsAlive(player) then
		
			Player_GetAll(player)
			
			SGroup_ForEach (sg_allsquads, VetCheck)
		
		end
	
	end

end

function VetCheck (sgroup, index, squad)

	if Squad_GetVeterancyRank (squad) < 1 then
	
		Squad_IncreaseVeterancyRank (squad, 1, true)
		
	end

end