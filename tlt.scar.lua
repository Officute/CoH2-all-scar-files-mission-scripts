import("ScarUtil.scar")
import("Fatalities/Fatalities.scar")

function Util_CreateLocString(text)
	local tmpstr = LOC(text)
	tmpstr[1] = text
	return tmpstr
end

function WinCondition_GameOver(winningTeam, losingTeam)
	-- Set the winning team (this will fire win/loss events for each player).
	World_SetTeamWin(winningTeam)
	
	--[[	--causes trouble, probably because it gets called too late
	local winningPlayers = Team_GetPlayers(winningTeam)
	local losingPlayers = Team_GetPlayers(losingTeam)
	
	Fatality_Execute(winningPlayers, losingPlayers) --]]
end

function INIT_ObjTigerObjective()

	print("Initializing Main Objective...")
		
	obj_Tiger = {
	
		SetupUI = function() 
			--Objective_StartTimer(obj_Tiger, COUNT_DOWN, g_GameTime)
		end,
		
		OnStart = function()
		end,
		
		OnComplete = function()
		end,
		
		OnFail = function()
		end,
		
		Title = Util_CreateLocString("Time until German reinforcements:"),
		Description = 0,
		Type = OT_Primary,
	}
		
	Objective_Register(obj_Tiger)
	
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
				if (Entity_IsOfType(entity, "annihilation_condition")) or team == Player_GetTeam(g_TigerPlayer) then
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
end

function WinCondition_Check_no_axis()
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
end

