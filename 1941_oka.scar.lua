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
import("Systems/BlizzardMulitplayer.scar")

g_isWinterMap = true

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
	
	MP_BlizzardInit("data:art/scenarios/presets/atmosphere/_mp_4p_coh2_okariver_blizzard.aps" ,"data:art/scenarios/presets/atmosphere/_mp_4p_coh2_okariver.aps")

	t_soviets = {}

	for i=1,World_GetPlayerCount() do
	
		local player = World_GetPlayerAt(i)
		ToW_SetUpTechTreeByYear(player,1941)
		ToW_SetStandardResources (player)
		if Player_GetRaceName(player) == "soviet" and not Player_IsHuman(player) then
			Setup_SetPlayerName(player, 11038758)
			table.insert (t_soviets, player)
			Player_CompleteUpgrade(player, UPG.SOVIET.GUARD_TROOPS)
			if AI_IsAIPlayer(player) then
				AI_SetPersonality( player, "tow_soviet_winter_1941")
--~ 			AI_EnableEconomyOverride ( player, "Cold Weather Slant", true)
			end
		elseif Player_GetRaceName(player) == "german" and not Player_IsHuman(player) then
			Setup_SetPlayerName(player, 11038759)
		end
		
	end
	
	
	ToW_SetUpBattleObjectives ()
	
end

Scar_AddInit(OnInit)

