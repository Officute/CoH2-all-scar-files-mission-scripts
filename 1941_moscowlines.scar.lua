-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- MISSION NAME
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
	MP_BlizzardInit("data:art/scenarios/presets/atmosphere/_mp_frozen_scrum_b.aps" ,"data:art/scenarios/presets/atmosphere/_mp_4p_rshev_frontline.aps")
	t_germans = {}
	t_raids = {}
	for i=1,World_GetPlayerCount() do
		local player = World_GetPlayerAt(i)
		ToW_SetUpTechTreeByYear(player,1941)
		ToW_SetStandardResources (player)
		if Player_GetRaceName(player) == "soviet" and not Player_IsHuman(player) then
			Setup_SetPlayerName(player, 11038758)
		elseif Player_GetRaceName(player) == "german" and not Player_IsHuman(player) then
			Setup_SetPlayerName(player, 11038759)
			table.insert (t_germans, player)
		end
	end
	
	InitPoints()
	
	Event_Timer(GoForPoint, {player=t_germans[1], target=eg_fuelPoints}, 1)
	
	if #t_germans > 1 then
		Event_Timer(GoForPoint, {player=t_germans[2], target=eg_munitionsPoints}, 1)
	end
	ToW_SetUpBattleObjectives ()
	
end

Scar_AddInit(OnInit)

function InitPoints()
	eg_fuelPoints = EGroup_CreateIfNotFound("eg_fuelPoints")
	eg_munitionsPoints = EGroup_CreateIfNotFound("eg_munitionsPoints")
	World_GetStrategyPoints(eg_fuelPoints, false)
	EGroup_Filter(eg_fuelPoints, BP_GetEntityBlueprint("territory_fuel_point_mp"), FILTER_KEEP)
	World_GetStrategyPoints(eg_munitionsPoints, false)
	EGroup_Filter(eg_munitionsPoints, BP_GetEntityBlueprint("territory_munitions_point_mp"), FILTER_KEEP)
end

function GoForPoint (data)

	table.insert(t_raids, {})
	local index = #t_raids

	Player_GetAll(data.player)

	local encData = {
		player = data.player,
		name = "Raid" .. tostring(index),
		spawn = eg_allentities,
		sgroups = {},
		units = {
			{
				sbp = SBP.GERMAN.PIONEER_SQUAD,
			},
		},
		onDeath = nil,
	}
	local goalData = {
		name = "Attack",
		target = EGroup_GetSpawnedEntityAt(data.target, 1),
		range = 10,
		onSuccess = ReturnToAI,
	}
	
	t_raids[index] = Encounter:Create(encData)
	t_raids[index]:SetGoal(goalData)
	
end

function ReturnToAI(enc)

	if AI_IsEnabled(enc.data.player) then
		AI_UnlockSquads(enc.data.player, enc.sgroup)
	end
	
end