local function WinCondition_Init()
	
	if Setup_GetWinConditionOption() == 1 then
		g_GameTime = 1200
	elseif Setup_GetWinConditionOption() == 2 then
		g_GameTime = 1800
	elseif Setup_GetWinConditionOption() == 3 then
		g_GameTime = 2400
	end
	
	INIT_ObjTigerObjective()
	
	g_TimeLeft = 1
	Timer_Start(g_TimeLeft, g_GameTime)
	
	g_foundAxisPlayer = false
	
	for i = 1, World_GetPlayerCount() do
		local player = World_GetPlayerAt(i)
		
			--assign the first found axis player to be the player controlling the tiger
		if Player_GetRaceName(player) == "german" or Player_GetRaceName(player) == "west_german" then
			print("Player "..i..": Axis")
			if g_foundAxisPlayer == false then
				g_foundAxisPlayer = true
				g_TigerPlayer = player
				print("Player "..i.." is controlling the Tiger")
			else
				Modify_PlayerResourceRate(player, RT_Manpower, 0.5)
				Modify_PlayerResourceRate(player, RT_Fuel, 0.5)
			end
			local g_enemy
			for i = 1, World_GetPlayerCount() do
				local _player = World_GetPlayerAt(i)
				local g_enemy_found = false
				if Player_GetRelationship(player, _player) == R_ENEMY and g_enemy_found == false then
					g_enemy_found = true
					g_enemy = _player
				end
			end
			if Player_GetRaceName(player) == "german" then
					--East Germans start in battle phase 4
				Player_CompleteUpgrade(player, BP_GetUpgradeBlueprint("battle_phase_2_mp"))
				Player_CompleteUpgrade(player, BP_GetUpgradeBlueprint("battle_phase_3_mp"))
				Player_CompleteUpgrade(player, BP_GetUpgradeBlueprint("battle_phase_4_mp"))
					--spawn starting troops
				Util_CreateSquads(player, nil, {BP_GetSquadBlueprint("grenadier_squad_mp"), BP_GetSquadBlueprint("assault_grenadier_squad_mp"), BP_GetSquadBlueprint("pioneer_squad_mp"), BP_GetSquadBlueprint("panzer_grenadier_squad_mp")}, Util_GetRandomPosition(TLT_GetClosestEntryPoint(player), 20), Player_GetStartingPosition(player), World_GetRand(5, 7))
			elseif Player_GetRaceName(player) == "west_german" then
				Util_CreateSquads(player, nil, BP_GetSquadBlueprint("sws_halftrack_squad_mp"), Util_GetRandomPosition(TLT_GetClosestEntryPoint(player), 20), Player_GetStartingPosition(player), World_GetRand(1, 2))
				Util_CreateSquads(player, nil, {BP_GetSquadBlueprint("obersoldaten_squad_mp"), BP_GetSquadBlueprint("jaeger_light_infantry_recon_squad_mp"), BP_GetSquadBlueprint("fallschirmjager_squad_mp"), BP_GetSquadBlueprint("panzerfusilier_squad_mp")}, Util_GetRandomPosition(TLT_GetClosestEntryPoint(player), 20), Player_GetStartingPosition(player), 5)
			end
			Player_SetResource(player, RT_Manpower, 3000)
			Player_SetResource(player, RT_Fuel, 750)
		elseif Player_GetRaceName(player) == "soviet" or Player_GetRaceName(player) == "aef" or Player_GetRaceName(player) == "british" then
			print("Player "..i..": Allies")
			Modify_PlayerResourceRate(player, RT_Manpower, 2)
			Modify_PlayerResourceRate(player, RT_Fuel, 2)
			if Player_GetRaceName(player) == "aef" then
					--add abilities
				Player_AddAbility(player, BP_GetAbilityBlueprint("cbd6f88ad27b451d827a2fc98ba01d9a:m4a3_sherman_squad_tlt_mp"))
				Player_AddAbility(player, BP_GetAbilityBlueprint("cbd6f88ad27b451d827a2fc98ba01d9a:sherman_calliope_squad_tlt_mp"))
					--setup restrictions
				Player_SetSquadProductionAvailability(player, {
					BP_GetSquadBlueprint("m20_utility_car_squad_mp"),
					BP_GetSquadBlueprint("m5a1_stuart_squad_mp"),
					BP_GetSquadBlueprint("m15a1_aa_halftrack_squad_mp"),
					BP_GetSquadBlueprint("m8_greyhound_squad_mp"),
					--BP_GetSquadBlueprint("m4a3_sherman_squad_mp"), --issues trying to get the blueprint for this squad
					BP_GetSquadBlueprint("m36_tank_destroyer_squad_mp"),
					BP_GetSquadBlueprint("m8a1_hmc_squad_mp"),
					--BP_GetSquadBlueprint("m10_tank_destroyer_squad_mp"),
					BP_GetSquadBlueprint("m7b1_priest_squad_mp"),
					BP_GetSquadBlueprint("m4a3_76mm_sherman_bulldozer_squad_mp"),
					BP_GetSquadBlueprint("m4a3e8_sherman_easy_8_squad_mp"),
					BP_GetSquadBlueprint("m4a3_76mm_sherman_squad_commander_mp"),
				}, ITEM_REMOVED)
				--------------------------------
				Player_SetAbilityAvailability(player, {
					BP_GetAbilityBlueprint("priest_dispatch"),
					BP_GetAbilityBlueprint("sherman_easy8_dispatch"),
					BP_GetAbilityBlueprint("sherman_bulldozer_dispatch"),
					--BP_GetAbilityBlueprint("m10_deploy"),
					BP_GetAbilityBlueprint("m21_mortar_halftrack_dispatch"),
					BP_GetAbilityBlueprint("greyhound_recon_dispatch"),
					BP_GetAbilityBlueprint("mechanized_group_mp"),
					BP_GetAbilityBlueprint("sherman_bulldozer_dispatch"),
					BP_GetAbilityBlueprint("sherman_calliope_dispatch"),
					BP_GetAbilityBlueprint("sherman_easy8_dispatch"),
					BP_GetAbilityBlueprint("sherman_modifications"),
				}, ITEM_REMOVED)
					--complete upgrades to enable early access to explosives
				Player_CompleteUpgrade(player, BP_GetUpgradeBlueprint("weapon_rack_upgrade_mp"))
				Player_CompleteUpgrade(player, BP_GetUpgradeBlueprint("rifle_command_grenade_mp"))
				if World_GetRand(0, 1) >= 0.5 then --50% chance
					Player_CompleteUpgrade(player, BP_GetUpgradeBlueprint("captain_dispatched_upgrade_mp"))
				end
				if World_GetRand(0, 1) >= 0.5 then
					Player_CompleteUpgrade(player, BP_GetUpgradeBlueprint("lieutenant_dispatched_upgrade_mp"))
				end
			elseif Player_GetRaceName(player) == "british" then
				if World_GetRand(0, 1) >= 0.5 then
					Player_CompleteUpgrade(player, BP_GetUpgradeBlueprint("tommy_increased_squad_size_mp"))
				end
				Player_SetResource(player, RT_Fuel, 30)
					--complete upgrades to enable early access to explosives
				Player_CompleteUpgrade(player, BP_GetUpgradeBlueprint("weapon_rack_unlock_mp"))
				Player_CompleteUpgrade(player, BP_GetUpgradeBlueprint("tommy_mills_bomb_mp"))
			elseif Player_GetRaceName(player) == "soviet" then
				Util_CreateSquads(player, nil, {BP_GetSquadBlueprint("conscript_squad_mp"), BP_GetSquadBlueprint("guards_troops_mp"), BP_GetSquadBlueprint("penal_battalion_mp"), BP_GetSquadBlueprint("m1942_zis-3_76mm_at_gun_squad_mp")}, Util_GetRandomPosition(TLT_GetClosestEntryPoint(player), 20), Player_GetStartingPosition(player), World_GetRand(10, 15))
				Player_CompleteUpgrade(player, BP_GetUpgradeBlueprint("hq_anti_tank_grenade_mp"))
				if World_GetRand(0, 1) >= 0.5 then
					Player_CompleteUpgrade(player, BP_GetUpgradeBlueprint("hq_healing_aura_mp"))
				end
				if World_GetRand(0, 1) >= 0.5 then
					Player_CompleteUpgrade(player, BP_GetUpgradeBlueprint("hq_molotov_grenade_mp"))
				end
			end
			Player_SetResource(player, RT_Munition, 600)
		else
			fatal("Player "..i.." couldn't be assigned by race")
		end
		
		local squads = Player_GetSquads(player)
		
		if Util_GetDistance(SGroup_GetPosition(squads), Player_GetStartingPosition(player)) >= 45 then
			Cmd_Retreat(squads)
		end
	end 
	
		--only start the modified Win condition Check and spawn the Tiger if there is at least one axis player present, otherwise launch the vanilla win condition
	if g_TigerPlayer ~= nil then
		Objective_Start(obj_Tiger, false)
		Rule_AddInterval(WinCondition_Check, 3)
		Rule_AddInterval(TLT_tigercheck, 3)
		Rule_Add(TLT_updateTigerData)
		sg_Tiger = SGroup_CreateIfNotFound("sg_Tiger") --BP_GetSquadBlueprint("tiger_ace_squad_mp")
		Util_CreateSquads(g_TigerPlayer, sg_Tiger, BP_GetSquadBlueprint("cbd6f88ad27b451d827a2fc98ba01d9a:tiger_tlt_squad_mp"), TLT_GetClosestEntryPoint(g_TigerPlayer), Player_GetStartingPosition(g_TigerPlayer))
		--Rule_AddOneShot(TLT_generateFrontLine, 3)
		eg_TerritoryPoints = EGroup_CreateIfNotFound("eg_TerritoryPoints")
		World_GetStrategyPoints(eg_TerritoryPoints, false)
		
	else
		Rule_AddInterval(WinCondition_Check_no_axis, 3)
	end
