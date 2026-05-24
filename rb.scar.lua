import("ScarUtil.scar")
import("Fatalities/Fatalities.scar")
import("WinConditions/victorypointplusannihilate.scar")

function Util_CreateLocString(text)
	local tmpstr = LOC(text)
	tmpstr[1] = text
	return tmpstr
end

function WinCondition_GameOver(winningTeam, losingTeam)
	-- Set the winning team (this will fire win/loss events for each player).
	World_SetTeamWin(winningTeam)
	
	local winningPlayers = Team_GetPlayers(winningTeam)
	local losingPlayers = Team_GetPlayers(losingTeam)
	
	Fatality_Execute(winningPlayers, losingPlayers)
end

function WinCondition_Check()
	local results = {}

	-- Check every player on each team for ownership of the "annihilation_condition" entity.
	for i = 1, World_GetPlayerCount() do
		local player = World_GetPlayerAt(i)
		local team = Player_GetTeam(player)
	
		results[team] = results[team] or { surrender_count = 0, annihilation_condition_count = 0 }
		
		-- If any player on a team has surrendered, that team loses.
		if (Player_IsSurrendered(player)) then
			results[team].surrender_count = results[team].surrender_count + 1
		end
		
		-- If at least one player on a given team owns an "annihilation_condition" entity, then that team has not yet lost.
		if (Player_IsAlive(player)) then
			local entities = Player_GetEntities(player)
			for entityCount = 1, EGroup_CountSpawned(entities) do
				local entity = EGroup_GetSpawnedEntityAt(entities, entityCount)
				if (Entity_IsOfType(entity, "annihilation_condition")) then
					results[team].annihilation_condition_count = results[team].annihilation_condition_count + 1
					break
				end
			end
		end
	end
	
	-- Check if any team has lost.
	for team,result in pairs(results) do
		if (result.surrender_count > 0 or result.annihilation_condition_count == 0) then
			Rule_RemoveAll()
			
			local winningTeam = Team_GetEnemyTeam(team)
			local losingTeam = team

			WinCondition_GameOver(winningTeam, losingTeam)
		end
	end
	
	--[[
	local points = {}
	points[0] = 0
	points[1] = 0
	local points0
	local points1
	
	if eg_CPs then
		for i = 1, EGroup_Count(eg_CPs) do
			if not World_OwnsEntity(EGroup_GetSpawnedEntityAt(eg_CPs, i)) then
				points[Player_GetTeam(Util_GetPlayerOwner(EGroup_GetSpawnedEntityAt(eg_CPs, i)))] = points[Player_GetTeam(Util_GetPlayerOwner(EGroup_GetSpawnedEntityAt(eg_CPs, i)))] + 1
			end
		end
	end
	if (points[0] - points[1]) < 0 then points0 = 0 else points0 = points[0] - points[1] end
	if (points[1] - points[0]) < 0 then points1 = 0 else points1 = points[1] - points[0] end
	--WinWarning_SetTickers(World_GetTeamVictoryTicker(Player_GetTeam(World_GetPlayerAt(1))) - points1, World_GetTeamVictoryTicker(Player_GetTeam(World_GetPlayerAt(World_GetPlayerCount()))) - points0)
	Util_MissionTitle(Util_CreateLocString("tickers team 1: "..World_GetTeamVictoryTicker(Player_GetTeam(World_GetPlayerAt(1)))))
	WinWarning_SetTickers(1, 1)--]]
end

local function WinCondition_Init()
	Rule_AddInterval(WinCondition_Check, 3)
end

Scar_AddInit(WinCondition_Init)

