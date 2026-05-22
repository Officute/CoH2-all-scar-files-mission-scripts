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
	
	t_soviets = {}

	for i=1,World_GetPlayerCount() do
	
		local player = World_GetPlayerAt(i)
		ToW_SetUpTechTreeByYear(player,1941)
		ToW_SetStandardResources (player)
		
		if Player_GetRaceName(player) == "soviet" and not Player_IsHuman(player) then
			Setup_SetPlayerName(player, 11038758)
			table.insert (t_soviets, player)
			if AI_IsAIPlayer(player) then
				AI_SetPersonality( player, "tow_testbed")
				AI_EnableEconomyOverride ( player, "test override", true)
				AI_EnableEconomyOverride ( player, "No Snipers", true)
			end
--~ 			Player_SetSquadProductionAvailability(player, SBP.SOVIET.CONSCRIPT_SQUAD, ITEM_REMOVED)
			Cmd_InstantUpgrade(player, UPG.SOVIET.GUARD_TROOPS)
			Player_SetResource(player, RT_Command, 2)
			Event_Timer (RemoveOverride, {player = player, override = "No Snipers"}, 300)
		elseif Player_GetRaceName(player) == "german" and not Player_IsHuman(player) then
			Setup_SetPlayerName(player, 11038759)
		end
		
	end
	
	ToW_SetUpBattleObjectives ()
	
	
end

Scar_AddInit(OnInit)

function RemoveOverride (data)
	if AI_IsAIPlayer(data.player) then
		AI_EnableEconomyOverride ( data.player, data.override, false)
	end
end