end

Scar_AddInit(WinCondition_Init)

function TLT_generateFrontLine()
	for i = 1, EGroup_Count(eg_TerritoryPoints) do
		local entity = EGroup_GetSpawnedEntityAt(eg_TerritoryPoints, i)
		local pos_e = Entity_GetPosition(entity)
		
		if Util_GetDistance(pos_e, Player_GetStartingPosition(World_GetPlayerAt(1))) < Util_GetDistance(pos_e, Player_GetStartingPosition(World_GetPlayerAt(World_GetPlayerCount()))) then
			Entity_InstantCaptureStrategicPoint(entity, World_GetPlayerAt(1))
		else
			Entity_InstantCaptureStrategicPoint(entity, World_GetPlayerAt(World_GetPlayerCount()))
		end
	end
end

function TLT_tigercheck()
	if SGroup_IsAlive(sg_Tiger) == false then
		Rule_RemoveAll()
		Obj_HideProgress()
		Objective_Show(obj_Tiger, false)
			--end sequence triggered when the allies win
		Camera_MoveTo(g_Tiger_pos, true, 0.35, false, true)
		FOW_RevealArea(g_Tiger_pos, 60, -1)
		for i = 1, World_GetPlayerCount() do
			local player = World_GetPlayerAt(i)
			
			if Player_GetTeam(player) == Player_GetTeam(g_TigerPlayer) then
				local sg_AllAxis_end = SGroup_CreateIfNotFound("sg_AllAxis_end")
				Player_GetAll(player, sg_AllAxis_end)
				Cmd_Retreat(sg_AllAxis_end)
			end
		end
		sg_EndSequence_allies = SGroup_CreateIfNotFound("sg_EndSequence_allies")
		Util_CreateSquads(g_TigerPlayer, sg_EndSequence_allies, BP_GetSquadBlueprint("pioneer_squad_mp"), g_Tiger_pos)
		SGroup_SetInvulnerable(sg_EndSequence_allies, true)
		if World_GetRand(0, 1) < 0.5 then
			Cmd_Retreat(sg_EndSequence_allies)
		else
			Cmd_Surrender(sg_EndSequence_allies, 0, TLT_GetAlliedStartingPosition(), true, true)
		end
		--Game_SetMode(UI_Cinematic)
		
		local losingTeam = Player_GetTeam(g_TigerPlayer)
		
		WinCondition_GameOver(Team_GetEnemyTeam(losingTeam), losingTeam)
	end
	
	--if Objective_GetTimerSeconds(obj_Tiger) == 0 then
	if Timer_GetRemaining(g_TimeLeft) <= 0 then
		Rule_RemoveAll()
		--Objective_StopTimer(obj_Tiger)
		Obj_HideProgress()
		Objective_Show(obj_Tiger, false)
		Timer_End(g_TimeLeft)