function Init_rb()
	for i = 1, World_GetPlayerCount() do
		local player = World_GetPlayerAt(i)
		
		Player_SetPopCapOverride(player, 50)
		if Player_GetRaceName(player) == "soviet" then
			bp_replaced = BP_GetEntityBlueprint("hq_mp")
			bp_replace = BP_GetEntityBlueprint("117d5a31f8174111baada7a7c1ab4c1d:hq_rb")
			Player_AddAbility(player, BP_GetAbilityBlueprint("117d5a31f8174111baada7a7c1ab4c1d:partisans_commander_anti_vehicle_rb"))
			
		elseif Player_GetRaceName(player) == "german" then
			bp_replaced = BP_GetEntityBlueprint("german_hq_mp")
			bp_replace = BP_GetEntityBlueprint("117d5a31f8174111baada7a7c1ab4c1d:german_hq_rb")
			Player_AddAbility(player, BP_GetAbilityBlueprint("117d5a31f8174111baada7a7c1ab4c1d:stormtroopers_rb"))
			
		elseif Player_GetRaceName(player) == "west_german" then
			bp_replaced = BP_GetEntityBlueprint("west_german_hq_mp")
			bp_replace = BP_GetEntityBlueprint("117d5a31f8174111baada7a7c1ab4c1d:west_german_hq_rb")
			Player_AddAbility(player, BP_GetAbilityBlueprint("117d5a31f8174111baada7a7c1ab4c1d:fallschirmjaeger_rb"))
			
		elseif Player_GetRaceName(player) == "aef" then
			bp_replaced = BP_GetEntityBlueprint("rifle_command_mp")
			bp_replace = BP_GetEntityBlueprint("117d5a31f8174111baada7a7c1ab4c1d:rifle_command_rb")
			Player_SetUpgradeAvailability(player, {BP_GetUpgradeBlueprint("lieutenant_dispatched_upgrade_mp"), BP_GetUpgradeBlueprint("captain_dispatched_upgrade_mp")}, ITEM_REMOVED)
			Player_AddAbility(player, BP_GetAbilityBlueprint("117d5a31f8174111baada7a7c1ab4c1d:paratroopers_paradrop_rb"))
			
		elseif Player_GetRaceName(player) == "british" then
			bp_replaced = BP_GetEntityBlueprint("british_hq_truck_mp")
			bp_replace = BP_GetEntityBlueprint("117d5a31f8174111baada7a7c1ab4c1d:british_hq_truck_rb")
			Player_AddAbility(player, BP_GetAbilityBlueprint("117d5a31f8174111baada7a7c1ab4c1d:infiltration_commandos_rb"))
			
		end
		
		local eg_temp = EGroup_CreateIfNotFound("eg_temp")
		local sg_temp = SGroup_CreateIfNotFound("sg_temp")
		Player_GetAll(player, sg_temp, eg_temp)
		
		local function _replaceBase(gid, idx, eid)
			if Entity_GetBlueprint(eid) == bp_replaced then
				Util_CreateEntities(player, nil, bp_replace, Entity_GetPosition(eid), 1, Entity_GetPosition(eid))
				Entity_Destroy(eid)
			end
		end
		
		EGroup_ForEach(eg_temp, _replaceBase)
		
		SGroup_DestroyAllSquads(sg_temp)
	end
-----------------------------------------------------------------------
	eg_CPs = EGroup_CreateIfNotFound("eg_CPs")
	World_GetStrategyPoints(eg_CPs, true)
	EGroup_Filter(eg_CPs, BP_GetEntityBlueprint("victory_point"), FILTER_KEEP)
-----------------------------------------------------------------------
	cps = {}
	for i = 1, EGroup_Count(eg_CPs) do
		cps["p"..i.."t"..Player_GetTeam(World_GetPlayerAt(1))] = SGroup_CreateIfNotFound("sg_CPs"..i.."t0")
		cps["p"..i.."t"..Player_GetTeam(World_GetPlayerAt(World_GetPlayerCount()))] = SGroup_CreateIfNotFound("sg_CPs"..i.."t1")
	end
	targets = {}
	targets[1] = GetEntryPointByPlayer(World_GetPlayerAt(1))
	targets[0] = GetEntryPointByPlayer(World_GetPlayerAt(World_GetPlayerCount()))
	SpawnCycle()
	Rule_AddInterval(SpawnCycle, 90)
	Rule_Add(Infantry_CheckMoveUpCycle)
	Rule_Add(ResetCmdPoints)
	--VPTickerData.paused = false
end
	Scar_AddInit(Init_rb)

function ResetCmdPoints()
	for i = 1, World_GetPlayerCount() do
		Player_SetResource(World_GetPlayerAt(i), RT_Command, 0)
	end
end

function Infantry_CheckMoveUpCycle()
	Infantry_CheckMoveUp(World_GetPlayerAt(1))
	Infantry_CheckMoveUp(World_GetPlayerAt(World_GetPlayerCount()))
end

function Infantry_CheckMoveUp(player)
	for i = 1, EGroup_Count(eg_CPs) do
		if not World_OwnsEntity(EGroup_GetSpawnedEntityAt(eg_CPs, i)) and not SGroup_IsEmpty(cps["p"..i.."t"..Player_GetTeam(player)]) then
			local function _checkVpoint(gid, idx, sid)
				if Util_GetDistance(sid, EGroup_GetSpawnedEntityAt(eg_CPs, i)) < 5 and Player_GetTeam(Util_GetPlayerOwner(EGroup_GetSpawnedEntityAt(eg_CPs, i))) == Player_GetTeam(player) then
					local sg_temp = SGroup_Single(sg_temp, sid)
					Cmd_AttackMove(sg_temp, World_GetNearestInteractablePoint(targets[Player_GetTeam(player)]))
				end
			end
			SGroup_ForEach(cps["p"..i.."t"..Player_GetTeam(player)], _checkVpoint)
		end
	end
end

