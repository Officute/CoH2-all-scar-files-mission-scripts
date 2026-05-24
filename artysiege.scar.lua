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
	
	local winningPlayers = Team_GetPlayers(winningTeam)
	local losingPlayers = Team_GetPlayers(losingTeam)
	
	Fatality_Execute(winningPlayers, losingPlayers)
end

function Init_as()
	p_arty = World_GetPlayerAt(1)
	p_base = World_GetPlayerAt(World_GetPlayerCount())
	pos_arty = Obj_GetPos(p_arty)
	pos_base = Obj_GetPos(p_base)
	
	local bp_arty
	if Player_GetRaceName(p_arty) == "german" then
		bp_arty = BP_GetSquadBlueprint("dc277230fda7439c89008eac902dd21f:howitzer_105mm_le_fh18_artillery_as")
		
	elseif Player_GetRaceName(p_arty) == "soviet" then
		bp_arty = BP_GetSquadBlueprint("dc277230fda7439c89008eac902dd21f:m1937_152mm_ml_20_artillery_as")
		
	elseif Player_GetRaceName(p_arty) == "west_german" then
		bp_arty = BP_GetSquadBlueprint("dc277230fda7439c89008eac902dd21f:okw_howitzer_105mm_le_fh18_artillery_as")
		
	elseif Player_GetRaceName(p_arty) == "british" then
		bp_arty = BP_GetSquadBlueprint("dc277230fda7439c89008eac902dd21f:sexton_spg_squad_as")
		
	elseif Player_GetRaceName(p_arty) == "aef" then
		bp_arty = BP_GetSquadBlueprint("dc277230fda7439c89008eac902dd21f:m7b1_priest_squad_as")
		
	end
	
	local bp_base
	if Player_GetRaceName(p_base) == "british" then
		bp_base = BP_GetEntityBlueprint("dc277230fda7439c89008eac902dd21f:brit_forward_hq_as")
		
	elseif Player_GetRaceName(p_base) == "aef" then
		bp_base = BP_GetEntityBlueprint("dc277230fda7439c89008eac902dd21f:company_weapons_pool_as")
		
	elseif Player_GetRaceName(p_base) == "west_german" then
		bp_base = BP_GetEntityBlueprint("dc277230fda7439c89008eac902dd21f:heavy_armor_support_as")
		
	elseif Player_GetRaceName(p_base) == "german" then
		bp_base = BP_GetEntityBlueprint("dc277230fda7439c89008eac902dd21f:concrete_bunker_commander_as")
		
	elseif Player_GetRaceName(p_base) == "soviet" then
		bp_base = BP_GetEntityBlueprint("dc277230fda7439c89008eac902dd21f:tank_depot_as")
		
	end
	
	sg_arty = SGroup_CreateIfNotFound("sg_arty")
	for i = 1, 3 do
		Util_CreateSquads(p_arty, sg_arty, bp_arty, Obj_GetArtyPos())
	end
	
	eg_base = EGroup_CreateIfNotFound("eg_base")
	Util_CreateEntities(p_base, eg_base, bp_base, pos_base, 1, World_Pos(0, 0, 0))
	if Setup_GetWinConditionOption() == 2 then Modify_Vulnerability(eg_base, 0.5) end --make the hq tougher if player wishes for long battle
	FOW_RevealEGroup(eg_base, -1)--debug, doesn't even work ¯\_(ツ)_/¯
	
	if Player_GetRaceName(p_arty) == "aef" then
		bp_arty_abl = BP_GetAbilityBlueprint("dc277230fda7439c89008eac902dd21f:m7b1_priest_105mm_barrage_ability_as")
		
	elseif Player_GetRaceName(p_arty) == "british" then
		bp_arty_abl = BP_GetAbilityBlueprint("dc277230fda7439c89008eac902dd21f:sexton_spg_25_pdr_barrage_ability_as")
		
	elseif Player_GetRaceName(p_arty) == "soviet" then
		bp_arty_abl = BP_GetAbilityBlueprint("dc277230fda7439c89008eac902dd21f:ml_20_152mm_barrage_ability_as")
		
	else
		bp_arty_abl = BP_GetAbilityBlueprint("dc277230fda7439c89008eac902dd21f:howitzer_105mm_barrage_ability_as")
		
	end
	
	if Player_GetRaceName(p_arty) == "german" then
		bp_r_arty =  BP_GetSquadBlueprint("pioneer_squad_mp")
		
	elseif Player_GetRaceName(p_arty) == "west_german" then
		bp_r_arty =  BP_GetSquadBlueprint("assault_pioneer_squad_mp")
		
	elseif Player_GetRaceName(p_arty) == "british" then
		bp_r_arty =  BP_GetSquadBlueprint("sapper_squad_mp")
		
	elseif Player_GetRaceName(p_arty) == "aef" then
		bp_r_arty =  BP_GetSquadBlueprint("rear_echelon_squad_mp")
		
	elseif Player_GetRaceName(p_arty) == "soviet" then
		bp_r_arty =  BP_GetSquadBlueprint("combat_engineer_squad_mp")
	end
	
	if Player_GetRaceName(p_base) == "german" then
		bp_r_base =  BP_GetSquadBlueprint("pioneer_squad_mp")
		
	elseif Player_GetRaceName(p_base) == "west_german" then
		bp_r_base =  BP_GetSquadBlueprint("assault_pioneer_squad_mp")
		
	elseif Player_GetRaceName(p_base) == "british" then
		bp_r_base =  BP_GetSquadBlueprint("sapper_squad_mp")
		
	elseif Player_GetRaceName(p_base) == "aef" then
		bp_r_base =  BP_GetSquadBlueprint("rear_echelon_squad_mp")
		
	elseif Player_GetRaceName(p_base) == "soviet" then
		bp_r_base =  BP_GetSquadBlueprint("combat_engineer_squad_mp")
	end