-------------------------------------------------------------------------
		AI_EnableAll(false)
		
		Rule_AddOneShot(g_axis_win, 6)
		pos_reinforcement_point = TLT_GetClosestEntryPoint(g_TigerPlayer)
		g_camera_moved = false
		FOW_RevealArea(g_Tiger_pos, 60, -1)
		g_EndSequence_axis()
		Rule_AddIntervalEx(g_EndSequence_axis, 3, 5)
		
		
		--Game_SetMode(UI_Cinematic)
	end
end

function g_EndSequence_axis()
	sg_EndSequence = SGroup_CreateIfNotFound("sg_EndSequence")
	Util_CreateSquads(g_TigerPlayer, sg_EndSequence, {BP_GetSquadBlueprint("obersoldaten_squad_mp"), BP_GetSquadBlueprint("jaeger_light_infantry_recon_squad_mp"), BP_GetSquadBlueprint("fallschirmjager_squad_mp"), BP_GetSquadBlueprint("panzerfusilier_squad_mp")}, Util_GetRandomPosition(pos_reinforcement_point, 5), TLT_GetAlliedStartingPosition(), 2, nil, false, Player_GetStartingPosition(g_TigerPlayer), nil, TLT_GetAlliedStartingPosition())
	Util_CreateSquads(g_TigerPlayer, sg_EndSequence, {BP_GetSquadBlueprint("panzer_iv_squad_mp"), BP_GetSquadBlueprint("panther_squad_mp"), BP_GetSquadBlueprint("stug_iii_squad_mp"), BP_GetSquadBlueprint("opel_blitz_supply_squad"), BP_GetSquadBlueprint("opel_blitz_squad_mp")}, Util_GetRandomPosition(pos_reinforcement_point, 5), TLT_GetAlliedStartingPosition(), 1, nil, false, Player_GetStartingPosition(g_TigerPlayer), nil, TLT_GetAlliedStartingPosition())
	
	if g_camera_moved == false then
		g_camera_moved = true
		Camera_MoveTo(Util_GetPosition(sg_EndSequence), true, 0.35, false, true)
	end
end

function g_axis_win()
	Game_SetMode(UI_Normal)
	--Camera_Follow(sg_EndSequence)
	
	local winningTeam = Player_GetTeam(g_TigerPlayer)
	local losing_Team = Team_GetEnemyTeam(winningTeam)
	
	WinCondition_GameOver(winningTeam, losingTeam)
end

function TLT_updateTigerData()
	if SGroup_IsAlive(sg_Tiger) then
		Obj_ShowProgress2(Util_CreateLocString("Tiger 237 'Stefan'"), SGroup_GetAvgHealth(sg_Tiger))
		g_Tiger_pos = SGroup_GetPosition(sg_Tiger)
		
		local seconds = math.floor(Timer_GetRemaining(g_TimeLeft))
		Objective_UpdateText(obj_Tiger, Util_CreateLocString("Time until German reinforcements: "..math.floor(seconds/60)..":"..math.floor((seconds % 60) / 10)..(seconds % 60) - math.floor((seconds % 60) / 10) * 10), nil, false)
	end
