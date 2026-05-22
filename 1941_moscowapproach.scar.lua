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

	MP_BlizzardInit("data:art/scenarios/presets/atmosphere/_mp_4p_moscow_outskirts_blizzard.aps" ,"data:art/scenarios/presets/atmosphere/_mp_4p_moscow_outskirts.aps")

	
	t_germans = {}
	
	for i=1,World_GetPlayerCount() do
	
		local player = World_GetPlayerAt(i)
		ToW_SetUpTechTreeByYear(player,1941)
		ToW_SetStandardResources (player)
		if Player_GetRaceName(player) == "soviet" and not Player_IsHuman(player) then
			Setup_SetPlayerName(player, 11038758)
		elseif Player_GetRaceName(player) == "german" and not Player_IsHuman(player) then
			Setup_SetPlayerName(player, 11038759)
			Cmd_InstantUpgrade(player, 	UPG.GERMAN.RECON_PLANE)
			table.insert (t_germans, player)
		end
		
		
	end
	
	InitializePoints()
	
	eg_targets = EGroup_CreateIfNotFound("eg_targets")
	
	
	Event_Timer(ReconOverflight, nil, World_GetRand(90,240))
	ToW_SetUpBattleObjectives ()
	
	
end

Scar_AddInit(OnInit)


function InitializePoints()

	eg_vps = EGroup_CreateIfNotFound("eg_vps")
	World_GetStrategyPoints(eg_vps, true)
	EGroup_Filter(eg_vps, "victory_point", FILTER_KEEP)
	
end


function ReconOverflight(data)


	if #t_germans < 1 then
		return
	end
	
	local player = t_germans[World_GetRand(1,#t_germans)]

	if Player_IsAlive(player) then
		if (Player_GetResource(player, RT_Command) >= 2) or (Misc_IsCommandLineOptionSet("debug")) then
	
			local target = nil
			EGroup_Clear(eg_targets)
		
			EGroup_ForEach(eg_vps, GetTargets)
	
	
			if EGroup_Count(eg_targets) > 0 then
		
				target = EGroup_GetSpawnedEntityAt(eg_targets, World_GetRand(1, EGroup_Count(eg_targets)))
			
			else
		
				target = Player_GetSquadConcentration(World_GetPlayerAt(1))
			
			end
		
			Cmd_Ability(player, ABILITY.GERMAN.STUKA_AIR_RECON, target, nil, true)
			_ToWDebugDisplay ("Recon Overflight")
			
		end
		
	end

	
	Event_Timer(ReconOverflight, {playerid = player}, World_GetRand(90,240))

end


function GetTargets (egroup, index, entity)

	if World_OwnsEntity(entity) then
	
		EGroup_Add(eg_targets, entity)
		
	elseif Player_OwnsEntity (World_GetPlayerAt(1), entity) then
	
		EGroup_Add(eg_targets, entity)
		
	end

end