-----------------------------------------------------------------------
	obj_base = {
	
		SetupUI = function()
			ui_arty = Objective_AddUIElements(obj_base, SGroup_GetPosition(sg_arty), true, Util_CreateLocString("Siege Howitzers"), true, 3.5)
		end,
		
		OnStart = function()
		end,
		
		OnComplete = function()
		end,
		
		OnFail = function()
		end,
		
		Title = Util_CreateLocString("Defend or Destroy the Howitzers"),
		Description = 0,
		Type = OT_Primary,
	}
	
	obj_arty = {
	
		SetupUI = function() 
		end,
		
		OnStart = function()
		end,
		
		OnComplete = function()
		end,
		
		OnFail = function()
		end,
		
		Title = Util_CreateLocString("Artillery Status"),
		Description = 0,
		Type = OT_Information,
	}
	
	Objective_Register(obj_base)
	Objective_Register(obj_arty)
	Objective_Start(obj_base)
	Objective_Start(obj_arty, false)
	
	hp_base = HintPoint_Add(pos_base, true, Util_CreateLocString("Besieged HQ"), 3.5)
	
	--Obj_Create(p_arty, Util_CreateLocString("Objective"), Util_CreateLocString("Desc"), nil, OT_Primary, nil) ~TBD
-----------------------------------------------------------------------
	if Setup_GetWinConditionOption() == 2 then Rule_Add(Obj_SpawnGuards) end
	Rule_AddInterval(Arty_Status, 1)
	Rule_Add(Obj_UpdateObjectives)
	g_arty_interval = 120
	g_time_til_fire = g_arty_interval
	g_arty_active = false
end
	Scar_AddInit(Init_as)

function Obj_SpawnGuards()
	Rule_RemoveMe()
	
	local bp_mg
	if Player_GetRaceName(p_arty) == "german" then
		bp_mg = BP_GetSquadBlueprint("mg42_heavy_machine_gun_squad_mp")
		
	elseif Player_GetRaceName(p_arty) == "west_german" then
		bp_mg = BP_GetSquadBlueprint("mg34_heavy_machine_gun_squad_mp")
		
	elseif Player_GetRaceName(p_arty) == "soviet" then
		bp_mg = BP_GetSquadBlueprint("m1910_maxim_heavy_machine_gun_squad_mp")
		
	elseif Player_GetRaceName(p_arty) == "british" then
		bp_mg = BP_GetSquadBlueprint("british_machine_gun_squad_mp")
		
	elseif Player_GetRaceName(p_arty) == "aef" then
		bp_mg = BP_GetSquadBlueprint("m2hb_50cal_hmg_squad_mp")
	end
	
	Util_CreateSquads(p_arty, nil, bp_mg, Util_GetRandomPosition(pos_arty, 5))
	Util_CreateSquads(p_arty, nil, bp_r_arty, Util_GetRandomPosition(pos_arty, 5))
	
	local eg_points = EGroup_CreateIfNotFound("eg_points")
	World_GetStrategyPoints(eg_points, false)
	for i = 1, EGroup_CountSpawned(eg_points) do
		local e = EGroup_GetSpawnedEntityAt(eg_points, i)
		
		if World_GetTerritorySectorID(pos_arty) == World_GetTerritorySectorID(Entity_GetPosition(e)) then
			Entity_InstantCaptureStrategicPoint(e, p_arty)
		end
	end
end