end

function TLT_GetAlliedStartingPosition()

	for i = 1, World_GetPlayerCount() do
		local player = World_GetPlayerAt(i)
		
		if Player_GetTeam(player) ~= Player_GetTeam(g_TigerPlayer) then
			return Player_GetStartingPosition(player)
		end
	end
end

--[[
function TLT_GetPlayerEntryPoint(player)

	local eg_all_entry_points = EGroup_CreateIfNotFound("eg_all_entries")

	local _sg_temp = SGroup_CreateIfNotFound("_sg_temp")
	local _eg_all = EGroup_CreateIfNotFound("_eg_all")
	
	local team = Player_GetTeam(player)
	
	local g_entry_axis_found = false
	local g_entry_allies_found = false
	
	Player_GetAll(player, _sg_temp, _eg_all)
	EGroup_Filter(_eg_all, BP_GetEntityBlueprint("map_entry_point"), FILTER_KEEP)
		
	EGroup_AddEGroup(eg_all_entry_points, _eg_all)
	
	if EGroup_IsEmpty(eg_all_entry_points) == false then
		if g_TigerPlayer ~= nil then
			local _entry_pos = Entity_GetPosition(EGroup_GetRandomSpawnedEntity(eg_all_entry_points))
			if team == Player_GetTeam(g_TigerPlayer) and g_entry_axis_found == false then
				g_entry_axis_found = true
				g_entry_axis = _entry_pos
			elseif team ~= Player_GetTeam(g_TigerPlayer) and g_entry_allies_found == false then
				g_entry_allies_found = true
				g_entry_allies = _entry_pos
			end
			if _entry_pos ~= nil then
				return _entry_pos
			else
				fatal("Unable to assign an entry point for "..Player_GetDisplayName(player))
			end
		else
			return Player_GetStartingPosition(player)
		end
	else
		if g_TigerPlayer ~= nil then
			if team == Player_GetTeam(g_TigerPlayer) then
				if g_entry_axis ~= nil then
					return g_entry_axis
				else
					fatal("Unable to assign an entry point for "..Player_GetDisplayName(player))
				end
			elseif team ~= Player_GetTeam(g_TigerPlayer) then
				if g_entry_allies ~= nil then
					return g_entry_allies
				else
					fatal("Unable to assign an entry point for "..Player_GetDisplayName(player))
				end
			end
		else
			return Player_GetStartingPosition(player)
		end
	end
end --]]

--[[
function TLT_GetPlayerEntryPointCentre()

	local eg_all_entry_points = EGroup_CreateIfNotFound("eg_all_entries")

	local _sg_temp = SGroup_CreateIfNotFound("_sg_temp")
	local _eg_all = EGroup_CreateIfNotFound("_eg_all")
	
	for i = 1, World_GetPlayerCount() do
	
		local player = World_GetPlayerAt(i)
	
		Player_GetAll(player, _sg_temp, _eg_all)
		EGroup_Filter(_eg_all, BP_GetEntityBlueprint("map_entry_point"), FILTER_KEEP)
		
		EGroup_AddEGroup(eg_all_entry_points, _eg_all);
		
	end
	
	return EGroup_GetPosition(eg_all_entry_points)

end

function _TLT_GetClosestEntryPoint(player)

	local eg_all_entry_points = EGroup_CreateIfNotFound("eg_all_entries")

	local _sg_temp = SGroup_CreateIfNotFound("_sg_temp")
	local _eg_all = EGroup_CreateIfNotFound("_eg_all")
	
	for i = 1, World_GetPlayerCount() do
	
		local _player = World_GetPlayerAt(i)
	
		Player_GetAll(_player, _sg_temp, _eg_all)
		EGroup_Filter(_eg_all, BP_GetEntityBlueprint("map_entry_point"), FILTER_KEEP)
		
		EGroup_AddEGroup(eg_all_entry_points, _eg_all)
		
	end
	
	local t = {}
	for i = 1, EGroup_CountSpawned(eg_all_entry_points) do 
		local entity = EGroup_GetSpawnedEntityAt(eg_all_entry_points, i)
		local eg_temp = EGroup_CreateIfNotFound("eg_temp"..i)
		
		EGroup_Add(eg_temp, entity)
		t["k"..i] = eg_temp
	end
	
	if World_GetClosest(Player_GetStartingPosition(player), t) ~= nil then
		return Util_GetPosition(World_GetClosest(Player_GetStartingPosition(player), t))
	else
		--fatal("Unable to assign an entry point for "..Player_GetDisplayName(player))
	end
end --]]

