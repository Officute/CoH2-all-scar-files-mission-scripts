-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- Battle: Leningrad Approach -- German Player
-- Designer: Philippe Boulle
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
	
	MP_BlizzardInit("data:art/scenarios/presets/atmosphere/_mp_2p_kholodnaya_ferma_blizzard.aps" ,"data:art/scenarios/presets/atmosphere/_mp_2p_Kholodnaya_Ferma.aps", nil, nil, true, "data:art/scenarios/presets/atmosphere/_mp_2p_kholodnaya_ferma_transition_out.aps")
	
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
			end
			Cmd_InstantUpgrade(player, UPG.SOVIET.SHOCK_TROOPS)
		elseif Player_GetRaceName(player) == "german" and not Player_IsHuman(player) then
			Setup_SetPlayerName(player, 11038759)
		end
		
	end
	
	Rule_AddInterval(AssaultUpgrade, 5)
	ToW_SetUpBattleObjectives ()
end

Scar_AddInit(OnInit)

function AssaultUpgrade()

	for k,player in pairs (t_soviets) do
	
		if Player_IsAlive (player) and Player_GetResource(player, RT_Command) >= 2 then
			Player_GetAll (player)
			SGroup_Filter (sg_allsquads, SBP.SOVIET.CONSCRIPT_SQUAD_MP, FILTER_KEEP)
			SGroup_ForEach(sg_allsquads, UpgradeConscripts)
		end
	
	end


end

function UpgradeConscripts(sgroup, index, squad)

	if not Squad_HasUpgrade(squad, UPG.SOVIET.CONSCRIPT_ASSAULT_PACKAGE_INGAME) then
		local sg_temp = SGroup_CreateIfNotFound("sg_temp")
		SGroup_Clear(sg_temp)
		SGroup_Add(sg_temp, squad)
		Cmd_InstantUpgrade(sg_temp, UPG.SOVIET.CONSCRIPT_ASSAULT_PACKAGE_INGAME)
	end
end