function Arty_Status()
	if g_time_til_fire > 0 then
		g_time_til_fire = g_time_til_fire - 1
	else
		g_time_til_fire = g_arty_interval
		--Cmd_Ability(sg_arty, bp_arty_abl, EGroup_GetPosition(eg_base))
		if SGroup_CanCastAbilityOnPosition(sg_arty, bp_arty_abl, EGroup_GetPosition(eg_base), true) then
			Command_SquadPosAbility(p_arty, sg_arty, EGroup_GetPosition(eg_base), bp_arty_abl, true, false)
		else
			g_time_til_fire = 10
			--Util_MissionTitle(Util_CreateLocString("Artillery doesn't seem to be firing. setting timer to 10 seconds..."))
		end
		g_arty_active = true
	end
	if SGroup_IsDoingAbility(sg_arty, bp_arty_abl, false) then
		if g_arty_active then
			Objective_UpdateText(obj_arty, Util_CreateLocString(Table_GetRandomItem({"Fire at will!", "Barrage underway!", "Artillery firing!", "Bombardment in progress!"})), nil,  false)
			g_arty_active = false
		end
	else
		Objective_UpdateText(obj_arty, Util_CreateLocString("Artillery Preparing"), nil, false)
	end
	Obj_ShowProgress(Util_CreateLocString("Next barrage in: "..g_time_til_fire), g_time_til_fire/g_arty_interval)
end

function Obj_UpdateObjectives()
	if not EGroup_IsEmpty(eg_base) then
		Obj_ShowProgress2(Util_CreateLocString("Besieged HQ"), EGroup_GetAvgHealth(eg_base))
	else
		local sg_retreatees = SGroup_CreateIfNotFound("sg_retreatees")
		
		Util_CreateSquads(p_base, sg_retreatees, bp_r_base, Util_GetRandomPosition(pos_base, 5), Util_GetRandomPosition(pos_base, 5), World_GetRand(3, 4))
		
		Cmd_Surrender(sg_retreatees, 0, Player_GetClosestEntryPoint(p_base), true, true)
		
		Game_SetMode(UI_Cinematic)
		Camera_MoveTo(pos_base, true, 0.15)
		World_SetTeamWin(Player_GetTeam(p_arty))
		Rule_RemoveAll()
	end
	if not SGroup_IsAlive(sg_arty) then
		local sg_retreatees = SGroup_CreateIfNotFound("sg_retreatees")
		
		Util_CreateSquads(p_arty, sg_retreatees, bp_r_arty, Util_GetRandomPosition(pos_arty, 5), Util_GetRandomPosition(pos_arty, 5), World_GetRand(3, 4))
		
		Cmd_Retreat(sg_retreatees, Player_GetClosestEntryPoint(p_arty))
		
		Game_SetMode(UI_Cinematic)
		Camera_MoveTo(pos_arty, true, 0.15)
		World_SetTeamWin(Player_GetTeam(p_base))
		Rule_RemoveAll()
	end
	
	local function _checkArty(gid, idx, sid)
		if Squad_Count(sid) < 3 then Squad_Kill(sid) end
	end
	
	if Player_GetRaceName(p_arty) == "german" or Player_GetRaceName(p_arty) == "west_german" or Player_GetRaceName(p_arty) == "soviet" then SGroup_ForEach(sg_arty, _checkArty) end
end

function Obj_GetArtyPos()
	local pos = Util_GetRandomPosition(pos_arty, 25)
	if not SGroup_IsEmpty(sg_arty) then
		for i = 1, SGroup_CountSpawned(sg_arty) do
			local squad = SGroup_GetSpawnedSquadAt(sg_arty, i)
			if Util_GetDistance(squad, pos) < 3 or Util_GetDistance(pos, World_GetNearestInteractablePoint(pos)) > 1 then
				return Obj_GetArtyPos()
			end
		end
		return pos
	else
		return pos
	end
end

function Obj_GetPos(player)
	local pos = World_GetNearestInteractablePoint(Util_GetRandomPosition(Player_GetStartingPosition(player), 100))
	if World_GetTerritorySectorID(pos) ~= World_GetTerritorySectorID(Player_GetStartingPosition(player)) then return pos else return Obj_GetPos(player) end
end

function Player_GetClosestEntryPoint(player)
	local t = {}
	for i = 1, World_GetPlayerCount() do
		local player = World_GetPlayerAt(i)
		local sg_temp = SGroup_CreateIfNotFound("sg_temp")
		local eg_temp = EGroup_CreateIfNotFound("eg_temp")
		
		Player_GetAll(player, sg_arty, eg_temp)
		for i = 1, EGroup_CountSpawned(eg_temp) do
			local entity = EGroup_GetSpawnedEntityAt(eg_temp, i)
			if Entity_GetBlueprint(entity) == BP_GetEntityBlueprint("map_entry_point") then
				t[#t+1] = entity
			end	
		end
	end
	return Util_GetPosition(World_GetClosest(Player_GetStartingPosition(player), t))
end