--[[
function TLT_GetClosestEntryPoint(player)

	local eg_all_entry_points = EGroup_CreateIfNotFound("eg_all_entries")

	local _sg_temp = SGroup_CreateIfNotFound("_sg_temp")
	local _eg_all = EGroup_CreateIfNotFound("_eg_all")
	
	for i = 1, World_GetPlayerCount() do
	
		local _player = World_GetPlayerAt(i)
	
		Player_GetAll(_player, _sg_temp, _eg_all)
		EGroup_Filter(_eg_all, BP_GetEntityBlueprint("map_entry_point"), FILTER_KEEP)
		
		EGroup_AddEGroup(eg_all_entry_points, _eg_all)
		
	end
	
	local c = EGroup_CountSpawned(eg_all_entry_points)
	local t_all_entry_points = {}
	
	eg_entry_point1 = EGroup_CreateIfNotFound("eg_entry_point1")
	eg_entry_point2 = EGroup_CreateIfNotFound("eg_entry_point2")
	eg_entry_point3 = EGroup_CreateIfNotFound("eg_entry_point3")
	eg_entry_point4 = EGroup_CreateIfNotFound("eg_entry_point4")
	eg_entry_point5 = EGroup_CreateIfNotFound("eg_entry_point5")
	eg_entry_point6 = EGroup_CreateIfNotFound("eg_entry_point6")
	eg_entry_point7 = EGroup_CreateIfNotFound("eg_entry_point7")
	eg_entry_point8 = EGroup_CreateIfNotFound("eg_entry_point8")
	eg_entry_point9 = EGroup_CreateIfNotFound("eg_entry_point9")
	eg_entry_point10 = EGroup_CreateIfNotFound("eg_entry_point10")
	
	if c == 2 then
	t_all_entry_points = {
			EGroup_Single(eg_entry_point1, EGroup_GetSpawnedEntityAt(eg_all_entry_points, 1)),
			EGroup_Single(eg_entry_point2, EGroup_GetSpawnedEntityAt(eg_all_entry_points, 2)),
		}
	elseif c == 3 then
	t_all_entry_points = {
			EGroup_Single(eg_entry_point1, EGroup_GetSpawnedEntityAt(eg_all_entry_points, 1)),
			EGroup_Single(eg_entry_point2, EGroup_GetSpawnedEntityAt(eg_all_entry_points, 2)),
			EGroup_Single(eg_entry_point3, EGroup_GetSpawnedEntityAt(eg_all_entry_points, 3)),
		}
	elseif c == 4 then
	t_all_entry_points = {
			EGroup_Single(eg_entry_point1, EGroup_GetSpawnedEntityAt(eg_all_entry_points, 1)),
			EGroup_Single(eg_entry_point2, EGroup_GetSpawnedEntityAt(eg_all_entry_points, 2)),
			EGroup_Single(eg_entry_point3, EGroup_GetSpawnedEntityAt(eg_all_entry_points, 3)),
			EGroup_Single(eg_entry_point4, EGroup_GetSpawnedEntityAt(eg_all_entry_points, 4)),
		}
	elseif c == 5 then
	t_all_entry_points = {
			EGroup_Single(eg_entry_point1, EGroup_GetSpawnedEntityAt(eg_all_entry_points, 1)),
			EGroup_Single(eg_entry_point2, EGroup_GetSpawnedEntityAt(eg_all_entry_points, 2)),
			EGroup_Single(eg_entry_point3, EGroup_GetSpawnedEntityAt(eg_all_entry_points, 3)),
			EGroup_Single(eg_entry_point4, EGroup_GetSpawnedEntityAt(eg_all_entry_points, 4)),
			EGroup_Single(eg_entry_point5, EGroup_GetSpawnedEntityAt(eg_all_entry_points, 5)),
		}
	elseif c == 6 then
	t_all_entry_points = {
			EGroup_Single(eg_entry_point1, EGroup_GetSpawnedEntityAt(eg_all_entry_points, 1)),
			EGroup_Single(eg_entry_point2, EGroup_GetSpawnedEntityAt(eg_all_entry_points, 2)),
			EGroup_Single(eg_entry_point3, EGroup_GetSpawnedEntityAt(eg_all_entry_points, 3)),
			EGroup_Single(eg_entry_point4, EGroup_GetSpawnedEntityAt(eg_all_entry_points, 4)),
			EGroup_Single(eg_entry_point5, EGroup_GetSpawnedEntityAt(eg_all_entry_points, 5)),
			EGroup_Single(eg_entry_point6, EGroup_GetSpawnedEntityAt(eg_all_entry_points, 6)),
		}
	elseif c == 7 then
	t_all_entry_points = {
			EGroup_Single(eg_entry_point1, EGroup_GetSpawnedEntityAt(eg_all_entry_points, 1)),
			EGroup_Single(eg_entry_point2, EGroup_GetSpawnedEntityAt(eg_all_entry_points, 2)),
			EGroup_Single(eg_entry_point3, EGroup_GetSpawnedEntityAt(eg_all_entry_points, 3)),
			EGroup_Single(eg_entry_point4, EGroup_GetSpawnedEntityAt(eg_all_entry_points, 4)),
			EGroup_Single(eg_entry_point5, EGroup_GetSpawnedEntityAt(eg_all_entry_points, 5)),
			EGroup_Single(eg_entry_point6, EGroup_GetSpawnedEntityAt(eg_all_entry_points, 6)),
			EGroup_Single(eg_entry_point7, EGroup_GetSpawnedEntityAt(eg_all_entry_points, 7)),
		}
	elseif c == 8 then
	t_all_entry_points = {
			EGroup_Single(eg_entry_point1, EGroup_GetSpawnedEntityAt(eg_all_entry_points, 1)),
			EGroup_Single(eg_entry_point2, EGroup_GetSpawnedEntityAt(eg_all_entry_points, 2)),
			EGroup_Single(eg_entry_point3, EGroup_GetSpawnedEntityAt(eg_all_entry_points, 3)),
			EGroup_Single(eg_entry_point4, EGroup_GetSpawnedEntityAt(eg_all_entry_points, 4)),
			EGroup_Single(eg_entry_point5, EGroup_GetSpawnedEntityAt(eg_all_entry_points, 5)),
			EGroup_Single(eg_entry_point6, EGroup_GetSpawnedEntityAt(eg_all_entry_points, 6)),
			EGroup_Single(eg_entry_point7, EGroup_GetSpawnedEntityAt(eg_all_entry_points, 7)),
			EGroup_Single(eg_entry_point8, EGroup_GetSpawnedEntityAt(eg_all_entry_points, 8)),
		}
	elseif c == 9 then
		t_all_entry_points = {
			EGroup_Single(eg_entry_point1, EGroup_GetSpawnedEntityAt(eg_all_entry_points, 1)),
			EGroup_Single(eg_entry_point2, EGroup_GetSpawnedEntityAt(eg_all_entry_points, 2)),
			EGroup_Single(eg_entry_point3, EGroup_GetSpawnedEntityAt(eg_all_entry_points, 3)),
			EGroup_Single(eg_entry_point4, EGroup_GetSpawnedEntityAt(eg_all_entry_points, 4)),
			EGroup_Single(eg_entry_point5, EGroup_GetSpawnedEntityAt(eg_all_entry_points, 5)),
			EGroup_Single(eg_entry_point6, EGroup_GetSpawnedEntityAt(eg_all_entry_points, 6)),
			EGroup_Single(eg_entry_point7, EGroup_GetSpawnedEntityAt(eg_all_entry_points, 7)),
			EGroup_Single(eg_entry_point8, EGroup_GetSpawnedEntityAt(eg_all_entry_points, 8)),
			EGroup_Single(eg_entry_point9, EGroup_GetSpawnedEntityAt(eg_all_entry_points, 9)),
		}
	elseif c >= 9 then
		t_all_entry_points = {
			EGroup_Single(eg_entry_point1, EGroup_GetSpawnedEntityAt(eg_all_entry_points, 1)),
			EGroup_Single(eg_entry_point2, EGroup_GetSpawnedEntityAt(eg_all_entry_points, 2)),
			EGroup_Single(eg_entry_point3, EGroup_GetSpawnedEntityAt(eg_all_entry_points, 3)),
			EGroup_Single(eg_entry_point4, EGroup_GetSpawnedEntityAt(eg_all_entry_points, 4)),
			EGroup_Single(eg_entry_point5, EGroup_GetSpawnedEntityAt(eg_all_entry_points, 5)),
			EGroup_Single(eg_entry_point6, EGroup_GetSpawnedEntityAt(eg_all_entry_points, 6)),
			EGroup_Single(eg_entry_point7, EGroup_GetSpawnedEntityAt(eg_all_entry_points, 7)),
			EGroup_Single(eg_entry_point8, EGroup_GetSpawnedEntityAt(eg_all_entry_points, 8)),
			EGroup_Single(eg_entry_point9, EGroup_GetSpawnedEntityAt(eg_all_entry_points, 9)),
			EGroup_Single(eg_entry_point10, EGroup_GetSpawnedEntityAt(eg_all_entry_points, 10)),
		}
	end
	
	if World_GetClosest(Player_GetStartingPosition(player), t_all_entry_points) ~= nil then
		return Util_GetPosition(World_GetClosest(Player_GetStartingPosition(player), t_all_entry_points))
	else
		print("Unable to find an entry point for player "..Player_GetID(player)..", using starting position instead")
		return Player_GetStartingPosition(player)
	end
	
end --]]