function SpawnCycle()
	SpawnInfantry(World_GetPlayerAt(1))
	SpawnInfantry(World_GetPlayerAt(World_GetPlayerCount()))
	
	for i = 1, World_GetPlayerCount() do
		local player = World_GetPlayerAt(i)
		local sg_temp = SGroup_CreateIfNotFound("sg_temp")
		
		if AI_IsAIPlayer(player) then
			local bp_sniper
			if Player_GetRaceName(player) == "west_german" then bp_sniper = BP_GetSquadBlueprint("117d5a31f8174111baada7a7c1ab4c1d:sniper_west_german_rb")
			elseif Player_GetRaceName(player) == "soviet" then bp_sniper = BP_GetSquadBlueprint("117d5a31f8174111baada7a7c1ab4c1d:sniper_team_rb")
			elseif Player_GetRaceName(player) == "german" then bp_sniper = BP_GetSquadBlueprint("117d5a31f8174111baada7a7c1ab4c1d:sniper_squad_rb")
			elseif Player_GetRaceName(player) == "british" then bp_sniper = BP_GetSquadBlueprint("117d5a31f8174111baada7a7c1ab4c1d:sniper_british_squad_rb")
			elseif Player_GetRaceName(player) == "aef" then bp_sniper = BP_GetSquadBlueprint("117d5a31f8174111baada7a7c1ab4c1d:sniper_aef_squad_rb")
			end
			
			local bp_mg
			if Player_GetRaceName(player) == "west_german" then bp_mg = BP_GetSquadBlueprint("117d5a31f8174111baada7a7c1ab4c1d:mg34_heavy_machine_gun_squad_rb")
			elseif Player_GetRaceName(player) == "soviet" then bp_mg = BP_GetSquadBlueprint("117d5a31f8174111baada7a7c1ab4c1d:m1910_maxim_heavy_machine_gun_squad_rb")
			elseif Player_GetRaceName(player) == "german" then bp_mg = BP_GetSquadBlueprint("117d5a31f8174111baada7a7c1ab4c1d:mg42_heavy_machine_gun_squad_rb")
			elseif Player_GetRaceName(player) == "british" then bp_mg = BP_GetSquadBlueprint("117d5a31f8174111baada7a7c1ab4c1d:british_machine_gun_squad_rb")
			elseif Player_GetRaceName(player) == "aef" then bp_mg = BP_GetSquadBlueprint("117d5a31f8174111baada7a7c1ab4c1d:m2hb_50cal_hmg_squad_rb")
			end
			
			local bp_armour
			if Player_GetRaceName(player) == "west_german" then bp_armour = BP_GetSquadBlueprint("117d5a31f8174111baada7a7c1ab4c1d:kubelwagen_squad_rb")
			elseif Player_GetRaceName(player) == "soviet" then bp_armour = BP_GetSquadBlueprint("117d5a31f8174111baada7a7c1ab4c1d:m3a1_scout_car_squad_rb")
			elseif Player_GetRaceName(player) == "german" then bp_armour = BP_GetSquadBlueprint("scoutcar_sdkfz222_mp")
			elseif Player_GetRaceName(player) == "british" then bp_armour = BP_GetSquadBlueprint("117d5a31f8174111baada7a7c1ab4c1d:universal_carrier_squad_rb")
			elseif Player_GetRaceName(player) == "aef" then bp_armour = BP_GetSquadBlueprint("117d5a31f8174111baada7a7c1ab4c1d:m20_utility_car_squad_rb")
			end
			
			local bp_special
			if Player_GetRaceName(player) == "west_german" then bp_special = BP_GetSquadBlueprint("117d5a31f8174111baada7a7c1ab4c1d:fallschirmjager_squad_rb")
			elseif Player_GetRaceName(player) == "soviet" then bp_special = BP_GetSquadBlueprint("117d5a31f8174111baada7a7c1ab4c1d:partisans_panzerschreck_rb")
			elseif Player_GetRaceName(player) == "german" then bp_special = BP_GetSquadBlueprint("117d5a31f8174111baada7a7c1ab4c1d:stormtrooper_squad_rb")
			elseif Player_GetRaceName(player) == "british" then bp_special = BP_GetSquadBlueprint("117d5a31f8174111baada7a7c1ab4c1d:commando_squad_rb")
			elseif Player_GetRaceName(player) == "aef" then bp_special = BP_GetSquadBlueprint("117d5a31f8174111baada7a7c1ab4c1d:paratrooper_squad_rb")
			end
			
			if World_GetRand(0, 1) == 1 then Util_CreateSquads(player, sg_temp, bp_sniper, GetEntryPointByPlayer(player), Player_GetStartingPosition(player)) end
			if World_GetRand(0, 1) == 1 then Util_CreateSquads(player, sg_temp, bp_mg, GetEntryPointByPlayer(player), Player_GetStartingPosition(player)) end
			if World_GetRand(0, 1) == 1 then Util_CreateSquads(player, sg_temp, bp_armour, GetEntryPointByPlayer(player), Player_GetStartingPosition(player)) end
			if World_GetRand(0, 1) == 1 then Util_CreateSquads(player, sg_temp, bp_special, GetEntryPointByPlayer(player), Player_GetStartingPosition(player)) end
		end
	end
