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
	g_phaseTwoCutOff = 600
	for i=1,World_GetPlayerCount() do
		
		local player = World_GetPlayerAt(i)
		ToW_SetUpTechTreeByYear(player,1941)
		ToW_SetStandardResources (player)
		if Player_GetRaceName(player) == "soviet" and not Player_IsHuman(player) then
			Setup_SetPlayerName(player, 11038758)
			table.insert (t_soviets, player)
			Player_CompleteUpgrade(player, UPG.SOVIET.GUARD_TROOPS)
			if AI_IsAIPlayer(player) then
				AI_SetPersonality( player, "tow_testbed")
				AI_EnableEconomyOverride ( player, "Infantry Phase", true)
			end
		elseif Player_GetRaceName(player) == "german" and not Player_IsHuman(player) then
			Setup_SetPlayerName(player, 11038759)
		end
		
	end
	
	Rule_AddInterval (PhaseTwoCheck, 2)
	
	ToW_SetUpBattleObjectives ()
	
end

function Test()
	print("TESSSSST!")

end

Scar_AddInit(OnInit)

function PhaseTwoCheck()

	if World_GetGameTime() < g_phaseTwoCutOff then
		
		if Player_GetNumVictoryPoints( World_GetPlayerAt(1) ) >=3 then
			Rule_RemoveMe()
			PhaseTwo()
		end
		
	else
		
		Rule_RemoveMe()
		PhaseTwo()
		
	end


end



function PhaseTwo()

	for k,player in pairs (t_soviets) do
		if Player_IsAlive(player) then
			if AI_IsAIPlayer(player) then
				AI_EnableEconomyOverride ( player, "Infantry Phase", false)
				AI_EnableEconomyOverride ( player, "Armor Phase", true)
			end
			Player_AddResource(player, RT_Manpower, 600)
			Player_AddResource(player, RT_Fuel, 150)
		end
	end

end



 -- Phase 1
 
 -- focus on Radio Tower(s)
 -- Build infantry only
 
 -- Phase 2 
 
 -- switch to vehicles & AT guns
 -- priority on KV1