--[[ ~the following attempt is more beautiful and practical, as it usable for any number of map entry points, buuuuuuuuuuut it for some reason appears not to actually return the map entry point but rather the player starting position, which indicates that something probably doesn't work 
~ edit: after some testing I found out that scar seems to not add the entry points into the table and thus the closest entry in the table is always 'nil' as the table is empty --]]
--[
function TLT_GetClosestEntryPoint(player)

	--[[local eg_all_entry_points = EGroup_CreateIfNotFound("eg_all_entries")

	local _sg_temp = SGroup_CreateIfNotFound("_sg_temp")
	local _eg_all = EGroup_CreateIfNotFound("_eg_all")
	
	for i = 1, World_GetPlayerCount() do
	
		local _player = World_GetPlayerAt(i)
	
		Player_GetAll(_player, _sg_temp, _eg_all)
		EGroup_Filter(_eg_all, BP_GetEntityBlueprint("map_entry_point"), FILTER_KEEP)
		
		EGroup_AddEGroup(eg_all_entry_points, _eg_all)
		
	end
	
	local c = EGroup_CountSpawned(eg_all_entry_points)
	local allEntryPoints = {}
	
	for i = 1, c do
		
		local _entry_point = EGroup_GetSpawnedEntityAt(eg_all_entry_points, i)
		
		allEntryPoints["entryPoint"..i] = _entry_point
		
	end
	
	if World_GetClosest(Player_GetStartingPosition(player), allEntryPoints) ~= nil then
		Util_MissionTitle(Util_CreateLocString("Successfully found entry point for player '"..Player_GetID(player).."'"))
		return Util_GetPosition(World_GetClosest(Player_GetStartingPosition(player), allEntryPoints))
	else	
		--print("Unable to find an entry point for player "..Player_GetID(player)..", using starting position instead")
		fatal("Unable to find entry point for player '"..Player_GetID(player).."'")
		return Player_GetStartingPosition(player)
	end ]]
	
	local eg_all_entry_points = EGroup_CreateIfNotFound("eg_all_entry_points")
	local sg_temp = SGroup_CreateIfNotFound("sg_temp")
	local t = {}
	
	--Team_GetAll(Player_GetTeam(player), sg_temp, eg_all_entry_points) ~produces error: 'bad argument #1 to 'getn' (table expected, got number)'
	for i = 1, World_GetPlayerCount() do
		local p = World_GetPlayerAt(i)
		
		if Player_GetTeam(p) == Player_GetTeam(player) then
			EGroup_AddEGroup(eg_all_entry_points, Player_GetEntities(p))
		end
	end
	for i = 1, EGroup_Count(eg_all_entry_points) do
		local e = EGroup_GetSpawnedEntityAt(eg_all_entry_points, i)
		if Entity_GetBlueprint(e) == BP_GetEntityBlueprint("map_entry_point") then
			t[#t+1] = e
		end
	end
	
	if World_GetClosest(Player_GetStartingPosition(player), t) ~= nil then 
		return Util_GetPosition(World_GetClosest(Player_GetStartingPosition(player), t))
	else
		fatal("Unable to get entry point for player '"..Player_GetDisplayName(player).."' ("..player..")!!!")
		return Player_GetStartingPosition(player)
	end
end
--]]