end

function SpawnInfantry(player)
	local bps
	local upgrds
	if Player_GetRaceName(player) == "soviet" then
		bps = {BP_GetSquadBlueprint("117d5a31f8174111baada7a7c1ab4c1d:conscript_squad_rb")}
		upgrds = BP_GetUpgradeBlueprint("captain_bazooka_upgrade_mp")
	elseif Player_GetRaceName(player) == "german" then
		bps = {BP_GetSquadBlueprint("117d5a31f8174111baada7a7c1ab4c1d:grenadier_squad_rb")}
		upgrds = BP_GetUpgradeBlueprint("assault_pioneer_panzerschreck_upgrade")
	elseif Player_GetRaceName(player) == "west_german" then
		bps = {BP_GetSquadBlueprint("117d5a31f8174111baada7a7c1ab4c1d:volksgrenadier_squad_rb")}
		upgrds = BP_GetUpgradeBlueprint("assault_pioneer_panzerschreck_upgrade")
	elseif Player_GetRaceName(player) == "british" then
		bps = {BP_GetSquadBlueprint("117d5a31f8174111baada7a7c1ab4c1d:tommy_squad_rb")}
		upgrds = BP_GetUpgradeBlueprint("captain_bazooka_upgrade_mp")
	elseif Player_GetRaceName(player) == "aef" then
		bps = {BP_GetSquadBlueprint("117d5a31f8174111baada7a7c1ab4c1d:riflemen_squad_rb")}
		upgrds = BP_GetUpgradeBlueprint("captain_bazooka_upgrade_mp")
	end
	for i = 1, EGroup_Count(eg_CPs) do
		Util_CreateSquads(player, cps["p"..i.."t"..Player_GetTeam(player)], bps, GetEntryPointByPlayer(player), Entity_GetPosition(EGroup_GetSpawnedEntityAt(eg_CPs, i)), 2, nil, true, Entity_GetPosition(EGroup_GetSpawnedEntityAt(eg_CPs, i)), upgrds)
		Util_CreateSquads(player, cps["p"..i.."t"..Player_GetTeam(player)], bps, GetEntryPointByPlayer(player), Entity_GetPosition(EGroup_GetSpawnedEntityAt(eg_CPs, i)), 2, nil, true, Entity_GetPosition(EGroup_GetSpawnedEntityAt(eg_CPs, i)))
		SGroup_SetSelectable(cps["p"..i.."t"..Player_GetTeam(player)], false)
		if AI_IsAIPlayer(player) and AI_IsEnabled(player) then AI_LockSquads(player, cps["p"..i.."t"..Player_GetTeam(player)]) end
	end
end

function GetEntryPointByPlayer(player)
	local t = {}
	for i = 1, World_GetPlayerCount() do 
		local player = World_GetPlayerAt(i)
		local eg_temp = EGroup_CreateIfNotFound("eg_temp")
		local sg_temp = SGroup_CreateIfNotFound("sg_temp")
		
		Player_GetAll(player, sg_temp, eg_temp)
		EGroup_Filter(eg_temp, BP_GetEntityBlueprint("map_entry_point"), FILTER_KEEP)
		local function _makeTable(gid, idx, eid)
			t[#t+1] = eid
		end
		EGroup_ForEach(eg_temp, _makeTable)
	end
	return Util_GetPosition(World_GetClosest(Player_GetStartingPosition(player), t))
end

function GetEntryPointByTeam(team)
	local eg_all_entries = EGroup_CreateIfNotFound("eg_all_entries")
	if not EGroup_IsEmpty(eg_all_entries) then EGroup_Clear(eg_all_entries) end
	for i = 1, World_GetPlayerCount() do 
		local player = World_GetPlayerAt(i)
		local eg_temp = EGroup_CreateIfNotFound("eg_temp")
		
		if Player_GetTeam(player) == team then
			local sg_temp = SGroup_CreateIfNotFound("sg_temp")
			
			Player_GetAll(player, sg_temp, eg_temp)
			EGroup_Filter(eg_temp, BP_GetEntityBlueprint("map_entry_point"), FILTER_KEEP)
			EGroup_AddEGroup(eg_all_entries, eg_temp)
		end
	end
	return Entity_GetPosition(EGroup_GetRandomSpawnedEntity(eg_all_entries))
end
