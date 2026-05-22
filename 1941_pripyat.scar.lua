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
			Event_Timer(TacticalMove, {playerid = player}, World_GetRand(75,100))
		end
		
		
	end
	
	Rule_AddInterval(JaegerUpgrade, 5)
	
	ToW_SetUpBattleObjectives ()
	
end

Scar_AddInit(OnInit)

function JaegerUpgrade()

	for k,player in pairs (t_germans) do
	
		if Player_IsAlive (player) and Player_GetResource(player, RT_Command) >= 2 then
			Player_GetAll (player)
			SGroup_Filter (sg_allsquads, {SBP.GERMAN.GRENADIER_SQUAD_MP, SBP.GERMAN.PANZER_GRENADIER_SQUAD_MP}, FILTER_KEEP)
			SGroup_ForEach(sg_allsquads, UpgradeLightInfantry)
		end
	
	end


end

function UpgradeLightInfantry(sgroup, index, squad)

	if Squad_GetBlueprint(squad) == SBP.GERMAN.GRENADIER_SQUAD_MP then
		if not Squad_HasUpgrade(squad, UPG.GERMAN.LIGHT_INFANTRY_PACKAGE) then
			local sg_temp = SGroup_CreateIfNotFound("sg_temp")
			SGroup_Clear(sg_temp)
			SGroup_Add(sg_temp, squad)
			Cmd_InstantUpgrade(sg_temp, UPG.GERMAN.LIGHT_INFANTRY_PACKAGE)
		end
	elseif Squad_GetBlueprint(squad) == SBP.GERMAN.PANZER_GRENADIER_SQUAD_MP then
		if not Squad_HasUpgrade(squad, UPG.GERMAN.LIGHT_INFANTRY_PANZERGREN_PACKAGE) then
			local sg_temp = SGroup_CreateIfNotFound("sg_temp")
			SGroup_Clear(sg_temp)
			SGroup_Add(sg_temp, squad)
			Cmd_InstantUpgrade(sg_temp, UPG.GERMAN.LIGHT_INFANTRY_PANZERGREN_PACKAGE)
		end
	end
end


function TacticalMove(data)

	local player = data.playerid

	if Player_IsAlive (player) and Player_GetResource(player, RT_Command) >= 3 then
		Cmd_Ability (player, ABILITY.GERMAN.FAST_MARCH, nil, nil, true)
	end

	Event_Timer(TacticalMove, data, World_GetRand(75,100))

end
